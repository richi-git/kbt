import 'package:flutter/material.dart';
import 'package:praktikum_1/view/adventurepage.dart';
import 'package:praktikum_1/widget/math_background.dart';
import 'package:praktikum_1/config/game_config.dart';
import 'package:praktikum_1/service/item_service.dart';

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

                              // ACTION CARDS (PLAY, LATIHAN, ADVENTURE) - Always Column as requested
                              Flexible(
                                flex: 6,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: SizedBox(
                                    width: isLandscape ? 450 : 380, // Reduced width for tighter look
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _buildPlayCard(context, isLandscape),
                                        const SizedBox(height: 16),
                                        _buildLatihanCard(isLandscape),
                                        const SizedBox(height: 16),
                                        _buildAdventureCard(context, isLandscape),
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

  Widget _buildPlayCard(BuildContext context, bool isLandscape) {
    // Ambil data karakter terpilih
    final selectedCharName = GameConfig.selectedCharacter;
    final allSkins = ItemService().skins;
    final selectedChar = allSkins.firstWhere(
      (char) => char.name == selectedCharName,
      orElse: () => allSkins.first,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => isHoveredPlay = true),
      onExit: (_) => setState(() => isHoveredPlay = false),
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
          transform: isHoveredPlay
              ? (Matrix4.diagonal3Values(1.05, 1.05, 1.0))
              : Matrix4.identity(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)], // Gradasi biru
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: isHoveredPlay ? Colors.yellowAccent : Colors.white,
                width: 4),
            boxShadow: [
              BoxShadow(
                  color: isHoveredPlay
                      ? Colors.blue.withValues(alpha: 0.5)
                      : Colors.black38,
                  offset: Offset(0, isHoveredPlay ? 10 : 6),
                  blurRadius: isHoveredPlay ? 12 : 6)
            ],
          ),
          child: Row(
            children: [
              // Mascot Icon in Circle (Same size as other cards)
              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: ClipOval(
                  child: selectedChar.imagePath != null
                      ? Image.asset(
                          selectedChar.imagePath!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Icon(
                              selectedChar.icon,
                              size: 45,
                              color: selectedChar.color),
                        )
                      : Icon(selectedChar.icon,
                          size: 45, color: selectedChar.color),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "PLAY",
                      style: TextStyle(
                        fontSize: 26, // Increased from 22
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        shadows: [
                          Shadow(color: Colors.black26, offset: Offset(1, 1))
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Selamat Datang!\nAyo mulai bermain.",
                      style: TextStyle(
                        fontSize: 14, // Increased from 12
                        color: Color(0xFFBFDBFE), // Biru muda
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

  Widget _buildLatihanCard(bool isLandscape) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHoveredLatihan = true),
      onExit: (_) => setState(() => isHoveredLatihan = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: isHoveredLatihan
            ? (Matrix4.diagonal3Values(1.05, 1.05, 1.0))
            : Matrix4.identity(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          border: Border.all(
              color: isHoveredLatihan ? Colors.blue : Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
                color: isHoveredLatihan
                    ? Colors.orange.withValues(alpha: 0.5)
                    : Colors.black38,
                offset: Offset(0, isHoveredLatihan ? 10 : 6),
                blurRadius: isHoveredLatihan ? 12 : 6)
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "LATIHAN",
                    style: TextStyle(
                      fontSize: 26, // Increased from 22
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.black26, offset: Offset(1, 1))
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Asah kemampuan\nmatematika kamu!",
                    style: TextStyle(
                      fontSize: 14, // Increased from 12
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

  Widget _buildAdventureCard(BuildContext context, bool isLandscape) {
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
          transform: isHoveredAdventure
              ? (Matrix4.diagonal3Values(1.05, 1.05, 1.0))
              : Matrix4.identity(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFD8B4E2), Color(0xFFB066D6)], // Gradasi ungu
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: isHoveredAdventure ? Colors.blue : Colors.white,
                width: 4),
            boxShadow: [
              BoxShadow(
                  color: isHoveredAdventure
                      ? Colors.purple.withValues(alpha: 0.5)
                      : Colors.black38,
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "ADVENTURE",
                      style: TextStyle(
                        fontSize: 26, // Increased from 22
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        shadows: [
                          Shadow(color: Colors.black26, offset: Offset(1, 1))
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Jelajahi dunia\ndan selesaikan misi!",
                      style: TextStyle(
                        fontSize: 14, // Increased from 12
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
