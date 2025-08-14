import 'package:flutter/material.dart';

class TotalProvider with ChangeNotifier {
  int? _monthTotal;
  int? _weekTotal;
  int? _dayTotal;

  int? get monthTotal => _monthTotal;
  int? get weekTotal => _weekTotal;
  int? get dayTotal => _dayTotal;

  void setMonthTotal(int monthTotal) {
    _monthTotal = monthTotal;
    notifyListeners();
  }

  void setWeekTotal(int weekTotal) {
    _weekTotal = weekTotal;
    notifyListeners();
  }

  void setDayTotal(int dayTotal) {
    _dayTotal = dayTotal;
    notifyListeners();
  }

  void justRefresh() {
    notifyListeners();
  }
}
