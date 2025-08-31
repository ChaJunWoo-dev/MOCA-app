import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/constants/message_constants.dart';
import 'package:prob/db/database.dart';
import 'package:prob/providers/expense/expense_provider.dart';
import 'package:prob/providers/repository_providers.dart';

class ExpenseFormService {
  static Future<void> createExpense({
    required WidgetRef ref,
    required DateTime date,
    required int amount,
    required String vendor,
    required String? categorySlug,
    required String? memo,
  }) async {
    final expenseNotifier = ref.read(expenseWriteProvider.notifier);

    await expenseNotifier.save(ExpensesCompanion(
      date: Value(date),
      amount: Value(amount),
      vendor: Value(vendor),
      categorySlug: Value(categorySlug),
      memo: Value(memo),
    ));
  }

  static Future<void> updateExpense({
    required WidgetRef ref,
    required int expenseId,
    required DateTime date,
    required int amount,
    required String vendor,
    required String? categorySlug,
    required String? memo,
  }) async {
    await ref.read(expenseRepositoryProvider).updateExpenseById(
          expenseId,
          ExpensesCompanion(
            date: Value(date),
            amount: Value(amount),
            vendor: Value(vendor),
            categorySlug: Value(categorySlug),
            memo: Value(memo),
          ),
        );
  }

  static Future<bool> deleteExpense({
    required BuildContext context,
    required WidgetRef ref,
    required Expense expense,
  }) async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: Messages.deleteConfirmTitle,
      message:
          '${expense.vendor} • ${toCurrencyString(expense.amount.toString(), mantissaLength: 0)}원',
      okLabel: '삭제',
      cancelLabel: '취소',
      isDestructiveAction: true,
      barrierDismissible: true,
    );

    if (result == OkCancelResult.ok) {
      await ref.read(expenseRepositoryProvider).deleteExpenseById(expense.id);
      return true;
    }

    return false;
  }
}
