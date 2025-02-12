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
    StatusScreen(),
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
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: _screens[_selectedIndex], // Display selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: primaryColor, // Use theme color
        // unselectedItemColor: isDarkMode ? Colors.white70 : Colors.grey,
        backgroundColor: theme.scaffoldBackgroundColor, // Match theme
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedIconTheme: IconThemeData(color: primaryColor),
        // unselectedIconTheme: IconThemeData(color: isDarkMode ? Colors.white70 : Colors.grey),
        items: [
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.add, 0, primaryColor),
            label: "Posts",
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.chat_bubble_outline, 1, primaryColor),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.settings_suggest_outlined, 2, primaryColor),
            label: "Settings",
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _selectedIndex == index ? color.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon),
    );
  }
}
