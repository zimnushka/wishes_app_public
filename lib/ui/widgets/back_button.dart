import 'package:flutter/material.dart';

class BackButtonL extends StatelessWidget {
  const BackButtonL({
    required this.onTap,
    this.color,
    super.key,
  });
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? Theme.of(context).iconTheme.color;
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: SizedBox(
        width: 40,
        height: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              width: 1,
              color: iconColor ?? Theme.of(context).cardColor,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 15,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
