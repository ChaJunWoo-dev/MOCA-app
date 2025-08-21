import 'package:prob/db/database.dart';

class CategoryRepository {
  final AppDatabase db;

  CategoryRepository(this.db);

  Future<List<Category>> getAll() => db.select(db.categories).get();

  Future<Category> getBySlug(String slug) {
    final query = db.select(db.categories)
      ..where(
        (category) => category.slug.equals(slug),
      );

    return query.getSingle();
  }
}
