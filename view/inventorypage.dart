import 'package:flutter/material.dart';
import 'package:praktikum_1/config/game_config.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late String activeCharacter;
  late Color activeBorder;

  @override
  void initState() {
    super.initState();
    activeCharacter = GameConfig.selectedCharacter;
    activeBorder = GameConfig.selectedBorderColor;
  }

  // Data Karakter (Yang dimiliki)
  final List<Map<String, dynamic>> ownedCharacters = [
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
      "desc": "Bonus +1 poin ekstra untuk setiap target HARD.",
      "icon": Icons.stars_rounded
    },
  ];

  // Data Frame Border (Yang dimiliki)
  final List<Map<String, dynamic>> ownedBorders = [
    {"name": "Classic Blue", "color": Colors.blue[300]!},
    {"name": "Golden Frame", "color": Colors.amber},
    {"name": "Toxic Green", "color": Colors.greenAccent[700]!},
    {"name": "Neon Pink", "color": Colors.pinkAccent},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/beachmap.jpg'), fit: BoxFit.cover),
          ),
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  children: [
                    _buildHeader(),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.blue[300]!, width: 2),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                            color: Colors.green[500],
                            borderRadius: BorderRadius.circular(25)),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.blue[800],
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        tabs: const [
                          Tab(text: "KARAKTER"),
                          Tab(text: "FRAME BORDER")
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildCharacterTab(),
                          _buildBorderTab(),
                        ],
                      ),
                    ),
                  ],
                ),
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
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Column(
        children: [
          const Text("INVENTORY",
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2)),
          Text("Atur perlengkapan bermainmu!",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue[100],
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // --- TAB 1: KARAKTER ---
  Widget _buildCharacterTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: ownedCharacters.map((char) {
          bool isSelected = activeCharacter == char['name'];
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  activeCharacter = char['name'];
                  GameConfig.selectedCharacter = char['name']; // Save ke Config
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
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20))),
                        child:
                            Icon(char['image'], size: 70, color: Colors.white),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Icon(char['icon'],
                                    color: char['color'], size: 24),
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
                      padding:
                          const EdgeInsets.only(bottom: 12, left: 8, right: 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              activeCharacter = char['name'];
                              GameConfig.selectedCharacter = char['name'];
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isSelected ? Colors.green : Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          child: Text(isSelected ? "DIPAKAI" : "GUNAKAN",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- TAB 2: FRAME BORDER ---
  Widget _buildBorderTab() {
    return Center(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 90),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            childAspectRatio: 0.85,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16),
        itemCount: ownedBorders.length,
        itemBuilder: (context, index) {
          final border = ownedBorders[index];
          bool isSelected = activeBorder == border['color'];

          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                  color: isSelected ? Colors.yellowAccent : border['color'],
                  width: isSelected ? 5 : 4),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: border['color'].withOpacity(0.2),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20))),
                    child: Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(color: border['color'], width: 6)),
                        child: Center(
                            child: Text("12",
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: border['color']))),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(border['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: Colors.blue[900])),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              activeBorder = border['color'];
                              GameConfig.selectedBorderColor = border['color'];
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isSelected ? Colors.green : Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.zero),
                          child: Text(isSelected ? "DIPAKAI" : "GUNAKAN",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 13)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
