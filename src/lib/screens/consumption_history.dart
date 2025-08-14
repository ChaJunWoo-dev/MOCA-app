// import 'package:flutter/material.dart';
// import 'package:prob/api/total_consume_api.dart';
// import 'package:prob/provider/common/auth_provider.dart';
// import 'package:prob/provider/loading_provider.dart';
// import 'package:prob/provider/total_provider.dart';
// import 'package:prob/service/auth_service.dart';
// import 'package:prob/widgets/history_details/history_card.dart';
// import 'package:prob/widgets/main_page_old/chart.dart';
// import 'package:prob/widgets/main_page_old/home_header.dart';
// import 'package:prob/widgets/history_details/calculator_widget.dart';
// import 'package:provider/provider.dart';

// class ConsumptionHistory extends StatefulWidget {
//   const ConsumptionHistory({super.key});

//   @override
//   State<ConsumptionHistory> createState() => _ConsumptionHistoryState();
// }

// class _ConsumptionHistoryState extends State<ConsumptionHistory> {
//   late final AuthProvider authProvider;

//   @override
//   void initState() {
//     super.initState();
//     _checkAndLoadData();
//   }

//   Future<void> _checkAndLoadData() async {
//     authProvider = context.read<AuthProvider>();
//     final ConsumeHistLoadingProvider loadingProvider =
//         context.read<ConsumeHistLoadingProvider>();
//     //토큰 만료 여부 후 만료 시 재발급
//     if (authProvider.accessToken != null && authProvider.refreshToken != null) {
//       final tokenValid = await AuthService.checkAndRefreshToken(
//           authProvider.accessToken, authProvider.refreshToken, context);

//       if (tokenValid) {
//         _fetchTodayTotal();
//       } else {
//         loadingProvider.setError("재로그인 해주세요");
//       }
//     } else {
//       loadingProvider.setError("인증 실패\n 다시 시도해주세요");
//     }
//   }

//   Future<void> _fetchTodayTotal() async {
//     final totalProvider = context.read<TotalProvider>();
//     if (totalProvider.dayTotal == null) {
//       final todayTotal = await TotalConsumeApi.readPreiodTotalMWD(
//           'day', authProvider.accessToken);
//       totalProvider.setDayTotal(todayTotal);
//     }
//     if (totalProvider.monthTotal == null) {
//       final monthTotal = await TotalConsumeApi.readPreiodTotalMWD(
//           'month', authProvider.accessToken);
//       totalProvider.setMonthTotal(monthTotal);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             HomeHeader(),
//             SizedBox(
//               height: 18,
//             ),
//             Column(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(20.0),
//                   child: HistoryCard(),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // AddModal(isLightTheme: true),
//                       CalculatorWidget(
//                         isLightTheme: true,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 55,
//                 ),
//                 Chart()
//                 // HistoryDetails()
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
