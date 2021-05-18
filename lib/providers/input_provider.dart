import 'package:flutter/cupertino.dart';

class InputProvider with ChangeNotifier {
  String _name;
  String _episode;
  String _season;
  String get name => _name;
  String get episode => _episode;
  String get season => _season;
  void setName(String n) => _name = n;
  void setSeason(String s) => _season = s;
  void setEpisode(String e) => _episode = e;
  void clear() {
    _name = null;
    _season = null;
    _episode = null;
  }
}
