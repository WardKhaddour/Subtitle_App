import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../providers/imdb_provider.dart';

class SubtitleView extends StatefulWidget {
  final String name;
  final String url;
  SubtitleView(
    this.name,
    this.url,
  );

  @override
  _SubtitleViewState createState() => _SubtitleViewState();
}

class _SubtitleViewState extends State<SubtitleView> {
  bool _isDownloading = false;
  bool _downloaded;
  String _snackBarMessage;
  @override
  void initState() {
    super.initState();
    _downloaded = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: _isDownloading == false
            ? ListTile(
                leading: _downloaded == false
                    ? IconButton(
                        icon: Icon(Icons.download_rounded),
                        onPressed: () async {
                          try {
                            setState(() {
                              _isDownloading = true;
                            });
                            await Provider.of<IMDBProvider>(context,
                                    listen: false)
                                .downloadSub(widget.url, widget.name);
                            setState(() {
                              _isDownloading = false;
                            });
                            if (Provider.of<IMDBProvider>(context,
                                        listen: false)
                                    .error ==
                                null) {
                              setState(() {
                                _snackBarMessage = 'File Saved in Downloads';
                                _downloaded = true;
                              });
                            } else {
                              setState(() {
                                _snackBarMessage =
                                    'Unable to download.Please Try again';
                                _downloaded = false;
                              });
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  _snackBarMessage,
                                  textAlign: TextAlign.center,
                                ),
                                backgroundColor: Colors.grey,
                                padding: EdgeInsets.all(8),
                              ),
                            );
                          } catch (e) {
                            print('subtitle view error $e');
                          }
                        },
                      )
                    : Icon(Icons.check),
                title: Text(
                  widget.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                ),
              )
            : CircularProgressIndicator(),
      ),
      margin: EdgeInsets.all(
        15,
      ),
      padding: EdgeInsets.all(
        15,
      ),
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
        color: Colors.grey,
      ),
    );
  }
}
