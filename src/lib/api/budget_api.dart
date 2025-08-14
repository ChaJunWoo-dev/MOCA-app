import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:prob/model/budget_model.dart';

class BudgetApi {
  static String baseUrl = "http://localhost:8000/budgets";

  static Future<BudgetModel> readBudget(String? token) async {
    const extraUrl = '/get/budget';
    final url = Uri.parse(baseUrl + extraUrl);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return BudgetModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('예산 가져오기 실패');
    }
  }

  static Future<BudgetModel> updateBudget(String? token, int newBudget) async {
    const extraUrl = '/update/budget/byId';
    final url = Uri.parse(baseUrl + extraUrl);
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'new_budget': newBudget}),
    );

    if (response.statusCode == 200) {
      return BudgetModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('예산 업데이트 실패');
    }
  }
}
