// ════════════════════════════════════════════════════════════════════════════
// MORNING PAGES SERVICE - Timed free-writing session tracking
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MorningPageSession {
  final String dateKey; // yyyy-MM-dd
  final int durationMinutes;
  final int wordCount;
  final DateTime completedAt;

  const MorningPageSession({
    required this.dateKey,
    required this.durationMinutes,
    required this.wordCount,
    required this.completedAt,
  });

  Map<String, dynamic> toJson() => {
        'dateKey': dateKey,
        'durationMinutes': durationMinutes,
        'wordCount': wordCount,
        'completedAt': completedAt.toIso8601String(),
      };

  factory MorningPageSession.fromJson(Map<String, dynamic> json) {
    return MorningPageSession(
      dateKey: json['dateKey'] as String,
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      wordCount: json['wordCount'] as int? ?? 0,
      completedAt: DateTime.parse(json['completedAt'] as String),
    );
  }
}

class MorningPagesService {
  static const _storageKey = 'morning_pages_sessions_v1';
  final SharedPreferences _prefs;
  List<MorningPageSession> _sessions = [];

  MorningPagesService._(this._prefs) {
    _load();
  }

  static Future<MorningPagesService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return MorningPagesService._(prefs);
  }

  void _load() {
    final raw = _prefs.getStringList(_storageKey) ?? [];
    _sessions = raw
        .map((s) {
          try {
            return MorningPageSession.fromJson(
                json.decode(s) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<MorningPageSession>()
        .toList()
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
  }

  Future<void> _persist() async {
    final raw = _sessions.map((s) => json.encode(s.toJson())).toList();
    await _prefs.setStringList(_storageKey, raw);
  }

  Future<void> logSession({
    required int durationMinutes,
    required int wordCount,
  }) async {
    final now = DateTime.now();
    final dateKey =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final session = MorningPageSession(
      dateKey: dateKey,
      durationMinutes: durationMinutes,
      wordCount: wordCount,
      completedAt: now,
    );
    _sessions.insert(0, session);
    await _persist();
  }

  bool get hasSessionToday {
    final now = DateTime.now();
    final todayKey =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return _sessions.any((s) => s.dateKey == todayKey);
  }

  int get totalSessions => _sessions.length;

  int get totalWords =>
      _sessions.fold(0, (sum, s) => sum + s.wordCount);

  int get currentStreak {
    if (_sessions.isEmpty) return 0;
    int streak = 0;
    final now = DateTime.now();
    for (int i = 0; i < 365; i++) {
      final day = now.subtract(Duration(days: i));
      final key =
          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      if (_sessions.any((s) => s.dateKey == key)) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  List<MorningPageSession> getRecent({int limit = 7}) {
    return _sessions.take(limit).toList();
  }

  /// Average word count per session
  double get avgWordCount {
    if (_sessions.isEmpty) return 0;
    return _sessions.map((s) => s.wordCount).reduce((a, b) => a + b) /
        _sessions.length;
  }
}
