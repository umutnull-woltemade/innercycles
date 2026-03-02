// ════════════════════════════════════════════════════════════════════════════
// VALUES SERVICE - Personal values identification and tracking
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalValue {
  final String key;
  final String nameEn;
  final String nameTr;
  final String descEn;
  final String descTr;
  final IconData icon;
  final Color color;

  const PersonalValue({
    required this.key,
    required this.nameEn,
    required this.nameTr,
    required this.descEn,
    required this.descTr,
    required this.icon,
    required this.color,
  });

  String name(bool isEn) => isEn ? nameEn : nameTr;
  String desc(bool isEn) => isEn ? descEn : descTr;
}

class ValuesService {
  static const String _storageKey = 'inner_cycles_values';

  final SharedPreferences _prefs;
  List<String> _topValues = []; // ordered list of value keys
  DateTime? _completedAt;

  ValuesService._(this._prefs) {
    _load();
  }

  static Future<ValuesService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return ValuesService._(prefs);
  }

  /// All 12 values
  static const allValues = [
    PersonalValue(
      key: 'autonomy', nameEn: 'Autonomy', nameTr: 'Özerklik',
      descEn: 'Freedom to make your own choices', descTr: 'Kendi kararlarını verme özgürlüğü',
      icon: Icons.flight_takeoff_rounded, color: Color(0xFFC8553D),
    ),
    PersonalValue(
      key: 'connection', nameEn: 'Connection', nameTr: 'Bağlantı',
      descEn: 'Deep bonds with people you care about', descTr: 'Önemsediğin insanlarla derin bağlar',
      icon: Icons.favorite_rounded, color: Color(0xFFB5727A),
    ),
    PersonalValue(
      key: 'creativity', nameEn: 'Creativity', nameTr: 'Yaratıcılık',
      descEn: 'Expressing yourself through creation', descTr: 'Yaratarak kendini ifade etme',
      icon: Icons.palette_rounded, color: Color(0xFF9B8EC4),
    ),
    PersonalValue(
      key: 'growth', nameEn: 'Growth', nameTr: 'Gelişim',
      descEn: 'Continuously learning and evolving', descTr: 'Sürekli öğrenme ve gelişme',
      icon: Icons.trending_up_rounded, color: Color(0xFF7EB8A8),
    ),
    PersonalValue(
      key: 'honesty', nameEn: 'Honesty', nameTr: 'Dürüstlük',
      descEn: 'Living authentically and truthfully', descTr: 'Özgün ve dürüst yaşama',
      icon: Icons.visibility_rounded, color: Color(0xFF6B8FB5),
    ),
    PersonalValue(
      key: 'adventure', nameEn: 'Adventure', nameTr: 'Macera',
      descEn: 'Seeking new experiences and challenges', descTr: 'Yeni deneyimler ve zorluklar arama',
      icon: Icons.explore_rounded, color: Color(0xFFD4704A),
    ),
    PersonalValue(
      key: 'calm', nameEn: 'Calm', nameTr: 'Huzur',
      descEn: 'Inner peace and emotional balance', descTr: 'İç huzur ve duygusal denge',
      icon: Icons.spa_rounded, color: Color(0xFFD4A07A),
    ),
    PersonalValue(
      key: 'achievement', nameEn: 'Achievement', nameTr: 'Başarı',
      descEn: 'Setting and reaching meaningful goals', descTr: 'Anlamlı hedefler belirleyip ulaşma',
      icon: Icons.emoji_events_rounded, color: Color(0xFFC8553D),
    ),
    PersonalValue(
      key: 'family', nameEn: 'Family', nameTr: 'Aile',
      descEn: 'Nurturing family bonds and traditions', descTr: 'Aile bağlarını ve gelenekleri besleme',
      icon: Icons.home_rounded, color: Color(0xFF8B6F5E),
    ),
    PersonalValue(
      key: 'justice', nameEn: 'Justice', nameTr: 'Adalet',
      descEn: 'Standing up for fairness and equality', descTr: 'Adalet ve eşitlik için mücadele',
      icon: Icons.balance_rounded, color: Color(0xFF6B8FB5),
    ),
    PersonalValue(
      key: 'play', nameEn: 'Play', nameTr: 'Eğlence',
      descEn: 'Finding joy and lightness in life', descTr: 'Hayatta neşe ve hafiflik bulma',
      icon: Icons.celebration_rounded, color: Color(0xFFD4704A),
    ),
    PersonalValue(
      key: 'security', nameEn: 'Security', nameTr: 'Güvenlik',
      descEn: 'Stability and safety for yourself and loved ones', descTr: 'Kendin ve sevdiklerin için istikrar ve güvenlik',
      icon: Icons.shield_rounded, color: Color(0xFF7EB8A8),
    ),
  ];

  /// Save ranked top 5 values
  Future<void> saveTopValues(List<String> valueKeys) async {
    _topValues = valueKeys.take(5).toList();
    _completedAt = DateTime.now();
    await _persist();
  }

  /// Get user's top values (ordered)
  List<PersonalValue> getTopValues() {
    return _topValues
        .map((key) => allValues.firstWhere((v) => v.key == key,
            orElse: () => allValues.first))
        .toList();
  }

  /// Whether the user has completed the values exercise
  bool get hasCompleted => _topValues.isNotEmpty;

  /// Get value of the week (rotates through top values)
  PersonalValue? getValueOfWeek() {
    if (_topValues.isEmpty) return null;
    final weekOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays ~/ 7;
    return getTopValues()[weekOfYear % _topValues.length];
  }

  /// Get all value keys
  List<String> get topValueKeys => List.from(_topValues);

  void _load() {
    final json = _prefs.getString(_storageKey);
    if (json != null) {
      try {
        final map = jsonDecode(json) as Map<String, dynamic>;
        _topValues = (map['topValues'] as List?)?.cast<String>() ?? [];
        _completedAt = map['completedAt'] != null
            ? DateTime.parse(map['completedAt'] as String)
            : null;
      } catch (_) {
        _topValues = [];
      }
    }
  }

  Future<void> _persist() async {
    await _prefs.setString(
      _storageKey,
      jsonEncode({
        'topValues': _topValues,
        'completedAt': _completedAt?.toIso8601String(),
      }),
    );
  }
}
