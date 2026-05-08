import 'package:flutter/material.dart';
import 'package:praktikum_1/config/game_config.dart';
import 'package:praktikum_1/view/game_view.dart';

class AdventurePage extends StatefulWidget {
  const AdventurePage({super.key});

  @override
  State<AdventurePage> createState() => _AdventurePageState();
}

class _AdventurePageState extends State<AdventurePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4FC3F7), Color(0xFF1565C0)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Petualangan (Sudah ditambah tombol Back)
              _buildHeader(),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildLevelCard(
                          4, "CITY", Colors.purple, Icons.location_city),
                      _buildPathLine(),
                      _buildLevelCard(
                          3, "VILLAGE", Colors.green, Icons.home_work),
                      _buildPathLine(),
                      _buildLevelCard(
                          2, "BEACH", Colors.orange, Icons.beach_access),
                      _buildPathLine(),
                      _buildLevelCard(1, "OCEAN", Colors.blue, Icons.sailing),
                      const SizedBox(height: 100), // Spasi bawah
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HEADER (DIPERBARUI) ---
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Tombol Back di Kiri
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: const BoxDecoration(
                color:
                    Colors.black26, // Background transparan agar tombol jelas
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white, size: 28),
                onPressed: () {
                  // Fungsi untuk kembali ke halaman sebelumnya (Home)
                  Navigator.pop(context);
                },
              ),
            ),
          ),

          // Teks Judul di Tengah
          const Text(
            "ADVENTURE MAP",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard(int lv, String title, Color color, IconData icon) {
    bool isUnlocked = lv <= GameConfig.latestUnlockedLevel;

    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: isUnlocked ? color.withOpacity(0.9) : Colors.grey[700],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
        ],
      ),
      child: Stack(
        children: [
          // Background Icon sebagai dekorasi
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(icon, size: 100, color: Colors.white12),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Nomor Level
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  child: Text(
                    lv.toString(),
                    style: TextStyle(
                        color: color,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 20),

                // Nama Level
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "LEVEL $lv",
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),

                const Spacer(),

                // Tombol Play atau Lock
                isUnlocked ? _buildPlayButton(lv) : _buildLockedOverlay(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayButton(int lv) {
    return ElevatedButton(
      onPressed: () async {
        // Navigasi ke game dan tunggu hasil (jika menang)
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GameView(
                    bgImagePath:
                        'assets/beachmap.jpeg', // Bisa diganti sesuai map
                    level: lv,
                  )),
        );
        // Refresh halaman saat kembali dari game untuk update gembok level
        setState(() {});
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.greenAccent[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: const Text("PLAY",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildLockedOverlay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        children: [
          Icon(Icons.lock, color: Colors.white, size: 18),
          SizedBox(width: 5),
          Text("LOCKED",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPathLine() {
    return Container(
      height: 40,
      width: 4,
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
