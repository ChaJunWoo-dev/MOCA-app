import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/provider/budget_provider.dart';
import 'package:prob/provider/total_provider.dart';
import 'package:prob/widgets/common/custom_alert.dart';
import 'package:prob/widgets/common/line_widget.dart';
import 'package:provider/provider.dart';
import 'package:prob/api/budget_api.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TotalCard extends StatelessWidget {
  const TotalCard({super.key});

  @override
  Widget build(BuildContext context) {
    final token = context.read<AuthProvider>().accessToken;

    return SizedBox(
      height: 220,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBudgetHeader(context, token),
              const SizedBox(height: 18),
              _buildTotalConsumption(context),
              const SizedBox(height: 6),
              LineWidget(
                color: Colors.black,
                height: 1,
                width: MediaQuery.of(context).size.width,
              ),
              const SizedBox(height: 6),
              _buildBudgetInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  // BudgetProvider와의 상호작용을 통한 헤더 구성
  Widget _buildBudgetHeader(BuildContext context, String? token) {
    return Consumer<BudgetProvider>(
      builder: (context, budgetProvider, _) {
        if (budgetProvider.budgetData == null) {
          return const Skeletonizer(
            enabled: true,
            enableSwitchAnimation: true,
            child: SizedBox(
              height: 50, // 적절한 높이 설정
              width: double.infinity, // 전체 너비
            ),
          );
        }

        // budgetData가 있을 경우
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '이번 달 소비는',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings_suggest_rounded),
              iconSize: 24,
              onPressed: () => _showBudgetUpdateDialog(
                context,
                budgetProvider.budgetData!.budgetAmount,
                token,
              ),
            ),
          ],
        );
      },
    );
  }

  // 총 소비 금액을 보여주는 Row
  Widget _buildTotalConsumption(BuildContext context) {
    return Consumer<TotalProvider>(
      builder: (context, totalProvider, _) {
        if (totalProvider.monthTotal == null) {
          return const Skeletonizer(
            enabled: true,
            child: SizedBox(
              height: 20, // 원하는 높이 설정
              width: double.infinity, // 원하는 너비 설정
            ),
          );
        }
        int monthTotal = totalProvider.monthTotal!;
        MoneyFormatter monthTotalFm =
            MoneyFormatter(amount: monthTotal.toDouble());
        MoneyFormatterOutput MTF = monthTotalFm.output;
        return Align(
          alignment: Alignment.centerRight,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
              children: [
                Text(
                  MTF.withoutFractionDigits,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  " 원",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 예산 및 남은 예산을 보여주는 위젯
  Widget _buildBudgetInfo(BuildContext context) {
    return Consumer2<BudgetProvider, TotalProvider>(
      builder: (context, budgetProvider, totalProvider, _) {
        if (budgetProvider.budgetData == null ||
            totalProvider.monthTotal == null) {
          return const Skeletonizer(
            enabled: true,
            child: SizedBox(
              height: 20, // 원하는 높이 설정
              // width: MediaQuery.of(context).size.width, // 원하는 너비 설정
            ),
          );
        }

        int budget = budgetProvider.budgetData!.budgetAmount;
        int total = totalProvider.monthTotal!;
        int remainedBudget = budget - total;

        MoneyFormatter budgetFm = MoneyFormatter(amount: budget.toDouble());
        MoneyFormatterOutput bf = budgetFm.output;

        MoneyFormatter remainFm =
            MoneyFormatter(amount: remainedBudget.toDouble());
        MoneyFormatterOutput rm = remainFm.output;

        return Column(
          children: [
            _buildBudgetInfoRow('이번 달 예산 : ', '${bf.withoutFractionDigits} 원'),
            const SizedBox(height: 6),
            _buildBudgetInfoRow('남은 예산 : ', '${rm.withoutFractionDigits} 원'),
          ],
        );
      },
    );
  }

  // Label과 Value로 구성된 예산 정보 Row
  Row _buildBudgetInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}

void _showBudgetUpdateDialog(
    BuildContext context, int currentBudget, String? token) {
  final TextEditingController budgetController =
      TextEditingController(text: currentBudget.toString());
  final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
  String? errorMessage;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('예산 변경'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(13), // 최대 자리수 설정
                  ],
                  controller: budgetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '최대 1조까지만 설정 가능해요',
                    errorText: errorMessage,
                  ),
                  maxLengthEnforcement:
                      MaxLengthEnforcement.enforced, // maxLength 적용
                  maxLength: 13,
                  onChanged: (value) {
                    // 입력값이 10억을 초과할 경우, 경고 또는 처리 로직 추가
                    if (value.isNotEmpty &&
                        int.tryParse(value)! > 1000000000000) {
                      // 10억을 초과하면 맨 마지막 입력을 지웁니다.
                      budgetController.text =
                          value.substring(0, value.length - 1);
                      budgetController.selection = TextSelection.fromPosition(
                          TextPosition(offset: budgetController.text.length));
                    }
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('취소'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final newBudget = budgetController.text;
                  if (double.tryParse(newBudget) != null) {
                    bool isOk = await MyAlert.yesOrNoAlert(
                        context,
                        Icons.currency_exchange_rounded,
                        '아래 금액으로 예산을 변경할까요?',
                        '$newBudget 원');
                    if (isOk) {
                      budgetProvider.setBudgetAmount(int.parse(newBudget));
                      await BudgetApi.updateBudget(token, int.parse(newBudget));
                    }
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  } else {
                    // setState를 사용하여 에러 메시지 업데이트
                    setState(() {
                      errorMessage = '숫자를 입력하세요';
                    });
                  }
                },
                child: const Text('저장'),
              ),
            ],
          );
        },
      );
    },
  );
}
