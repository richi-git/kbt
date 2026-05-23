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
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait || MediaQuery.of(context).size.width < 600;
    double headerFontSize = isPortrait ? 16 : 28; // Diperbesar dari 22 ke 28
    double itemFontSize = isPortrait ? 14 : 24;   // Diperbesar dari 18 ke 24

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: Colors.white
              .withValues(alpha: 0.9), // Latar belakang putih transparan
          borderRadius: BorderRadius.circular(12.0),
          border:
              Border.all(color: headerColor.withValues(alpha: 0.5), width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
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
                style: TextStyle(
                    fontSize: headerFontSize,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                    leadingDistribution: TextLeadingDistribution.even,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 4),
            // Daftar Angka
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ...targets.map((t) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text(
                            t,
                            style: TextStyle(
                                fontSize: itemFontSize,
                                fontWeight: FontWeight.bold,
                                height: 1.0,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                                color: Colors.black87),
                          ),
                        )),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
