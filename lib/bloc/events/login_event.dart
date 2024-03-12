import 'package:wishes_app/bloc/main_event.dart';

class LoginEvent extends MainEvent {
  final String token;
  final String? customToken;
  final String? pushToken;

  LoginEvent({
    required this.token,
    this.customToken,
    required this.pushToken,
  });
}
