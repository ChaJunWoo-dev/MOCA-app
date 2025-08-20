import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/error/backup_error.dart';
import 'package:prob/models/budget_model.dart';
import 'package:prob/models/expense_model.dart';
import 'package:prob/providers/backup/backup_provider.dart';
import 'package:prob/providers/budget/budget_provider.dart';
import 'package:prob/providers/expense/expense_read_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final backupWriteProvider =
    AsyncNotifierProvider<BackupWrite, void>(BackupWrite.new);

class BackupWrite extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> upload(String userId) async {
    state = const AsyncLoading();

    try {
      final budget = ref.read(currentBudgetModelProvider);

      if (budget == null) throw const BackupError(BackupErrorType.noBudget);

      final expenses = await ref.read(last3MonthModelsProvider.future);

      if (expenses.isEmpty) throw const BackupError(BackupErrorType.noExpenses);

      final payload = {
        'schemaVersion': 1,
        'uploadedAt': DateTime.now().toIso8601String(),
        'budget': budget.toMap(),
        'expenses': expenses.map((expense) => expense.toMap()).toList(),
      };

      await Supabase.instance.client.storage.from('backups').uploadBinary(
            '$userId/backup.json',
            utf8.encode(jsonEncode(payload)),
            fileOptions: const FileOptions(
              contentType: 'application/json',
              upsert: true,
            ),
          );

      state = const AsyncData(null);
    } catch (err, stack) {
      state = AsyncError(err, stack);

      rethrow;
    }
  }

  Future<void> restore(String userId) async {
    state = const AsyncLoading();

    try {
      final path = '$userId/backup.json';
      final storage = Supabase.instance.client.storage.from('backups');
      final bytes = await storage.download(path);

      if (bytes.isEmpty) {
        throw const BackupError(BackupErrorType.schema, 'empty file');
      }

      final data = Map<String, dynamic>.from(
        jsonDecode(utf8.decode(bytes)) as Map,
      );

      if (data['schemaVersion'] != 1 ||
          data['budget'] == null ||
          data['expenses'] == null) {
        throw const BackupError(BackupErrorType.schema);
      }

      final budget = BudgetModel.fromMap(
        Map<String, dynamic>.from(data['budget'] as Map),
      );
      final expenses = (data['expenses'] as List)
          .map((e) => ExpenseModel.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
      final svc = ref.read(backupServiceProvider);

      await svc.restore(budget: budget, expenses: expenses);

      ref.invalidate(budgetProvider);
      ref.invalidate(last3MonthsProvider);

      state = const AsyncData(null);
    } on BackupError {
      rethrow;
    } catch (_) {
      throw const BackupError(BackupErrorType.unknown);
    }
  }
}
