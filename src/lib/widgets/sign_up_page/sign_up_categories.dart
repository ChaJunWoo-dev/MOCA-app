import 'package:flutter/material.dart';
import 'package:prob/api/category_api.dart';
import 'package:prob/api/user_api.dart';
import 'package:prob/model/all_category_model.dart';
import 'package:prob/provider/signup/categories_provider.dart';
import 'package:prob/provider/signup/signup_provider.dart';
import 'package:prob/widgets/common/custom_alert.dart';
import 'package:prob/widgets/sign_up_page/reset.dart';
import 'package:provider/provider.dart';

class SignUpEndWidget extends StatefulWidget {
  const SignUpEndWidget({super.key});

  @override
  State<SignUpEndWidget> createState() => _SignUpEndWidgetState();
}

bool _isLoading = true;
late Future<List<AllCateModel>> allCategories;

class _SignUpEndWidgetState extends State<SignUpEndWidget> {
  @override
  void initState() {
    super.initState();
    final signupProvider = context.read<SignupProvider>();
    //카테고리 전체 조회
    allCategories = CategoryApi.readAllCategories();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (signupProvider.email == null ||
          signupProvider.password == null ||
          signupProvider.nickname == null) {
        MyAlert.failShow(context, '잘못된 접근입니다', '/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Text(
          "주로 소비하는 카테고리가 있나요?",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
        const Text(
          "4개를 선택해주세요  :)",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
        const SizedBox(height: 30),
        _buildCategorySelection(),
        const SizedBox(height: 20),
        _buildSignUpButton(),
      ],
    );
  }

  Widget _buildCategorySelection() {
    final categoriesProvider = context.watch<CategoriesProvider>();
    return FutureBuilder(
      future: allCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('오류가 발생했어요'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No categories found.'));
        } else {
          final categories = snapshot.data!;
          return SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: GridView.builder(
              shrinkWrap: true, // GridView가 스크롤 가능하게 설정
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 열의 개수
                crossAxisSpacing: 30, // 가로 간격
                mainAxisSpacing: 20, // 세로 간격
                childAspectRatio: 3, // 아이템 비율
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = categoriesProvider.selectedCategories
                    .contains(category.name);

                return GestureDetector(
                  onTap: () {
                    if (categoriesProvider.isOver4 && !isSelected) {
                      MyAlert.successShow(context, "이미 4개를 선택했어요");
                    } else {
                      isSelected
                          ? categoriesProvider.removeElement(category.name)
                          : categoriesProvider.addElement(category.name);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16), // Padding 추가
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? Colors.blueAccent : Colors.grey,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        category.name,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildSignUpButton() {
    final categoriesProvider = context.watch<CategoriesProvider>();
    final signupProvider = context.read<SignupProvider>();
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 40,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          overlayColor: const Color.fromRGBO(1, 1, 1, 1),
          foregroundColor: const Color.fromRGBO(1, 1, 1, 1),
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
        onPressed: categoriesProvider.isOver4
            ? () async {
                setState(() {
                  _isLoading = true; // 로딩 시작
                });
                signupProvider
                    .setCategories(categoriesProvider.selectedCategories);

                // 최종 검증 및 회원가입 요청
                if (signupProvider.isNotEmpty()) {
                  final signupRes = await UserApi.signUp(
                    signupProvider.email!,
                    signupProvider.password!,
                    signupProvider.nickname!,
                    signupProvider.categories!,
                  );

                  setState(() {
                    _isLoading = false; // 로딩 종료
                  });

                  if (!context.mounted) return;

                  if (!signupRes) {
                    MyAlert.failShow(context, "오류. 다시 시도해주세요", null);
                  } else {
                    Reset.resetproviders(context);
                    Navigator.pushReplacementNamed(context, "/welcome");
                  }
                } else {
                  setState(() {
                    _isLoading = false; // 로딩 종료
                  });
                  MyAlert.failShow(context, "오류가 발생했습니다", '/');
                }
              }
            : null,
        child: const Text(
          '회원가입 완료',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
