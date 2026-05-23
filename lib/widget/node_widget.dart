import 'package:flutter/material.dart';
import 'package:praktikum_1/model/node_model.dart';

class NodeWidget extends StatelessWidget {
  final NodeModel node;

  const NodeWidget({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Hitung ukuran font secara dinamis (sekitar 45% dari lebar kotak)
        double fontSize = (constraints.maxWidth * 0.45).clamp(12.0, 32.0);

        return Container(
          margin: const EdgeInsets.all(2.0), // Margin diperkecil agar ruang lega
          decoration: BoxDecoration(
            color: node.isSelected ? Colors.blue[100] : Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
                color: node.isSelected ? Colors.blue : Colors.blue[100]!,
                width: 2),
            boxShadow: [
              if (!node.isSelected)
                BoxShadow(
                  color: Colors.blueGrey.withValues(alpha: 0.2),
                  blurRadius: 2,
                  offset: const Offset(1, 2),
                )
            ],
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                node.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize * 1.6, // Ukuran lebih mantap
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                  leadingDistribution: TextLeadingDistribution.even,
                  color: node.type == NodeType.empty
                      ? Colors.transparent
                      : const Color(0xFF0D47A1), // Biru gelap
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
