// ════════════════════════════════════════════════════════════════════════════
// JOURNAL ENTRY MODEL - InnerCycles Personal Cycle Tracking
// ════════════════════════════════════════════════════════════════════════════

import '../providers/app_providers.dart';

/// Focus areas for journal entries - the 5 personal life cycle dimensions
enum FocusArea {
  energy,
  focus,
  emotions,
  decisions,
  social;

  String get displayNameEn {
    switch (this) {
      case FocusArea.energy:
        return 'Spark';
      case FocusArea.focus:
        return 'Lens';
      case FocusArea.emotions:
        return 'Tides';
      case FocusArea.decisions:
        return 'Compass';
      case FocusArea.social:
        return 'Orbit';
    }
  }

  String get displayNameTr {
    switch (this) {
      case FocusArea.energy:
        return 'Kıvılcım';
      case FocusArea.focus:
        return 'Mercek';
      case FocusArea.emotions:
        return 'Gelgit';
      case FocusArea.decisions:
        return 'Pusula';
      case FocusArea.social:
        return 'Yörünge';
    }

  }

  String localizedName(AppLanguage language) => language == AppLanguage.en ? displayNameEn : displayNameTr;

  /// Sub-rating keys for this focus area
  List<String> get subRatingKeys {
    switch (this) {
      case FocusArea.energy:
        return ['physical', 'mental', 'motivation'];
      case FocusArea.focus:
        return ['clarity', 'productivity', 'distractibility'];
      case FocusArea.emotions:
        return ['mood', 'stress', 'calm'];
      case FocusArea.decisions:
        return ['confidence', 'certainty', 'regret'];
      case FocusArea.social:
        return ['connection', 'isolation', 'communication'];
    }
  }

  /// Sub-rating display names (English)
  Map<String, String> get subRatingNamesEn {
    switch (this) {
      case FocusArea.energy:
        return {
          'physical': 'Physical',
          'mental': 'Mental',
          'motivation': 'Motivation',
        };
      case FocusArea.focus:
        return {
          'clarity': 'Clarity',
          'productivity': 'Productivity',
          'distractibility': 'Distractibility',
        };
      case FocusArea.emotions:
        return {'mood': 'Mood', 'stress': 'Stress', 'calm': 'Calm'};
      case FocusArea.decisions:
        return {
          'confidence': 'Confidence',
          'certainty': 'Certainty',
          'regret': 'Regret',
        };
      case FocusArea.social:
        return {
          'connection': 'Connection',
          'isolation': 'Isolation',
          'communication': 'Communication',
        };
    }
  }

  /// Sub-rating display names (Turkish)
  Map<String, String> get subRatingNamesTr {
    switch (this) {
      case FocusArea.energy:
        return {
          'physical': 'Fiziksel',
          'mental': 'Zihinsel',
          'motivation': 'Motivasyon',
        };
      case FocusArea.focus:
        return {
          'clarity': 'Netlik',
          'productivity': 'Verimlilik',
          'distractibility': 'Dikkat Dağınıklığı',
        };
      case FocusArea.emotions:
        return {'mood': 'Ruh Hali', 'stress': 'Stres', 'calm': 'Huzur'};
      case FocusArea.decisions:
        return {
          'confidence': 'Güven',
          'certainty': 'Kesinlik',
          'regret': 'Pişmanlık',
        };
      case FocusArea.social:
        return {
          'connection': 'Bağlantı',
          'isolation': 'Yalnızlık',
          'communication': 'İletişim',
        };
    }
  }
}

/// A single journal entry representing one day's cycle tracking
class JournalEntry {
  final String id;
  final DateTime date;
  final DateTime createdAt;
  final FocusArea focusArea;
  final int overallRating; // 1-5
  final Map<String, int> subRatings; // key -> 1-5
  final String? note;
  final String? imagePath; // local file path to attached photo
  final List<String> tags; // user-defined tags
  final bool isPrivate; // vault-protected entry

  const JournalEntry({
    required this.id,
    required this.date,
    required this.createdAt,
    required this.focusArea,
    required this.overallRating,
    this.subRatings = const {},
    this.note,
    this.imagePath,
    this.tags = const [],
    this.isPrivate = false,
  });

  JournalEntry copyWith({
    String? id,
    DateTime? date,
    DateTime? createdAt,
    FocusArea? focusArea,
    int? overallRating,
    Map<String, int>? subRatings,
    String? note,
    String? imagePath,
    List<String>? tags,
    bool? isPrivate,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      focusArea: focusArea ?? this.focusArea,
      overallRating: overallRating ?? this.overallRating,
      subRatings: subRatings ?? this.subRatings,
      note: note ?? this.note,
      imagePath: imagePath ?? this.imagePath,
      tags: tags ?? this.tags,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'focusArea': focusArea.name,
    'overallRating': overallRating,
    'subRatings': subRatings,
    'note': note,
    'imagePath': imagePath,
    'tags': tags,
    'isPrivate': isPrivate,
  };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
    id: json['id'] as String? ?? '',
    date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
    createdAt:
        DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
        DateTime.now(),
    focusArea: FocusArea.values.firstWhere(
      (e) => e.name == json['focusArea'],
      orElse: () => FocusArea.energy,
    ),
    overallRating: json['overallRating'] as int? ?? 3,
    subRatings: json['subRatings'] is Map
        ? Map<String, int>.fromEntries(
            (json['subRatings'] as Map).entries.map(
              (e) => MapEntry(
                e.key.toString(),
                e.value is num ? (e.value as num).toInt() : 0,
              ),
            ),
          )
        : {},
    note: json['note'] as String?,
    imagePath: json['imagePath'] as String?,
    tags: (json['tags'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        const [],
    isPrivate: json['isPrivate'] as bool? ?? false,
  );

  /// Date key for grouping entries by day (yyyy-MM-dd)
  String get dateKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
