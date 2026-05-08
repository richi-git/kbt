import 'package:flutter/material.dart';

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

    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("YOU",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("AI",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              Expanded(
                flex: flexUser,
                child: Container(height: 20, color: Colors.blue[700]),
              ),
              Expanded(
                flex: flexAi,
                child: Container(height: 20, color: Colors.redAccent),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
