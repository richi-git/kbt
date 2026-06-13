import 'package:flutter/material.dart';

class LanguageService {
  // Singleton pattern
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  // ValueNotifier untuk memberitahu seluruh aplikasi saat bahasa berubah
  final ValueNotifier<String> languageNotifier = ValueNotifier<String>('id');

  void changeLanguage(String newLanguage) {
    languageNotifier.value = newLanguage;
  }

  String get currentLanguage => languageNotifier.value;

  // Map terpusat untuk semua teks aplikasi
  static final Map<String, Map<String, Map<String, String>>> _translations = {
    'homepage': {
      'id': {
        'leaderboard': 'LEADERBOARD',
        'play': 'MAIN',
        'play_subtitle': 'Selamat Datang!\nAyo mulai bermain.',
        'practice': 'TUTORIAL',
        'practice_subtitle': 'Pelajari cara bermain\ndan menangkan game!',
        'adventure': 'ADVENTURE',
        'adventure_subtitle': 'Jelajahi dunia\ndan selesaikan misi!',
        'tutorial_title': 'CARA BERMAIN',
        'tutorial_step_1': 'TAHAP 1: Hubungkan 3 kotak dengan menahan dan menggeser jari. Kamu bisa bergerak ke 8 arah (Horizontal, Vertikal, dan Diagonal)!',
        'tutorial_step_2': 'TAHAP 2: Hubungkan angka dengan simbol (+) untuk menjumlahkan nilai.',
        'tutorial_step_3': 'TAHAP 3: Coba gunakan simbol lain seperti (-) atau (x) untuk hasil berbeda.',
        'tutorial_step_4': 'TAHAP TERAKHIR: Capai skor maksimal untuk memenangkan permainan!',
        'tutorial_hint': 'Petunjuk: Tarik garis dari angka ke simbol lalu ke angka lagi.',
        'tutorial_close': 'MENGERTI',
        'tutorial_next': 'LANJUT',
      },
      'en': {
        'leaderboard': 'LEADERBOARD',
        'play': 'PLAY',
        'play_subtitle': 'Welcome!\nLet\'s start playing.',
        'practice': 'TUTORIAL',
        'practice_subtitle': 'Learn how to play\nand win the game!',
        'adventure': 'ADVENTURE',
        'adventure_subtitle': 'Explore the world\nand finish missions!',
        'tutorial_title': 'HOW TO PLAY',
        'tutorial_step_1': 'Welcome to MathLink! Let\'s learn how to play.',
        'tutorial_step_2': 'Select a number to start creating a calculation path.',
        'tutorial_step_3': 'Connect with math symbols (+, -, x, ÷) to get the result.',
        'tutorial_step_4': 'Reach the target number before the enemy (AI) does!',
        'tutorial_step_5': 'Use Skills to help you in difficult situations.',
        'tutorial_close': 'GOT IT',
        'tutorial_next': 'NEXT',
      }
    },
    'leaderboard': {
      'id': {
        'title': 'LEADERBOARD',
        'no_data': 'Belum ada data skor.',
        'points': 'pts',
      },
      'en': {
        'title': 'LEADERBOARD',
        'no_data': 'No score data yet.',
        'points': 'pts',
      }
    },
    'settings': {
      'id': {
        'title': 'PENGATURAN',
        'username': 'NAMA PENGGUNA',
        'volume': 'VOLUME SUARA',
        'language': 'BAHASA',
        'save': 'SIMPAN PERUBAHAN',
        'hint': 'Masukkan nama kamu...',
        'success': 'Pengaturan diperbarui!',
      },
      'en': {
        'title': 'SETTINGS',
        'username': 'USERNAME',
        'volume': 'SOUND VOLUME',
        'language': 'LANGUAGE',
        'save': 'SAVE CHANGES',
        'hint': 'Enter your name...',
        'success': 'Settings updated!',
      }
    },
    'navigation': {
      'id': {
        'home': 'BERANDA',
        'inventory': 'TAS',
        'store': 'TOKO',
      },
      'en': {
        'home': 'HOME',
        'inventory': 'INVENTORY',
        'store': 'STORE',
      }
    },
    'adventure': {
      'id': {
        'title': 'PETUALANGAN',
        'play': 'MAIN',
        'done': 'SELESAI',
        'locked': 'TERKUNCI',
        'city': 'KOTA',
        'village': 'DESA',
        'beach': 'PANTAI',
        'ocean': 'LAUT',
      },
      'en': {
        'title': 'ADVENTURE',
        'play': 'PLAY',
        'done': 'DONE',
        'locked': 'LOCKED',
        'city': 'CITY',
        'village': 'VILLAGE',
        'beach': 'BEACH',
        'ocean': 'OCEAN',
      }
    },
    'store': {
      'id': {
        'title': 'TOKO',
        'subtitle': 'Kustomisasi permainanmu!',
        'tab_skin': 'SKIN KARAKTER',
        'tab_border': 'FRAME BORDER',
        'owned': 'DIMILIKI',
        'buy': 'BELI',
        'buy_success': 'Berhasil membeli ',
        'no_money': 'Koin tidak cukup!',
        'premium_title': 'UPGRADE PREMIUM',
        'premium_subtitle': 'Bebas iklan & Fitur eksklusif!',
        'premium_buy': 'BELI PREMIUM',
        'premium_owned': 'ANDA TELAH PREMIUM',
        'bebas_iklan': 'BEBAS IKLAN',
      },
      'en': {
        'title': 'STORE',
        'subtitle': 'Customize your game!',
        'tab_skin': 'CHARACTER SKINS',
        'tab_border': 'FRAME BORDERS',
        'owned': 'OWNED',
        'buy': 'BUY',
        'buy_success': 'Successfully bought ',
        'no_money': 'Not enough coins!',
        'premium_title': 'UPGRADE PREMIUM',
        'premium_subtitle': 'Ad-free & Exclusive features!',
        'premium_buy': 'BUY PREMIUM',
        'premium_owned': 'YOU ARE PREMIUM',
        'bebas_iklan': 'AD-FREE',
      }
    },
    'inventory': {
      'id': {
        'title': 'INVENTORY',
        'subtitle': 'Atur perlengkapan bermainmu!',
        'tab_skin': 'KARAKTER',
        'tab_border': 'FRAME BORDER',
        'use': 'GUNAKAN',
        'using': 'DIPAKAI',
      },
      'en': {
        'title': 'INVENTORY',
        'subtitle': 'Manage your equipment!',
        'tab_skin': 'CHARACTERS',
        'tab_border': 'FRAME BORDERS',
        'use': 'EQUIP',
        'using': 'EQUIPPED',
      }
    },
    'dialog': {
      'id': {
        'win_title': 'LEVEL SELESAI!',
        'win_content': 'Selamat! Level berikutnya telah terbuka.',
        'win_score': 'Skor kamu: ',
        'win_button': 'KEMBALI KE MAP',
        'lose_title': 'PERMAINAN BERAKHIR!',
        'lose_content': '\nCoba lagi ya!',
        'lose_button': 'KEMBALI KE MAP',
        'pause_title': 'PAUSE',
        'pause_status': 'PERMAINAN DIJEDA',
        'pause_subtitle': 'Pilih tindakan selanjutnya',
        'resume': 'LANJUTKAN',
        'restart': 'ULANGI',
        'home': 'BERANDA',
      },
      'en': {
        'win_title': 'LEVEL COMPLETE!',
        'win_content': 'Congratulations! Next level is now unlocked.',
        'win_score': 'Your score: ',
        'win_button': 'BACK TO MAP',
        'lose_title': 'GAME OVER!',
        'lose_content': '\nTry again!',
        'lose_button': 'BACK TO MAP',
        'pause_title': 'PAUSE',
        'pause_status': 'GAME PAUSED',
        'pause_subtitle': 'Choose your next action',
        'resume': 'RESUME',
        'restart': 'RESTART',
        'home': 'HOME',
      }
    },
    'skills': {
      'id': {
        'MATH HELPER_name': 'MATH HELPER',
        'MATH HELPER_desc': 'Memberi petunjuk jalur jika kamu bingung selama 5 detik.',
        'QUICK SOLVER_name': 'QUICK SOLVER',
        'QUICK SOLVER_desc': 'Menambah jeda waktu berpikir AI sebanyak 1 detik.',
        'POINT BOOSTER_name': 'POINT BOOSTER',
        'POINT BOOSTER_desc': 'Bonus +1 poin ekstra untuk setiap target HARD.',
        'TREASURE HUNTER_name': 'TREASURE HUNTER',
        'TREASURE HUNTER_desc': 'Mendapatkan bonus +50 koin tambahan setiap kali memenangkan level HARD.',
        'SHADOW STRIKE_name': 'SHADOW STRIKE',
        'SHADOW STRIKE_desc': 'Mengurangi target angka AI sebanyak 1 poin di awal permainan.',
        'ROYAL SHIELD_name': 'ROYAL SHIELD',
        'ROYAL SHIELD_desc': 'Memberikan 1x kesempatan salah jawab tanpa mengurangi poin per level.',
        'TECH SCAN_name': 'TECH SCAN',
        'TECH SCAN_desc': 'Mendeteksi jawaban yang benar lebih cepat dengan bantuan sensor.',
        'ROYAL WEALTH_name': 'ROYAL WEALTH',
        'ROYAL WEALTH_desc': 'Mendapatkan koin 2x lipat lebih banyak di setiap level.',
        'GALAXY STRIKE_name': 'GALAXY STRIKE',
        'GALAXY STRIKE_desc': 'Kemenangan instan dengan skor 9999 pts saat kondisi kritis.',
      },
      'en': {
        'MATH HELPER_name': 'MATH HELPER',
        'MATH HELPER_desc': 'Gives path hints if you are confused for 5 seconds.',
        'QUICK SOLVER_name': 'QUICK SOLVER',
        'QUICK SOLVER_desc': 'Adds 1 second thinking time delay for the AI.',
        'POINT BOOSTER_name': 'POINT BOOSTER',
        'POINT BOOSTER_desc': 'Bonus +1 extra point for every HARD target.',
        'TREASURE HUNTER_name': 'TREASURE HUNTER',
        'TREASURE HUNTER_desc': 'Get +50 bonus coins every time you win a HARD level.',
        'SHADOW STRIKE_name': 'SHADOW STRIKE',
        'SHADOW STRIKE_desc': 'Reduces AI target number by 1 point at the start.',
        'ROYAL SHIELD_name': 'ROYAL SHIELD',
        'ROYAL SHIELD_desc': 'Gives 1x chance of wrong answer without point deduction.',
        'TECH SCAN_name': 'TECH SCAN',
        'TECH SCAN_desc': 'Detects the correct answer faster with sensor help.',
        'ROYAL WEALTH_name': 'ROYAL WEALTH',
        'ROYAL WEALTH_desc': 'Get 2x more coins in every level.',
        'GALAXY STRIKE_name': 'GALAXY STRIKE',
        'GALAXY STRIKE_desc': 'Instant victory with 9999 pts when in critical condition.',
      }
    }
  };

  String translate(String page, String key) {
    return _translations[page]?[languageNotifier.value]?[key] ?? key;
  }
}
