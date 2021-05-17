import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_3_subtitle_app/dummy_data.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import './my_container.dart';
import './error_message.dart';
import '../providers/imdb_provider.dart';

class SearchType extends StatefulWidget {
  @override
  _SearchTypeState createState() => _SearchTypeState();
}

class _SearchTypeState extends State<SearchType> {
  String name;
  String episode;
  String season;
  void clear() {
    name = null;
    season = null;
    episode = null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MyContainer(
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                autofocus: true,
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
              ),
              onSuggestionSelected: (_) {},
              itemBuilder: (context, suggestion) {
                return Text(suggestion);
              },
              suggestionsCallback: (pattern) {
                return Data.getSuggestions(pattern);
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
                    onPressed: () async {
                      print('searching');
                      // Provider.of<IMDBProvider>(context, listen: false)
                      //     .toggleLoading();
                      await Provider.of<IMDBProvider>(context, listen: false)
                          .getData(name, season, episode);

                      if (Provider.of<IMDBProvider>(context, listen: false)
                              .error !=
                          null) {
                        showDialog(
                          context: context,
                          builder: (context) => ErrorMessage(
                            error: Provider.of<IMDBProvider>(context).error,
                          ),
                        );
                        // Provider.of<IMDBProvider>(context, listen: false)
                        //     .toggleLoading();
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
                        onPressed: () async {
                          print('searching');
                          // Provider.of<IMDBProvider>(context).toggleLoading();
                          await Provider.of<IMDBProvider>(context,
                                  listen: false)
                              .getData(name, season, episode);

                          if (Provider.of<IMDBProvider>(context, listen: false)
                                  .error !=
                              null) {
                            print('errorrrrr');
                            showDialog(
                              context: context,
                              builder: (_) => ErrorMessage(
                                error: Provider.of<IMDBProvider>(context).error,
                              ),
                            );
                          }
                          // Provider.of<IMDBProvider>(context).toggleLoading();
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
