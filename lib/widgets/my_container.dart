import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  final Widget child;
  MyContainer({
    this.child,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: child,
    );
  }
}
