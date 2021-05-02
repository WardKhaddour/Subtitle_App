import 'package:flutter/material.dart';

class SubtitleView extends StatelessWidget {
  final String title;
  SubtitleView(this.title);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
      ),
      margin: EdgeInsets.all(
        15,
      ),
      padding: EdgeInsets.all(
        15,
      ),
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          30,
        ),
        color: Colors.white,
      ),
    );
  }
}
