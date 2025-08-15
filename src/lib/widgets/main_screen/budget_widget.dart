import 'package:flutter/material.dart';
import 'package:prob/db/database.dart';
import 'package:prob/widgets/common/button.dart';
import 'package:drift/drift.dart' show Value;
import 'package:prob/db/crud/budget_crud.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class BudgetWidget extends StatefulWidget {
  final VoidCallback onRefresh;

  const BudgetWidget({
    super.key,
    required this.onRefresh,
  });

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

  void onSetBudget() async {
    FocusScope.of(context).unfocus();

    final budget = int.tryParse(budgetController.text) ?? 0;

    if (budget <= 0 || budget > 100000000) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(message: '예산은 1원 이상, 1억 이하로 설정해주세요.'),
      );

      return;
    }
    await upsertBudget(BudgetsCompanion(
      month: Value(DateTime.now().toIso8601String().substring(0, 7)),
      limit: Value(budget),
      updatedAt: Value(DateTime.now()),
    ));
    budgetController.clear();
    widget.onRefresh();

    if (!mounted) return;

    showTopSnackBar(
      Overlay.of(context),
      const CustomSnackBar.success(message: '예산을 설정했어요.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "한 달 예산을 세워볼까요?",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        const Text(
          "예산을 설정하고 계획적으로 관리 해보세요",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w400,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 70,
          ),
          child: TextField(
            controller: budgetController,
            autofocus: false,
            textAlign: TextAlign.center,
            cursorColor: const Color(0xFF4CAF93),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF4CAF93)),
              ),
              hintText: '0 원',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade100,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '최근 3개월 평균 지출',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    Text("848,000원",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        )),
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '지난달 지출',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    Text("848,000원",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        AppButton(
          text: '예산 설정',
          width: double.infinity,
          height: 40,
          onPressed: onSetBudget,
          backgroundColor: const Color(0xFF4CAF93),
          textColor: Colors.white,
        ),
      ],
    );
  }
}
