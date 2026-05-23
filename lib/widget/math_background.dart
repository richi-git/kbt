import 'package:flutter/material.dart';

// Custom Widget for Mathlink Background with Mouse Parallax Effect
class MathBackground extends StatefulWidget {
  const MathBackground({super.key});

  @override
  State<MathBackground> createState() => _MathBackgroundState();
}

class _MathBackgroundState extends State<MathBackground> {
  Offset _mousePos = Offset.zero;

  void _onPointerMove(PointerEvent event) {
    setState(() {
      // Normalize position to -1.0 to 1.0 range
      double dx = (event.localPosition.dx / MediaQuery.of(context).size.width) * 2 - 1;
      double dy = (event.localPosition.dy / MediaQuery.of(context).size.height) * 2 - 1;
      _mousePos = Offset(dx, dy);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => _onPointerMove(event),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E3A8A),
              Color(0xFF312E81)
            ], // Deep Mathlink blue/purple space
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            _ParallaxSymbol(
                symbol: '+',
                left: 40,
                top: 100,
                size: 60,
                opacity: 0.15,
                angle: 0.2,
                mouseOffset: _mousePos,
                factor: 15),
            _ParallaxSymbol(
                symbol: '×',
                right: 50,
                top: 150,
                size: 80,
                opacity: 0.1,
                angle: -0.2,
                mouseOffset: _mousePos,
                factor: 25),
            _ParallaxSymbol(
                symbol: '÷',
                left: 80,
                bottom: 200,
                size: 70,
                opacity: 0.12,
                angle: 0.1,
                mouseOffset: _mousePos,
                factor: 20),
            _ParallaxSymbol(
                symbol: '-',
                right: 80,
                bottom: 120,
                size: 90,
                opacity: 0.08,
                angle: -0.1,
                mouseOffset: _mousePos,
                factor: 30),
            _ParallaxSymbol(
                symbol: '=',
                left: 150,
                top: 300,
                size: 50,
                opacity: 0.1,
                angle: 0.4,
                mouseOffset: _mousePos,
                factor: 10),
            _ParallaxSymbol(
                symbol: 'π',
                right: 120,
                top: 400,
                size: 60,
                opacity: 0.15,
                angle: -0.3,
                mouseOffset: _mousePos,
                factor: 18),
            _ParallaxSymbol(
                symbol: '%',
                right: 40,
                bottom: 300,                size: 55,
                opacity: 0.12,
                angle: -0.4,
                mouseOffset: _mousePos,
                factor: 14),

            // Geometric Shapes with subtle movement
            _ParallaxShape(
              left: -30,
              top: -30,
              radius: 100,
              mouseOffset: _mousePos,
              factor: 5,
            ),
            _ParallaxShape(
              right: -50,
              bottom: -50,
              radius: 120,
              mouseOffset: _mousePos,
              factor: 8,
            ),
          ],
        ),
      ),
    );
  }
}

class _ParallaxSymbol extends StatelessWidget {
  final String symbol;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final double size;
  final double opacity;
  final double angle;
  final Offset mouseOffset;
  final double factor;

  const _ParallaxSymbol({
    required this.symbol,
    this.left,
    this.right,
    this.top,
    this.bottom,
    required this.size,
    required this.opacity,
    required this.angle,
    required this.mouseOffset,
    required this.factor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 100),
      left: left != null ? left! + (mouseOffset.dx * factor) : null,
      right: right != null ? right! - (mouseOffset.dx * factor) : null,
      top: top != null ? top! + (mouseOffset.dy * factor) : null,
      bottom: bottom != null ? bottom! - (mouseOffset.dy * factor) : null,
      child: Transform.rotate(
        angle: angle + (mouseOffset.dx * 0.1), // Subtle rotation reaction
        child: Text(
          symbol,
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w900,
            color: Colors.white.withValues(alpha: opacity),
          ),
        ),
      ),
    );
  }
}

class _ParallaxShape extends StatelessWidget {
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final double radius;
  final Offset mouseOffset;
  final double factor;

  const _ParallaxShape({
    this.left,
    this.right,
    this.top,
    this.bottom,
    required this.radius,
    required this.mouseOffset,
    required this.factor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 100),
      left: left != null ? left! + (mouseOffset.dx * factor) : null,
      right: right != null ? right! - (mouseOffset.dx * factor) : null,
      top: top != null ? top! + (mouseOffset.dy * factor) : null,
      bottom: bottom != null ? bottom! - (mouseOffset.dy * factor) : null,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white10,
      ),
    );
  }
}
