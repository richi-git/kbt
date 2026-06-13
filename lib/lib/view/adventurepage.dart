import 'package:flutter/material.dart';
import 'package:praktikum_1/config/game_config.dart';
import 'package:praktikum_1/view/game_view.dart';
import 'package:praktikum_1/widget/math_background.dart';
import 'package:praktikum_1/service/language_service.dart';

class AdventurePage extends StatefulWidget {
  const AdventurePage({super.key});

  @override
  State<AdventurePage> createState() => _AdventurePageState();
}

class _AdventurePageState extends State<AdventurePage> {
  int? hoveredLevel;
  final LanguageService _lang = LanguageService();

  String _t(String key) => _lang.translate('adventure', key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Mathlink Custom - Same as Home
          const MathBackground(),

          // Content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(
                          children: [
                            _buildLevelCard(
                                level: 4,
                                title: _t('city'),
                                gradientColors: [
                                  const Color(0xFF9333EA),
                                  const Color(0xFF6B21A8)
                                ],
                                bgImage: 'assets/background_card_city.png'),
                            _buildDottedLine(),
                            _buildLevelCard(
                                level: 3,
                                title: _t('village'),
                                gradientColors: [
                                  const Color(0xFF4ADE80),
                                  const Color(0xFF16A34A)
                                ],
                                bgImage: 'assets/background_card_village.png'),
                            _buildDottedLine(),
                            _buildLevelCard(
                                level: 2,
                                title: _t('beach'),
                                gradientColors: [
                                  const Color(0xFFFBBF24),
                                  const Color(0xFFB45309)
                                ],
                                bgImage: 'assets/background_card_beach.png'),
                            _buildDottedLine(),
                            _buildLevelCard(
                                level: 1,
                                title: _t('ocean'),
                                gradientColors: [
                                  const Color(0xFF38BDF8),
                                  const Color(0xFF1D4ED8)
                                ],
                                bgImage: 'assets/background_card_ocean.png'),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back to Home Button
          _buildCircleButton(
            icon: Icons.home_rounded,
            color: const Color(0xFFD97706),
            borderColor: const Color(0xFF92400E),
            onTap: () => Navigator.pop(context),
          ),
          
          // Premium Adventure Title (Wooden Style)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFD97706), // Wood brown
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF92400E), width: 4),
              boxShadow: const [BoxShadow(color: Colors.black45, offset: Offset(0, 4), blurRadius: 4)],
            ),
            child: Stack(
              children: [
                Text(
                  _t('title'),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 6
                      ..color = const Color(0xFF1E3A8A), // Dark blue outline
                  ),
                ),
                Text(
                  _t('title'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Settings Button
          _buildCircleButton(
            icon: Icons.settings_rounded,
            color: const Color(0xFF1E3A8A),
            borderColor: const Color(0xFF60A5FA),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({required IconData icon, required Color color, required Color borderColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 3),
          boxShadow: const [BoxShadow(color: Colors.black45, offset: Offset(0, 4), blurRadius: 4)],
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildDottedLine() {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) => Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            shape: BoxShape.circle,
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 2)],
          ),
        )),
      ),
    );
  }

  Widget _buildLevelCard(
      {required int level,
      required String title,
      required List<Color> gradientColors,
      required String bgImage}) {
    bool isUnlocked = level <= GameConfig.latestUnlockedLevel;
    bool isCurrentLevel = level == GameConfig.latestUnlockedLevel;
    bool isDone = level < GameConfig.latestUnlockedLevel;
    bool isHovered = hoveredLevel == level;

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredLevel = level),
      onExit: (_) => setState(() => hoveredLevel = null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: isHovered ? (Matrix4.diagonal3Values(1.03, 1.03, 1.0)) : Matrix4.identity(),
        height: 110,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.centerLeft,
          children: [
            // Main Card
            Container(
              margin: const EdgeInsets.only(left: 35),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isUnlocked ? gradientColors : [Colors.grey[600]!, Colors.grey[800]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                image: isUnlocked
                    ? DecorationImage(
                        image: AssetImage(bgImage),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3), BlendMode.darken),
                      )
                    : null,
                borderRadius: BorderRadius.circular(55),
                border: Border.all(color: isHovered ? Colors.yellowAccent : Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(0, isHovered ? 8 : 4),
                    blurRadius: isHovered ? 12 : 6,
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 55, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1,
                              shadows: [Shadow(color: Colors.black45, offset: Offset(2, 2))],
                            ),
                          ),
                          Text(
                            "LEVEL $level",
                            style: TextStyle(
                              color: Colors.yellow[400],
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Action Button
                    GestureDetector(
                      onTap: isUnlocked ? () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GameView(bgImagePath: bgImage, level: level)),
                        );
                        setState(() {});
                      } : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isCurrentLevel ? Colors.greenAccent[400] : (isDone ? Colors.green[600] : Colors.grey[400]),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 4))],
                        ),
                        child: Text(
                          isCurrentLevel ? _t('play') : (isDone ? _t('done') : _t('locked')),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Badge
            Positioned(
              left: 0,
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color: isUnlocked ? gradientColors[0] : Colors.grey[500],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: const [BoxShadow(color: Colors.black38, offset: Offset(0, 4), blurRadius: 4)],
                ),
                alignment: Alignment.center,
                child: Text(
                  level.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
