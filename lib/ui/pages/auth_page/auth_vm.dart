import 'package:flutter/material.dart';
import 'package:wishes_app/bloc/events/login_event.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wishes_app/domain/firebase/push_notification.dart';
import 'package:wishes_app/domain/vk/vk_service.dart';
import 'package:wishes_app/helpers/error_helper.dart';
import 'package:wishes_app/repository/api/api_repository.dart';

class AuthVM extends ChangeNotifier {
  final MainBloc mainBloc;

  AuthVM({required this.mainBloc});

  static final VkAuthService? vkService = VkAuthService.byPlatform();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? get vkAuthUrl => vkService?.getAuthUrl();

  Future<void> vkSignIn(String val) async {
    if (vkService == null) return;
    _isLoading = true;
    notifyListeners();
    final isSuccess = await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        final code = vkService!.getValueFromRiderect(val);
        if (code == null) {
          return;
          // throw const LogicalError(message: 'Parse vk code error');
        }

        final tokenData = await mainBloc.state.repo.getVkAccessTokenByCode(deviceId: vkService!.uuidGenerated, code: code);
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
    if (isSuccess) {
      return;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> googleSignIn() async {
    _isLoading = true;
    notifyListeners();
    final isSuccess = await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        final user = await FirebaseAuth.instance.signInWithCredential(credential);
        final userId = await user.user?.getIdToken(true);
        final pushToken = await FirebasePush.getToken();

        if (userId != null) {
          await mainBloc.state.repo.authByFirabase(userId: userId);
          mainBloc.add(LoginEvent(token: userId, pushToken: pushToken));
          return;
        } else {
          throw const LogicalError(message: 'user id or push token is null');
        }
      },
    );
    if (isSuccess) {
      return;
    }
    _isLoading = false;
    notifyListeners();
  }

  bool _disposed = false;
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
