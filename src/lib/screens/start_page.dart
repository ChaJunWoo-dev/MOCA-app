import 'package:flutter/material.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/widgets/common/custom_alert.dart';
import 'package:prob/service/auth_service.dart';
import 'package:prob/widgets/common/app_colors.dart';
import 'package:prob/widgets/common/line_widget.dart';
import 'package:prob/widgets/sign_up_page/reset.dart';
import 'package:provider/provider.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  static const logo = 'assets/images/logo.png';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height -
              (MediaQuery.of(context).size.height / 7),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Color.fromARGB(255, 241, 207, 177),
                Color.fromARGB(255, 236, 199, 167),
                Color.fromARGB(255, 241, 207, 177),
                Colors.white,
              ],
              stops: [0.0, 0.25, 0.5, 0.75, 1.0], // 색상이 전환되는 위치(0=시작, 0.5 = 중앙)
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 0, bottom: 40, left: 40, right: 40),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    logo,
                    width: 240,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 25),
                  const BoldText(text: '지금 두부로'),
                  const BoldText(text: '내 소비습관을 확인하세요!'),
                  const SizedBox(height: 5),
                  const SubText(text: '소비내역 확인부터 카테고리별 정리까지'),
                  const SizedBox(height: 55),
                  const LoginForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BoldText extends StatelessWidget {
  const BoldText({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          color: Color.fromARGB(255, 161, 117, 76), fontSize: 20),
    );
  }
}

class SubText extends StatelessWidget {
  const SubText({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          color: Color.fromARGB(255, 173, 134, 97), fontSize: 13),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 10),
        SignInTextField(
            emailController: emailController, text: '  이메일 입력', obscure: false),
        const SizedBox(height: 20),
        SignInTextField(
            emailController: passwordController,
            text: '  비밀번호 입력',
            obscure: true),
        const SizedBox(height: 20),

        // 로그인 버튼
        SignButton(
          text: '로그인',
          onPressed: () async {
            const String email =
                'wnsdnxla123@gmail.com'; //emailController.text;
            const String password = 'ASDasd123!'; //passwordController.text;

            //로그인해서 토큰 저장
            try {
              if (email.isEmpty || password.isEmpty) {
                throw Exception();
              }
              final result = await authProvider.login(email, password);
              if (result == 'login success') {
                if (!context.mounted) return;
                Navigator.pushReplacementNamed(context, "/home");
              } else {
                throw Exception();
              }
            } catch (e) {
              MyAlert.failShow(context, "로그인 정보가 올바르지 않습니다", null);
              passwordController.text = '';
            }
          },
        ),
        const SizedBox(height: 10),

        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextButton(
                child: const Text(
                  '아이디/비밀번호 찾기',
                  style: TextStyle(
                    color: StartPageColors.textFieldBorder,
                    fontSize: 13,
                  ),
                ),
                onPressed: () => MyAlert.successShow(context, '준비 중인 기능이에요'),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const LineWidget(
              color: StartPageColors.textFieldBorder,
              width: 1,
              height: 13,
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: TextButton(
                child: const Text(
                  '회원가입',
                  style: TextStyle(
                    color: StartPageColors.textFieldBorder,
                    fontSize: 13,
                  ),
                ),
                onPressed: () {
                  Reset.resetproviders(context);
                  Navigator.pushReplacementNamed(context, "/join_first");
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SignInTextField extends StatelessWidget {
  const SignInTextField(
      {super.key,
      required this.emailController,
      required this.text,
      required this.obscure});

  final TextEditingController emailController;
  final String text;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      controller: emailController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(
            color: StartPageColors.textFieldBorder,
            width: 2.0,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(
            color: StartPageColors.textFieldFocusBorder,
            width: 2.0,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
        // prefixIcon: Icon(Icons.email_rounded),
        // prefixIconColor: Color.fromARGB(117, 37, 29, 21),
        labelText: text,
        labelStyle: const TextStyle(
          color: StartPageColors.labelText,
        ),
        filled: true,
        fillColor: StartPageColors.filled,
      ),
    );
  }
}

class SignButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SignButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 45,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: StartPageColors.textFieldBorder,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            side: const BorderSide(
              color: StartPageColors.textFieldBorder,
              width: 2.0,
            ),
            textStyle: const TextStyle(
              fontSize: 18,
            ),
            enableFeedback: true),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
