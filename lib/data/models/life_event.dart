import 'package:innercycles/data/providers/app_providers.dart';
// ════════════════════════════════════════════════════════════════════════════
// LIFE EVENT MODEL - InnerCycles Life Timeline
// ════════════════════════════════════════════════════════════════════════════

/// Category of life event
enum LifeEventType {
  positive,
  challenging,
  custom;

  String get displayNameEn {
    switch (this) {
      case LifeEventType.positive:
        return 'Positive';
      case LifeEventType.challenging:
        return 'Challenging';
      case LifeEventType.custom:
        return 'Custom';
    }
  }

  String get displayNameTr {
    switch (this) {
      case LifeEventType.positive:
        return 'Olumlu';
      case LifeEventType.challenging:
        return 'Zorlu';
      case LifeEventType.custom:
        return 'Kişisel';
    }

  }

  String localizedName(AppLanguage language) => language.isEn ? displayNameEn : displayNameTr;
}

/// A life event representing a significant moment in the user's timeline
class LifeEvent {
  final String id;
  final DateTime date;
  final DateTime createdAt;
  final LifeEventType type;
  final String? eventKey; // preset key, null for custom events
  final String title;
  final String? note;
  final List<String> emotionTags; // keys from emotional vocabulary
  final String? imagePath;
  final int intensity; // 1-5

  const LifeEvent({
    required this.id,
    required this.date,
    required this.createdAt,
    required this.type,
    this.eventKey,
    required this.title,
    this.note,
    this.emotionTags = const [],
    this.imagePath,
    this.intensity = 3,
  });

  LifeEvent copyWith({
    String? id,
    DateTime? date,
    DateTime? createdAt,
    LifeEventType? type,
    String? eventKey,
    String? title,
    String? note,
    List<String>? emotionTags,
    String? imagePath,
    int? intensity,
  }) {
    return LifeEvent(
      id: id ?? this.id,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      eventKey: eventKey ?? this.eventKey,
      title: title ?? this.title,
      note: note ?? this.note,
      emotionTags: emotionTags ?? this.emotionTags,
      imagePath: imagePath ?? this.imagePath,
      intensity: intensity ?? this.intensity,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'type': type.name,
    'eventKey': eventKey,
    'title': title,
    'note': note,
    'emotionTags': emotionTags,
    'imagePath': imagePath,
    'intensity': intensity,
  };

  factory LifeEvent.fromJson(Map<String, dynamic> json) => LifeEvent(
    id: json['id'] as String? ?? '',
    date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
    createdAt:
        DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
        DateTime.now(),
    type: LifeEventType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => LifeEventType.custom,
    ),
    eventKey: json['eventKey'] as String?,
    title: json['title'] as String? ?? '',
    note: json['note'] as String?,
    emotionTags:
        (json['emotionTags'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [],
    imagePath: json['imagePath'] as String?,
    intensity: (json['intensity'] as int?) ?? 3,
  );

  /// Date key for grouping by day (yyyy-MM-dd)
  String get dateKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
