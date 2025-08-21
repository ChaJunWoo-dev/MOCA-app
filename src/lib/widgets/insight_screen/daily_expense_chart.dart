import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:prob/db/database.dart';

class DailyExpenseChart extends StatelessWidget {
  final List<Expense> expenses;

  const DailyExpenseChart({
    super.key,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = today.subtract(const Duration(days: 13));
    final end = today.add(const Duration(days: 1));
    final totalsWon = List<int>.filled(14, 0);

    for (final expense in expenses) {
      final date = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );

      if (!date.isBefore(start) && date.isBefore(end)) {
        final index = date.difference(start).inDays;

        if (index >= 0 && index < 14) totalsWon[index] += expense.amount;
      }
    }

    final groups = <BarChartGroupData>[];
    double maxManwon = 0;

    for (int i = 0; i < 14; i++) {
      final manwon = totalsWon[i] / 10000.0;

      if (manwon > maxManwon) maxManwon = manwon;

      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: manwon,
              width: 14,
              borderRadius: BorderRadius.circular(2),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      );
    }

    double niceStep(double target) {
      if (target <= 0) return 1.0;

      const c = [1.0, 2.0, 5.0, 10.0, 20.0, 50.0, 100.0, 200.0, 500.0, 1000.0];

      for (final s in c) {
        if (s >= target) return s;
      }
      return c.last;
    }

    final step = niceStep(maxManwon / 4.0);
    final safeMaxY =
        maxManwon == 0 ? 1.0 : ((maxManwon / step).ceil() + 1) * step;
    final yInterval = step;

    return AspectRatio(
      aspectRatio: 1.8,
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: safeMaxY,
          barGroups: groups,
          alignment: BarChartAlignment.spaceBetween,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48,
                interval: yInterval,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const SizedBox.shrink();

                  return Text(
                    '${value.toStringAsFixed(0)}만',
                    style: const TextStyle(fontSize: 11),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();

                  if (idx < 0 || idx >= 14) return const SizedBox.shrink();

                  final date = start.add(Duration(days: idx));

                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${date.day}',
                      style: const TextStyle(fontSize: 11),
                    ),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) =>
                  Theme.of(context).primaryColor.withAlpha(100),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                if (rod.toY == 0) return null;

                final date = start.add(Duration(days: group.x));

                return BarTooltipItem(
                  '${date.month}/${date.day}\n${rod.toY.toStringAsFixed(1)}만원',
                  const TextStyle(fontWeight: FontWeight.w600),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
