import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/providers/app_database_provider.dart';
import 'package:prob/repositories/expense_repository.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final db = ref.read(appDatabaseProvider);

  return ExpenseRepository(db);
});
