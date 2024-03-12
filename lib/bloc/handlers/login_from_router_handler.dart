import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wishes_app/bloc/events/login_event.dart';
import 'package:wishes_app/bloc/events/login_from_router_event.dart';
import 'package:wishes_app/bloc/events/logout_event.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/domain/auth/auth_state.dart';
import 'package:wishes_app/domain/firebase/push_notification.dart';
import 'package:wishes_app/domain/vk/vk_service.dart';
import 'package:wishes_app/helpers/error_helper.dart';
import 'package:wishes_app/repository/api/api_repository.dart';

Future<void> loginFromRouterHandler(LoginFromRouterEvent event, Emitter emit, MainBloc mainBloc) async {
  emit(
    mainBloc.state.copyWith(
      authState: mainBloc.state.authState.copyWith(
        status: AuthStatus.loading,
      ),
    ),
  );
  final vkService = VkAuthService.byPlatform();
  bool isSuccess = false;
  if (vkService != null) {
    isSuccess = await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        final code = vkService.getValueFromRiderect(event.uri);
        if (code == null) return;

        final tokenData = await mainBloc.state.repo.getVkAccessTokenByCode(deviceId: vkService.uuidGenerated, code: code);
        final firebaseData = await mainBloc.state.repo.authByVK(
          token: tokenData.$1,
          email: tokenData.$2,
          phone: tokenData.$3,
        );
        if (firebaseData.$1 == null || firebaseData.$2 == null) {
          throw const LogicalError(message: 'firebase_uid or firebase_token is empty');
        }
        final user = await FirebaseAuth.instance.signInWithCustomToken(firebaseData.$2!);
        final userId = await user.user?.getIdToken(true);
        final pushToken = await FirebasePush.getToken();
        if (userId != null) {
          mainBloc.add(
            LoginEvent(
              token: userId,
              pushToken: pushToken,
              customToken: firebaseData.$2,
            ),
          );
          return;
        } else {
          throw const LogicalError(message: 'user id or push token is null');
        }
      },
    );
  }
  if (!isSuccess) {
    mainBloc.add(LogoutEvent());
  }
}
