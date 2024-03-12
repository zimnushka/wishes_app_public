import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/router/routes.dart';

class FirebasePush {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static MainBloc? _mainBloc;

  static Future<void> _bgMessage(RemoteMessage message) async {
    if (kDebugMode) {
      print(message.notification?.title);
      print(message.notification?.body);
      print(message.data);
    }
  }

  static Future<void> _fgMessage(RemoteMessage message) async {
    final mainBloc = _mainBloc;
    if (mainBloc != null && message.data.containsKey('link')) {
      final uri = Uri.tryParse(message.data['link']);
      if (uri == null) return;
      mainBloc.router.goTo(AppRoute.fromUri(uri));
    }
  }

  static Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (err) {
      return null;
    }
  }

  static Future<void> init(MainBloc mainBloc) async {
    _mainBloc = mainBloc;
    await _firebaseMessaging.requestPermission();
    await _firebaseMessaging.setAutoInitEnabled(true);

    FirebaseMessaging.onMessage.listen((event) {
      final title = event.notification?.title ?? '';
      final body = event.notification?.body ?? '';

      _mainBloc?.router.showInfo('$title\n$body', onTap: () {
        if (event.data.containsKey('link')) {
          final uri = Uri.tryParse(event.data['link']);
          if (uri == null) return;
          mainBloc.router.goTo(AppRoute.fromUri(uri));
        }
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_fgMessage);
    FirebaseMessaging.onBackgroundMessage(_bgMessage);
  }
}
