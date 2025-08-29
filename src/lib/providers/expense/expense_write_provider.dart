import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/db/database.dart';
import 'package:prob/providers/expense/expense_notifier.dart';
import 'package:prob/providers/repository_providers.dart';

final expenseWriteProvider =
    StateNotifierProvider<ExpenseNotifier, Expense?>((ref) {
  final repo = ref.read(expenseRepositoryProvider);

  return ExpenseNotifier(repo);
});
