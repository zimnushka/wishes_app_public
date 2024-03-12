import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:wishes_app/domain/configs/app_config.dart';
import 'package:wishes_app/router/routes/archive_wish.dart';
import 'package:wishes_app/router/routes/edit_profile.dart';
import 'package:wishes_app/router/routes/followers.dart';
import 'package:wishes_app/router/routes/home.dart';
import 'package:wishes_app/router/routes/profile.dart';
import 'package:wishes_app/router/routes/user.dart';
import 'package:wishes_app/router/routes/wish.dart';

abstract class AppRoute extends Equatable {
  static Uri formatUri({
    required AppConfig config,
    String? path,
    Map<String, String?>? queryParameters,
  }) {
    final uri = Uri.parse('${config.appDomainUrl}${path ?? ''}');

    return Uri(
      scheme: uri.scheme,
      userInfo: uri.userInfo,
      host: uri.host,
      port: uri.port,
      path: uri.path,
      query: uri.query,
      queryParameters: queryParameters,
      fragment: uri.fragment,
    );
  }

  String get path;
  Widget get page;

  Uri toUri({required AppConfig config}) {
    return HomePageRoute().toUri(
      config: config,
    );
  }

  factory AppRoute.fromUri(Uri uri) {
    final constructor = pathes[uri.path];
    if (constructor != null) {
      return constructor(uri);
    } else {
      return HomePageRoute();
    }
  }
}

Map<String, AppRoute Function(Uri)> pathes = {
  HomePageRoute().path: HomePageRoute.fromUri,
  ArchivedWishesPageRoute().path: ArchivedWishesPageRoute.fromUri,
  EditProfilePageRoute().path: EditProfilePageRoute.fromUri,
  FollowersPageRoute().path: FollowersPageRoute.fromUri,
  ProfilePageRoute().path: ProfilePageRoute.fromUri,
  UserPageRoute().path: UserPageRoute.fromUri,
  WishPageRoute().path: WishPageRoute.fromUri,
};
