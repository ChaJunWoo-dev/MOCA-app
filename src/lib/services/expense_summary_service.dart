class ExpenseSummaryData {
  final int lastMonthTotal;
  final int threeMonthAverage;

  ExpenseSummaryData({
    required this.lastMonthTotal,
    required this.threeMonthAverage,
  });
}

class ExpenseSummaryService {
  static ExpenseSummaryData processMonthlyTotals(List<int> monthlyTotals) {
    final values = monthlyTotals.length >= 3
        ? monthlyTotals
        : List<int>.filled(3 - monthlyTotals.length, 0) + monthlyTotals;

    final lastMonthTotal = values.length >= 2 ? values[values.length - 2] : 0;
    final threeMonthAverage =
        values.isEmpty ? 0 : ((values[0] + values[1] + values[2]) / 3).round();

    return ExpenseSummaryData(
      lastMonthTotal: lastMonthTotal,
      threeMonthAverage: threeMonthAverage,
    );
  }

  static ({DateTime startDate, DateTime endDate}) getThreeMonthRange() {
    final now = DateTime.now();
    final nextMonthStart = DateTime(now.year, now.month + 1, 1);
    final last3MonthsStart = DateTime(now.year, now.month - 2, 1);

    return (
      startDate: last3MonthsStart,
      endDate: nextMonthStart,
    );
  }
}
