import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dhikr.dart';
import '../providers/theme_provider.dart';
import '../services/dhikr_service.dart';

class AutoTasbihControls extends StatefulWidget {
  final bool isAutoMode;
  final VoidCallback onToggleAuto;
  final VoidCallback onIncrement;

  const AutoTasbihControls({
    super.key,
    required this.isAutoMode,
    required this.onToggleAuto,
    required this.onIncrement,
  });

  @override
  State<AutoTasbihControls> createState() => _AutoTasbihControlsState();
}

class _AutoTasbihControlsState extends State<AutoTasbihControls>
    with TickerProviderStateMixin {
  DhikrSpeed _currentSpeed = DhikrSpeed.medium;
  Timer? _autoTimer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _loadAutoSpeed();
  }

  @override
  void dispose() {
    _stopAutoMode();
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
  void didUpdateWidget(AutoTasbihControls oldWidget) {
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: themeProvider.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          // Auto Mode Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.isAutoMode ? Icons.autorenew : Icons.touch_app,
                color: themeProvider.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                widget.isAutoMode ? 'Auto Mode Active' : 'Manual Mode',
                style: TextStyle(
                  color: themeProvider.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: widget.isAutoMode,
                onChanged: (_) => widget.onToggleAuto(),
                activeColor: themeProvider.primaryColor,
              ),
            ],
          ),

          if (widget.isAutoMode) ...[
            const SizedBox(height: 16),

            // Speed Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSpeedButton('Slow', DhikrSpeed.slow, themeProvider),
                _buildSpeedButton('Medium', DhikrSpeed.medium, themeProvider),
                _buildSpeedButton('Fast', DhikrSpeed.fast, themeProvider),
              ],
            ),

            const SizedBox(height: 16),

            // Pause/Resume Button
            ElevatedButton.icon(
              onPressed: _togglePause,
              icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
              label: Text(_isPaused ? 'Resume' : 'Pause'),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? themeProvider.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: themeProvider.primaryColor, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : themeProvider.primaryColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
