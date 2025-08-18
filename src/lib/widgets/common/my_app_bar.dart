import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final FontWeight? weight;

  const MyAppBar({
    super.key,
    required this.text,
    this.weight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        text,
        style: TextStyle(fontWeight: weight),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
