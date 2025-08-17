import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prob/providers/expense/expense_read_provider.dart';
import 'package:prob/utils/money_format.dart';
import 'package:prob/widgets/expense_list/expense_tile.dart';

bool sameYMD(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

class ExpenseListView extends ConsumerWidget {
  final DateTime monthDate;
  final DateTime? selectedDay;

  const ExpenseListView({
    super.key,
    required this.monthDate,
    this.selectedDay,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthStart = DateTime(monthDate.year, monthDate.month, 1);
    final groupsValue = ref.watch(dailyGroupsProvider(monthStart));

    return groupsValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('지출 내역 조회에 실패했어요')),
      data: (groups) {
        final monthFiltered = groups
            .where(
              (group) =>
                  group.day.year == monthDate.year &&
                  group.day.month == monthDate.month,
            )
            .toList();
        final visibleGroups = selectedDay == null
            ? monthFiltered
            : monthFiltered
                .where(
                  (group) =>
                      group.day.year == selectedDay!.year &&
                      group.day.month == selectedDay!.month &&
                      group.day.day == selectedDay!.day,
                )
                .toList();

        if (visibleGroups.isEmpty) {
          return const Center(child: Text('지출 내역이 없어요'));
        }

        return ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          children: [
            for (var i = 0; i < visibleGroups.length; i++) ...[
              const SizedBox(height: 25),
              DailySection(visibleGroups: visibleGroups, i: i),
            ],
          ],
        );
      },
    );
  }
}

class DailySection extends StatelessWidget {
  const DailySection({
    super.key,
    required this.visibleGroups,
    required this.i,
  });

  final List<DailyGroup> visibleGroups;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('M월 d일 EEEE', 'ko_KR').format(
                visibleGroups[i].day,
              ),
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              '-${money(visibleGroups[i].total)}원',
              style: TextStyle(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Divider(
          height: 30,
          color: Colors.grey.shade300,
        ),
        const SizedBox(height: 6),
        ...visibleGroups[i].items.map(
              (expense) => ExpenseTile(item: expense),
            ),
      ],
    );
  }
}
