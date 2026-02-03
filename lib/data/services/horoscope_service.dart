import 'dart:math';
import '../models/zodiac_sign.dart';
import '../models/horoscope.dart';
import '../providers/app_providers.dart';
import 'horoscope_content.dart';

class HoroscopeService {
  static final _random = Random();

  // Generate daily horoscope based on sign, date and language
  static DailyHoroscope generateDailyHoroscope(
    ZodiacSign sign,
    DateTime date, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final summaries = HoroscopeContent.getEsotericSummaries(sign, language);
    final loveAdvices = HoroscopeContent.getLoveAdvices(language);
    final careerAdvices = HoroscopeContent.getCareerAdvices(language);
    final healthAdvices = HoroscopeContent.getHealthAdvices(language);
    final moods = HoroscopeContent.getMoods(language);
    final colors = HoroscopeContent.getSacredColors(sign, language);

    // Use date as seed for consistent daily results
    final seed = date.year * 10000 + date.month * 100 + date.day + sign.index;
    final seededRandom = Random(seed);

    // Geçmiş, Şimdi, Gelecek içerikleri
    final pastInsights = HoroscopeContent.getPastInsights(sign, language);
    final presentEnergies = HoroscopeContent.getPresentEnergies(sign, language);
    final futureGuidances = HoroscopeContent.getFutureGuidances(sign, language);
    final cosmicMessages = HoroscopeContent.getCosmicMessages(sign, language);

    return DailyHoroscope(
      sign: sign,
      date: date,
      summary: summaries[seededRandom.nextInt(summaries.length)],
      loveAdvice: loveAdvices[seededRandom.nextInt(loveAdvices.length)],
      careerAdvice: careerAdvices[seededRandom.nextInt(careerAdvices.length)],
      healthAdvice: healthAdvices[seededRandom.nextInt(healthAdvices.length)],
      luckRating: seededRandom.nextInt(5) + 1,
      luckyNumber: '${seededRandom.nextInt(99) + 1}',
      luckyColor: colors[seededRandom.nextInt(colors.length)],
      mood: moods[seededRandom.nextInt(moods.length)],
      pastInsight: pastInsights[seededRandom.nextInt(pastInsights.length)],
      presentEnergy: presentEnergies[seededRandom.nextInt(presentEnergies.length)],
      futureGuidance: futureGuidances[seededRandom.nextInt(futureGuidances.length)],
      cosmicMessage: cosmicMessages[seededRandom.nextInt(cosmicMessages.length)],
    );
  }

  static Compatibility calculateCompatibility(
    ZodiacSign sign1,
    ZodiacSign sign2, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final elementMatch = _getElementCompatibility(sign1.element, sign2.element);
    final modalityMatch =
        _getModalityCompatibility(sign1.modality, sign2.modality);

    final baseScore = ((elementMatch + modalityMatch) / 2 * 100).round();
    final variation = _random.nextInt(20) - 10;
    final overallScore = (baseScore + variation).clamp(0, 100);

    return Compatibility(
      sign1: sign1,
      sign2: sign2,
      overallScore: overallScore,
      loveScore: (overallScore + _random.nextInt(20) - 10).clamp(0, 100),
      friendshipScore: (overallScore + _random.nextInt(20) - 10).clamp(0, 100),
      communicationScore:
          (overallScore + _random.nextInt(20) - 10).clamp(0, 100),
      summary: _getEsotericCompatibilitySummary(sign1, sign2, overallScore, language),
      strengths: _getEsotericCompatibilityStrengths(sign1, sign2, language),
      challenges: _getEsotericCompatibilityChallenges(sign1, sign2, language),
    );
  }

  static double _getElementCompatibility(Element e1, Element e2) {
    if (e1 == e2) return 0.9;

    // Fire + Air = Alchemical fusion
    if ((e1 == Element.fire && e2 == Element.air) ||
        (e1 == Element.air && e2 == Element.fire)) {
      return 0.85;
    }

    // Earth + Water = Sacred vessel
    if ((e1 == Element.earth && e2 == Element.water) ||
        (e1 == Element.water && e2 == Element.earth)) {
      return 0.85;
    }

    // Fire + Earth = Forging tension
    if ((e1 == Element.fire && e2 == Element.earth) ||
        (e1 == Element.earth && e2 == Element.fire)) {
      return 0.5;
    }

    // Air + Water = Mist and mystery
    if ((e1 == Element.air && e2 == Element.water) ||
        (e1 == Element.water && e2 == Element.air)) {
      return 0.5;
    }

    return 0.65;
  }

  static double _getModalityCompatibility(Modality m1, Modality m2) {
    if (m1 == m2) return 0.6;
    return 0.8;
  }

  static String _getEsotericCompatibilitySummary(
      ZodiacSign sign1, ZodiacSign sign2, int score, AppLanguage language) {
    final name1 = language == AppLanguage.en ? sign1.name : sign1.nameTr;
    final name2 = language == AppLanguage.en ? sign2.name : sign2.nameTr;

    if (language == AppLanguage.en) {
      if (score >= 80) {
        return 'There is an ancient bond between $name1 and $name2 - as if your souls have met many times in different lives. This connection is no coincidence; the universe bringing you together has deep meaning. An energy flow that illuminates, transforms, and elevates each other. This relationship is a catalyst for both of you to reach your highest potential.';
      } else if (score >= 60) {
        return '$name1 and $name2 are in a match where different melodies can form a harmonic composition. There are challenges, but these challenges are opportunities for growth. You can both emerge from this relationship transformed - as long as you focus on understanding, not changing each other.';
      } else if (score >= 40) {
        return 'The energy between $name1 and $name2 is like flame and water - it can extinguish or create steam. This may be a karmic relationship; you may have come together to complete unfinished business from the past. With conscious effort, this relationship can be a deep source of teaching.';
      } else {
        return '$name1 and $name2 is a combination where the universe holds a mirror to you. What you see in each other is actually your own shadow side. This relationship is not easy, but the hardest relationships sometimes carry the greatest teachings.';
      }
    } else {
      if (score >= 80) {
        return '$name1 ve $name2 arasında kadim bir bağ var - sanki ruhlarınız farklı hayatlarda birçok kez karşılaşmış gibi. Bu bağlantı tesadüf değil; evrenin sizi bir araya getirmesinin derin bir anlamı var. Birbirinizi aydınlatan, dönüştüren ve yücelten bir enerji akışı söz konusu. Bu ilişki, her ikinizin de en yüksek potansiyeline ulaşması için bir katalizör.';
      } else if (score >= 60) {
        return '$name1 ve $name2, farklı melodilerin harmonik bir kompozisyon oluşturabileceği bir eşleşmede. Zorluklar var, ama bu zorluklar büyüme fırsatıdır. Her ikiniz de bu ilişkiden dönüşmüş olarak çıkabilirsiniz - yeter ki, birbirinizi değiştirmeye değil, anlamaya odaklanın. Ayrılıklar, birleşmenin dansının bir parçasıdır.';
      } else if (score >= 40) {
        return '$name1 ve $name2 arasındaki enerji, alev ve su gibi - birbirini söndürebilir veya buhar oluşturabilir. Bu bir karmik ilişki olabilir; geçmişte tamamlanmamış bir iş için bir araya gelmiş olabilirsiniz. Bilinçli çaba gösterirseniz, bu ilişki derin bir öğreti kaynağı olabilir. Ama kolay olmayacak - ve belki de öyle olması gerekmiyor.';
      } else {
        return '$name1 ve $name2, evrenin size bir ayna tuttuğu bir kombinasyon. Birbirinizde gördüğünüz, aslında kendi gölge yanınızdır. Bu ilişki kolay değil, ama en zor ilişkiler bazen en büyük öğretileri taşır. Soru şu: Bu aynayla yüzleşmeye hazır mısınız? Cevap "evet" ise, bu ilişki sizi derinden dönüştürebilir.';
      }
    }
  }

  static List<String> _getEsotericCompatibilityStrengths(
      ZodiacSign sign1, ZodiacSign sign2, AppLanguage language) {
    final strengths = <String>[];
    final isEn = language == AppLanguage.en;

    if (sign1.element == sign2.element) {
      final elementName = isEn
          ? sign1.element.name
          : sign1.element.nameTr;
      strengths.add(isEn
          ? 'Sharing the same $elementName element creates wordless understanding - as if you speak the same language.'
          : 'Aynı $elementName elementini paylaşmak, kelimesiz bir anlayış yaratıyor - sanki aynı dili konuşuyorsunuz.');
    }

    if (sign1.modality != sign2.modality) {
      strengths.add(isEn
          ? 'Different modalities complete missing pieces. Where one starts, the other can continue.'
          : 'Farklı modaliteler, eksik parçaları tamamlıyor. Birinin başladığı yerde diğeri devam edebilir.');
    }

    if (sign1.element == Element.fire && sign2.element == Element.air ||
        sign1.element == Element.air && sign2.element == Element.fire) {
      strengths.add(isEn
          ? 'The alchemical union of Fire and Air: ideas catch fire, passions take flight.'
          : 'Ateş ve Hava\'nın simyasal birleşimi: fikirler alev alıyor, tutkular kanat açıyor.');
    }

    if (sign1.element == Element.earth && sign2.element == Element.water ||
        sign1.element == Element.water && sign2.element == Element.earth) {
      strengths.add(isEn
          ? 'The sacred marriage of Earth and Water: emotions materialize, dreams become reality.'
          : 'Toprak ve Su\'yun kutsal evliliği: duygular somutlaşıyor, hayaller gerçekleşiyor.');
    }

    strengths.addAll(isEn
        ? [
            'Strong potential for spiritual growth - you elevate each other.',
            'A foundation of mutual respect and admiration exists.',
            'The ability to see each other\'s hidden potentials.',
          ]
        : [
            'Ruhsal büyüme için güçlü bir potansiyel - birbirinizi yükseltiyorsunuz.',
            'Karşılıklı saygı ve hayranlık temeli var.',
            'Birbirinizin gizli potansiyellerini görebilme yeteneği.',
          ]);

    return strengths.take(4).toList();
  }

  static List<String> _getEsotericCompatibilityChallenges(
      ZodiacSign sign1, ZodiacSign sign2, AppLanguage language) {
    final challenges = <String>[];
    final isEn = language == AppLanguage.en;

    if (sign1.element != sign2.element) {
      challenges.add(isEn
          ? 'Different elements mean different needs. Can one withstand the other\'s fire? Does water want to cool or nourish?'
          : 'Farklı elementler, farklı ihtiyaçlar demek. Birinin ateşine diğer dayanabilir mi? Su soğutmak mı istiyor, beslemek mi?');
    }

    if (sign1.modality == sign2.modality) {
      challenges.add(isEn
          ? 'The same modality carries the risk of power struggle. Who will set the direction? Who will follow?'
          : 'Aynı modalite, iktidar mücadelesi riski taşıyor. Kim yön belirleyecek? Kim takip edecek?');
    }

    if (sign1.element == Element.fire && sign2.element == Element.water ||
        sign1.element == Element.water && sign2.element == Element.fire) {
      challenges.add(isEn
          ? 'The dance of Fire and Water can be dangerous - you either extinguish each other or evaporate together.'
          : 'Ateş ve Su\'yun dansı tehlikeli olabilir - ya birbirinizi söndürürsünüz, ya da buhar olup uçarsınız.');
    }

    challenges.addAll(isEn
        ? [
            'Communication differences: You may assign different meanings to the same words.',
            'Shadow reflections: You may see sides in each other that you don\'t want to see.',
          ]
        : [
            'İletişim farklılıkları: Aynı kelimelere farklı anlamlar yükleyebilirsiniz.',
            'Gölge yansımaları: Birbirinizde görmek istemediğiniz yanları görebilirsiniz.',
          ]);

    return challenges.take(3).toList();
  }
}
