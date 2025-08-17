import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/providers/app_database_provider.dart';
import 'package:prob/repositories/category_repository.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final db = ref.read(appDatabaseProvider);

  return CategoryRepository(db);
});
