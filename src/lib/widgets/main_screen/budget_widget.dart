import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import 'package:prob/db/database.dart';
import 'package:prob/providers/budget/budget_provider.dart';
import 'package:prob/providers/expense/expense_provider.dart';
import 'package:prob/services/budget_validation_service.dart';
import 'package:prob/services/expense_summary_service.dart';
import 'package:prob/utils/money_format.dart';
import 'package:prob/widgets/common/button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class BudgetWidget extends StatefulWidget {
  const BudgetWidget({super.key});

  @override
  State<BudgetWidget> createState() => _BudgetWidgetState();
}

class _BudgetWidgetState extends State<BudgetWidget> {
  late final TextEditingController budgetController;

  @override
  void initState() {
    super.initState();
    budgetController = TextEditingController();
  }

  @override
  void dispose() {
    budgetController.dispose();
    super.dispose();
  }

  Future<void> onSetBudget(WidgetRef ref) async {
    FocusScope.of(context).unfocus();

    final validationResult =
        BudgetValidationService.validateBudget(budgetController.text);

    if (!validationResult.isValid) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(message: validationResult.errorMessage!),
      );
      return;
    }

    final yearMonth = BudgetValidationService.getCurrentYearMonth();

    await ref.read(budgetProvider.notifier).save(
          BudgetsCompanion(
            month: Value(yearMonth),
            limit: Value(validationResult.value!),
            updatedAt: Value(DateTime.now()),
          ),
        );

    budgetController.clear();

    if (!mounted) return;

    showTopSnackBar(
      Overlay.of(context),
      const CustomSnackBar.success(message: '예산을 설정했어요.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return Column(
          children: [
            const Text(
              "한 달 예산을 세워볼까요?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            const Text(
              "예산을 설정하고 계획적으로 관리 해보세요",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 70),
              child: TextField(
                  controller: budgetController,
                  autofocus: false,
                  textAlign: TextAlign.center,
                  cursorColor: const Color(0xFF4CAF93),
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF4CAF93))),
                    hintText: '0 원',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    CurrencyInputFormatter(
                      thousandSeparator: ThousandSeparator.Comma,
                      mantissaLength: 0,
                      trailingSymbol: '원',
                    )
                  ]),
            ),
            _ExpenseSummaryCard(),
            const SizedBox(height: 18),
            AppButton(
              text: '예산 설정',
              width: double.infinity,
              height: 40,
              onPressed: () => onSetBudget(ref),
            ),
          ],
        );
      },
    );
  }
}

class _ExpenseSummaryCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateRange = ExpenseSummaryService.getThreeMonthRange();
    final totals3Month = ref.watch(rangeMonthsTotalProvider(dateRange));

    return totals3Month.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => const Center(child: Text('데이터를 가져오지 못했어요')),
      data: (monthlyTotals) {
        final summaryData =
            ExpenseSummaryService.processMonthlyTotals(monthlyTotals);

        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade100),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                _SummaryRow(
                  title: '지난 달 지출',
                  expenseTotal: summaryData.lastMonthTotal,
                ),
                const SizedBox(height: 7),
                _SummaryRow(
                  title: '최근 3개월 평균 지출',
                  expenseTotal: summaryData.threeMonthAverage,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final int expenseTotal;

  const _SummaryRow({
    required this.title,
    required this.expenseTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 13)),
        Text(
          "${money(expenseTotal)}원",
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
