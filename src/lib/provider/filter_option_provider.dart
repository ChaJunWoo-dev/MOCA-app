import 'package:flutter/material.dart';

class FilterOptionsProvider extends ChangeNotifier {
  String _selectedPeriod = "1개월";
  String _selectedSortOrder = "최신순";

  String get selectedPeriod => _selectedPeriod;
  String get selectedSortOrder => _selectedSortOrder;

  // 기간 변경 메서드
  void setSelectedPeriod(String period) {
    _selectedPeriod = period;
    notifyListeners();
  }

  // 정렬 순서 변경 메서드
  void setSelectedSortOrder(String sortOrder) {
    _selectedSortOrder = sortOrder;
    notifyListeners();
  }
}
