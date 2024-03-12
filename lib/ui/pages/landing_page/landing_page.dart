import 'package:flutter/material.dart';
import 'package:wishes_app/ui/widgets/auth_listener.dart';

class AppLanding extends StatelessWidget {
  const AppLanding({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: AuthListener(
        child: child,
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
