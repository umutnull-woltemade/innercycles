/// Comprehensive Numerology Calculation Service
/// Includes Pythagorean and Chaldean systems with Turkish letter support
library;

// ============================================================================
// SUPPORTING CLASSES
// ============================================================================

/// Represents a Pinnacle period in one's life
class Pinnacle {
  final int number;
  final int startAge;
  final int endAge;
  final String meaning;
  final String theme;
  final String opportunities;
  final String advice;

  const Pinnacle({
    required this.number,
    required this.startAge,
    required this.endAge,
    required this.meaning,
    this.theme = '',
    this.opportunities = '',
    this.advice = '',
  });

  bool isActive(int currentAge) =>
      currentAge >= startAge && currentAge <= endAge;

  @override
  String toString() => 'Pinnacle($number: age $startAge-$endAge)';
}

/// Represents a Challenge period in one's life
class Challenge {
  final int number;
  final int startAge;
  final int endAge;
  final String lesson;
  final String description;
  final String howToOvercome;

  const Challenge({
    required this.number,
    required this.startAge,
    required this.endAge,
    required this.lesson,
    this.description = '',
    this.howToOvercome = '',
  });

  bool isActive(int currentAge) =>
      currentAge >= startAge && currentAge <= endAge;

  @override
  String toString() => 'Challenge($number: age $startAge-$endAge)';
}

/// Detailed compatibility report between two people
class CompatibilityReport {
  final int overallScore;
  final String lifePathCompatibility;
  final String expressionCompatibility;
  final String soulUrgeCompatibility;
  final String personalityCompatibility;
  final List<String> strengths;
  final List<String> challenges;
  final List<String> advice;
  final Map<String, int> categoryScores;

  const CompatibilityReport({
    required this.overallScore,
    required this.lifePathCompatibility,
    required this.expressionCompatibility,
    required this.soulUrgeCompatibility,
    required this.personalityCompatibility,
    required this.strengths,
    required this.challenges,
    this.advice = const [],
    this.categoryScores = const {},
  });

  String get compatibilityLevel {
    if (overallScore >= 90) return 'Mukemmel Uyum';
    if (overallScore >= 75) return 'Cok Iyi Uyum';
    if (overallScore >= 60) return 'Iyi Uyum';
    if (overallScore >= 45) return 'Orta Uyum';
    return 'Zorlayici Uyum';
  }
}

/// Numerology forecast for a period
class NumerologyForecast {
  final int personalNumber;
  final String theme;
  final String generalAdvice;
  final String loveAdvice;
  final String careerAdvice;
  final String healthAdvice;
  final String financialAdvice;
  final String spiritualAdvice;
  final List<int> luckyNumbers;
  final List<String> luckyDays;
  final List<String> favorableActivities;
  final List<String> challengesToWatch;
  final String affirmation;

  const NumerologyForecast({
    required this.personalNumber,
    required this.theme,
    required this.generalAdvice,
    required this.loveAdvice,
    required this.careerAdvice,
    required this.healthAdvice,
    this.financialAdvice = '',
    this.spiritualAdvice = '',
    required this.luckyNumbers,
    required this.luckyDays,
    this.favorableActivities = const [],
    this.challengesToWatch = const [],
    this.affirmation = '',
  });
}

/// Karmic lesson information
class KarmicLesson {
  final int number;
  final String description;
  final String howToHeal;
  final List<String> affirmations;

  const KarmicLesson({
    required this.number,
    required this.description,
    required this.howToHeal,
    this.affirmations = const [],
  });
}

/// Complete numerology profile
class NumerologyProfile {
  final int lifePath;
  final int expression;
  final int soulUrge;
  final int personality;
  final int birthday;
  final int maturity;
  final int? balance;
  final List<int> karmicDebts;
  final List<int> karmicLessons;
  final List<Pinnacle> pinnacles;
  final List<Challenge> challenges;
  final Map<int, int> numberFrequency;
  final List<int> missingNumbers;
  final bool hasMasterNumber;

  const NumerologyProfile({
    required this.lifePath,
    required this.expression,
    required this.soulUrge,
    required this.personality,
    required this.birthday,
    required this.maturity,
    this.balance,
    required this.karmicDebts,
    required this.karmicLessons,
    required this.pinnacles,
    required this.challenges,
    required this.numberFrequency,
    required this.missingNumbers,
    required this.hasMasterNumber,
  });
}

// ============================================================================
// MAIN SERVICE CLASS
// ============================================================================

/// Comprehensive Numerology Calculation Service
class NumerologyCalculationService {
  // ==========================================================================
  // LETTER VALUE MAPPINGS
  // ==========================================================================

  /// Pythagorean letter values (Western system)
  /// Based on the Latin alphabet with Turkish special characters
  static const Map<String, int> pythagoreanValues = {
    // Row 1: 1
    'A': 1, 'J': 1, 'S': 1,
    // Row 2: 2
    'B': 2, 'K': 2, 'T': 2,
    // Row 3: 3
    'C': 3, 'L': 3, 'U': 3,
    // Row 4: 4
    'D': 4, 'M': 4, 'V': 4,
    // Row 5: 5
    'E': 5, 'N': 5, 'W': 5,
    // Row 6: 6
    'F': 6, 'O': 6, 'X': 6,
    // Row 7: 7
    'G': 7, 'P': 7, 'Y': 7,
    // Row 8: 8
    'H': 8, 'Q': 8, 'Z': 8,
    // Row 9: 9
    'I': 9, 'R': 9,

    // Turkish special characters (Pythagorean mapping)
    'Ç': 3, // C with cedilla - same as C
    'Ğ': 7, // G with breve - same as G
    'İ': 9, // I with dot - treated as I
    'Ö': 6, // O with umlaut - same as O
    'Ş': 1, // S with cedilla - same as S
    'Ü': 3, // U with umlaut - same as U
  };

  /// Chaldean letter values (Ancient Babylonian system)
  /// Note: Chaldean doesn't assign 9 to any letter (sacred number)
  static const Map<String, int> chaldeanValues = {
    'A': 1, 'I': 1, 'J': 1, 'Q': 1, 'Y': 1,
    'B': 2, 'K': 2, 'R': 2,
    'C': 3, 'G': 3, 'L': 3, 'S': 3,
    'D': 4, 'M': 4, 'T': 4,
    'E': 5, 'H': 5, 'N': 5, 'X': 5,
    'U': 6, 'V': 6, 'W': 6,
    'O': 7, 'Z': 7,
    'F': 8, 'P': 8,

    // Turkish special characters (Chaldean mapping)
    'Ç': 3, // C with cedilla
    'Ğ': 3, // G with breve
    'İ': 1, // I with dot
    'Ö': 7, // O with umlaut
    'Ş': 3, // S with cedilla
    'Ü': 6, // U with umlaut
  };

  /// Extended Turkish character mapping
  static const Map<String, String> _turkishToLatin = {
    '\u00C7': 'C', // C - C with cedilla uppercase
    '\u00E7': 'C', // c - c with cedilla lowercase
    '\u011E': 'G', // G - G with breve uppercase
    '\u011F': 'G', // g - g with breve lowercase
    '\u0130': 'I', // I - I with dot above uppercase
    '\u0131': 'I', // i - dotless i lowercase
    '\u00D6': 'O', // O - O with umlaut uppercase
    '\u00F6': 'O', // o - o with umlaut lowercase
    '\u015E': 'S', // S - S with cedilla uppercase
    '\u015F': 'S', // s - s with cedilla lowercase
    '\u00DC': 'U', // U - U with umlaut uppercase
    '\u00FC': 'U', // u - u with umlaut lowercase
  };

  /// Vowels in Pythagorean system (including Turkish vowels)
  static const Set<String> _vowels = {
    'A', 'E', 'I', 'O', 'U',
    // Turkish vowels map to these base vowels
  };

  /// Vowels in Chaldean system (Y can be vowel or consonant)
  static const Set<String> _chaldeanVowels = {'A', 'E', 'I', 'O', 'U'};

  // ==========================================================================
  // LETTER VALUE METHODS
  // ==========================================================================

  /// Get the numerical value of a letter
  /// [letter] - Single letter to convert
  /// [chaldean] - Use Chaldean system if true, Pythagorean if false
  static int getLetterValue(String letter, {bool chaldean = false}) {
    if (letter.isEmpty) return 0;

    // Normalize to uppercase
    var normalized = letter.toUpperCase();

    // Handle Turkish special characters
    if (_turkishToLatin.containsKey(letter)) {
      normalized = _turkishToLatin[letter]!;
    } else if (_turkishToLatin.containsKey(letter.toUpperCase())) {
      normalized = _turkishToLatin[letter.toUpperCase()]!;
    }

    final values = chaldean ? chaldeanValues : pythagoreanValues;
    return values[normalized] ?? 0;
  }

  /// Convert a name to its base letters (handling Turkish characters)
  static String _normalizeNameForCalculation(String name) {
    var result = name.toUpperCase();

    // Replace Turkish special characters
    _turkishToLatin.forEach((turkish, latin) {
      result = result.replaceAll(turkish, latin);
      result = result.replaceAll(turkish.toLowerCase(), latin);
    });

    // Remove non-letter characters
    result = result.replaceAll(RegExp(r'[^A-Z]'), '');

    return result;
  }

  /// Check if a letter is a vowel
  static bool _isVowel(String letter, {bool chaldean = false}) {
    final normalized = letter.toUpperCase();

    // Handle Turkish vowels
    if (['\u0130', '\u0131', 'I'].contains(letter) ||
        ['\u00D6', '\u00F6', 'O'].contains(letter) ||
        ['\u00DC', '\u00FC', 'U'].contains(letter)) {
      return true;
    }

    return chaldean
        ? _chaldeanVowels.contains(normalized)
        : _vowels.contains(normalized);
  }

  // ==========================================================================
  // REDUCTION METHODS
  // ==========================================================================

  /// Reduce a number to a single digit
  static int _reduceToSingleDigit(int number) {
    while (number > 9) {
      number = _digitSum(number);
    }
    return number;
  }

  /// Reduce a number to single digit OR master number (11, 22, 33)
  static int _reduceToSingleDigitOrMaster(int number) {
    while (number > 9 && !isMasterNumber(number)) {
      number = _digitSum(number);
    }
    return number;
  }

  /// Get the sum of digits in a number
  static int _digitSum(int number) {
    var sum = 0;
    number = number.abs();
    while (number > 0) {
      sum += number % 10;
      number ~/= 10;
    }
    return sum;
  }

  // ==========================================================================
  // MASTER NUMBER METHODS
  // ==========================================================================

  /// Check if a number is a master number (11, 22, 33, 44)
  static bool isMasterNumber(int number) {
    return number == 11 || number == 22 || number == 33 || number == 44;
  }

  /// Reduce a master number to its base vibration
  static int reduceMasterNumber(int number) {
    if (!isMasterNumber(number)) return number;
    return _reduceToSingleDigit(number);
  }

  /// Get the intensity level of a master number
  static String getMasterNumberIntensity(int number) {
    switch (number) {
      case 11:
        return 'Spiritual Messenger - Intuition & Illumination';
      case 22:
        return 'Master Builder - Material Mastery & Vision';
      case 33:
        return 'Master Teacher - Compassion & Healing';
      case 44:
        return 'Master Healer - Grounded Transformation';
      default:
        return 'Not a Master Number';
    }
  }

  // ==========================================================================
  // CORE CALCULATIONS
  // ==========================================================================

  /// Calculate Life Path Number from birth date
  /// The most important number - represents life purpose
  static int calculateLifePath(DateTime birthDate) {
    // Method 1: Reduce each component first, then add
    final day = _reduceToSingleDigit(birthDate.day);
    final month = _reduceToSingleDigit(birthDate.month);
    final year = _reduceToSingleDigit(birthDate.year);

    final sum = day + month + year;
    return _reduceToSingleDigitOrMaster(sum);
  }

  /// Alternative Life Path calculation (full addition method)
  /// Some numerologists prefer this approach
  static int calculateLifePathAlternative(DateTime birthDate) {
    // Add all digits together without reducing components first
    final dateString =
        '${birthDate.year}${birthDate.month.toString().padLeft(2, '0')}${birthDate.day.toString().padLeft(2, '0')}';
    var sum = 0;
    for (final char in dateString.split('')) {
      sum += int.tryParse(char) ?? 0;
    }
    return _reduceToSingleDigitOrMaster(sum);
  }

  /// Calculate Expression/Destiny Number from full name
  /// Represents talents and abilities
  static int calculateExpression(String fullName, {bool chaldean = false}) {
    final name = _normalizeNameForCalculation(fullName);
    var sum = 0;

    for (final char in name.split('')) {
      sum += getLetterValue(char, chaldean: chaldean);
    }

    return _reduceToSingleDigitOrMaster(sum);
  }

  /// Calculate Soul Urge/Heart's Desire Number (vowels only)
  /// Represents inner desires and motivations
  static int calculateSoulUrge(String fullName, {bool chaldean = false}) {
    final name = _normalizeNameForCalculation(fullName);
    var sum = 0;

    for (final char in name.split('')) {
      if (_isVowel(char, chaldean: chaldean)) {
        sum += getLetterValue(char, chaldean: chaldean);
      }
    }

    return _reduceToSingleDigitOrMaster(sum);
  }

  /// Calculate Personality Number (consonants only)
  /// Represents outer personality and first impressions
  static int calculatePersonality(String fullName, {bool chaldean = false}) {
    final name = _normalizeNameForCalculation(fullName);
    var sum = 0;

    for (final char in name.split('')) {
      if (!_isVowel(char, chaldean: chaldean)) {
        sum += getLetterValue(char, chaldean: chaldean);
      }
    }

    return _reduceToSingleDigitOrMaster(sum);
  }

  /// Calculate Birthday Number (just the day)
  /// Represents a special gift or talent
  static int calculateBirthday(int birthDay) {
    return _reduceToSingleDigitOrMaster(birthDay);
  }

  /// Calculate Maturity Number (Life Path + Expression)
  /// Represents the person you're becoming
  static int calculateMaturity(int lifePath, int expression) {
    final sum =
        _reduceToSingleDigit(lifePath) + _reduceToSingleDigit(expression);
    return _reduceToSingleDigitOrMaster(sum);
  }

  /// Calculate Balance Number (from initials)
  /// Represents how to handle stress
  static int calculateBalance(String fullName, {bool chaldean = false}) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    var sum = 0;

    for (final part in parts) {
      if (part.isNotEmpty) {
        sum += getLetterValue(part[0], chaldean: chaldean);
      }
    }

    return _reduceToSingleDigit(sum);
  }

  /// Calculate Hidden Passion Number
  /// The number that appears most frequently in the name
  static int? calculateHiddenPassion(String fullName, {bool chaldean = false}) {
    final frequency = getNumberFrequency(fullName, chaldean: chaldean);
    if (frequency.isEmpty) return null;

    int maxCount = 0;
    int? hiddenPassion;

    frequency.forEach((number, count) {
      if (count > maxCount) {
        maxCount = count;
        hiddenPassion = number;
      }
    });

    // Hidden passion is significant if it appears 3+ times
    return maxCount >= 3 ? hiddenPassion : null;
  }

  /// Calculate Subconscious Self Number
  /// Based on how many numbers are present in the name (out of 9)
  static int calculateSubconsciousSelf(
    String fullName, {
    bool chaldean = false,
  }) {
    final missing = getMissingNumbers(fullName, chaldean: chaldean);
    return 9 - missing.length;
  }

  // ==========================================================================
  // KARMIC NUMBERS
  // ==========================================================================

  /// Check for Karmic Debt 13 (laziness in past life)
  static bool hasKarmicDebt13(DateTime birthDate) {
    // Check if 13 appears in life path calculation
    final day = birthDate.day;
    final month = birthDate.month;
    final year = birthDate.year;

    // Check day
    if (day == 13) return true;

    // Check month + day
    if ((month + day) == 13) return true;

    // Check year reduction
    if (_digitSum(year) == 13) return true;

    // Check full date reduction before final reduction
    final sum = _digitSum(day) + _digitSum(month) + _digitSum(year);
    return sum == 13;
  }

  /// Check for Karmic Debt 14 (abuse of freedom in past life)
  static bool hasKarmicDebt14(DateTime birthDate) {
    final day = birthDate.day;
    final month = birthDate.month;
    final year = birthDate.year;

    if (day == 14) return true;
    if ((month + day) == 14) return true;
    if (_digitSum(year) == 14) return true;

    final sum = _digitSum(day) + _digitSum(month) + _digitSum(year);
    return sum == 14;
  }

  /// Check for Karmic Debt 16 (ego/abuse of love in past life)
  static bool hasKarmicDebt16(DateTime birthDate) {
    final day = birthDate.day;
    final month = birthDate.month;
    final year = birthDate.year;

    if (day == 16) return true;
    if ((month + day) == 16) return true;
    if (_digitSum(year) == 16) return true;

    final sum = _digitSum(day) + _digitSum(month) + _digitSum(year);
    return sum == 16;
  }

  /// Check for Karmic Debt 19 (abuse of power in past life)
  static bool hasKarmicDebt19(DateTime birthDate) {
    final day = birthDate.day;
    final month = birthDate.month;
    final year = birthDate.year;

    if (day == 19) return true;
    if ((month + day) == 19) return true;
    if (_digitSum(year) == 19) return true;

    final sum = _digitSum(day) + _digitSum(month) + _digitSum(year);
    return sum == 19;
  }

  /// Get all Karmic Debts present in birth date
  static List<int> getKarmicDebts(DateTime birthDate) {
    final debts = <int>[];
    if (hasKarmicDebt13(birthDate)) debts.add(13);
    if (hasKarmicDebt14(birthDate)) debts.add(14);
    if (hasKarmicDebt16(birthDate)) debts.add(16);
    if (hasKarmicDebt19(birthDate)) debts.add(19);
    return debts;
  }

  /// Get Karmic Lessons from name (missing numbers 1-9)
  static List<int> getKarmicLessons(String fullName, {bool chaldean = false}) {
    return getMissingNumbers(fullName, chaldean: chaldean);
  }

  /// Get detailed Karmic Lesson information
  static KarmicLesson? getKarmicLessonDetails(int number) {
    final lessons = {
      1: const KarmicLesson(
        number: 1,
        description:
            'Ozguven ve bagimsizlik konusunda dersler ogrenmeniz gerekiyor.',
        howToHeal:
            'Kendi kararlarinizi vermeyi, liderlik almaya ve kendinize guvenmeyi ogrenmek.',
        affirmations: ['Ben guclu ve bagimsizim', 'Kendi yolumu yaratiyorum'],
      ),
      2: const KarmicLesson(
        number: 2,
        description: 'Isbirligi ve diplomasi konusunda gelismeniz gerekiyor.',
        howToHeal:
            'Sabir, empati ve baskalariyla uyum icinde calismayi ogrenmek.',
        affirmations: ['Isbirligine acigim', 'Uyum yaratiyorum'],
      ),
      3: const KarmicLesson(
        number: 3,
        description: 'Yaratici ifade ve iletisim konusunda engelleriniz var.',
        howToHeal:
            'Kendinizi ifade etmekten korkmamak, yaraticiligi kucaklamak.',
        affirmations: [
          'Yaraticiligimi ozgurce ifade ediyorum',
          'Sesim degerli',
        ],
      ),
      4: const KarmicLesson(
        number: 4,
        description:
            'Disiplin, organizasyon ve pratiklik konusunda calismaniz gerekiyor.',
        howToHeal: 'Duzenli calisma, planlama ve sabir gelistirmek.',
        affirmations: [
          'Duzen ve stabilite yaratiyorum',
          'Sabirla insa ediyorum',
        ],
      ),
      5: const KarmicLesson(
        number: 5,
        description:
            'Degisim, ozgurluk ve adaptasyon konusunda dersleriniz var.',
        howToHeal:
            'Degisimi kucaklamak, esnek olmak, yeni deneyimlere acik olmak.',
        affirmations: ['Degisime acigim', 'Ozgurlugumu kutluyorum'],
      ),
      6: const KarmicLesson(
        number: 6,
        description:
            'Sorumluluk, aile ve bakim verme konusunda ogreniminiz var.',
        howToHeal: 'Baskalarina sefkat gostermek, sorumluluk almak.',
        affirmations: ['Sevgiyle bakim veriyorum', 'Ailem icin varim'],
      ),
      7: const KarmicLesson(
        number: 7,
        description:
            'Spiritüel arayis ve icsel bilgelik konusunda gelismeniz gerekiyor.',
        howToHeal:
            'Meditasyon, kendini tanimayla, derin dusunce ile baglanmak.',
        affirmations: ['Icsel bilgeligimi dinliyorum', 'Derinlige iniyorum'],
      ),
      8: const KarmicLesson(
        number: 8,
        description: 'Maddi dunya, guc ve otorite konusunda dersleriniz var.',
        howToHeal: 'Finansal bilinclilik, guc dengesini ogrenmek.',
        affirmations: ['Bollugu hak ediyorum', 'Gucumu bilgece kullaniyorum'],
      ),
      9: const KarmicLesson(
        number: 9,
        description:
            'Evrensel sevgi, sefkat ve birakma konusunda ogreniminiz var.',
        howToHeal: 'Kosulsuz sevgi, affetme ve hizmet etmeyi ogrenmek.',
        affirmations: ['Kosulsuz seviyorum', 'Kolayca birakiyorum'],
      ),
    };
    return lessons[number];
  }

  // ==========================================================================
  // CYCLES - PERSONAL YEAR/MONTH/DAY
  // ==========================================================================

  /// Calculate Personal Year Number
  static int calculatePersonalYear(DateTime birthDate, int currentYear) {
    final day = _reduceToSingleDigit(birthDate.day);
    final month = _reduceToSingleDigit(birthDate.month);
    final year = _reduceToSingleDigit(currentYear);

    return _reduceToSingleDigitOrMaster(day + month + year);
  }

  /// Calculate Personal Month Number
  static int calculatePersonalMonth(int personalYear, int currentMonth) {
    final month = _reduceToSingleDigit(currentMonth);
    return _reduceToSingleDigitOrMaster(personalYear + month);
  }

  /// Calculate Personal Day Number
  static int calculatePersonalDay(int personalMonth, int currentDay) {
    final day = _reduceToSingleDigit(currentDay);
    return _reduceToSingleDigitOrMaster(personalMonth + day);
  }

  /// Calculate Universal Year Number
  static int calculateUniversalYear(int year) {
    return _reduceToSingleDigitOrMaster(_digitSum(year));
  }

  /// Calculate Universal Month Number
  static int calculateUniversalMonth(int year, int month) {
    final universalYear = calculateUniversalYear(year);
    return _reduceToSingleDigitOrMaster(universalYear + month);
  }

  /// Calculate Universal Day Number
  static int calculateUniversalDay(int year, int month, int day) {
    final sum = _digitSum(year) + month + day;
    return _reduceToSingleDigitOrMaster(sum);
  }

  /// Get complete cycle information for a date
  static Map<String, int> getCompleteCycles(
    DateTime birthDate,
    DateTime currentDate,
  ) {
    final personalYear = calculatePersonalYear(birthDate, currentDate.year);
    final personalMonth = calculatePersonalMonth(
      personalYear,
      currentDate.month,
    );
    final personalDay = calculatePersonalDay(personalMonth, currentDate.day);

    return {
      'personalYear': personalYear,
      'personalMonth': personalMonth,
      'personalDay': personalDay,
      'universalYear': calculateUniversalYear(currentDate.year),
      'universalMonth': calculateUniversalMonth(
        currentDate.year,
        currentDate.month,
      ),
      'universalDay': calculateUniversalDay(
        currentDate.year,
        currentDate.month,
        currentDate.day,
      ),
    };
  }

  // ==========================================================================
  // PINNACLES & CHALLENGES
  // ==========================================================================

  /// Calculate the four Pinnacles of life
  static List<Pinnacle> calculatePinnacles(DateTime birthDate) {
    final lifePath = calculateLifePath(birthDate);
    final day = _reduceToSingleDigit(birthDate.day);
    final month = _reduceToSingleDigit(birthDate.month);
    final year = _reduceToSingleDigit(birthDate.year);

    // First Pinnacle duration: 36 - Life Path
    final firstEnd = 36 - _reduceToSingleDigit(lifePath);

    // First Pinnacle: Month + Day
    final first = _reduceToSingleDigitOrMaster(month + day);

    // Second Pinnacle: Day + Year
    final second = _reduceToSingleDigitOrMaster(day + year);

    // Third Pinnacle: First + Second
    final third = _reduceToSingleDigitOrMaster(first + second);

    // Fourth Pinnacle: Month + Year
    final fourth = _reduceToSingleDigitOrMaster(month + year);

    return [
      Pinnacle(
        number: first,
        startAge: 0,
        endAge: firstEnd,
        meaning: _getPinnacleMeaning(first),
        theme: _getPinnacleTheme(first, 1),
        opportunities: _getPinnacleOpportunities(first),
        advice: _getPinnacleAdvice(first),
      ),
      Pinnacle(
        number: second,
        startAge: firstEnd + 1,
        endAge: firstEnd + 9,
        meaning: _getPinnacleMeaning(second),
        theme: _getPinnacleTheme(second, 2),
        opportunities: _getPinnacleOpportunities(second),
        advice: _getPinnacleAdvice(second),
      ),
      Pinnacle(
        number: third,
        startAge: firstEnd + 10,
        endAge: firstEnd + 18,
        meaning: _getPinnacleMeaning(third),
        theme: _getPinnacleTheme(third, 3),
        opportunities: _getPinnacleOpportunities(third),
        advice: _getPinnacleAdvice(third),
      ),
      Pinnacle(
        number: fourth,
        startAge: firstEnd + 19,
        endAge: 99, // Lifetime
        meaning: _getPinnacleMeaning(fourth),
        theme: _getPinnacleTheme(fourth, 4),
        opportunities: _getPinnacleOpportunities(fourth),
        advice: _getPinnacleAdvice(fourth),
      ),
    ];
  }

  static String _getPinnacleMeaning(int number) {
    final meanings = {
      1: 'Liderlik ve bagimsizlik donemi. Kendi yolunuzu cizeceksiniz.',
      2: 'Isbirligi ve iliski donemi. Diplomasi onemli.',
      3: 'Yaraticilik ve ifade donemi. Kendinizi gosterin.',
      4: 'Insaat ve temel atma donemi. Siki calisma gerekli.',
      5: 'Degisim ve ozgurluk donemi. Macera sizi bekliyor.',
      6: 'Sorumluluk ve aile donemi. Bakim ve sevgi.',
      7: 'Icsel arayis ve spiritüellik donemi. Kendinizi kesfedeceksiniz.',
      8: 'Maddi basari ve guc donemi. Kariyer odakli olun.',
      9: 'Tamamlanma ve hizmet donemi. Baskalarina yardim edin.',
      11: 'Spiritüel aydinlanma ve ilham donemi. Sezgilerinize guvenin.',
      22: 'Buyuk projeleri hayata gecirme donemi. Vizyon gerekli.',
      33: 'Evrensel ogretmenlik ve sifa donemi. Insanliga hizmet.',
    };
    return meanings[number] ?? 'Ozel bir donem.';
  }

  static String _getPinnacleTheme(int number, int pinnacleOrder) {
    final baseTheme = _getPinnacleMeaning(number);
    final orderContext = {
      1: 'Genclik ve ogrenim doneminde',
      2: 'Olgunlasma doneminde',
      3: 'Ustalık doneminde',
      4: 'Bilgelik doneminde',
    };
    return '${orderContext[pinnacleOrder]} $baseTheme';
  }

  static String _getPinnacleOpportunities(int number) {
    final opportunities = {
      1: 'Yeni baslangiçlar, girisimcilik, liderlik pozisyonlari',
      2: 'Ortakliklar, evlilik, isbirligi projeleri',
      3: 'Sanatsal projeler, iletisim, sosyal etkinlikler',
      4: 'Is kurma, gayrimenkul, uzun vadeli yatirimlar',
      5: 'Seyahat, yeni kariyer, yasam degisiklikleri',
      6: 'Aile kurma, ev alma, topluma hizmet',
      7: 'Egitim, arastirma, spiritüel gelisim',
      8: 'Kariyer yukselmesi, finansal kazanc, guc pozisyonlari',
      9: 'Insani projeler, sanat, evrensel hizmet',
      11: 'Spiritüel ogretmenlik, psikolojik calisma, ilham verme',
      22: 'Büyük ölcekli projeler, uluslararasi isler',
      33: 'Sifa isleri, egitim, hayirseverlik',
    };
    return opportunities[number] ?? 'Cesitli firsatlar mevcut.';
  }

  static String _getPinnacleAdvice(int number) {
    final advice = {
      1: 'Cesaretli olun ama bagimsizlikta asiriya kacmayin.',
      2: 'Sabir ve diplomasi gelistirin.',
      3: 'Yaraticiligizi ifade edin ama odaklani kaybetmeyin.',
      4: 'Siki calisin ama kendinizi ihmal etmeyin.',
      5: 'Degisime acik olun ama sorumsuzluga dusmeyin.',
      6: 'Baskalarina bakin ama kendinizi de unutmayin.',
      7: 'Icsel arayis yapin ama izole olmayin.',
      8: 'Basari icin calisin ama etik sinirlar icinde kalin.',
      9: 'Hizmet edin ama kendinizi tuketmeyin.',
      11: 'Sezgilerinize guvenin ama pratik kalin.',
      22: 'Büyük düsunun ama adim adim ilerleyin.',
      33: 'Sifa verin ama kendi sinirllarinizi koruyun.',
    };
    return advice[number] ?? 'Icsel rehberliginizi dinleyin.';
  }

  /// Calculate the four Challenges of life
  static List<Challenge> calculateChallenges(DateTime birthDate) {
    final lifePath = calculateLifePath(birthDate);
    final day = _reduceToSingleDigit(birthDate.day);
    final month = _reduceToSingleDigit(birthDate.month);
    final year = _reduceToSingleDigit(birthDate.year);

    final firstEnd = 36 - _reduceToSingleDigit(lifePath);

    // First Challenge: |Month - Day|
    final first = (month - day).abs();

    // Second Challenge: |Day - Year|
    final second = (day - year).abs();

    // Third Challenge: |First - Second|
    final third = (first - second).abs();

    // Fourth Challenge: |Month - Year|
    final fourth = (month - year).abs();

    return [
      Challenge(
        number: first,
        startAge: 0,
        endAge: firstEnd,
        lesson: _getChallengeMeaning(first),
        description: _getChallengeDescription(first),
        howToOvercome: _getChallengeAdvice(first),
      ),
      Challenge(
        number: second,
        startAge: firstEnd + 1,
        endAge: firstEnd + 9,
        lesson: _getChallengeMeaning(second),
        description: _getChallengeDescription(second),
        howToOvercome: _getChallengeAdvice(second),
      ),
      Challenge(
        number: third,
        startAge: firstEnd + 10,
        endAge: firstEnd + 18,
        lesson: _getChallengeMeaning(third),
        description: _getChallengeDescription(third),
        howToOvercome: _getChallengeAdvice(third),
      ),
      Challenge(
        number: fourth,
        startAge: firstEnd + 19,
        endAge: 99,
        lesson: _getChallengeMeaning(fourth),
        description: _getChallengeDescription(fourth),
        howToOvercome: _getChallengeAdvice(fourth),
      ),
    ];
  }

  static String _getChallengeMeaning(int number) {
    final meanings = {
      0: 'Tum zorluklar veya hicbir zorluk - secim sizin.',
      1: 'Ozguven ve bagimsizlik gelistirme.',
      2: 'Hassasiyet ve isbirligini dengeleme.',
      3: 'Kendinizi ifade etme ve daginikliktan kacinma.',
      4: 'Disiplin ve pratiklik olusturma.',
      5: 'Ozgurluk ve sorumluluk dengesi.',
      6: 'Sorumluluk ve mukemmeliyetcilikten kurtulma.',
      7: 'Guven ve spiritüel inanc gelistirme.',
      8: 'Guc ve para ile saglikli iliski kurma.',
    };
    return meanings[number] ?? 'Ozel bir ders.';
  }

  static String _getChallengeDescription(int number) {
    final descriptions = {
      0: 'Bu nadir zorluk, yasam boyunca tum sayilarin derslerini ogrenmek anlamina gelir.',
      1: 'Korku: Yetersizlik. Ders: Kendinize guvenmeyi ogrenmek.',
      2: 'Korku: Catisma. Ders: Kendi ihtiyaclarinizi da ifade etmek.',
      3: 'Korku: Elestiri. Ders: Yaraticilikla korkmadan paylasmak.',
      4: 'Korku: Karmasiklik. Ders: Duzen ve sistem olusturmak.',
      5: 'Korku: Sikisip kalmak. Ders: Saglikli degisim bulmak.',
      6: 'Korku: Basarisizlik. Ders: Mukemmelin dusmani iyidir.',
      7: 'Korku: Aldatilmak. Ders: Saglikli suphecilik ve inanc dengesi.',
      8: 'Korku: Basarisizlik/iflas. Ders: Gucle saglikli iliski.',
    };
    return descriptions[number] ?? '';
  }

  static String _getChallengeAdvice(int number) {
    final advice = {
      0: 'Hayatin tum derslerine açik olun. Her an bir ogretmendir.',
      1: 'Kendi fikirlerinize deger verin. Liderlige adim atin.',
      2: 'Sinir koymayı ogrenmek. Hayir demek de sevgidir.',
      3: 'Mükemmel olmak zorunda değilsiniz. Paylasin ve buyuyun.',
      4: 'Kucuk adimlarla baslayın. Her gun biraz ilerleme.',
      5: 'Saglikli degisim bulun. Macerayi sorumlulukla birleştirin.',
      6: 'Kendinize de şefkat gosterin. Baskalari kadar onemlisiniz.',
      7: 'Sezgilerinize guvenin ama dogrulayin. Inanc ve akil birlikte.',
      8: 'Para bir araç, amaç değil. Değeriniz başarınızdan bağımsız.',
    };
    return advice[number] ?? 'Icsel rehberliginizi dinleyin.';
  }

  /// Get current Pinnacle for an age
  static Pinnacle? getCurrentPinnacle(DateTime birthDate, int currentAge) {
    final pinnacles = calculatePinnacles(birthDate);
    for (final pinnacle in pinnacles) {
      if (pinnacle.isActive(currentAge)) {
        return pinnacle;
      }
    }
    return pinnacles.isNotEmpty ? pinnacles.last : null;
  }

  /// Get current Challenge for an age
  static Challenge? getCurrentChallenge(DateTime birthDate, int currentAge) {
    final challenges = calculateChallenges(birthDate);
    for (final challenge in challenges) {
      if (challenge.isActive(currentAge)) {
        return challenge;
      }
    }
    return challenges.isNotEmpty ? challenges.last : null;
  }

  // ==========================================================================
  // NAME ANALYSIS
  // ==========================================================================

  /// Analyze name using Pythagorean grid (Lo Shu grid concept)
  static Map<String, int> analyzeNameGrid(
    String fullName, {
    bool chaldean = false,
  }) {
    final name = _normalizeNameForCalculation(fullName);
    final grid = <String, int>{
      'mental': 0, // 1, 2, 3 - Mental plane
      'emotional': 0, // 4, 5, 6 - Emotional plane
      'physical': 0, // 7, 8, 9 - Physical plane
      'will': 0, // 1, 5, 9 - Will/Determination
      'intuition': 0, // 2, 5, 8 - Intuition/Balance
      'creativity': 0, // 3, 5, 7 - Creativity/Spirituality
    };

    for (final char in name.split('')) {
      final value = getLetterValue(char, chaldean: chaldean);

      // Planes
      if ([1, 2, 3].contains(value)) grid['mental'] = grid['mental']! + 1;
      if ([4, 5, 6].contains(value)) grid['emotional'] = grid['emotional']! + 1;
      if ([7, 8, 9].contains(value)) grid['physical'] = grid['physical']! + 1;

      // Diagonals
      if ([1, 5, 9].contains(value)) grid['will'] = grid['will']! + 1;
      if ([3, 5, 7].contains(value)) {
        grid['creativity'] = grid['creativity']! + 1;
      }
      if ([2, 5, 8].contains(value)) grid['intuition'] = grid['intuition']! + 1;
    }

    return grid;
  }

  /// Get missing numbers in the name (1-9)
  static List<int> getMissingNumbers(String fullName, {bool chaldean = false}) {
    final frequency = getNumberFrequency(fullName, chaldean: chaldean);
    final missing = <int>[];

    for (var i = 1; i <= 9; i++) {
      if (!frequency.containsKey(i) || frequency[i] == 0) {
        missing.add(i);
      }
    }

    return missing;
  }

  /// Get frequency of each number in the name
  static Map<int, int> getNumberFrequency(
    String fullName, {
    bool chaldean = false,
  }) {
    final name = _normalizeNameForCalculation(fullName);
    final frequency = <int, int>{};

    for (final char in name.split('')) {
      final value = getLetterValue(char, chaldean: chaldean);
      if (value > 0) {
        frequency[value] = (frequency[value] ?? 0) + 1;
      }
    }

    return frequency;
  }

  /// Get the intensity of each number (how many times it appears)
  static Map<int, String> getNumberIntensities(
    String fullName, {
    bool chaldean = false,
  }) {
    final frequency = getNumberFrequency(fullName, chaldean: chaldean);
    final intensities = <int, String>{};

    frequency.forEach((number, count) {
      if (count == 0) {
        intensities[number] = 'Eksik';
      } else if (count == 1) {
        intensities[number] = 'Normal';
      } else if (count == 2) {
        intensities[number] = 'Guclu';
      } else if (count >= 3) {
        intensities[number] = 'Cok Guclu';
      }
    });

    // Add missing numbers
    for (var i = 1; i <= 9; i++) {
      if (!intensities.containsKey(i)) {
        intensities[i] = 'Eksik';
      }
    }

    return intensities;
  }

  // ==========================================================================
  // COMPATIBILITY
  // ==========================================================================

  /// Calculate basic compatibility score between two numbers
  static int calculateCompatibilityScore(int number1, int number2) {
    // Reduce master numbers for base comparison
    final n1 = _reduceToSingleDigit(number1);
    final n2 = _reduceToSingleDigit(number2);

    // Same numbers
    if (n1 == n2) return 95;

    // Define compatibility matrix
    final highCompatibility = {
      1: [1, 3, 5, 7, 9],
      2: [2, 4, 6, 8],
      3: [1, 3, 5, 6, 9],
      4: [2, 4, 6, 8],
      5: [1, 3, 5, 7, 9],
      6: [2, 3, 4, 6, 9],
      7: [1, 5, 7],
      8: [2, 4, 8],
      9: [1, 3, 5, 6, 9],
    };

    final mediumCompatibility = {
      1: [2, 4, 8],
      2: [1, 3, 5, 9],
      3: [2, 4, 7, 8],
      4: [1, 3, 5, 7, 9],
      5: [2, 4, 6, 8],
      6: [1, 5, 7, 8],
      7: [2, 3, 4, 6, 8, 9],
      8: [1, 3, 5, 6, 7, 9],
      9: [2, 4, 7, 8],
    };

    // Master number bonus
    var bonus = 0;
    if (isMasterNumber(number1) && isMasterNumber(number2)) bonus = 10;
    if (number1 == 11 && number2 == 22) bonus = 15;
    if (number1 == 22 && number2 == 11) bonus = 15;

    if (highCompatibility[n1]?.contains(n2) ?? false) {
      return 85 + bonus;
    }
    if (mediumCompatibility[n1]?.contains(n2) ?? false) {
      return 65 + bonus;
    }

    return 45 + bonus;
  }

  /// Get detailed compatibility report between two people
  static CompatibilityReport getDetailedCompatibility(
    DateTime birthDate1,
    String name1,
    DateTime birthDate2,
    String name2, {
    bool chaldean = false,
  }) {
    // Calculate all numbers for both people
    final lifePath1 = calculateLifePath(birthDate1);
    final lifePath2 = calculateLifePath(birthDate2);
    final expression1 = calculateExpression(name1, chaldean: chaldean);
    final expression2 = calculateExpression(name2, chaldean: chaldean);
    final soulUrge1 = calculateSoulUrge(name1, chaldean: chaldean);
    final soulUrge2 = calculateSoulUrge(name2, chaldean: chaldean);
    final personality1 = calculatePersonality(name1, chaldean: chaldean);
    final personality2 = calculatePersonality(name2, chaldean: chaldean);

    // Calculate individual compatibility scores
    final lifePathScore = calculateCompatibilityScore(lifePath1, lifePath2);
    final expressionScore = calculateCompatibilityScore(
      expression1,
      expression2,
    );
    final soulUrgeScore = calculateCompatibilityScore(soulUrge1, soulUrge2);
    final personalityScore = calculateCompatibilityScore(
      personality1,
      personality2,
    );

    // Weighted average for overall score
    final overallScore =
        ((lifePathScore * 0.35) +
                (soulUrgeScore * 0.30) +
                (expressionScore * 0.20) +
                (personalityScore * 0.15))
            .round();

    // Generate compatibility descriptions
    final lifePathCompatibility = _getLifePathCompatibilityDescription(
      lifePath1,
      lifePath2,
    );
    final expressionCompatibility = _getExpressionCompatibilityDescription(
      expression1,
      expression2,
    );
    final soulUrgeCompatibility = _getSoulUrgeCompatibilityDescription(
      soulUrge1,
      soulUrge2,
    );
    final personalityCompatibility = _getPersonalityCompatibilityDescription(
      personality1,
      personality2,
    );

    // Identify strengths and challenges
    final strengths = _identifyRelationshipStrengths(
      lifePath1,
      lifePath2,
      expression1,
      expression2,
      soulUrge1,
      soulUrge2,
    );
    final challenges = _identifyRelationshipChallenges(
      lifePath1,
      lifePath2,
      expression1,
      expression2,
      soulUrge1,
      soulUrge2,
    );
    final advice = _generateRelationshipAdvice(overallScore, challenges);

    return CompatibilityReport(
      overallScore: overallScore,
      lifePathCompatibility: lifePathCompatibility,
      expressionCompatibility: expressionCompatibility,
      soulUrgeCompatibility: soulUrgeCompatibility,
      personalityCompatibility: personalityCompatibility,
      strengths: strengths,
      challenges: challenges,
      advice: advice,
      categoryScores: {
        'lifePath': lifePathScore,
        'expression': expressionScore,
        'soulUrge': soulUrgeScore,
        'personality': personalityScore,
      },
    );
  }

  static String _getLifePathCompatibilityDescription(int lp1, int lp2) {
    final score = calculateCompatibilityScore(lp1, lp2);
    if (score >= 90) {
      return 'Yasam yollariniz muhtesem bir uyum icinde. Ayni yonde ilerliyorsunuz.';
    } else if (score >= 75) {
      return 'Yasam yollariniz birbirini destekliyor. Birlikte buyuyebilirsiniz.';
    } else if (score >= 60) {
      return 'Farkli yasam yollari, ama ogrenme potansiyeli yuksek.';
    }
    return 'Farkli yasam yollari zorluklar yaratabilir, ama anlayisla asabilirsiniz.';
  }

  static String _getExpressionCompatibilityDescription(int e1, int e2) {
    final score = calculateCompatibilityScore(e1, e2);
    if (score >= 90) {
      return 'Yetenekleriniz ve ifade sekliniz mukemmel uyumlu.';
    } else if (score >= 75) {
      return 'Birbirinizin yeteneklerini tamamliyorsunuz.';
    } else if (score >= 60) {
      return 'Farkli yetenekler zenginlik yaratabilir.';
    }
    return 'Ifade farkliliklari iletisimde dikkat gerektirir.';
  }

  static String _getSoulUrgeCompatibilityDescription(int s1, int s2) {
    final score = calculateCompatibilityScore(s1, s2);
    if (score >= 90) {
      return 'Ic dunyalariniz ve derin arzulariniz ayni titresimde.';
    } else if (score >= 75) {
      return 'Ruhsal baglantiiniz guclu, birbirinizi anliyorsunuz.';
    } else if (score >= 60) {
      return 'Farkli ic dunyalar, ama empati ile koprü kurabilirsiniz.';
    }
    return 'Derin istekleriniz farkli, sabir ve anlayis gerekli.';
  }

  static String _getPersonalityCompatibilityDescription(int p1, int p2) {
    final score = calculateCompatibilityScore(p1, p2);
    if (score >= 90) {
      return 'Dis dünyaya ayni enerjiyi yansitiyorsunuz.';
    } else if (score >= 75) {
      return 'Kisilikleriniz birbirini tamamliyor.';
    } else if (score >= 60) {
      return 'Farkli kisilikler ilginc bir dinamik yaratiyor.';
    }
    return 'Kisilik farkliliklari anlayis gerektiriyor.';
  }

  static List<String> _identifyRelationshipStrengths(
    int lp1,
    int lp2,
    int e1,
    int e2,
    int s1,
    int s2,
  ) {
    final strengths = <String>[];

    if (lp1 == lp2) {
      strengths.add('Ayni yasam yolunu paylasiyorsunuz - derin anlayis');
    }
    if (s1 == s2) {
      strengths.add('Kalp arzulariniz ayni - ruhsal bag');
    }
    if (calculateCompatibilityScore(lp1, lp2) >= 85) {
      strengths.add('Yasam hedefleriniz uyumlu');
    }
    if (calculateCompatibilityScore(s1, s2) >= 85) {
      strengths.add('Duygusal ihtiyaclariniz ortusüyor');
    }

    // Complementary energies
    if ((lp1 == 1 && lp2 == 2) || (lp1 == 2 && lp2 == 1)) {
      strengths.add('Liderlik ve destek dengesi');
    }
    if ((lp1 == 3 && lp2 == 4) || (lp1 == 4 && lp2 == 3)) {
      strengths.add('Yaraticilik ve pratiklik birligi');
    }
    if ((lp1 == 5 && lp2 == 6) || (lp1 == 6 && lp2 == 5)) {
      strengths.add('Macera ve yuva dengesi');
    }

    if (strengths.isEmpty) {
      strengths.add('Birbirinizden ogrenme firsati');
    }

    return strengths;
  }

  static List<String> _identifyRelationshipChallenges(
    int lp1,
    int lp2,
    int e1,
    int e2,
    int s1,
    int s2,
  ) {
    final challenges = <String>[];

    if (calculateCompatibilityScore(lp1, lp2) < 60) {
      challenges.add('Farkli yasam yonleri - uzlasma gerekli');
    }
    if (calculateCompatibilityScore(s1, s2) < 60) {
      challenges.add('Farkli duygusal ihtiyaclar - empati onemli');
    }

    // Challenging combinations
    if ((lp1 == 4 && lp2 == 5) || (lp1 == 5 && lp2 == 4)) {
      challenges.add('Stabilite vs degisim gerilimi');
    }
    if ((lp1 == 1 && lp2 == 8) || (lp1 == 8 && lp2 == 1)) {
      challenges.add('Guc mucadelesi potansiyeli');
    }
    if ((lp1 == 7 && lp2 == 3) || (lp1 == 3 && lp2 == 7)) {
      challenges.add('Icsel vs disal odak farki');
    }

    if (challenges.isEmpty) {
      challenges.add('Buyuk zorluklar yok - kucuk farkliliklara dikkat');
    }

    return challenges;
  }

  static List<String> _generateRelationshipAdvice(
    int overallScore,
    List<String> challenges,
  ) {
    final advice = <String>[];

    if (overallScore >= 85) {
      advice.add('Bu uyum nadir - degeri bilin ve koruyun.');
      advice.add('Birlikte buyumeye devam edin.');
    } else if (overallScore >= 70) {
      advice.add('Guclu bir temel var - uzerine insa edin.');
      advice.add('Farkliliklarinizi zenginlik olarak gorun.');
    } else if (overallScore >= 55) {
      advice.add('Iletisim anahtariniz - acik konusun.');
      advice.add('Birbirinizin ihtiyaçlarini anlamaya calisin.');
    } else {
      advice.add('Zorlu ama imkansiz degil - sabir gerekli.');
      advice.add('Profesyonel destek dusunebilirsiniz.');
    }

    advice.add('Her iliski calisma gerektirir - birlikte buyuyun.');

    return advice;
  }

  // ==========================================================================
  // BUSINESS/NAME SELECTION
  // ==========================================================================

  /// Calculate the numerology number for a business name
  static int calculateBusinessNumber(
    String businessName, {
    bool chaldean = false,
  }) {
    return calculateExpression(businessName, chaldean: chaldean);
  }

  /// Check if a business name number is favorable for a specific purpose
  static Map<String, dynamic> analyzeBusinessName(
    String businessName, {
    bool chaldean = false,
  }) {
    final number = calculateBusinessNumber(businessName, chaldean: chaldean);

    final analysis = {
      'number': number,
      'favorable': <String>[],
      'challenges': <String>[],
      'industries': <String>[],
      'rating': 0,
    };

    switch (_reduceToSingleDigit(number)) {
      case 1:
        analysis['favorable'] = ['Liderlik', 'Yenilik', 'Bagimsiz calisma'];
        analysis['challenges'] = ['Isbirligi gereken isler'];
        analysis['industries'] = ['Teknoloji', 'Danismanlik', 'Spor'];
        analysis['rating'] = 85;
        break;
      case 2:
        analysis['favorable'] = ['Ortaklik', 'Musteri hizmetleri', 'Diplomasi'];
        analysis['challenges'] = ['Agresif pazarlama'];
        analysis['industries'] = ['HR', 'Terapi', 'Arabuluculuk'];
        analysis['rating'] = 75;
        break;
      case 3:
        analysis['favorable'] = ['Yaraticilik', 'Iletisim', 'Eglence'];
        analysis['challenges'] = ['Teknik isler'];
        analysis['industries'] = ['Reklam', 'Sanat', 'Medya'];
        analysis['rating'] = 90;
        break;
      case 4:
        analysis['favorable'] = ['Stabilite', 'Goven', 'Uzun vadeli'];
        analysis['challenges'] = ['Hizli degisim gereken isler'];
        analysis['industries'] = ['Insaat', 'Finans', 'Uretim'];
        analysis['rating'] = 80;
        break;
      case 5:
        analysis['favorable'] = ['Degisim', 'Seyahat', 'Iletisim'];
        analysis['challenges'] = ['Rutin isler'];
        analysis['industries'] = ['Turizm', 'Medya', 'Satis'];
        analysis['rating'] = 85;
        break;
      case 6:
        analysis['favorable'] = ['Hizmet', 'Bakim', 'Estetik'];
        analysis['challenges'] = ['Agresif rekabet'];
        analysis['industries'] = ['Saglik', 'Guzellik', 'Egitim'];
        analysis['rating'] = 85;
        break;
      case 7:
        analysis['favorable'] = ['Arastirma', 'Analiz', 'Uzmanlik'];
        analysis['challenges'] = ['Kitle pazarlama'];
        analysis['industries'] = ['Arastirma', 'Teknoloji', 'Egitim'];
        analysis['rating'] = 70;
        break;
      case 8:
        analysis['favorable'] = ['Finans', 'Guc', 'Buyuk olcek'];
        analysis['challenges'] = ['Kucuk nicler'];
        analysis['industries'] = ['Finans', 'Gayrimenkul', 'Kurumsal'];
        analysis['rating'] = 95;
        break;
      case 9:
        analysis['favorable'] = ['Insani degerler', 'Global', 'Sanat'];
        analysis['challenges'] = ['Sadece kar odakli isler'];
        analysis['industries'] = ['STK', 'Sanat', 'Uluslararasi'];
        analysis['rating'] = 80;
        break;
    }

    // Master number bonuses
    if (isMasterNumber(number)) {
      (analysis['favorable'] as List).add(
        'Master sayi enerjisi - yuksek potansiyel',
      );
      analysis['rating'] = (analysis['rating'] as int) + 10;
    }

    return analysis;
  }

  /// Suggest modifications to make a name reach a desired number
  static List<String> suggestLuckyNames(
    int desiredNumber,
    String baseName, {
    bool chaldean = false,
  }) {
    final suggestions = <String>[];
    final currentNumber = calculateExpression(baseName, chaldean: chaldean);

    if (_reduceToSingleDigit(currentNumber) ==
        _reduceToSingleDigit(desiredNumber)) {
      suggestions.add('$baseName zaten istenen sayiya sahip!');
      return suggestions;
    }

    // Calculate what value we need to add
    final currentSum = _calculateNameSum(baseName, chaldean: chaldean);
    final targetRemainder = desiredNumber % 9;
    final currentRemainder = currentSum % 9;
    var neededValue = (targetRemainder - currentRemainder + 9) % 9;
    if (neededValue == 0) neededValue = 9;

    // Find letters that match the needed value
    final matchingLetters = <String>[];
    final values = chaldean ? chaldeanValues : pythagoreanValues;

    values.forEach((letter, value) {
      if (value == neededValue && !letter.contains(RegExp(r'[^A-Z]'))) {
        matchingLetters.add(letter);
      }
    });

    // Generate suggestions
    for (final letter in matchingLetters.take(5)) {
      suggestions.add('$baseName$letter');
      suggestions.add('$letter$baseName');
    }

    // Double letter suggestions
    for (final letter in matchingLetters.take(3)) {
      final doubleValue = (neededValue * 2) % 9;
      if (doubleValue == neededValue || doubleValue == 0) {
        suggestions.add('$baseName$letter$letter');
      }
    }

    return suggestions.take(10).toList();
  }

  static int _calculateNameSum(String name, {bool chaldean = false}) {
    final normalized = _normalizeNameForCalculation(name);
    var sum = 0;
    for (final char in normalized.split('')) {
      sum += getLetterValue(char, chaldean: chaldean);
    }
    return sum;
  }

  // ==========================================================================
  // LUCKY NUMBERS
  // ==========================================================================

  /// Get lucky numbers based on birth date and name
  static List<int> getLuckyNumbers(
    DateTime birthDate,
    String name, {
    bool chaldean = false,
  }) {
    final luckyNumbers = <int>{};

    // Life Path is always lucky
    luckyNumbers.add(calculateLifePath(birthDate));

    // Expression number
    luckyNumbers.add(calculateExpression(name, chaldean: chaldean));

    // Soul Urge
    luckyNumbers.add(calculateSoulUrge(name, chaldean: chaldean));

    // Birthday number
    luckyNumbers.add(calculateBirthday(birthDate.day));

    // Maturity number
    final maturity = calculateMaturity(
      calculateLifePath(birthDate),
      calculateExpression(name, chaldean: chaldean),
    );
    luckyNumbers.add(maturity);

    // Add complementary numbers
    final lifePath = calculateLifePath(birthDate);
    final complementary = _getComplementaryNumbers(lifePath);
    luckyNumbers.addAll(complementary);

    // Remove any that reduced to 0
    luckyNumbers.remove(0);

    return luckyNumbers.toList()..sort();
  }

  /// Get daily lucky numbers
  static List<int> getDailyLuckyNumbers(
    DateTime birthDate,
    DateTime currentDate, {
    String? name,
    bool chaldean = false,
  }) {
    final luckyNumbers = <int>{};

    // Personal day number
    final personalYear = calculatePersonalYear(birthDate, currentDate.year);
    final personalMonth = calculatePersonalMonth(
      personalYear,
      currentDate.month,
    );
    final personalDay = calculatePersonalDay(personalMonth, currentDate.day);
    luckyNumbers.add(personalDay);

    // Universal day number
    final universalDay = calculateUniversalDay(
      currentDate.year,
      currentDate.month,
      currentDate.day,
    );
    luckyNumbers.add(universalDay);

    // Life Path always lucky
    luckyNumbers.add(calculateLifePath(birthDate));

    // Day of the week number (1-7)
    final dayOfWeek = currentDate.weekday;
    luckyNumbers.add(dayOfWeek);

    // Combine personal and universal for synergy number
    final synergyNumber = _reduceToSingleDigit(personalDay + universalDay);
    luckyNumbers.add(synergyNumber);

    // If name provided, add expression
    if (name != null) {
      luckyNumbers.add(calculateExpression(name, chaldean: chaldean));
    }

    luckyNumbers.remove(0);
    return luckyNumbers.toList()..sort();
  }

  static List<int> _getComplementaryNumbers(int number) {
    final complementary = {
      1: [3, 5, 7],
      2: [4, 6, 8],
      3: [1, 5, 9],
      4: [2, 6, 8],
      5: [1, 3, 7],
      6: [2, 4, 9],
      7: [1, 5, 9],
      8: [2, 4, 6],
      9: [3, 6, 7],
      11: [2, 4, 22],
      22: [4, 11, 33],
      33: [6, 11, 22],
    };

    return complementary[number] ?? [1, 5, 9];
  }

  // ==========================================================================
  // FORECASTS
  // ==========================================================================

  /// Get daily forecast
  static NumerologyForecast getDailyForecast(
    DateTime birthDate,
    DateTime date, {
    String? name,
  }) {
    final personalYear = calculatePersonalYear(birthDate, date.year);
    final personalMonth = calculatePersonalMonth(personalYear, date.month);
    final personalDay = calculatePersonalDay(personalMonth, date.day);

    return _generateForecast(
      personalNumber: personalDay,
      periodType: 'daily',
      birthDate: birthDate,
      date: date,
      name: name,
    );
  }

  /// Get weekly forecast
  static NumerologyForecast getWeeklyForecast(
    DateTime birthDate,
    DateTime weekStart, {
    String? name,
  }) {
    final personalYear = calculatePersonalYear(birthDate, weekStart.year);
    final personalMonth = calculatePersonalMonth(personalYear, weekStart.month);

    // Week number calculation
    final weekNumber = ((weekStart.day - 1) ~/ 7) + 1;
    final weekEnergy = _reduceToSingleDigit(personalMonth + weekNumber);

    return _generateForecast(
      personalNumber: weekEnergy,
      periodType: 'weekly',
      birthDate: birthDate,
      date: weekStart,
      name: name,
    );
  }

  /// Get monthly forecast
  static NumerologyForecast getMonthlyForecast(
    DateTime birthDate,
    int year,
    int month, {
    String? name,
  }) {
    final personalYear = calculatePersonalYear(birthDate, year);
    final personalMonth = calculatePersonalMonth(personalYear, month);

    return _generateForecast(
      personalNumber: personalMonth,
      periodType: 'monthly',
      birthDate: birthDate,
      date: DateTime(year, month),
      name: name,
    );
  }

  /// Get yearly forecast
  static NumerologyForecast getYearlyForecast(
    DateTime birthDate,
    int year, {
    String? name,
  }) {
    final personalYear = calculatePersonalYear(birthDate, year);

    return _generateForecast(
      personalNumber: personalYear,
      periodType: 'yearly',
      birthDate: birthDate,
      date: DateTime(year),
      name: name,
    );
  }

  static NumerologyForecast _generateForecast({
    required int personalNumber,
    required String periodType,
    required DateTime birthDate,
    required DateTime date,
    String? name,
  }) {
    final themes = {
      1: 'Yeni Baslangiçlar',
      2: 'Isbirligi ve Sabir',
      3: 'Yaraticilik ve Ifade',
      4: 'Insaat ve Temel Atma',
      5: 'Degisim ve Ozgurluk',
      6: 'Sorumluluk ve Aile',
      7: 'Icsel Arayis',
      8: 'Basari ve Guc',
      9: 'Tamamlanma ve Birakma',
      11: 'Spiritüel Uyanis',
      22: 'Buyuk Vizyon',
      33: 'Evrensel Sifa',
    };

    final generalAdvices = {
      1: 'Yeni projelere baslamak icin mukemmel bir zaman. Liderlik alin.',
      2: 'Sabir ve diplomasi gerekli. Iliskilere odaklanin.',
      3: 'Yaraticiligizi ifade edin. Sosyallesmek icin ideal.',
      4: 'Siki calisma zamani. Temeller atin, detaylara dikkat edin.',
      5: 'Degisime acik olun. Seyahat ve yeni deneyimler icin uygun.',
      6: 'Aile ve sorumluluklar on planda. Ev isleri ve bakim.',
      7: 'Kendinize vakit ayin. Meditasyon ve arastirma zamani.',
      8: 'Is ve kariyer on planda. Finansal firsatlar mevcut.',
      9: 'Birakma ve tamamlama zamani. Eski donguler kapaniyor.',
      11: 'Sezgilerinize guvenin. Spiritüel icgörüler mümkün.',
      22: 'Buyuk hedefler icin planlama zamani.',
      33: 'Sifa ve ogretmenlik enerjisi guclu.',
    };

    final loveAdvices = {
      1: 'Bagimsizliginizi koruyun ama kalpleri de dinleyin.',
      2: 'Romantizm icin mukemmel. Uyum ve anlayis on planda.',
      3: 'Eglence ve flort zamani. Iletisim anahtariniz.',
      4: 'Guvenilirlik onemli. Uzun vadeli dusunun.',
      5: 'Heyecan ve macera isteyen bir enerji.',
      6: 'Baglililik ve aile kurmak icin uygun.',
      7: 'Derin baglantilar arayin. Yalnizlik da iyilestirir.',
      8: 'Güclü partnerler cekersiniz.',
      9: 'Eski iliskileri birakma zamani olabilir.',
      11: 'Ruh esi enerjisi aktif.',
      22: 'Buyuk vizyon paylasan partnerler.',
      33: 'Kosulsuz sevgi akisi.',
    };

    final careerAdvices = {
      1: 'Yeni girisimler icin ideal. Liderlik alin.',
      2: 'Isbirligi projeleri basarili olur.',
      3: 'Yaratici projeler ve sunum zamani.',
      4: 'Detayli calisma ve planlama.',
      5: 'Degisiklik zamani - yeni firsatlar.',
      6: 'Takim calismasi ve mentorlluk.',
      7: 'Arastirma ve analiz projeleri.',
      8: 'Terfi ve finansal kazanc mümkün.',
      9: 'Projeleri tamamlama ve yeni baslangica hazirllik.',
      11: 'Ilham veren liderlik.',
      22: 'Buyuk ölcekli projeler.',
      33: 'Ogretme ve paylasma.',
    };

    final healthAdvices = {
      1: 'Enerjiniz yuksek. Fiziksel aktivite iyi gelir.',
      2: 'Stres yonetimi onemli. Dinlenin.',
      3: 'Sosyal aktiviteler ruh sagligi icin iyi.',
      4: 'Rutin olusturun. Düzenli beslenme.',
      5: 'Hareketli kalin. Sinirli hissetmeyin.',
      6: 'Ev ortami ve beslenme on planda.',
      7: 'Medidasyon ve mental saglik.',
      8: 'Is-yasam dengesi kritik.',
      9: 'Detoks ve temizlik zamani.',
      11: 'Sinir sistemi hassas - dinlenin.',
      22: 'Fiziksel ve mental denge.',
      33: 'Sifa enerjisi guclu - kendine de ver.',
    };

    final number = _reduceToSingleDigit(personalNumber);
    final displayNumber = isMasterNumber(personalNumber)
        ? personalNumber
        : number;

    // Generate lucky days based on period type
    List<String> luckyDays;
    if (periodType == 'daily') {
      luckyDays = ['Bugun sans sizinle!'];
    } else if (periodType == 'weekly') {
      luckyDays = _getWeeklyLuckyDays(number);
    } else if (periodType == 'monthly') {
      luckyDays = _getMonthlyLuckyDays(number, date.year, date.month);
    } else {
      luckyDays = _getYearlyLuckyMonths(number);
    }

    return NumerologyForecast(
      personalNumber: displayNumber,
      theme: themes[displayNumber] ?? 'Ozel Donen',
      generalAdvice:
          generalAdvices[displayNumber] ?? 'Icsel rehberliginizi dinleyin.',
      loveAdvice: loveAdvices[displayNumber] ?? 'Kalbiizi dinleyin.',
      careerAdvice: careerAdvices[displayNumber] ?? 'Hedeflerinize odaklanin.',
      healthAdvice: healthAdvices[displayNumber] ?? 'Dengenizi koruyun.',
      financialAdvice: _getFinancialAdvice(displayNumber),
      spiritualAdvice: _getSpiritualAdvice(displayNumber),
      luckyNumbers: getDailyLuckyNumbers(birthDate, date, name: name),
      luckyDays: luckyDays,
      favorableActivities: _getFavorableActivities(displayNumber),
      challengesToWatch: _getChallengesToWatch(displayNumber),
      affirmation: _getAffirmation(displayNumber),
    );
  }

  static String _getFinancialAdvice(int number) {
    final advices = {
      1: 'Yeni yatirimlar icin cesaret gosterin.',
      2: 'Ortaklik yatirimlari uygun.',
      3: 'Yaratici projelerden kazanc mümkün.',
      4: 'Uzun vadeli ve guvenli yatirimlar.',
      5: 'Cesitlilik onemli - risk dagitin.',
      6: 'Gayrimenkul ve aile yatirimlari.',
      7: 'Arastirin, acele etmeyin.',
      8: 'Buyuk firsatlar donemi!',
      9: 'Hayirseverlik ve birakma.',
      11: 'Sezgisel yatirimlar.',
      22: 'Buyuk ölcekli yatirimlar.',
      33: 'Deger odakli yatirimlar.',
    };
    return advices[number] ?? 'Dikkatli ve bilinçli olun.';
  }

  static String _getSpiritualAdvice(int number) {
    final advices = {
      1: 'Bireysel meditasyon ve niyetlenme.',
      2: 'Grup meditasyonu ve yoga.',
      3: 'Yaratici ifade ile spiritüellik.',
      4: 'Disiplinli pratik olusturun.',
      5: 'Yeni spiritüel yollar kesferin.',
      6: 'Hizmet yoluyla spiritüellik.',
      7: 'Derin meditasyon ve arastirma.',
      8: 'Manifestasyon pratikleri.',
      9: 'Birakma ve kabul meditasyonu.',
      11: 'Sezgisel gelisim.',
      22: 'Vizyon kurma pratikleri.',
      33: 'Sifa meditasyonlari.',
    };
    return advices[number] ?? 'Gunluk meditasyon yapin.';
  }

  static List<String> _getWeeklyLuckyDays(int number) {
    final dayMappings = {
      1: ['Pazar', 'Sali'],
      2: ['Pazartesi', 'Cuma'],
      3: ['Carsamba', 'Persembe'],
      4: ['Cumartesi', 'Pazar'],
      5: ['Carsamba', 'Cuma'],
      6: ['Cuma', 'Pazartesi'],
      7: ['Pazartesi', 'Cumartesi'],
      8: ['Cumartesi', 'Persembe'],
      9: ['Sali', 'Carsamba'],
    };
    return dayMappings[number] ?? ['Pazartesi', 'Cuma'];
  }

  static List<String> _getMonthlyLuckyDays(int number, int year, int month) {
    // Return days of the month that match the personal number
    final luckyDays = <String>[];
    final daysInMonth = DateTime(year, month + 1, 0).day;

    for (var day = 1; day <= daysInMonth; day++) {
      final dayNumber = _reduceToSingleDigit(day);
      if (dayNumber == number || _reduceToSingleDigit(day + number) == number) {
        luckyDays.add('$day. gun');
      }
    }

    return luckyDays.take(5).toList();
  }

  static List<String> _getYearlyLuckyMonths(int number) {
    final months = [
      'Ocak',
      'Subat',
      'Mart',
      'Nisan',
      'Mayis',
      'Haziran',
      'Temmuz',
      'Agustos',
      'Eylul',
      'Ekim',
      'Kasim',
      'Aralik',
    ];
    final luckyMonths = <String>[];

    for (var i = 0; i < 12; i++) {
      final monthNumber = _reduceToSingleDigit(i + 1);
      if (monthNumber == number ||
          _reduceToSingleDigit(monthNumber + number) == number) {
        luckyMonths.add(months[i]);
      }
    }

    return luckyMonths.isEmpty ? [(months[number - 1])] : luckyMonths;
  }

  static List<String> _getFavorableActivities(int number) {
    final activities = {
      1: ['Yeni projelere baslamak', 'Liderlik almak', 'Girisimcilik'],
      2: ['Isbirligi', 'Muzakere', 'Iliskileri gelistirme'],
      3: ['Yaratici projeler', 'Sosyallesme', 'Sanatsal ifade'],
      4: ['Planlama', 'Organizasyon', 'Detayli calisma'],
      5: ['Seyahat', 'Yeni deneyimler', 'Degisim yapma'],
      6: ['Aile aktiviteleri', 'Ev isleri', 'Bakim verme'],
      7: ['Medidasyon', 'Arastirma', 'Yalniz vakit'],
      8: ['Is görüsmeleri', 'Finansal kararlar', 'Kariyer hamleleri'],
      9: ['Hayirseverlik', 'Projeleri tamamlama', 'Eski baglari birakma'],
      11: ['Spiritüel calisma', 'Ilham alma', 'Sezgisel kararlar'],
      22: ['Buyuk projeleri planlama', 'Vizyon olusturma'],
      33: ['Ogretme', 'Sifa verme', 'Mentorlluk'],
    };
    return activities[number] ?? ['Icsel sesini dinle'];
  }

  static List<String> _getChallengesToWatch(int number) {
    final challenges = {
      1: ['Bencillik', 'Sabırsızlık', 'Dinlememek'],
      2: ['Karsızlık', 'Asırı hassasiyet', 'Erteleme'],
      3: ['Dağınıklık', 'Yüzeysellik', 'Dedikodu'],
      4: ['Katılık', 'Iskoliklik', 'Kontrol ihtiyacı'],
      5: ['Huzursuzluk', 'Risk alma', 'Sorumsuzluk'],
      6: ['Mükemmeliyetçilik', 'Müdahalecilik', 'Kendini ihmal'],
      7: ['Izolasyon', 'Şüphecilik', 'Duygusal mesafe'],
      8: ['Açgözlülük', 'Güç mücadelesi', 'Insanlari ezmek'],
      9: ['Hayal kırıklığı', 'Bırakamama', 'Tükenmislik'],
      11: ['Aşırı hassasiyet', 'Sinir gerginliği', 'Pratiklik eksikliği'],
      22: ['Tükenmislik', 'Aşırı beklenti', 'Stres'],
      33: ['Fedakarlık kompleksi', 'Sınır koyamama'],
    };
    return challenges[number] ?? ['Dengede kalin'];
  }

  static String _getAffirmation(int number) {
    final affirmations = {
      1: 'Ben guclu ve bagimsizim. Kendi yolumu yaratiyorum.',
      2: 'Uyum ve baris icinde yasiyorum. Iliksilerim bereketli.',
      3: 'Yaraticiligimi ozgurce ifade ediyorum. Neseyim bulaşıcı.',
      4: 'Sagłam temeller olusturuyorum. Emeğim meyvesini veriyor.',
      5: 'Degisime açığım. Özgürce yasiyorum ve büyüyorum.',
      6: 'Sevgi veriyorum ve aliyorum. Ailem ve yuvam bereketli.',
      7: 'Icsel bilgeligimi dinliyorum. Gerçegi ariyorum ve buluyorum.',
      8: 'Bolluğu hak ediyorum. Gücümü bilgece kullaniyorum.',
      9: 'Kolayca birakiyorum. Evrensel sevgiyle hizmet ediyorum.',
      11: 'Ilhamim baska insanlara dokunuyor. Isikla doluym.',
      22: 'Buyuk vizyonlarimi gercege donusturuyorum.',
      33: 'Sifa enerjisi benimle akiyor. Evrensel sevgiyi taşıyorum.',
    };
    return affirmations[number] ?? 'Evrenle uyum içindeyim.';
  }

  // ==========================================================================
  // COMPLETE PROFILE
  // ==========================================================================

  /// Generate complete numerology profile
  static NumerologyProfile generateCompleteProfile(
    DateTime birthDate,
    String fullName, {
    bool chaldean = false,
  }) {
    final lifePath = calculateLifePath(birthDate);
    final expression = calculateExpression(fullName, chaldean: chaldean);
    final soulUrge = calculateSoulUrge(fullName, chaldean: chaldean);
    final personality = calculatePersonality(fullName, chaldean: chaldean);
    final birthday = calculateBirthday(birthDate.day);
    final maturity = calculateMaturity(lifePath, expression);
    final balance = calculateBalance(fullName, chaldean: chaldean);

    return NumerologyProfile(
      lifePath: lifePath,
      expression: expression,
      soulUrge: soulUrge,
      personality: personality,
      birthday: birthday,
      maturity: maturity,
      balance: balance,
      karmicDebts: getKarmicDebts(birthDate),
      karmicLessons: getKarmicLessons(fullName, chaldean: chaldean),
      pinnacles: calculatePinnacles(birthDate),
      challenges: calculateChallenges(birthDate),
      numberFrequency: getNumberFrequency(fullName, chaldean: chaldean),
      missingNumbers: getMissingNumbers(fullName, chaldean: chaldean),
      hasMasterNumber:
          isMasterNumber(lifePath) ||
          isMasterNumber(expression) ||
          isMasterNumber(soulUrge),
    );
  }
}
