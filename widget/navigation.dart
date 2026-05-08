import 'package:flutter/material.dart';
import 'package:praktikum_1/view/homepage.dart';
import 'package:praktikum_1/view/adventurepage.dart';
import 'package:praktikum_1/view/characterpage.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Daftar halaman tujuan
  final List<Widget> _pages = const [
    HomePage(),
    AdventurePage(),
    CharacterPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body akan berubah sesuai index yang dipilih
      body: _pages[_currentIndex],
      
      // Menggunakan extendBody agar background halaman bisa "masuk" ke bawah nav bar
      extendBody: true, 
      
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
        decoration: BoxDecoration(
          color: const Color(0xFF0D47A1), // Warna biru gelap sesuai gambar
          borderRadius: BorderRadius.circular(30.0), // Bentuk pill melengkung
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
            backgroundColor: Colors.transparent, // Transparan agar warna Container terlihat
            elevation: 0, // Hilangkan bayangan bawaan
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.6),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                // Menggunakan icon bawaan flutter sebagai placeholder
                icon: Icon(Icons.home_rounded, size: 28), 
                label: 'HOME',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map_rounded, size: 28),
                label: 'ADVENTURE',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.face_rounded, size: 28),
                label: 'CHARACTER',
              ),
            ],
          ),
        ),
      ),
    );
  }
}