import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ShareIcon extends StatelessWidget {
  const ShareIcon({
    this.color,
    this.size,
    super.key,
  });
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    Widget icon = const SizedBox();

    if (kIsWeb) {
      icon = Icon(Icons.share, size: size, color: color);
    } else {
      if (Platform.isIOS || Platform.isMacOS) {
        icon = Icon(Icons.ios_share, size: size, color: color);
      } else {
        icon = Icon(Icons.share, size: size, color: color);
      }
    }

    return icon;
  }
}
