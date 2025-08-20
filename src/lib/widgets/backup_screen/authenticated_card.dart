import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/models/budget_model.dart';
import 'package:prob/models/expense_model.dart';
import 'package:prob/providers/budget/budget_provider.dart';
import 'package:prob/providers/expense/expense_read_provider.dart';
import 'package:prob/widgets/common/button.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AuthenticatedCard extends ConsumerWidget {
  final Session? session;
  final String email, avatarUrl;
  final GoTrueClient auth;
  final void Function(String?) onBackupUpdated;

  const AuthenticatedCard({
    super.key,
    required this.session,
    required this.email,
    required this.avatarUrl,
    required this.auth,
    required this.onBackupUpdated,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BudgetModel? getBudgetData() {
      final budget = ref.read(budgetProvider);

      if (budget == null || budget.month.isEmpty) {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(message: '실패 - 저장할 예산이 없어요'),
        );

        return null;
      }

      return BudgetModel(
        month: budget.month,
        limit: budget.limit,
        updatedAt: budget.updatedAt,
      );
    }

    Future<List<ExpenseModel>> getExpenseData() async {
      final expenses = await ref.read(last3MonthsProvider.future);

      if (expenses.isEmpty) {
        if (!context.mounted) return [];

        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(message: '실패 - 최근 3개월 지출이 없어요'),
        );

        return [];
      }

      return expenses
          .map((expense) => ExpenseModel(
                id: expense.id,
                date: expense.date,
                amount: expense.amount,
                vendor: expense.vendor,
                categorySlug: expense.categorySlug,
                memo: expense.memo,
              ))
          .toList();
    }

    Future<void> uploadStorage() async {
      try {
        final budget = getBudgetData();
        final expenses = await getExpenseData();

        if (budget == null || expenses.isEmpty) return;

        final uploadJson = {
          'schemaVersion': 1,
          'uploadedAt': DateTime.now().toIso8601String(),
          'budget': budget.toMap(),
          'expenses': expenses.map((expense) => expense.toMap()).toList(),
        };
        final jsonString = jsonEncode(uploadJson);

        final userId = session?.user.id;
        final fileName = '$userId/backup.json';

        await Supabase.instance.client.storage.from('backups').uploadBinary(
              fileName,
              utf8.encode(jsonString),
              fileOptions: const FileOptions(
                contentType: 'application/json',
                upsert: true,
              ),
            );

        onBackupUpdated(userId);

        if (!context.mounted) return;

        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(message: '클라우드 저장 성공'),
        );
      } catch (err) {
        if (!context.mounted) return;

        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(message: '클라우드 저장 실패'),
        );
      }
    }

    return Card(
      elevation: 0,
      color: const Color(0xFFF2F4F7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      (avatarUrl.isNotEmpty) ? NetworkImage(avatarUrl) : null,
                  child: (avatarUrl.isEmpty)
                      ? const Icon(Icons.person, size: 30)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(email,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await auth.signOut();
                    if (context.mounted) {
                      showTopSnackBar(
                        Overlay.of(context),
                        const CustomSnackBar.error(message: '로그아웃 완료'),
                      );
                    }
                  },
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text('로그아웃'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: '클라우드에 저장',
                    onPressed: uploadStorage,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: AppButton(
                    text: '데이터 가져오기',
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
