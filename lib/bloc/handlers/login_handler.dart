import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wishes_app/bloc/events/change_theme_event.dart';
import 'package:wishes_app/bloc/events/login_event.dart';
import 'package:wishes_app/bloc/events/logout_event.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/domain/auth/auth_state.dart';
import 'package:wishes_app/domain/firebase/push_notification.dart';
import 'package:wishes_app/domain/logs/logger_service.dart';
import 'package:wishes_app/helpers/error_helper.dart';
import 'package:wishes_app/repository/api/api_repository.dart';
import 'package:wishes_app/repository/local/local_reposutory.dart';

Future<void> loginHandler(LoginEvent event, Emitter emit, MainBloc mainBloc) async {
  try {
    final repo = ApiRepository(
      config: mainBloc.state.config,
      token: event.token,
    );
    // Пробное получение пользователя
    final user = await repo.getUserMe();
    // при успешном получении сохраняем токен
    await mainBloc.localRepo.saveApiToken(userId: event.token);
    if (event.customToken != null) {
      await mainBloc.localRepo.saveCustomToken(custom: event.customToken!);
    }
    // отправляем пуш токен на бек
    if (event.pushToken != null) {
      await repo.savePushToken(pushToken: event.pushToken!);
    }

    final isDarkTheme = await mainBloc.localRepo.readTheme();
    mainBloc.add(ChangeThemeEvent(isDarkTheme: isDarkTheme ?? true));

    emit(
      mainBloc.state.copyWith(
        repo: repo,
        authState: AuthState(
          user: user,
          status: AuthStatus.authorized,
        ),
      ),
    );
  } on ApiError catch (err) {
    if (err.statusCode == 401) {
      final custom = await mainBloc.localRepo.readCustomToken();

      final user = FirebaseAuth.instance.currentUser;
      final userId = await user?.getIdToken(true);
      final pushToken = await FirebasePush.getToken();

      if (userId != null) {
        mainBloc.add(
          LoginEvent(
            token: userId,
            pushToken: pushToken,
            customToken: custom,
          ),
        );
        return;
      }
    }
    mainBloc.add(LogoutEvent());
  } catch (err) {
    LoggerService(config: mainBloc.state.config).send(
      AppLogEvent(
        type: AppLogType.error,
        value: err.toString(),
      ),
    );
    mainBloc.add(LogoutEvent());
  }
}
