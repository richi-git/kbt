import 'package:flutter/material.dart';
import 'package:praktikum_1/view/adventurepage.dart';
import 'package:praktikum_1/widget/math_background.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isHoveredPlay = false;
  bool isHoveredLatihan = false;
  bool isHoveredAdventure = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Mathlink Custom - Tetap dipertahankan sesuai instruksi
          const MathBackground(),

          // Content
          SafeArea(
            child: OrientationBuilder(
              builder: (context, orientation) {
                bool isLandscape = orientation == Orientation.landscape;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      // TOP ROW: Leaderboard & Settings
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLeaderboardButton(),
                          _buildSettingsIcon(),
                        ],
                      ),
                      
                      Expanded(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: isLandscape ? 1000 : 500,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // LOGO
                              Flexible(
                                flex: 2,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: _buildLogo(),
                                ),
                              ),

                              // MAIN BANNER
                              Flexible(
                                flex: 3,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: 400,
                                      maxWidth: 600,
                                    ),
                                    child: _buildMainBanner(context, isLandscape),
                                  ),
                                ),
                              ),

                              // ACTION CARDS
                              Flexible(
                                flex: 2,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: SizedBox(
                                    width: isLandscape ? 800 : 400,
                                    height: isLandscape ? 120 : 200,
                                    child: isLandscape
                                        ? Row(
                                            children: [
                                              Expanded(child: _buildLatihanCard()),
                                              const SizedBox(width: 20),
                                              Expanded(
                                                  child: _buildAdventureCard(context)),
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              Expanded(child: _buildLatihanCard()),
                                              const SizedBox(height: 10),
                                              Expanded(
                                                  child: _buildAdventureCard(context)),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Ruang ekstra kecil untuk navigasi jika diperlukan, 
                      // tapi biarkan SafeArea menangani margin bawah.
                      const SizedBox(height: 10), 
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB), // Biru
        shape: BoxShape.circle,
        border: Border.all(
            color: const Color(0xFF60A5FA), width: 3), // Border biru muda
        boxShadow: const [
          BoxShadow(color: Colors.black38, offset: Offset(0, 4), blurRadius: 4)
        ],
      ),
      child: const Icon(Icons.settings_rounded, color: Colors.white, size: 36),
    );
  }

  Widget _buildLeaderboardButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)], // Gradasi biru
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(color: Colors.black38, offset: Offset(0, 4), blurRadius: 4)
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.emoji_events_rounded, color: Color(0xFFFBBF24), size: 28),
          SizedBox(width: 8),
          Text(
            "LEADERBOARD",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Math symbols (decorations like the image)
        const Positioned(
            top: -10,
            left: -40,
            child: Text('+',
                style: TextStyle(
                    color: Color(0xFF4ADE80),
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(color: Colors.black26, offset: Offset(1, 2))
                    ]))),
        const Positioned(
            bottom: 20,
            left: -40,
            child: Text('x',
                style: TextStyle(
                    color: Color(0xFFC084FC),
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(color: Colors.black26, offset: Offset(1, 2))
                    ]))),
        const Positioned(
            top: 0,
            right: -40,
            child: Text('÷',
                style: TextStyle(
                    color: Color(0xFFFBBF24),
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(color: Colors.black26, offset: Offset(1, 2))
                    ]))),
        const Positioned(
            bottom: 10,
            right: -45,
            child: Text('=',
                style: TextStyle(
                    color: Color(0xFF60A5FA),
                    fontSize: 52,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(color: Colors.black26, offset: Offset(1, 2))
                    ]))),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // "MATH" text
            Stack(
              children: [
                Text(
                  "MATH",
                  style: TextStyle(
                      fontSize: 76,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 18
                        ..color =
                            const Color(0xFF1E3A8A), // Thick dark blue border
                      shadows: const [
                        Shadow(
                            color: Colors.black38,
                            offset: Offset(0, 6),
                            blurRadius: 6)
                      ]),
                ),
                const Text(
                  "MATH",
                  style: TextStyle(
                    fontSize: 76,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            // "LINK" on wooden board
            Transform.translate(
              offset: const Offset(0, -25),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD97706), // Wood brown
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFF92400E), width: 5), // Darker edge
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0, 6),
                        blurRadius: 6)
                  ],
                ),
                child: Stack(
                  children: [
                    Text(
                      "LINK",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 12
                          ..color = const Color(0xFF1E3A8A),
                      ),
                    ),
                    const Text(
                      "LINK",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3,
                        color: Color(0xFFFBBF24), // Yellow text
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainBanner(BuildContext context, bool isLandscape) {
    Widget content = Row(
          children: [
            // Mascot Icon Placeholder (Composed to look like the image)
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  width: isLandscape ? 140 : 100,
                  height: isLandscape ? 140 : 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF60A5FA), // Light blue skin
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 6),
                          blurRadius: 6)
                    ],
                  ),
                  child: Icon(Icons.face_rounded,
                      size: isLandscape ? 100 : 70, color: Colors.white),
                ),
                // Hat placeholder
                Positioned(
                  top: -10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: const Color(0xFF1E3A8A), width: 3)),
                    child: Icon(Icons.star_rounded,
                        color: const Color(0xFF60A5FA), size: isLandscape ? 24 : 18),
                  ),
                ),
                // Red "MATH" book in hand
                Positioned(
                  bottom: -10,
                  right: -10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626), // Red book
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black45,
                            offset: Offset(0, 4),
                            blurRadius: 4)
                      ],
                    ),
                    child: Text("MATH",
                        style: TextStyle(
                            color: Colors.yellow,
                            fontWeight: FontWeight.w900,
                            fontSize: isLandscape ? 14 : 10)),
                  ),
                ),
              ],
            ),
            SizedBox(width: isLandscape ? 32 : 16),

            // Texts and PLAY Button
            Expanded(
              child: Column(
                crossAxisAlignment: isLandscape ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome!",
                    style: TextStyle(
                      fontSize: isLandscape ? 42 : 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      shadows: const [
                        Shadow(color: Colors.black26, offset: Offset(2, 2))
                      ],
                    ),
                  ),
                  Text(
                    "Let's play and learn!",
                    style: TextStyle(
                      fontSize: isLandscape ? 20 : 14,
                      color: const Color(0xFFFDE047), // Kuning
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Play Button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdventurePage()),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      height: isLandscape ? 70 : 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF86EFAC),
                            Color(0xFF22C55E)
                          ], // Hijau cerah ke hijau
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xFF166534),
                              offset: Offset(0, isHoveredPlay ? 4 : 8)), // 3D effect changes on hover
                          BoxShadow(
                              color: Colors.black38,
                              offset: Offset(0, isHoveredPlay ? 8 : 12),
                              blurRadius: 8),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "PLAY",
                        style: TextStyle(
                          fontSize: isLandscape ? 36 : 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2,
                          shadows: const [
                            Shadow(
                                color: Colors.black26,
                                offset: Offset(1, 2),
                                blurRadius: 2)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

    return MouseRegion(
      onEnter: (_) => setState(() => isHoveredPlay = true),
      onExit: (_) => setState(() => isHoveredPlay = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: isHoveredPlay ? (Matrix4.diagonal3Values(1.02, 1.02, 1.0)) : Matrix4.identity(),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF1D4ED8), // Biru vivid
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: isHoveredPlay ? Colors.yellowAccent : Colors.white, width: 5),
          boxShadow: [
            BoxShadow(
                color: isHoveredPlay ? Colors.blue.withValues(alpha: 0.5) : Colors.black38, 
                offset: Offset(0, isHoveredPlay ? 15 : 10), 
                blurRadius: isHoveredPlay ? 20 : 10)
          ],
        ),
        child: content,
      ),
    );
  }

  Widget _buildLatihanCard() {
    return MouseRegion(
      onEnter: (_) => setState(() => isHoveredLatihan = true),
      onExit: (_) => setState(() => isHoveredLatihan = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: isHoveredLatihan ? (Matrix4.diagonal3Values(1.05, 1.05, 1.0)) : Matrix4.identity(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFDE047),
              Color(0xFFF59E0B)
            ], // Gradasi kuning ke oranye
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isHoveredLatihan ? Colors.blue : Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: isHoveredLatihan ? Colors.orange.withValues(alpha: 0.5) : Colors.black38, 
            offset: Offset(0, isHoveredLatihan ? 10 : 6), 
            blurRadius: isHoveredLatihan ? 12 : 6
          )
        ],
      ),
      child: Row(
        children: [
          // Icon Buku dengan Angka (Composed)
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.menu_book_rounded,
                    size: 45, color: Color(0xFFD97706)),
                Positioned(
                    top: 15,
                    left: 10,
                    child: Text("+",
                        style: TextStyle(
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.w900,
                            fontSize: 16))),
                const Positioned(
                    top: 12,
                    right: 15,
                    child: Text("2",
                        style: TextStyle(
                            color: Color(0xFFD97706),
                            fontWeight: FontWeight.w900,
                            fontSize: 16))),
                const Positioned(
                    bottom: 12,
                    left: 15,
                    child: Text("x",
                        style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.w900,
                            fontSize: 16))),
                const Positioned(
                    bottom: 10,
                    right: 15,
                    child: Text("3",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w900,
                            fontSize: 16))),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "LATIHAN",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: [
                      Shadow(color: Colors.black26, offset: Offset(1, 1))
                    ],
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Asah kemampuan\nmatematika kamu!",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF78350F), // Coklat gelap
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildAdventureCard(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHoveredAdventure = true),
      onExit: (_) => setState(() => isHoveredAdventure = false),
      child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdventurePage()),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: isHoveredAdventure ? (Matrix4.diagonal3Values(1.05, 1.05, 1.0)) : Matrix4.identity(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD8B4E2), Color(0xFFB066D6)], // Gradasi ungu
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isHoveredAdventure ? Colors.blue : Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
                color: isHoveredAdventure ? Colors.purple.withValues(alpha: 0.5) : Colors.black38, 
                offset: Offset(0, isHoveredAdventure ? 10 : 6), 
                blurRadius: isHoveredAdventure ? 12 : 6)
          ],
        ),
        child: Row(
          children: [
            // Icon Map & Compass (Composed)
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.map_rounded,
                      size: 45, color: Color(0xFF7E22CE)),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.explore_rounded,
                            size: 28, color: Colors.blue),
                      )),
                ],
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ADVENTURE",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.black26, offset: Offset(1, 1))
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Jelajahi dunia\ndan selesaikan misi!",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4C1D95), // Ungu gelap
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
