import 'package:wishes_app/bloc/main_event.dart';

class ChangeThemeEvent extends MainEvent {
  ChangeThemeEvent({required this.isDarkTheme});
  final bool isDarkTheme;
}
