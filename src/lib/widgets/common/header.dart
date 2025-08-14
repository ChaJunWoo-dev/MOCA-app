import 'package:flutter/material.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/provider/home_provider.dart';
import 'package:prob/provider/main_page/calendar_provider.dart';
import 'package:prob/provider/user_provider.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  static const logoImage = 'assets/images/logo.png';
  static const logoutImage = 'assets/images/logout.png';
  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final authProvider = context.read<AuthProvider>();
    final homeProvider = context.read<HomeProvider>();
    final calendarProvider = context.read<CalendarProvider>();
    void logout() {
      userProvider.clearUser();
      authProvider.clearTokens();
      calendarProvider.clear();

      homeProvider.setHomeWidget('mainPage');
      Navigator.pushReplacementNamed(context, '/');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(logoImage, width: 70.5, height: 45, fit: BoxFit.contain),
          ElevatedButton(
            onPressed: logout,
            style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.all(0),
                backgroundColor: Colors.white),
            child: Image.asset(
              logoutImage,
              width: 27.4,
              height: 27.4,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
