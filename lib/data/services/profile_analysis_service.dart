import '../models/natal_chart.dart';
import '../models/planet.dart';
import '../models/aspect.dart';
import '../models/house.dart';
import '../models/zodiac_sign.dart';
import 'numerology_service.dart';

/// Complete psychological and relationship profile analysis
class ProfileAnalysisService {
  /// Generate complete profile analysis from natal chart
  static ProfileAnalysis analyzeProfile(NatalChart chart, {String? name}) {
    // Personality
    final personality = _analyzePersonality(chart);

    // Emotional profile
    final emotional = _analyzeEmotionalProfile(chart);

    // Love & relationships
    final love = _analyzeLoveProfile(chart);

    // Career & money
    final career = _analyzeCareerProfile(chart);

    // Psychological patterns
    final psychological = _analyzePsychologicalProfile(chart);

    // Karmic patterns
    final karmic = _analyzeKarmicProfile(chart);

    // Numerology
    NumerologyProfile? numerology;
    if (name != null) {
      numerology = _analyzeNumerology(chart.birthDate, name);
    }

    return ProfileAnalysis(
      personality: personality,
      emotional: emotional,
      love: love,
      career: career,
      psychological: psychological,
      karmic: karmic,
      numerology: numerology,
    );
  }

  static PersonalityProfile _analyzePersonality(NatalChart chart) {
    final sun = chart.sun;
    final moon = chart.moon;
    final asc = chart.ascendant;

    // Core traits from Sun sign
    final coreTraits = sun?.sign.traits ?? [];

    // Emotional style from Moon
    String emotionalStyle = '';
    if (moon != null) {
      switch (moon.sign.element) {
        case Element.fire:
          emotionalStyle = 'Passionate and spontaneous emotional expression';
          break;
        case Element.earth:
          emotionalStyle = 'Reliable and stable emotional approach';
          break;
        case Element.air:
          emotionalStyle = 'Analytical and communicative emotional processing';
          break;
        case Element.water:
          emotionalStyle = 'Deep and intuitive emotional world';
          break;
      }
    }

    // First impression from Ascendant
    String firstImpression = '';
    if (asc != null) {
      firstImpression = 'Projects ${asc.sign.name} energy to the outer world: '
          '${asc.sign.traits.take(2).join(", ")}';
    }

    // Dominant element
    final dominantElement = chart.dominantElement;

    // Dominant modality
    final dominantModality = chart.dominantModality;

    return PersonalityProfile(
      sunSign: sun?.sign ?? ZodiacSign.aries,
      moonSign: moon?.sign,
      risingSign: asc?.sign,
      coreTraits: coreTraits,
      emotionalStyle: emotionalStyle,
      firstImpression: firstImpression,
      dominantElement: dominantElement,
      dominantModality: dominantModality,
      retrogradeCount: chart.retrogradePlanets.length,
    );
  }

  static EmotionalProfile _analyzeEmotionalProfile(NatalChart chart) {
    final moon = chart.moon;
    final mars = chart.mars;
    final aspects = chart.aspectsForPlanet(Planet.moon);

    // Attachment style based on Moon aspects
    String attachmentStyle = 'Secure attachment';
    bool hasChallengingMoonAspects = aspects.any((a) => a.type.isChallenging);
    if (hasChallengingMoonAspects) {
      final saturnAspect = aspects.any((a) =>
          a.planet2 == Planet.saturn && a.type.isChallenging);
      final plutoAspect = aspects.any((a) =>
          a.planet2 == Planet.pluto && a.type.isChallenging);

      if (saturnAspect) {
        attachmentStyle = 'Avoidant attachment tendency - emotional distance';
      } else if (plutoAspect) {
        attachmentStyle = 'Anxious attachment tendency - intense emotional need';
      }
    }

    // Security needs from Moon sign
    String securityNeeds = '';
    if (moon != null) {
      switch (moon.sign) {
        case ZodiacSign.aries:
        case ZodiacSign.sagittarius:
          securityNeeds = 'Freedom and sense of adventure';
          break;
        case ZodiacSign.taurus:
        case ZodiacSign.cancer:
          securityNeeds = 'Physical comfort and family bonds';
          break;
        case ZodiacSign.gemini:
        case ZodiacSign.aquarius:
          securityNeeds = 'Mental stimulation and social connection';
          break;
        case ZodiacSign.leo:
          securityNeeds = 'Appreciation and recognition';
          break;
        case ZodiacSign.virgo:
          securityNeeds = 'Order and feeling useful';
          break;
        case ZodiacSign.libra:
          securityNeeds = 'Harmony and relationships';
          break;
        case ZodiacSign.scorpio:
          securityNeeds = 'Deep emotional bond and trust';
          break;
        case ZodiacSign.capricorn:
          securityNeeds = 'Achievement and social status';
          break;
        case ZodiacSign.pisces:
          securityNeeds = 'Spiritual connection and acceptance';
          break;
      }
    }

    // Emotional triggers
    final triggers = <String>[];
    final moonSquares =
        aspects.where((a) => a.type == AspectType.square).toList();
    for (final aspect in moonSquares) {
      final otherPlanet =
          aspect.planet1 == Planet.moon ? aspect.planet2 : aspect.planet1;
      triggers.add('${otherPlanet.name} matters can be emotional triggers');
    }

    // Stress response
    String stressResponse = '';
    if (mars != null) {
      switch (mars.sign.element) {
        case Element.fire:
          stressResponse = 'Active struggle - anger outbursts possible';
          break;
        case Element.earth:
          stressResponse = 'Seeks practical solutions - may withdraw';
          break;
        case Element.air:
          stressResponse = 'Rationalizes - may avoid emotions';
          break;
        case Element.water:
          stressResponse = 'Emotional reaction - withdrawal or passive aggression';
          break;
      }
    }

    return EmotionalProfile(
      attachmentStyle: attachmentStyle,
      securityNeeds: securityNeeds,
      emotionalTriggers: triggers,
      stressResponse: stressResponse,
      empathyLevel: _calculateEmpathyLevel(chart),
      emotionalResilience: _calculateResilienceLevel(chart),
    );
  }

  static LoveProfile _analyzeLoveProfile(NatalChart chart) {
    final venus = chart.venus;
    final mars = chart.mars;

    // Love language from Venus
    String loveLanguage = '';
    if (venus != null) {
      switch (venus.sign) {
        case ZodiacSign.aries:
        case ZodiacSign.leo:
          loveLanguage = 'Physical touch and actions';
          break;
        case ZodiacSign.taurus:
        case ZodiacSign.cancer:
          loveLanguage = 'Gifts and quality time';
          break;
        case ZodiacSign.gemini:
        case ZodiacSign.libra:
          loveLanguage = 'Words of affirmation and communication';
          break;
        case ZodiacSign.virgo:
        case ZodiacSign.capricorn:
          loveLanguage = 'Acts of service and practical support';
          break;
        case ZodiacSign.scorpio:
        case ZodiacSign.pisces:
          loveLanguage = 'Quality time and deep connection';
          break;
        case ZodiacSign.sagittarius:
        case ZodiacSign.aquarius:
          loveLanguage = 'Sharing adventures and giving freedom';
          break;
      }
    }

    // Attraction pattern from Venus/Mars
    String attractionPattern = '';
    if (venus != null && mars != null) {
      attractionPattern =
          '${venus.sign.name} attraction combined with ${mars.sign.name} desire';
    }

    // Relationship style
    String relationshipStyle = '';
    final venusAspects = chart.aspectsForPlanet(Planet.venus);
    final hasSaturnVenus = venusAspects.any((a) =>
        (a.planet1 == Planet.saturn || a.planet2 == Planet.saturn));

    if (hasSaturnVenus) {
      relationshipStyle = 'Inclined toward serious and long-term relationships';
    } else if (venus?.sign.element == Element.fire) {
      relationshipStyle = 'Passionate and spontaneous relationships';
    } else if (venus?.sign.element == Element.earth) {
      relationshipStyle = 'Reliable and stable relationships';
    } else if (venus?.sign.element == Element.air) {
      relationshipStyle = 'Intellectual and social relationships';
    } else {
      relationshipStyle = 'Deep and emotional relationships';
    }

    // Jealousy tendency
    int jealousyTendency = 50;
    if (venus?.sign == ZodiacSign.scorpio ||
        mars?.sign == ZodiacSign.scorpio) {
      jealousyTendency = 80;
    } else if (venus?.sign == ZodiacSign.taurus) {
      jealousyTendency = 70;
    } else if (venus?.sign == ZodiacSign.sagittarius ||
        venus?.sign == ZodiacSign.aquarius) {
      jealousyTendency = 30;
    }

    // Partner profile (7th house)
    String idealPartnerProfile = '';
    if (chart.hasExactTime) {
      final planetsIn7th = chart.planetsInHouse(House.seventh);
      final descendant = chart.planets.where((p) => p.planet == Planet.descendant).firstOrNull;
      if (descendant != null) {
        idealPartnerProfile =
            'Attracted to partners with ${descendant.sign.name} qualities';
        if (planetsIn7th.isNotEmpty) {
          idealPartnerProfile +=
              '. ${planetsIn7th.map((p) => p.planet.name).join(", ")} energy is important in relationships';
        }
      }
    }

    return LoveProfile(
      venusSign: venus?.sign,
      marsSign: mars?.sign,
      loveLanguage: loveLanguage,
      attractionPattern: attractionPattern,
      relationshipStyle: relationshipStyle,
      jealousyTendency: jealousyTendency,
      commitmentReadiness: _calculateCommitmentReadiness(chart),
      idealPartnerProfile: idealPartnerProfile,
    );
  }

  static CareerProfile _analyzeCareerProfile(NatalChart chart) {
    final sun = chart.sun;
    final saturn = chart.saturn;
    final jupiter = chart.jupiter;

    // Natural talents based on dominant element
    List<String> talents = [];
    switch (chart.dominantElement) {
      case Element.fire:
        talents = ['Leadership', 'Entrepreneurship', 'Motivation'];
        break;
      case Element.earth:
        talents = ['Planning', 'Organization', 'Financial intelligence'];
        break;
      case Element.air:
        talents = ['Communication', 'Analysis', 'Networking'];
        break;
      case Element.water:
        talents = ['Empathy', 'Creativity', 'Intuition'];
        break;
    }

    // Career direction from MC
    String careerDirection = '';
    if (chart.midheaven != null) {
      careerDirection =
          'Shines in public life with ${chart.midheaven!.sign.name} energy';
    }

    // Leadership vs support role
    bool isLeaderType = sun?.sign.modality == Modality.cardinal ||
        chart.dominantModality == Modality.cardinal;

    // Risk tolerance
    int riskTolerance = 50;
    if (jupiter?.sign.element == Element.fire ||
        sun?.sign == ZodiacSign.sagittarius) {
      riskTolerance = 80;
    } else if (saturn?.isRetrograde == true ||
        sun?.sign == ZodiacSign.capricorn) {
      riskTolerance = 30;
    }

    // Entrepreneurship potential
    int entrepreneurPotential = 50;
    final hasFireSun = sun?.sign.element == Element.fire;
    final hasCapricornPlacements = chart.planets
        .where((p) => p.sign == ZodiacSign.capricorn)
        .length;
    if (hasFireSun && hasCapricornPlacements > 0) {
      entrepreneurPotential = 85;
    } else if (hasFireSun) {
      entrepreneurPotential = 70;
    }

    return CareerProfile(
      naturalTalents: talents,
      careerDirection: careerDirection,
      isLeaderType: isLeaderType,
      riskTolerance: riskTolerance,
      entrepreneurPotential: entrepreneurPotential,
      saturnSign: saturn?.sign,
      jupiterSign: jupiter?.sign,
    );
  }

  static PsychologicalProfile _analyzePsychologicalProfile(NatalChart chart) {
    // Defense mechanisms based on Moon/Saturn aspects
    List<String> defenseMechanisms = [];
    final moonSaturnAspect = chart.aspects.any((a) =>
        (a.planet1 == Planet.moon && a.planet2 == Planet.saturn) ||
        (a.planet1 == Planet.saturn && a.planet2 == Planet.moon));

    if (moonSaturnAspect) {
      defenseMechanisms.add('Emotional suppression');
      defenseMechanisms.add('Excessive need for control');
    }

    // Pluto aspects indicate transformation patterns
    final plutoAspects = chart.aspectsForPlanet(Planet.pluto);
    if (plutoAspects.any((a) => a.type.isChallenging)) {
      defenseMechanisms.add('Intense control tendency');
    }

    // Shadow self from Lilith
    String shadowSelf = '';
    final lilith = chart.lilith;
    if (lilith != null) {
      shadowSelf = 'Suppressed ${lilith.sign.name} energy - '
          '${_getLilithMeaning(lilith.sign)}';
    }

    // Relationship patterns
    List<String> relationshipPatterns = [];
    final venusAspects = chart.aspectsForPlanet(Planet.venus);
    for (final aspect in venusAspects.where((a) => a.type.isChallenging)) {
      relationshipPatterns.add(
          '${aspect.planet1.name}-${aspect.planet2.name} ${aspect.type.name}: ${aspect.interpretation}');
    }

    return PsychologicalProfile(
      defenseMechanisms: defenseMechanisms,
      shadowSelf: shadowSelf,
      controlNeed: _calculateControlNeed(chart),
      solitaryNeed: _calculateSolitaryNeed(chart),
      relationshipPatterns: relationshipPatterns,
    );
  }

  static KarmicProfile _analyzeKarmicProfile(NatalChart chart) {
    final northNode = chart.northNode;
    final southNode = chart.southNode;
    final chiron = chart.chiron;

    // Life lesson from North Node
    String lifeLesson = '';
    if (northNode != null) {
      lifeLesson =
          'Developing ${northNode.sign.name} qualities is needed in this life: '
          '${_getNorthNodeLesson(northNode.sign)}';
    }

    // Past life patterns from South Node
    String pastLifePatterns = '';
    if (southNode != null) {
      pastLifePatterns =
          'Expert in ${southNode.sign.name} energy but must learn to let go: '
          '${_getSouthNodePattern(southNode.sign)}';
    }

    // Deepest wound from Chiron
    String deepestWound = '';
    if (chiron != null) {
      deepestWound = 'A deep wound exists in the ${chiron.sign.name} area: '
          '${_getChironWound(chiron.sign)}';
    }

    // Karmic debt numbers
    final karmicDebts =
        NumerologyService.findKarmicDebtNumbers(chart.birthDate);

    return KarmicProfile(
      northNodeSign: northNode?.sign,
      southNodeSign: southNode?.sign,
      chironSign: chiron?.sign,
      lifeLesson: lifeLesson,
      pastLifePatterns: pastLifePatterns,
      deepestWound: deepestWound,
      karmicDebtNumbers: karmicDebts,
    );
  }

  static NumerologyProfile _analyzeNumerology(DateTime birthDate, String name) {
    final lifePath = NumerologyService.calculateLifePathNumber(birthDate);
    final destiny = NumerologyService.calculateDestinyNumber(name);
    final soulUrge = NumerologyService.calculateSoulUrgeNumber(name);
    final personality = NumerologyService.calculatePersonalityNumber(name);
    final birthday = NumerologyService.calculateBirthdayNumber(birthDate);
    final personalYear = NumerologyService.calculatePersonalYearNumber(
        birthDate, DateTime.now().year);

    return NumerologyProfile(
      lifePathNumber: lifePath,
      destinyNumber: destiny,
      soulUrgeNumber: soulUrge,
      personalityNumber: personality,
      birthdayNumber: birthday,
      personalYearNumber: personalYear,
      lifePathMeaning: NumerologyService.getNumberMeaning(lifePath),
      destinyMeaning: NumerologyService.getNumberMeaning(destiny),
    );
  }

  // Helper methods
  static int _calculateEmpathyLevel(NatalChart chart) {
    int level = 50;
    final waterPlanets = chart.planets.where((p) =>
        p.sign.element == Element.water &&
        (p.planet.isPersonalPlanet || p.planet == Planet.moon));
    level += waterPlanets.length * 10;

    if (chart.moon?.sign == ZodiacSign.pisces ||
        chart.moon?.sign == ZodiacSign.cancer) {
      level += 15;
    }

    return level.clamp(0, 100);
  }

  static int _calculateResilienceLevel(NatalChart chart) {
    int level = 50;
    // Fixed signs add resilience
    final fixedPlanets = chart.planets.where((p) =>
        p.sign.modality == Modality.fixed && p.planet.isPersonalPlanet);
    level += fixedPlanets.length * 8;

    // Saturn aspects to personal planets
    final saturnAspects = chart.aspectsForPlanet(Planet.saturn);
    if (saturnAspects.any((a) => a.type == AspectType.trine)) {
      level += 10;
    }

    return level.clamp(0, 100);
  }

  static int _calculateCommitmentReadiness(NatalChart chart) {
    int level = 50;

    // Saturn aspects to Venus
    final venusAspects = chart.aspectsForPlanet(Planet.venus);
    if (venusAspects.any((a) =>
        (a.planet1 == Planet.saturn || a.planet2 == Planet.saturn) &&
        a.type.isHarmonious)) {
      level += 20;
    }

    // Earth signs
    final earthPlanets = chart.planets.where((p) =>
        p.sign.element == Element.earth &&
        (p.planet == Planet.venus || p.planet == Planet.moon));
    level += earthPlanets.length * 10;

    return level.clamp(0, 100);
  }

  static int _calculateControlNeed(NatalChart chart) {
    int level = 50;

    // Scorpio/Pluto placements
    final scorpioPlanets =
        chart.planets.where((p) => p.sign == ZodiacSign.scorpio);
    level += scorpioPlanets.length * 8;

    // Pluto aspects
    final plutoAspects = chart.aspectsForPlanet(Planet.pluto);
    level += plutoAspects.where((a) => a.type.isChallenging).length * 5;

    return level.clamp(0, 100);
  }

  static int _calculateSolitaryNeed(NatalChart chart) {
    int level = 50;

    // 12th house planets
    final twelfthHousePlanets = chart.planetsInHouse(House.twelfth);
    level += twelfthHousePlanets.length * 10;

    // Scorpio/Capricorn Moon
    if (chart.moon?.sign == ZodiacSign.scorpio ||
        chart.moon?.sign == ZodiacSign.capricorn) {
      level += 15;
    }

    return level.clamp(0, 100);
  }

  static String _getLilithMeaning(ZodiacSign sign) {
    switch (sign) {
      case ZodiacSign.aries:
        return 'the hidden fire of wild rage and pure independence. The primal warrior within you wants to exist beyond societal rules. When controlled, this dark fire becomes a revolutionary force; when suppressed, it becomes a destructive volcano';
      case ZodiacSign.taurus:
        return 'the forbidden fruits of the earth goddess - bodily pleasures, possessive passion, and the magic of the material world. This energy within you is an ancient quest seeking the sacred in the material. Honor it and you open the flow of abundance';
      case ZodiacSign.gemini:
        return 'the dark twin - the shadow of unspoken words, manipulative intellect, and dual nature. This energy is the trickster archetype that knows truth has multiple faces. Unbalanced it breeds lies; balanced it births healing stories';
      case ZodiacSign.cancer:
        return 'the dark side of the moon goddess - suffocating love, emotional vampirism, and the shadow of motherhood. This energy within carries the endless need for nurturing and the fear of being unable to provide it. Healing begins with nurturing yourself first';
      case ZodiacSign.leo:
        return 'the shadow of a dethroned monarch - irresistible hunger for attention, creative jealousy, and the forbidden pleasure of shining. This energy is the chaotic manifestation of the divine spark within you. Used consciously it inspires; unconsciously it becomes tyranny';
      case ZodiacSign.virgo:
        return 'the dark side of perfection - criticism as a weapon, war with the body, and the curse of "never being enough." This energy within carries the archetype that seeks sacred order but drowns in its flaws. Healing lies in finding beauty within imperfection';
      case ZodiacSign.libra:
        return 'the self lost beneath the mask of relationships - dependence on people, hunger for approval, and the trap of false harmony. This energy represents the ancient battle between losing yourself in love and finding yourself. Balance must first be established within';
      case ZodiacSign.scorpio:
        return 'the treasure hidden in the darkest depths - obsessive passion, power games, and the urge to destroy. This is the fire that burns even in the soul\'s darkest night. Transformed it becomes alchemical gold; suppressed it becomes a venomous serpent';
      case ZodiacSign.sagittarius:
        return 'the shadow of escape and fanaticism - using truth as a weapon, spiritual bypass, and the fantasy of "somewhere better." This energy within is both the cure and the disease of endless seeking. Balance lies in being able to stay "here and now"';
      case ZodiacSign.capricorn:
        return 'the dark throne of ambition - success obsession, emotional numbness, and the curse of "loneliness at the top." This energy asks the question of the spiritual cost of worldly success. Healing comes from uniting success with love';
      case ZodiacSign.aquarius:
        return 'the shadow of alienation - cold distance, emotional disconnection, and the curse of "being different." This energy within carries both the liberating and isolating aspects of separating from the collective. Balance is freedom within connection';
      case ZodiacSign.pisces:
        return 'the darkest depths of the ocean - the victim archetype, the nightmare of boundlessness, and escape addictions. This energy carries the anguish between divine unity and material separation. Healing means learning to be spiritual while embodied';
    }
  }

  static String _getNorthNodeLesson(ZodiacSign sign) {
    switch (sign) {
      case ZodiacSign.aries:
        return 'Standing on your own feet, courage';
      case ZodiacSign.taurus:
        return 'Inner peace, building material security';
      case ZodiacSign.gemini:
        return 'Communication, curiosity, flexibility';
      case ZodiacSign.cancer:
        return 'Emotional bonding, creating a home';
      case ZodiacSign.leo:
        return 'Creative expression, leadership';
      case ZodiacSign.virgo:
        return 'Practical service, attention to detail';
      case ZodiacSign.libra:
        return 'Partnership, balance, diplomacy';
      case ZodiacSign.scorpio:
        return 'Transformation, depth, sharing';
      case ZodiacSign.sagittarius:
        return 'Search for meaning, expansion';
      case ZodiacSign.capricorn:
        return 'Responsibility, career, authority';
      case ZodiacSign.aquarius:
        return 'Community, innovation, independence';
      case ZodiacSign.pisces:
        return 'Spiritual connection, surrender';
    }
  }

  static String _getSouthNodePattern(ZodiacSign sign) {
    switch (sign) {
      case ZodiacSign.aries:
        return 'Excessive independence and selfishness';
      case ZodiacSign.taurus:
        return 'Material attachment and resistance';
      case ZodiacSign.gemini:
        return 'Superficiality and scattered energy';
      case ZodiacSign.cancer:
        return 'Excessive emotionality and dependence';
      case ZodiacSign.leo:
        return 'Ego and attention addiction';
      case ZodiacSign.virgo:
        return 'Excessive criticism and perfectionism';
      case ZodiacSign.libra:
        return 'Indecision and dependence on others';
      case ZodiacSign.scorpio:
        return 'Need for control and vengefulness';
      case ZodiacSign.sagittarius:
        return 'Escapism and excessive idealism';
      case ZodiacSign.capricorn:
        return 'Workaholism and emotional coldness';
      case ZodiacSign.aquarius:
        return 'Distance and fear of attachment';
      case ZodiacSign.pisces:
        return 'Victim role and lack of boundaries';
    }
  }

  static String _getChironWound(ZodiacSign sign) {
    switch (sign) {
      case ZodiacSign.aries:
        return 'Identity and self-confidence wound';
      case ZodiacSign.taurus:
        return 'Worthlessness and material insecurity';
      case ZodiacSign.gemini:
        return 'Communication and acceptance wound';
      case ZodiacSign.cancer:
        return 'Family and emotional security wound';
      case ZodiacSign.leo:
        return 'Creativity and recognition wound';
      case ZodiacSign.virgo:
        return 'Perfectionism and inadequacy';
      case ZodiacSign.libra:
        return 'Relationship and balance wound';
      case ZodiacSign.scorpio:
        return 'Trust and betrayal wound';
      case ZodiacSign.sagittarius:
        return 'Meaning and faith crisis';
      case ZodiacSign.capricorn:
        return 'Failure and authority wound';
      case ZodiacSign.aquarius:
        return 'Difference and alienation';
      case ZodiacSign.pisces:
        return 'Spiritual disconnection and loss';
    }
  }
}

// Result classes
class ProfileAnalysis {
  final PersonalityProfile personality;
  final EmotionalProfile emotional;
  final LoveProfile love;
  final CareerProfile career;
  final PsychologicalProfile psychological;
  final KarmicProfile karmic;
  final NumerologyProfile? numerology;

  ProfileAnalysis({
    required this.personality,
    required this.emotional,
    required this.love,
    required this.career,
    required this.psychological,
    required this.karmic,
    this.numerology,
  });
}

class PersonalityProfile {
  final ZodiacSign sunSign;
  final ZodiacSign? moonSign;
  final ZodiacSign? risingSign;
  final List<String> coreTraits;
  final String emotionalStyle;
  final String firstImpression;
  final Element dominantElement;
  final Modality dominantModality;
  final int retrogradeCount;

  PersonalityProfile({
    required this.sunSign,
    this.moonSign,
    this.risingSign,
    required this.coreTraits,
    required this.emotionalStyle,
    required this.firstImpression,
    required this.dominantElement,
    required this.dominantModality,
    required this.retrogradeCount,
  });
}

class EmotionalProfile {
  final String attachmentStyle;
  final String securityNeeds;
  final List<String> emotionalTriggers;
  final String stressResponse;
  final int empathyLevel;
  final int emotionalResilience;

  EmotionalProfile({
    required this.attachmentStyle,
    required this.securityNeeds,
    required this.emotionalTriggers,
    required this.stressResponse,
    required this.empathyLevel,
    required this.emotionalResilience,
  });
}

class LoveProfile {
  final ZodiacSign? venusSign;
  final ZodiacSign? marsSign;
  final String loveLanguage;
  final String attractionPattern;
  final String relationshipStyle;
  final int jealousyTendency;
  final int commitmentReadiness;
  final String idealPartnerProfile;

  LoveProfile({
    this.venusSign,
    this.marsSign,
    required this.loveLanguage,
    required this.attractionPattern,
    required this.relationshipStyle,
    required this.jealousyTendency,
    required this.commitmentReadiness,
    required this.idealPartnerProfile,
  });
}

class CareerProfile {
  final List<String> naturalTalents;
  final String careerDirection;
  final bool isLeaderType;
  final int riskTolerance;
  final int entrepreneurPotential;
  final ZodiacSign? saturnSign;
  final ZodiacSign? jupiterSign;

  CareerProfile({
    required this.naturalTalents,
    required this.careerDirection,
    required this.isLeaderType,
    required this.riskTolerance,
    required this.entrepreneurPotential,
    this.saturnSign,
    this.jupiterSign,
  });
}

class PsychologicalProfile {
  final List<String> defenseMechanisms;
  final String shadowSelf;
  final int controlNeed;
  final int solitaryNeed;
  final List<String> relationshipPatterns;

  PsychologicalProfile({
    required this.defenseMechanisms,
    required this.shadowSelf,
    required this.controlNeed,
    required this.solitaryNeed,
    required this.relationshipPatterns,
  });
}

class KarmicProfile {
  final ZodiacSign? northNodeSign;
  final ZodiacSign? southNodeSign;
  final ZodiacSign? chironSign;
  final String lifeLesson;
  final String pastLifePatterns;
  final String deepestWound;
  final List<int> karmicDebtNumbers;

  KarmicProfile({
    this.northNodeSign,
    this.southNodeSign,
    this.chironSign,
    required this.lifeLesson,
    required this.pastLifePatterns,
    required this.deepestWound,
    required this.karmicDebtNumbers,
  });
}

class NumerologyProfile {
  final int lifePathNumber;
  final int destinyNumber;
  final int soulUrgeNumber;
  final int personalityNumber;
  final int birthdayNumber;
  final int personalYearNumber;
  final NumerologyMeaning lifePathMeaning;
  final NumerologyMeaning destinyMeaning;

  NumerologyProfile({
    required this.lifePathNumber,
    required this.destinyNumber,
    required this.soulUrgeNumber,
    required this.personalityNumber,
    required this.birthdayNumber,
    required this.personalYearNumber,
    required this.lifePathMeaning,
    required this.destinyMeaning,
  });
}
