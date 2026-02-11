/// Numerology calculations service
class NumerologyService {
  /// Calculate Life Path Number from birth date
  static int calculateLifePathNumber(DateTime birthDate) {
    final day = _reduceToSingleDigit(birthDate.day);
    final month = _reduceToSingleDigit(birthDate.month);
    final year = _reduceToSingleDigit(birthDate.year);

    final sum = day + month + year;
    return _reduceToSingleDigitOrMaster(sum);
  }

  /// Calculate Destiny/Expression Number from full name
  static int calculateDestinyNumber(String fullName) {
    final name = fullName.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
    var sum = 0;

    for (final char in name.split('')) {
      sum += _letterToNumber(char);
    }

    return _reduceToSingleDigitOrMaster(sum);
  }

  /// Calculate Soul Urge/Heart's Desire Number (vowels only)
  static int calculateSoulUrgeNumber(String fullName) {
    final name = fullName.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
    const vowels = 'AEIOU';
    var sum = 0;

    for (final char in name.split('')) {
      if (vowels.contains(char)) {
        sum += _letterToNumber(char);
      }
    }

    return _reduceToSingleDigitOrMaster(sum);
  }

  /// Calculate Personality Number (consonants only)
  static int calculatePersonalityNumber(String fullName) {
    final name = fullName.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
    const vowels = 'AEIOU';
    var sum = 0;

    for (final char in name.split('')) {
      if (!vowels.contains(char)) {
        sum += _letterToNumber(char);
      }
    }

    return _reduceToSingleDigitOrMaster(sum);
  }

  /// Calculate Birthday Number (just the day)
  static int calculateBirthdayNumber(DateTime birthDate) {
    return _reduceToSingleDigitOrMaster(birthDate.day);
  }

  /// Calculate Personal Year Number
  static int calculatePersonalYearNumber(DateTime birthDate, int currentYear) {
    final day = _reduceToSingleDigit(birthDate.day);
    final month = _reduceToSingleDigit(birthDate.month);
    final year = _reduceToSingleDigit(currentYear);

    return _reduceToSingleDigitOrMaster(day + month + year);
  }

  /// Calculate Personal Month Number
  static int calculatePersonalMonthNumber(
    DateTime birthDate,
    int currentYear,
    int currentMonth,
  ) {
    final personalYear = calculatePersonalYearNumber(birthDate, currentYear);
    return _reduceToSingleDigitOrMaster(personalYear + currentMonth);
  }

  /// Calculate Karmic Debt Numbers (13, 14, 16, 19)
  static List<int> findKarmicDebtNumbers(DateTime birthDate) {
    final karmicNumbers = <int>[];

    // Check in life path calculation
    final day = birthDate.day;
    final year = birthDate.year;

    if (day == 13 || day == 14 || day == 16 || day == 19) {
      karmicNumbers.add(day);
    }

    final yearSum = _digitSum(year);
    if (yearSum == 13 || yearSum == 14 || yearSum == 16 || yearSum == 19) {
      karmicNumbers.add(yearSum);
    }

    return karmicNumbers;
  }

  /// Calculate Compatibility Score between two people
  static NumerologyCompatibility calculateCompatibility(
    DateTime date1,
    DateTime date2, {
    String? name1,
    String? name2,
  }) {
    final lifeP1 = calculateLifePathNumber(date1);
    final lifeP2 = calculateLifePathNumber(date2);

    // Life Path compatibility
    final lifePathScore = _getLifePathCompatibility(lifeP1, lifeP2);

    int? destinyScore;
    int? soulScore;

    if (name1 != null && name2 != null) {
      final destiny1 = calculateDestinyNumber(name1);
      final destiny2 = calculateDestinyNumber(name2);
      destinyScore = _getNumberCompatibility(destiny1, destiny2);

      final soul1 = calculateSoulUrgeNumber(name1);
      final soul2 = calculateSoulUrgeNumber(name2);
      soulScore = _getNumberCompatibility(soul1, soul2);
    }

    return NumerologyCompatibility(
      lifePathScore: lifePathScore,
      destinyScore: destinyScore,
      soulUrgeScore: soulScore,
      person1LifePath: lifeP1,
      person2LifePath: lifeP2,
    );
  }

  static int _reduceToSingleDigit(int number) {
    while (number > 9) {
      number = _digitSum(number);
    }
    return number;
  }

  static int _reduceToSingleDigitOrMaster(int number) {
    // Keep master numbers 11, 22, 33
    while (number > 9 && number != 11 && number != 22 && number != 33) {
      number = _digitSum(number);
    }
    return number;
  }

  static int _digitSum(int number) {
    var sum = 0;
    while (number > 0) {
      sum += number % 10;
      number ~/= 10;
    }
    return sum;
  }

  static int _letterToNumber(String letter) {
    const values = {
      'A': 1,
      'B': 2,
      'C': 3,
      'D': 4,
      'E': 5,
      'F': 6,
      'G': 7,
      'H': 8,
      'I': 9,
      'J': 1,
      'K': 2,
      'L': 3,
      'M': 4,
      'N': 5,
      'O': 6,
      'P': 7,
      'Q': 8,
      'R': 9,
      'S': 1,
      'T': 2,
      'U': 3,
      'V': 4,
      'W': 5,
      'X': 6,
      'Y': 7,
      'Z': 8,
    };
    return values[letter] ?? 0;
  }

  static int _getLifePathCompatibility(int lp1, int lp2) {
    // Compatibility matrix (simplified)
    final compatiblePairs = {
      1: [1, 3, 5, 7],
      2: [2, 4, 6, 8],
      3: [1, 3, 5, 9],
      4: [2, 4, 6, 8],
      5: [1, 3, 5, 7, 9],
      6: [2, 4, 6, 9],
      7: [1, 5, 7],
      8: [2, 4, 8],
      9: [3, 5, 6, 9],
      11: [2, 11, 22],
      22: [4, 11, 22, 33],
      33: [6, 22, 33],
    };

    if (lp1 == lp2) return 95;
    if (compatiblePairs[lp1]?.contains(lp2) ?? false) return 85;
    return 60;
  }

  static int _getNumberCompatibility(int n1, int n2) {
    if (n1 == n2) return 95;
    final diff = (n1 - n2).abs();
    if (diff <= 2) return 85;
    if (diff <= 4) return 70;
    return 55;
  }

  /// Get meaning of a number
  static NumerologyMeaning getNumberMeaning(int number) {
    return NumerologyMeaning.fromNumber(number);
  }
}

/// Numerology compatibility result
class NumerologyCompatibility {
  final int lifePathScore;
  final int? destinyScore;
  final int? soulUrgeScore;
  final int person1LifePath;
  final int person2LifePath;

  NumerologyCompatibility({
    required this.lifePathScore,
    this.destinyScore,
    this.soulUrgeScore,
    required this.person1LifePath,
    required this.person2LifePath,
  });

  int get overallScore {
    var total = lifePathScore;
    var count = 1;
    if (destinyScore != null) {
      total += destinyScore!;
      count++;
    }
    if (soulUrgeScore != null) {
      total += soulUrgeScore!;
      count++;
    }
    return (total / count).round();
  }
}

/// Meaning of numerology numbers
class NumerologyMeaning {
  final int number;
  final String title;
  final String keywords;
  final String meaning;
  final String strengths;
  final String challenges;
  final String loveStyle;
  final String detailedInterpretation;
  final String careerPath;
  final String spiritualLesson;
  final String shadowSide;
  final String compatibleNumbers;

  NumerologyMeaning({
    required this.number,
    required this.title,
    required this.keywords,
    required this.meaning,
    required this.strengths,
    required this.challenges,
    required this.loveStyle,
    this.detailedInterpretation = '',
    this.careerPath = '',
    this.spiritualLesson = '',
    this.shadowSide = '',
    this.compatibleNumbers = '',
  });

  factory NumerologyMeaning.fromNumber(int number) {
    switch (number) {
      case 1:
        return NumerologyMeaning(
          number: 1,
          title: 'The Leader',
          keywords: 'Independence - Pioneering - Creativity',
          meaning:
              'Natural leaders, innovators, and pioneers. Independence is their greatest value.',
          strengths:
              'Determination, self-confidence, creativity, entrepreneurship',
          challenges: 'Stubbornness, selfishness, impatience',
          loveStyle: 'Independent but loyal, prefers to take the lead',
          detailedInterpretation: '''
The number 1 is the first manifestation of cosmic energy - pure potential, the starting point, the creative spark. Those born with this number came into the universe with the message "I exist."

Your soul is designed to be a pioneer. Opening new paths, taking the first step, going where no one has gone before is in your nature. Leadership for you is not a choice but an existential necessity.

The 1 energy is associated with the Sun - the central, radiating, life-giving force. Like the Sun, you illuminate and warm those around you, but sometimes you can also burn.

The shadow side of this number is isolation and arrogance. The thought "I know best" can lead to loneliness. To find your balance, you need to learn cooperation and humility.
''',
          careerPath:
              'Entrepreneurship, management, innovation, starting your own business, sports, artistic direction',
          spiritualLesson:
              'Finding the balance between ego and soul. Understanding that leadership is service.',
          shadowSide:
              'Selfishness, dictatorship, closed to criticism, loneliness',
          compatibleNumbers: '1, 3, 5, 7',
        );
      case 2:
        return NumerologyMeaning(
          number: 2,
          title: 'The Diplomat',
          keywords: 'Balance - Partnership - Intuition',
          meaning:
              'Peaceful, cooperative, and sensitive. They seek harmony in relationships.',
          strengths: 'Diplomacy, empathy, patience, cooperation',
          challenges: 'Indecisiveness, oversensitivity, dependency',
          loveStyle: 'Romantic, supportive, harmonious partner',
          detailedInterpretation: '''
The number 2 represents duality, union, and balance - Yin and Yang, night and day, masculine and feminine. Those born with this number came into the world with the message "We exist."

Your soul is designed to unite, balance, and create harmony. Relationships are your learning field - alone you don't make sense, you need a mirror.

The 2 energy is associated with the Moon - reflecting, cyclical, emotional. Like the Moon, you are intuitive, sensing and reflecting the energies around you.

The shadow side of this number is excessive dependency and loss of identity. In trying to make others happy, you can lose yourself. To find your balance, you need to find your own voice.
''',
          careerPath:
              'Counseling, therapy, human resources, diplomacy, negotiation, mediation',
          spiritualLesson:
              'Merging while maintaining your own identity. Learning to set boundaries.',
          shadowSide:
              'Indecisiveness, conflict avoidance, passive-aggressiveness, loss of identity',
          compatibleNumbers: '2, 4, 6, 8',
        );
      case 3:
        return NumerologyMeaning(
          number: 3,
          title: 'The Creative',
          keywords: 'Expression - Joy - Communication',
          meaning:
              'Artistic, social, and energetic individuals. They love to express themselves.',
          strengths: 'Creativity, sociability, optimism, expressive power',
          challenges:
              'Scattered energy, superficiality, fear of self-expression',
          loveStyle: 'Fun, romantic, spontaneous relationships',
          detailedInterpretation: '''
The number 3 represents the sacred trinity - creator, creation, and created. Father, Mother, Child. Beginning, middle, end. Those born with this number came into the world with the message "I express."

Your soul is designed to create, communicate, and spread joy. Words, colors, sounds, and movements are your tools. Silence for you is a spiritual prison.

The 3 energy is associated with Jupiter - expanding, optimistic, abundant. Like Jupiter, you enlarge, enrich, and color life.

The shadow side of this number is scattered energy and superficiality. The danger of touching everything but not deepening anything. To find your balance, you need to learn to focus.
''',
          careerPath:
              'Art, writing, acting, music, marketing, communications, entertainment industry',
          spiritualLesson:
              'Combining creativity with discipline. Bearing the responsibility of expression.',
          shadowSide:
              'Scattered energy, superficiality, gossip, wasting energy',
          compatibleNumbers: '1, 3, 5, 9',
        );
      case 4:
        return NumerologyMeaning(
          number: 4,
          title: 'The Builder',
          keywords: 'Order - Diligence - Reliability',
          meaning:
              'Practical, disciplined, and reliable. They build solid foundations.',
          strengths: 'Organization, loyalty, perseverance, practicality',
          challenges: 'Rigidity, stubbornness, excessive caution',
          loveStyle: 'Loyal, reliable, traditional values',
          detailedInterpretation: '''
The number 4 represents the foundation of the material world - four elements, four directions, four seasons. Those born with this number came into the world with the message "I build."

Your soul is designed to build lasting structures - physical, emotional, or mental. Transforming dreams into reality is your special talent.

The 4 energy is associated with Saturn - disciplined, limiting, teaching. Like Saturn, you represent rules, structures, and responsibility.

The shadow side of this number is rigidity and fear-based control. Trying to plan everything kills spontaneity. To find your balance, you need to learn flexibility.
''',
          careerPath:
              'Engineering, architecture, accounting, project management, banking, real estate',
          spiritualLesson:
              'Understanding that security comes from within. Learning to let go of control.',
          shadowSide:
              'Rigidity, workaholism, control obsession, fear of change',
          compatibleNumbers: '2, 4, 6, 8',
        );
      case 5:
        return NumerologyMeaning(
          number: 5,
          title: 'The Free Spirit',
          keywords: 'Change - Adventure - Freedom',
          meaning:
              'Adventurous, versatile, and change-loving individuals. They dislike limitations.',
          strengths: 'Adaptability, courage, curiosity, versatility',
          challenges: 'Restlessness, excessive risk-taking, fear of commitment',
          loveStyle: 'Excitement-seeking, freedom-loving, spontaneous',
          detailedInterpretation: '''
The number 5 represents change and the five senses - experiencing, tasting, feeling life. Those born with this number came into the world with the message "I am free."

Your soul is designed to explore, experience, and transform. Routine means death to you, change means life. The world is your playground.

The 5 energy is associated with Mercury - mobile, communicative, adaptive. Like Mercury, you are quick, agile, and changeable.

The shadow side of this number is scattered energy and addictive searching. Trying everything and staying with nothing. To find your balance, you need to learn commitment.
''',
          careerPath:
              'Travel, sales, media, marketing, entrepreneurship, consulting, entertainment',
          spiritualLesson:
              'Understanding that freedom can coexist with commitment.',
          shadowSide:
              'Fear of attachment, excessive risk-taking, addictions, restlessness',
          compatibleNumbers: '1, 3, 5, 7, 9',
        );
      case 6:
        return NumerologyMeaning(
          number: 6,
          title: 'The Caregiver',
          keywords: 'Responsibility - Family - Harmony',
          meaning:
              'Nurturing, responsible, and family-oriented. They love helping others.',
          strengths: 'Compassion, responsibility, aesthetics, healing',
          challenges: 'Overprotectiveness, perfectionism, self-sacrifice',
          loveStyle: 'Caring, loyal, long-term relationships',
          detailedInterpretation: '''
The number 6 represents harmony, beauty, and responsibility - the six-pointed star, perfect balance. Those born with this number came into the world with the message "I heal."

Your soul is designed to care, heal, and create beauty. Family - whether blood-related or chosen - is your sacred space.

The 6 energy is associated with Venus - love, beauty, harmony. Like Venus, you spread beauty and healing around you.

The shadow side of this number is intrusive protection and perfectionism. Trying to save everyone can lead to neglecting yourself. To find your balance, you need to learn to set boundaries.
''',
          careerPath:
              'Healthcare, therapy, education, interior design, beauty, family counseling, social services',
          spiritualLesson:
              'Learning to care for yourself before caring for others.',
          shadowSide: 'Intrusiveness, martyr complex, perfectionism, criticism',
          compatibleNumbers: '2, 4, 6, 9',
        );
      case 7:
        return NumerologyMeaning(
          number: 7,
          title: 'The Seeker',
          keywords: 'Wisdom - Analysis - Spirituality',
          meaning: 'Thinker, researcher, and on a spiritual quest.',
          strengths: 'Analytical intelligence, intuition, depth, wisdom',
          challenges: 'Isolation, skepticism, emotional distance',
          loveStyle:
              'Seeks deep connection, intellectual compatibility important',
          detailedInterpretation: '''
The number 7 is the mystical number - seven planets, seven chakras, seven days. Those born with this number came into the world with the message "I understand."

Your soul is designed to seek truth, go deep, and find wisdom. Superficial answers don't satisfy you - you seek the meaning underlying everything.

The 7 energy is associated with Neptune - mystical, intuitive, spiritual. Like Neptune, you see the invisible and feel the unknown.

The shadow side of this number is isolation and skepticism. Getting lost in the world in your head and disconnecting from the real world. To find your balance, you need to learn grounding.
''',
          careerPath:
              'Research, academia, psychology, philosophy, writing, spiritual teaching, analysis',
          spiritualLesson:
              'Sharing inner wisdom with the outer world. The difference between solitude and isolation.',
          shadowSide: 'Over-analysis, paranoia, emotional closure, arrogance',
          compatibleNumbers: '1, 5, 7',
        );
      case 8:
        return NumerologyMeaning(
          number: 8,
          title: 'The Powerhouse',
          keywords: 'Success - Material Power - Authority',
          meaning:
              'Ambitious, powerful, and success-oriented. Masters of the material world.',
          strengths: 'Leadership, business acumen, determination, power',
          challenges: 'Workaholism, need for control, materialism',
          loveStyle: 'Security-seeking, loyal, strong partner',
          detailedInterpretation: '''
The number 8 is the infinity symbol and the number of material power - karma, balance, manifestation. Those born with this number came into the world with the message "I succeed."

Your soul is designed to master the material world. Money, power, and influence are your tools - but these are means, not ends. The real test: how do you use your power?

The 8 energy is associated with Saturn - karma, responsibility, consequences. Like Saturn, you reap what you sow, there's no escape.

The shadow side of this number is greed and power intoxication. Success obsession can crush human values. To find your balance, you need to understand the responsibility of power.
''',
          careerPath:
              'Finance, management, entrepreneurship, banking, law, real estate',
          spiritualLesson:
              'Balancing material and spiritual wealth. Understanding that power is for service.',
          shadowSide:
              'Greed, power intoxication, workaholism, emotional blindness',
          compatibleNumbers: '2, 4, 8',
        );
      case 9:
        return NumerologyMeaning(
          number: 9,
          title: 'The Humanitarian',
          keywords: 'Compassion - Universality - Wisdom',
          meaning: 'Idealistic, compassionate, and working for humanity.',
          strengths: 'Mercy, universal love, wisdom, creativity',
          challenges: 'Disappointment, difficulty letting go, being scattered',
          loveStyle: 'Unconditional love, self-sacrificing, idealistic',
          detailedInterpretation: '''
The number 9 is completion and universal love - the last single digit, containing all numbers, wholeness. Those born with this number came into the world with the message "I serve."

Your soul is designed to serve humanity. Beyond individual interests, collective good is your vision. Leaving the world a better place is your mission.

The 9 energy is associated with Mars - action, passion, struggle. Like Mars, you fight for your beliefs, but your weapon is not violence, it's love.

The shadow side of this number is disappointment and burnout. Exhausting yourself trying to change the world. To find your balance, you need to know your limits.
''',
          careerPath:
              'Philanthropy, art, therapy, international work, activism, teaching',
          spiritualLesson:
              'Learning to let go and accept. To change the world, first change yourself.',
          shadowSide:
              'Fanaticism, disappointment, martyr complex, difficulty finishing',
          compatibleNumbers: '3, 5, 6, 9',
        );
      case 11:
        return NumerologyMeaning(
          number: 11,
          title: 'The Master Intuitive',
          keywords: 'Inspiration - Intuition - Spiritual Vision',
          meaning:
              'Master number. High intuition, inspiration, and spiritual leadership potential.',
          strengths: 'Strong intuition, inspiring, visionary, spiritual',
          challenges:
              'Nervous tension, hypersensitivity, practical difficulties',
          loveStyle: 'Seeking a soulmate, deep spiritual connection',
          detailedInterpretation: '''
11 is a Master Number - high vibration, high potential, high responsibility. Double the power of 1, but also the sensitivity of 2. Those born with this number came into the world with the message "I inspire."

Your soul is designed to be a bridge between spiritual and material worlds. Strong intuition, visionary thinking, and the capacity to inspire are your gifts.

The 11 energy is like electricity - high voltage, high impact, but dangerous if not controlled. Your nervous system is sensitive, prone to overstimulation.

The shadow side of this number is hypersensitivity and inability to cope with the practical world. Your visions are great but you may forget to keep your feet on the ground. To find your balance, you need to learn grounding.
''',
          careerPath:
              'Spiritual teaching, psychology, art, music, healing, inspirational speaking',
          spiritualLesson:
              'Combining vision with practice. Transforming sensitivity into strength.',
          shadowSide:
              'Nervous tension, disconnection from reality, excessive idealism, inability to decide',
          compatibleNumbers: '2, 11, 22',
        );
      case 22:
        return NumerologyMeaning(
          number: 22,
          title: 'The Master Builder',
          keywords: 'Grand Vision - Manifestation - Power',
          meaning:
              'Master number. Visionary builders who can bring major projects to life.',
          strengths: 'Grand vision, practical power, leadership, success',
          challenges: 'Excessive pressure, perfectionism, burnout',
          loveStyle: 'Seeking a strong and supportive partner',
          detailedInterpretation: '''
22 is the most powerful Master Number - "The Master Builder." The visionary power of 11 + the practical capacity of 4. Those born with this number came into the world with the message "I build - on a grand scale."

Your soul is designed to change the world permanently. You don't just dream, you have the power to turn those dreams into reality. Empire builders, movement starters.

The 22 energy is like pyramids - massive, permanent, inspiring. Like pyramids, you have the potential to build structures that will stand for generations.

The shadow side of this number is burnout and excessive pressure. Big goals create big stress. To find your balance, you need to show compassion to yourself too.
''',
          careerPath:
              'Large-scale entrepreneurship, architecture, international organizations, leadership',
          spiritualLesson:
              'Understanding that great power requires great responsibility.',
          shadowSide:
              'Burnout, perfectionism, crushing others, exhausting yourself',
          compatibleNumbers: '4, 11, 22, 33',
        );
      case 33:
        return NumerologyMeaning(
          number: 33,
          title: 'The Master Teacher',
          keywords: 'Universal Love - Healing - Inspiration',
          meaning:
              'Master number. Teachers carrying unconditional love and healing energy.',
          strengths: 'Unconditional love, healing, inspiration, self-sacrifice',
          challenges: 'Excessive responsibility, neglecting own needs',
          loveStyle: 'Deep spiritual connection, unconditional love',
          detailedInterpretation: '''
33 is the rarest and highest Master Number - "The Master Teacher" or "Cosmic Parent." The intuition of 11 + the building power of 22 + the compassion of 6. Those born with this number came into the world with the message "I heal and teach."

Your soul is designed to elevate humanity. Unconditional love, universal healing, and spiritual teaching are your sacred duties. You may not become aware of this energy until age 33.

The 33 energy is associated with Christ consciousness - self-sacrifice, unconditional love, healing. Like great spiritual teachers, you have the capacity to carry others' burdens.

The shadow side of this number is excessive self-sacrifice and martyrdom complex. You can sacrifice yourself trying to save everyone. To find your balance, you need to love yourself too.
''',
          careerPath:
              'Spiritual teaching, therapy, healing, philanthropy, art therapy, counseling',
          spiritualLesson:
              'Healing yourself while healing others. Loving while maintaining boundaries.',
          shadowSide:
              'Martyr complex, victim mentality, self-exhaustion, inability to set boundaries',
          compatibleNumbers: '6, 22, 33',
        );
      default:
        return NumerologyMeaning(
          number: number,
          title: 'Unknown',
          keywords: '',
          meaning: '',
          strengths: '',
          challenges: '',
          loveStyle: '',
        );
    }
  }
}
