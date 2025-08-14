import 'package:http/http.dart' as http;
import 'package:prob/model/hist_model.dart';
import 'dart:convert';
import 'package:prob/model/reqModel/add_consume_hist.dart';

class ConsumeHistApi {
  static String baseUrl = "http://localhost:8000/consume.history";

  static Future<List<HistModel>> addHist(
      AddConsumeHist addConsumeHist, String? token) async {
    const extraUrl = '/add/new_history';
    final url = Uri.parse(
        '$baseUrl$extraUrl?category_name=${addConsumeHist.categoryName}');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "receiver": addConsumeHist.content,
          "date": addConsumeHist.date,
          "amount": addConsumeHist.amount,
          "installment": addConsumeHist.installment,
          "card": addConsumeHist.card,
        }));

    if (response.statusCode == 200) {
      final List<dynamic> consumeHistList =
          json.decode(utf8.decode(response.bodyBytes));
      // print(consumeHistList);
      List<HistModel> histModels =
          consumeHistList.map((data) => HistModel.fromJson(data)).toList();
      return histModels;
    } else {
      throw Exception('요청 실패. 관리자에게 문의하세요.');
    }
  }

  //수정
  static Future<List<HistModel>> editHist(
      AddConsumeHist addConsumeHist, String? token, int editItemId) async {
    const extraUrl = '/edit/history/';
    final url = Uri.parse(
        '$baseUrl$extraUrl?category_name=${addConsumeHist.categoryName}');
    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "receiver": addConsumeHist.content,
          "date": addConsumeHist.date,
          "amount": addConsumeHist.amount,
          "installment": addConsumeHist.installment,
          "card": addConsumeHist.card,
          "editItemId": editItemId,
        }));

    if (response.statusCode == 200) {
      final List<dynamic> consumeHistList =
          json.decode(utf8.decode(response.bodyBytes));
      // print(consumeHistList);
      List<HistModel> histModels =
          consumeHistList.map((data) => HistModel.fromJson(data)).toList();
      return histModels;
    } else {
      throw Exception('수정 실패');
    }
  }

  //조회
  static Future<Map<String, List<HistModel>>> getHist(String? token) async {
    final url = Uri.parse(baseUrl);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> consumeHistList =
          json.decode(utf8.decode(response.bodyBytes));
      // print(consumeHistList);
      Map<String, List<HistModel>> histModelsMap = {};

      for (var monthlyData in consumeHistList) {
        // monthlyData는 {"YYYY-MM": [...] } 형태의 Map이므로 key, value로 분리
        monthlyData.forEach((yearMonth, dataList) {
          // dataList를 List<HistModel>로 변환
          List<HistModel> histModels = (dataList != null && dataList is List)
              ? dataList.map((hist) => HistModel.fromJson(hist)).toList()
              : [];

          histModelsMap[yearMonth] = histModels; // key는 YYYY-MM 형식
        });
      }
      // print(histModelsMap);
      return histModelsMap;
    } else if (response.statusCode == 404) {
      return {};
    } else {
      throw Exception('요청 실패. 관리자에게 문의하세요.');
    }
  }

  //삭제
  static Future<List<HistModel>> removeHist(int histId, String? token) async {
    final url = Uri.parse('$baseUrl/$histId');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> consumeHistList =
          json.decode(utf8.decode(response.bodyBytes));
      // print(consumeHistList);
      List<HistModel> histModels =
          consumeHistList.map((data) => HistModel.fromJson(data)).toList();
      return histModels;
    } else {
      throw Exception('요청 실패. 관리자에게 문의하세요.');
    }
  }
}
