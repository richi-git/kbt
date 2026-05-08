import 'package:flutter/material.dart';

class ResultPreviewWidget extends StatelessWidget {
  final String result;

  const ResultPreviewWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0, // Memastikan bentuknya selalu persegi simetris
      child: Container(
        margin: const EdgeInsets.all(
            8.0), // Margin agar tidak terlalu mepet dengan grid/target
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(16), // Sudut lebih halus
          border: Border.all(color: Colors.blue[400]!, width: 3),
        ),
        padding: const EdgeInsets.all(
            8.0), // Jarak aman agar teks tidak menempel garis
        child: Center(
          // FITTEDBOX: Kunci agar teks panjang (contoh: 120, 1000) otomatis mengecil
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              result,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 56, // Ukuran maksimal font
                fontWeight: FontWeight.w900,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
