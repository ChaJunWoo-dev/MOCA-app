import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFFFFFBF5)),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 37, horizontal: 15),
        child: Column(
          children: [
            // MainCard(),
            // SizedBox(height: 37),
            // CalendarButton(),
          ],
        ),
      ),
    );
  }
}
