import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum SubTypes {
  Movie,
  TvShow,
}

class IMDBProvider with ChangeNotifier {
  String _id;
  String _error;
  List _responseBody;
  String _language;
  bool _isMovie = true;
  SubTypes _searchType = SubTypes.Movie;

  SubTypes get searchType {
    return _searchType;
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
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<void> getData(String name, String season, String episode) async {
    try {
      if (name == null || episode == null || season == null) {
        print('null values');
        return;
      }
      await getId(name);
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
  }
}
