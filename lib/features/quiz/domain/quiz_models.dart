/// Quiz Segmentation Models
/// Model classes for Google Discover -> Quiz -> Premium funnel
library;

/// Quiz segmentation - user's likelihood of premium conversion
enum QuizSegment {
  low, // Low - Soft CTA or skip
  medium, // Medium - Normal premium offer
  high, // High - Aggressive premium offer (30-40% conversion target)
}

/// Quiz type
enum QuizType {
  dream, // Dream interpretation quiz
  astrology, // Astrology quiz
  numerology, // Numerology quiz
  general, // General discovery quiz
  personality, // Personality test
}

/// Single quiz answer
class QuizAnswer {
  final String text;
  final String? emoji;
  final int weight; // Weight for segment calculation (1-5)
  final Map<String, dynamic>? metadata;

  const QuizAnswer({
    required this.text,
    this.emoji,
    this.weight = 3,
    this.metadata,
  });
}

/// Single quiz question
class QuizQuestion {
  final String text;
  final String? emoji;
  final List<QuizAnswer> answers;
  final String? hint;

  const QuizQuestion({
    required this.text,
    this.emoji,
    required this.answers,
    this.hint,
  });
}

/// Quiz result
class QuizResult {
  final String title;
  final String description;
  final String emoji;
  final QuizSegment segment;
  final int score;
  final Map<String, dynamic>? insights;
  final String? recommendedRoute; // Post-premium redirect

  const QuizResult({
    required this.title,
    required this.description,
    required this.emoji,
    required this.segment,
    required this.score,
    this.insights,
    this.recommendedRoute,
  });
}

/// Complete quiz structure
class Quiz {
  final String id;
  final String title;
  final String description;
  final QuizType type;
  final List<QuizQuestion> questions;
  final String? coverImage; // Discover cover image
  final Map<String, dynamic>? metadata;

  const Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.questions,
    this.coverImage,
    this.metadata,
  });

  int get questionCount => questions.length;
}

/// Quiz CTA content - displayed on pages
class QuizCTA {
  final String headline;
  final String subtext;
  final String buttonText;
  final String quizType;
  final String? emoji;

  const QuizCTA({
    required this.headline,
    required this.subtext,
    required this.buttonText,
    required this.quizType,
    this.emoji,
  });

  /// Default CTA for dream page
  /// Note: Actual text comes from L10nService via quiz.cta.* keys
  static const QuizCTA dream = QuizCTA(
    headline: 'quiz.cta.dream_headline',
    subtext: 'quiz.cta.dream_subtext',
    buttonText: 'quiz.cta.dream_button',
    quizType: 'dream',
    emoji: '🔮',
  );

  /// CTA for astrology page
  /// Note: Actual text comes from L10nService via quiz.cta.* keys
  static const QuizCTA astrology = QuizCTA(
    headline: 'quiz.cta.astrology_headline',
    subtext: 'quiz.cta.astrology_subtext',
    buttonText: 'quiz.cta.astrology_button',
    quizType: 'astrology',
    emoji: '⭐',
  );

  /// CTA for numerology page
  /// Note: Actual text comes from L10nService via quiz.cta.* keys
  static const QuizCTA numerology = QuizCTA(
    headline: 'quiz.cta.numerology_headline',
    subtext: 'quiz.cta.numerology_subtext',
    buttonText: 'quiz.cta.numerology_button',
    quizType: 'numerology',
    emoji: '🔢',
  );

  /// General discovery CTA
  /// Note: Actual text comes from L10nService via quiz.cta.* keys
  static const QuizCTA general = QuizCTA(
    headline: 'quiz.cta.general_headline',
    subtext: 'quiz.cta.general_subtext',
    buttonText: 'quiz.cta.general_button',
    quizType: 'general',
    emoji: '✨',
  );
}
