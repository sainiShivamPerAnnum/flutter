import 'package:flutter/material.dart';
import 'router_delegate.dart';

// 1
class FelloBackButtonDispatcher extends RootBackButtonDispatcher {
  // 2
  final FelloRouterDelegate _routerDelegate;

  FelloBackButtonDispatcher(this._routerDelegate) : super();

  // 3
  @override
  Future<bool> didPopRoute() {
    return _routerDelegate.popRoute();
  }
}
