import 'quiz_models.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';

/// Quiz Service - Quiz içerikleri ve segment hesaplama
class QuizService {
  QuizService._();

  /// Quiz tipine göre quiz getir
  static Quiz getQuiz(String type, AppLanguage language) {
    switch (type) {
      case 'dream':
        return _getDreamQuiz(language);
      case 'astrology':
        return _getAstrologyQuiz(language);
      case 'numerology':
        return _getNumerologyQuiz(language);
      default:
        return _getGeneralQuiz(language);
    }
  }

  /// Cevaplara göre sonuç hesapla
  static QuizResult calculateResult(Quiz quiz, Map<int, int> answers, AppLanguage language) {
    int totalScore = 0;
    int maxPossibleScore = quiz.questions.length * 5;

    for (var entry in answers.entries) {
      final questionIndex = entry.key;
      final answerIndex = entry.value;

      if (questionIndex < quiz.questions.length) {
        final question = quiz.questions[questionIndex];
        if (answerIndex < question.answers.length) {
          totalScore += question.answers[answerIndex].weight;
        }
      }
    }

    // Segment hesapla
    final percentage = (totalScore / maxPossibleScore) * 100;
    QuizSegment segment;
    if (percentage >= 70) {
      segment = QuizSegment.high;
    } else if (percentage >= 40) {
      segment = QuizSegment.medium;
    } else {
      segment = QuizSegment.low;
    }

    // Quiz tipine göre sonuç döndür
    return _getResultForSegment(quiz.type, segment, totalScore, language);
  }

  static QuizResult _getResultForSegment(
    QuizType type,
    QuizSegment segment,
    int score,
    AppLanguage language,
  ) {
    switch (type) {
      case QuizType.dream:
        return _getDreamResult(segment, score, language);
      case QuizType.astrology:
        return _getAstrologyResult(segment, score, language);
      case QuizType.numerology:
        return _getNumerologyResult(segment, score, language);
      default:
        return _getGeneralResult(segment, score, language);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // RÜYA QUIZ'İ
  // ═══════════════════════════════════════════════════════════════

  static Quiz _getDreamQuiz(AppLanguage language) {
    return Quiz(
      id: 'dream_insight',
      title: L10nService.get('quiz.dream_title', language),
      description: L10nService.get('quiz.dream_description', language),
      type: QuizType.dream,
      questions: [
        QuizQuestion(
          text: L10nService.get('quiz.dream_q1', language),
          emoji: '💭',
          answers: [
            QuizAnswer(text: L10nService.get('quiz.dream_a1_1', language), emoji: '🌟', weight: 5),
            QuizAnswer(text: L10nService.get('quiz.dream_a1_2', language), emoji: '✨', weight: 4),
            QuizAnswer(text: L10nService.get('quiz.dream_a1_3', language), emoji: '🌙', weight: 2),
            QuizAnswer(text: L10nService.get('quiz.dream_a1_4', language), emoji: '😴', weight: 1),
          ],
        ),
        QuizQuestion(
          text: L10nService.get('quiz.dream_q2', language),
          emoji: '🎭',
          answers: [
            QuizAnswer(text: L10nService.get('quiz.dream_a2_1', language), emoji: '💫', weight: 5),
            QuizAnswer(text: L10nService.get('quiz.dream_a2_2', language), emoji: '🔍', weight: 4),
            QuizAnswer(text: L10nService.get('quiz.dream_a2_3', language), emoji: '🌓', weight: 3),
            QuizAnswer(text: L10nService.get('quiz.dream_a2_4', language), emoji: '😐', weight: 1),
          ],
        ),
        QuizQuestion(
          text: L10nService.get('quiz.dream_q3', language),
          emoji: '🔄',
          answers: [
            QuizAnswer(text: L10nService.get('quiz.dream_a3_1', language), emoji: '🔮', weight: 5),
            QuizAnswer(text: L10nService.get('quiz.dream_a3_2', language), emoji: '🌀', weight: 3),
            QuizAnswer(text: L10nService.get('quiz.dream_a3_3', language), emoji: '💫', weight: 2),
            QuizAnswer(text: L10nService.get('quiz.dream_a3_4', language), emoji: '❌', weight: 1),
          ],
        ),
        QuizQuestion(
          text: L10nService.get('quiz.dream_q4', language),
          emoji: '🧩',
          answers: [
            QuizAnswer(text: L10nService.get('quiz.dream_a4_1', language), emoji: '🔥', weight: 5),
            QuizAnswer(text: L10nService.get('quiz.dream_a4_2', language), emoji: '📚', weight: 4),
            QuizAnswer(text: L10nService.get('quiz.dream_a4_3', language), emoji: '🤔', weight: 2),
            QuizAnswer(text: L10nService.get('quiz.dream_a4_4', language), emoji: '🤷', weight: 1),
          ],
        ),
      ],
    );
  }

  static QuizResult _getDreamResult(QuizSegment segment, int score, AppLanguage language) {
    switch (segment) {
      case QuizSegment.high:
        return QuizResult(
          title: L10nService.get('quiz.result_dream_high_title', language),
          description: L10nService.get('quiz.result_dream_high_desc', language),
          emoji: '🔮',
          segment: segment,
          score: score,
          recommendedRoute: '/dream-interpretation',
        );
      case QuizSegment.medium:
        return QuizResult(
          title: L10nService.get('quiz.result_dream_medium_title', language),
          description: L10nService.get('quiz.result_dream_medium_desc', language),
          emoji: '🌙',
          segment: segment,
          score: score,
        );
      case QuizSegment.low:
        return QuizResult(
          title: L10nService.get('quiz.result_dream_low_title', language),
          description: L10nService.get('quiz.result_dream_low_desc', language),
          emoji: '💤',
          segment: segment,
          score: score,
        );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // ASTROLOJİ QUIZ'İ
  // ═══════════════════════════════════════════════════════════════

  static Quiz _getAstrologyQuiz(AppLanguage language) {
    return Quiz(
      id: 'astro_insight',
      title: L10nService.get('quiz.astrology_title', language),
      description: L10nService.get('quiz.astrology_description', language),
      type: QuizType.astrology,
      questions: [
        QuizQuestion(
          text: L10nService.get('quiz.astrology_q1', language),
          emoji: '⭐',
          answers: [
            QuizAnswer(text: L10nService.get('quiz.astrology_a1_1', language), emoji: '🌟', weight: 5),
            QuizAnswer(text: L10nService.get('quiz.astrology_a1_2', language), emoji: '✨', weight: 4),
            QuizAnswer(text: L10nService.get('quiz.astrology_a1_3', language), emoji: '🌙', weight: 2),
            QuizAnswer(text: L10nService.get('quiz.astrology_a1_4', language), emoji: '💫', weight: 1),
          ],
        ),
        QuizQuestion(
          text: L10nService.get('quiz.astrology_q2', language),
          emoji: '🗺️',
          answers: [
            QuizAnswer(text: L10nService.get('quiz.astrology_a2_1', language), emoji: '📊', weight: 5),
            QuizAnswer(text: L10nService.get('quiz.astrology_a2_2', language), emoji: '☀️', weight: 4),
            QuizAnswer(text: L10nService.get('quiz.astrology_a2_3', language), emoji: '♈', weight: 2),
            QuizAnswer(text: L10nService.get('quiz.astrology_a2_4', language), emoji: '🤷', weight: 1),
          ],
        ),
        QuizQuestion(
          text: L10nService.get('quiz.astrology_q3', language),
          emoji: '🔄',
          answers: [
            QuizAnswer(text: L10nService.get('quiz.astrology_a3_1', language), emoji: '⚠️', weight: 5),
            QuizAnswer(text: L10nService.get('quiz.astrology_a3_2', language), emoji: '👀', weight: 3),
            QuizAnswer(text: L10nService.get('quiz.astrology_a3_3', language), emoji: '🤔', weight: 2),
            QuizAnswer(text: L10nService.get('quiz.astrology_a3_4', language), emoji: '❓', weight: 1),
          ],
        ),
      ],
    );
  }

  static QuizResult _getAstrologyResult(QuizSegment segment, int score, AppLanguage language) {
    switch (segment) {
      case QuizSegment.high:
        return QuizResult(
          title: L10nService.get('quiz.result_astrology_high_title', language),
          description: L10nService.get('quiz.result_astrology_high_desc', language),
          emoji: '🌟',
          segment: segment,
          score: score,
          recommendedRoute: '/birth-chart',
        );
      case QuizSegment.medium:
        return QuizResult(
          title: L10nService.get('quiz.result_astrology_medium_title', language),
          description: L10nService.get('quiz.result_astrology_medium_desc', language),
          emoji: '⭐',
          segment: segment,
          score: score,
        );
      case QuizSegment.low:
        return QuizResult(
          title: L10nService.get('quiz.result_astrology_low_title', language),
          description: L10nService.get('quiz.result_astrology_low_desc', language),
          emoji: '✨',
          segment: segment,
          score: score,
        );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // NUMEROLOJİ QUIZ'İ
  // ═══════════════════════════════════════════════════════════════

  static Quiz _getNumerologyQuiz(AppLanguage language) {
    return Quiz(
      id: 'number_insight',
      title: L10nService.get('quiz.numerology_title', language),
      description: L10nService.get('quiz.numerology_description', language),
      type: QuizType.numerology,
      questions: [
        QuizQuestion(
          text: L10nService.get('quiz.numerology_q1', language),
          emoji: '🔢',
          answers: [
            QuizAnswer(text: L10nService.get('quiz.numerology_a1_1', language), emoji: '1️⃣', weight: 5),
            QuizAnswer(text: L10nService.get('quiz.numerology_a1_2', language), emoji: '👀', weight: 3),
            QuizAnswer(text: L10nService.get('quiz.numerology_a1_3', language), emoji: '🤔', weight: 2),
            QuizAnswer(text: L10nService.get('quiz.numerology_a1_4', language), emoji: '🤷', weight: 1),
          ],
        ),
        QuizQuestion(
          text: L10nService.get('quiz.numerology_q2', language),
          emoji: '🛤️',
          answers: [
            QuizAnswer(text: L10nService.get('quiz.numerology_a2_1', language), emoji: '📖', weight: 5),
            QuizAnswer(text: L10nService.get('quiz.numerology_a2_2', language), emoji: '🔍', weight: 3),
            QuizAnswer(text: L10nService.get('quiz.numerology_a2_3', language), emoji: '💭', weight: 2),
            QuizAnswer(text: L10nService.get('quiz.numerology_a2_4', language), emoji: '❓', weight: 1),
          ],
        ),
        QuizQuestion(
          text: L10nService.get('quiz.numerology_q3', language),
          emoji: '📅',
          answers: [
            QuizAnswer(text: L10nService.get('quiz.numerology_a3_1', language), emoji: '✅', weight: 5),
            QuizAnswer(text: L10nService.get('quiz.numerology_a3_2', language), emoji: '🤔', weight: 3),
            QuizAnswer(text: L10nService.get('quiz.numerology_a3_3', language), emoji: '🌙', weight: 2),
            QuizAnswer(text: L10nService.get('quiz.numerology_a3_4', language), emoji: '❌', weight: 1),
          ],
        ),
      ],
    );
  }

  static QuizResult _getNumerologyResult(QuizSegment segment, int score, AppLanguage language) {
    switch (segment) {
      case QuizSegment.high:
        return QuizResult(
          title: L10nService.get('quiz.result_numerology_high_title', language),
          description: L10nService.get('quiz.result_numerology_high_desc', language),
          emoji: '🔢',
          segment: segment,
          score: score,
          recommendedRoute: '/numerology',
        );
      case QuizSegment.medium:
        return QuizResult(
          title: L10nService.get('quiz.result_numerology_medium_title', language),
          description: L10nService.get('quiz.result_numerology_medium_desc', language),
          emoji: '🔮',
          segment: segment,
          score: score,
        );
      case QuizSegment.low:
        return QuizResult(
          title: L10nService.get('quiz.result_numerology_low_title', language),
          description: L10nService.get('quiz.result_numerology_low_desc', language),
          emoji: '✨',
          segment: segment,
          score: score,
        );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // GENEL QUIZ
  // ═══════════════════════════════════════════════════════════════

  static Quiz _getGeneralQuiz(AppLanguage language) {
    return Quiz(
      id: 'cosmic_profile',
      title: L10nService.get('quiz.general_title', language),
      description: L10nService.get('quiz.general_description', language),
      type: QuizType.general,
      questions: [
        QuizQuestion(
          text: L10nService.get('quiz.general_q1', language),
          emoji: '🧘',
          answers: [
            QuizAnswer(text: L10nService.get('quiz.general_a1_1', language), emoji: '🕯️', weight: 5),
            QuizAnswer(text: L10nService.get('quiz.general_a1_2', language), emoji: '🌿', weight: 4),
            QuizAnswer(text: L10nService.get('quiz.general_a1_3', language), emoji: '💕', weight: 3),
            QuizAnswer(text: L10nService.get('quiz.general_a1_4', language), emoji: '🏃', weight: 2),
          ],
        ),
        QuizQuestion(
          text: L10nService.get('quiz.general_q2', language),
          emoji: '🔮',
          answers: [
            QuizAnswer(text: L10nService.get('quiz.general_a2_1', language), emoji: '💫', weight: 5),
            QuizAnswer(text: L10nService.get('quiz.general_a2_2', language), emoji: '👂', weight: 4),
            QuizAnswer(text: L10nService.get('quiz.general_a2_3', language), emoji: '🤔', weight: 2),
            QuizAnswer(text: L10nService.get('quiz.general_a2_4', language), emoji: '🧠', weight: 1),
          ],
        ),
        QuizQuestion(
          text: L10nService.get('quiz.general_q3', language),
          emoji: '✨',
          answers: [
            QuizAnswer(text: L10nService.get('quiz.general_a3_1', language), emoji: '📿', weight: 5),
            QuizAnswer(text: L10nService.get('quiz.general_a3_2', language), emoji: '📚', weight: 4),
            QuizAnswer(text: L10nService.get('quiz.general_a3_3', language), emoji: '🌙', weight: 2),
            QuizAnswer(text: L10nService.get('quiz.general_a3_4', language), emoji: '🤷', weight: 1),
          ],
        ),
        QuizQuestion(
          text: L10nService.get('quiz.general_q4', language),
          emoji: '🎯',
          answers: [
            QuizAnswer(text: L10nService.get('quiz.general_a4_1', language), emoji: '🌟', weight: 5),
            QuizAnswer(text: L10nService.get('quiz.general_a4_2', language), emoji: '☮️', weight: 4),
            QuizAnswer(text: L10nService.get('quiz.general_a4_3', language), emoji: '💗', weight: 3),
            QuizAnswer(text: L10nService.get('quiz.general_a4_4', language), emoji: '🏆', weight: 2),
          ],
        ),
      ],
    );
  }

  static QuizResult _getGeneralResult(QuizSegment segment, int score, AppLanguage language) {
    switch (segment) {
      case QuizSegment.high:
        return QuizResult(
          title: L10nService.get('quiz.result_general_high_title', language),
          description: L10nService.get('quiz.result_general_high_desc', language),
          emoji: '🌟',
          segment: segment,
          score: score,
          recommendedRoute: '/kozmoz',
        );
      case QuizSegment.medium:
        return QuizResult(
          title: L10nService.get('quiz.result_general_medium_title', language),
          description: L10nService.get('quiz.result_general_medium_desc', language),
          emoji: '🚀',
          segment: segment,
          score: score,
        );
      case QuizSegment.low:
        return QuizResult(
          title: L10nService.get('quiz.result_general_low_title', language),
          description: L10nService.get('quiz.result_general_low_desc', language),
          emoji: '🌱',
          segment: segment,
          score: score,
        );
    }
  }
}
