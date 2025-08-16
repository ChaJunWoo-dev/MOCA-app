import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:prob/screens/add_expense_screen.dart';
import 'package:prob/screens/add_fixed_expense_screen.dart';
import 'package:prob/screens/main_screen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MainNavigator extends StatelessWidget {
  const MainNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    PersistentTabController controller;

    controller = PersistentTabController(initialIndex: 0);

    List<Widget> buildScreens() {
      return [const MainScreen(), const MainScreen()];
    }

    List<PersistentBottomNavBarItem> navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home_rounded),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
          routeAndNavigatorSettings: RouteAndNavigatorSettings(
            initialRoute: "/main_screen",
            routes: {
              "/main_screen": (final context) => const MainScreen(),
              "/profile": (final context) => const MainScreen(),
            },
          ),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person_rounded),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
          routeAndNavigatorSettings: RouteAndNavigatorSettings(
            initialRoute: "/",
            routes: {
              "/first": (final context) => const MainScreen(),
              "/second": (final context) => const MainScreen(),
            },
          ),
        ),
      ];
    }

    return Stack(
      children: [
        PersistentTabView(
          context,
          controller: controller,
          screens: buildScreens(),
          items: navBarsItems(),
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          hideNavigationBarWhenKeyboardAppears: true,
          popBehaviorOnSelectedNavBarItemPress: PopBehavior.none,
          padding: const EdgeInsets.only(top: 8),
          backgroundColor: Colors.grey.shade900,
          isVisible: true,
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
          confineToSafeArea: true,
          navBarHeight: kBottomNavigationBarHeight,
          navBarStyle: NavBarStyle.style12,
        ),
        Positioned(
          right: 25,
          bottom: 100,
          child: SpeedDial(
            spacing: 10,
            icon: Icons.add,
            activeIcon: Icons.close,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: const CircleBorder(),
            children: [
              SpeedDialChild(
                child: const Icon(Icons.attach_money, color: Colors.white),
                backgroundColor: const Color.fromARGB(255, 241, 130, 130),
                label: '지출',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddExpenseScreen(),
                  ),
                ),
              ),
              SpeedDialChild(
                child: const Icon(Icons.receipt_long, color: Colors.white),
                backgroundColor: const Color.fromARGB(255, 165, 139, 236),
                label: '고정비',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddFixedExpenseScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
