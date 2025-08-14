import 'package:flutter/material.dart';
import 'package:prob/provider/budget_provider.dart';
import 'package:prob/provider/main_page/card_option_provider.dart';
import 'package:prob/provider/total_provider.dart';
import 'package:prob/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MainCard extends StatelessWidget {
  const MainCard({super.key});
  static const cardTextColor = Color(0xFF707070);
  static const imageColor = Color(0xFFE39B3D);
  static const clapImage = 'assets/images/clap.png';
  static const progressBarVPadding = 44.0;
  static const textColSpacer = SizedBox(height: 15);
  final textStyle = const TextStyle(color: cardTextColor, fontSize: 18);
  @override
  Widget build(BuildContext context) {
    return Consumer4<UserProvider, CardOptionProvider, BudgetProvider,
            TotalProvider>(
        builder: (context, userProvider, optionProvider, budgetProvider,
            totalProvider, child) {
      return Skeletonizer(
        enableSwitchAnimation: true,
        enabled: userProvider.user == null ||
            budgetProvider.budgetData == null ||
            totalProvider.monthTotal == null ||
            totalProvider.weekTotal == null,
        child: Container(
          // margin: const EdgeInsets.symmetric(vertical: 37, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 21, top: 49),
            child: Column(
              children: [
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildUserInfo(userProvider, textStyle),
                        textColSpacer,
                        _buildCardOptions(optionProvider, textStyle),
                        textColSpacer,
                        Text('남은 예산은', style: textStyle),
                        textColSpacer,
                        _buildBudgetInfo(
                            optionProvider, budgetProvider, textStyle),
                        textColSpacer,
                      ],
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Transform.translate(
                        offset: const Offset(10, -35),
                        child: Image.asset(
                          clapImage,
                          color: imageColor,
                          width: 178,
                        ),
                      ),
                    ),
                  ],
                ),
                const ProgressBar(
                  verticalPadding: progressBarVPadding,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildUserInfo(UserProvider userProvider, TextStyle textStyle) {
    return userProvider.user != null
        ? Row(
            children: [
              Text(
                userProvider.user!.nickname,
                style: textStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 3),
              Text('님의', style: textStyle),
            ],
          )
        : const SizedBox(width: 8);
  }

  Widget _buildCardOptions(
      CardOptionProvider optionProvider, TextStyle textStyle) {
    return SizedBox(
      height: 40,
      child: Row(
        children: <Widget>[
          CardOptionButton(
            text: '이번달',
            textStyle: textStyle,
            provider: optionProvider,
            weight: optionProvider.isMonth,
          ),
          const VerticalDivider(
            color: MainCard.cardTextColor,
            width: 20,
            thickness: 2,
            endIndent: 10,
            indent: 10,
          ),
          CardOptionButton(
            text: '이번주',
            textStyle: textStyle,
            provider: optionProvider,
            weight: optionProvider.isMonth == false,
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetInfo(CardOptionProvider optionProvider,
      BudgetProvider budgetProvider, TextStyle textStyle) {
    return Row(
      children: [
        Text(
          optionProvider.isMonth
              ? '${budgetProvider.remainBudget?.month ?? 0}'
              : '${budgetProvider.remainBudget?.week ?? 0}',
          style: textStyle.copyWith(
              fontWeight: FontWeight.bold, color: imageColor),
        ),
        const SizedBox(width: 8),
        Text('원 입니다.', style: textStyle),
      ],
    );
  }
}

class CardOptionButton extends StatelessWidget {
  const CardOptionButton({
    super.key,
    required this.textStyle,
    required this.text,
    required this.provider,
    required this.weight,
  });

  final TextStyle textStyle;
  final String text;
  final CardOptionProvider provider;
  final bool weight;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => provider.setIsMonth(),
      child: Text(text,
          style: textStyle.copyWith(
              fontWeight: weight ? FontWeight.bold : FontWeight.normal)),
    );
  }
}

class ProgressBar extends StatelessWidget {
  const ProgressBar({required this.verticalPadding, super.key});

  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: 21, top: verticalPadding, bottom: verticalPadding),
      child: Consumer2<CardOptionProvider, BudgetProvider>(
        builder: (context, optionProvider, budgetProvider, child) {
          if (budgetProvider.remainBudget == null ||
              budgetProvider.budgetData == null) {
            return LinearPercentIndicator(
              padding: EdgeInsets.zero,
              percent: 1,
              lineHeight: 10,
              barRadius: const Radius.circular(10),
              backgroundColor: const Color.fromRGBO(227, 155, 61, 0.32),
              progressColor: const Color(0xFFE39B3D),
            );
          }
          return LinearPercentIndicator(
            padding: EdgeInsets.zero,
            percent: optionProvider.isMonth
                ? budgetProvider.remainBudget!.month <= 0
                    ? 0
                    : (budgetProvider.remainBudget!.month /
                        budgetProvider.budgetData!.budgetAmount)
                : budgetProvider.remainBudget!.week <= 0
                    ? 0
                    : (budgetProvider.remainBudget!.week /
                        budgetProvider.budgetData!.budgetAmount),
            lineHeight: 10,
            barRadius: const Radius.circular(10),
            backgroundColor: const Color.fromRGBO(227, 155, 61, 0.32),
            progressColor: const Color(0xFFE39B3D),
          );
        },
      ),
    );
  }
}
