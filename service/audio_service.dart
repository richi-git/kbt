import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _sfxPlayer = AudioPlayer();

  // Variabel untuk mencatat kapan terakhir kali suara diputar
  static DateTime _lastPlayed =
      DateTime.now().subtract(const Duration(seconds: 2));

  static Future<void> playSuccessSFX() async {
    // ANTI-SPAM (Debounce): Jika jarak dari suara terakhir kurang dari 500 milidetik, abaikan
    if (DateTime.now().difference(_lastPlayed).inMilliseconds < 500) {
      return;
    }
    _lastPlayed = DateTime.now();

    try {
      // Gunakan ReleaseMode.stop agar audio otomatis bersih dari memori setelah selesai bunyi
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);

      // Putar audio
      await _sfxPlayer.play(
          AssetSource('audio/Bubble Pop Sound Effect - DigitalDials.mp3'));
    } catch (e) {
      print("Gagal memutar audio: $e");
    }
  }

  // BGM (Biarkan jika nanti mau dipakai)
  static final AudioPlayer _bgmPlayer = AudioPlayer();
  static Future<void> playBGM() async {
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer.play(AssetSource('audio/background_music.mp3'));
  }
}
