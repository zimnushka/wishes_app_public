import 'package:flutter/material.dart';

enum ResponsiveUiMode {
  mobile,
  desctop;

  static ResponsiveUiMode byWidth(double width) {
    if (width < 800) {
      return ResponsiveUiMode.mobile;
    }
    return ResponsiveUiMode.desctop;
  }

// double? get maxWidth{
//   switch (this) {

//     case ResponsiveUiMode.mobile:
//      return 800;
//     case ResponsiveUiMode.desctop:
//       return null;
//   }
// }
}

class ResponsiveUi extends StatelessWidget {
  const ResponsiveUi({
    required this.builder,
    super.key,
  });
  final Widget Function(BuildContext context, ResponsiveUiMode mode) builder;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return builder(context, ResponsiveUiMode.byWidth(width));
  }
}
