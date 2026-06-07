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
        'practice': 'LATIHAN',
        'practice_subtitle': 'Asah kemampuan\nmatematika kamu!',
        'adventure': 'ADVENTURE',
        'adventure_subtitle': 'Jelajahi dunia\ndan selesaikan misi!',
      },
      'en': {
        'leaderboard': 'LEADERBOARD',
        'play': 'PLAY',
        'play_subtitle': 'Welcome!\nLet\'s start playing.',
        'practice': 'PRACTICE',
        'practice_subtitle': 'Sharpen your\nmath skills!',
        'adventure': 'ADVENTURE',
        'adventure_subtitle': 'Explore the world\nand finish missions!',
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
    }
  };

  String translate(String page, String key) {
    return _translations[page]?[languageNotifier.value]?[key] ?? key;
  }
}
