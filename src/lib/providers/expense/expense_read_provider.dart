import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/providers/expense/expense_repository_provider.dart';

final monthlyTotalProvider = StreamProvider.family<int, DateTime>((ref, date) {
  final repo = ref.read(expenseRepositoryProvider);

  return repo.getMonthlyExpensesTotal(date);
});
