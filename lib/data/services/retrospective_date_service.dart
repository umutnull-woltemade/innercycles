// ════════════════════════════════════════════════════════════════════════════
// RETROSPECTIVE DATE SERVICE - Persistence for meaningful past dates
// ════════════════════════════════════════════════════════════════════════════
// Follows LifeEventService pattern: static init(), SharedPreferences, CRUD.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/retrospective_date.dart';

class RetrospectiveDateService {
  static const String _storageKey = 'inner_cycles_retrospective_dates';
  static const _uuid = Uuid();

  final SharedPreferences _prefs;
  List<RetrospectiveDate> _dates = [];

  RetrospectiveDateService._(this._prefs) {
    _loadDates();
  }

  static Future<RetrospectiveDateService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return RetrospectiveDateService._(prefs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CRUD
  // ══════════════════════════════════════════════════════════════════════════

  Future<RetrospectiveDate> saveDate({
    required String presetKey,
    required DateTime date,
  }) async {
    final retroDate = RetrospectiveDate(
      id: _uuid.v4(),
      presetKey: presetKey,
      date: date,
      createdAt: DateTime.now(),
    );
    _dates.add(retroDate);
    await _persistDates();
    return retroDate;
  }

  List<RetrospectiveDate> getAllDates() {
    return List.unmodifiable(_dates);
  }

  List<RetrospectiveDate> getIncomplete() {
    return _dates.where((d) => !d.hasJournalEntry).toList();
  }

  Future<void> linkJournalEntry(
    String retrospectiveId,
    String journalEntryId,
  ) async {
    final index = _dates.indexWhere((d) => d.id == retrospectiveId);
    if (index == -1) return;
    _dates[index] = _dates[index].copyWith(
      hasJournalEntry: true,
      journalEntryId: journalEntryId,
    );
    await _persistDates();
  }

  Future<void> deleteDate(String id) async {
    _dates.removeWhere((d) => d.id == id);
    await _persistDates();
  }

  bool get hasAnyDates => _dates.isNotEmpty;
  int get dateCount => _dates.length;
  int get completedCount => _dates.where((d) => d.hasJournalEntry).length;

  // ══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ══════════════════════════════════════════════════════════════════════════

  void _loadDates() {
    final jsonString = _prefs.getString(_storageKey);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        _dates = jsonList.map((j) => RetrospectiveDate.fromJson(j)).toList();
      } catch (_) {
        _dates = [];
      }
    }
  }

  Future<void> _persistDates() async {
    final jsonList = _dates.map((d) => d.toJson()).toList();
    await _prefs.setString(_storageKey, json.encode(jsonList));
  }
}
