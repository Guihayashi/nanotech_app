import 'package:flutter/material.dart';

class SessionManager with ChangeNotifier {
  String? _loggedInUser;

  String? get loggedInUser => _loggedInUser;

  void login(String username) {
    _loggedInUser = username;
    notifyListeners();
  }

  void logout() {
    _loggedInUser = null;
    notifyListeners();
  }

  bool isLoggedIn() {
    return _loggedInUser != null;
  }
}
