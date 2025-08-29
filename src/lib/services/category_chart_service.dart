import 'package:prob/db/database.dart';

class CategoryChartData {
  final String categorySlug;
  final String categoryName;
  final int amount;
  final double percent;

  CategoryChartData({
    required this.categorySlug,
    required this.categoryName,
    required this.amount,
    required this.percent,
  });
}

class CategoryChartService {
  static List<CategoryChartData> processExpensesForChart(
    List<Expense> expenses,
    Map<String, Category> categoryMap, {
    int topCount = 5,
  }) {
    if (expenses.isEmpty) return [];

    final groupedAmounts = <String, int>{};

    for (final expense in expenses) {
      final categorySlug = expense.categorySlug ?? '미분류';

      groupedAmounts[categorySlug] =
          (groupedAmounts[categorySlug] ?? 0) + expense.amount;
    }

    final total = groupedAmounts.values.fold<int>(0, (a, b) => a + b);

    if (total == 0) return [];

    final sortedEntries = groupedAmounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final result = <CategoryChartData>[];

    final topEntries = sortedEntries.take(topCount).toList();

    for (final entry in topEntries) {
      final percent = (entry.value / total * 100);
      final categoryName = categoryMap[entry.key]?.name ?? entry.key;

      result.add(CategoryChartData(
        categorySlug: entry.key,
        categoryName: categoryName,
        amount: entry.value,
        percent: percent,
      ));
    }

    final etcSum = sortedEntries
        .skip(topCount)
        .fold<int>(0, (sum, entry) => sum + entry.value);

    if (etcSum > 0) {
      final etcPercent = (etcSum / total * 100);
      result.add(CategoryChartData(
        categorySlug: '기타',
        categoryName: '기타',
        amount: etcSum,
        percent: etcPercent,
      ));
    }

    return result;
  }
}
