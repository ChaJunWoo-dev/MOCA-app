import 'package:drift/drift.dart';
import 'package:prob/db/database.dart';
import 'package:prob/models/expense_model.dart';

class ExpenseRepository {
  final AppDatabase db;

  ExpenseRepository(this.db);

  Future<void> insertExpense(ExpensesCompanion data) =>
      db.into(db.expenses).insert((data));

  Stream<int> getMonthlyExpensesTotal(DateTime date) {
    final monthStart = DateTime(date.year, date.month, 1);
    final nextMonthStart = DateTime(date.year, date.month + 1, 1);

    final amountSum = db.expenses.amount.sum();
    final query = db.selectOnly(db.expenses)
      ..addColumns([amountSum])
      ..where(db.expenses.date.isBiggerOrEqualValue(monthStart) &
          db.expenses.date.isSmallerThanValue(nextMonthStart));

    return query.watchSingle().map(
          (row) => row.read(amountSum) ?? 0,
        );
  }

  Stream<List<Expense>> getMonthlyExpenses(DateTime date) {
    final start = DateTime(date.year, date.month, 1);
    final end = DateTime(date.year, date.month + 1, 1);

    final query = db.select(db.expenses)
      ..where((expense) =>
          expense.date.isBiggerOrEqualValue(start) &
          expense.date.isSmallerThanValue(end))
      ..orderBy([
        (expense) => OrderingTerm.desc(expense.date),
        (expense) => OrderingTerm.desc(expense.id),
      ]);

    return query.watch();
  }

  Future<List<Expense>> getExpensesInRange(DateTime start, DateTime end) {
    final query = (db.select(db.expenses)
      ..where((expense) =>
          expense.date.isBiggerOrEqualValue(start) &
          expense.date.isSmallerThanValue(end))
      ..orderBy([
        (expense) => OrderingTerm.desc(expense.date),
        (expense) => OrderingTerm.desc(expense.id),
      ]));
    return query.get();
  }

  Future<void> replaceAll(List<ExpenseModel> expenses) async {
    await db.delete(db.expenses).go();
    await db.batch((batch) {
      batch.insertAll(
        db.expenses,
        expenses
            .map((expense) => ExpensesCompanion(
                  id: Value(expense.id),
                  date: Value(expense.date),
                  amount: Value(expense.amount),
                  vendor: Value(expense.vendor),
                  categorySlug: Value(expense.categorySlug),
                  memo: Value(expense.memo),
                ))
            .toList(),
      );
    });
  }
}
