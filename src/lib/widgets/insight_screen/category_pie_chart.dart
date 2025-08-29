import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/db/database.dart';
import 'package:prob/providers/category/category_provider.dart';
import 'package:prob/services/category_chart_service.dart';
import 'package:prob/utils/money_format.dart';

class CategoryPieTop5 extends ConsumerWidget {
  final List<Expense> expenses;
  final double smallCutoffPercent;

  const CategoryPieTop5({
    super.key,
    required this.expenses,
    this.smallCutoffPercent = 5,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryProvider);

    return categoriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const Center(child: Text('오류가 발생했습니다.')),
      data: (categories) => _buildChart(categories),
    );
  }

  Widget _buildChart(List<Category> categories) {
    final categoryMap = {for (var cat in categories) cat.slug: cat};
    final chartData = CategoryChartService.processExpensesForChart(
      expenses,
      categoryMap,
    );

    if (chartData.isEmpty) return _buildEmptyChart();

    final palette = [
      Colors.redAccent,
      Colors.blueAccent,
      Colors.green,
      Colors.purple,
      Colors.teal,
    ];
    final slices = <_CategorySlice>[];

    for (int i = 0; i < chartData.length; i++) {
      final data = chartData[i];
      final isEtc = data.categorySlug == '기타';

      slices.add(_CategorySlice(
        name: data.categoryName,
        color: isEtc ? Colors.grey : palette[i % palette.length],
        value: data.amount.toDouble(),
        percent: data.percent,
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
              sections: slices.map((slice) => _buildSection(slice)).toList(),
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

  Widget _buildEmptyChart() {
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
              sections: [
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
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const _LegendList(slices: []),
      ],
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
