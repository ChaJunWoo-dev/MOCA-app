import 'package:prob/constants/date_constants.dart';

class AppDateUtils {
  static DateTime getMonthStart(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime getNextMonthStart(DateTime date) {
    return DateTime(date.year, date.month + 1, 1);
  }

  static DateTime getStatisticsStartDate([DateTime? baseDate]) {
    final now = baseDate ?? DateTime.now();

    return DateTime(
        now.year, now.month - (DateConstants.statisticsMonths - 1), 1);
  }

  static DateTime getStatisticsEndDate([DateTime? baseDate]) {
    final now = baseDate ?? DateTime.now();

    return getNextMonthStart(now);
  }

  static DateTime getUiDateLimit([DateTime? baseDate]) {
    final now = baseDate ?? DateTime.now();

    return DateTime(
        now.year, now.month - DateConstants.uiDateLimitMonths, now.day);
  }

  static DateTime getToday([DateTime? baseDate]) {
    final now = baseDate ?? DateTime.now();

    return DateTime(now.year, now.month, now.day);
  }

  static DateTime addMonths(DateTime date, int months) {
    return DateTime(date.year, date.month + months, date.day);
  }

  static int calculateMonthCount(DateTime startMonth, DateTime endMonth) {
    return (endMonth.year - startMonth.year) * DateConstants.monthsPerYear +
        (endMonth.month - startMonth.month);
  }
}
