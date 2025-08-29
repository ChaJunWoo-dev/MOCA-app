import 'package:drift/drift.dart';
import 'package:prob/db/database.dart';
import 'package:prob/models/expense_model.dart';
import 'package:prob/utils/date_utils.dart';
import 'package:prob/utils/type.dart';

class ExpenseRepository {
  final AppDatabase db;

  ExpenseRepository(this.db);

  Future<void> insertExpense(ExpensesCompanion data) =>
      db.into(db.expenses).insert((data));

  Future<void> deleteExpenseById(int id) async {
    await (db.delete(db.expenses)..where((expense) => expense.id.equals(id)))
        .go();
  }

  Future<void> updateExpenseById(int id, ExpensesCompanion data) async {
    await (db.update(db.expenses)..where((expense) => expense.id.equals(id)))
        .write(data);
  }

  Future<void> replaceAll(List<ExpenseModel> expenses) async {
    await db.delete(db.expenses).go();
    await db.batch((batch) {
      batch.insertAll(
        db.expenses,
        expenses.map((expense) => expense.toCompanion()).toList(),
      );
    });
  }

  Stream<int> getMonthlyExpensesTotal(DateTime date) {
    final monthStart = AppDateUtils.getMonthStart(date);
    final nextMonthStart = AppDateUtils.getNextMonthStart(date);

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
    final start = AppDateUtils.getMonthStart(date);
    final end = AppDateUtils.getNextMonthStart(date);

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

  Stream<List<Expense>> watchExpensesInRange(DateTime start, DateTime end) {
    final query = (db.select(db.expenses)
      ..where((expense) =>
          expense.date.isBiggerOrEqualValue(start) &
          expense.date.isSmallerThanValue(end))
      ..orderBy([
        (expense) => OrderingTerm.desc(expense.date),
        (expense) => OrderingTerm.desc(expense.id),
      ]));
    return query.watch();
  }

  Stream<List<int>> getRangeMonthsTotal(DateRange dateRange) {
    final startMonth = AppDateUtils.getMonthStart(dateRange.startDate);
    final endMonth = AppDateUtils.getMonthStart(dateRange.endDate);
    final rowsStream = (db.select(db.expenses)
          ..where((expense) =>
              expense.date.isBiggerOrEqualValue(startMonth) &
              expense.date.isSmallerThanValue(endMonth)))
        .watch();

    final result = rowsStream.map((rows) {
      final totalsByMonth = <DateTime, int>{};

      for (final row in rows) {
        final date = row.date;
        final key = AppDateUtils.getMonthStart(date);

        totalsByMonth[key] = (totalsByMonth[key] ?? 0) + row.amount;
      }

      final monthCount = AppDateUtils.calculateMonthCount(startMonth, endMonth);

      return List.generate(monthCount, (i) {
        final current = AppDateUtils.getMonthStart(
            AppDateUtils.addMonths(startMonth, i));

        return totalsByMonth[current] ?? 0;
      });
    });

    return result;
  }
}
