import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  String _homeWidget = 'mainPage';

  String get homeWidget => _homeWidget;

  void setHomeWidget(String seletedWidget) {
    _homeWidget = seletedWidget;
    notifyListeners();
  }

  String _profile = 'profile';

  String get profile => _profile;

  void setProfile(String seletedWidget) {
    _profile = seletedWidget;
    notifyListeners();
  }
}
