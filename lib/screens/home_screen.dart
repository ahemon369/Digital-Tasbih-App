import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dhikr.dart';
import '../providers/theme_provider.dart';
import '../services/dhikr_service.dart';
import '../widgets/tasbih_button.dart';
import '../widgets/dhikr_selector.dart';
import '../widgets/auto_tasbih_controls.dart';
import '../widgets/animated_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Dhikr? _selectedDhikr;
  int _currentCount = 0;
  bool _isAutoMode = false;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );
    _initializeDhikr();
  }

  Future<void> _initializeDhikr() async {
    final dhikrs = DhikrService.getDhikrs();
    if (dhikrs.isNotEmpty) {
      setState(() {
        _selectedDhikr = dhikrs.first;
      });
      await _loadDhikrCount();
    }
  }

  Future<void> _loadDhikrCount() async {
    if (_selectedDhikr == null) return;
    final counts = await DhikrService.getDhikrCounts();
    final count = counts[_selectedDhikr!.id];
    if (count != null) {
      setState(() {
        _currentCount = count.count;
      });
    }
  }

  Future<void> _incrementCount() async {
    if (_selectedDhikr == null) return;

    setState(() {
      _currentCount++;
    });

    _pulseController.forward().then((_) => _pulseController.reverse());
    _rotationController.forward().then((_) => _rotationController.reverse());

    final counts = await DhikrService.getDhikrCounts();
    final existingCount =
        counts[_selectedDhikr!.id] ??
        DhikrCount(dhikrId: _selectedDhikr!.id, lastUpdated: DateTime.now());

    existingCount.count = _currentCount;
    existingCount.totalCount++;
    existingCount.lastUpdated = DateTime.now();

    counts[_selectedDhikr!.id] = existingCount;
    await DhikrService.saveDhikrCounts(counts);

    if (_currentCount >= _selectedDhikr!.target) {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('MashaAllah! 🎉'),
        content: Text('You have completed ${_selectedDhikr!.transliteration}!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetCount();
            },
            child: Text('Reset'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _resetCount() {
    setState(() {
      _currentCount = 0;
    });
  }

  void _selectDhikr(Dhikr dhikr) {
    setState(() {
      _selectedDhikr = dhikr;
      _currentCount = 0;
    });
    _loadDhikrCount();
  }

  void _toggleAutoMode() {
    setState(() {
      _isAutoMode = !_isAutoMode;
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DhikrSelector(
                        selectedDhikr: _selectedDhikr,
                        onDhikrSelected: _selectDhikr,
                      ),
                      const SizedBox(height: 40),
                      if (_selectedDhikr != null) ...[
                        _buildProgressIndicator(),
                        const SizedBox(height: 40),
                        AnimatedBuilder(
                          animation: Listenable.merge([
                            _pulseAnimation,
                            _rotationAnimation,
                          ]),
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Transform.rotate(
                                angle: _rotationAnimation.value,
                                child: TasbihButton(
                                  onPressed: _incrementCount,
                                  isAutoMode: _isAutoMode,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                        _buildCountDisplay(),
                        const SizedBox(height: 20),
                        AutoTasbihControls(
                          isAutoMode: _isAutoMode,
                          onToggleAuto: _toggleAutoMode,
                          onIncrement: _incrementCount,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Ramadan Kareem ✦',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: themeProvider.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () => themeProvider.toggleRamadanMode(),
            icon: Icon(
              themeProvider.isRamadanMode ? Icons.nights_stay : Icons.wb_sunny,
              color: themeProvider.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    if (_selectedDhikr == null) return const SizedBox.shrink();

    final progress = _currentCount / _selectedDhikr!.target;

    return Column(
      children: [
        Text(
          '${_currentCount} / ${_selectedDhikr!.target}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation<Color>(
            Provider.of<ThemeProvider>(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCountDisplay() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Provider.of<ThemeProvider>(
            context,
          ).primaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            '$_currentCount',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedDhikr?.transliteration ?? '',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'رَمَضَان مُبَارَك',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Provider.of<ThemeProvider>(context).accentColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
