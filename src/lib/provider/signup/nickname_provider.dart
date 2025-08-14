import 'package:flutter/material.dart';

class NicknameProvider with ChangeNotifier {
  bool _isValidLength = false;
  bool _availableNickname = false;
  bool _isValid = false;

  bool get isValidLength => _isValidLength;
  bool get availableNickname => _availableNickname;
  bool get isValid => _isValid;

  void setIsValid(bool isValid) {
    _isValid = isValid;
  }

  void validateNickname(String nickname) {
    _isValidLength = nickname.length <= 8 && nickname.isNotEmpty;
    _availableNickname = nickname.contains(RegExp(r'^[A-Za-z0-9가-힣ㄱ-ㅎ]+$'));
    if (_isValidLength && _availableNickname) {
      setIsValid(true);
    } else {
      setIsValid(false);
    }
    notifyListeners();
  }

  void reset() {
    _isValidLength = false;
    _availableNickname = false;
    _isValid = false;
    notifyListeners();
  }
}
