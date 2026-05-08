import 'package:flutter/material.dart';
import 'package:praktikum_1/view/adventurepage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4FC3F7),
              Color(0xFF81C784)
            ], // Biru langit ke Hijau rumput
          ),
        ),
        child: SafeArea(
          // Center & ConstrainedBox: Menjaga UI tetap simetris & tidak melar di layar Web/PC
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                child: Column(
                  children: [
                    // === HEADER: Logo, Leaderboard, & Settings ===
                    _buildHeader(),

                    const Spacer(),

                    // === KONTEN UTAMA: Banner Welcome & Tombol PLAY ===
                    _buildMainBanner(context),

                    const SizedBox(height: 16),

                    // === KONTEN BAWAH: Tombol Latihan & Adventure ===
                    Row(
                      children: [
                        Expanded(child: _buildLatihanButton()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildAdventureButton()),
                      ],
                    ),

                    const Spacer(),
                    const SizedBox(
                        height: 60), // Ekstra spasi untuk custom navigation bar
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET HEADER (Diperbarui dengan Stack) ---
  Widget _buildHeader() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Logo MATH LINK di tengah layar
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "MATH",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.0, // Merapatkan jarak teks
                shadows: [
                  Shadow(
                      color: Colors.blue[900]!,
                      offset: const Offset(2, 2),
                      blurRadius: 4),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(
                  0, -4), // Menggeser kotak LINK agar menempel dengan MATH
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber[600],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.brown[800]!, width: 2),
                ),
                child: const Text(
                  "LINK",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.0),
                ),
              ),
            ),
          ],
        ),

        // Tombol Kanan (Leaderboard & Settings)
        Align(
          alignment: Alignment.topRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                    SizedBox(width: 4),
                    Text("LEADERBOARD",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child:
                    const Icon(Icons.settings, color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- WIDGET BANNER UTAMA (PLAY) ---
  Widget _buildMainBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[700]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: const [
          BoxShadow(color: Colors.black26, offset: Offset(0, 8), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          // Mascot Placeholder
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
                color: Colors.blueAccent, shape: BoxShape.circle),
            child: const Icon(Icons.smart_toy, size: 60, color: Colors.white),
          ),
          const SizedBox(width: 24),

          // Teks & Tombol
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Welcome!",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const Text(
                  "Let's play and learn!",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),

                // TOMBOL PLAY (Dibatasi lebarnya)
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdventurePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[500],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      "PLAY",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET TOMBOL LATIHAN ---
  Widget _buildLatihanButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber[400]!, Colors.orange[500]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.menu_book_rounded, size: 40, color: Colors.brown[600]),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("LATIHAN",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text("Asah kemampuan\nmatematika kamu!",
                    style: TextStyle(
                        fontSize: 12, color: Colors.white, height: 1.2)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET TOMBOL ADVENTURE ---
  Widget _buildAdventureButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[400]!, Colors.deepPurple[500]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.explore_rounded, size: 40, color: Colors.lightBlue[100]),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ADVENTURE",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text("Jelajahi dunia\ndan selesaikan misi!",
                    style: TextStyle(
                        fontSize: 12, color: Colors.white, height: 1.2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
