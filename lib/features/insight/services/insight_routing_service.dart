/// Insight Routing Service - Input Classification
/// Classifies user input into reflection categories (invisible to user)
/// NO astrology, NO predictions - purely for response routing
library;

import '../../../data/providers/app_providers.dart';

/// Types of insight reflections (internal use only)
enum InsightType {
  /// User describes a dream
  dreamReflection,

  /// User asks about recurring patterns/habits
  patternAwareness,

  /// User explores emotions/feelings
  emotionalExplore,

  /// User needs perspective on a decision
  decisionSupport,

  /// User discusses relationships
  relationshipReflection,

  /// User explores self-understanding
  selfDiscovery,

  /// Default catch-all
  generalReflection,
}

/// Service for classifying user input into insight types
class InsightRoutingService {
  /// Classify user input to determine response type
  /// This is completely invisible to the user
  InsightType classifyInput(String input, AppLanguage language) {
    final lower = input.toLowerCase();

    // Dream-related keywords (EN + TR)
    if (_containsAny(lower, [
      // English
      'dream', 'dreamed', 'dreaming', 'nightmare', 'sleep', 'slept',
      'woke up', 'sleeping', 'night', 'vision',
      // Turkish
      'rüya', 'ruya', 'kabus', 'uyku', 'uyudum', 'uyandım', 'uyandigimda',
      'gece', 'gördüm', 'gordum',
    ])) {
      return InsightType.dreamReflection;
    }

    // Pattern/habit keywords
    if (_containsAny(lower, [
      // English
      'pattern', 'keep', 'always', 'repeating', 'again', 'habit',
      'every time', 'same thing', 'cycle', 'stuck', 'loop',
      // Turkish
      'kalıp', 'kalip', 'hep', 'tekrar', 'sürekli', 'surekli',
      'döngü', 'dongu', 'alışkanlık', 'aliskanlik', 'aynı şey', 'ayni sey',
    ])) {
      return InsightType.patternAwareness;
    }

    // Emotion keywords
    if (_containsAny(lower, [
      // English
      'feel', 'feeling', 'felt', 'anxious', 'anxiety', 'happy', 'sad',
      'angry', 'frustrated', 'overwhelmed', 'stressed', 'worried',
      'scared', 'afraid', 'nervous', 'calm', 'peaceful', 'excited',
      'lonely', 'confused', 'lost', 'hopeful', 'hopeless',
      // Turkish
      'hissediyorum', 'hissettim', 'kaygı', 'kaygi', 'mutlu', 'üzgün', 'uzgun',
      'kızgın', 'kizgin', 'sinirli', 'stresli', 'endişeli', 'endiseli',
      'korkuyorum', 'gergin', 'huzurlu', 'heyecanlı', 'heyecanli',
      'yalnız', 'yalniz', 'kafam karışık', 'kafam karisik', 'umutlu', 'umutsuz',
    ])) {
      return InsightType.emotionalExplore;
    }

    // Decision keywords
    if (_containsAny(lower, [
      // English
      'should', 'decide', 'decision', 'choice', 'option', 'choose',
      'choosing', 'dilemma', 'torn', 'unsure', 'what to do',
      'can\'t decide', 'help me decide', 'which one', 'either',
      // Turkish
      'karar', 'seçim', 'secim', 'yapmalı', 'yapmali', 'hangisi',
      'seçenek', 'secenek', 'kararsız', 'kararsiz', 'ne yapmalı', 'ne yapmali',
      'ikisi de', 'arada kaldım', 'arada kaldim',
    ])) {
      return InsightType.decisionSupport;
    }

    // Relationship keywords
    if (_containsAny(lower, [
      // English
      'relationship', 'partner', 'friend', 'family', 'mother', 'father',
      'parent', 'sibling', 'colleague', 'boss', 'ex', 'boyfriend',
      'girlfriend', 'husband', 'wife', 'marriage', 'dating',
      // Turkish
      'ilişki', 'iliski', 'partner', 'arkadaş', 'arkadas', 'aile',
      'anne', 'baba', 'kardeş', 'kardes', 'iş arkadaşı', 'patron',
      'eski', 'sevgili', 'eş', 'es', 'evlilik', 'flört', 'flort',
    ])) {
      return InsightType.relationshipReflection;
    }

    // Self-discovery keywords
    if (_containsAny(lower, [
      // English
      'who am i', 'myself', 'identity', 'purpose', 'meaning',
      'understand myself', 'why do i', 'what kind of person',
      'my personality', 'my nature', 'who i am',
      // Turkish
      'kendim', 'kimim', 'kim olduğum', 'kim oldugum', 'amacım', 'amacim',
      'anlam', 'kendimi anlamak', 'neden böyleyim', 'neden boyleyim',
      'kişiliğim', 'kisiliğim', 'doğam', 'dogam',
    ])) {
      return InsightType.selfDiscovery;
    }

    return InsightType.generalReflection;
  }

  /// Check if text contains any of the keywords
  bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }
}
