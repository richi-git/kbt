import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:praktikum_1/model/node_model.dart';
import 'package:praktikum_1/widget/node_widget.dart';
import 'package:praktikum_1/config/game_config.dart';
import 'package:praktikum_1/widget/result_preview.dart';
import 'package:praktikum_1/widget/score_bar_widget.dart';
import 'package:praktikum_1/widget/target_column_widget.dart';
import 'package:praktikum_1/service/qc_service.dart';
import 'package:praktikum_1/service/audio_service.dart';
import 'package:praktikum_1/widget/game_dialog_helper.dart';
import 'package:praktikum_1/widget/floating_score_widget.dart';
import 'package:praktikum_1/widget/animated_border_painter.dart';

class GameView extends StatefulWidget {
  final String bgImagePath;
  final int level;

  const GameView({
    super.key,
    this.bgImagePath = 'assets/beachmap.jpg',
    this.level = 1,
  });

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView>
    with SingleTickerProviderStateMixin {
  late List<NodeModel> gridNodes;
  final Random _random = Random();

  List<String> easyTargets = [];
  List<String> mediumTargets = [];
  List<String> hardTargets = [];
  List<int> activeDeliveryRoute = [];

  // LOGIKA TARIK TAMBANG: Total 50 poin
  int userScore = 25;
  int aiScore = 25;
  int currentSessionScore = 0;
  String currentCalculationResult = "";

  Timer? _timer;
  Timer? _aiTimer;
  Timer? _idleTimer;
  List<int> hintedRoute = [];
  late int remainingSeconds;

  late AnimationController _borderAnimationController;

  @override
  void initState() {
    super.initState();
    _initRandomInventory();
    _generateDemandForecast();
    _initTimerConfig();
    _startAITimer();
    _resetIdleTimer();

    _borderAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  void _initTimerConfig() {
    switch (widget.level) {
      case 4:
        remainingSeconds = 3 * 60;
        break;
      case 3:
        remainingSeconds = 5 * 60;
        break;
      case 2:
        remainingSeconds = 8 * 60;
        break;
      default:
        remainingSeconds = 10 * 60;
        break;
    }
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        _stopAllTimers();
        GameDialogHelper.showLoseDialog(context, "Waktu Habis!");
      }
    });
  }

  void _startAITimer() {
    // Skill BOY memperlambat AI
    int aiInterval = GameConfig.selectedCharacter == "BOY" ? 5 : 3;
    _aiTimer = Timer.periodic(Duration(seconds: aiInterval), (timer) {
      if (mounted) {
        setState(() {
          if (userScore > 0) {
            userScore -= 1;
            aiScore += 1;
          }
          if (userScore <= 0) {
            userScore = 0;
            aiScore = 50;
            _stopAllTimers();
            GameDialogHelper.showLoseDialog(
                context, "AI merebut semua poinmu!");
          }
        });
      }
    });
  }

  void _resetIdleTimer() {
    _idleTimer?.cancel();
    if (hintedRoute.isNotEmpty) {
      setState(() {
        hintedRoute.clear();
      });
    }
    // Skill BUBU memberikan hint rute
    if (GameConfig.selectedCharacter == "BUBU") {
      _idleTimer = Timer(const Duration(seconds: 5), () {
        if (mounted) {
          List<int> route =
              QCService.findHintRoute(gridNodes, _getAllActiveOrders());
          if (route.isNotEmpty) {
            setState(() {
              hintedRoute = route;
            });
          }
        }
      });
    }
  }

  void _stopAllTimers() {
    _timer?.cancel();
    _aiTimer?.cancel();
    _idleTimer?.cancel();
  }

  String get formattedTime =>
      '${(remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(remainingSeconds % 60).toString().padLeft(2, '0')}';

  @override
  void dispose() {
    _stopAllTimers();
    _borderAnimationController.dispose();
    super.dispose();
  }

  void _initRandomInventory() {
    gridNodes = List.generate(
        GameConfig.crossAxisCount * GameConfig.mainAxisCount, (index) {
      if (_random.nextDouble() > 0.3) {
        return NodeModel(
            id: index,
            value: (_random.nextInt(9) + 1).toString(),
            type: NodeType.number);
      } else {
        return NodeModel(
            id: index,
            value: GameConfig
                .operators[_random.nextInt(GameConfig.operators.length)],
            type: NodeType.operator);
      }
    });
  }

  List<String> _getAllActiveOrders() =>
      [...easyTargets, ...mediumTargets, ...hardTargets];

  void _generateDemandForecast() {
    int batchSize = GameConfig.mainAxisCount;
    easyTargets.clear();
    mediumTargets.clear();
    hardTargets.clear();
    for (int i = 0; i < batchSize; i++) {
      easyTargets.add(QCService.pullUniqueFromInventory(
          gridNodes: gridNodes,
          possibleLengths: [3],
          minResult: 2,
          maxResult: 20,
          allowedOperators: ['+', '-'],
          excludeList: _getAllActiveOrders()));
    }
    for (int i = 0; i < batchSize; i++) {
      mediumTargets.add(QCService.pullUniqueFromInventory(
          gridNodes: gridNodes,
          possibleLengths: [3, 5],
          minResult: 10,
          maxResult: 50,
          allowedOperators: ['+', '-', 'x'],
          excludeList: _getAllActiveOrders()));
    }
    for (int i = 0; i < batchSize; i++) {
      hardTargets.add(QCService.pullUniqueFromInventory(
          gridNodes: gridNodes,
          possibleLengths: [5, 7],
          minResult: 20,
          maxResult: 100,
          allowedOperators: ['+', '-', 'x', '÷'],
          excludeList: _getAllActiveOrders()));
    }
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
    _resetIdleTimer();
    double cellW = constraints.maxWidth / GameConfig.crossAxisCount;
    double cellH = constraints.maxHeight / GameConfig.mainAxisCount;
    int col = (position.dx / cellW).floor();
    int row = (position.dy / cellH).floor();

    if (col >= 0 &&
        col < GameConfig.crossAxisCount &&
        row >= 0 &&
        row < GameConfig.mainAxisCount) {
      if ((position.dx % cellW) / cellW < 0.2 ||
          (position.dx % cellW) / cellW > 0.8 ||
          (position.dy % cellH) / cellH < 0.2 ||
          (position.dy % cellH) / cellH > 0.8) {
        return;
      }
      int index = row * GameConfig.crossAxisCount + col;
      if (activeDeliveryRoute.contains(index)) {
        if (activeDeliveryRoute.length > 1 &&
            activeDeliveryRoute[activeDeliveryRoute.length - 2] == index) {
          setState(() {
            gridNodes[activeDeliveryRoute.removeLast()].isSelected = false;
            AudioService.playBubblePopSFX();
            currentCalculationResult = (activeDeliveryRoute.isNotEmpty &&
                    QCService.validateRoute(activeDeliveryRoute, gridNodes))
                ? QCService.calculateOutput(activeDeliveryRoute, gridNodes)
                    .toString()
                : "";
          });
        }
        return;
      }
      if (activeDeliveryRoute.isNotEmpty) {
        int lIdx = activeDeliveryRoute.last;
        if ((row - lIdx ~/ GameConfig.crossAxisCount).abs() > 1 ||
            (col - lIdx % GameConfig.crossAxisCount).abs() > 1) {
          return;
        }
      }
      setState(() {
        activeDeliveryRoute.add(index);
        gridNodes[index].isSelected = true;
        AudioService.playBubblePopSFX();
        currentCalculationResult =
            QCService.validateRoute(activeDeliveryRoute, gridNodes)
                ? QCService.calculateOutput(activeDeliveryRoute, gridNodes)
                    .toString()
                : "";
      });
    }
  }

  void _executeDelivery() {
    _resetIdleTimer();
    if (activeDeliveryRoute.isEmpty) return;

    if (QCService.validateRoute(activeDeliveryRoute, gridNodes)) {
      String outputStr =
          QCService.calculateOutput(activeDeliveryRoute, gridNodes).toString();
      bool isOrderFulfilled = false;
      int earned = 0;

      int eIdx = easyTargets.indexOf(outputStr);
      int mIdx = mediumTargets.indexOf(outputStr);
      int hIdx = hardTargets.indexOf(outputStr);

      if (eIdx != -1) {
        isOrderFulfilled = true;
        earned = 3;
        _showFloatingAnimation("+$earned", Colors.green[600]!);
        easyTargets[eIdx] = QCService.pullUniqueFromInventory(
            gridNodes: gridNodes,
            possibleLengths: [3],
            minResult: 2,
            maxResult: 20,
            allowedOperators: ['+', '-'],
            excludeList: _getAllActiveOrders());
      } else if (mIdx != -1) {
        isOrderFulfilled = true;
        earned = 5;
        _showFloatingAnimation("+$earned", Colors.purple[600]!);
        mediumTargets[mIdx] = QCService.pullUniqueFromInventory(
            gridNodes: gridNodes,
            possibleLengths: [3, 5],
            minResult: 10,
            maxResult: 50,
            allowedOperators: ['+', '-', 'x'],
            excludeList: _getAllActiveOrders());
      } else if (hIdx != -1) {
        isOrderFulfilled = true;
        // Skill GIRL memberikan poin ekstra
        earned = GameConfig.selectedCharacter == "GIRL" ? 10 : 9;
        _showFloatingAnimation("+$earned", Colors.orange[600]!);
        hardTargets[hIdx] = QCService.pullUniqueFromInventory(
            gridNodes: gridNodes,
            possibleLengths: [5, 7],
            minResult: 20,
            maxResult: 100,
            allowedOperators: ['+', '-', 'x', '÷'],
            excludeList: _getAllActiveOrders());
      }

      if (isOrderFulfilled) {
        AudioService.playSuccessSFX();
        QCService.restockInventory(activeDeliveryRoute, gridNodes);
        setState(() {
          userScore += earned;
          currentSessionScore += earned;
          aiScore -= earned;
          if (aiScore < 0) aiScore = 0;
          if (userScore >= 50) {
            userScore = 50;
            aiScore = 0;
            _stopAllTimers();
            if (GameConfig.latestUnlockedLevel < 4) {
              GameConfig.latestUnlockedLevel++;
            }
            GameDialogHelper.showWinDialog(context, score: currentSessionScore);
          }
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
      backgroundColor: Colors.blue[300],
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(widget.bgImagePath), fit: BoxFit.cover)),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.pause_circle_filled_rounded),
                        color: Colors.white,
                        iconSize: 48,
                        onPressed: () {
                          _stopAllTimers();
                          GameDialogHelper.showPauseMenu(
                            context,
                            onResume: () {
                              _startTimer();
                              _startAITimer();
                              _resetIdleTimer();
                            },
                            onRestart: () {
                              setState(() {
                                userScore = 25;
                                aiScore = 25;
                                currentCalculationResult = "";
                                activeDeliveryRoute.clear();
                                _initRandomInventory();
                                _generateDemandForecast();
                                _initTimerConfig();
                                _startAITimer();
                                _resetIdleTimer();
                              });
                            },
                          );
                        }),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white, width: 2)),
                        child: Row(children: [
                          Icon(Icons.timer_rounded,
                              color: remainingSeconds <= 60
                                  ? Colors.redAccent
                                  : Colors.white),
                          const SizedBox(width: 8),
                          Text(formattedTime,
                              style: TextStyle(
                                  color: remainingSeconds <= 60
                                      ? Colors.redAccent
                                      : Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                        ])),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedBuilder(
                  animation: _borderAnimationController,
                  builder: (context, child) {
                    return Container(
                      margin: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 5))
                        ],
                      ),
                      child: Stack(
                        children: [
                          // ANIMATED BORDER - Berada di lapisan paling bawah stack, pas dengan kontainer
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
                          // GAME CONTENT - Menggunakan Padding agar konten tidak menempel ke border tebal
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                ScoreBarWidget(
                                    userScore: userScore, aiScore: aiScore),
                                const SizedBox(height: 16),
                                Expanded(
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait || MediaQuery.of(context).size.width < 600;
                                      
                                      Widget gridWidget = Expanded(
                                        flex: isPortrait ? 5 : 2,
                                        child: Center(
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: LayoutBuilder(builder:
                                                (context, gridConstraints) {
                                              return _buildGrid(gridConstraints);
                                            }),
                                          ),
                                        ),
                                      );

                                      Widget previewWidget = Expanded(
                                        flex: isPortrait ? 1 : 1,
                                        child: Center(
                                          child: ResultPreviewWidget(
                                              result: currentCalculationResult),
                                        ),
                                      );

                                      Widget targetsWidget = Expanded(
                                        flex: isPortrait ? 3 : 2,
                                        child: _buildTargetsRow(),
                                      );

                                      if (isPortrait) {
                                        return Column(
                                          children: [
                                            targetsWidget,
                                            const SizedBox(height: 8),
                                            previewWidget,
                                            const SizedBox(height: 8),
                                            gridWidget,
                                          ],
                                        );
                                      } else {
                                        return Row(
                                          children: [
                                            gridWidget,
                                            previewWidget,
                                            targetsWidget,
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
            crossAxisCount: GameConfig.crossAxisCount, childAspectRatio: 1.0),
        itemCount: gridNodes.length,
        itemBuilder: (context, index) {
          bool isHint = hintedRoute.contains(index);
          return Container(
            decoration: isHint
                ? BoxDecoration(
                    border: Border.all(color: Colors.yellowAccent, width: 4),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                        BoxShadow(
                            color: Colors.yellowAccent.withValues(alpha: 0.6),
                            blurRadius: 8,
                            spreadRadius: 2)
                      ])
                : null,
            child: NodeWidget(node: gridNodes[index]),
          );
        },
      ),
    );
  }

  Widget _buildTargetsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TargetColumnWidget(
            header: '+3',
            targets: easyTargets,
            headerColor: Colors.green[600]!),
        TargetColumnWidget(
            header: '+5',
            targets: mediumTargets,
            headerColor: Colors.purple[600]!),
        TargetColumnWidget(
            header: '+9',
            targets: hardTargets,
            headerColor: Colors.orange[600]!),
      ],
    );
  }
}
