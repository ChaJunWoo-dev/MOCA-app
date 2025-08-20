class BudgetModel {
  final String month;
  final int limit;
  final DateTime updatedAt;

  const BudgetModel({
    required this.month,
    required this.limit,
    required this.updatedAt,
  });

  BudgetModel.fromMap(Map<String, dynamic> map)
      : month = map['month'] as String,
        limit = map['limit'] as int,
        updatedAt = DateTime.parse(map['updatedAt'] as String);

  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'limit': limit,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
