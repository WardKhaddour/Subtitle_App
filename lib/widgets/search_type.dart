import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../helpers/check_internet.dart';
import './my_container.dart';
import './error_message.dart';
import '../providers/imdb_provider.dart';
import '../providers/input_provider.dart';
import '../dummy_data.dart';
import 'no_intenet.dart';

class SearchType extends StatefulWidget {
  @override
  _SearchTypeState createState() => _SearchTypeState();
}

class _SearchTypeState extends State<SearchType> {
  String name;
  String episode;
  String season;
  bool isExpand = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<IMDBProvider>(context, listen: false).setNormalPath();
    Provider.of<IMDBProvider>(context, listen: false).tryGetiingPath();
  }

  Future<void> search() async {
    print('search name $name');
    bool isConnected = await CheckInternet.checkInternet();
    if (isConnected) {
      await Provider.of<IMDBProvider>(context, listen: false)
          .getData(name, season, episode);

      if (Provider.of<IMDBProvider>(context, listen: false).error != null) {
        await showDialog(
          context: context,
          builder: (context) => ErrorMessage(
            error: Provider.of<IMDBProvider>(context).error,
          ),
        );
        print('finish search');
        // Provider.of<IMDBProvider>(context, listen: false).clear();
      }
    } else {
      showDialog(
        context: context,
        builder: (_) => NoInternet(context, () {
          search();
          Navigator.of(context).pop();
        }, () {
          Navigator.of(context).pop();
        }),
      );
    }
  }

  // void clear() {
  //   name = null;
  //   season = null;
  //   episode = null;
  // }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<InputProvider>(context, listen: true);
    final nameController = prov.nameController;
    final seasonController = prov.seasonController;
    final episodeController = prov.episodeController;
    name = prov.name;
    season = prov.season;
    episode = prov.episode;
    return isExpand
        ? Hero(
            tag: 'logo',
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyContainer(
                    isReversed: false,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: nameController,
                              autofocus: true,
                              style:
                                  TextStyle(color: Colors.green, fontSize: 16),
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    Provider.of<IMDBProvider>(context).isMovie
                                        ? 'Enter Movie Name'
                                        : 'Enter Tv Show Name',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                ),
                              ),
                              onChanged: (value) {
                                // name = value;
                                nameController.text = value;
                                nameController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: nameController.text.length));
                                prov.setName(value);
                              },
                            ),
                            animationStart: 0.5,
                            suggestionsBoxDecoration: SuggestionsBoxDecoration(
                              shadowColor: Colors.grey,
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                              ),
                              offsetX: 0.0,
                            ),
                            onSuggestionSelected: (selectedName) {
                              print(selectedName);
                              setState(
                                () {
                                  nameController.text = selectedName;
                                  prov.setName(selectedName);
                                  name = selectedName;
                                },
                              );
                              search();
                            },
                            itemBuilder: (context, suggestion) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      suggestion,
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                ],
                              );
                            },
                            suggestionsCallback: (pattern) {
                              return Data.getSuggestions(pattern);
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              prov.clear();
                              Provider.of<IMDBProvider>(context, listen: false)
                                  .clear();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Provider.of<IMDBProvider>(context, listen: false).isMovie
                      ? SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.all(15),
                            padding: EdgeInsets.all(15),
                            width: 100,
                            height: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.elliptical(15.0, 15.0),
                                ),
                                color: Colors.greenAccent),
                            child: TextButton(
                              onPressed: search,
                              child: Text(
                                'Search',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: MyContainer(
                                    isReversed: true,
                                    child: Form(
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.isNotEmpty ||
                                              int.tryParse(value) != null) {
                                            return 'Invalid Value';
                                          }
                                          return null;
                                        },
                                        controller: seasonController,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(color: Colors.green),
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
                                          // season = value;
                                          seasonController.text = value;
                                          prov.setSeason(value);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: MyContainer(
                                    isReversed: true,
                                    child: Form(
                                      child: TextFormField(
                                        controller: episodeController,
                                        validator: (value) {
                                          if (value.isNotEmpty ||
                                              int.tryParse(value) != null) {
                                            return 'Invalid Value';
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(color: Colors.green),
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
                                          // episode = value;
                                          episodeController.text = value;
                                          prov.setEpisode(value);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                              child: Container(
                                margin: EdgeInsets.all(15),
                                padding: EdgeInsets.all(15),
                                width: 100,
                                height: 70,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.elliptical(15.0, 15.0),
                                    ),
                                    color: Colors.greenAccent),
                                child: TextButton(
                                  onPressed: search,
                                  child: Text(
                                    'Search',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  // Image(
                  //   image: AssetImage(
                  //     'assets/images/tasqment-logo.jpg',
                  //   ),
                  // ),
                ],
              ),
            ),
          )
        : Hero(
            tag: 'logo',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(15.0),
                //   child: Card(
                //     margin: EdgeInsets.all(20),
                //     color: Colors.greenAccent,
                //     child: Text(
                //       'Find Subtitle',
                //       style: TextStyle(fontSize: 20),
                //     ),
                //   ),
                // ),
                Card(
                  margin: EdgeInsets.all(10),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        isExpand = true;
                      });
                      Provider.of<IMDBProvider>(context, listen: false)
                          .setToMovie();
                    },
                    child: Text(
                      'Find Subtitle For Movie',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(10),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        isExpand = true;
                      });
                      Provider.of<IMDBProvider>(context, listen: false)
                          .setToTvShow();
                    },
                    child: Text(
                      'Find Subtitle For Tv Show',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                // Image(
                //   image: AssetImage(
                //     'assets/images/tasqment-logo.jpg',
                //   ),
                // ),
              ],
            ),
          );
  }
}
