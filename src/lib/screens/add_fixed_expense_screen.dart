import 'package:flutter/material.dart';

class AddFixedExpenseScreen extends StatelessWidget {
  const AddFixedExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('고정 지출 추가 화면'),
      ),
    );
  }
}
