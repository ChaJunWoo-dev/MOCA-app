import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/providers/app_database_provider.dart';
import 'package:prob/providers/budget/budget_repository_provider.dart';
import 'package:prob/providers/expense/expense_repository_provider.dart';
import 'package:prob/services/backup_service.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  final db = ref.read(appDatabaseProvider);
  final budgetRepo = ref.read(budgetRepositoryProvider);
  final expenseRepo = ref.read(expenseRepositoryProvider);

  return BackupService(db, budgetRepo, expenseRepo);
});
