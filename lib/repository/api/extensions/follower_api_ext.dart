part of '../api_repository.dart';

extension FollowerApiExt on ApiRepository {
  Future<void> follow({required String userId}) async {
    await _postRequest(
      url: '/follow/$userId',
      headers: Map.fromEntries([
        headerContentJson,
        headerAcceptAll,
        headerAuthToken,
        headerCORS,
      ]),
    );
  }

  Future<void> unFollow({required String userId}) async {
    await _postRequest(
      url: '/unfollow/$userId',
      headers: Map.fromEntries([
        headerContentJson,
        headerAcceptAll,
        headerAuthToken,
        headerCORS,
      ]),
    );
  }

  Future<List<User>> getSubscriptions({required String userId}) async {
    final json = await _getRequest(
      url: '/users/$userId/follows',
      headers: Map.fromEntries([
        headerContentJson,
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

  Future<List<User>> getSubscriber({required String userId}) async {
    final json = await _getRequest(
      url: '/users/$userId/followers',
      headers: Map.fromEntries([
        headerContentJson,
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
}
