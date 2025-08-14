import 'package:flutter/material.dart';

class ErrorAlert extends StatelessWidget {
  const ErrorAlert({
    super.key,
    required this.title,
    required this.content,
    required this.navigatePath,
  });
  final String title;
  final String content;
  final String navigatePath;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: const Text("확인"),
          onPressed: () =>
              Navigator.of(context).pushReplacementNamed(navigatePath),
        ),
      ],
    );
  }
}
