import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Periodprovider extends ChangeNotifier {
  String _startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _endDate = DateFormat('yyyy-MM-dd').format(DateTime(
      DateTime.now().year, DateTime.now().month - 1, DateTime.now().day));

  String get startDate => _startDate;
  String get endDate => _endDate;

  // 기간(날짜)변경 메서드
  void setDate(String startDate, String endDate) {
    _startDate = startDate;
    _endDate = endDate;
    notifyListeners();
  }
}
