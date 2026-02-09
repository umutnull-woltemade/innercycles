import 'zodiac_sign.dart';

/// Daily reflection content for self-awareness and mindfulness.
/// This content is for personal reflection only, not prediction or advice.
class DailyHoroscope {
  final ZodiacSign sign;
  final DateTime date;
  final String summary;
  final String loveAdvice;
  final String careerAdvice;
  final String healthAdvice;
  final int energyLevel; // 1-5 (for UI display only, represents thematic intensity)
  final String focusNumber;
  final String reflectionColor;
  final String mood;

  // Reflection Themes - Past patterns, Present awareness, Future intentions
  final String pastInsight;      // Patterns from the past to reflect on
  final String presentEnergy;    // Current awareness themes
  final String futureIntention;  // Intentions to consider (not predictions)
  final String dailyTheme;       // Daily reflection theme (summary)

  // Element ve Modalite Analizi
  final String elementAnalysis;   // Element derinlemesine analizi
  final String modalityAnalysis;  // Modalite yorumu

  // Gezegensel Saatler ve Enerjiler
  final String planetaryHourInfo;  // Günün gezegensel saatleri
  final String rulingPlanetMessage; // Yönetici gezegen mesajı

  // Ritüeller ve Pratikler
  final String dailyRitual;       // Günlük ritüel önerisi
  final String meditationFocus;   // Meditasyon odağı
  final String affirmation;       // Günün olumlaması

  // Kristaller ve Taşlar
  final String crystalOfDay;      // Günün kristali
  final String crystalMeaning;    // Kristal anlamı ve kullanımı

  // Çakra ve Enerji Çalışması
  final String chakraFocus;       // Odaklanılacak çakra
  final String chakraExercise;    // Çakra egzersizi

  // Ruh Hayvanı ve Semboller
  final String spiritAnimal;      // Günün ruh hayvanı
  final String spiritAnimalMessage; // Ruh hayvanı mesajı

  // Numeroloji
  final String numerologyInsight; // Numerolojik analiz

  // Tarot Kartı
  final String tarotCard;         // Günün tarot kartı
  final String tarotMeaning;      // Tarot kartı yorumu

  // Ay Fazı Etkisi
  final String moonPhaseEffect;   // Ay fazının burca etkisi

  // Özel Uyarılar
  final String specialWarning;    // Theme to pay attention to
  final String focusTime;         // Suggested focus time for activities

  DailyHoroscope({
    required this.sign,
    required this.date,
    required this.summary,
    required this.loveAdvice,
    required this.careerAdvice,
    required this.healthAdvice,
    required this.energyLevel,
    required this.focusNumber,
    required this.reflectionColor,
    required this.mood,
    required this.pastInsight,
    required this.presentEnergy,
    required this.futureIntention,
    required this.dailyTheme,
    this.elementAnalysis = '',
    this.modalityAnalysis = '',
    this.planetaryHourInfo = '',
    this.rulingPlanetMessage = '',
    this.dailyRitual = '',
    this.meditationFocus = '',
    this.affirmation = '',
    this.crystalOfDay = '',
    this.crystalMeaning = '',
    this.chakraFocus = '',
    this.chakraExercise = '',
    this.spiritAnimal = '',
    this.spiritAnimalMessage = '',
    this.numerologyInsight = '',
    this.tarotCard = '',
    this.tarotMeaning = '',
    this.moonPhaseEffect = '',
    this.specialWarning = '',
    this.focusTime = '',
  });

  Map<String, dynamic> toJson() => {
        'sign': sign.index,
        'date': date.toIso8601String(),
        'summary': summary,
        'loveAdvice': loveAdvice,
        'careerAdvice': careerAdvice,
        'healthAdvice': healthAdvice,
        'energyLevel': energyLevel,
        'focusNumber': focusNumber,
        'reflectionColor': reflectionColor,
        'mood': mood,
        'pastInsight': pastInsight,
        'presentEnergy': presentEnergy,
        'futureIntention': futureIntention,
        'dailyTheme': dailyTheme,
      };

  factory DailyHoroscope.fromJson(Map<String, dynamic> json) => DailyHoroscope(
        sign: ZodiacSign.values[json['sign'] as int],
        date: DateTime.parse(json['date'] as String),
        summary: json['summary'] as String,
        loveAdvice: json['loveAdvice'] as String,
        careerAdvice: json['careerAdvice'] as String,
        healthAdvice: json['healthAdvice'] as String,
        energyLevel: json['energyLevel'] as int? ?? json['luckRating'] as int? ?? 3,
        focusNumber: json['focusNumber'] as String? ?? json['luckyNumber'] as String? ?? '',
        reflectionColor: json['reflectionColor'] as String? ?? json['luckyColor'] as String? ?? '',
        mood: json['mood'] as String,
        pastInsight: json['pastInsight'] as String? ?? '',
        presentEnergy: json['presentEnergy'] as String? ?? '',
        futureIntention: json['futureIntention'] as String? ?? json['futureGuidance'] as String? ?? '',
        dailyTheme: json['dailyTheme'] as String? ?? json['cosmicMessage'] as String? ?? '',
      );
}

/// Relationship reflection themes based on archetypal patterns.
/// Scores represent thematic harmony patterns for self-reflection,
/// not predictions or guarantees about relationship outcomes.
/// This content is for entertainment and reflection only.
class Compatibility {
  final ZodiacSign sign1;
  final ZodiacSign sign2;
  final int overallScore; // 0-100 thematic harmony indicator
  final int loveScore;
  final int friendshipScore;
  final int communicationScore;
  final String summary;
  final List<String> strengths;
  final List<String> challenges; // growth areas to consider

  Compatibility({
    required this.sign1,
    required this.sign2,
    required this.overallScore,
    required this.loveScore,
    required this.friendshipScore,
    required this.communicationScore,
    required this.summary,
    required this.strengths,
    required this.challenges,
  });
}
