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
    RegExp(r'\bseni bekliyor\b', caseSensitive: false),
    RegExp(r'\bşans kapıları\b', caseSensitive: false),

    // Additional English patterns
    RegExp(r'\byou will receive\b', caseSensitive: false),
    RegExp(r'\byou will find\b', caseSensitive: false),
    RegExp(r'\byou will get\b', caseSensitive: false),
    RegExp(r'\bexpect to receive\b', caseSensitive: false),
    RegExp(r'\bdoors will open\b', caseSensitive: false),
    RegExp(r'\bsoulmate will\b', caseSensitive: false),

    // Love/relationship prediction patterns
    RegExp(r'\byour soulmate\b', caseSensitive: false),
    RegExp(r'\btrue love awaits\b', caseSensitive: false),
    RegExp(r'\bperfect match\b', caseSensitive: false),
    RegExp(r'\bwill meet\b', caseSensitive: false),
    RegExp(r'\bwill marry\b', caseSensitive: false),

    // Health claim patterns (critical)
    RegExp(r'\bwill cure\b', caseSensitive: false),
    RegExp(r'\bwill heal\b', caseSensitive: false),
    RegExp(r'\bguaranteed cure\b', caseSensitive: false),
    RegExp(r'\bproven remedy\b', caseSensitive: false),
    RegExp(r'\bmedical advice\b', caseSensitive: false),

    // Financial prediction patterns
    RegExp(r'\bget rich\b', caseSensitive: false),
    RegExp(r'\bguaranteed profit\b', caseSensitive: false),
    RegExp(r'\bfinancial advice\b', caseSensitive: false),

    // Additional certainty patterns
    RegExp(r'\bwill surely\b', caseSensitive: false),
    RegExp(r'\bsurely will\b', caseSensitive: false),
    RegExp(r'\bwill definitely\b', caseSensitive: false),
    RegExp(r'\bwill certainly\b', caseSensitive: false),
    RegExp(r'\bis meant for you\b', caseSensitive: false),
    RegExp(r'\bbelongs to you\b', caseSensitive: false),

    // Negative prediction patterns
    RegExp(r'\bwill fail\b', caseSensitive: false),
    RegExp(r'\bwill suffer\b', caseSensitive: false),
    RegExp(r'\bbad luck\b', caseSensitive: false),
    RegExp(r'\bmisfortune\b', caseSensitive: false),

    // Time-specific predictions
    RegExp(r'\bby age \d+\b', caseSensitive: false),
    RegExp(r'\bwithin \d+ years\b', caseSensitive: false),

    // Additional Turkish patterns
    RegExp(r'\bruh eşi\b', caseSensitive: false),
    RegExp(r'\bevlenecek\b', caseSensitive: false),
    RegExp(r'\bzengin olacak\b', caseSensitive: false),
    RegExp(r'\başkın bulacak\b', caseSensitive: false),
    RegExp(r'\bkötü şans\b', caseSensitive: false),
    RegExp(r'\btalihsizlik\b', caseSensitive: false),

    // German patterns
    RegExp(r'\bwird passieren\b', caseSensitive: false),
    RegExp(r'\bSchicksal\b', caseSensitive: false),
    RegExp(r'\bVorhersage\b', caseSensitive: false),
    RegExp(r'\bwird kommen\b', caseSensitive: false),
    RegExp(r'\bgarantiert\b', caseSensitive: false),
    RegExp(r'\bSeelenverwandter\b', caseSensitive: false),

    // French patterns
    RegExp(r'\bva arriver\b', caseSensitive: false),
    RegExp(r'\bdestin\b', caseSensitive: false),
    RegExp(r'\bprédiction\b', caseSensitive: false),
    RegExp(r'\bâme sœur\b', caseSensitive: false),
    RegExp(r'\bgaranti\b', caseSensitive: false),

    // Spanish patterns
    RegExp(r'\bva a pasar\b', caseSensitive: false),
    RegExp(r'\bdestino\b', caseSensitive: false),
    RegExp(r'\bpredicción\b', caseSensitive: false),
    RegExp(r'\balma gemela\b', caseSensitive: false),
    RegExp(r'\bgarantizado\b', caseSensitive: false),
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
    'seni bekliyor': 'düşünebilirsin',
    'şans kapıları': 'fırsat temaları',

    // Additional English replacements
    'you will receive': 'you may consider',
    'you will find': 'you might explore',
    'you will get': 'you could experience',
    'expect to receive': 'may encounter',
    'doors will open': 'opportunities may appear',
    'soulmate will': 'connection themes',

    // Love/relationship replacements
    'your soulmate': 'meaningful connections',
    'true love awaits': 'love themes may emerge',
    'perfect match': 'compatible energies',
    'will meet': 'may encounter',
    'will marry': 'may explore partnership themes',

    // Health claim replacements
    'will cure': 'may support',
    'will heal': 'may nurture',
    'guaranteed cure': 'supportive practice',
    'proven remedy': 'traditional practice',
    'medical advice': 'wellness reflection',

    // Financial replacements
    'get rich': 'explore abundance themes',
    'guaranteed profit': 'potential opportunity',
    'financial advice': 'financial reflection',

    // Certainty replacements
    'will surely': 'may often',
    'surely will': 'often appears',
    'will definitely': 'commonly shows',
    'will certainly': 'frequently indicates',
    'is meant for you': 'resonates with your path',
    'belongs to you': 'aligns with your journey',

    // Negative prediction replacements
    'will fail': 'may face challenges in',
    'will suffer': 'may experience tension in',
    'bad luck': 'challenging themes',
    'misfortune': 'growth opportunity',

    // Turkish replacements
    'ruh eşi': 'anlamlı bağlantılar',
    'evlenecek': 'ilişki temalarını keşfedebilir',
    'zengin olacak': 'bolluk temalarını keşfedebilir',
    'aşkın bulacak': 'sevgi temalarını keşfedebilir',
    'kötü şans': 'zorlayıcı temalar',
    'talihsizlik': 'büyüme fırsatı',

    // German replacements
    'wird passieren': 'könnte sich entfalten',
    'Schicksal': 'Lebensweg',
    'Vorhersage': 'Reflexion',
    'wird kommen': 'könnte erscheinen',
    'garantiert': 'häufig',
    'Seelenverwandter': 'bedeutungsvolle Verbindungen',

    // French replacements
    'va arriver': 'pourrait se développer',
    'destin': 'chemin de vie',
    'prédiction': 'réflexion',
    'âme sœur': 'connexions significatives',
    'garanti': 'souvent',

    // Spanish replacements
    'va a pasar': 'podría desarrollarse',
    'destino': 'camino de vida',
    'predicción': 'reflexión',
    'alma gemela': 'conexiones significativas',
    'garantizado': 'frecuentemente',
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
    logBlockedContent(content.hashCode.toString(), context ?? 'AI_RESPONSE');

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
