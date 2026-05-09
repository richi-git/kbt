import 'package:flutter/material.dart';

class FloatingScoreWidget extends StatefulWidget {
  final String text;
  final Color color;
  final VoidCallback onComplete;

  const FloatingScoreWidget({
    super.key,
    required this.text,
    required this.color,
    required this.onComplete,
  });

  @override
  State<FloatingScoreWidget> createState() => _FloatingScoreWidgetState();
}

class _FloatingScoreWidgetState extends State<FloatingScoreWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dyAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    // Durasi animasi melayang = 1.5 detik
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Animasi bergerak ke atas (Sumbu Y negatif) sebesar 200 pixel
    _dyAnimation = Tween<double>(begin: 0, end: -200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Animasi memudar perlahan (Opacity 1.0 ke 0.0)
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Langsung mulai jalankan animasi begitu dibuat
    _controller.forward().then((_) {
      widget.onComplete(); // Panggil fungsi pembersihan setelah selesai
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          // Posisi awal muncul: Agak ke tengah kanan dekat papan target angka
          top: MediaQuery.of(context).size.height / 2 + _dyAnimation.value,
          right: MediaQuery.of(context).size.width / 4,
          child: Material(
            type: MaterialType
                .transparency, // Cegah error double underline kuning
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 64, // Ukuran teks besar agar memuaskan
                  fontWeight: FontWeight.w900,
                  color: widget.color,
                  shadows: const [
                    Shadow(
                        color: Colors.white,
                        blurRadius: 10), // Aura bersinar putih
                    Shadow(
                        color: Colors.black45,
                        offset: Offset(2, 4),
                        blurRadius: 4),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
