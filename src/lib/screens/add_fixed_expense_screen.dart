import 'package:flutter/material.dart';
import 'package:prob/widgets/common/app_speed_dial.dart';
import 'package:prob/widgets/common/my_app_bar.dart';

class AddFixedExpenseScreen extends StatelessWidget {
  const AddFixedExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      floatingActionButton: AppSpeedDial(),
      appBar: MyAppBar(text: '고정비 추가'),
      body: Center(
        child: Text('고정 지출 추가 화면'),
      ),
    );
  }
}
