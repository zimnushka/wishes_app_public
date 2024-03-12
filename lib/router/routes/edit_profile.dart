import 'package:flutter/material.dart';
import 'package:wishes_app/domain/configs/app_config.dart';
import 'package:wishes_app/router/routes.dart';
import 'package:wishes_app/ui/pages/edit_profile_page/edit_profile_page.dart';

class EditProfilePageRoute implements AppRoute {
  EditProfilePageRoute();

  @override
  String get path => '/editProfile';

  @override
  Widget get page => const EditProfilePage();

  @override
  Uri toUri({required AppConfig config}) {
    return AppRoute.formatUri(
      config: config,
      path: path,
    );
  }

  @override
  factory EditProfilePageRoute.fromUri(Uri uri) {
    return EditProfilePageRoute();
  }

  @override
  List<Object?> get props => [path];

  @override
  bool? get stringify => false;
}
