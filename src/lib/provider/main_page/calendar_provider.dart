import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prob/model/hist_model.dart';

class CalendarProvider extends ChangeNotifier {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  List<HistModel> _selectHist = [];

  DateTime? get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;
  List<HistModel> get selectHist => _selectHist;

  void selectDay(DateTime? selectedDay, DateTime? focusedDay) {
    _selectedDay = selectedDay;
    if (focusedDay != null) {
      _focusedDay = focusedDay;
    }
    notifyListeners();
  }

  void setSelectHist(List<HistModel> list) {
    _selectHist = list;
    notifyListeners();
  }

  void clear() {
    _selectedDay = null;
    _selectHist = [];
  }

  void refresh(Map<String, List<HistModel>> data) {
    if (_selectedDay != null) {
      _selectHist = data.entries
          .where((entry) =>
              entry.key == DateFormat('yyyy-MM').format(_selectedDay!))
          .expand((entry) => entry.value)
          .where((hist) {
        // hist는 HistModel 객체입니다.
        final historyDate = DateFormat('yyyy-MM-dd').parse(hist.date).toLocal();
        return isSameDay(historyDate, selectedDay);
      }).toList();
    }
    notifyListeners();
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }

    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // void resetDays(DateTime? previousSelectedDay, DateTime? previousFocusedDay) {
  //   _selectedDay = previousSelectedDay ?? _selectedDay;
  //   _focusedDay = previousFocusedDay ?? _focusedDay;
  //   notifyListeners();
  // }

  // void setIsSwipe(bool swipe) {
  //   _isSwiped = swipe;
  //   notifyListeners();
  // }
}
