class BudgetModel {
  final int id;
  final int userId;
  int budgetAmount;

  BudgetModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['user_id'],
        budgetAmount = json['budget_amount'];

  BudgetModel({
    required this.id,
    required this.userId,
    required this.budgetAmount,
  });
}
