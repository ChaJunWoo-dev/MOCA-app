import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/providers/repository_providers.dart';
import 'package:prob/providers/budget/budget_notifier.dart';
import 'package:prob/db/database.dart';

final budgetProvider = StateNotifierProvider<BudgetNotifier, Budget?>((ref) {
  final repo = ref.read(budgetRepositoryProvider);

  return BudgetNotifier(repo);
});
