// ════════════════════════════════════════════════════════════════════════════
// NOTE TO SELF SERVICE - CRUD + Reminders + Premium Gating
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/note_to_self.dart';
import '../mixins/supabase_sync_mixin.dart';
import 'notification_service.dart';
import 'sync_service.dart';

class NoteToSelfService with SupabaseSyncMixin {
  @override
  String get tableName => 'notes_to_self';
  static const String _notesKey = 'notes_to_self_entries';
  static const String _remindersKey = 'notes_to_self_reminders';
  static const _uuid = Uuid();

  /// Free tier limits
  static const int freeNoteLimit = 5;
  static const int freeActiveReminderLimit = 1;

  /// Notification ID base (200+ range to avoid collision)
  static const int _notificationIdBase = 200;

  final SharedPreferences _prefs;
  List<NoteToSelf> _notes = [];
  List<NoteReminder> _reminders = [];

  NoteToSelfService._(this._prefs) {
    _loadNotes();
    _loadReminders();
  }

  static Future<NoteToSelfService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return NoteToSelfService._(prefs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // NOTE CRUD
  // ══════════════════════════════════════════════════════════════════════════

  /// Save a new note. Returns null if free limit reached.
  Future<NoteToSelf?> saveNote({
    required String title,
    required String content,
    List<String> tags = const [],
    bool isPinned = false,
    String? linkedJournalEntryId,
    String? moodAtCreation,
    required bool isPremium,
  }) async {
    if (!isPremium && _notes.length >= freeNoteLimit) {
      return null;
    }

    final now = DateTime.now();
    final note = NoteToSelf(
      id: _uuid.v4(),
      createdAt: now,
      updatedAt: now,
      title: title,
      content: content,
      isPinned: isPinned,
      tags: tags,
      linkedJournalEntryId: linkedJournalEntryId,
      moodAtCreation: moodAtCreation,
    );

    _notes.add(note);
    await _persistNotes();

    // Sync to Supabase
    queueSync('UPSERT', note.id, {
      'id': note.id,
      'title': note.title,
      'content': note.content,
      'is_pinned': note.isPinned,
      'tags': note.tags,
      'linked_journal_entry_id': note.linkedJournalEntryId,
      'mood_at_creation': note.moodAtCreation,
    });

    return note;
  }

  Future<NoteToSelf> updateNote(NoteToSelf note) async {
    final updated = note.copyWith(updatedAt: DateTime.now());
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index >= 0) {
      _notes[index] = updated;
    } else {
      _notes.add(updated);
    }
    await _persistNotes();

    // Sync to Supabase
    queueSync('UPSERT', updated.id, {
      'id': updated.id,
      'title': updated.title,
      'content': updated.content,
      'is_pinned': updated.isPinned,
      'tags': updated.tags,
      'linked_journal_entry_id': updated.linkedJournalEntryId,
      'mood_at_creation': updated.moodAtCreation,
    });

    return updated;
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((n) => n.id == id);
    // Also remove associated reminders
    final noteReminders = _reminders.where((r) => r.noteId == id).toList();
    for (final r in noteReminders) {
      await _cancelNotification(r.id);
      // Soft-delete reminder remotely
      _queueReminderSoftDelete(r.id);
    }
    _reminders.removeWhere((r) => r.noteId == id);
    await _persistNotes();
    await _persistReminders();

    // Soft-delete note remotely
    queueSoftDelete(id);
  }

  NoteToSelf? getNote(String id) {
    return _notes.where((n) => n.id == id).firstOrNull;
  }

  List<NoteToSelf> getAllNotes() {
    final sorted = List<NoteToSelf>.from(_notes)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return List.unmodifiable(sorted);
  }

  int get noteCount => _notes.length;

  // ══════════════════════════════════════════════════════════════════════════
  // FILTERS
  // ══════════════════════════════════════════════════════════════════════════

  List<NoteToSelf> getPinnedNotes() {
    return _notes.where((n) => n.isPinned).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  List<NoteToSelf> searchNotes(String query) {
    final q = query.toLowerCase();
    return _notes
        .where(
          (n) =>
              n.title.toLowerCase().contains(q) ||
              n.content.toLowerCase().contains(q) ||
              n.tags.any((t) => t.toLowerCase().contains(q)),
        )
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  List<NoteToSelf> getNotesByTag(String tag) {
    final t = tag.toLowerCase();
    return _notes
        .where((n) => n.tags.any((nt) => nt.toLowerCase() == t))
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  /// Get all unique tags across all notes
  List<String> getAllTags() {
    final tagSet = <String>{};
    for (final note in _notes) {
      tagSet.addAll(note.tags);
    }
    return tagSet.toList()..sort();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // REMINDERS
  // ══════════════════════════════════════════════════════════════════════════

  /// Add a reminder. Returns null if free limit reached.
  Future<NoteReminder?> addReminder({
    required String noteId,
    required DateTime scheduledAt,
    required ReminderFrequency frequency,
    String? customMessage,
    required bool isPremium,
  }) async {
    final activeCount = _reminders.where((r) => r.isActive).length;
    if (!isPremium && activeCount >= freeActiveReminderLimit) {
      return null;
    }
    // Free users can only use "once" frequency
    if (!isPremium && frequency != ReminderFrequency.once) {
      return null;
    }

    final reminder = NoteReminder(
      id: _uuid.v4(),
      noteId: noteId,
      scheduledAt: scheduledAt,
      frequency: frequency,
      isActive: true,
      customMessage: customMessage,
    );

    _reminders.add(reminder);
    await _persistReminders();
    await _scheduleNotification(reminder);

    // Sync reminder to Supabase
    SyncService.queueOperation(
      tableName: 'note_reminders',
      operation: 'UPSERT',
      recordId: reminder.id,
      payload: {
        'id': reminder.id,
        'note_id': reminder.noteId,
        'scheduled_at': reminder.scheduledAt.toIso8601String(),
        'frequency': reminder.frequency.name,
        'is_active': reminder.isActive,
        'custom_message': reminder.customMessage,
      },
    );

    return reminder;
  }

  Future<void> removeReminder(String reminderId) async {
    await _cancelNotification(reminderId);
    _reminders.removeWhere((r) => r.id == reminderId);
    await _persistReminders();

    // Soft-delete reminder remotely
    _queueReminderSoftDelete(reminderId);
  }

  List<NoteReminder> getRemindersForNote(String noteId) {
    return _reminders.where((r) => r.noteId == noteId).toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  List<NoteReminder> getUpcomingReminders({int hours = 48}) {
    final now = DateTime.now();
    final cutoff = now.add(Duration(hours: hours));
    return _reminders
        .where(
          (r) =>
              r.isActive &&
              r.scheduledAt.isAfter(now) &&
              r.scheduledAt.isBefore(cutoff),
        )
        .toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  List<NoteReminder> getPastDueReminders() {
    final now = DateTime.now();
    return _reminders
        .where((r) => r.isActive && r.scheduledAt.isBefore(now))
        .toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  List<NoteReminder> getAllReminders() {
    return List.unmodifiable(_reminders);
  }

  void _queueReminderSoftDelete(String reminderId) {
    SyncService.queueOperation(
      tableName: 'note_reminders',
      operation: 'UPDATE',
      recordId: reminderId,
      payload: {'id': reminderId, 'is_deleted': true},
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // REMOTE MERGE
  // ══════════════════════════════════════════════════════════════════════════

  /// Merge notes pulled from Supabase into local storage.
  Future<void> mergeRemoteNotes(List<Map<String, dynamic>> remoteData) async {
    for (final row in remoteData) {
      final id = row['id'] as String;
      final isDeleted = row['is_deleted'] as bool? ?? false;

      if (isDeleted) {
        _notes.removeWhere((n) => n.id == id);
        continue;
      }

      final note = NoteToSelf(
        id: id,
        createdAt:
            DateTime.tryParse(row['created_at']?.toString() ?? '') ??
            DateTime.now(),
        updatedAt:
            DateTime.tryParse(row['updated_at']?.toString() ?? '') ??
            DateTime.now(),
        title: row['title'] as String? ?? '',
        content: row['content'] as String? ?? '',
        isPinned: row['is_pinned'] as bool? ?? false,
        tags:
            (row['tags'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        linkedJournalEntryId: row['linked_journal_entry_id'] as String?,
        moodAtCreation: row['mood_at_creation'] as String?,
      );

      final existingIdx = _notes.indexWhere((n) => n.id == id);
      if (existingIdx >= 0) {
        _notes[existingIdx] = note;
      } else {
        _notes.add(note);
      }
    }
    await _persistNotes();
  }

  /// Merge reminders pulled from Supabase into local storage.
  Future<void> mergeRemoteReminders(
    List<Map<String, dynamic>> remoteData,
  ) async {
    for (final row in remoteData) {
      final id = row['id'] as String;
      final isDeleted = row['is_deleted'] as bool? ?? false;

      if (isDeleted) {
        _reminders.removeWhere((r) => r.id == id);
        continue;
      }

      final reminder = NoteReminder(
        id: id,
        noteId: row['note_id'] as String? ?? '',
        scheduledAt:
            DateTime.tryParse(row['scheduled_at']?.toString() ?? '') ??
            DateTime.now(),
        frequency: ReminderFrequency.values.firstWhere(
          (e) => e.name == row['frequency'],
          orElse: () => ReminderFrequency.once,
        ),
        isActive: row['is_active'] as bool? ?? true,
        customMessage: row['custom_message'] as String?,
      );

      final existingIdx = _reminders.indexWhere((r) => r.id == id);
      if (existingIdx >= 0) {
        _reminders[existingIdx] = reminder;
      } else {
        _reminders.add(reminder);
      }
    }
    await _persistReminders();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // NOTIFICATION SCHEDULING
  // ══════════════════════════════════════════════════════════════════════════

  int _notificationIdFor(String reminderId) {
    return _notificationIdBase + reminderId.hashCode.abs() % 10000;
  }

  Future<void> _scheduleNotification(NoteReminder reminder) async {
    final note = getNote(reminder.noteId);
    if (note == null) return;

    final notificationService = NotificationService();
    await notificationService.scheduleNoteReminder(
      notificationId: _notificationIdFor(reminder.id),
      scheduledAt: reminder.scheduledAt,
      noteTitle: note.title,
      message: reminder.customMessage,
      noteId: reminder.noteId,
      frequency: reminder.frequency,
    );
  }

  Future<void> _cancelNotification(String reminderId) async {
    final notificationService = NotificationService();
    await notificationService.cancelNoteReminder(
      _notificationIdFor(reminderId),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ══════════════════════════════════════════════════════════════════════════

  void _loadNotes() {
    final jsonString = _prefs.getString(_notesKey);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        _notes = jsonList.map((j) => NoteToSelf.fromJson(j)).toList();
      } catch (e) {
        debugPrint('NoteToSelfService._loadNotes: JSON decode failed: $e');
        _notes = [];
      }
    }
  }

  void _loadReminders() {
    final jsonString = _prefs.getString(_remindersKey);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        _reminders = jsonList.map((j) => NoteReminder.fromJson(j)).toList();
      } catch (e) {
        debugPrint('NoteToSelfService._loadReminders: JSON decode failed: $e');
        _reminders = [];
      }
    }
  }

  Future<void> _persistNotes() async {
    final jsonList = _notes.map((n) => n.toJson()).toList();
    await _prefs.setString(_notesKey, json.encode(jsonList));
  }

  Future<void> _persistReminders() async {
    final jsonList = _reminders.map((r) => r.toJson()).toList();
    await _prefs.setString(_remindersKey, json.encode(jsonList));
  }

  Future<void> clearAll() async {
    for (final r in _reminders) {
      await _cancelNotification(r.id);
    }
    _notes.clear();
    _reminders.clear();
    await _prefs.remove(_notesKey);
    await _prefs.remove(_remindersKey);
  }
}
