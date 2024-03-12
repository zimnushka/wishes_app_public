import 'package:flutter/material.dart';
import 'package:wishes_app/router/router_delegate.dart';

class AppBackBtnDispatcher extends RootBackButtonDispatcher {
  final AppRouterDelegate _routerDelegate;

  AppBackBtnDispatcher(this._routerDelegate) : super();

  @override
  Future<bool> didPopRoute() async {
    return _routerDelegate.popRoute();
  }
}
