import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../setting/settings_screen.dart';
import '../status/status_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // Default to Home Screen

  final List<Widget> _screens = [
    StatusScreen(), // Replace with StatusScreen()
    const HomeScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor, // Use theme color
        unselectedItemColor: Theme.of(context).iconTheme.color?.withOpacity(0.6), // Dynamic unselected color
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_motion),
            label: "Status",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
