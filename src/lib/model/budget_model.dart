class BudgetModel {
  final int id;
  final int userId;
  int budgetAmount;
  // final int preBudget;

  BudgetModel({
    required this.id,
    required this.userId,
    required this.budgetAmount,
    // required this.preBudget,
  });

  // 사용자 정보를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'budget_amount': budgetAmount,
        // 'pre_budget': preBudget,
      };

  // JSON을 사용자 객체로 변환하는 메서드
  factory BudgetModel.fromJson(Map<String, dynamic> json) => BudgetModel(
        id: json['id'],
        userId: json['user_id'],
        budgetAmount: json['budget_amount'],
        // preBudget: json['pre_budget'],
      );
}
