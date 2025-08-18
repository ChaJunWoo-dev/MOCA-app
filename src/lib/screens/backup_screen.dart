import 'package:flutter/material.dart';

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('데이터 백업'),
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      body: const Placeholder(),
    );
  }
}
