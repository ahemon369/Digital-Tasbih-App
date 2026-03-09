import 'package:flutter/material.dart';
import '../models/dhikr.dart';
import '../services/dhikr_service.dart';

class ThemeProvider extends ChangeNotifier {
  AppTheme _currentTheme = AppTheme.nightSky;
  bool _isRamadanMode = false;

  AppTheme get currentTheme => _currentTheme;
  bool get isRamadanMode => _isRamadanMode;

  ThemeData get themeData {
    switch (_currentTheme) {
      case AppTheme.nightSky:
        return _nightSkyTheme;
      case AppTheme.goldenRamadan:
        return _goldenRamadanTheme;
    }
  }

  static final ThemeData _nightSkyTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: const Color(0xFF0F1B2D),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF4A90E2),
      secondary: Color(0xFFD4AF37),
      surface: Color(0xFF1A2D4A),
      background: Color(0xFF0D2235),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onBackground: Colors.white,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
      bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4A90E2),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1A2D4A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
    ),
  );

  static final ThemeData _goldenRamadanTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.amber,
    scaffoldBackgroundColor: const Color(0xFF1A1A00),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFD4AF37),
      secondary: Color(0xFF8B4513),
      surface: Color(0xFF2D2D00),
      background: Color(0xFF0D0D00),
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Color(0xFFD4AF37),
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFFD4AF37),
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
      bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD4AF37),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF2D2D00),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
    ),
  );

  Future<void> setTheme(AppTheme theme) async {
    _currentTheme = theme;
    await DhikrService.setTheme(theme);
    notifyListeners();
  }

  Future<void> toggleRamadanMode() async {
    _isRamadanMode = !_isRamadanMode;
    if (_isRamadanMode) {
      _currentTheme = AppTheme.goldenRamadan;
    } else {
      _currentTheme = AppTheme.nightSky;
    }
    await DhikrService.setTheme(_currentTheme);
    notifyListeners();
  }

  Future<void> loadTheme() async {
    _currentTheme = await DhikrService.getTheme();
    notifyListeners();
  }

  Gradient get backgroundGradient {
    switch (_currentTheme) {
      case AppTheme.nightSky:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0F1B2D), Color(0xFF1A2D4A), Color(0xFF0D2235)],
        );
      case AppTheme.goldenRamadan:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A1A00), Color(0xFF2D2D00), Color(0xFF0D0D00)],
        );
    }
  }

  Color get primaryColor {
    switch (_currentTheme) {
      case AppTheme.nightSky:
        return const Color(0xFF4A90E2);
      case AppTheme.goldenRamadan:
        return const Color(0xFFD4AF37);
    }
  }

  Color get accentColor {
    switch (_currentTheme) {
      case AppTheme.nightSky:
        return const Color(0xFFD4AF37);
      case AppTheme.goldenRamadan:
        return const Color(0xFF8B4513);
    }
  }
}
