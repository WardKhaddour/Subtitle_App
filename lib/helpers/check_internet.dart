import 'dart:io';

class CheckInternet {
  static bool _isConnected;
  static Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      print(result);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _isConnected = true;
        print(_isConnected);
        // _message = 'connected';
      }
    } on SocketException catch (_) {
      _isConnected = false;
      print(_isConnected);
      // _message = 'not connected';
    }
    return _isConnected;
  }

  // static Future<bool> getResult() async {
  //   await checkInternet();
  //   return _isConnected;
  // }
}
