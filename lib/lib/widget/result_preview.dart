import 'package:flutter/material.dart';

class ResultPreviewWidget extends StatelessWidget {
  final String result;

  const ResultPreviewWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue[400]!, width: 3),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              result,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w900,
                height: 1.0,
                leadingDistribution: TextLeadingDistribution.even,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
