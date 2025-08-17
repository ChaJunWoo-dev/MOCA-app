import 'package:prob/db/database.dart';

class CategoryRepository {
  final AppDatabase db;

  CategoryRepository(this.db);

  Future<List<Category>> getAll() => db.select(db.categories).get();
}
