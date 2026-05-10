import 'dart:math' as math;
import 'package:flutter/material.dart';

class MLBorderPainter extends CustomPainter {
  final Color color;
  final double progress;
  final String type;
  final bool isHovered;
  final double borderRadius;

  MLBorderPainter({
    required this.color,
    required this.progress,
    required this.type,
    required this.isHovered,
    this.borderRadius = 20.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    
    // Background Glow Base (Aura Dasar)
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = isHovered ? 12 : 8
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
      ..color = color.withValues(alpha: 0.6);
    canvas.drawRRect(rrect, glowPaint);

    final mainPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = isHovered ? 6 : 4;

    if (type == "flow") {
      _paintFlowEffect(canvas, size, mainPaint);
    } else if (type == "shimmer") {
      _paintShimmerEffect(canvas, size, mainPaint);
    } else if (type == "scan") {
      _paintScanEffect(canvas, size, mainPaint);
    } else if (type == "pulse") {
      _paintPulseEffect(canvas, size, mainPaint);
    } else if (type == "fire") {
      _paintFireEffect(canvas, size, mainPaint);
    } else if (type == "crystal") {
      _paintCrystalEffect(canvas, size, mainPaint);
    } else if (type == "vortex") {
      _paintVortexEffect(canvas, size, mainPaint);
    }
  }

  void _paintFlowEffect(Canvas canvas, Size size, Paint paint) {
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(borderRadius));
    
    paint.shader = SweepGradient(
      colors: [Colors.transparent, color, Colors.white, color, Colors.transparent],
      stops: const [0.0, 0.4, 0.5, 0.6, 1.0],
      transform: GradientRotation(progress * 2 * math.pi),
    ).createShader(Offset.zero & size);
    
    paint.strokeWidth = 8;
    canvas.drawRRect(rrect, paint);
  }

  void _paintShimmerEffect(Canvas canvas, Size size, Paint paint) {
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(borderRadius));
    
    final shimmerShader = LinearGradient(
      colors: [Colors.transparent, Colors.white, color, Colors.white, Colors.transparent],
      stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      transform: GradientRotation(progress * 4 * math.pi),
    ).createShader(Offset.zero & size);
    
    paint.shader = shimmerShader;
    paint.strokeWidth = 7;
    canvas.drawRRect(rrect, paint);
    
    final cornerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    
    double orbit = 12 * math.sin(progress * 2 * math.pi);
    canvas.drawCircle(Offset(orbit, orbit), 6, cornerPaint);
    canvas.drawCircle(Offset(size.width - orbit, orbit), 6, cornerPaint);
    canvas.drawCircle(Offset(orbit, size.height - orbit), 6, cornerPaint);
    canvas.drawCircle(Offset(size.width - orbit, size.height - orbit), 6, cornerPaint);
  }

  void _paintScanEffect(Canvas canvas, Size size, Paint paint) {
    final scanY = size.height * progress;
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(borderRadius));
    
    paint.color = color.withValues(alpha: 0.4);
    paint.strokeWidth = 4;
    canvas.drawRRect(rrect, paint);

    final scanPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawLine(Offset(5, scanY), Offset(size.width - 5, scanY), scanPaint);
    
    final glowShader = LinearGradient(
      colors: [Colors.transparent, color, Colors.white, color, Colors.transparent],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(Rect.fromLTWH(0, scanY - 30, size.width, 60));
    
    final glowPaint = Paint()..shader = glowShader;
    canvas.drawRect(Rect.fromLTWH(0, scanY - 30, size.width, 60), glowPaint);
  }

  void _paintPulseEffect(Canvas canvas, Size size, Paint paint) {
    final pulseValue = (math.sin(progress * 2 * math.pi) + 1) / 2;
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(borderRadius));
    
    final outerPulse = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10 * pulseValue
      ..color = color.withValues(alpha: 0.5 * (1 - pulseValue))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawRRect(rrect, outerPulse);

    paint.color = Color.lerp(color, Colors.white, 0.5 * pulseValue)!;
    paint.strokeWidth = 6 + 4 * pulseValue;
    canvas.drawRRect(rrect, paint);
  }

  void _paintFireEffect(Canvas canvas, Size size, Paint paint) {
    final fireShader = LinearGradient(
      colors: [Colors.transparent, color, Colors.white, Colors.orangeAccent, Colors.transparent],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      stops: [0.0, progress * 0.8, progress, (progress + 0.2).clamp(0, 1), 1.0],
    ).createShader(Offset.zero & size);
    
    paint.strokeWidth = 8;
    paint.shader = fireShader;
    canvas.drawRRect(RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(borderRadius)), paint);

    for (int i = 0; i < 8; i++) {
      final pPaint = Paint()
        ..color = i % 2 == 0 ? Colors.white : color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      double px = (math.sin(progress * 15 + i * 50) + 1) / 2 * size.width;
      double py = ((1 - progress) * size.height + (i * 10)) % size.height;
      canvas.drawCircle(Offset(px, py), 4 * (1 - py/size.height), pPaint);
    }
  }

  void _paintCrystalEffect(Canvas canvas, Size size, Paint paint) {
    final crystalShader = LinearGradient(
      colors: [color, Colors.white, color, Colors.white, color],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.0, (progress - 0.1).clamp(0, 1), progress, (progress + 0.1).clamp(0, 1), 1.0],
    ).createShader(Offset.zero & size);
    
    paint.strokeWidth = 6;
    paint.shader = crystalShader;
    canvas.drawRRect(RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(borderRadius)), paint);

    final flashPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9 * (math.sin(progress * 4 * math.pi).abs()))
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawLine(const Offset(10, 10), Offset(size.width - 10, size.height - 10), flashPaint);
    canvas.drawLine(Offset(size.width - 10, 10), Offset(10, size.height - 10), flashPaint);
  }

  void _paintVortexEffect(Canvas canvas, Size size, Paint paint) {
    canvas.save();
    canvas.translate(size.width/2, size.height/2);
    canvas.rotate(progress * 2 * math.pi);
    
    final vortexShader = RadialGradient(
      colors: [Colors.white, color, Colors.transparent, color, Colors.white],
      stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
    ).createShader(Rect.fromCircle(center: Offset.zero, radius: size.width));
    
    paint.shader = vortexShader;
    paint.strokeWidth = 10;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: size.width + 10, height: size.height + 10), Radius.circular(borderRadius)), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(MLBorderPainter oldDelegate) => true;
}
