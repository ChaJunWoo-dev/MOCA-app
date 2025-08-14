import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prob/model/categories_model.dart';
import 'package:prob/provider/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikeManager {
  // 항목의 like 상태를 저장
  static Future<void> saveLikeStatus(int subId, bool isLiked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("$subId", isLiked);
  }

  // 항목의 like 상태를 불러오기
  static Future<bool> getLikeStatus(int subId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("$subId") ?? false;
  }
}

class EditCategory extends StatefulWidget {
  const EditCategory({super.key});

  @override
  State<EditCategory> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<EditCategory> {
  late Future<void> _fetchFuture;

  @override
  void initState() {
    super.initState();
    _fetchFuture = context.read<CategoryProvider>().fetchCategories(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();
    return Container(
      color: const Color(0xFFFFFBF5),
      child: FutureBuilder(
          future: _fetchFuture,
          builder: (context, snapshot) {
            bool isLoading =
                snapshot.connectionState == ConnectionState.waiting;
            if (snapshot.hasError) {
              return const Center(child: Text('카테고리 목록 조회에 실패했습니다.'));
            } else {
              return Skeletonizer(
                  enabled: isLoading,
                  child: snapshot.connectionState == ConnectionState.waiting
                      ? const Center(child: CircularProgressIndicator())
                      : snapshot.hasError
                          ? const Center(child: Text('카테고리 목록 조회에 실패했습니다.'))
                          : provider.userCategory.isEmpty
                              ? Container(
                                  color: const Color(0xFFFFFBF5),
                                  child: const Center(
                                    child: Text('카테고리 목록이 비어 있습니다.'),
                                  ),
                                )
                              : GridTile(provider: provider));
            }
          }),
    );
  }
}

class GridTile extends StatelessWidget {
  const GridTile({
    super.key,
    required this.provider,
  });

  final CategoryProvider provider;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 3),
      itemCount: provider.userCategory.length,
      itemBuilder: (context, index) {
        final category = provider.userCategory[index];
        const padding = EdgeInsets.only(left: 14, top: 5);
        return Container(
          // height: 75,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: const Color(0xFFD5D5D5)),
            color: provider.userCategory[index].visible
                ? const Color(0xFFFFFBF5)
                : const Color(0xFFECEBEB),
          ),
          child: Padding(
            padding: padding,
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: SvgPicture.asset(
                    category.icon,
                    width: 53,
                    height: 53,
                    semanticsLabel: 'X',
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 3,
                  child: Text(
                    category.name,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Color(0xFF917046),
                      fontSize: 15,
                    ),
                  ),
                ),
                Flexible(
                    flex: 1,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: AddAndRemButton(
                            category: category, provider: provider)))
              ],
            ),
          ),
        );
      },
    );
  }
}

class AddAndRemButton extends StatelessWidget {
  const AddAndRemButton({
    super.key,
    required this.category,
    required this.provider,
  });

  final CategoriesModel category;
  final CategoryProvider provider;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      iconSize: 25,
      constraints: const BoxConstraints(maxHeight: 30, maxWidth: 30),
      icon: Icon(
        category.visible ? Icons.remove : Icons.add,
        weight: 100,
      ),
      onPressed: () {
        // 요소를 찾고 수정
        provider.toggleVisibile(category.subId);
      },
      color:
          category.visible ? const Color(0xFFE68C25) : const Color(0xFF5D89BB),
    );
  }
}
