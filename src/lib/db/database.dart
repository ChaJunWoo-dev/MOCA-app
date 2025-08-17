import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prob/db/tables/budget_table.dart';
import 'package:prob/db/tables/category_table.dart';
import 'package:prob/constants/categories_data.dart';
import 'package:prob/db/tables/expense_table.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Budgets,
    Categories,
    Expenses,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(
          executor ?? _openConnection(),
        );

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'app_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();

          for (final entry in categoriesData.entries) {
            await into(categories).insert(
              CategoriesCompanion.insert(
                slug: entry.key,
                name: entry.value['name'],
                icon: entry.value['icon'],
              ),
            );
          }
        },
      );
}
