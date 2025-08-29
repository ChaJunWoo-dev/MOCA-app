import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/db/database.dart';
import 'package:prob/providers/repository_providers.dart';

final categoryProvider = FutureProvider<List<Category>>((ref) async {
  final repo = ref.read(categoryRepositoryProvider);

  return repo.getAll();
});

final categoryBySlugProvider =
    FutureProvider.family<Category?, String>((ref, slug) async {
  final repo = ref.read(categoryRepositoryProvider);

  return repo.getBySlug(slug);
});
