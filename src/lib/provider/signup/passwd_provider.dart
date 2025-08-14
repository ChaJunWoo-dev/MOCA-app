import 'package:flutter/material.dart';

class PasswdProvider with ChangeNotifier {
  String? _passwdMessage;
  String? _verifyPasswdMessage;
  bool _obscure = false;
  bool _isValid = false;
  bool _isSame = false;

  bool _isValidLength = false;
  bool _hasUpperOrLowercase = false;
  bool _hasDigits = false;
  bool _hasSpecialCharacters = false;

  String? get passwdMessage => _passwdMessage;
  String? get verifyPasswdMessage => _verifyPasswdMessage;
  bool get obscure => _obscure;
  bool get isSame => _isSame;
  bool get isValid => _isValid;

  bool get isValidLength => _isValidLength;
  bool get hasUpperOrLowercase => _hasUpperOrLowercase;
  bool get hasDigits => _hasDigits;
  bool get hasSpecialCharacters => _hasSpecialCharacters;

  void setPasswdMessage(dynamic passwdMessage) {
    _passwdMessage = passwdMessage;
    notifyListeners();
  }

  void setVerifyPasswdMessage(String? verifyPasswdMessage) {
    _verifyPasswdMessage = verifyPasswdMessage;
    notifyListeners();
  }

  void toggleObscure() {
    _obscure = !obscure;
    notifyListeners();
  }

  void setIsSame(bool isSame) {
    _isSame = isSame;
    notifyListeners();
  }

  void setIsValid(bool isValid) {
    _isValid = isValid;
    notifyListeners();
  }

  void validatePassword(String password) {
    _isValidLength = password.length >= 8;
    _hasUpperOrLowercase = password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]'));
    _hasDigits = password.contains(RegExp(r'[0-9]'));
    _hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    if (_isValidLength &&
        _hasUpperOrLowercase &&
        _hasDigits &&
        _hasSpecialCharacters) {
      setIsValid(true);
    } else {
      setIsValid(false);
    }
    notifyListeners();
  }

  bool verifyPassword(String? verifyPassword, String? password) {
    if (verifyPassword != password) {
      setIsSame(false);
      setVerifyPasswdMessage("입력하신 비밀번호와 달라요");
    } else {
      setIsSame(true);
      setVerifyPasswdMessage(null);
    }
    notifyListeners();
    return isSame;
  }

  void reset() {
    _passwdMessage = null;
    _verifyPasswdMessage = null;
    _obscure = false;
    _isValid = false;
    _isSame = false;

    _isValidLength = false;
    _hasUpperOrLowercase = false;
    _hasDigits = false;
    _hasSpecialCharacters = false;

    notifyListeners();
  }
}
