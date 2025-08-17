import 'package:flutter/material.dart';

class ExpenseTextField extends StatelessWidget {
  final String? placeholderText;
  final TextEditingController controller;

  const ExpenseTextField({
    super.key,
    required this.placeholderText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.primary,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: placeholderText,
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 17,
        ),
      ),
    );
  }
}
