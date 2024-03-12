import 'package:wishes_app/bloc/main_event.dart';

class LoginFromRouterEvent extends MainEvent {
  final String uri;
  LoginFromRouterEvent({required this.uri});
}
