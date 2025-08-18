import 'package:flutter/material.dart';

class InsightScreen extends StatelessWidget {
  const InsightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('통계'),
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      body: const Placeholder(),
    );
  }
}
