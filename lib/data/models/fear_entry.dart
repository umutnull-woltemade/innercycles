// ════════════════════════════════════════════════════════════════════════════
// FEAR ENTRY MODEL - Named fears with intensity and reframe
// ════════════════════════════════════════════════════════════════════════════

enum FearCategory {
  health,
  relationships,
  work,
  future,
  identity,
  failure,
  loss,
  unknown;

  String labelEn() {
    switch (this) {
      case FearCategory.health:
        return 'Health';
      case FearCategory.relationships:
        return 'Relationships';
      case FearCategory.work:
        return 'Work';
      case FearCategory.future:
        return 'Future';
      case FearCategory.identity:
        return 'Identity';
      case FearCategory.failure:
        return 'Failure';
      case FearCategory.loss:
        return 'Loss';
      case FearCategory.unknown:
        return 'Unknown';
    }
  }

  String labelTr() {
    switch (this) {
      case FearCategory.health:
        return 'Sa\u011fl\u0131k';
      case FearCategory.relationships:
        return '\u0130li\u015fkiler';
      case FearCategory.work:
        return '\u0130\u015f';
      case FearCategory.future:
        return 'Gelecek';
      case FearCategory.identity:
        return 'Kimlik';
      case FearCategory.failure:
        return 'Ba\u015far\u0131s\u0131zl\u0131k';
      case FearCategory.loss:
        return 'Kay\u0131p';
      case FearCategory.unknown:
        return 'Bilinmeyen';
    }
  }

  String label(bool isEn) => isEn ? labelEn() : labelTr();

  String get emoji {
    switch (this) {
      case FearCategory.health:
        return '\u{1F3E5}';
      case FearCategory.relationships:
        return '\u{1F494}';
      case FearCategory.work:
        return '\u{1F4BC}';
      case FearCategory.future:
        return '\u{1F52E}';
      case FearCategory.identity:
        return '\u{1F3AD}';
      case FearCategory.failure:
        return '\u{1F4C9}';
      case FearCategory.loss:
        return '\u{1F54A}';
      case FearCategory.unknown:
        return '\u{2753}';
    }
  }
}

class FearEntry {
  final String id;
  final String fearText;
  final FearCategory category;
  final int intensity; // 1-5
  final String? reframeText;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  const FearEntry({
    required this.id,
    required this.fearText,
    required this.category,
    required this.intensity,
    this.reframeText,
    required this.createdAt,
    this.resolvedAt,
  });

  bool get isResolved => resolvedAt != null;

  FearEntry copyWith({
    String? reframeText,
    DateTime? resolvedAt,
    int? intensity,
  }) {
    return FearEntry(
      id: id,
      fearText: fearText,
      category: category,
      intensity: intensity ?? this.intensity,
      reframeText: reframeText ?? this.reframeText,
      createdAt: createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fearText': fearText,
        'category': category.name,
        'intensity': intensity,
        'reframeText': reframeText,
        'createdAt': createdAt.toIso8601String(),
        'resolvedAt': resolvedAt?.toIso8601String(),
      };

  factory FearEntry.fromJson(Map<String, dynamic> json) => FearEntry(
        id: json['id'] as String? ?? '',
        fearText: json['fearText'] as String? ?? '',
        category: FearCategory.values.firstWhere(
          (c) => c.name == json['category'],
          orElse: () => FearCategory.unknown,
        ),
        intensity: json['intensity'] as int? ?? 3,
        reframeText: json['reframeText'] as String?,
        createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
        resolvedAt: json['resolvedAt'] != null
            ? DateTime.tryParse(json['resolvedAt'].toString())
            : null,
      );
}
