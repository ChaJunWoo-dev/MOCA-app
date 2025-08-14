import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prob/api/auth_api.dart';

class AuthProvider with ChangeNotifier {
  String? _accessToken;
  String? _refreshToken;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  void setTokens(String accessToken, String refreshToken) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    notifyListeners();
  }

  void setAccessToken(String accessToken) {
    _accessToken = accessToken;
    notifyListeners();
  }

  void clearTokens() {
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  // 로그인 시도
  Future<String?> login(String email, String password) async {
    try {
      final response = await AuthApi.getAccessToken(email, password);
      _accessToken = response.accessToken;
      _refreshToken = response.refreshToken;
      notifyListeners();
      return 'login success';
    } catch (e) {
      return '로그인에 실패했습니다. 다시 시도해 주세요.';
    }
  }

  // 만료 여부 확인 + 재발급
  Future<bool> checkAndRefreshToken() async {
    if (_isTokenExpired(_accessToken)) {
      try {
        await _refreshAccessToken();
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return true;
    }
  }

  // 토큰 유효 여부 확인
  bool _isTokenExpired(String? token) {
    if (token == null) return true;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(decoded) as Map<String, dynamic>;

      if (!payloadMap.containsKey('exp')) return true;

      final exp = payloadMap['exp'] as int;
      final currentTime = DateTime.now().millisecondsSinceEpoch / 1000;
      return currentTime >= exp;
    } catch (e) {
      return true;
    }
  }

  // 토큰 재발급
  Future<void> _refreshAccessToken() async {
    if (_refreshToken == null) throw Exception('No refresh token available');
    final response = await AuthApi.refreshToken(_refreshToken!);
    _accessToken = response.accessToken;
    notifyListeners();
  }
}
