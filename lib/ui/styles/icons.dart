import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icons, {
    this.height = 15,
    this.width = 15,
    this.color,
    super.key,
  });
  final AppIcons icons;
  final double width;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/${icons.path}.svg'.toLowerCase(),
      height: height,
      width: width,
      colorFilter: ColorFilter.mode(color ?? IconTheme.of(context).color!, BlendMode.srcIn),
    );
  }
}

enum AppIcons {
  google,
  vk;

  String get path {
    switch (this) {
      case AppIcons.google:
        return 'google';
      case AppIcons.vk:
        return 'vk';
    }
  }
}
