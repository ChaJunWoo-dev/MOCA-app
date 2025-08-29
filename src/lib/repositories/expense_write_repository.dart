import 'package:prob/db/database.dart';
import 'package:prob/models/expense_model.dart';

abstract class ExpenseWriteRepository {
  Future<void> insertExpense(ExpensesCompanion data);
  Future<void> deleteExpenseById(int id);
  Future<void> updateExpenseById(int id, ExpensesCompanion data);
  Future<void> replaceAll(List<ExpenseModel> expenses);
}

class ExpenseWriteRepositoryImpl implements ExpenseWriteRepository {
  final AppDatabase db;

  ExpenseWriteRepositoryImpl(this.db);

  @override
  Future<void> insertExpense(ExpensesCompanion data) =>
      db.into(db.expenses).insert((data));

  @override
  Future<void> deleteExpenseById(int id) async {
    await (db.delete(db.expenses)..where((expense) => expense.id.equals(id)))
        .go();
  }

  @override
  Future<void> updateExpenseById(int id, ExpensesCompanion data) async {
    await (db.update(db.expenses)..where((expense) => expense.id.equals(id)))
        .write(data);
  }

  @override
  Future<void> replaceAll(List<ExpenseModel> expenses) async {
    await db.delete(db.expenses).go();
    await db.batch((batch) {
      batch.insertAll(
        db.expenses,
        expenses.map((expense) => expense.toCompanion()).toList(),
      );
    });
  }
}