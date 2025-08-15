import 'package:prob/db/database.dart';

final database = AppDatabase();

Future<void> upsertBudget(BudgetsCompanion budget) async {
  await database.into(database.budgets).insertOnConflictUpdate(budget);
}

Future<Budget?> getBudget() async {
  final result = await database.select(database.budgets).get();

  return result.isNotEmpty ? result.first : null;
}
