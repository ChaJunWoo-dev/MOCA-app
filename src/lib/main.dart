import 'package:flutter/material.dart';
import 'package:prob/main_navigator.dart';
import 'package:prob/screens/start_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isFirstRun = prefs.getBool('isFirstRun') ?? true;

  void onCompleteOnboarding() async {
    await prefs.setBool('isFirstRun', false);
  }

  initializeDateFormatting().then(
    (_) => runApp(
      ProviderScope(
        child: MyApp(
          isFirstRun: isFirstRun,
          onCompleteOnboarding: onCompleteOnboarding,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isFirstRun;
  final VoidCallback onCompleteOnboarding;

  const MyApp({
    super.key,
    required this.isFirstRun,
    required this.onCompleteOnboarding,
  });

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
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4CAF93),
        ),
      ),
      home: isFirstRun
          ? StartScreen(
              onCompleteOnboarding: onCompleteOnboarding,
            )
          : const MainNavigator(),
    );
  }
}
