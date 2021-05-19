import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SubTypes {
  Movie,
  TvShow,
}

class IMDBProvider with ChangeNotifier {
  String id;
  String error;
  String subDownloadLink;
  String subtitlesLink;
  String subFileName;
  String language = 'ara';
  bool hasSub = false;
  bool isMovie = true;
  bool isLoading = false;
  bool hasPath = false;
  SubTypes searchType = SubTypes.Movie;
  List<dynamic> responseBody;
  List<String> subFilesLinks = [];
  List<String> subFilesNames = [];
  String normalPath;
  String userPath;
  bool connectedToInternet = true;
  void checkConnection() {}
  void clear() {
    subFilesNames = [];
    subFilesLinks = [];
    id = null;
    error = null;
    responseBody = null;
    notifyListeners();
  }

  Future<void> setNormalPath() async {
    Directory dir = await DownloadsPathProvider.downloadsDirectory;
    // Directory finaldir = Directory('${dir.path}/' 'subs/');
    // if (await finaldir.exists() == false) {
    //   finaldir.create();
    // }
    normalPath = dir.path;
  }

  Future<void> setUserPath(String path) async {
    userPath = path;
    final pref = await SharedPreferences.getInstance();
    pref.setString('settings', userPath);
  }

  Future<void> tryGetiingPath() async {
    final pref = await SharedPreferences.getInstance();

    if (pref.containsKey('settings')) {
      hasPath = true;
      userPath = pref.getString('settings');
    } else {
      hasPath = false;
    }
  }

  void toggleLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void selectLanguage(String lang) {
    language = lang;
    notifyListeners();
  }

  void toggleSearchType() {
    isMovie = !isMovie;
    searchType == SubTypes.TvShow
        ? searchType = SubTypes.Movie
        : searchType = SubTypes.TvShow;
    notifyListeners();
  }

  Future<void> getId(String name) async {
    const apiKey = '1c9d8247';
    final url = 'http://www.omdbapi.com/?t=$name&apikey=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      id = extractedData['imdbID'];
      print('id=${id.toString()}');
    } catch (e) {
      print('error $e');
      error = e.toString();
    }
  }

  Future<void> getData(String name, String season, String episode) async {
    try {
      if (!isMovie && (episode == null || season == null) || name == null) {
        print('error if statement');
        return;
      }
      print('isLoading');
      toggleLoading();
      print('getting data');
      await getId(name);
      print('finish getting data');
      isMovie ? await getMovieSub(id) : await getTvShowSub(id, season, episode);
      toggleLoading();
      notifyListeners();
    } catch (e) {
      print('error getting data!');
      error = e.toString();
    }
  }

  Future<void> getMovieSub(id) async {
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
      responseBody = json.decode(result.toString());
      for (var obj in responseBody) {
        subFilesNames.add(obj['SubFileName']);
        subFilesLinks.add(obj['SubDownloadLink']);
      }
      print('get movie sub $responseBody');
      print('zip ${responseBody[0]['SubDownloadLink']}');
      print('str ${responseBody[0]['SubtitlesLink']}');
      subDownloadLink = responseBody[0]['SubDownloadLink'];
      subtitlesLink = responseBody[0]['SubtitlesLink'];
      subFileName = responseBody[0]['SubFileName'];
      hasSub = true;
    } catch (e) {
      error = e.toString();
      print('get movie sub $error');
    }
  }

  Future<void> getTvShowSub(
      String showName, String season, String episode) async {
    print("getTvSub");
    try {
      HttpClient client = new HttpClient();
      client.userAgent = 'obadasub';

      HttpClientRequest request = await client.getUrl(Uri.parse(
          "https://rest.opensubtitles.org/search/episode-$episode/imdbid-$id/season-$season/sublanguageid-$language"));
      HttpClientResponse response = await request.close();

      var result = StringBuffer();
      await for (var contents in response.transform(Utf8Decoder())) {
        result.write(contents);
      }
      responseBody = jsonDecode(result.toString());
      for (var obj in responseBody) {
        subFilesNames.add(obj['SubFileName']);
        subFilesLinks.add(obj['SubDownloadLink']);
      }
      print(responseBody);
      print('get movie sub $responseBody');
      print('zip ${responseBody[0]['SubDownloadLink']}');
      print('str ${responseBody[0]['SubtitlesLink']}');
      subDownloadLink = responseBody[0]['SubDownloadLink'];
      subtitlesLink = responseBody[0]['SubtitlesLink'];
      subFileName = responseBody[0]['SubFileName'];
      hasSub = true;
    } catch (e) {
      print(e.toString());
      error = e.toString();
    }
  }

  Future<void> downloadSub(String url, String name) async {
    print('url $url');
    try {
      final per = await Permission.storage.request();
      if (per.isDenied) {
        throw 'We need Storage Permission';
      }
      await tryGetiingPath();
      if (!hasPath) {
        await setNormalPath();
      }
      print("normalPath $normalPath");
      String finalPath = userPath == null ? normalPath : userPath;
      print('final path $finalPath');
      print(1);
      Dio dio = Dio();
      print(2);
      await dio.download(url, finalPath + '/$name');
      print('Done');
      notifyListeners();
    } catch (e) {
      print('error ${e.toString()}');
      error = e.toString();
      throw e;
    }
  }
}
