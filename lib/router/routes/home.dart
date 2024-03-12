import 'package:flutter/material.dart';
import 'package:wishes_app/domain/configs/app_config.dart';
import 'package:wishes_app/router/routes.dart';
import 'package:wishes_app/ui/pages/home_page/home_page.dart';

class HomePageRoute implements AppRoute {
  HomePageRoute();

  @override
  String get path => '/';

  @override
  Widget get page => const HomePage();

  @override
  Uri toUri({required AppConfig config}) {
    return AppRoute.formatUri(
      config: config,
      path: path,
    );
  }

  @override
  factory HomePageRoute.fromUri(Uri uri) {
    return HomePageRoute();
  }

  @override
  List<Object?> get props => [path];

  @override
  bool? get stringify => false;
}
