import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:wishes_app/bloc/events/login_event.dart';
import 'package:wishes_app/bloc/events/logout_event.dart';
import 'package:wishes_app/bloc/events/start_event.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/domain/firebase/push_notification.dart';
import 'package:wishes_app/firebase_options.secure.dart';
import 'package:wishes_app/repository/local/local_reposutory.dart';

Future<void> startHandler(StartEvent event, Emitter emit, MainBloc mainBloc) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebasePush.init(mainBloc);
  FirebaseAnalytics.instance.logAppOpen();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  final apiToken = await mainBloc.localRepo.readApiToken();
  final pushToken = await FirebasePush.getToken();

  if (apiToken != null) {
    mainBloc.add(LoginEvent(token: apiToken, pushToken: pushToken));
  } else {
    mainBloc.add(LogoutEvent());
  }
}
