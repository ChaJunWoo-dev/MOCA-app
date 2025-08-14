import 'package:flutter/material.dart';

class CategoriesProvider with ChangeNotifier {
  List<String> _selectedCategories = [];
  bool _isOver4 = false;

  List<String> get selectedCategories => _selectedCategories;
  bool get isOver4 => _isOver4;

  void setIsOver4(bool isOver4) {
    _isOver4 = isOver4;
  }

  void addElement(String categoryName) {
    _selectedCategories.add(categoryName);
    counter();
    notifyListeners();
  }

  void removeElement(String categoryName) {
    _selectedCategories.remove(categoryName);
    counter();
    notifyListeners();
  }

  void counter() {
    if (_selectedCategories.length >= 4) {
      setIsOver4(true);
    } else {
      setIsOver4(false);
    }
    notifyListeners();
  }

  void reset() {
    _selectedCategories = [];
    _isOver4 = false;
    notifyListeners();
  }
}
