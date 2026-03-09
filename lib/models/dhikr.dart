class Dhikr {
  final String id;
  final String arabic;
  final String transliteration;
  final String meaning;
  final int target;
  final String category;

  Dhikr({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    required this.target,
    required this.category,
  });
}

class DhikrCount {
  final String dhikrId;
  int count;
  DateTime lastUpdated;
  int totalCount;

  DhikrCount({
    required this.dhikrId,
    this.count = 0,
    required this.lastUpdated,
    this.totalCount = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'dhikrId': dhikrId,
      'count': count,
      'lastUpdated': lastUpdated.toIso8601String(),
      'totalCount': totalCount,
    };
  }

  factory DhikrCount.fromJson(Map<String, dynamic> json) {
    return DhikrCount(
      dhikrId: json['dhikrId'],
      count: json['count'] ?? 0,
      lastUpdated: DateTime.parse(json['lastUpdated']),
      totalCount: json['totalCount'] ?? 0,
    );
  }
}

class AllahName {
  final int number;
  final String arabic;
  final String transliteration;
  final String meaning;

  AllahName({
    required this.number,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
  });
}

enum DhikrSpeed { slow, medium, fast }

enum AppTheme { nightSky, goldenRamadan }
