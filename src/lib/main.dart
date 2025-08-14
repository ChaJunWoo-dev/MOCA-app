import 'package:flutter/material.dart';
import 'package:prob/screens/start_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 43, 43, 43),
          ),
          headlineSmall: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            color: Colors.grey,
          ),
        ),
      ),
      home: const StartScreen(),
    );
  }
}
