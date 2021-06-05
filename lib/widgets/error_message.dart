import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String error;
  ErrorMessage({@required this.error});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'An error occured.Please Try again.',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      content: Text(error),
      actions: [
        TextButton(
          child: Text('Close.'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
