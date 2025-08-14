import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prob/provider/filter_option_provider.dart';
import 'package:prob/provider/period_provider.dart';
import 'package:provider/provider.dart';

class SelectDate extends StatelessWidget {
  const SelectDate({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedPeriod =
        Provider.of<FilterOptionsProvider>(context).selectedPeriod;
    final preiodprovider = Provider.of<Periodprovider>(context);

    DateTime today = DateTime.now();
    late DateTime ago;

    switch (selectedPeriod) {
      case '1개월':
        ago = DateTime(today.year, today.month - 1, today.day);
        break;
      case '3개월':
        ago = DateTime(today.year, today.month - 3, today.day);
        break;
      case '올해':
        ago = DateTime(today.year, 1, 1);
        break;
      default:
        ago = DateTime(today.year, today.month - 1, today.day);
        break;
    }

    // 날짜 포맷팅
    String formattedToday = DateFormat('yyyy-MM-dd').format(today);
    String formattedAgo = DateFormat('yyyy-MM-dd').format(ago);

    // 상태 변경을 build 메서드 바깥으로 옮김
    WidgetsBinding.instance.addPostFrameCallback((_) {
      preiodprovider.setDate(formattedAgo, formattedToday);
    });

    return Text(
      '$formattedAgo~$formattedToday',
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
