import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  final BuildContext context;
  final Function retry;
  final Function close;
  NoInternet(this.context, this.retry, this.close);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Unable to connect!!',
            style: TextStyle(
              color: Theme.of(context).errorColor,
              fontSize: 20,
            ),
          ),
          Text('Check your internet connection'),
        ],
      ),
      content: Image.asset(
        'assets/images/no-conection.png',
        height: 100,
        width: 100,
      ),
      actions: [
        TextButton(
          child: Text('Retry'),
          onPressed: retry,
        ),
        TextButton(
          child: Text('Close'),
          onPressed: close,
        ),
      ],
    );
  }
}
