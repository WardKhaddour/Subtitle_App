import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_3_subtitle_app/service/omdb_api.dart';
import 'package:task_3_subtitle_app/service/subtitle_sevice.dart';
import '../helpers/subtitle_info.dart';

enum SubTypes {
  Movie,
  TvShow,
}

class IMDBProvider with ChangeNotifier {
  OmdbApi omdbApi = OmdbApi();
  SubtitleService subtitleService = SubtitleService();
  String error;
  String language = 'ara';
  bool hasSub = false;
  bool isMovie;
  bool isLoading = false;
  bool hasPath = false;
  SubTypes searchType = SubTypes.Movie;
  List<dynamic> responseBody;
  List<SubtitleInfo> subtitleInfo = [];
  String normalPath;
  String userPath;
  void setToMovie() {
    isMovie = true;
    searchType = SubTypes.Movie;
    notifyListeners();
  }

  void setToTvShow() {
    isMovie = false;
    searchType = SubTypes.TvShow;
    notifyListeners();
  }

  void clear() {
    subtitleInfo = [];
    error = null;
    responseBody = null;
    notifyListeners();
  }

  Future<void> setNormalPath() async {
    Directory dir = await DownloadsPathProvider.downloadsDirectory;
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

  Future<String> getId(String name) async {
    final ids = await omdbApi.getId(name);
    hasSub = ids.isNotEmpty;
    if (ids.isNotEmpty) {
      return ids;
    } else {
      return 'error';
    }
  }

  Future<void> getData(String name, String season, String episode) async {
    try {
      if (!isMovie && (episode == null || season == null) || name == null) {
        error = 'Invalid Input';
        return;
      }
      toggleLoading();
      final String id = await getId(name);
      isMovie ? await getMovieSub(id) : await getTvShowSub(season, episode, id);
      toggleLoading();
      notifyListeners();
    } catch (e) {
      error = 'Network Error';
    }
  }

  Future<void> getMovieSub(id) async {
    final res = await subtitleService.getMovieSub(id, language);
    //
    subtitleInfo = res ?? [];
  }

  Future<void> getTvShowSub(String season, String episode, String id) async {
    final res = await subtitleService.getTvShowSub(
        season: season, episode: episode, id: id, language: language);
    subtitleInfo = res ?? [];
  }

  Future<void> downloadSub(String url, String name) async {
    try {
      final per = await Permission.storage.request();
      if (per.isDenied) {
        throw 'We need Storage Permission';
      }
      await tryGetiingPath();
      if (!hasPath) {
        await setNormalPath();
      }
      String finalPath = userPath == null ? normalPath : userPath;
      Dio dio = Dio();
      await dio.download(url, finalPath + '/$name');
      notifyListeners();
    } catch (e) {
      error = 'Permission not allowed';
      throw e;
    }
  }
}
