import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './settings_screen.dart';
import '../providers/imdb_provider.dart';
import '../widgets/subtitle_view.dart';
import '../widgets/search_type.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    List<String> names = Provider.of<IMDBProvider>(context).subFilesNames;
    List<String> urls = Provider.of<IMDBProvider>(context).subFilesLinks;
    // SearchType searchType = SearchType();
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
            icon: Icon(Icons.refresh),
            onPressed: () {
              Provider.of<IMDBProvider>(context, listen: false).clear();
              // searchType.clear();
            },
          ),
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).pushNamed(SettingsScreen.routeName);
              }),
          IconButton(
              icon: Icon(
                Icons.swap_horiz,
                size: 30,
              ),
              onPressed: () {
                Provider.of<IMDBProvider>(context, listen: false)
                    .toggleSearchType();
                Provider.of<IMDBProvider>(context, listen: false).clear();
                // searchType.clear();
              }),
          PopupMenuButton(
            icon: Text(Provider.of<IMDBProvider>(context).language),
            //  Icon(
            //   Icons.language,
            //   size: 30,
            //   color: Colors.white,
            // ),
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
          Provider.of<IMDBProvider>(context).isLoading == false
              ? Provider.of<IMDBProvider>(context).hasSub
                  ? Expanded(
                      child: Container(
                        width: double.infinity,
                        child: ListView.builder(
                          itemCount: names.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                for (int i = 0; i < names.length; ++i)
                                  SubtitleView(
                                    names[i],
                                    urls[i],
                                  )
                              ],
                            );
                          },
                        ),
                      ),
                    )
                  : SizedBox()
              : CircularProgressIndicator(),
        ],
      ),
    );
  }
}
