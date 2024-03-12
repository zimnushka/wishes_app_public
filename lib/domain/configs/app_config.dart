// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:wishes_app/domain/logs/logger_service.dart';

class AppConfig extends Equatable {
  const AppConfig({
    required this.apiUrl,
    required this.apiPhotoStorageUrl,
    required this.appDomainUrl,
    required this.logsType,
    required this.isDebug,
  });
  final bool isDebug;
  final List<AppLogType> logsType;
  final String apiUrl;
  final String apiPhotoStorageUrl;
  final String appDomainUrl;

  factory AppConfig.test() => const AppConfig(
        apiUrl: 'https://hotelki.pro/api/v1',
        apiPhotoStorageUrl: 'https://hotelki.pro',
        appDomainUrl: 'https://hotelki.pro',
        isDebug: true,
        logsType: AppLogType.values,
      );

  factory AppConfig.prod() => const AppConfig(
        apiUrl: 'https://hotelki.pro/api/v1',
        apiPhotoStorageUrl: 'https://hotelki.pro',
        appDomainUrl: 'https://hotelki.pro',
        isDebug: false,
        logsType: AppLogType.values,
      );

  AppConfig copyWith({
    bool? isDebug,
    List<AppLogType>? logsType,
    String? apiUrl,
    String? apiPhotoStorageUrl,
    String? appDomainUrl,
    bool? usePreviewPub,
  }) {
    return AppConfig(
      isDebug: isDebug ?? this.isDebug,
      logsType: logsType ?? this.logsType,
      apiUrl: apiUrl ?? this.apiUrl,
      apiPhotoStorageUrl: apiPhotoStorageUrl ?? this.apiPhotoStorageUrl,
      appDomainUrl: appDomainUrl ?? this.appDomainUrl,
    );
  }

  @override
  List<Object?> get props => [
        isDebug,
        logsType,
        apiUrl,
        apiPhotoStorageUrl,
        appDomainUrl,
      ];
}
