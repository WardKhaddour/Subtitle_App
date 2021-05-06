import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/imdb_provider.dart';

class ErrorMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'An error occured.Please Try again.',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      content: Text(
        Provider.of<IMDBProvider>(context).error,
      ),
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
