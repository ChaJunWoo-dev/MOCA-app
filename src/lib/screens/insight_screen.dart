import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/db/database.dart';
import 'package:prob/providers/expense/expense_read_provider.dart';
import 'package:prob/widgets/common/app_speed_dial.dart';
import 'package:prob/widgets/common/my_app_bar.dart';
import 'package:prob/widgets/insight_screen/category_pie_chart.dart';
import 'package:prob/widgets/insight_screen/daily_expense_chart.dart';

class InsightScreen extends ConsumerWidget {
  const InsightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(last3MonthsProvider);

    return Scaffold(
      floatingActionButton: const AppSpeedDial(),
      appBar: const MyAppBar(
        text: '통계',
        weight: FontWeight.bold,
      ),
      body: expensesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => const Center(child: Text('데이터를 가져오는 데 실패했어요')),
        data: (List<Expense> expenses) {
          final now = DateTime.now();
          final start = DateTime(now.year, now.month, 1);
          final end = DateTime(now.year, now.month + 1, 1);
          final thisMonth = expenses
              .where(
                (expense) =>
                    !expense.date.isBefore(start) && expense.date.isBefore(end),
              )
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: Colors.grey.shade100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '이번 달 카테고리별 지출',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        CategoryPieTop5(expenses: thisMonth),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: Colors.grey.shade100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '최근 14일 지출',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        DailyExpenseChart(expenses: expenses),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }
}
