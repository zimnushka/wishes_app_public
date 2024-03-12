import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:wishes_app/bloc/events/login_event.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/domain/logs/logger_service.dart';

class ApiError implements Exception {
  final String message;
  final int statusCode;

  const ApiError({
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() {
    return '$message\ncode = $statusCode';
  }

  String? tryGetMessage() {
    final res = jsonDecode(message);
    if (res is Map && res.containsKey('detail')) {
      return res['detail'];
    }
    return null;
  }
}

class LogicalError implements Exception {
  final String message;

  const LogicalError({
    required this.message,
  });

  @override
  String toString() {
    return message;
  }
}

class ErrorHelper {
  static Future<bool> catchError({
    required MainBloc mainBloc,
    required AsyncCallback func,
    bool notifyError = true,
    Function(Object)? onError,
  }) async {
    final logger = LoggerService(config: mainBloc.state.config);
    final random = Random();
    try {
      await func();
      return true;
    } on ApiError catch (error) {
      logger.send(AppLogEvent(type: AppLogType.error, value: '${error.message}\ncode: ${error.statusCode}'));

      // Token сгнил
      if (error.statusCode == 401) {
        // TODO: попробовать сделать обновление токена, и перезапуск запроса
        mainBloc.add(LoginEvent(token: '', pushToken: ''));
        return false;
      }

      // Token сгнил
      if (error.statusCode == 502) {
        if (notifyError) {
          mainBloc.router.showError(
            [
              'SERVER не алё',
              'SERVER абонент не абонент',
              'SERVER наелся и спит',
            ].elementAt(random.nextInt(3)),
          );
        }
        return false;
      }

      if (notifyError) {
        mainBloc.router.showError(error.tryGetMessage() ?? error.message);
      }
      onError?.call(error);
      return false;
    } on LogicalError catch (error) {
      logger.send(AppLogEvent(type: AppLogType.error, value: error.message));

      if (notifyError) {
        mainBloc.router.showError(error.message);
      }
      onError?.call(error);
      return false;
    } catch (error) {
      logger.send(AppLogEvent(type: AppLogType.error, value: error.toString()));
      if (notifyError) {
        mainBloc.router.showError(error.toString());
      }
      onError?.call(error);
      return false;
    }
  }
}
