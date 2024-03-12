import 'package:flutter/material.dart';
import 'package:wishes_app/domain/configs/app_config.dart';
import 'package:wishes_app/router/routes.dart';
import 'package:wishes_app/ui/pages/profile_page/profile_page.dart';

class ProfilePageRoute implements AppRoute {
  ProfilePageRoute();

  @override
  String get path => '/profile';

  @override
  Widget get page => const ProfilePage();

  @override
  factory ProfilePageRoute.fromUri(Uri uri) {
    return ProfilePageRoute();
  }

  @override
  Uri toUri({required AppConfig config}) {
    return AppRoute.formatUri(
      config: config,
      path: path,
    );
  }

  @override
  List<Object?> get props => [path];

  @override
  bool? get stringify => false;
}
