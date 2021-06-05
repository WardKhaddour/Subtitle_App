import 'dart:convert';
import 'dart:io';

import 'package:task_3_subtitle_app/helpers/subtitle_info.dart';

class SubtitleService {
  Future<List<SubtitleInfo>> getMovieSub(String id, String language) async {
    try {
      HttpClient client = HttpClient();
      client.userAgent = 'obadasub';
      final url =
          'http://rest.opensubtitles.org/search/imdbid-$id/sublanguageid-$language';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();
      var result = StringBuffer();
      await for (var contents in response.transform(Utf8Decoder())) {
        result.write(contents);
      }
      final subtitleInfo = <SubtitleInfo>[];
      final responseBody = json.decode(result.toString());
      for (var obj in responseBody) {
        subtitleInfo.add(
          SubtitleInfo(
              name: obj['SubFileName'],
              downloadUrl: obj['SubDownloadLink'],
              size: obj['SubSize']),
        );
      }
      return subtitleInfo;
    } catch (e) {
      return null;
    }
  }

  Future<List<SubtitleInfo>> getTvShowSub(
      {String season, String episode, String id, String language}) async {
    try {
      HttpClient client = HttpClient();
      client.userAgent = 'obadasub';
      final String url =
          "https://rest.opensubtitles.org/search/episode-$episode/imdbid-$id/season-$season/sublanguageid-$language";
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();

      var result = StringBuffer();
      await for (var contents in response.transform(Utf8Decoder())) {
        result.write(contents);
      }
      final subtitleInfo = <SubtitleInfo>[];
      final responseBody = jsonDecode(result.toString());
      for (var obj in responseBody) {
        subtitleInfo.add(
          SubtitleInfo(
              name: obj['SubFileName'],
              downloadUrl: obj['SubDownloadLink'],
              size: obj['SubSize']),
        );
      }
      return subtitleInfo;
    } catch (e) {
      return null;
    }
  }
}
