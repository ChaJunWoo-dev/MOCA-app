import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:prob/constants/categories_data.dart';
import 'package:prob/db/database.dart';
import 'package:prob/utils/money_format.dart';

class CategoryPieTop5 extends StatelessWidget {
  final List<Expense> expenses;
  final double smallCutoffPercent;

  const CategoryPieTop5({
    super.key,
    required this.expenses,
    this.smallCutoffPercent = 5,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, num> group(List<Expense> expense) {
      final group = <String, num>{};

      for (final expense in expense) {
        final categorySlug = expense.categorySlug ?? '미분류';

        group[categorySlug] = (group[categorySlug] ?? 0) + expense.amount;
      }
      return group;
    }

    final grouped = group(expenses);
    final total = grouped.values.fold<num>(0, (a, b) => a + b);
    final sorted = grouped.entries.toList()
      ..sort(
        (a, b) => b.value.compareTo(a.value),
      );
    final top = sorted.take(5).toList();
    final etcSum = sorted.skip(5).fold<num>(
          0,
          (sum, entry) => sum + entry.value,
        );

    final palette = [
      Colors.redAccent,
      Colors.blueAccent,
      Colors.green,
      Colors.purple,
      Colors.teal,
    ];

    final slices = <_CategorySlice>[];

    for (int i = 0; i < top.length; i++) {
      final categoryEntry = top[i];
      final percent = total == 0 ? 0.0 : (categoryEntry.value / total * 100);
      final name =
          categoriesData[categoryEntry.key]?['name'] ?? categoryEntry.key;

      slices.add(_CategorySlice(
        name: name,
        color: palette[i % palette.length],
        value: categoryEntry.value.toDouble(),
        percent: percent,
      ));
    }

    if (etcSum > 0) {
      final percent = total == 0 ? 0.0 : (etcSum / total * 100);

      slices.add(_CategorySlice(
        name: '기타',
        color: Colors.grey,
        value: etcSum.toDouble(),
        percent: percent,
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 1.6,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 40,
              sectionsSpace: 2,
              borderData: FlBorderData(show: false),
              sections: total == 0
                  ? [
                      PieChartSectionData(
                        value: 1,
                        title: '0%',
                        radius: 60,
                        color: Colors.grey,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      )
                    ]
                  : slices.map((slice) => _buildSection(slice)).toList(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _LegendList(slices: slices),
      ],
    );
  }

  PieChartSectionData _buildSection(_CategorySlice slice) {
    final isSmall = slice.percent < smallCutoffPercent;

    return PieChartSectionData(
      value: slice.value,
      color: slice.color,
      radius: 60,
      title: isSmall ? '' : '${slice.percent.toStringAsFixed(0)}%',
      titleStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      badgeWidget: isSmall
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(150),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${slice.percent.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            )
          : null,
      badgePositionPercentageOffset: 1.3,
    );
  }
}

class _LegendList extends StatelessWidget {
  final List<_CategorySlice> slices;

  const _LegendList({required this.slices});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: slices.map((slice) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: slice.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  slice.name,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              Text('${slice.percent.toStringAsFixed(1)}%'),
              const SizedBox(width: 8),
              Text(
                '${money(slice.value.toInt())}원',
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _CategorySlice {
  final String name;
  final Color color;
  final double value;
  final double percent;

  _CategorySlice({
    required this.name,
    required this.color,
    required this.value,
    required this.percent,
  });
}
