import 'package:flutter/material.dart';
import 'package:prob/model/budget_model.dart';

class BudgetProvider with ChangeNotifier {
  BudgetModel? _budgetData;
  RemainBudget? _remainBudget;

  BudgetModel? get budgetData => _budgetData;
  RemainBudget? get remainBudget => _remainBudget;

  void setBudget(BudgetModel budgetModel) {
    _budgetData = budgetModel;
    notifyListeners();
  }

  void setBudgetAmount(int budgetAmount) {
    _budgetData!.budgetAmount = budgetAmount;
    notifyListeners();
  }

  void setRemainBudget(RemainBudget remainBudget) {
    _remainBudget = remainBudget;
    notifyListeners();
  }
}

class RemainBudget {
  final int week;
  final int month;

  RemainBudget({
    required this.week,
    required this.month,
  });
}
