import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math' as math;
import '../providers/theme_provider.dart';

class TasbihButtonV2 extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isAutoMode;

  const TasbihButtonV2({
    super.key,
    required this.onPressed,
    this.isAutoMode = false,
  });

  @override
  State<TasbihButtonV2> createState() => _TasbihButtonV2State();
}

class _TasbihButtonV2State extends State<TasbihButtonV2>
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return GestureDetector(
      onTap: widget.isAutoMode ? null : _onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _rippleAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(-0.3, -0.3),
                  radius: 0.8,
                  colors: [
                    themeProvider.primaryColor.withOpacity(0.9),
                    themeProvider.primaryColor.withOpacity(0.7),
                    themeProvider.primaryColor.withOpacity(0.5),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: themeProvider.primaryColor.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: themeProvider.accentColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Ripple effect
                  if (_rippleAnimation.value > 0)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: themeProvider.primaryColor.withOpacity(
                              0.3 * (1 - _rippleAnimation.value),
                            ),
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  
                  // Bead texture pattern
                  Positioned.fill(
                    child: CustomPaint(
                      painter: BeadPatternPainter(
                        primaryColor: themeProvider.primaryColor,
                        accentColor: themeProvider.accentColor,
                      ),
                    ),
                  ),
                  
                  // Inner circle
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          themeProvider.primaryColor.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  
                  // Main button content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.isAutoMode ? Icons.autorenew : Icons.touch_app,
                        size: 40,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.isAutoMode ? 'AUTO' : 'TAP',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BeadPatternPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;

  BeadPatternPainter({required this.primaryColor, required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Bead lines
    final linePaint = Paint()
      ..color = primaryColor.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw radial bead pattern
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * (math.pi / 180);
      final start = Offset(
        center.dx + radius * 0.3 * math.cos(angle),
        center.dy + radius * 0.3 * math.sin(angle),
      );
      final end = Offset(
        center.dx + radius * 0.9 * math.cos(angle),
        center.dy + radius * 0.9 * math.sin(angle),
      );
      canvas.drawLine(start, end, linePaint);
    }

    // Concentric circles
    for (double r = 0.2; r <= 1.0; r += 0.2) {
      canvas.drawCircle(
        center,
        radius * r,
        linePaint,
      );
    }

    // Decorative dots
    final dotPaint = Paint()
      ..color = accentColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (math.pi / 180);
      final dotPos = Offset(
        center.dx + radius * 0.6 * math.cos(angle),
        center.dy + radius * 0.6 * math.sin(angle),
      );
      canvas.drawCircle(dotPos, 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
