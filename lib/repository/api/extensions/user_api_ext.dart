part of '../api_repository.dart';

extension UserApiExt on ApiRepository {
  Future<User> getUserMe() async {
    final json = await _getRequest(
      url: '/users/me/',
      headers: Map.fromEntries([
        headerAuthToken,
        headerAcceptAll,
        headerCORS,
      ]),
    );
    if (json == null) throw const LogicalError(message: 'user is empty');
    final user = User.fromJson(jsonDecode(json));
    return user;
  }

  Future<User> getUserById({required String userId}) async {
    final json = await _getRequest(
      url: '/users/$userId',
      headers: Map.fromEntries([
        headerAuthToken,
        headerAcceptAll,
        headerCORS,
      ]),
    );
    if (json == null) throw const LogicalError(message: 'user is empty');
    final user = User.fromJson(jsonDecode(json));
    return user;
  }

  Future<List<User>> searchUser({required String q}) async {
    final json = await _getRequest(
      url: '/users/search/?q=$q',
      headers: Map.fromEntries([
        headerAcceptAll,
        headerAuthToken,
        headerCORS,
      ]),
    );
    if (json == null || json.isEmpty) {
      return [];
    }
    final data = jsonDecode(json);
    final list = data as List<dynamic>;
    return list.map((e) => User.fromJson(e)).toList();
  }

  Future<List<User>> getPossibleFriends() async {
    final json = await _getRequest(
      url: '/possible_friends',
      headers: Map.fromEntries([
        headerAcceptAll,
        headerAuthToken,
        headerCORS,
      ]),
    );
    if (json == null || json.isEmpty) {
      return [];
    }
    final data = jsonDecode(json);
    final list = data as List<dynamic>;
    return list.map((e) => User.fromJson(e)).toList();
  }

  Future<void> setProfileImage({
    required String fileName,
    required List<int> byets,
  }) async {
    await _multipartRequest(
      fileName: fileName,
      bytes: byets,
      fileParametrName: 'image',
      url: '/set_profile_image',
      headers: Map.fromEntries([
        headerAcceptAll,
        headerAuthToken,
        headerCORS,
      ]),
    );
  }

  Future<void> deleteProfileImage() async {
    await _postRequest(
      url: '/delete_profile_image',
      headers: Map.fromEntries([
        headerAcceptAll,
        headerAuthToken,
        headerCORS,
      ]),
    );
  }

  Future<void> deleteAccount() async {
    await _postRequest(
      url: '/delete_own_account',
      headers: Map.fromEntries([
        headerContentJson,
        headerAcceptAll,
        headerAuthToken,
        headerCORS,
      ]),
    );
  }

  Future<void> updateUserMe({
    required String name,
    required Gender gender,
    required DateTime? birthDate,
  }) async {
    await _putRequest(
      url: '/users/me',
      headers: Map.fromEntries([
        headerAuthToken,
        headerAcceptAll,
        headerContentJson,
        headerCORS,
      ]),
      body: {
        'display_name': name,
        'gender': gender.toJson(),
        'birth_date': birthDate != null ? DateFormat('yyyy-MM-dd').format(birthDate) : null,
      },
    );
  }
}
