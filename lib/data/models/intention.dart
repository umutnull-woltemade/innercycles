// ════════════════════════════════════════════════════════════════════════════
// INTENTION MODEL - Weekly personal intention with self-rating
// ════════════════════════════════════════════════════════════════════════════

class Intention {
  final String id;
  final String text;
  final String weekKey; // e.g. "2026-W09"
  final int? selfRating; // 1-5, null = not yet rated
  final bool isActive;
  final DateTime createdAt;

  const Intention({
    required this.id,
    required this.text,
    required this.weekKey,
    this.selfRating,
    this.isActive = true,
    required this.createdAt,
  });

  Intention copyWith({
    int? selfRating,
    bool? isActive,
  }) {
    return Intention(
      id: id,
      text: text,
      weekKey: weekKey,
      selfRating: selfRating ?? this.selfRating,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'weekKey': weekKey,
        'selfRating': selfRating,
        'isActive': isActive,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Intention.fromJson(Map<String, dynamic> json) => Intention(
        id: json['id'] as String? ?? '',
        text: json['text'] as String? ?? '',
        weekKey: json['weekKey'] as String? ?? '',
        selfRating: json['selfRating'] as int?,
        isActive: json['isActive'] as bool? ?? true,
        createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      );
}
