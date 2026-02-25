// ════════════════════════════════════════════════════════════════════════════
// LIFE EVENT SERVICE - InnerCycles Life Timeline Persistence
// ════════════════════════════════════════════════════════════════════════════
// Provides CRUD operations and date-range queries for life events.
// Uses SharedPreferences for persistence (follows JournalService pattern).
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/life_event.dart';
import '../mixins/supabase_sync_mixin.dart';

class LifeEventService with SupabaseSyncMixin {
  @override
  String get tableName => 'life_events';
  static const String _storageKey = 'inner_cycles_life_events';
  static const _uuid = Uuid();

  final SharedPreferences _prefs;
  List<LifeEvent> _events = [];
  List<LifeEvent>? _sortedCache;

  LifeEventService._(this._prefs) {
    _loadEvents();
  }

  static Future<LifeEventService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LifeEventService._(prefs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CRUD OPERATIONS
  // ══════════════════════════════════════════════════════════════════════════

  Future<LifeEvent> saveEvent({
    required DateTime date,
    required LifeEventType type,
    String? eventKey,
    required String title,
    String? note,
    List<String> emotionTags = const [],
    String? imagePath,
    int intensity = 3,
  }) async {
    final event = LifeEvent(
      id: _uuid.v4(),
      date: date,
      createdAt: DateTime.now(),
      type: type,
      eventKey: eventKey,
      title: title,
      note: note,
      emotionTags: emotionTags,
      imagePath: imagePath,
      intensity: intensity.clamp(1, 5),
    );

    _events.add(event);
    _sortedCache = null;
    await _persistEvents();

    // Sync to Supabase
    queueSync('UPSERT', event.id, {
      'id': event.id,
      'date': event.dateKey,
      'type': event.type.name,
      'event_key': event.eventKey,
      'title': event.title,
      'note': event.note,
      'emotion_tags': event.emotionTags,
      'image_path': event.imagePath,
      'intensity': event.intensity,
    });

    return event;
  }

  Future<LifeEvent> updateEvent(LifeEvent updated) async {
    final index = _events.indexWhere((e) => e.id == updated.id);
    if (index == -1) return updated;
    _events[index] = updated;
    _sortedCache = null;
    await _persistEvents();

    // Sync to Supabase
    queueSync('UPSERT', updated.id, {
      'id': updated.id,
      'date': updated.dateKey,
      'type': updated.type.name,
      'event_key': updated.eventKey,
      'title': updated.title,
      'note': updated.note,
      'emotion_tags': updated.emotionTags,
      'image_path': updated.imagePath,
      'intensity': updated.intensity,
    });

    return updated;
  }

  Future<void> deleteEvent(String id) async {
    _events.removeWhere((e) => e.id == id);
    _sortedCache = null;
    await _persistEvents();

    // Soft-delete remotely
    queueSoftDelete(id);
  }

  LifeEvent? getEvent(String id) {
    return _events.where((e) => e.id == id).firstOrNull;
  }

  List<LifeEvent> getAllEvents() {
    if (_sortedCache != null) return List.unmodifiable(_sortedCache!);
    final sorted = List<LifeEvent>.from(_events)
      ..sort((a, b) => b.date.compareTo(a.date));
    _sortedCache = sorted;
    return List.unmodifiable(sorted);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // QUERIES
  // ══════════════════════════════════════════════════════════════════════════

  List<LifeEvent> getEventsForMonth(int year, int month) {
    return _events
        .where((e) => e.date.year == year && e.date.month == month)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<LifeEvent> getEventsForDateRange(DateTime start, DateTime end) {
    final startDay = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day, 23, 59, 59);
    return _events
        .where((e) => !e.date.isBefore(startDay) && !e.date.isAfter(endDay))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<LifeEvent> getEventsByType(LifeEventType type) {
    return _events.where((e) => e.type == type).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Map of dateKey → List[LifeEvent] for calendar overlay
  Map<String, List<LifeEvent>> getEventsMap() {
    final map = <String, List<LifeEvent>>{};
    for (final event in _events) {
      map.putIfAbsent(event.dateKey, () => []).add(event);
    }
    return map;
  }

  List<LifeEvent> getRecentEvents(int count) {
    final sorted = getAllEvents();
    return sorted.take(count).toList();
  }

  int get eventCount => _events.length;

  // ══════════════════════════════════════════════════════════════════════════
  // REMOTE MERGE
  // ══════════════════════════════════════════════════════════════════════════

  /// Merge events pulled from Supabase into local storage.
  Future<void> mergeRemoteEvents(List<Map<String, dynamic>> remoteData) async {
    for (final row in remoteData) {
      final id = row['id'] as String;
      final isDeleted = row['is_deleted'] as bool? ?? false;

      if (isDeleted) {
        _events.removeWhere((e) => e.id == id);
        continue;
      }

      final event = LifeEvent(
        id: id,
        date:
            DateTime.tryParse(row['date']?.toString() ?? '') ?? DateTime.now(),
        createdAt:
            DateTime.tryParse(row['created_at']?.toString() ?? '') ??
            DateTime.now(),
        type: LifeEventType.values.firstWhere(
          (e) => e.name == row['type'],
          orElse: () => LifeEventType.custom,
        ),
        eventKey: row['event_key'] as String?,
        title: row['title'] as String? ?? '',
        note: row['note'] as String?,
        emotionTags:
            (row['emotion_tags'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        intensity: (row['intensity'] as int?) ?? 3,
      );

      final existingIdx = _events.indexWhere((e) => e.id == id);
      if (existingIdx >= 0) {
        _events[existingIdx] = event;
      } else {
        _events.add(event);
      }
    }

    _sortedCache = null;
    await _persistEvents();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ══════════════════════════════════════════════════════════════════════════

  void _loadEvents() {
    _sortedCache = null;
    final jsonString = _prefs.getString(_storageKey);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        _events = jsonList.map((j) => LifeEvent.fromJson(j)).toList();
      } catch (e) {
        debugPrint('LifeEventService._loadEvents: JSON decode failed: $e');
        _events = [];
      }
    }
  }

  Future<void> _persistEvents() async {
    final jsonList = _events.map((e) => e.toJson()).toList();
    await _prefs.setString(_storageKey, json.encode(jsonList));
  }

  Future<void> clearAll() async {
    _events.clear();
    _sortedCache = null;
    await _prefs.remove(_storageKey);
  }
}
