import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:prob/model/chart_model.dart';

class TotalConsumeApi {
  static String baseUrl = "http://localhost:8000/total";

  //for chart this month total consume 기능 제거
  // static Future<List<ChartModel>> readTotalForChart(String? token) async {
  //   const extraUrl = '/get/category/total/consume';
  //   final url = Uri.parse(baseUrl + extraUrl);
  //   final response = await http.get(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
  //     final List<ChartModel> chartData =
  //         data.map((json) => ChartModel.fromJson(json)).toList();
  //     return chartData;
  //   } else {
  //     throw Exception(
  //         'get user or get total_consume failed. Token may have expired');
  //   }
  // }

  //기간 소비 조회
  static Future<dynamic> readPreiodTotal(
      String startDate, String endDate, String? token) async {
    const extraUrl = '/get/total/consume/period';
    final url =
        Uri.parse('$baseUrl$extraUrl?startDate=$startDate&endDate=$endDate');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      // 응답이 int일 경우 그대로 반환
      if (parsedResponse is int) {
        return parsedResponse;
      }
      // 응답이 String으로 오는 경우 int로 파싱
      else if (parsedResponse is String) {
        return int.parse(parsedResponse);
      } else {
        return throw Exception('Unexpected response format: $parsedResponse');
      }
    } else {
      return false;
    }
  }

  //한 달 소비 조회(이번달 or 저번달)
  static Future<int> readPreiodTotalMWD(String MWD, String? token) async {
    const extraUrl = '/get/total/consume/period_this_MWD';
    final url = Uri.parse('$baseUrl$extraUrl?MWD=$MWD');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      // 응답이 int일 경우 그대로 반환
      if (parsedResponse is int) {
        return parsedResponse;
      }
      // 응답이 String으로 오는 경우 int로 파싱
      else if (parsedResponse is String) {
        return int.parse(parsedResponse);
      } else {
        return throw Exception('Unexpected response format: $parsedResponse');
      }
    } else {
      throw Exception('한 달 소비 조회 실패');
    }
  }

  //for bar chart
  static Future<List<ChartModel>> readChartData(String? token) async {
    const extraUrl = '/get/total/consume/chart';
    final url = Uri.parse(baseUrl + extraUrl);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      final List<ChartModel> chartData =
          data.map((json) => ChartModel.fromJson(json)).toList();
      return chartData;
    } else {
      throw Exception(
          'get user or get total_consume failed. Token may have expired');
    }
  }
}
