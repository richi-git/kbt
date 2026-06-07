class LeaderboardEntry {
  final String username;
  final int score;
  final String? profilePic;

  LeaderboardEntry({
    required this.username,
    required this.score,
    this.profilePic,
  });

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntry(
      username: map['username'] ?? 'Anonymous',
      score: map['score'] ?? 0,
      profilePic: map['profilePic'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'score': score,
      'profilePic': profilePic,
    };
  }
}
