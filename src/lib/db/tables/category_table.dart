import 'package:drift/drift.dart';

@DataClassName('Category')
class Categories extends Table {
  TextColumn get slug => text()();
  TextColumn get name => text()();
  TextColumn get icon => text()();

  @override
  Set<Column> get primaryKey => {slug};
}
