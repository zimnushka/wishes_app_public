part of '../api_repository.dart';

extension AuthApiExt on ApiRepository {
  Future<void> authByFirabase({required String userId}) async {
    await _postRequest(
      url: '/auth/firebase',
      body: {"id_token": userId},
      headers: Map.fromEntries([
        headerCORS,
        headerAcceptAll,
        headerContentJson,
      ]),
    );
  }

  Future<void> savePushToken({required String pushToken}) async {
    await _postRequest(
      url: '/save_push_token',
      body: {"push_token": pushToken},
      headers: Map.fromEntries([
        headerAuthToken,
        headerAcceptAll,
        headerContentJson,
        headerCORS,
      ]),
    );
  }

  Future<(String?, String?)> authByVK({
    required String token,
    String? phone,
    String? email,
  }) async {
    final json = await _postRequest(
      url: '/auth/vk/mobile',
      headers: Map.fromEntries([
        headerAcceptAll,
        headerContentJson,
      ]),
      body: {
        "access_token": token,
        "email": email,
        "phone": phone,
      },
    );

    final data = jsonDecode(json ?? "");
    return (data['firebase_uid'] as String?, data['firebase_token'] as String?);
  }

  Future<(String, String?, String?)> getVkAccessTokenByCode({required String deviceId, required String code}) async {
    final vkService = VkAuthService.byPlatform();
    if (vkService == null) {
      throw const LogicalError(
        message: 'Данная платформа не поддерживает авторизацию VK, мы над этим уже работаем',
      );
    }
    final res = await http.post(
      Uri.parse('https://oauth.vk.com/access_token'),
      headers: <String, String>{},
      body: {
        "client_id": vkService.appId,
        "client_secret": vkService.protectedKey,
        "code_verifier": vkService.codeVerifier,
        "device_id": deviceId,
        "code": code,
        "redirect_uri": vkService.redirect,
      },
    );
    if (res.statusCode < 200 || res.statusCode > 204) {
      throw ApiError(message: res.body, statusCode: res.statusCode);
    }
    final json = jsonDecode(utf8.decode(res.bodyBytes));
    return (json['access_token'] as String, json['email'] as String?, json['phone'] as String?);
  }
}
