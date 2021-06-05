import 'package:flutter/material.dart';
import 'storage_info_screen.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'Pattaya-Regular.ttf',
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            StorageInformation(),
          ],
        ),
      ),
    );
  }
}
