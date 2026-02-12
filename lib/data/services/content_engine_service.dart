// ════════════════════════════════════════════════════════════════════════════
// CONTENT ENGINE - InnerCycles Infinite Daily Content Generation
// ════════════════════════════════════════════════════════════════════════════
// Generates unique daily prompts using a combinatorial formula:
// [Archetype] + [Emotional State] + [Trend Context] + [Growth Direction]
//   + [Reflective Question]
// Total unique combinations: 12 × 20 × 12 × 8 × 30 = 691,200
// With rotation rules enforced, content stays fresh for years.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ══════════════════════════════════════════════════════════════════════════
// DAILY CONTENT MODEL
// ══════════════════════════════════════════════════════════════════════════

class DailyContent {
  final String archetype;
  final String emotionalState;
  final String trendContext;
  final String growthDirection;
  final String reflectiveQuestion;
  final String hash;
  final DateTime generatedAt;
  final int confidenceScore; // 1-10

  const DailyContent({
    required this.archetype,
    required this.emotionalState,
    required this.trendContext,
    required this.growthDirection,
    required this.reflectiveQuestion,
    required this.hash,
    required this.generatedAt,
    required this.confidenceScore,
  });

  Map<String, dynamic> toJson() => {
        'archetype': archetype,
        'emotionalState': emotionalState,
        'trendContext': trendContext,
        'growthDirection': growthDirection,
        'reflectiveQuestion': reflectiveQuestion,
        'hash': hash,
        'generatedAt': generatedAt.toIso8601String(),
        'confidenceScore': confidenceScore,
      };

  factory DailyContent.fromJson(Map<String, dynamic> json) => DailyContent(
        archetype: json['archetype'],
        emotionalState: json['emotionalState'],
        trendContext: json['trendContext'],
        growthDirection: json['growthDirection'],
        reflectiveQuestion: json['reflectiveQuestion'],
        hash: json['hash'],
        generatedAt: DateTime.parse(json['generatedAt']),
        confidenceScore: json['confidenceScore'],
      );
}

// ══════════════════════════════════════════════════════════════════════════
// CONTENT ENGINE SERVICE
// ══════════════════════════════════════════════════════════════════════════

class ContentEngineService {
  static const String _contentHistoryKey = 'content_engine_history';
  static const String _questionHistoryKey = 'content_engine_questions';
  static const String _archetypeHistoryKey = 'content_engine_archetypes';
  static const String _comboHistoryKey = 'content_engine_combos';
  static const String _growthIndexKey = 'content_engine_growth_index';

  final SharedPreferences _prefs;
  final Random _random = Random();

  ContentEngineService._(this._prefs);

  /// Initialize the content engine service
  static Future<ContentEngineService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return ContentEngineService._(prefs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // VARIABLE POOLS
  // ══════════════════════════════════════════════════════════════════════════

  static const List<String> archetypes = [
    'Hero',
    'Seeker',
    'Healer',
    'Observer',
    'Protector',
    'Creator',
    'Rebel',
    'Sage',
    'Explorer',
    'Nurturer',
    'Visionary',
    'Anchor',
  ];

  static const List<String> emotionalStates = [
    'Energized',
    'Drained',
    'Anxious',
    'Calm',
    'Restless',
    'Content',
    'Overwhelmed',
    'Focused',
    'Scattered',
    'Hopeful',
    'Grieving',
    'Excited',
    'Numb',
    'Curious',
    'Frustrated',
    'Grateful',
    'Lonely',
    'Connected',
    'Conflicted',
    'At Peace',
  ];

  static const List<String> trendContexts = [
    'New Moon',
    'Full Moon',
    'Mercury Retrograde',
    'Eclipse Season',
    'Equinox',
    'Solstice',
    'Monday Reset',
    'Mid-Week Check',
    'Friday Release',
    'Monthly Review',
    'Seasonal Shift',
    'Year Transition',
  ];

  static const List<String> growthDirections = [
    'Emerging Awareness',
    'Breaking Patterns',
    'Building Strength',
    'Deepening Connection',
    'Finding Voice',
    'Releasing Control',
    'Embracing Change',
    'Integrating Shadow',
  ];

  static const List<String> reflectiveQuestions = [
    'What is asking for your attention right now?',
    'What pattern are you ready to release?',
    'Where in your body do you feel this?',
    'What would your wisest self say?',
    'What are you avoiding looking at?',
    'What truth are you ready to honor?',
    'What boundary needs strengthening?',
    'What are you grateful for that surprised you?',
    'What dream keeps returning and why?',
    'What cycle are you ready to complete?',
    'Where do you need more gentleness?',
    'What emotion have you been calling something else?',
    'What relationship pattern is repeating?',
    'What does rest actually look like for you?',
    'What fear is dressed up as logic?',
    'What growth are you not giving yourself credit for?',
    'What would you tell your younger self about this pattern?',
    'What are you building that nobody sees yet?',
    'Where is your energy leaking?',
    'What conversation are you avoiding?',
    'What does your body know that your mind won\'t admit?',
    'What season of life are you actually in?',
    'What would change if you trusted yourself more?',
    'What do your dreams suggest about your waking life?',
    'What emotional muscle are you strengthening?',
    'What pattern connects your best days?',
    'What small shift would create the biggest change?',
    'What are you holding onto that has already ended?',
    'What does your ideal inner cycle look like?',
    'What is emerging in you right now?',
  ];

  // ══════════════════════════════════════════════════════════════════════════
  // CONTENT GENERATION
  // ══════════════════════════════════════════════════════════════════════════

  /// Generate unique daily content with rotation rules enforced
  DailyContent generateDailyContent({
    int entryCount = 0,
    DateTime? currentDate,
  }) {
    final now = currentDate ?? DateTime.now();
    final confidenceScore = _calculateConfidence(entryCount);

    // Select archetype (no repeat within 7 days)
    final archetype = _selectArchetype(now);

    // Select emotional state (no identical state + archetype combo within 30 days)
    final emotionalState = _selectEmotionalState(archetype, now);

    // Select trend context (matches real-world timing)
    final trendContext = _selectTrendContext(now);

    // Select growth direction (rotates through all 8 every 2 weeks)
    final growthDirection = _selectGrowthDirection(now);

    // Select reflective question (no repeat within 30 days)
    final reflectiveQuestion = getReflectiveQuestion();

    // Generate hash for duplication avoidance
    final hash = _generateHash(
      archetype,
      emotionalState,
      trendContext,
      growthDirection,
      reflectiveQuestion,
    );

    final content = DailyContent(
      archetype: archetype,
      emotionalState: emotionalState,
      trendContext: trendContext,
      growthDirection: growthDirection,
      reflectiveQuestion: reflectiveQuestion,
      hash: hash,
      generatedAt: now,
      confidenceScore: confidenceScore,
    );

    // Store in history for rotation tracking
    _storeContentHistory(content);
    _storeArchetypeHistory(archetype, now);
    _storeComboHistory(archetype, emotionalState, now);
    _storeQuestionHistory(reflectiveQuestion, now);

    return content;
  }

  /// Generate a formatted daily hook message
  String generateDailyHook({required int entryCount}) {
    final content = generateDailyContent(entryCount: entryCount);
    final confidence = content.confidenceScore;

    String confidenceLabel;
    if (confidence <= 3) {
      confidenceLabel = 'Early Insight';
    } else if (confidence <= 6) {
      confidenceLabel = 'Growing Clarity';
    } else if (confidence <= 9) {
      confidenceLabel = 'Deep Pattern';
    } else {
      confidenceLabel = 'Peak Awareness';
    }

    return 'Today\'s Inner Cycle: The $confidenceLabel of the '
        '${content.archetype}\n\n'
        'You may notice a sense of being ${content.emotionalState.toLowerCase()} '
        'during this ${content.trendContext.toLowerCase()} phase. '
        'Your current growth edge points toward '
        '${content.growthDirection.toLowerCase()}.\n\n'
        '${content.reflectiveQuestion}';
  }

  /// Get a random reflective question with no repeat within 30 days
  String getReflectiveQuestion() {
    final recentQuestions = _getRecentQuestions(30);
    final available = reflectiveQuestions
        .where((q) => !recentQuestions.contains(q))
        .toList();

    // If all questions used in last 30 days, reset and pick from full pool
    if (available.isEmpty) {
      return reflectiveQuestions[_random.nextInt(reflectiveQuestions.length)];
    }

    return available[_random.nextInt(available.length)];
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ROTATION RULES
  // ══════════════════════════════════════════════════════════════════════════

  /// Select archetype with no repeat within 7 days
  String _selectArchetype(DateTime now) {
    final recentArchetypes = _getRecentArchetypes(7);
    final available =
        archetypes.where((a) => !recentArchetypes.contains(a)).toList();

    if (available.isEmpty) {
      // All archetypes used within 7 days (only 12 exist), pick least recent
      return archetypes[_random.nextInt(archetypes.length)];
    }

    return available[_random.nextInt(available.length)];
  }

  /// Select emotional state with no identical state + archetype combo within 30 days
  String _selectEmotionalState(String archetype, DateTime now) {
    final recentCombos = _getRecentCombos(30);
    final available = emotionalStates.where((state) {
      final comboKey = '${archetype}_$state';
      return !recentCombos.contains(comboKey);
    }).toList();

    if (available.isEmpty) {
      return emotionalStates[_random.nextInt(emotionalStates.length)];
    }

    return available[_random.nextInt(available.length)];
  }

  /// Select trend context based on real-world timing
  String _selectTrendContext(DateTime now) {
    // Day of week overrides
    if (now.weekday == DateTime.monday) return 'Monday Reset';
    if (now.weekday == DateTime.wednesday) return 'Mid-Week Check';
    if (now.weekday == DateTime.friday) return 'Friday Release';

    // Month-based seasonal context
    final month = now.month;
    final day = now.day;

    // Equinox windows (around March 20 and September 22)
    if ((month == 3 && day >= 18 && day <= 22) ||
        (month == 9 && day >= 20 && day <= 24)) {
      return 'Equinox';
    }

    // Solstice windows (around June 21 and December 21)
    if ((month == 6 && day >= 19 && day <= 23) ||
        (month == 12 && day >= 19 && day <= 23)) {
      return 'Solstice';
    }

    // Year transition (Dec 28 - Jan 5)
    if ((month == 12 && day >= 28) || (month == 1 && day <= 5)) {
      return 'Year Transition';
    }

    // Monthly review (last 2 days of month)
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0).day;
    if (day >= lastDayOfMonth - 1) {
      return 'Monthly Review';
    }

    // Seasonal shift (first week of March, June, September, December)
    if (day <= 7 && (month == 3 || month == 6 || month == 9 || month == 12)) {
      return 'Seasonal Shift';
    }

    // Approximate lunar phases using a simple 29.53-day cycle
    final moonAge = _approximateMoonAge(now);
    if (moonAge <= 1.5 || moonAge >= 28.0) return 'New Moon';
    if (moonAge >= 13.5 && moonAge <= 15.5) return 'Full Moon';
    if (moonAge >= 7.0 && moonAge <= 9.0) return 'Eclipse Season';

    // Fallback: pick from cosmic contexts based on date seed
    final cosmicContexts = [
      'New Moon',
      'Full Moon',
      'Mercury Retrograde',
      'Eclipse Season',
    ];
    final seed = now.year * 1000 + now.month * 100 + now.day;
    return cosmicContexts[seed % cosmicContexts.length];
  }

  /// Select growth direction rotating through all 8 every 2 weeks
  String _selectGrowthDirection(DateTime now) {
    // Load the persisted growth index
    int growthIndex = _prefs.getInt(_growthIndexKey) ?? 0;

    // Calculate which 2-day slot we are in within a 16-day (2-week) cycle
    // Each growth direction gets ~2 days in a 16-day window
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final slotIndex = (dayOfYear ~/ 2) % growthDirections.length;

    // Persist the new index
    if (slotIndex != growthIndex) {
      _prefs.setInt(_growthIndexKey, slotIndex);
    }

    return growthDirections[slotIndex];
  }

  /// Approximate moon age in days (0 = new moon, ~14.7 = full moon)
  double _approximateMoonAge(DateTime date) {
    // Known new moon: January 6, 2000 18:14 UTC
    final knownNewMoon = DateTime.utc(2000, 1, 6, 18, 14);
    final daysSince = date.difference(knownNewMoon).inHours / 24.0;
    const lunarCycle = 29.53058867;
    final moonAge = daysSince % lunarCycle;
    return moonAge < 0 ? moonAge + lunarCycle : moonAge;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CONFIDENCE SCORING
  // ══════════════════════════════════════════════════════════════════════════

  /// Calculate confidence score based on journal entry count
  int _calculateConfidence(int entryCount) {
    if (entryCount >= 90) return 10; // peak
    if (entryCount >= 30) return 7 + ((entryCount - 30) * 2 ~/ 60); // high 7-9
    if (entryCount >= 7) return 4 + ((entryCount - 7) * 2 ~/ 23); // medium 4-6
    return 1 + (entryCount * 2 ~/ 7); // low 1-3
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HASH-BASED DUPLICATION AVOIDANCE
  // ══════════════════════════════════════════════════════════════════════════

  /// Generate SHA256 hash for content combination
  String _generateHash(
    String archetype,
    String emotionalState,
    String trendContext,
    String growthDirection,
    String reflectiveQuestion,
  ) {
    final input =
        '$archetype$emotionalState$trendContext$growthDirection$reflectiveQuestion';
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Store content in rolling 90-day history window
  void _storeContentHistory(DailyContent content) {
    final history = _getContentHistory();
    history.add(content.toJson());

    // Prune entries older than 90 days
    final cutoff = DateTime.now().subtract(const Duration(days: 90));
    history.removeWhere((entry) {
      final generatedAt = DateTime.parse(entry['generatedAt']);
      return generatedAt.isBefore(cutoff);
    });

    _prefs.setString(_contentHistoryKey, json.encode(history));
  }

  /// Get content generation history
  List<Map<String, dynamic>> _getContentHistory() {
    final historyJson = _prefs.getString(_contentHistoryKey);
    if (historyJson == null) return [];
    try {
      final List<dynamic> decoded = json.decode(historyJson);
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ARCHETYPE HISTORY TRACKING
  // ══════════════════════════════════════════════════════════════════════════

  /// Store archetype usage with date
  void _storeArchetypeHistory(String archetype, DateTime date) {
    final history = _getRawArchetypeHistory();
    history.add({
      'archetype': archetype,
      'date': date.toIso8601String(),
    });

    // Prune entries older than 30 days
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    history.removeWhere((entry) {
      final entryDate = DateTime.parse(entry['date']);
      return entryDate.isBefore(cutoff);
    });

    _prefs.setString(_archetypeHistoryKey, json.encode(history));
  }

  /// Get archetypes used within the last N days
  List<String> _getRecentArchetypes(int days) {
    final history = _getRawArchetypeHistory();
    final cutoff = DateTime.now().subtract(Duration(days: days));

    return history
        .where((entry) {
          final entryDate = DateTime.parse(entry['date']);
          return entryDate.isAfter(cutoff);
        })
        .map<String>((entry) => entry['archetype'] as String)
        .toList();
  }

  List<Map<String, dynamic>> _getRawArchetypeHistory() {
    final historyJson = _prefs.getString(_archetypeHistoryKey);
    if (historyJson == null) return [];
    try {
      final List<dynamic> decoded = json.decode(historyJson);
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // COMBO HISTORY TRACKING (ARCHETYPE + EMOTIONAL STATE)
  // ══════════════════════════════════════════════════════════════════════════

  /// Store archetype + emotional state combo with date
  void _storeComboHistory(
    String archetype,
    String emotionalState,
    DateTime date,
  ) {
    final history = _getRawComboHistory();
    history.add({
      'combo': '${archetype}_$emotionalState',
      'date': date.toIso8601String(),
    });

    // Prune entries older than 30 days
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    history.removeWhere((entry) {
      final entryDate = DateTime.parse(entry['date']);
      return entryDate.isBefore(cutoff);
    });

    _prefs.setString(_comboHistoryKey, json.encode(history));
  }

  /// Get combos used within the last N days
  List<String> _getRecentCombos(int days) {
    final history = _getRawComboHistory();
    final cutoff = DateTime.now().subtract(Duration(days: days));

    return history
        .where((entry) {
          final entryDate = DateTime.parse(entry['date']);
          return entryDate.isAfter(cutoff);
        })
        .map<String>((entry) => entry['combo'] as String)
        .toList();
  }

  List<Map<String, dynamic>> _getRawComboHistory() {
    final historyJson = _prefs.getString(_comboHistoryKey);
    if (historyJson == null) return [];
    try {
      final List<dynamic> decoded = json.decode(historyJson);
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // QUESTION HISTORY TRACKING
  // ══════════════════════════════════════════════════════════════════════════

  /// Store question usage with date
  void _storeQuestionHistory(String question, DateTime date) {
    final history = _getRawQuestionHistory();
    history.add({
      'question': question,
      'date': date.toIso8601String(),
    });

    // Prune entries older than 30 days
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    history.removeWhere((entry) {
      final entryDate = DateTime.parse(entry['date']);
      return entryDate.isBefore(cutoff);
    });

    _prefs.setString(_questionHistoryKey, json.encode(history));
  }

  /// Get questions used within the last N days
  List<String> _getRecentQuestions(int days) {
    final history = _getRawQuestionHistory();
    final cutoff = DateTime.now().subtract(Duration(days: days));

    return history
        .where((entry) {
          final entryDate = DateTime.parse(entry['date']);
          return entryDate.isAfter(cutoff);
        })
        .map<String>((entry) => entry['question'] as String)
        .toList();
  }

  List<Map<String, dynamic>> _getRawQuestionHistory() {
    final historyJson = _prefs.getString(_questionHistoryKey);
    if (historyJson == null) return [];
    try {
      final List<dynamic> decoded = json.decode(historyJson);
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TONE GUARDRAILS
  // ══════════════════════════════════════════════════════════════════════════

  /// Sanitize content to ensure safe, reflective framing
  /// Never predictive, never diagnostic, always empowering
  String sanitizeContent(String text) {
    var sanitized = text;

    // Never "will happen" → "you may notice"
    sanitized = sanitized.replaceAll(
      RegExp(r'will happen', caseSensitive: false),
      'you may notice',
    );
    sanitized = sanitized.replaceAll(
      RegExp(r'is going to happen', caseSensitive: false),
      'you may notice',
    );

    // Never "you have [condition]" → "you might be feeling"
    sanitized = sanitized.replaceAll(
      RegExp(r'you have (a |an )?(?=\w)', caseSensitive: false),
      'you might be feeling ',
    );

    // Never "you should" → "you might consider"
    sanitized = sanitized.replaceAll(
      RegExp(r'you should', caseSensitive: false),
      'you might consider',
    );

    // Additional guardrails for predictive language
    sanitized = sanitized.replaceAll(
      RegExp(r'will be\b', caseSensitive: false),
      'may be',
    );
    sanitized = sanitized.replaceAll(
      RegExp(r'is going to\b', caseSensitive: false),
      'you may notice',
    );
    sanitized = sanitized.replaceAll(
      RegExp(r'you must', caseSensitive: false),
      'you might consider',
    );
    sanitized = sanitized.replaceAll(
      RegExp(r'you need to', caseSensitive: false),
      'you might consider',
    );

    // Never diagnostic
    sanitized = sanitized.replaceAll(
      RegExp(r'you are (depressed|anxious|sick|ill)', caseSensitive: false),
      'you might be feeling this way',
    );

    // Ensure reflective framing: "predict" → "past entries suggest"
    sanitized = sanitized.replaceAll(
      RegExp(r'\bpredict\b', caseSensitive: false),
      'past entries suggest',
    );
    sanitized = sanitized.replaceAll(
      RegExp(r'\bforecast\b', caseSensitive: false),
      'past entries suggest',
    );

    return sanitized;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // UTILITY
  // ══════════════════════════════════════════════════════════════════════════

  /// Clear all content engine data
  Future<void> clearAll() async {
    await _prefs.remove(_contentHistoryKey);
    await _prefs.remove(_questionHistoryKey);
    await _prefs.remove(_archetypeHistoryKey);
    await _prefs.remove(_comboHistoryKey);
    await _prefs.remove(_growthIndexKey);
  }
}
