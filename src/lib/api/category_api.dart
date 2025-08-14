import 'package:http/http.dart' as http;
import 'package:prob/model/all_cate_model.dart';
import 'dart:convert';

import 'package:prob/model/categories_model.dart';

class CategoryApi {
  static String baseUrl = "http://localhost:8000/category";
  //유저 카테고리 조회
  static Future<List<CategoriesModel>> readCategories(String? token) async {
    const extraUrl = '/categories';
    final url = Uri.parse(baseUrl + extraUrl);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse
          .map((data) => CategoriesModel.fromJson(data))
          .toList();
    } else {
      return [];
    }
  }

  //모든 카테고리 조회(login 안해도 조회 가능)
  static Future<List<AllCateModel>> readAllCategories() async {
    const extraUrl = '/all_categories';
    final url = Uri.parse(baseUrl + extraUrl);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((data) => AllCateModel.fromJson(data)).toList();
    } else {
      throw Exception('전체 카테고리 조회 실패');
    }
  }

  //유저 카테고리 수정(수정필요)
  static Future<List<CategoriesModel>> updateCategories() async {
    const extraUrl = '/update/categories';
    final url = Uri.parse(baseUrl + extraUrl);
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse
          .map((data) => CategoriesModel.fromJson(data))
          .toList();
    } else {
      throw Exception('수정 실패');
    }
  }

  //바 차트 선택 카테고리 업데이트
  static Future<bool> updateUserCategories(
      List<int>? updateList, String? token) async {
    const extraUrl = '/udpate/bar_chart.categories';
    final url = Uri.parse(baseUrl + extraUrl);
    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"updated_list": updateList}));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
      // throw Exception('차트 카테고리 업데이트 실패');
    }
  }

  static Future<List<CategoriesModel>> readBarChartCategories(
      String? token) async {
    const extraUrl = '/categories/for_chart/data';
    final url = Uri.parse(baseUrl + extraUrl);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse
          .map((data) => CategoriesModel.fromJson(data))
          .toList();
    } else {
      throw Exception('get user failed. Token may have expired');
    }
  }
}
