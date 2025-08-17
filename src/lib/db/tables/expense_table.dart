import 'package:drift/drift.dart';
import 'package:prob/db/tables/category_table.dart';

enum ExpenseType {
  transfer,
  expense,
}

@DataClassName('Expense')
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get amount => integer()();
  TextColumn get vendor => text().nullable()();
  TextColumn get categorySlug =>
      text().nullable().references(Categories, #slug)();
  TextColumn get memo => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
