import 'package:flutter/material.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/provider/home_provider.dart';
import 'package:prob/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    const boxSize = 190.0;
    const boxColor = Color(0xFFFFFBF5);
    final userProvider = context.read<UserProvider>();
    final homeProvider = context.read<HomeProvider>();
    const defaultImage = 'assets/images/default_profile.svg';
    return Column(
      children: [
        Container(
          height: boxSize,
          decoration: const BoxDecoration(color: boxColor),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 30, left: 125, right: 125, bottom: 14),
              child: Column(
                children: [
                  //이미지
                  GestureDetector(
                    onTap: () {
                      // 버튼을 클릭했을 때의 동작을 여기에 작성
                    },
                    child: ClipOval(
                      child: Container(
                        width: 100.0, // 원하는 너비
                        height: 100.0, // 원하는 높이
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color.fromARGB(246, 0, 0, 0),
                              width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SvgPicture.asset(
                            defaultImage,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    userProvider.user?.nickname ?? "홍길동",
                    style:
                        const TextStyle(fontSize: 17, color: Color(0xFF3B2304)),
                  )
                ],
              ),
            ),
          ),
        ),
        RowList(
          method: () {
            homeProvider.setProfile('edit_category');
          },
          title: '카테고리 수정',
        ),
        RowList(
          method: () {},
          title: '고정 지출',
        ),
        RowList(
          method: () {},
          title: '예산 설정',
        ),
        RowList(
          method: () {},
          title: '총 수입 설정',
        ),
        const Spacer(),
        TextButton(
            style: const ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.zero)),
            onPressed: () {},
            child: Container(
              padding: const EdgeInsets.all(18),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Color(0xFFF9DEDE)),
              child: const Center(
                child: Text(
                  '회원탈퇴',
                  style: TextStyle(color: Color(0xFFE53C42), fontSize: 18),
                ),
              ),
            ))
      ],
    );
  }
}

class RowList extends StatelessWidget {
  const RowList({
    required this.title,
    required this.method,
    super.key,
  });
  final String title;
  final VoidCallback method;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 17),
          child: TextButton(
              onPressed: method,
              child: Text(
                title,
                style: const TextStyle(
                    color: Color.fromARGB(125, 59, 35, 4), fontSize: 16),
              )),
        ),
        const Divider(color: Color(0xFFD5D5D5), thickness: 1, height: 0)
      ],
    );
  }
}
