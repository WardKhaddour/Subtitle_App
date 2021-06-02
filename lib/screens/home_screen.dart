import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'settings_screen.dart';
import '../providers/input_provider.dart';
import '../providers/imdb_provider.dart';
import '../widgets/subtitle_view.dart';
import '../widgets/search_type.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    List<String> names = Provider.of<IMDBProvider>(context).subFilesNames;
    List<String> urls = Provider.of<IMDBProvider>(context).subFilesLinks;
    List<String> sizes = Provider.of<IMDBProvider>(context).subFilesSizes;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          children: [
            GestureDetector(
              // onTap: () {
              //   showDialog(

              //     context: context,
              //     builder: (context) => Container(
              //       color: Colors.white,
              //       child: LoadingImage(),
              //       // child: SpinKitCircle(
              //       //   itemBuilder: (context, index) =>
              //       //       Image.asset('assets/images/tasqment-logo.jpg'),
              //       // ),
              //     ),
              //   );
              // },
              child: Container(
                width: 25,
                height: 25,
                child: Image.asset(
                  'assets/images/tasqment-logo.jpg',
                  fit: BoxFit.cover,
                  // color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              Provider.of<IMDBProvider>(context).isMovie != null
                  ? describeEnum(Provider.of<IMDBProvider>(context).searchType)
                  : 'Find Subtitle',
              style: TextStyle(
                fontFamily: 'Pattaya-Regular.ttf',
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(SettingsScreen.routeName);
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.refresh),
          //   onPressed: () {
          //     Provider.of<IMDBProvider>(context, listen: false).clear();
          //     Provider.of<InputProvider>(context, listen: false).clear();
          //   },
          // ),
          IconButton(
              icon: Icon(
                Icons.swap_horiz,
                // size: 30,
              ),
              onPressed: () {
                Provider.of<IMDBProvider>(context, listen: false)
                    .toggleSearchType();
                Provider.of<IMDBProvider>(context, listen: false).clear();
                Provider.of<InputProvider>(context, listen: false).clear();
              }),
          PopupMenuButton(
            color: Colors.green,
            icon: Text(Provider.of<IMDBProvider>(context).language),
            //  Icon(
            //   Icons.language,
            //   size: 30,
            //   color: Colors.white,
            // ),
            itemBuilder: (_) => ['ara', 'eng', 'fre', 'ger', 'ita', 'spa']
                .map(
                  (e) => PopupMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
                .toList(),
            onSelected: (String value) {
              Provider.of<IMDBProvider>(context, listen: false)
                  .selectLanguage(value);
            },
          ),
        ],
      ),
      // drawer: MyDrawer(),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          shrinkWrap: true,
                          itemCount: names.length,
                          itemBuilder: (context, index) {
                            print('length ${names.length}');
                            return Column(
                              children: [
                                for (int i = 0; i < names.length; ++i)
                                  SubtitleView(
                                    names[i],
                                    urls[i],
                                    sizes[i],
                                  )
                              ],
                            );
                          },
                        ),
                      ),
                    )
                  : SizedBox()
              : SingleChildScrollView(
                  child: SpinKitPulse(
                    color: Colors.green,
                  ),
                ),
        ],
      ),
    );
  }
}
