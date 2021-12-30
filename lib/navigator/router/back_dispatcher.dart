//Project Imports
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/router_delegate.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_confirm_dialog_landscape.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
//Flutter Imports
import 'package:flutter/material.dart';
import 'package:felloapp/util/custom_logger.dart';

class FelloBackButtonDispatcher extends RootBackButtonDispatcher {
  final FelloRouterDelegate _routerDelegate;
  final CustomLogger logger = locator<CustomLogger>();
  DBModel _dbModel = locator<DBModel>();
  BaseUtil _baseUtil = locator<BaseUtil>();
  AppState _appState = locator<AppState>();

  FelloBackButtonDispatcher(this._routerDelegate) : super();

  Future<bool> _confirmExit(
      String title, String description, Function confirmAction) {
    BaseUtil.openDialog(
        addToScreenStack: true,
        isBarrierDismissable: false,
        hapticVibrate: true,
        content: FelloConfirmationLandScapeDialog(
          asset: Assets.noTickets,
          title: title,
          subtitle: description,
          accept: "Exit",
          acceptColor: Colors.red,
          rejectColor: Colors.grey.withOpacity(0.3),
          reject: "Stay",
          onAccept: confirmAction,
          onReject: didPopRoute,
        ));
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
    }
    // If the top item is anything except a scaffold
    if (AppState.screenStack.last == ScreenItem.dialog) {
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
    //If the cricket game is in progress
    else if (AppState.circGameInProgress)
      return _confirmExit("Exit Game", "Are you sure you want to leave?", () {
        AppState.circGameInProgress = false;
        didPopRoute();
        return didPopRoute();
      });
    else if (AppState.isUpdateScreen) {
      AppState.isUpdateScreen = false;
      return _routerDelegate.popRoute();
    }
    // If the root tab is not 0 at the time of exit
    else if (_baseUtil.isUserOnboarded &&
        AppState.screenStack.length == 1 &&
        (AppState.delegate.appState.rootIndex != 1 ||
            RootViewModel.scaffoldKey.currentState.isDrawerOpen)) {
      logger.w("Checking if app can be closed");
      if (RootViewModel.scaffoldKey.currentState.isDrawerOpen)
        RootViewModel.scaffoldKey.currentState.openEndDrawer();
      else if (AppState.delegate.appState.rootIndex != 1)
        AppState.delegate.appState.setCurrentTabIndex = 1;
      return Future.value(true);
    }

    return _routerDelegate.popRoute();
  }
}
