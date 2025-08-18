import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/db/database.dart';
import 'package:prob/providers/expense/expense_write_provider.dart';
import 'package:prob/widgets/add_expense_screen/amount_input_field.dart';
import 'package:prob/widgets/add_expense_screen/category_select_sheet.dart';
import 'package:prob/widgets/add_expense_screen/date_text.dart';
import 'package:prob/widgets/add_expense_screen/expense_text_field.dart';
import 'package:prob/widgets/add_expense_screen/input_row.dart';
import 'package:prob/widgets/add_expense_screen/type_select_box.dart';
import 'package:prob/widgets/common/button.dart';
import 'package:drift/drift.dart' show Value;
import 'package:prob/widgets/common/my_app_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _State();
}

class _State extends ConsumerState<AddExpenseScreen> {
  String type = '지출';
  Category? selectedCategory;
  DateTime selectedDate = DateTime.now();
  final amountCtrl = TextEditingController(text: '0원');
  final vendorCtrl = TextEditingController();
  final memoCtrl = TextEditingController();

  void _onTypeChanged(String newType) {
    setState(() => type = newType);
  }

  void _onSelectCategory(Category? category) {
    setState(() => selectedCategory = category);
  }

  void _onDateChanged(DateTime newDate) {
    setState(() => selectedDate = newDate);
  }

  Future<void> _save() async {
    final digits = toNumericString(amountCtrl.text.trim());
    final amount = int.tryParse(digits) ?? 0;

    if (amount <= 0) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(message: '금액을 입력하세요'),
      );

      return;
    }

    if (vendorCtrl.text.trim() == '') {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(message: '거래처 명을 입력하세요'),
      );

      return;
    }

    final expenseNotifier = ref.read(expenseWriteProvider.notifier);

    await expenseNotifier.save(
      ExpensesCompanion(
        date: Value(selectedDate),
        amount: Value(amount),
        vendor: Value(vendorCtrl.text),
        categorySlug: Value(selectedCategory?.slug),
        memo: Value(memoCtrl.text),
      ),
    );

    if (!mounted) return;

    showTopSnackBar(
      Overlay.of(context),
      const CustomSnackBar.success(message: '저장했어요'),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final mainColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: const MyAppBar(text: '지출 추가'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '금액',
                          style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        AmountInputField(
                          mainColor: mainColor,
                          controller: amountCtrl,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Divider(
                    thickness: 15,
                    color: Colors.grey.shade200,
                  ),
                  const SizedBox(height: 10),
                  InputRow(
                    title: '분류',
                    widget: TypeSelectBox(
                      onTypeChanged: _onTypeChanged,
                    ),
                    showIcon: false,
                  ),
                  InputRow(
                    title: '카테고리',
                    widget: CategorySelectSheet(
                      type: type,
                      selectedCategory: selectedCategory,
                      onSelectCategory: _onSelectCategory,
                    ),
                    showIcon: true,
                  ),
                  InputRow(
                    title: '거래처',
                    widget: ExpenseTextField(
                      placeholderText: '입력하세요',
                      controller: vendorCtrl,
                    ),
                    showIcon: false,
                  ),
                  InputRow(
                    title: '날짜',
                    widget: DateText(
                      selectedDate: selectedDate,
                      onDateChanged: _onDateChanged,
                    ),
                    showIcon: true,
                  ),
                  InputRow(
                    title: '메모',
                    widget: ExpenseTextField(
                      placeholderText: '입력하세요',
                      controller: memoCtrl,
                    ),
                    showIcon: false,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 35,
            ),
            child: AppButton(
              text: '저장',
              onPressed: _save,
              width: double.infinity,
              backgroundColor: mainColor,
            ),
          ),
        ],
      ),
    );
  }
}
