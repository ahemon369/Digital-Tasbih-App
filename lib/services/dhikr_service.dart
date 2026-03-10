import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/dhikr.dart';

class DhikrService {
  static const String _dhikrCountsKey = 'dhikr_counts';
  static const String _themeKey = 'app_theme';
  static const String _autoSpeedKey = 'auto_speed';
  static const String _ramadanStatsKey = 'ramadan_stats';
  static const String _totalDhikrCountKey = 'total_dhikr_count';

  static final List<Dhikr> _dhikrs = [
    Dhikr(
      id: 'subhanallah',
      arabic: 'سُبْحَانَ اللَّهِ',
      transliteration: 'Subhanallah',
      meaning: 'Glory be to Allah',
      target: 33,
      category: 'tasbih',
    ),
    Dhikr(
      id: 'alhamdulillah',
      arabic: 'الْحَمْدُ لِلَّهِ',
      transliteration: 'Alhamdulillah',
      meaning: 'Praise be to Allah',
      target: 33,
      category: 'tasbih',
    ),
    Dhikr(
      id: 'allahu_akbar',
      arabic: 'اللَّهُ أَكْبَرُ',
      transliteration: 'Allahu Akbar',
      meaning: 'Allah is the Greatest',
      target: 34,
      category: 'tasbih',
    ),
    Dhikr(
      id: 'la_ilaha_illallah',
      arabic: 'لَا إِلَٰهَ إِلَّا اللَّهُ',
      transliteration: 'La ilaha illallah',
      meaning: 'There is no god but Allah',
      target: 100,
      category: 'tahlil',
    ),
    Dhikr(
      id: 'astaghfirullah',
      arabic: 'أَسْتَغْفِرُ اللَّهَ',
      transliteration: 'Astaghfirullah',
      meaning: 'I seek forgiveness from Allah',
      target: 100,
      category: 'istighfar',
    ),
    Dhikr(
      id: 'dorud_sharif',
      arabic: 'صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ',
      transliteration: 'Dorud Sharif',
      meaning: 'Peace and blessings be upon him',
      target: 100,
      category: 'dorud',
    ),
  ];

  static final List<AllahName> _allahNames = [
    for (int i = 1; i <= 99; i++)
      AllahName(
        number: i,
        arabic: 'اسم $i',
        transliteration: 'Name $i',
        meaning: 'Meaning $i',
      ),
  ];

  static List<Dhikr> getDhikrs() => _dhikrs;
  static List<AllahName> getAllahNames() => _allahNames;

  static Future<Map<String, DhikrCount>> getDhikrCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final countsJson = prefs.getString(_dhikrCountsKey);
    if (countsJson != null) {
      final Map<String, dynamic> data = json.decode(countsJson);
      return data.map(
        (key, value) => MapEntry(key, DhikrCount.fromJson(value)),
      );
    }
    return {};
  }

  static Future<void> saveDhikrCounts(Map<String, DhikrCount> counts) async {
    final prefs = await SharedPreferences.getInstance();
    final data = counts.map((key, value) => MapEntry(key, value.toJson()));
    await prefs.setString(_dhikrCountsKey, json.encode(data));
  }

  static Future<AppTheme> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    return AppTheme.values[themeIndex];
  }

  static Future<void> setTheme(AppTheme theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, theme.index);
  }

  static Future<DhikrSpeed> getAutoSpeed() async {
    final prefs = await SharedPreferences.getInstance();
    final speedIndex = prefs.getInt(_autoSpeedKey) ?? 1;
    return DhikrSpeed.values[speedIndex];
  }

  static Future<void> setAutoSpeed(DhikrSpeed speed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_autoSpeedKey, speed.index);
  }

  static Future<Map<String, dynamic>> getRamadanStats() async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString(_ramadanStatsKey);
    if (statsJson != null) return json.decode(statsJson);
    return {'ramadanDay': 1, 'totalDhikr': 0, 'dailyStats': <String, int>{}};
  }

  static Future<void> saveRamadanStats(Map<String, dynamic> stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ramadanStatsKey, json.encode(stats));
  }

  static Future<void> saveTotalDhikrCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_totalDhikrCountKey, count);
  }

  static Future<int> getTotalDhikrCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalDhikrCountKey) ?? 0;
  }

  static Future<int> getTodayDhikrCount() async {
    final counts = await getDhikrCounts();
    final today = DateTime.now();
    int total = 0;
    for (var count in counts.values) {
      if (count.lastUpdated.year == today.year &&
          count.lastUpdated.month == today.month &&
          count.lastUpdated.day == today.day) {
        total += count.count;
      }
    }
    return total;
  }

  static Future<int> getWeekDhikrCount() async {
    final counts = await getDhikrCounts();
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    int total = 0;
    for (var count in counts.values) {
      if (count.lastUpdated.isAfter(weekAgo)) total += count.count;
    }
    return total;
  }

  static Future<int> getMonthDhikrCount() async {
    final counts = await getDhikrCounts();
    final now = DateTime.now();
    final monthAgo = now.subtract(const Duration(days: 30));
    int total = 0;
    for (var count in counts.values) {
      if (count.lastUpdated.isAfter(monthAgo)) total += count.count;
    }
    return total;
  }
}
