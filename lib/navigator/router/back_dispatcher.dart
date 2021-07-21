import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/confirm_action_dialog.dart';
import 'package:flutter/material.dart';

import 'router_delegate.dart';

class FelloBackButtonDispatcher extends RootBackButtonDispatcher {
  final FelloRouterDelegate _routerDelegate;

  FelloBackButtonDispatcher(this._routerDelegate) : super();

  Future<bool> _confirmExit() {
    AppState.screenStack.add(ScreenItem.dialog);
    return showDialog<bool>(
      barrierDismissible: false,
      context: _routerDelegate.navigatorKey.currentContext,
      builder: (ctx) => ConfirmActionDialog(
        title: "You have unsaved changes",
        description: "Are you sure you want to exit",
        buttonText: "Yes",
        confirmAction: () {
          print(AppState.screenStack);
          AppState.unsavedChanges = false;
          didPopRoute();
          return didPopRoute();
        },
        cancelAction: () {
          didPopRoute();
        },
      ),
    );
  }

  @override
  Future<bool> didPopRoute() {
    // If the top item is anything except a scaffold
    if (AppState.screenStack.last == ScreenItem.dialog) {
      Navigator.pop(_routerDelegate.navigatorKey.currentContext);
      AppState.screenStack.removeLast();
      print("Current Stack: ${AppState.screenStack}");

      return Future.value(true);
    }
    // If the root tab is not 0 at the time of exit
    else if (AppState.screenStack.length == 1 &&
        _routerDelegate.appState.getCurrentTabIndex != 0) {
      _routerDelegate.appState.returnHome();
    } else if (AppState.isOnboardingInProgress) {
      BaseUtil().showNegativeAlert(
          "Exit Onboarding?🕺",
          "Press back once more to exit",
          _routerDelegate.navigatorKey.currentContext);
      AppState.isOnboardingInProgress = false;
      //return _confirmExit();
    } else if (AppState.unsavedChanges)
      return _confirmExit();
    else
      return _routerDelegate.popRoute();
  }
}
