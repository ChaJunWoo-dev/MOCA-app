import 'package:flutter/material.dart';
import 'package:prob/widgets/expense_list/expense_list_view.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  static const preButton = 'assets/images/pre_button.png';
  static const calendarImage = 'assets/images/calendar.png';

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('지출 관리'),
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      body: ExpenseListView(
        monthDate: DateTime.now(),
        selectedDay: null,
      ),
    );
  }
}
