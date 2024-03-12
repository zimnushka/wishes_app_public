import 'package:flutter/material.dart';
import 'package:wishes_app/bloc/events/update_user_event.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/domain/models/user.dart';
import 'package:wishes_app/domain/models/wish.dart';
import 'package:wishes_app/helpers/error_helper.dart';
import 'package:wishes_app/repository/api/api_repository.dart';

class UserVM extends ChangeNotifier {
  final MainBloc mainBloc;
  final String? userId;

  UserVM({
    required this.mainBloc,
    required this.userId,
  }) {
    _init();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Wish> _items = [];
  List<Wish> get items => _items;

  User _user = User.empty();
  User get user => _user;

  bool get isMyProfile => user.id == mainBloc.state.authState.user.id;

  bool get isInSubscribed => user.followedBy.where((followers) => followers.id == mainBloc.state.authState.user.id).isNotEmpty;

  String formatImageUrl(String url) {
    return '${mainBloc.state.config.apiPhotoStorageUrl}$url';
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    await _getItems();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> update() async {
    _isLoading = true;
    notifyListeners();
    await _getItems();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUserMeProfile(User value) async {
    if (isMyProfile && value != user) {
      _user = value;
      notifyListeners();
    }
  }

  Future<void> _getItems() async {
    await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        if (userId != null) {
          _user = await mainBloc.state.repo.getUserById(userId: userId!);
          _items = await mainBloc.state.repo.getUserWishes(userId!);
        } else {
          _user = mainBloc.state.authState.user;
          _items = await mainBloc.state.repo.getMyWishes();
        }
      },
    );
  }

  Future<void> subscribe() async {
    await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        if (userId != null) {
          await mainBloc.state.repo.follow(userId: userId!.toString());
          _user = await mainBloc.state.repo.getUserById(userId: userId!);
          mainBloc.add(UpdateUserEvent());
          notifyListeners();
        }
      },
    );
  }

  Future<void> unSubscribe() async {
    await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        if (userId != null) {
          await mainBloc.state.repo.unFollow(userId: userId!.toString());
          _user = await mainBloc.state.repo.getUserById(userId: userId!);
          mainBloc.add(UpdateUserEvent());
          notifyListeners();
        }
      },
    );
  }

  bool _disposed = false;
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
