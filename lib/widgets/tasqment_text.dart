import 'dart:async';
import 'package:flutter/material.dart';

class TasqmentText extends StatefulWidget {
  @override
  _TasqmentTextState createState() => _TasqmentTextState();
}

class _TasqmentTextState extends State<TasqmentText> {
  String tasqment = '';
  int index = 0;
  List<String> charachters = [
    'T',
    'Ta',
    'Tas',
    'TasQ',
    'TasQm',
    'TasQme',
    'TasQmen',
    'TasQment',
  ];
  @override
  void dispose() {
    super.dispose();
  }

  void changeText() {
    Timer(
      Duration(milliseconds: 1000),
      () => setState(
        () {
          if (index < 7) {
            index++;
          } else {
            index = 0;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    changeText();
    tasqment = charachters[index];
    return Container(
      child: Center(
        child: Text(
          tasqment,
          style: TextStyle(
            color: Colors.green,
            fontFamily: 'Pattaya-Regular.ttf',
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
