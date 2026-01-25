/// Dream Personalization Service - Kişiselleştirilmiş Rüya Yorumlama Motoru
/// Kullanıcı verisine dayalı derin kişiselleştirme, adaptif öğrenme, astrolojik entegrasyon
library;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dream_interpretation_models.dart';
import '../models/dream_memory.dart';
import '../content/dream_advanced_content.dart';
import 'dream_memory_service.dart';
import 'dream_interpretation_service.dart';

// ════════════════════════════════════════════════════════════════════════════
// KULLANICI RÜYA PROFİLİ
// ════════════════════════════════════════════════════════════════════════════

/// Rüya yorumlama stilleri
enum DreamStyle {
  jungian('Jungian', 'Arketip odaklı, gölge çalışması, bilinçdışı analiz'),
  spiritual('Spiritüel', 'Kozmik mesajlar, ruhani rehberlik, mistik yorumlama'),
  practical('Pratik', 'Günlük yaşam odaklı, eylem önerileri, somut tavsiyeler'),
  esoteric('Ezoterik', 'Kadim bilgelik, sembolizm, gizli öğretiler'),
  psychological('Psikolojik', 'Modern psikoloji perspektifi, duygusal analiz');

  final String label;
  final String description;
  const DreamStyle(this.label, this.description);
}

/// Kullanıcı rüya profili - Kişiselleştirmenin temel modeli
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
        symbolFrequency:
            Map<String, int>.from(json['symbolFrequency'] ?? {}),
        personalSymbolMeanings:
            Map<String, String>.from(json['personalSymbolMeanings'] ?? {}),
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
        feedbackHistory: (json['feedbackHistory'] as List?)
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
  }) =>
      UserDreamProfile(
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
        dominantDreamEmotion:
            dominantDreamEmotion ?? this.dominantDreamEmotion,
        lucidDreamFrequency:
            lucidDreamFrequency ?? this.lucidDreamFrequency,
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

  /// Profil tamamlanma yüzdesi
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

  /// Astroloji verisi var mı?
  bool get hasAstrologyData =>
      sunSign != null || moonSign != null || risingSign != null;

  /// Yaşam bağlamı var mı?
  bool get hasLifeContext =>
      currentLifePhase != null ||
      lifeAreas.isNotEmpty ||
      recentLifeEvents.isNotEmpty;
}

/// Yorum geri bildirimi
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
        notResonatingParts:
            List<String>.from(json['notResonatingParts'] ?? []),
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
      );
}

// ════════════════════════════════════════════════════════════════════════════
// RÜYA BAĞLAMI
// ════════════════════════════════════════════════════════════════════════════

/// Rüya yorumlama için bağlam verisi
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
// YAŞAM EVRELERİ
// ════════════════════════════════════════════════════════════════════════════

/// Yaşam evreleri ve rüya etkileri
class LifePhaseData {
  static const Map<String, LifePhaseInfo> phases = {
    'ogrenci': LifePhaseInfo(
      id: 'ogrenci',
      label: 'Öğrenci',
      emoji: '📚',
      commonDreamThemes: [
        'Sınavlar',
        'geç kalma',
        'hazırlıksız yakalanma',
        'okul'
      ],
      interpretationFocus: 'Performans kaygısı, gelecek belirsizliği, öğrenme',
      advice:
          'Rüyalardaki sınav temaları genellikle hayatındaki değerlendirme anlarını yansıtır.',
    ),
    'yeni_ebeveyn': LifePhaseInfo(
      id: 'yeni_ebeveyn',
      label: 'Yeni Ebeveyn',
      emoji: '👶',
      commonDreamThemes: [
        'Bebek',
        'koruma',
        'kaybolma',
        'yetersizlik',
        'büyük sorumluluk'
      ],
      interpretationFocus:
          'Koruma içgüdüsü, kimlik değişimi, yeni sorumluluklar',
      advice:
          'Bebek rüyaları yeni projeleri veya kimliğinin yeni yönlerini de temsil edebilir.',
    ),
    'kariyer_degisimi': LifePhaseInfo(
      id: 'kariyer_degisimi',
      label: 'Kariyer Değişimi',
      emoji: '💼',
      commonDreamThemes: [
        'Kaybolma',
        'yeni binalar',
        'yolculuk',
        'geç kalma',
        'hazırlıksız'
      ],
      interpretationFocus: 'Kimlik sorgulaması, güvensizlik, fırsatlar',
      advice:
          'Yeni mekanlar rüyanda yeni olasılıkları, kaybolma ise belirsizliği temsil eder.',
    ),
    'yas_tutan': LifePhaseInfo(
      id: 'yas_tutan',
      label: 'Yas Sürecinde',
      emoji: '🖤',
      commonDreamThemes: [
        'Kaybedilen kişi',
        'vedalaşma',
        'arayış',
        'yeniden buluşma'
      ],
      interpretationFocus: 'Kayıp işleme, tamamlanmamış iş, ruhani bağlantı',
      advice:
          'Kaybettiğin kişiyi rüyanda görmek doğal bir yas sürecidir ve şifa taşır.',
    ),
    'emekli': LifePhaseInfo(
      id: 'emekli',
      label: 'Emekli',
      emoji: '🌅',
      commonDreamThemes: [
        'Eski iş yeri',
        'zaman',
        'gençlik',
        'tamamlanma',
        'miras'
      ],
      interpretationFocus: 'Yaşam değerlendirmesi, anlam arayışı, miras',
      advice:
          'Geçmişe dair rüyalar yaşamını gözden geçirme ve bilgelik toparlama sürecidir.',
    ),
    'iliski_krizi': LifePhaseInfo(
      id: 'iliski_krizi',
      label: 'İlişki Krizi',
      emoji: '💔',
      commonDreamThemes: [
        'Partner',
        'ihanet',
        'kavga',
        'ayrılık',
        'yabancı partner'
      ],
      interpretationFocus: 'İlişki dinamikleri, güven, iletişim',
      advice:
          'Partner rüyaları çoğu zaman içindeki anima/animus ile ilişkini yansıtır.',
    ),
    'saglik_krizi': LifePhaseInfo(
      id: 'saglik_krizi',
      label: 'Sağlık Mücadelesi',
      emoji: '🏥',
      commonDreamThemes: [
        'Beden',
        'şifa',
        'hastane',
        'dönüşüm',
        'ölüm ve yeniden doğuş'
      ],
      interpretationFocus: 'Beden bilinci, şifa, ölümlülük farkındalığı',
      advice:
          'Bedenle ilgili rüyalar genellikle fiziksel durumunla ilgili mesajlar taşır.',
    ),
    'spiritüel_uyanis': LifePhaseInfo(
      id: 'spiritüel_uyanis',
      label: 'Spiritüel Uyanış',
      emoji: '✨',
      commonDreamThemes: [
        'Işık',
        'rehberler',
        'uçuş',
        'kozmik deneyimler',
        'ölüm ve yeniden doğuş'
      ],
      interpretationFocus: 'Ruhani gelişim, aşkın deneyimler, anlam arayışı',
      advice:
          'Spiritüel rüyalar yükselişin işaretleridir, mesajları ciddiye al.',
    ),
    'yeni_baslangic': LifePhaseInfo(
      id: 'yeni_baslangic',
      label: 'Yeni Başlangıç',
      emoji: '🌱',
      commonDreamThemes: [
        'Bebek',
        'tohumlar',
        'yeni ev',
        'yolculuk başlangıcı'
      ],
      interpretationFocus: 'Potansiyel, umut, büyüme fırsatları',
      advice:
          'Yeni başlangıç sembolleri içindeki potansiyeli ve büyüme alanlarını gösterir.',
    ),
  };

  static LifePhaseInfo? getPhase(String phaseId) {
    return phases[phaseId.toLowerCase().replaceAll(' ', '_')];
  }

  static List<String> get allPhaseIds => phases.keys.toList();
}

/// Yaşam evresi bilgisi
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
}

// ════════════════════════════════════════════════════════════════════════════
// KİŞİSELLEŞTİRME SERVİSİ
// ════════════════════════════════════════════════════════════════════════════

/// Ana kişiselleştirme servisi
class DreamPersonalizationService {
  static const String _profileKey = 'dream_profile_';
  static const String _feedbackKey = 'dream_feedback_';
  static const String _personalSymbolsKey = 'personal_symbols_';
  static const String _learningDataKey = 'dream_learning_';

  final SharedPreferences _prefs;
  final DreamMemoryService? memoryService;

  DreamPersonalizationService(this._prefs, {this.memoryService});

  /// Servisi başlat
  static Future<DreamPersonalizationService> init({
    DreamMemoryService? memoryService,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return DreamPersonalizationService(prefs, memoryService: memoryService);
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PROFİL YÖNETİMİ
  // ═══════════════════════════════════════════════════════════════════════

  /// Profil al veya oluştur
  Future<UserDreamProfile> getOrCreateProfile(String userId) async {
    final key = '$_profileKey$userId';
    final json = _prefs.getString(key);

    if (json != null) {
      try {
        return UserDreamProfile.fromJson(jsonDecode(json));
      } catch (e) {
        debugPrint('Profil yükleme hatası: $e');
      }
    }

    // Yeni profil oluştur
    final newProfile = UserDreamProfile(
      userId: userId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _saveProfile(newProfile);
    return newProfile;
  }

  /// Profili güncelle
  Future<void> updateProfile(UserDreamProfile profile) async {
    final updatedProfile = profile.copyWith(updatedAt: DateTime.now());
    await _saveProfile(updatedProfile);
  }

  Future<void> _saveProfile(UserDreamProfile profile) async {
    final key = '$_profileKey${profile.userId}';
    await _prefs.setString(key, jsonEncode(profile.toJson()));
  }

  /// Profili sil
  Future<void> deleteProfile(String userId) async {
    await _prefs.remove('$_profileKey$userId');
    await _prefs.remove('$_feedbackKey$userId');
    await _prefs.remove('$_personalSymbolsKey$userId');
    await _prefs.remove('$_learningDataKey$userId');
  }

  // ═══════════════════════════════════════════════════════════════════════
  // SEMBOL ÖĞRENME
  // ═══════════════════════════════════════════════════════════════════════

  /// Sembol görünümünü kaydet
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

    // Öğrenme verisi güncelle
    await _updateLearningData(userId, symbol, context, emotion);
  }

  /// Kişisel sembol anlamı kaydet
  Future<void> setPersonalSymbolMeaning(
    String userId,
    String symbol,
    String meaning,
  ) async {
    final profile = await getOrCreateProfile(userId);

    final updatedMeanings =
        Map<String, String>.from(profile.personalSymbolMeanings);
    updatedMeanings[symbol] = meaning;

    final updatedProfile =
        profile.copyWith(personalSymbolMeanings: updatedMeanings);
    await updateProfile(updatedProfile);
  }

  /// Kişisel sembol anlamı al
  String? getPersonalSymbolMeaning(UserDreamProfile profile, String symbol) {
    return profile.personalSymbolMeanings[symbol.toLowerCase()];
  }

  /// Kişisel sembol sözlüğü
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

    // Sembol öğrenme verisini güncelle
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
  // GERİ BİLDİRİM
  // ═══════════════════════════════════════════════════════════════════════

  /// Yorum geri bildirimi kaydet
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

    final updatedFeedback =
        List<InterpretationFeedback>.from(profile.feedbackHistory);
    updatedFeedback.add(newFeedback);

    // Son 100 geri bildirimi tut
    if (updatedFeedback.length > 100) {
      updatedFeedback.removeRange(0, updatedFeedback.length - 100);
    }

    final updatedProfile = profile.copyWith(feedbackHistory: updatedFeedback);
    await updateProfile(updatedProfile);

    // Geri bildirimi ayrıca kaydet
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

    // Son 200 geri bildirimi tut
    if (feedbackList.length > 200) {
      feedbackList.removeRange(0, feedbackList.length - 200);
    }

    await _prefs.setString(key, jsonEncode(feedbackList));
  }

  /// Ortalama yorum puanı
  double getAverageRating(UserDreamProfile profile) {
    if (profile.feedbackHistory.isEmpty) return 0.0;

    final total =
        profile.feedbackHistory.fold(0, (sum, f) => sum + f.rating);
    return total / profile.feedbackHistory.length;
  }

  // ═══════════════════════════════════════════════════════════════════════
  // BAĞLAM OLUŞTURMA
  // ═══════════════════════════════════════════════════════════════════════

  /// Rüya bağlamı oluştur
  Future<DreamContext> buildContext(String userId, DateTime dreamTime) async {
    final profile = await getOrCreateProfile(userId);
    List<Dream> recentDreams = [];

    // Memory service varsa son rüyaları al
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
    // Basit ay burcu hesabı (yaklaşık 2.5 gün her burçta)
    final signs = [
      'Koç',
      'Boğa',
      'İkizler',
      'Yengeç',
      'Aslan',
      'Başak',
      'Terazi',
      'Akrep',
      'Yay',
      'Oğlak',
      'Kova',
      'Balık'
    ];

    // Referans: 1 Ocak 2000 00:00 UTC - Ay Yengeç'te başlıyor
    final reference = DateTime.utc(2000, 1, 1);
    final daysSince = date.difference(reference).inDays;
    final lunarCycle = 27.32; // Sidereal ay döngüsü
    final daysPerSign = lunarCycle / 12;

    final signIndex = ((daysSince % lunarCycle) / daysPerSign).floor() % 12;
    return signs[signIndex];
  }

  List<String> _getActiveTransits(UserDreamProfile profile, DateTime date) {
    final transits = <String>[];

    // Kullanıcının doğum verisi varsa ilgili transitleri hesapla
    if (profile.sunSign != null) {
      // Basit transit önerileri
      final moonSign = _calculateMoonSign(date);
      if (moonSign != null) {
        if (_isCompatibleSign(profile.sunSign!, moonSign)) {
          transits.add('Ay $moonSign\'de - uyumlu akış');
        } else if (_isChallengeSign(profile.sunSign!, moonSign)) {
          transits.add('Ay $moonSign\'de - iç gerilim olası');
        }
      }
    }

    // Genel transit bilgileri
    final month = date.month;
    if (month == 3 || month == 4) {
      transits.add('Koç sezonu - yeni başlangıçlar');
    } else if (month == 10 || month == 11) {
      transits.add('Akrep sezonu - dönüşüm dönemi');
    }

    return transits;
  }

  bool _isCompatibleSign(String sign1, String sign2) {
    final compatible = {
      'Koç': ['Aslan', 'Yay', 'İkizler', 'Kova'],
      'Boğa': ['Başak', 'Oğlak', 'Yengeç', 'Balık'],
      'İkizler': ['Terazi', 'Kova', 'Koç', 'Aslan'],
      'Yengeç': ['Akrep', 'Balık', 'Boğa', 'Başak'],
      'Aslan': ['Koç', 'Yay', 'İkizler', 'Terazi'],
      'Başak': ['Boğa', 'Oğlak', 'Yengeç', 'Akrep'],
      'Terazi': ['İkizler', 'Kova', 'Aslan', 'Yay'],
      'Akrep': ['Yengeç', 'Balık', 'Başak', 'Oğlak'],
      'Yay': ['Koç', 'Aslan', 'Terazi', 'Kova'],
      'Oğlak': ['Boğa', 'Başak', 'Akrep', 'Balık'],
      'Kova': ['İkizler', 'Terazi', 'Koç', 'Yay'],
      'Balık': ['Yengeç', 'Akrep', 'Boğa', 'Oğlak'],
    };
    return compatible[sign1]?.contains(sign2) ?? false;
  }

  bool _isChallengeSign(String sign1, String sign2) {
    final challenge = {
      'Koç': ['Yengeç', 'Oğlak'],
      'Boğa': ['Aslan', 'Kova'],
      'İkizler': ['Başak', 'Balık'],
      'Yengeç': ['Koç', 'Terazi'],
      'Aslan': ['Boğa', 'Akrep'],
      'Başak': ['İkizler', 'Yay'],
      'Terazi': ['Yengeç', 'Oğlak'],
      'Akrep': ['Aslan', 'Kova'],
      'Yay': ['Başak', 'Balık'],
      'Oğlak': ['Koç', 'Terazi'],
      'Kova': ['Boğa', 'Akrep'],
      'Balık': ['İkizler', 'Yay'],
    };
    return challenge[sign1]?.contains(sign2) ?? false;
  }

  String? _getCurrentRetrograde(DateTime date) {
    // Basit retro takvimi (2024-2025)
    final year = date.year;
    final month = date.month;
    final day = date.day;

    // Merkür retro dönemleri (yılda yaklaşık 3 kez)
    final merkurRetros = [
      [1, 1, 1, 25], // Ocak başı
      [4, 1, 4, 25], // Nisan
      [8, 5, 8, 28], // Ağustos
      [11, 25, 12, 15], // Kasım sonu - Aralık ortası
    ];

    for (final retro in merkurRetros) {
      if ((month == retro[0] && day >= retro[1]) ||
          (month == retro[2] && day <= retro[3])) {
        return 'Merkür';
      }
    }

    // Venüs retro (her 18 ayda bir, yaklaşık 40 gün)
    if ((year == 2024 && month >= 3 && month <= 4) ||
        (year == 2025 && month >= 3 && month <= 4)) {
      return 'Venüs';
    }

    return null;
  }

  String _getSeason(DateTime date) {
    final month = date.month;
    if (month >= 3 && month <= 5) return 'İlkbahar';
    if (month >= 6 && month <= 8) return 'Yaz';
    if (month >= 9 && month <= 11) return 'Sonbahar';
    return 'Kış';
  }

  String _getDayOfWeek(DateTime date) {
    final days = [
      'Pazartesi',
      'Salı',
      'Çarşamba',
      'Perşembe',
      'Cuma',
      'Cumartesi',
      'Pazar'
    ];
    return days[date.weekday - 1];
  }

  // ═══════════════════════════════════════════════════════════════════════
  // KİŞİSELLEŞTİRİLMİŞ YORUM
  // ═══════════════════════════════════════════════════════════════════════

  /// Kullanıcıya göre yorum ayarla
  String adjustInterpretationForUser(
    String interpretation,
    UserDreamProfile profile,
  ) {
    var adjusted = interpretation;

    // Yaş grubuna göre dil ayarla
    if (profile.age != null) {
      adjusted = _adjustForAge(adjusted, profile.age!);
    }

    // Stil terciğine göre ayarla
    adjusted = _adjustForStyle(adjusted, profile.preferredStyle);

    // Yaşam evresine göre bağlam ekle
    if (profile.currentLifePhase != null) {
      adjusted = _addLifePhaseContext(adjusted, profile.currentLifePhase!);
    }

    // Kültürel arka plana göre ayarla
    if (profile.culturalBackground != null) {
      adjusted =
          _adjustForCulture(adjusted, profile.culturalBackground!);
    }

    return adjusted;
  }

  String _adjustForAge(String text, int age) {
    if (age < 25) {
      // Daha genç dil, daha fazla emoji ipuçları
      return text.replaceAll('bilinçaltı', 'iç dünyan');
    } else if (age > 60) {
      // Daha bilge, olgun dil
      return text.replaceAll('gelişim', 'olgunlaşma');
    }
    return text;
  }

  String _adjustForStyle(String text, DreamStyle style) {
    switch (style) {
      case DreamStyle.practical:
        // Daha az mistik, daha fazla somut
        return text
            .replaceAll('evren sana mesaj gönderiyor', 'bilinçaltın sana bir şey söylüyor')
            .replaceAll('kozmik', 'derin');
      case DreamStyle.spiritual:
        // Daha spiritüel vurgu
        return text
            .replaceAll('bilinçaltı', 'ruhun')
            .replaceAll('psikolojik', 'spiritüel');
      case DreamStyle.esoteric:
        // Kadim bilgelik vurgusu
        return text
            .replaceAll('analiz', 'okuma')
            .replaceAll('yorum', 'keşif');
      case DreamStyle.psychological:
        // Bilimsel dil
        return text
            .replaceAll('kadim', 'psikolojik')
            .replaceAll('mistik', 'bilinçdışı');
      default:
        return text;
    }
  }

  String _addLifePhaseContext(String text, String phaseId) {
    final phase = LifePhaseData.getPhase(phaseId);
    if (phase != null) {
      return '$text\n\n${phase.emoji} **Yaşam Evren Bağlamı:** ${phase.advice}';
    }
    return text;
  }

  String _adjustForCulture(String text, String culture) {
    // Kültürel referansları ayarla
    switch (culture.toLowerCase()) {
      case 'türk':
      case 'turkish':
        // Türk kültürel referansları zaten mevcut
        return text;
      case 'batı':
      case 'western':
        return text.replaceAll('kadim bilgeler', 'Jung ve Freud gibi psikologlar');
      default:
        return text;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // AI PROMPT OLUŞTURMA
  // ═══════════════════════════════════════════════════════════════════════

  /// Kişiselleştirilmiş AI promptu oluştur
  Future<String> generatePersonalizedPrompt(
    DreamInput input,
    UserDreamProfile profile,
  ) async {
    final context = await buildContext(profile.userId, DateTime.now());
    final recentSymbols = _getRecentSymbolPatterns(profile);
    final styleGuide = _getStyleGuide(profile.preferredStyle);

    final buffer = StringBuffer();

    buffer.writeln('=== KİŞİSELLEŞTİRİLMİŞ RÜYA YORUMU TALİMATI ===\n');

    // Kullanıcı profili
    buffer.writeln('KULLANICI PROFİLİ:');
    if (profile.sunSign != null) {
      buffer.writeln('- Güneş Burcu: ${profile.sunSign}');
    }
    if (profile.moonSign != null) {
      buffer.writeln('- Ay Burcu: ${profile.moonSign}');
    }
    if (profile.risingSign != null) {
      buffer.writeln('- Yükselen: ${profile.risingSign}');
    }
    if (profile.age != null) {
      buffer.writeln('- Yaş: ${profile.age}');
    }
    if (profile.currentLifePhase != null) {
      final phase = LifePhaseData.getPhase(profile.currentLifePhase!);
      buffer.writeln('- Yaşam Evresi: ${phase?.label ?? profile.currentLifePhase}');
    }
    if (profile.lifeAreas.isNotEmpty) {
      buffer.writeln('- Odak Alanları: ${profile.lifeAreas.join(", ")}');
    }
    if (profile.recentLifeEvents.isNotEmpty) {
      buffer.writeln('- Son Yaşam Olayları: ${profile.recentLifeEvents.join(", ")}');
    }

    buffer.writeln('\n');

    // Rüya verisi
    buffer.writeln('RÜYA:');
    buffer.writeln('"${input.dreamDescription}"');
    buffer.writeln('\n');

    // Duygusal ton
    if (input.dominantEmotion != null) {
      buffer.writeln('HAKİM DUYGU: ${input.dominantEmotion!.label}');
    }
    if (input.wakingFeeling != null) {
      buffer.writeln('UYANDIKTAN SONRAKİ HİS: ${input.wakingFeeling}');
    }
    if (input.isRecurring) {
      buffer.writeln('TEKRARLAYAN RÜYA: Evet (${input.recurringCount ?? "?"} kez)');
    }

    buffer.writeln('\n');

    // Bağlam
    buffer.writeln('BAĞLAM:');
    buffer.writeln('- Ay Fazı: ${context.moonPhase.label} ${context.moonPhase.emoji}');
    if (context.moonSign != null) {
      buffer.writeln('- Ay Burcu: ${context.moonSign}');
    }
    if (context.activeTransits.isNotEmpty) {
      buffer.writeln('- Aktif Transitler: ${context.activeTransits.join(", ")}');
    }
    if (context.currentRetrograde != null) {
      buffer.writeln('- Retro: ${context.currentRetrograde}');
    }
    buffer.writeln('- Mevsim: ${context.season}');
    buffer.writeln('- Gün: ${context.dayOfWeek}');

    buffer.writeln('\n');

    // Kişisel sembol geçmişi
    if (recentSymbols.isNotEmpty) {
      buffer.writeln('KİŞİSEL SEMBOL GEÇMİŞİ:');
      for (final entry in recentSymbols.entries.take(5)) {
        buffer.writeln('- ${entry.key}: ${entry.value} kez görüldü');
        final personalMeaning =
            getPersonalSymbolMeaning(profile, entry.key);
        if (personalMeaning != null) {
          buffer.writeln('  Kişisel anlam: $personalMeaning');
        }
      }
      buffer.writeln('\n');
    }

    // Önceki rüyalarla bağlantı
    if (context.recentDreams.isNotEmpty) {
      buffer.writeln('SON 7 GÜNDEKİ RÜYALAR:');
      for (final dream in context.recentDreams.take(3)) {
        buffer.writeln('- ${dream.dreamDate.day}/${dream.dreamDate.month}: '
            '${dream.content.length > 50 ? dream.content.substring(0, 50) + "..." : dream.content}');
        if (dream.symbols.isNotEmpty) {
          buffer.writeln('  Semboller: ${dream.symbols.join(", ")}');
        }
      }
      buffer.writeln('\n');
    }

    // Stil rehberi
    buffer.writeln('YORUM STİLİ: ${profile.preferredStyle.label}');
    buffer.writeln(styleGuide);
    buffer.writeln('\n');

    // Özel talimatlar
    buffer.writeln('ÖZEL TALİMATLAR:');
    buffer.writeln('1. Kullanıcının burç profilini yoruma entegre et');
    buffer.writeln('2. Kişisel sembol anlamlarını dikkate al');
    buffer.writeln('3. Yaşam evresine uygun tavsiyeler ver');
    buffer.writeln('4. Önceki rüyalarla bağlantı kur (varsa)');
    buffer.writeln('5. ${profile.preferredStyle.description}');

    if (profile.age != null) {
      if (profile.age! < 25) {
        buffer.writeln('6. Genç ve enerjik bir dil kullan');
      } else if (profile.age! > 55) {
        buffer.writeln('6. Bilge ve olgun bir dil kullan');
      }
    }

    return buffer.toString();
  }

  Map<String, int> _getRecentSymbolPatterns(UserDreamProfile profile) {
    // Sıklığa göre sırala
    final sorted = profile.symbolFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sorted.take(10));
  }

  String _getStyleGuide(DreamStyle style) {
    switch (style) {
      case DreamStyle.jungian:
        return '''
- Arketiplere odaklan: Gölge, Anima/Animus, Bilge Yaşlı, vb.
- Bireyselleşme sürecini vurgula
- Kolektif bilinçdışından referanslar ver
- Sembollerin evrensel ve kişisel anlamlarını ayır''';
      case DreamStyle.spiritual:
        return '''
- Ruhani rehberlik tonunda yaz
- Kozmik mesajlar ve işaretlere vurgu yap
- Meditasyon ve spiritüel pratik önerileri ekle
- Yüksek benlik ve ruhani gelişimden bahset''';
      case DreamStyle.practical:
        return '''
- Somut ve uygulanabilir tavsiyeler ver
- Günlük yaşamla doğrudan bağlantı kur
- Mistik dilin minimum ol
- Problem çözme odaklı yaklaş''';
      case DreamStyle.esoteric:
        return '''
- Kadim bilgelik ve mistik geleneklere referans ver
- Sembolizmin derin katmanlarını aç
- Ezoterik kavramları kullan ama açıkla
- Gizli öğretilere göndermeler yap''';
      case DreamStyle.psychological:
        return '''
- Bilimsel psikoloji terminolojisi kullan
- Duygu düzenleme ve başa çıkma stratejileri öner
- Savunma mekanizmalarını tanımla
- Terapötik içgörüler sun''';
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // KULLANICI İÇGÖRÜLERİ
  // ═══════════════════════════════════════════════════════════════════════

  /// Kişisel kalıpları al
  List<String> getPersonalPatterns(UserDreamProfile profile) {
    final patterns = <String>[];

    // Sembol kalıpları
    final topSymbols = _getRecentSymbolPatterns(profile);
    if (topSymbols.isNotEmpty) {
      final topSymbol = topSymbols.entries.first;
      if (topSymbol.value >= 3) {
        patterns.add(
            '${topSymbol.key.toUpperCase()} sembolü rüyalarında sıkça beliriyor (${topSymbol.value} kez). '
            'Bu senin için özel bir anlam taşıyor olabilir.');
      }
    }

    // Duygusal kalıplar
    if (profile.dominantDreamEmotion != null) {
      patterns.add(
          'Rüyalarında en çok ${profile.dominantDreamEmotion!.label.toLowerCase()} duygusu hakim. '
          '${profile.dominantDreamEmotion!.hint}');
    }

    // Lucid rüya eğilimi
    if (profile.lucidDreamFrequency > 0.3) {
      patterns.add(
          'Lucid rüya deneyimin ortalamanın üzerinde. Bu farkındalığı geliştirmek için '
          'MILD veya reality check tekniklerini kullanabilirsin.');
    }

    // Kâbus sıklığı
    if (profile.nightmareFrequency > 0.2) {
      patterns.add(
          'Kâbus sıklığın biraz yüksek görünüyor. Bu, işlenmemiş duygusal malzeme '
          'veya stres dönemlerine işaret edebilir.');
    }

    // Tekrarlayan temalar
    if (profile.recurringThemes.isNotEmpty) {
      patterns.add(
          'Tekrarlayan temalar: ${profile.recurringThemes.join(", ")}. '
          'Bu temalar bilinçaltının sürekli işlediği konuları gösteriyor.');
    }

    return patterns;
  }

  /// Kullanıcıya özel transit bilgileri
  Future<List<String>> getRelevantTransitsForUser(String userId) async {
    final profile = await getOrCreateProfile(userId);
    final now = DateTime.now();

    final transits = <String>[];

    if (profile.sunSign == null) {
      return ['Doğum bilgilerini ekleyerek kişisel transitlerini görebilirsin.'];
    }

    // Ay transitini kontrol et
    final currentMoonSign = _calculateMoonSign(now);
    if (currentMoonSign != null) {
      if (currentMoonSign == profile.sunSign) {
        transits.add(
            '🌙 Ay senin burcunda (${profile.sunSign}) - Duygusal yoğunluk ve sezgi artışı');
      }
      if (currentMoonSign == profile.moonSign) {
        transits.add(
            '🌙 Ay doğum Ay burcunda (${profile.moonSign}) - İç dünyayla derin bağlantı');
      }
    }

    // Retro kontrol
    final retrograde = _getCurrentRetrograde(now);
    if (retrograde != null) {
      transits.add('⏪ $retrograde retrosu aktif - Geçmişe dair rüyalar olası');
    }

    // Ay fazı
    final moonPhase = MoonPhaseCalculator.calculate(now);
    final phaseDetail = AstroRuyaKorelasyonlari.ayFaziDetay[
        moonPhase.name.toLowerCase().replaceAll('ı', 'i')];
    if (phaseDetail != null) {
      transits.add('${phaseDetail.emoji} ${phaseDetail.phase}: ${phaseDetail.dreamQuality}');
    }

    return transits.isEmpty
        ? ['Şu an aktif önemli bir transit bulunmuyor.']
        : transits;
  }

  // ═══════════════════════════════════════════════════════════════════════
  // BURÇ-BAZLI KİŞİSELLEŞTİRME
  // ═══════════════════════════════════════════════════════════════════════

  /// Burca özel yorum ayarlaması
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
        '${zodiacProfile.emoji} **${zodiacProfile.sign} Burcu Perspektifi:**');
    buffer.writeln(zodiacProfile.dreamAdvice);

    // Ay burcunu da ekle
    if (profile.moonSign != null) {
      final moonProfile = ZodiacDreamInsights.getProfile(profile.moonSign!);
      if (moonProfile != null) {
        buffer.writeln('\n🌙 **Ay Burcun (${moonProfile.sign}) Etkisi:**');
        buffer.writeln(
            'Duygusal işleme tarzın: ${moonProfile.commonThemes.take(3).join(", ")} temaları etrafında döner.');
      }
    }

    return buffer.toString();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // İSTATİSTİKLER
  // ═══════════════════════════════════════════════════════════════════════

  /// Kullanıcı rüya istatistikleri
  Future<Map<String, dynamic>> getUserDreamStats(String userId) async {
    final profile = await getOrCreateProfile(userId);

    final stats = <String, dynamic>{
      'profilTamamlama': '${(profile.completionPercentage * 100).toInt()}%',
      'toplamSembol': profile.symbolFrequency.length,
      'enSikSembol': _getTopSymbol(profile),
      'kisiselAnlamlar': profile.personalSymbolMeanings.length,
      'tekrarlayanTemalar': profile.recurringThemes.length,
      'lucidOrani': '${(profile.lucidDreamFrequency * 100).toInt()}%',
      'kabusOrani': '${(profile.nightmareFrequency * 100).toInt()}%',
      'geriBildirimSayisi': profile.feedbackHistory.length,
      'ortalamaPuan': getAverageRating(profile).toStringAsFixed(1),
      'tercihedilenStil': profile.preferredStyle.label,
    };

    if (profile.hasAstrologyData) {
      stats['burcProfili'] = {
        'gunes': profile.sunSign,
        'ay': profile.moonSign,
        'yukselen': profile.risingSign,
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
// YARDIMCI KİŞİSELLEŞTİRME METODLARI
// ════════════════════════════════════════════════════════════════════════════

/// Kişiselleştirme yardımcıları
class PersonalizationHelpers {
  /// Yaşa göre dil seviyesi önerisi
  static String getLanguageLevelForAge(int age) {
    if (age < 18) return 'genç';
    if (age < 30) return 'genç yetişkin';
    if (age < 50) return 'orta yaş';
    if (age < 65) return 'olgun';
    return 'yaşlı bilge';
  }

  /// Yaşam alanına göre odak sembolleri
  static List<String> getFocusSymbolsForLifeArea(String area) {
    final focusSymbols = {
      'kariyer': ['ofis', 'patron', 'para', 'başarı', 'merdiven', 'bina'],
      'ask': ['partner', 'evlilik', 'kalp', 'öpücük', 'yabancı', 'ayrılık'],
      'saglik': ['hastane', 'doktor', 'beden', 'ilaç', 'şifa', 'ağrı'],
      'aile': ['anne', 'baba', 'ev', 'çocuk', 'kardeş', 'akraba'],
      'finans': ['para', 'banka', 'borç', 'zenginlik', 'kayıp', 'bulma'],
      'egitim': ['okul', 'sınav', 'öğretmen', 'kitap', 'öğrenme', 'diploma'],
      'spiritüel': ['ışık', 'uçuş', 'melek', 'tanrı', 'tapınak', 'meditasyon'],
    };

    return focusSymbols[area.toLowerCase()] ?? [];
  }

  /// Mevsime göre ek yorum
  static String getSeasonalInsight(String season) {
    switch (season.toLowerCase()) {
      case 'ilkbahar':
        return 'İlkbahar enerjisi yeni başlangıçları ve yeniden doğuşu destekler. '
            'Rüyalarında filizlenen tohumlar ve açan çiçekler umut taşır.';
      case 'yaz':
        return 'Yaz enerjisi dışa dönüklük ve bolluk getirir. '
            'Rüyalarındaki güneş ve sıcaklık yaşam gücünü temsil eder.';
      case 'sonbahar':
        return 'Sonbahar bırakma ve hasat zamanıdır. '
            'Rüyalarındaki düşen yapraklar ve hasat sembolleri tamamlanmayı gösterir.';
      case 'kış':
        return 'Kış içe dönüş ve dinlenme zamanıdır. '
            'Rüyalarındaki kar ve soğuk temizlenme ve yeniden başlangıç hazırlığıdır.';
      default:
        return '';
    }
  }

  /// Haftanın gününe göre rüya eğilimi
  static String getDayOfWeekInsight(String day) {
    final insights = {
      'Pazartesi':
          'Pazartesi rüyaları genellikle iş ve sorumluluk temalarını yansıtır.',
      'Salı':
          'Mars günü olan Salı, aksiyon ve enerji dolu rüyalara eğilimlidir.',
      'Çarşamba':
          'Merkür günü Çarşamba, iletişim ve mesaj içerikli rüyalar getirir.',
      'Perşembe':
          'Jüpiter günü Perşembe, genişleme ve şans temalı rüyalar görülebilir.',
      'Cuma':
          'Venüs günü Cuma, aşk ve güzellik rüyalarına açıktır.',
      'Cumartesi':
          'Satürn günü Cumartesi, sınırlar ve yapı hakkında rüyalar getirir.',
      'Pazar':
          'Güneş günü Pazar, benlik ve kimlik keşfi rüyalarına elverişlidir.',
    };

    return insights[day] ?? '';
  }
}
