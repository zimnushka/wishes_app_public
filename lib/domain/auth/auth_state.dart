import 'package:equatable/equatable.dart';
import 'package:wishes_app/domain/models/user.dart';

enum AuthStatus {
  authorized,
  unAuthorized,
  loading,
}

class AuthState extends Equatable {
  final User user;
  final AuthStatus status;

  const AuthState({
    required this.user,
    required this.status,
  });

  factory AuthState.empty() => AuthState(
        user: User.empty(),
        status: AuthStatus.loading,
      );

  @override
  List<Object?> get props => [user, status];

  AuthState copyWith({
    User? user,
    AuthStatus? status,
  }) {
    return AuthState(
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }
}
