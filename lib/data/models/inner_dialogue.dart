// ════════════════════════════════════════════════════════════════════════════
// INNER DIALOGUE MODEL - Heart vs Mind dual-perspective journaling
// ════════════════════════════════════════════════════════════════════════════

import 'package:uuid/uuid.dart';

enum DialoguePerspective {
  heartMind,
  pastFuture,
  fearCourage,
  innerCritic;

  String labelLeftEn() {
    switch (this) {
      case heartMind:
        return 'Heart';
      case pastFuture:
        return 'Past Self';
      case fearCourage:
        return 'Fear';
      case innerCritic:
        return 'Inner Critic';
    }
  }

  String labelRightEn() {
    switch (this) {
      case heartMind:
        return 'Mind';
      case pastFuture:
        return 'Future Self';
      case fearCourage:
        return 'Courage';
      case innerCritic:
        return 'Compassionate Self';
    }
  }

  String labelLeftTr() {
    switch (this) {
      case heartMind:
        return 'Kalp';
      case pastFuture:
        return 'Geçmiş Ben';
      case fearCourage:
        return 'Korku';
      case innerCritic:
        return 'İç Eleştirmen';
    }
  }

  String labelRightTr() {
    switch (this) {
      case heartMind:
        return 'Akıl';
      case pastFuture:
        return 'Gelecek Ben';
      case fearCourage:
        return 'Cesaret';
      case innerCritic:
        return 'Şefkatli Ben';
    }
  }

  String get emoji {
    switch (this) {
      case heartMind:
        return '\u{2764}\u{FE0F}';
      case pastFuture:
        return '\u{23F3}';
      case fearCourage:
        return '\u{1F525}';
      case innerCritic:
        return '\u{1F33F}';
    }
  }
}

class InnerDialogue {
  final String id;
  final DialoguePerspective perspective;
  final String leftText;
  final String rightText;
  final String? topic;
  final DateTime createdAt;

  InnerDialogue({
    String? id,
    required this.perspective,
    this.leftText = '',
    this.rightText = '',
    this.topic,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  InnerDialogue copyWith({
    String? leftText,
    String? rightText,
    String? topic,
  }) {
    return InnerDialogue(
      id: id,
      perspective: perspective,
      leftText: leftText ?? this.leftText,
      rightText: rightText ?? this.rightText,
      topic: topic ?? this.topic,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'perspective': perspective.name,
        'leftText': leftText,
        'rightText': rightText,
        'topic': topic,
        'createdAt': createdAt.toIso8601String(),
      };

  factory InnerDialogue.fromJson(Map<String, dynamic> json) {
    return InnerDialogue(
      id: json['id'] as String,
      perspective: DialoguePerspective.values.firstWhere(
        (p) => p.name == json['perspective'],
        orElse: () => DialoguePerspective.heartMind,
      ),
      leftText: json['leftText'] as String? ?? '',
      rightText: json['rightText'] as String? ?? '',
      topic: json['topic'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  bool get isEmpty => leftText.trim().isEmpty && rightText.trim().isEmpty;
  int get totalWords =>
      leftText.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length +
      rightText.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
}
