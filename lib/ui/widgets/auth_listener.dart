import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/domain/auth/auth_state.dart';
import 'package:wishes_app/ui/pages/auth_page/auth_page.dart';
import 'package:wishes_app/ui/pages/splash_page/splash_page.dart';

class AuthListener extends StatelessWidget {
  const AuthListener({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final status = context.select((MainBloc vm) => vm.state.authState.status);
    switch (status) {
      case AuthStatus.loading:
        return const SplashPage();
      case AuthStatus.unAuthorized:
        return const AuthPage();
      case AuthStatus.authorized:
        return child;
    }
  }
}
