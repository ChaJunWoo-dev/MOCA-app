import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prob/api/mail_api.dart';
import 'package:prob/api/user_api.dart';
import 'package:prob/provider/signup/email_provider.dart';
import 'package:prob/provider/signup/signup_provider.dart';
import 'package:prob/widgets/common/custom_alert.dart';
import 'package:provider/provider.dart';

class SignUpEmail extends StatefulWidget {
  const SignUpEmail({super.key});

  @override
  State<SignUpEmail> createState() => _SignUpEmailState();
}

class _SignUpEmailState extends State<SignUpEmail> {
  late TextEditingController _emailController;
  late TextEditingController _validCodeController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _validCodeController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _validCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emailProvider = context.watch<EmailProvider>();
    final signupProvider = context.read<SignupProvider>();
    Map<dynamic, String> emailErrorMsg = {
      'notEmail': '이메일을 입력해주세요',
      'usedEmail': '이미 가입된 이메일이에요',
      'sendFail': '전송 실패... 관리자에게 문의해주세요',
    };
    Map<dynamic, dynamic> emailAlertMsg = {
      'main': ['이메일로', ' 인증 코드', '를 전송했어요!'],
      'sub': '메일함을 확인해주세요',
    };
    Map<dynamic, String> codeErrorMsg = {
      'wrongCode': '인증 번호가 올바르지 않아요',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        const Text(
          "이메일을 입력해주세요  :)",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 24,
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        const Text(
          "로그인 시 아이디로 사용됩니다",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        TextField(
          inputFormatters: [LengthLimitingTextInputFormatter(200)],
          enabled: !emailProvider.isButtonDisabled,
          controller: _emailController,
          decoration: InputDecoration(
            hintText: 'DOBU@example.com',
            labelText: '이메일',
            labelStyle: const TextStyle(
              fontSize: 18,
            ),
            errorText: emailProvider.emailMessage,
            errorStyle: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // 인증 코드 받기 버튼
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 40,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              textStyle:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              overlayColor: const Color.fromRGBO(1, 1, 1, 1),
              foregroundColor: const Color.fromRGBO(1, 1, 1, 1),
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            ),
            onPressed: emailProvider.isVerified ||
                    emailProvider.isButtonDisabled
                ? null
                : () async {
                    final String email = _emailController.text;
                    // 이메일 유효성 검사
                    RegExp emailRegex = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    if (!emailRegex.hasMatch(email)) {
                      emailProvider.setEmailMessage(emailErrorMsg['notEmail']);
                      return;
                    }

                    // 이메일 중복 체크 API 호출
                    final bool isEmailAvailable =
                        await UserApi.checkEmail(email);
                    if (!isEmailAvailable) {
                      emailProvider.setEmailMessage(emailErrorMsg['usedEmail']);
                      return;
                    } else {
                      // 사용 가능한 이메일임. 코드 전송
                      final bool sendVerifyCode =
                          await SignupApi.createValidEmailNum(email);
                      if (sendVerifyCode) {
                        emailProvider.setEmailMessage(null);
                        if (!context.mounted) return;
                        MyAlert.successAccentShow(context, emailAlertMsg);
                        emailProvider.startTimer();
                      } else {
                        //전송 실패. 서버 오류
                        emailProvider
                            .setEmailMessage(emailErrorMsg['sendFail']);
                      }
                    }
                  },
            child: Text(
              emailProvider.isButtonDisabled
                  ? '${emailProvider.countdown}초 후 재시도'
                  : '인증 코드 받기',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(height: 35),

        // 인증코드
        TextField(
          inputFormatters: [LengthLimitingTextInputFormatter(6)],
          enabled: !emailProvider.isVerified,
          controller: _validCodeController,
          decoration: InputDecoration(
            labelText: '인증코드',
            labelStyle: const TextStyle(
              fontSize: 18,
            ),
            errorText: emailProvider.codeMessage,
            errorStyle: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 40,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              textStyle:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              overlayColor: const Color.fromRGBO(1, 1, 1, 1),
              foregroundColor: const Color.fromRGBO(1, 1, 1, 1),
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            ),
            onPressed: emailProvider.isVerified
                ? null
                : () async {
                    final String code = _validCodeController.text;
                    final String email = _emailController.text;

                    // 이메일 인증 번호 확인
                    final bool isEmailAvailable =
                        await SignupApi.validEmailNum(email, code);
                    if (!isEmailAvailable) {
                      emailProvider.setCodeMessage(codeErrorMsg['wrongCode']);
                    } else {
                      if (!context.mounted) return;
                      emailProvider.toggleIsVerified();
                      emailProvider.setCodeMessage(null);
                      signupProvider.setEmail(email);
                      Navigator.pushReplacementNamed(context, "/join_second");
                    }
                  },
            child: const Text(
              '확인',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}
