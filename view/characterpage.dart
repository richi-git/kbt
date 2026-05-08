import 'package:flutter/material.dart';
import 'package:praktikum_1/config/game_config.dart'; // Import config

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  // Ambil karakter yang sedang aktif dari Config saat halaman dimuat
  late String selectedCharacter;

  @override
  void initState() {
    super.initState();
    selectedCharacter = GameConfig.selectedCharacter;
  }

  // Data Karakter & Skill
  final List<Map<String, dynamic>> characters = [
    {
      "name": "BUBU",
      "image": Icons.smart_toy,
      "color": Colors.blue[400],
      "skill": "MATH HELPER",
      "desc": "Memberi petunjuk jalur jika kamu bingung selama 5 detik.",
      "icon": Icons.lightbulb_rounded
    },
    {
      "name": "BOY",
      "image": Icons.face_rounded,
      "color": Colors.orange[400],
      "skill": "QUICK SOLVER",
      "desc": "Menambah jeda waktu berpikir AI sebanyak 1 detik.",
      "icon": Icons.timer_rounded
    },
    {
      "name": "GIRL",
      "image": Icons.face_3_rounded,
      "color": Colors.purple[400],
      "skill": "POINT BOOSTER",
      "desc": "Mendapat bonus +1 poin ekstra untuk setiap target HARD.",
      "icon": Icons.stars_rounded
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/beachmap.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: characters.map((char) {
                          return Expanded(
                            child: _buildCharacterCard(char),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D47A1).withOpacity(0.9),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Column(
        children: [
          const Text(
            "CHARACTER",
            style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2),
          ),
          Text(
            "Pilih karakter favoritmu!",
            style: TextStyle(
                fontSize: 16,
                color: Colors.blue[100],
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterCard(Map<String, dynamic> char) {
    bool isSelected = selectedCharacter == char['name'];

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCharacter = char['name'];
          GameConfig.selectedCharacter =
              char['name']; // --- SIMPAN KE CONFIG ---
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
              color: isSelected ? Colors.yellowAccent : Colors.white,
              width: isSelected ? 5 : 2),
          boxShadow: [
            BoxShadow(
                color: isSelected
                    ? Colors.orange.withOpacity(0.5)
                    : Colors.black26,
                blurRadius: 10,
                offset: const Offset(0, 5))
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: char['color'],
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Icon(char['image'], size: 70, color: Colors.white),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: const Color(0xFF0D47A1),
              child: Text(char['name'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(char['icon'], color: char['color'], size: 24),
                        const SizedBox(height: 4),
                        Text(char['skill'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: char['color'])),
                        const SizedBox(height: 4),
                        Text(char['desc'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.black87)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 8, right: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedCharacter = char['name'];
                      GameConfig.selectedCharacter =
                          char['name']; // --- SIMPAN KE CONFIG ---
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? Colors.green : Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(isSelected ? "TERPILIH" : "PILIH",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
