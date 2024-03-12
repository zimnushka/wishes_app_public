import 'package:flutter/material.dart';
import 'package:wishes_app/domain/configs/app_config.dart';
import 'package:wishes_app/domain/logs/logger_service.dart';
import 'package:wishes_app/domain/toast/toast_state.dart';
import 'package:wishes_app/router/app_back_btn_dispetcher.dart';
import 'package:wishes_app/router/router_delegate.dart';
import 'package:wishes_app/router/router_information_parser.dart';
import 'package:wishes_app/router/routes.dart';

class AppRouter {
  final AppConfig config;
  AppRouter({required this.config}) {
    routerDelegate = AppRouterDelegate();
    routerInformationParser = AppRouterInformationParser(config: config);
    backBtnDispatcher = AppBackBtnDispatcher(routerDelegate);
  }

  late final AppRouterDelegate routerDelegate;
  late final AppRouterInformationParser routerInformationParser;

  late final AppBackBtnDispatcher backBtnDispatcher;

  Future<void> goTo(AppRoute page) async {
    LoggerService(config: config).send(
      AppLogEvent(type: AppLogType.route, value: page.runtimeType.toString()),
    );
    routerDelegate.setNewRoutePath(page);
  }

  void showError(
    String text, {
    VoidCallback? onTap,
    Duration duration = const Duration(seconds: 4),
  }) {
    routerDelegate.showOverlayMessage(
      text: text,
      toastType: ToastType.error,
      duration: duration,
      onTap: onTap,
    );
  }

  void showInfo(
    String text, {
    VoidCallback? onTap,
    Duration duration = const Duration(seconds: 4),
  }) {
    routerDelegate.showOverlayMessage(
      text: text,
      toastType: ToastType.info,
      duration: duration,
      onTap: onTap,
    );
  }

  void showSuccess(
    String text, {
    VoidCallback? onTap,
    Duration duration = const Duration(seconds: 4),
  }) {
    routerDelegate.showOverlayMessage(
      text: text,
      toastType: ToastType.success,
      duration: duration,
      onTap: onTap,
    );
  }

  Future<void> pop() async {
    routerDelegate.back();
  }

  Future<void> clear() async {
    routerDelegate.clear();
  }

  bool get canPop => routerDelegate.canPop;
}
