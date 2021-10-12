//Project Imports
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/router_delegate.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/util/locator.dart';

//Flutter Imports
import 'package:flutter/material.dart';

class FelloBackButtonDispatcher extends RootBackButtonDispatcher {
  final FelloRouterDelegate _routerDelegate;
  DBModel _dbModel = locator<DBModel>();
  BaseUtil _baseUtil = locator<BaseUtil>();

  FelloBackButtonDispatcher(this._routerDelegate) : super();

  Future<bool> _confirmExit(
      String title, String description, Function confirmAction) {
    AppState.screenStack.add(ScreenItem.dialog);
    return showDialog<bool>(
      barrierDismissible: false,
      context: _routerDelegate.navigatorKey.currentContext,
      builder: (ctx) => ConfirmActionDialog(
        title: title,
        description: description,
        buttonText: "Yes",
        confirmAction: confirmAction,
        cancelAction: () {
          didPopRoute();
        },
      ),
    );
  }

  @override
  Future<bool> didPopRoute() {
    // If user is in the profile page and preferences are changed
    if (AppState.unsavedPrefs) {
      if (_baseUtil != null &&
          _baseUtil.myUser != null &&
          _baseUtil.myUser.uid != null &&
          _baseUtil.myUser.userPreferences != null)
        _dbModel
            .updateUserPreferences(
                _baseUtil.myUser.uid, _baseUtil.myUser.userPreferences)
            .then((value) {
          AppState.unsavedPrefs = false;
          log("Preferences updated");
        });
      return _routerDelegate.popRoute();
    }
    // If the top item is anything except a scaffold
    else if (AppState.screenStack.last == ScreenItem.dialog) {
      Navigator.pop(_routerDelegate.navigatorKey.currentContext);
      AppState.screenStack.removeLast();
      print("Current Stack: ${AppState.screenStack}");
      return Future.value(true);
    }
    // If onboarding is in progress
    else if (AppState.isOnboardingInProgress) {
      BaseUtil.showNegativeAlert(
          "Exit Onboarding?🕺", "Press back once more to exit");
      AppState.isOnboardingInProgress = false;
      return Future.value(true);
    }

    // If the root tab is not 0 at the time of exit
    else if (AppState.screenStack.length == 1 &&
        AppState.getCurrentTabIndex != 0 &&
        _baseUtil.isUserOnboarded) {
      //_routerDelegate.appState.setCurrentGameTabIndex = 0;
      _routerDelegate.appState.returnHome();
      return Future.value(true);
    }
    // else if (AppState.unsavedChanges)
    //   return _confirmExit(
    //       "You have unsaved changes", "Are you sure you want to exit", () {
    //     print(AppState.screenStack);
    //     AppState.unsavedChanges = false;
    //     didPopRoute();
    //     return didPopRoute();
    //   });
    // else
    return _routerDelegate.popRoute();
  }
}
