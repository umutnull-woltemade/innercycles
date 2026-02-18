// ════════════════════════════════════════════════════════════════════════════
// QUIZ ENGINE MODELS - InnerCycles Generic Quiz System
// ════════════════════════════════════════════════════════════════════════════
// Reusable data models for any self-reflection quiz in the app.
// Supports categorical, spectrum, and multi-dimension scoring.
//
// IMPORTANT: All quizzes are self-reflection tools for personal awareness,
// NOT clinical diagnostic instruments.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:ui';

// ════════════════════════════════════════════════════════════════════════════
// SCORING TYPE
// ════════════════════════════════════════════════════════════════════════════

/// How a quiz calculates its final result
enum QuizScoringType {
  /// Highest-score dimension wins (e.g. attachment style, dream personality)
  categorical,

  /// Single-axis left-to-right (e.g. introvert <-> extrovert)
  spectrum,

  /// Multiple independent dimensions each get a score (e.g. EQ breakdown)
  multiDimension,
}

// ════════════════════════════════════════════════════════════════════════════
// QUIZ DEFINITION
// ════════════════════════════════════════════════════════════════════════════

/// The full definition of a quiz: metadata + questions + scoring rules
class QuizDefinition {
  final String id;
  final String title;
  final String titleTr;
  final String description;
  final String descriptionTr;
  final String emoji;
  final List<QuizQuestion> questions;
  final QuizScoringType scoringType;

  /// Maps dimension keys to display metadata (name, color, emoji, descriptions)
  final Map<String, QuizDimensionMeta> dimensions;

  const QuizDefinition({
    required this.id,
    required this.title,
    required this.titleTr,
    required this.description,
    required this.descriptionTr,
    required this.emoji,
    required this.questions,
    required this.scoringType,
    required this.dimensions,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// QUIZ QUESTION
// ════════════════════════════════════════════════════════════════════════════

/// A single quiz question with localized text and scored options
class QuizQuestion {
  final String text;
  final String textTr;
  final List<QuizOption> options;

  /// Optional category tag for grouping (e.g. "empathy", "regulation")
  final String? category;

  const QuizQuestion({
    required this.text,
    required this.textTr,
    required this.options,
    this.category,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// QUIZ OPTION
// ════════════════════════════════════════════════════════════════════════════

/// A single answer option; scores maps dimension key -> point value
class QuizOption {
  final String text;
  final String textTr;

  /// Maps dimension key (e.g. "introvert", "empathy") to point value
  final Map<String, int> scores;

  const QuizOption({
    required this.text,
    required this.textTr,
    required this.scores,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// DIMENSION METADATA
// ════════════════════════════════════════════════════════════════════════════

/// Display metadata for a scoring dimension
class QuizDimensionMeta {
  final String key;
  final String nameEn;
  final String nameTr;
  final String emoji;
  final Color color;
  final String descriptionEn;
  final String descriptionTr;
  final List<String> strengthsEn;
  final List<String> strengthsTr;
  final List<String> growthAreasEn;
  final List<String> growthAreasTr;

  const QuizDimensionMeta({
    required this.key,
    required this.nameEn,
    required this.nameTr,
    required this.emoji,
    required this.color,
    required this.descriptionEn,
    required this.descriptionTr,
    this.strengthsEn = const [],
    this.strengthsTr = const [],
    this.growthAreasEn = const [],
    this.growthAreasTr = const [],
  });
}

// ════════════════════════════════════════════════════════════════════════════
// QUIZ RESULT
// ════════════════════════════════════════════════════════════════════════════

/// Stores the outcome of a completed quiz
class QuizResult {
  final String quizId;

  /// Raw scores per dimension
  final Map<String, int> scores;

  /// Normalized 0.0–1.0 percentages per dimension
  final Map<String, double> percentages;

  /// The winning dimension key (highest score)
  final String resultType;

  final DateTime completedAt;

  const QuizResult({
    required this.quizId,
    required this.scores,
    required this.percentages,
    required this.resultType,
    required this.completedAt,
  });

  /// Serialize to JSON for SharedPreferences storage
  Map<String, dynamic> toJson() => {
        'quizId': quizId,
        'scores': scores,
        'percentages': percentages,
        'resultType': resultType,
        'completedAt': completedAt.toIso8601String(),
      };

  /// Deserialize from JSON
  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      quizId: json['quizId'] as String,
      scores: Map<String, int>.from(json['scores'] as Map),
      percentages: (json['percentages'] as Map).map(
        (key, value) => MapEntry(key as String, (value as num).toDouble()),
      ),
      resultType: json['resultType'] as String,
      completedAt: DateTime.tryParse(json['completedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  /// Get percentage for a specific dimension, defaulting to 0
  double percentageFor(String dimension) => percentages[dimension] ?? 0.0;
}
