import 'package:flutter/material.dart';

class ResultPreviewWidget extends StatelessWidget {
  final String result;

  const ResultPreviewWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70, // Lebar tetap stasiun inspeksi
      height: 70, // Tinggi tetap stasiun inspeksi
      decoration: BoxDecoration(
        color: Colors.blue[100], // Warna area inspeksi
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[300]!, width: 2),
      ),
      child: Center(
        child: Text(
          result,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 48, // Text besar untuk keterbacaan
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
