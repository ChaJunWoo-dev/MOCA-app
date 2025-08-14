import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prob/api/user_api.dart';
import 'package:prob/provider/signup/nickname_provider.dart';
import 'package:prob/provider/signup/signup_provider.dart';
import 'package:prob/widgets/common/custom_alert.dart';
import 'package:prob/widgets/sign_up_page/valid_form.dart';
import 'package:provider/provider.dart';

class SignUpNickname extends StatefulWidget {
  const SignUpNickname({super.key});

  @override
  State<SignUpNickname> createState() => _SignUpNicknameState();
}

class _SignUpNicknameState extends State<SignUpNickname> {
  late final TextEditingController _nicknameController;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final signupProvider = context.read<SignupProvider>();
      if (signupProvider.email == null || signupProvider.password == null) {
        MyAlert.failShow(context, '잘못된 접근입니다', '/');
      }
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nicknameProvider = context.watch<NicknameProvider>();
    final signupProvider = context.read<SignupProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Text(
          "닉네임을 입력해주세요  :)",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
        ),
        const SizedBox(height: 6),
        const Text(
          "닉네임 규칙을 지켜주세요",
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 30),
        TextField(
          inputFormatters: [LengthLimitingTextInputFormatter(8)],
          controller: _nicknameController,
          decoration: const InputDecoration(
            labelText: '닉네임',
            labelStyle: TextStyle(fontSize: 18),
          ),
          onChanged: (value) {
            nicknameProvider.validateNickname(value);
          },
        ),
        const SizedBox(height: 8),
        _buildValidationMessages(nicknameProvider),
        const SizedBox(height: 20),
        _buildNextButton(nicknameProvider, signupProvider),
      ],
    );
  }

  Widget _buildValidationMessages(NicknameProvider nicknameProvider) {
    return Column(
      children: [
        ValidForm(
          checker: nicknameProvider.isValidLength,
          text: "8자 이내로 구성해주세요",
        ),
        const SizedBox(height: 5),
        ValidForm(
          checker: nicknameProvider.availableNickname,
          text: "사용 가능 목록 : 한글, 영문, 숫자",
        ),
      ],
    );
  }

  Widget _buildNextButton(
      NicknameProvider nicknameProvider, SignupProvider signupProvider) {
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
        onPressed: nicknameProvider.isValid
            ? () async {
                final String nickname = _nicknameController.text;

                if (nickname.trim().isEmpty) {
                  MyAlert.fieldNullMsg(context);
                  return;
                }

                // 닉네임 사용 가능 여부 검증
                final bool isAvailable = await UserApi.checkNickname(nickname);
                if (!isAvailable) {
                  MyAlert.failShow(context, '사용 중인 닉네임이에요', null);
                  return;
                }

                signupProvider.setNickname(nickname);
                Navigator.pushReplacementNamed(context, "/join_end");
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
