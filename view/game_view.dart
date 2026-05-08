import 'dart:math';
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

  const GameView({
    super.key,
    this.bgImagePath = 'assets/beachmap.jpeg',
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

  int userScore = 10;
  int aiScore = 100;
  String currentCalculationResult = "";

  @override
  void initState() {
    super.initState();
    _initRandomInventory();
    _generateDemandForecast();
  }

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
          possibleLengths: [3], // 1 Langkah (Angka-Operator-Angka)
          minResult: 2,
          maxResult: 20,
          allowedOperators: ['+', '-'],
          excludeList: _getAllActiveOrders()));
    }
    for (int i = 0; i < batchSize; i++) {
      mediumTargets.add(_pullUniqueFromInventory(
          possibleLengths: [3, 5], // 1 - 2 Langkah
          minResult: 10,
          maxResult: 50,
          allowedOperators: ['+', '-', 'x'],
          excludeList: _getAllActiveOrders()));
    }
    for (int i = 0; i < batchSize; i++) {
      hardTargets.add(_pullUniqueFromInventory(
          possibleLengths: [5, 7], // 2 - 3 Langkah
          minResult: 20,
          maxResult: 100,
          allowedOperators: ['+', '-', 'x', '÷'],
          excludeList: _getAllActiveOrders()));
    }
  }

  // Parameter yang lebih fleksibel menyesuaikan tabel level
  String _pullUniqueFromInventory({
    required List<int> possibleLengths,
    required int minResult,
    required int maxResult,
    required List<String> allowedOperators,
    required List<String> excludeList,
  }) {
    int attempts = 0;
    while (attempts < 100) {
      // Limit percobaan untuk menemukan rute di grid
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

        // Hanya mengizinkan operator sesuai tingkat kesulitan
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

    // Fallback sistem jika susunan grid sedang tidak memungkinkan membuat target tersebut
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
          relativeY > 0.8) {
        return;
      }

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
    if (activeDeliveryRoute.isEmpty) return;

    if (QCService.validateRoute(activeDeliveryRoute, gridNodes)) {
      int output = QCService.calculateOutput(activeDeliveryRoute, gridNodes);
      String outputStr = output.toString();

      bool isOrderFulfilled = false;

      int easyIndex = easyTargets.indexOf(outputStr);
      if (easyIndex != -1) {
        isOrderFulfilled = true;
        userScore += 3;
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
          userScore += 5;
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
            userScore += 9;
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

        // Logika Menang
        if (userScore >= 50) {
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

  void _showPauseMenu() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Game Paused',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          content: const Text(
            'Apa yang ingin kamu lakukan?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[500],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Resume',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Home',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
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
        title: const Text(
          "LEVEL COMPLETE!",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.green),
        ),
        content: const Text(
          "Selamat! Level berikutnya telah terbuka.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              "BACK TO MAP",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                          return NodeWidget(
                                              node: gridNodes[index]);
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
