import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/db/database.dart';
import 'package:prob/providers/budget/budget_provider.dart';
import 'package:prob/screens/calendar_screen.dart';
import 'package:prob/screens/list_screen.dart';
import 'package:prob/widgets/main_screen/account_summary_header.dart';
import 'package:prob/widgets/main_screen/budget_widget.dart';
import 'package:prob/widgets/main_screen/card_button.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Budget? budget = ref.watch(budgetProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('가계부', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            AccountSummaryHeader(budget: budget?.limit ?? 0),
            const SizedBox(height: 40),
            const BudgetWidget(),
            const SizedBox(height: 40),
            const CardButton(
              icon: Icons.edit_calendar_rounded,
              title: '달력으로 관리하기',
              subtitle: '날짜별 지출을 한눈에',
              routeWidget: CalendarScreen(),
            ),
            const SizedBox(height: 30),
            const CardButton(
              icon: Icons.list_alt_rounded,
              title: '리스트로 관리하기',
              subtitle: '상세 내역 빠르게 확인',
              routeWidget: ListScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
