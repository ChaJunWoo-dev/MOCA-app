import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/db/database.dart';
import 'package:prob/providers/expense/expense_notifier.dart';
import 'package:prob/providers/expense/expense_repository_provider.dart';

final expenseProvider = StateNotifierProvider<ExpenseNotifier, Expense?>((ref) {
  final repo = ref.read(expenseRepositoryProvider);

  return ExpenseNotifier(repo);
});
