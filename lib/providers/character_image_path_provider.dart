import 'package:flutter/material.dart';

class CharacterImagePathProvider with ChangeNotifier {
  String _imagePath = '';
  String get path => _imagePath;

  void changePath(String path) {
    _imagePath = path;
    notifyListeners();
  }
}