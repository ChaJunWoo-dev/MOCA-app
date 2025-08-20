import 'package:drift/drift.dart';
import 'package:prob/db/database.dart';
import 'package:prob/models/budget_model.dart';
import 'package:prob/models/expense_model.dart';
import 'package:prob/repositories/budget_repository.dart';
import 'package:prob/repositories/expense_repository.dart';

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
}
