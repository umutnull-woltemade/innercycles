// ════════════════════════════════════════════════════════════════════════════
// BIRTHDAY CONTACT MODEL - InnerCycles Birthday Agenda
// ════════════════════════════════════════════════════════════════════════════

/// Source of the birthday contact
enum BirthdayContactSource {
  manual,
  facebook;

  String get displayNameEn {
    switch (this) {
      case BirthdayContactSource.manual:
        return 'Manual';
      case BirthdayContactSource.facebook:
        return 'Facebook';
    }
  }

  String get displayNameTr {
    switch (this) {
      case BirthdayContactSource.manual:
        return 'Manuel';
      case BirthdayContactSource.facebook:
        return 'Facebook';
    }

  }

  String localizedName(bool isEn) => isEn ? displayNameEn : displayNameTr;
}

/// Relationship type for a birthday contact
enum BirthdayRelationship {
  friend,
  family,
  partner,
  colleague,
  classmate,
  other;

  String get displayNameEn {
    switch (this) {
      case BirthdayRelationship.friend:
        return 'Friend';
      case BirthdayRelationship.family:
        return 'Family';
      case BirthdayRelationship.partner:
        return 'Partner';
      case BirthdayRelationship.colleague:
        return 'Colleague';
      case BirthdayRelationship.classmate:
        return 'Classmate';
      case BirthdayRelationship.other:
        return 'Other';
    }
  }

  String get displayNameTr {
    switch (this) {
      case BirthdayRelationship.friend:
        return 'Arkadaş';
      case BirthdayRelationship.family:
        return 'Aile';
      case BirthdayRelationship.partner:
        return 'Partner';
      case BirthdayRelationship.colleague:
        return 'İş Arkadaşı';
      case BirthdayRelationship.classmate:
        return 'Sınıf Arkadaşı';
      case BirthdayRelationship.other:
        return 'Diğer';
    }
  }

  String localizedName(bool isEn) => isEn ? displayNameEn : displayNameTr;

  String get emoji {
    switch (this) {
      case BirthdayRelationship.friend:
        return '\u{1F91D}';
      case BirthdayRelationship.family:
        return '\u{1F46A}';
      case BirthdayRelationship.partner:
        return '\u{2764}\u{FE0F}';
      case BirthdayRelationship.colleague:
        return '\u{1F4BC}';
      case BirthdayRelationship.classmate:
        return '\u{1F393}';
      case BirthdayRelationship.other:
        return '\u{2B50}';
    }
  }
}

/// A birthday contact for the Birthday Agenda feature
class BirthdayContact {
  final String id;
  final String name;
  final int birthdayMonth; // 1-12
  final int birthdayDay; // 1-31
  final int? birthYear; // nullable for FB imports without year
  final DateTime createdAt;
  final String? photoPath;
  final String? avatarEmoji;
  final BirthdayRelationship relationship;
  final String? note;
  final BirthdayContactSource source;
  final bool notificationsEnabled;
  final bool dayBeforeReminder;

  const BirthdayContact({
    required this.id,
    required this.name,
    required this.birthdayMonth,
    required this.birthdayDay,
    this.birthYear,
    required this.createdAt,
    this.photoPath,
    this.avatarEmoji,
    this.relationship = BirthdayRelationship.friend,
    this.note,
    this.source = BirthdayContactSource.manual,
    this.notificationsEnabled = true,
    this.dayBeforeReminder = true,
  });

  BirthdayContact copyWith({
    String? id,
    String? name,
    int? birthdayMonth,
    int? birthdayDay,
    int? birthYear,
    DateTime? createdAt,
    String? photoPath,
    String? avatarEmoji,
    BirthdayRelationship? relationship,
    String? note,
    BirthdayContactSource? source,
    bool? notificationsEnabled,
    bool? dayBeforeReminder,
  }) {
    return BirthdayContact(
      id: id ?? this.id,
      name: name ?? this.name,
      birthdayMonth: birthdayMonth ?? this.birthdayMonth,
      birthdayDay: birthdayDay ?? this.birthdayDay,
      birthYear: birthYear ?? this.birthYear,
      createdAt: createdAt ?? this.createdAt,
      photoPath: photoPath ?? this.photoPath,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      relationship: relationship ?? this.relationship,
      note: note ?? this.note,
      source: source ?? this.source,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dayBeforeReminder: dayBeforeReminder ?? this.dayBeforeReminder,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'birthdayMonth': birthdayMonth,
    'birthdayDay': birthdayDay,
    'birthYear': birthYear,
    'createdAt': createdAt.toIso8601String(),
    'photoPath': photoPath,
    'avatarEmoji': avatarEmoji,
    'relationship': relationship.name,
    'note': note,
    'source': source.name,
    'notificationsEnabled': notificationsEnabled,
    'dayBeforeReminder': dayBeforeReminder,
  };

  factory BirthdayContact.fromJson(Map<String, dynamic> json) =>
      BirthdayContact(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        birthdayMonth: (json['birthdayMonth'] as int?) ?? 1,
        birthdayDay: (json['birthdayDay'] as int?) ?? 1,
        birthYear: json['birthYear'] as int?,
        createdAt:
            DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
            DateTime.now(),
        photoPath: json['photoPath'] as String?,
        avatarEmoji: json['avatarEmoji'] as String?,
        relationship: BirthdayRelationship.values.firstWhere(
          (e) => e.name == json['relationship'],
          orElse: () => BirthdayRelationship.friend,
        ),
        note: json['note'] as String?,
        source: BirthdayContactSource.values.firstWhere(
          (e) => e.name == json['source'],
          orElse: () => BirthdayContactSource.manual,
        ),
        notificationsEnabled: (json['notificationsEnabled'] as bool?) ?? true,
        dayBeforeReminder: (json['dayBeforeReminder'] as bool?) ?? true,
      );

  // ══════════════════════════════════════════════════════════════════════════
  // COMPUTED PROPERTIES
  // ══════════════════════════════════════════════════════════════════════════

  /// MM-dd format key for birthday map grouping
  String get birthdayDateKey =>
      '${birthdayMonth.toString().padLeft(2, '0')}-${birthdayDay.toString().padLeft(2, '0')}';

  /// Construct a birthday DateTime safely, handling Feb 29 in non-leap years.
  /// Falls back to Feb 28 when the year is not a leap year.
  static DateTime _safeBirthdayDate(
    int year,
    int month,
    int day, [
    int hour = 0,
    int minute = 0,
  ]) {
    if (month == 2 && day == 29) {
      final isLeap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
      if (!isLeap) return DateTime(year, 2, 28, hour, minute);
    }
    return DateTime(year, month, day, hour, minute);
  }

  /// Days until next birthday from today
  int get daysUntilBirthday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var nextBirthday = _safeBirthdayDate(now.year, birthdayMonth, birthdayDay);
    if (nextBirthday.isBefore(today)) {
      nextBirthday = _safeBirthdayDate(
        now.year + 1,
        birthdayMonth,
        birthdayDay,
      );
    }
    return nextBirthday.difference(today).inDays;
  }

  /// Whether this person's birthday is today.
  /// For Feb 29 birthdays in non-leap years, recognizes Feb 28 as their birthday.
  bool get isBirthdayToday {
    final now = DateTime.now();
    if (now.month == birthdayMonth && now.day == birthdayDay) return true;
    if (birthdayMonth == 2 &&
        birthdayDay == 29 &&
        now.month == 2 &&
        now.day == 28) {
      final isLeap =
          (now.year % 4 == 0 && now.year % 100 != 0) || (now.year % 400 == 0);
      return !isLeap;
    }
    return false;
  }

  /// Whether birthday falls within this week (next 7 days)
  bool get isBirthdayThisWeek => daysUntilBirthday <= 7;

  /// Age if birth year is known, null otherwise. Returns null for invalid/future years.
  int? get age {
    if (birthYear == null) return null;
    final now = DateTime.now();
    var calculatedAge = now.year - birthYear!;
    if (now.month < birthdayMonth ||
        (now.month == birthdayMonth && now.day < birthdayDay)) {
      calculatedAge--;
    }
    return calculatedAge >= 0 ? calculatedAge : null;
  }

  /// Initials from name (first letters of first two words)
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
