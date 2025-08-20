import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/db/database.dart';
import 'package:prob/providers/expense/expense_repository_provider.dart';
import 'package:prob/utils/type.dart';

final monthlyTotalProvider = StreamProvider.family<int, DateTime>((ref, date) {
  final repo = ref.read(expenseRepositoryProvider);

  return repo.getMonthlyExpensesTotal(date);
});

final totalRangeMonthProvider =
    StreamProvider.family<List<int>, DateRange>((ref, dateRange) {
  final repo = ref.read(expenseRepositoryProvider);

  return repo.getRangeMonthsTotal(dateRange);
});

final monthlyExpensesProvider =
    StreamProvider.family<List<Expense>, DateTime>((ref, base) {
  final repo = ref.read(expenseRepositoryProvider);

  return repo.getMonthlyExpenses(base);
});

class DailyGroup {
  final DateTime day;
  final int total;
  final List<Expense> items;
  const DailyGroup(this.day, this.total, this.items);
}

final dailyGroupsProvider =
    Provider.family<AsyncValue<List<DailyGroup>>, DateTime>((ref, base) {
  final expenses = ref.watch(monthlyExpensesProvider(base));

  return expenses.whenData((expenseList) {
    final expenseMap = <DateTime, List<Expense>>{};

    for (final expense in expenseList) {
      final date = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );
      (expenseMap[date] ??= []).add(expense);
    }

    final groups = expenseMap.entries.map((entry) {
      final total = entry.value.fold(
        0,
        (sum, expense) => sum + expense.amount,
      );

      return DailyGroup(entry.key, total, entry.value);
    }).toList()
      ..sort((a, b) => b.day.compareTo(a.day));

    return groups;
  });
});

final last3MonthsProvider = FutureProvider<List<Expense>>((ref) async {
  final repo = ref.read(expenseRepositoryProvider);
  final now = DateTime.now();
  final start = DateTime(now.year, now.month - 2, 1);
  final end = DateTime(now.year, now.month + 1, 1);

  return repo.getExpensesInRange(start, end);
});
