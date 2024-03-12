import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishes_app/bloc/events/change_theme_event.dart';
import 'package:wishes_app/bloc/events/login_event.dart';
import 'package:wishes_app/bloc/events/login_from_router_event.dart';
import 'package:wishes_app/bloc/events/logout_event.dart';
import 'package:wishes_app/bloc/events/start_event.dart';
import 'package:wishes_app/bloc/events/update_config_event.dart';
import 'package:wishes_app/bloc/events/update_user_event.dart';
import 'package:wishes_app/bloc/handlers/change_theme_handler.dart';
import 'package:wishes_app/bloc/handlers/login_from_router_handler.dart';
import 'package:wishes_app/bloc/handlers/login_handler.dart';
import 'package:wishes_app/bloc/handlers/logout_handler.dart';
import 'package:wishes_app/bloc/handlers/start_handler.dart';
import 'package:wishes_app/bloc/handlers/update_config_handler.dart';
import 'package:wishes_app/bloc/handlers/update_user_handler.dart';
import 'package:wishes_app/bloc/main_event.dart';
import 'package:wishes_app/bloc/main_state.dart';
import 'package:wishes_app/repository/local/local_reposutory.dart';
import 'package:wishes_app/router/app_router.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final AppRouter router;
  final LocalRepository localRepo;

  MainBloc(
    super.initialState, {
    required this.router,
    required this.localRepo,
  }) {
    on<MainEvent>(
      (event, emit) async {
        if (handlersMap.containsKey(event.runtimeType)) {
          await handlersMap[event.runtimeType]!(event, emit, this);
        }
      },
      transformer: sequential(),
    );
  }
}

const Map<Type, Function> handlersMap = {
  StartEvent: startHandler,
  LoginEvent: loginHandler,
  LogoutEvent: logoutHandler,
  UpdateUserEvent: updateUserHandler,
  ChangeThemeEvent: changeThemeHandler,
  UpdateConfigEvent: updateConfigHandler,
  LoginFromRouterEvent: loginFromRouterHandler,
};
