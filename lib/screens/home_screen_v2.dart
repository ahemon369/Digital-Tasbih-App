import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dhikr.dart';
import '../providers/theme_provider.dart';
import '../services/dhikr_service.dart';
import '../widgets/tasbih_button_v2.dart';
import '../widgets/dhikr_selector_v2.dart';
import '../widgets/auto_tasbih_controls_v2.dart';
import '../widgets/animated_background_v2.dart';

class HomeScreenV2 extends StatefulWidget {
  const HomeScreenV2({super.key});

  @override
  State<HomeScreenV2> createState() => _HomeScreenV2State();
}

class _HomeScreenV2State extends State<HomeScreenV2> with TickerProviderStateMixin {
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
    final existingCount = counts[_selectedDhikr!.id] ?? 
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
      body: AnimatedBackgroundV2(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(themeProvider),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildDhikrCards(themeProvider),
                      const SizedBox(height: 24),
                      if (_selectedDhikr != null) ...[
                        _buildMainCounter(themeProvider),
                        const SizedBox(height: 24),
                        _buildTasbihButton(themeProvider),
                        const SizedBox(height: 24),
                        _buildAutoControls(themeProvider),
                        const SizedBox(height: 30),
                      ],
                    ],
                  ),
                ),
              ),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ramadan Kareem',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.primaryColor,
                ),
              ),
              Text(
                '✦ Digital Tasbih',
                style: TextStyle(
                  fontSize: 14,
                  color: themeProvider.accentColor,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeProvider.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: themeProvider.primaryColor.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.nightlight_round,
              color: themeProvider.primaryColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDhikrCards(ThemeProvider themeProvider) {
    return SizedBox(
      height: 100,
      child: DhikrSelectorV2(
        selectedDhikr: _selectedDhikr,
        onDhikrSelected: _selectDhikr,
      ),
    );
  }

  Widget _buildMainCounter(ThemeProvider themeProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeProvider.primaryColor.withOpacity(0.8),
            themeProvider.primaryColor.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: themeProvider.primaryColor.withOpacity(0.6),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: themeProvider.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedDhikr?.arabic ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentCount}/${_selectedDhikr?.target ?? 0}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _selectedDhikr?.transliteration ?? '',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedDhikr?.meaning ?? '',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white60,
            ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: _selectedDhikr != null ? _currentCount / _selectedDhikr!.target : 0.0,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildTasbihButton(ThemeProvider themeProvider) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _rotationAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: TasbihButtonV2(
              onPressed: _incrementCount,
              isAutoMode: _isAutoMode,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAutoControls(ThemeProvider themeProvider) {
    return AutoTasbihControlsV2(
      isAutoMode: _isAutoMode,
      onToggleAuto: _toggleAutoMode,
      onIncrement: _incrementCount,
    );
  }
}
