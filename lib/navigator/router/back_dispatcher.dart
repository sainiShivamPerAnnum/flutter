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
    if (AppState().getDialogOpenStatus == true) {
      Navigator.pop(_routerDelegate.navigatorKey.currentContext);
      AppState().setDialogOpenStatus = false;
      return Future.value(true);
    }
    return _routerDelegate.popRoute();
  }
}
