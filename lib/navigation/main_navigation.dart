import 'package:flutter/material.dart';
import '../screens/iv_rate_screen.dart';
import '../screens/dilution_screen.dart';
import '../screens/remaining_time_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const IvRateScreen(),
    const DilutionScreen(),
    const RemainingTimeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: '수액속도'),
          BottomNavigationBarItem(icon: Icon(Icons.medication), label: '약물희석'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: '잔여시간'),
        ],
      ),
    );
  }
}
