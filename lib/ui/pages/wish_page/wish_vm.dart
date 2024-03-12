import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/domain/models/wish.dart';
import 'package:wishes_app/helpers/error_helper.dart';
import 'package:wishes_app/helpers/string_helper.dart';
import 'package:wishes_app/repository/api/api_repository.dart';

enum WishPageState {
  edit,
  view,
  create,
}

class AppImage {
  final Uint8List bytes;
  final String fileName;
  final double size;

  const AppImage({
    required this.bytes,
    required this.size,
    required this.fileName,
  });
}

class WishVM extends ChangeNotifier {
  final MainBloc mainBloc;
  final VoidCallback? onUpdate;
  final String? initImageLink;
  final _imagePicker = ImagePicker();

  // FROM CONSTRUCTOR INIT
  String? _wishId;
  String? get wishId => _wishId;

  WishVM({
    required this.mainBloc,
    required this.onUpdate,
    required String? wishId,
    this.initImageLink,
  }) : _wishId = wishId {
    _init();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool get isMyWish => item.user.id == mainBloc.state.authState.user.id;

  Wish _item = Wish.empty();
  Wish get item => _item;

  WishPageState _state = WishPageState.view;
  WishPageState get state => _state;
  set state(WishPageState val) {
    clearEditFields();
    if (_state != val) {
      _state = val;
      notifyListeners();
    }
  }

  String? get imageUrl {
    if (item.imageLink != null) {
      return '${mainBloc.state.config.apiPhotoStorageUrl}${item.imageLink}';
    }
    return null;
  }

  bool get isEditOrCreateBTNActive {
    return titleTextValidate && descTextValidate && priceTextValidate && linkTextValidate;
  }

  void clearEditFields() {
    _titleError = null;
    _descError = null;
    _priceError = null;
    _linkError = null;
    titleTextController.text = '';
    descTextController.text = '';
    priceTextController.text = '';
    linkTextController.text = '';
    _image = null;
    _deletePreviousImageInEdit = false;
    notifyListeners();
  }

  AppImage? _image;
  AppImage? get image => _image;

  bool _deletePreviousImageInEdit = false;
  bool get deletePreviousImageInEdit => _deletePreviousImageInEdit;

  String? _titleError;
  String? get titleError => _titleError;
  String? _descError;
  String? get descError => _descError;
  String? _priceError;
  String? get priceError => _priceError;
  String? _linkError;
  String? get linkError => _linkError;

  bool get titleTextValidate => titleTextController.text.isNotEmpty;
  bool get descTextValidate => true;
  bool get priceTextValidate => priceTextController.text.isEmpty ? true : int.tryParse(priceTextController.text) != null;
  bool get linkTextValidate {
    if (linkTextController.text.isEmpty) {
      return true;
    }
    final urls = StringHelper.getLink(linkTextController.text);
    return urls.isNotEmpty;
  }

  final titleTextController = TextEditingController();
  final descTextController = TextEditingController();
  final priceTextController = TextEditingController();
  final linkTextController = TextEditingController();

  final titleFocus = FocusNode();
  final descFocus = FocusNode();
  final priceFocus = FocusNode();
  final linkFocus = FocusNode();

  void _titleControllerListener() {
    final errorValue = !titleTextValidate ? 'заполните поле' : null;

    if (_titleError != errorValue) {
      _titleError = errorValue;
      notifyListeners();
    }
  }

  void _descControllerListener() {}

  void _priceControllerListener() {
    final errorValue = !priceTextValidate ? 'неверное значение' : null;

    if (_priceError != errorValue) {
      _priceError = errorValue;
      notifyListeners();
    }
  }

  void _linkControllerListener() {
    final errorValue = !linkTextValidate ? 'неверное значение' : null;

    if (_linkError != errorValue) {
      _linkError = errorValue;
      notifyListeners();
    }
  }

  String? extractLinkFromLinkControllerText() {
    if (!linkTextValidate) return null;
    final urls = StringHelper.getLink(linkTextController.text);
    if (urls.isEmpty) return null;
    linkTextController.text = urls.first;
    return urls.first;
  }

  Future<void> _init() async {
    titleTextController.addListener(_titleControllerListener);
    descTextController.addListener(_descControllerListener);
    priceTextController.addListener(_priceControllerListener);
    linkTextController.addListener(_linkControllerListener);
    await update();
  }

  Future<void> update() async {
    _isLoading = true;
    notifyListeners();
    await _getItems();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _getItems() async {
    await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        if (wishId != null) {
          final wish = await mainBloc.state.repo.getWishById(wishId: wishId!);
          if (wish == null) {
            _state = WishPageState.create;
            throw LogicalError(message: 'Wish with id: $wishId not found');
          } else {
            _state = WishPageState.view;
          }
          _item = wish;
        } else {
          _state = WishPageState.create;
        }
        clearEditFields();
      },
    );
  }

  Future<void> deleteImage() async {
    await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        if (image != null) {
          _image = null;
        } else if (state != WishPageState.create) {
          _deletePreviousImageInEdit = true;
        }
        notifyListeners();
      },
    );
  }

  Future<void> getImage() async {
    await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        final file = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 50,
          maxWidth: 2000,
          maxHeight: 2000,
        );
        if (file != null) {
          final bytes = await file.readAsBytes();
          final name = file.name;
          final size = (await file.length()) / 1024;
          _image = AppImage(bytes: bytes, fileName: name, size: size);
          notifyListeners();
        }
      },
    );
  }

  Future<void> create() async {
    if (!isEditOrCreateBTNActive) return;
    _isLoading = true;
    notifyListeners();
    await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        final title = titleTextController.text;
        final price = int.tryParse(priceTextController.text);
        final description = descTextController.text;
        final link = Uri.tryParse(linkTextController.text) != null
            ? Uri.parse(linkTextController.text).scheme == 'https'
                ? linkTextController.text
                : null
            : null;

        final newWish = await mainBloc.state.repo.addWish(
          item: Wish(
            id: '',
            name: title,
            link: link,
            price: price,
            description: description,
            isArchived: false,
            user: mainBloc.state.authState.user,
          ),
        );

        _wishId = newWish.id;
        if (image != null) {
          await mainBloc.state.repo.addWishImage(
            wishId: newWish.id,
            fileName: image!.fileName,
            byets: image!.bytes.toList(),
          );
        }
        onUpdate?.call();
        await update();
      },
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<void> edit() async {
    if (!isEditOrCreateBTNActive) return;
    _isLoading = true;
    notifyListeners();
    await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        final title = titleTextController.text;
        final price = int.tryParse(priceTextController.text);
        final description = descTextController.text;
        final link = Uri.tryParse(linkTextController.text) != null
            ? Uri.parse(linkTextController.text).scheme == 'https'
                ? linkTextController.text
                : null
            : null;

        await mainBloc.state.repo.editWish(
          item: Wish(
            id: item.id,
            name: title,
            link: link,
            price: price,
            description: description,
            isArchived: item.isArchived,
            user: mainBloc.state.authState.user,
          ),
        );
        if (_deletePreviousImageInEdit) {
          await mainBloc.state.repo.deleteWishImage(wishId: item.id);
        }
        if (image != null) {
          await mainBloc.state.repo.addWishImage(
            wishId: item.id,
            fileName: image!.fileName,
            byets: image!.bytes.toList(),
          );
        }
        onUpdate?.call();
        await update();
      },
    );
    _isLoading = false;
    notifyListeners();
  }

  void startEdit() async {
    state = WishPageState.edit;
    titleTextController.text = item.name;
    descTextController.text = item.description ?? '';
    priceTextController.text = item.price != null ? item.price.toString() : '';
    linkTextController.text = item.link ?? '';
    notifyListeners();
  }

  Future<bool> delete() async {
    return await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        if (wishId != null) {
          await mainBloc.state.repo.deleteWish(wishId: wishId!);
          onUpdate?.call();
        }
      },
    );
  }

  Future<void> getPreview(String link) async {
    _isLoading = true;
    notifyListeners();

    // ПЫТАЕМСЯ ВЗЯТЬ ДАННЫЕ ПРИ ПОМОЩИ АПИ
    await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        final metadata = await mainBloc.state.repo.getPreview(link);

        if (metadata.imageUrl != null) {
          final bytes = await mainBloc.state.repo.getImageFromPreviewLink(link: metadata.imageUrl!);
          final size = bytes.length / 1024;
          _image = AppImage(bytes: bytes, fileName: '', size: size);
        }
        titleTextController.text = metadata.title ?? titleTextController.text;
        descTextController.text = metadata.description ?? descTextController.text;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> reserve() async {
    await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        await mainBloc.state.repo.reserveWish(wishId: item.id);
        onUpdate?.call();
        await update();
      },
    );
  }

  Future<void> unReserve() async {
    await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        await mainBloc.state.repo.unReserveWish(wishId: item.id);
        onUpdate?.call();
        await update();
      },
    );
  }

  Future<void> archive() async {
    await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        await mainBloc.state.repo.archiveWish(wishId: item.id);
        onUpdate?.call();
        await update();
      },
    );
  }

  Future<void> unArchive() async {
    await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        await mainBloc.state.repo.unArchiveWish(wishId: item.id);
        onUpdate?.call();
        await update();
      },
    );
  }

  bool _disposed = false;
  @override
  void dispose() {
    _disposed = true;
    titleTextController.removeListener(_titleControllerListener);
    descTextController.removeListener(_descControllerListener);
    priceTextController.removeListener(_priceControllerListener);
    linkTextController.removeListener(_linkControllerListener);

    titleTextController.dispose();
    descTextController.dispose();
    priceTextController.dispose();
    linkTextController.dispose();

    titleFocus.dispose();
    descFocus.dispose();
    priceFocus.dispose();
    linkFocus.dispose();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
