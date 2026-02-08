import 'dart:math';
import '../models/specialized_tools.dart';
import '../models/zodiac_sign.dart';
import '../models/planet.dart';
import '../providers/app_providers.dart';
import 'l10n_service.dart';

class SpecializedToolsService {
  static final SpecializedToolsService _instance =
      SpecializedToolsService._internal();
  factory SpecializedToolsService() => _instance;
  SpecializedToolsService._internal();

  /// Generate Local Space Chart
  LocalSpaceChart generateLocalSpaceChart({
    required String userName,
    required DateTime birthDate,
    required double latitude,
    required double longitude,
    AppLanguage language = AppLanguage.tr,
  }) {
    final random = Random(birthDate.millisecondsSinceEpoch);
    final localSpacePlanets = [
      Planet.sun, Planet.moon, Planet.mercury, Planet.venus, Planet.mars, Planet.jupiter, Planet.saturn
    ];

    final planetLines = localSpacePlanets.map((planet) {
      final azimuth = random.nextDouble() * 360;
      final direction = _getDirectionFromAzimuth(azimuth);
      final planetName = planet.localizedName(language);

      return LocalSpaceLine(
        planet: planetName,
        azimuth: azimuth,
        direction: direction,
        meaning: _getPlanetDirectionMeaning(planet, direction, language),
        homeAdvice: _getPlanetHomeAdvice(planet, direction, language),
        travelAdvice: _getPlanetTravelAdvice(planet, direction, language),
      );
    }).toList();

    final directions = CardinalDirection.values.map((dir) {
      final planetsInDirection = planetLines
          .where((l) => l.direction == dir)
          .map((l) => l.planet)
          .toList();

      return DirectionalInfluence(
        direction: dir,
        activePlanets: planetsInDirection,
        theme: _getDirectionTheme(dir, planetsInDirection, language),
        advice: _getDirectionAdvice(dir, planetsInDirection, language),
        strengthRating: planetsInDirection.isEmpty ? 2 : 3 + random.nextInt(3),
      );
    }).toList();

    return LocalSpaceChart(
      userName: userName,
      birthDate: birthDate,
      latitude: latitude,
      longitude: longitude,
      planetLines: planetLines,
      directions: directions,
      homeAnalysis: _generateHomeAnalysis(planetLines, language),
      officeAnalysis: _generateOfficeAnalysis(planetLines, language),
    );
  }

  CardinalDirection _getDirectionFromAzimuth(double azimuth) {
    if (azimuth >= 337.5 || azimuth < 22.5) return CardinalDirection.north;
    if (azimuth >= 22.5 && azimuth < 67.5) return CardinalDirection.northeast;
    if (azimuth >= 67.5 && azimuth < 112.5) return CardinalDirection.east;
    if (azimuth >= 112.5 && azimuth < 157.5) return CardinalDirection.southeast;
    if (azimuth >= 157.5 && azimuth < 202.5) return CardinalDirection.south;
    if (azimuth >= 202.5 && azimuth < 247.5) return CardinalDirection.southwest;
    if (azimuth >= 247.5 && azimuth < 292.5) return CardinalDirection.west;
    return CardinalDirection.northwest;
  }

  String _getPlanetDirectionMeaning(Planet planet, CardinalDirection dir, AppLanguage language) {
    final directionName = L10nService.get('local_space.directions.${dir.name}', language);
    final planetKey = planet.name.toLowerCase();
    final key = 'local_space.planet_meanings.$planetKey';

    // Try specific planet key, fallback to default
    String template = L10nService.get(key, language);
    if (template == key) {
      template = L10nService.get('local_space.planet_meanings.default', language);
    }

    return template.replaceAll('{direction}', directionName);
  }

  String _getPlanetHomeAdvice(Planet planet, CardinalDirection dir, AppLanguage language) {
    final directionName = L10nService.get('local_space.directions.${dir.name}', language);
    final planetKey = planet.name.toLowerCase();
    final key = 'local_space.home_advice.$planetKey';

    String template = L10nService.get(key, language);
    if (template == key) {
      template = L10nService.get('local_space.home_advice.default', language);
    }

    return template.replaceAll('{direction}', directionName);
  }

  String _getPlanetTravelAdvice(Planet planet, CardinalDirection dir, AppLanguage language) {
    final directionName = L10nService.get('local_space.directions.${dir.name}', language);
    final planetKey = planet.name.toLowerCase();
    final key = 'local_space.travel_advice.$planetKey';

    String template = L10nService.get(key, language);
    if (template == key) {
      template = L10nService.get('local_space.travel_advice.default', language);
    }

    return template.replaceAll('{direction}', directionName);
  }

  String _getDirectionTheme(CardinalDirection dir, List<String> planets, AppLanguage language) {
    final directionName = L10nService.get('local_space.directions.${dir.name}', language);

    String themeKey;
    if (planets.isEmpty) {
      themeKey = 'neutral';
    } else {
      // Check for positive planets (Sun, Jupiter) in any language
      final sunName = Planet.sun.localizedName(language);
      final jupiterName = Planet.jupiter.localizedName(language);
      final saturnName = Planet.saturn.localizedName(language);
      final marsName = Planet.mars.localizedName(language);

      if (planets.contains(sunName) || planets.contains(jupiterName)) {
        themeKey = 'positive';
      } else if (planets.contains(saturnName) || planets.contains(marsName)) {
        themeKey = 'careful';
      } else {
        themeKey = 'balanced';
      }
    }

    final template = L10nService.get('local_space.direction_themes.$themeKey', language);
    return template.replaceAll('{direction}', directionName);
  }

  String _getDirectionAdvice(CardinalDirection dir, List<String> planets, AppLanguage language) {
    final directionName = L10nService.get('local_space.directions.${dir.name}', language);

    if (planets.isEmpty) {
      final template = L10nService.get('local_space.direction_themes.neutral', language);
      return template.replaceAll('{direction}', directionName);
    }

    final planetStr = planets.join(', ');
    final template = L10nService.get('local_space.direction_themes.balanced', language);
    return '$planetStr - ${template.replaceAll('{direction}', directionName)}';
  }

  String _generateHomeAnalysis(List<LocalSpaceLine> lines, AppLanguage language) {
    final buffer = StringBuffer();
    buffer.writeln(L10nService.get('local_space.analysis.home_title', language));
    buffer.writeln();
    buffer.writeln(L10nService.get('local_space.analysis.home_intro', language));
    buffer.writeln();

    for (final line in lines.take(4)) {
      buffer.writeln('• ${line.planet}: ${line.homeAdvice}');
    }

    buffer.writeln();
    buffer.writeln(L10nService.get('local_space.analysis.home_conclusion', language));

    return buffer.toString();
  }

  String _generateOfficeAnalysis(List<LocalSpaceLine> lines, AppLanguage language) {
    final buffer = StringBuffer();
    buffer.writeln(L10nService.get('local_space.analysis.office_title', language));
    buffer.writeln();
    buffer.writeln(L10nService.get('local_space.analysis.office_intro', language));
    buffer.writeln();

    // Find planets by their localized names
    final sunName = Planet.sun.localizedName(language);
    final mercuryName = Planet.mercury.localizedName(language);
    final jupiterName = Planet.jupiter.localizedName(language);

    final sunLine = lines.firstWhere((l) => l.planet == sunName);
    final mercuryLine = lines.firstWhere((l) => l.planet == mercuryName);
    final jupiterLine = lines.firstWhere((l) => l.planet == jupiterName);

    final sunDir = L10nService.get('local_space.directions.${sunLine.direction.name}', language);
    final mercuryDir = L10nService.get('local_space.directions.${mercuryLine.direction.name}', language);
    final jupiterDir = L10nService.get('local_space.directions.${jupiterLine.direction.name}', language);

    buffer.writeln('• ${L10nService.get('local_space.analysis.desk_position', language).replaceAll('{direction}', sunDir)}');
    buffer.writeln('• ${L10nService.get('local_space.analysis.communication_devices', language).replaceAll('{direction}', mercuryDir)}');
    buffer.writeln('• ${L10nService.get('local_space.analysis.growth_goals', language).replaceAll('{direction}', jupiterDir)}');

    return buffer.toString();
  }

  /// Generate Child Horoscope
  ChildHoroscope generateChildHoroscope({
    required String childName,
    required DateTime birthDate,
    ZodiacSign? moonSign,
    AppLanguage language = AppLanguage.tr,
  }) {
    final random = Random(birthDate.millisecondsSinceEpoch + DateTime.now().day);
    final sunSign = ZodiacSignExtension.fromDate(birthDate);

    return ChildHoroscope(
      childName: childName,
      birthDate: birthDate,
      sunSign: sunSign,
      moonSign: moonSign,
      personalityProfile: _getChildPersonality(sunSign, language),
      learningStyle: _getChildLearningStyle(sunSign, language),
      socialStyle: _getChildSocialStyle(sunSign, language),
      emotionalNeeds: _getChildEmotionalNeeds(sunSign, moonSign, language),
      talents: _getChildTalents(sunSign, language),
      challenges: _getChildChallenges(sunSign, language),
      parentingTips: _getParentingTips(sunSign, language),
      dailyHoroscope: _getChildDailyHoroscope(sunSign, random, language),
      moodRating: 2 + random.nextInt(4),
      energyRating: 2 + random.nextInt(4),
      focusRating: 2 + random.nextInt(4),
    );
  }

  String _getChildPersonality(ZodiacSign sign, AppLanguage language) {
    final signKey = _getSignKey(sign);
    return L10nService.get('child_horoscope.personality.$signKey', language);
  }

  String _getSignKey(ZodiacSign sign) {
    switch (sign) {
      case ZodiacSign.aries: return 'aries';
      case ZodiacSign.taurus: return 'taurus';
      case ZodiacSign.gemini: return 'gemini';
      case ZodiacSign.cancer: return 'cancer';
      case ZodiacSign.leo: return 'leo';
      case ZodiacSign.virgo: return 'virgo';
      case ZodiacSign.libra: return 'libra';
      case ZodiacSign.scorpio: return 'scorpio';
      case ZodiacSign.sagittarius: return 'sagittarius';
      case ZodiacSign.capricorn: return 'capricorn';
      case ZodiacSign.aquarius: return 'aquarius';
      case ZodiacSign.pisces: return 'pisces';
    }
  }

  String _getChildLearningStyle(ZodiacSign sign, AppLanguage language) {
    final signKey = _getSignKey(sign);
    return L10nService.get('child_horoscope.learning_style.$signKey', language);
  }

  String _getChildSocialStyle(ZodiacSign sign, AppLanguage language) {
    final signKey = _getSignKey(sign);
    return L10nService.get('child_horoscope.social_style.$signKey', language);
  }

  String _getChildEmotionalNeeds(ZodiacSign sun, ZodiacSign? moon, AppLanguage language) {
    final moonSign = moon ?? sun;
    final signKey = _getSignKey(moonSign);
    return L10nService.get('child_horoscope.emotional_needs.$signKey', language);
  }

  List<String> _getChildTalents(ZodiacSign sign, AppLanguage language) {
    final signKey = _getSignKey(sign);
    return L10nService.getList('child_horoscope.talents.$signKey', language);
  }

  List<String> _getChildChallenges(ZodiacSign sign, AppLanguage language) {
    final signKey = _getSignKey(sign);
    return L10nService.getList('child_horoscope.challenges.$signKey', language);
  }

  String _getParentingTips(ZodiacSign sign, AppLanguage language) {
    final signKey = _getSignKey(sign);
    return L10nService.get('child_horoscope.parenting_tips.$signKey', language);
  }

  String _getChildDailyHoroscope(ZodiacSign sign, Random random, AppLanguage language) {
    final horoscopes = L10nService.getList('child_horoscope.daily_horoscopes', language);
    return horoscopes[random.nextInt(horoscopes.length)];
  }

  /// Generate Family Horoscope
  FamilyHoroscope generateFamilyHoroscope(List<FamilyMember> members, {AppLanguage language = AppLanguage.tr}) {
    final random = Random(DateTime.now().millisecondsSinceEpoch);

    // Analyze family dynamics based on elements
    final elementCounts = <Element, int>{};
    for (final member in members) {
      final element = member.sunSign.element;
      elementCounts[element] = (elementCounts[element] ?? 0) + 1;
    }

    final dominantElement = elementCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return FamilyHoroscope(
      members: members,
      familyDynamics: _getFamilyDynamics(dominantElement, members, language),
      strengthsAsFamily: _getFamilyStrengths(dominantElement, members, language),
      challengesAsFamily: _getFamilyChallenges(elementCounts, language),
      communicationStyle: _getFamilyCommunicationStyle(members, language),
      familyAdvice: _getFamilyAdvice(dominantElement, random, language),
      date: DateTime.now(),
    );
  }

  String _getElementKey(Element element) {
    switch (element) {
      case Element.fire: return 'fire';
      case Element.earth: return 'earth';
      case Element.air: return 'air';
      case Element.water: return 'water';
    }
  }

  String _getFamilyDynamics(Element dominant, List<FamilyMember> members, AppLanguage language) {
    final elementKey = _getElementKey(dominant);
    return L10nService.get('child_horoscope.family_dynamics.$elementKey', language);
  }

  List<String> _getFamilyStrengths(Element dominant, List<FamilyMember> members, AppLanguage language) {
    final elementKey = _getElementKey(dominant);
    return L10nService.getList('child_horoscope.family_strengths.$elementKey', language);
  }

  List<String> _getFamilyChallenges(Map<Element, int> elements, AppLanguage language) {
    final challenges = <String>[];

    if ((elements[Element.fire] ?? 0) > 2) {
      challenges.add(L10nService.get('child_horoscope.family_challenges.fire_dominant', language));
    }
    if ((elements[Element.earth] ?? 0) > 2) {
      challenges.add(L10nService.get('child_horoscope.family_challenges.earth_dominant', language));
    }
    if ((elements[Element.air] ?? 0) > 2) {
      challenges.add(L10nService.get('child_horoscope.family_challenges.air_dominant', language));
    }
    if ((elements[Element.water] ?? 0) > 2) {
      challenges.add(L10nService.get('child_horoscope.family_challenges.water_dominant', language));
    }

    if (challenges.isEmpty) {
      challenges.add(L10nService.get('child_horoscope.family_challenges.balanced', language));
    }

    return challenges;
  }

  String _getFamilyCommunicationStyle(List<FamilyMember> members, AppLanguage language) {
    final airCount = members.where((m) => m.sunSign.element == Element.air).length;
    final waterCount = members.where((m) => m.sunSign.element == Element.water).length;

    if (airCount > members.length / 2) {
      return L10nService.get('child_horoscope.communication_style.air_heavy', language);
    }
    if (waterCount > members.length / 2) {
      return L10nService.get('child_horoscope.communication_style.water_heavy', language);
    }
    return L10nService.get('child_horoscope.communication_style.default', language);
  }

  String _getFamilyAdvice(Element dominant, Random random, AppLanguage language) {
    final elementKey = _getElementKey(dominant);
    return L10nService.get('child_horoscope.daily_advice.$elementKey', language);
  }
}
