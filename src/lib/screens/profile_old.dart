// import 'package:flutter/material.dart';
// import 'package:prob/api/profile_api.dart';
// import 'package:prob/provider/common/auth_provider.dart';
// import 'package:prob/provider/user_provider.dart';
// import 'package:prob/widgets/common/custom_alert.dart';
// import 'package:provider/provider.dart';

// class Profile extends StatelessWidget {
//   const Profile({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);
//     final authProvider = Provider.of<AuthProvider>(context);
//     final token = authProvider.accessToken;
//     void logout() {
//       userProvider.clearUser();
//       authProvider.clearTokens();
//       Navigator.pushReplacementNamed(context, '/');
//     }

//     void showChangePasswordModal() {
//       final currentPasswordController = TextEditingController();
//       final newPasswordController = TextEditingController();
//       final confirmPasswordController = TextEditingController();
//       final formKey = GlobalKey<FormState>();

//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('비밀번호 변경'),
//             content: Form(
//               key: formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextFormField(
//                     controller: currentPasswordController,
//                     obscureText: true,
//                     maxLength: 16,
//                     decoration: const InputDecoration(
//                       labelText: '현재 비밀번호',
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return '현재 비밀번호를 입력해주세요.';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 8.0),
//                   TextFormField(
//                     controller: newPasswordController,
//                     obscureText: true,
//                     maxLength: 16,
//                     decoration: const InputDecoration(
//                       labelText: '새 비밀번호',
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return '새 비밀번호를 입력해주세요.';
//                       }
//                       if (value.length < 8 || value.length > 16) {
//                         return '비밀번호는 8~16글자이어야 합니다.';
//                       }
//                       final hasLowerCase = RegExp(r'[a-z]');
//                       final hasDigit = RegExp(r'\d');
//                       final hasSpecialCharacter =
//                           RegExp(r'[!@#$%^&*(),.?":{}|<>]');
//                       if (!hasLowerCase.hasMatch(value) ||
//                           !hasDigit.hasMatch(value) ||
//                           !hasSpecialCharacter.hasMatch(value)) {
//                         return '비밀번호는 소문자, 숫자, 특수문자를 포함해야 합니다.';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 8.0),
//                   TextFormField(
//                     controller: confirmPasswordController,
//                     obscureText: true,
//                     maxLength: 16,
//                     decoration: const InputDecoration(
//                       labelText: '비밀번호 확인',
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return '비밀번호 확인을 입력해주세요.';
//                       }
//                       return null;
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(); // Close the modal
//                 },
//                 child: const Text('취소'),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (formKey.currentState?.validate() ?? false) {
//                     final currentPassword = currentPasswordController.text;
//                     final newPassword = newPasswordController.text;
//                     final confirmPassword = confirmPasswordController.text;

//                     bool correctCurrentPwd =
//                         await ProfileApi.confirmCurrentPassword(
//                             currentPassword, token);
//                     if (!correctCurrentPwd) {
//                       if (!context.mounted) return;
//                       CustomAlert.show(context, '현재 비밀번호가 아닙니다.', Colors.red);
//                       return;
//                     }
//                     if (newPassword == confirmPassword) {
//                       bool isAvailable = await ProfileApi.changePassword(
//                           currentPassword, newPassword, token);
//                       if (isAvailable) {
//                         if (!context.mounted) return;
//                         CustomAlert.show(
//                             context, '비밀번호가 변경되었습니다.', Colors.black);
//                         Navigator.of(context).pop();
//                       }
//                     } else {
//                       if (!context.mounted) return;
//                       CustomAlert.show(
//                           context, '새 비밀번호와 비밀번호 확인이 일치하지 않습니다.', Colors.red);
//                       return;
//                     }
//                   }
//                 },
//                 child: const Text('확인'),
//               ),
//             ],
//           );
//         },
//       );
//     }

//     void showChangeNicknameModal() {
//       final nickNameController = TextEditingController();
//       final formKey = GlobalKey<FormState>();

//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('닉네임 변경'),
//             content: Form(
//               key: formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextFormField(
//                     controller: nickNameController,
//                     maxLength: 8,
//                     decoration: const InputDecoration(
//                       labelText: '닉네임',
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return '변경할 닉네임을 입력해주세요';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 8.0),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('취소'),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (formKey.currentState?.validate() ?? false) {
//                     final nickName = nickNameController.text;

//                     bool isChanged =
//                         await ProfileApi.changeNickname(nickName, token);
//                     if (isChanged) {
//                       CustomAlert.show(context, '닉네임이 변경되었습니다.', Colors.black);
//                       Navigator.of(context).pop();
//                     } else {
//                       CustomAlert.show(context, '이미 사용 중인 닉네임입니다.', Colors.red);
//                       return;
//                     }
//                   } else {
//                     CustomAlert.show(context, '닉네임을 입력해주세요.', Colors.red);
//                     return;
//                   }
//                 },
//                 child: const Text('확인'),
//               ),
//             ],
//           );
//         },
//       );
//     }

//     // Sample data for announcements
//     final List<Map<String, String>> announcements = [
//       {'date': '2024-08-28', 'title': '서비스 시작', 'description': '편하게 이용해주세요.'},
//       {
//         'date': '2024-08-28',
//         'title': '업데이트 예정 목록.',
//         'description': '1. 아이디, 비밀번호 찾기 2. 카테고리별 소비 차트 3. 유저 게시판'
//       },
//     ];
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Image.asset(
//             'assets/images/logo_dobu.png',
//             width: 250, // 필요에 따라 크기를 조정
//           ),

//           // 비밀번호 변경 버튼
//           ProfileButton(
//             buttonText: "비밀번호 변경",
//             onPressed: showChangePasswordModal,
//           ),
//           // 닉네임 변경 버튼
//           ProfileButton(
//             buttonText: "닉네임 변경",
//             onPressed: showChangeNicknameModal,
//           ),
//           const SizedBox(
//             height: 30,
//           ),
//           // 게시판(공지사항)
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               '공지사항',
//               style: Theme.of(context).textTheme.headlineLarge,
//             ),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 columns: const <DataColumn>[
//                   DataColumn(label: Text('Date')),
//                   DataColumn(label: Text('Title')),
//                   DataColumn(label: Text('Description')),
//                 ],
//                 rows: announcements.map((announcement) {
//                   return DataRow(
//                     cells: <DataCell>[
//                       DataCell(Text(
//                         announcement['date'] ?? '',
//                         overflow: TextOverflow.ellipsis,
//                       )),
//                       DataCell(Text(
//                         announcement['title'] ?? '',
//                         overflow: TextOverflow.ellipsis,
//                       )),
//                       DataCell(Text(
//                         announcement['description'] ?? '',
//                         overflow: TextOverflow.ellipsis,
//                       )),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//           const Spacer(), // 비밀번호 변경과 닉네임 변경 버튼을 위로 밀어내는 역할
//           // 로그아웃 버튼
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextButton(
//               onPressed: logout,
//               child: const Text('로그아웃'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ProfileButton extends StatelessWidget {
//   const ProfileButton({
//     required this.buttonText,
//     required this.onPressed,
//     super.key,
//   });

//   final String buttonText;
//   final VoidCallback onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width, // Set width to screen width
//         child: ElevatedButton(
//           onPressed: onPressed,
//           child: Text(buttonText),
//         ),
//       ),
//     );
//   }
// }
