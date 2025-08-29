import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:prob/screens/insight_screen.dart';
import 'package:prob/screens/main_screen.dart';
import 'package:prob/screens/backup_screen.dart';

class MainNavigator extends StatelessWidget {
  const MainNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PersistentTabController(initialIndex: 0);

    final navigationItems = [
      (screen: const MainScreen(), icon: Icons.home_rounded),
      (screen: const InsightScreen(), icon: Icons.insights_rounded),
      (screen: const BackupScreen(), icon: Icons.cloud_upload_rounded),
    ];

    PersistentBottomNavBarItem createNavBarItem(IconData icon) {
      return PersistentBottomNavBarItem(
        icon: Icon(icon),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      );
    }

    List<Widget> buildScreens() {
      return navigationItems.map((item) => item.screen).toList();
    }

    List<PersistentBottomNavBarItem> navBarsItems() {
      return navigationItems
          .map((item) => createNavBarItem(item.icon))
          .toList();
    }

    return BottomNavigator(
      controller: controller,
      buildScreens: buildScreens,
      navBarsItems: navBarsItems,
    );
  }
}

class BottomNavigator extends StatelessWidget {
  final PersistentTabController controller;
  final List<Widget> Function() buildScreens;
  final List<PersistentBottomNavBarItem> Function() navBarsItems;

  const BottomNavigator({
    super.key,
    required this.controller,
    required this.buildScreens,
    required this.navBarsItems,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PersistentTabView(
          context,
          controller: controller,
          screens: buildScreens(),
          items: navBarsItems(),
          hideNavigationBarWhenKeyboardAppears: true,
          padding: const EdgeInsets.only(top: 8),
          backgroundColor: Colors.grey.shade900,
          animationSettings: const NavBarAnimationSettings(
            navBarItemAnimation: ItemAnimationSettings(
              duration: Duration(milliseconds: 400),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: ScreenTransitionAnimationSettings(
              animateTabTransition: true,
              duration: Duration(milliseconds: 200),
              screenTransitionAnimationType:
                  ScreenTransitionAnimationType.fadeIn,
            ),
          ),
          navBarStyle: NavBarStyle.style12,
        ),
      ],
    );
  }
}
