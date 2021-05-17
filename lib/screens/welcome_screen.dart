import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../widgets/no_intenet.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // String _message;
  bool _isConnected;
  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          _isConnected = true;
          // _message = 'connected';
        });
      }
    } on SocketException catch (_) {
      setState(() {
        _isConnected = false;
        // _message = 'not connected';
      });
    }
    if (_isConnected) {
      print('connect');
      Timer(Duration(seconds: 5), () {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      });
    } else {
      print('not connect');

      showDialog(
        context: context,
        builder: (_) => NoInternet(context, WelcomeScreen.routeName),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/subtitle-icon.jpg',
            color: Colors.white,
          ),
          SizedBox(height: 30),
          Text(
            'Download Any Subtitle You Want!',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 30),
          Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
