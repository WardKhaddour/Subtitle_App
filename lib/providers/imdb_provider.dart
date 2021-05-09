import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:ext_storage/ext_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';

enum SubTypes {
  Movie,
  TvShow,
}

class IMDBProvider with ChangeNotifier {
  String _id;
  String _error;
  String _language = 'en';
  String _zipDownloadLink;
  String _subtitlesLink;
  String _subFileName;
  List _responseBody;
  bool _hasSub = false;
  bool _isMovie = true;
  SubTypes _searchType = SubTypes.Movie;
  bool _isLoading = false;
  bool _downloaded = false;
  SubTypes get searchType {
    return _searchType;
  }

  bool get isLoading {
    return _isLoading;
  }

  bool get hasSub {
    return _hasSub;
  }

  bool get downloaded {
    return _downloaded;
  }

  String get subFileName {
    return _subFileName;
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

  void toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
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

  Future<void> getId(String name) async {
    const apiKey = '1c9d8247';
    final url = 'http://www.omdbapi.com/?t=$name&apikey=$apiKey';
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
      _subFileName = _responseBody[0]['SubFileName'];
      _hasSub = true;
    } catch (e) {
      _error = e.toString();
      print('get movie sub $_error');
    }
  }

  Future<void> getData(String name, String season, String episode) async {
    try {
      await FlutterDownloader.initialize(
        debug: true,
      );
      if (!isMovie && (episode == null || season == null) || name == null) {
        print('error if statement');
        return;
      }
      print('isLoading');
      // toggleLoading();
      print('getting data');
      await getId(name);
      print('finish getting data');
      _isMovie
          ? await getMovieSub(_id)
          : await getTvShowSub(_id, season, episode);
      // toggleLoading();
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
      // String path = await ExtStorage.getExternalStoragePublicDirectory(
      //     ExtStorage.DIRECTORY_DOWNLOADS + '/subs');
      var per = await Permission.storage.request();
      Permission.manageExternalStorage.request();
      if (per.isDenied) {
        await Permission.storage.request();
        throw 'We need Storage Permission';
      }
      Directory p = await DownloadsPathProvider.downloadsDirectory;
      String path = p.path;
      Directory dir = Directory(path);
      bool exists = await dir.exists();
      print(exists);
      if (!exists) {
        dir.createSync();
        print('created');
      }
      print(Directory(path).existsSync());
      print('path = $path');
      final taskId = await FlutterDownloader.enqueue(
        url: _subtitlesLink + '/',
        savedDir: path,
        showNotification: true,
        openFileFromNotification: true,
        fileName: _subFileName,
      );
      _downloaded = true;
      print('taskId $taskId');
    } catch (e) {
      print(e.toString());
      _error = e.toString();
    }
  }

  // Future<void> downloadSub2() async {
  //   try {
  //     print(1);
  //     var per = await Permission.storage.request();
  //     print(2);

  //     if (per.isDenied) {
  //       throw 'We need Storage permission';
  //     }
  //     Dio dio;
  //     var path = await DownloadsPathProvider.downloadsDirectory;
  //     print(3);

  //     String savePath = '${path.path}/$_id';
  //     Response response = await dio.get(
  //       _subtitlesLink,
  //       onReceiveProgress: (_, _a) {},
  //       //Received data with List<int>
  //       options: Options(
  //           responseType: ResponseType.bytes,
  //           followRedirects: false,
  //           validateStatus: (status) {
  //             return status < 500;
  //           }),
  //     );
  //     print(4);

  //     File file = File(savePath);
  //     var raf = file.openSync(mode: FileMode.write);
  //     raf.writeFromSync(response.data);
  //     print(5);

  //     await raf.close();
  //     print(6);
  //   } catch (e) {
  //     _error = e.toString();
  //   }
  // }

  // Future<void> downloadSub3() async {
  //   HttpClient httpClient = HttpClient();
  //   File file;
  //   String filePath = '';
  //   String myUrl = '';

  //   try {
  //     var per = await Permission.storage.request();
  //     if (per.isDenied) {
  //       throw 'We need Storage permission';
  //     }
  //     print('downloading...');
  //     // String path = await ExtStorage.getExternalStoragePublicDirectory(
  //     //     ExtStorage.DIRECTORY_DOWNLOADS);
  //     var path = await DownloadsPathProvider.downloadsDirectory;
  //     print('path = ${path.toString()}');
  //     print(1);
  //     myUrl = zipDownloadLink;
  //     var request = await httpClient.getUrl(Uri.parse(myUrl));
  //     print(2);

  //     var response = await request.close();
  //     print(3);

  //     if (response.statusCode == 200) {
  //       var bytes = await consolidateHttpClientResponseBytes(response);
  //       print(4);

  //       filePath = '$path/$_id';
  //       file = File(filePath);
  //       print(5);
  //       await file.create();
  //       print(6);
  //       print('bytes = =$bytes');
  //       await file.writeAsBytes(bytes);

  //       print(6);
  //     } else
  //       filePath = 'Error code: ' + response.statusCode.toString();
  //   } catch (ex) {
  //     filePath = 'Can not fetch url';
  //   }

  //   return filePath;
  // }

  Future<void> downloadSub4() async {
    await Permission.storage.request();
    var tempDir = await DownloadsPathProvider.downloadsDirectory;

    await Directory(tempDir.path).create();
    String fullPath = tempDir.path;

    print('full path $fullPath');
    var per = await Permission.storage.request();

    if (per.isGranted) {
      try {
        Response response = await Dio().get(
          _subtitlesLink,
          onReceiveProgress: (received, total) {},
          //Received data with List<int>
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) {
                return status < 500;
              }),
        );

        print(response.headers);
        File file = File(fullPath);
        var raf = file.openSync(mode: FileMode.write);
        // response.data is List<int> type
        print(1);
        raf.writeFromSync(response.data);
        print(2);
        await raf.close();
      } catch (e) {
        _error = e.toString();
      }

      notifyListeners();
    } else {
      _error =
          "we need Storage permission to download subtitles to your device ...";
      notifyListeners();
    }
  }
  // Future<void> downloadSubZip() async {
  //   try {
  //     String path = await ExtStorage.getExternalStoragePublicDirectory(
  //         ExtStorage.DIRECTORY_DOWNLOADS);
  //     print('path = $path');
  //     final taskId = await FlutterDownloader.enqueue(
  //       url: _subtitlesLink,
  //       savedDir: path,
  //       showNotification: true,
  //       openFileFromNotification: true,
  //     );
  //     print(taskId);
  //   } catch (e) {
  //     print(e.toString());
  //     _error = e.toString();
  //   }
  // }
}
