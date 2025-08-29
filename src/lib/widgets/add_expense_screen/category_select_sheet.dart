import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/db/database.dart';
import 'package:prob/providers/category/category_repository_provider.dart';
import 'package:prob/utils/icon_mapper.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CategorySelectSheet extends ConsumerStatefulWidget {
  final String type;
  final Category? selectedCategory;
  final ValueChanged<Category?> onSelectCategory;

  const CategorySelectSheet({
    super.key,
    required this.type,
    this.selectedCategory,
    required this.onSelectCategory,
  });

  @override
  ConsumerState<CategorySelectSheet> createState() => _State();
}

class _State extends ConsumerState<CategorySelectSheet> {
  Future<void> _open() async {
    final categoryRepository = ref.read(categoryRepositoryProvider);
    final categories = await categoryRepository.getAll();
    final selectableCategories =
        categories.where((category) => category.slug != 'transfer').toList();

    if (!mounted) return;
    if (selectableCategories.isEmpty) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(message: '카테고리를 불러오지 못했어요'),
      );

      return;
    }

    final picked = await showModalBottomSheet<Category>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => GridView.count(
        crossAxisCount: 4,
        padding: const EdgeInsets.all(12),
        children: selectableCategories.map(
          (category) {
            return GestureDetector(
              onTap: () => Navigator.pop(context, category),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    getCategoryIcon(category.icon),
                    size: 28,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ).toList(),
      ),
    );

    if (picked != null) widget.onSelectCategory(picked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.type == '이체' ? null : _open,
      child: Text(
        widget.type == '이체' ? '이체' : (widget.selectedCategory?.name ?? '미분류'),
        style: TextStyle(
          color: widget.type == '이체'
              ? Colors.black
              : (widget.selectedCategory == null ? Colors.grey : Colors.black),
          fontSize: 17,
        ),
      ),
    );
  }
}
