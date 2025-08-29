import 'package:prob/db/database.dart';
import 'package:prob/models/expense_model.dart';
import 'package:prob/repositories/expense_read_repository.dart';
import 'package:prob/repositories/expense_write_repository.dart';
import 'package:prob/utils/type.dart';

class ExpenseRepository implements ExpenseReadRepository, ExpenseWriteRepository {
  final ExpenseReadRepository _readRepo;
  final ExpenseWriteRepository _writeRepo;

  ExpenseRepository(AppDatabase db)
      : _readRepo = ExpenseReadRepositoryImpl(db),
        _writeRepo = ExpenseWriteRepositoryImpl(db);

  // Write operations
  @override
  Future<void> insertExpense(ExpensesCompanion data) =>
      _writeRepo.insertExpense(data);

  @override
  Future<void> deleteExpenseById(int id) =>
      _writeRepo.deleteExpenseById(id);

  @override
  Future<void> updateExpenseById(int id, ExpensesCompanion data) =>
      _writeRepo.updateExpenseById(id, data);

  @override
  Future<void> replaceAll(List<ExpenseModel> expenses) =>
      _writeRepo.replaceAll(expenses);

  // Read operations
  @override
  Stream<int> getMonthlyExpensesTotal(DateTime date) =>
      _readRepo.getMonthlyExpensesTotal(date);

  @override
  Stream<List<Expense>> getMonthlyExpenses(DateTime date) =>
      _readRepo.getMonthlyExpenses(date);

  @override
  Future<List<Expense>> getExpensesInRange(DateTime start, DateTime end) =>
      _readRepo.getExpensesInRange(start, end);

  @override
  Stream<List<int>> getRangeMonthsTotal(DateRange dateRange) =>
      _readRepo.getRangeMonthsTotal(dateRange);
}
