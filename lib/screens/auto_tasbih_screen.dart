import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/animated_background.dart';

class AutoTasbihScreen extends StatefulWidget {
  const AutoTasbihScreen({super.key});

  @override
  State<AutoTasbihScreen> createState() => _AutoTasbihScreenState();
}

class _AutoTasbihScreenState extends State<AutoTasbihScreen>
    with TickerProviderStateMixin {
  int _currentCount = 0;
  int _targetCount = 33;
  int _sessionProgress = 0;
  bool _isPlaying = false;
  double _speed = 1.0; // 0.5 = Slow, 1.0 = Medium, 2.0 = Fast
  String _currentDhikr = 'Subhanallah';

  Timer? _autoTimer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<String> _dhikrs = ['Subhanallah', 'Alhamdulillah', 'Allahu Akbar'];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _startAutoTasbih();
    } else {
      _stopAutoTasbih();
    }
  }

  void _startAutoTasbih() {
    final interval = Duration(milliseconds: (1000 / _speed).round());
    _autoTimer = Timer.periodic(interval, (timer) {
      setState(() {
        if (_currentCount < _targetCount) {
          _currentCount++;
          _sessionProgress++;
        } else {
          _stopAutoTasbih();
        }
      });
    });
  }

  void _stopAutoTasbih() {
    _autoTimer?.cancel();
    setState(() {
      _isPlaying = false;
    });
  }

  void _changeDhikr(String dhikr) {
    _stopAutoTasbih();
    setState(() {
      _currentDhikr = dhikr;
      _currentCount = 0;
      _sessionProgress = 0;
      _targetCount = dhikr == 'Allahu Akbar' ? 34 : 33;
    });
  }

  void _changeSpeed(double speed) {
    setState(() {
      _speed = speed;
    });

    if (_isPlaying) {
      _stopAutoTasbih();
      _startAutoTasbih();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBackground(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDhikrSelector(),
                    const SizedBox(height: 30),
                    _buildCircularCounter(),
                    const SizedBox(height: 30),
                    _buildSpeedControl(),
                    const SizedBox(height: 30),
                    _buildPlayPauseButton(),
                    const SizedBox(height: 30),
                    _buildSessionProgress(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Spacer(),
          const Text(
            'Auto Tasbih',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const Icon(Icons.more_vert, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildDhikrSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Dhikr',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: _dhikrs.map((dhikr) {
              final isSelected = dhikr == _currentDhikr;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _changeDhikr(dhikr),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.orange
                          : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.orange
                            : Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      dhikr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularCounter() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withOpacity(0.8),
                  Colors.orange.withOpacity(0.6),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$_currentCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '/ $_targetCount',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpeedControl() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Speed Control',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSpeedOption('Slow', 0.5, Icons.hourglass_bottom),
              const SizedBox(width: 12),
              _buildSpeedOption('Medium', 1.0, Icons.speed),
              const SizedBox(width: 12),
              _buildSpeedOption('Fast', 2.0, Icons.flash_on),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedOption(String label, double speed, IconData icon) {
    final isSelected = _speed == speed;
    return Expanded(
      child: GestureDetector(
        onTap: () => _changeSpeed(speed),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.orange : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.orange : Colors.white.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.white70,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: _isPlaying
              ? [Colors.red.withOpacity(0.8), Colors.red.withOpacity(0.6)]
              : [Colors.green.withOpacity(0.8), Colors.green.withOpacity(0.6)],
        ),
        boxShadow: [
          BoxShadow(
            color: (_isPlaying ? Colors.red : Colors.green).withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(60),
        child: InkWell(
          borderRadius: BorderRadius.circular(60),
          onTap: _togglePlayPause,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
              const SizedBox(height: 4),
              Text(
                _isPlaying ? 'Pause' : 'Play',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionProgress() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Session Progress',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$_sessionProgress dhikrs',
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_currentCount / _targetCount).clamp(0.0, 1.0),
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        ],
      ),
    );
  }
}
