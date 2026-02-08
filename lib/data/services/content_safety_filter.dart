// ════════════════════════════════════════════════════════════════════════════
// CONTENT SAFETY FILTER - App Store 4.3(b) Runtime Compliance
// ════════════════════════════════════════════════════════════════════════════
//
// This service filters AI-generated content to ensure App Store compliance.
// It blocks prediction/fortune-telling language and replaces with safe alternatives.
//
// USAGE:
// ```dart
// final safeContent = ContentSafetyFilter.filterContent(aiResponse);
// ```
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart' show debugPrint;

/// Runtime content filter for App Store 4.3(b) compliance.
/// Blocks prediction, fortune-telling, and certainty language.
class ContentSafetyFilter {
  ContentSafetyFilter._();

  // ══════════════════════════════════════════════════════════════════════════
  // FORBIDDEN PATTERNS - Will block or replace
  // ══════════════════════════════════════════════════════════════════════════

  /// Regex patterns for forbidden prediction language
  static final List<RegExp> _forbiddenPatterns = [
    // Prediction language (English)
    RegExp(r'\bwill happen\b', caseSensitive: false),
    RegExp(r'\bis destined\b', caseSensitive: false),
    RegExp(r'\bare destined\b', caseSensitive: false),
    RegExp(r'\bfate reveals\b', caseSensitive: false),
    RegExp(r'\bthe stars predict\b', caseSensitive: false),
    RegExp(r'\byour future\b', caseSensitive: false),
    RegExp(r'\bprophecy\b', caseSensitive: false),
    RegExp(r'\bdivination\b', caseSensitive: false),
    RegExp(r'\bfortune.?telling\b', caseSensitive: false),
    RegExp(r'\bdefinitely will\b', caseSensitive: false),
    RegExp(r'\bcertainly going to\b', caseSensitive: false),
    RegExp(r'\bguaranteed to\b', caseSensitive: false),
    RegExp(r'\bwithout doubt\b', caseSensitive: false),
    RegExp(r'\babsolutely will\b', caseSensitive: false),
    RegExp(r'\bwill bring you\b', caseSensitive: false),
    RegExp(r'\bwill come true\b', caseSensitive: false),
    RegExp(r'\bis certain to\b', caseSensitive: false),

    // Astrology-forward language
    RegExp(r'\bhoroscope reading\b', caseSensitive: false),
    RegExp(r'\bzodiac reading\b', caseSensitive: false),
    RegExp(r'\bthe cards reveal\b', caseSensitive: false),
    RegExp(r'\baccording to the stars\b', caseSensitive: false),
    RegExp(r'\bthe planets indicate\b', caseSensitive: false),
    RegExp(r'\byour zodiac predicts\b', caseSensitive: false),
    RegExp(r'\bcosmic prediction\b', caseSensitive: false),

    // Prediction language (Turkish)
    RegExp(r'\bkaderin\b', caseSensitive: false),
    RegExp(r'\bkaderiniz\b', caseSensitive: false),
    RegExp(r'\bkehanet\b', caseSensitive: false),
    RegExp(r'\bgelecekte olacak\b', caseSensitive: false),
    RegExp(r'\bolacaktır\b', caseSensitive: false),
    RegExp(r'\bkesinlikle olacak\b', caseSensitive: false),
    RegExp(r'\bmutlaka gerçekleşecek\b', caseSensitive: false),
    RegExp(r'\byıldızlar söylüyor\b', caseSensitive: false),
  ];

  // ══════════════════════════════════════════════════════════════════════════
  // SAFE REPLACEMENTS
  // ══════════════════════════════════════════════════════════════════════════

  /// Map of forbidden phrases to safe alternatives
  static const Map<String, String> _replacements = {
    // English replacements
    'will happen': 'might unfold',
    'is destined': 'could represent',
    'are destined': 'might find meaning in',
    'fate reveals': 'this pattern suggests',
    'the stars predict': 'some interpret this as',
    'your future': 'your personal journey',
    'prophecy': 'reflection',
    'divination': 'insight',
    'fortune telling': 'self-reflection',
    'fortune-telling': 'self-reflection',
    'definitely will': 'often appears when',
    'certainly going to': 'many experience this as',
    'guaranteed to': 'frequently associated with',
    'without doubt': 'commonly interpreted as',
    'absolutely will': 'might manifest as',
    'will bring you': 'could bring',
    'will come true': 'may resonate',
    'is certain to': 'might be seen as',
    'horoscope reading': 'personal reflection',
    'zodiac reading': 'self-exploration',
    'the cards reveal': 'the symbols suggest',
    'according to the stars': 'in this interpretation',
    'the planets indicate': 'this pattern may show',
    'your zodiac predicts': 'this may represent',
    'cosmic prediction': 'cosmic reflection',

    // Turkish replacements
    'kaderin': 'yolculuğun',
    'kaderiniz': 'yolculuğunuz',
    'kehanet': 'yansıma',
    'gelecekte olacak': 'olabilir',
    'olacaktır': 'olabilir',
    'kesinlikle olacak': 'sıklıkla görülür',
    'mutlaka gerçekleşecek': 'yaygın olarak yorumlanır',
    'yıldızlar söylüyor': 'bu şekilde yorumlanabilir',
  };

  // ══════════════════════════════════════════════════════════════════════════
  // PUBLIC API
  // ══════════════════════════════════════════════════════════════════════════

  /// Check if content contains any forbidden phrases.
  /// Returns `true` if unsafe content detected.
  static bool containsForbiddenContent(String content) {
    if (content.isEmpty) return false;

    for (final pattern in _forbiddenPatterns) {
      if (pattern.hasMatch(content)) {
        return true;
      }
    }
    return false;
  }

  /// Filter content by replacing forbidden phrases with safe alternatives.
  /// Returns filtered content safe for App Store display.
  static String filterContent(String content) {
    if (content.isEmpty) return content;

    var result = content;

    // Apply all replacements
    _replacements.forEach((forbidden, safe) {
      result = result.replaceAll(
        RegExp(RegExp.escape(forbidden), caseSensitive: false),
        safe,
      );
    });

    return result;
  }

  /// Validate and filter content, logging if modifications were made.
  /// Returns filtered content and logs privacy-safe telemetry.
  static String validateAndFilter(String content, {String? context}) {
    if (!containsForbiddenContent(content)) {
      return content;
    }

    // Log that content was filtered (privacy-safe - no actual content logged)
    logBlockedContent(
      content.hashCode.toString(),
      context ?? 'AI_RESPONSE',
    );

    return filterContent(content);
  }

  /// Log blocked content event for analytics (privacy-safe).
  /// Only logs a hash, never the actual content.
  static void logBlockedContent(String contentHash, String reason) {
    debugPrint(
      'ContentSafetyFilter: Filtered content (hash: $contentHash) - $reason',
    );
  }

  /// Get list of detected forbidden phrases in content (for debugging).
  /// Only use in debug mode, not in production.
  static List<String> detectForbiddenPhrases(String content) {
    final detected = <String>[];

    for (final pattern in _forbiddenPatterns) {
      final matches = pattern.allMatches(content);
      for (final match in matches) {
        detected.add(match.group(0) ?? pattern.pattern);
      }
    }

    return detected;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // BATCH PROCESSING
  // ══════════════════════════════════════════════════════════════════════════

  /// Filter a list of strings, returning only safe content.
  static List<String> filterBatch(List<String> contents) {
    return contents.map((c) => filterContent(c)).toList();
  }

  /// Check if any item in a list contains forbidden content.
  static bool batchContainsForbidden(List<String> contents) {
    return contents.any((c) => containsForbiddenContent(c));
  }
}
