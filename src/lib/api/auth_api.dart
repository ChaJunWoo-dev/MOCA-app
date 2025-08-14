import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:prob/model/token_model.dart';

class AuthApi {
  static String baseUrl = "http://localhost:8000";

  static Future<AuthModel> getAccessToken(String email, String password) async {
    const extraUrl = "/token";
    final url = Uri.parse(baseUrl + extraUrl);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'username': email, // 이메일을 'username'으로 전송
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return AuthModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get token');
    }
  }

  // 리프레시 토큰을 사용하여 새 액세스 토큰을 얻는 메서드
  static Future<AuthModel> refreshToken(String refreshToken) async {
    const extraUrl = "/refresh";
    final url = Uri.parse(baseUrl + extraUrl);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'refresh_token': refreshToken,
      },
    );

    if (response.statusCode == 200) {
      return AuthModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('refresh 만료');
    }
  }
}
