import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:folder_picker/folder_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../providers/imdb_provider.dart';

class StorageInformation extends StatefulWidget {
  @override
  _StorageInformationState createState() => _StorageInformationState();
}

class _StorageInformationState extends State<StorageInformation> {
  Directory externalDirectory;
  Directory pickedDirectory;
  String createdFolder;
  List<StorageInfo> storageInfo = [];

  Future<void> getPermissions() async {
    final per = await Permission.storage.request();
    if (per.isDenied) {
      return;
    }
  }

  Future<void> getStorage() async {
    final directory = await getExternalStorageDirectory();
    print(" ${directory.path}");
    setState(
      () {
        externalDirectory = directory;
      },
    );
  }

  Future<void> init() async {
    await getPermissions();
    await getStorage();
  }

  Future<void> initPlatformState() async {
    List<StorageInfo> storageInformation;
    try {
      storageInformation = await PathProviderEx.getStorageInfo();
    } on PlatformException {}

    if (!mounted) return;

    setState(() {
      storageInfo = storageInformation;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    pickedDirectory = Provider.of<IMDBProvider>(context).userPath != null
        ? Directory(Provider.of<IMDBProvider>(context).userPath)
        : Directory(Provider.of<IMDBProvider>(context).normalPath);
    return Center(
      child: (storageInfo.length > 0)
          ? ListTile(
              title: Text('Picked folder'),
              subtitle: Text(
                "${pickedDirectory.path}",
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push<FolderPickerPage>(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return Scaffold(
                          floatingActionButton: FloatingActionButton(
                            child: Icon(
                              Icons.add,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (ctx) => SingleChildScrollView(
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          'Add folder',
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Container(
                                          color: Colors.white,
                                          child: TextField(
                                            autofocus: true,
                                            decoration: InputDecoration(
                                              hintText: 'Enter Folder Name',
                                            ),
                                            onChanged: (value) {
                                              createdFolder = value;
                                            },
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Directory cFolder =
                                                Directory(createdFolder);
                                            print(1);
                                            print(storageInfo[0].rootDir);
                                            Directory dir = Directory(
                                                '${storageInfo[0].rootDir}/${cFolder.path}');
                                            print('dir $dir');
                                            if (await dir.exists()) {
                                              print('exists');
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Folder Exists',
                                                  ),
                                                ),
                                              );
                                            } else {
                                              print('creating');
                                              await dir.create();
                                              final storageInformation =
                                                  await PathProviderEx
                                                      .getStorageInfo();
                                              setState(() {
                                                storageInfo =
                                                    storageInformation;
                                              });
                                              print('created');
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content:
                                                      Text('Folder Created'),
                                                ),
                                              );
                                            }
                                          },
                                          child: Text('Create'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          body: FolderPickerPage(
                            rootDirectory: Directory(storageInfo[0].rootDir),
                            action:
                                (BuildContext context, Directory folder) async {
                              print("Picked directory $folder");
                              setState(() => pickedDirectory = folder);
                              Provider.of<IMDBProvider>(context, listen: false)
                                  .setUserPath(pickedDirectory.path);
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            )
          : const CircularProgressIndicator(),
    );
  }
}
