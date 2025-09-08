import 'package:flutter/material.dart';
import 'package:zoom_clone/screen/home%20screen/home_screen.dart';
import 'package:zoom_clone/screen/profile_page/profile_page.dart';
import 'package:zoom_clone/screen/settings_screen/settings_page.dart';

class BottomNevigationBarWidget extends StatefulWidget {
  const BottomNevigationBarWidget({super.key});

  @override
  State<BottomNevigationBarWidget> createState() =>
      _BottomNevigationBarWidgetState();
}

class _BottomNevigationBarWidgetState extends State<BottomNevigationBarWidget> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomeScreen(),
    SettingsPage(),
    HomeScreen(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(231, 158, 158, 158),

        // backgroundColor: Theme.of(context).primaryColor,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}
