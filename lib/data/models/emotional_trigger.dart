// ════════════════════════════════════════════════════════════════════════════
// EMOTIONAL TRIGGER MODEL - Trigger identification and tracking
// ════════════════════════════════════════════════════════════════════════════

import 'package:uuid/uuid.dart';

enum TriggerCategory {
  relationships,
  work,
  health,
  selfImage,
  environment,
  memories;

  String get nameEn {
    switch (this) {
      case relationships:
        return 'Relationships';
      case work:
        return 'Work & Career';
      case health:
        return 'Health & Body';
      case selfImage:
        return 'Self-Image';
      case environment:
        return 'Environment';
      case memories:
        return 'Memories';
    }
  }

  String get nameTr {
    switch (this) {
      case relationships:
        return '\u0130li\u015fkiler';
      case work:
        return '\u0130\u015f & Kariyer';
      case health:
        return 'Sa\u011fl\u0131k & Beden';
      case selfImage:
        return 'Benlik \u0130maj\u0131';
      case environment:
        return '\u00c7evre';
      case memories:
        return 'An\u0131lar';
    }
  }

  String get emoji {
    switch (this) {
      case relationships:
        return '\u{1F465}';
      case work:
        return '\u{1F4BC}';
      case health:
        return '\u{1F3CB}';
      case selfImage:
        return '\u{1FA9E}';
      case environment:
        return '\u{1F30D}';
      case memories:
        return '\u{1F4F7}';
    }
  }
}

class EmotionalTrigger {
  final String id;
  final String label;
  final TriggerCategory category;
  final List<DateTime> occurrences;
  final int intensity; // 1-5
  final List<String> linkedEmotions;
  final DateTime createdAt;

  EmotionalTrigger({
    String? id,
    required this.label,
    required this.category,
    this.occurrences = const [],
    this.intensity = 3,
    this.linkedEmotions = const [],
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  EmotionalTrigger copyWith({
    String? label,
    TriggerCategory? category,
    List<DateTime>? occurrences,
    int? intensity,
    List<String>? linkedEmotions,
  }) {
    return EmotionalTrigger(
      id: id,
      label: label ?? this.label,
      category: category ?? this.category,
      occurrences: occurrences ?? this.occurrences,
      intensity: intensity ?? this.intensity,
      linkedEmotions: linkedEmotions ?? this.linkedEmotions,
      createdAt: createdAt,
    );
  }

  int get frequency => occurrences.length;

  int get recentFrequency {
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    return occurrences.where((d) => d.isAfter(cutoff)).length;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'category': category.name,
        'occurrences':
            occurrences.map((d) => d.toIso8601String()).toList(),
        'intensity': intensity,
        'linkedEmotions': linkedEmotions,
        'createdAt': createdAt.toIso8601String(),
      };

  factory EmotionalTrigger.fromJson(Map<String, dynamic> json) {
    return EmotionalTrigger(
      id: json['id'] as String,
      label: json['label'] as String,
      category: TriggerCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => TriggerCategory.environment,
      ),
      occurrences: (json['occurrences'] as List<dynamic>?)
              ?.map((s) => DateTime.parse(s as String))
              .toList() ??
          [],
      intensity: json['intensity'] as int? ?? 3,
      linkedEmotions: (json['linkedEmotions'] as List<dynamic>?)
              ?.cast<String>() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
