import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileApi {
  static String baseUrl = "http://localhost:8000";

  static Future<dynamic> changePassword(
      String password, String newPassword, String? token) async {
    const extraUrl = '/users/update/password';
    final url = Uri.parse('$baseUrl$extraUrl');
    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"passwd": password, "new_passwd": newPassword}));

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      return false;
    } else {
      throw Exception('get user failed. Token may have expired');
    }
  }

  //닉네임 변경
  static Future<dynamic> changeNickname(
      String newNickname, String? token) async {
    const extraUrl = '/users/update/nickname';
    final url = Uri.parse('$baseUrl$extraUrl');
    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"new_nickname": newNickname}));

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      return false;
    } else {
      throw Exception('get user failed. Token may have expired');
    }
  }

  //현재 비밀번호 검증
  static Future<dynamic> confirmCurrentPassword(
      String password, String? token) async {
    const extraUrl = '/users/confirm/password';
    final url = Uri.parse('$baseUrl$extraUrl');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "passwd": password,
        }));

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      return false;
    } else {
      throw Exception('에러 발생. 관리자에게 문의하세요');
    }
  }
}
