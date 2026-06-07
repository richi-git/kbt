import 'package:flutter/material.dart';
import 'package:praktikum_1/widget/navigation.dart';
import 'package:praktikum_1/service/language_service.dart';

// Pastikan path ini sesuai dengan tempat kamu menyimpan GameView.
// Jika masih merah, hapus baris ini, lalu ketik ulang "GameView()"
// di bagian 'home:' di bawah, lalu tekan Ctrl + . (Quick Fix) untuk auto-import.

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Langsung jalankan aplikasi tanpa inisialisasi Firebase/Bloc
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LanguageService().languageNotifier,
      builder: (context, language, child) {
        return MaterialApp(
          key: ValueKey(language), // Force rebuild when language changes
          title: 'Math Connect Game',
          debugShowCheckedModeBanner: false, // Menghilangkan pita "DEBUG" di pojok
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
            useMaterial3: true,
          ),
          // Langsung arahkan ke tampilan Game
          home: const MainNavigation(),
        );
      },
    );
  }
}
