// ════════════════════════════════════════════════════════════════════════════
// GROWTH LETTER SERVICE - Reflective letter persistence
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/growth_letter.dart';

class GrowthLetterService {
  static const _storageKey = 'growth_letters_v1';
  final SharedPreferences _prefs;
  List<GrowthLetter> _letters = [];

  GrowthLetterService._(this._prefs) {
    _load();
  }

  static Future<GrowthLetterService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return GrowthLetterService._(prefs);
  }

  void _load() {
    final raw = _prefs.getStringList(_storageKey) ?? [];
    _letters = raw
        .map((s) {
          try {
            return GrowthLetter.fromJson(
                json.decode(s) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<GrowthLetter>()
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> _persist() async {
    final raw = _letters.map((l) => json.encode(l.toJson())).toList();
    await _prefs.setStringList(_storageKey, raw);
  }

  List<GrowthLetter> getAll() => List.unmodifiable(_letters);

  List<GrowthLetter> getRecent({int limit = 5}) =>
      _letters.take(limit).toList();

  List<GrowthLetter> getByType(LetterType type) =>
      _letters.where((l) => l.letterType == type).toList();

  Future<GrowthLetter> save(GrowthLetter letter) async {
    final idx = _letters.indexWhere((l) => l.id == letter.id);
    if (idx >= 0) {
      _letters[idx] = letter;
    } else {
      _letters.insert(0, letter);
    }
    await _persist();
    return letter;
  }

  Future<void> delete(String id) async {
    _letters.removeWhere((l) => l.id == id);
    await _persist();
  }

  int get totalCount => _letters.length;

  bool get hasLetterThisMonth {
    final now = DateTime.now();
    return _letters.any(
        (l) => l.createdAt.year == now.year && l.createdAt.month == now.month);
  }
}
