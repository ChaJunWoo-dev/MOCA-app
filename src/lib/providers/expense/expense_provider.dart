import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/db/database.dart';
import 'package:prob/providers/repository_providers.dart';
import 'package:prob/repositories/expense_repository.dart';
import 'package:prob/utils/date_utils.dart';
import 'package:prob/utils/type.dart';

final monthlyTotalProvider = StreamProvider.family<int, DateTime>((ref, date) {
  final repo = ref.read(expenseRepositoryProvider);

  return repo.getMonthlyExpensesTotal(date);
});

final rangeMonthsTotalProvider =
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

final last3MonthsExpensesProvider = StreamProvider<List<Expense>>((ref) {
  final repo = ref.read(expenseRepositoryProvider);
  final start = AppDateUtils.getStatisticsStartDate();
  final end = AppDateUtils.getStatisticsEndDate();

  return repo.watchExpensesInRange(start, end);
});

class ExpenseNotifier extends StateNotifier<Expense?> {
  ExpenseNotifier(this._repo) : super(null);

  final ExpenseRepository _repo;

  Future<void> save(ExpensesCompanion data) async {
    await _repo.insertExpense(data);
  }
}

final expenseWriteProvider =
    StateNotifierProvider<ExpenseNotifier, Expense?>((ref) {
  final repo = ref.read(expenseRepositoryProvider);

  return ExpenseNotifier(repo);
});