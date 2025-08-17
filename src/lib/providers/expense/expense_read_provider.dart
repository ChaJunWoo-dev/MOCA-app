import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/providers/expense/expense_repository_provider.dart';

final monthlyTotalProvider = StreamProvider.family<int, DateTime>((ref, date) {
  final repo = ref.read(expenseRepositoryProvider);

  return repo.getMonthlyExpensesTotal(date);
});

final total3MonthProvider =
    FutureProvider.family<List<int>, DateTime>((ref, base) async {
  final monthKeys = [
    DateTime(base.year, base.month - 1, 1),
    DateTime(base.year, base.month - 2, 1),
    DateTime(base.year, base.month - 3, 1),
  ];

  return Future.wait(
    monthKeys.map((key) => ref.watch(monthlyTotalProvider(key).future)),
  );
});
