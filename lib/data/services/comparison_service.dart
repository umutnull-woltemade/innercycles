import '../models/user_profile.dart';
import '../models/zodiac_sign.dart' as zodiac;
import '../providers/app_providers.dart';

typedef ZodiacSign = zodiac.ZodiacSign;
typedef Element = zodiac.Element;
typedef Modality = zodiac.Modality;

class ComparisonResult {
  final UserProfile profile1;
  final UserProfile profile2;
  final int overallScore;
  final int loveScore;
  final int friendshipScore;
  final int communicationScore;
  final int trustScore;
  final String summaryTr;
  final String summaryEn;
  final List<String> strengthsTr;
  final List<String> strengthsEn;
  final List<String> challengesTr;
  final List<String> challengesEn;
  final String adviceTr;
  final String adviceEn;
  final ElementCompatibility elementMatch;
  final ModalityCompatibility modalityMatch;

  ComparisonResult({
    required this.profile1,
    required this.profile2,
    required this.overallScore,
    required this.loveScore,
    required this.friendshipScore,
    required this.communicationScore,
    required this.trustScore,
    required this.summaryTr,
    required this.summaryEn,
    required this.strengthsTr,
    required this.strengthsEn,
    required this.challengesTr,
    required this.challengesEn,
    required this.adviceTr,
    required this.adviceEn,
    required this.elementMatch,
    required this.modalityMatch,
  });

  String get emoji {
    if (overallScore >= 85) return '💫';
    if (overallScore >= 70) return '💕';
    if (overallScore >= 55) return '✨';
    if (overallScore >= 40) return '🌙';
    return '🌟';
  }

  String get levelTr {
    if (overallScore >= 85) return 'Ruh Eşi';
    if (overallScore >= 70) return 'Çok Uyumlu';
    if (overallScore >= 55) return 'Uyumlu';
    if (overallScore >= 40) return 'Orta';
    return 'Zorlu';
  }

  String get levelEn {
    if (overallScore >= 85) return 'Soulmates';
    if (overallScore >= 70) return 'Highly Compatible';
    if (overallScore >= 55) return 'Compatible';
    if (overallScore >= 40) return 'Moderate';
    return 'Challenging';
  }

  /// Get localized level based on language
  String localizedLevel(AppLanguage language) {
    return language == AppLanguage.tr ? levelTr : levelEn;
  }

  /// Get localized summary based on language
  String localizedSummary(AppLanguage language) {
    return language == AppLanguage.tr ? summaryTr : summaryEn;
  }

  /// Get localized strengths based on language
  List<String> localizedStrengths(AppLanguage language) {
    return language == AppLanguage.tr ? strengthsTr : strengthsEn;
  }

  /// Get localized challenges based on language
  List<String> localizedChallenges(AppLanguage language) {
    return language == AppLanguage.tr ? challengesTr : challengesEn;
  }

  /// Get localized advice based on language
  String localizedAdvice(AppLanguage language) {
    return language == AppLanguage.tr ? adviceTr : adviceEn;
  }
}

enum ElementCompatibility { perfect, good, neutral, challenging }

enum ModalityCompatibility { harmonious, dynamic, stable }

class ComparisonService {
  static ComparisonResult analyze(UserProfile p1, UserProfile p2) {
    final sign1 = p1.sunSign;
    final sign2 = p2.sunSign;

    final elementMatch = _getElementCompatibility(sign1, sign2);
    final modalityMatch = _getModalityCompatibility(sign1, sign2);

    final baseScore = _getBaseCompatibility(sign1, sign2);
    final elementBonus = _elementBonus(elementMatch);
    final modalityBonus = _modalityBonus(modalityMatch);

    final overallScore = (baseScore + elementBonus + modalityBonus).clamp(
      0,
      100,
    );
    final loveScore = _calculateLoveScore(sign1, sign2, overallScore);
    final friendshipScore = _calculateFriendshipScore(
      sign1,
      sign2,
      overallScore,
    );
    final communicationScore = _calculateCommunicationScore(sign1, sign2);
    final trustScore = _calculateTrustScore(sign1, sign2);

    final strengths = _getStrengths(sign1, sign2, elementMatch);
    final challenges = _getChallenges(sign1, sign2);
    final advice = _getAdvice(sign1, sign2, overallScore);
    final summary = _getSummary(sign1, sign2, overallScore);

    return ComparisonResult(
      profile1: p1,
      profile2: p2,
      overallScore: overallScore,
      loveScore: loveScore,
      friendshipScore: friendshipScore,
      communicationScore: communicationScore,
      trustScore: trustScore,
      summaryTr: summary['tr']!,
      summaryEn: summary['en']!,
      strengthsTr: strengths['tr']!,
      strengthsEn: strengths['en']!,
      challengesTr: challenges['tr']!,
      challengesEn: challenges['en']!,
      adviceTr: advice['tr']!,
      adviceEn: advice['en']!,
      elementMatch: elementMatch,
      modalityMatch: modalityMatch,
    );
  }

  static ElementCompatibility _getElementCompatibility(
    ZodiacSign s1,
    ZodiacSign s2,
  ) {
    final e1 = s1.element;
    final e2 = s2.element;

    if (e1 == e2) return ElementCompatibility.perfect;

    final compatible = {
      Element.fire: [Element.air],
      Element.air: [Element.fire],
      Element.earth: [Element.water],
      Element.water: [Element.earth],
    };

    if (compatible[e1]?.contains(e2) == true) return ElementCompatibility.good;

    final neutral = {
      Element.fire: [Element.earth],
      Element.earth: [Element.fire],
      Element.air: [Element.water],
      Element.water: [Element.air],
    };

    if (neutral[e1]?.contains(e2) == true) return ElementCompatibility.neutral;

    return ElementCompatibility.challenging;
  }

  static ModalityCompatibility _getModalityCompatibility(
    ZodiacSign s1,
    ZodiacSign s2,
  ) {
    final m1 = s1.modality;
    final m2 = s2.modality;

    if (m1 == m2) return ModalityCompatibility.stable;
    if ((m1 == Modality.cardinal && m2 == Modality.mutable) ||
        (m1 == Modality.mutable && m2 == Modality.cardinal)) {
      return ModalityCompatibility.dynamic;
    }
    return ModalityCompatibility.harmonious;
  }

  static int _getBaseCompatibility(ZodiacSign s1, ZodiacSign s2) {
    final matrix = <String, Map<String, int>>{
      'Koç': {
        'Koç': 70,
        'Boğa': 55,
        'İkizler': 75,
        'Yengeç': 45,
        'Aslan': 90,
        'Başak': 50,
        'Terazi': 65,
        'Akrep': 55,
        'Yay': 90,
        'Oğlak': 45,
        'Kova': 80,
        'Balık': 50,
      },
      'Boğa': {
        'Koç': 55,
        'Boğa': 75,
        'İkizler': 50,
        'Yengeç': 85,
        'Aslan': 60,
        'Başak': 90,
        'Terazi': 70,
        'Akrep': 80,
        'Yay': 45,
        'Oğlak': 95,
        'Kova': 40,
        'Balık': 85,
      },
      'İkizler': {
        'Koç': 75,
        'Boğa': 50,
        'İkizler': 70,
        'Yengeç': 55,
        'Aslan': 80,
        'Başak': 60,
        'Terazi': 90,
        'Akrep': 45,
        'Yay': 75,
        'Oğlak': 50,
        'Kova': 90,
        'Balık': 55,
      },
      'Yengeç': {
        'Koç': 45,
        'Boğa': 85,
        'İkizler': 55,
        'Yengeç': 75,
        'Aslan': 65,
        'Başak': 80,
        'Terazi': 50,
        'Akrep': 90,
        'Yay': 45,
        'Oğlak': 60,
        'Kova': 50,
        'Balık': 95,
      },
      'Aslan': {
        'Koç': 90,
        'Boğa': 60,
        'İkizler': 80,
        'Yengeç': 65,
        'Aslan': 75,
        'Başak': 55,
        'Terazi': 85,
        'Akrep': 55,
        'Yay': 90,
        'Oğlak': 50,
        'Kova': 70,
        'Balık': 55,
      },
      'Başak': {
        'Koç': 50,
        'Boğa': 90,
        'İkizler': 60,
        'Yengeç': 80,
        'Aslan': 55,
        'Başak': 70,
        'Terazi': 65,
        'Akrep': 85,
        'Yay': 50,
        'Oğlak': 90,
        'Kova': 45,
        'Balık': 75,
      },
      'Terazi': {
        'Koç': 65,
        'Boğa': 70,
        'İkizler': 90,
        'Yengeç': 50,
        'Aslan': 85,
        'Başak': 65,
        'Terazi': 75,
        'Akrep': 60,
        'Yay': 80,
        'Oğlak': 55,
        'Kova': 90,
        'Balık': 60,
      },
      'Akrep': {
        'Koç': 55,
        'Boğa': 80,
        'İkizler': 45,
        'Yengeç': 90,
        'Aslan': 55,
        'Başak': 85,
        'Terazi': 60,
        'Akrep': 70,
        'Yay': 50,
        'Oğlak': 80,
        'Kova': 55,
        'Balık': 90,
      },
      'Yay': {
        'Koç': 90,
        'Boğa': 45,
        'İkizler': 75,
        'Yengeç': 45,
        'Aslan': 90,
        'Başak': 50,
        'Terazi': 80,
        'Akrep': 50,
        'Yay': 75,
        'Oğlak': 55,
        'Kova': 85,
        'Balık': 60,
      },
      'Oğlak': {
        'Koç': 45,
        'Boğa': 95,
        'İkizler': 50,
        'Yengeç': 60,
        'Aslan': 50,
        'Başak': 90,
        'Terazi': 55,
        'Akrep': 80,
        'Yay': 55,
        'Oğlak': 75,
        'Kova': 60,
        'Balık': 70,
      },
      'Kova': {
        'Koç': 80,
        'Boğa': 40,
        'İkizler': 90,
        'Yengeç': 50,
        'Aslan': 70,
        'Başak': 45,
        'Terazi': 90,
        'Akrep': 55,
        'Yay': 85,
        'Oğlak': 60,
        'Kova': 70,
        'Balık': 65,
      },
      'Balık': {
        'Koç': 50,
        'Boğa': 85,
        'İkizler': 55,
        'Yengeç': 95,
        'Aslan': 55,
        'Başak': 75,
        'Terazi': 60,
        'Akrep': 90,
        'Yay': 60,
        'Oğlak': 70,
        'Kova': 65,
        'Balık': 75,
      },
    };

    return matrix[s1.name]?[s2.name] ?? 50;
  }

  static int _elementBonus(ElementCompatibility match) {
    switch (match) {
      case ElementCompatibility.perfect:
        return 10;
      case ElementCompatibility.good:
        return 5;
      case ElementCompatibility.neutral:
        return 0;
      case ElementCompatibility.challenging:
        return -5;
    }
  }

  static int _modalityBonus(ModalityCompatibility match) {
    switch (match) {
      case ModalityCompatibility.harmonious:
        return 5;
      case ModalityCompatibility.dynamic:
        return 3;
      case ModalityCompatibility.stable:
        return 0;
    }
  }

  static int _calculateLoveScore(ZodiacSign s1, ZodiacSign s2, int base) {
    final romantic = ['Boğa', 'Yengeç', 'Terazi', 'Balık'];
    final bonus =
        (romantic.contains(s1.name) ? 5 : 0) +
        (romantic.contains(s2.name) ? 5 : 0);
    return (base + bonus).clamp(0, 100);
  }

  static int _calculateFriendshipScore(ZodiacSign s1, ZodiacSign s2, int base) {
    final social = ['İkizler', 'Aslan', 'Terazi', 'Yay', 'Kova'];
    final bonus =
        (social.contains(s1.name) ? 5 : 0) + (social.contains(s2.name) ? 5 : 0);
    return (base + bonus).clamp(0, 100);
  }

  static int _calculateCommunicationScore(ZodiacSign s1, ZodiacSign s2) {
    final communicators = ['İkizler', 'Terazi', 'Kova'];
    final quiet = ['Akrep', 'Oğlak', 'Balık'];

    if (communicators.contains(s1.name) && communicators.contains(s2.name)) {
      return 90;
    }
    if (quiet.contains(s1.name) && quiet.contains(s2.name)) return 75;
    if ((communicators.contains(s1.name) && quiet.contains(s2.name)) ||
        (quiet.contains(s1.name) && communicators.contains(s2.name))) {
      return 55;
    }
    return 70;
  }

  static int _calculateTrustScore(ZodiacSign s1, ZodiacSign s2) {
    final loyal = ['Boğa', 'Yengeç', 'Aslan', 'Akrep', 'Oğlak'];
    final bonus =
        (loyal.contains(s1.name) ? 10 : 0) + (loyal.contains(s2.name) ? 10 : 0);
    return (60 + bonus).clamp(0, 100);
  }

  static Map<String, List<String>> _getStrengths(
    ZodiacSign s1,
    ZodiacSign s2,
    ElementCompatibility element,
  ) {
    final trList = <String>[];
    final enList = <String>[];

    if (element == ElementCompatibility.perfect) {
      trList.add('Aynı elementi paylaşıyorsunuz - doğal bir anlayış');
      enList.add('Same element - natural understanding');
    }

    final strengthMap = {
      Element.fire: {
        'tr': 'Tutku ve heyecan dolu bir bağ',
        'en': 'Passionate and exciting bond',
      },
      Element.earth: {
        'tr': 'Sağlam ve güvenilir temel',
        'en': 'Solid and reliable foundation',
      },
      Element.air: {
        'tr': 'Entelektüel ve sosyal uyum',
        'en': 'Intellectual and social harmony',
      },
      Element.water: {
        'tr': 'Derin duygusal bağ',
        'en': 'Deep emotional connection',
      },
    };

    if (s1.element == s2.element) {
      final elementStr = strengthMap[s1.element];
      if (elementStr != null) {
        trList.add(elementStr['tr']!);
        enList.add(elementStr['en']!);
      }
    }

    trList.add('${s1.name} ile ${s2.name} birbirini tamamlıyor');
    enList.add('${s1.name} and ${s2.name} complement each other');

    return {'tr': trList, 'en': enList};
  }

  static Map<String, List<String>> _getChallenges(
    ZodiacSign s1,
    ZodiacSign s2,
  ) {
    final trList = <String>[];
    final enList = <String>[];

    if (s1.element != s2.element) {
      trList.add('Farklı elementler - sabır gerektirir');
      enList.add('Different elements - requires patience');
    }

    if (s1.modality == s2.modality && s1.modality == Modality.cardinal) {
      trList.add('İki lider - güç çatışması olabilir');
      enList.add('Two leaders - power struggles possible');
    }

    if (s1.modality == Modality.fixed && s2.modality == Modality.fixed) {
      trList.add('İnatçılık - esneklik gerekli');
      enList.add('Stubbornness - flexibility needed');
    }

    if (trList.isEmpty) {
      trList.add('Her ilişki gibi iletişim önemli');
      enList.add('Like all relationships, communication is key');
    }

    return {'tr': trList, 'en': enList};
  }

  static Map<String, String> _getAdvice(
    ZodiacSign s1,
    ZodiacSign s2,
    int score,
  ) {
    if (score >= 80) {
      return {
        'tr':
            'Harika bir uyumunuz var! Bu özel bağı korumak için birbirinize zaman ayırın.',
        'en':
            'You have great compatibility! Make time for each other to nurture this special bond.',
      };
    } else if (score >= 60) {
      return {
        'tr':
            'Güzel bir potansiyel var. Farklılıklarınızı kabul edip birbirinizden öğrenin.',
        'en':
            'Good potential here. Accept your differences and learn from each other.',
      };
    } else {
      return {
        'tr': 'Zorluklar büyüme fırsatıdır. Açık iletişim ve sabır anahtardır.',
        'en':
            'Challenges are growth opportunities. Open communication and patience are key.',
      };
    }
  }

  static Map<String, String> _getSummary(
    ZodiacSign s1,
    ZodiacSign s2,
    int score,
  ) {
    final level = score >= 80 ? 'yüksek' : (score >= 60 ? 'iyi' : 'orta');
    final levelEn = score >= 80 ? 'high' : (score >= 60 ? 'good' : 'moderate');

    return {
      'tr':
          '${s1.name} ve ${s2.name} arasında $level seviyede bir uyum var. ${s1.element} ve ${s2.element} elementlerinin birleşimi ilginç dinamikler yaratıyor.',
      'en':
          '${s1.name} and ${s2.name} share a $levelEn level of compatibility. The combination of ${s1.element} and ${s2.element} elements creates interesting dynamics.',
    };
  }
}
