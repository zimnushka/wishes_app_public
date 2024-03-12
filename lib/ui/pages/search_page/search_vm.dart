import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/domain/models/user.dart';
import 'package:wishes_app/helpers/error_helper.dart';
import 'package:wishes_app/repository/api/api_repository.dart';

class SearchVM extends ChangeNotifier {
  final MainBloc mainBloc;

  SearchVM({required this.mainBloc}) {
    _init();
  }

  final searchController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<User> _users = [];
  List<User> get users => _users;

  bool _isSearchTextEmpty = true;
  bool get isSearchTextEmpty => _isSearchTextEmpty;

  Timer _timerSearchRequest = Timer(const Duration(), () {});

  void searchControllerListener() {
    bool isShow = false;
    if (searchController.text.isEmpty) {
      isShow = true;
    } else {
      isShow = false;
    }
    if (_isSearchTextEmpty != isShow) {
      _isSearchTextEmpty = isShow;
      notifyListeners();
    }
    _timerSearchRequest.cancel();
    _timerSearchRequest = Timer(const Duration(milliseconds: 500), getItems);
  }

  Future<void> _init() async {
    searchController.addListener(searchControllerListener);

    await getItems();
  }

  Future<void> getItems() async {
    _isLoading = true;
    notifyListeners();
    await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        if (searchController.text.isEmpty) {
          _users = await mainBloc.state.repo.getPossibleFriends();
        } else {
          _users = await mainBloc.state.repo.searchUser(q: searchController.text);
        }
      },
    );
    _isLoading = false;
    notifyListeners();
  }

  bool _disposed = false;
  @override
  void dispose() {
    _disposed = true;

    searchController.removeListener(searchControllerListener);
    searchController.dispose();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
