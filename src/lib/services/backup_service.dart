import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:prob/db/database.dart';
import 'package:prob/models/budget_model.dart';
import 'package:prob/models/expense_model.dart';
import 'package:prob/repositories/budget_repository.dart';
import 'package:prob/repositories/expense_repository.dart';
import 'package:prob/error/backup_error.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BackupService {
  BackupService(this._db, this._budgetRepo, this._expenseRepo);

  final AppDatabase _db;
  final BudgetRepository _budgetRepo;
  final ExpenseRepository _expenseRepo;

  Future<void> restore({
    required BudgetModel budget,
    required List<ExpenseModel> expenses,
  }) async {
    await _db.transaction(() async {
      await _budgetRepo.upsert(BudgetsCompanion(
        month: Value(budget.month),
        limit: Value(budget.limit),
        updatedAt: Value(budget.updatedAt),
      ));
      await _expenseRepo.replaceAll(expenses);
    });
  }

  Future<void> uploadBackup({
    required String userId,
    required BudgetModel budget,
    required List<ExpenseModel> expenses,
  }) async {
    if (expenses.isEmpty) {
      throw const BackupError(BackupErrorType.noExpenses);
    }

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
            cacheControl: '3600',
            upsert: true,
          ),
        );
  }

  Future<Map<String, dynamic>> downloadBackup(String userId) async {
    final response = await Supabase.instance.client.storage
        .from('backups')
        .download('$userId/backup.json');

    return jsonDecode(utf8.decode(response));
  }
}
