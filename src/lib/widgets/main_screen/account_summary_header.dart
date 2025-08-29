import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/providers/expense/expense_provider.dart';
import 'package:prob/utils/date_utils.dart';
import 'package:prob/utils/money_format.dart';

class AccountSummaryHeader extends ConsumerWidget {
  final int budget;

  const AccountSummaryHeader({
    super.key,
    this.budget = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final monthKey = AppDateUtils.getMonthStart(now);
    final monthlyTotal = ref.watch(monthlyTotalProvider(monthKey));

    return monthlyTotal.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => const Center(child: Text('데이터를 가져오지 못했어요')),
      data: (total) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 62,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('이번 달 지출',
                          style:
                              TextStyle(fontSize: 16, color: Colors.black54)),
                      const SizedBox(width: 10),
                      Text('${money(total)} 원',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('이번 달 예산',
                          style:
                              TextStyle(fontSize: 16, color: Colors.black54)),
                      const SizedBox(width: 10),
                      Text(
                        '${money(budget)} 원',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4CAF93),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
