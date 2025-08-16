import 'package:flutter/material.dart';

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('지출 추가 화면'),
      ),
    );
  }
}
