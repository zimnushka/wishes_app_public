import 'package:bloc/bloc.dart';
import 'package:wishes_app/bloc/events/update_config_event.dart';
import 'package:wishes_app/bloc/main_bloc.dart';

Future<void> updateConfigHandler(UpdateConfigEvent event, Emitter emit, MainBloc mainBloc) async {
  emit(mainBloc.state.copyWith(config: event.config));
}
