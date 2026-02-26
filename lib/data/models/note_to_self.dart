// ════════════════════════════════════════════════════════════════════════════
// NOTE TO SELF MODEL - InnerCycles Personal Notes with Reminders
// ════════════════════════════════════════════════════════════════════════════

/// Reminder frequency options
enum ReminderFrequency {
  once,
  daily,
  weekly,
  monthly;

  String displayNameEn() {
    switch (this) {
      case ReminderFrequency.once:
        return 'Once';
      case ReminderFrequency.daily:
        return 'Daily';
      case ReminderFrequency.weekly:
        return 'Weekly';
      case ReminderFrequency.monthly:
        return 'Monthly';
    }
  }

  String displayNameTr() {
    switch (this) {
      case ReminderFrequency.once:
        return 'Bir Kez';
      case ReminderFrequency.daily:
        return 'Günlük';
      case ReminderFrequency.weekly:
        return 'Haftalık';
      case ReminderFrequency.monthly:
        return 'Aylık';
    }
  }
}

/// A reminder attached to a note
class NoteReminder {
  final String id;
  final String noteId;
  final DateTime scheduledAt;
  final ReminderFrequency frequency;
  final bool isActive;
  final String? customMessage;

  const NoteReminder({
    required this.id,
    required this.noteId,
    required this.scheduledAt,
    required this.frequency,
    this.isActive = true,
    this.customMessage,
  });

  NoteReminder copyWith({
    String? id,
    String? noteId,
    DateTime? scheduledAt,
    ReminderFrequency? frequency,
    bool? isActive,
    String? customMessage,
  }) {
    return NoteReminder(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      frequency: frequency ?? this.frequency,
      isActive: isActive ?? this.isActive,
      customMessage: customMessage ?? this.customMessage,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'noteId': noteId,
    'scheduledAt': scheduledAt.toIso8601String(),
    'frequency': frequency.name,
    'isActive': isActive,
    'customMessage': customMessage,
  };

  factory NoteReminder.fromJson(Map<String, dynamic> json) => NoteReminder(
    id: json['id'] as String? ?? '',
    noteId: json['noteId'] as String? ?? '',
    scheduledAt:
        DateTime.tryParse(json['scheduledAt']?.toString() ?? '') ??
        DateTime.now(),
    frequency: ReminderFrequency.values.firstWhere(
      (e) => e.name == json['frequency'],
      orElse: () => ReminderFrequency.once,
    ),
    isActive: json['isActive'] as bool? ?? true,
    customMessage: json['customMessage'] as String?,
  );
}

/// A personal note-to-self entry
class NoteToSelf {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final String content;
  final bool isPinned;
  final List<String> tags;
  final String? linkedJournalEntryId;
  final String? moodAtCreation;
  final bool isPrivate; // vault-protected note

  const NoteToSelf({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.content,
    this.isPinned = false,
    this.tags = const [],
    this.linkedJournalEntryId,
    this.moodAtCreation,
    this.isPrivate = false,
  });

  NoteToSelf copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? title,
    String? content,
    bool? isPinned,
    List<String>? tags,
    String? linkedJournalEntryId,
    String? moodAtCreation,
    bool? isPrivate,
  }) {
    return NoteToSelf(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      content: content ?? this.content,
      isPinned: isPinned ?? this.isPinned,
      tags: tags ?? this.tags,
      linkedJournalEntryId: linkedJournalEntryId ?? this.linkedJournalEntryId,
      moodAtCreation: moodAtCreation ?? this.moodAtCreation,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'title': title,
    'content': content,
    'isPinned': isPinned,
    'tags': tags,
    'linkedJournalEntryId': linkedJournalEntryId,
    'moodAtCreation': moodAtCreation,
    'isPrivate': isPrivate,
  };

  factory NoteToSelf.fromJson(Map<String, dynamic> json) => NoteToSelf(
    id: json['id'] as String? ?? '',
    createdAt:
        DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
        DateTime.now(),
    updatedAt:
        DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
        DateTime.now(),
    title: json['title'] as String? ?? '',
    content: json['content'] as String? ?? '',
    isPinned: json['isPinned'] as bool? ?? false,
    tags:
        (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
        [],
    linkedJournalEntryId: json['linkedJournalEntryId'] as String?,
    moodAtCreation: json['moodAtCreation'] as String?,
    isPrivate: json['isPrivate'] as bool? ?? false,
  );

  /// Preview text: first line of content, truncated
  String get preview {
    final firstLine = content.split('\n').first;
    return firstLine.length > 80
        ? '${firstLine.substring(0, 80)}...'
        : firstLine;
  }
}
