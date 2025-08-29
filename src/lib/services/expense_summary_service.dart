import 'package:prob/constants/date_constants.dart';
import 'package:prob/utils/date_utils.dart';

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
    final values = monthlyTotals.length >= DateConstants.statisticsMonths
        ? monthlyTotals
        : List<int>.filled(
                DateConstants.statisticsMonths - monthlyTotals.length, 0) +
            monthlyTotals;

    final lastMonthTotal = values.length >= 2 ? values[values.length - 2] : 0;
    final threeMonthAverage = values.isEmpty
        ? 0
        : (values.take(DateConstants.statisticsMonths).reduce((a, b) => a + b) /
                DateConstants.statisticsMonths)
            .round();

    return ExpenseSummaryData(
      lastMonthTotal: lastMonthTotal,
      threeMonthAverage: threeMonthAverage,
    );
  }

  static ({DateTime startDate, DateTime endDate}) getThreeMonthRange() {
    return (
      startDate: AppDateUtils.getStatisticsStartDate(),
      endDate: AppDateUtils.getStatisticsEndDate(),
    );
  }
}
