import 'package:flutter/material.dart';
import 'package:prob/api/budget_api.dart';
import 'package:prob/api/total_consume_api.dart';
import 'package:prob/api/user_api.dart';
import 'package:prob/model/user_model.dart';
import 'package:prob/provider/budget_provider.dart';
import 'package:prob/provider/category_provider.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/provider/loading_provider.dart';
import 'package:prob/provider/total_provider.dart';
import 'package:prob/provider/user_provider.dart';
import 'package:prob/service/this_week_cal.dart';
import 'package:prob/widgets/main_page/calendar_button.dart';
import 'package:prob/widgets/main_page/main_card.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final AuthProvider authProvider;
  late final UserProvider userProvider;
  late final BudgetProvider budgetProvider;
  late final TotalProvider totalProvider;
  late final CategoryProvider categoryProvider;
  UserModel? user;

// 페이지가 다시 활성화될 때마다 데이터 로드
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndLoadData();
    });
  }

  Future<void> _checkAndLoadData() async {
    authProvider = context.read<AuthProvider>();
    final MainLoadingProvider loadingProvider =
        context.read<MainLoadingProvider>();
    //토큰 만료 여부 후 만료 시 재발급
    bool isTokenValid = await authProvider.checkAndRefreshToken();
    if (isTokenValid) {
      _fetchData();
    } else {
      loadingProvider.setError("다시 로그인 해주세요");
    }
  }

  Future<void> _fetchData() async {
    //loading
    final MainLoadingProvider loadingProvider =
        context.read<MainLoadingProvider>();
    loadingProvider.setLoading(true);
    loadingProvider.setError(null);

    try {
      userProvider = context.read<UserProvider>();
      budgetProvider = context.read<BudgetProvider>();
      totalProvider = context.read<TotalProvider>();

      if (userProvider.user == null) {
        final user = await UserApi.readUser(authProvider.accessToken);
        userProvider.setUser(user);
      }

      if (budgetProvider.budgetData == null) {
        final budgetData = await BudgetApi.readBudget(authProvider.accessToken);
        budgetProvider.setBudget(budgetData);
      }
      if (totalProvider.monthTotal == null || totalProvider.weekTotal == null) {
        final monthTotal = await TotalConsumeApi.readPreiodTotalMWD(
            'month', authProvider.accessToken);
        final weekTotal = await TotalConsumeApi.readPreiodTotalMWD(
            'week', authProvider.accessToken);
        totalProvider.setMonthTotal(monthTotal);
        totalProvider.setWeekTotal(weekTotal);
        final budget = budgetProvider.budgetData!.budgetAmount;
        //이번주 계산
        DateTime now =
            DateTime.now().toUtc().add(const Duration(hours: 9)); // UTC에 9시간 추가
        int remainingDays = ThisWeekCal.countRemainingDaysInCurrentWeek(now);

        budgetProvider.setRemainBudget(RemainBudget(
            week: (budget ~/ remainingDays - weekTotal),
            month: (budget - monthTotal)));
      }
    } catch (e) {
      loadingProvider.setError("데이터 가져오기 실패!");
    } finally {
      loadingProvider.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFFFFFBF5)),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 37, horizontal: 15),
        child: Column(
          children: [
            MainCard(),
            SizedBox(height: 37),
            CalendarButton(),
          ],
        ),
      ),
    );
  }
}
