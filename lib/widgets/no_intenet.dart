import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoInternet extends StatelessWidget {
  final String currentPageRouteName;
  final BuildContext context;
  NoInternet(this.context, this.currentPageRouteName);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Unable to connect !',
            style: TextStyle(
              color: Colors.red,
              fontSize: 26,
            ),
          ),
          Text('Check your internet connection'),
        ],
      ),
      content: Image.asset('assets/images/no-conection.png'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(currentPageRouteName);
          },
          child: Text('Retry'),
        ),
        TextButton(
            child: Text('Close'),
            onPressed: () {
              SystemNavigator.pop();
            })
      ],
    );
  }
}
