import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = 'welcome';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String _message;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          _message = 'connected';
        });
      }
    } on SocketException catch (_) {
      setState(() {
        _message = 'not connected';
      });
    }
    if (_message == 'connected') {
      Timer(Duration(seconds: 5), () {
        Navigator.of(context).pushReplacementNamed('home');
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Check your internet connection'),
          content: Image.asset('assets/images/no-conection.png'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('welcome');
              },
              child: Text('Retry'),
            ),
            TextButton(
                child: Text('Close'),
                onPressed: () {
                  SystemNavigator.pop();
                })
          ],
        ),
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
