import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:wishes_app/domain/configs/app_config.dart';
import 'package:wishes_app/domain/logs/logger_service.dart';
import 'package:wishes_app/domain/models/preview_meta_data.dart';
import 'package:wishes_app/domain/models/user.dart';
import 'dart:convert';
import 'package:wishes_app/domain/models/wish.dart';
import 'package:wishes_app/domain/vk/vk_service.dart';
import 'package:wishes_app/helpers/error_helper.dart';

part 'extensions/user_api_ext.dart';
part 'extensions/preview_api_ext.dart';
part 'extensions/wish_api_ext.dart';
part 'extensions/auth_api_ext.dart';
part 'extensions/follower_api_ext.dart';

class ApiRepository {
  const ApiRepository({
    required this.config,
    this.token,
  });
  final AppConfig config;
  final String? token;

  LoggerService get _logger => LoggerService(config: config);

  MapEntry<String, String> get headerAcceptAll => const MapEntry('accept', '*/*');
  MapEntry<String, String> get headerContentJson => const MapEntry('Content-Type', 'application/json');
  MapEntry<String, String> get headerContentXWwwFormUrlcoded => const MapEntry('Content-Type', 'application/x-www-form-urlencoded');
  MapEntry<String, String> get headerCORS => const MapEntry('Access-Control-Allow-Origin', '*');
  MapEntry<String, String> get headerContentMultipart => const MapEntry('Content-Type', 'multipart/form-data');
  MapEntry<String, String> get headerAuthToken => MapEntry('Authorization', token ?? '');

  Future<String?> _getRequest({
    required String url,
    String? hostUrl,
    Map<String, String>? headers,
  }) async {
    final res = await http.get(Uri.parse('${hostUrl ?? config.apiUrl}$url'), headers: headers);
    _logger.send(AppLogEvent(type: AppLogType.api, value: '''
METHOD: GET
URL: ${hostUrl ?? config.apiUrl}$url
STATUS CODE: ${res.statusCode}
RESPONSE: ${res.body}
'''));
    final resultStr = utf8.decode(res.bodyBytes);
    if (res.statusCode < 200 || res.statusCode > 204) {
      throw ApiError(message: resultStr, statusCode: res.statusCode);
    }

    return resultStr;
  }

  Future<String?> _deleteRequest({
    required String url,
    String? hostUrl,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final res = await http.delete(
      Uri.parse('${hostUrl ?? config.apiUrl}$url'),
      headers: headers,
      body: jsonEncode(body),
    );
    _logger.send(AppLogEvent(type: AppLogType.api, value: '''
METHOD: DELETE
URL: ${hostUrl ?? config.apiUrl}$url
STATUS CODE: ${res.statusCode}
BODY: $body
RESPONSE: ${res.body}
'''));
    final resultStr = utf8.decode(res.bodyBytes);
    if (res.statusCode < 200 || res.statusCode > 204) {
      throw ApiError(message: resultStr, statusCode: res.statusCode);
    }
    return resultStr;
  }

  Future<String?> _postRequest({
    required String url,
    String? hostUrl,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final res = await http.post(
      Uri.parse('${hostUrl ?? config.apiUrl}$url'),
      headers: headers,
      body: jsonEncode(body),
    );
    _logger.send(AppLogEvent(type: AppLogType.api, value: '''
METHOD: POST
URL: ${hostUrl ?? config.apiUrl}$url
STATUS CODE: ${res.statusCode}
BODY: $body
RESPONSE: ${res.body}
'''));
    final resultStr = utf8.decode(res.bodyBytes);

    if (res.statusCode < 200 || res.statusCode > 204) {
      throw ApiError(message: resultStr, statusCode: res.statusCode);
    }
    return resultStr;
  }

  Future<String?> _multipartRequest({
    required String url,
    String? hostUrl,
    String fileParametrName = 'file',
    required String fileName,
    required List<int> bytes,
    Map<String, String>? headers,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse('${hostUrl ?? config.apiUrl}$url'));
    request.headers.addAll(headers ?? {});
    request.files.add(http.MultipartFile.fromBytes(fileParametrName, bytes, filename: fileName));

    final response = await request.send();

    final res = await http.Response.fromStream(response);

    _logger.send(AppLogEvent(type: AppLogType.api, value: '''
METHOD: MULTIPART
URL: ${hostUrl ?? config.apiUrl}$url
STATUS CODE: ${res.statusCode}
RESPONSE: ${res.body}
'''));

    final resultStr = utf8.decode(res.bodyBytes);
    if (res.statusCode < 200 || res.statusCode > 204) {
      throw ApiError(message: resultStr, statusCode: res.statusCode);
    }
    return resultStr;
  }

  Future<String?> _putRequest({
    required String url,
    String? hostUrl,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final res = await http.put(
      Uri.parse('${hostUrl ?? config.apiUrl}$url'),
      headers: headers,
      body: jsonEncode(body),
    );
    _logger.send(AppLogEvent(type: AppLogType.api, value: '''
METHOD: PUT
URL: ${hostUrl ?? config.apiUrl}$url
STATUS CODE: ${res.statusCode}
BODY: $body
RESPONSE: ${res.body}
'''));

    final resultStr = utf8.decode(res.bodyBytes);
    if (res.statusCode < 200 || res.statusCode > 204) {
      throw ApiError(message: resultStr, statusCode: res.statusCode);
    }
    return resultStr;
  }
}
