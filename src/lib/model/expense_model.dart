class ExpenseModel {
  final int id;
  final DateTime date;
  final int amount;
  final String title;
  final String category;
  final String? memo;
  final String? account;

  const ExpenseModel({
    required this.id,
    required this.date,
    required this.amount,
    required this.title,
    required this.category,
    this.memo,
    this.account,
  });

  ExpenseModel.fromMap(Map<String, dynamic> map)
      : id = map['id'] as int,
        date = DateTime.parse(map['date'] as String),
        amount = map['amount'] as int,
        title = map['title'] as String,
        category = map['category'] as String,
        memo = map['memo'] as String?,
        account = map['account'] as String?;
}
