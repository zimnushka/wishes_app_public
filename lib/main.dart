import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:wishes_app/bloc/events/start_event.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/bloc/main_state.dart';
import 'package:wishes_app/domain/auth/auth_state.dart';
import 'package:wishes_app/domain/configs/app_config.dart';
import 'package:wishes_app/domain/toast/toast_state.dart';
import 'package:wishes_app/repository/api/api_repository.dart';
import 'package:wishes_app/repository/local/local_reposutory.dart';
import 'package:wishes_app/router/app_router.dart';
import 'package:wishes_app/ui/styles/themes_book.dart';

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(HotelkiApp(AppConfig.prod()));
}

class HotelkiApp extends StatefulWidget {
  const HotelkiApp(this.config, {super.key});
  final AppConfig config;

  @override
  State<HotelkiApp> createState() => _HotelkiAppState();
}

class _HotelkiAppState extends State<HotelkiApp> {
  late final router = AppRouter(config: widget.config);

  @override
  Widget build(BuildContext context) {
    final theme = ThemesBook.dark;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: theme.scaffoldBackgroundColor,
        systemNavigationBarColor: theme.scaffoldBackgroundColor,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    final repo = ApiRepository(config: widget.config);
    const localRepo = LocalRepository();
    final mainBloc = MainBloc(
      MainState(
        isDarkTheme: true,
        authState: AuthState.empty(),
        config: widget.config,
        repo: repo,
        toastState: ToastState.empty(),
      ),
      router: router,
      localRepo: localRepo,
    )..add(StartEvent());
    return BlocProvider.value(
      value: mainBloc,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: widget.config.isDebug,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ru'),
        ],
        title: 'Hotelki',
        routeInformationParser: router.routerInformationParser,
        routerDelegate: router.routerDelegate,
        backButtonDispatcher: router.backBtnDispatcher,
        builder: (context, child) {
          final isDarkTheme = context.select((MainBloc vm) => vm.state.isDarkTheme);
          return Theme(
            data: isDarkTheme ? ThemesBook.dark : ThemesBook.light,
            child: child ?? const SizedBox(),
          );
        },
      ),
    );
  }
}
