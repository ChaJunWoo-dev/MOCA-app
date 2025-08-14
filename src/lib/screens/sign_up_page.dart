import 'package:flutter/material.dart';
import 'package:prob/widgets/common/custom_alert.dart';
import 'package:prob/widgets/sign_up_page/sign_up_email.dart';
import 'package:prob/widgets/sign_up_page/sign_up_categories.dart';
import 'package:prob/widgets/sign_up_page/sign_up_passwd.dart';
import 'package:prob/widgets/sign_up_page/sign_up_nickname.dart';
import 'package:prob/widgets/sign_up_page/welcome.dart';

class SignUpAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SignUpAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: const Text(
        "회원가입",
        style: TextStyle(color: Colors.black), // 원하는 스타일로 변경 가능
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.close_rounded,
          size: 32,
        ),
        onPressed: () {
          MyAlert.closeConfirm(context);
        },
        style: IconButton.styleFrom(
          backgroundColor: Colors.transparent, // 배경색을 투명으로 설정
          padding: EdgeInsets.zero, // 패딩을 0으로 설정
        ),
      ),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SignUpPage1 extends StatelessWidget {
  const SignUpPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SignUpAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: SignUpEmail(),
      ),
    );
  }
}

class SignUpPage2 extends StatelessWidget {
  const SignUpPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SignUpAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: SignUpPasswd(),
      ),
    );
  }
}

class SignUpPage3 extends StatelessWidget {
  const SignUpPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SignUpAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: SignUpNickname(),
      ),
    );
  }
}

class SignUpEnd extends StatelessWidget {
  const SignUpEnd({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SignUpAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: SignUpEndWidget(),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Welcome(),
      ),
    );
  }
}
