import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

enum VkAuthServicePlatform { android, ios, web }

class VkAuthService {
  static const _uuid = Uuid();

  const VkAuthService._({
    required this.platform,
    required this.uuidGenerated,
    required this.codeVerifier,
    required this.codeChallenge,
    required this.appId,
    required this.redirect,
    required this.state,
    required this.protectedKey,
    required this.serviceKey,
  });

  final VkAuthServicePlatform platform;
  final String uuidGenerated;

  // generate by
  // Online PKCE Generator Tool
  // https://tonyxu-io.github.io/pkce-generator/
  final String codeVerifier;
  final String codeChallenge;

  // VK app id
  // ПРИ ЗАМЕНЕ ПРОВЕРИТЬ В ДИП ЛИНКАХ, ТАК КАК РАБОТАЕТ ПО РИДЕРЕКТУ В ДИП ЛИНК
  final String appId;

  // Catch riderct page
  // ПРИ ЗАМЕНЕ ПРОВЕРИТЬ В ДИП ЛИНКАХ, ТАК КАК РАБОТАЕТ ПО РИДЕРЕКТУ В ДИП ЛИНК
  final String redirect;

  // Catch state after auth for check
  final String state;
  final String protectedKey;
  final String serviceKey;

  static VkAuthService? byPlatform() {
    if (kIsWeb) {
      return VkAuthService._web();
    } else if (Platform.isIOS) {
      return VkAuthService._ios();
    } else if (Platform.isAndroid) {
      return VkAuthService._android();
    }
    return null;
  }

  // TODO!!: set data
  factory VkAuthService._android() {
    const appId = '';
    return VkAuthService._(
      platform: VkAuthServicePlatform.android,
      uuidGenerated: _uuid.v4(),
      codeVerifier: '',
      codeChallenge: '',
      appId: appId,
      redirect: appId,
      state: '',
      protectedKey: '',
      serviceKey: '',
    );
  }

  factory VkAuthService._web() {
    const appId = '';
    return VkAuthService._(
      platform: VkAuthServicePlatform.android,
      uuidGenerated: _uuid.v4(),
      codeVerifier: '',
      codeChallenge: '',
      appId: appId,
      redirect: 'vk$appId://vk.com/service.html',
      state: '',
      protectedKey: '',
      serviceKey: '',
    );
  }

  factory VkAuthService._ios() {
    const appId = '';
    return VkAuthService._(
      platform: VkAuthServicePlatform.android,
      uuidGenerated: _uuid.v4(),
      codeVerifier: '',
      codeChallenge: '',
      appId: appId,
      redirect: 'vk$appId://vk.com/service.html',
      state: '',
      protectedKey: '',
      serviceKey: '',
    );
  }

  String getAuthUrl() {
    return 'https://id.vk.com/auth?state=$state&response_type=code&code_challenge=$codeChallenge&code_challenge_method=sha256&app_id=$appId&v=0.0.2&redirect_uri=$redirect&uuid=$uuidGenerated';
  }

  String? getValueFromRiderect(String value) {
    try {
      final params = Uri.parse(value).queryParameters;
      final Map<String, dynamic> payload = jsonDecode(params['payload']!);
      final code = payload['oauth']['code'];
      return code;
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      return null;
    }
  }
}
