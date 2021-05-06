import 'dart:convert';
import 'dart:io';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_downloader/flutter_downloader.dart';

enum SubTypes {
  Movie,
  TvShow,
}

class IMDBProvider with ChangeNotifier {
  String _id;
  String _error = '';
  String _language = 'ar';
  String _zipDownloadLink;
  String _subtitlesLink;
  List _responseBody;
  bool _hasSub = false;
  bool _isMovie = true;
  SubTypes _searchType = SubTypes.Movie;

  SubTypes get searchType {
    return _searchType;
  }

  bool get hasSub {
    return _hasSub;
  }

  String get zipDownloadLink {
    return _zipDownloadLink;
  }

  String get subtitlesLink {
    return _subtitlesLink;
  }

  String get error {
    return _error;
  }

  List get response {
    return _responseBody;
  }

  String get language {
    return _language;
  }

  bool get isMovie {
    return _isMovie;
  }

  void selectLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  void toggleSearchType() {
    _isMovie = !_isMovie;
    _searchType == SubTypes.TvShow
        ? _searchType = SubTypes.Movie
        : _searchType = SubTypes.TvShow;
    notifyListeners();
  }

  Future<void> getId(String movieName) async {
    const apiKey = '1c9d8247';
    final url = 'http://www.omdbapi.com/?t=$movieName&apikey=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      _id = extractedData['imdbID'];
      print('id=${_id.toString()}');
    } catch (e) {
      print('error $e');
      _error = e.toString();
    }
  }

  Future<void> getMovieSub(id) async {
    try {
      HttpClient client = new HttpClient();
      client.userAgent = 'obadasub';

      HttpClientRequest request = await client.getUrl(Uri.parse(
          'http://rest.opensubtitles.org/search/imdbid-$id/sublanguageid-$_language'));
      HttpClientResponse response = await request.close();
      var result = new StringBuffer();
      await for (var contents in response.transform(Utf8Decoder())) {
        result.write(contents);
      }
      _responseBody = json.decode(result.toString());
      print('get movie sub $_responseBody');
      print(_responseBody[0]['ZipDownloadLink']);
      _zipDownloadLink = _responseBody[0]['ZipDownloadLink'];
      _subtitlesLink = _responseBody[0]['SubtitlesLink'];
      _hasSub = true;
    } catch (e) {
      _error = e.toString();
      print(_error);
    }
  }

  Future<void> getData(String name, String season, String episode) async {
    try {
      if (!isMovie && (episode == null || season == null) || name == null) {
        print('erro if statement');
        return;
      }
      print('getting data');
      await getId(name);
      print('finish getting data');
      _isMovie
          ? await getMovieSub(_id)
          : await getTvShowSub(_id, season, episode);
      notifyListeners();
    } catch (e) {
      print('error getting data!');
      _error = e.toString();
    }
  }

  Future<void> getTvShowSub(
      String showName, String season, String episode) async {
    print("getTvSub");
    try {
      HttpClient client = new HttpClient();
      client.userAgent = 'obadasub';

      HttpClientRequest request = await client.getUrl(Uri.parse(
          "https://rest.opensubtitles.org/search/episode-$episode/imdbid-$_id/season-$season/sublanguageid-$_language"));
      HttpClientResponse response = await request.close();

      var result = StringBuffer();
      await for (var contents in response.transform(Utf8Decoder())) {
        result.write(contents);
      }
      _responseBody = jsonDecode(result.toString());
      print(_responseBody);
      _zipDownloadLink = _responseBody[0]['ZipDownloadLink'];
      _subtitlesLink = _responseBody[0]['SubtitlesLink'];
      _hasSub = true;
    } catch (e) {
      print(e.toString());
      _error = e.toString();
    }
  }

  Future<void> downloadSub() async {
    try {
      String path = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);
      print('path = $path');
      final taskId = await FlutterDownloader.enqueue(
        url: _subtitlesLink,
        savedDir: path,
        showNotification: true,
        openFileFromNotification: true,
      );
      print(taskId);
    } catch (e) {
      print(e.toString());
      _error = e.toString();
    }
  }

  Future<void> downloadSubZip() async {
    try {
      String path = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);
      print('path = $path');
      final taskId = await FlutterDownloader.enqueue(
        url: _subtitlesLink,
        savedDir: path,
        showNotification: true,
        openFileFromNotification: true,
      );
      print(taskId);
    } catch (e) {
      print(e.toString());
      _error = e.toString();
    }
  }
}
