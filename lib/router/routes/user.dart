import 'package:flutter/material.dart';
import 'package:wishes_app/domain/configs/app_config.dart';
import 'package:wishes_app/router/routes.dart';
import 'package:wishes_app/ui/pages/user_page/user_page.dart';

class UserPageRoute implements AppRoute {
  UserPageRoute({
    this.userId,
    this.onSubscribeChangeState,
  });

  final String? userId;
  final VoidCallback? onSubscribeChangeState;

  @override
  String get path => '/user';

  @override
  Widget get page => UserPage(
        userId: userId,
        onSubscribeChangeState: onSubscribeChangeState,
      );

  @override
  factory UserPageRoute.fromUri(Uri uri) {
    return UserPageRoute(
      onSubscribeChangeState: null,
      userId: uri.queryParameters['userId'],
    );
  }

  @override
  Uri toUri({required AppConfig config}) {
    return AppRoute.formatUri(
      config: config,
      path: path,
      queryParameters: {'userId': userId.toString()},
    );
  }

  @override
  List<Object?> get props => [path, userId, onSubscribeChangeState];

  @override
  bool? get stringify => false;
}
