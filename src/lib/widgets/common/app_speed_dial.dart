import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:prob/screens/add_expense_screen.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AppSpeedDial extends StatelessWidget {
  const AppSpeedDial({super.key});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      spacing: 10,
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: const CircleBorder(),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.attach_money, color: Colors.white),
          backgroundColor: const Color.fromARGB(255, 241, 130, 130),
          label: '지출',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
            );
          },
        ),
      ],
    );
  }
}
