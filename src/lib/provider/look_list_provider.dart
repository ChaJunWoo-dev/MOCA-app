import 'package:flutter/material.dart';

class LookListProvider extends ChangeNotifier {
  bool _showListView = true;

  bool get showListView => _showListView;

  // 리스트와 차트를 전환하는 메서드
  void setView(bool showListView) {
    _showListView = showListView;
    notifyListeners();
  }
}
