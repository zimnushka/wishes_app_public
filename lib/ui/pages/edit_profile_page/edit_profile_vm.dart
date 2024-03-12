import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wishes_app/bloc/events/update_user_event.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/domain/models/user.dart';
import 'package:wishes_app/helpers/error_helper.dart';
import 'package:wishes_app/repository/api/api_repository.dart';

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

class EditProfileVM extends ChangeNotifier {
  final MainBloc mainBloc;

  EditProfileVM({required this.mainBloc}) {
    _init();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User _user = User.empty();
  User get user => _user;

  final nameContreller = TextEditingController();
  final nameFocus = FocusNode();
  String? _nameError;
  String? get nameError => _nameError;

  Gender _gender = Gender.male;
  Gender get gender => _gender;
  set gender(Gender val) {
    if (gender != val) {
      _gender = val;
      notifyListeners();
    }
  }

  DateTime? _birthDate;
  DateTime? get birthDate => _birthDate;
  set birthDate(DateTime? val) {
    if (birthDate != val) {
      _birthDate = val;
      notifyListeners();
    }
  }

  AppImage? _image;
  AppImage? get image => _image;

  bool _needDeleteImage = false;
  bool get needDeleteImage => _needDeleteImage;

  bool get isButtonActive => hasChanges && nameError == null;

  bool get hasChanges {
    final userBirthDate = DateTime.tryParse(user.birthDate ?? '');
    return gender != user.gender || nameContreller.text != user.displayName || userBirthDate != birthDate || _needDeleteImage || _image != null;
  }

  void _nameListener() {
    final text = nameContreller.text;
    if (text.isEmpty) {
      _nameError = 'Поле не может быть пустым';
    } else {
      _nameError = null;
    }
    notifyListeners();
  }

  Future<void> _init() async {
    nameContreller.addListener(_nameListener);
    onUserUpdate(mainBloc.state.authState.user);
  }

  void onUserUpdate(User value) {
    _user = value;
    _gender = user.gender;
    _birthDate = DateTime.tryParse(user.birthDate ?? '');
    nameContreller.text = user.displayName;
    notifyListeners();
  }

  Future<void> save() async {
    _isLoading = true;
    notifyListeners();
    await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        await mainBloc.state.repo.updateUserMe(
          name: nameContreller.text,
          gender: gender,
          birthDate: birthDate,
        );
        if (needDeleteImage) {
          await mainBloc.state.repo.deleteProfileImage();
        }
        if (image != null) {
          await mainBloc.state.repo.setProfileImage(fileName: image!.fileName, byets: image!.bytes);
        }

        mainBloc.add(UpdateUserEvent());
        _needDeleteImage = false;
        _image = null;
      },
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updatePhoto(BuildContext context) async {
    await ErrorHelper.catchError(
      mainBloc: mainBloc,
      func: () async {
        final file = await ImagePicker().pickImage(
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
          _needDeleteImage = false;
          notifyListeners();
        }
      },
    );
  }

  Future<void> deletePhoto(BuildContext context) async {
    if (!needDeleteImage) {
      _needDeleteImage = true;
      notifyListeners();
    }
  }

  bool _disposed = false;
  @override
  void dispose() {
    _disposed = true;
    nameContreller.removeListener(_nameListener);
    nameContreller.dispose();
    nameFocus.dispose();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
