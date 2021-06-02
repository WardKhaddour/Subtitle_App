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
            // ListTile(
            //   title: Text('Edit Download Path'),
            //   trailing: IconButton(
            //     icon: Icon(Icons.edit),
            //     onPressed: () async {
            //       final FilePickerResult result =
            //           await FilePicker.platform.pickFiles(
            //         withReadStream: true,
            //         withData: true,
            //         onFileLoading: (status) {
            //           Provider.of<IMDBProvider>(context)
            //               .setUserPath(FilePickerStatus.picking.toString());
            //         },
            //         type: FileType.custom,
            //         allowedExtensions: ['Folder'],
            //       );
            //       if (result != null) {
            //         PlatformFile file = result.files.first;
            //         print(file.name);
            //       } else {}
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
