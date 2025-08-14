import 'package:flutter/material.dart';
import 'package:prob/api/category_api.dart';
import 'package:prob/model/categories_model.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoriesModel> _userCategory = [];
  List<CategoriesModel> get userCategory => _userCategory;

  void setCategory(List<CategoriesModel> userCategory) {
    _userCategory = userCategory;
    notifyListeners();
  }

  void sortCategoryByVisible() {
    userCategory.sort((a, b) {
      // true가 앞에 오도록 정렬
      if (a.visible && !b.visible) return -1;
      if (!a.visible && b.visible) return 1;
      return 0;
    });
  }

  void toggleVisibile(int subId) {
    final index = userCategory.indexWhere((cat) => cat.subId == subId);
    if (index != -1) {
      userCategory[index] = CategoriesModel(
        subId: userCategory[index].subId,
        name: userCategory[index].name,
        icon: userCategory[index].icon,
        color: userCategory[index].color,
        chart: userCategory[index].chart,
        visible: !userCategory[index].visible,
      );
      sortCategoryByVisible();
      notifyListeners();
    }
  }

  Future<void> fetchCategories(BuildContext context) async {
    try {
      // AuthProvider에서 토큰 유효성 확인 및 재발급 처리
      final authProvider = context.read<AuthProvider>();
      bool isTokenValid = await authProvider.checkAndRefreshToken();

      if (!isTokenValid) {
        return;
      }
      final accessToken = authProvider.accessToken;
      final data = await CategoryApi.readCategories(accessToken);
      _userCategory = data;
      notifyListeners(); // UI 갱신 알림
    } catch (e) {
      throw Exception(e);
    }
  }
}
