import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wishes_app/domain/toast/toast_state.dart';
import 'package:wishes_app/router/routes.dart';
import 'package:wishes_app/router/routes/home.dart';
import 'package:wishes_app/ui/pages/landing_page/landing_page.dart';
import 'package:wishes_app/ui/widgets/toast_widget.dart';

class AppRouterDelegate extends RouterDelegate<AppRoute> with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  List<AppRoute> pages = [];

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  AppRoute? get currentConfiguration => pages.isNotEmpty ? pages.last : null;

  void back() {
    if (canPop) {
      pages.removeLast();
      notifyListeners();
    }
  }

  void clear() {
    pages.clear();
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    if (pages.isNotEmpty && pages.last.runtimeType == configuration.runtimeType) return;
    pages.add(configuration);
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    if (pages.isEmpty) {
      pages.add(HomePageRoute());
    }
    return Navigator(
      key: navigatorKey,
      onPopPage: (route, result) {
        try {
          final didPop = route.didPop(result);
          if (!didPop) {
            return false;
          }
        } catch (e) {
          return false;
        }
        //return true;
        if (canPop) {
          back();
          return true;
        } else {
          return false;
        }
      },
      pages: pages.map((e) {
        return AppRouteBuilder(e.page);
      }).toList(),
    );
  }

  bool get canPop => pages.length > 1;

  void showOverlayMessage({
    required String text,
    required ToastType toastType,
    VoidCallback? onTap,
    Duration duration = const Duration(seconds: 4),
  }) {
    final overlayState = navigatorKey.currentState?.overlay;
    if (overlayState == null) return;
    OverlayEntry? overlayScreen;
    overlayScreen = OverlayEntry(
      builder: (context) {
        return OverlayToast(
          text: text,
          type: toastType,
          duration: duration,
          onDismiss: () {
            try {
              overlayScreen?.remove();
            } catch (e) {
              if (kDebugMode) {
                print(e);
              }
            }
          },
          onTap: onTap,
        );
      },
    );

    overlayState.insert(overlayScreen);
  }
}

class AppRouteBuilder extends Page<Widget> {
  const AppRouteBuilder(this.instance);
  final Widget instance;

  @override
  Route<Widget> createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animationTo, animationFrom) {
        return AppLanding(
          child: FadeTransition(
            opacity: animationTo,
            child: instance,
          ),
        );
      },
    );
  }
}
