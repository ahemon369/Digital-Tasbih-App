import 'package:flutter/material.dart';
import '../widgets/animated_background.dart';

class HomeScreenModern extends StatefulWidget {
  const HomeScreenModern({super.key});

  @override
  State<HomeScreenModern> createState() => _HomeScreenModernState();
}

class _HomeScreenModernState extends State<HomeScreenModern>
    with TickerProviderStateMixin {
  int _selectedTab = 0;
  bool _isDarkTheme = true;
  bool _hapticEnabled = true;

  late AnimationController _starController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _starController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _starController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  void _navigateToScreen(int index) {
    switch (index) {
      case 0: // Counter
        Navigator.pushNamed(context, '/digital_tasbih');
        break;
      case 1: // Dhikr
        Navigator.pushNamed(context, '/allah_names');
        break;
      case 2: // Stats
        Navigator.pushNamed(context, '/dhikr_statistics');
        break;
      case 3: // Settings
        Navigator.pushNamed(context, '/settings');
        break;
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildMainTitle(),
                    const SizedBox(height: 30),
                    _buildFeatureGrid(),
                    const SizedBox(height: 30),
                    _buildAppearanceSection(),
                    const SizedBox(height: 30),
                    _buildPremiumCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _buildBottomNavigationBar(),
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
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          ),
          const Spacer(),
          Text(
            'More Features',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const Icon(Icons.more_vert, color: Colors.white, size: 24),
        ],
      ),
    );
  }

  Widget _buildMainTitle() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Text(
        'ENHANCE YOUR DHIKR',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
        ),
      ),
    );
  }

  Widget _buildFeatureGrid() {
    final features = [
      {
        'title': 'Auto Tasbih',
        'subtitle': 'Hands-free mode',
        'icon': Icons.play_arrow,
        'color': Colors.orange,
      },
      {
        'title': '99 Names',
        'subtitle': 'Divine Attributes',
        'icon': Icons.book,
        'color': Colors.orange,
      },
      {
        'title': 'Dhikr Stats',
        'subtitle': 'Daily progress',
        'icon': Icons.bar_chart,
        'color': Colors.orange,
      },
      {
        'title': 'Ramadan',
        'subtitle': 'Days to Eid',
        'icon': Icons.nightlight_round,
        'color': Colors.orange,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.4,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return _buildFeatureCard(feature);
      },
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> feature) {
    return GestureDetector(
      onTap: () {
        switch (feature['title']) {
          case 'Auto Tasbih':
            Navigator.pushNamed(context, '/auto_tasbih');
            break;
          case '99 Names':
            Navigator.pushNamed(context, '/allah_names');
            break;
          case 'Dhikr Stats':
            Navigator.pushNamed(context, '/dhikr_statistics');
            break;
          case 'Ramadan':
            Navigator.pushNamed(context, '/ramadan_counter');
            break;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: feature['color'] as Color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                feature['icon'] as IconData,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              feature['title'] as String,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              feature['subtitle'] as String,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'APPEARANCE',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 20),

          // Theme Switch
          Row(
            children: [
              const Icon(Icons.palette, color: Colors.white70, size: 20),
              const SizedBox(width: 12),
              const Text(
                'Theme Switch',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _isDarkTheme = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _isDarkTheme
                              ? Colors.white.withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Dark',
                          style: TextStyle(
                            color: _isDarkTheme ? Colors.white : Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _isDarkTheme = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: !_isDarkTheme
                              ? Colors.white.withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Gold',
                          style: TextStyle(
                            color: !_isDarkTheme
                                ? Colors.white
                                : Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Haptic Feedback Toggle
          Row(
            children: [
              const Icon(Icons.vibration, color: Colors.white70, size: 20),
              const SizedBox(width: 12),
              const Text(
                'Haptic Feedback',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const Spacer(),
              Switch(
                value: _hapticEnabled,
                onChanged: (value) => setState(() => _hapticEnabled = value),
                activeColor: Colors.orange,
                inactiveTrackColor: Colors.white.withOpacity(0.3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.withOpacity(0.8),
            Colors.orange.withOpacity(0.6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.diamond, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'Premium Collection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Unlock exclusive Tasbih themes and audio recitations.',
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // Handle upgrade
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Text(
                    'Upgrade Now',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    final tabs = [
      {'icon': Icons.touch_app, 'label': 'Counter'},
      {'icon': Icons.favorite, 'label': 'Dhikr'},
      {'icon': Icons.bar_chart, 'label': 'Stats'},
      {'icon': Icons.settings, 'label': 'Settings'},
    ];

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isActive = index == _selectedTab;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedTab = index);
                _navigateToScreen(index);
              },
              child: Container(
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: isActive ? Colors.orange : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tab['icon'] as IconData,
                      color: isActive ? Colors.white : Colors.white70,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tab['label'] as String,
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.white70,
                        fontSize: 12,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
