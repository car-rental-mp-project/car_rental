import 'package:car_rent/Screens/cars_list_page.dart';
import 'package:car_rent/Screens/cars_home_page.dart';
import 'package:car_rent/Screens/car_details_page.dart';
import 'package:car_rent/Screens/add_car.dart';
import 'package:car_rent/Screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:car_rent/utils/colors.dart' as AppColors;

import 'notifications_page.dart';

class NavPage extends StatefulWidget {
  const NavPage({Key? key}) : super(key: key);

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int currentIndex = 0;

  final screens = [
    const CarsHomePage(),
    const CarsListPage(),
    const AddCarScreen(),
    const NotificationsPage(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: AppColors.backgroundColor,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          onTap: (index) => setState(() => currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.directions_car), label: 'Cars'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Share'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'Notifications'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ));
  }
}
