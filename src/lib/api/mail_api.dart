import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupApi {
  static String baseUrl = "http://localhost:8000/mail";

  //인증번호 발급
  static Future<bool> createValidEmailNum(String email) async {
    const extraUrl = '/send/verify/email/background';
    final url = Uri.parse('$baseUrl$extraUrl');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "email": [email],
        }));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> validEmailNum(
    String email,
    String validCode,
  ) async {
    const extraUrl = '/verify/email_code';
    final url = Uri.parse('$baseUrl$extraUrl');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"email": email, "input_code": validCode}));

    if (response.statusCode == 200) {
      //print(response.body);
      return true;
    } else {
      return false;
      //throw Exception('get user failed. Token may have expired');
    }
  }
}
