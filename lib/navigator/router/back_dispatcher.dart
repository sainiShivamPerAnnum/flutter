import 'package:felloapp/navigator/app_state.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'router_delegate.dart';

// 1
class FelloBackButtonDispatcher extends RootBackButtonDispatcher {
  // 2
  final FelloRouterDelegate _routerDelegate;

  FelloBackButtonDispatcher(this._routerDelegate) : super();

  // 3
  @override
  Future<bool> didPopRoute() {
    if (AppState.dialogOpenCount > 0) {
      Navigator.pop(_routerDelegate.navigatorKey.currentContext);
      AppState.dialogOpenCount--;
      print("Dialog open remaining are: ${AppState.dialogOpenCount}");
      return Future.value(true);
    }
    return _routerDelegate.popRoute();
  }
}
