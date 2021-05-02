import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/imdb_provider.dart';
import 'styling_container.dart';

class SearchType extends StatefulWidget {
  @override
  _SearchTypeState createState() => _SearchTypeState();
}

class _SearchTypeState extends State<SearchType> {
  String name;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StylingContainer(
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
            onSubmitted: (value) {
              Provider.of<IMDBProvider>(context, listen: false).getId(value);
            },
          ),
        ),
        Provider.of<IMDBProvider>(context).isMovie
            ? StylingContainer(
                child: TextButton(
                  onPressed: () {},
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
                        child: StylingContainer(
                          child: TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Season',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: StylingContainer(
                          child: TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Episode',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  StylingContainer(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Search',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ],
    );
  }
}
