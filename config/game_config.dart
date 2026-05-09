import 'dart:ui';

import 'package:flutter/material.dart';

class GameConfig {
  // Ukuran grid, misal 8 kolom dan 8 baris
  static const int crossAxisCount = 8;
  static const int mainAxisCount = 8;

  // Daftar operator matematika yang tersedia
  static const List<String> operators = ['+', '-', 'x', '÷'];

// --- SISTEM PROGRES LEVEL ---
  // Level 1 selalu terbuka (unlocked)
  static int latestUnlockedLevel = 1;

// --- TAMBAHAN: Menyimpan Karakter yang Dipilih ---
  static String selectedCharacter = "BUBU"; // Default awal
  static Color selectedBorderColor = Colors.blue[300]!; // Default warna border

  // Rentang angka yang akan muncul (misal 1 sampai 9)
  static const int minNumber = 1;
  static const int maxNumber = 9;
}
