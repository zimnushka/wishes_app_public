import 'package:bloc/bloc.dart';
import 'package:wishes_app/bloc/events/logout_event.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/domain/auth/auth_state.dart';
import 'package:wishes_app/domain/models/user.dart';

Future<void> logoutHandler(LogoutEvent event, Emitter emit, MainBloc mainBloc) async {
  await mainBloc.localRepo.clearAll();
  emit(
    mainBloc.state.copyWith(
      authState: AuthState(
        status: AuthStatus.unAuthorized,
        user: User.empty(),
      ),
    ),
  );
}
