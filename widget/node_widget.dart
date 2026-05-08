import 'package:flutter/material.dart';
import 'package:praktikum_1/model/node_model.dart';

class NodeWidget extends StatelessWidget {
  final NodeModel node;

  const NodeWidget({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: node.isSelected ? Colors.blue[100] : Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
            color: node.isSelected ? Colors.blue : Colors.blue[100]!, width: 2),
        boxShadow: [
          if (!node.isSelected)
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.2),
              blurRadius: 2,
              offset: const Offset(1, 2),
            )
        ],
      ),
      child: Center(
        child: Text(
          node.value,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: node.type == NodeType.empty
                ? Colors.transparent
                : const Color(0xFF0D47A1), // Biru gelap
          ),
        ),
      ),
    );
  }
}
