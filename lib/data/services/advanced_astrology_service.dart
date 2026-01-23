import 'dart:math';
import '../models/zodiac_sign.dart';
import '../models/advanced_astrology.dart';

class AdvancedAstrologyService {
  static final _random = Random();

  // ============ COMPOSITE CHART ============

  static CompositeChart generateCompositeChart({
    required String person1Name,
    required String person2Name,
    required ZodiacSign person1Sun,
    required ZodiacSign person2Sun,
    required ZodiacSign person1Moon,
    required ZodiacSign person2Moon,
  }) {
    final seed = person1Sun.index * 100 + person2Sun.index * 10 + person1Moon.index + person2Moon.index;
    final seededRandom = Random(seed);

    // Calculate composite positions (midpoint method)
    // All composite positions are derived deterministically from the input signs
    // to ensure consistent results across sessions
    final compositeSun = _getMidpointSign(person1Sun, person2Sun);
    final compositeMoon = _getMidpointSign(person1Moon, person2Moon);
    // Composite Ascendant: derived from midpoint of Sun signs + 3 (traditional offset)
    final compositeAsc = ZodiacSign.values[((person1Sun.index + person2Sun.index) ~/ 2 + 3) % 12];
    // Composite Venus: derived from Moon midpoint + 2
    final compositeVenus = ZodiacSign.values[((person1Moon.index + person2Moon.index) ~/ 2 + 2) % 12];
    // Composite Mars: derived from Sun midpoint + 5
    final compositeMars = ZodiacSign.values[((person1Sun.index + person2Sun.index) ~/ 2 + 5) % 12];

    final themes = _getRelationshipThemes(compositeSun, compositeMoon);
    final emotions = _getEmotionalDynamics(compositeMoon);
    final communication = _getCommunicationStyle(compositeAsc);
    final challenges = _getChallenges(compositeSun, compositeMoon);
    final strengths = _getStrengths(compositeSun, compositeMoon);
    final purpose = _getSoulPurpose(compositeSun);

    // Generate aspects
    final aspects = _generateCompositeAspects(seededRandom);

    // Calculate compatibility
    final compatibility = _calculateCompatibilityScore(person1Sun, person2Sun, person1Moon, person2Moon);

    return CompositeChart(
      person1Name: person1Name,
      person2Name: person2Name,
      compositeSun: compositeSun,
      compositeMoon: compositeMoon,
      compositeAscendant: compositeAsc,
      compositeVenus: compositeVenus,
      compositeMars: compositeMars,
      relationshipTheme: themes[seededRandom.nextInt(themes.length)],
      emotionalDynamics: emotions[seededRandom.nextInt(emotions.length)],
      communicationStyle: communication[seededRandom.nextInt(communication.length)],
      challengesOverview: challenges[seededRandom.nextInt(challenges.length)],
      strengthsOverview: strengths[seededRandom.nextInt(strengths.length)],
      soulPurpose: purpose[seededRandom.nextInt(purpose.length)],
      overallCompatibility: compatibility,
      keyAspects: aspects,
    );
  }

  static ZodiacSign _getMidpointSign(ZodiacSign sign1, ZodiacSign sign2) {
    final midpoint = ((sign1.index + sign2.index) / 2).round();
    return ZodiacSign.values[midpoint % 12];
  }

  static int _calculateCompatibilityScore(ZodiacSign sun1, ZodiacSign sun2, ZodiacSign moon1, ZodiacSign moon2) {
    int score = 50;

    // Same element bonus
    if (sun1.element == sun2.element) score += 15;
    if (moon1.element == moon2.element) score += 10;

    // Complementary elements
    if ((sun1.element == Element.fire && sun2.element == Element.air) ||
        (sun1.element == Element.air && sun2.element == Element.fire)) score += 12;
    if ((sun1.element == Element.earth && sun2.element == Element.water) ||
        (sun1.element == Element.water && sun2.element == Element.earth)) score += 12;

    // Opposing signs (can be challenging but magnetic)
    if ((sun1.index - sun2.index).abs() == 6) score += 5;

    // Deterministic variation based on sign indices for consistency
    // No randomness to ensure same input always produces same output
    final variation = ((sun1.index * 3 + sun2.index * 7 + moon1.index * 5 + moon2.index * 11) % 11) - 5;
    score += variation;

    return score.clamp(0, 100);
  }

  static List<CompositeAspect> _generateCompositeAspects(Random seededRandom) {
    final planets = ['Güneş', 'Ay', 'Merkür', 'Venüs', 'Mars', 'Jüpiter', 'Satürn'];
    final aspects = <CompositeAspect>[];

    for (int i = 0; i < 4; i++) {
      final p1 = planets[seededRandom.nextInt(planets.length)];
      var p2 = planets[seededRandom.nextInt(planets.length)];
      while (p2 == p1) {
        p2 = planets[seededRandom.nextInt(planets.length)];
      }

      final type = AspectType.values[seededRandom.nextInt(AspectType.values.length)];
      final interpretation = _getAspectInterpretation(p1, p2, type);
      final isHarmonious = type == AspectType.trine || type == AspectType.sextile || type == AspectType.conjunction;

      aspects.add(CompositeAspect(
        planet1: p1,
        planet2: p2,
        type: type,
        interpretation: interpretation,
        isHarmonious: isHarmonious,
      ));
    }

    return aspects;
  }

  static String _getAspectInterpretation(String p1, String p2, AspectType type) {
    final interpretations = {
      AspectType.conjunction: '$p1 ve $p2 enerjileri birleşik. Bu ilişki için güçlü ve yoğun bir bağlantı.',
      AspectType.trine: '$p1 ile $p2 arasında uyumlu enerji akışı. Doğal ve kolay bir etkileşim.',
      AspectType.sextile: '$p1 ve $p2 arasında fırsatlar yaratan pozitif açı. İşbirliği potansiyeli yüksek.',
      AspectType.square: '$p1 ve $p2 arasında gerilim. Zorlayıcı ama büyüme potansiyeli taşıyan dinamik.',
      AspectType.opposition: '$p1 ve $p2 karşıtlığı. Dengelenmesi gereken zıt kutuplar.',
    };
    return interpretations[type]!;
  }

  static List<String> _getRelationshipThemes(ZodiacSign sun, ZodiacSign moon) {
    return [
      'Bu ilişki, ${sun.nameTr} enerjisinin cesaret ve tutku kattığını, ${moon.nameTr} ayının ise duygusal derinlik sağladığını gösteriyor. Birlikte hem ateş hem su taşıyorsunuz.',
      'Kompozit haritanız, karşılıklı büyüme ve dönüşüm üzerine kurulu bir ilişki olduğunu ortaya koyuyor. Her ikiniz de bu birliktelikten dönüşmüş çıkacaksınız.',
      'Ruhsal bağlantınız güçlü. Bu ilişki, sadece romantik değil, aynı zamanda karmik bir anlam taşıyor. Birbirinize öğretecek çok şeyiniz var.',
    ];
  }

  static List<String> _getEmotionalDynamics(ZodiacSign moon) {
    return [
      '${moon.nameTr} ayıyla, duygusal dünyanız ${moon.element.nameTr} elementi tarafından şekilleniyor. Hislerinizi paylaşmak ve anlamak bu ilişkinin temelini oluşturuyor.',
      'Duygusal iletişimde derinlik arıyorsunuz. Yüzeysel bağlantılar sizi tatmin etmez - gerçek yakınlık ve güven istiyorsunuz.',
      'Birbirinizin duygusal ihtiyaçlarını anlamak için zaman ve sabır gerekiyor. Ama bu çaba, karşılıklı şifa ve büyümeyi beraberinde getirecek.',
    ];
  }

  static List<String> _getCommunicationStyle(ZodiacSign asc) {
    return [
      '${asc.nameTr} yükseleniyle, dış dünyaya nasıl birlikte göründüğünüz ve iletişiminiz ${asc.element.nameTr} enerjisi taşıyor.',
      'İletişim tarzı doğrudan ve açık. Birbirinize karşı samimi ve dürüstler, bu da güveni güçlendiriyor.',
      'Sözleriniz ve sessizlikleriniz eşit derecede anlam taşıyor. Sözlü olmayan iletişimde de ustasınız.',
    ];
  }

  static List<String> _getChallenges(ZodiacSign sun, ZodiacSign moon) {
    return [
      'Ego çatışmaları ve bireysel ihtiyaçların ilişki ihtiyaçlarıyla dengelenmesi zorluk olabilir. Taviz vermeyi öğrenmek gerekiyor.',
      'Farklı duygusal diller konuşuyor olabilirsiniz. Birbirinizi yanlış anlamadan önce, dinlemeyi ve sormayı öğrenin.',
      'Bağımsızlık ve yakınlık arasındaki denge, bu ilişkinin ana temalarından biri. Her ikisine de alan tanımak gerekiyor.',
    ];
  }

  static List<String> _getStrengths(ZodiacSign sun, ZodiacSign moon) {
    return [
      'Karşılıklı saygı ve hayranlık ilişkinizin temelini oluşturuyor. Birbirinizin güçlü yanlarını takdir ediyorsunuz.',
      'Ortak değerlere ve vizyona sahipsiniz. Bu, uzun vadeli uyum ve hedef birliği sağlıyor.',
      'Zorluklar karşısında birlikte güçleniyorsunuz. Kriz anları ilişkinizi yıkmıyor, aksine pekiştiriyor.',
    ];
  }

  static List<String> _getSoulPurpose(ZodiacSign sun) {
    return [
      'Bu ilişki, her ikinizin de en yüksek potansiyelinize ulaşmanız için bir araç. Birlikte, tek başınıza yapamadığınız şeyleri başarabilirsiniz.',
      'Ruhsal amacınız, birbirinize ayna tutarak gölge yanlarınızı iyileştirmek. Bu bazen ağır ama her zaman değerli.',
      'Birlikte, dünyaya sevgi ve şifa enerjisi yayma potansiyeliniz var. İlişkiniz sadece sizin için değil, çevrenizdekiler için de ilham kaynağı.',
    ];
  }

  // ============ VEDIC/SIDEREAL CHART ============

  static VedicChart generateVedicChart({
    required DateTime birthDate,
    required ZodiacSign westernSun,
    required ZodiacSign westernMoon,
    required ZodiacSign westernAscendant,
  }) {
    final seed = birthDate.year * 10000 + birthDate.month * 100 + birthDate.day;
    final seededRandom = Random(seed);

    // Apply ayanamsa (approximately 24 degrees) to convert to sidereal
    final siderealMoon = _applySiderealCorrection(westernMoon);
    final siderealAsc = _applySiderealCorrection(westernAscendant);

    // Calculate nakshatra - deterministic based on sidereal moon
    // Each sign contains approximately 2.25 nakshatras (27 nakshatras / 12 signs)
    // Nakshatra index is derived from moon sign for consistency
    final nakshatraIndex = ((siderealMoon.index * 27) ~/ 12 + (birthDate.day % 3)) % 27;
    final nakshatra = Nakshatra.all[nakshatraIndex];

    // Generate planet positions
    final planets = _generateVedicPlanetPositions(seededRandom, siderealAsc);

    // Check for doshas
    final manglikStatus = _checkManglikDosha(planets);
    final kalaSarpa = _checkKalaSarpaYoga(planets);
    final yogas = _identifyYogas(planets, seededRandom);

    // Calculate dasha
    final dashas = _calculateDasha(nakshatra, birthDate);

    final predictions = _getVedicPredictions(siderealMoon, nakshatra);

    return VedicChart(
      moonSign: siderealMoon,
      nakshatra: nakshatra.number,
      nakshatraName: nakshatra.name,
      nakshatraLord: nakshatra.lord,
      // Pada is deterministic based on birth day
      nakshatraPada: '${(birthDate.day % 4) + 1}',
      ascendant: siderealAsc,
      planets: planets,
      manglikStatus: manglikStatus,
      kalaSarpaYoga: kalaSarpa,
      yogas: yogas,
      dashaLord: dashas['mahadasha']!,
      antardasha: dashas['antardasha']!,
      pratyantardasha: dashas['pratyantardasha']!,
      generalPrediction: predictions[seededRandom.nextInt(predictions.length)],
    );
  }

  static ZodiacSign _applySiderealCorrection(ZodiacSign tropical) {
    // Move back approximately 1 sign (24 degrees ≈ 1 sign)
    final correctedIndex = (tropical.index - 1 + 12) % 12;
    return ZodiacSign.values[correctedIndex];
  }

  static List<VedicPlanetPosition> _generateVedicPlanetPositions(Random seededRandom, ZodiacSign ascendant) {
    final planetNames = ['Güneş', 'Ay', 'Mars', 'Merkür', 'Jüpiter', 'Venüs', 'Satürn', 'Rahu', 'Ketu'];
    final planets = <VedicPlanetPosition>[];

    // Traditional planetary offsets from ascendant for approximate Vedic positions
    // These create deterministic but varied positions based on ascendant
    final planetOffsets = [0, 4, 7, 2, 9, 3, 10, 6, 0]; // Traditional approximate offsets

    for (int i = 0; i < planetNames.length; i++) {
      // Deterministic sign calculation: ascendant + offset + seed variation
      final seedVariation = (seededRandom.nextInt(4) - 2); // Small deterministic variation
      final sign = ZodiacSign.values[(ascendant.index + planetOffsets[i] + seedVariation + 12) % 12];
      final house = ((sign.index - ascendant.index + 12) % 12) + 1;
      // Deterministic retrograde based on planet type (outer planets more likely)
      final isRetro = i >= 4 && (seededRandom.nextInt(10) < 3);

      String dignity = 'Normal';
      bool isExalted = false;
      bool isDebilitated = false;

      // Check dignity (simplified)
      if (_isExalted(planetNames[i], sign)) {
        dignity = 'Yükselmiş';
        isExalted = true;
      } else if (_isDebilitated(planetNames[i], sign)) {
        dignity = 'Düşmüş';
        isDebilitated = true;
      } else if (_isOwnSign(planetNames[i], sign)) {
        dignity = 'Kendi Evi';
      }

      planets.add(VedicPlanetPosition(
        planet: planetNames[i],
        sign: sign,
        house: house,
        isRetrograde: isRetro,
        isExalted: isExalted,
        isDebilitated: isDebilitated,
        dignity: dignity,
      ));
    }

    return planets;
  }

  static bool _isExalted(String planet, ZodiacSign sign) {
    final exaltations = {
      'Güneş': ZodiacSign.aries,
      'Ay': ZodiacSign.taurus,
      'Mars': ZodiacSign.capricorn,
      'Merkür': ZodiacSign.virgo,
      'Jüpiter': ZodiacSign.cancer,
      'Venüs': ZodiacSign.pisces,
      'Satürn': ZodiacSign.libra,
    };
    return exaltations[planet] == sign;
  }

  static bool _isDebilitated(String planet, ZodiacSign sign) {
    final debilitations = {
      'Güneş': ZodiacSign.libra,
      'Ay': ZodiacSign.scorpio,
      'Mars': ZodiacSign.cancer,
      'Merkür': ZodiacSign.pisces,
      'Jüpiter': ZodiacSign.capricorn,
      'Venüs': ZodiacSign.virgo,
      'Satürn': ZodiacSign.aries,
    };
    return debilitations[planet] == sign;
  }

  static bool _isOwnSign(String planet, ZodiacSign sign) {
    final ownSigns = {
      'Güneş': [ZodiacSign.leo],
      'Ay': [ZodiacSign.cancer],
      'Mars': [ZodiacSign.aries, ZodiacSign.scorpio],
      'Merkür': [ZodiacSign.gemini, ZodiacSign.virgo],
      'Jüpiter': [ZodiacSign.sagittarius, ZodiacSign.pisces],
      'Venüs': [ZodiacSign.taurus, ZodiacSign.libra],
      'Satürn': [ZodiacSign.capricorn, ZodiacSign.aquarius],
    };
    return ownSigns[planet]?.contains(sign) ?? false;
  }

  static String _checkManglikDosha(List<VedicPlanetPosition> planets) {
    final mars = planets.firstWhere((p) => p.planet == 'Mars');
    final manglikHouses = [1, 4, 7, 8, 12];

    if (manglikHouses.contains(mars.house)) {
      return 'Manglik Dosha mevcut. Mars ${mars.house}. evde. Evlilik öncesi dikkate alınması gereken bir dosha.';
    }
    return 'Manglik Dosha yok. Mars uygun konumda.';
  }

  static String _checkKalaSarpaYoga(List<VedicPlanetPosition> planets) {
    // Simplified check
    final rahu = planets.firstWhere((p) => p.planet == 'Rahu');
    final ketu = planets.firstWhere((p) => p.planet == 'Ketu');

    if ((rahu.house - ketu.house).abs() == 6) {
      return 'Kala Sarpa Yoga belirtileri mevcut. Ruhsal gelişim için önemli bir yoga.';
    }
    return 'Kala Sarpa Yoga yok.';
  }

  static List<String> _identifyYogas(List<VedicPlanetPosition> planets, Random seededRandom) {
    final possibleYogas = [
      'Gajakesari Yoga - Jüpiter Ay ile güçlü açıda',
      'Budhaditya Yoga - Merkür Güneş ile kavuşumda',
      'Chandra-Mangal Yoga - Ay Mars ile birlikte',
      'Hamsa Yoga - Jüpiter köşe evinde',
      'Malavya Yoga - Venüs köşe evinde',
      'Raja Yoga - Lagna ve 5. ev lordu kavuşumda',
      'Dhana Yoga - 2. ve 11. ev lordları ilişkide',
    ];

    final count = seededRandom.nextInt(3) + 1;
    final selected = <String>[];

    for (int i = 0; i < count; i++) {
      final yoga = possibleYogas[seededRandom.nextInt(possibleYogas.length)];
      if (!selected.contains(yoga)) {
        selected.add(yoga);
      }
    }

    return selected;
  }

  static Map<String, String> _calculateDasha(Nakshatra nakshatra, DateTime birthDate) {
    final lords = ['Ketu', 'Venus', 'Sun', 'Moon', 'Mars', 'Rahu', 'Jupiter', 'Saturn', 'Mercury'];
    final nakshatraLord = nakshatra.lord;
    final lordIndex = lords.indexOf(nakshatraLord);

    final age = DateTime.now().difference(birthDate).inDays ~/ 365;
    final mahadashaIndex = (lordIndex + age ~/ 10) % lords.length;
    final antardashaIndex = (mahadashaIndex + age % 10) % lords.length;
    final pratyantarIndex = (antardashaIndex + DateTime.now().month) % lords.length;

    return {
      'mahadasha': lords[mahadashaIndex],
      'antardasha': lords[antardashaIndex],
      'pratyantardasha': lords[pratyantarIndex],
    };
  }

  static List<String> _getVedicPredictions(ZodiacSign moon, Nakshatra nakshatra) {
    return [
      '${moon.nameTr} Rasi\'nde Ay ile doğdunuz. ${nakshatra.name} nakshatra\'sının etkileri yaşamınızda belirgindir. ${nakshatra.lord} gezegeni sizin nakshatra lordunuz olarak önemli kararlarınızı yönlendiriyor.',
      'Vedik astrolojiye göre, ${nakshatra.deity} tanrıçasının kutsaması altındasınız. Bu, size ${nakshatra.symbol} sembolünün temsil ettiği nitelikleri veriyor.',
      'Mevcut dasha döneminiz önemli gelişmelere işaret ediyor. Gezegen transitlerini takip ederek, uygun zamanlarda adım atabilirsiniz.',
    ];
  }

  // ============ SECONDARY PROGRESSIONS ============

  static SecondaryProgressions generateProgressions({
    required DateTime birthDate,
    required ZodiacSign natalSun,
    required ZodiacSign natalMoon,
    required ZodiacSign natalAscendant,
  }) {
    final now = DateTime.now();
    final age = now.difference(birthDate).inDays ~/ 365;
    final seed = birthDate.year * 10000 + birthDate.month * 100 + birthDate.day + age;
    final seededRandom = Random(seed);

    // Calculate progressed positions
    // Sun moves ~1 degree per year
    final progressedSunIndex = (natalSun.index + age ~/ 30) % 12;
    final progressedSun = ZodiacSign.values[progressedSunIndex];

    // Moon moves ~1 sign per 2.5 years
    final progressedMoonIndex = (natalMoon.index + age ~/ 2.5).round() % 12;
    final progressedMoon = ZodiacSign.values[progressedMoonIndex];

    // Ascendant progresses slowly
    final progressedAscIndex = (natalAscendant.index + age ~/ 72) % 12;
    final progressedAsc = ZodiacSign.values[progressedAscIndex];

    // Other planets
    final progressedMercury = ZodiacSign.values[(natalSun.index + age ~/ 25) % 12];
    final progressedVenus = ZodiacSign.values[(natalSun.index + age ~/ 20) % 12];
    final progressedMars = ZodiacSign.values[(natalSun.index + age ~/ 60) % 12];

    // Generate content
    final lifePhases = _getLifePhaseContent(age, progressedSun);
    final emotionalThemes = _getProgressedEmotionalTheme(progressedMoon);
    final identityContent = _getIdentityEvolution(natalSun, progressedSun);
    final upcomingContent = _getUpcomingChanges(progressedSun, progressedMoon, seededRandom);

    // Generate aspects
    final aspects = _generateProgressedAspects(natalSun, progressedSun, natalMoon, progressedMoon, seededRandom);

    // Generate events
    final events = _generateProgressionEvents(birthDate, age, seededRandom);

    return SecondaryProgressions(
      birthDate: birthDate,
      progressedDate: now,
      progressedAge: age,
      progressedSun: progressedSun,
      progressedMoon: progressedMoon,
      progressedAscendant: progressedAsc,
      progressedMercury: progressedMercury,
      progressedVenus: progressedVenus,
      progressedMars: progressedMars,
      currentLifePhase: lifePhases[seededRandom.nextInt(lifePhases.length)],
      emotionalTheme: emotionalThemes[seededRandom.nextInt(emotionalThemes.length)],
      identityEvolution: identityContent[seededRandom.nextInt(identityContent.length)],
      upcomingChanges: upcomingContent[seededRandom.nextInt(upcomingContent.length)],
      activeAspects: aspects,
      significantEvents: events,
    );
  }

  static List<String> _getLifePhaseContent(int age, ZodiacSign progressedSun) {
    return [
      '$age yaşındasınız ve ilerlemişş Güneşiniz ${progressedSun.nameTr} burcunda. Bu dönem, ${progressedSun.element.nameTr} elementi temalarının ön plana çıktığı bir yaşam evresini temsil ediyor.',
      'Şu anki yaşam fazınız, kimlik ve özbilincin derinleşmesiyle ilgili. ${progressedSun.nameTr} enerjisi size yeni bakış açıları ve fırsatlar sunuyor.',
      'İlerlemişş haritanız, bu dönemde iç dünyanızda önemli değişimlerin yaşandığına işaret ediyor. Dış olaylar bu iç dönüşümün yansımaları.',
    ];
  }

  static List<String> _getProgressedEmotionalTheme(ZodiacSign moon) {
    return [
      'İlerlemişş Ayınız ${moon.nameTr} burcunda. Duygusal dünyanız ${moon.element.nameTr} elementinin niteliklerini taşıyor. Bu dönem, duygusal olgunlaşma ve iç huzur arayışı ile belirleniyor.',
      'Ayınız şu anki konumunda, ilişkileriniz ve iç dünyanızla bağlantınız konusunda yeni fikirler getiriyor. Duygusal zeka geliştirmek için ideal bir dönem.',
      'İlerlemişş Ay, bakım ve beslenmek temalarını vurguluyor. Hem kendinize hem de sevdiklerinize nasıl baktığınızı sorgulayın.',
    ];
  }

  static List<String> _getIdentityEvolution(ZodiacSign natal, ZodiacSign progressed) {
    if (natal == progressed) {
      return [
        'Güneşiniz hala doğum burcunuzda. Kimliğiniz istikrarlı bir evrimden geçiyor. Temel değerleriniz sağlamlaşıyor.',
      ];
    }
    return [
      'Güneşiniz ${natal.nameTr}\'dan ${progressed.nameTr}\'a ilerledi. Bu, kimliğinizde önemli bir evrime işaret ediyor. ${progressed.nameTr} niteliklerini bütünleştiriyorsunuz.',
      'Doğumda ${natal.nameTr} olan kimliğiniz, şimdi ${progressed.nameTr} enerjilerini de kapsıyor. Bu genişleme, sizi daha bütünsel bir insan yapıyor.',
    ];
  }

  static List<String> _getUpcomingChanges(ZodiacSign sun, ZodiacSign moon, Random seededRandom) {
    return [
      'Önümüzdeki dönemde, Ay yeni bir burca ilerleyecek. Bu, duygusal önceliklerinizde bir kayma anlamına gelecek.',
      'İlerlemişş Güneş yeni bir açı oluşturmak üzere. Bu, önemli kararlar ve yeni başlangıçlar için bir işarettir.',
      'Gezegen ilerlemeleri, kariyer ve ilişki alanlarında önemli gelişmelere işaret ediyor. Hazır olun.',
    ];
  }

  static List<ProgressedAspect> _generateProgressedAspects(
    ZodiacSign natalSun,
    ZodiacSign progressedSun,
    ZodiacSign natalMoon,
    ZodiacSign progressedMoon,
    Random seededRandom,
  ) {
    final aspects = <ProgressedAspect>[];

    aspects.add(ProgressedAspect(
      progressedPlanet: 'Güneş',
      natalPlanet: 'Güneş',
      type: AspectType.values[seededRandom.nextInt(AspectType.values.length)],
      interpretation: 'İlerlemişş Güneş, natal Güneşinizle etkileşimde. Kimlik ve yaşam amacı temaları gündemde.',
      exactDate: DateTime.now().add(Duration(days: seededRandom.nextInt(365))),
      isApplying: seededRandom.nextBool(),
    ));

    aspects.add(ProgressedAspect(
      progressedPlanet: 'Ay',
      natalPlanet: 'Ay',
      type: AspectType.values[seededRandom.nextInt(AspectType.values.length)],
      interpretation: 'İlerlemişş Ay, natal Ayınızla arada. Duygusal dönem ve iç dünyanız ön planda.',
      exactDate: DateTime.now().add(Duration(days: seededRandom.nextInt(90))),
      isApplying: seededRandom.nextBool(),
    ));

    return aspects;
  }

  static List<ProgressionEvent> _generateProgressionEvents(DateTime birthDate, int age, Random seededRandom) {
    final events = <ProgressionEvent>[];
    final now = DateTime.now();

    // Past events
    if (age > 30) {
      events.add(ProgressionEvent(
        date: birthDate.add(Duration(days: 30 * 365)),
        event: 'İlerlemişş Güneş burç değişimi',
        description: '30 yaşında ilerlemişş Güneşiniz yeni bir burca geçti. Kimliğinizde önemli bir evrim.',
        type: ProgressionEventType.sunSignChange,
      ));
    }

    // Upcoming events
    events.add(ProgressionEvent(
      date: now.add(Duration(days: seededRandom.nextInt(365) + 30)),
      event: 'İlerlemişş Yeni Ay',
      description: 'İlerlemişş Güneş ve Ay kavuşumu. Yeni başlangıçlar için güçlü bir zaman.',
      type: ProgressionEventType.newMoon,
    ));

    events.add(ProgressionEvent(
      date: now.add(Duration(days: seededRandom.nextInt(180) + 10)),
      event: 'Önemli Açı Aktivasyonu',
      description: 'İlerlemişş bir gezegen natal haritanızda önemli bir noktayla açı yapıyor.',
      type: ProgressionEventType.majorAspect,
    ));

    return events;
  }
}
