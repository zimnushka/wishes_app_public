import 'package:flutter/material.dart';
import 'package:wishes_app/ui/styles/colors_book.dart';
import 'package:wishes_app/ui/styles/const.dart';

class ThemesBook {
  static ThemeData get light => _setColors(
        ThemeData.light().copyWith(
          scaffoldBackgroundColor: ColorsBook.lightBase,
          cardColor: Colors.grey.shade100,
          disabledColor: ColorsBook.lightDisable,
          dividerColor: ColorsBook.lightDivider,
          colorScheme: ThemeData.light().colorScheme.copyWith(
                error: ColorsBook.error,
                background: ColorsBook.lightBase,
              ),
        ),
        ColorsBook.active,
      );
  static ThemeData get dark => _setColors(
        ThemeData.dark().copyWith(
          scaffoldBackgroundColor: ColorsBook.darkBase,
          disabledColor: ColorsBook.darkDisable,
          dividerColor: ColorsBook.darkDivider,
          colorScheme: ThemeData.dark().colorScheme.copyWith(
                error: ColorsBook.error,
                background: ColorsBook.darkBase,
              ),
        ),
        ColorsBook.active,
      );
}

ThemeData _setColors(ThemeData data, Color color) {
  return data.copyWith(
    dividerTheme: DividerThemeData(
      color: data.dividerColor,
      space: 0,
    ),
    splashColor: Colors.transparent,
    hoverColor: Colors.transparent,
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: color,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: data.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: color,
      selectionColor: Colors.grey.withOpacity(0.3),
      selectionHandleColor: Colors.grey.withOpacity(0.3),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: data.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(radius),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: data.cardColor,
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(radius),
        borderSide: BorderSide(color: data.colorScheme.error, width: 1),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(radius),
        borderSide: BorderSide(color: Colors.transparent, width: 1),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(radius),
        borderSide: BorderSide(color: Colors.transparent, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(radius),
        borderSide: BorderSide(color: color, width: 1),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(radius),
        borderSide: BorderSide(color: color, width: 1),
      ),
    ),
    primaryColor: color,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        elevation: 0,
        side: BorderSide(
          width: 1,
          color: color,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(radius),
          side: BorderSide(
            width: 1,
            color: color,
          ),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        overlayColor: const MaterialStatePropertyAll(Colors.transparent),
        foregroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> state) {
          if (state.contains(MaterialState.disabled)) {
            return ColorsBook.lightBase.withOpacity(0.5);
          }
          return ColorsBook.lightBase;
        }),
        backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> state) {
          if (state.contains(MaterialState.disabled)) {
            return data.disabledColor;
          }
          return color;
        }),
        shape: const MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(radius),
          ),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: color)),
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: color),
    colorScheme: data.colorScheme.copyWith(
      background: data.scaffoldBackgroundColor,
    ),
    listTileTheme: ListTileThemeData(
      selectedColor: color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(radius),
      ),
    ),
  );
}
