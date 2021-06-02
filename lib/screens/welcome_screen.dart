import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helpers/check_internet.dart';
import '../widgets/tasqment_text.dart';
import '../widgets/loading_image.dart';
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
    _isConnected = await CheckInternet.checkInternet();
    if (_isConnected) {
      print('connect');
      Timer(Duration(seconds: 5), () {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      });
    } else {
      print('not connect');

      showDialog(
        context: context,
        builder: (_) => NoInternet(context, () async {
          Navigator.of(context).pop();
          _isConnected = await CheckInternet.checkInternet();
        }, () {
          SystemNavigator.pop();
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Hero(
              tag: 'logo',
              child: LoadingImage(),
            ),
          ),
          SizedBox(height: 30),
          TasqmentText(),
          SizedBox(height: 40),
          Text(
            'Download Any Subtitle You Want!',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
