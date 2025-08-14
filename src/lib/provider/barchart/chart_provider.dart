import 'package:flutter/material.dart';
import 'package:prob/api/total_consume_api.dart';
import 'package:prob/model/chart_model.dart';

class ChartProvider with ChangeNotifier {
  List<ChartModel>? _categoryConsume; // = totalForChart

  int? _touchedIndex;
  bool _showPieChart = true;
  bool _showDetail = false;
  final List<int> _chartCategories = []; // 차트 카테고리 수정 데이터 임시 저장용
  List<ChartModel>? _filteredList;
  List<ChartModel>? _mappedList;
  double? _total;

  List<ChartModel>? get categoryConsume => _categoryConsume;
  List<int> get chartCategories => _chartCategories;
  int? get touchedIndex => _touchedIndex;
  bool get showPieChart => _showPieChart;
  bool get showDetail => _showDetail;
  List<ChartModel>? get filteredList => _filteredList;
  List<ChartModel>? get mappedList => _mappedList;
  double? get total => _total;

  void setCategoryConsume(List<ChartModel>? categoryConsume) {
    _categoryConsume = categoryConsume;
    notifyListeners();
  }

  void setFilteredList(List<ChartModel>? filteredList) {
    _filteredList = filteredList;
    notifyListeners();
  }

  void setMappedList(List<ChartModel>? mappedList) {
    _mappedList = mappedList;
    notifyListeners();
  }

  void setTouchedIndex(int? touchedIndex) {
    _touchedIndex = touchedIndex;
    notifyListeners();
  }

  void setShowPieChart(bool toggle) {
    _showPieChart = toggle;
    _touchedIndex = null;
    _showDetail = false;
    notifyListeners();
  }

  void toggleShowDetail() {
    _showDetail = !_showDetail;
    notifyListeners();
  }

  void selectCategory(int category) {
    if (chartCategories.contains(category)) {
      chartCategories.remove(category);
    } else {
      chartCategories.add(category);
    }
    notifyListeners();
  }

  void clearSelections() {
    chartCategories.clear(); // 선택 목록 초기화
    notifyListeners();
  }

  void reFetchData(String? accessToken) {
    fetchData(accessToken);
    notifyListeners();
  }

  void calculateTotal() {
    double res =
        _filteredList!.fold(0.0, (sum, data) => sum + data.totalAmount);
    setTotal(res);
    notifyListeners();
  }

  void setTotal(double? total) {
    _total = total;
    notifyListeners();
  }

  void fetchData(String? accessToken) async {
    final categoryConsume = await TotalConsumeApi.readChartData(accessToken);
    setCategoryConsume(categoryConsume);
    final List<ChartModel> mappedList = [];

    for (var data in categoryConsume) {
      if (data.isFavorite) {
        mappedList.add(data);
      }
    }
    setMappedList(mappedList);

    final filteredList =
        categoryConsume.where((item) => item.totalAmount > 0).toList();
    setFilteredList(filteredList);
    calculateTotal();
  }
}
