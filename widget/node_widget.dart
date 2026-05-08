import 'package:flutter/material.dart';
import 'package:praktikum_1/model/node_model.dart';

class NodeWidget extends StatelessWidget {
  final NodeModel node;

  const NodeWidget({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    return Container(
      // --- PERUBAHAN: Meningkatkan margin antar box ---
      margin: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: node.isSelected ? Colors.blueGrey[400] : Colors.grey[400],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text(
          node.value,
          style: TextStyle(
            // --- PERUBAHAN: Meningkatkan ukuran text ---
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: node.type == NodeType.empty
                ? Colors.transparent
                : Colors.black87,
          ),
        ),
      ),
    );
  }
}
