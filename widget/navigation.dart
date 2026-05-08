import 'package:flutter/material.dart';
import 'package:praktikum_1/view/homepage.dart';
import 'package:praktikum_1/view/characterpage.dart';
import 'package:praktikum_1/view/storepage.dart'; // Import Store Page

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Daftar halaman tujuan (Home, Character, Store)
  final List<Widget> _pages = const [
    HomePage(),
    CharacterPage(),
    StorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
        decoration: BoxDecoration(
          color: const Color(0xFF0D47A1),
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.6),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded, size: 28),
                label: 'HOME',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.face_rounded, size: 28),
                label: 'CHARACTER',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.store_rounded, size: 28),
                label: 'STORE',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
