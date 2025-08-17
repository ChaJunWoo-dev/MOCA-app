import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/providers/app_database_provider.dart';
import 'package:prob/repositories/budget_repository.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final db = ref.read(appDatabaseProvider);

  return BudgetRepository(db);
});
