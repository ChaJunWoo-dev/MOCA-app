import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailProvider with ChangeNotifier {
  String? _emailMessage;
  String? _codeMessage;
  bool _isVerified = false;
  //타이머용
  bool _isButtonDisabled = false;
  Timer? _timer;
  int _countdown = 0;

  String? get emailMessage => _emailMessage;
  String? get codeMessage => _codeMessage;
  bool get isVerified => _isVerified;
  //타이머용
  bool get isButtonDisabled => _isButtonDisabled;
  int get countdown => _countdown;

  EmailProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isVerified = prefs.getBool('isVerified') ?? false;
    _isButtonDisabled = prefs.getBool('isButtonDisabled') ?? false;
    _countdown = prefs.getInt('countdown') ?? 0;
    if (_countdown > 0) {
      _startCountdown();
    } else {
      notifyListeners();
    }
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isVerified', _isVerified);
    await prefs.setBool('isButtonDisabled', _isButtonDisabled);
    await prefs.setInt('countdown', _countdown);
  }

  void toggleIsVerified() {
    _isVerified = !_isVerified;
    _savePreferences();
    notifyListeners();
  }

  void setEmailMessage(dynamic emailMessage) {
    _emailMessage = emailMessage;
    notifyListeners();
  }

  void setCodeMessage(dynamic codeMessage) {
    _codeMessage = codeMessage;
    notifyListeners();
  }

  void startTimer() {
    _isButtonDisabled = true;
    _countdown = 30;
    _savePreferences();
    notifyListeners();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        _countdown--;
        _savePreferences();
        notifyListeners();
      } else {
        _timer?.cancel();
        _isButtonDisabled = false;
        _savePreferences();
        notifyListeners();
      }
    });
  }

  void reset() async {
    // 타이머 중지
    _timer?.cancel();
    _timer = null;

    // 상태 초기화
    _emailMessage = null;
    _codeMessage = null;
    _isVerified = false;
    _isButtonDisabled = false;
    _countdown = 0;

    // 저장된 값 초기화
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isVerified');
    await prefs.remove('isButtonDisabled');
    await prefs.remove('countdown');
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
