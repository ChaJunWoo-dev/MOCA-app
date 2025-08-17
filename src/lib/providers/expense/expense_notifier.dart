import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/db/database.dart';
import 'package:prob/repositories/expense_repository.dart';

class ExpenseNotifier extends StateNotifier<Expense?> {
  ExpenseNotifier(this._repo) : super(null);

  final ExpenseRepository _repo;

  Future<void> save(ExpensesCompanion data) async {
    await _repo.insertExpense(data);
  }
}
