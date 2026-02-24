// ════════════════════════════════════════════════════════════════════════════
// BIRTHDAY CONTACT SERVICE - InnerCycles Birthday Agenda Persistence
// ════════════════════════════════════════════════════════════════════════════
// Provides CRUD operations, birthday queries, and import batch operations.
// Uses SharedPreferences for persistence (follows LifeEventService pattern).
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/birthday_contact.dart';
import '../mixins/supabase_sync_mixin.dart';

class BirthdayContactService with SupabaseSyncMixin {
  @override
  String get tableName => 'birthday_contacts';
  static const String _storageKey = 'inner_cycles_birthday_contacts';
  static const _uuid = Uuid();

  final SharedPreferences _prefs;
  List<BirthdayContact> _contacts = [];
  List<BirthdayContact>? _sortedCache;

  BirthdayContactService._(this._prefs) {
    _loadContacts();
  }

  static Future<BirthdayContactService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return BirthdayContactService._(prefs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CRUD OPERATIONS
  // ══════════════════════════════════════════════════════════════════════════

  Future<BirthdayContact> saveContact({
    required String name,
    required int birthdayMonth,
    required int birthdayDay,
    int? birthYear,
    String? photoPath,
    String? avatarEmoji,
    BirthdayRelationship relationship = BirthdayRelationship.friend,
    String? note,
    BirthdayContactSource source = BirthdayContactSource.manual,
    bool notificationsEnabled = true,
    bool dayBeforeReminder = true,
  }) async {
    final contact = BirthdayContact(
      id: _uuid.v4(),
      name: name,
      birthdayMonth: birthdayMonth.clamp(1, 12),
      birthdayDay: birthdayDay.clamp(1, 31),
      birthYear: birthYear,
      createdAt: DateTime.now(),
      photoPath: photoPath,
      avatarEmoji: avatarEmoji,
      relationship: relationship,
      note: note,
      source: source,
      notificationsEnabled: notificationsEnabled,
      dayBeforeReminder: dayBeforeReminder,
    );

    _contacts.add(contact);
    _sortedCache = null;
    await _persistContacts();

    queueSync('UPSERT', contact.id, _toSupabasePayload(contact));

    return contact;
  }

  Future<BirthdayContact> updateContact(BirthdayContact updated) async {
    final index = _contacts.indexWhere((c) => c.id == updated.id);
    if (index == -1) return updated;
    _contacts[index] = updated;
    _sortedCache = null;
    await _persistContacts();

    queueSync('UPSERT', updated.id, _toSupabasePayload(updated));

    return updated;
  }

  Future<void> deleteContact(String id) async {
    _contacts.removeWhere((c) => c.id == id);
    _sortedCache = null;
    await _persistContacts();

    queueSoftDelete(id);
  }

  BirthdayContact? getContact(String id) {
    return _contacts.where((c) => c.id == id).firstOrNull;
  }

  List<BirthdayContact> getAllContacts() {
    if (_sortedCache != null) return List.unmodifiable(_sortedCache!);
    final sorted = List<BirthdayContact>.from(_contacts)
      ..sort((a, b) => a.daysUntilBirthday.compareTo(b.daysUntilBirthday));
    _sortedCache = sorted;
    return List.unmodifiable(sorted);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // QUERIES
  // ══════════════════════════════════════════════════════════════════════════

  /// Map of "MM-dd" to list of contacts for calendar overlay
  Map<String, List<BirthdayContact>> getBirthdayMap() {
    final map = <String, List<BirthdayContact>>{};
    for (final contact in _contacts) {
      map.putIfAbsent(contact.birthdayDateKey, () => []).add(contact);
    }
    return map;
  }

  /// Contacts with birthdays within the next [withinDays] days
  List<BirthdayContact> getUpcomingBirthdays({int withinDays = 30}) {
    return _contacts
        .where((c) => c.daysUntilBirthday <= withinDays)
        .toList()
      ..sort((a, b) => a.daysUntilBirthday.compareTo(b.daysUntilBirthday));
  }

  /// Contacts whose birthday is today
  List<BirthdayContact> getTodayBirthdays() {
    return _contacts.where((c) => c.isBirthdayToday).toList();
  }

  /// Contacts whose birthday is within the next 7 days
  List<BirthdayContact> getThisWeekBirthdays() {
    return _contacts.where((c) => c.isBirthdayThisWeek).toList()
      ..sort((a, b) => a.daysUntilBirthday.compareTo(b.daysUntilBirthday));
  }

  /// Contacts with birthdays in a specific month
  List<BirthdayContact> getBirthdaysForMonth(int month) {
    return _contacts.where((c) => c.birthdayMonth == month).toList()
      ..sort((a, b) => a.birthdayDay.compareTo(b.birthdayDay));
  }

  /// Search contacts by name
  List<BirthdayContact> searchByName(String query) {
    final lower = query.toLowerCase();
    return _contacts
        .where((c) => c.name.toLowerCase().contains(lower))
        .toList();
  }

  int get contactCount => _contacts.length;

  // ══════════════════════════════════════════════════════════════════════════
  // BATCH IMPORT
  // ══════════════════════════════════════════════════════════════════════════

  /// Import multiple contacts, deduplicating by name+birthday
  Future<int> importContacts(List<BirthdayContact> newContacts) async {
    int imported = 0;
    for (final incoming in newContacts) {
      final isDuplicate = _contacts.any(
        (c) =>
            c.name.toLowerCase() == incoming.name.toLowerCase() &&
            c.birthdayMonth == incoming.birthdayMonth &&
            c.birthdayDay == incoming.birthdayDay,
      );
      if (!isDuplicate) {
        final contact = incoming.copyWith(id: _uuid.v4());
        _contacts.add(contact);
        queueSync('UPSERT', contact.id, _toSupabasePayload(contact));
        imported++;
      }
    }
    if (imported > 0) {
      _sortedCache = null;
      await _persistContacts();
    }
    return imported;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // REMOTE MERGE
  // ══════════════════════════════════════════════════════════════════════════

  /// Merge contacts pulled from Supabase into local storage.
  Future<void> mergeRemoteContacts(List<Map<String, dynamic>> remoteData) async {
    for (final row in remoteData) {
      final id = row['id'] as String;
      final isDeleted = row['is_deleted'] as bool? ?? false;

      if (isDeleted) {
        _contacts.removeWhere((c) => c.id == id);
        continue;
      }

      final contact = BirthdayContact(
        id: id,
        name: row['name'] as String? ?? '',
        birthdayMonth: (row['birthday_month'] as int?) ?? 1,
        birthdayDay: (row['birthday_day'] as int?) ?? 1,
        birthYear: row['birth_year'] as int?,
        createdAt:
            DateTime.tryParse(row['created_at']?.toString() ?? '') ??
            DateTime.now(),
        photoPath: row['photo_path'] as String?,
        avatarEmoji: row['avatar_emoji'] as String?,
        relationship: BirthdayRelationship.values.firstWhere(
          (e) => e.name == row['relationship'],
          orElse: () => BirthdayRelationship.friend,
        ),
        note: row['note'] as String?,
        source: BirthdayContactSource.values.firstWhere(
          (e) => e.name == row['source'],
          orElse: () => BirthdayContactSource.manual,
        ),
        notificationsEnabled:
            (row['notifications_enabled'] as bool?) ?? true,
        dayBeforeReminder:
            (row['day_before_reminder'] as bool?) ?? true,
      );

      final existingIdx = _contacts.indexWhere((c) => c.id == id);
      if (existingIdx >= 0) {
        _contacts[existingIdx] = contact;
      } else {
        _contacts.add(contact);
      }
    }

    _sortedCache = null;
    await _persistContacts();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ══════════════════════════════════════════════════════════════════════════

  void _loadContacts() {
    _sortedCache = null;
    final jsonString = _prefs.getString(_storageKey);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        _contacts = jsonList.map((j) => BirthdayContact.fromJson(j)).toList();
      } catch (_) {
        _contacts = [];
      }
    }
  }

  Future<void> _persistContacts() async {
    final jsonList = _contacts.map((c) => c.toJson()).toList();
    await _prefs.setString(_storageKey, json.encode(jsonList));
  }

  Future<void> clearAll() async {
    _contacts.clear();
    _sortedCache = null;
    await _prefs.remove(_storageKey);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  Map<String, dynamic> _toSupabasePayload(BirthdayContact c) => {
    'id': c.id,
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
  };
}
