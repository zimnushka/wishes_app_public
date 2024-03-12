import 'package:flutter/material.dart';
import 'package:wishes_app/domain/configs/app_config.dart';
import 'package:wishes_app/router/routes.dart';
import 'package:wishes_app/ui/pages/archive_wishes/archive_wishes.dart';

class ArchivedWishesPageRoute implements AppRoute {
  ArchivedWishesPageRoute();

  @override
  String get path => '/archived/wishes';

  @override
  Widget get page => const ArchirvedWishes();

  @override
  Uri toUri({required AppConfig config}) {
    return AppRoute.formatUri(
      path: path,
      config: config,
    );
  }

  @override
  factory ArchivedWishesPageRoute.fromUri(Uri uri) {
    return ArchivedWishesPageRoute();
  }

  @override
  List<Object?> get props => [path];

  @override
  bool? get stringify => false;
}
