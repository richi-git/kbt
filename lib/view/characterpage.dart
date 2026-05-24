import 'package:flutter/material.dart';
import 'package:praktikum_1/config/game_config.dart'; // Import config
import 'package:praktikum_1/service/item_service.dart';
import 'package:praktikum_1/widget/math_background.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const SizedBox(height: 30),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListenableBuilder(
                        listenable: ItemService(),
                        builder: (context, child) {
                          final characters = ItemService().ownedSkins;
                          return OrientationBuilder(
                            builder: (context, orientation) {
                              if (orientation == Orientation.landscape) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: characters.map((char) {
                                    return Expanded(
                                      child: _buildCharacterCard(char),
                                    );
                                  }).toList(),
                                );
                              } else {
                                return SingleChildScrollView(
                                  padding: const EdgeInsets.only(bottom: 100),
                                  child: Column(
                                    children: characters.map((char) {
                                      return SizedBox(
                                        height: 450,
                                        child: _buildCharacterCard(char),
                                      );
                                    }).toList(),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF0D47A1).withOpacity(0.95), const Color(0xFF1976D2).withOpacity(0.95)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5)),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Column(
            children: [
              const Text(
                "CHARACTER",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 3,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 5, offset: Offset(2, 2))]),
              ),
              const SizedBox(height: 4),
              Text(
                "Pilih karakter jagoanmu!",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue[100],
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterCard(StoreItem char) {
    return _CharacterCard(
      char: char,
      isSelected: selectedCharacter == char.name,
      onSelect: (name) {
        setState(() {
          selectedCharacter = name;
          GameConfig.selectedCharacter = name;
        });
      },
    );
  }
}

class _CharacterCard extends StatefulWidget {
  final StoreItem char;
  final bool isSelected;
  final Function(String) onSelect;

  const _CharacterCard({
    required this.char,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  State<_CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<_CharacterCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final char = widget.char;
    final isSelected = widget.isSelected;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () => widget.onSelect(char.name),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          transform: isHovered ? (Matrix4.diagonal3Values(1.02, 1.02, 1.0)) : Matrix4.identity(),
          margin: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: isSelected ? 0 : 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
                color: isSelected
                    ? Colors.yellowAccent.shade400
                    : (isHovered ? Colors.blue.shade300 : Colors.transparent),
                width: isSelected || isHovered ? 4 : 0),
            boxShadow: [
              BoxShadow(
                  color: isSelected
                      ? char.color.withOpacity(0.6)
                      : (isHovered
                          ? char.color.withOpacity(0.3)
                          : Colors.black.withOpacity(0.2)),
                  blurRadius: isSelected ? 20 : (isHovered ? 15 : 10),
                  spreadRadius: isSelected ? 2 : 0,
                  offset: const Offset(0, 8))
            ],
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  // Top Half: Character Image with Gradient Background
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [char.color.withOpacity(0.6), char.color],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(26)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            child:
                                Icon(char.icon, size: 60, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Middle Banner: Character Name and Badge Icon
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    color: const Color(0xFF0D47A1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.military_tech_rounded, color: Colors.yellowAccent, size: 20),
                        const SizedBox(width: 8),
                        Text(char.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                                fontSize: 16)),
                      ],
                    ),
                  ),
                  // Bottom Half: Skill Info
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (char.skillIcon != null)
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: char.color.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(char.skillIcon,
                                    color: char.color, size: 24),
                              ),
                            const SizedBox(height: 6),
                            if (char.skill != null)
                              Text(char.skill!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: char.color)),
                            const SizedBox(height: 6),
                            if (char.desc != null)
                              Text(char.desc!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.black87,
                                      height: 1.2)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () => widget.onSelect(char.name),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? Colors.green.shade600
                              : Colors.blue.shade600,
                          elevation: isSelected ? 8 : 2,
                          shadowColor: isSelected
                              ? Colors.green.withOpacity(0.5)
                              : Colors.blue.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text(isSelected ? "TERPILIH" : "PILIH",
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                fontSize: 12,
                                letterSpacing: 1)),
                      ),
                    ),
                  ),
                ],
              ),
              // Floating Badge Check Icon
              if (isSelected)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.yellowAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2))
                      ],
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: Colors.black, size: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
