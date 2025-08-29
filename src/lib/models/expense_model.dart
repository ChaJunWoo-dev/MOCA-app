import 'package:drift/drift.dart';
import 'package:prob/db/database.dart';

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount,
      'vendor': vendor,
      'categorySlug': categorySlug,
      'memo': memo,
    };
  }

  ExpensesCompanion toCompanion() {
    return ExpensesCompanion(
      id: Value(id),
      date: Value(date),
      amount: Value(amount),
      vendor: Value(vendor),
      categorySlug: Value(categorySlug),
      memo: Value(memo),
    );
  }
}
