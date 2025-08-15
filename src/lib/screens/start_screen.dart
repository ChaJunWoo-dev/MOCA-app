import 'package:flutter/material.dart';
import 'package:prob/main_navigator.dart';
import 'package:prob/widgets/common/button.dart';

class StartScreen extends StatelessWidget {
  final VoidCallback onCompleteOnboarding;

  const StartScreen({
    super.key,
    required this.onCompleteOnboarding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'MOCA',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 70,
        ),
        child: Column(
          children: [
            Flexible(
              flex: 3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 160,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text('MOCA와 함께',
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text('똑똑한 소비습관 시작하기!',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(
                      height: 5,
                    ),
                    Text('달력형 조회부터 월별 통계까지',
                        style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    width: double.infinity,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainNavigator(),
                        ),
                      );
                      onCompleteOnboarding();
                    },
                    text: '시작하기',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
