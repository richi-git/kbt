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

class GameView extends StatefulWidget {
  final String bgImagePath;
  final int level;

  const GameView({
    super.key,
    this.bgImagePath = 'assets/beachmap.jpeg',
    this.level = 1,
  });

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  late List<NodeModel> gridNodes;
  final Random _random = Random();

  List<String> easyTargets = [];
  List<String> mediumTargets = [];
  List<String> hardTargets = [];
  List<int> activeDeliveryRoute = [];

  // FIX: Tarik Tambang! Total poin harus selalu 50.
  int userScore = 10;
  int aiScore = 40;

  String currentCalculationResult = "";

  // Variabel Timer Utama & Skill Karakter
  Timer? _timer;
  Timer? _aiTimer;
  Timer? _idleTimer;
  List<int> hintedRoute = [];

  late int remainingSeconds;

  @override
  void initState() {
    super.initState();
    _initRandomInventory();
    _generateDemandForecast();
    _initTimerConfig();
    _startAITimer();
    _resetIdleTimer();
  }

  // --- LOGIKA TIMER & SKILL KARAKTER ---
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
      case 1:
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
        _showLoseDialog("Waktu Habis!");
      }
    });
  }

  // AI OTONOM (Skill BOY)
  void _startAITimer() {
    int aiInterval = GameConfig.selectedCharacter == "BOY" ? 5 : 3;

    _aiTimer = Timer.periodic(Duration(seconds: aiInterval), (timer) {
      if (mounted) {
        setState(() {
          if (userScore > 0) {
            // FIX: AI mencuri poin pemain secara nyata (Tarik Tambang)
            userScore -= 1;
            aiScore += 1;
          }

          // Jika AI berhasil mencuri semua poin pemain, game over!
          if (userScore <= 0) {
            userScore = 0;
            aiScore = 50;
            _stopAllTimers();
            _showLoseDialog("AI merebut semua poinmu!");
          }
        });
      }
    });
  }

  // HINT LOGIC (Skill BUBU)
  void _resetIdleTimer() {
    _idleTimer?.cancel();
    if (hintedRoute.isNotEmpty) {
      setState(() {
        hintedRoute.clear();
      });
    }

    if (GameConfig.selectedCharacter == "BUBU") {
      _idleTimer = Timer(const Duration(seconds: 5), () {
        if (mounted) {
          List<int> route = _findHintRoute();
          if (route.isNotEmpty) {
            setState(() {
              hintedRoute = route;
            });
          }
        }
      });
    }
  }

  List<int> _findHintRoute() {
    List<String> allTargets = _getAllActiveOrders();
    for (int attempts = 0; attempts < 300; attempts++) {
      int length = _random.nextBool() ? 3 : (_random.nextBool() ? 5 : 7);
      int startIndex = _random.nextInt(gridNodes.length);

      if (gridNodes[startIndex].type != NodeType.number) continue;

      List<int> testRoute = [startIndex];
      int currentIndex = startIndex;
      bool isFailed = false;

      for (int i = 1; i < length; i++) {
        List<int> neighbors = _getAdjacentNodes(currentIndex);
        neighbors.removeWhere((n) => testRoute.contains(n));
        NodeType expectedType =
            (i % 2 == 0) ? NodeType.number : NodeType.operator;
        neighbors.retainWhere((n) => gridNodes[n].type == expectedType);

        if (neighbors.isEmpty) {
          isFailed = true;
          break;
        }
        currentIndex = neighbors[_random.nextInt(neighbors.length)];
        testRoute.add(currentIndex);
      }

      if (!isFailed && QCService.validateRoute(testRoute, gridNodes)) {
        int result = QCService.calculateOutput(testRoute, gridNodes);
        if (allTargets.contains(result.toString())) return testRoute;
      }
    }
    return [];
  }

  void _stopAllTimers() {
    _timer?.cancel();
    _aiTimer?.cancel();
    _idleTimer?.cancel();
  }

  String get formattedTime {
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _stopAllTimers();
    super.dispose();
  }

  // --- LOGIKA PERMAINAN INTI ---
  void _initRandomInventory() {
    gridNodes = List.generate(
      GameConfig.crossAxisCount * GameConfig.mainAxisCount,
      (index) {
        if (_random.nextDouble() > 0.3) {
          int randomNum = _random.nextInt(9) + 1;
          return NodeModel(
              id: index, value: randomNum.toString(), type: NodeType.number);
        } else {
          String randomOp = GameConfig
              .operators[_random.nextInt(GameConfig.operators.length)];
          return NodeModel(id: index, value: randomOp, type: NodeType.operator);
        }
      },
    );
  }

  List<String> _getAllActiveOrders() {
    return [...easyTargets, ...mediumTargets, ...hardTargets];
  }

  void _generateDemandForecast() {
    int batchSize = GameConfig.mainAxisCount;
    easyTargets.clear();
    mediumTargets.clear();
    hardTargets.clear();

    for (int i = 0; i < batchSize; i++) {
      easyTargets.add(_pullUniqueFromInventory(
          possibleLengths: [3],
          minResult: 2,
          maxResult: 20,
          allowedOperators: ['+', '-'],
          excludeList: _getAllActiveOrders()));
    }
    for (int i = 0; i < batchSize; i++) {
      mediumTargets.add(_pullUniqueFromInventory(
          possibleLengths: [3, 5],
          minResult: 10,
          maxResult: 50,
          allowedOperators: ['+', '-', 'x'],
          excludeList: _getAllActiveOrders()));
    }
    for (int i = 0; i < batchSize; i++) {
      hardTargets.add(_pullUniqueFromInventory(
          possibleLengths: [5, 7],
          minResult: 20,
          maxResult: 100,
          allowedOperators: ['+', '-', 'x', '÷'],
          excludeList: _getAllActiveOrders()));
    }
  }

  String _pullUniqueFromInventory({
    required List<int> possibleLengths,
    required int minResult,
    required int maxResult,
    required List<String> allowedOperators,
    required List<String> excludeList,
  }) {
    int attempts = 0;
    while (attempts < 100) {
      attempts++;
      int targetLength =
          possibleLengths[_random.nextInt(possibleLengths.length)];
      int startIndex = _random.nextInt(gridNodes.length);

      if (gridNodes[startIndex].type != NodeType.number) continue;

      List<int> testRoute = [startIndex];
      int currentIndex = startIndex;
      bool isRouteFailed = false;

      for (int i = 1; i < targetLength; i++) {
        List<int> neighbors = _getAdjacentNodes(currentIndex);
        neighbors.removeWhere((n) => testRoute.contains(n));
        NodeType expectedType =
            (i % 2 == 0) ? NodeType.number : NodeType.operator;
        neighbors.retainWhere((n) => gridNodes[n].type == expectedType);
        if (expectedType == NodeType.operator) {
          neighbors.retainWhere(
              (n) => allowedOperators.contains(gridNodes[n].value));
        }

        if (neighbors.isEmpty) {
          isRouteFailed = true;
          break;
        }

        currentIndex = neighbors[_random.nextInt(neighbors.length)];
        testRoute.add(currentIndex);
      }

      if (!isRouteFailed && QCService.validateRoute(testRoute, gridNodes)) {
        int result = QCService.calculateOutput(testRoute, gridNodes);
        if (result >= minResult &&
            result <= maxResult &&
            !excludeList.contains(result.toString())) {
          return result.toString();
        }
      }
    }

    int fallbackAttempts = 0;
    while (fallbackAttempts < 50) {
      fallbackAttempts++;
      int fallback = _random.nextInt(maxResult - minResult + 1) + minResult;
      if (!excludeList.contains(fallback.toString()))
        return fallback.toString();
    }
    return (_random.nextInt(maxResult - minResult + 1) + minResult).toString();
  }

  List<int> _getAdjacentNodes(int index) {
    List<int> neighbors = [];
    int row = index ~/ GameConfig.crossAxisCount;
    int col = index % GameConfig.crossAxisCount;

    for (int r = max(0, row - 1);
        r <= min(GameConfig.mainAxisCount - 1, row + 1);
        r++) {
      for (int c = max(0, col - 1);
          c <= min(GameConfig.crossAxisCount - 1, col + 1);
          c++) {
        if (r == row && c == col) continue;
        neighbors.add(r * GameConfig.crossAxisCount + c);
      }
    }
    return neighbors;
  }

  void _planRoute(Offset position, BoxConstraints constraints) {
    _resetIdleTimer();

    double cellWidth = constraints.maxWidth / GameConfig.crossAxisCount;
    double cellHeight = constraints.maxHeight / GameConfig.mainAxisCount;

    int col = (position.dx / cellWidth).floor();
    int row = (position.dy / cellHeight).floor();

    if (col >= 0 &&
        col < GameConfig.crossAxisCount &&
        row >= 0 &&
        row < GameConfig.mainAxisCount) {
      double relativeX = (position.dx % cellWidth) / cellWidth;
      double relativeY = (position.dy % cellHeight) / cellHeight;
      if (relativeX < 0.2 ||
          relativeX > 0.8 ||
          relativeY < 0.2 ||
          relativeY > 0.8) return;

      int index = row * GameConfig.crossAxisCount + col;

      if (activeDeliveryRoute.contains(index)) {
        if (activeDeliveryRoute.length > 1 &&
            activeDeliveryRoute[activeDeliveryRoute.length - 2] == index) {
          setState(() {
            int removedIndex = activeDeliveryRoute.removeLast();
            gridNodes[removedIndex].isSelected = false;
            if (activeDeliveryRoute.isNotEmpty &&
                QCService.validateRoute(activeDeliveryRoute, gridNodes)) {
              currentCalculationResult =
                  QCService.calculateOutput(activeDeliveryRoute, gridNodes)
                      .toString();
            } else {
              currentCalculationResult = "";
            }
          });
        }
        return;
      }

      if (activeDeliveryRoute.isNotEmpty) {
        int lastIndex = activeDeliveryRoute.last;
        int lastRow = lastIndex ~/ GameConfig.crossAxisCount;
        int lastCol = lastIndex % GameConfig.crossAxisCount;
        if ((row - lastRow).abs() > 1 || (col - lastCol).abs() > 1) return;
      }

      setState(() {
        activeDeliveryRoute.add(index);
        gridNodes[index].isSelected = true;

        if (QCService.validateRoute(activeDeliveryRoute, gridNodes)) {
          currentCalculationResult =
              QCService.calculateOutput(activeDeliveryRoute, gridNodes)
                  .toString();
        } else {
          currentCalculationResult = "";
        }
      });
    }
  }

  void _executeDelivery() {
    _resetIdleTimer();

    if (activeDeliveryRoute.isEmpty) return;

    if (QCService.validateRoute(activeDeliveryRoute, gridNodes)) {
      int output = QCService.calculateOutput(activeDeliveryRoute, gridNodes);
      String outputStr = output.toString();
      bool isOrderFulfilled = false;

      int easyIndex = easyTargets.indexOf(outputStr);
      if (easyIndex != -1) {
        isOrderFulfilled = true;

        // FIX: Tarik Tambang Bertambah!
        int earned = 3;
        userScore += earned;
        aiScore -= earned;

        easyTargets[easyIndex] = _pullUniqueFromInventory(
            possibleLengths: [3],
            minResult: 2,
            maxResult: 20,
            allowedOperators: ['+', '-'],
            excludeList: _getAllActiveOrders());
      } else {
        int mediumIndex = mediumTargets.indexOf(outputStr);
        if (mediumIndex != -1) {
          isOrderFulfilled = true;

          // FIX: Tarik Tambang Bertambah!
          int earned = 5;
          userScore += earned;
          aiScore -= earned;

          mediumTargets[mediumIndex] = _pullUniqueFromInventory(
              possibleLengths: [3, 5],
              minResult: 10,
              maxResult: 50,
              allowedOperators: ['+', '-', 'x'],
              excludeList: _getAllActiveOrders());
        } else {
          int hardIndex = hardTargets.indexOf(outputStr);
          if (hardIndex != -1) {
            isOrderFulfilled = true;

            // FIX: Tarik Tambang Bertambah dengan Skil Girl!
            int earned = GameConfig.selectedCharacter == "GIRL" ? 10 : 9;
            userScore += earned;
            aiScore -= earned;

            hardTargets[hardIndex] = _pullUniqueFromInventory(
                possibleLengths: [5, 7],
                minResult: 20,
                maxResult: 100,
                allowedOperators: ['+', '-', 'x', '÷'],
                excludeList: _getAllActiveOrders());
          }
        }
      }

      if (isOrderFulfilled) {
        QCService.restockInventory(activeDeliveryRoute, gridNodes);

        // Pastikan AI tidak minus
        if (aiScore < 0) aiScore = 0;

        // FIX: Syarat Menang dan Memenuhi Bar 100%
        if (userScore >= 50) {
          userScore = 50;
          aiScore = 0;
          _stopAllTimers();
          if (GameConfig.latestUnlockedLevel < 4) {
            GameConfig.latestUnlockedLevel++;
          }
          _showWinDialog();
          return;
        }
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

  // --- POP-UP MENU ---
  void _showPauseMenu() {
    _stopAllTimers();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Game Paused',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          content: const Text('Apa yang ingin kamu lakukan?',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startTimer();
                _startAITimer();
                _resetIdleTimer();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[500],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
              child: const Text('Resume',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
              child: const Text('Home',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("LEVEL COMPLETE!",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.green)),
        content: const Text("Selamat! Level berikutnya telah terbuka.",
            textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
            child: const Text("BACK TO MAP",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  void _showLoseDialog(String reason) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("GAME OVER!",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: Colors.red)),
        content: Text("$reason\nCoba lagi ya!",
            textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
            child: const Text("KEMBALI KE MAP",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.bgImagePath),
            fit: BoxFit.cover,
          ),
        ),
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
                      onPressed: _showPauseMenu,
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.timer_rounded,
                                color: remainingSeconds <= 60
                                    ? Colors.redAccent
                                    : Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              formattedTime,
                              style: TextStyle(
                                  color: remainingSeconds <= 60
                                      ? Colors.redAccent
                                      : Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 24),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.blue[300]!, width: 4),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5))
                    ],
                  ),
                  child: Column(
                    children: [
                      ScoreBarWidget(userScore: userScore, aiScore: aiScore),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: LayoutBuilder(
                                      builder: (context, constraints) {
                                    return GestureDetector(
                                      onPanStart: (details) => _planRoute(
                                          details.localPosition, constraints),
                                      onPanUpdate: (details) => _planRoute(
                                          details.localPosition, constraints),
                                      onPanEnd: (details) => _executeDelivery(),
                                      child: GridView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              GameConfig.crossAxisCount,
                                          childAspectRatio: 1.0,
                                        ),
                                        itemCount: gridNodes.length,
                                        itemBuilder: (context, index) {
                                          bool isHint =
                                              hintedRoute.contains(index);
                                          return Container(
                                            decoration: isHint
                                                ? BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            Colors.yellowAccent,
                                                        width: 4),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    boxShadow: [
                                                        BoxShadow(
                                                          color: Colors
                                                              .yellowAccent
                                                              .withOpacity(0.6),
                                                          blurRadius: 8,
                                                          spreadRadius: 2,
                                                        )
                                                      ])
                                                : null,
                                            child: NodeWidget(
                                                node: gridNodes[index]),
                                          );
                                        },
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: ResultPreviewWidget(
                                    result: currentCalculationResult),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                              ),
                            ),
                          ],
                        ),
                      ),
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
}
