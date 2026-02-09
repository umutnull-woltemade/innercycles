import 'dart:math';
import '../models/zodiac_sign.dart';
import '../models/planet.dart';
import '../providers/app_providers.dart';
import 'l10n_service.dart';
import 'moon_service.dart';

/// Service for generating viral, shareable cosmic content
class CosmicShareContentService {
  static final _random = Random();

  /// Generate complete share screen content for a user
  static CosmicShareContent generateContent({
    required ZodiacSign sunSign,
    required DateTime birthDate,
    ZodiacSign? risingSign,
    ZodiacSign? moonSign,
    AppLanguage language = AppLanguage.tr,
  }) {
    final today = DateTime.now();
    final moonPhase = MoonService.getCurrentPhase(today);
    final dayOfYear = today.difference(DateTime(today.year, 1, 1)).inDays;

    return CosmicShareContent(
      heroBlock: _generateHeroBlock(sunSign, today, moonPhase, language: language),
      personalMessage: _generatePersonalMessage(sunSign, risingSign, moonSign, language: language),
      energyMeter: _generateEnergyMeter(sunSign, dayOfYear, language: language),
      planetaryInfluence: _generatePlanetaryInfluence(sunSign, today, language: language),
      shadowLight: _generateShadowLight(sunSign, language: language),
      cosmicAdvice: _generateCosmicAdvice(sunSign, language: language),
      symbolicMessage: _generateSymbolicMessage(sunSign, dayOfYear, language: language),
      viralHook: _generateViralHook(sunSign, language: language),
      sharePrompt: _generateSharePrompt(language: language),
      collectiveMoment: _generateCollectiveMoment(sunSign, moonPhase, language: language),
      premiumCuriosity: _generatePremiumCuriosity(sunSign, language: language),
      microMessages: _generateMicroMessages(sunSign, language: language),
      // MASTER LEVEL additions
      dreamInsight: _generateDreamInsight(sunSign, moonPhase, language: language),
      numerologyInsight: _generateNumerologyInsight(today, language: language),
      tantraWisdom: _generateTantraWisdom(sunSign, language: language),
      chakraSnapshot: _generateChakraSnapshot(sunSign, dayOfYear, language: language),
      timingHint: _generateTimingHint(sunSign, today, language: language),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // MASTER LEVEL: NEW GENERATORS
  // ═══════════════════════════════════════════════════════════════

  static DreamInsight _generateDreamInsight(ZodiacSign sign, MoonPhase moonPhase, {AppLanguage language = AppLanguage.tr}) {
    // Get localized symbol meaning
    final symbolKey = 'cosmic_share.dream_symbols.${sign.name}';
    final localizedSymbol = L10nService.get(symbolKey, language);

    final trSymbols = {
      ZodiacSign.aries: ['🔥', 'Ateş — dönüşüm ve tutku'],
      ZodiacSign.taurus: ['🌳', 'Ağaç — kökler ve büyüme'],
      ZodiacSign.gemini: ['🪞', 'Ayna — iç yansıma'],
      ZodiacSign.cancer: ['🌊', 'Su — duygusal derinlik'],
      ZodiacSign.leo: ['👑', 'Taç — içsel güç'],
      ZodiacSign.virgo: ['🔮', 'Kristal — berraklık'],
      ZodiacSign.libra: ['⚖️', 'Terazi — denge arayışı'],
      ZodiacSign.scorpio: ['🦋', 'Kelebek — metamorfoz'],
      ZodiacSign.sagittarius: ['🏹', 'Ok — hedef ve yön'],
      ZodiacSign.capricorn: ['⛰️', 'Dağ — zirve yolculuğu'],
      ZodiacSign.aquarius: ['⚡', 'Şimşek — ani farkındalık'],
      ZodiacSign.pisces: ['🐚', 'Deniz kabuğu — içsel ses'],
    };
    final enSymbols = {
      ZodiacSign.aries: ['🔥', 'Fire — transformation and passion'],
      ZodiacSign.taurus: ['🌳', 'Tree — roots and growth'],
      ZodiacSign.gemini: ['🪞', 'Mirror — inner reflection'],
      ZodiacSign.cancer: ['🌊', 'Water — emotional depth'],
      ZodiacSign.leo: ['👑', 'Crown — inner power'],
      ZodiacSign.virgo: ['🔮', 'Crystal — clarity'],
      ZodiacSign.libra: ['⚖️', 'Scales — seeking balance'],
      ZodiacSign.scorpio: ['🦋', 'Butterfly — metamorphosis'],
      ZodiacSign.sagittarius: ['🏹', 'Arrow — aim and direction'],
      ZodiacSign.capricorn: ['⛰️', 'Mountain — summit journey'],
      ZodiacSign.aquarius: ['⚡', 'Lightning — sudden awareness'],
      ZodiacSign.pisces: ['🐚', 'Seashell — inner voice'],
    };

    final symbols = language == AppLanguage.tr ? trSymbols : enSymbols;
    final defaultSymbol = language == AppLanguage.tr ? ['✨', 'Yıldız — sonsuz potansiyel'] : ['✨', 'Star — infinite potential'];

    // Get localized dream prompts
    final promptKey = 'cosmic_share.dream_prompts.${_random.nextInt(4) + 1}';
    final localizedPrompt = L10nService.get(promptKey, language);
    final trPrompts = [
      'Bu gece rüyanda neyi görmek isterdin?',
      'Gözlerini kapattığında hangi renk beliriyor?',
      'Bilinçaltın sana ne fısıldıyor?',
      'Ay ışığında hangi kapı açılıyor?',
    ];
    final enPrompts = [
      'What would you like to see in your dreams tonight?',
      'What color appears when you close your eyes?',
      'What is your subconscious whispering to you?',
      'What door opens in the moonlight?',
    ];
    final prompts = language == AppLanguage.tr ? trPrompts : enPrompts;

    // Get localized night messages
    final nightKey = 'cosmic_share.night_messages.${moonPhase.name}';
    final localizedNight = L10nService.get(nightKey, language);
    final trNightMessages = {
      MoonPhase.newMoon: 'Karanlıkta bile ışık var.',
      MoonPhase.waxingCrescent: 'Tohumlar sessizce büyüyor.',
      MoonPhase.firstQuarter: 'Yarısı aydınlık, yarısı gizem.',
      MoonPhase.waxingGibbous: 'Doluluk yaklaşıyor.',
      MoonPhase.fullMoon: 'Her şey aydınlanıyor.',
      MoonPhase.waningGibbous: 'Minnetle bırak.',
      MoonPhase.lastQuarter: 'Eski döngü kapanıyor.',
      MoonPhase.waningCrescent: 'Dinlenme zamanı.',
    };
    final enNightMessages = {
      MoonPhase.newMoon: 'There is light even in darkness.',
      MoonPhase.waxingCrescent: 'Seeds are quietly growing.',
      MoonPhase.firstQuarter: 'Half illuminated, half mystery.',
      MoonPhase.waxingGibbous: 'Fullness is approaching.',
      MoonPhase.fullMoon: 'Everything is illuminated.',
      MoonPhase.waningGibbous: 'Release with gratitude.',
      MoonPhase.lastQuarter: 'The old cycle is closing.',
      MoonPhase.waningCrescent: 'Time to rest.',
    };
    final nightMessages = language == AppLanguage.tr ? trNightMessages : enNightMessages;
    final defaultNightMsg = language == AppLanguage.tr ? 'Rüyaların rehberin olsun.' : 'Let your dreams guide you.';

    final symbolData = symbols[sign] ?? defaultSymbol;

    return DreamInsight(
      symbol: symbolData[0],
      symbolMeaning: localizedSymbol != symbolKey ? localizedSymbol : symbolData[1],
      dreamPrompt: localizedPrompt != promptKey ? localizedPrompt : prompts[_random.nextInt(prompts.length)],
      nightMessage: localizedNight != nightKey ? localizedNight : (nightMessages[moonPhase] ?? defaultNightMsg),
    );
  }

  static NumerologyInsight _generateNumerologyInsight(DateTime today, {AppLanguage language = AppLanguage.tr}) {
    // Calculate day number (reduce to single digit)
    int daySum = today.day + today.month + today.year;
    while (daySum > 9 && daySum != 11 && daySum != 22 && daySum != 33) {
      daySum = daySum.toString().split('').map(int.parse).reduce((a, b) => a + b);
    }

    // Get localized meaning
    final meaningKey = 'cosmic_share.numerology.meanings.$daySum';
    final localizedMeaning = L10nService.get(meaningKey, language);

    final trMeanings = {
      1: 'Başlangıçların enerjisi',
      2: 'Ortaklık ve denge',
      3: 'Yaratıcılık akışta',
      4: 'Temel atma zamanı',
      5: 'Değişim rüzgârı',
      6: 'Sevgi ve sorumluluk',
      7: 'İçsel yolculuk',
      8: 'Bolluk kapısı',
      9: 'Tamamlanma enerjisi',
      11: 'Aydınlanma portali',
      22: 'Usta inşaatçı',
      33: 'Kozmik öğretmen',
    };
    final enMeanings = {
      1: 'Energy of beginnings',
      2: 'Partnership and balance',
      3: 'Creativity in flow',
      4: 'Time to lay foundations',
      5: 'Winds of change',
      6: 'Love and responsibility',
      7: 'Inner journey',
      8: 'Gateway to abundance',
      9: 'Energy of completion',
      11: 'Portal of enlightenment',
      22: 'Master builder',
      33: 'Cosmic teacher',
    };
    final meanings = language == AppLanguage.tr ? trMeanings : enMeanings;
    final defaultMeaning = language == AppLanguage.tr ? 'Evrensel enerji' : 'Universal energy';

    // Get localized vibration
    final vibrationKey = 'cosmic_share.numerology.vibrations.$daySum';
    final localizedVibration = L10nService.get(vibrationKey, language);

    final trVibrations = {
      1: 'Cesur ve kararlı',
      2: 'Hassas ve sezgisel',
      3: 'Neşeli ve ifade dolu',
      4: 'Pratik ve disiplinli',
      5: 'Maceracı ve özgür',
      6: 'Şefkatli ve koruyucu',
      7: 'Mistik ve analitik',
      8: 'Güçlü ve hırslı',
      9: 'Bilge ve insancıl',
      11: 'Vizyoner ve ilham dolu',
      22: 'Yapıcı ve manifestör',
      33: 'Şifacı ve yüksek bilinç',
    };
    final enVibrations = {
      1: 'Brave and determined',
      2: 'Sensitive and intuitive',
      3: 'Joyful and expressive',
      4: 'Practical and disciplined',
      5: 'Adventurous and free',
      6: 'Compassionate and protective',
      7: 'Mystical and analytical',
      8: 'Powerful and ambitious',
      9: 'Wise and humanitarian',
      11: 'Visionary and inspiring',
      22: 'Builder and manifestor',
      33: 'Healer and higher consciousness',
    };
    final vibrations = language == AppLanguage.tr ? trVibrations : enVibrations;
    final defaultVibration = language == AppLanguage.tr ? 'Dengeli titreşim' : 'Balanced vibration';

    // Calculate lucky hour based on day number
    final luckyHours = ['06:00', '09:00', '11:11', '14:00', '17:00', '19:00', '21:00', '23:00'];
    final luckyHour = luckyHours[(daySum - 1) % luckyHours.length];

    return NumerologyInsight(
      dayNumber: daySum,
      numberMeaning: localizedMeaning != meaningKey ? localizedMeaning : (meanings[daySum] ?? defaultMeaning),
      vibration: localizedVibration != vibrationKey ? localizedVibration : (vibrations[daySum] ?? defaultVibration),
      luckyHour: luckyHour,
    );
  }

  static TantraWisdom _generateTantraWisdom(ZodiacSign sign, {AppLanguage language = AppLanguage.tr}) {
    final breathIndex = _random.nextInt(4) + 1;
    final breathKey = 'cosmic_share.tantra.breath_focus.$breathIndex';
    final localizedBreath = L10nService.get(breathKey, language);

    final trBreathFocuses = [
      'Nefesini kalbinin merkezine yönlendir.',
      'Her nefeste evrenle bir ol.',
      'Nefes alırken ışık, verirken huzur.',
      'Sessizlikte nefesinin sesini dinle.',
    ];
    final enBreathFocuses = [
      'Direct your breath to the center of your heart.',
      'Be one with the universe with every breath.',
      'Light as you inhale, peace as you exhale.',
      'Listen to the sound of your breath in silence.',
    ];
    final breathFocuses = language == AppLanguage.tr ? trBreathFocuses : enBreathFocuses;

    // Awareness points
    final awarenessKey = 'cosmic_share.tantra.awareness.${sign.name}';
    final localizedAwareness = L10nService.get(awarenessKey, language);

    final trAwarenessPoints = {
      ZodiacSign.aries: 'Başının tepesi — taç çakra',
      ZodiacSign.taurus: 'Boğazın — ifade merkezi',
      ZodiacSign.gemini: 'Ellerinin içi — enerji portali',
      ZodiacSign.cancer: 'Kalbinin ortası — sevgi merkezi',
      ZodiacSign.leo: 'Göğüs kafesinin merkezi',
      ZodiacSign.virgo: 'Solar pleksus — güç merkezi',
      ZodiacSign.libra: 'Kalp ile zihin arasındaki köprü',
      ZodiacSign.scorpio: 'Sakral bölge — yaratım enerjisi',
      ZodiacSign.sagittarius: 'Kalçalar — hareket enerjisi',
      ZodiacSign.capricorn: 'Dizler — alçakgönüllülük noktası',
      ZodiacSign.aquarius: 'Üçüncü göz — sezgi kapısı',
      ZodiacSign.pisces: 'Ayak tabanları — topraklama',
    };
    final enAwarenessPoints = {
      ZodiacSign.aries: 'Top of your head — crown chakra',
      ZodiacSign.taurus: 'Your throat — expression center',
      ZodiacSign.gemini: 'Palms of your hands — energy portal',
      ZodiacSign.cancer: 'Center of your heart — love center',
      ZodiacSign.leo: 'Center of your chest',
      ZodiacSign.virgo: 'Solar plexus — power center',
      ZodiacSign.libra: 'Bridge between heart and mind',
      ZodiacSign.scorpio: 'Sacral region — creative energy',
      ZodiacSign.sagittarius: 'Hips — movement energy',
      ZodiacSign.capricorn: 'Knees — point of humility',
      ZodiacSign.aquarius: 'Third eye — gate of intuition',
      ZodiacSign.pisces: 'Soles of your feet — grounding',
    };
    final awarenessPoints = language == AppLanguage.tr ? trAwarenessPoints : enAwarenessPoints;
    final defaultAwareness = language == AppLanguage.tr ? 'Kalbinin derinliği' : 'Depth of your heart';

    // Inner connection
    final connectionIndex = _random.nextInt(5) + 1;
    final connectionKey = 'cosmic_share.tantra.connection.$connectionIndex';
    final localizedConnection = L10nService.get(connectionKey, language);

    final trConnections = [
      'Bedenin tapınağın, ruhun sakin.',
      'İçindeki sonsuzluğu hisset.',
      'Şu an mükemmel. Olduğun gibi.',
      'Evren seninle nefes alıyor.',
      'Her an yeni bir başlangıç.',
    ];
    final enConnections = [
      'Your body is your temple, your soul is at peace.',
      'Feel the infinity within you.',
      'This moment is perfect. Just as you are.',
      'The universe breathes with you.',
      'Every moment is a new beginning.',
    ];
    final connections = language == AppLanguage.tr ? trConnections : enConnections;

    return TantraWisdom(
      breathFocus: localizedBreath != breathKey ? localizedBreath : breathFocuses[_random.nextInt(breathFocuses.length)],
      awarenessPoint: localizedAwareness != awarenessKey ? localizedAwareness : (awarenessPoints[sign] ?? defaultAwareness),
      innerConnection: localizedConnection != connectionKey ? localizedConnection : connections[_random.nextInt(connections.length)],
    );
  }

  static ChakraSnapshot _generateChakraSnapshot(ZodiacSign sign, int dayOfYear, {AppLanguage language = AppLanguage.tr}) {
    // Get localized chakra data
    final chakraNameKey = 'cosmic_share.chakras.${sign.name}.name';
    final chakraMsgKey = 'cosmic_share.chakras.${sign.name}.message';
    final localizedName = L10nService.get(chakraNameKey, language);
    final localizedMsg = L10nService.get(chakraMsgKey, language);

    final trChakras = {
      ZodiacSign.aries: ['Kök Çakra', '🔴', 'Güvenlik ve topraklama'],
      ZodiacSign.taurus: ['Sakral Çakra', '🟠', 'Yaratıcılık ve tutku'],
      ZodiacSign.gemini: ['Boğaz Çakra', '🔵', 'İletişim ve ifade'],
      ZodiacSign.cancer: ['Kalp Çakra', '💚', 'Sevgi ve şefkat'],
      ZodiacSign.leo: ['Solar Pleksus', '💛', 'Güç ve özgüven'],
      ZodiacSign.virgo: ['Solar Pleksus', '💛', 'Analiz ve düzen'],
      ZodiacSign.libra: ['Kalp Çakra', '💚', 'Denge ve uyum'],
      ZodiacSign.scorpio: ['Sakral Çakra', '🟠', 'Dönüşüm ve yeniden doğuş'],
      ZodiacSign.sagittarius: ['Üçüncü Göz', '💜', 'Vizyon ve bilgelik'],
      ZodiacSign.capricorn: ['Kök Çakra', '🔴', 'Yapı ve disiplin'],
      ZodiacSign.aquarius: ['Taç Çakra', '🤍', 'Evrensel bağlantı'],
      ZodiacSign.pisces: ['Üçüncü Göz', '💜', 'Sezgi ve rüyalar'],
    };
    final enChakras = {
      ZodiacSign.aries: ['Root Chakra', '🔴', 'Security and grounding'],
      ZodiacSign.taurus: ['Sacral Chakra', '🟠', 'Creativity and passion'],
      ZodiacSign.gemini: ['Throat Chakra', '🔵', 'Communication and expression'],
      ZodiacSign.cancer: ['Heart Chakra', '💚', 'Love and compassion'],
      ZodiacSign.leo: ['Solar Plexus', '💛', 'Power and confidence'],
      ZodiacSign.virgo: ['Solar Plexus', '💛', 'Analysis and order'],
      ZodiacSign.libra: ['Heart Chakra', '💚', 'Balance and harmony'],
      ZodiacSign.scorpio: ['Sacral Chakra', '🟠', 'Transformation and rebirth'],
      ZodiacSign.sagittarius: ['Third Eye', '💜', 'Vision and wisdom'],
      ZodiacSign.capricorn: ['Root Chakra', '🔴', 'Structure and discipline'],
      ZodiacSign.aquarius: ['Crown Chakra', '🤍', 'Universal connection'],
      ZodiacSign.pisces: ['Third Eye', '💜', 'Intuition and dreams'],
    };

    final chakras = language == AppLanguage.tr ? trChakras : enChakras;
    final defaultChakra = language == AppLanguage.tr ? ['Kalp Çakra', '💚', 'Sevgi merkezi'] : ['Heart Chakra', '💚', 'Love center'];

    final chakraData = chakras[sign] ?? defaultChakra;
    final balance = 0.5 + (dayOfYear % 50) / 100.0; // 0.5 - 1.0 arası

    return ChakraSnapshot(
      activeChakra: localizedName != chakraNameKey ? localizedName : chakraData[0],
      chakraSymbol: chakraData[1],
      chakraMessage: localizedMsg != chakraMsgKey ? localizedMsg : chakraData[2],
      balanceLevel: balance.clamp(0.0, 1.0),
    );
  }

  static CosmicTimingHint _generateTimingHint(ZodiacSign sign, DateTime today, {AppLanguage language = AppLanguage.tr}) {
    final goldenHours = {
      ZodiacSign.aries: '06:00 - 08:00',
      ZodiacSign.taurus: '10:00 - 12:00',
      ZodiacSign.gemini: '14:00 - 16:00',
      ZodiacSign.cancer: '20:00 - 22:00',
      ZodiacSign.leo: '12:00 - 14:00',
      ZodiacSign.virgo: '08:00 - 10:00',
      ZodiacSign.libra: '16:00 - 18:00',
      ZodiacSign.scorpio: '22:00 - 00:00',
      ZodiacSign.sagittarius: '14:00 - 16:00',
      ZodiacSign.capricorn: '06:00 - 08:00',
      ZodiacSign.aquarius: '18:00 - 20:00',
      ZodiacSign.pisces: '04:00 - 06:00',
    };

    final avoidHours = {
      ZodiacSign.aries: '14:00 - 15:00',
      ZodiacSign.taurus: '18:00 - 19:00',
      ZodiacSign.gemini: '10:00 - 11:00',
      ZodiacSign.cancer: '12:00 - 13:00',
      ZodiacSign.leo: '20:00 - 21:00',
      ZodiacSign.virgo: '16:00 - 17:00',
      ZodiacSign.libra: '08:00 - 09:00',
      ZodiacSign.scorpio: '14:00 - 15:00',
      ZodiacSign.sagittarius: '06:00 - 07:00',
      ZodiacSign.capricorn: '22:00 - 23:00',
      ZodiacSign.aquarius: '10:00 - 11:00',
      ZodiacSign.pisces: '14:00 - 15:00',
    };

    // Get localized ritual
    final ritualIndex = _random.nextInt(6) + 1;
    final ritualKey = 'cosmic_share.rituals.$ritualIndex';
    final localizedRitual = L10nService.get(ritualKey, language);

    final trRituals = [
      'Niyetini kağıda yaz, sonra yak.',
      '3 dakika sessizce nefes al.',
      'Bir bardak su içerken minnetle dol.',
      'Güneşe veya aya bak, teşekkür et.',
      'Bugün için tek bir kelime seç.',
      'Kalbine elini koy, dinle.',
    ];
    final enRituals = [
      'Write your intention on paper, then burn it.',
      'Breathe quietly for 3 minutes.',
      'Fill with gratitude while drinking a glass of water.',
      'Look at the sun or moon, give thanks.',
      'Choose one word for today.',
      'Place your hand on your heart, listen.',
    ];
    final rituals = language == AppLanguage.tr ? trRituals : enRituals;

    return CosmicTimingHint(
      goldenHour: goldenHours[sign] ?? '12:00 - 14:00',
      avoidHour: avoidHours[sign] ?? '15:00 - 16:00',
      ritualSuggestion: localizedRitual != ritualKey ? localizedRitual : rituals[_random.nextInt(rituals.length)],
    );
  }

  static HeroBlock _generateHeroBlock(
    ZodiacSign sign,
    DateTime today,
    MoonPhase moonPhase, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final headlines = _heroHeadlines[sign] ?? _defaultHeroHeadlines;
    final headline = headlines[_random.nextInt(headlines.length)];

    // Get localized cosmic title
    final key = 'cosmic_share.cosmic_titles.${sign.name}';
    final localizedTitle = L10nService.get(key, language);
    final cosmicTitle = localizedTitle != key ? localizedTitle : _getCosmicTitleFallback(sign, language);

    return HeroBlock(
      signTitle: cosmicTitle,
      signSymbol: sign.symbol,
      cosmicHeadline: headline,
      dateFormatted: _formatDate(today, language: language),
      moonPhaseText: _getMoonPhaseText(moonPhase, language: language),
      moonPhaseEmoji: _getMoonPhaseEmoji(moonPhase),
    );
  }

  static String _getCosmicTitleFallback(ZodiacSign sign, AppLanguage language) {
    final trTitles = {
      ZodiacSign.aries: 'Ateşin Çocuğu',
      ZodiacSign.taurus: 'Toprağın Koruyucusu',
      ZodiacSign.gemini: 'Rüzgârın Elçisi',
      ZodiacSign.cancer: 'Ay\'ın Varisi',
      ZodiacSign.leo: 'Güneşin Tahtı',
      ZodiacSign.virgo: 'Yıldızların Şifacısı',
      ZodiacSign.libra: 'Dengenin Ustası',
      ZodiacSign.scorpio: 'Dönüşümün Simyacısı',
      ZodiacSign.sagittarius: 'Ufkun Kâşifi',
      ZodiacSign.capricorn: 'Zamanın Mimarı',
      ZodiacSign.aquarius: 'Geleceğin Vizyoneri',
      ZodiacSign.pisces: 'Sonsuzluğun Rüyacısı',
    };
    final enTitles = {
      ZodiacSign.aries: 'Child of Fire',
      ZodiacSign.taurus: 'Guardian of Earth',
      ZodiacSign.gemini: 'Messenger of Wind',
      ZodiacSign.cancer: 'Heir of the Moon',
      ZodiacSign.leo: 'Throne of the Sun',
      ZodiacSign.virgo: 'Healer of Stars',
      ZodiacSign.libra: 'Master of Balance',
      ZodiacSign.scorpio: 'Alchemist of Transformation',
      ZodiacSign.sagittarius: 'Explorer of Horizons',
      ZodiacSign.capricorn: 'Architect of Time',
      ZodiacSign.aquarius: 'Visionary of the Future',
      ZodiacSign.pisces: 'Dreamer of Infinity',
    };
    return language == AppLanguage.tr ? trTitles[sign]! : enTitles[sign]!;
  }

  static PersonalCosmicMessage _generatePersonalMessage(
    ZodiacSign sunSign,
    ZodiacSign? risingSign,
    ZodiacSign? moonSign, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final messages = _personalMessages[sunSign] ?? _defaultPersonalMessages;
    final message = messages[_random.nextInt(messages.length)];

    String enhancedMessage = message;
    if (risingSign != null) {
      enhancedMessage += ' ${_risingInfluence[risingSign] ?? ''}';
    }
    if (moonSign != null) {
      enhancedMessage += ' ${_moonInfluence[moonSign] ?? ''}';
    }

    return PersonalCosmicMessage(
      message: enhancedMessage.trim(),
      emotionalCore: _getEmotionalCore(sunSign, language: language),
    );
  }

  static CosmicEnergyMeter _generateEnergyMeter(ZodiacSign sign, int dayOfYear, {AppLanguage language = AppLanguage.tr}) {
    // Pseudo-randomized but consistent for the same day
    final seed = dayOfYear + sign.index;
    final energyLevel = 45 + (seed % 50);
    final intuitionLevel = 30 + ((seed * 7) % 65);

    // Use English keys for intensity - localized in UI
    final intensityOptions = ['calm', 'rising', 'intense', 'stormy'];
    final intensityIndex = (seed ~/ 10) % intensityOptions.length;

    final balanceRatio = (seed % 100) / 100.0;

    // Use English keys for balance description - localized in UI
    final balanceKey = balanceRatio > 0.6
        ? 'action_day'
        : balanceRatio < 0.4
            ? 'reflection_day'
            : 'balanced_day';

    return CosmicEnergyMeter(
      energyLevel: energyLevel,
      energyDescription: _getEnergyDescription(energyLevel, language: language),
      emotionalIntensity: intensityOptions[intensityIndex],
      intensityDescription: _getIntensityDescription(intensityOptions[intensityIndex], language: language),
      intuitionStrength: intuitionLevel,
      intuitionDescription: _getIntuitionDescription(intuitionLevel, language: language),
      actionReflectionBalance: balanceRatio,
      balanceDescription: balanceKey,
    );
  }

  static PlanetaryInfluence _generatePlanetaryInfluence(
    ZodiacSign sign,
    DateTime today, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final dominantPlanets = _getDominantPlanets(sign, today);
    final dominant = dominantPlanets.first;

    final planetData = _getPlanetInfluenceData(dominant, language: language);
    final signName = language == AppLanguage.tr ? sign.nameTr : sign.name;
    final compatibleSign = _getCompatibleSign(sign);
    final compatibleName = language == AppLanguage.tr ? compatibleSign.nameTr : compatibleSign.name;

    // Get localized exclusivity text
    final exclKey = 'cosmic_share.planetary.exclusivity';
    final localizedExcl = L10nService.get(exclKey, language);
    String exclusivityText;
    if (localizedExcl != exclKey) {
      exclusivityText = localizedExcl.replaceAll('{sign1}', signName).replaceAll('{sign2}', compatibleName);
    } else {
      exclusivityText = language == AppLanguage.tr
          ? 'Bu gezegen etkisi bugün sadece $signName ve $compatibleName için bu kadar güçlü.'
          : 'This planetary influence is especially strong today only for $signName and $compatibleName.';
    }

    return PlanetaryInfluence(
      dominantPlanet: dominant,
      planetSymbol: _getPlanetSymbol(dominant),
      activates: planetData.activates,
      blocks: planetData.blocks,
      oneAction: planetData.action,
      exclusivityText: exclusivityText,
    );
  }

  static PlanetInfluenceData _getPlanetInfluenceData(Planet planet, {AppLanguage language = AppLanguage.tr}) {
    final activatesKey = 'cosmic_share.planetary.${planet.name}.activates';
    final blocksKey = 'cosmic_share.planetary.${planet.name}.blocks';
    final actionKey = 'cosmic_share.planetary.${planet.name}.action';

    final localizedActivates = L10nService.get(activatesKey, language);
    final localizedBlocks = L10nService.get(blocksKey, language);
    final localizedAction = L10nService.get(actionKey, language);

    final trData = {
      Planet.sun: PlanetInfluenceData(
        activates: 'Özgüvenini ve yaşam enerjini',
        blocks: 'Gölgede kalmayı ve küçümsenmeyi',
        action: 'Bugün görünür ol. Işığını saklamanın zamanı değil.',
      ),
      Planet.moon: PlanetInfluenceData(
        activates: 'Sezgilerini ve duygusal zekânı',
        blocks: 'Mantıksal aşırılığı ve duygusal kaçınmayı',
        action: 'Bir duyguyu bastırmak yerine, onu dinle.',
      ),
      Planet.mercury: PlanetInfluenceData(
        activates: 'İletişim gücünü ve zihinsel netliği',
        blocks: 'Sessizliği ve yanlış anlaşılmayı',
        action: 'Söylemen gereken bir şey var. Bugün söyle.',
      ),
      Planet.venus: PlanetInfluenceData(
        activates: 'Çekiciliğini ve ilişki enerjini',
        blocks: 'Yalnızlığı ve özdeğer eksikliğini',
        action: 'Kendine güzel bir şey yap. Hak ediyorsun.',
      ),
      Planet.mars: PlanetInfluenceData(
        activates: 'Savaşçı ruhunu ve harekete geçme gücünü',
        blocks: 'Pasifliği ve ertelemeyi',
        action: 'Bir konuda adım at. Düşünme, yap.',
      ),
      Planet.jupiter: PlanetInfluenceData(
        activates: 'Bolluğu ve genişleme enerjini',
        blocks: 'Kısıtlayıcı düşünceleri ve küçük oynamayı',
        action: 'Bugün büyük düşün. Evren seni destekliyor.',
      ),
      Planet.saturn: PlanetInfluenceData(
        activates: 'Disiplinini ve uzun vadeli vizyonunu',
        blocks: 'Kısa yolları ve sorumsuzluğu',
        action: 'Zor ama doğru olanı seç.',
      ),
    };

    final enData = {
      Planet.sun: PlanetInfluenceData(
        activates: 'Your confidence and life energy',
        blocks: 'Staying in the shadows and being underestimated',
        action: 'Be visible today. This is not the time to hide your light.',
      ),
      Planet.moon: PlanetInfluenceData(
        activates: 'Your intuition and emotional intelligence',
        blocks: 'Logical extremes and emotional avoidance',
        action: 'Instead of suppressing a feeling, listen to it.',
      ),
      Planet.mercury: PlanetInfluenceData(
        activates: 'Your communication power and mental clarity',
        blocks: 'Silence and misunderstandings',
        action: 'There is something you need to say. Say it today.',
      ),
      Planet.venus: PlanetInfluenceData(
        activates: 'Your attractiveness and relationship energy',
        blocks: 'Loneliness and lack of self-worth',
        action: 'Do something beautiful for yourself. You deserve it.',
      ),
      Planet.mars: PlanetInfluenceData(
        activates: 'Your warrior spirit and power to take action',
        blocks: 'Passivity and procrastination',
        action: 'Take a step on something. Don\'t think, do.',
      ),
      Planet.jupiter: PlanetInfluenceData(
        activates: 'Abundance and expansion energy',
        blocks: 'Limiting thoughts and playing small',
        action: 'Think big today. The universe supports you.',
      ),
      Planet.saturn: PlanetInfluenceData(
        activates: 'Your discipline and long-term vision',
        blocks: 'Shortcuts and irresponsibility',
        action: 'Choose what is difficult but right.',
      ),
    };

    final data = language == AppLanguage.tr ? trData : enData;
    final defaultData = language == AppLanguage.tr
        ? PlanetInfluenceData(activates: 'İç gücünüzü', blocks: 'Şüphelerinizi', action: 'Kalbinizin sesini dinleyin.')
        : PlanetInfluenceData(activates: 'Your inner power', blocks: 'Your doubts', action: 'Listen to your heart.');

    final fallbackData = data[planet] ?? defaultData;

    return PlanetInfluenceData(
      activates: localizedActivates != activatesKey ? localizedActivates : fallbackData.activates,
      blocks: localizedBlocks != blocksKey ? localizedBlocks : fallbackData.blocks,
      action: localizedAction != actionKey ? localizedAction : fallbackData.action,
    );
  }

  static ShadowLightDuality _generateShadowLight(ZodiacSign sign, {AppLanguage language = AppLanguage.tr}) {
    final shadowData = _getShadowData(sign, language: language);
    final lightData = _getLightData(sign, language: language);

    return ShadowLightDuality(
      shadowChallenge: shadowData.challenge,
      shadowFear: shadowData.fear,
      shadowPattern: shadowData.pattern,
      lightStrength: lightData.strength,
      lightOpportunity: lightData.opportunity,
      lightMagnetic: lightData.magnetic,
    );
  }

  static ShadowData _getShadowData(ZodiacSign sign, {AppLanguage language = AppLanguage.tr}) {
    final challengeKey = 'cosmic_share.shadow.${sign.name}.challenge';
    final fearKey = 'cosmic_share.shadow.${sign.name}.fear';
    final patternKey = 'cosmic_share.shadow.${sign.name}.pattern';

    final localizedChallenge = L10nService.get(challengeKey, language);
    final localizedFear = L10nService.get(fearKey, language);
    final localizedPattern = L10nService.get(patternKey, language);

    final fallbackData = _shadowData[sign] ?? _defaultShadowData;

    // If we need English fallback and localization not found
    if (language != AppLanguage.tr && localizedChallenge == challengeKey) {
      return _getEnglishShadowData(sign);
    }

    return ShadowData(
      challenge: localizedChallenge != challengeKey ? localizedChallenge : fallbackData.challenge,
      fear: localizedFear != fearKey ? localizedFear : fallbackData.fear,
      pattern: localizedPattern != patternKey ? localizedPattern : fallbackData.pattern,
    );
  }

  static ShadowData _getEnglishShadowData(ZodiacSign sign) {
    final enShadowData = {
      ZodiacSign.aries: ShadowData(
        challenge: 'Impatience is pushing you toward wrong decisions.',
        fear: 'Fear of appearing inadequate',
        pattern: 'Acting without thinking, then regret.',
      ),
      ZodiacSign.taurus: ShadowData(
        challenge: 'Stubbornness is causing missed opportunities.',
        fear: 'Loss of control and insecurity',
        pattern: 'Resisting change, then forced adaptation.',
      ),
      ZodiacSign.gemini: ShadowData(
        challenge: 'Scattered energy is blocking focus.',
        fear: 'Being stuck and bored',
        pattern: 'Start everything, finish nothing.',
      ),
      ZodiacSign.cancer: ShadowData(
        challenge: 'Over-emotionality is clouding decisions.',
        fear: 'Rejection and abandonment',
        pattern: 'Going defensive, raising walls.',
      ),
      ZodiacSign.leo: ShadowData(
        challenge: 'Ego is pushing others away.',
        fear: 'Feeling invisible and unimportant',
        pattern: 'Seeking approval, then disappointment.',
      ),
      ZodiacSign.virgo: ShadowData(
        challenge: 'Perfectionism is paralyzing.',
        fear: 'Criticism and making mistakes',
        pattern: 'Over-analyzing, then inaction.',
      ),
      ZodiacSign.libra: ShadowData(
        challenge: 'Indecision is stealing time.',
        fear: 'Conflict and being unloved',
        pattern: 'Trying to please everyone, losing yourself.',
      ),
      ZodiacSign.scorpio: ShadowData(
        challenge: 'Need for control is poisoning relationships.',
        fear: 'Betrayal and loss of power',
        pattern: 'Testing, then self-fulfilling prophecy.',
      ),
      ZodiacSign.sagittarius: ShadowData(
        challenge: 'Escape tendency is magnifying problems.',
        fear: 'Commitment and being limited',
        pattern: 'Leave when it gets hard, then regret.',
      ),
      ZodiacSign.capricorn: ShadowData(
        challenge: 'Work addiction is neglecting relationships.',
        fear: 'Failure and loss of status',
        pattern: 'Escape from feeling, bury in work.',
      ),
      ZodiacSign.aquarius: ShadowData(
        challenge: 'Emotional distance is isolating.',
        fear: 'Ordinariness and conformity pressure',
        pattern: 'Being different for the sake of it, losing essence.',
      ),
      ZodiacSign.pisces: ShadowData(
        challenge: 'Escape mechanisms are disconnecting from reality.',
        fear: 'Pain and disappointment',
        pattern: 'Dream, then crash with reality.',
      ),
    };
    return enShadowData[sign] ?? ShadowData(
      challenge: 'Inner conflicts are blocking clarity.',
      fear: 'Fear of the unknown',
      pattern: 'Repeating cycles.',
    );
  }

  static LightData _getLightData(ZodiacSign sign, {AppLanguage language = AppLanguage.tr}) {
    final strengthKey = 'cosmic_share.light.${sign.name}.strength';
    final opportunityKey = 'cosmic_share.light.${sign.name}.opportunity';
    final magneticKey = 'cosmic_share.light.${sign.name}.magnetic';

    final localizedStrength = L10nService.get(strengthKey, language);
    final localizedOpportunity = L10nService.get(opportunityKey, language);
    final localizedMagnetic = L10nService.get(magneticKey, language);

    final fallbackData = _lightData[sign] ?? _defaultLightData;

    // If we need English fallback and localization not found
    if (language != AppLanguage.tr && localizedStrength == strengthKey) {
      return _getEnglishLightData(sign);
    }

    return LightData(
      strength: localizedStrength != strengthKey ? localizedStrength : fallbackData.strength,
      opportunity: localizedOpportunity != opportunityKey ? localizedOpportunity : fallbackData.opportunity,
      magnetic: localizedMagnetic != magneticKey ? localizedMagnetic : fallbackData.magnetic,
    );
  }

  static LightData _getEnglishLightData(ZodiacSign sign) {
    final enLightData = {
      ZodiacSign.aries: LightData(
        strength: 'Courage and pioneering spirit',
        opportunity: 'Ideal day for a new beginning',
        magnetic: 'Your energy is contagious, people are drawn to you.',
      ),
      ZodiacSign.taurus: LightData(
        strength: 'Loyalty and reliability',
        opportunity: 'Time to clarify your values',
        magnetic: 'Your calmness gives confidence, people find peace near you.',
      ),
      ZodiacSign.gemini: LightData(
        strength: 'Adaptability and communication',
        opportunity: 'Openness for an important conversation',
        magnetic: 'Your wit sparkles, your ideas attract interest.',
      ),
      ZodiacSign.cancer: LightData(
        strength: 'Empathy and protectiveness',
        opportunity: 'Deepening emotional bonds',
        magnetic: 'Your warmth feels like home, people open up to you.',
      ),
      ZodiacSign.leo: LightData(
        strength: 'Creativity and generosity',
        opportunity: 'Courage to express yourself',
        magnetic: 'Your presence radiates light, all eyes on you.',
      ),
      ZodiacSign.virgo: LightData(
        strength: 'Analytical power and service heart',
        opportunity: 'Problem-solving ability at peak',
        magnetic: 'Your competence inspires trust, you\'re like a consultant.',
      ),
      ZodiacSign.libra: LightData(
        strength: 'Diplomacy and aesthetics',
        opportunity: 'Power to resolve conflicts',
        magnetic: 'Your elegance enchants, everyone wants to be with you.',
      ),
      ZodiacSign.scorpio: LightData(
        strength: 'Depth and transformative power',
        opportunity: 'Bringing healing to an old wound',
        magnetic: 'Mystery is attractive, people want to understand you.',
      ),
      ZodiacSign.sagittarius: LightData(
        strength: 'Optimism and vision',
        opportunity: 'New horizons opening',
        magnetic: 'Your adventurous spirit is contagious, you bring excitement.',
      ),
      ZodiacSign.capricorn: LightData(
        strength: 'Discipline and resilience',
        opportunity: 'Clarity for a long-term step',
        magnetic: 'Your authority commands respect, your word is heard.',
      ),
      ZodiacSign.aquarius: LightData(
        strength: 'Originality and humanitarianism',
        opportunity: 'Offering a different perspective',
        magnetic: 'Your uniqueness attracts, you\'re a source of inspiration.',
      ),
      ZodiacSign.pisces: LightData(
        strength: 'Intuition and creative imagination',
        opportunity: 'An artistic or spiritual opening',
        magnetic: 'Your mysterious aura enchants, you\'re like a dream.',
      ),
    };
    return enLightData[sign] ?? LightData(
      strength: 'Inner strength and potential',
      opportunity: 'New opportunities emerging',
      magnetic: 'Your energy attracts people.',
    );
  }

  static List<String> _generateCosmicAdvice(ZodiacSign sign, {AppLanguage language = AppLanguage.tr}) {
    // Check for localized advice
    final key = 'cosmic_share.advice.${sign.name}';
    final localized = L10nService.get(key, language);

    if (localized != key) {
      // If we have localized data, it should be comma-separated or we use the array from JSON
      // For now, use fallback with English support
    }

    // Fallback - use Turkish or get English
    if (language == AppLanguage.tr) {
      final allAdvice = _cosmicAdvice[sign] ?? _defaultCosmicAdvice;
      final shuffled = List<String>.from(allAdvice)..shuffle(_random);
      return shuffled.take(3).toList();
    } else {
      final allAdvice = _getEnglishCosmicAdvice(sign);
      final shuffled = List<String>.from(allAdvice)..shuffle(_random);
      return shuffled.take(3).toList();
    }
  }

  static List<String> _getEnglishCosmicAdvice(ZodiacSign sign) {
    final enCosmicAdvice = {
      ZodiacSign.aries: [
        'Stop. Breathe. Then move.',
        'Your anger is a messenger, but you are the decision maker.',
        'Building peace also requires courage, not just winning battles.',
        'Being right matters more than being first.',
        'No need for power displays, you are already powerful.',
      ],
      ZodiacSign.taurus: [
        'Letting go is not losing.',
        'Your comfort zone is safe but growth isn\'t there.',
        'Your possessions don\'t define you.',
        'Be slow but don\'t stop.',
        'Stay where you\'re valued, leave where you\'re not.',
      ],
      ZodiacSign.gemini: [
        'You don\'t have to follow every thought.',
        'Silence is also an answer.',
        'Depth is sometimes more valuable than breadth.',
        'Being between two paths is also a path.',
        'Listening is also communication.',
      ],
      ZodiacSign.cancer: [
        'Protecting isn\'t loving, it can be suffocating.',
        'The past is a teacher, not a home.',
        'Are your walls protecting you or imprisoning you?',
        'Vulnerability is not weakness.',
        'Sometimes the best care is letting go.',
      ],
      ZodiacSign.leo: [
        'Don\'t let your light extinguish others.',
        'You are valuable even without applause.',
        'Kingdoms are won through service.',
        'Pride can be a prison, not protection.',
        'Who are you when you\'re invisible?',
      ],
      ZodiacSign.virgo: [
        'Be real, not perfect.',
        'Criticize yourself first, then others.',
        '"Good enough" is sometimes perfect.',
        'Asking for help is not weakness.',
        'If analysis paralyzes, feel instead.',
      ],
      ZodiacSign.libra: [
        'Saying no is also love.',
        'Find balance within, not outside.',
        'Conflict is an opportunity for growth.',
        'Everyone\'s happiness is not your responsibility.',
        'Indecision is also a decision.',
      ],
      ZodiacSign.scorpio: [
        'Control is an illusion.',
        'Trust is not a risk, it\'s a gift.',
        'You don\'t have to know everything.',
        'Revenge poisons you, forgiveness liberates.',
        'Depth is beautiful, but there\'s life on the surface too.',
      ],
      ZodiacSign.sagittarius: [
        'Escape is not a solution.',
        'Attachment is not imprisonment.',
        'The answer could be right here too.',
        'Don\'t promise, do.',
        'Adventure exists within too.',
      ],
      ZodiacSign.capricorn: [
        'Success doesn\'t guarantee happiness.',
        'Don\'t let work become escape.',
        'The journey matters, not the summit.',
        'Your feelings also deserve respect.',
        'Taking a break is not giving up.',
      ],
      ZodiacSign.aquarius: [
        'Don\'t be different just to be different.',
        'Not everyone has to understand.',
        'Heart is as important as mind.',
        'Revolution starts within.',
        'Independence is not loneliness.',
      ],
      ZodiacSign.pisces: [
        'Dreams are beautiful, reality is too.',
        'You don\'t have to carry everyone\'s pain.',
        'Boundaries are not lovelessness.',
        'Dreaming is not action.',
        'Don\'t escape, face it.',
      ],
    };
    return enCosmicAdvice[sign] ?? [
      'Be kind to yourself.',
      'Patience is needed today.',
      'Trust your intuition.',
    ];
  }

  static SymbolicMessage _generateSymbolicMessage(ZodiacSign sign, int dayOfYear, {AppLanguage language = AppLanguage.tr}) {
    if (language == AppLanguage.tr) {
      final archetypes = _archetypes[sign] ?? _defaultArchetypes;
      final index = dayOfYear % archetypes.length;
      return archetypes[index];
    } else {
      final archetypes = _getEnglishArchetypes(sign);
      final index = dayOfYear % archetypes.length;
      return archetypes[index];
    }
  }

  static List<SymbolicMessage> _getEnglishArchetypes(ZodiacSign sign) {
    final enArchetypes = {
      ZodiacSign.aries: [
        SymbolicMessage(
          type: 'Archetype',
          symbol: 'Warrior',
          title: 'The Warrior Within',
          meaning: 'The warrior archetype is active today. But the true warrior knows: The greatest victory is conquering yourself.',
          imageHint: 'aries_warrior',
        ),
        SymbolicMessage(
          type: 'Tarot',
          symbol: 'Emperor',
          title: 'IV - The Emperor',
          meaning: 'Structure, authority and control. Your leadership energy is strong today. But beware: Power brings responsibility.',
          imageHint: 'emperor',
        ),
      ],
      ZodiacSign.taurus: [
        SymbolicMessage(
          type: 'Archetype',
          symbol: 'Gardener',
          title: 'The Patient Gardener',
          meaning: 'Seeds bear fruit in time. Consider how what you planted with patience is now sprouting.',
          imageHint: 'taurus_gardener',
        ),
        SymbolicMessage(
          type: 'Tarot',
          symbol: 'Empress',
          title: 'III - The Empress',
          meaning: 'Abundance, sensuality and creativity. Time to feel life\'s beauties.',
          imageHint: 'empress',
        ),
      ],
      ZodiacSign.gemini: [
        SymbolicMessage(
          type: 'Archetype',
          symbol: 'Messenger',
          title: 'Messenger of the Gods',
          meaning: 'Like Hermes, you build bridges between worlds. Your words carry power today.',
          imageHint: 'gemini_messenger',
        ),
        SymbolicMessage(
          type: 'Tarot',
          symbol: 'Lovers',
          title: 'VI - The Lovers',
          meaning: 'Choices and connections. Time to unite two paths, not choose between them.',
          imageHint: 'lovers',
        ),
      ],
      ZodiacSign.cancer: [
        SymbolicMessage(
          type: 'Archetype',
          symbol: 'Mother',
          title: 'The Great Mother',
          meaning: 'Nurturing, protecting, embracing. Today, mother both others and yourself.',
          imageHint: 'cancer_mother',
        ),
        SymbolicMessage(
          type: 'Tarot',
          symbol: 'Moon',
          title: 'XVIII - The Moon',
          meaning: 'Subconscious, intuition and hidden fears. You can find your way even in darkness.',
          imageHint: 'moon',
        ),
      ],
      ZodiacSign.leo: [
        SymbolicMessage(
          type: 'Archetype',
          symbol: 'King',
          title: 'The Just King',
          meaning: 'The true king rules hearts, not thrones. Rule today with generosity.',
          imageHint: 'leo_king',
        ),
        SymbolicMessage(
          type: 'Tarot',
          symbol: 'Strength',
          title: 'VIII - Strength',
          meaning: 'Taming the inner lion. Strength lies in gentleness, not control.',
          imageHint: 'strength',
        ),
      ],
      ZodiacSign.virgo: [
        SymbolicMessage(
          type: 'Archetype',
          symbol: 'Healer',
          title: 'The Sacred Healer',
          meaning: 'Your hands carry healing. Today you have the potential to heal everything you touch.',
          imageHint: 'virgo_healer',
        ),
        SymbolicMessage(
          type: 'Tarot',
          symbol: 'Hermit',
          title: 'IX - The Hermit',
          meaning: 'Inner search and wisdom. Answers are not outside, but in the depths.',
          imageHint: 'hermit',
        ),
      ],
      ZodiacSign.libra: [
        SymbolicMessage(
          type: 'Archetype',
          symbol: 'Diplomat',
          title: 'Peace Ambassador',
          meaning: 'Building bridges, healing wounds. A theme of harmony today.',
          imageHint: 'libra_diplomat',
        ),
        SymbolicMessage(
          type: 'Tarot',
          symbol: 'Justice',
          title: 'XI - Justice',
          meaning: 'Balance, truth and decisions. The scales are balanced — now is the time to choose.',
          imageHint: 'justice',
        ),
      ],
      ZodiacSign.scorpio: [
        SymbolicMessage(
          type: 'Archetype',
          symbol: 'Alchemist',
          title: 'The Dark Alchemist',
          meaning: 'You turn lead into gold. You have the power to transform pain into wisdom, loss into gain.',
          imageHint: 'scorpio_alchemist',
        ),
        SymbolicMessage(
          type: 'Tarot',
          symbol: 'Death',
          title: 'XIII - Death',
          meaning: 'Transformation and rebirth. Endings are doorways to beginnings.',
          imageHint: 'death',
        ),
      ],
      ZodiacSign.sagittarius: [
        SymbolicMessage(
          type: 'Archetype',
          symbol: 'Explorer',
          title: 'Horizon Explorer',
          meaning: 'The unknown is calling you. Today the courage to cross boundaries is within you.',
          imageHint: 'sagittarius_explorer',
        ),
        SymbolicMessage(
          type: 'Tarot',
          symbol: 'Temperance',
          title: 'XIV - Temperance',
          meaning: 'Balance and patience. Find the middle way between extremes.',
          imageHint: 'temperance',
        ),
      ],
      ZodiacSign.capricorn: [
        SymbolicMessage(
          type: 'Archetype',
          symbol: 'Sage',
          title: 'Sage of the Mountain',
          meaning: 'Those who climb to the summit return to guide others. Your experience lights the way for others.',
          imageHint: 'capricorn_sage',
        ),
        SymbolicMessage(
          type: 'Tarot',
          symbol: 'Devil',
          title: 'XV - The Devil',
          meaning: 'Chains or choices? Do the things you\'re attached to define you?',
          imageHint: 'devil',
        ),
      ],
      ZodiacSign.aquarius: [
        SymbolicMessage(
          type: 'Archetype',
          symbol: 'Revolutionary',
          title: 'Visionary Revolutionary',
          meaning: 'You see the future from today. Your ideas are ahead of their time.',
          imageHint: 'aquarius_revolutionary',
        ),
        SymbolicMessage(
          type: 'Tarot',
          symbol: 'Star',
          title: 'XVII - The Star',
          meaning: 'Hope, inspiration and guidance. Even in the darkest night, stars shine.',
          imageHint: 'star',
        ),
      ],
      ZodiacSign.pisces: [
        SymbolicMessage(
          type: 'Archetype',
          symbol: 'Dreamer',
          title: 'Mystic Dreamer',
          meaning: 'You swim between worlds. Your dreams carry messages, listen.',
          imageHint: 'pisces_dreamer',
        ),
        SymbolicMessage(
          type: 'Tarot',
          symbol: 'Moon',
          title: 'XVIII - The Moon',
          meaning: 'Intuition, illusion and subconscious. Look behind what\'s visible.',
          imageHint: 'moon',
        ),
      ],
    };
    return enArchetypes[sign] ?? [
      SymbolicMessage(
        type: 'Archetype',
        symbol: 'Traveler',
        title: 'Cosmic Traveler',
        meaning: 'The journey continues. Every step is a discovery.',
        imageHint: 'traveler',
      ),
    ];
  }

  static String _generateViralHook(ZodiacSign sign, {AppLanguage language = AppLanguage.tr}) {
    final hookIndex = _random.nextInt(12) + 1;
    final key = 'cosmic_share.viral_hooks.$hookIndex';
    final localized = L10nService.get(key, language);

    final signName = language == AppLanguage.tr ? sign.nameTr : sign.name;

    if (localized != key) {
      return localized.replaceAll('{sign}', signName);
    }

    // Fallback
    final trHooks = [
      'Bugün $signName burçları bir şeylerin farkına varıyor.',
      'Bu enerji sadece birkaç burcu etkiliyor — sen de onlardan birisin.',
      '$signName burçları için kritik bir dönem başlıyor.',
      'Şu an $signName burçlarının çoğu bunu hissediyor.',
      'Bu kozmik hizalanma nadir görülüyor.',
      'Evren bugün $signName burçlarına mesaj gönderiyor.',
      'Rüyaların bugün sana bir şey söylüyor.',
      'Sayılar bugün seninle konuşuyor.',
      'Çakraların uyandığını hissedebiliyor musun?',
      '$signName enerjisi bugün farklı akıyor.',
      'Bu farkındalık tesadüf değil.',
      'Evrenin sana özel bir notu var.',
    ];
    final enHooks = [
      'Today $signName signs are becoming aware of something.',
      'This energy only affects a few signs — you are one of them.',
      'A critical period is beginning for $signName signs.',
      'Right now, most $signName signs are feeling this.',
      'This cosmic alignment is rare.',
      'The universe is sending a message to $signName signs today.',
      'Your dreams are telling you something today.',
      'Numbers are speaking to you today.',
      'Can you feel your chakras awakening?',
      '$signName energy is flowing differently today.',
      'This awareness is no coincidence.',
      'The universe has a special note for you.',
    ];
    final hooks = language == AppLanguage.tr ? trHooks : enHooks;
    return hooks[_random.nextInt(hooks.length)];
  }

  static String _generateSharePrompt({AppLanguage language = AppLanguage.tr}) {
    final promptIndex = _random.nextInt(10) + 1;
    final key = 'cosmic_share.share_prompts.$promptIndex';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;

    // Fallback
    final trPrompts = [
      'Bu sana dokunduysa, birinin de buna ihtiyacı var.',
      'Tanıdığın biri bugün bunu görmeli.',
      'Kalbine dokunan şeyleri paylaşmaktan korkma.',
      'Belki de bu mesaj senin için değil, senin aracılığınla birine ulaşacak.',
      'Evrenin mesajları paylaşıldıkça güçlenir.',
      'Kozmik enerji paylaşıldıkça çoğalır.',
      'Rüya İzini takip edenler için.',
      'Bugünün sayısı sana ne söylüyor?',
      'İçsel yolculuğunu paylaş.',
      'Farkındalık bulaşıcıdır.',
    ];
    final enPrompts = [
      'If this touched you, someone else needs it too.',
      'Someone you know should see this today.',
      'Don\'t be afraid to share what touches your heart.',
      'Maybe this message isn\'t for you, but will reach someone through you.',
      'The universe\'s messages grow stronger when shared.',
      'Cosmic energy multiplies when shared.',
      'For those who follow the Dream Trail.',
      'What is today\'s number telling you?',
      'Share your inner journey.',
      'Awareness is contagious.',
    ];
    final prompts = language == AppLanguage.tr ? trPrompts : enPrompts;
    return prompts[_random.nextInt(prompts.length)];
  }

  static CollectiveMoment _generateCollectiveMoment(ZodiacSign sign, MoonPhase moonPhase, {AppLanguage language = AppLanguage.tr}) {
    final signName = language == AppLanguage.tr ? sign.nameTr : sign.name;

    final mainIndex = _random.nextInt(5) + 1;
    final mainKey = 'cosmic_share.collective.main.$mainIndex';
    final localizedMain = L10nService.get(mainKey, language);

    final subIndex = _random.nextInt(5) + 1;
    final subKey = 'cosmic_share.collective.sub.$subIndex';
    final localizedSub = L10nService.get(subKey, language);

    // Fallback
    final trMainTexts = [
      'Senin burcundan pek çok kişi bugün aynı şeyi hissediyor.',
      'Bu enerji şu an sadece birkaç burcu bu kadar derinden etkiliyor.',
      '$signName burçları için bu dönem özel bir anlam taşıyor.',
      'Bugün $signName burçlarının çoğu benzer bir iç sese kulak veriyor.',
      'Bu kozmik dalga seninle aynı burçta olanları özellikle sarıyor.',
    ];
    final enMainTexts = [
      'Many people of your sign are feeling the same thing today.',
      'This energy is affecting only a few signs so deeply right now.',
      'This period carries special meaning for $signName signs.',
      'Today most $signName signs are listening to a similar inner voice.',
      'This cosmic wave is especially embracing those who share your sign.',
    ];
    final mainTexts = language == AppLanguage.tr ? trMainTexts : enMainTexts;

    final trSubTexts = [
      'Yalnız değilsin.',
      'Evren bu mesajı seçilmiş olanlara gönderiyor.',
      'Bazı şeyler tesadüf değil.',
      'Aynı gökyüzünün altında, aynı hislerle.',
      'Bu farkındalık nadir ve değerli.',
    ];
    final enSubTexts = [
      'You are not alone.',
      'The universe sends this message to the chosen ones.',
      'Some things are not coincidence.',
      'Under the same sky, with the same feelings.',
      'This awareness is rare and precious.',
    ];
    final subTexts = language == AppLanguage.tr ? trSubTexts : enSubTexts;

    return CollectiveMoment(
      mainText: localizedMain != mainKey ? localizedMain.replaceAll('{sign}', signName) : mainTexts[_random.nextInt(mainTexts.length)],
      subText: localizedSub != subKey ? localizedSub : subTexts[_random.nextInt(subTexts.length)],
    );
  }

  static SoftPremiumCuriosity _generatePremiumCuriosity(ZodiacSign sign, {AppLanguage language = AppLanguage.tr}) {
    final curiosityIndex = _random.nextInt(5) + 1;
    final curiosityKey = 'cosmic_share.premium.curiosity.$curiosityIndex';
    final localizedCuriosity = L10nService.get(curiosityKey, language);

    final invitationIndex = _random.nextInt(5) + 1;
    final invitationKey = 'cosmic_share.premium.invitation.$invitationIndex';
    final localizedInvitation = L10nService.get(invitationKey, language);

    // Fallback
    final trCuriosityTexts = [
      'Bu, bugünün sadece bir katmanı.',
      'Bazı kalıplar yüzeyde görünmez.',
      'Her güne ait bir de gizli hikaye var.',
      'Derinlerde daha fazlası saklı.',
      'Bu mesaj bir kapı — gerisinde neler olduğunu merak ediyorsan...',
    ];
    final enCuriosityTexts = [
      'This is just one layer of today.',
      'Some patterns don\'t appear on the surface.',
      'Every day has a hidden story.',
      'There\'s more hidden in the depths.',
      'This message is a door — if you wonder what lies beyond...',
    ];
    final curiosityTexts = language == AppLanguage.tr ? trCuriosityTexts : enCuriosityTexts;

    final trInvitationTexts = [
      'Bazıları bu kalıbı daha derinden keşfetmeyi seçiyor.',
      'Merak edenler için her zaman bir sonraki katman var.',
      'Belki bir gün bu hikayenin tamamını görmek istersin.',
      'Evrenin sana söyleyecek daha çok şeyi var.',
      'İstersen, bu sadece başlangıç olabilir.',
    ];
    final enInvitationTexts = [
      'Some choose to explore this pattern more deeply.',
      'For the curious, there\'s always a next layer.',
      'Maybe one day you\'ll want to see the full story.',
      'The universe has much more to tell you.',
      'If you wish, this could be just the beginning.',
    ];
    final invitationTexts = language == AppLanguage.tr ? trInvitationTexts : enInvitationTexts;

    return SoftPremiumCuriosity(
      curiosityText: localizedCuriosity != curiosityKey ? localizedCuriosity : curiosityTexts[_random.nextInt(curiosityTexts.length)],
      invitationText: localizedInvitation != invitationKey ? localizedInvitation : invitationTexts[_random.nextInt(invitationTexts.length)],
    );
  }

  static List<String> _generateMicroMessages(ZodiacSign sign, {AppLanguage language = AppLanguage.tr}) {
    if (language == AppLanguage.tr) {
      final allMicroMessages = _microMessagesBySign[sign] ?? _defaultMicroMessages;
      final shuffled = List<String>.from(allMicroMessages)..shuffle(_random);
      return shuffled.take(3).toList();
    } else {
      final allMicroMessages = _getEnglishMicroMessages(sign);
      final shuffled = List<String>.from(allMicroMessages)..shuffle(_random);
      return shuffled.take(3).toList();
    }
  }

  static List<String> _getEnglishMicroMessages(ZodiacSign sign) {
    final enMicroMessages = {
      ZodiacSign.aries: [
        'Your silence speaks louder than words today.',
        'Not everyone deserves access to your energy.',
        'Patience is your sharpest weapon today.',
        'Slowing down is not falling behind.',
        'No need to show strength — you\'re already visible.',
      ],
      ZodiacSign.taurus: [
        'Is what you\'re holding carrying you, or are you carrying it?',
        'Your comfort zone is beautiful but don\'t let it become a prison.',
        'Letting go is sometimes the greatest ownership.',
        'Change is not an enemy — it\'s an invitation.',
        'Your roots are strong. Let your branches grow too.',
      ],
      ZodiacSign.gemini: [
        'You don\'t have to follow every thought.',
        'Silence is also an answer.',
        'You have two faces — both are you.',
        'Depth is sometimes more valuable than breadth.',
        'Your contradictions enrich you.',
      ],
      ZodiacSign.cancer: [
        'Vulnerability is not weakness.',
        'Protecting isn\'t loving, it can be suffocating.',
        'The past is a teacher, not a home.',
        'Are your walls protecting you or imprisoning you?',
        'You don\'t need to be perfect to be loved.',
      ],
      ZodiacSign.leo: [
        'You are valuable even without applause.',
        'Who are you when you\'re invisible?',
        'Don\'t let your light extinguish others.',
        'Kingdoms are won through service.',
        'You are already light — you don\'t have to be the sun.',
      ],
      ZodiacSign.virgo: [
        'Be real, not flawless.',
        '"Good enough" is sometimes perfect.',
        'Asking for help is not weakness.',
        'Criticize yourself first, then others.',
        'Don\'t get lost in details — see the big picture.',
      ],
      ZodiacSign.libra: [
        'Saying no is also love.',
        'Everyone\'s happiness is not your responsibility.',
        'Find balance within, not outside.',
        'Conflict is an opportunity for growth.',
        'Indecision is also a decision.',
      ],
      ZodiacSign.scorpio: [
        'Control is an illusion.',
        'You don\'t have to know everything.',
        'Trust is not a risk, it\'s a gift.',
        'Depth is beautiful — but there\'s life on the surface too.',
        'Forgiveness liberates you.',
      ],
      ZodiacSign.sagittarius: [
        'Escape is not a solution.',
        'The answer could be right here.',
        'Attachment is not imprisonment.',
        'Adventure exists within too.',
        'Don\'t promise, do.',
      ],
      ZodiacSign.capricorn: [
        'Success doesn\'t guarantee happiness.',
        'Taking a break is not giving up.',
        'Your feelings also deserve respect.',
        'The journey matters, not the summit.',
        'Don\'t let work become escape.',
      ],
      ZodiacSign.aquarius: [
        'Don\'t be different just to be different.',
        'Not everyone has to understand.',
        'Heart is as important as mind.',
        'Revolution starts within.',
        'Independence is not loneliness.',
      ],
      ZodiacSign.pisces: [
        'Dreams are beautiful — reality is too.',
        'You don\'t have to carry everyone\'s pain.',
        'Boundaries are not lovelessness.',
        'Dreaming is not action.',
        'Don\'t escape, face it.',
      ],
    };
    return enMicroMessages[sign] ?? [
      'Be kind to yourself today.',
      'Trust your intuition.',
      'The answer is already within you.',
    ];
  }

  static const Map<ZodiacSign, List<String>> _microMessagesBySign = {
    ZodiacSign.aries: [
      'Sessizliğin bugün kelimelerinden daha çok iş görüyor.',
      'Herkes enerjine erişmeyi hak etmiyor.',
      'Sabır bugün en keskin silahın.',
      'Yavaşlamak geri kalmak değil.',
      'Güç göstermeye gerek yok — sen zaten görünüyorsun.',
    ],
    ZodiacSign.taurus: [
      'Tutunduğun şey seni mi taşıyor, yoksa sen mi onu?',
      'Konfor alanın güzel ama hapishane olmasın.',
      'Bırakmak bazen en büyük sahiplenme.',
      'Değişim düşman değil — davet.',
      'Köklerin sağlam. Dalların da büyüsün.',
    ],
    ZodiacSign.gemini: [
      'Her düşünceni takip etmek zorunda değilsin.',
      'Sessizlik de bir cevap.',
      'İki yüzün var — ikisi de sensin.',
      'Derinlik genişlikten değerli bazen.',
      'Çelişkilerin seni zenginleştiriyor.',
    ],
    ZodiacSign.cancer: [
      'Kırılganlık zayıflık değil.',
      'Korumak sevmek değil, boğmak olabilir.',
      'Geçmiş öğretmen, ev değil.',
      'Duvarların seni koruyor mu, hapsediyor mu?',
      'Sevilmek için mükemmel olmana gerek yok.',
    ],
    ZodiacSign.leo: [
      'Alkış olmadan da değerlisin.',
      'Görünmez olduğunda kim oluyorsun?',
      'Işığın başkalarını söndürmesin.',
      'Krallık hizmetle kazanılır.',
      'Sen zaten ışıksın — güneş olmak zorunda değilsin.',
    ],
    ZodiacSign.virgo: [
      'Kusursuz değil, gerçek ol.',
      '"Yeterince iyi" bazen mükemmel.',
      'Yardım istemek zayıflık değil.',
      'Eleştiri önce kendine, sonra başkalarına.',
      'Detaylarda kaybolma — büyük resmi gör.',
    ],
    ZodiacSign.libra: [
      'Hayır demek de sevgi.',
      'Herkesin mutluluğu senin sorumluluğun değil.',
      'Dengeyi kendinde bul, dışarıda arama.',
      'Çatışma büyüme fırsatı.',
      'Kararsızlık da bir karar.',
    ],
    ZodiacSign.scorpio: [
      'Kontrol illüzyon.',
      'Her şeyi bilmek zorunda değilsin.',
      'Güvenmek risk değil, hediye.',
      'Derinlik güzel — ama yüzeyde de yaşam var.',
      'Affetmek seni özgürleştirir.',
    ],
    ZodiacSign.sagittarius: [
      'Kaçış çözüm değil.',
      'Cevap burada da olabilir.',
      'Bağlanmak hapsolmak değil.',
      'Macera içeride de var.',
      'Vaat etme, yap.',
    ],
    ZodiacSign.capricorn: [
      'Başarı mutluluk garantisi değil.',
      'Mola vermek vazgeçmek değil.',
      'Duyguların da saygıyı hak ediyor.',
      'Zirve değil, yolculuk önemli.',
      'Çalışmak kaçış olmasın.',
    ],
    ZodiacSign.aquarius: [
      'Farklı olmak için farklı olma.',
      'Herkes anlamak zorunda değil.',
      'Kalp de akıl kadar önemli.',
      'Devrim önce kendinde.',
      'Bağımsızlık yalnızlık değil.',
    ],
    ZodiacSign.pisces: [
      'Rüya güzel — gerçeklik de.',
      'Herkesin acısını taşımak zorunda değilsin.',
      'Sınırlar sevgisizlik değil.',
      'Hayal kurmak eylem değil.',
      'Kaçış değil, yüzleş.',
    ],
  };

  static const _defaultMicroMessages = [
    'Bugün kendine nazik ol.',
    'Sezgilerine güven.',
    'Cevap zaten içinde.',
  ];

  // Helper methods
  static String _formatDate(DateTime date, {AppLanguage language = AppLanguage.tr}) {
    final monthKey = 'common.months.${date.month}';
    final dayKey = 'common.days.${date.weekday}';

    final localizedMonth = L10nService.get(monthKey, language);
    final localizedDay = L10nService.get(dayKey, language);

    // If localization found, use it; otherwise fallback
    if (localizedMonth != monthKey && localizedDay != dayKey) {
      return '${date.day} $localizedMonth ${date.year} · $localizedDay';
    }

    // Fallback
    final trMonths = ['Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'];
    final enMonths = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    final trDays = ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'];
    final enDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    final months = language == AppLanguage.tr ? trMonths : enMonths;
    final days = language == AppLanguage.tr ? trDays : enDays;
    return '${date.day} ${months[date.month - 1]} ${date.year} · ${days[date.weekday - 1]}';
  }

  static String _getMoonPhaseText(MoonPhase phase, {AppLanguage language = AppLanguage.tr}) {
    final key = 'cosmic_share.moon_phases.${phase.name}';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;

    // Fallback
    final trTexts = {
      MoonPhase.newMoon: 'Yeni Ay — Başlangıçların zamanı',
      MoonPhase.waxingCrescent: 'Hilal Ay — Niyetler filizleniyor',
      MoonPhase.firstQuarter: 'İlk Dördün — Karar zamanı',
      MoonPhase.waxingGibbous: 'Şişkin Ay — Momentum artıyor',
      MoonPhase.fullMoon: 'Dolunay — Aydınlanma ve tamamlanma',
      MoonPhase.waningGibbous: 'Küçülen Ay — Minnettarlık zamanı',
      MoonPhase.lastQuarter: 'Son Dördün — Bırakma zamanı',
      MoonPhase.waningCrescent: 'Balzamik Ay — Dinlenme ve hazırlık',
    };
    final enTexts = {
      MoonPhase.newMoon: 'New Moon — Time of beginnings',
      MoonPhase.waxingCrescent: 'Waxing Crescent — Intentions sprouting',
      MoonPhase.firstQuarter: 'First Quarter — Decision time',
      MoonPhase.waxingGibbous: 'Waxing Gibbous — Momentum building',
      MoonPhase.fullMoon: 'Full Moon — Illumination and completion',
      MoonPhase.waningGibbous: 'Waning Gibbous — Time for gratitude',
      MoonPhase.lastQuarter: 'Last Quarter — Time to release',
      MoonPhase.waningCrescent: 'Balsamic Moon — Rest and preparation',
    };
    return language == AppLanguage.tr ? trTexts[phase]! : enTexts[phase]!;
  }

  static String _getMoonPhaseEmoji(MoonPhase phase) {
    switch (phase) {
      case MoonPhase.newMoon:
        return '🌑';
      case MoonPhase.waxingCrescent:
        return '🌒';
      case MoonPhase.firstQuarter:
        return '🌓';
      case MoonPhase.waxingGibbous:
        return '🌔';
      case MoonPhase.fullMoon:
        return '🌕';
      case MoonPhase.waningGibbous:
        return '🌖';
      case MoonPhase.lastQuarter:
        return '🌗';
      case MoonPhase.waningCrescent:
        return '🌘';
    }
  }

  static String _getEmotionalCore(ZodiacSign sign, {AppLanguage language = AppLanguage.tr}) {
    final key = 'cosmic_share.emotional_cores.${sign.name}';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;

    final trCores = {
      ZodiacSign.aries: 'Cesaretinin kaynağı',
      ZodiacSign.taurus: 'Huzurunun temeli',
      ZodiacSign.gemini: 'Merakının kıvılcımı',
      ZodiacSign.cancer: 'Duygularının derinliği',
      ZodiacSign.leo: 'Işığının merkezi',
      ZodiacSign.virgo: 'Mükemmellik arayışın',
      ZodiacSign.libra: 'Uyumun özü',
      ZodiacSign.scorpio: 'Dönüşüm gücün',
      ZodiacSign.sagittarius: 'Özgürlük tutkun',
      ZodiacSign.capricorn: 'Azmin kaynağı',
      ZodiacSign.aquarius: 'Farklılığının değeri',
      ZodiacSign.pisces: 'Sezgilerinin sesi',
    };
    final enCores = {
      ZodiacSign.aries: 'Source of your courage',
      ZodiacSign.taurus: 'Foundation of your peace',
      ZodiacSign.gemini: 'Spark of your curiosity',
      ZodiacSign.cancer: 'Depth of your emotions',
      ZodiacSign.leo: 'Center of your light',
      ZodiacSign.virgo: 'Your pursuit of perfection',
      ZodiacSign.libra: 'Essence of your harmony',
      ZodiacSign.scorpio: 'Your transformative power',
      ZodiacSign.sagittarius: 'Your passion for freedom',
      ZodiacSign.capricorn: 'Source of your determination',
      ZodiacSign.aquarius: 'Value of your uniqueness',
      ZodiacSign.pisces: 'Voice of your intuition',
    };
    final cores = language == AppLanguage.tr ? trCores : enCores;
    return cores[sign] ?? (language == AppLanguage.tr ? 'Ruhunun özü' : 'Essence of your soul');
  }

  static String _getEnergyDescription(int level, {AppLanguage language = AppLanguage.tr}) {
    String key;
    if (level >= 80) {
      key = 'cosmic_share.energy.peak';
    } else if (level >= 60) {
      key = 'cosmic_share.energy.high';
    } else if (level >= 40) {
      key = 'cosmic_share.energy.balanced';
    } else if (level >= 20) {
      key = 'cosmic_share.energy.low';
    } else {
      key = 'cosmic_share.energy.recharge';
    }

    final localized = L10nService.get(key, language);
    if (localized != key) return localized;

    // Fallback
    final trDescs = {
      'cosmic_share.energy.peak': 'Doruk noktasında',
      'cosmic_share.energy.high': 'Yüksek enerji',
      'cosmic_share.energy.balanced': 'Dengeli akış',
      'cosmic_share.energy.low': 'Dinlenme modunda',
      'cosmic_share.energy.recharge': 'Şarj zamanı',
    };
    final enDescs = {
      'cosmic_share.energy.peak': 'At peak level',
      'cosmic_share.energy.high': 'High energy',
      'cosmic_share.energy.balanced': 'Balanced flow',
      'cosmic_share.energy.low': 'Resting mode',
      'cosmic_share.energy.recharge': 'Time to recharge',
    };
    return language == AppLanguage.tr ? trDescs[key]! : enDescs[key]!;
  }

  static String _getIntensityDescription(String intensity, {AppLanguage language = AppLanguage.tr}) {
    final key = 'cosmic_share.intensity.$intensity';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;

    // Fallback
    final trDescs = {
      'calm': 'Sakin ve dingin',
      'rising': 'Yükselen dalga',
      'intense': 'Yoğun ve derin',
      'stormy': 'Fırtınalı enerji',
    };
    final enDescs = {
      'calm': 'Calm and serene',
      'rising': 'Rising wave',
      'intense': 'Intense and deep',
      'stormy': 'Stormy energy',
    };
    return language == AppLanguage.tr ? (trDescs[intensity] ?? 'Dengeli') : (enDescs[intensity] ?? 'Balanced');
  }

  static String _getIntuitionDescription(int level, {AppLanguage language = AppLanguage.tr}) {
    String key;
    if (level >= 80) {
      key = 'cosmic_share.intuition.peak';
    } else if (level >= 60) {
      key = 'cosmic_share.intuition.high';
    } else if (level >= 40) {
      key = 'cosmic_share.intuition.balanced';
    } else if (level >= 20) {
      key = 'cosmic_share.intuition.low';
    } else {
      key = 'cosmic_share.intuition.analytical';
    }

    final localized = L10nService.get(key, language);
    if (localized != key) return localized;

    // Fallback
    final trDescs = {
      'cosmic_share.intuition.peak': 'Sezgiler dorukta',
      'cosmic_share.intuition.high': 'Güçlü sezgisel akış',
      'cosmic_share.intuition.balanced': 'Dengeli farkındalık',
      'cosmic_share.intuition.low': 'Mantık önde',
      'cosmic_share.intuition.analytical': 'Analitik mod',
    };
    final enDescs = {
      'cosmic_share.intuition.peak': 'Intuition at peak',
      'cosmic_share.intuition.high': 'Strong intuitive flow',
      'cosmic_share.intuition.balanced': 'Balanced awareness',
      'cosmic_share.intuition.low': 'Logic leads',
      'cosmic_share.intuition.analytical': 'Analytical mode',
    };
    return language == AppLanguage.tr ? trDescs[key]! : enDescs[key]!;
  }

  static List<Planet> _getDominantPlanets(ZodiacSign sign, DateTime today) {
    // Simplified - would normally use ephemeris
    final rulers = {
      ZodiacSign.aries: Planet.mars,
      ZodiacSign.taurus: Planet.venus,
      ZodiacSign.gemini: Planet.mercury,
      ZodiacSign.cancer: Planet.moon,
      ZodiacSign.leo: Planet.sun,
      ZodiacSign.virgo: Planet.mercury,
      ZodiacSign.libra: Planet.venus,
      ZodiacSign.scorpio: Planet.mars,
      ZodiacSign.sagittarius: Planet.jupiter,
      ZodiacSign.capricorn: Planet.saturn,
      ZodiacSign.aquarius: Planet.saturn,
      ZodiacSign.pisces: Planet.jupiter,
    };
    return [rulers[sign] ?? Planet.sun];
  }

  static String _getPlanetSymbol(Planet planet) {
    switch (planet) {
      case Planet.sun:
        return '☉';
      case Planet.moon:
        return '☽';
      case Planet.mercury:
        return '☿';
      case Planet.venus:
        return '♀';
      case Planet.mars:
        return '♂';
      case Planet.jupiter:
        return '♃';
      case Planet.saturn:
        return '♄';
      default:
        return '✧';
    }
  }

  static ZodiacSign _getCompatibleSign(ZodiacSign sign) {
    final compatible = {
      ZodiacSign.aries: ZodiacSign.leo,
      ZodiacSign.taurus: ZodiacSign.virgo,
      ZodiacSign.gemini: ZodiacSign.libra,
      ZodiacSign.cancer: ZodiacSign.scorpio,
      ZodiacSign.leo: ZodiacSign.sagittarius,
      ZodiacSign.virgo: ZodiacSign.capricorn,
      ZodiacSign.libra: ZodiacSign.aquarius,
      ZodiacSign.scorpio: ZodiacSign.pisces,
      ZodiacSign.sagittarius: ZodiacSign.aries,
      ZodiacSign.capricorn: ZodiacSign.taurus,
      ZodiacSign.aquarius: ZodiacSign.gemini,
      ZodiacSign.pisces: ZodiacSign.cancer,
    };
    return compatible[sign] ?? ZodiacSign.aries;
  }

  // Static data maps
  static const Map<ZodiacSign, List<String>> _heroHeadlines = {
    ZodiacSign.aries: [
      'Bugün cesaretin test ediliyor.',
      'Ateşin içinden geçme zamanı.',
      'Liderlik sende. Harekete geç.',
    ],
    ZodiacSign.taurus: [
      'Köklerin seni taşıyor.',
      'Sabır bugün en büyük gücün.',
      'Değerini bil, taviz verme.',
    ],
    ZodiacSign.gemini: [
      'İki dünya arasında dans ediyorsun.',
      'Kelimeler bugün silahın.',
      'Merakın kapıları açıyor.',
    ],
    ZodiacSign.cancer: [
      'Ay seninle konuşuyor.',
      'Duygularının derinliğinde cevap var.',
      'Koruyucu kabuğun altında güç saklı.',
    ],
    ZodiacSign.leo: [
      'Güneş senin için doğuyor.',
      'Işığın karanlığı yırtıyor.',
      'Kral/Kraliçe, tahtın hazır.',
    ],
    ZodiacSign.virgo: [
      'Detaylarda evren gizli.',
      'Mükemmellik değil, anlam ara.',
      'Şifa veren ellerin var.',
    ],
    ZodiacSign.libra: [
      'Denge noktasındasın.',
      'Güzellik ve adalet senin silahın.',
      'İlişkilerde dönüşüm zamanı.',
    ],
    ZodiacSign.scorpio: [
      'Karanlıktan korkmuyorsun.',
      'Dönüşüm temaları güçlü. Hazır mısın?',
      'Derinliklerde hazine var.',
    ],
    ZodiacSign.sagittarius: [
      'Ufuk seni çağırıyor.',
      'Ok yaydan çıkmak üzere.',
      'Özgürlük senin doğum hakkın.',
    ],
    ZodiacSign.capricorn: [
      'Zirve görüş mesafesinde.',
      'Disiplin bugün süper gücün.',
      'Zamanın ustası sensin.',
    ],
    ZodiacSign.aquarius: [
      'Geleceği sen yazıyorsun.',
      'Farklılığın senin armağanın.',
      'Devrim içinden başlıyor.',
    ],
    ZodiacSign.pisces: [
      'Rüyalar gerçeğe dönüşüyor.',
      'Sezgilerin hiç bu kadar keskin olmamıştı.',
      'Okyanus derinliğinde yüzüyorsun.',
    ],
  };

  static const _defaultHeroHeadlines = [
    'Evren bugün seninle konuşuyor.',
    'Yıldızlar senin için hizalandı.',
  ];

  static const Map<ZodiacSign, List<String>> _personalMessages = {
    ZodiacSign.aries: [
      'İçindeki ateş bugün farklı yanıyor. Belki de savaşman gereken şey dışarıda değil, kendi içinde. O sabırsızlık, o hemen şimdi isteği — dur bir an. Gerçek cesaret bazen beklemektir. Bugün acele etme, ama hareketsiz de kalma. Ortada bir yol var ve sen onu bulabilirsin.',
      'Herkes senin gücünü görüyor ama kimse yorgunluğunu bilmiyor. Bugün kendine şunu sor: Kimin için savaşıyorum? Cevap "kendim için" değilse, strateji değiştirme zamanı. Enerjin sınırsız değil, onu doğru yere yatır.',
    ],
    ZodiacSign.taurus: [
      'Konfor alanın güzel ama hapishaneye dönüşmesin. Bugün bir şeyi bırakman gerekebilir — bir alışkanlık, bir düşünce, belki de bir kişi. Köklerin sağlam, ama dalların da büyümesi gerek. Değişim düşman değil, davetiye.',
      'Sahip olduklarına sıkı sıkı tutunuyorsun ama soruyorum: Onlar seni mi tanımlıyor? Bugün "yeterince" kelimesini hatırla. Sen zaten bütünsün. Dış dünya bunu onaylamasa bile.',
    ],
    ZodiacSign.gemini: [
      'Zihnin bugün 100 farklı yöne koşuyor. Hepsi ilginç, hepsi parlak — ama hangisi gerçek? O gürültünün altında sessiz bir ses var. Bugün onu duy. Cevap dışarıda değil, tüm o düşüncelerin arasında saklı.',
      'İki yüzün var diyorlar ama ikisi de sensin. Bugün birini seçmek zorunda değilsin. Çelişkilerin seni zayıflatmıyor, zenginleştiriyor. O "ama"ları kucakla.',
    ],
    ZodiacSign.cancer: [
      'Duygularını korumak için ördüğün duvarlar seni koruyor ama aynı zamanda yalnızlaştırıyor. Bugün bir kapı aç — küçük olsun, ama aç. Kırılganlık zayıflık değil, en saf güç. Sevilmek için mükemmel olmana gerek yok.',
      'Geçmiş bugün kapını çalacak. Bir anı, bir koku, bir şarkı. Ona sarılabilirsin ama orada kalma. Ayların döngüsü gibi sen de değişiyorsun. Eskiyi onurlandır, ama bugünü yaşa.',
    ],
    ZodiacSign.leo: [
      'Herkes seni sahne ışıklarında görüyor ama kimse kulis arkasını bilmiyor. O alkışlar güzel, ama sen onlarsız da değerlisin. Bugün kendine sor: Parladığımda mı seviliyorum, yoksa sadece ben olduğumda mı? Cevap seni özgürleştirecek.',
      'Krallık yorucu. Taç ağır. Bugün onu indir, sadece sen ol. Güneş olmak zorunda değilsin — sen zaten ışıksın. Başkalarının gözlerinde kendini aramayı bırak.',
    ],
    ZodiacSign.virgo: [
      'Mükemmellik peşinde koşarken kaçırdıklarını gördün mü? Bugün kusurlarına bak — orada güzellik var. Detaylara takılma, büyük resmi gör. Bazen "yeterince iyi" aslında mükemmeldir.',
      'Herkese yardım ediyorsun ama sana kim yardım ediyor? Bugün almayı öğren. Vermek kolay, kabul etmek cesaret ister. Sen de bakılmayı hak ediyorsun.',
    ],
    ZodiacSign.libra: [
      'Dengeyi ararken kendi ağırlığını unuttun mu? Bugün tarafa geç — sadece bugünlük. Herkesi memnun etmek zorunda değilsin. Senin "hayır"ın da güzel bir kelime.',
      'Aynaya bak. Gördüğün kişi başkalarının istediği sen mi, yoksa gerçek sen mi? Bugün maskeleri indir. Çirkin görüneceğinden korkma — gerçeklik her zaman güzeldir.',
    ],
    ZodiacSign.scorpio: [
      'Derinlere dalıyorsun yine. Karanlık seni korkutmuyor, biliyorum. Ama bugün ışığa da izin ver. Her sır çözülmek zorunda değil. Bazı gizemler bırakıldığında anlam kazanır.',
      'Kontrol ihtiyacın seni tüketiyor. Bugün bir şeyi akışa bırak. Evren senin yerine çalışsın biraz. Güvenmek zayıflık değil, en büyük dönüşüm.',
    ],
    ZodiacSign.sagittarius: [
      'Ufuk güzel ama ayaklarının altındaki toprağı da gör. Bugün kaçmak yerine kal. Cevap uzaklarda değil, tam burada olabilir. Macera bazen bir adım geri atmaktır.',
      'Özgürlük adına ne feda ettin? Bağlar hapishane değil — doğru olanlar kanat olur. Bugün "bağlanmak"tan korkma. Sevgi de bir macera.',
    ],
    ZodiacSign.capricorn: [
      'Zirveye tırmanırken manzarayı gördün mü? Dur bir an. Başarı listeleri değil, anılar bırakır. Bugün hedefleri unut, anı yaşa. Disiplin ara verince çökmez, nefes alır.',
      'Güçlü olmak zorunda değilsin. Her zaman değil. Bugün zırhı indir, kırılganlığını göster. Saygı değil, sevgi kazanma teması güçlü.',
    ],
    ZodiacSign.aquarius: [
      'Herkesten farklısın ve bu yorucu olabiliyor. Bugün anlaşılmak için değiştirme kendini. Evren seni böyle yarattı — orijinal. Kalabalıkta yalnız hissetmek, yanlış kalabalıkta olmak demek.',
      'Geleceği düşünürken bugünü kaçırma. Devrimler büyük patlamalarla değil, küçük kararlarla başlar. Bugün küçük bir şey değiştir — kendinde.',
    ],
    ZodiacSign.pisces: [
      'Rüyalar ve gerçeklik arasında yüzüyorsun. Bugün ayaklarını yere bas — sadece bir an için. Hayal kurmak güzel ama yaşamak da öyle. Sezgilerin seni doğru yere götürüyor, güven.',
      'Herkesin acısını hissediyorsun ama seninki nerede? Bugün empati sınırlarını çiz. Başkalarını kurtarmak için önce sen sağlam olmalısın. Kendi okyanusunda boğulma.',
    ],
  };

  static const _defaultPersonalMessages = [
    'Bugün evren sana özel bir mesaj gönderiyor. Dinle.',
  ];

  static const Map<ZodiacSign, String> _risingInfluence = {
    ZodiacSign.aries: 'Yükselen Koç etkisi seni daha cesur kılıyor.',
    ZodiacSign.taurus: 'Yükselen Boğa sana istikrar getiriyor.',
    ZodiacSign.gemini: 'Yükselen İkizler iletişimini güçlendiriyor.',
    ZodiacSign.cancer: 'Yükselen Yengeç sezgilerini keskinleştiriyor.',
    ZodiacSign.leo: 'Yükselen Aslan karizmana katkı sağlıyor.',
    ZodiacSign.virgo: 'Yükselen Başak detaylara dikkatini artırıyor.',
    ZodiacSign.libra: 'Yükselen Terazi dengeleme yeteneğini güçlendiriyor.',
    ZodiacSign.scorpio: 'Yükselen Akrep derinliğini artırıyor.',
    ZodiacSign.sagittarius: 'Yükselen Yay iyimserliğini besliyor.',
    ZodiacSign.capricorn: 'Yükselen Oğlak kararlılığını pekiştiriyor.',
    ZodiacSign.aquarius: 'Yükselen Kova özgünlüğünü öne çıkarıyor.',
    ZodiacSign.pisces: 'Yükselen Balık empati gücünü artırıyor.',
  };

  static const Map<ZodiacSign, String> _moonInfluence = {
    ZodiacSign.aries: 'Ay\'ın Koç\'ta olması duygularını ateşliyor.',
    ZodiacSign.taurus: 'Ay\'ın Boğa\'da olması seni topraklıyor.',
    ZodiacSign.gemini: 'Ay\'ın İkizler\'de olması zihnini hareketlendiriyor.',
    ZodiacSign.cancer: 'Ay\'ın Yengeç\'te olması duygusal derinlik katıyor.',
    ZodiacSign.leo: 'Ay\'ın Aslan\'da olması özgüvenini artırıyor.',
    ZodiacSign.virgo: 'Ay\'ın Başak\'ta olması pratikliğini güçlendiriyor.',
    ZodiacSign.libra: 'Ay\'ın Terazi\'de olması ilişkilere odaklanmanı sağlıyor.',
    ZodiacSign.scorpio: 'Ay\'ın Akrep\'te olması yoğunluğunu artırıyor.',
    ZodiacSign.sagittarius: 'Ay\'ın Yay\'da olması macera ruhunu canlandırıyor.',
    ZodiacSign.capricorn: 'Ay\'ın Oğlak\'ta olması disiplinini güçlendiriyor.',
    ZodiacSign.aquarius: 'Ay\'ın Kova\'da olması yenilikçiliğini öne çıkarıyor.',
    ZodiacSign.pisces: 'Ay\'ın Balık\'ta olması sezgilerini zirveye taşıyor.',
  };

  static final Map<ZodiacSign, ShadowData> _shadowData = {
    ZodiacSign.aries: ShadowData(
      challenge: 'Sabırsızlık seni yanlış kararlara itiyor.',
      fear: 'Yetersiz görünme korkusu',
      pattern: 'Düşünmeden atılma, sonra pişmanlık.',
    ),
    ZodiacSign.taurus: ShadowData(
      challenge: 'İnatçılık fırsatları kaçırıyor.',
      fear: 'Kontrol kaybı ve güvensizlik',
      pattern: 'Değişime direnme, sonra zorla uyum.',
    ),
    ZodiacSign.gemini: ShadowData(
      challenge: 'Dağınıklık odaklanmayı engelliyor.',
      fear: 'Sıkışmak ve sıkılmak',
      pattern: 'Her şeye başla, hiçbirini bitirme.',
    ),
    ZodiacSign.cancer: ShadowData(
      challenge: 'Aşırı duygusallık kararları bulandırıyor.',
      fear: 'Reddedilme ve terk edilme',
      pattern: 'Savunmaya geçme, duvarları yükseltme.',
    ),
    ZodiacSign.leo: ShadowData(
      challenge: 'Ego başkalarını uzaklaştırıyor.',
      fear: 'Görünmez ve önemsiz hissetmek',
      pattern: 'Onay arayışı, sonra hayal kırıklığı.',
    ),
    ZodiacSign.virgo: ShadowData(
      challenge: 'Mükemmeliyetçilik felç ediyor.',
      fear: 'Eleştiri ve hata yapma',
      pattern: 'Aşırı analiz, sonra hareketsizlik.',
    ),
    ZodiacSign.libra: ShadowData(
      challenge: 'Kararsızlık zamanı çalıyor.',
      fear: 'Çatışma ve sevilmemek',
      pattern: 'Herkesi memnun etmeye çalış, kendini kaybet.',
    ),
    ZodiacSign.scorpio: ShadowData(
      challenge: 'Kontrol ihtiyacı ilişkileri zehirliyor.',
      fear: 'İhanet ve güç kaybı',
      pattern: 'Test etme, sonra kendini gerçekleştiren kehanet.',
    ),
    ZodiacSign.sagittarius: ShadowData(
      challenge: 'Kaçış eğilimi sorunları büyütüyor.',
      fear: 'Bağlanmak ve sınırlanmak',
      pattern: 'Zor olunca git, sonra pişmanlık.',
    ),
    ZodiacSign.capricorn: ShadowData(
      challenge: 'İş bağımlılığı ilişkileri ihmal ediyor.',
      fear: 'Başarısızlık ve statü kaybı',
      pattern: 'Hissetmekten kaç, işe gömül.',
    ),
    ZodiacSign.aquarius: ShadowData(
      challenge: 'Duygusal mesafe yalnızlaştırıyor.',
      fear: 'Sıradanlık ve uyum baskısı',
      pattern: 'Farklı olmak için farklı ol, özü kaybet.',
    ),
    ZodiacSign.pisces: ShadowData(
      challenge: 'Kaçış mekanizmaları gerçeklikten koparıyor.',
      fear: 'Acı ve hayal kırıklığı',
      pattern: 'Hayal kur, sonra gerçeklikle çarpış.',
    ),
  };

  static const _defaultShadowData = ShadowData(
    challenge: 'İç çatışmalar netliği engelliyor.',
    fear: 'Bilinmeyenden korku',
    pattern: 'Tekrarlayan döngüler.',
  );

  static final Map<ZodiacSign, LightData> _lightData = {
    ZodiacSign.aries: LightData(
      strength: 'Cesaret ve öncülük',
      opportunity: 'Yeni bir başlangıç için ideal gün',
      magnetic: 'Enerjin bulaşıcı, insanlar sana çekiliyor.',
    ),
    ZodiacSign.taurus: LightData(
      strength: 'Sadakat ve güvenilirlik',
      opportunity: 'Değerlerini netleştirme zamanı',
      magnetic: 'Sakinliğin güven veriyor, insanlar yanında huzur buluyor.',
    ),
    ZodiacSign.gemini: LightData(
      strength: 'Uyum sağlama ve iletişim',
      opportunity: 'Önemli bir konuşma için açıklık',
      magnetic: 'Zekan parıldıyor, fikirlerin ilgi çekiyor.',
    ),
    ZodiacSign.cancer: LightData(
      strength: 'Empati ve koruyuculuk',
      opportunity: 'Duygusal bağları derinleştirme',
      magnetic: 'Sıcaklığın eve benziyorsun, insanlar sana açılıyor.',
    ),
    ZodiacSign.leo: LightData(
      strength: 'Yaratıcılık ve cömertlik',
      opportunity: 'Kendini ifade etme cesareti',
      magnetic: 'Varlığın ışık saçıyor, gözler sende.',
    ),
    ZodiacSign.virgo: LightData(
      strength: 'Analiz gücü ve hizmet kalbi',
      opportunity: 'Bir sorunu çözme yeteneği dorukta',
      magnetic: 'Yetkinliğin güven veriyor, danışman gibisin.',
    ),
    ZodiacSign.libra: LightData(
      strength: 'Diplomasi ve estetik',
      opportunity: 'Çatışmaları çözme gücü',
      magnetic: 'Zarafetin büyülüyor, herkes seninle olmak istiyor.',
    ),
    ZodiacSign.scorpio: LightData(
      strength: 'Derinlik ve dönüşüm gücü',
      opportunity: 'Eski bir yaraya şifa getirme',
      magnetic: 'Gizem çekici, insanlar seni çözmek istiyor.',
    ),
    ZodiacSign.sagittarius: LightData(
      strength: 'İyimserlik ve vizyon',
      opportunity: 'Yeni ufuklar açılıyor',
      magnetic: 'Macera ruhun bulaşıcı, heyecan veriyorsun.',
    ),
    ZodiacSign.capricorn: LightData(
      strength: 'Disiplin ve dayanıklılık',
      opportunity: 'Uzun vadeli bir adım için netlik',
      magnetic: 'Otoriten saygı uyandırıyor, sözün dinleniyor.',
    ),
    ZodiacSign.aquarius: LightData(
      strength: 'Özgünlük ve insancıllık',
      opportunity: 'Farklı bir bakış açısı sunma',
      magnetic: 'Benzersizliğin çekiyor, ilham kaynağısın.',
    ),
    ZodiacSign.pisces: LightData(
      strength: 'Sezgi ve yaratıcı hayal gücü',
      opportunity: 'Sanatsal veya ruhsal bir açılım',
      magnetic: 'Gizemli auran büyülüyor, rüya gibisin.',
    ),
  };

  static const _defaultLightData = LightData(
    strength: 'İçsel güç ve potansiyel',
    opportunity: 'Yeni fırsatlar beliriyor',
    magnetic: 'Enerjin insanları çekiyor.',
  );

  static final Map<ZodiacSign, List<String>> _cosmicAdvice = {
    ZodiacSign.aries: [
      'Dur. Nefes al. Sonra hareket et.',
      'Öfken mesajcı, ama sen karar vericisin.',
      'Savaş kazanmak değil, barış kurmak için de cesaret gerek.',
      'İlk olmak değil, doğru olmak önemli.',
      'Güç gösterisine gerek yok, sen zaten güçlüsün.',
    ],
    ZodiacSign.taurus: [
      'Bırakmak kaybetmek değil.',
      'Konfor alanın güvenli ama büyüme orada yok.',
      'Sahip oldukların seni tanımlamıyor.',
      'Yavaş ol ama durma.',
      'Değer gördüğün yerde kal, görmediğin yerde kalma.',
    ],
    ZodiacSign.gemini: [
      'Her düşünceyi takip etmek zorunda değilsin.',
      'Sessizlik de bir cevap.',
      'Derinlik, genişlikten daha değerli bazen.',
      'İki yol arasında kalmak da bir yol.',
      'Dinlemek de iletişim.',
    ],
    ZodiacSign.cancer: [
      'Korumak sevmek değil, boğmak olabilir.',
      'Geçmiş öğretmen, ev değil.',
      'Duvarların seni koruyor mu, hapsediyor mu?',
      'Kırılganlık güçsüzlük değil.',
      'Bazen en iyi bakım, bırakmak.',
    ],
    ZodiacSign.leo: [
      'Işığın başkalarını söndürmesin.',
      'Alkış olmadan da değerlisin.',
      'Krallık hizmetle kazanılır.',
      'Gurur koruyucu değil, hapishane olabilir.',
      'Görünmez olduğunda kim oluyorsun?',
    ],
    ZodiacSign.virgo: [
      'Kusursuz değil, gerçek ol.',
      'Eleştiri önce kendine, sonra başkalarına.',
      '"Yeterince iyi" bazen mükemmel.',
      'Yardım istemek zayıflık değil.',
      'Analiz felç ederse, hisset.',
    ],
    ZodiacSign.libra: [
      'Hayır demek de sevgi.',
      'Dengeyi kendinde bul, dışarıda arama.',
      'Çatışma büyüme fırsatı.',
      'Herkesin mutluluğu senin sorumluluğun değil.',
      'Kararsızlık da bir karar.',
    ],
    ZodiacSign.scorpio: [
      'Kontrol illüzyon.',
      'Güvenmek risk değil, hediye.',
      'Her şeyi bilmek zorunda değilsin.',
      'İntikam seni zehirler, affetmek özgürleştirir.',
      'Derinlik güzel, ama yüzeyde de yaşam var.',
    ],
    ZodiacSign.sagittarius: [
      'Kaçış çözüm değil.',
      'Bağlanmak hapsolmak değil.',
      'Cevap burada da olabilir.',
      'Vaat etme, yap.',
      'Macera içeride de var.',
    ],
    ZodiacSign.capricorn: [
      'Başarı mutluluk garantisi değil.',
      'Çalışmak kaçış olmasın.',
      'Zirve değil, yolculuk önemli.',
      'Duyguların da saygıyı hak ediyor.',
      'Mola vermek vazgeçmek değil.',
    ],
    ZodiacSign.aquarius: [
      'Farklı olmak için farklı olma.',
      'Bağımsızlık yalnızlık değil.',
      'Kalp de akıl kadar önemli.',
      'Herkes anlamak zorunda değil.',
      'Devrim önce kendinde.',
    ],
    ZodiacSign.pisces: [
      'Rüya güzel, gerçeklik de.',
      'Herkesin acısını taşımak zorunda değilsin.',
      'Sınırlar sevgisizlik değil.',
      'Kaçış değil, yüzleş.',
      'Hayal kurmak eylem değil.',
    ],
  };

  static const _defaultCosmicAdvice = [
    'Kendine nazik ol.',
    'Bugün sabır gerekiyor.',
    'Sezgilerine güven.',
  ];

  static final Map<ZodiacSign, List<SymbolicMessage>> _archetypes = {
    ZodiacSign.aries: [
      SymbolicMessage(
        type: 'Arketip',
        symbol: 'Savaşçı',
        title: 'İçindeki Savaşçı',
        meaning: 'Bugün savaşçı arketipi aktif. Ama gerçek savaşçı bilir: En büyük zafer kendini fethetmektir.',
        imageHint: 'aries_warrior',
      ),
      SymbolicMessage(
        type: 'Tarot',
        symbol: 'İmparator',
        title: 'IV - İmparator',
        meaning: 'Yapı, otorite ve kontrol. Bugün liderlik enerjin güçlü. Ama dikkat: Güç sorumluluk getirir.',
        imageHint: 'emperor',
      ),
    ],
    ZodiacSign.taurus: [
      SymbolicMessage(
        type: 'Arketip',
        symbol: 'Bahçıvan',
        title: 'Sabırlı Bahçıvan',
        meaning: 'Tohumlar zamanla meyve verir. Bugün sabırla ektiğin şeylerin yeşermesi teması güçlü.',
        imageHint: 'taurus_gardener',
      ),
      SymbolicMessage(
        type: 'Tarot',
        symbol: 'İmparatoriçe',
        title: 'III - İmparatoriçe',
        meaning: 'Bereket, duyusallık ve yaratıcılık. Hayatın güzelliklerini hissetme zamanı.',
        imageHint: 'empress',
      ),
    ],
    ZodiacSign.gemini: [
      SymbolicMessage(
        type: 'Arketip',
        symbol: 'Elçi',
        title: 'Tanrıların Elçisi',
        meaning: 'Hermes gibi sen de dünyalar arasında köprü kuruyorsun. Sözlerin bugün güç taşıyor.',
        imageHint: 'gemini_messenger',
      ),
      SymbolicMessage(
        type: 'Tarot',
        symbol: 'Aşıklar',
        title: 'VI - Aşıklar',
        meaning: 'Seçimler ve bağlantılar. İki yol arasında değil, ikisini birleştirme zamanı.',
        imageHint: 'lovers',
      ),
    ],
    ZodiacSign.cancer: [
      SymbolicMessage(
        type: 'Arketip',
        symbol: 'Anne',
        title: 'Büyük Anne',
        meaning: 'Besleyen, koruyan, sarmalayan. Bugün hem başkalarına hem kendine annelik et.',
        imageHint: 'cancer_mother',
      ),
      SymbolicMessage(
        type: 'Tarot',
        symbol: 'Ay',
        title: 'XVIII - Ay',
        meaning: 'Bilinçaltı, sezgiler ve gizli korkular. Karanlıkta da yol bulabilirsin.',
        imageHint: 'moon',
      ),
    ],
    ZodiacSign.leo: [
      SymbolicMessage(
        type: 'Arketip',
        symbol: 'Kral',
        title: 'Adil Kral',
        meaning: 'Gerçek kral tahtı değil, kalpleri yönetir. Bugün cömertliğinle hükmet.',
        imageHint: 'leo_king',
      ),
      SymbolicMessage(
        type: 'Tarot',
        symbol: 'Güç',
        title: 'VIII - Güç',
        meaning: 'İç aslanını evcilleştirme. Güç kontrolde değil, yumuşaklıkta.',
        imageHint: 'strength',
      ),
    ],
    ZodiacSign.virgo: [
      SymbolicMessage(
        type: 'Arketip',
        symbol: 'Şifacı',
        title: 'Kutsal Şifacı',
        meaning: 'Ellerin şifa taşıyor. Bugün dokunduğun her şeyi iyileştirme potansiyelin var.',
        imageHint: 'virgo_healer',
      ),
      SymbolicMessage(
        type: 'Tarot',
        symbol: 'Ermiş',
        title: 'IX - Ermiş',
        meaning: 'İç arayış ve bilgelik. Cevaplar dışarıda değil, derinlerde.',
        imageHint: 'hermit',
      ),
    ],
    ZodiacSign.libra: [
      SymbolicMessage(
        type: 'Arketip',
        symbol: 'Diplomat',
        title: 'Barış Elçisi',
        meaning: 'Köprüler kuran, yaralar saran. Bugün uyum teması öne çıkıyor.',
        imageHint: 'libra_diplomat',
      ),
      SymbolicMessage(
        type: 'Tarot',
        symbol: 'Adalet',
        title: 'XI - Adalet',
        meaning: 'Denge, doğruluk ve kararlar. Terazi dengede — şimdi seçim zamanı.',
        imageHint: 'justice',
      ),
    ],
    ZodiacSign.scorpio: [
      SymbolicMessage(
        type: 'Arketip',
        symbol: 'Simyacı',
        title: 'Karanlık Simyacı',
        meaning: 'Kurşunu altına çevirirsin. Acıyı bilgeliğe, kaybı kazanca dönüştürme gücün var.',
        imageHint: 'scorpio_alchemist',
      ),
      SymbolicMessage(
        type: 'Tarot',
        symbol: 'Ölüm',
        title: 'XIII - Ölüm',
        meaning: 'Dönüşüm ve yeniden doğuş. Bitişler, başlangıçların kapısıdır.',
        imageHint: 'death',
      ),
    ],
    ZodiacSign.sagittarius: [
      SymbolicMessage(
        type: 'Arketip',
        symbol: 'Kaşif',
        title: 'Ufuk Kaşifi',
        meaning: 'Bilinmeyen seni çağırıyor. Bugün sınırları aşma cesareti içinde.',
        imageHint: 'sagittarius_explorer',
      ),
      SymbolicMessage(
        type: 'Tarot',
        symbol: 'Ölçülülük',
        title: 'XIV - Ölçülülük',
        meaning: 'Denge ve sabır. Uçlar arasında orta yolu bul.',
        imageHint: 'temperance',
      ),
    ],
    ZodiacSign.capricorn: [
      SymbolicMessage(
        type: 'Arketip',
        symbol: 'Bilge',
        title: 'Dağın Bilgesi',
        meaning: 'Zirveye çıkan, geri dönüp yol gösterir. Deneyimin başkalarına ışık tutuyor.',
        imageHint: 'capricorn_sage',
      ),
      SymbolicMessage(
        type: 'Tarot',
        symbol: 'Şeytan',
        title: 'XV - Şeytan',
        meaning: 'Zincirler mi, seçimler mi? Bağlandığın şeyler seni tanımlıyor mu?',
        imageHint: 'devil',
      ),
    ],
    ZodiacSign.aquarius: [
      SymbolicMessage(
        type: 'Arketip',
        symbol: 'Devrimci',
        title: 'Vizyoner Devrimci',
        meaning: 'Geleceği bugünden görürsün. Fikirlerin zamanının ötesinde.',
        imageHint: 'aquarius_revolutionary',
      ),
      SymbolicMessage(
        type: 'Tarot',
        symbol: 'Yıldız',
        title: 'XVII - Yıldız',
        meaning: 'Umut, ilham ve rehberlik. En karanlık gecede bile yıldızlar parlar.',
        imageHint: 'star',
      ),
    ],
    ZodiacSign.pisces: [
      SymbolicMessage(
        type: 'Arketip',
        symbol: 'Rüyacı',
        title: 'Mistik Rüyacı',
        meaning: 'Dünyalar arasında yüzersin. Rüyaların mesaj taşıyor, dinle.',
        imageHint: 'pisces_dreamer',
      ),
      SymbolicMessage(
        type: 'Tarot',
        symbol: 'Ay',
        title: 'XVIII - Ay',
        meaning: 'Sezgi, illüzyon ve bilinçaltı. Görünenin arkasına bak.',
        imageHint: 'moon',
      ),
    ],
  };

  static const _defaultArchetypes = [
    SymbolicMessage(
      type: 'Arketip',
      symbol: 'Yolcu',
      title: 'Kozmik Yolcu',
      meaning: 'Yolculuk devam ediyor. Her adım bir keşif.',
      imageHint: 'traveler',
    ),
  ];
}

// Data models
class CosmicShareContent {
  final HeroBlock heroBlock;
  final PersonalCosmicMessage personalMessage;
  final CosmicEnergyMeter energyMeter;
  final PlanetaryInfluence planetaryInfluence;
  final ShadowLightDuality shadowLight;
  final List<String> cosmicAdvice;
  final SymbolicMessage symbolicMessage;
  final String viralHook;
  final String sharePrompt;
  final CollectiveMoment collectiveMoment;
  final SoftPremiumCuriosity premiumCuriosity;
  final List<String> microMessages;
  // NEW: Master level additions
  final DreamInsight dreamInsight;
  final NumerologyInsight numerologyInsight;
  final TantraWisdom tantraWisdom;
  final ChakraSnapshot chakraSnapshot;
  final CosmicTimingHint timingHint;

  const CosmicShareContent({
    required this.heroBlock,
    required this.personalMessage,
    required this.energyMeter,
    required this.planetaryInfluence,
    required this.shadowLight,
    required this.cosmicAdvice,
    required this.symbolicMessage,
    required this.viralHook,
    required this.sharePrompt,
    required this.collectiveMoment,
    required this.premiumCuriosity,
    required this.microMessages,
    required this.dreamInsight,
    required this.numerologyInsight,
    required this.tantraWisdom,
    required this.chakraSnapshot,
    required this.timingHint,
  });
}

class HeroBlock {
  final String signTitle;
  final String signSymbol;
  final String cosmicHeadline;
  final String dateFormatted;
  final String moonPhaseText;
  final String moonPhaseEmoji;

  const HeroBlock({
    required this.signTitle,
    required this.signSymbol,
    required this.cosmicHeadline,
    required this.dateFormatted,
    required this.moonPhaseText,
    required this.moonPhaseEmoji,
  });
}

class PersonalCosmicMessage {
  final String message;
  final String emotionalCore;

  const PersonalCosmicMessage({
    required this.message,
    required this.emotionalCore,
  });
}

class CosmicEnergyMeter {
  final int energyLevel;
  final String energyDescription;
  final String emotionalIntensity;
  final String intensityDescription;
  final int intuitionStrength;
  final String intuitionDescription;
  final double actionReflectionBalance;
  final String balanceDescription;

  const CosmicEnergyMeter({
    required this.energyLevel,
    required this.energyDescription,
    required this.emotionalIntensity,
    required this.intensityDescription,
    required this.intuitionStrength,
    required this.intuitionDescription,
    required this.actionReflectionBalance,
    required this.balanceDescription,
  });
}

class PlanetaryInfluence {
  final Planet dominantPlanet;
  final String planetSymbol;
  final String activates;
  final String blocks;
  final String oneAction;
  final String exclusivityText;

  const PlanetaryInfluence({
    required this.dominantPlanet,
    required this.planetSymbol,
    required this.activates,
    required this.blocks,
    required this.oneAction,
    required this.exclusivityText,
  });
}

class ShadowLightDuality {
  final String shadowChallenge;
  final String shadowFear;
  final String shadowPattern;
  final String lightStrength;
  final String lightOpportunity;
  final String lightMagnetic;

  const ShadowLightDuality({
    required this.shadowChallenge,
    required this.shadowFear,
    required this.shadowPattern,
    required this.lightStrength,
    required this.lightOpportunity,
    required this.lightMagnetic,
  });
}

class SymbolicMessage {
  final String type;
  final String symbol;
  final String title;
  final String meaning;
  final String imageHint;

  const SymbolicMessage({
    required this.type,
    required this.symbol,
    required this.title,
    required this.meaning,
    required this.imageHint,
  });
}

class PlanetInfluenceData {
  final String activates;
  final String blocks;
  final String action;

  const PlanetInfluenceData({
    required this.activates,
    required this.blocks,
    required this.action,
  });
}

class ShadowData {
  final String challenge;
  final String fear;
  final String pattern;

  const ShadowData({
    required this.challenge,
    required this.fear,
    required this.pattern,
  });
}

class LightData {
  final String strength;
  final String opportunity;
  final String magnetic;

  const LightData({
    required this.strength,
    required this.opportunity,
    required this.magnetic,
  });
}

class CollectiveMoment {
  final String mainText;
  final String subText;

  const CollectiveMoment({
    required this.mainText,
    required this.subText,
  });
}

class SoftPremiumCuriosity {
  final String curiosityText;
  final String invitationText;

  const SoftPremiumCuriosity({
    required this.curiosityText,
    required this.invitationText,
  });
}

// ═══════════════════════════════════════════════════════════════
// MASTER LEVEL: NEW DATA MODELS
// ═══════════════════════════════════════════════════════════════

/// Rüya İzi - Dream insight for the day
class DreamInsight {
  final String symbol;
  final String symbolMeaning;
  final String dreamPrompt;
  final String nightMessage;

  const DreamInsight({
    required this.symbol,
    required this.symbolMeaning,
    required this.dreamPrompt,
    required this.nightMessage,
  });
}

/// Numerology insight based on today's date
class NumerologyInsight {
  final int dayNumber;
  final String numberMeaning;
  final String vibration;
  final String luckyHour;

  const NumerologyInsight({
    required this.dayNumber,
    required this.numberMeaning,
    required this.vibration,
    required this.luckyHour,
  });
}

/// Tantra wisdom - non-physical spiritual micro-ritual
class TantraWisdom {
  final String breathFocus;
  final String awarenessPoint;
  final String innerConnection;

  const TantraWisdom({
    required this.breathFocus,
    required this.awarenessPoint,
    required this.innerConnection,
  });
}

/// Chakra energy snapshot
class ChakraSnapshot {
  final String activeChakra;
  final String chakraSymbol;
  final String chakraMessage;
  final double balanceLevel;

  const ChakraSnapshot({
    required this.activeChakra,
    required this.chakraSymbol,
    required this.chakraMessage,
    required this.balanceLevel,
  });
}

/// Cosmic timing hint
class CosmicTimingHint {
  final String goldenHour;
  final String avoidHour;
  final String ritualSuggestion;

  const CosmicTimingHint({
    required this.goldenHour,
    required this.avoidHour,
    required this.ritualSuggestion,
  });
}
