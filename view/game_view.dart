import 'dart:math';
import 'package:flutter/material.dart';
import 'package:praktikum_1/model/node_model.dart';
import 'package:praktikum_1/widget/node_widget.dart';
import 'package:praktikum_1/config/game_config.dart';
import 'package:praktikum_1/widget/result_preview.dart';
import 'package:praktikum_1/widget/score_bar_widget.dart';
import 'package:praktikum_1/service/qc_service.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

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

  // KPI Score Dashboard State
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

  // Helper logistik untuk melihat semua order yang ada
  List<String> _getAllActiveOrders() {
    return [...easyTargets, ...mediumTargets, ...hardTargets];
  }

  void _generateDemandForecast() {
    int batchSize = GameConfig.mainAxisCount;
    easyTargets.clear();
    mediumTargets.clear();
    hardTargets.clear();

    for (int i = 0; i < batchSize; i++) {
      easyTargets.add(_pullUniqueFromInventory(3, _getAllActiveOrders()));
    }
    for (int i = 0; i < batchSize; i++) {
      mediumTargets.add(_pullUniqueFromInventory(5, _getAllActiveOrders()));
    }
    for (int i = 0; i < batchSize; i++) {
      hardTargets.add(_pullUniqueFromInventory(7, _getAllActiveOrders()));
    }
  }

  // Ekstraksi data dengan filter Unique SKU
  String _pullUniqueFromInventory(int targetLength, List<String> excludeList) {
    int attempts = 0;
    while (attempts < 50) {
      attempts++;
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

        if (neighbors.isEmpty) {
          isRouteFailed = true;
          break;
        }

        currentIndex = neighbors[_random.nextInt(neighbors.length)];
        testRoute.add(currentIndex);
      }

      if (!isRouteFailed && QCService.validateRoute(testRoute, gridNodes)) {
        int result = QCService.calculateOutput(testRoute, gridNodes);
        // Validasi tambahan: Hasil harus positif dan belum ada di daftar order
        if (result > 0 && !excludeList.contains(result.toString())) {
          return result.toString();
        }
      }
    }

    // Safety stock fallback dengan validasi unik
    int fallbackAttempts = 0;
    while (fallbackAttempts < 50) {
      fallbackAttempts++;
      String fallback;
      if (targetLength == 3)
        fallback = (_random.nextInt(20) + 1).toString();
      else if (targetLength == 5)
        fallback = (_random.nextInt(30) + 21).toString();
      else
        fallback = (_random.nextInt(50) + 51).toString();

      if (!excludeList.contains(fallback)) return fallback;
    }

    return (_random.nextInt(900) + 100).toString(); // Extreme fallback
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
        easyTargets[easyIndex] =
            _pullUniqueFromInventory(3, _getAllActiveOrders());
      } else {
        int mediumIndex = mediumTargets.indexOf(outputStr);
        if (mediumIndex != -1) {
          isOrderFulfilled = true;
          userScore += 5;
          mediumTargets[mediumIndex] =
              _pullUniqueFromInventory(5, _getAllActiveOrders());
        } else {
          int hardIndex = hardTargets.indexOf(outputStr);
          if (hardIndex != -1) {
            isOrderFulfilled = true;
            userScore += 9;
            hardTargets[hardIndex] =
                _pullUniqueFromInventory(7, _getAllActiveOrders());
          }
        }
      }

      if (isOrderFulfilled) {
        QCService.restockInventory(activeDeliveryRoute, gridNodes);
        if (aiScore > 10) aiScore -= 2;
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ScoreBarWidget(userScore: userScore, aiScore: aiScore),
              const SizedBox(height: 24),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: LayoutBuilder(builder: (context, constraints) {
                            return GestureDetector(
                              onPanStart: (details) => _planRoute(
                                  details.localPosition, constraints),
                              onPanUpdate: (details) => _planRoute(
                                  details.localPosition, constraints),
                              onPanEnd: (details) => _executeDelivery(),
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: GameConfig.crossAxisCount,
                                  childAspectRatio: 1.0,
                                ),
                                itemCount: gridNodes.length,
                                itemBuilder: (context, index) {
                                  return NodeWidget(node: gridNodes[index]);
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ResultPreviewWidget(result: currentCalculationResult),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildDemandColumn('+3', easyTargets),
                          _buildDemandColumn('+5', mediumTargets),
                          _buildDemandColumn('+9', hardTargets),
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
    );
  }

  Widget _buildDemandColumn(String header, List<String> targets) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                header,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ...targets.map((t) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    t,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
