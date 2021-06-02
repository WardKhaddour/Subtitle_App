import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../helpers/check_internet.dart';
import '../providers/imdb_provider.dart';
import 'no_intenet.dart';

class SubtitleView extends StatefulWidget {
  final String name;
  final String url;
  final String size;
  SubtitleView(
    this.name,
    this.url,
    this.size,
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
                subtitle: Text(
                  '${(double.tryParse(widget.size) / 1024).toStringAsFixed(2)} KB',
                ),
                trailing: _downloaded == false
                    ? IconButton(
                        icon: Icon(Icons.download_rounded),
                        onPressed: () async {
                          try {
                            setState(() {
                              _isDownloading = true;
                            });
                            bool isConnected =
                                await CheckInternet.checkInternet();
                            if (isConnected) {
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
                                  _snackBarMessage = 'File Saved';
                                  _downloaded = true;
                                });
                              } else {
                                setState(() {
                                  _snackBarMessage =
                                      'Unable to download.Please Try again';
                                  _downloaded = false;
                                });
                              }
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    _snackBarMessage,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.all(8),
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => NoInternet(
                                  context,
                                  () async {
                                    await Provider.of<IMDBProvider>(context,
                                            listen: false)
                                        .downloadSub(widget.url, widget.name);
                                    setState(() {
                                      _isDownloading = false;
                                    });
                                  },
                                  () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              );
                            }
                          } catch (e) {
                            print('subtitle view error $e');
                          }
                        },
                      )
                    : Icon(Icons.check),
                title: Text(
                  widget.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              )
            : SpinKitChasingDots(
                color: Colors.white,
              ),
      ),
      margin: EdgeInsets.all(
        8,
      ),
      padding: EdgeInsets.all(
        8,
      ),
      width: double.infinity,
      height: 90,
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.only(
      //     topRight: Radius.circular(30),
      //     bottomLeft: Radius.circular(30),
      //   ),
      color: Colors.green,
    );
  }
}
