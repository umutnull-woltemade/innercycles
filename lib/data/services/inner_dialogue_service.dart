// ════════════════════════════════════════════════════════════════════════════
// INNER DIALOGUE SERVICE - Dual-perspective journaling persistence
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/inner_dialogue.dart';

class InnerDialogueService {
  static const _storageKey = 'inner_dialogues_v1';
  final SharedPreferences _prefs;
  List<InnerDialogue> _dialogues = [];

  InnerDialogueService._(this._prefs) {
    _load();
  }

  static Future<InnerDialogueService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return InnerDialogueService._(prefs);
  }

  void _load() {
    final raw = _prefs.getStringList(_storageKey) ?? [];
    _dialogues = raw
        .map((s) {
          try {
            return InnerDialogue.fromJson(
                json.decode(s) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<InnerDialogue>()
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> _persist() async {
    final raw = _dialogues.map((d) => json.encode(d.toJson())).toList();
    await _prefs.setStringList(_storageKey, raw);
  }

  List<InnerDialogue> getAll() => List.unmodifiable(_dialogues);

  List<InnerDialogue> getRecent({int limit = 5}) {
    return _dialogues.take(limit).toList();
  }

  InnerDialogue? getById(String id) {
    try {
      return _dialogues.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<InnerDialogue> save(InnerDialogue dialogue) async {
    final idx = _dialogues.indexWhere((d) => d.id == dialogue.id);
    if (idx >= 0) {
      _dialogues[idx] = dialogue;
    } else {
      _dialogues.insert(0, dialogue);
    }
    await _persist();
    return dialogue;
  }

  Future<void> delete(String id) async {
    _dialogues.removeWhere((d) => d.id == id);
    await _persist();
  }

  int get totalCount => _dialogues.length;

  /// Most used perspective
  DialoguePerspective? get favoritePerspective {
    if (_dialogues.isEmpty) return null;
    final counts = <DialoguePerspective, int>{};
    for (final d in _dialogues) {
      counts[d.perspective] = (counts[d.perspective] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  /// Check if user has written a dialogue this week
  bool get hasDialogueThisWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDate =
        DateTime(weekStart.year, weekStart.month, weekStart.day);
    return _dialogues.any((d) => d.createdAt.isAfter(weekStartDate));
  }
}
