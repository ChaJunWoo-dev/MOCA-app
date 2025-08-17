import 'package:prob/db/database.dart';

class BudgetRepository {
  final AppDatabase db;

  BudgetRepository(this.db);

  String getYearMonth() {
    final now = DateTime.now();

    return "${now.year}-${now.month.toString().padLeft(2, '0')}";
  }

  Future<Budget?> getBudget() {
    return (db.select(db.budgets)
          ..where((t) => t.month.equals(getYearMonth()))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> upsert(BudgetsCompanion data) async =>
      await db.into(db.budgets).insertOnConflictUpdate(data);
}
