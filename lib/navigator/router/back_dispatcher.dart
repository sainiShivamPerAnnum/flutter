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
        title: "Are you sure?",
        description: "You have unsaved changes, if you exit it will be lost",
        buttonText: "Yes",
        confirmAction: () {
          print(AppState.screenStack);
          AppState.unsavedChanges = false;
          didPopRoute();
          return _routerDelegate.popRoute();
        },
        cancelAction: () {
          didPopRoute();
        },
      ),
    );
  }

  @override
  Future<bool> didPopRoute() {
    if (AppState.screenStack.last == ScreenItem.dialog) {
      Navigator.pop(_routerDelegate.navigatorKey.currentContext);
      AppState.screenStack.removeLast();
      print("Current Stack: ${AppState.screenStack}");

      return Future.value(true);
    } else {
      if (AppState.unsavedChanges == true) {
        return _confirmExit();
      } else {
        return _routerDelegate.popRoute();
      }
    }
  }
}
