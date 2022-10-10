import 'package:flutter/material.dart';
import 'package:spending_management/views/inner_screen/analytic_screen.dart';
import 'package:spending_management/views/inner_screen/home_screen.dart';
import 'package:spending_management/views/inner_screen/profile_screen.dart';
import 'package:spending_management/views/inner_screen/spending_screen.dart';

class MainScreen extends StatefulWidget {
  String currentUserId;
  MainScreen({required this.currentUserId, Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectIndex = 0;

  final _listBottomNav = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Trang chủ',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.money),
      label: 'Chi tiêu',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.analytics),
      label: 'Thống kê',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Hồ sơ',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final listPage = [
      const HomeScreen(),
      const SpendingScreen(),
      const AnalyticScreen(),
      ProfileScreen(currentUserId: widget.currentUserId,),
    ];
    return Scaffold(
      body: listPage[_selectIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.blue,
        currentIndex: _selectIndex,
        onTap: (index) {
          setState(() {
            _selectIndex = index;
          });
        },
        items: _listBottomNav,
      ),
    );
  }
}
