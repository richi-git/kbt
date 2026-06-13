import 'dart:async';
import 'dart:convert';
import 'package:praktikum_1/model/leaderboard_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardService {
  static final LeaderboardService _instance = LeaderboardService._internal();
  factory LeaderboardService() => _instance;
  LeaderboardService._internal();

  static const String _storageKey = 'leaderboard_data';
  
  // StreamController untuk memantau perubahan data secara real-time
  final StreamController<List<LeaderboardEntry>> _controller = 
      StreamController<List<LeaderboardEntry>>.broadcast();

  final List<LeaderboardEntry> _defaultData = [
    LeaderboardEntry(username: "Bubu Master", score: 2500),
    LeaderboardEntry(username: "Math Ninja", score: 2100),
    LeaderboardEntry(username: "Logic King", score: 1850),
    LeaderboardEntry(username: "Speed Solver", score: 1600),
    LeaderboardEntry(username: "Brainy Girl", score: 1450),
    LeaderboardEntry(username: "Number Cruncher", score: 1200),
    LeaderboardEntry(username: "Prime Seeker", score: 1100),
    LeaderboardEntry(username: "Equation Pro", score: 950),
    LeaderboardEntry(username: "Digit Dash", score: 800),
    LeaderboardEntry(username: "Zero Hero", score: 750),
  ];

  Future<void> saveScore(String username, int score) async {
    final prefs = await SharedPreferences.getInstance();
    List<LeaderboardEntry> currentData = await _loadFromStorage();
    
    // Tambahkan skor baru
    currentData.add(LeaderboardEntry(username: username, score: score));
    
    // Urutkan skor tertinggi ke terendah
    currentData.sort((a, b) => b.score.compareTo(a.score));
    
    // Simpan maksimal 20 besar
    if (currentData.length > 20) {
      currentData = currentData.sublist(0, 20);
    }

    final String encodedData = jsonEncode(
      currentData.map((e) => e.toMap()).toList(),
    );
    await prefs.setString(_storageKey, encodedData);
    
    // Beritahu semua listener bahwa data telah berubah
    _controller.add(currentData);
  }

  Future<List<LeaderboardEntry>> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_storageKey);
    
    if (encodedData == null) {
      return List.from(_defaultData);
    }

    try {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      return decodedData.map((e) => LeaderboardEntry.fromMap(e)).toList();
    } catch (e) {
      return List.from(_defaultData);
    }
  }

  Stream<List<LeaderboardEntry>> getLeaderboard() {
    // Gunakan Stream.fromFuture untuk emisi pertama, lalu gabungkan dengan controller
    // Agar StreamBuilder mendapatkan data awal meskipun data tersimpan di storage
    
    StreamController<List<LeaderboardEntry>> localController = StreamController<List<LeaderboardEntry>>();
    
    _loadFromStorage().then((data) {
      if (!localController.isClosed) {
        localController.add(data);
      }
      
      // Setelah data awal dikirim, dengarkan perubahan dari controller utama
      _controller.stream.listen((updatedData) {
        if (!localController.isClosed) {
          localController.add(updatedData);
        }
      });
    });

    return localController.stream;
  }
}
