import 'package:flutter/material.dart';
import 'package:praktikum_1/config/game_config.dart';
import 'package:praktikum_1/service/item_service.dart';
import 'package:praktikum_1/widget/math_background.dart';
import 'package:praktikum_1/widget/animated_border_painter.dart';
import 'package:praktikum_1/service/language_service.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage>
    with SingleTickerProviderStateMixin {
  late String activeCharacter;
  late Color activeBorder;
  int? hoveredCharIndex;
  int? hoveredBorderIndex;
  final LanguageService _lang = LanguageService();

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    activeCharacter = GameConfig.selectedCharacter;
    activeBorder = GameConfig.selectedBorderColor;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _t(String key) => _lang.translate('inventory', key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
          children: [
            const MathBackground(),
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: [
                      _buildHeader(),
                      _buildTabBar(),
                      Expanded(
                        child: ListenableBuilder(
                          listenable: ItemService(),
                          builder: (context, child) {
                            return TabBarView(
                              children: [
                                _buildCharacterTab(),
                                _buildBorderTab(),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
          Text(_t('title'),
              style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2)),
          Text(_t('subtitle'),
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue[100],
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.blue[300]!, width: 2),
      ),
      child: TabBar(
        indicator: BoxDecoration(
            color: Colors.blue[600], borderRadius: BorderRadius.circular(25)),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.blue[800],
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: [Tab(text: _t('tab_skin')), Tab(text: _t('tab_border'))],
      ),
    );
  }

  Widget _buildCharacterTab() {
    final ownedCharacters = ItemService().ownedSkins;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: OrientationBuilder(
        builder: (context, orientation) {
          bool isLandscape = orientation == Orientation.landscape;
          
          List<Widget> childrenList = ownedCharacters.asMap().entries.map((entry) {
            int idx = entry.key;
            var char = entry.value;
            bool isSelected = activeCharacter == char.name;
            bool isHovered = hoveredCharIndex == idx;

            Widget card = MouseRegion(
              onEnter: (_) => setState(() => hoveredCharIndex = idx),
              onExit: (_) => setState(() => hoveredCharIndex = null),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                transform: isHovered
                    ? (Matrix4.diagonal3Values(1.02, 1.02, 1.0))
                    : Matrix4.identity(),
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95), // Latar belakang putih transparan
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                      color: isSelected
                          ? Colors.yellowAccent
                          : (isHovered ? Colors.blueAccent : Colors.white),
                      width: isSelected ? 5 : 2),
                  boxShadow: [
                    BoxShadow(
                        color: isSelected
                            ? Colors.orange.withOpacity(0.5)
                            : (isHovered
                                ? Colors.blue.withOpacity(0.3)
                                : Colors.black26),
                        blurRadius: isHovered ? 15 : 10,
                        offset: Offset(0, isHovered ? 8 : 5))
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      activeCharacter = char.name;
                      GameConfig.selectedCharacter = char.name;
                    });
                  },
                  child: Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: char.color,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          child: char.imagePath != null
                              ? ClipRect(
                                  child: OverflowBox(
                                    maxHeight: 240, // 2x zoom (120 * 2)
                                    alignment: Alignment.topCenter,
                                    child: Image.asset(
                                      char.imagePath!,
                                      fit: BoxFit.contain,
                                      filterQuality: FilterQuality.high,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                              char.icon,
                                              size: 70,
                                              color: Colors.white),
                                    ),
                                  ),
                                )
                              : Icon(char.icon, size: 70, color: Colors.white),
                        ),
                      ),
                      _buildCharacterInfo(char, isSelected),
                    ],
                  ),
                ),
              ),
            );

            if (isLandscape) {
              return Expanded(child: card);
            } else {
              return SizedBox(height: 350, child: card);
            }
          }).toList();

          if (isLandscape) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: childrenList,
            );
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: childrenList,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCharacterInfo(StoreItem char, bool isSelected) {
    return Expanded(
      flex: 6,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: const Color(0xFF0D47A1),
            child: Text(char.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (char.skillIcon != null)
                      Icon(char.skillIcon, color: char.color, size: 24),
                    if (char.skill != null)
                      Text(_lang.translate('skills', '${char.skill}_name'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: char.color)),
                    const SizedBox(height: 4),
                    if (char.desc != null)
                      Text(_lang.translate('skills', '${char.skill}_desc'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.black87)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    activeCharacter = char.name;
                    GameConfig.selectedCharacter = char.name;
                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? Colors.green : Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                child: Text(isSelected ? _t('using') : _t('use'),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBorderTab() {
    final ownedBorders = ItemService().ownedBorders;
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 0.7,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: ownedBorders.length,
      itemBuilder: (context, index) {
        final border = ownedBorders[index];
        bool isSelected = activeBorder == border.color;
        bool isHovered = hoveredBorderIndex == index;

        return MouseRegion(
          onEnter: (_) => setState(() => hoveredBorderIndex = index),
          onExit: (_) => setState(() => hoveredBorderIndex = null),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    activeBorder = border.color;
                    GameConfig.selectedBorderColor = border.color;
                    GameConfig.selectedBorderType = border.borderType ?? "flow";
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.yellowAccent : Colors.white10,
                      width: isSelected ? 3 : 1,
                    ),
                    boxShadow: [
                      if (isSelected || isHovered)
                        BoxShadow(
                          color: border.color.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                        )
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: MLBorderPainter(
                            color: border.color,
                            progress: _animationController.value,
                            type: border.borderType ?? "flow",
                            isHovered: isHovered || isSelected,
                            borderRadius: 20.0,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text("12",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: border.color)),
                            ),
                          ),
                          _buildBorderFooter(border, isSelected),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBorderFooter(StoreItem border, bool isSelected) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Text(border.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            height: 28,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  activeBorder = border.color;
                  GameConfig.selectedBorderColor = border.color;
                  GameConfig.selectedBorderType = border.borderType ?? "flow";
                });
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? Colors.green : Colors.blue,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: Text(isSelected ? _t('using') : _t('use'),
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
