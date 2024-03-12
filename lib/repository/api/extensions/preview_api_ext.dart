part of '../api_repository.dart';

extension PreviewApiExt on ApiRepository {
  Future<PreviewMetaData> getPreview(String link) async {
    final htmlResponseData = await _getHtmlFromLink(link);

    final json = await _postRequest(
      url: '/item_info_from_page',
      body: {
        "link": link,
        "html": htmlResponseData,
      },
      headers: Map.fromEntries([
        headerCORS,
        headerAcceptAll,
        headerContentJson,
        headerAuthToken,
      ]),
    );

    if (json == null) throw const LogicalError(message: 'не удалось получить данные');
    final data = PreviewMetaData.fromJson(jsonDecode(json));
    return data;
  }

  Future<String?> _getHtmlFromLink(String link) async {
    try {
      final res = await http.get(Uri.parse(link));
      return utf8.decode(res.bodyBytes);
    } catch (e) {
      return null;
    }
  }
}
