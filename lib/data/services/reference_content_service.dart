import '../models/reference_content.dart';
import '../models/zodiac_sign.dart';
import '../content/glossary_content.dart';

class ReferenceContentService {
  static final ReferenceContentService _instance =
      ReferenceContentService._internal();
  factory ReferenceContentService() => _instance;
  ReferenceContentService._internal();

  /// Get all glossary entries (300+ terms)
  List<GlossaryEntry> getGlossaryEntries() {
    return GlossaryContent.getAllEntries();
  }

  /// Get glossary entries count
  int get glossaryCount => GlossaryContent.totalCount;

  /// Search planet in house interpretations
  List<GlossaryEntry> searchPlanetInHouse(String query) {
    return GlossaryContent.searchPlanetInHouse(query);
  }

  /// Get entries by category
  List<GlossaryEntry> getEntriesByCategory(GlossaryCategory category) {
    return GlossaryContent.getByCategory(category);
  }

  /// Search glossary with improved algorithm
  List<GlossaryEntry> searchGlossary(String query) {
    if (query.trim().isEmpty) return getGlossaryEntries();

    final normalizedQuery = query.toLowerCase().trim();
    final entries = getGlossaryEntries();

    // Priority search: exact match, starts with, contains, related terms
    final exactMatches = <GlossaryEntry>[];
    final startsWithMatches = <GlossaryEntry>[];
    final containsMatches = <GlossaryEntry>[];
    final relatedMatches = <GlossaryEntry>[];

    for (final entry in entries) {
      final termLower = entry.term.toLowerCase();
      final termTrLower = entry.termTr.toLowerCase();
      final definitionLower = entry.definition.toLowerCase();
      final definitionEnLower = entry.definitionEn?.toLowerCase() ?? '';
      final planetInHouse = entry.planetInHouse?.toLowerCase() ?? '';

      // Exact match
      if (termLower == normalizedQuery || termTrLower == normalizedQuery) {
        exactMatches.add(entry);
        continue;
      }

      // Starts with
      if (termLower.startsWith(normalizedQuery) ||
          termTrLower.startsWith(normalizedQuery)) {
        startsWithMatches.add(entry);
        continue;
      }

      // Contains in term, termTr, planetInHouse
      if (termLower.contains(normalizedQuery) ||
          termTrLower.contains(normalizedQuery) ||
          planetInHouse.contains(normalizedQuery)) {
        containsMatches.add(entry);
        continue;
      }

      // Contains in definition (TR or EN) or deep explanation (TR or EN)
      if (definitionLower.contains(normalizedQuery) ||
          definitionEnLower.contains(normalizedQuery) ||
          (entry.deepExplanation?.toLowerCase().contains(normalizedQuery) ??
              false) ||
          (entry.deepExplanationEn?.toLowerCase().contains(normalizedQuery) ??
              false)) {
        relatedMatches.add(entry);
        continue;
      }

      // Related terms match
      if (entry.relatedTerms.any(
        (term) => term.toLowerCase().contains(normalizedQuery),
      )) {
        relatedMatches.add(entry);
      }
    }

    // Combine results in priority order
    return [
      ...exactMatches,
      ...startsWithMatches,
      ...containsMatches,
      ...relatedMatches,
    ];
  }

  /// Get gardening moon calendar for a month
  List<GardeningMoonDay> getGardeningCalendar(int year, int month) {
    final days = <GardeningMoonDay>[];
    final daysInMonth = DateTime(year, month + 1, 0).day;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      days.add(_generateGardeningDay(date));
    }

    return days;
  }

  GardeningMoonDay _generateGardeningDay(DateTime date) {
    // Calculate approximate moon phase
    final phase = _getMoonPhase(date);
    final moonSign = ZodiacSign.values[(date.day + date.month) % 12];

    // Determine activities based on moon phase and sign
    final bestActivity = _getBestActivity(phase, moonSign);
    final goodActivities = _getGoodActivities(phase, moonSign);
    final avoidActivities = _getAvoidActivities(phase, moonSign);

    return GardeningMoonDay(
      date: date,
      phase: phase,
      moonSign: moonSign,
      bestActivity: bestActivity,
      goodActivities: goodActivities,
      avoidActivities: avoidActivities,
      advice: _getGardeningAdvice(phase, moonSign),
      fertilityRating: _getFertilityRating(moonSign, phase),
    );
  }

  MoonPhase _getMoonPhase(DateTime date) {
    // Simplified moon phase calculation
    final dayOfMonth = date.day;
    if (dayOfMonth <= 3) return MoonPhase.newMoon;
    if (dayOfMonth <= 7) return MoonPhase.waxingCrescent;
    if (dayOfMonth <= 10) return MoonPhase.firstQuarter;
    if (dayOfMonth <= 14) return MoonPhase.waxingGibbous;
    if (dayOfMonth <= 17) return MoonPhase.fullMoon;
    if (dayOfMonth <= 21) return MoonPhase.waningGibbous;
    if (dayOfMonth <= 25) return MoonPhase.lastQuarter;
    return MoonPhase.waningCrescent;
  }

  GardeningActivity _getBestActivity(MoonPhase phase, ZodiacSign sign) {
    if (phase.isWaxing) {
      if (sign.element == Element.water || sign.element == Element.earth) {
        return GardeningActivity.planting;
      }
      return GardeningActivity.seedStarting;
    } else {
      if (sign.element == Element.fire || sign.element == Element.air) {
        return GardeningActivity.pruning;
      }
      return GardeningActivity.harvesting;
    }
  }

  List<GardeningActivity> _getGoodActivities(MoonPhase phase, ZodiacSign sign) {
    final activities = <GardeningActivity>[];

    if (phase.isWaxing) {
      activities.add(GardeningActivity.transplanting);
      activities.add(GardeningActivity.fertilizing);
      activities.add(GardeningActivity.watering);
    } else {
      activities.add(GardeningActivity.weeding);
      activities.add(GardeningActivity.composting);
    }

    if (sign.element == Element.water) {
      activities.add(GardeningActivity.watering);
    }
    if (sign.element == Element.earth) {
      activities.add(GardeningActivity.transplanting);
    }

    return activities.toSet().toList();
  }

  List<GardeningActivity> _getAvoidActivities(
    MoonPhase phase,
    ZodiacSign sign,
  ) {
    final activities = <GardeningActivity>[];

    if (phase == MoonPhase.newMoon || phase == MoonPhase.fullMoon) {
      activities.add(GardeningActivity.planting);
      activities.add(GardeningActivity.transplanting);
    }

    if (sign.element == Element.fire) {
      activities.add(GardeningActivity.watering);
    }

    if (!phase.isWaxing) {
      activities.add(GardeningActivity.seedStarting);
    }

    return activities;
  }

  String _getGardeningAdvice(MoonPhase phase, ZodiacSign sign) {
    if (phase == MoonPhase.newMoon) {
      return 'New Moon period. Ideal for garden planning and seed preparation. '
          'Wait a few days before planting.';
    }
    if (phase == MoonPhase.fullMoon) {
      return 'Full Moon period. Perfect time for harvesting. '
          'Avoid planting, water your plants instead.';
    }
    if (phase.isWaxing) {
      return 'Waxing Moon. The Moon in ${sign.element.name} element is favorable for '
          'above-ground plants. Planting and fertilizing can be done.';
    }
    return 'Waning Moon. The Moon in ${sign.element.name} element is favorable for '
        'root vegetables and pruning. Weeding can be done.';
  }

  int _getFertilityRating(ZodiacSign sign, MoonPhase phase) {
    int rating = 3;

    // Water and Earth signs are most fertile
    if (sign.element == Element.water) rating += 2;
    if (sign.element == Element.earth) rating += 1;
    if (sign.element == Element.fire) rating -= 1;

    // Waxing moon is better for growth
    if (phase.isWaxing) rating += 1;

    return rating.clamp(1, 5);
  }

  /// Get celebrity charts
  List<CelebrityChart> getCelebrityCharts() {
    return [
      // Scientists
      CelebrityChart(
        name: 'Albert Einstein',
        profession: 'Physicist',
        birthDate: DateTime(1879, 3, 14),
        birthPlace: 'Ulm, Germany',
        sunSign: ZodiacSign.pisces,
        moonSign: ZodiacSign.sagittarius,
        ascendant: ZodiacSign.cancer,
        imageUrl: '',
        chartAnalysis:
            'Einstein\'s Pisces Sun shows his intuitive and imaginative nature. '
            'Sagittarius Moon gives inclination toward philosophical thinking and seeing the big picture. '
            'Cancer Ascendant emphasizes the need to work in a secure environment and emotional intelligence. '
            'The strong position of Uranus shows revolutionary ideas and unconventional thinking.',
        notableAspects: [
          'Sun-Mercury conjunction - Brilliant mind',
          'Uranus in 3rd house - Innovative thinking',
          'Jupiter-Saturn trine - Patient expansion',
        ],
        category: CelebrityCategory.scientists,
      ),
      CelebrityChart(
        name: 'Marie Curie',
        profession: 'Physicist, Chemist',
        birthDate: DateTime(1867, 11, 7),
        birthPlace: 'Warsaw, Poland',
        sunSign: ZodiacSign.scorpio,
        moonSign: ZodiacSign.pisces,
        ascendant: ZodiacSign.virgo,
        imageUrl: '',
        chartAnalysis:
            'Curie\'s Scorpio Sun shows the investigative spirit and passion for going deep. '
            'Pisces Moon emphasizes intuitive understanding and capacity for sacrifice. '
            'Virgo Ascendant indicates scientific meticulousness and analytical approach. '
            'The strong position of Pluto is symbolically connected to the discovery of radioactivity.',
        notableAspects: [
          'Sun-Pluto aspect - Transformative discoveries',
          'Mercury in 8th house - Researching the hidden',
          'Saturn in 10th house - Lasting success',
        ],
        category: CelebrityCategory.scientists,
      ),
      CelebrityChart(
        name: 'Nikola Tesla',
        profession: 'Inventor, Engineer',
        birthDate: DateTime(1856, 7, 10),
        birthPlace: 'Smiljan, Croatia',
        sunSign: ZodiacSign.cancer,
        moonSign: ZodiacSign.libra,
        ascendant: ZodiacSign.aquarius,
        imageUrl: '',
        chartAnalysis:
            'Tesla\'s Cancer Sun shows deep intuition and protective vision. '
            'Libra Moon emphasizes the pursuit of harmony and aesthetic engineering. '
            'Aquarius Ascendant indicates revolutionary inventions and ability to see the future. '
            'The strong position of Uranus symbolizes genius in the field of electricity and energy.',
        notableAspects: [
          'Uranus-Mercury trine - Revolutionary ideas',
          'Neptune in 11th house - Future vision',
          'Saturn in 1st house - Disciplined genius',
        ],
        category: CelebrityCategory.scientists,
      ),
      CelebrityChart(
        name: 'Stephen Hawking',
        profession: 'Theoretical Physicist',
        birthDate: DateTime(1942, 1, 8),
        birthPlace: 'Oxford, England',
        sunSign: ZodiacSign.capricorn,
        moonSign: ZodiacSign.aries,
        ascendant: ZodiacSign.virgo,
        imageUrl: '',
        chartAnalysis:
            'Hawking\'s Capricorn Sun shows perseverance and desire for lasting success. '
            'Aries Moon emphasizes courage and fighting spirit. '
            'Virgo Ascendant indicates analytical intelligence and attention to detail. '
            'Saturn\'s position in the 6th house shows work discipline despite health challenges.',
        notableAspects: [
          'Sun-Saturn conjunction - Success despite obstacles',
          'Mars in 9th house - Philosophical warrior',
          'Jupiter in 8th house - Exploring the universe\'s secrets',
        ],
        category: CelebrityCategory.scientists,
      ),

      // Historical Figures
      CelebrityChart(
        name: 'Atatürk',
        profession: 'Statesman',
        birthDate: DateTime(1881, 5, 19),
        birthPlace: 'Thessaloniki',
        sunSign: ZodiacSign.taurus,
        moonSign: ZodiacSign.leo,
        ascendant: ZodiacSign.scorpio,
        imageUrl: '',
        chartAnalysis:
            'Atatürk\'s Taurus Sun shows determination and practical leadership. '
            'Leo Moon emphasizes strong will and instinct to protect his people. '
            'Scorpio Ascendant indicates transformative power and strategic intelligence. '
            'Mars-Pluto aspect shows unstoppable determination and capacity for reform.',
        notableAspects: [
          'Sun in 10th house - Social leadership',
          'Mars-Pluto conjunction - Transformative power',
          'Jupiter in 9th house - Vision and idealism',
        ],
        category: CelebrityCategory.historical,
      ),
      CelebrityChart(
        name: 'Fatih Sultan Mehmet',
        profession: 'Ottoman Sultan',
        birthDate: DateTime(1432, 3, 30),
        birthPlace: 'Edirne',
        sunSign: ZodiacSign.aries,
        moonSign: ZodiacSign.capricorn,
        ascendant: ZodiacSign.leo,
        imageUrl: '',
        chartAnalysis:
            'Fatih\'s Aries Sun shows the spirit of conquest and pioneering courage. '
            'Capricorn Moon emphasizes strategic planning and long-term goals. '
            'Leo Ascendant indicates imperial vision and leadership charisma. '
            'The strong position of Mars symbolizes military genius and bold actions.',
        notableAspects: [
          'Mars in 10th house - Military leadership',
          'Jupiter-Saturn trine - Empire building',
          'Sun-Mars conjunction - Warrior spirit',
        ],
        category: CelebrityCategory.historical,
      ),
      CelebrityChart(
        name: 'Mevlana Celaleddin Rumi',
        profession: 'Sufi Poet, Mystic',
        birthDate: DateTime(1207, 9, 30),
        birthPlace: 'Balkh, Afghanistan',
        sunSign: ZodiacSign.libra,
        moonSign: ZodiacSign.pisces,
        ascendant: ZodiacSign.cancer,
        imageUrl: '',
        chartAnalysis:
            'Rumi\'s Libra Sun shows pursuit of harmony and deep understanding in relationships. '
            'Pisces Moon emphasizes mystical intuition and universal love. '
            'Cancer Ascendant indicates deep emotional bonds and compassion. '
            'The strong position of Neptune symbolizes spiritual awakening and divine love.',
        notableAspects: [
          'Neptune in 12th house - Mystical experience',
          'Venus-Moon trine - Poetic love',
          'Jupiter in 9th house - Spiritual teaching',
        ],
        category: CelebrityCategory.historical,
      ),
      CelebrityChart(
        name: 'Cleopatra',
        profession: 'Queen of Egypt',
        birthDate: DateTime(-69, 1, 15),
        birthPlace: 'Alexandria, Egypt',
        sunSign: ZodiacSign.capricorn,
        moonSign: ZodiacSign.scorpio,
        ascendant: ZodiacSign.leo,
        imageUrl: '',
        chartAnalysis:
            'Cleopatra\'s Capricorn Sun shows political intelligence and ambition. '
            'Scorpio Moon emphasizes deep passion and ability to manipulate. '
            'Leo Ascendant indicates royal charisma and dramatic appeal. '
            'The strong position of Venus symbolizes legendary beauty and allure.',
        notableAspects: [
          'Venus in 1st house - Enchanting beauty',
          'Pluto in 7th house - Powerful relationships',
          'Mars-Saturn trine - Strategic warrior',
        ],
        category: CelebrityCategory.historical,
      ),

      // Artists
      CelebrityChart(
        name: 'Leonardo da Vinci',
        profession: 'Artist, Inventor',
        birthDate: DateTime(1452, 4, 15),
        birthPlace: 'Vinci, Italy',
        sunSign: ZodiacSign.aries,
        moonSign: ZodiacSign.pisces,
        ascendant: ZodiacSign.sagittarius,
        imageUrl: '',
        chartAnalysis:
            'Da Vinci\'s Aries Sun shows his pioneering and courageous nature. '
            'Pisces Moon represents deep artistic intuition and imagination. '
            'Sagittarius Ascendant indicates versatility and passion for continuous learning. '
            'Mercury-Venus conjunction shows the combination of aesthetic intelligence and manual skill.',
        notableAspects: [
          'Mercury-Venus conjunction - Artistic intelligence',
          'Mars in 5th house - Creative energy',
          'Neptune strong - Spiritual inspiration',
        ],
        category: CelebrityCategory.artists,
      ),
      CelebrityChart(
        name: 'Vincent van Gogh',
        profession: 'Painter',
        birthDate: DateTime(1853, 3, 30),
        birthPlace: 'Zundert, Netherlands',
        sunSign: ZodiacSign.aries,
        moonSign: ZodiacSign.sagittarius,
        ascendant: ZodiacSign.cancer,
        imageUrl: '',
        chartAnalysis:
            'Van Gogh\'s Aries Sun shows passionate and bold artistic expression. '
            'Sagittarius Moon emphasizes idealism and search for meaning. '
            'Cancer Ascendant indicates emotional sensitivity and inner world. '
            'The strong position of Neptune symbolizes visionary art and spiritual turmoil.',
        notableAspects: [
          'Sun-Uranus conjunction - Radical creativity',
          'Moon-Neptune square - Emotional intensity',
          'Venus in 12th house - Hidden perception of beauty',
        ],
        category: CelebrityCategory.artists,
      ),
      CelebrityChart(
        name: 'Frida Kahlo',
        profession: 'Painter',
        birthDate: DateTime(1907, 7, 6),
        birthPlace: 'Coyoacan, Mexico',
        sunSign: ZodiacSign.cancer,
        moonSign: ZodiacSign.taurus,
        ascendant: ZodiacSign.leo,
        imageUrl: '',
        chartAnalysis:
            'Frida\'s Cancer Sun shows deep emotionality and self-protective instinct. '
            'Taurus Moon emphasizes sensual pleasures and resilience. '
            'Leo Ascendant indicates dramatic self-expression and bold image. '
            'The strong position of Chiron symbolizes art through pain.',
        notableAspects: [
          'Chiron in 1st house - Wounded artist',
          'Venus-Pluto square - Passionate love',
          'Mars in 8th house - Dance with death',
        ],
        category: CelebrityCategory.artists,
      ),
      CelebrityChart(
        name: 'Pablo Picasso',
        profession: 'Painter, Sculptor',
        birthDate: DateTime(1881, 10, 25),
        birthPlace: 'Malaga, Spain',
        sunSign: ZodiacSign.scorpio,
        moonSign: ZodiacSign.sagittarius,
        ascendant: ZodiacSign.leo,
        imageUrl: '',
        chartAnalysis:
            'Picasso\'s Scorpio Sun shows intense creativity and transformation. '
            'Sagittarius Moon emphasizes free thinking and experimentation. '
            'Leo Ascendant indicates artistic ego and desire for attention. '
            'The strong position of Uranus symbolizes revolutionizing art.',
        notableAspects: [
          'Sun-Mercury conjunction - Sharp intellect',
          'Uranus in 3rd house - Innovative expression',
          'Venus-Mars square - Passionate relationships',
        ],
        category: CelebrityCategory.artists,
      ),

      // Musicians
      CelebrityChart(
        name: 'Freddie Mercury',
        profession: 'Musician',
        birthDate: DateTime(1946, 9, 5),
        birthPlace: 'Zanzibar',
        sunSign: ZodiacSign.virgo,
        moonSign: ZodiacSign.sagittarius,
        ascendant: ZodiacSign.leo,
        imageUrl: '',
        chartAnalysis:
            'Mercury\'s Virgo Sun shows perfectionism and musical attention to detail. '
            'Sagittarius Moon emphasizes stage performance enthusiasm and passion for freedom. '
            'Leo Ascendant indicates charismatic stage presence and dramatic expression. '
            'Venus-Mars conjunction represents passionate artistic expression.',
        notableAspects: [
          'Leo Ascendant - Stage charisma',
          'Venus-Mars conjunction - Passionate performance',
          'Neptune in 5th house - Musical inspiration',
        ],
        category: CelebrityCategory.musicians,
      ),
      CelebrityChart(
        name: 'Baris Manco',
        profession: 'Musician, Singer',
        birthDate: DateTime(1943, 1, 2),
        birthPlace: 'Istanbul',
        sunSign: ZodiacSign.capricorn,
        moonSign: ZodiacSign.aries,
        ascendant: ZodiacSign.gemini,
        imageUrl: '',
        chartAnalysis:
            'Baris Manco\'s Capricorn Sun shows disciplined musicality and desire for lasting legacy. '
            'Aries Moon emphasizes bold stage performance and pioneering spirit. '
            'Gemini Ascendant indicates communication skills and connection with children. '
            'The strong position of Jupiter symbolizes cultural ambassadorship.',
        notableAspects: [
          'Mercury in 3rd house - Master communicator',
          'Venus-Neptune trine - Musical intuition',
          'Jupiter in 9th house - Cultural bridge',
        ],
        category: CelebrityCategory.musicians,
      ),
      CelebrityChart(
        name: 'Wolfgang Amadeus Mozart',
        profession: 'Composer',
        birthDate: DateTime(1756, 1, 27),
        birthPlace: 'Salzburg, Austria',
        sunSign: ZodiacSign.aquarius,
        moonSign: ZodiacSign.sagittarius,
        ascendant: ZodiacSign.virgo,
        imageUrl: '',
        chartAnalysis:
            'Mozart\'s Aquarius Sun shows genius originality and being ahead of his time. '
            'Sagittarius Moon emphasizes joyful creativity and musical adventurousness. '
            'Virgo Ascendant indicates perfectionist technique and meticulousness. '
            'The strong position of Uranus symbolizes early emerging genius.',
        notableAspects: [
          'Mercury-Venus conjunction - Melodic genius',
          'Sun-Saturn trine - Disciplined creativity',
          'Neptune in 5th house - Divine music',
        ],
        category: CelebrityCategory.musicians,
      ),
      CelebrityChart(
        name: 'Ludwig van Beethoven',
        profession: 'Composer',
        birthDate: DateTime(1770, 12, 16),
        birthPlace: 'Bonn, Germany',
        sunSign: ZodiacSign.sagittarius,
        moonSign: ZodiacSign.sagittarius,
        ascendant: ZodiacSign.scorpio,
        imageUrl: '',
        chartAnalysis:
            'Beethoven\'s Sagittarius Sun shows love of freedom and idealism. '
            'Sagittarius Moon emphasizes passionate expression and philosophical depth. '
            'Scorpio Ascendant indicates intense emotionality and transformation. '
            'The strong position of Saturn symbolizes continued struggle despite deafness.',
        notableAspects: [
          'Sun-Moon conjunction - Strong will',
          'Mars in 1st house - Warrior spirit',
          'Pluto in 8th house - Transformation in music',
        ],
        category: CelebrityCategory.musicians,
      ),
      CelebrityChart(
        name: 'Tarkan',
        profession: 'Pop Singer',
        birthDate: DateTime(1972, 10, 17),
        birthPlace: 'Alzey, Germany',
        sunSign: ZodiacSign.libra,
        moonSign: ZodiacSign.taurus,
        ascendant: ZodiacSign.leo,
        imageUrl: '',
        chartAnalysis:
            'Tarkan\'s Libra Sun shows aesthetic perfectionism and allure. '
            'Taurus Moon emphasizes sensual musicality and vocal quality. '
            'Leo Ascendant indicates stage dominance and star charisma. '
            'The strong position of Venus symbolizes romantic songs and dance talent.',
        notableAspects: [
          'Venus in 1st house - Natural charm',
          'Mars-Neptune trine - Hypnotic performance',
          'Jupiter in 5th house - Creative success',
        ],
        category: CelebrityCategory.musicians,
      ),

      // Actors
      CelebrityChart(
        name: 'Marilyn Monroe',
        profession: 'Actress',
        birthDate: DateTime(1926, 6, 1),
        birthPlace: 'Los Angeles, USA',
        sunSign: ZodiacSign.gemini,
        moonSign: ZodiacSign.aquarius,
        ascendant: ZodiacSign.leo,
        imageUrl: '',
        chartAnalysis:
            'Monroe\'s Gemini Sun shows versatility and dual nature. '
            'Aquarius Moon emphasizes desire to be different and emotional independence. '
            'Leo Ascendant indicates radiant appeal and dramatic presence. '
            'The strong position of Neptune symbolizes fantasy image and escapist tendencies.',
        notableAspects: [
          'Venus-Neptune conjunction - Enchanting allure',
          'Moon in 7th house - Complexity in relationships',
          'Pluto in 12th house - Hidden depths',
        ],
        category: CelebrityCategory.actors,
      ),
      CelebrityChart(
        name: 'Turkan Soray',
        profession: 'Actress',
        birthDate: DateTime(1945, 6, 28),
        birthPlace: 'Istanbul',
        sunSign: ZodiacSign.cancer,
        moonSign: ZodiacSign.scorpio,
        ascendant: ZodiacSign.libra,
        imageUrl: '',
        chartAnalysis:
            'Turkan Soray\'s Cancer Sun shows deep emotionality and the mother figure. '
            'Scorpio Moon emphasizes intense roles and transformative performances. '
            'Libra Ascendant indicates elegant beauty and diplomatic personality. '
            'The strong position of Venus symbolizes her title as the Sultan of Turkish Cinema.',
        notableAspects: [
          'Sun-Venus conjunction - Natural star',
          'Moon-Pluto conjunction - Deep roles',
          'Jupiter in 10th house - Career success',
        ],
        category: CelebrityCategory.actors,
      ),
      CelebrityChart(
        name: 'Leonardo DiCaprio',
        profession: 'Actor',
        birthDate: DateTime(1974, 11, 11),
        birthPlace: 'Los Angeles, USA',
        sunSign: ZodiacSign.scorpio,
        moonSign: ZodiacSign.libra,
        ascendant: ZodiacSign.libra,
        imageUrl: '',
        chartAnalysis:
            'DiCaprio\'s Scorpio Sun shows intense performances and transformation. '
            'Libra Moon emphasizes aesthetic sensitivity and collaboration skills. '
            'Libra Ascendant indicates attractive appearance and diplomatic personality. '
            'The strong position of Pluto symbolizes heavy roles and activism.',
        notableAspects: [
          'Sun-Pluto trine - Transformative talent',
          'Mars in 11th house - Social activism',
          'Neptune in 5th house - Cinematic inspiration',
        ],
        category: CelebrityCategory.actors,
      ),
      CelebrityChart(
        name: 'Kemal Sunal',
        profession: 'Comedian, Actor',
        birthDate: DateTime(1944, 11, 11),
        birthPlace: 'Istanbul',
        sunSign: ZodiacSign.scorpio,
        moonSign: ZodiacSign.gemini,
        ascendant: ZodiacSign.virgo,
        imageUrl: '',
        chartAnalysis:
            'Kemal Sunal\'s Scorpio Sun shows going deep into characters. '
            'Gemini Moon emphasizes comedic timing and verbal wit. '
            'Virgo Ascendant indicates humble personality and meticulous work. '
            'The strong position of Mercury symbolizes his image as a man of the people.',
        notableAspects: [
          'Mercury-Jupiter trine - Comic genius',
          'Saturn in 10th house - Lasting legacy',
          'Neptune in 1st house - Character immersion',
        ],
        category: CelebrityCategory.actors,
      ),

      // Athletes
      CelebrityChart(
        name: 'Cristiano Ronaldo',
        profession: 'Footballer',
        birthDate: DateTime(1985, 2, 5),
        birthPlace: 'Madeira, Portugal',
        sunSign: ZodiacSign.aquarius,
        moonSign: ZodiacSign.leo,
        ascendant: ZodiacSign.virgo,
        imageUrl: '',
        chartAnalysis:
            'Ronaldo\'s Aquarius Sun shows individuality and unique talents. '
            'Leo Moon emphasizes pride and need for recognition. '
            'Virgo Ascendant indicates disciplined work and perfectionism. '
            'The strong position of Mars symbolizes physical superiority and competitiveness.',
        notableAspects: [
          'Mars-Jupiter conjunction - Athletic luck',
          'Sun-Saturn square - Overcoming obstacles',
          'Venus in 5th house - Fame and wealth',
        ],
        category: CelebrityCategory.athletes,
      ),
      CelebrityChart(
        name: 'Naim Suleymanoglu',
        profession: 'Weightlifter',
        birthDate: DateTime(1967, 1, 23),
        birthPlace: 'Pticar, Bulgaria',
        sunSign: ZodiacSign.aquarius,
        moonSign: ZodiacSign.aries,
        ascendant: ZodiacSign.scorpio,
        imageUrl: '',
        chartAnalysis:
            'Naim\'s Aquarius Sun shows unique physical strength and love of freedom. '
            'Aries Moon emphasizes competitive spirit and courageous struggle. '
            'Scorpio Ascendant indicates intense determination and transformation. '
            'The strong position of Pluto symbolizes his nickname "Pocket Hercules".',
        notableAspects: [
          'Mars in 1st house - Physical power',
          'Saturn-Pluto conjunction - Unstoppable will',
          'Jupiter in 10th house - World championship',
        ],
        category: CelebrityCategory.athletes,
      ),

      // Writers
      CelebrityChart(
        name: 'William Shakespeare',
        profession: 'Writer, Poet',
        birthDate: DateTime(1564, 4, 23),
        birthPlace: 'Stratford-upon-Avon, England',
        sunSign: ZodiacSign.taurus,
        moonSign: ZodiacSign.virgo,
        ascendant: ZodiacSign.gemini,
        imageUrl: '',
        chartAnalysis:
            'Shakespeare\'s Taurus Sun shows sensual language and enduring art. '
            'Virgo Moon emphasizes meticulous writing and psychological analysis. '
            'Gemini Ascendant indicates mastery of language and versatility. '
            'The strong position of Mercury symbolizes literary genius.',
        notableAspects: [
          'Mercury-Venus conjunction - Poetic language',
          'Neptune in 3rd house - Literary inspiration',
          'Pluto in 5th house - Depth in tragedies',
        ],
        category: CelebrityCategory.writers,
      ),
      CelebrityChart(
        name: 'Orhan Pamuk',
        profession: 'Writer',
        birthDate: DateTime(1952, 6, 7),
        birthPlace: 'Istanbul',
        sunSign: ZodiacSign.gemini,
        moonSign: ZodiacSign.pisces,
        ascendant: ZodiacSign.libra,
        imageUrl: '',
        chartAnalysis:
            'Pamuk\'s Gemini Sun shows narrative talent and intellectual curiosity. '
            'Pisces Moon emphasizes nostalgic sensitivity and imagination. '
            'Libra Ascendant indicates aesthetic sensitivity and balanced perspective. '
            'The strong position of Neptune symbolizes Istanbul romanticism.',
        notableAspects: [
          'Mercury in 3rd house - Writing genius',
          'Neptune-Moon conjunction - Dreamlike narrative',
          'Saturn in 10th house - Nobel Prize',
        ],
        category: CelebrityCategory.writers,
      ),
      CelebrityChart(
        name: 'Nazim Hikmet',
        profession: 'Poet',
        birthDate: DateTime(1902, 1, 15),
        birthPlace: 'Thessaloniki',
        sunSign: ZodiacSign.capricorn,
        moonSign: ZodiacSign.aquarius,
        ascendant: ZodiacSign.sagittarius,
        imageUrl: '',
        chartAnalysis:
            'Nazim\'s Capricorn Sun shows determination and sense of social responsibility. '
            'Aquarius Moon emphasizes humanitarian ideals and love of freedom. '
            'Sagittarius Ascendant indicates universal vision and life in exile. '
            'The strong position of Uranus symbolizes revolutionary poetry.',
        notableAspects: [
          'Sun-Uranus square - Rebellious spirit',
          'Moon in 3rd house - Poet of the people',
          'Mars in 9th house - Struggle in exile',
        ],
        category: CelebrityCategory.writers,
      ),
    ];
  }

  /// Get articles
  List<AstrologyArticle> getArticles() {
    return [
      AstrologyArticle(
        id: '1',
        title: 'Introduction to Astrology: Basic Concepts',
        summary:
            'Take your first step into the world of astrology. Basic information about zodiac signs, planets, and houses.',
        content: '''
Astrology is an ancient science based on the belief that the positions of celestial bodies in the sky influence events on Earth and human behavior.

## Zodiac Signs

The zodiac belt is divided into 12 equal parts, each representing a sign:

1. **Aries (March 21 - April 19)**: Courage, energy, leadership
2. **Taurus (April 20 - May 20)**: Stability, security, comfort
3. **Gemini (May 21 - June 20)**: Communication, curiosity, versatility
4. **Cancer (June 21 - July 22)**: Emotionality, protection, intuition
5. **Leo (July 23 - August 22)**: Creativity, leadership, generosity
6. **Virgo (August 23 - September 22)**: Analysis, service, perfectionism
7. **Libra (September 23 - October 22)**: Balance, harmony, relationships
8. **Scorpio (October 23 - November 21)**: Intensity, transformation, passion
9. **Sagittarius (November 22 - December 21)**: Adventure, philosophy, freedom
10. **Capricorn (December 22 - January 19)**: Ambition, discipline, responsibility
11. **Aquarius (January 20 - February 18)**: Innovation, humanitarianism, independence
12. **Pisces (February 19 - March 20)**: Intuition, compassion, spirituality

## Planets

Each planet represents a different area of life:

- **Sun**: Self, identity
- **Moon**: Emotions, instincts
- **Mercury**: Communication, thought
- **Venus**: Love, beauty
- **Mars**: Action, energy
- **Jupiter**: Growth, luck
- **Saturn**: Structure, discipline
- **Uranus**: Change, originality
- **Neptune**: Dreams, spirituality
- **Pluto**: Transformation, power

## Houses

The birth chart is divided into 12 houses, each representing a different area of life:

1st House - Self and appearance
2nd House - Money and values
3rd House - Communication and immediate environment
4th House - Home and family
5th House - Creativity and romance
6th House - Health and daily routines
7th House - Partnerships and marriage
8th House - Transformation and shared resources
9th House - Philosophy and foreign cultures
10th House - Career and social status
11th House - Friendships and ideals
12th House - Subconscious and spirituality
        ''',
        category: ArticleCategory.beginners,
        publishedAt: DateTime.now().subtract(const Duration(days: 30)),
        author: 'Venus One Team',
        readTimeMinutes: 8,
        tags: ['beginners', 'zodiac signs', 'planets', 'houses'],
      ),
      AstrologyArticle(
        id: '2',
        title: 'Astrology in Relationships: A Synastry Guide',
        summary:
            'How can you evaluate your compatibility with your partner from an astrological perspective?',
        content: '''
Synastry is the art of understanding relationship dynamics by comparing two people's birth charts.

## Important Aspects

Planetary connections between two charts determine the nature of the relationship:

### Conjunctions (0°)
When two planets come together, a strong bond is formed. Sun-Moon conjunction indicates a deep emotional connection.

### Trines (120°)
Natural harmony and flow. Venus-Mars trine facilitates romantic attraction.

### Squares (90°)
Challenge but growth potential. Sun-Saturn square requires maturation in the relationship.

## Most Important Connections

1. **Sun-Moon**: Basic compatibility indicator
2. **Venus-Mars**: Romantic and sexual attraction
3. **Mercury-Mercury**: Communication harmony
4. **Moon-Venus**: Emotional bond and affection
5. **Jupiter connections**: Growing together

## 7th House Analysis

Both partners' 7th house shows relationship expectations. The position and aspects of the 7th house ruler are important.
        ''',
        category: ArticleCategory.relationships,
        publishedAt: DateTime.now().subtract(const Duration(days: 15)),
        author: 'Venus One Team',
        readTimeMinutes: 6,
        tags: ['synastry', 'relationships', 'compatibility'],
      ),
      AstrologyArticle(
        id: '3',
        title: 'Mercury Retrograde: Nothing to Fear',
        summary:
            'The true meaning of Mercury retrograde and how to make this period productive.',
        content: '''
Mercury retrograde is one of the most talked about and feared periods in astrology. However, with the right understanding, this period can turn into an opportunity.

## What is Mercury Retrograde?

It's when Mercury appears to move backward when viewed from Earth. It happens about three times a year, each lasting 3 weeks.

## What to Expect?

- Communication disruptions
- Technology issues
- Travel delays
- Issues from the past resurfacing

## What to Do?

### Things to Do:
- Back up your data
- Pay attention to details
- Complete old projects
- Reconnect with old friends
- Reflect and plan

### Things to Avoid:
- Signing major contracts
- Buying new technology
- Making important decisions
- Starting new projects

## Shadow Periods

The 2-week shadow periods before and after the retrograde also require attention.
        ''',
        category: ArticleCategory.currentTransits,
        publishedAt: DateTime.now().subtract(const Duration(days: 5)),
        author: 'Venus One Team',
        readTimeMinutes: 5,
        tags: ['mercury', 'retrograde', 'transit'],
      ),
    ];
  }
}
