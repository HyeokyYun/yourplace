import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _user = '';
  String get user => _user;

  void changeUser(String user) {
    _user = user;
    notifyListeners();
  }
}