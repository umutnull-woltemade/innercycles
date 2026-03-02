// ════════════════════════════════════════════════════════════════════════════
// GROWTH LETTER MODEL - Reflective letters to past/future self
// ════════════════════════════════════════════════════════════════════════════

import 'package:uuid/uuid.dart';

enum LetterType {
  toFutureSelf,
  toPastSelf,
  growthMilestone,
  gratitudeLetter;

  String nameEn() {
    switch (this) {
      case toFutureSelf:
        return 'To Future Self';
      case toPastSelf:
        return 'To Past Self';
      case growthMilestone:
        return 'Growth Milestone';
      case gratitudeLetter:
        return 'Gratitude Letter';
    }
  }

  String nameTr() {
    switch (this) {
      case toFutureSelf:
        return 'Gelecek Benime';
      case toPastSelf:
        return 'Ge\u00e7mi\u015f Benime';
      case growthMilestone:
        return 'B\u00fcy\u00fcme Kilometre Ta\u015f\u0131';
      case gratitudeLetter:
        return '\u015e\u00fckran Mektubu';
    }
  }

  String get emoji {
    switch (this) {
      case toFutureSelf:
        return '\u{1F4E8}';
      case toPastSelf:
        return '\u{1F4DC}';
      case growthMilestone:
        return '\u{1F3C6}';
      case gratitudeLetter:
        return '\u{1F49D}';
    }
  }
}

class GrowthLetter {
  final String id;
  final LetterType letterType;
  final String title;
  final String body;
  final DateTime createdAt;

  GrowthLetter({
    String? id,
    required this.letterType,
    required this.title,
    required this.body,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  GrowthLetter copyWith({String? title, String? body}) {
    return GrowthLetter(
      id: id,
      letterType: letterType,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'letterType': letterType.name,
        'title': title,
        'body': body,
        'createdAt': createdAt.toIso8601String(),
      };

  factory GrowthLetter.fromJson(Map<String, dynamic> json) {
    return GrowthLetter(
      id: json['id'] as String,
      letterType: LetterType.values.firstWhere(
        (t) => t.name == json['letterType'],
        orElse: () => LetterType.toFutureSelf,
      ),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  int get wordCount =>
      body.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
}
