import 'package:drift/drift.dart';
import 'package:prob/db/database.dart';

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

  Future<List<Expense>> getMonthlyExpenses(DateTime date) async {
    final monthStart = DateTime(date.year, date.month, 1);
    final nextMonthStart = DateTime(date.year, date.month + 1, 1);

    final query = db.select(db.expenses)
      ..where((expenses) =>
          expenses.date.isBiggerOrEqualValue(monthStart) &
          expenses.date.isSmallerThanValue(nextMonthStart))
      ..orderBy([
        (expenses) => OrderingTerm.desc(expenses.date),
        (expenses) => OrderingTerm.desc(expenses.id)
      ]);

    return query.get();
  }
}
