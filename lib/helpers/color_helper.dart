import 'package:flutter/material.dart';

abstract class ColorHelper {
  static Color colorFromId(String id) {
    return Color(id.hashCode).withOpacity(0.5);
  }

  static LinearGradient gradientFromId(String id, ThemeData theme) {
    final primaryColor = colorFromId(id);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.8, 1],
      colors: [
        theme.scaffoldBackgroundColor,
        primaryColor,
        theme.scaffoldBackgroundColor,
      ],
    );
  }
}
