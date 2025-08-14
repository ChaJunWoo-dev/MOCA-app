import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prob/provider/signup/passwd_provider.dart';
import 'package:prob/provider/signup/signup_provider.dart';
import 'package:prob/widgets/common/custom_alert.dart';
import 'package:prob/widgets/sign_up_page/valid_form.dart';
import 'package:provider/provider.dart';

class SignUpPasswd extends StatefulWidget {
  const SignUpPasswd({super.key});

  @override
  State<SignUpPasswd> createState() => _SignUpPasswdState();
}

class _SignUpPasswdState extends State<SignUpPasswd> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final signupProvider = context.read<SignupProvider>();
      if (signupProvider.email == null) {
        MyAlert.failShow(context, '잘못된 접근입니다', '/');
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final passwdProvider = context.watch<PasswdProvider>();
    final signupProvider = context.read<SignupProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Text(
          "비밀번호를 입력해주세요  :)",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
        ),
        const SizedBox(height: 6),
        const Text(
          "비밀번호 규칙을 지켜주세요",
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 30),
        TextField(
          inputFormatters: [LengthLimitingTextInputFormatter(30)],
          controller: _passwordController,
          obscureText: !passwdProvider.obscure,
          decoration: InputDecoration(
            labelText: '비밀번호',
            labelStyle: const TextStyle(fontSize: 18),
            suffixIcon: IconButton(
              icon: Icon(
                passwdProvider.obscure
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: passwdProvider.toggleObscure,
            ),
          ),
          onChanged: (value) {
            passwdProvider.validatePassword(value);
            passwdProvider.verifyPassword(
                _confirmPasswordController.text, value);
          },
        ),
        const SizedBox(height: 8),
        _buildValidationMessages(passwdProvider),
        const SizedBox(height: 20),
        TextField(
          inputFormatters: [
            LengthLimitingTextInputFormatter(30),
            FilteringTextInputFormatter.deny(RegExp(r'\b')),
          ],
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: '비밀번호 확인',
            labelStyle: const TextStyle(fontSize: 18),
            errorText: passwdProvider.verifyPasswdMessage,
            errorStyle: const TextStyle(fontSize: 12),
          ),
          onChanged: (value) {
            passwdProvider.verifyPassword(value, _passwordController.text);
          },
        ),
        const SizedBox(height: 20),
        _buildNextButton(passwdProvider, signupProvider),
        const SizedBox(height: 35),
      ],
    );
  }

  Widget _buildValidationMessages(PasswdProvider passwdProvider) {
    return Column(
      children: [
        ValidForm(
          checker: passwdProvider.isValidLength,
          text: "8~30자 구성",
        ),
        const SizedBox(height: 5),
        ValidForm(
          checker: passwdProvider.hasDigits,
          text: "숫자 포함",
        ),
        const SizedBox(height: 5),
        ValidForm(
          checker: passwdProvider.hasUpperOrLowercase,
          text: "영문 대문자, 소문자를 모두 포함",
        ),
        const SizedBox(height: 5),
        ValidForm(
          checker: passwdProvider.hasSpecialCharacters,
          text: "특수문자를 포함",
        ),
      ],
    );
  }

  Widget _buildNextButton(
      PasswdProvider passwdProvider, SignupProvider signupProvider) {
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
        onPressed: passwdProvider.isSame && passwdProvider.isValid
            ? () async {
                final String password = _passwordController.text;
                final String confirmPassword = _confirmPasswordController.text;

                if (password.trim().isEmpty || confirmPassword.trim().isEmpty) {
                  MyAlert.fieldNullMsg(context);
                  return;
                }
                signupProvider.setPassword(password);
                Navigator.pushReplacementNamed(context, "/join_third");
              }
            : null,
        child: const Text(
          '다음',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
