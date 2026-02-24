import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'journal_service.dart';
import 'dream_journal_service.dart';
import 'mood_checkin_service.dart';
import 'note_to_self_service.dart';
import 'life_event_service.dart';
import 'cycle_sync_service.dart';
import 'storage_service.dart';
import 'birthday_contact_service.dart';

/// One-time migration service that pushes all existing local data to Supabase
/// for users who already have data before the sync feature was added.
class DataMigrationService {
  static const String _migratedKey = 'supabase_data_migrated';

  /// Check if migration has already been completed.
  static Future<bool> needsMigration() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_migratedKey) ?? false);
  }

  /// Migrate all local data to Supabase.
  /// [onProgress] callback: (currentStep, totalSteps, tableName)
  static Future<MigrationResult> migrateAllLocalData({
    required String userId,
    void Function(int current, int total, String table)? onProgress,
  }) async {
    final supabase = Supabase.instance.client;
    final errors = <String>[];
    int migrated = 0;
    const totalSteps = 8;

    // 1. Profiles
    onProgress?.call(1, totalSteps, 'user_profiles');
    try {
      final profiles = StorageService.loadAllProfiles();
      if (profiles.isNotEmpty) {
        final rows = profiles.map((p) => {
          'id': p.id,
          'user_id': userId,
          'display_name': p.name,
          'avatar_emoji': p.avatarEmoji,
          'birth_date': '${p.birthDate.year}-${p.birthDate.month.toString().padLeft(2, '0')}-${p.birthDate.day.toString().padLeft(2, '0')}',
          'birth_time': p.birthTime,
          'birth_place': p.birthPlace,
          'birth_latitude': p.birthLatitude,
          'birth_longitude': p.birthLongitude,
          'is_primary': p.isPrimary,
          'relationship': p.relationship,
          'settings': <String, dynamic>{},
        }).toList();
        await supabase.from('user_profiles').upsert(rows);
        migrated += rows.length;
      }
    } catch (e) {
      errors.add('user_profiles: $e');
      if (kDebugMode) debugPrint('Migration: user_profiles error: $e');
    }

    // 2. Journal entries
    onProgress?.call(2, totalSteps, 'journal_entries');
    try {
      final journalService = await JournalService.init();
      final entries = journalService.getAllEntries();
      if (entries.isNotEmpty) {
        final rows = entries.map((e) => {
          'id': e.id,
          'user_id': userId,
          'date': e.dateKey,
          'focus_area': e.focusArea.name,
          'overall_rating': e.overallRating,
          'sub_ratings': e.subRatings,
          'note': e.note,
          'image_path': e.imagePath,
        }).toList();
        // Batch in chunks of 50
        for (var i = 0; i < rows.length; i += 50) {
          final chunk = rows.sublist(i, (i + 50).clamp(0, rows.length));
          await supabase.from('journal_entries').upsert(chunk);
        }
        migrated += rows.length;
      }
    } catch (e) {
      errors.add('journal_entries: $e');
      if (kDebugMode) debugPrint('Migration: journal_entries error: $e');
    }

    // 3. Dream entries
    onProgress?.call(3, totalSteps, 'dream_entries');
    try {
      final dreamService = await DreamJournalService.init();
      final dreams = await dreamService.getAllDreams();
      if (dreams.isNotEmpty) {
        final rows = dreams.map((d) => {
          'id': d.id,
          'user_id': userId,
          'dream_date': '${d.dreamDate.year}-${d.dreamDate.month.toString().padLeft(2, '0')}-${d.dreamDate.day.toString().padLeft(2, '0')}',
          'title': d.title,
          'content': d.content,
          'detected_symbols': d.detectedSymbols,
          'user_tags': d.userTags,
          'dominant_emotion': d.dominantEmotion.name,
          'emotional_intensity': d.emotionalIntensity,
          'is_recurring': d.isRecurring,
          'is_lucid': d.isLucid,
          'is_nightmare': d.isNightmare,
          'moon_phase': d.moonPhase.name,
          'interpretation': d.interpretation?.toJson(),
          'metadata': d.metadata,
          'characters': d.characters ?? <String>[],
          'locations': d.locations ?? <String>[],
          'clarity': d.clarity,
          'sleep_quality': d.sleepQuality,
          'dream_series_id': d.dreamSeriesId,
        }).toList();
        for (var i = 0; i < rows.length; i += 50) {
          final chunk = rows.sublist(i, (i + 50).clamp(0, rows.length));
          await supabase.from('dream_entries').upsert(chunk);
        }
        migrated += rows.length;
      }
    } catch (e) {
      errors.add('dream_entries: $e');
      if (kDebugMode) debugPrint('Migration: dream_entries error: $e');
    }

    // 4. Mood entries
    onProgress?.call(4, totalSteps, 'mood_entries');
    try {
      final moodService = await MoodCheckinService.init();
      final moods = moodService.getAllEntries();
      if (moods.isNotEmpty) {
        final rows = moods.map((m) => {
          'id': m.id,
          'user_id': userId,
          'date': '${m.date.year}-${m.date.month.toString().padLeft(2, '0')}-${m.date.day.toString().padLeft(2, '0')}',
          'mood': m.mood,
          'emoji': m.emoji,
        }).toList();
        for (var i = 0; i < rows.length; i += 50) {
          final chunk = rows.sublist(i, (i + 50).clamp(0, rows.length));
          await supabase.from('mood_entries').upsert(chunk);
        }
        migrated += rows.length;
      }
    } catch (e) {
      errors.add('mood_entries: $e');
      if (kDebugMode) debugPrint('Migration: mood_entries error: $e');
    }

    // 5. Notes + reminders
    onProgress?.call(5, totalSteps, 'notes_to_self');
    try {
      final noteService = await NoteToSelfService.init();
      final notes = noteService.getAllNotes();
      if (notes.isNotEmpty) {
        final noteRows = notes.map((n) => {
          'id': n.id,
          'user_id': userId,
          'title': n.title,
          'content': n.content,
          'is_pinned': n.isPinned,
          'tags': n.tags,
          'linked_journal_entry_id': n.linkedJournalEntryId,
          'mood_at_creation': n.moodAtCreation,
        }).toList();
        await supabase.from('notes_to_self').upsert(noteRows);
        migrated += noteRows.length;

        // Reminders
        final allReminders = noteService.getAllReminders();
        if (allReminders.isNotEmpty) {
          final reminderRows = allReminders.map((r) => {
            'id': r.id,
            'note_id': r.noteId,
            'scheduled_at': r.scheduledAt.toIso8601String(),
            'frequency': r.frequency.name,
            'is_active': r.isActive,
            'custom_message': r.customMessage,
          }).toList();
          await supabase.from('note_reminders').upsert(reminderRows);
          migrated += reminderRows.length;
        }
      }
    } catch (e) {
      errors.add('notes_to_self: $e');
      if (kDebugMode) debugPrint('Migration: notes_to_self error: $e');
    }

    // 6. Life events
    onProgress?.call(6, totalSteps, 'life_events');
    try {
      final lifeService = await LifeEventService.init();
      final events = lifeService.getAllEvents();
      if (events.isNotEmpty) {
        final rows = events.map((e) => {
          'id': e.id,
          'user_id': userId,
          'date': e.dateKey,
          'type': e.type.name,
          'event_key': e.eventKey,
          'title': e.title,
          'note': e.note,
          'emotion_tags': e.emotionTags,
          'image_path': e.imagePath,
          'intensity': e.intensity,
        }).toList();
        await supabase.from('life_events').upsert(rows);
        migrated += rows.length;
      }
    } catch (e) {
      errors.add('life_events: $e');
      if (kDebugMode) debugPrint('Migration: life_events error: $e');
    }

    // 7. Cycle logs
    onProgress?.call(7, totalSteps, 'cycle_period_logs');
    try {
      final cycleService = await CycleSyncService.init();
      final logs = cycleService.getAllLogs();
      if (logs.isNotEmpty) {
        final rows = logs.map((l) => {
          'id': l.id,
          'user_id': userId,
          'period_start_date': l.dateKey,
          'period_end_date': l.periodEndDate != null
              ? '${l.periodEndDate!.year}-${l.periodEndDate!.month.toString().padLeft(2, '0')}-${l.periodEndDate!.day.toString().padLeft(2, '0')}'
              : null,
          'flow_intensity': l.flowIntensity?.name,
          'symptoms': l.symptoms,
        }).toList();
        await supabase.from('cycle_period_logs').upsert(rows);
        migrated += rows.length;
      }
    } catch (e) {
      errors.add('cycle_period_logs: $e');
      if (kDebugMode) debugPrint('Migration: cycle_period_logs error: $e');
    }

    // 8. Birthday contacts
    onProgress?.call(8, totalSteps, 'birthday_contacts');
    try {
      final birthdayService = await BirthdayContactService.init();
      final contacts = birthdayService.getAllContacts();
      if (contacts.isNotEmpty) {
        final rows = contacts.map((c) => {
          'id': c.id,
          'user_id': userId,
          'name': c.name,
          'birthday_month': c.birthdayMonth,
          'birthday_day': c.birthdayDay,
          'birth_year': c.birthYear,
          'photo_path': c.photoPath,
          'avatar_emoji': c.avatarEmoji,
          'relationship': c.relationship.name,
          'note': c.note,
          'source': c.source.name,
          'notifications_enabled': c.notificationsEnabled,
          'day_before_reminder': c.dayBeforeReminder,
        }).toList();
        for (var i = 0; i < rows.length; i += 50) {
          final chunk = rows.sublist(i, (i + 50).clamp(0, rows.length));
          await supabase.from('birthday_contacts').upsert(chunk);
        }
        migrated += rows.length;
      }
    } catch (e) {
      errors.add('birthday_contacts: $e');
      if (kDebugMode) debugPrint('Migration: birthday_contacts error: $e');
    }

    // Mark migration complete (even if partial — errors are tracked)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_migratedKey, errors.isEmpty);

    // Update sync metadata
    try {
      await supabase.from('sync_metadata').upsert({
        'user_id': userId,
        'last_full_sync': DateTime.now().toIso8601String(),
        'schema_version': 1,
      });
    } catch (e) {
      if (kDebugMode) debugPrint('Migration: sync_metadata error: $e');
    }

    if (kDebugMode) {
      debugPrint('Migration complete: $migrated records, ${errors.length} errors');
    }

    return MigrationResult(
      migrated: migrated,
      errors: errors,
    );
  }
}

class MigrationResult {
  final int migrated;
  final List<String> errors;

  bool get hasErrors => errors.isNotEmpty;
  bool get isSuccess => errors.isEmpty;

  const MigrationResult({required this.migrated, required this.errors});
}
