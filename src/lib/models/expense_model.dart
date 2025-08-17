class ExpenseModel {
  final int id;
  final DateTime date;
  final int amount;
  final String vendor;
  final String? categorySlug;
  final String? memo;

  const ExpenseModel({
    required this.id,
    required this.date,
    required this.amount,
    required this.vendor,
    required this.categorySlug,
    this.memo,
  });

  ExpenseModel.fromMap(Map<String, dynamic> map)
      : id = map['id'] as int,
        date = DateTime.parse(map['date'] as String),
        amount = map['amount'] as int,
        vendor = map['vendor'] as String,
        categorySlug = map['categorySlug'] as String?,
        memo = map['memo'] as String?;
}
