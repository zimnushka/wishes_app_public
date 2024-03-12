import 'package:bloc/bloc.dart';
import 'package:wishes_app/bloc/events/update_user_event.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/helpers/error_helper.dart';
import 'package:wishes_app/repository/api/api_repository.dart';

Future<void> updateUserHandler(UpdateUserEvent event, Emitter emit, MainBloc mainBloc) async {
  await ErrorHelper.catchError(
    mainBloc: mainBloc,
    func: () async {
      final user = await mainBloc.state.repo.getUserMe();
      emit(
        mainBloc.state.copyWith(
          authState: mainBloc.state.authState.copyWith(
            user: user,
          ),
        ),
      );
    },
  );
}
