import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/imdb_provider.dart';
import '../widgets/subtitle_view.dart';
import '../widgets/search_type.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: Text(
          describeEnum(Provider.of<IMDBProvider>(context).searchType),
          style: TextStyle(
            fontFamily: 'Lobster-Regular.ttf',
            fontSize: 30,
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.swap_horiz,
                size: 30,
              ),
              onPressed: () {
                Provider.of<IMDBProvider>(context, listen: false)
                    .toggleSearchType();
              }),
          PopupMenuButton(
            icon: Icon(
              Icons.language,
              size: 30,
              color: Colors.white,
            ),
            itemBuilder: (_) => ['ar', 'en', 'fr']
                .map(
                  (e) => PopupMenuItem(
                    value: e,
                    child: Text(e),
                  ),
                )
                .toList(),
            onSelected: (value) {
              Provider.of<IMDBProvider>(context, listen: false)
                  .selectLanguage(value);
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SearchType(),
          SizedBox(
            height: 40,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return SubtitleView('Helllo');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
