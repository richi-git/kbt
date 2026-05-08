import 'package:flutter/material.dart';

class ScoreBarWidget extends StatelessWidget {
  final int userScore;
  final int aiScore;

  const ScoreBarWidget({
    super.key,
    this.userScore = 50,
    this.aiScore = 50,
  });

  @override
  Widget build(BuildContext context) {
    int flexUser = userScore > 0 ? userScore : 1;
    int flexAi = aiScore > 0 ? aiScore : 1;

    return Row(
      children: [
        // Avatar Pemain
        const CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.person, color: Colors.white, size: 30),
        ),
        const SizedBox(width: 12),

        // Progress Bar
        Expanded(
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("YOU",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.blue)),
                  Text("AI",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.red)),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2))
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    children: [
                      Expanded(
                          flex: flexUser,
                          child: Container(color: Colors.blue[600])),
                      Expanded(
                          flex: flexAi,
                          child: Container(color: Colors.redAccent)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),
        // Avatar AI Robot
        const CircleAvatar(
          radius: 24,
          backgroundColor: Colors.redAccent,
          child: Icon(Icons.smart_toy, color: Colors.white, size: 30),
        ),
      ],
    );
  }
}
