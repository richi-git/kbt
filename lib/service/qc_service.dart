import 'dart:math';
import 'package:praktikum_1/model/node_model.dart';
import 'package:praktikum_1/config/game_config.dart';

class QCService {
  static final Random _random = Random();

  // --- LOGIKA VALIDASI & OUTPUT ---
  static bool validateRoute(List<int> route, List<NodeModel> inventory) {
    if (route.length < 3 || route.length % 2 == 0) return false;
    for (int i = 0; i < route.length; i++) {
      NodeType expectedType =
          (i % 2 == 0) ? NodeType.number : NodeType.operator;
      if (inventory[route[i]].type != expectedType) return false;
    }
    return true;
  }

  static int calculateOutput(List<int> route, List<NodeModel> inventory) {
    int result = int.parse(inventory[route[0]].value);
    for (int i = 1; i < route.length; i += 2) {
      String op = inventory[route[i]].value;
      int nextNum = int.parse(inventory[route[i + 1]].value);
      if (op == '+') {
        result += nextNum;
      } else if (op == '-') {
        result -= nextNum;
      } else if (op == 'x') {
        result *= nextNum;
      } else if (op == '÷') {
        if (nextNum == 0 || result % nextNum != 0) return -9999;
        result ~/= nextNum;
      }
    }
    return result;
  }

  static void restockInventory(List<int> route, List<NodeModel> inventory) {
    for (int index in route) {
      if (_random.nextDouble() > 0.3) {
        inventory[index] = NodeModel(
            id: index,
            value: (_random.nextInt(9) + 1).toString(),
            type: NodeType.number);
      } else {
        String randomOp =
            GameConfig.operators[_random.nextInt(GameConfig.operators.length)];
        inventory[index] =
            NodeModel(id: index, value: randomOp, type: NodeType.operator);
      }
    }
  }

  // --- LOGIKA ALGORITMA PINDAHAN DARI GAME_VIEW ---
  static List<int> getAdjacentNodes(int index) {
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

  static String pullUniqueFromInventory({
    required List<NodeModel> gridNodes,
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
        List<int> neighbors = getAdjacentNodes(currentIndex);
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

      if (!isRouteFailed && validateRoute(testRoute, gridNodes)) {
        int result = calculateOutput(testRoute, gridNodes);
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
      if (!excludeList.contains(fallback.toString())) {
        return fallback.toString();
      }
    }
    return (_random.nextInt(maxResult - minResult + 1) + minResult).toString();
  }

  static List<int> findHintRoute(
      List<NodeModel> gridNodes, List<String> allTargets) {
    for (int attempts = 0; attempts < 300; attempts++) {
      int length = _random.nextBool() ? 3 : (_random.nextBool() ? 5 : 7);
      int startIndex = _random.nextInt(gridNodes.length);
      if (gridNodes[startIndex].type != NodeType.number) continue;

      List<int> testRoute = [startIndex];
      int currentIndex = startIndex;
      bool isFailed = false;

      for (int i = 1; i < length; i++) {
        List<int> neighbors = getAdjacentNodes(currentIndex);
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

      if (!isFailed && validateRoute(testRoute, gridNodes)) {
        int result = calculateOutput(testRoute, gridNodes);
        if (allTargets.contains(result.toString())) return testRoute;
      }
    }
    return [];
  }
}
