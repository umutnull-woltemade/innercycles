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
    final compositeSun = _getMidpointSign(person1Sun, person2Sun);
    final compositeMoon = _getMidpointSign(person1Moon, person2Moon);
    final compositeAsc = ZodiacSign.values[seededRandom.nextInt(12)];
    final compositeVenus = ZodiacSign.values[seededRandom.nextInt(12)];
    final compositeMars = ZodiacSign.values[seededRandom.nextInt(12)];

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

    // Add some randomness
    score += _random.nextInt(10) - 5;

    return score.clamp(0, 100);
  }

  static List<CompositeAspect> _generateCompositeAspects(Random seededRandom) {
    final planets = ['Gunes', 'Ay', 'Merkur', 'Venus', 'Mars', 'Jupiter', 'Saturn'];
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
      AspectType.conjunction: '$p1 ve $p2 enerjileri birlesik. Bu iliski icin guclü ve yogun bir baglanti.',
      AspectType.trine: '$p1 ile $p2 arasinda uyumlu enerji akisi. Dogal ve kolay bir etkilesim.',
      AspectType.sextile: '$p1 ve $p2 arasinda firsatlar yaratan pozitif aci. Isbirligi potansiyeli yuksek.',
      AspectType.square: '$p1 ve $p2 arasinda gerilim. Zorlayici ama buyume potansiyeli tasiyan dinamik.',
      AspectType.opposition: '$p1 ve $p2 karsitligi. Dengelenmesi gereken zit kutuplar.',
    };
    return interpretations[type]!;
  }

  static List<String> _getRelationshipThemes(ZodiacSign sun, ZodiacSign moon) {
    return [
      'Bu iliski, ${sun.nameTr} enerjisinin cesaret ve tutku kattigini, ${moon.nameTr} ayinin ise duygusal derinlik sagladigini gosteriyor. Birlikte hem ates hem su tasiyorsunuz.',
      'Kompozit haritaniz, karsilikli buyume ve donusum uzerine kurulu bir iliski oldugunu ortaya koyuyor. Her ikiniz de bu birliktelikten donusmus cikacaksiniz.',
      'Ruhsal baglantiniz guclu. Bu iliski, sadece romantik degil, ayni zamanda karmik bir anlam tasiyor. Birbirinize ogretecek cok seyiniz var.',
    ];
  }

  static List<String> _getEmotionalDynamics(ZodiacSign moon) {
    return [
      '${moon.nameTr} ayiyla, duygusal dunyaniz ${moon.element.nameTr} elementi tarafindan sekilleniyor. Hislerinizi paylasmak ve anlamak bu iliskinin temelini olusturuyor.',
      'Duygusal iletisimde derinlik ariyorsunuz. Yuzeysel baglantiler sizi tatmin etmez - gercek yakinlik ve guven istiyorsunuz.',
      'Birbirinizin duygusal ihtiyaclarini anlamak icin zaman ve sabir gerekiyor. Ama bu caba, karsilikli sifa ve buyumeyi beraberinde getirecek.',
    ];
  }

  static List<String> _getCommunicationStyle(ZodiacSign asc) {
    return [
      '${asc.nameTr} yukseleniyle, dis dunyaya nasil birlikte gorundugunuz ve iletisiminiz ${asc.element.nameTr} enerjisi tasiyor.',
      'Iletisim tarzi dogrudan ve acik. Birbirinize karsisincere ve durustler, bu da guveni guclendiriyor.',
      'Sozleriniz ve sessizlikleriniz esit derecede anlam tasiyor. Sozlu olmayan iletisimde de ustasınız.',
    ];
  }

  static List<String> _getChallenges(ZodiacSign sun, ZodiacSign moon) {
    return [
      'Ego catismalari ve bireysel ihtiyaclarin ilişki ihtiyaclariyla dengelenmesi zorluk olabilir. Taviz vermeyi ogrenmek gerekiyor.',
      'Farkli duygusal diller konusuyor olabilirsiniz. Birbirinizi yanlis anlamadan once, dinlemeyi ve sormayı ogrenin.',
      'Bagimsizlik ve yakinlik arasindaki denge, bu iliskinin ana temalaindan biri. Her ikisine de alan tanimak gerekiyor.',
    ];
  }

  static List<String> _getStrengths(ZodiacSign sun, ZodiacSign moon) {
    return [
      'Karsilikli saygi ve hayranlık iliskinizin temelini olusturuyor. Birbirinizin guçlu yanlarini takdir ediyorsunuz.',
      'Ortak degerlere ve vizyona sahipsiniz. Bu, uzun vadeli uyum ve hedef birliği sagliyor.',
      'Zorluklar karsisinda birlikte gucleniyorsunuz. Kriz anlari iliskinizi yikmiyor, aksine pekistiriyor.',
    ];
  }

  static List<String> _getSoulPurpose(ZodiacSign sun) {
    return [
      'Bu iliski, her ikinizin de en yuksek potansiyelinize ulasmaniz icin bir araç. Birlikte, tek basiniza yapamadiginiz seyleri başarabilirsiniz.',
      'Ruhsal amacınız, birbirinize ayna tutarak gölge yanlarinizi iyilestirmek. Bu bazen agir ama her zaman degerli.',
      'Birlikte, dunyaya sevgi ve sifa enerjisi yayma potansiyeliniz var. Iliskiniz sadece sizin icin degil, cevrenizdekiler icin de ilham kaynagi.',
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

    // Calculate nakshatra
    final nakshatraIndex = seededRandom.nextInt(27);
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
      nakshatraPada: '${seededRandom.nextInt(4) + 1}',
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
    final planetNames = ['Gunes', 'Ay', 'Mars', 'Merkur', 'Jupiter', 'Venus', 'Saturn', 'Rahu', 'Ketu'];
    final planets = <VedicPlanetPosition>[];

    for (int i = 0; i < planetNames.length; i++) {
      final sign = ZodiacSign.values[seededRandom.nextInt(12)];
      final house = ((sign.index - ascendant.index + 12) % 12) + 1;
      final isRetro = seededRandom.nextDouble() < 0.3;

      String dignity = 'Normal';
      bool isExalted = false;
      bool isDebilitated = false;

      // Check dignity (simplified)
      if (_isExalted(planetNames[i], sign)) {
        dignity = 'Yukselmis';
        isExalted = true;
      } else if (_isDebilitated(planetNames[i], sign)) {
        dignity = 'Dusmus';
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
      'Gunes': ZodiacSign.aries,
      'Ay': ZodiacSign.taurus,
      'Mars': ZodiacSign.capricorn,
      'Merkur': ZodiacSign.virgo,
      'Jupiter': ZodiacSign.cancer,
      'Venus': ZodiacSign.pisces,
      'Saturn': ZodiacSign.libra,
    };
    return exaltations[planet] == sign;
  }

  static bool _isDebilitated(String planet, ZodiacSign sign) {
    final debilitations = {
      'Gunes': ZodiacSign.libra,
      'Ay': ZodiacSign.scorpio,
      'Mars': ZodiacSign.cancer,
      'Merkur': ZodiacSign.pisces,
      'Jupiter': ZodiacSign.capricorn,
      'Venus': ZodiacSign.virgo,
      'Saturn': ZodiacSign.aries,
    };
    return debilitations[planet] == sign;
  }

  static bool _isOwnSign(String planet, ZodiacSign sign) {
    final ownSigns = {
      'Gunes': [ZodiacSign.leo],
      'Ay': [ZodiacSign.cancer],
      'Mars': [ZodiacSign.aries, ZodiacSign.scorpio],
      'Merkur': [ZodiacSign.gemini, ZodiacSign.virgo],
      'Jupiter': [ZodiacSign.sagittarius, ZodiacSign.pisces],
      'Venus': [ZodiacSign.taurus, ZodiacSign.libra],
      'Saturn': [ZodiacSign.capricorn, ZodiacSign.aquarius],
    };
    return ownSigns[planet]?.contains(sign) ?? false;
  }

  static String _checkManglikDosha(List<VedicPlanetPosition> planets) {
    final mars = planets.firstWhere((p) => p.planet == 'Mars');
    final manglikHouses = [1, 4, 7, 8, 12];

    if (manglikHouses.contains(mars.house)) {
      return 'Manglik Dosha mevcut. Mars ${mars.house}. evde. Evlilik oncesi dikkate alinmasi gereken bir dosha.';
    }
    return 'Manglik Dosha yok. Mars uygun konumda.';
  }

  static String _checkKalaSarpaYoga(List<VedicPlanetPosition> planets) {
    // Simplified check
    final rahu = planets.firstWhere((p) => p.planet == 'Rahu');
    final ketu = planets.firstWhere((p) => p.planet == 'Ketu');

    if ((rahu.house - ketu.house).abs() == 6) {
      return 'Kala Sarpa Yoga belirtileri mevcut. Ruhsal gelisim için onemli bir yoga.';
    }
    return 'Kala Sarpa Yoga yok.';
  }

  static List<String> _identifyYogas(List<VedicPlanetPosition> planets, Random seededRandom) {
    final possibleYogas = [
      'Gajakesari Yoga - Jupiter Ay ile güçlü açıda',
      'Budhaditya Yoga - Merkur Günes ile kavuşumda',
      'Chandra-Mangal Yoga - Ay Mars ile birlikte',
      'Hamsa Yoga - Jupiter köşe evinde',
      'Malavya Yoga - Venus köşe evinde',
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
      '${moon.nameTr} Rasi\'nde Ay ile dogdunuz. ${nakshatra.name} nakshatra\'sinin etkileri yasaminizda belirgindir. ${nakshatra.lord} gezegeni sizin nakshatra lordunuz olarak onemli kararlarinizi yonlendiriyor.',
      'Vedik astrolojiye gore, ${nakshatra.deity} tanriçasinin kutsamasi altindasiniz. Bu, size ${nakshatra.symbol} sembolunun temsil ettigi nitelikleri veriyor.',
      'Mevcut dasha doneminiz onemli gelismelere işaret ediyor. Gezegen transitlerini takip ederek, uygun zamanlarda adim atabilirsiniz.',
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
      '$age yasindasiniz ve ilerlemis Gunesiniz ${progressedSun.nameTr} burcunda. Bu donem, ${progressedSun.element.nameTr} elementi temalarinin on plana ciktigi bir yasam evresini temsil ediyor.',
      'Su anki yasam fasiniz, kimlik ve ozbilincin derinlesmesiyle ilgili. ${progressedSun.nameTr} enerjisi size yeni bakis acilari ve firsatlar sunuyor.',
      'Ilerlemis haritaniz, bu donemde ic dunyanizda onemli degisimlerin yasandigina isaret ediyor. Dis olaylar bu ic donusumun yansimalari.',
    ];
  }

  static List<String> _getProgressedEmotionalTheme(ZodiacSign moon) {
    return [
      'Ilerlemis Ayiniz ${moon.nameTr} burcunda. Duygusal dunyaniz ${moon.element.nameTr} elementinin niteliklerini tasiyor. Bu donem, duygusal olgunlasma ve ic huzur arayisi ile belirleniyor.',
      'Ayiniz su anki konumunda, iliskileriniz ve ic dunyanizla baglantiniz konusunda yeni fikirler getiriyor. Duygusal zeka gelistirmek icin ideal bir donem.',
      'Ilerlemis Ay, bakim ve beslenmek temalarini vurguluyor. Hem kendinize hem de sevdiklerinize nasil baktığınızı sorgulayin.',
    ];
  }

  static List<String> _getIdentityEvolution(ZodiacSign natal, ZodiacSign progressed) {
    if (natal == progressed) {
      return [
        'Gunesiniz hala dogum burcunuzda. Kimliginiz istikrarli bir evrimden geciyor. Temel degerleriniz saglamlasiyor.',
      ];
    }
    return [
      'Gunesiniz ${natal.nameTr}\'dan ${progressed.nameTr}\'a ilerledi. Bu, kimliginizde onemli bir evrime isaret ediyor. ${progressed.nameTr} niteliklerini butunlestiriyorsunuz.',
      'Dogumda ${natal.nameTr} olan kimliginiz, simdi ${progressed.nameTr} enerjilerini de kapsıyor. Bu genisleme, sizi daha bütünsel bir insan yapiyor.',
    ];
  }

  static List<String> _getUpcomingChanges(ZodiacSign sun, ZodiacSign moon, Random seededRandom) {
    return [
      'Onumuzdeki donemde, Ay yeni bir burca ilerleyecek. Bu, duygusal onceliklerinizde bir kayma anlamina gelecek.',
      'Ilerlemis Gunes yeni bir aci oluşturmak uzere. Bu, onemli kararlar ve yeni baslangiçlar icin bir isarettir.',
      'Gezegen ilerlemeleri, kariyer ve iliski alanlarinda onemli gelismelere isaret ediyor. Hazir olun.',
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
      progressedPlanet: 'Gunes',
      natalPlanet: 'Gunes',
      type: AspectType.values[seededRandom.nextInt(AspectType.values.length)],
      interpretation: 'Ilerlemis Gunes, natal Gunesinizle etkilesimde. Kimlik ve yasam amaci temaları gundemde.',
      exactDate: DateTime.now().add(Duration(days: seededRandom.nextInt(365))),
      isApplying: seededRandom.nextBool(),
    ));

    aspects.add(ProgressedAspect(
      progressedPlanet: 'Ay',
      natalPlanet: 'Ay',
      type: AspectType.values[seededRandom.nextInt(AspectType.values.length)],
      interpretation: 'Ilerlemis Ay, natal Ayinizla arada. Duygusal donem ve ic dunyaniz on planda.',
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
        event: 'Ilerlemis Gunes burc degisimi',
        description: '30 yasinda ilerlemis Gunesiniz yeni bir burca gecti. Kimliginizde onemli bir evrim.',
        type: ProgressionEventType.sunSignChange,
      ));
    }

    // Upcoming events
    events.add(ProgressionEvent(
      date: now.add(Duration(days: seededRandom.nextInt(365) + 30)),
      event: 'Ilerlemis Yeni Ay',
      description: 'Ilerlemis Gunes ve Ay kavuşumu. Yeni baslangiclar icin guclu bir zaman.',
      type: ProgressionEventType.newMoon,
    ));

    events.add(ProgressionEvent(
      date: now.add(Duration(days: seededRandom.nextInt(180) + 10)),
      event: 'Onemli Aci Aktivasyonu',
      description: 'Ilerlemis bir gezegen natal haritanizda onemli bir nokatayla aci yapiyor.',
      type: ProgressionEventType.majorAspect,
    ));

    return events;
  }
}
