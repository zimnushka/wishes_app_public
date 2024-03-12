import 'package:flutter/material.dart';
import 'package:wishes_app/domain/configs/app_config.dart';
import 'package:wishes_app/router/routes.dart';
import 'package:wishes_app/ui/pages/followers_page/followers_page.dart';

class FollowersPageRoute implements AppRoute {
  FollowersPageRoute({
    this.userId,
    this.followedBy = true,
  });

  final String? userId;
  final bool followedBy;

  @override
  String get path => '/followers';

  @override
  Widget get page => FollowersPage(
        userId: userId,
        followedBy: followedBy,
      );

  @override
  factory FollowersPageRoute.fromUri(Uri uri) {
    final followedBy = bool.tryParse(uri.queryParameters['followedBy'] ?? 'false');
    final userId = uri.queryParameters['userId'];
    return FollowersPageRoute(
      followedBy: followedBy ?? false,
      userId: userId != null && userId.isNotEmpty ? userId : null,
    );
  }

  @override
  Uri toUri({required AppConfig config}) {
    return AppRoute.formatUri(
      config: config,
      path: path,
      queryParameters: {
        'userId': userId,
        'followedBy': followedBy.toString(),
      },
    );
  }

  @override
  List<Object?> get props => [path, userId, followedBy];

  @override
  bool? get stringify => false;
}
