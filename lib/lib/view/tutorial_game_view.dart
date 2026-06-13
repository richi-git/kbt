import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:praktikum_1/model/node_model.dart';
import 'package:praktikum_1/widget/node_widget.dart';
import 'package:praktikum_1/config/game_config.dart';
import 'package:praktikum_1/widget/result_preview.dart';
import 'package:praktikum_1/widget/score_bar_widget.dart';
import 'package:praktikum_1/service/qc_service.dart';
import 'package:praktikum_1/service/audio_service.dart';
import 'package:praktikum_1/widget/floating_score_widget.dart';
import 'package:praktikum_1/widget/animated_border_painter.dart';
import 'package:praktikum_1/service/language_service.dart';

class TutorialGameView extends StatefulWidget {
  final String bgImagePath;

  const TutorialGameView({
    super.key,
    this.bgImagePath = 'assets/beachmap.jpg',
  });

  @override
  State<TutorialGameView> createState() => _TutorialGameViewState();
}

class _TutorialGameViewState extends State<TutorialGameView>
    with SingleTickerProviderStateMixin {
  late List<NodeModel> gridNodes;
  final Random _random = Random();
  final LanguageService _lang = LanguageService();

  List<String> easyTargets = [];
  List<String> mediumTargets = [];
  List<String> hardTargets = [];
  List<int> activeDeliveryRoute = [];

  int userScore = 25;
  int aiScore = 25;
  int currentSessionScore = 0;
  String currentCalculationResult = "";

  int tutorialStep = 1;
  final int totalTutorialSteps = 4; // Changed from 5 to 4
  Timer? _hintTimer;
  bool _showHint = false;

  String _hintAnswer = "";

  late AnimationController _borderAnimationController;

  String _t(String key) => _lang.translate('homepage', key);

  @override
  void initState() {
    super.initState();
    _initTutorialInventory();
    _generateTutorialTargets();
    _startHintTimer();
    
    _borderAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Show first instruction after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInstructionDialog();
    });
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    _borderAnimationController.dispose();
    super.dispose();
  }

  void _startHintTimer() {
    _hintTimer?.cancel();
    setState(() => _showHint = false);
    _hintTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        List<String> allTargets = [...easyTargets, ...mediumTargets, ...hardTargets];
        List<int> route = QCService.findHintRoute(gridNodes, allTargets);
        if (route.isNotEmpty) {
          _hintAnswer = route.map((idx) => gridNodes[idx].value).join(" ");
          setState(() => _showHint = true);
        }
      }
    });
  }

  void _initTutorialInventory() {
    // Stage-specific inventory to ensure the player can always fulfill the goal
    gridNodes = List.generate(
        GameConfig.crossAxisCount * GameConfig.mainAxisCount, (index) {
      if (index % 2 == 0) {
        // Varied numbers based on step
        int val;
        if (tutorialStep == 1) {
          val = 5; // Keep it simple for step 1
        } else {
          val = _random.nextInt(8) + 1; // 1-8 for more variety
        }
        return NodeModel(id: index, value: val.toString(), type: NodeType.number);
      } else {
        String op = (tutorialStep <= 2) ? "+" : GameConfig.operators[_random.nextInt(GameConfig.operators.length)];
        return NodeModel(id: index, value: op, type: NodeType.operator);
      }
    });
  }

  void _generateTutorialTargets() {
    // Clear all first
    easyTargets = [];
    mediumTargets = [];
    hardTargets = [];
    
    switch (tutorialStep) {
      case 1:
        easyTargets = ["10"]; // Goal: 5 + 5 = 10 (3 nodes)
        break;
      case 2:
        easyTargets = ["8", "12"]; // Goal: simple addition
        break;
      case 3:
        mediumTargets = ["18", "24"]; // Goal: multiplication
        break;
      case 4:
        easyTargets = ["20"];
        mediumTargets = ["40"];
        hardTargets = ["60"];
        break;
    }
  }

  void _showInstructionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.touch_app_rounded, color: Colors.blue, size: 30),
            const SizedBox(width: 10),
            Text(_t('tutorial_title'), style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFD97706))),
          ],
        ),
        content: Text(
          _t('tutorial_step_$tutorialStep'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF4B2C20)),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startHintTimer(); // Reset hint timer when dialog closed
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(tutorialStep == totalTutorialSteps ? _t('tutorial_close') : _t('tutorial_next'), style: const TextStyle(fontWeight: FontWeight.w900)),
          )
        ],
      ),
    );
  }

  void _nextStep() {
    if (tutorialStep < totalTutorialSteps) {
      setState(() {
        tutorialStep++;
        _initTutorialInventory();
        _generateTutorialTargets();
      });
      _showInstructionDialog();
    } else {
      _finishTutorial();
    }
  }

  void _finishTutorial() {
    setState(() {
      userScore = 100; // Full points on finish
      aiScore = 0;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        title: const Text("TUTORIAL SELESAI!", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.green)),
        content: const Text(
          "Luar biasa! Kamu sudah menguasai dasar-dasar MathLink. Sekarang saatnya membuktikan kemampuanmu di mode Adventure!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF4B2C20)),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("KEMBALI KE LOBBY", style: TextStyle(fontWeight: FontWeight.w900)),
          )
        ],
      ),
    );
  }

  void _showFloatingAnimation(String text, Color color) {
    if (!mounted) return;
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => FloatingScoreWidget(
        text: text,
        color: color,
        onComplete: () {
          entry.remove();
        },
      ),
    );
    overlay.insert(entry);
  }

  void _planRoute(Offset position, BoxConstraints constraints) {
    _startHintTimer(); // Reset hint timer on any interaction
    double cellW = constraints.maxWidth / GameConfig.crossAxisCount;
    double cellH = constraints.maxHeight / GameConfig.mainAxisCount;
    
    // Calculate col and row
    int col = (position.dx / cellW).floor();
    int row = (position.dy / cellH).floor();

    if (col >= 0 && col < GameConfig.crossAxisCount && row >= 0 && row < GameConfig.mainAxisCount) {
      // Sensitivity refinement: only select if the touch is within the center 70% of the cell
      double localX = position.dx % cellW;
      double localY = position.dy % cellH;
      double marginW = cellW * 0.15;
      double marginH = cellH * 0.15;

      if (localX < marginW || localX > (cellW - marginW) || 
          localY < marginH || localY > (cellH - marginH)) {
        return; // Skip if too close to the edge of the cell
      }

      int index = row * GameConfig.crossAxisCount + col;
      if (activeDeliveryRoute.contains(index)) {
        if (activeDeliveryRoute.length > 1 && activeDeliveryRoute[activeDeliveryRoute.length - 2] == index) {
          setState(() {
            gridNodes[activeDeliveryRoute.removeLast()].isSelected = false;
            AudioService.playBubblePopSFX();
            currentCalculationResult = (activeDeliveryRoute.isNotEmpty && QCService.validateRoute(activeDeliveryRoute, gridNodes))
                ? QCService.calculateOutput(activeDeliveryRoute, gridNodes).toString()
                : "";
          });
        }
        return;
      }
      if (activeDeliveryRoute.isNotEmpty) {
        int lIdx = activeDeliveryRoute.last;
        if ((row - lIdx ~/ GameConfig.crossAxisCount).abs() > 1 || (col - lIdx % GameConfig.crossAxisCount).abs() > 1) {
          return;
        }
      }
      setState(() {
        activeDeliveryRoute.add(index);
        gridNodes[index].isSelected = true;
        AudioService.playBubblePopSFX();
        currentCalculationResult = QCService.validateRoute(activeDeliveryRoute, gridNodes)
            ? QCService.calculateOutput(activeDeliveryRoute, gridNodes).toString()
            : "";
      });
    }
  }

  void _executeDelivery() {
    _startHintTimer(); // Reset hint timer on delivery
    if (activeDeliveryRoute.isEmpty) return;

    if (QCService.validateRoute(activeDeliveryRoute, gridNodes)) {
      String outputStr = QCService.calculateOutput(activeDeliveryRoute, gridNodes).toString();
      
      bool isOrderFulfilled = false;

      if (easyTargets.contains(outputStr) || mediumTargets.contains(outputStr) || hardTargets.contains(outputStr)) {
        isOrderFulfilled = true;
      }

      if (isOrderFulfilled) {
        AudioService.playSuccessSFX();
        _showFloatingAnimation("BERHASIL!", Colors.green);
        Future.delayed(const Duration(milliseconds: 600), () {
          _nextStep();
        });
      }
    }

    setState(() {
      for (int index in activeDeliveryRoute) {
        gridNodes[index].isSelected = false;
      }
      activeDeliveryRoute.clear();
      currentCalculationResult = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(widget.bgImagePath), fit: BoxFit.cover)),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.close_rounded),
                            color: Colors.white,
                            iconSize: 40,
                            onPressed: () => Navigator.pop(context)),
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white, width: 2)),
                            child: Text("STEP $tutorialStep/$totalTutorialSteps",
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _borderAnimationController,
                      builder: (context, child) {
                        return Container(
                          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: MLBorderPainter(
                                    color: GameConfig.selectedBorderColor,
                                    progress: _borderAnimationController.value,
                                    type: GameConfig.selectedBorderType,
                                    isHovered: true,
                                    borderRadius: 30.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    ScoreBarWidget(userScore: userScore, aiScore: aiScore),
                                    const SizedBox(height: 12),
                                    Expanded(
                                      child: OrientationBuilder(
                                        builder: (context, orientation) {
                                          bool isLandscape = orientation == Orientation.landscape;
                                          
                                          Widget targetsWidget = _buildTargetsRow();
                                          Widget previewWidget = SizedBox(
                                            height: 80, // Increased height for better visibility
                                            child: Center(
                                              child: ResultPreviewWidget(result: currentCalculationResult),
                                            ),
                                          );
                                          Widget gridWidget = Expanded(
                                            child: Center(
                                              child: AspectRatio(
                                                aspectRatio: 1,
                                                child: LayoutBuilder(builder: (context, gridConstraints) {
                                                  return _buildGrid(gridConstraints);
                                                }),
                                              ),
                                            ),
                                          );

                                          if (isLandscape) {
                                            return Row(
                                              children: [
                                                Expanded(flex: 3, child: gridWidget),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      targetsWidget,
                                                      const SizedBox(height: 12),
                                                      previewWidget,
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return Column(
                                              children: [
                                                targetsWidget,
                                                previewWidget,
                                                gridWidget,
                                              ],
                                            );
                                          }
                                        },
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
                  ),
                ],
              ),
              // Hint Overlay at the top
              if (_showHint)
                Positioned(
                  top: 70, // Below close button row
                  left: 20,
                  right: 20,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _t('tutorial_hint'),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "JAWABAN: $_hintAnswer",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(BoxConstraints constraints) {
    return GestureDetector(
      onPanStart: (details) => _planRoute(details.localPosition, constraints),
      onPanUpdate: (details) => _planRoute(details.localPosition, constraints),
      onPanEnd: (details) => _executeDelivery(),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: GameConfig.crossAxisCount, 
            childAspectRatio: 1.0,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8),
        itemCount: gridNodes.length,
        itemBuilder: (context, index) {
          return NodeWidget(node: gridNodes[index]);
        },
      ),
    );
  }

  Widget _buildTargetsRow() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        if (easyTargets.isNotEmpty)
          _buildTargetBox("TARGET", easyTargets, Colors.green[600]!),
        if (mediumTargets.isNotEmpty)
          _buildTargetBox("MEDIUM", mediumTargets, Colors.purple[600]!),
        if (hardTargets.isNotEmpty)
          _buildTargetBox("HARD", hardTargets, Colors.orange[600]!),
      ],
    );
  }

  Widget _buildTargetBox(String label, List<String> targets, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      constraints: const BoxConstraints(minWidth: 80),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10)),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: targets.map((t) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Text(t, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 16)),
            )).toList(),
          )
        ],
      ),
    );
  }
}
