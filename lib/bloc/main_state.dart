// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:wishes_app/domain/auth/auth_state.dart';
import 'package:wishes_app/domain/configs/app_config.dart';
import 'package:wishes_app/domain/toast/toast_state.dart';
import 'package:wishes_app/repository/api/api_repository.dart';

class MainState extends Equatable {
  final AuthState authState;
  final bool isDarkTheme;
  final ToastState toastState;
  final AppConfig config;
  final ApiRepository repo;

  const MainState({
    required this.authState,
    required this.isDarkTheme,
    required this.toastState,
    required this.config,
    required this.repo,
  });

  @override
  List<Object?> get props => [
        authState,
        isDarkTheme,
        toastState,
        config,
        repo,
      ];

  MainState copyWith({
    AuthState? authState,
    ToastState? toastState,
    bool? isDarkTheme,
    AppConfig? config,
    ApiRepository? repo,
  }) {
    return MainState(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      authState: authState ?? this.authState,
      toastState: toastState ?? this.toastState,
      config: config ?? this.config,
      repo: repo ?? this.repo,
    );
  }
}
