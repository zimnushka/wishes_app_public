import 'package:flutter/material.dart';
import 'package:wishes_app/bloc/events/update_user_event.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/domain/models/user.dart';
import 'package:wishes_app/helpers/error_helper.dart';
import 'package:wishes_app/repository/api/api_repository.dart';

class FollowersVM extends ChangeNotifier {
  final MainBloc mainBloc;
  final String userId;

  // followedBy => подписчики
  // follows => подписки
  final bool followedBy;

  FollowersVM({
    required this.followedBy,
    required this.mainBloc,
    required this.userId,
  }) {
    _init();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<User> _users = [];
  List<User> get users => _users;

  Future<void> _init() async {
    await getItems();
  }

  Future<void> getItems() async {
    _isLoading = true;
    notifyListeners();
    await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        if (followedBy) {
          _users = await mainBloc.state.repo.getSubscriber(userId: userId);
        } else {
          _users = await mainBloc.state.repo.getSubscriptions(userId: userId);
        }
      },
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<void> unSubscribe(String id) async {
    await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        await mainBloc.state.repo.unFollow(userId: id);
        await getItems();
        mainBloc.add(UpdateUserEvent());
        notifyListeners();
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
