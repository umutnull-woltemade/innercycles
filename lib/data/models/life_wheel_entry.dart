// ════════════════════════════════════════════════════════════════════════════
// LIFE WHEEL ENTRY MODEL - Balance assessment across 8 life areas
// ════════════════════════════════════════════════════════════════════════════

enum LifeArea {
  health,
  career,
  finances,
  relationships,
  fun,
  growth,
  environment,
  spirituality;

  String labelEn() {
    switch (this) {
      case LifeArea.health:
        return 'Health';
      case LifeArea.career:
        return 'Career';
      case LifeArea.finances:
        return 'Finances';
      case LifeArea.relationships:
        return 'Relationships';
      case LifeArea.fun:
        return 'Fun & Recreation';
      case LifeArea.growth:
        return 'Personal Growth';
      case LifeArea.environment:
        return 'Environment';
      case LifeArea.spirituality:
        return 'Spirituality';
    }
  }

  String labelTr() {
    switch (this) {
      case LifeArea.health:
        return 'Sa\u011fl\u0131k';
      case LifeArea.career:
        return 'Kariyer';
      case LifeArea.finances:
        return 'Finans';
      case LifeArea.relationships:
        return '\u0130li\u015fkiler';
      case LifeArea.fun:
        return 'E\u011flence';
      case LifeArea.growth:
        return 'Ki\u015fisel Geli\u015fim';
      case LifeArea.environment:
        return '\u00c7evre';
      case LifeArea.spirituality:
        return 'Maneviyat';
    }
  }

  String label(bool isEn) => isEn ? labelEn() : labelTr();

  String get emoji {
    switch (this) {
      case LifeArea.health:
        return '\u{1F49A}';
      case LifeArea.career:
        return '\u{1F4BC}';
      case LifeArea.finances:
        return '\u{1F4B0}';
      case LifeArea.relationships:
        return '\u{1F91D}';
      case LifeArea.fun:
        return '\u{1F3A8}';
      case LifeArea.growth:
        return '\u{1F331}';
      case LifeArea.environment:
        return '\u{1F3E1}';
      case LifeArea.spirituality:
        return '\u{2728}';
    }
  }
}

class LifeWheelEntry {
  final String id;
  final Map<LifeArea, int> scores; // 1-10 for each area
  final String? note;
  final DateTime createdAt;

  const LifeWheelEntry({
    required this.id,
    required this.scores,
    this.note,
    required this.createdAt,
  });

  double get averageScore {
    if (scores.isEmpty) return 0;
    return scores.values.reduce((a, b) => a + b) / scores.length;
  }

  LifeArea get lowestArea {
    if (scores.isEmpty) return LifeArea.values.first;
    return scores.entries.reduce((a, b) => a.value <= b.value ? a : b).key;
  }

  LifeArea get highestArea {
    if (scores.isEmpty) return LifeArea.values.first;
    return scores.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'scores': scores.map((k, v) => MapEntry(k.name, v)),
        'note': note,
        'createdAt': createdAt.toIso8601String(),
      };

  factory LifeWheelEntry.fromJson(Map<String, dynamic> json) {
    final rawScores = json['scores'] as Map<String, dynamic>;
    final scoresMap = <LifeArea, int>{};
    for (final entry in rawScores.entries) {
      final area = LifeArea.values.where((a) => a.name == entry.key).firstOrNull;
      if (area != null) {
        scoresMap[area] = entry.value as int;
      }
    }
    return LifeWheelEntry(
      id: json['id'] as String,
      scores: scoresMap,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
