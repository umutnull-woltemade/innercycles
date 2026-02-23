// ════════════════════════════════════════════════════════════════════════════
// RETROSPECTIVE DATE MODEL - Past meaningful dates for journaling
// ════════════════════════════════════════════════════════════════════════════

class RetrospectiveDate {
  final String id;
  final String presetKey;
  final DateTime date;
  final DateTime createdAt;
  final bool hasJournalEntry;
  final String? journalEntryId;

  const RetrospectiveDate({
    required this.id,
    required this.presetKey,
    required this.date,
    required this.createdAt,
    this.hasJournalEntry = false,
    this.journalEntryId,
  });

  String get dateKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  RetrospectiveDate copyWith({
    String? id,
    String? presetKey,
    DateTime? date,
    DateTime? createdAt,
    bool? hasJournalEntry,
    String? journalEntryId,
  }) {
    return RetrospectiveDate(
      id: id ?? this.id,
      presetKey: presetKey ?? this.presetKey,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      hasJournalEntry: hasJournalEntry ?? this.hasJournalEntry,
      journalEntryId: journalEntryId ?? this.journalEntryId,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'presetKey': presetKey,
        'date': date.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'hasJournalEntry': hasJournalEntry,
        'journalEntryId': journalEntryId,
      };

  factory RetrospectiveDate.fromJson(Map<String, dynamic> json) {
    return RetrospectiveDate(
      id: json['id'] as String? ?? '',
      presetKey: json['presetKey'] as String? ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      hasJournalEntry: json['hasJournalEntry'] as bool? ?? false,
      journalEntryId: json['journalEntryId'] as String?,
    );
  }
}
