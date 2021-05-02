import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:dio/dio.dart';
enum SubTypes {
  Movie,
  TvShow,
}

//subRepo

class IMDBProvider with ChangeNotifier {
  String _id;
  String _error;
  List _responseBody;
  String _language;
  bool _isMovie;
  SubTypes _searchType = SubTypes.Movie;

  // void toggleSearchType() {
  //   _searchType == SubTypes.Movie
  //       ? _searchType = SubTypes.TvShow
  //       : _searchType = SubTypes.Movie;
  //   print(describeEnum(searchType));
  //   notifyListeners();
  // }

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

  set selectedLanguage(String lang) {
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

    var result = new StringBuffer();
    await for (var contents in response.transform(Utf8Decoder())) {
      result.write(contents);
    }
    _responseBody = jsonDecode(result.toString());
  }
}
// class MyProvider with ChangeNotifier {
//   List<dynamic> responseBody;
//   bool isLoading = false;
//   bool isDownloading = false;
//   String errMsg = "";
//   String per = "0 %";
//   String lang = "ara";
//   bool isMovie = true;
//   String _id;

//   Future<void> getData(String moviename, String ep, String se) async {
//     try {
//       if (!isMovie && (ep == '' || se == '') || moviename == '') {
//         return;
//       }
//       clearData();
//       await getid(moviename);

//       isMovie ? await getSub(_id) : await getTvSub(_id, ep, se);

//       notifyListeners();
//     } catch (e) {
//       errMsg = "somthing went Wrong please try again ......";
//     }
//   }

// String get errMSG {
//   return errMsg;
// }

// void toogleLoading() {
//   isLoading = !isLoading;
//   notifyListeners();
// }

// void toogleisDownloading() {
//   isDownloading = !isDownloading;
//   notifyListeners();
// }

// void toogleisMovie() {
//   isMovie = !isMovie;
//   notifyListeners();
// }

// List<dynamic> get items {
//   return responseBody;
// }

// Future<void> getid(String movieName) async {
//   const apiKey = '1c9d8247';
//   final url = 'http://www.omdbapi.com/?t=$movieName&apikey=$apiKey';
//   try {
//     final response = await http.get(Uri.parse(url));
//     final extractedData = json.decode(response.body) as Map<String, dynamic>;
//     _id = extractedData['imdbID'];
//     print('id=$_id.toString()');
//   } catch (e) {
//     print('error $e');
//   }
// }

// Future<void> getSub(id) async {
//   print("getSub");

//   try {
//     HttpClient client = new HttpClient();
//     // String s = '';
//     client.userAgent = 'obadasub';

//     HttpClientRequest request = await client.getUrl(Uri.parse(
//         'http://rest.opensubtitles.org/search/imdbid-$id/sublanguageid-$lang'));
//     HttpClientResponse response = await request.close();
//     var result = new StringBuffer();
//     await for (var contents in response.transform(Utf8Decoder())) {
//       result.write(contents);
//     }
//     responseBody = jsonDecode(result.toString());
//   } catch (e) {
//     errMsg = e.toString();
//   }
// }

// String get pers {
//   return per;
// }

//   Future<void> download2(String url, String savePath) async {
//     var per = await Permission.storage.request();

//     if (per.isGranted) {
//       toogleisDownloading();
//       try {
//         Response response = await Dio().get(
//           url,
//           onReceiveProgress: (received, total) {
//             showDownloadProgress(received, total);
//           },
//           //Received data with List<int>
//           options: Options(
//               responseType: ResponseType.bytes,
//               followRedirects: false,
//               validateStatus: (status) {
//                 return status < 500;
//               }),
//         );
//         // print(response.headers);
//         File file = File(savePath);
//         var raf = file.openSync(mode: FileMode.write);
//         // response.data is List<int> type
//         raf.writeFromSync(response.data);
//         await raf.close();
//       } catch (e) {
//         errMsg = e;
//       }

//       toogleisDownloading();
//       notifyListeners();
//     } else {
//       errMsg =
//           "we need Storage permission to download subtitles to your device ...";
//       notifyListeners();
//     }
//   }

//   void showDownloadProgress(received, total) {
//     if (total != -1) {
//       print((received / total * 100).toStringAsFixed(0) + "%");
//       per = (received / total * 100).toStringAsFixed(0) + "%";
//       notifyListeners();
//     }
//   }

//   Future<void> getTvSub(id, ep, se) async {
//     print("getTvSub");
//     HttpClient client = new HttpClient();
//     client.userAgent = 'obadasub';

//     HttpClientRequest request = await client.getUrl(Uri.parse(
//         "https://rest.opensubtitles.org/search/episode-$ep/imdbid-$id/season-$se/sublanguageid-$lang"));
//     HttpClientResponse response = await request.close();

//     var result = new StringBuffer();
//     await for (var contents in response.transform(Utf8Decoder())) {
//       result.write(contents);
//     }
//     responseBody = jsonDecode(result.toString());
//   }

//   void clearData() {
//     if (responseBody != null) responseBody.clear();
//     errMsg = '';
//   }

//   List<String> get langList {
//     return ["ara", "eng", "fra", "ger"];
//   }

//   String get language {
//     return lang;
//   }

//   set language(String s) {
//     lang = s;
//     notifyListeners();
//   }
// }
