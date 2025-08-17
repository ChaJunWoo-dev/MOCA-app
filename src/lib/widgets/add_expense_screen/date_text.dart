import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateText extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const DateText({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  State<DateText> createState() => _DateTextState();
}

class _DateTextState extends State<DateText> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
    final threeMonthsLater = DateTime(now.year, now.month + 3, now.day);

    Future<void> onSelectDate() async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        firstDate: threeMonthsAgo,
        lastDate: threeMonthsLater,
        initialDate: now,
      );

      if (pickedDate != null) widget.onDateChanged(pickedDate);
    }

    return GestureDetector(
      onTap: onSelectDate,
      child: Text(
        DateFormat('yyyy년 MM월 dd일').format(
          widget.selectedDate,
        ),
        style: const TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }
}
