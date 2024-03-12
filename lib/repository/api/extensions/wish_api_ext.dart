part of '../api_repository.dart';

extension WishApiExt on ApiRepository {
  Future<List<Wish>> getMyWishes() async {
    final json = await _getRequest(
      url: '/wishes',
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
    return list.map((e) => Wish.fromJson(e)).toList();
  }

  Future<List<Wish>> getReservedWishes() async {
    final json = await _getRequest(
      url: '/reserved_wishes',
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
    return list.map((e) => Wish.fromJson(e)).toList();
  }

  Future<List<Wish>> getArhcivedWishes() async {
    final json = await _getRequest(
      url: '/archived_wishes',
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
    return list.map((e) => Wish.fromJson(e)).toList();
  }

  Future<List<Wish>> getUserWishes(String userId) async {
    final json = await _getRequest(
      url: '/users/$userId/wishes',
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
    return list.map((e) => Wish.fromJson(e)).toList();
  }

  Future<Wish?> getWishById({
    required String wishId,
  }) async {
    final json = await _getRequest(
      url: '/wishes/$wishId',
      headers: Map.fromEntries([
        headerAcceptAll,
        headerContentJson,
        headerAuthToken,
        headerCORS,
      ]),
    );
    if (json == null || json.isEmpty) {
      return null;
    }
    final data = jsonDecode(json);
    return Wish.fromJson(data);
  }

  Future<Uint8List> getImageFromPreviewLink({required String link}) async {
    http.Response response = await http.get(Uri.parse(link));
    return response.bodyBytes;
  }

  Future<void> addWishImage({
    required String wishId,
    required String fileName,
    required List<int> byets,
  }) async {
    await _multipartRequest(
      fileName: fileName,
      bytes: byets,
      url: '/wishes/$wishId/image',
      headers: Map.fromEntries([
        headerAcceptAll,
        headerAuthToken,
        headerCORS,
      ]),
    );
  }

  Future<void> deleteWishImage({
    required String wishId,
  }) async {
    await _deleteRequest(
      url: '/wishes/$wishId/image',
      headers: Map.fromEntries([
        headerAcceptAll,
        headerAuthToken,
        headerCORS,
      ]),
    );
  }

  Future<Wish> addWish({required Wish item}) async {
    final json = await _postRequest(
      url: '/wishes',
      headers: Map.fromEntries([
        headerAcceptAll,
        headerContentJson,
        headerAuthToken,
        headerCORS,
      ]),
      body: item.toJson(),
    );

    final data = jsonDecode(json!);
    return Wish.fromJson(data);
  }

  Future<void> editWish({required Wish item}) async {
    await _putRequest(
      url: '/wishes/${item.id}',
      headers: Map.fromEntries([
        headerAcceptAll,
        headerContentJson,
        headerAuthToken,
        headerCORS,
      ]),
      body: item.toJson(),
    );
  }

  Future<void> deleteWish({
    required String wishId,
  }) async {
    await _deleteRequest(
      url: '/wishes/$wishId',
      headers: Map.fromEntries([
        headerAcceptAll,
        headerContentJson,
        headerCORS,
        headerAuthToken,
      ]),
    );
  }

  Future<void> reserveWish({required String wishId}) async {
    await _postRequest(
      url: '/wishes/$wishId/reserve',
      headers: Map.fromEntries([
        headerAcceptAll,
        headerContentJson,
        headerAuthToken,
        headerCORS,
      ]),
    );
  }

  Future<void> unReserveWish({required String wishId}) async {
    await _postRequest(
      url: '/wishes/$wishId/cancel_reservation',
      headers: Map.fromEntries([
        headerAcceptAll,
        headerContentJson,
        headerAuthToken,
        headerCORS,
      ]),
    );
  }

  Future<void> archiveWish({required String wishId}) async {
    await _postRequest(
      url: '/wishes/$wishId/archive',
      headers: Map.fromEntries([
        headerAcceptAll,
        headerContentJson,
        headerAuthToken,
        headerCORS,
      ]),
    );
  }

  Future<void> unArchiveWish({required String wishId}) async {
    await _postRequest(
      url: '/wishes/$wishId/unarchive',
      headers: Map.fromEntries([
        headerAcceptAll,
        headerContentJson,
        headerAuthToken,
        headerCORS,
      ]),
    );
  }
}
