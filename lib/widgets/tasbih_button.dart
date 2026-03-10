import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math' as math;
import '../providers/theme_provider.dart';

class TasbihButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isCompleted;

  const TasbihButton({
    super.key,
    required this.onPressed,
    this.isCompleted = false,
  });

  @override
  State<TasbihButton> createState() => _TasbihButtonState();
}

class _TasbihButtonState extends State<TasbihButton>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;
  late AnimationController _scaleController;
  late Animation<double> _rippleAnimation;
  late Animation<double> _scaleAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _scaleController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/tasbih_click.mp3'));
    } catch (e) {
      // Handle sound error silently
    }
  }

  Future<void> _vibrate() async {
    try {
      await Vibration.vibrate(duration: 50);
    } catch (e) {
      // Handle vibration error silently
    }
  }

  void _onTap() {
    widget.onPressed();
    _scaleController.forward().then((_) => _scaleController.reverse());
    _rippleController.forward().then((_) => _rippleController.reset());
    _playSound();
    _vibrate();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return GestureDetector(
          onTap: widget.isCompleted ? null : _onTap,
          child: AnimatedBuilder(
            animation: Listenable.merge([_scaleAnimation, _rippleAnimation]),
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 140, // Further reduced from 160
                  height: 140, // Further reduced from 160
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        themeProvider.primaryColor,
                        themeProvider.primaryColor.withOpacity(0.8),
                        themeProvider.primaryColor.withOpacity(0.6),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: themeProvider.primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Ripple effect
                      if (_rippleAnimation.value > 0)
                        Container(
                          width: 140 * (1 + _rippleAnimation.value * 0.5),
                          height: 140 * (1 + _rippleAnimation.value * 0.5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: themeProvider.primaryColor.withOpacity(
                                0.3 * (1 - _rippleAnimation.value),
                              ),
                              width: 2,
                            ),
                          ),
                        ),

                      // Main button content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.isCompleted
                                ? Icons.check_circle
                                : Icons.touch_app,
                            size: 32, // Reduced from 40
                            color: Colors.white,
                          ),
                          const SizedBox(height: 6), // Reduced from 8
                          Text(
                            widget.isCompleted ? 'Completed' : 'Tap',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14, // Reduced from 18
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      // Bead texture effect
                      Positioned.fill(
                        child: CustomPaint(
                          painter: BeadPainter(
                            primaryColor: themeProvider.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class BeadPainter extends CustomPainter {
  final Color primaryColor;

  BeadPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2; // Now 80 instead of 100
    final paint = Paint()
      ..color = primaryColor.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw bead lines
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (3.14159 / 180);
      final start = Offset(
        center.dx + radius * 0.3 * math.cos(angle),
        center.dy + radius * 0.3 * math.sin(angle),
      );
      final end = Offset(
        center.dx + radius * 0.9 * math.cos(angle),
        center.dy + radius * 0.9 * math.sin(angle),
      );
      canvas.drawLine(start, end, paint);
    }

    // Draw concentric circles
    for (double r = 0.2; r <= 1.0; r += 0.2) {
      canvas.drawCircle(center, radius * r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
