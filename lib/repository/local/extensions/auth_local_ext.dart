part of '../local_reposutory.dart';

extension AuthLocalExt on LocalRepository {
  static const _authLocalStorageKeyUserId = '_authLocalStorageKeyUserId';
  static const _authLocalStorageKeyCustom = '_authLocalStorageKeyCustom';

  Future<void> saveApiToken({required String userId}) async {
    await _write(key: _authLocalStorageKeyUserId, value: userId);
  }

  Future<void> saveCustomToken({required String custom}) async {
    await _write(key: _authLocalStorageKeyCustom, value: custom);
  }

  Future<String?> readApiToken() async {
    return await _read(_authLocalStorageKeyUserId);
  }

  Future<String?> readCustomToken() async {
    return await _read(_authLocalStorageKeyCustom);
  }

  Future<void> removeApiToken() async {
    await _remove(_authLocalStorageKeyUserId);
  }

  Future<void> removeCustomToken() async {
    await _remove(_authLocalStorageKeyCustom);
  }
}
