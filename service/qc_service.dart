import 'dart:math';
import 'package:praktikum_1/model/node_model.dart';
import 'package:praktikum_1/config/game_config.dart';

class QCService {
  static final Random _random = Random();

  // Validasi alur produksi (Angka -> Operator -> Angka)
  static bool validateRoute(List<int> route, List<NodeModel> inventory) {
    if (route.length < 3 || route.length % 2 == 0) return false;
    for (int i = 0; i < route.length; i++) {
      NodeType expectedType =
          (i % 2 == 0) ? NodeType.number : NodeType.operator;
      if (inventory[route[i]].type != expectedType) return false;
    }
    return true;
  }

  // Kalkulasi output produksi (kiri ke kanan)
  static int calculateOutput(List<int> route, List<NodeModel> inventory) {
    int result = int.parse(inventory[route[0]].value);
    for (int i = 1; i < route.length; i += 2) {
      String op = inventory[route[i]].value;
      int nextNum = int.parse(inventory[route[i + 1]].value);

      if (op == '+')
        result += nextNum;
      else if (op == '-')
        result -= nextNum;
      else if (op == 'x')
        result *= nextNum;
      else if (op == '÷') {
        if (nextNum == 0 || result % nextNum != 0)
          return -9999; // Reject barang cacat (desimal)
        result ~/= nextNum;
      }
    }
    return result;
  }

  // Restock inventory otomatis pada rute yang kosong
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
}
