import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/confirm_action_dialog.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'router_delegate.dart';

class FelloBackButtonDispatcher extends RootBackButtonDispatcher {
  final FelloRouterDelegate _routerDelegate;

  FelloBackButtonDispatcher(this._routerDelegate) : super();

  @override
  Future<bool> didPopRoute() {
    if (AppState.dialogOpenCount > 0) {
      Navigator.pop(_routerDelegate.navigatorKey.currentContext);
      AppState.dialogOpenCount--;
      print("Dialog open remaining are: ${AppState.dialogOpenCount}");
      return Future.value(true);
    }
    if (AppState.unsavedChanges) {
      showDialog(
        context: _routerDelegate.navigatorKey.currentContext,
        builder: (ctx) => ConfirmActionDialog(
          title: "You changes are unsaved",
          description: "Are you sure you want to go back?",
          buttonText: "Yes",
          cancelBtnText: 'Cancel',
          confirmAction: () {
            AppState.dialogOpenCount--;
            Navigator.pop(_routerDelegate.navigatorKey.currentContext);
            Navigator.pop(_routerDelegate.navigatorKey.currentContext);
          },
          cancelAction: () {
            AppState.dialogOpenCount--;
            Navigator.pop(_routerDelegate.navigatorKey.currentContext);
          },
        ),
      );
    }
    return _routerDelegate.popRoute();
  }
}
