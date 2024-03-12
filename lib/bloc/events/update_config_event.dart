import 'package:wishes_app/bloc/main_event.dart';
import 'package:wishes_app/domain/configs/app_config.dart';

class UpdateConfigEvent extends MainEvent {
  final AppConfig config;
  UpdateConfigEvent({required this.config});
}
