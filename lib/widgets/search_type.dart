import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/imdb_provider.dart';
import './my_container.dart';
import './error_message.dart';

class SearchType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String name;
    String episode;
    String season;
    return SingleChildScrollView(
      child: Column(
        children: [
          MyContainer(
            child: TextField(
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: Provider.of<IMDBProvider>(context).isMovie
                    ? 'Enter Movie Name'
                    : 'Enter Tv Show Name',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
              onChanged: (value) {
                name = value;
              },
            ),
          ),
          Provider.of<IMDBProvider>(context, listen: false).isMovie
              ? Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(15),
                  width: 100,
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.lightBlueAccent),
                  child: TextButton(
                    onPressed: () {
                      {
                        print('searching');
                        Provider.of<IMDBProvider>(context, listen: false)
                                    .error !=
                                null
                            ? Provider.of<IMDBProvider>(context, listen: false)
                                .getData(name, season, episode)
                            : showDialog(
                                context: context,
                                builder: (context) => ErrorMessage(),
                              );
                        print('finish search');
                      }
                    },
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: MyContainer(
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Season',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                ),
                              ),
                              onChanged: (value) {
                                season = value;
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: MyContainer(
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Episode',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                ),
                              ),
                              onChanged: (value) {
                                episode = value;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(15),
                      padding: EdgeInsets.all(15),
                      width: 100,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightBlueAccent,
                      ),
                      child: TextButton(
                        onPressed: () {
                          print('searching');
                          if (Provider.of<IMDBProvider>(context, listen: false)
                                  .error !=
                              null) {
                            Provider.of<IMDBProvider>(context, listen: false)
                                .getData(name, season, episode);
                          } else {
                            print('errorrrrr');
                            showDialog(
                                context: context,
                                builder: (_) => ErrorMessage());
                          }
                          print('finish search');
                        },
                        child: Text(
                          'Search',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
