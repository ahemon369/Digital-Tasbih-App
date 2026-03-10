import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/animated_background.dart';

class TumareBolciAmarDewaScreen extends StatefulWidget {
  const TumareBolciAmarDewaScreen({super.key});

  @override
  State<TumareBolciAmarDewaScreen> createState() =>
      _TumareBolciAmarDewaScreenState();
}

class _TumareBolciAmarDewaScreenState extends State<TumareBolciAmarDewaScreen>
    with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _mottoController;
  late Animation<double> _titleAnimation;
  late Animation<double> _mottoAnimation;

  final List<Map<String, dynamic>> _motivationalQuotes = [
    {
      'quote': 'Ramadan is the month of mercy, forgiveness, and salvation.',
      'author': 'Prophet Muhammad (PBUH)',
    },
    {
      'quote':
          'Whoever fasts Ramadan out of faith and hope, seeking reward from Allah, will have his past sins forgiven.',
      'author': 'Prophet Muhammad (PBUH)',
    },
    {
      'quote':
          'The best of deeds are those done continuously, even if they are small.',
      'author': 'Prophet Muhammad (PBUH)',
    },
    {
      'quote': 'When Ramadan comes, the doors of Paradise are opened.',
      'author': 'Prophet Muhammad (PBUH)',
    },
  ];

  int _currentQuoteIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _titleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _mottoController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeInOut),
    );
    _mottoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mottoController, curve: Curves.easeInOut),
    );

    _titleController.forward();
    _mottoController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _mottoController.dispose();
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
                      const SizedBox(height: 40),

                      // Main Title Section
                      _buildMainTitle(themeProvider),
                      const SizedBox(height: 40),

                      // Motto Section
                      _buildMottoSection(themeProvider),
                      const SizedBox(height: 40),

                      // Features Grid
                      _buildFeaturesGrid(themeProvider),
                      const SizedBox(height: 40),

                      // Daily Quote Section
                      _buildDailyQuoteSection(themeProvider),
                      const SizedBox(height: 40),

                      // Action Buttons
                      _buildActionButtons(themeProvider),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              _buildFooter(themeProvider),
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
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: themeProvider.primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tumare Bolci Amar Dewa',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.primaryColor,
                  ),
                ),
                Text(
                  'Ramadan Mubarak',
                  style: TextStyle(
                    fontSize: 14,
                    color: themeProvider.accentColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeProvider.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.favorite,
              color: themeProvider.primaryColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainTitle(ThemeProvider themeProvider) {
    return AnimatedBuilder(
      animation: _titleAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -50 * (1 - _titleAnimation.value)),
          child: Opacity(opacity: _titleAnimation.value, child: child),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
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
              spreadRadius: 3,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.nightlight_round, color: Colors.white, size: 60),
            const SizedBox(height: 16),
            Text(
              'Tumare Bolci Amar Dewa',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: const [
                  Shadow(color: Color.fromRGBO(0, 0, 0, 0.3), blurRadius: 4),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'May your Ramadan be blessed',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMottoSection(ThemeProvider themeProvider) {
    return AnimatedBuilder(
      animation: _mottoAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -30 * (1 - _mottoAnimation.value)),
          child: Opacity(opacity: _mottoAnimation.value, child: child),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: themeProvider.accentColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              '✦ Our Motto ✦',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.accentColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Faith, Hope, and Blessing',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Embracing the spiritual essence of Ramadan through devotion, prayer, and reflection',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesGrid(ThemeProvider themeProvider) {
    final features = [
      {
        'icon': Icons.mosque,
        'title': 'Prayer Times',
        'description': 'Accurate prayer schedules for your location',
      },
      {
        'icon': Icons.book,
        'title': 'Quran Reading',
        'description': 'Daily verses and reflections',
      },
      {
        'icon': Icons.volunteer_activism,
        'title': 'Charity',
        'description': 'Give to those in need',
      },
      {
        'icon': Icons.restaurant_menu,
        'title': 'Iftar Times',
        'description': 'Community breaking fast schedules',
      },
      {
        'icon': Icons.self_improvement,
        'title': 'Self-Reflection',
        'description': 'Personal growth journal',
      },
      {
        'icon': Icons.groups,
        'title': 'Community',
        'description': 'Connect with fellow Muslims',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return _buildFeatureCard(feature, themeProvider);
      },
    );
  }

  Widget _buildFeatureCard(
    Map<String, dynamic> feature,
    ThemeProvider themeProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeProvider.primaryColor.withOpacity(0.8),
            themeProvider.primaryColor.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeProvider.primaryColor.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: themeProvider.primaryColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(feature['icon'] as IconData, color: Colors.white, size: 40),
          const SizedBox(height: 12),
          Text(
            feature['title'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            feature['description'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyQuoteSection(ThemeProvider themeProvider) {
    final currentQuote = _motivationalQuotes[_currentQuoteIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeProvider.accentColor.withOpacity(0.8),
            themeProvider.accentColor.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeProvider.accentColor.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: themeProvider.accentColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.format_quote, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Daily Wisdom',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _currentQuoteIndex =
                        (_currentQuoteIndex + 1) % _motivationalQuotes.length;
                  });
                },
                icon: const Icon(Icons.refresh, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '"${currentQuote['quote']}"',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '— ${currentQuote['author']}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          'Start Dhikr',
          Icons.play_arrow,
          themeProvider.primaryColor,
          () => Navigator.pushReplacementNamed(context, '/'),
        ),
        _buildActionButton(
          'Settings',
          Icons.settings,
          themeProvider.accentColor,
          () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String title,
    IconData iconData,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(25),
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(iconData, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'تُمَارَك بَارَك رَمَضَان',
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
