import 'package:prob/db/database.dart';

final database = AppDatabase();

Future<List<Category>> getCategories() async {
  final categories = await database.select(database.categories).get();

  return categories;
}
