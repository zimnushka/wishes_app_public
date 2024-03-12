import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:wishes_app/bloc/events/change_theme_event.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/repository/local/local_reposutory.dart';
import 'package:wishes_app/ui/styles/themes_book.dart';

Future<void> changeThemeHandler(ChangeThemeEvent event, Emitter emit, MainBloc mainBloc) async {
  await mainBloc.localRepo.saveTheme(isDarkTheme: event.isDarkTheme);

  final theme = event.isDarkTheme ? ThemesBook.dark : ThemesBook.light;

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: theme.scaffoldBackgroundColor,
      systemNavigationBarColor: theme.scaffoldBackgroundColor,
      statusBarIconBrightness: event.isDarkTheme ? Brightness.light : Brightness.dark,
      systemNavigationBarIconBrightness: event.isDarkTheme ? Brightness.light : Brightness.dark,
    ),
  );

  emit(mainBloc.state.copyWith(isDarkTheme: event.isDarkTheme));
}
