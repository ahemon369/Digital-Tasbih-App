import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../providers/theme_provider.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _starsController;
  late AnimationController _moonController;
  late List<Star> _stars;

  @override
  void initState() {
    super.initState();
    _starsController = AnimationController(
      duration: const Duration(seconds: 180),
      vsync: this,
    )..repeat();

    _moonController = AnimationController(
      duration: const Duration(seconds: 120),
      vsync: this,
    )..repeat(reverse: true);

    _generateStars();
  }

  void _generateStars() {
    _stars = List.generate(50, (index) {
      return Star(
        x: math.Random().nextDouble(),
        y: math.Random().nextDouble(),
        size: math.Random().nextDouble() * 3 + 1,
        opacity: math.Random().nextDouble() * 0.8 + 0.2,
        twinkleSpeed: math.Random().nextDouble() * 2 + 1,
      );
    });
  }

  @override
  void dispose() {
    _starsController.dispose();
    _moonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(gradient: themeProvider.backgroundGradient),
          child: Stack(
            children: [
              // Animated Stars
              AnimatedBuilder(
                animation: _starsController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: StarsPainter(
                      stars: _stars,
                      animationValue: _starsController.value,
                    ),
                    size: Size.infinite,
                  );
                },
              ),

              // Glowing Moon
              Positioned(
                top: 60,
                right: 40,
                child: AnimatedBuilder(
                  animation: _moonController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_moonController.value * 0.1),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: themeProvider.isRamadanMode
                              ? const Color(0xFFD4AF37).withOpacity(0.8)
                              : const Color(0xFFF0E68C).withOpacity(0.8),
                          boxShadow: [
                            BoxShadow(
                              color: themeProvider.isRamadanMode
                                  ? const Color(0xFFD4AF37)
                                  : const Color(0xFFF0E68C),
                              blurRadius: 20 + (_moonController.value * 10),
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  themeProvider.isRamadanMode
                                      ? const Color(0xFFFFD700)
                                      : const Color(0xFFFFFACD),
                                  themeProvider.isRamadanMode
                                      ? const Color(0xFFD4AF37)
                                      : const Color(0xFFF0E68C),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Content
              widget.child,
            ],
          ),
        );
      },
    );
  }
}

class Star {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final double twinkleSpeed;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.twinkleSpeed,
  });
}

class StarsPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;

  StarsPainter({required this.stars, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final star in stars) {
      final twinkle =
          (math.sin(animationValue * 2 * math.pi * star.twinkleSpeed) + 1) / 2;
      final opacity = star.opacity * twinkle;

      paint.color = Colors.white.withOpacity(opacity);

      final x = star.x * size.width;
      final y = star.y * size.height;

      canvas.drawCircle(Offset(x, y), star.size, paint);

      // Add glow effect
      paint.color = Colors.white.withOpacity(opacity * 0.3);
      canvas.drawCircle(Offset(x, y), star.size * 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
