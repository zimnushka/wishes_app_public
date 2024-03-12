part of '../local_reposutory.dart';

extension ThemeLocalExt on LocalRepository {
  static const _themeLocalStorageKey = '_themeLocalStorageKey';

  Future<void> saveTheme({required bool isDarkTheme}) async {
    await _write(key: _themeLocalStorageKey, value: isDarkTheme.toString());
  }

  Future<bool?> readTheme() async {
    return bool.tryParse(await _read(_themeLocalStorageKey) ?? '');
  }

  Future<void> removeTheme() async {
    await _remove(_themeLocalStorageKey);
  }
}
