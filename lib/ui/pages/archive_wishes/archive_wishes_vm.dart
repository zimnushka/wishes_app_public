import 'package:flutter/material.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/domain/models/wish.dart';
import 'package:wishes_app/helpers/error_helper.dart';
import 'package:wishes_app/repository/api/api_repository.dart';

class ArchivedWishesVM extends ChangeNotifier {
  final MainBloc mainBloc;

  ArchivedWishesVM({required this.mainBloc}) {
    _init();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Wish> _items = [];
  List<Wish> get items => _items;

  String formatImageUrl(String url) {
    return '${mainBloc.state.config.apiPhotoStorageUrl}$url';
  }

  Future<void> _init() async {
    await update();
  }

  Future<void> update() async {
    _isLoading = true;
    notifyListeners();
    await getItems();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getItems() async {
    await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        _items = await mainBloc.state.repo.getArhcivedWishes();
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
