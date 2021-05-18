import 'package:flutter/material.dart';
import '../widgets/storage_info.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
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
