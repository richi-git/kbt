import 'package:flutter/material.dart';
import 'package:praktikum_1/view/game_view.dart';
import 'package:praktikum_1/widget/navigation.dart';

// Pastikan path ini sesuai dengan tempat kamu menyimpan GameView.
// Jika masih merah, hapus baris ini, lalu ketik ulang "GameView()"
// di bagian 'home:' di bawah, lalu tekan Ctrl + . (Quick Fix) untuk auto-import.

void main() {
  // Langsung jalankan aplikasi tanpa inisialisasi Firebase/Bloc
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Connect Game',
      debugShowCheckedModeBanner: false, // Menghilangkan pita "DEBUG" di pojok
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      // Langsung arahkan ke tampilan Game
      home: const MainNavigation(),
    );
  }
}
