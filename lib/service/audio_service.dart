import 'package:audioplayers/audioplayers.dart';
import 'package:praktikum_1/config/game_config.dart';

class AudioService {
  static final AudioPlayer _successPlayer = AudioPlayer();
  static final AudioPlayer _bubblePlayer = AudioPlayer();

  // Variabel untuk mencatat kapan terakhir kali suara diputar secara terpisah
  static DateTime _lastSuccessPlayed =
      DateTime.now().subtract(const Duration(seconds: 2));
  static DateTime _lastBubblePlayed =
      DateTime.now().subtract(const Duration(seconds: 2));

  static Future<void> updateVolume() async {
    await _successPlayer.setVolume(GameConfig.volume);
    await _bubblePlayer.setVolume(GameConfig.volume);
    await _bgmPlayer.setVolume(GameConfig.volume);
  }

  static Future<void> playSuccessSFX() async {
    if (DateTime.now().difference(_lastSuccessPlayed).inMilliseconds < 400) {
      return;
    }
    _lastSuccessPlayed = DateTime.now();

    try {
      await _successPlayer.stop();
      await _successPlayer.setVolume(GameConfig.volume);
      await _successPlayer.play(AssetSource('audio/bubble_pop.mp3'));
    } catch (e) {
      print("Error playing success SFX: $e");
    }
  }

  static Future<void> playBubblePopSFX() async {
    if (DateTime.now().difference(_lastBubblePlayed).inMilliseconds < 20) {
      return;
    }
    _lastBubblePlayed = DateTime.now();

    try {
      await _bubblePlayer.stop();
      await _bubblePlayer.setVolume(GameConfig.volume);
      await _bubblePlayer.play(AssetSource('audio/bubble_pop.mp3'), mode: PlayerMode.lowLatency);
    } catch (e) {
      print("Error playing bubble pop SFX: $e");
    }
  }

  // BGM
  static final AudioPlayer _bgmPlayer = AudioPlayer();

  static Future<void> playBGM() async {
    // Jika sudah main, jangan mulai lagi
    if (_bgmPlayer.state == PlayerState.playing) return;
    
    try {
      await _bgmPlayer.stop();
      await _bgmPlayer.setSource(AssetSource('audio/bgm_mathlink.mp3'));
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.setVolume(GameConfig.volume);
      await _bgmPlayer.resume();
    } catch (e) {
      print("Error playing BGM: $e. Make sure assets/audio/bgm_mathlink.mp3 exists.");
    }
  }

  static Future<void> stopBGM() async {
    await _bgmPlayer.stop();
  }

  static Future<void> toggleBGM(bool play) async {
    if (play) {
      await playBGM();
    } else {
      await stopBGM();
    }
  }
}
