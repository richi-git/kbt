import 'package:flutter/material.dart';
import 'package:praktikum_1/service/item_service.dart';
import 'package:praktikum_1/config/game_config.dart';

class ScoreBarWidget extends StatelessWidget {
  final int userScore;
  final int aiScore;

  const ScoreBarWidget({
    super.key,
    this.userScore = 50, // Inventory awal (dummy)
    this.aiScore = 50,
  });

  @override
  Widget build(BuildContext context) {
    // Mencegah error bottleneck jika skor 0
    int flexUser = userScore > 0 ? userScore : 1;
    int flexAi = aiScore > 0 ? aiScore : 1;

    // Ambil data karakter terpilih
    final selectedCharName = GameConfig.selectedCharacter;
    final allSkins = ItemService().skins;
    final selectedChar = allSkins.firstWhere(
      (char) => char.name == selectedCharName,
      orElse: () => allSkins.first,
    );

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.blue[200]!, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar YOU
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: selectedChar.color, width: 2),
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: selectedChar.color.withOpacity(0.2),
                child: selectedChar.imagePath != null
                    ? ClipOval(
                        child: OverflowBox(
                          maxHeight: 120, // Extreme height for coverage
                          maxWidth: 120,
                          alignment: const Alignment(0, -0.6), // Focus on face
                          child: Image.asset(
                            selectedChar.imagePath!,
                            fit: BoxFit.cover, // Fill the entire area
                            filterQuality: FilterQuality.high,
                            errorBuilder: (context, error, stackTrace) => Icon(
                                selectedChar.icon,
                                color: selectedChar.color,
                                size: 28),
                          ),
                        ),
                      )
                    : Icon(selectedChar.icon,
                        color: selectedChar.color, size: 28),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "YOU",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(width: 16),

            // Progress Bar
            Expanded(
              child: Container(
                height: 18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200], // Latar belakang bar
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: flexUser,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4), // Celah kecil di tengah
                    Expanded(
                      flex: flexAi,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red[600],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 16),
            Text(
              "AI",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.red[600],
              ),
            ),
            const SizedBox(width: 12),

            // Avatar AI
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.red, width: 2),
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.red[100],
                child: Icon(Icons.smart_toy_rounded,
                    color: Colors.red[800], size: 26),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
