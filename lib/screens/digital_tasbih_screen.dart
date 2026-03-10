import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../models/dhikr.dart';
import '../providers/theme_provider.dart';
import '../services/dhikr_service.dart';
import '../widgets/animated_background.dart';
import '../widgets/glassmorphism_card.dart';
import '../widgets/circular_counter.dart';
import '../widgets/tasbih_button.dart';
import '../widgets/dhikr_selector_pills.dart';
import '../widgets/navigation_drawer.dart';

class DigitalTasbihScreen extends StatefulWidget {
  const DigitalTasbihScreen({super.key});

  @override
  State<DigitalTasbihScreen> createState() => _DigitalTasbihScreenState();
}

class _DigitalTasbihScreenState extends State<DigitalTasbihScreen>
    with TickerProviderStateMixin {
  Dhikr? _selectedDhikr;
  int _currentCount = 0;
  int _totalCount = 0;
  bool _isCompleted = false;
  bool _showSparkles = false;

  late AnimationController _sparkleController;
  late AnimationController _glowController;
  late AnimationController _pulseController;
  late Animation<double> _sparkleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadData();
  }

  void _initializeAnimations() {
    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _sparkleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sparkleController, curve: Curves.easeOut),
    );
    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _loadData() async {
    final dhikrs = DhikrService.getDhikrs();
    if (dhikrs.isNotEmpty) {
      setState(() {
        _selectedDhikr = dhikrs.first;
      });
      await _loadCounts();
    }
  }

  Future<void> _loadCounts() async {
    if (_selectedDhikr == null) return;

    final counts = await DhikrService.getDhikrCounts();
    final count = counts[_selectedDhikr!.id];
    final total = await DhikrService.getTotalDhikrCount();

    setState(() {
      _currentCount = count?.count ?? 0;
      _totalCount = total;
      _isCompleted = _currentCount >= _selectedDhikr!.target;
    });
  }

  Future<void> _incrementCount() async {
    if (_selectedDhikr == null || _isCompleted) return;

    setState(() {
      _currentCount++;
      _totalCount++;
    });

    _pulseController.forward().then((_) => _pulseController.reverse());

    // Save counts
    await _saveCounts();

    // Check if completed
    if (_currentCount >= _selectedDhikr!.target) {
      _showCompletion();
    }
  }

  Future<void> _saveCounts() async {
    if (_selectedDhikr == null) return;

    final counts = await DhikrService.getDhikrCounts();
    final existingCount =
        counts[_selectedDhikr!.id] ??
        DhikrCount(dhikrId: _selectedDhikr!.id, lastUpdated: DateTime.now());

    existingCount.count = _currentCount;
    existingCount.totalCount++;
    existingCount.lastUpdated = DateTime.now();

    counts[_selectedDhikr!.id] = existingCount;
    await DhikrService.saveDhikrCounts(counts);
    await DhikrService.saveTotalDhikrCount(_totalCount);
  }

  void _showCompletion() {
    setState(() {
      _isCompleted = true;
      _showSparkles = true;
    });

    _glowController.repeat(reverse: true);
    _sparkleController.forward().then((_) {
      _sparkleController.reset();
      setState(() {
        _showSparkles = false;
      });
    });

    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Provider.of<ThemeProvider>(
                  context,
                ).primaryColor.withOpacity(0.9),
                Provider.of<ThemeProvider>(
                  context,
                ).primaryColor.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Provider.of<ThemeProvider>(context).accentColor,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star,
                color: Provider.of<ThemeProvider>(context).accentColor,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                'Mashallah! Completed!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'You have completed ${_selectedDhikr?.transliteration}',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _resetCount();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Provider.of<ThemeProvider>(
                        context,
                      ).accentColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Continue'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resetCount() {
    setState(() {
      _currentCount = 0;
      _isCompleted = false;
      _showSparkles = false;
    });
    _glowController.stop();
    _glowController.reset();
    _saveCounts();
  }

  void _selectDhikr(Dhikr dhikr) {
    setState(() {
      _selectedDhikr = dhikr;
      _currentCount = 0;
      _isCompleted = false;
      _showSparkles = false;
    });
    _glowController.stop();
    _glowController.reset();
    _loadCounts();
  }

  @override
  void dispose() {
    _sparkleController.dispose();
    _glowController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(themeProvider),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      DhikrSelectorPills(
                        selectedDhikr: _selectedDhikr,
                        onDhikrSelected: _selectDhikr,
                      ),
                      const SizedBox(height: 30),

                      if (_selectedDhikr != null) ...[
                        GlassmorphismCard(
                          arabicText: _selectedDhikr!.arabic,
                          transliteration: _selectedDhikr!.transliteration,
                          meaning: _selectedDhikr!.meaning,
                          isCompleted: _isCompleted,
                        ),
                        const SizedBox(height: 30),

                        _buildCircularCounter(themeProvider),
                        const SizedBox(height: 30),

                        _buildTasbihButton(themeProvider),
                        const SizedBox(height: 20),

                        _buildActionButtons(themeProvider),
                        const SizedBox(height: 30),
                      ],
                    ],
                  ),
                ),
              ),
              _buildFooter(themeProvider),
            ],
          ),
        ),
      ),
      drawer: const AppNavigationDrawer(),
    );
  }

  Widget _buildHeader(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ramadan Kareem ✦',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: themeProvider.primaryColor,
              shadows: [
                Shadow(
                  color: themeProvider.primaryColor.withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularCounter(ThemeProvider themeProvider) {
    return AnimatedBuilder(
      animation: Listenable.merge([_glowAnimation, _sparkleAnimation]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Glow effect when completed
            if (_isCompleted)
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: themeProvider.accentColor.withOpacity(
                        _glowAnimation.value * 0.8,
                      ),
                      blurRadius: 30 * _glowAnimation.value,
                      spreadRadius: 10 * _glowAnimation.value,
                    ),
                  ],
                ),
              ),

            // Sparkles when completed
            if (_showSparkles)
              ...List.generate(8, (index) {
                final angle = (index * 45) * (math.pi / 180);
                final distance = 120 + (_sparkleAnimation.value * 30);
                return Positioned(
                  left: 100 + distance * math.cos(angle),
                  top: 100 + distance * math.sin(angle),
                  child: Transform.scale(
                    scale: _sparkleAnimation.value,
                    child: Icon(
                      Icons.star,
                      color: themeProvider.accentColor,
                      size: 20,
                    ),
                  ),
                );
              }),

            // Main counter
            CircularCounter(
              current: _currentCount,
              target: _selectedDhikr?.target ?? 0,
              isCompleted: _isCompleted,
            ),
          ],
        );
      },
    );
  }

  Widget _buildTasbihButton(ThemeProvider themeProvider) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: TasbihButton(
            onPressed: _isCompleted ? () {} : _incrementCount,
            isCompleted: _isCompleted,
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: themeProvider.primaryColor.withOpacity(0.3),
            ),
          ),
          child: Column(
            children: [
              IconButton(
                onPressed: _resetCount,
                icon: Icon(Icons.refresh, color: themeProvider.primaryColor),
              ),
              const SizedBox(height: 4),
              Text(
                'Reset',
                style: TextStyle(
                  color: themeProvider.primaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: themeProvider.primaryColor.withOpacity(0.3),
            ),
          ),
          child: Column(
            children: [
              Text(
                '$_totalCount',
                style: TextStyle(
                  color: themeProvider.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Total',
                style: TextStyle(
                  color: themeProvider.primaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'رَمَضَان مُبَارَك',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: themeProvider.accentColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: themeProvider.accentColor.withOpacity(0.5),
              blurRadius: 5,
            ),
          ],
        ),
      ),
    );
  }
}
