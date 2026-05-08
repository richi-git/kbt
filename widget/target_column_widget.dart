import 'package:flutter/material.dart';

class TargetColumnWidget extends StatelessWidget {
  final String header;
  final List<String> targets;
  final Color headerColor;

  const TargetColumnWidget({
    super.key,
    required this.header,
    required this.targets,
    required this.headerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color:
              Colors.white.withOpacity(0.9), // Latar belakang putih transparan
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: headerColor.withOpacity(0.5), width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Berwarna (Hijau, Ungu, Orange)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Text(
                header,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 4),
            // Daftar Angka
            ...targets.map((t) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    t,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
  