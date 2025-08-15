import 'package:drift/drift.dart';

@DataClassName('Budget')
class Budgets extends Table {
  TextColumn get month => text()();
  IntColumn get limit => integer()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {month};
}
