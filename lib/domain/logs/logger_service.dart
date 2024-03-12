import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:wishes_app/domain/configs/app_config.dart';

enum AppLogType {
  api,
  error,
  test,
  route,
}

class AppLogEvent {
  final String value;
  final String? onlyTestValue;
  final AppLogType type;

  const AppLogEvent({
    required this.type,
    required this.value,
    this.onlyTestValue,
  });
}

class LoggerService {
  final AppConfig config;
  const LoggerService({required this.config});

  void send(AppLogEvent event) {
    try {
      if (config.logsType.contains(event.type)) {
        final logName = event.type.name.toUpperCase();
        final time = DateTime.now();

        if (event.type != AppLogType.api) {
          FirebaseAnalytics.instance.logEvent(
            name: logName,
            parameters: {'value': event.value},
          );
        }

        if (kIsWeb) {
          if (kDebugMode) {
            print('[${event.type.name.toUpperCase()}]  ${event.value}\n${event.onlyTestValue}');
          }
        } else {
          log(
            '${event.value}\n${event.onlyTestValue}',
            name: logName,
            time: time,
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
