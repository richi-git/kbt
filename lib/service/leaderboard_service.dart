import 'dart:async';
import 'package:praktikum_1/model/leaderboard_entry.dart';

class LeaderboardService {
  // Data dummy statis untuk sementara
  static final List<LeaderboardEntry> _dummyData = [
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
    // Mock save score: Tidak melakukan apa-apa ke server
    print('Mock saving score for $username: $score');
    
    // Opsional: Bisa ditambahkan ke list lokal jika ingin simulasi
    // Namun karena datanya statis, akan hilang saat restart.
  }

  Stream<List<LeaderboardEntry>> getLeaderboard() {
    // Mengembalikan data dummy sebagai stream untuk mensimulasikan database
    return Stream.value(_dummyData);
  }
}
