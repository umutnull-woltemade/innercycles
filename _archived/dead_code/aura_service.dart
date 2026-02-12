import 'dart:ui';

import '../providers/app_providers.dart';
import 'l10n_service.dart';

/// Aura renk analizi servisi
class AuraService {
  /// Doğum tarihinden birincil aura rengini hesapla
  static AuraColor calculatePrimaryAura(DateTime birthDate) {
    final lifePathSum = _calculateLifePath(birthDate);
    return _auraFromLifePath(lifePathSum);
  }

  /// İsimden ikincil aura rengini hesapla
  static AuraColor calculateSecondaryAura(String name) {
    final sum = _calculateNameValue(name);
    final reduced = _reduceToSingleDigit(sum);
    return _auraFromNumber(reduced);
  }

  /// Tam aura profili oluştur
  static AuraProfile createAuraProfile({
    required DateTime birthDate,
    String? name,
    String? currentMood,
  }) {
    final primaryAura = calculatePrimaryAura(birthDate);
    AuraColor? secondaryAura;
    AuraColor? moodAura;

    if (name != null && name.isNotEmpty) {
      secondaryAura = calculateSecondaryAura(name);
    }

    if (currentMood != null) {
      moodAura = _getMoodAura(currentMood);
    }

    final chakraAlignment = _calculateChakraAlignment(birthDate);

    return AuraProfile(
      primaryColor: primaryAura,
      secondaryColor: secondaryAura,
      moodColor: moodAura,
      chakraAlignment: chakraAlignment,
      overallEnergy: _calculateOverallEnergy(primaryAura, secondaryAura),
      spiritualAdvice: _getSpiritualAdvice(primaryAura),
    );
  }

  /// Günlük aura enerjisi
  static DailyAuraEnergy getDailyAuraEnergy(
    DateTime birthDate,
    DateTime today,
  ) {
    final basePath = _calculateLifePath(birthDate);
    final todaySum =
        _digitSum(today.day) + _digitSum(today.month) + _digitSum(today.year);
    final combined = _reduceToSingleDigit(basePath + todaySum);

    final primaryAura = _auraFromLifePath(basePath);
    final todayAura = _auraFromNumber(combined);

    return DailyAuraEnergy(
      date: today,
      baseAura: primaryAura,
      todayAura: todayAura,
      energyLevel: _calculateEnergyLevel(basePath, combined),
      guidance: _getDailyGuidance(primaryAura, todayAura),
      affirmation: _getDailyAffirmation(todayAura),
    );
  }

  /// Aura temizleme önerileri
  static List<AuraCleansingTip> getCleansingTips(
    AuraColor aura, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final tips = <AuraCleansingTip>[];

    String getTipLocalized(String tipKey, String fallback) {
      final key = 'aura.cleansing_tips.$tipKey';
      final localized = L10nService.get(key, language);
      return localized != key ? localized : fallback;
    }

    final colorName = aura.localizedName(language);

    tips.add(
      AuraCleansingTip(
        title: getTipLocalized('meditation_title', 'Meditation'),
        description:
            getTipLocalized(
                  'meditation_desc',
                  'Meditate on ${aura.meditationFocus} for 10-15 minutes daily to strengthen your $colorName aura.',
                )
                .replaceAll('{color}', colorName)
                .replaceAll('{focus}', aura.localizedMeditationFocus(language)),
        icon: 'meditation',
      ),
    );

    tips.add(
      AuraCleansingTip(
        title: getTipLocalized('crystal_title', 'Crystal Therapy'),
        description: getTipLocalized(
          'crystal_desc',
          '${aura.recommendedCrystal} crystal is ideal for balancing your aura.',
        ).replaceAll('{crystal}', aura.localizedCrystal(language)),
        icon: 'crystal',
      ),
    );

    tips.add(
      AuraCleansingTip(
        title: getTipLocalized('color_title', 'Color Therapy'),
        description: getTipLocalized(
          'color_desc',
          'Wear clothes in $colorName tones or surround yourself with objects in this color.',
        ).replaceAll('{color}', colorName),
        icon: 'color',
      ),
    );

    tips.add(
      AuraCleansingTip(
        title: getTipLocalized('nature_title', 'Nature Connection'),
        description: aura.localizedNatureConnection(language),
        icon: 'nature',
      ),
    );

    tips.add(
      AuraCleansingTip(
        title: getTipLocalized('sound_title', 'Sound Therapy'),
        description:
            getTipLocalized(
                  'sound_desc',
                  'Listen to music at ${aura.soundFrequency} Hz frequency or chant the ${aura.chakra.mantras} mantra.',
                )
                .replaceAll('{frequency}', aura.soundFrequency.toString())
                .replaceAll('{mantra}', aura.chakra.mantras),
        icon: 'sound',
      ),
    );

    return tips;
  }

  static int _calculateLifePath(DateTime birthDate) {
    final day = _digitSum(birthDate.day);
    final month = _digitSum(birthDate.month);
    final year = _digitSum(birthDate.year);
    return _reduceToSingleDigitOrMaster(day + month + year);
  }

  static AuraColor _auraFromLifePath(int lifePath) {
    switch (lifePath) {
      case 1:
        return AuraColor.red;
      case 2:
        return AuraColor.blue;
      case 3:
        return AuraColor.yellow;
      case 4:
        return AuraColor.green;
      case 5:
        return AuraColor.orange;
      case 6:
        return AuraColor.pink;
      case 7:
        return AuraColor.indigo;
      case 8:
        return AuraColor.gold;
      case 9:
        return AuraColor.violet;
      case 11:
        return AuraColor.white;
      case 22:
        return AuraColor.gold;
      case 33:
        return AuraColor.violet;
      default:
        return AuraColor.white;
    }
  }

  static AuraColor _auraFromNumber(int number) {
    switch (number % 10) {
      case 1:
        return AuraColor.red;
      case 2:
        return AuraColor.blue;
      case 3:
        return AuraColor.yellow;
      case 4:
        return AuraColor.green;
      case 5:
        return AuraColor.orange;
      case 6:
        return AuraColor.pink;
      case 7:
        return AuraColor.indigo;
      case 8:
        return AuraColor.gold;
      case 9:
        return AuraColor.violet;
      case 0:
        return AuraColor.white;
      default:
        return AuraColor.white;
    }
  }

  static int _calculateNameValue(String name) {
    final cleanName = name.toUpperCase().replaceAll(
      RegExp(r'[^A-ZÇĞİÖŞÜ]'),
      '',
    );
    var sum = 0;
    for (final char in cleanName.split('')) {
      sum += _letterValue(char);
    }
    return sum;
  }

  static int _letterValue(String letter) {
    const values = {
      'A': 1,
      'B': 2,
      'C': 3,
      'Ç': 3,
      'D': 4,
      'E': 5,
      'F': 6,
      'G': 7,
      'Ğ': 7,
      'H': 8,
      'I': 9,
      'İ': 9,
      'J': 1,
      'K': 2,
      'L': 3,
      'M': 4,
      'N': 5,
      'O': 6,
      'Ö': 6,
      'P': 7,
      'Q': 8,
      'R': 9,
      'S': 1,
      'Ş': 1,
      'T': 2,
      'U': 3,
      'Ü': 3,
      'V': 4,
      'W': 5,
      'X': 6,
      'Y': 7,
      'Z': 8,
    };
    return values[letter] ?? 0;
  }

  static int _digitSum(int number) {
    var sum = 0;
    while (number > 0) {
      sum += number % 10;
      number ~/= 10;
    }
    return sum;
  }

  static int _reduceToSingleDigit(int number) {
    while (number > 9) {
      number = _digitSum(number);
    }
    return number;
  }

  static int _reduceToSingleDigitOrMaster(int number) {
    while (number > 9 && number != 11 && number != 22 && number != 33) {
      number = _digitSum(number);
    }
    return number > 9 ? _reduceToSingleDigit(number) : number;
  }

  static AuraColor _getMoodAura(String mood) {
    final moodLower = mood.toLowerCase();
    // Turkish and English mood keywords
    if (moodLower.contains('mutlu') ||
        moodLower.contains('neşeli') ||
        moodLower.contains('happy') ||
        moodLower.contains('joyful')) {
      return AuraColor.yellow;
    } else if (moodLower.contains('sakin') ||
        moodLower.contains('huzurlu') ||
        moodLower.contains('calm') ||
        moodLower.contains('peaceful')) {
      return AuraColor.blue;
    } else if (moodLower.contains('tutkulu') ||
        moodLower.contains('enerjik') ||
        moodLower.contains('passionate') ||
        moodLower.contains('energetic')) {
      return AuraColor.red;
    } else if (moodLower.contains('yaratıcı') ||
        moodLower.contains('ilhamlı') ||
        moodLower.contains('creative') ||
        moodLower.contains('inspired')) {
      return AuraColor.orange;
    } else if (moodLower.contains('sevgi') ||
        moodLower.contains('romantik') ||
        moodLower.contains('loving') ||
        moodLower.contains('romantic')) {
      return AuraColor.pink;
    } else if (moodLower.contains('spiritüel') ||
        moodLower.contains('derin') ||
        moodLower.contains('spiritual') ||
        moodLower.contains('deep')) {
      return AuraColor.violet;
    } else if (moodLower.contains('topraklanmış') ||
        moodLower.contains('güvende') ||
        moodLower.contains('grounded') ||
        moodLower.contains('safe')) {
      return AuraColor.green;
    }
    return AuraColor.white;
  }

  static Map<Chakra, int> _calculateChakraAlignment(DateTime birthDate) {
    final day = birthDate.day;
    final month = birthDate.month;

    return {
      Chakra.root: ((day + month) % 10) * 10 + 50,
      Chakra.sacral: ((day + 1) % 10) * 10 + 50,
      Chakra.solarPlexus: ((day + 2) % 10) * 10 + 50,
      Chakra.heart: ((day + 3) % 10) * 10 + 50,
      Chakra.throat: ((day + 4) % 10) * 10 + 50,
      Chakra.thirdEye: ((day + 5) % 10) * 10 + 50,
      Chakra.crown: ((day + 6) % 10) * 10 + 50,
    };
  }

  static int _calculateOverallEnergy(AuraColor primary, AuraColor? secondary) {
    var base = primary.baseEnergy;
    if (secondary != null) {
      // Uyumlu renkler enerjiyi artırır
      if (_areHarmoniousColors(primary, secondary)) {
        base += 15;
      }
    }
    return base.clamp(0, 100);
  }

  static bool _areHarmoniousColors(AuraColor a, AuraColor b) {
    final harmonious = {
      AuraColor.red: [AuraColor.orange, AuraColor.yellow],
      AuraColor.orange: [AuraColor.red, AuraColor.yellow],
      AuraColor.yellow: [AuraColor.orange, AuraColor.green],
      AuraColor.green: [AuraColor.yellow, AuraColor.blue],
      AuraColor.blue: [AuraColor.green, AuraColor.indigo],
      AuraColor.indigo: [AuraColor.blue, AuraColor.violet],
      AuraColor.violet: [AuraColor.indigo, AuraColor.pink],
      AuraColor.pink: [AuraColor.violet, AuraColor.white],
      AuraColor.white: [AuraColor.pink, AuraColor.gold],
      AuraColor.gold: [AuraColor.white, AuraColor.yellow],
    };
    return harmonious[a]?.contains(b) ?? false;
  }

  static String _getSpiritualAdvice(
    AuraColor aura, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final key = 'aura.spiritual_advice.${aura.name.toLowerCase()}';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;

    // English fallback
    switch (aura) {
      case AuraColor.red:
        return 'Ground your energy. Physical activity and nature walks will balance your aura.';
      case AuraColor.orange:
        return 'Express your creativity. Art, dance or music will strengthen your aura.';
      case AuraColor.yellow:
        return 'Keep your mental clarity. Learning and teaching will polish your aura.';
      case AuraColor.green:
        return 'Open your heart. Healing work and helping others will grow your aura.';
      case AuraColor.blue:
        return 'Speak your truth. Honest communication and authentic expression will strengthen your aura.';
      case AuraColor.indigo:
        return 'Trust your intuition. Meditation and dream work will deepen your aura.';
      case AuraColor.violet:
        return 'Strengthen your cosmic connection. Spiritual practices and service will elevate your aura.';
      case AuraColor.pink:
        return 'Spread unconditional love. Compassion and empathy will expand your aura.';
      case AuraColor.white:
        return 'Maintain your purity. Purification rituals and meditation will protect your aura.';
      case AuraColor.gold:
        return 'Remember your divine connection. Prayer and gratitude will polish your aura.';
    }
  }

  static int _calculateEnergyLevel(int basePath, int todayNumber) {
    final diff = (basePath - todayNumber).abs();
    if (diff == 0) return 95;
    if (diff <= 2) return 85;
    if (diff <= 4) return 70;
    return 60;
  }

  static String _getDailyGuidance(
    AuraColor base,
    AuraColor today, {
    AppLanguage language = AppLanguage.tr,
  }) {
    String key;
    String fallback;

    if (base == today) {
      key = 'aura.daily_guidance.strongest';
      fallback =
          'Today your aura is at its strongest. Ideal day to use your natural talents.';
    } else if (_areHarmoniousColors(base, today)) {
      key = 'aura.daily_guidance.harmonious';
      fallback =
          "Today's energy is harmonious with your aura. Stay in flow and seize opportunities.";
    } else {
      key = 'aura.daily_guidance.different';
      fallback =
          'Today has a different energy flow. Flexibility and adaptation are important. Find balance.';
    }

    final localized = L10nService.get(key, language);
    return localized != key ? localized : fallback;
  }

  static String _getDailyAffirmation(
    AuraColor aura, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final key = 'aura.affirmations.${aura.name.toLowerCase()}';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;

    // English fallback
    switch (aura) {
      case AuraColor.red:
        return 'I am strong and safe. I move forward fearlessly.';
      case AuraColor.orange:
        return 'My creativity is limitless. I express with joy.';
      case AuraColor.yellow:
        return 'My mind is clear, my will is strong. Success is mine.';
      case AuraColor.green:
        return 'My heart is open, my love is infinite. I carry healing.';
      case AuraColor.blue:
        return 'I speak my truth. My voice is powerful.';
      case AuraColor.indigo:
        return 'I trust my intuition. My inner wisdom guides me.';
      case AuraColor.violet:
        return 'I am one with the universe. I serve my higher purpose.';
      case AuraColor.pink:
        return 'I give love, I receive love. Compassion is my nature.';
      case AuraColor.white:
        return 'I am in pure light. Divine protection is with me.';
      case AuraColor.gold:
        return 'I am divine energy. Abundance and prosperity flow with me.';
    }
  }
}

/// Aura renkleri
enum AuraColor {
  red,
  orange,
  yellow,
  green,
  blue,
  indigo,
  violet,
  pink,
  white,
  gold,
}

extension AuraColorExtension on AuraColor {
  String get name {
    switch (this) {
      case AuraColor.red:
        return 'Red';
      case AuraColor.orange:
        return 'Orange';
      case AuraColor.yellow:
        return 'Yellow';
      case AuraColor.green:
        return 'Green';
      case AuraColor.blue:
        return 'Blue';
      case AuraColor.indigo:
        return 'Indigo';
      case AuraColor.violet:
        return 'Violet';
      case AuraColor.pink:
        return 'Pink';
      case AuraColor.white:
        return 'White';
      case AuraColor.gold:
        return 'Gold';
    }
  }

  String get nameTr {
    switch (this) {
      case AuraColor.red:
        return 'Kırmızı';
      case AuraColor.orange:
        return 'Turuncu';
      case AuraColor.yellow:
        return 'Sarı';
      case AuraColor.green:
        return 'Yeşil';
      case AuraColor.blue:
        return 'Mavi';
      case AuraColor.indigo:
        return 'Çivit';
      case AuraColor.violet:
        return 'Mor';
      case AuraColor.pink:
        return 'Pembe';
      case AuraColor.white:
        return 'Beyaz';
      case AuraColor.gold:
        return 'Altın';
    }
  }

  String localizedName(AppLanguage language) {
    final key = 'aura.colors.${name.toLowerCase()}';
    final localized = L10nService.get(key, language);
    return localized != key ? localized : name;
  }

  String localizedMeditationFocus(AppLanguage language) {
    final key = 'aura.meditation_focus.${name.toLowerCase()}';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;
    return language == AppLanguage.tr ? meditationFocusTr : meditationFocusEn;
  }

  String localizedCrystal(AppLanguage language) {
    final key = 'aura.crystals.${name.toLowerCase()}';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;
    return language == AppLanguage.tr
        ? recommendedCrystalTr
        : recommendedCrystalEn;
  }

  String localizedNatureConnection(AppLanguage language) {
    final key = 'aura.nature.${name.toLowerCase()}';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;
    return language == AppLanguage.tr ? natureConnectionTr : natureConnectionEn;
  }

  String localizedMeaning(AppLanguage language) {
    final key = 'aura.meanings.${name.toLowerCase()}';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;
    return language == AppLanguage.tr ? meaningTr : meaningEn;
  }

  Color get color {
    switch (this) {
      case AuraColor.red:
        return const Color(0xFFE53935);
      case AuraColor.orange:
        return const Color(0xFFFF9800);
      case AuraColor.yellow:
        return const Color(0xFFFFEB3B);
      case AuraColor.green:
        return const Color(0xFF4CAF50);
      case AuraColor.blue:
        return const Color(0xFF2196F3);
      case AuraColor.indigo:
        return const Color(0xFF3F51B5);
      case AuraColor.violet:
        return const Color(0xFF9C27B0);
      case AuraColor.pink:
        return const Color(0xFFE91E63);
      case AuraColor.white:
        return const Color(0xFFF5F5F5);
      case AuraColor.gold:
        return const Color(0xFFFFD700);
    }
  }

  String get meaning => meaningTr;

  String get meaningTr {
    switch (this) {
      case AuraColor.red:
        return 'Güçlü yaşam enerjisi, tutku ve fiziksel güç. Topraklı ve hayatta kalmaya odaklı.';
      case AuraColor.orange:
        return 'Yaratıcılık, duygusal ifade ve sosyallik. Neşeli ve maceracı ruh.';
      case AuraColor.yellow:
        return 'Zihinsel güç, iyimserlik ve özgüven. Entelektüel ve analitik.';
      case AuraColor.green:
        return 'Şifa enerjisi, denge ve büyüme. Kalp merkezli ve besleyici.';
      case AuraColor.blue:
        return 'İletişim, hakikat ve sakinlik. Güvenilir ve barışçıl.';
      case AuraColor.indigo:
        return 'Derin sezgi, spiritüel farkındalık ve içgörü. Mistik ve vizyoner.';
      case AuraColor.violet:
        return 'Spiritüel bağlantı, dönüşüm ve bilgelik. Yüksek bilinç.';
      case AuraColor.pink:
        return 'Koşulsuz sevgi, şefkat ve romantizm. Hassas ve sevgi dolu.';
      case AuraColor.white:
        return 'Saflık, ilahi koruma ve yüksek spiritüel gelişim. Aydınlanmış.';
      case AuraColor.gold:
        return 'İlahi bilgelik, koruma ve bolluk. Spiritüel liderlik.';
    }
  }

  String get meaningEn {
    switch (this) {
      case AuraColor.red:
        return 'Strong life energy, passion and physical power. Grounded and focused on survival.';
      case AuraColor.orange:
        return 'Creativity, emotional expression and sociability. Joyful and adventurous spirit.';
      case AuraColor.yellow:
        return 'Mental power, optimism and self-confidence. Intellectual and analytical.';
      case AuraColor.green:
        return 'Healing energy, balance and growth. Heart-centered and nurturing.';
      case AuraColor.blue:
        return 'Communication, truth and calmness. Trustworthy and peaceful.';
      case AuraColor.indigo:
        return 'Deep intuition, spiritual awareness and insight. Mystical and visionary.';
      case AuraColor.violet:
        return 'Spiritual connection, transformation and wisdom. Higher consciousness.';
      case AuraColor.pink:
        return 'Unconditional love, compassion and romance. Sensitive and loving.';
      case AuraColor.white:
        return 'Purity, divine protection and high spiritual development. Enlightened.';
      case AuraColor.gold:
        return 'Divine wisdom, protection and abundance. Spiritual leadership.';
    }
  }

  int get baseEnergy {
    switch (this) {
      case AuraColor.red:
        return 80;
      case AuraColor.orange:
        return 75;
      case AuraColor.yellow:
        return 70;
      case AuraColor.green:
        return 75;
      case AuraColor.blue:
        return 70;
      case AuraColor.indigo:
        return 65;
      case AuraColor.violet:
        return 60;
      case AuraColor.pink:
        return 70;
      case AuraColor.white:
        return 85;
      case AuraColor.gold:
        return 90;
    }
  }

  Chakra get chakra {
    switch (this) {
      case AuraColor.red:
        return Chakra.root;
      case AuraColor.orange:
        return Chakra.sacral;
      case AuraColor.yellow:
        return Chakra.solarPlexus;
      case AuraColor.green:
        return Chakra.heart;
      case AuraColor.blue:
        return Chakra.throat;
      case AuraColor.indigo:
        return Chakra.thirdEye;
      case AuraColor.violet:
        return Chakra.crown;
      case AuraColor.pink:
        return Chakra.heart;
      case AuraColor.white:
        return Chakra.crown;
      case AuraColor.gold:
        return Chakra.crown;
    }
  }

  String get meditationFocus => meditationFocusTr;

  String get meditationFocusTr {
    switch (this) {
      case AuraColor.red:
        return 'topraklanma ve güvenlik';
      case AuraColor.orange:
        return 'yaratıcılık ve duygusal akış';
      case AuraColor.yellow:
        return 'kişisel güç ve özgüven';
      case AuraColor.green:
        return 'kalp açılımı ve şifa';
      case AuraColor.blue:
        return 'iletişim ve özgün ifade';
      case AuraColor.indigo:
        return 'üçüncü göz ve sezgi';
      case AuraColor.violet:
        return 'taç chakra ve evrensel bağlantı';
      case AuraColor.pink:
        return 'koşulsuz sevgi ve şefkat';
      case AuraColor.white:
        return 'arınma ve koruma';
      case AuraColor.gold:
        return 'ilahi bağlantı ve bolluk';
    }
  }

  String get meditationFocusEn {
    switch (this) {
      case AuraColor.red:
        return 'grounding and security';
      case AuraColor.orange:
        return 'creativity and emotional flow';
      case AuraColor.yellow:
        return 'personal power and confidence';
      case AuraColor.green:
        return 'heart opening and healing';
      case AuraColor.blue:
        return 'communication and authentic expression';
      case AuraColor.indigo:
        return 'third eye and intuition';
      case AuraColor.violet:
        return 'crown chakra and universal connection';
      case AuraColor.pink:
        return 'unconditional love and compassion';
      case AuraColor.white:
        return 'purification and protection';
      case AuraColor.gold:
        return 'divine connection and abundance';
    }
  }

  String get recommendedCrystal => recommendedCrystalTr;

  String get recommendedCrystalTr {
    switch (this) {
      case AuraColor.red:
        return 'Kırmızı Jasper veya Garnet';
      case AuraColor.orange:
        return 'Karneol veya Turuncu Kalsit';
      case AuraColor.yellow:
        return 'Sitrin veya Kaplan Gözü';
      case AuraColor.green:
        return 'Yeşil Aventurin veya Zümrüt';
      case AuraColor.blue:
        return 'Lapis Lazuli veya Akuamarin';
      case AuraColor.indigo:
        return 'Ametist veya Sodalit';
      case AuraColor.violet:
        return 'Mor Ametist veya Sugilit';
      case AuraColor.pink:
        return 'Pembe Kuvars veya Rodonit';
      case AuraColor.white:
        return 'Şeffaf Kuvars veya Selenit';
      case AuraColor.gold:
        return 'Altın Topaz veya Pirit';
    }
  }

  String get recommendedCrystalEn {
    switch (this) {
      case AuraColor.red:
        return 'Red Jasper or Garnet';
      case AuraColor.orange:
        return 'Carnelian or Orange Calcite';
      case AuraColor.yellow:
        return 'Citrine or Tiger\'s Eye';
      case AuraColor.green:
        return 'Green Aventurine or Emerald';
      case AuraColor.blue:
        return 'Lapis Lazuli or Aquamarine';
      case AuraColor.indigo:
        return 'Amethyst or Sodalite';
      case AuraColor.violet:
        return 'Purple Amethyst or Sugilite';
      case AuraColor.pink:
        return 'Rose Quartz or Rhodonite';
      case AuraColor.white:
        return 'Clear Quartz or Selenite';
      case AuraColor.gold:
        return 'Golden Topaz or Pyrite';
    }
  }

  String get natureConnection => natureConnectionTr;

  String get natureConnectionTr {
    switch (this) {
      case AuraColor.red:
        return 'Yalın ayak toprakta yürü. Ağaçlara sarıl.';
      case AuraColor.orange:
        return 'Gün batımını izle. Su kenarında zaman geçir.';
      case AuraColor.yellow:
        return 'Güneş banyosu yap. Çiçekli bahçelerde ol.';
      case AuraColor.green:
        return 'Ormanda yürü. Bitkilerle ilgilen.';
      case AuraColor.blue:
        return 'Deniz veya göl kenarında ol. Gökyüzünü izle.';
      case AuraColor.indigo:
        return 'Gece gökyüzünü ve yıldızları izle.';
      case AuraColor.violet:
        return 'Dağlarda veya yüksek yerlerde ol.';
      case AuraColor.pink:
        return 'Çiçek bahçelerinde zaman geçir.';
      case AuraColor.white:
        return 'Kar veya bulutları izle. Temiz havada ol.';
      case AuraColor.gold:
        return 'Gün doğumunu izle. Güneş ışığında ol.';
    }
  }

  String get natureConnectionEn {
    switch (this) {
      case AuraColor.red:
        return 'Walk barefoot on the earth. Hug trees.';
      case AuraColor.orange:
        return 'Watch the sunset. Spend time by the water.';
      case AuraColor.yellow:
        return 'Take a sunbath. Be in flower gardens.';
      case AuraColor.green:
        return 'Walk in the forest. Care for plants.';
      case AuraColor.blue:
        return 'Be by the sea or lake. Watch the sky.';
      case AuraColor.indigo:
        return 'Watch the night sky and stars.';
      case AuraColor.violet:
        return 'Be in mountains or high places.';
      case AuraColor.pink:
        return 'Spend time in flower gardens.';
      case AuraColor.white:
        return 'Watch snow or clouds. Be in fresh air.';
      case AuraColor.gold:
        return 'Watch the sunrise. Be in sunlight.';
    }
  }

  int get soundFrequency {
    switch (this) {
      case AuraColor.red:
        return 396;
      case AuraColor.orange:
        return 417;
      case AuraColor.yellow:
        return 528;
      case AuraColor.green:
        return 639;
      case AuraColor.blue:
        return 741;
      case AuraColor.indigo:
        return 852;
      case AuraColor.violet:
        return 963;
      case AuraColor.pink:
        return 639;
      case AuraColor.white:
        return 963;
      case AuraColor.gold:
        return 963;
    }
  }

  static AuraColor fromLifePath(int lifePath) {
    switch (lifePath) {
      case 1:
        return AuraColor.red;
      case 2:
        return AuraColor.blue;
      case 3:
        return AuraColor.yellow;
      case 4:
        return AuraColor.green;
      case 5:
        return AuraColor.orange;
      case 6:
        return AuraColor.pink;
      case 7:
        return AuraColor.indigo;
      case 8:
        return AuraColor.gold;
      case 9:
        return AuraColor.violet;
      case 11:
        return AuraColor.white;
      case 22:
        return AuraColor.gold;
      case 33:
        return AuraColor.violet;
      default:
        return AuraColor.white;
    }
  }

  static AuraColor fromNumber(int number) {
    switch (number % 10) {
      case 1:
        return AuraColor.red;
      case 2:
        return AuraColor.blue;
      case 3:
        return AuraColor.yellow;
      case 4:
        return AuraColor.green;
      case 5:
        return AuraColor.orange;
      case 6:
        return AuraColor.pink;
      case 7:
        return AuraColor.indigo;
      case 8:
        return AuraColor.gold;
      case 9:
        return AuraColor.violet;
      case 0:
        return AuraColor.white;
      default:
        return AuraColor.white;
    }
  }
}

/// Chakra enum
enum Chakra { root, sacral, solarPlexus, heart, throat, thirdEye, crown }

extension ChakraExtension on Chakra {
  String get name {
    switch (this) {
      case Chakra.root:
        return 'Root';
      case Chakra.sacral:
        return 'Sacral';
      case Chakra.solarPlexus:
        return 'Solar Plexus';
      case Chakra.heart:
        return 'Heart';
      case Chakra.throat:
        return 'Throat';
      case Chakra.thirdEye:
        return 'Third Eye';
      case Chakra.crown:
        return 'Crown';
    }
  }

  String get nameTr {
    switch (this) {
      case Chakra.root:
        return 'Kök Chakra';
      case Chakra.sacral:
        return 'Sakral Chakra';
      case Chakra.solarPlexus:
        return 'Solar Pleksus';
      case Chakra.heart:
        return 'Kalp Chakra';
      case Chakra.throat:
        return 'Boğaz Chakra';
      case Chakra.thirdEye:
        return 'Üçüncü Göz';
      case Chakra.crown:
        return 'Taç Chakra';
    }
  }

  String localizedName(AppLanguage language) {
    final key = 'chakra.names.${name.toLowerCase().replaceAll(' ', '_')}';
    return L10nService.get(key, language);
  }

  String get mantras {
    switch (this) {
      case Chakra.root:
        return 'LAM';
      case Chakra.sacral:
        return 'VAM';
      case Chakra.solarPlexus:
        return 'RAM';
      case Chakra.heart:
        return 'YAM';
      case Chakra.throat:
        return 'HAM';
      case Chakra.thirdEye:
        return 'OM';
      case Chakra.crown:
        return 'OM / Sessizlik';
    }
  }

  Color get color {
    switch (this) {
      case Chakra.root:
        return const Color(0xFFE53935);
      case Chakra.sacral:
        return const Color(0xFFFF9800);
      case Chakra.solarPlexus:
        return const Color(0xFFFFEB3B);
      case Chakra.heart:
        return const Color(0xFF4CAF50);
      case Chakra.throat:
        return const Color(0xFF2196F3);
      case Chakra.thirdEye:
        return const Color(0xFF3F51B5);
      case Chakra.crown:
        return const Color(0xFF9C27B0);
    }
  }
}

/// Aura profili
class AuraProfile {
  final AuraColor primaryColor;
  final AuraColor? secondaryColor;
  final AuraColor? moodColor;
  final Map<Chakra, int> chakraAlignment;
  final int overallEnergy;
  final String spiritualAdvice;

  AuraProfile({
    required this.primaryColor,
    this.secondaryColor,
    this.moodColor,
    required this.chakraAlignment,
    required this.overallEnergy,
    required this.spiritualAdvice,
  });
}

/// Günlük aura enerjisi
class DailyAuraEnergy {
  final DateTime date;
  final AuraColor baseAura;
  final AuraColor todayAura;
  final int energyLevel;
  final String guidance;
  final String affirmation;

  DailyAuraEnergy({
    required this.date,
    required this.baseAura,
    required this.todayAura,
    required this.energyLevel,
    required this.guidance,
    required this.affirmation,
  });
}

/// Aura temizleme ipucu
class AuraCleansingTip {
  final String title;
  final String description;
  final String icon;

  AuraCleansingTip({
    required this.title,
    required this.description,
    required this.icon,
  });
}
