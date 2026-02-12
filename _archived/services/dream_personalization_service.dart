/// Dream Personalization Service - Personalized Dream Interpretation Engine
/// Deep personalization based on user data, adaptive learning, astrological integration
library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/dream_interpretation_models.dart';
import '../models/dream_memory.dart';
import '../providers/app_providers.dart';
import 'dream_interpretation_service.dart';
import 'dream_memory_service.dart';
import 'l10n_service.dart';

// ════════════════════════════════════════════════════════════════════════════
// USER DREAM PROFILE
// ════════════════════════════════════════════════════════════════════════════

/// Dream interpretation styles
enum DreamStyle {
  jungian,
  spiritual,
  practical,
  esoteric,
  psychological;

  String get label => localizedLabel(AppLanguage.en);
  String get description => localizedDescription(AppLanguage.en);

  String localizedLabel(AppLanguage language) {
    final key = 'dream_personalization.styles.$name.label';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;
    // Fallback
    return switch (this) {
      DreamStyle.jungian => 'Jungian',
      DreamStyle.spiritual => 'Spiritual',
      DreamStyle.practical => 'Practical',
      DreamStyle.esoteric => 'Esoteric',
      DreamStyle.psychological => 'Psychological',
    };
  }

  String localizedDescription(AppLanguage language) {
    final key = 'dream_personalization.styles.$name.description';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;
    // Fallback
    return switch (this) {
      DreamStyle.jungian =>
        'Archetype-focused, shadow work, unconscious analysis',
      DreamStyle.spiritual =>
        'Cosmic messages, spiritual guidance, mystical interpretation',
      DreamStyle.practical =>
        'Daily life focused, action suggestions, concrete advice',
      DreamStyle.esoteric => 'Ancient wisdom, symbolism, hidden teachings',
      DreamStyle.psychological =>
        'Modern psychology perspective, emotional analysis',
    };
  }
}

/// User dream profile - The fundamental model for personalization
class UserDreamProfile {
  final String userId;
  final String? sunSign;
  final String? moonSign;
  final String? risingSign;
  final DateTime? birthDate;
  final String? birthPlace;
  final Map<String, int> symbolFrequency;
  final Map<String, String> personalSymbolMeanings;
  final List<String> recurringThemes;
  final EmotionalTone? dominantDreamEmotion;
  final double lucidDreamFrequency;
  final double nightmareFrequency;
  final List<String> lifeAreas;
  final String? currentLifePhase;
  final List<String> recentLifeEvents;
  final DreamStyle preferredStyle;
  final String? culturalBackground;
  final int? age;
  final List<InterpretationFeedback> feedbackHistory;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserDreamProfile({
    required this.userId,
    this.sunSign,
    this.moonSign,
    this.risingSign,
    this.birthDate,
    this.birthPlace,
    this.symbolFrequency = const {},
    this.personalSymbolMeanings = const {},
    this.recurringThemes = const [],
    this.dominantDreamEmotion,
    this.lucidDreamFrequency = 0.0,
    this.nightmareFrequency = 0.0,
    this.lifeAreas = const [],
    this.currentLifePhase,
    this.recentLifeEvents = const [],
    this.preferredStyle = DreamStyle.jungian,
    this.culturalBackground,
    this.age,
    this.feedbackHistory = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'sunSign': sunSign,
    'moonSign': moonSign,
    'risingSign': risingSign,
    'birthDate': birthDate?.toIso8601String(),
    'birthPlace': birthPlace,
    'symbolFrequency': symbolFrequency,
    'personalSymbolMeanings': personalSymbolMeanings,
    'recurringThemes': recurringThemes,
    'dominantDreamEmotion': dominantDreamEmotion?.name,
    'lucidDreamFrequency': lucidDreamFrequency,
    'nightmareFrequency': nightmareFrequency,
    'lifeAreas': lifeAreas,
    'currentLifePhase': currentLifePhase,
    'recentLifeEvents': recentLifeEvents,
    'preferredStyle': preferredStyle.name,
    'culturalBackground': culturalBackground,
    'age': age,
    'feedbackHistory': feedbackHistory.map((f) => f.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory UserDreamProfile.fromJson(Map<String, dynamic> json) =>
      UserDreamProfile(
        userId: json['userId'] ?? '',
        sunSign: json['sunSign'],
        moonSign: json['moonSign'],
        risingSign: json['risingSign'],
        birthDate: json['birthDate'] != null
            ? DateTime.tryParse(json['birthDate'])
            : null,
        birthPlace: json['birthPlace'],
        symbolFrequency: Map<String, int>.from(json['symbolFrequency'] ?? {}),
        personalSymbolMeanings: Map<String, String>.from(
          json['personalSymbolMeanings'] ?? {},
        ),
        recurringThemes: List<String>.from(json['recurringThemes'] ?? []),
        dominantDreamEmotion: json['dominantDreamEmotion'] != null
            ? EmotionalTone.values.firstWhere(
                (e) => e.name == json['dominantDreamEmotion'],
                orElse: () => EmotionalTone.merak,
              )
            : null,
        lucidDreamFrequency:
            (json['lucidDreamFrequency'] as num?)?.toDouble() ?? 0.0,
        nightmareFrequency:
            (json['nightmareFrequency'] as num?)?.toDouble() ?? 0.0,
        lifeAreas: List<String>.from(json['lifeAreas'] ?? []),
        currentLifePhase: json['currentLifePhase'],
        recentLifeEvents: List<String>.from(json['recentLifeEvents'] ?? []),
        preferredStyle: json['preferredStyle'] != null
            ? DreamStyle.values.firstWhere(
                (e) => e.name == json['preferredStyle'],
                orElse: () => DreamStyle.jungian,
              )
            : DreamStyle.jungian,
        culturalBackground: json['culturalBackground'],
        age: json['age'],
        feedbackHistory:
            (json['feedbackHistory'] as List?)
                ?.map((f) => InterpretationFeedback.fromJson(f))
                .toList() ??
            [],
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : DateTime.now(),
      );

  UserDreamProfile copyWith({
    String? userId,
    String? sunSign,
    String? moonSign,
    String? risingSign,
    DateTime? birthDate,
    String? birthPlace,
    Map<String, int>? symbolFrequency,
    Map<String, String>? personalSymbolMeanings,
    List<String>? recurringThemes,
    EmotionalTone? dominantDreamEmotion,
    double? lucidDreamFrequency,
    double? nightmareFrequency,
    List<String>? lifeAreas,
    String? currentLifePhase,
    List<String>? recentLifeEvents,
    DreamStyle? preferredStyle,
    String? culturalBackground,
    int? age,
    List<InterpretationFeedback>? feedbackHistory,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserDreamProfile(
    userId: userId ?? this.userId,
    sunSign: sunSign ?? this.sunSign,
    moonSign: moonSign ?? this.moonSign,
    risingSign: risingSign ?? this.risingSign,
    birthDate: birthDate ?? this.birthDate,
    birthPlace: birthPlace ?? this.birthPlace,
    symbolFrequency: symbolFrequency ?? this.symbolFrequency,
    personalSymbolMeanings:
        personalSymbolMeanings ?? this.personalSymbolMeanings,
    recurringThemes: recurringThemes ?? this.recurringThemes,
    dominantDreamEmotion: dominantDreamEmotion ?? this.dominantDreamEmotion,
    lucidDreamFrequency: lucidDreamFrequency ?? this.lucidDreamFrequency,
    nightmareFrequency: nightmareFrequency ?? this.nightmareFrequency,
    lifeAreas: lifeAreas ?? this.lifeAreas,
    currentLifePhase: currentLifePhase ?? this.currentLifePhase,
    recentLifeEvents: recentLifeEvents ?? this.recentLifeEvents,
    preferredStyle: preferredStyle ?? this.preferredStyle,
    culturalBackground: culturalBackground ?? this.culturalBackground,
    age: age ?? this.age,
    feedbackHistory: feedbackHistory ?? this.feedbackHistory,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? DateTime.now(),
  );

  /// Profile completion percentage
  double get completionPercentage {
    int completed = 0;
    int total = 10;

    if (sunSign != null) completed++;
    if (moonSign != null) completed++;
    if (risingSign != null) completed++;
    if (birthDate != null) completed++;
    if (currentLifePhase != null) completed++;
    if (lifeAreas.isNotEmpty) completed++;
    if (recentLifeEvents.isNotEmpty) completed++;
    if (culturalBackground != null) completed++;
    if (age != null) completed++;
    if (personalSymbolMeanings.isNotEmpty) completed++;

    return completed / total;
  }

  /// Has astrology data?
  bool get hasAstrologyData =>
      sunSign != null || moonSign != null || risingSign != null;

  /// Has life context?
  bool get hasLifeContext =>
      currentLifePhase != null ||
      lifeAreas.isNotEmpty ||
      recentLifeEvents.isNotEmpty;
}

/// Interpretation feedback
class InterpretationFeedback {
  final String dreamId;
  final int rating; // 1-5
  final String? comment;
  final List<String> resonatingParts;
  final List<String> notResonatingParts;
  final DateTime createdAt;

  const InterpretationFeedback({
    required this.dreamId,
    required this.rating,
    this.comment,
    this.resonatingParts = const [],
    this.notResonatingParts = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'dreamId': dreamId,
    'rating': rating,
    'comment': comment,
    'resonatingParts': resonatingParts,
    'notResonatingParts': notResonatingParts,
    'createdAt': createdAt.toIso8601String(),
  };

  factory InterpretationFeedback.fromJson(Map<String, dynamic> json) =>
      InterpretationFeedback(
        dreamId: json['dreamId'] ?? '',
        rating: json['rating'] ?? 3,
        comment: json['comment'],
        resonatingParts: List<String>.from(json['resonatingParts'] ?? []),
        notResonatingParts: List<String>.from(json['notResonatingParts'] ?? []),
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
      );
}

// ════════════════════════════════════════════════════════════════════════════
// DREAM CONTEXT
// ════════════════════════════════════════════════════════════════════════════

/// Context data for dream interpretation
class DreamContext {
  final MoonPhase moonPhase;
  final String? moonSign;
  final List<String> activeTransits;
  final String? currentRetrograde;
  final String season;
  final String dayOfWeek;
  final TimeOfDay dreamTime;
  final List<Dream> recentDreams;
  final List<String> recentLifeEvents;

  const DreamContext({
    required this.moonPhase,
    this.moonSign,
    this.activeTransits = const [],
    this.currentRetrograde,
    required this.season,
    required this.dayOfWeek,
    required this.dreamTime,
    this.recentDreams = const [],
    this.recentLifeEvents = const [],
  });

  Map<String, dynamic> toJson() => {
    'moonPhase': moonPhase.name,
    'moonSign': moonSign,
    'activeTransits': activeTransits,
    'currentRetrograde': currentRetrograde,
    'season': season,
    'dayOfWeek': dayOfWeek,
    'dreamTime': '${dreamTime.hour}:${dreamTime.minute}',
    'recentDreams': recentDreams.map((d) => d.toJson()).toList(),
    'recentLifeEvents': recentLifeEvents,
  };
}

// ════════════════════════════════════════════════════════════════════════════
// LIFE PHASES
// ════════════════════════════════════════════════════════════════════════════

/// Life phases and dream influences
class LifePhaseData {
  static const List<String> _phaseIds = [
    'student',
    'new_parent',
    'career_change',
    'grieving',
    'retired',
    'relationship_crisis',
    'health_crisis',
    'spiritual_awakening',
    'new_beginning',
  ];

  static const Map<String, String> _phaseEmojis = {
    'student': '📚',
    'new_parent': '👶',
    'career_change': '💼',
    'grieving': '🖤',
    'retired': '🌅',
    'relationship_crisis': '💔',
    'health_crisis': '🏥',
    'spiritual_awakening': '✨',
    'new_beginning': '🌱',
  };

  static LifePhaseInfo? getPhase(
    String phaseId, {
    AppLanguage language = AppLanguage.en,
  }) {
    final normalizedId = phaseId.toLowerCase().replaceAll(' ', '_');
    if (!_phaseIds.contains(normalizedId)) return null;
    return LifePhaseInfo.fromId(normalizedId, language);
  }

  static List<String> get allPhaseIds => _phaseIds;

  static List<LifePhaseInfo> getAllPhases(AppLanguage language) {
    return _phaseIds.map((id) => LifePhaseInfo.fromId(id, language)).toList();
  }
}

/// Life phase information
class LifePhaseInfo {
  final String id;
  final String label;
  final String emoji;
  final List<String> commonDreamThemes;
  final String interpretationFocus;
  final String advice;

  const LifePhaseInfo({
    required this.id,
    required this.label,
    required this.emoji,
    required this.commonDreamThemes,
    required this.interpretationFocus,
    required this.advice,
  });

  factory LifePhaseInfo.fromId(String id, AppLanguage language) {
    final baseKey = 'dream_personalization.life_phases.$id';
    return LifePhaseInfo(
      id: id,
      label: L10nService.get('$baseKey.label', language),
      emoji: LifePhaseData._phaseEmojis[id] ?? '📝',
      commonDreamThemes: L10nService.getList(
        '$baseKey.common_dream_themes',
        language,
      ),
      interpretationFocus: L10nService.get(
        '$baseKey.interpretation_focus',
        language,
      ),
      advice: L10nService.get('$baseKey.advice', language),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// PERSONALIZATION SERVICE
// ════════════════════════════════════════════════════════════════════════════

/// Main personalization service
class DreamPersonalizationService {
  static const String _profileKey = 'dream_profile_';
  static const String _feedbackKey = 'dream_feedback_';
  static const String _personalSymbolsKey = 'personal_symbols_';
  static const String _learningDataKey = 'dream_learning_';

  final SharedPreferences _prefs;
  final DreamMemoryService? memoryService;

  DreamPersonalizationService(this._prefs, {this.memoryService});

  /// Initialize service
  static Future<DreamPersonalizationService> init({
    DreamMemoryService? memoryService,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return DreamPersonalizationService(prefs, memoryService: memoryService);
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PROFILE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════

  /// Get or create profile
  Future<UserDreamProfile> getOrCreateProfile(String userId) async {
    final key = '$_profileKey$userId';
    final json = _prefs.getString(key);

    if (json != null) {
      try {
        return UserDreamProfile.fromJson(jsonDecode(json));
      } catch (e) {
        debugPrint('Profile loading error: $e');
      }
    }

    // Create new profile
    final newProfile = UserDreamProfile(
      userId: userId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _saveProfile(newProfile);
    return newProfile;
  }

  /// Update profile
  Future<void> updateProfile(UserDreamProfile profile) async {
    final updatedProfile = profile.copyWith(updatedAt: DateTime.now());
    await _saveProfile(updatedProfile);
  }

  Future<void> _saveProfile(UserDreamProfile profile) async {
    final key = '$_profileKey${profile.userId}';
    await _prefs.setString(key, jsonEncode(profile.toJson()));
  }

  /// Delete profile
  Future<void> deleteProfile(String userId) async {
    await _prefs.remove('$_profileKey$userId');
    await _prefs.remove('$_feedbackKey$userId');
    await _prefs.remove('$_personalSymbolsKey$userId');
    await _prefs.remove('$_learningDataKey$userId');
  }

  // ═══════════════════════════════════════════════════════════════════════
  // SYMBOL LEARNING
  // ═══════════════════════════════════════════════════════════════════════

  /// Record symbol appearance
  Future<void> recordSymbolAppearance(
    String userId,
    String symbol, {
    String? context,
    EmotionalTone? emotion,
  }) async {
    final profile = await getOrCreateProfile(userId);

    final updatedFrequency = Map<String, int>.from(profile.symbolFrequency);
    updatedFrequency[symbol] = (updatedFrequency[symbol] ?? 0) + 1;

    final updatedProfile = profile.copyWith(symbolFrequency: updatedFrequency);
    await updateProfile(updatedProfile);

    // Update learning data
    await _updateLearningData(userId, symbol, context, emotion);
  }

  /// Save personal symbol meaning
  Future<void> setPersonalSymbolMeaning(
    String userId,
    String symbol,
    String meaning,
  ) async {
    final profile = await getOrCreateProfile(userId);

    final updatedMeanings = Map<String, String>.from(
      profile.personalSymbolMeanings,
    );
    updatedMeanings[symbol] = meaning;

    final updatedProfile = profile.copyWith(
      personalSymbolMeanings: updatedMeanings,
    );
    await updateProfile(updatedProfile);
  }

  /// Get personal symbol meaning
  String? getPersonalSymbolMeaning(UserDreamProfile profile, String symbol) {
    return profile.personalSymbolMeanings[symbol.toLowerCase()];
  }

  /// Personal symbol dictionary
  Map<String, String> getPersonalSymbolDictionary(UserDreamProfile profile) {
    return Map.unmodifiable(profile.personalSymbolMeanings);
  }

  Future<void> _updateLearningData(
    String userId,
    String symbol,
    String? context,
    EmotionalTone? emotion,
  ) async {
    final key = '$_learningDataKey$userId';
    final existing = _prefs.getString(key);
    Map<String, dynamic> learningData = {};

    if (existing != null) {
      try {
        learningData = jsonDecode(existing);
      } catch (_) {}
    }

    // Update symbol learning data
    final symbolData = learningData[symbol] as Map<String, dynamic>? ?? {};
    final contexts = List<String>.from(symbolData['contexts'] ?? []);
    final emotions = List<String>.from(symbolData['emotions'] ?? []);

    if (context != null && !contexts.contains(context)) {
      contexts.add(context);
      if (contexts.length > 10) contexts.removeAt(0);
    }

    if (emotion != null && !emotions.contains(emotion.name)) {
      emotions.add(emotion.name);
      if (emotions.length > 10) emotions.removeAt(0);
    }

    symbolData['contexts'] = contexts;
    symbolData['emotions'] = emotions;
    symbolData['lastSeen'] = DateTime.now().toIso8601String();
    symbolData['count'] = (symbolData['count'] as int? ?? 0) + 1;

    learningData[symbol] = symbolData;
    await _prefs.setString(key, jsonEncode(learningData));
  }

  // ═══════════════════════════════════════════════════════════════════════
  // FEEDBACK
  // ═══════════════════════════════════════════════════════════════════════

  /// Record interpretation feedback
  Future<void> recordInterpretationFeedback(
    String userId,
    String dreamId,
    int rating, {
    String? feedback,
    List<String>? resonatingParts,
    List<String>? notResonatingParts,
  }) async {
    final profile = await getOrCreateProfile(userId);

    final newFeedback = InterpretationFeedback(
      dreamId: dreamId,
      rating: rating,
      comment: feedback,
      resonatingParts: resonatingParts ?? [],
      notResonatingParts: notResonatingParts ?? [],
      createdAt: DateTime.now(),
    );

    final updatedFeedback = List<InterpretationFeedback>.from(
      profile.feedbackHistory,
    );
    updatedFeedback.add(newFeedback);

    // Keep last 100 feedbacks
    if (updatedFeedback.length > 100) {
      updatedFeedback.removeRange(0, updatedFeedback.length - 100);
    }

    final updatedProfile = profile.copyWith(feedbackHistory: updatedFeedback);
    await updateProfile(updatedProfile);

    // Save feedback details separately
    await _saveFeedbackDetails(userId, newFeedback);
  }

  Future<void> _saveFeedbackDetails(
    String userId,
    InterpretationFeedback feedback,
  ) async {
    final key = '$_feedbackKey$userId';
    final existing = _prefs.getString(key);
    List<dynamic> feedbackList = [];

    if (existing != null) {
      try {
        feedbackList = jsonDecode(existing);
      } catch (_) {}
    }

    feedbackList.add(feedback.toJson());

    // Keep last 200 feedbacks
    if (feedbackList.length > 200) {
      feedbackList.removeRange(0, feedbackList.length - 200);
    }

    await _prefs.setString(key, jsonEncode(feedbackList));
  }

  /// Average interpretation rating
  double getAverageRating(UserDreamProfile profile) {
    if (profile.feedbackHistory.isEmpty) return 0.0;

    final total = profile.feedbackHistory.fold(0, (sum, f) => sum + f.rating);
    return total / profile.feedbackHistory.length;
  }

  // ═══════════════════════════════════════════════════════════════════════
  // CONTEXT BUILDING
  // ═══════════════════════════════════════════════════════════════════════

  /// Build dream context
  Future<DreamContext> buildContext(String userId, DateTime dreamTime) async {
    final profile = await getOrCreateProfile(userId);
    List<Dream> recentDreams = [];

    // Get recent dreams if memory service is available
    if (memoryService != null) {
      recentDreams = await memoryService!.getRecentDreams(days: 7);
    }

    final moonPhase = MoonPhaseCalculator.calculate(dreamTime);
    final moonSign = _calculateMoonSign(dreamTime);
    final activeTransits = _getActiveTransits(profile, dreamTime);
    final retrograde = _getCurrentRetrograde(dreamTime);
    final season = _getSeason(dreamTime);
    final dayOfWeek = _getDayOfWeek(dreamTime);

    return DreamContext(
      moonPhase: moonPhase,
      moonSign: moonSign,
      activeTransits: activeTransits,
      currentRetrograde: retrograde,
      season: season,
      dayOfWeek: dayOfWeek,
      dreamTime: TimeOfDay.fromDateTime(dreamTime),
      recentDreams: recentDreams,
      recentLifeEvents: profile.recentLifeEvents,
    );
  }

  String? _calculateMoonSign(DateTime date) {
    // Simple moon sign calculation (approximately 2.5 days in each sign)
    final signs = [
      'Aries',
      'Taurus',
      'Gemini',
      'Cancer',
      'Leo',
      'Virgo',
      'Libra',
      'Scorpio',
      'Sagittarius',
      'Capricorn',
      'Aquarius',
      'Pisces',
    ];

    // Reference: January 1, 2000 00:00 UTC - Moon starts in Cancer
    final reference = DateTime.utc(2000, 1, 1);
    final daysSince = date.difference(reference).inDays;
    final lunarCycle = 27.32; // Sidereal lunar cycle
    final daysPerSign = lunarCycle / 12;

    final signIndex = ((daysSince % lunarCycle) / daysPerSign).floor() % 12;
    return signs[signIndex];
  }

  List<String> _getActiveTransits(UserDreamProfile profile, DateTime date) {
    final transits = <String>[];

    // Calculate relevant transits if user has birth data
    if (profile.sunSign != null) {
      // Simple transit suggestions
      final moonSign = _calculateMoonSign(date);
      if (moonSign != null) {
        if (_isCompatibleSign(profile.sunSign!, moonSign)) {
          transits.add('Moon in $moonSign - harmonious flow');
        } else if (_isChallengeSign(profile.sunSign!, moonSign)) {
          transits.add('Moon in $moonSign - inner tension possible');
        }
      }
    }

    // General transit information
    final month = date.month;
    if (month == 3 || month == 4) {
      transits.add('Aries season - new beginnings');
    } else if (month == 10 || month == 11) {
      transits.add('Scorpio season - transformation period');
    }

    return transits;
  }

  bool _isCompatibleSign(String sign1, String sign2) {
    final compatible = {
      'Aries': ['Leo', 'Sagittarius', 'Gemini', 'Aquarius'],
      'Taurus': ['Virgo', 'Capricorn', 'Cancer', 'Pisces'],
      'Gemini': ['Libra', 'Aquarius', 'Aries', 'Leo'],
      'Cancer': ['Scorpio', 'Pisces', 'Taurus', 'Virgo'],
      'Leo': ['Aries', 'Sagittarius', 'Gemini', 'Libra'],
      'Virgo': ['Taurus', 'Capricorn', 'Cancer', 'Scorpio'],
      'Libra': ['Gemini', 'Aquarius', 'Leo', 'Sagittarius'],
      'Scorpio': ['Cancer', 'Pisces', 'Virgo', 'Capricorn'],
      'Sagittarius': ['Aries', 'Leo', 'Libra', 'Aquarius'],
      'Capricorn': ['Taurus', 'Virgo', 'Scorpio', 'Pisces'],
      'Aquarius': ['Gemini', 'Libra', 'Aries', 'Sagittarius'],
      'Pisces': ['Cancer', 'Scorpio', 'Taurus', 'Capricorn'],
    };
    return compatible[sign1]?.contains(sign2) ?? false;
  }

  bool _isChallengeSign(String sign1, String sign2) {
    final challenge = {
      'Aries': ['Cancer', 'Capricorn'],
      'Taurus': ['Leo', 'Aquarius'],
      'Gemini': ['Virgo', 'Pisces'],
      'Cancer': ['Aries', 'Libra'],
      'Leo': ['Taurus', 'Scorpio'],
      'Virgo': ['Gemini', 'Sagittarius'],
      'Libra': ['Cancer', 'Capricorn'],
      'Scorpio': ['Leo', 'Aquarius'],
      'Sagittarius': ['Virgo', 'Pisces'],
      'Capricorn': ['Aries', 'Libra'],
      'Aquarius': ['Taurus', 'Scorpio'],
      'Pisces': ['Gemini', 'Sagittarius'],
    };
    return challenge[sign1]?.contains(sign2) ?? false;
  }

  String? _getCurrentRetrograde(DateTime date) {
    // Simple retrograde calendar (2024-2025)
    final month = date.month;
    final day = date.day;

    // Mercury retrograde periods (approximately 3 times per year)
    final mercuryRetros = [
      [1, 1, 1, 25], // Early January
      [4, 1, 4, 25], // April
      [8, 5, 8, 28], // August
      [11, 25, 12, 15], // Late November - Mid December
    ];

    for (final retro in mercuryRetros) {
      if ((month == retro[0] && day >= retro[1]) ||
          (month == retro[2] && day <= retro[3])) {
        return 'Mercury';
      }
    }

    // Venus retrograde (every 18 months, approximately 40 days)
    if ((date.year == 2024 && month >= 3 && month <= 4) ||
        (date.year == 2025 && month >= 3 && month <= 4)) {
      return 'Venus';
    }

    return null;
  }

  String _getSeason(DateTime date) {
    final month = date.month;
    if (month >= 3 && month <= 5) return 'Spring';
    if (month >= 6 && month <= 8) return 'Summer';
    if (month >= 9 && month <= 11) return 'Autumn';
    return 'Winter';
  }

  String _getDayOfWeek(DateTime date) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[date.weekday - 1];
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PERSONALIZED INTERPRETATION
  // ═══════════════════════════════════════════════════════════════════════

  /// Adjust interpretation for user
  String adjustInterpretationForUser(
    String interpretation,
    UserDreamProfile profile,
  ) {
    var adjusted = interpretation;

    // Adjust language for age group
    if (profile.age != null) {
      adjusted = _adjustForAge(adjusted, profile.age!);
    }

    // Adjust for style preference
    adjusted = _adjustForStyle(adjusted, profile.preferredStyle);

    // Add context for life phase
    if (profile.currentLifePhase != null) {
      adjusted = _addLifePhaseContext(adjusted, profile.currentLifePhase!);
    }

    // Adjust for cultural background
    if (profile.culturalBackground != null) {
      adjusted = _adjustForCulture(adjusted, profile.culturalBackground!);
    }

    return adjusted;
  }

  String _adjustForAge(String text, int age) {
    if (age < 25) {
      // Younger language, more emoji hints
      return text.replaceAll('subconscious', 'inner world');
    } else if (age > 60) {
      // Wiser, mature language
      return text.replaceAll('development', 'maturation');
    }
    return text;
  }

  String _adjustForStyle(String text, DreamStyle style) {
    switch (style) {
      case DreamStyle.practical:
        // Less mystical, more concrete
        return text
            .replaceAll(
              'the universe is sending you a message',
              'your subconscious is telling you something',
            )
            .replaceAll('cosmic', 'deep');
      case DreamStyle.spiritual:
        // More spiritual emphasis
        return text
            .replaceAll('subconscious', 'soul')
            .replaceAll('psychological', 'spiritual');
      case DreamStyle.esoteric:
        // Ancient wisdom emphasis
        return text
            .replaceAll('analysis', 'reading')
            .replaceAll('interpretation', 'discovery');
      case DreamStyle.psychological:
        // Scientific language
        return text
            .replaceAll('ancient', 'psychological')
            .replaceAll('mystical', 'unconscious');
      default:
        return text;
    }
  }

  String _addLifePhaseContext(String text, String phaseId) {
    final phase = LifePhaseData.getPhase(phaseId);
    if (phase != null) {
      return '$text\n\n${phase.emoji} **Life Phase Context:** ${phase.advice}';
    }
    return text;
  }

  String _adjustForCulture(String text, String culture) {
    // Adjust cultural references
    switch (culture.toLowerCase()) {
      case 'turkish':
        // Turkish cultural references
        return text;
      case 'western':
        return text.replaceAll(
          'ancient sages',
          'psychologists like Jung and Freud',
        );
      default:
        return text;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // AI PROMPT GENERATION
  // ═══════════════════════════════════════════════════════════════════════

  /// Generate personalized AI prompt
  Future<String> generatePersonalizedPrompt(
    DreamInput input,
    UserDreamProfile profile,
  ) async {
    final context = await buildContext(profile.userId, DateTime.now());
    final recentSymbols = _getRecentSymbolPatterns(profile);
    final styleGuide = _getStyleGuide(profile.preferredStyle);

    final buffer = StringBuffer();

    buffer.writeln('=== PERSONALIZED DREAM INTERPRETATION INSTRUCTION ===\n');

    // User profile
    buffer.writeln('USER PROFILE:');
    if (profile.sunSign != null) {
      buffer.writeln('- Sun Sign: ${profile.sunSign}');
    }
    if (profile.moonSign != null) {
      buffer.writeln('- Moon Sign: ${profile.moonSign}');
    }
    if (profile.risingSign != null) {
      buffer.writeln('- Rising: ${profile.risingSign}');
    }
    if (profile.age != null) {
      buffer.writeln('- Age: ${profile.age}');
    }
    if (profile.currentLifePhase != null) {
      final phase = LifePhaseData.getPhase(profile.currentLifePhase!);
      buffer.writeln(
        '- Life Phase: ${phase?.label ?? profile.currentLifePhase}',
      );
    }
    if (profile.lifeAreas.isNotEmpty) {
      buffer.writeln('- Focus Areas: ${profile.lifeAreas.join(", ")}');
    }
    if (profile.recentLifeEvents.isNotEmpty) {
      buffer.writeln(
        '- Recent Life Events: ${profile.recentLifeEvents.join(", ")}',
      );
    }

    buffer.writeln('\n');

    // Dream data
    buffer.writeln('DREAM:');
    buffer.writeln('"${input.dreamDescription}"');
    buffer.writeln('\n');

    // Emotional tone
    if (input.dominantEmotion != null) {
      buffer.writeln('DOMINANT EMOTION: ${input.dominantEmotion!.label}');
    }
    if (input.wakingFeeling != null) {
      buffer.writeln('FEELING AFTER WAKING: ${input.wakingFeeling}');
    }
    if (input.isRecurring) {
      buffer.writeln(
        'RECURRING DREAM: Yes (${input.recurringCount ?? "?"} times)',
      );
    }

    buffer.writeln('\n');

    // Context
    buffer.writeln('CONTEXT:');
    buffer.writeln(
      '- Moon Phase: ${context.moonPhase.label} ${context.moonPhase.emoji}',
    );
    if (context.moonSign != null) {
      buffer.writeln('- Moon Sign: ${context.moonSign}');
    }
    if (context.activeTransits.isNotEmpty) {
      buffer.writeln('- Active Transits: ${context.activeTransits.join(", ")}');
    }
    if (context.currentRetrograde != null) {
      buffer.writeln('- Retrograde: ${context.currentRetrograde}');
    }
    buffer.writeln('- Season: ${context.season}');
    buffer.writeln('- Day: ${context.dayOfWeek}');

    buffer.writeln('\n');

    // Personal symbol history
    if (recentSymbols.isNotEmpty) {
      buffer.writeln('PERSONAL SYMBOL HISTORY:');
      for (final entry in recentSymbols.entries.take(5)) {
        buffer.writeln('- ${entry.key}: seen ${entry.value} times');
        final personalMeaning = getPersonalSymbolMeaning(profile, entry.key);
        if (personalMeaning != null) {
          buffer.writeln('  Personal meaning: $personalMeaning');
        }
      }
      buffer.writeln('\n');
    }

    // Connection with previous dreams
    if (context.recentDreams.isNotEmpty) {
      buffer.writeln('DREAMS IN THE LAST 7 DAYS:');
      for (final dream in context.recentDreams.take(3)) {
        buffer.writeln(
          '- ${dream.dreamDate.day}/${dream.dreamDate.month}: '
          '${dream.content.length > 50 ? "${dream.content.substring(0, 50)}..." : dream.content}',
        );
        if (dream.symbols.isNotEmpty) {
          buffer.writeln('  Symbols: ${dream.symbols.join(", ")}');
        }
      }
      buffer.writeln('\n');
    }

    // Style guide
    buffer.writeln('INTERPRETATION STYLE: ${profile.preferredStyle.label}');
    buffer.writeln(styleGuide);
    buffer.writeln('\n');

    // Special instructions
    buffer.writeln('SPECIAL INSTRUCTIONS:');
    buffer.writeln(
      '1. Integrate the user\'s zodiac profile into the interpretation',
    );
    buffer.writeln('2. Consider personal symbol meanings');
    buffer.writeln('3. Give advice appropriate to life phase');
    buffer.writeln('4. Connect with previous dreams (if any)');
    buffer.writeln('5. ${profile.preferredStyle.description}');

    if (profile.age != null) {
      if (profile.age! < 25) {
        buffer.writeln('6. Use young and energetic language');
      } else if (profile.age! > 55) {
        buffer.writeln('6. Use wise and mature language');
      }
    }

    return buffer.toString();
  }

  Map<String, int> _getRecentSymbolPatterns(UserDreamProfile profile) {
    // Sort by frequency
    final sorted = profile.symbolFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sorted.take(10));
  }

  String _getStyleGuide(
    DreamStyle style, {
    AppLanguage language = AppLanguage.en,
  }) {
    final key = 'dream_personalization.style_guides.${style.name}';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;
    // Fallback
    switch (style) {
      case DreamStyle.jungian:
        return '''
- Focus on archetypes: Shadow, Anima/Animus, Wise Old Man, etc.
- Emphasize the individuation process
- Provide references from the collective unconscious
- Distinguish between universal and personal meanings of symbols''';
      case DreamStyle.spiritual:
        return '''
- Write in a spiritual guidance tone
- Emphasize cosmic messages and signs
- Add meditation and spiritual practice suggestions
- Talk about higher self and spiritual development''';
      case DreamStyle.practical:
        return '''
- Give concrete and actionable advice
- Make direct connections to daily life
- Use minimal mystical language
- Approach with problem-solving focus''';
      case DreamStyle.esoteric:
        return '''
- Reference ancient wisdom and mystical traditions
- Open deeper layers of symbolism
- Use esoteric concepts but explain them
- Make references to hidden teachings''';
      case DreamStyle.psychological:
        return '''
- Use scientific psychology terminology
- Suggest emotion regulation and coping strategies
- Identify defense mechanisms
- Offer therapeutic insights''';
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // USER INSIGHTS
  // ═══════════════════════════════════════════════════════════════════════

  /// Get personal patterns
  List<String> getPersonalPatterns(
    UserDreamProfile profile, {
    AppLanguage language = AppLanguage.en,
  }) {
    final patterns = <String>[];

    // Symbol patterns
    final topSymbols = _getRecentSymbolPatterns(profile);
    if (topSymbols.isNotEmpty) {
      final topSymbol = topSymbols.entries.first;
      if (topSymbol.value >= 3) {
        final key = 'dream_personalization.patterns.symbol_frequency';
        final localized = L10nService.get(key, language);
        if (localized != key) {
          patterns.add(
            localized
                .replaceAll('{symbol}', topSymbol.key.toUpperCase())
                .replaceAll('{count}', topSymbol.value.toString()),
          );
        } else {
          patterns.add(
            'The ${topSymbol.key.toUpperCase()} symbol appears frequently in your dreams (${topSymbol.value} times). '
            'This may hold special meaning for you.',
          );
        }
      }
    }

    // Emotional patterns
    if (profile.dominantDreamEmotion != null) {
      final key = 'dream_personalization.patterns.dominant_emotion';
      final localized = L10nService.get(key, language);
      if (localized != key) {
        patterns.add(
          localized
              .replaceAll(
                '{emotion}',
                profile.dominantDreamEmotion!.label.toLowerCase(),
              )
              .replaceAll('{hint}', profile.dominantDreamEmotion!.hint),
        );
      } else {
        patterns.add(
          'The ${profile.dominantDreamEmotion!.label.toLowerCase()} emotion is most dominant in your dreams. '
          '${profile.dominantDreamEmotion!.hint}',
        );
      }
    }

    // Lucid dream tendency
    if (profile.lucidDreamFrequency > 0.3) {
      final key = 'dream_personalization.patterns.lucid_tendency';
      final localized = L10nService.get(key, language);
      patterns.add(
        localized != key
            ? localized
            : 'Your lucid dream experience is above average. You can use '
                  'MILD or reality check techniques to develop this awareness.',
      );
    }

    // Nightmare frequency
    if (profile.nightmareFrequency > 0.2) {
      final key = 'dream_personalization.patterns.nightmare_frequency';
      final localized = L10nService.get(key, language);
      patterns.add(
        localized != key
            ? localized
            : 'Your nightmare frequency seems a bit high. This may indicate '
                  'unprocessed emotional material or stress periods.',
      );
    }

    // Recurring themes
    if (profile.recurringThemes.isNotEmpty) {
      final key = 'dream_personalization.patterns.recurring_themes';
      final localized = L10nService.get(key, language);
      if (localized != key) {
        patterns.add(
          localized.replaceAll('{themes}', profile.recurringThemes.join(", ")),
        );
      } else {
        patterns.add(
          'Recurring themes: ${profile.recurringThemes.join(", ")}. '
          'These themes show topics that your subconscious is continuously processing.',
        );
      }
    }

    return patterns;
  }

  /// User-specific transit information
  Future<List<String>> getRelevantTransitsForUser(
    String userId, {
    AppLanguage language = AppLanguage.en,
  }) async {
    final profile = await getOrCreateProfile(userId);
    final now = DateTime.now();

    final transits = <String>[];

    if (profile.sunSign == null) {
      final key = 'dream_personalization.transits.add_birth_info';
      final localized = L10nService.get(key, language);
      return [
        localized != key
            ? localized
            : 'You can see your personal transits by adding your birth information.',
      ];
    }

    // Check Moon transit
    final currentMoonSign = _calculateMoonSign(now);
    if (currentMoonSign != null) {
      if (currentMoonSign == profile.sunSign) {
        final key = 'dream_personalization.transits.moon_in_sign';
        final localized = L10nService.get(key, language);
        transits.add(
          localized != key
              ? localized.replaceAll('{sign}', profile.sunSign!)
              : 'Moon is in your sign (${profile.sunSign}) - Emotional intensity and intuition increase',
        );
      }
      if (currentMoonSign == profile.moonSign) {
        final key = 'dream_personalization.transits.moon_natal';
        final localized = L10nService.get(key, language);
        transits.add(
          localized != key
              ? localized.replaceAll('{sign}', profile.moonSign!)
              : 'Moon is in your natal Moon sign (${profile.moonSign}) - Deep connection with inner world',
        );
      }
    }

    // Check retrograde
    final retrograde = _getCurrentRetrograde(now);
    if (retrograde != null) {
      final key = 'dream_personalization.transits.retrograde_active';
      final localized = L10nService.get(key, language);
      transits.add(
        localized != key
            ? localized.replaceAll('{planet}', retrograde)
            : '$retrograde retrograde active - Dreams about the past likely',
      );
    }

    // Moon phase - basic info without undefined AstroDreamCorrelations
    final moonPhase = MoonPhaseCalculator.calculate(now);
    final phaseKey = 'dream_personalization.transits.moon_phase';
    final phaseLocalized = L10nService.get(phaseKey, language);
    transits.add(
      phaseLocalized != phaseKey
          ? phaseLocalized.replaceAll('{phase}', moonPhase.name)
          : 'Moon phase: ${moonPhase.name} - affects dream clarity',
    );

    if (transits.isEmpty) {
      final noTransitKey = 'dream_personalization.transits.no_transits';
      final noTransitLocalized = L10nService.get(noTransitKey, language);
      return [
        noTransitLocalized != noTransitKey
            ? noTransitLocalized
            : 'No significant active transits at the moment.',
      ];
    }

    return transits;
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ZODIAC-BASED PERSONALIZATION
  // ═══════════════════════════════════════════════════════════════════════

  /// Zodiac-specific interpretation adjustment
  String getZodiacAdjustedInterpretation(
    String baseInterpretation,
    UserDreamProfile profile,
  ) {
    if (profile.sunSign == null) return baseInterpretation;

    final zodiacProfile = ZodiacDreamInsights.getProfile(profile.sunSign!);
    if (zodiacProfile == null) return baseInterpretation;

    final buffer = StringBuffer(baseInterpretation);

    buffer.writeln('\n\n---');
    buffer.writeln(
      '${zodiacProfile.emoji} **${zodiacProfile.sign} Perspective:**',
    );
    buffer.writeln(zodiacProfile.dreamAdvice);

    // Add Moon sign too
    if (profile.moonSign != null) {
      final moonProfile = ZodiacDreamInsights.getProfile(profile.moonSign!);
      if (moonProfile != null) {
        buffer.writeln('\n**Your Moon Sign (${moonProfile.sign}) Influence:**');
        buffer.writeln(
          'Your emotional processing style revolves around themes of: ${moonProfile.commonThemes.take(3).join(", ")}.',
        );
      }
    }

    return buffer.toString();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // STATISTICS
  // ═══════════════════════════════════════════════════════════════════════

  /// User dream statistics
  Future<Map<String, dynamic>> getUserDreamStats(String userId) async {
    final profile = await getOrCreateProfile(userId);

    final stats = <String, dynamic>{
      'profileCompletion': '${(profile.completionPercentage * 100).toInt()}%',
      'totalSymbols': profile.symbolFrequency.length,
      'mostFrequentSymbol': _getTopSymbol(profile),
      'personalMeanings': profile.personalSymbolMeanings.length,
      'recurringThemes': profile.recurringThemes.length,
      'lucidRatio': '${(profile.lucidDreamFrequency * 100).toInt()}%',
      'nightmareRatio': '${(profile.nightmareFrequency * 100).toInt()}%',
      'feedbackCount': profile.feedbackHistory.length,
      'averageRating': getAverageRating(profile).toStringAsFixed(1),
      'preferredStyle': profile.preferredStyle.label,
    };

    if (profile.hasAstrologyData) {
      stats['zodiacProfile'] = {
        'sun': profile.sunSign,
        'moon': profile.moonSign,
        'rising': profile.risingSign,
      };
    }

    return stats;
  }

  String? _getTopSymbol(UserDreamProfile profile) {
    if (profile.symbolFrequency.isEmpty) return null;

    final sorted = profile.symbolFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.first.key;
  }
}

// ════════════════════════════════════════════════════════════════════════════
// PERSONALIZATION HELPER METHODS
// ════════════════════════════════════════════════════════════════════════════

/// Personalization helpers
class PersonalizationHelpers {
  /// Language level suggestion based on age
  static String getLanguageLevelForAge(
    int age, {
    AppLanguage language = AppLanguage.en,
  }) {
    String levelKey;
    if (age < 18) {
      levelKey = 'young';
    } else if (age < 30) {
      levelKey = 'young_adult';
    } else if (age < 50) {
      levelKey = 'middle_age';
    } else if (age < 65) {
      levelKey = 'mature';
    } else {
      levelKey = 'elder_sage';
    }
    final key = 'dream_personalization.language_levels.$levelKey';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;
    // Fallback
    return levelKey.replaceAll('_', ' ');
  }

  /// Focus symbols for life area
  static List<String> getFocusSymbolsForLifeArea(
    String area, {
    AppLanguage language = AppLanguage.en,
  }) {
    final key = 'dream_personalization.focus_symbols.${area.toLowerCase()}';
    final localized = L10nService.getList(key, language);
    if (localized.isNotEmpty && localized.first != key) return localized;
    // Fallback
    final focusSymbols = {
      'career': ['office', 'boss', 'money', 'success', 'stairs', 'building'],
      'love': [
        'partner',
        'marriage',
        'heart',
        'kiss',
        'stranger',
        'separation',
      ],
      'health': ['hospital', 'doctor', 'body', 'medicine', 'healing', 'pain'],
      'family': ['mother', 'father', 'home', 'child', 'sibling', 'relative'],
      'finance': ['money', 'bank', 'debt', 'wealth', 'loss', 'finding'],
      'education': ['school', 'exam', 'teacher', 'book', 'learning', 'diploma'],
      'spiritual': ['light', 'flight', 'angel', 'god', 'temple', 'meditation'],
    };

    return focusSymbols[area.toLowerCase()] ?? [];
  }

  /// Additional interpretation based on season
  static String getSeasonalInsight(
    String season, {
    AppLanguage language = AppLanguage.en,
  }) {
    final key =
        'dream_personalization.seasonal_insights.${season.toLowerCase()}';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;
    // Fallback
    switch (season.toLowerCase()) {
      case 'spring':
        return 'Spring energy supports new beginnings and rebirth. '
            'Sprouting seeds and blooming flowers in your dreams carry hope.';
      case 'summer':
        return 'Summer energy brings extroversion and abundance. '
            'Sun and warmth in your dreams represent life force.';
      case 'autumn':
        return 'Autumn is a time for letting go and harvest. '
            'Falling leaves and harvest symbols in your dreams indicate completion.';
      case 'winter':
        return 'Winter is a time for introspection and rest. '
            'Snow and cold in your dreams represent cleansing and preparation for a new beginning.';
      default:
        return '';
    }
  }

  /// Dream tendency based on day of the week
  static String getDayOfWeekInsight(
    String day, {
    AppLanguage language = AppLanguage.en,
  }) {
    final key = 'dream_personalization.day_insights.$day';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;
    // Fallback
    final insights = {
      'Monday': 'Monday dreams usually reflect work and responsibility themes.',
      'Tuesday':
          'Mars day Tuesday is prone to action and energy-filled dreams.',
      'Wednesday':
          'Mercury day Wednesday brings communication and message-filled dreams.',
      'Thursday':
          'Jupiter day Thursday may feature expansion and luck-themed dreams.',
      'Friday': 'Venus day Friday is open to love and beauty dreams.',
      'Saturday':
          'Saturn day Saturday brings dreams about boundaries and structure.',
      'Sunday':
          'Sun day Sunday is conducive to self and identity discovery dreams.',
    };

    return insights[day] ?? '';
  }
}
