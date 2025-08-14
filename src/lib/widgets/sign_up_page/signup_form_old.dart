// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:prob/api/signup_api.dart';
// import 'package:prob/widgets/common/custom_alert.dart';

// class SignupForm extends StatefulWidget {
//   const SignupForm({super.key});

//   @override
//   State<SignupForm> createState() => _SignupFormState();
// }

// class _SignupFormState extends State<SignupForm> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController validNumController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();
//   Map<String, dynamic> errorMessage = {
//     'email': null,
//     'password': null,
//     'nickname': null,
//     'confirmPassword': null,
//     'validNum': null,
//   };
//   bool isSent = false;
//   bool isVerified = false;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   enabled: !isSent,
//                   controller: emailController,
//                   decoration: InputDecoration(
//                     labelText: '이메일',
//                     errorText: errorMessage['email'],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               // 인증 버튼
//               SizedBox(
//                 width: 100,
//                 child: ElevatedButton(
//                   onPressed: isSent
//                       ? null
//                       : () async {
//                           final String email = emailController.text;

//                           // 이메일 유효성 검사
//                           RegExp emailRegex = RegExp(
//                               r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
//                           if (!emailRegex.hasMatch(email)) {
//                             setState(() {
//                               errorMessage['email'] =
//                                   '이메일 형태가 아닙니다. DOBU@example.com';
//                             });
//                             return;
//                           }

//                           // 이메일 중복 체크 API 호출
//                           final bool isEmailAvailable =
//                               await SignupApi.checkId(email);
//                           if (!isEmailAvailable) {
//                             setState(() {
//                               errorMessage['email'] = '이미 사용 중인 이메일입니다.';
//                             });
//                           } else {
//                             final bool sendVerifyCode =
//                                 await SignupApi.createValidEmailNum(email);
//                             if (sendVerifyCode) {
//                               isSent = true;
//                               CustomAlert.show(context, '인증번호를 해당 이메일로 전송했습니다.',
//                                   Colors.green);
//                             } else {
//                               setState(() {
//                                 errorMessage['email'] = '전송 실패. 잠시 후에 시도해주세요.';
//                               });
//                             }

//                             setState(() {
//                               errorMessage['email'] = null;
//                             });
//                           }
//                         },
//                   child: Text(isSent ? '전송됨' : '인증하기'),
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   enabled: !isVerified,
//                   controller: validNumController,
//                   decoration: InputDecoration(
//                     labelText: '인증번호',
//                     errorText: errorMessage['validNum'],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               // 확인 버튼
//               SizedBox(
//                 width: 100,
//                 child: ElevatedButton(
//                   onPressed: isVerified
//                       ? null
//                       : () async {
//                           final String num = validNumController.text;
//                           final String email = emailController.text;

//                           // 이메일 인증 번호 확인
//                           final bool isEmailAvailable =
//                               await SignupApi.validEmailNum(email, num);
//                           if (!isEmailAvailable) {
//                             setState(() {
//                               errorMessage['validNum'] = '인증 번호가 올바르지 않습니다.';
//                             });
//                           } else {
//                             CustomAlert.show(context, '인증되었습니다.', Colors.green);
//                             isVerified = true;
//                             setState(() {
//                               errorMessage['validNum'] = null;
//                             });
//                           }
//                         },
//                   child: Text(isVerified ? '인증됨' : '확인'),
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: nameController,
//                   decoration: InputDecoration(
//                     labelText: '닉네임',
//                     errorText: errorMessage['nickname'],
//                   ),
//                   inputFormatters: [LengthLimitingTextInputFormatter(8)],
//                 ),
//               ),
//               // // 확인 버튼
//               // SizedBox(
//               //   width: 100,
//               //   child: ElevatedButton(
//               //     onPressed: isAvailableNickname ? null : () async {
//               //       final String nickname = nameController.text;

//               //     },
//               //     child: const Text('중복확인'),
//               //   ),
//               // ),
//             ],
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: passwordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: '비밀번호',
//                     hintText: '비밀번호 조건을 지켜주세요',
//                     errorText: errorMessage['password'],
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.info_outline_rounded),
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: const Text("비밀번호 규칙"),
//                         content: const Text(
//                             """1. 8~16글자\n2. 소문자, 숫자, 특수문자를 모두 포함"""),
//                         actions: [
//                           TextButton(
//                             child: const Text("확인"),
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//               ),
//             ],
//           ),
//           TextField(
//             controller: confirmPasswordController,
//             obscureText: true,
//             decoration: InputDecoration(
//               labelText: '비밀번호 확인',
//               errorText: errorMessage['confirmPassword'],
//             ),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () async {
//               final String email = emailController.text;
//               final String nickname = nameController.text;
//               final String password = passwordController.text;
//               final String confirmPassword = confirmPasswordController.text;
//               bool isEmpty(String value) => value.trim().isEmpty;

//               if (isEmpty(email) ||
//                   isEmpty(nickname) ||
//                   isEmpty(password) ||
//                   isEmpty(confirmPassword)) {
//                 CustomAlert.show(context, "모두 입력해주세요.", Colors.black);
//                 return;
//               } else if (!isSent) {
//                 CustomAlert.show(context, "이메일 인증을 먼저 해주세요.", Colors.black);
//                 return;
//               } else if (!isVerified) {
//                 CustomAlert.show(context, "이메일 인증이 완료되지 않았습니다.", Colors.black);
//                 return;
//               }

//               //password verify
//               RegExp hasLowerCase = RegExp(r'[a-z]');
//               RegExp hasDigit = RegExp(r'\d');
//               RegExp hasSpecialCharacter = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

//               if ((password.length < 8 || password.length > 16) ||
//                   !hasLowerCase.hasMatch(password) ||
//                   !hasDigit.hasMatch(password) ||
//                   !hasSpecialCharacter.hasMatch(password)) {
//                 setState(() {
//                   errorMessage['password'] = '비밀번호 조건을 만족하지 않습니다.';
//                 });
//                 return;
//               }

//               // 비밀번호와 비밀번호 확인 일치 검사
//               if (password != confirmPassword) {
//                 setState(() {
//                   errorMessage['confirmPassword'] = '비밀번호와 비밀번호 확인이 일치하지 않습니다.';
//                 });
//                 return;
//               }

//               // 닉네임
//               final bool isAvailable = await SignupApi.checkNickname(nickname);
//               if (!isAvailable) {
//                 setState(() {
//                   CustomAlert.show(context, '사용 불가능한 닉네임입니다.', Colors.black);
//                 });
//               }
//               // 회원가입 로직 실행
//               final bool isSignUp =
//                   await SignupApi.signUp(email, password, nickname);
//               if (!isSignUp) {
//                 // 회원가입 fail
//                 await CustomAlert.signup(
//                     context, '서버 에러 : 회원가입 실패.\n관리자에게 문의하세요.');
//               } else {
//                 // 회원가입 성공
//                 await CustomAlert.signup(context, '회원가입 완료');
//                 Navigator.of(context).pop();
//               }

//               setState(() {
//                 errorMessage.updateAll((key, value) => null); // 성공 시 에러 메시지 초기화
//               });
//             },
//             child: const Text('회원가입'),
//           ),
//         ],
//       ),
//     );
//   }
// }
