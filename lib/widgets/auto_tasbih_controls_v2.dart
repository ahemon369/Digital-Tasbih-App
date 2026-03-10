import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dhikr.dart';
import '../providers/theme_provider.dart';
import '../services/dhikr_service.dart';

class AutoTasbihControlsV2 extends StatefulWidget {
  final bool isAutoMode;
  final VoidCallback onToggleAuto;
  final VoidCallback onIncrement;

  const AutoTasbihControlsV2({
    super.key,
    required this.isAutoMode,
    required this.onToggleAuto,
    required this.onIncrement,
  });

  @override
  State<AutoTasbihControlsV2> createState() => _AutoTasbihControlsV2State();
}

class _AutoTasbihControlsV2State extends State<AutoTasbihControlsV2>
    with TickerProviderStateMixin {
  DhikrSpeed _currentSpeed = DhikrSpeed.medium;
  Timer? _autoTimer;
  bool _isPaused = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _loadAutoSpeed();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _stopAutoMode();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadAutoSpeed() async {
    final speed = await DhikrService.getAutoSpeed();
    setState(() {
      _currentSpeed = speed;
    });
  }

  Duration _getSpeedDuration() {
    switch (_currentSpeed) {
      case DhikrSpeed.slow:
        return const Duration(seconds: 2);
      case DhikrSpeed.medium:
        return const Duration(seconds: 1);
      case DhikrSpeed.fast:
        return const Duration(milliseconds: 500);
    }
  }

  void _startAutoMode() {
    if (_autoTimer != null) return;

    _autoTimer = Timer.periodic(_getSpeedDuration(), (timer) {
      if (!_isPaused) {
        widget.onIncrement();
      }
    });
  }

  void _stopAutoMode() {
    _autoTimer?.cancel();
    _autoTimer = null;
    setState(() {
      _isPaused = false;
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _setSpeed(DhikrSpeed speed) async {
    setState(() {
      _currentSpeed = speed;
    });
    await DhikrService.setAutoSpeed(speed);

    // Restart timer with new speed if in auto mode
    if (widget.isAutoMode) {
      _stopAutoMode();
      _startAutoMode();
    }
  }

  @override
  void didUpdateWidget(AutoTasbihControlsV2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAutoMode != oldWidget.isAutoMode) {
      if (widget.isAutoMode) {
        _startAutoMode();
      } else {
        _stopAutoMode();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: themeProvider.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Auto Mode Toggle Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: widget.isAutoMode ? _pulseAnimation.value : 1.0,
                        child: Icon(
                          Icons.autorenew,
                          color: themeProvider.primaryColor,
                          size: 24,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Auto Tasbih Mode',
                    style: TextStyle(
                      color: themeProvider.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: themeProvider.primaryColor.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (widget.isAutoMode) {
                          widget.onToggleAuto();
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: !widget.isAutoMode
                              ? themeProvider.primaryColor
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(28),
                            bottomLeft: Radius.circular(28),
                          ),
                        ),
                        child: Text(
                          'OFF',
                          style: TextStyle(
                            color: !widget.isAutoMode
                                ? Colors.white
                                : themeProvider.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!widget.isAutoMode) {
                          widget.onToggleAuto();
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: widget.isAutoMode
                              ? themeProvider.primaryColor
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(28),
                            bottomRight: Radius.circular(28),
                          ),
                        ),
                        child: Text(
                          'ON',
                          style: TextStyle(
                            color: widget.isAutoMode
                                ? Colors.white
                                : themeProvider.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (widget.isAutoMode) ...[
            const SizedBox(height: 20),

            // Speed Controls
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Speed Control',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSpeedButton('Slow', DhikrSpeed.slow, themeProvider),
                    _buildSpeedButton(
                      'Medium',
                      DhikrSpeed.medium,
                      themeProvider,
                    ),
                    _buildSpeedButton('Fast', DhikrSpeed.fast, themeProvider),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Pause/Resume Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _togglePause,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    _isPaused ? Icons.play_arrow : Icons.pause,
                    key: ValueKey(_isPaused),
                    color: Colors.white,
                  ),
                ),
                label: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _isPaused ? 'Resume' : 'Pause',
                    key: ValueKey(_isPaused),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeProvider.accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpeedButton(
    String label,
    DhikrSpeed speed,
    ThemeProvider themeProvider,
  ) {
    final isSelected = _currentSpeed == speed;

    return GestureDetector(
      onTap: () => _setSpeed(speed),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? themeProvider.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: themeProvider.primaryColor, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              speed == DhikrSpeed.slow
                  ? Icons.hourglass_bottom
                  : speed == DhikrSpeed.fast
                  ? Icons.flash_on
                  : Icons.speed,
              size: 16,
              color: isSelected ? Colors.white : themeProvider.primaryColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : themeProvider.primaryColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
