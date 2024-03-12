import 'package:flutter/material.dart';
import 'package:wishes_app/domain/configs/app_config.dart';
import 'package:wishes_app/router/routes.dart';
import 'package:wishes_app/ui/pages/wish_page/wish_page.dart';

class WishPageRoute implements AppRoute {
  WishPageRoute({
    this.wishId,
    this.initImageLink,
    this.onUpdate,
  });

  final String? wishId;
  final String? initImageLink;
  final VoidCallback? onUpdate;

  @override
  String get path => '/wish';

  @override
  Widget get page => WishPage(
        wishId: wishId,
        initImageLink: initImageLink,
        onUpdate: onUpdate,
      );

  @override
  factory WishPageRoute.fromUri(Uri uri) {
    final id = uri.queryParameters['wishId'];
    return WishPageRoute(
      onUpdate: null,
      wishId: id != null && id.isNotEmpty ? id : null,
      initImageLink: null,
    );
  }

  @override
  Uri toUri({required AppConfig config}) {
    return AppRoute.formatUri(
      config: config,
      path: path,
      queryParameters: {'wishId': wishId},
    );
  }

  @override
  List<Object?> get props => [path, wishId, initImageLink, onUpdate];

  @override
  bool? get stringify => false;
}
