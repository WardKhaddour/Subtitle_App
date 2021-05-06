import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/imdb_provider.dart';

class SubtitleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<IMDBProvider>(context, listen: false).downloadSub();
      },
      child: Container(
        child: Center(
          child: Text(
            '${Provider.of<IMDBProvider>(context, listen: false).zipDownloadLink}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
            ),
          ),
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
      ),
    );
  }
}

class ZipSubtitleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<IMDBProvider>(context, listen: false).downloadSubZip();
      },
      child: Container(
        child: Center(
          child: Text(
            '${Provider.of<IMDBProvider>(context, listen: false).zipDownloadLink} "zip"',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
            ),
          ),
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
      ),
    );
  }
}
