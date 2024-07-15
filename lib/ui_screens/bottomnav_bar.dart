
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:splash_practices/auth_screens/signup_screen.dart';
import 'package:splash_practices/custom_widegets/customText.dart';
import 'package:splash_practices/ui_screens/history_screen.dart';
import 'package:splash_practices/ui_screens/home_screen.dart';
import 'package:splash_practices/ui_screens/profile%20screen.dart';
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late PersistentTabController controller;
  @override
  void initState() {
    super.initState();
    controller = PersistentTabController(initialIndex: 0);
  }

  int selectedindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        screens: const [
          HomeScreen(),
          HistoryScreen(),
          ProfileScreen(),
        ],
        items: [
          PersistentBottomNavBarItem(
            activeColorPrimary: Colors.purple,
            activeColorSecondary: Colors.purple,
            inactiveColorPrimary: Colors.black,
            inactiveColorSecondary: Colors.pink,
            icon: const Icon(Icons.home_outlined)),
          PersistentBottomNavBarItem(
              activeColorPrimary: Colors.purple,
              activeColorSecondary: Colors.purple,
              inactiveColorPrimary: Colors.black,
              inactiveColorSecondary: Colors.pink,
              icon: const Icon(Icons.history)),
          PersistentBottomNavBarItem(
              activeColorPrimary: Colors.purple,
              activeColorSecondary: Colors.purple,
              inactiveColorPrimary: Colors.black,
              inactiveColorSecondary: Colors.black,
              icon: const Icon(Icons.person)),
        ],
        onItemSelected: (value) {
          selectedindex = value;
        },
      ),
    );
  }
}
