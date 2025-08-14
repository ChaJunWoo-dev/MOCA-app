import 'package:flutter/material.dart';
import 'package:prob/model/budget_model.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/provider/budget_provider.dart';
import 'package:prob/provider/total_provider.dart';
import 'package:prob/widgets/common/line_widget.dart';
import 'package:provider/provider.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<AuthProvider, TotalProvider, BudgetProvider>(
        builder: (context, authProvider, totalProvider, budgetProvider, child) {
      if (totalProvider.dayTotal == null ||
          totalProvider.monthTotal == null ||
          budgetProvider.budgetData == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      int monthTotal = totalProvider.monthTotal!;
      int dayTotal = totalProvider.dayTotal!;
      BudgetModel budgetSchema = budgetProvider.budgetData!;
      String? token = authProvider.accessToken;

      if (token == null) {
        return const Center(
          child: CircularProgressIndicator(), // 로딩 표시
        );
      }
      int budgetAmount = budgetSchema.budgetAmount;
      int remianedBudget = budgetAmount - monthTotal;

      return SizedBox(
        // height: MediaQuery.of(context).size.height / 4,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '이번 달은',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$monthTotal 원',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '오늘은',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "$dayTotal 원",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            LineWidget(
              color: Colors.black,
              height: 1,
              width: MediaQuery.of(context).size.width,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '이번 달 예산 : ',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '$budgetAmount 원',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '남은 예산 : ',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '$remianedBudget 원',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

// class overUseButton extends StatelessWidget {
//   const overUseButton(
//       {super.key,
//       required this.icon,
//       required this.preBudget,
//       required this.preMonthTotal,
//       required this.iconColor});
//   final IconData icon;
//   final int preBudget;
//   final int preMonthTotal;
//   final iconColor;
//   @override
//   Widget build(BuildContext context) {
//     int cal = preBudget - preMonthTotal;
//     return IconButton(
//       icon: Icon(icon),
//       color: iconColor,
//       onPressed: () {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text('저번 달 사용 내역'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('저번 달 예산: $preBudget 원'),
//                   Text('저번 달 사용 금액: $preMonthTotal 원'),
//                   cal < 0 ? Text('초과 금액: $cal 원') : Text('아낀 금액: $cal 원'),
//                 ],
//               ),
//               actions: <Widget>[
//                 TextButton(
//                   child: const Text('확인'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }
