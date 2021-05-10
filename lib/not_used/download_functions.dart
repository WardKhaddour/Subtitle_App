// Future<void> downloadSub1() async {
//     try {
//       await FlutterDownloader.initialize();

//       // String path = await ExtStorage.getExternalStoragePublicDirectory(
//       //     ExtStorage.DIRECTORY_DOWNLOADS + '/subs');
//       var per = await Permission.storage.request();
//       if (per.isDenied) {
//         await Permission.storage.request();
//       }
//       String path = (await DownloadsPathProvider.downloadsDirectory).path;

//       Directory dir = Directory(path);
//       bool exists = await dir.exists();
//       print(exists);
//       if (!exists) {
//         dir.create();
//         print('created');
//       }
//       //   print(Directory(path).existsSync());
//       print('path = $path');
//       print('path = $subtitlesLink');
//       final taskId = await FlutterDownloader.enqueue(
//         url: zipDownloadLink,
//         savedDir: path,
//         showNotification: true,
//         fileName: subFileName,
//       );
//       print('taskId $taskId');
//     } catch (e) {
//       print('errrrrrrrrrrrrrrrrrrroooor ${e.toString()}');
//       error = e.toString();
//     }
//   }

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
// String path = await ExtStorage.getExternalStoragePublicDirectory(
//     ExtStorage.DIRECTORY_DOWNLOADS);
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

// Future<void> downloadSub4() async {
//   await Permission.storage.request();
//   var tempDir = await DownloadsPathProvider.downloadsDirectory;

//   await Directory(tempDir.path).create();
//   String fullPath = tempDir.path;

//   print('full path $fullPath');
//   var per = await Permission.storage.request();
//   if (per.isGranted) {
//     try {
//       Response response = await Dio().get(
//         zipDownloadLink,
//         onReceiveProgress: (received, total) {},
//         //Received data with List<int>
//         options: Options(
//             responseType: ResponseType.bytes,
//             followRedirects: false,
//             validateStatus: (status) {
//               return status < 500;
//             }),
//       );

//       print(response.headers);
//       File file = File(fullPath);
//       var raf = file.openSync(mode: FileMode.write);
//       // response.data is List<int> type
//       print(1);
//       raf.writeFromSync(response.data);
//       print(2);
//       await raf.close();
//     } catch (e) {
//       error = e.toString();
//     }

//     notifyListeners();
//   } else {
//     error =
//         "we need Storage permission to download subtitles to your device ...";
//     notifyListeners();
//   }
// }

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
