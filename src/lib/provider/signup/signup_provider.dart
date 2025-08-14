import 'package:flutter/material.dart';

class SignupProvider with ChangeNotifier {
  String? _email;
  String? _password;
  String? _nickname;
  List<String>? _categories;

  String? get email => _email;
  String? get password => _password;
  String? get nickname => _nickname;
  List<String>? get categories => _categories;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setNickname(String nickname) {
    _nickname = nickname;
    notifyListeners();
  }

  void setCategories(List<String> categories) {
    _categories = categories;
    notifyListeners();
  }

  void reset() {
    _email = null;
    _password = null;
    _nickname = null;
    _categories = null;
    notifyListeners();
  }

  bool isNotEmpty() {
    if (_email == null ||
        _password == null ||
        _nickname == null ||
        _categories == null) {
      return false;
    }
    if (_email!.trim().isNotEmpty &&
        _password!.trim().isNotEmpty &&
        _nickname!.trim().isNotEmpty &&
        _categories!.isNotEmpty) {
      return true;
    }
    return false;
  }
}
