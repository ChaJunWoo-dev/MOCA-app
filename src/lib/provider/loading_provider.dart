import 'package:flutter/material.dart';

class MainLoadingProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }
}

class ConsumeHistLoadingProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }
}

class ProfileLoadingProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }
}
