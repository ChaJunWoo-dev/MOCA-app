import 'package:flutter/material.dart';
import 'package:prob/widgets/common/app_speed_dial.dart';
import 'package:prob/widgets/common/my_app_bar.dart';

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      floatingActionButton: AppSpeedDial(),
      appBar: MyAppBar(
        text: '가계부',
        weight: FontWeight.bold,
      ),
      body: Placeholder(),
    );
  }
}
