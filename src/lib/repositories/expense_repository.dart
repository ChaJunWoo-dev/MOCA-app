import 'package:prob/db/database.dart';

class ExpenseRepository {
  final AppDatabase db;

  ExpenseRepository(this.db);

  Future<void> insertExpense(ExpensesCompanion data) =>
      db.into(db.expenses).insert((data));
}
