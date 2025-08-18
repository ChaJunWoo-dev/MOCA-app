import 'package:flutter/material.dart';
import 'package:prob/widgets/common/my_app_bar.dart';

class InsightScreen extends StatelessWidget {
  const InsightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(
        text: '통계',
        weight: FontWeight.bold,
      ),
      body: Placeholder(),
    );
  }
}
