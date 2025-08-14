import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:prob/model/user_model.dart';

class UserApi {
  static String baseUrl = "http://localhost:8000/users";

  static Future<UserModel> readUser(String? token) async {
    const extraUrl = '/get/me';
    final url = Uri.parse(baseUrl + extraUrl);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // 토큰을 헤더에 추가합니다.
      },
    );

    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedResponse);
      UserModel usermodel = UserModel.fromJson(jsonResponse);
      return usermodel;
    } else {
      throw Exception('get user failed');
    }
  }

  static Future<bool> signUp(String userId, String password, String nickname,
      List<String> categories) async {
    const extraUrl = '/signup';
    final url = Uri.parse(baseUrl + extraUrl);
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "email": userId,
          "password": password,
          "nickname": nickname,
          "categories": categories,
        }));
    if (response.statusCode == 200) {
      //print(response.body);
      return true;
    } else {
      return false;
      //throw Exception('get user failed. Token may have expired');
    }
  }

  static Future<bool> checkEmail(String userId) async {
    const extraUrl = '/check_use/email';
    final url = Uri.parse('$baseUrl$extraUrl?email=$userId');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      //print(response.body);
      return true;
    } else if (response.statusCode == 400) {
      return false;
    } else {
      throw Exception('Error,관리자에게 문의하세요');
    }
  }

  static Future<bool> checkNickname(String nickname) async {
    const extraUrl = '/check_use/nickname';
    final url = Uri.parse('$baseUrl$extraUrl?nickname=$nickname');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      return false;
    } else {
      throw Exception('Error,관리자에게 문의하세요');
    }
  }
}
