import 'package:felloapp/base_util.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/confirm_action_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'router_delegate.dart';

class FelloBackButtonDispatcher extends RootBackButtonDispatcher {
  final FelloRouterDelegate _routerDelegate;

  FelloBackButtonDispatcher(this._routerDelegate) : super();

  Future<bool> _confirmExit() {
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
          AppState.screenStack.removeLast();
          Navigator.pop(_routerDelegate.navigatorKey.currentContext);
          return _routerDelegate.popRoute();
        },
        cancelAction: () {
          AppState.screenStack.removeLast();
          Navigator.pop(_routerDelegate.navigatorKey.currentContext);
        },
      ),
    );
  }

  @override
  Future<bool> didPopRoute() {
    print("Previous: ${AppState.screenStack}");
    if (AppState.screenStack.last == ScreenItem.dialog) {
      AppState.screenStack.removeLast();
      Navigator.pop(_routerDelegate.navigatorKey.currentContext);
      return Future.value(true);
    } else {
      if (AppState.unsavedChanges == true) {
        return _confirmExit();
      } else
        return _routerDelegate.popRoute();
    }
  }
}
