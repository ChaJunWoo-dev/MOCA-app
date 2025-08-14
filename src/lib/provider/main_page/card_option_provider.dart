import 'package:flutter/material.dart';

class CardOptionProvider extends ChangeNotifier {
  bool _isMonth = true;

  bool get isMonth => _isMonth;

  void setIsMonth() {
    _isMonth = !isMonth;
    notifyListeners();
  }
}
