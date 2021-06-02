import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  final Widget child;
  final bool isReversed;
  MyContainer({
    @required this.child,
    @required this.isReversed,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green,
          width: 2,
        ),
        borderRadius: isReversed
            ? BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )
            : BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
        color: Colors.white,
      ),
      child: child,
    );
  }
}
