import 'package:flutter/cupertino.dart';

class InputProvider with ChangeNotifier {
  String _name;
  String _episode;
  String _season;

  String get name => _name;
  String get episode => _episode;
  String get season => _season;
  TextEditingController nameController = TextEditingController();
  TextEditingController seasonController = TextEditingController();
  TextEditingController episodeController = TextEditingController();

  void setName(String n) {
    _name = n;
    print('name $_name');
    notifyListeners();
  }

  void setSeason(String s) {
    _season = s;
    notifyListeners();
  }

  void setEpisode(String e) {
    _episode = e;
    notifyListeners();
  }

  void clear() {
    _name = null;
    _season = null;
    _episode = null;
    nameController.clear();
    seasonController.clear();
    episodeController.clear();
    notifyListeners();
  }
}
