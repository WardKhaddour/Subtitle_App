import 'package:flutter/material.dart';

class InputProvider with ChangeNotifier {
  String name;
  String episode;
  String season;
  TextEditingController controller;
  // String get name => _name;
  // String get episode => _episode;
  // String get season => _season;
  TextEditingController setController(String controllerText) =>
      TextEditingController(text: controllerText);

  void setName(String n) {
    name = n;
    print('name $name');
    notifyListeners();
  }

  void setSeason(String s) {
    season = s;
    notifyListeners();
  }

  void setEpisode(String e) {
    episode = e;
    notifyListeners();
  }

  void clear() {
    name = null;
    season = null;
    episode = null;
    notifyListeners();
  }
}
