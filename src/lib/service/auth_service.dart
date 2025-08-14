// import 'package:flutter/material.dart';
// import 'package:prob/api/auth_api.dart';
// import 'package:prob/provider/auth_provider.dart';
// import 'package:provider/provider.dart';
// import 'dart:convert';

// class AuthService {
//   //로그인 시도
//   static Future<String?> login(
//       String email, String password, BuildContext context) async {
//     try {
//       final response = await AuthApi.getAccessToken(email, password);
//       final accessToken = response.accessToken;
//       final refreshToken = response.refreshToken;

//       if (!context.mounted) return null;
//       //서버로부터 받은 토큰을 provider에 저장
//       final authProvider = context.read<AuthProvider>();
//       authProvider.setTokens(accessToken, refreshToken);
//       return 'login success';
//     } catch (e) {
//       return '로그인에 실패했습니다. 다시 시도해 주세요.';
//     }
//   }

//   //만료 여부 확인 + 재발급
//   static Future<bool> checkAndRefreshToken(
//       String? accessToken, BuildContext context) async {
//     if (isTokenExpired(accessToken)) {
//       try {
//         final authProvider = context.read<AuthProvider>();
//         String newAccessToken = await refreshAccessToken(context);
//         authProvider.setAccessToken(newAccessToken);
//         return true;
//       } catch (e) {
//         return false;
//       }
//     } else {
//       return true;
//     }
//   }

//   // ******************* 로직 ******************* //
//   //토큰 재발급
//   static Future<String> refreshAccessToken(BuildContext context) async {
//     try {
//       final authProvider = context.read<AuthProvider>();
//       final refreshToken = authProvider.refreshToken;

//       if (!context.mounted) return "fail";

//       if (refreshToken != null) {
//         final response = await AuthApi.refreshToken(refreshToken);
//         final newAccessToken = response.accessToken;

//         return newAccessToken;
//       }
//     } catch (e) {
//       return '로그인 만료. 다시 로그인하세요.';
//     }
//     return "fail";
//   }

//   //토큰 유효 여부 확인
//   static bool isTokenExpired(String? token) {
//     try {
//       if (token == null) {
//         return true; // 만료로 간주
//       }
//       final parts = token.split('.');
//       if (parts.length != 3) {
//         return true; // 잘못된 토큰 형식
//       }

//       // Base64 디코딩을 통해 payload 부분을 추출
//       final payload = parts[1];
//       final normalized = base64Url.normalize(payload);
//       final decoded = utf8.decode(base64Url.decode(normalized));

//       final payloadMap = json.decode(decoded) as Map<String, dynamic>;
//       if (!payloadMap.containsKey('exp')) {
//         return true; // 만료 시간(exp)이 없는 경우
//       }

//       // 현재 시간과 만료 시간을 비교
//       final exp = payloadMap['exp'] as int;
//       final currentTime = DateTime.now().millisecondsSinceEpoch / 1000;
//       return currentTime >= exp; // 만료 시간이 현재 시간보다 이전이면 만료
//     } catch (e) {
//       // 디코딩 실패 : 만료로 간주
//       return true;
//     }
//   }
// }
