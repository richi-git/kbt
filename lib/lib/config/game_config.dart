import 'package:flutter/material.dart';

class GameConfig {
  // Ukuran grid, misal 8 kolom dan 8 baris
  static const int crossAxisCount = 8;
  static const int mainAxisCount = 8;

  // Daftar operator matematika yang tersedia
  static const List<String> operators = ['+', '-', 'x', '÷'];

// --- SISTEM PROGRES LEVEL ---
  // Level 1 selalu terbuka (unlocked)
  static int latestUnlockedLevel = 4;

// --- TAMBAHAN: Menyimpan Karakter yang Dipilih ---
  static String selectedCharacter = "BUBU"; // Default awal
  static Color selectedBorderColor = Colors.blue; // Default warna border
  static String selectedBorderType = "flow"; // Default tipe animasi
  static String username = "Player 1"; // Default username
  static double volume = 1.0; // Default volume (0.0 to 1.0)
  static String language = "id"; // Default language ('id' or 'en')

  // Rentang angka yang akan muncul (misal 1 sampai 9)
  static const int minNumber = 1;
  static const int maxNumber = 9;
}
