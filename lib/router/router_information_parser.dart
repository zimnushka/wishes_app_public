import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishes_app/bloc/events/login_from_router_event.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/domain/configs/app_config.dart';
import 'package:wishes_app/router/routes.dart';

class AppRouterInformationParser implements RouteInformationParser<AppRoute> {
  AppRouterInformationParser({required this.config});
  final AppConfig config;

  @override
  Future<AppRoute> parseRouteInformation(RouteInformation routeInformation) async {
    return AppRoute.fromUri(routeInformation.uri);
  }

  @override
  Future<AppRoute> parseRouteInformationWithDependencies(RouteInformation routeInformation, BuildContext context) async {
    if (routeInformation.uri.queryParameters.containsKey('payload')) {
      final mainBloc = context.read<MainBloc>();
      mainBloc.add(LoginFromRouterEvent(uri: routeInformation.uri.toString()));
    }
    return AppRoute.fromUri(routeInformation.uri);
  }

  @override
  RouteInformation? restoreRouteInformation(configuration) {
    return RouteInformation(
      uri: configuration.toUri(config: config),
    );
  }
}
