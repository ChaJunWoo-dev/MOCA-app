import 'package:flutter/material.dart';

class AddControlRefresh with ChangeNotifier {
  bool? _isAdded;

  bool? get isAdded => _isAdded;

  void change(bool state) {
    _isAdded = state;
    notifyListeners();
  }
}
