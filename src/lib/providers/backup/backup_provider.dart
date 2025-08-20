import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/models/budget_model.dart';
import 'package:prob/models/expense_model.dart';
import 'package:prob/providers/app_database_provider.dart';
import 'package:prob/providers/budget/budget_provider.dart';
import 'package:prob/providers/budget/budget_repository_provider.dart';
import 'package:prob/providers/expense/expense_read_provider.dart';
import 'package:prob/providers/expense/expense_repository_provider.dart';
import 'package:prob/services/backup_service.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  final db = ref.read(appDatabaseProvider);
  final budgetRepo = ref.read(budgetRepositoryProvider);
  final expenseRepo = ref.read(expenseRepositoryProvider);

  return BackupService(db, budgetRepo, expenseRepo);
});

final currentBudgetModelProvider = Provider<BudgetModel?>((ref) {
  final budget = ref.watch(budgetProvider);

  if (budget == null || budget.month.isEmpty) return null;

  return BudgetModel(
    month: budget.month,
    limit: budget.limit,
    updatedAt: budget.updatedAt,
  );
});

final last3MonthModelsProvider =
    FutureProvider<List<ExpenseModel>>((ref) async {
  final rows = await ref.watch(last3MonthsProvider.future);

  return [
    for (final row in rows)
      ExpenseModel(
        id: row.id,
        date: row.date,
        amount: row.amount,
        vendor: row.vendor,
        categorySlug: row.categorySlug,
        memo: row.memo,
      ),
  ];
});
