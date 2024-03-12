import 'package:flutter/material.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/ui/pages/profile_page/profile_page.dart';
import 'package:wishes_app/ui/pages/reserved_wishes/reserved_wishes.dart';
import 'package:wishes_app/ui/pages/search_page/search_page.dart';
import 'package:wishes_app/ui/pages/user_page/user_page.dart';
import 'package:wishes_app/ui/widgets/menu/menu.dart';

class HomeVM extends ChangeNotifier {
  final MainBloc mainBloc;

  HomeVM({required this.mainBloc});

  final pageController = PageController();

  final Map<MenuItem, Widget> pages = {
    const MenuItem(icon: Icon(Icons.home_outlined), label: 'главная'): const UserPage(showBackBTN: false),
    const MenuItem(icon: Icon(Icons.lock_outline), label: 'резерв'): const ReservedWishes(),
    const MenuItem(icon: Icon(Icons.search), label: 'поиск'): const SearchPage(),
    const MenuItem(icon: Icon(Icons.settings_outlined), label: 'настройки'): const ProfilePage(),
  };

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;
  set pageIndex(int val) {
    if (_pageIndex != val) {
      _pageIndex = val;
      notifyListeners();
    }
  }

  bool _disposed = false;
  @override
  void dispose() {
    _disposed = true;
    pageController.dispose();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
