/// Insight Response Service - Safe Reflection Response Generation
/// Generates Apple-safe, non-predictive, reflective responses
/// Strictly reflective language only - no predictions
library;

import 'dart:math';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';
import 'insight_routing_service.dart';

/// Service for generating safe, reflective responses
class InsightResponseService {
  final Random _random = Random();

  /// Generate a safe, reflective response based on input type
  String generateResponse({
    required String userMessage,
    required InsightType insightType,
    required AppLanguage language,
    String? userName,
  }) {
    switch (insightType) {
      case InsightType.dreamReflection:
        return _getDreamReflectionResponse(userMessage, language);
      case InsightType.patternAwareness:
        return _getPatternAwarenessResponse(userMessage, language);
      case InsightType.emotionalExplore:
        return _getEmotionalExploreResponse(userMessage, language);
      case InsightType.decisionSupport:
        return _getDecisionSupportResponse(userMessage, language);
      case InsightType.relationshipReflection:
        return _getRelationshipResponse(userMessage, language);
      case InsightType.selfDiscovery:
        return _getSelfDiscoveryResponse(userMessage, language);
      case InsightType.generalReflection:
        return _getGeneralResponse(userMessage, language);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DREAM REFLECTION - Safe, non-predictive dream exploration
  // ═══════════════════════════════════════════════════════════════════════════

  String _getDreamReflectionResponse(String message, AppLanguage language) {
    final lower = message.toLowerCase();

    // Detect specific dream themes
    if (_containsAny(lower, [
      'fall',
      'falling',
      'düşmek',
      'dusmek',
      'düşüyorum',
    ])) {
      return _getFallingDreamResponse(language);
    }
    if (_containsAny(lower, [
      'water',
      'ocean',
      'sea',
      'swim',
      'su',
      'deniz',
      'yüzmek',
    ])) {
      return _getWaterDreamResponse(language);
    }
    if (_containsAny(lower, ['fly', 'flying', 'uçmak', 'ucmak', 'uçuyorum'])) {
      return _getFlyingDreamResponse(language);
    }
    if (_containsAny(lower, [
      'chase',
      'chased',
      'running',
      'kovalanmak',
      'kaçmak',
      'kacmak',
    ])) {
      return _getChaseDreamResponse(language);
    }
    if (_containsAny(lower, ['teeth', 'tooth', 'diş', 'dis', 'dişler'])) {
      return _getTeethDreamResponse(language);
    }

    return _getGeneralDreamResponse(language);
  }

  String _getFallingDreamResponse(AppLanguage language) {
    return L10nService.get('insight.responses.dream_falling', language);
  }

  String _getWaterDreamResponse(AppLanguage language) {
    return L10nService.get('insight.responses.dream_water', language);
  }

  String _getFlyingDreamResponse(AppLanguage language) {
    return L10nService.get('insight.responses.dream_flying', language);
  }

  String _getChaseDreamResponse(AppLanguage language) {
    return L10nService.get('insight.responses.dream_chase', language);
  }

  String _getTeethDreamResponse(AppLanguage language) {
    return L10nService.get('insight.responses.dream_teeth', language);
  }

  String _getGeneralDreamResponse(AppLanguage language) {
    final responses = [
      L10nService.get('insight.responses.dream_general_1', language),
      L10nService.get('insight.responses.dream_general_2', language),
    ];
    return responses[_random.nextInt(responses.length)];
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PATTERN AWARENESS - Recognizing recurring themes
  // ═══════════════════════════════════════════════════════════════════════════

  String _getPatternAwarenessResponse(String message, AppLanguage language) {
    final responses = [
      L10nService.get('insight.responses.pattern_1', language),
      L10nService.get('insight.responses.pattern_2', language),
    ];
    return responses[_random.nextInt(responses.length)];
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EMOTIONAL EXPLORATION - Supporting feeling exploration
  // ═══════════════════════════════════════════════════════════════════════════

  String _getEmotionalExploreResponse(String message, AppLanguage language) {
    final lower = message.toLowerCase();

    // Detect specific emotions
    if (_containsAny(lower, [
      'anxious',
      'anxiety',
      'worried',
      'kaygı',
      'endişe',
      'tedirgin',
    ])) {
      return _getAnxietyResponse(language);
    }
    if (_containsAny(lower, [
      'sad',
      'depressed',
      'down',
      'üzgün',
      'mutsuz',
      'kötü',
    ])) {
      return _getSadnessResponse(language);
    }
    if (_containsAny(lower, [
      'angry',
      'frustrated',
      'mad',
      'kızgın',
      'sinirli',
      'öfkeli',
    ])) {
      return _getAngerResponse(language);
    }
    if (_containsAny(lower, [
      'overwhelmed',
      'stressed',
      'burnout',
      'bunalmış',
      'stresli',
      'tükenmiş',
    ])) {
      return _getOverwhelmedResponse(language);
    }

    return _getGeneralEmotionResponse(language);
  }

  String _getAnxietyResponse(AppLanguage language) {
    return L10nService.get('insight.responses.emotion_anxiety', language);
  }

  String _getSadnessResponse(AppLanguage language) {
    return L10nService.get('insight.responses.emotion_sadness', language);
  }

  String _getAngerResponse(AppLanguage language) {
    return L10nService.get('insight.responses.emotion_anger', language);
  }

  String _getOverwhelmedResponse(AppLanguage language) {
    return L10nService.get('insight.responses.emotion_overwhelmed', language);
  }

  String _getGeneralEmotionResponse(AppLanguage language) {
    return L10nService.get('insight.responses.emotion_general', language);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DECISION SUPPORT - Perspective without advice
  // ═══════════════════════════════════════════════════════════════════════════

  String _getDecisionSupportResponse(String message, AppLanguage language) {
    final responses = [
      L10nService.get('insight.responses.decision_1', language),
      L10nService.get('insight.responses.decision_2', language),
    ];
    return responses[_random.nextInt(responses.length)];
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RELATIONSHIP REFLECTION
  // ═══════════════════════════════════════════════════════════════════════════

  String _getRelationshipResponse(String message, AppLanguage language) {
    final responses = [
      L10nService.get('insight.responses.relationship_1', language),
      L10nService.get('insight.responses.relationship_2', language),
    ];
    return responses[_random.nextInt(responses.length)];
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SELF-DISCOVERY
  // ═══════════════════════════════════════════════════════════════════════════

  String _getSelfDiscoveryResponse(String message, AppLanguage language) {
    final responses = [
      L10nService.get('insight.responses.self_discovery_1', language),
      L10nService.get('insight.responses.self_discovery_2', language),
    ];
    return responses[_random.nextInt(responses.length)];
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // GENERAL REFLECTION
  // ═══════════════════════════════════════════════════════════════════════════

  String _getGeneralResponse(String message, AppLanguage language) {
    final responses = [
      L10nService.get('insight.responses.general_1', language),
      L10nService.get('insight.responses.general_2', language),
    ];
    return responses[_random.nextInt(responses.length)];
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // UTILITY
  // ═══════════════════════════════════════════════════════════════════════════

  bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }
}
