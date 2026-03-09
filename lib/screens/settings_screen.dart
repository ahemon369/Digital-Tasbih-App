import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dhikr.dart';
import '../providers/theme_provider.dart';
import '../services/dhikr_service.dart';
import '../widgets/animated_background.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  DhikrSpeed _autoSpeed = DhikrSpeed.medium;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final speed = await DhikrService.getAutoSpeed();
    setState(() {
      _autoSpeed = speed;
    });
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildThemeSection(themeProvider),
                      const SizedBox(height: 24),
                      _buildAutoTasbihSection(themeProvider),
                      const SizedBox(height: 24),
                      _buildSoundSection(themeProvider),
                      const SizedBox(height: 24),
                      _buildAboutSection(themeProvider),
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
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: themeProvider.primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: themeProvider.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSection(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeProvider.primaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.palette, color: themeProvider.primaryColor, size: 24),
              const SizedBox(width: 12),
              Text(
                'Theme',
                style: TextStyle(
                  color: themeProvider.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildThemeOption('Night Sky Theme', AppTheme.nightSky, themeProvider),
          const SizedBox(height: 12),
          _buildThemeOption('Golden Ramadan Theme', AppTheme.goldenRamadan, themeProvider),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: themeProvider.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: themeProvider.accentColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Toggle Ramadan mode from the home screen for automatic theme switching.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(String title, AppTheme theme, ThemeProvider themeProvider) {
    final isSelected = themeProvider.currentTheme == theme;
    
    return GestureDetector(
      onTap: () => themeProvider.setTheme(theme),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? themeProvider.primaryColor.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? themeProvider.primaryColor : Colors.white.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? themeProvider.primaryColor : Colors.transparent,
                border: Border.all(
                  color: themeProvider.primaryColor,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutoTasbihSection(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeProvider.primaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.autorenew, color: themeProvider.primaryColor, size: 24),
              const SizedBox(width: 12),
              Text(
                'Auto Tasbih Settings',
                style: TextStyle(
                  color: themeProvider.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Default Speed',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildSpeedButton('Slow', DhikrSpeed.slow, themeProvider),
              const SizedBox(width: 8),
              _buildSpeedButton('Medium', DhikrSpeed.medium, themeProvider),
              const SizedBox(width: 8),
              _buildSpeedButton('Fast', DhikrSpeed.fast, themeProvider),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedButton(String label, DhikrSpeed speed, ThemeProvider themeProvider) {
    final isSelected = _autoSpeed == speed;
    
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          setState(() {
            _autoSpeed = speed;
          });
          await DhikrService.setAutoSpeed(speed);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? themeProvider.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: themeProvider.primaryColor,
              width: 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : themeProvider.primaryColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSoundSection(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeProvider.primaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.volume_up, color: themeProvider.primaryColor, size: 24),
              const SizedBox(width: 12),
              Text(
                'Sound & Vibration',
                style: TextStyle(
                  color: themeProvider.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSwitchTile('Sound Effects', _soundEnabled, (value) {
            setState(() {
              _soundEnabled = value;
            });
          }, themeProvider),
          const SizedBox(height: 12),
          _buildSwitchTile('Vibration', _vibrationEnabled, (value) {
            setState(() {
              _vibrationEnabled = value;
            });
          }, themeProvider),
          const SizedBox(height: 12),
          _buildSwitchTile('Notifications', _notificationsEnabled, (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          }, themeProvider),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged, ThemeProvider themeProvider) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: themeProvider.primaryColor,
        ),
      ],
    );
  }

  Widget _buildAboutSection(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeProvider.primaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: themeProvider.primaryColor, size: 24),
              const SizedBox(width: 12),
              Text(
                'About',
                style: TextStyle(
                  color: themeProvider.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Premium Digital Tasbih',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Version 1.0.0',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'A beautiful Islamic dhikr and tasbih mobile app with premium features for spiritual growth.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.favorite, color: themeProvider.accentColor, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Made with love for the Muslim community',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
