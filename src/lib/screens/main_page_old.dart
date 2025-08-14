// import 'package:flutter/material.dart';
// import 'package:prob/api/budget_api.dart';
// import 'package:prob/api/category_api.dart';
// import 'package:prob/api/consume_hist.dart';
// import 'package:prob/api/total_consume_api.dart';
// import 'package:prob/api/user_api.dart';
// import 'package:prob/model/user_model.dart';
// import 'package:prob/provider/calendar/consume_provider.dart';
// import 'package:prob/provider/category_provider.dart';
// import 'package:prob/provider/common/auth_provider.dart';
// import 'package:prob/provider/budget_provider.dart';
// import 'package:prob/provider/loading_provider.dart';
// import 'package:prob/provider/total_provider.dart';
// import 'package:prob/provider/user_provider.dart';
// import 'package:prob/service/auth_service.dart';
// import 'package:prob/widgets/common/custom_alert.dart';
// import 'package:prob/widgets/main_page_old/calendar_view.dart';
// import 'package:prob/widgets/main_page_old/home_header.dart';
// import 'package:prob/widgets/main_page_old/total_card.dart';
// import 'package:provider/provider.dart';
// import 'package:skeletonizer/skeletonizer.dart';

// class MainPageOld extends StatefulWidget {
//   const MainPageOld({super.key});

//   @override
//   State<MainPageOld> createState() => _MainPageOldState();
// }

// class _MainPageOldState extends State<MainPageOld> {
//   late final AuthProvider authProvider;
//   late final UserProvider userProvider;
//   late final BudgetProvider budgetProvider;
//   late final TotalProvider totalProvider;
//   late final ConsumeProvider consumeProvider;
//   late final CategoryProvider categoryProvider;
//   UserModel? user;

// // 페이지가 다시 활성화될 때마다 데이터 로드
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _checkAndLoadData();
//     });
//   }

//   Future<void> _checkAndLoadData() async {
//     authProvider = context.read<AuthProvider>();
//     final MainLoadingProvider loadingProvider =
//         context.read<MainLoadingProvider>();
//     //토큰 만료 여부 후 만료 시 재발급
//     if (authProvider.accessToken != null && authProvider.refreshToken != null) {
//       final tokenValid = await AuthService.checkAndRefreshToken(
//           authProvider.accessToken, authProvider.refreshToken, context);

//       if (tokenValid) {
//         _fetchData();
//       } else {
//         loadingProvider.setError("재로그인 해주세요");
//       }
//     } else {
//       loadingProvider.setError("인증 실패\n 다시 시도해주세요");
//     }
//   }

//   Future<void> _fetchData() async {
//     //loading
//     final MainLoadingProvider loadingProvider =
//         context.read<MainLoadingProvider>();
//     loadingProvider.setLoading(true);
//     loadingProvider.setError(null);

//     try {
//       userProvider = context.read<UserProvider>();
//       budgetProvider = context.read<BudgetProvider>();
//       totalProvider = context.read<TotalProvider>();
//       consumeProvider = context.read<ConsumeProvider>();
//       categoryProvider = context.read<CategoryProvider>();
//       // final chartProvider = context.read<ChartProvider>();

//       if (userProvider.user == null) {
//         final user = await UserApi.readUser(authProvider.accessToken);
//         userProvider.setUser(user);
//       }

//       if (budgetProvider.budgetData == null) {
//         final budgetData = await BudgetApi.readBudget(authProvider.accessToken);
//         budgetProvider.setBudget(budgetData);
//       }

//       if (totalProvider.monthTotal == null) {
//         final monthTotal = await TotalConsumeApi.readPreiodTotalMonth(
//             true, authProvider.accessToken);
//         totalProvider.setMonthTotal(monthTotal);
//       }

//       final consumeHist =
//           await ConsumeHistApi.getHist(authProvider.accessToken, 0, 0);
//       consumeProvider.setHistModel(consumeHist);

//       if (categoryProvider.userCategory.isEmpty) {
//         final userCategory =
//             await CategoryApi.readCategories(authProvider.accessToken);
//         categoryProvider.setCategory(userCategory);
//       }
//       // if (chartProvider.categoryConsume == null) {
//       //   chartProvider.fetchData(authProvider.accessToken);
//       // }
//     } catch (e) {
//       print(e);
//       loadingProvider.setError("데이터 가져오기 실패!");
//     } finally {
//       loadingProvider.setLoading(false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MainLoadingProvider>(
//       builder: (context, loadingProvider, child) {
//         if (loadingProvider.isLoading) {
//           return Skeletonizer(
//             enabled: true,
//             child: _buildMainContent(isLoading: true),
//           );
//         }
//         if (loadingProvider.error != null) {
//           Future.microtask(() => MyAlert.failShow(
//               context, loadingProvider.error ?? '오류 발생!', '/'));
//           return const SizedBox.shrink();
//         }
//         return _buildMainContent(isLoading: false);
//       },
//     );
//   }

//   Widget _buildMainContent({required bool isLoading}) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Skeletonizer(
//               enabled: isLoading,
//               child: const HomeHeader(),
//             ),
//             Skeletonizer(
//               enabled: isLoading,
//               child: const TotalCard(),
//             ),
//             const SizedBox(height: 25),
//             Skeletonizer(
//               enabled: isLoading,
//               child: const CalendarView(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
