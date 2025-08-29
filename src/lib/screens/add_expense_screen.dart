import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/db/database.dart';
import 'package:prob/providers/category/category_provider.dart';
import 'package:prob/providers/expense/expense_repository_provider.dart';
import 'package:prob/providers/expense/expense_write_provider.dart';
import 'package:prob/widgets/add_expense_screen/amount_input_field.dart';
import 'package:prob/widgets/add_expense_screen/category_select_sheet.dart';
import 'package:prob/widgets/add_expense_screen/date_text.dart';
import 'package:prob/widgets/add_expense_screen/expense_text_field.dart';
import 'package:prob/widgets/add_expense_screen/input_row.dart';
import 'package:prob/widgets/add_expense_screen/type_select_box.dart';
import 'package:prob/widgets/common/app_speed_dial.dart';
import 'package:prob/widgets/common/button.dart';
import 'package:drift/drift.dart' show Value;
import 'package:prob/widgets/common/my_app_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  final Expense? initialExpense;

  const AddExpenseScreen({
    super.key,
    this.initialExpense,
  });

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

  @override
  void initState() {
    super.initState();
    final expense = widget.initialExpense;

    if (expense != null) {
      selectedDate = expense.date;
      vendorCtrl.text = expense.vendor;
      memoCtrl.text = expense.memo ?? '';
      amountCtrl.text =
          '${toCurrencyString(expense.amount.toString(), mantissaLength: 0)}원';

      final slug = expense.categorySlug;

      if (slug != null) {
        ref.read(categoryBySlugProvider(slug).future).then((category) {
          setState(() => selectedCategory = category);
        });
      } else {
        selectedCategory = null;
      }
    }
  }

  void _onTypeChanged(String newType) {
    setState(() => type = newType);
  }

  void _onSelectCategory(Category? category) {
    setState(() => selectedCategory = category);
  }

  void _onDateChanged(DateTime newDate) {
    setState(() => selectedDate = newDate);
  }

  ({int? amount, String? error}) _validateInput() {
    final digits = toNumericString(amountCtrl.text.trim());
    final amount = int.tryParse(digits) ?? 0;

    if (amount <= 0) {
      return (amount: null, error: '금액을 입력하세요');
    }

    if (vendorCtrl.text.trim().isEmpty) {
      return (amount: null, error: '거래처 명을 입력하세요');
    }

    return (amount: amount, error: null);
  }

  ExpensesCompanion _createExpenseCompanion(int amount) {
    return ExpensesCompanion(
      date: Value(selectedDate),
      amount: Value(amount),
      vendor: Value(vendorCtrl.text),
      categorySlug: Value(selectedCategory?.slug),
      memo: Value(memoCtrl.text),
    );
  }

  void _showSuccessAndClose(String message) {
    if (!mounted) return;

    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(message: message),
    );
    Navigator.pop(context);
  }

  void _showError(String message) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(message: message),
    );
  }

  Future<void> _create() async {
    final validation = _validateInput();

    if (validation.error != null) {
      _showError(validation.error!);

      return;
    }

    final expenseNotifier = ref.read(expenseWriteProvider.notifier);

    await expenseNotifier.save(_createExpenseCompanion(validation.amount!));

    _showSuccessAndClose('저장했어요');
  }

  Future<void> _update() async {
    final current = widget.initialExpense;

    if (current == null) return;

    final validation = _validateInput();

    if (validation.error != null) {
      _showError(validation.error!);

      return;
    }

    await ref.read(expenseRepositoryProvider).updateExpenseById(
          current.id,
          _createExpenseCompanion(validation.amount!),
        );

    _showSuccessAndClose('수정했어요');
  }

  Future<void> _delete() async {
    final current = widget.initialExpense;

    if (current == null) return;

    final result = await showOkCancelAlertDialog(
      context: context,
      title: '삭제할까요?',
      message:
          '${current.vendor} • ${toCurrencyString(current.amount.toString(), mantissaLength: 0)}원',
      okLabel: '삭제',
      cancelLabel: '취소',
      isDestructiveAction: true,
      barrierDismissible: true,
    );

    final ok = result == OkCancelResult.ok;

    if (ok != true) return;

    await ref.read(expenseRepositoryProvider).deleteExpenseById(current.id);

    if (!mounted) return;

    showTopSnackBar(
      Overlay.of(context),
      const CustomSnackBar.success(message: '삭제했어요'),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final mainColor = Theme.of(context).colorScheme.primary;
    final isEdit = widget.initialExpense != null;

    return Scaffold(
      floatingActionButton: const AppSpeedDial(),
      appBar: isEdit
          ? const MyAppBar(text: '지출 상세 내역')
          : const MyAppBar(text: '지출 추가'),
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
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
            child: isEdit
                ? Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: '삭제',
                          onPressed: _delete,
                          width: double.infinity,
                          backgroundColor: Colors.red.shade300,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppButton(
                          text: '수정',
                          onPressed: _update,
                          width: double.infinity,
                          backgroundColor: mainColor,
                        ),
                      ),
                    ],
                  )
                : AppButton(
                    text: '저장',
                    onPressed: _create,
                    width: double.infinity,
                    backgroundColor: mainColor,
                  ),
          ),
        ],
      ),
    );
  }
}
