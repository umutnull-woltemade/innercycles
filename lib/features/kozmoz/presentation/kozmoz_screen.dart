import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart' as zodiac;
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/entertainment_disclaimer.dart';

/// Kozmoz - AI Astroloji Asistanı
/// Kullanıcının astroloji, burç, transit, numeroloji sorularını yanıtlar
class KozmozScreen extends ConsumerStatefulWidget {
  const KozmozScreen({super.key});

  @override
  ConsumerState<KozmozScreen> createState() => _KozmozScreenState();
}

class _KozmozScreenState extends ConsumerState<KozmozScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isTyping = false;
  late AnimationController _pulseController;

  // Question keys with emoji and category for localization
  static const List<Map<String, String>> _questionKeys = [
    // Daily
    {'emoji': '🌅', 'key': 'kozmoz.questions.daily_lucky_hours', 'category': 'gunluk'},
    {'emoji': '⚡', 'key': 'kozmoz.questions.daily_danger_hours', 'category': 'gunluk'},
    {'emoji': '🎯', 'key': 'kozmoz.questions.weekly_advice', 'category': 'gunluk'},
    {'emoji': '✨', 'key': 'kozmoz.questions.cosmic_weather', 'category': 'gunluk'},
    // Love
    {'emoji': '💘', 'key': 'kozmoz.questions.venus_mars_love', 'category': 'ask'},
    {'emoji': '🔥', 'key': 'kozmoz.questions.ideal_partner', 'category': 'ask'},
    {'emoji': '💔', 'key': 'kozmoz.questions.relationship_challenges', 'category': 'ask'},
    {'emoji': '👫', 'key': 'kozmoz.questions.synastry_analysis', 'category': 'ask'},
    {'emoji': '💍', 'key': 'kozmoz.questions.marriage_timing', 'category': 'ask'},
    // Career
    {'emoji': '📈', 'key': 'kozmoz.questions.career_paths', 'category': 'kariyer'},
    {'emoji': '💰', 'key': 'kozmoz.questions.financial_success', 'category': 'kariyer'},
    {'emoji': '🚀', 'key': 'kozmoz.questions.business_timing', 'category': 'kariyer'},
    {'emoji': '🤝', 'key': 'kozmoz.questions.business_partners', 'category': 'kariyer'},
    // Transit
    {'emoji': '♄', 'key': 'kozmoz.questions.saturn_return', 'category': 'transit'},
    {'emoji': '🌑', 'key': 'kozmoz.questions.mercury_retrograde', 'category': 'transit'},
    {'emoji': '🌕', 'key': 'kozmoz.questions.full_moon', 'category': 'transit'},
    {'emoji': '♃', 'key': 'kozmoz.questions.jupiter_transit', 'category': 'transit'},
    {'emoji': '⏳', 'key': 'kozmoz.questions.critical_dates', 'category': 'transit'},
    // Chart
    {'emoji': '☀️', 'key': 'kozmoz.questions.big_three', 'category': 'harita'},
    {'emoji': '🌙', 'key': 'kozmoz.questions.lunar_nodes', 'category': 'harita'},
    {'emoji': '🏠', 'key': 'kozmoz.questions.houses', 'category': 'harita'},
    {'emoji': '⚔️', 'key': 'kozmoz.questions.difficult_aspects', 'category': 'harita'},
    {'emoji': '🎁', 'key': 'kozmoz.questions.mc_ic_axis', 'category': 'harita'},
    // Numerology
    {'emoji': '1️⃣', 'key': 'kozmoz.questions.life_path', 'category': 'numeroloji'},
    {'emoji': '🔮', 'key': 'kozmoz.questions.name_numerology', 'category': 'numeroloji'},
    {'emoji': '📅', 'key': 'kozmoz.questions.personal_year', 'category': 'numeroloji'},
    {'emoji': '🎂', 'key': 'kozmoz.questions.birthday_number', 'category': 'numeroloji'},
    // Tarot
    {'emoji': '🃏', 'key': 'kozmoz.questions.daily_tarot', 'category': 'tarot'},
    {'emoji': '🌟', 'key': 'kozmoz.questions.three_card_spread', 'category': 'tarot'},
    {'emoji': '❓', 'key': 'kozmoz.questions.yes_no_tarot', 'category': 'tarot'},
    // Spiritual
    {'emoji': '🦋', 'key': 'kozmoz.questions.spiritual_awakening', 'category': 'spiritüel'},
    {'emoji': '🧬', 'key': 'kozmoz.questions.karmic_debts', 'category': 'spiritüel'},
    {'emoji': '🌈', 'key': 'kozmoz.questions.chakra_status', 'category': 'spiritüel'},
    {'emoji': '💎', 'key': 'kozmoz.questions.healing_crystals', 'category': 'spiritüel'},
    {'emoji': '🕯️', 'key': 'kozmoz.questions.moon_rituals', 'category': 'spiritüel'},
    // Deep
    {'emoji': '🎯', 'key': 'kozmoz.questions.life_purpose', 'category': 'derin'},
    {'emoji': '⚡', 'key': 'kozmoz.questions.hidden_talents', 'category': 'derin'},
    {'emoji': '🌪️', 'key': 'kozmoz.questions.repeating_patterns', 'category': 'derin'},
    {'emoji': '🔓', 'key': 'kozmoz.questions.blockages', 'category': 'derin'},
    // Dreams
    {'emoji': '💭', 'key': 'kozmoz.questions.dream_meaning', 'category': 'ruya'},
    {'emoji': '🌌', 'key': 'kozmoz.questions.subconscious_messages', 'category': 'ruya'},
    {'emoji': '🛏️', 'key': 'kozmoz.questions.sleep_cycles', 'category': 'ruya'},
    {'emoji': '👁️‍🗨️', 'key': 'kozmoz.questions.lucid_dreaming', 'category': 'ruya'},
    // Tantra
    {'emoji': '🔥', 'key': 'kozmoz.questions.kundalini', 'category': 'tantra'},
    {'emoji': '💫', 'key': 'kozmoz.questions.sexual_energy', 'category': 'tantra'},
    {'emoji': '🧘', 'key': 'kozmoz.questions.breathing_techniques', 'category': 'tantra'},
    {'emoji': '⚡', 'key': 'kozmoz.questions.energy_blockages', 'category': 'tantra'},
    // Health
    {'emoji': '🩺', 'key': 'kozmoz.questions.weak_organs', 'category': 'saglik'},
    {'emoji': '🍃', 'key': 'kozmoz.questions.herbal_healing', 'category': 'saglik'},
    {'emoji': '🥗', 'key': 'kozmoz.questions.astro_nutrition', 'category': 'saglik'},
    {'emoji': '🧪', 'key': 'kozmoz.questions.detox_timing', 'category': 'saglik'},
    // Home
    {'emoji': '🏡', 'key': 'kozmoz.questions.home_buying', 'category': 'ev'},
    {'emoji': '👨‍👩‍👧‍👦', 'key': 'kozmoz.questions.family_dynamics', 'category': 'ev'},
    {'emoji': '👶', 'key': 'kozmoz.questions.having_children', 'category': 'ev'},
    {'emoji': '🐕', 'key': 'kozmoz.questions.pets', 'category': 'ev'},
    // Travel
    {'emoji': '🗺️', 'key': 'kozmoz.questions.lucky_places', 'category': 'seyahat'},
    {'emoji': '✈️', 'key': 'kozmoz.questions.travel_timing', 'category': 'seyahat'},
    {'emoji': '🏖️', 'key': 'kozmoz.questions.vacation_destinations', 'category': 'seyahat'},
    // Education
    {'emoji': '📖', 'key': 'kozmoz.questions.learning_talents', 'category': 'egitim'},
    {'emoji': '🎓', 'key': 'kozmoz.questions.exam_dates', 'category': 'egitim'},
    {'emoji': '✍️', 'key': 'kozmoz.questions.creative_periods', 'category': 'egitim'},
    // Shadow
    {'emoji': '🖤', 'key': 'kozmoz.questions.shadow_self', 'category': 'golge'},
    {'emoji': '😈', 'key': 'kozmoz.questions.fears_origins', 'category': 'golge'},
    {'emoji': '🌑', 'key': 'kozmoz.questions.dark_moon_work', 'category': 'golge'},
    {'emoji': '🪞', 'key': 'kozmoz.questions.projection_patterns', 'category': 'golge'},
    // Manifestation
    {'emoji': '✨', 'key': 'kozmoz.questions.manifestation_timing', 'category': 'manifestasyon'},
    {'emoji': '🎯', 'key': 'kozmoz.questions.intention_moon', 'category': 'manifestasyon'},
    {'emoji': '📝', 'key': 'kozmoz.questions.abundance_rituals', 'category': 'manifestasyon'},
    {'emoji': '🌈', 'key': 'kozmoz.questions.vision_board', 'category': 'manifestasyon'},
    // Mystic
    {'emoji': '🌀', 'key': 'kozmoz.questions.past_lives', 'category': 'mistik'},
    {'emoji': '👼', 'key': 'kozmoz.questions.guardian_angels', 'category': 'mistik'},
    {'emoji': '🌠', 'key': 'kozmoz.questions.star_seeds', 'category': 'mistik'},
    {'emoji': '🕸️', 'key': 'kozmoz.questions.akashic_records', 'category': 'mistik'},
    // Crystal
    {'emoji': '💎', 'key': 'kozmoz.questions.power_stones', 'category': 'kristal'},
    {'emoji': '🔮', 'key': 'kozmoz.questions.current_crystals', 'category': 'kristal'},
    {'emoji': '💍', 'key': 'kozmoz.questions.stones_to_avoid', 'category': 'kristal'},
    // Ritual
    {'emoji': '🕯️', 'key': 'kozmoz.questions.full_moon_ritual', 'category': 'ritual'},
    {'emoji': '🌑', 'key': 'kozmoz.questions.new_moon_intention', 'category': 'ritual'},
    {'emoji': '🌸', 'key': 'kozmoz.questions.seasonal_rituals', 'category': 'ritual'},
    {'emoji': '🔥', 'key': 'kozmoz.questions.energy_cleansing', 'category': 'ritual'},
  ];

  /// Returns localized questions based on current language
  List<Map<String, dynamic>> _getLocalizedQuestions(AppLanguage language) {
    return _questionKeys.map((q) => {
      'emoji': q['emoji']!,
      'text': L10nService.get(q['key']!, language),
      'category': q['category']!,
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    final userProfile = ref.read(userProfileProvider);
    final sign = userProfile?.sunSign ?? zodiac.ZodiacSign.aries;
    final language = ref.read(languageProvider);
    final userName = userProfile?.name ?? L10nService.get('kozmoz.traveler', language);

    final hello = L10nService.get('kozmoz.greeting_hello', language);
    final introMessage = L10nService.get('kozmoz.intro_message', language)
        .replaceAll('{sign}', sign.localizedName(language));

    setState(() {
      _messages.add(_ChatMessage(
        text: '$hello $userName! 🌟\n\n'
            '$introMessage\n\n'
            '⚠️ ${DisclaimerTexts.astrology(language)}',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _sendMessage([String? quickMessage]) async {
    final text = quickMessage ?? _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // AI yanıtı oluştur
    await Future.delayed(const Duration(milliseconds: 800 + 400)); // Simüle typing
    _generateResponse(text);
  }

  void _generateResponse(String userMessage) {
    final userProfile = ref.read(userProfileProvider);
    final sign = userProfile?.sunSign ?? zodiac.ZodiacSign.aries;
    final language = ref.read(languageProvider);
    final lowerMessage = userMessage.toLowerCase();

    String response;

    // Multi-language keyword matching
    if (_matchesDailyKeywords(lowerMessage, language)) {
      response = _getDailyResponse(sign, language);
    } else if (_matchesLoveKeywords(lowerMessage, language)) {
      response = _getLoveResponse(sign, language);
    } else if (_matchesCareerKeywords(lowerMessage, language)) {
      response = _getCareerResponse(sign, language);
    } else if (_matchesMoonKeywords(lowerMessage, language)) {
      response = _getMoonResponse(sign, language);
    } else if (_matchesTransitKeywords(lowerMessage, language)) {
      response = _getTransitResponse(sign, language);
    } else if (_matchesRisingKeywords(lowerMessage, language)) {
      response = _getRisingResponse(sign, language);
    } else if (_matchesCompatibilityKeywords(lowerMessage, language)) {
      response = _getCompatibilityResponse(sign, language);
    } else if (_matchesNumerologyKeywords(lowerMessage, language)) {
      response = _getNumerologyResponse(sign, language);
    } else if (_matchesTarotKeywords(lowerMessage, language)) {
      response = _getTarotResponse(sign, language);
    } else if (_matchesAuraKeywords(lowerMessage, language)) {
      response = _getAuraResponse(sign, language);
    } else if (_matchesSpiritualKeywords(lowerMessage, language)) {
      response = _getSpiritualResponse(sign, language);
    } else if (_matchesLifePurposeKeywords(lowerMessage, language)) {
      response = _getLifePurposeResponse(sign, language);
    } else if (_matchesTalentKeywords(lowerMessage, language)) {
      response = _getTalentResponse(sign, language);
    } else if (_matchesDreamKeywords(lowerMessage, language)) {
      response = _getDreamResponse(sign, language);
    } else if (_matchesTantraKeywords(lowerMessage, language)) {
      response = _getTantraResponse(sign, language);
    } else if (_matchesHealthKeywords(lowerMessage, language)) {
      response = _getHealthResponse(sign, language);
    } else if (_matchesHomeKeywords(lowerMessage, language)) {
      response = _getHomeResponse(sign, language);
    } else if (_matchesTravelKeywords(lowerMessage, language)) {
      response = _getTravelResponse(sign, language);
    } else if (_matchesEducationKeywords(lowerMessage, language)) {
      response = _getEducationResponse(sign, language);
    } else if (_matchesShadowKeywords(lowerMessage, language)) {
      response = _getShadowResponse(sign, language);
    } else if (_matchesManifestationKeywords(lowerMessage, language)) {
      response = _getManifestationResponse(sign, language);
    } else if (_matchesMysticKeywords(lowerMessage, language)) {
      response = _getMysticResponse(sign, language);
    } else if (_matchesCrystalKeywords(lowerMessage, language)) {
      response = _getCrystalResponse(sign, language);
    } else if (_matchesRitualKeywords(lowerMessage, language)) {
      response = _getRitualResponse(sign, language);
    } else if (_matchesChakraKeywords(lowerMessage, language)) {
      response = _getChakraResponse(sign, language);
    } else if (_matchesGreetingKeywords(lowerMessage, language)) {
      response = _getGreetingResponse(sign, language);
    } else {
      response = _getGeneralResponse(sign, userMessage, language);
    }

    setState(() {
      _isTyping = false;
      _messages.add(_ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });

    _scrollToBottom();
  }

  bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }

  // ═══════════════════════════════════════════════════════════════
  // MULTI-LANGUAGE KEYWORD MATCHERS
  // ═══════════════════════════════════════════════════════════════

  bool _matchesDailyKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['bugün', 'günlük', 'gün nasıl', 'bu gün'],
      AppLanguage.en: ['today', 'daily', 'how is my day', 'this day'],
      AppLanguage.de: ['heute', 'täglich', 'wie ist mein tag', 'dieser tag'],
      AppLanguage.fr: ['aujourd\'hui', 'quotidien', 'comment est ma journée', 'ce jour'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesLoveKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['aşk', 'sevgili', 'ilişki', 'partner', 'evlilik', 'flört'],
      AppLanguage.en: ['love', 'relationship', 'partner', 'marriage', 'dating', 'romance'],
      AppLanguage.de: ['liebe', 'beziehung', 'partner', 'ehe', 'dating', 'romantik'],
      AppLanguage.fr: ['amour', 'relation', 'partenaire', 'mariage', 'romance', 'flirt'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesCareerKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['kariyer', 'iş', 'para', 'maddi', 'finans', 'terfi'],
      AppLanguage.en: ['career', 'job', 'money', 'financial', 'finance', 'promotion', 'work'],
      AppLanguage.de: ['karriere', 'arbeit', 'geld', 'finanziell', 'finanzen', 'beförderung'],
      AppLanguage.fr: ['carrière', 'travail', 'argent', 'financier', 'finances', 'promotion'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesMoonKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['ay', 'ay fazı', 'dolunay', 'yeniay', 'lunar'],
      AppLanguage.en: ['moon', 'moon phase', 'full moon', 'new moon', 'lunar'],
      AppLanguage.de: ['mond', 'mondphase', 'vollmond', 'neumond', 'lunar'],
      AppLanguage.fr: ['lune', 'phase lunaire', 'pleine lune', 'nouvelle lune', 'lunaire'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesTransitKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['saturn', 'transit', 'gezegen', 'retro', 'merkür'],
      AppLanguage.en: ['saturn', 'transit', 'planet', 'retrograde', 'mercury'],
      AppLanguage.de: ['saturn', 'transit', 'planet', 'rückläufig', 'merkur'],
      AppLanguage.fr: ['saturne', 'transit', 'planète', 'rétrograde', 'mercure'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesRisingKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['yükselen', 'ascendant', 'rising'],
      AppLanguage.en: ['rising', 'ascendant', 'rising sign'],
      AppLanguage.de: ['aszendent', 'aufsteigend', 'rising'],
      AppLanguage.fr: ['ascendant', 'montant', 'rising'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesCompatibilityKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['uyum', 'uyumlu', 'hangi burç'],
      AppLanguage.en: ['compatibility', 'compatible', 'which sign', 'match'],
      AppLanguage.de: ['kompatibilität', 'kompatibel', 'welches zeichen', 'passt'],
      AppLanguage.fr: ['compatibilité', 'compatible', 'quel signe', 'correspondance'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesNumerologyKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['numeroloji', 'sayı', 'yaşam yolu'],
      AppLanguage.en: ['numerology', 'number', 'life path'],
      AppLanguage.de: ['numerologie', 'zahl', 'lebenspfad'],
      AppLanguage.fr: ['numérologie', 'nombre', 'chemin de vie'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesTarotKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['tarot', 'kart', 'fal'],
      AppLanguage.en: ['tarot', 'card', 'fortune', 'reading'],
      AppLanguage.de: ['tarot', 'karte', 'wahrsagen', 'lesen'],
      AppLanguage.fr: ['tarot', 'carte', 'divination', 'lecture'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesAuraKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['aura', 'enerji beden'],
      AppLanguage.en: ['aura', 'energy body', 'energy field'],
      AppLanguage.de: ['aura', 'energiekörper', 'energiefeld'],
      AppLanguage.fr: ['aura', 'corps énergétique', 'champ énergétique'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesSpiritualKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['ruhsal', 'dönüşüm', 'spiritüel', 'uyanış'],
      AppLanguage.en: ['spiritual', 'transformation', 'awakening', 'soul'],
      AppLanguage.de: ['spirituell', 'transformation', 'erwachen', 'seele'],
      AppLanguage.fr: ['spirituel', 'transformation', 'éveil', 'âme'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesLifePurposeKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['hayat amacı', 'amaç', 'misyon'],
      AppLanguage.en: ['life purpose', 'purpose', 'mission', 'destiny'],
      AppLanguage.de: ['lebenszweck', 'zweck', 'mission', 'bestimmung'],
      AppLanguage.fr: ['but de vie', 'but', 'mission', 'destinée'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesTalentKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['yetenek', 'potansiyel', 'güçlü'],
      AppLanguage.en: ['talent', 'potential', 'strength', 'gift', 'ability'],
      AppLanguage.de: ['talent', 'potenzial', 'stärke', 'gabe', 'fähigkeit'],
      AppLanguage.fr: ['talent', 'potentiel', 'force', 'don', 'capacité'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesDreamKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['rüya', 'bilinçaltı', 'uyku', 'lüsid'],
      AppLanguage.en: ['dream', 'subconscious', 'sleep', 'lucid'],
      AppLanguage.de: ['traum', 'unterbewusstsein', 'schlaf', 'luzid'],
      AppLanguage.fr: ['rêve', 'subconscient', 'sommeil', 'lucide'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesTantraKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['tantra', 'kundalini', 'cinsel enerji', 'nefes'],
      AppLanguage.en: ['tantra', 'kundalini', 'sexual energy', 'breath', 'breathing'],
      AppLanguage.de: ['tantra', 'kundalini', 'sexuelle energie', 'atem', 'atmung'],
      AppLanguage.fr: ['tantra', 'kundalini', 'énergie sexuelle', 'souffle', 'respiration'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesHealthKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['sağlık', 'hastalık', 'organ', 'beslenme', 'detoks'],
      AppLanguage.en: ['health', 'illness', 'organ', 'nutrition', 'detox', 'wellness'],
      AppLanguage.de: ['gesundheit', 'krankheit', 'organ', 'ernährung', 'entgiftung'],
      AppLanguage.fr: ['santé', 'maladie', 'organe', 'nutrition', 'détox', 'bien-être'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesHomeKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['ev', 'taşınma', 'aile', 'çocuk', 'evcil'],
      AppLanguage.en: ['home', 'moving', 'family', 'child', 'pet', 'house'],
      AppLanguage.de: ['haus', 'umzug', 'familie', 'kind', 'haustier', 'zuhause'],
      AppLanguage.fr: ['maison', 'déménagement', 'famille', 'enfant', 'animal', 'foyer'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesTravelKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['seyahat', 'şehir', 'ülke', 'tatil', 'destinasyon'],
      AppLanguage.en: ['travel', 'city', 'country', 'vacation', 'destination', 'trip'],
      AppLanguage.de: ['reise', 'stadt', 'land', 'urlaub', 'reiseziel'],
      AppLanguage.fr: ['voyage', 'ville', 'pays', 'vacances', 'destination'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesEducationKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['eğitim', 'öğrenme', 'sınav', 'mülakat', 'yazarlık'],
      AppLanguage.en: ['education', 'learning', 'exam', 'interview', 'writing', 'study'],
      AppLanguage.de: ['bildung', 'lernen', 'prüfung', 'vorstellungsgespräch', 'schreiben'],
      AppLanguage.fr: ['éducation', 'apprentissage', 'examen', 'entretien', 'écriture'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesShadowKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['gölge', 'korku', 'karanlık', 'projeksiyon', 'bastır'],
      AppLanguage.en: ['shadow', 'fear', 'dark', 'projection', 'suppress', 'shadow work'],
      AppLanguage.de: ['schatten', 'angst', 'dunkel', 'projektion', 'unterdrücken'],
      AppLanguage.fr: ['ombre', 'peur', 'sombre', 'projection', 'réprimer'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesManifestationKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['manifestasyon', 'niyet', 'bolluk', 'çekim', 'vizyon'],
      AppLanguage.en: ['manifestation', 'intention', 'abundance', 'attraction', 'vision'],
      AppLanguage.de: ['manifestation', 'absicht', 'fülle', 'anziehung', 'vision'],
      AppLanguage.fr: ['manifestation', 'intention', 'abondance', 'attraction', 'vision'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesMysticKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['geçmiş yaşam', 'melek', 'rehber', 'akashik', 'yıldız tohum'],
      AppLanguage.en: ['past life', 'angel', 'guide', 'akashic', 'starseed', 'past lives'],
      AppLanguage.de: ['vergangenes leben', 'engel', 'führer', 'akashisch', 'sternensaat'],
      AppLanguage.fr: ['vie passée', 'ange', 'guide', 'akashique', 'graine d\'étoile'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesCrystalKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['kristal', 'taş', 'mücevher', 'ametist', 'kuvars'],
      AppLanguage.en: ['crystal', 'stone', 'gem', 'amethyst', 'quartz'],
      AppLanguage.de: ['kristall', 'stein', 'edelstein', 'amethyst', 'quarz'],
      AppLanguage.fr: ['cristal', 'pierre', 'gemme', 'améthyste', 'quartz'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesRitualKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['ritüel', 'tören', 'mevsim', 'temizlik', 'arın'],
      AppLanguage.en: ['ritual', 'ceremony', 'season', 'cleansing', 'purify'],
      AppLanguage.de: ['ritual', 'zeremonie', 'jahreszeit', 'reinigung', 'reinigen'],
      AppLanguage.fr: ['rituel', 'cérémonie', 'saison', 'nettoyage', 'purifier'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesChakraKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['çakra', 'bloke', 'enerji merkezi'],
      AppLanguage.en: ['chakra', 'blocked', 'energy center', 'chakras'],
      AppLanguage.de: ['chakra', 'blockiert', 'energiezentrum', 'chakren'],
      AppLanguage.fr: ['chakra', 'bloqué', 'centre d\'énergie', 'chakras'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  bool _matchesGreetingKeywords(String text, AppLanguage language) {
    const keywords = {
      AppLanguage.tr: ['merhaba', 'selam', 'hey', 'nasılsın'],
      AppLanguage.en: ['hello', 'hi', 'hey', 'how are you', 'greetings'],
      AppLanguage.de: ['hallo', 'hi', 'hey', 'wie geht es dir', 'grüß'],
      AppLanguage.fr: ['bonjour', 'salut', 'hey', 'comment allez-vous', 'coucou'],
    };
    return _containsAny(text, keywords[language] ?? keywords[AppLanguage.en]!);
  }

  // ═══════════════════════════════════════════════════════════════
  // MEGA GELİŞTİRİLMİŞ YANIT GENERATÖRLERİ - 5000x DETAYLI
  // ═══════════════════════════════════════════════════════════════

  String _getDailyResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    final now = DateTime.now();
    final moonSign = _getLocalizedMoonSign(language);
    final luckyHours = _getLuckyHours(sign);
    final dangerHours = _getDangerHours(sign);
    final element = sign.element;

    final header = L10nService.getWithParams('kozmoz.responses.daily_report_header', language, params: {
      'sign': sign.localizedName(language).toUpperCase(),
    });
    final moonInSign = L10nService.getWithParams('kozmoz.responses.moon_in_sign', language, params: {
      'sign': moonSign,
    });
    final morningEnergy = L10nService.get('kozmoz.responses.morning_energy', language);
    final noonEnergy = L10nService.get('kozmoz.responses.noon_energy', language);
    final eveningEnergy = L10nService.get('kozmoz.responses.evening_energy', language);
    final luckyHoursLabel = L10nService.get('kozmoz.responses.lucky_hours', language);
    final luckyHoursNote = L10nService.get('kozmoz.responses.lucky_hours_note', language);
    final carefulHours = L10nService.get('kozmoz.responses.careful_hours', language);
    final carefulHoursNote = L10nService.get('kozmoz.responses.careful_hours_note', language);
    final goldenAdvice = L10nService.get('kozmoz.responses.golden_advice', language);
    final dailyAffirmationLabel = L10nService.get('kozmoz.responses.daily_affirmation', language);
    final cosmicNote = L10nService.get('kozmoz.responses.cosmic_note', language);
    final cosmicNoteText = L10nService.getWithParams('kozmoz.responses.cosmic_note_text', language, params: {
      'element': element.localizedName(language),
      'element_note': _getElementDailyNote(element, language),
    });
    final remember = L10nService.get('kozmoz.responses.remember', language);

    return '''${sign.symbol} $header
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📅 ${now.day}.${now.month}.${now.year} | $moonInSign

🌅 $morningEnergy
${_getMorningEnergy(sign, language)}

☀️ $noonEnergy
${_getAfternoonEnergy(sign, language)}

🌙 $eveningEnergy
${_getEveningEnergy(sign, language)}

⭐ $luckyHoursLabel
$luckyHours
$luckyHoursNote

⚠️ $carefulHours
$dangerHours
$carefulHoursNote

🎯 $goldenAdvice
${_getDailyAdvice(sign, language)}

💫 $dailyAffirmationLabel
"${_getDailyAffirmation(sign, language)}"

🔮 $cosmicNote
$cosmicNoteText

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✨ $remember''';
  }

  String _getLoveResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    final venusSign = _getLocalizedMoonSign(language);
    final marsSign = _getLocalizedMoonSign(language);

    final header = L10nService.getWithParams('kozmoz.responses.love_analysis_header', language, params: {
      'sign': sign.localizedName(language).toUpperCase(),
    });
    final venusPos = L10nService.getWithParams('kozmoz.responses.venus_position', language, params: {
      'venus_sign': venusSign,
    });
    final marsPos = L10nService.getWithParams('kozmoz.responses.mars_position', language, params: {
      'mars_sign': marsSign,
    });
    final loveEnergy = L10nService.get('kozmoz.responses.love_energy', language);
    final loveLanguage = L10nService.get('kozmoz.responses.love_language', language);
    final idealPartner = L10nService.get('kozmoz.responses.ideal_partner', language);
    final bestMatches = L10nService.get('kozmoz.responses.best_matches', language);
    final perfectMatch = L10nService.get('kozmoz.responses.perfect_match', language);
    final goodMatch = L10nService.get('kozmoz.responses.good_match', language);
    final relationshipWarnings = L10nService.get('kozmoz.responses.relationship_warnings', language);
    final lovePeriod = L10nService.get('kozmoz.responses.love_period', language);
    final loveRitual = L10nService.get('kozmoz.responses.love_ritual', language);
    final cosmicLoveAdvice = L10nService.get('kozmoz.responses.cosmic_love_advice', language);
    final loveReminder = L10nService.get('kozmoz.responses.love_reminder', language);

    return '''${sign.symbol} $header
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💕 $venusPos
♂️ $marsPos

❤️ $loveEnergy
${_getDetailedLoveEnergy(sign, language)}

🔥 $loveLanguage
${_getLoveLanguage(sign, language)}

💘 $idealPartner
${_getIdealPartner(sign, language)}

👫 $bestMatches
━━━━━━━━━━━━━━━━━━━━
🟢 $perfectMatch
${_getPerfectMatches(sign, language)}

🟡 $goodMatch
${_getGoodMatches(sign, language)}

💔 $relationshipWarnings
${_getRelationshipWarnings(sign, language)}

🌹 $lovePeriod
${_getCurrentLovePeriod(sign, language)}

✨ $loveRitual
${_getLoveRitual(sign, language)}

🔮 $cosmicLoveAdvice
${_getLoveAdvice(sign, language)}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💝 $loveReminder''';
  }

  String _getCareerResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    final header = L10nService.getWithParams('kozmoz.responses.career_analysis_header', language, params: {
      'sign': sign.localizedName(language).toUpperCase(),
    });
    final naturalTalents = L10nService.get('kozmoz.responses.natural_talents', language);
    final careerPaths = L10nService.get('kozmoz.responses.career_paths', language);
    final industryRec = L10nService.get('kozmoz.responses.industry_recommendations', language);
    final financialTend = L10nService.get('kozmoz.responses.financial_tendencies', language);
    final investmentStyle = L10nService.get('kozmoz.responses.investment_style', language);
    final businessPartners = L10nService.get('kozmoz.responses.business_partner_signs', language);
    final careerPeriods = L10nService.get('kozmoz.responses.career_important_periods', language);
    final promotionOpp = L10nService.get('kozmoz.responses.promotion_opportunities', language);
    final careerWarnings = L10nService.get('kozmoz.responses.career_warnings', language);
    final successStrategy = L10nService.get('kozmoz.responses.success_strategy', language);
    final shortTermGoals = L10nService.get('kozmoz.responses.short_term_goals', language);
    final longTermVision = L10nService.get('kozmoz.responses.long_term_vision', language);
    final careerReminder = L10nService.get('kozmoz.responses.career_reminder', language);

    return '''${sign.symbol} $header
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💼 $naturalTalents
${_getDetailedCareerTalents(sign, language)}

🏆 $careerPaths
${_getBestCareerPaths(sign, language)}

📊 $industryRec
${_getIndustryRecommendations(sign, language)}

💰 $financialTend
${_getFinancialTendencies(sign, language)}

📈 $investmentStyle
${_getInvestmentStyle(sign, language)}

🤝 $businessPartners
${_getBusinessPartners(sign, language)}

⏰ $careerPeriods
${_getCareerTimings(sign, language)}

🚀 $promotionOpp
${_getPromotionAdvice(sign, language)}

⚠️ $careerWarnings
${_getCareerWarnings(sign, language)}

💡 $successStrategy
${_getSuccessStrategy(sign, language)}

🎯 $shortTermGoals
${_getShortTermGoals(sign, language)}

🌟 $longTermVision
${_getLongTermVision(sign, language)}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💎 $careerReminder''';
  }

  String _getMoonResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    final moonPhase = _getCurrentMoonPhase();
    final moonSign = _getLocalizedMoonSign(language);
    final daysToNext = 3 + DateTime.now().day % 5;

    final header = L10nService.getWithParams('kozmoz.responses.moon_phase_header', language, params: {
      'sign': sign.localizedName(language).toUpperCase(),
    });
    final moonCycle = L10nService.get('kozmoz.responses.moon_cycle', language);
    final currentPhase = L10nService.getWithParams('kozmoz.responses.current_phase', language, params: {
      'phase': moonPhase,
    });
    final moonInSign = L10nService.getWithParams('kozmoz.responses.moon_in_sign', language, params: {
      'sign': moonSign,
    });
    final nextPhase = L10nService.getWithParams('kozmoz.responses.next_phase', language, params: {
      'days': daysToNext.toString(),
    });
    final whatToAvoid = L10nService.get('kozmoz.responses.what_to_avoid', language);
    final moonRitual = L10nService.get('kozmoz.responses.moon_ritual', language);
    final crystalSugg = L10nService.get('kozmoz.responses.crystal_suggestion', language);
    final colorsAromas = L10nService.get('kozmoz.responses.colors_aromas', language);
    final mantraAffirm = L10nService.get('kozmoz.responses.mantra_affirmation', language);
    final moonSignEffect = L10nService.getWithParams('kozmoz.responses.moon_sign_effect', language, params: {
      'moon_sign': moonSign,
    });
    final upcomingDates = L10nService.get('kozmoz.responses.upcoming_moon_dates', language);
    final moonReminder = L10nService.get('kozmoz.responses.moon_reminder', language);

    return '''🌙 $header
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌑🌒🌓🌔🌕🌖🌗🌘 $moonCycle

📍 $currentPhase
📍 $moonInSign
📍 $nextPhase

${_getDetailedMoonPhaseEffect(moonPhase, sign, language)}

❌ $whatToAvoid
${_getMoonPhaseDontList(moonPhase, language)}

🧘 $moonRitual
${_getDetailedMoonRitual(moonPhase, sign, language)}

💎 $crystalSugg
${_getMoonCrystals(moonPhase, language)}

🕯️ $colorsAromas
${_getMoonColors(moonPhase, language)}

📿 $mantraAffirm
"${_getMoonMantra(moonPhase, language)}"

🌙 $moonSignEffect
${_getMoonSignEffect(moonSign, sign, language)}

📅 $upcomingDates
${_getUpcomingMoonDates(language)}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌟 $moonReminder''';
  }

  String _getTransitResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    final header = L10nService.getWithParams('kozmoz.responses.transit_header', language, params: {
      'sign': sign.localizedName(language).toUpperCase(),
    });
    final saturnTransit = L10nService.get('kozmoz.responses.saturn_transit', language);
    final jupiterTransit = L10nService.get('kozmoz.responses.jupiter_transit', language);
    final plutoTransit = L10nService.get('kozmoz.responses.pluto_transit', language);
    final uranusTransit = L10nService.get('kozmoz.responses.uranus_transit', language);
    final neptuneTransit = L10nService.get('kozmoz.responses.neptune_transit', language);
    final mercuryStatus = L10nService.get('kozmoz.responses.mercury_status', language);
    final venusStatus = L10nService.get('kozmoz.responses.venus_status', language);
    final marsStatus = L10nService.get('kozmoz.responses.mars_status', language);

    return '''🪐 $header
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

♄ $saturnTransit
${_getSaturnTransit(sign, language)}

♃ $jupiterTransit
${_getJupiterTransit(sign, language)}

♇ $plutoTransit
${_getPlutoTransit(sign, language)}

♅ $uranusTransit
${_getUranusTransit(sign, language)}

♆ $neptuneTransit
${_getNeptuneTransit(sign, language)}

☿ $mercuryStatus
${_getMercuryStatus(sign, language)}

♀ $venusStatus
${_getVenusStatus(sign, language)}

♂ $marsStatus
${_getMarsStatus(sign, language)}

⚡ ${L10nService.get('kozmoz.responses.critical_periods', language)}
${_getCriticalPeriods(sign, language)}

🌟 ${L10nService.get('kozmoz.responses.opportunity_windows', language)}
${_getOpportunityWindows(sign, language)}

🔮 ${L10nService.get('kozmoz.responses.transit_interpretation', language)}
${_getTransitSummary(sign, language)}

💡 ${L10nService.get('kozmoz.responses.transit_recommendations', language)}
${_getTransitRecommendations(sign, language)}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌌 ${L10nService.get('kozmoz.responses.transit_reminder', language)}''';
  }

  String _getRisingResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    final header = L10nService.getWithParams('kozmoz.responses.rising_sign_header', language, params: {
      'sign': sign.localizedName(language).toUpperCase(),
    });
    final whatIs = L10nService.get('kozmoz.responses.rising_sign_what_is', language);
    final description = L10nService.get('kozmoz.responses.rising_sign_description', language);
    final aspects = L10nService.get('kozmoz.responses.rising_sign_aspects', language);
    final twelveRising = L10nService.get('kozmoz.responses.twelve_rising_signs', language);
    final risingAries = L10nService.get('kozmoz.responses.rising_aries', language);
    final risingTaurus = L10nService.get('kozmoz.responses.rising_taurus', language);
    final risingGemini = L10nService.get('kozmoz.responses.rising_gemini', language);
    final risingCancer = L10nService.get('kozmoz.responses.rising_cancer', language);
    final risingLeo = L10nService.get('kozmoz.responses.rising_leo', language);
    final risingVirgo = L10nService.get('kozmoz.responses.rising_virgo', language);
    final risingLibra = L10nService.get('kozmoz.responses.rising_libra', language);
    final risingScorpio = L10nService.get('kozmoz.responses.rising_scorpio', language);
    final risingSagittarius = L10nService.get('kozmoz.responses.rising_sagittarius', language);
    final risingCapricorn = L10nService.get('kozmoz.responses.rising_capricorn', language);
    final risingAquarius = L10nService.get('kozmoz.responses.rising_aquarius', language);
    final risingPisces = L10nService.get('kozmoz.responses.rising_pisces', language);
    final calculateTip = L10nService.get('kozmoz.responses.calculate_rising_tip', language);
    final calculateNote = L10nService.get('kozmoz.responses.calculate_rising_note', language);
    final reminder = L10nService.get('kozmoz.responses.rising_reminder', language);

    return '''⬆️ $header
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌟 $whatIs
$description
$aspects

${_getRisingSignDetails(sign, language)}

🎭 $twelveRising

♈ $risingAries
${_getRisingAriesEffect(language)}

♉ $risingTaurus
${_getRisingTaurusEffect(language)}

♊ $risingGemini
${_getRisingGeminiEffect(language)}

♋ $risingCancer
${_getRisingCancerEffect(language)}

♌ $risingLeo
${_getRisingLeoEffect(language)}

♍ $risingVirgo
${_getRisingVirgoEffect(language)}

♎ $risingLibra
${_getRisingLibraEffect(language)}

♏ $risingScorpio
${_getRisingScorpioEffect(language)}

♐ $risingSagittarius
${_getRisingSagittariusEffect(language)}

♑ $risingCapricorn
${_getRisingCapricornEffect(language)}

♒ $risingAquarius
${_getRisingAquariusEffect(language)}

♓ $risingPisces
${_getRisingPiscesEffect(language)}

💡 $calculateTip
$calculateNote

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✨ $reminder''';
  }

  String _getCompatibilityResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    final header = L10nService.getWithParams('kozmoz.responses.compatibility_header', language, params: {
      'sign': sign.localizedName(language).toUpperCase(),
    });
    final elementCompat = L10nService.get('kozmoz.responses.element_compatibility', language);
    final signBySign = L10nService.get('kozmoz.responses.sign_by_sign_details', language);
    final bestMatches = L10nService.get('kozmoz.responses.best_matches', language);
    final challengingMatches = L10nService.get('kozmoz.responses.challenging_matches', language);
    final romanticVsBusiness = L10nService.get('kozmoz.responses.romantic_vs_business', language);
    final synastryTips = L10nService.get('kozmoz.responses.synastry_tips', language);
    final compatTips = L10nService.get('kozmoz.responses.compatibility_tips', language);
    final reminder = L10nService.get('kozmoz.responses.compatibility_reminder', language);

    return '''${sign.symbol} $header
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔥 $elementCompat
${_getElementCompatibility(sign, language)}

💑 $signBySign

${_getAllSignCompatibility(sign, language)}

🎯 $bestMatches
${_getTop3Compatible(sign, language)}

⚡ $challengingMatches
${_getTop3Challenging(sign, language)}

💕 $romanticVsBusiness
${_getRomanticVsBusiness(sign, language)}

🔮 $synastryTips
${_getSynastryTips(sign, language)}

💡 $compatTips
${_getCompatibilityTips(sign, language)}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
❤️ $reminder''';
  }

  String _getNumerologyResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    final header = L10nService.getWithParams('kozmoz.responses.numerology_header', language, params: {
      'sign': sign.localizedName(language).toUpperCase(),
    });
    final lifePathNumbers = L10nService.get('kozmoz.responses.life_path_numbers', language);
    final lifePath1 = L10nService.get('kozmoz.responses.life_path_1', language);
    final lifePath2 = L10nService.get('kozmoz.responses.life_path_2', language);
    final lifePath3 = L10nService.get('kozmoz.responses.life_path_3', language);
    final lifePath4 = L10nService.get('kozmoz.responses.life_path_4', language);
    final lifePath5 = L10nService.get('kozmoz.responses.life_path_5', language);
    final lifePath6 = L10nService.get('kozmoz.responses.life_path_6', language);
    final lifePath7 = L10nService.get('kozmoz.responses.life_path_7', language);
    final lifePath8 = L10nService.get('kozmoz.responses.life_path_8', language);
    final lifePath9 = L10nService.get('kozmoz.responses.life_path_9', language);
    final masterNumbers = L10nService.get('kozmoz.responses.master_numbers', language);
    final personalYearCalc = L10nService.get('kozmoz.responses.personal_year_calc', language);
    final signNumerology = L10nService.getWithParams('kozmoz.responses.sign_numerology_connection', language, params: {
      'sign': sign.localizedName(language),
    });
    final reminder = L10nService.get('kozmoz.responses.numerology_reminder', language);

    return '''🔢 $header
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 $lifePathNumbers

1️⃣ $lifePath1
${_getLifePath1Details(language)}

2️⃣ $lifePath2
${_getLifePath2Details(language)}

3️⃣ $lifePath3
${_getLifePath3Details(language)}

4️⃣ $lifePath4
${_getLifePath4Details(language)}

5️⃣ $lifePath5
${_getLifePath5Details(language)}

6️⃣ $lifePath6
${_getLifePath6Details(language)}

7️⃣ $lifePath7
${_getLifePath7Details(language)}

8️⃣ $lifePath8
${_getLifePath8Details(language)}

9️⃣ $lifePath9
${_getLifePath9Details(language)}

🌟 $masterNumbers
${_getMasterNumbers(language)}

📅 $personalYearCalc
${_getPersonalYearInfo(language)}

🔮 $signNumerology
${_getSignNumerologyConnection(sign, language)}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💫 $reminder''';
  }

  String _getTarotResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    final cardKeys = ['magician', 'high_priestess', 'empress', 'emperor', 'hierophant',
                   'lovers', 'chariot', 'strength', 'hermit', 'wheel_of_fortune',
                   'justice', 'hanged_man', 'death', 'temperance', 'devil',
                   'tower', 'star', 'moon', 'sun', 'judgement', 'world'];
    final cardIdx1 = DateTime.now().microsecond % cardKeys.length;
    final cardIdx2 = (DateTime.now().millisecond + 7) % cardKeys.length;
    final cardIdx3 = (DateTime.now().second + 3) % cardKeys.length;
    final card1 = L10nService.get('tarot.major_arcana.${cardKeys[cardIdx1]}.name', language);
    final card2 = L10nService.get('tarot.major_arcana.${cardKeys[cardIdx2]}.name', language);
    final card3 = L10nService.get('tarot.major_arcana.${cardKeys[cardIdx3]}.name', language);

    final header = L10nService.getWithParams('kozmoz.responses.tarot_header', language, params: {
      'sign': sign.localizedName(language).toUpperCase(),
    });
    final threeCardSpread = L10nService.get('kozmoz.responses.three_card_spread', language);
    final pastCard = L10nService.getWithParams('kozmoz.responses.past_card', language, params: {'card': card1});
    final presentCard = L10nService.getWithParams('kozmoz.responses.present_card', language, params: {'card': card2});
    final futureCard = L10nService.getWithParams('kozmoz.responses.future_card', language, params: {'card': card3});
    final combinedReading = L10nService.get('kozmoz.responses.combined_reading', language);
    final adviceCard = L10nService.get('kozmoz.responses.advice_card', language);
    final signNumerology = L10nService.getWithParams('kozmoz.responses.sign_numerology_connection', language, params: {
      'sign': sign.localizedName(language),
    });
    final cardOfTheDay = L10nService.get('kozmoz.responses.card_of_the_day', language);
    final cardMessage = L10nService.get('kozmoz.responses.card_message', language);
    final reminder = L10nService.get('kozmoz.responses.tarot_reminder', language);

    return '''🎴 $header
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔮 $threeCardSpread
━━━━━━━━━━━━━━━━━━━━

⏮️ $pastCard
${_getDetailedTarotMeaning(card1, language)}

⏸️ $presentCard
${_getDetailedTarotMeaning(card2, language)}

⏭️ $futureCard
${_getDetailedTarotMeaning(card3, language)}

🎯 $combinedReading
${_getTarotReading(card1, card2, card3, sign, language)}

💡 $adviceCard
${_getTarotAdvice(card2, sign, language)}

🌟 $signNumerology
${_getSignTarotConnection(sign, language)}

✨ $cardOfTheDay
$card2

$cardMessage
"${_getTarotMessage(card2, language)}"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🃏 $reminder''';
  }

  String _getAuraResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    final header = L10nService.getWithParams('kozmoz.responses.aura_header', language, params: {
      'sign': sign.localizedName(language).toUpperCase(),
    });
    final auraColors = L10nService.get('kozmoz.responses.aura_colors', language);
    final energyFrequency = L10nService.get('kozmoz.responses.energy_frequency', language);
    final energyLevel = L10nService.get('kozmoz.responses.energy_level', language);
    final auraLayers = L10nService.get('kozmoz.responses.aura_layers', language);
    final energyBlocks = L10nService.get('kozmoz.responses.energy_blocks', language);
    final auraStrengthening = L10nService.get('kozmoz.responses.aura_strengthening', language);
    final energyCleansing = L10nService.get('kozmoz.responses.energy_cleansing', language);
    final protectionShield = L10nService.get('kozmoz.responses.protection_shield', language);
    final compatibleCrystals = L10nService.get('kozmoz.responses.compatible_crystals', language);
    final colorTherapy = L10nService.get('kozmoz.responses.color_therapy', language);
    final energyMeditation = L10nService.get('kozmoz.responses.energy_meditation', language);
    final reminder = L10nService.get('kozmoz.responses.aura_reminder', language);

    return '''✨ $header
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌈 $auraColors
${_getDetailedAuraColors(sign, language)}

💎 $energyFrequency
${_getEnergyFrequency(sign, language)}

🔋 $energyLevel
${_getEnergyLevel(sign, language)}

🧿 $auraLayers
${_getAuraLayers(sign, language)}

⚡ $energyBlocks
${_getEnergyBlocks(sign, language)}

🌟 $auraStrengthening
${_getAuraStrengtheningDetailed(sign, language)}

💆 $energyCleansing
${_getEnergyCleansing(sign, language)}

🔮 $protectionShield
${_getProtectionShield(sign, language)}

💎 $compatibleCrystals
${_getAuraCrystals(sign, language)}

🕯️ $colorTherapy
${_getColorTherapy(sign, language)}

🧘 $energyMeditation
${_getEnergyMeditation(sign, language)}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌟 $reminder''';
  }

  String _getSpiritualResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    final header = L10nService.getWithParams('kozmoz.responses.spiritual_header', language, params: {
      'sign': sign.localizedName(language).toUpperCase(),
    });
    final evolutionLevel = L10nService.get('kozmoz.responses.spiritual_evolution_level', language);
    final lifeMission = L10nService.get('kozmoz.responses.life_mission', language);
    final karmicLessons = L10nService.get('kozmoz.responses.karmic_lessons', language);
    final repeatingPatterns = L10nService.get('kozmoz.responses.repeating_patterns', language);
    final spiritualPowers = L10nService.get('kozmoz.responses.spiritual_powers', language);
    final meditationPractices = L10nService.get('kozmoz.responses.meditation_practices', language);
    final mantras = L10nService.get('kozmoz.responses.mantras', language);
    final nightRituals = L10nService.get('kozmoz.responses.night_rituals', language);
    final morningRituals = L10nService.get('kozmoz.responses.morning_rituals', language);
    final spiritualTools = L10nService.get('kozmoz.responses.spiritual_tools', language);
    final higherSelfConnection = L10nService.get('kozmoz.responses.higher_self_connection', language);
    final auraCleansing = L10nService.get('kozmoz.responses.aura_cleansing', language);
    final reminder = L10nService.get('kozmoz.responses.spiritual_reminder', language);

    return '''🦋 $header
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌟 $evolutionLevel
${_getSpiritualLevel(sign, language)}

🎯 $lifeMission
${_getLifeMission(sign, language)}

🧬 $karmicLessons
${_getKarmicLessons(sign, language)}

🔄 $repeatingPatterns
${_getRepeatingPatterns(sign, language)}

💫 $spiritualPowers
${_getSpiritualGifts(sign, language)}

🧘 $meditationPractices
${_getSpiritualPracticesDetailed(sign, language)}

📿 $mantras
${_getMantras(sign, language)}

🌙 $nightRituals
${_getNightRituals(sign, language)}

☀️ $morningRituals
${_getMorningRituals(sign, language)}

🔮 $spiritualTools
${_getSpiritualTools(sign, language)}

💎 $higherSelfConnection
${_getHigherSelfConnection(sign, language)}

🌈 $auraCleansing
${_getAuraCleansing(sign, language)}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✨ $reminder''';
  }

  String _getLifePurposeResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    final header = L10nService.getWithParams('kozmoz.responses.life_purpose_header', language, params: {
      'sign': sign.localizedName(language).toUpperCase(),
    });
    final spiritualMission = L10nService.get('kozmoz.responses.spiritual_mission', language);
    final lifeMission = L10nService.get('kozmoz.responses.life_mission', language);
    final lessonsToLearn = L10nService.get('kozmoz.responses.lessons_to_learn', language);
    final strengths = L10nService.get('kozmoz.responses.strengths', language);
    final obstaclesToOvercome = L10nService.get('kozmoz.responses.obstacles_to_overcome', language);
    final potentialUnlocks = L10nService.get('kozmoz.responses.potential_unlocks', language);
    final journeyStages = L10nService.get('kozmoz.responses.journey_stages', language);
    final universalContribution = L10nService.get('kozmoz.responses.universal_contribution', language);
    final lifeRoadmap = L10nService.get('kozmoz.responses.life_roadmap', language);
    final reminder = L10nService.get('kozmoz.responses.purpose_reminder', language);

    return '''🎯 $header
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌟 $spiritualMission
${_getDetailedLifeMission(sign, language)}

🎯 $lifeMission
${_getLifePurposeDetails(sign, language)}

📚 $lessonsToLearn
${_getLifeLessonsDetailed(sign, language)}

💪 $strengths
${_getStrengthsForPurpose(sign, language)}

⚠️ $obstaclesToOvercome
${_getObstaclesForPurpose(sign, language)}

🔑 $potentialUnlocks
${_getPotentialUnlocks(sign, language)}

🌈 $journeyStages
${_getJourneyStages(sign, language)}

💫 $universalContribution
${_getUniversalContribution(sign, language)}

🧭 $lifeRoadmap
${_getLifeRoadmap(sign, language)}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✨ $reminder''';
  }

  String _getTalentResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    final header = L10nService.getWithParams('kozmoz.responses.talents_header', language, params: {
      'sign': sign.localizedName(language).toUpperCase(),
    });
    final innateTalents = L10nService.get('kozmoz.responses.innate_talents', language);
    final hiddenPotentials = L10nService.get('kozmoz.responses.hidden_potentials', language);
    final waitingActivation = L10nService.get('kozmoz.responses.waiting_activation', language);
    final strongestAreas = L10nService.get('kozmoz.responses.strongest_areas', language);
    final improvementAreas = L10nService.get('kozmoz.responses.improvement_areas', language);
    final unlockingPotential = L10nService.get('kozmoz.responses.unlocking_potential', language);
    final careerUse = L10nService.get('kozmoz.responses.career_use', language);
    final relationshipUse = L10nService.get('kozmoz.responses.relationship_use', language);
    final spiritualUse = L10nService.get('kozmoz.responses.spiritual_use', language);
    final activationCalendar = L10nService.get('kozmoz.responses.activation_calendar', language);
    final reminder = L10nService.get('kozmoz.responses.talents_reminder', language);

    return '''⚡ $header
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎁 $innateTalents
${_getInbornTalents(sign, language)}

💎 $hiddenPotentials
${_getHiddenPotentials(sign, language)}

🔓 $waitingActivation
${_getWaitingActivation(sign, language)}

🎯 $strongestAreas
${_getStrongestAreas(sign, language)}

📈 $improvementAreas
${_getImprovementAreas(sign, language)}

🚀 $unlockingPotential
${_getUnlockingPotential(sign, language)}

💼 $careerUse
${_getTalentCareerUse(sign, language)}

❤️ $relationshipUse
${_getTalentRelationshipUse(sign, language)}

🧘 $spiritualUse
${_getTalentSpiritualUse(sign, language)}

📅 $activationCalendar
${_getActivationCalendar(sign, language)}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌟 $reminder''';
  }

  String _getGreetingResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = L10nService.get('kozmoz.good_morning', language);
    } else if (hour < 18) {
      greeting = L10nService.get('kozmoz.good_afternoon', language);
    } else {
      greeting = L10nService.get('kozmoz.good_evening', language);
    }
    final dear = L10nService.get('kozmoz.dear', language);
    final introMessage = L10nService.getWithParams('kozmoz.responses.greeting_intro', language, params: {
      'element': sign.element.localizedName(language),
    });

    return '''$greeting, $dear ${sign.localizedName(language)}! 🌟

$introMessage''';
  }

  String _getGeneralResponse(zodiac.ZodiacSign sign, String message, AppLanguage language) {
    final header = L10nService.getWithParams('kozmoz.responses.general_response_header', language, params: {
      'sign': sign.localizedName(language).toUpperCase(),
    });
    final universalMessage = L10nService.get('kozmoz.responses.universal_message', language);
    final cosmicPerspective = L10nService.get('kozmoz.responses.cosmic_perspective', language);
    final elementMessage = L10nService.getWithParams('kozmoz.responses.element_message', language, params: {
      'element': sign.element.localizedName(language),
    });
    final universalGuidance = L10nService.get('kozmoz.responses.universal_guidance', language);
    final practicalAdvice = L10nService.get('kozmoz.responses.practical_advice', language);
    final wisdomAffirmation = L10nService.get('kozmoz.responses.wisdom_affirmation', language);
    final moreHelp = L10nService.get('kozmoz.responses.more_help', language);
    final exampleQuestions = L10nService.get('kozmoz.responses.example_questions', language);

    return '''${sign.symbol} $header
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$universalMessage

🌟 $cosmicPerspective
${_getDeepWisdom(sign, language)}

💫 $elementMessage
${_getElementMessage(sign, language)}

🔮 $universalGuidance
${_getUniversalGuidance(sign, language)}

💡 $practicalAdvice
${_getPracticalAdvice(sign, language)}

✨ $wisdomAffirmation
"${_getWisdomAffirmation(sign, language)}"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$moreHelp
$exampleQuestions''';
  }

  // ═══════════════════════════════════════════════════════════════
  // YARDIMCI FONKSİYONLAR
  // ═══════════════════════════════════════════════════════════════

  String _getLocalizedMoonSign(AppLanguage language) {
    final signIndex = DateTime.now().day % 12;
    final signs = zodiac.ZodiacSign.values;
    return signs[signIndex].localizedName(language);
  }

  String _getElementLoveStyle(zodiac.Element element, AppLanguage language) {
    final elementKey = element.name.toLowerCase();
    return L10nService.get('kozmoz.element_daily_notes.$elementKey', language);
  }

  String _getCompatibleSigns(zodiac.ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('kozmoz.compatible_signs.$signKey', language);
  }

  String _getChallengingSigns(zodiac.ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('kozmoz.challenging_signs.$signKey', language);
  }




  String _getCareerStrengths(zodiac.ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('kozmoz.career_strengths.$signKey', language);
  }




  String _getCurrentMoonPhase() {
    final day = DateTime.now().day;
    if (day <= 7) return 'Yeni Ay / Hilal';
    if (day <= 14) return 'İlk Dördün';
    if (day <= 21) return 'Dolunay';
    return 'Son Dördün';
  }




  String _getLifePurposeDescription(zodiac.ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('kozmoz.life_missions.$signKey', language);
  }




  String _getLifeLesson(zodiac.ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('kozmoz.life_lessons.$signKey', language);
  }




  String _getNaturalTalents(zodiac.ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('kozmoz.hidden_talents.$signKey', language);
  }




  // ═══════════════════════════════════════════════════════════════
  // MEGA GELİŞTİRİLMİŞ YARDIMCI FONKSİYONLAR
  // ═══════════════════════════════════════════════════════════════

  // GÜNLÜK FONKSİYONLARI
  String _getLuckyHours(zodiac.ZodiacSign sign) {
    final hours = {
      zodiac.ZodiacSign.aries: '07:00-09:00, 13:00-15:00, 20:00-22:00',
      zodiac.ZodiacSign.taurus: '08:00-10:00, 14:00-16:00, 21:00-23:00',
      zodiac.ZodiacSign.gemini: '09:00-11:00, 15:00-17:00, 19:00-21:00',
      zodiac.ZodiacSign.cancer: '06:00-08:00, 12:00-14:00, 20:00-22:00',
      zodiac.ZodiacSign.leo: '10:00-12:00, 14:00-16:00, 19:00-21:00',
      zodiac.ZodiacSign.virgo: '07:00-09:00, 11:00-13:00, 17:00-19:00',
      zodiac.ZodiacSign.libra: '09:00-11:00, 15:00-17:00, 21:00-23:00',
      zodiac.ZodiacSign.scorpio: '00:00-02:00, 12:00-14:00, 20:00-22:00',
      zodiac.ZodiacSign.sagittarius: '08:00-10:00, 14:00-16:00, 18:00-20:00',
      zodiac.ZodiacSign.capricorn: '06:00-08:00, 10:00-12:00, 16:00-18:00',
      zodiac.ZodiacSign.aquarius: '11:00-13:00, 17:00-19:00, 22:00-00:00',
      zodiac.ZodiacSign.pisces: '05:00-07:00, 13:00-15:00, 21:00-23:00',
    };
    return hours[sign] ?? '10:00-12:00, 16:00-18:00';
  }

  String _getDangerHours(zodiac.ZodiacSign sign) {
    final hours = {
      zodiac.ZodiacSign.aries: '11:00-12:00, 17:00-18:00 - Sabırsızlık ve agresyon riski',
      zodiac.ZodiacSign.taurus: '13:00-14:00, 19:00-20:00 - İnatçılık ve maddi kaygılar',
      zodiac.ZodiacSign.gemini: '12:00-13:00, 18:00-19:00 - Dağınıklık ve iletişim hataları',
      zodiac.ZodiacSign.cancer: '15:00-16:00, 22:00-23:00 - Aşırı duygusallık',
      zodiac.ZodiacSign.leo: '08:00-09:00, 17:00-18:00 - Ego çatışmaları',
      zodiac.ZodiacSign.virgo: '14:00-15:00, 20:00-21:00 - Aşırı eleştiri ve endişe',
      zodiac.ZodiacSign.libra: '12:00-13:00, 18:00-19:00 - Kararsızlık krizi',
      zodiac.ZodiacSign.scorpio: '09:00-10:00, 16:00-17:00 - Yoğun duygular ve şüphe',
      zodiac.ZodiacSign.sagittarius: '11:00-12:00, 17:00-18:00 - Aşırı iyimserlik riski',
      zodiac.ZodiacSign.capricorn: '14:00-15:00, 21:00-22:00 - Aşırı iş yükü stresi',
      zodiac.ZodiacSign.aquarius: '09:00-10:00, 15:00-16:00 - Aşırı bağımsızlık',
      zodiac.ZodiacSign.pisces: '10:00-11:00, 16:00-17:00 - Gerçeklikten kopuş',
    };
    return hours[sign] ?? '12:00-13:00 - Dikkatli ol';
  }

  String _getMorningEnergy(zodiac.ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('kozmoz.daily_energies.morning.$signKey', language);
  }

  String _getAfternoonEnergy(zodiac.ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('kozmoz.daily_energies.afternoon.$signKey', language);
  }

  String _getEveningEnergy(zodiac.ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('kozmoz.daily_energies.evening.$signKey', language);
  }

  String _getDailyAdvice(zodiac.ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('kozmoz.daily_advice.$signKey', language);
  }

  String _getDailyAffirmation(zodiac.ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('kozmoz.daily_affirmations.$signKey', language);
  }

  String _getElementDailyNote(zodiac.Element element, AppLanguage language) {
    final elementKey = element.name.toLowerCase();
    return L10nService.get('kozmoz.element_daily_notes.$elementKey', language);
  }

  // AŞK FONKSİYONLARI
  String _getDetailedLoveEnergy(zodiac.ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('kozmoz.love_energies.$signKey', language);
  }

  String _getLoveLanguage(zodiac.ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('kozmoz.love_languages.$signKey', language);
  }

  String _getIdealPartner(zodiac.ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('kozmoz.ideal_partners.$signKey', language);
  }

  String _getPerfectMatches(zodiac.ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('kozmoz.perfect_matches.$signKey', language);
  }

  String _getGoodMatches(zodiac.ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('kozmoz.compatible_signs.$signKey', language);
  }
  String _getRelationshipWarnings(zodiac.ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('kozmoz.relationship_warnings.$signKey', language);
  }

  String _getCurrentLovePeriod(zodiac.ZodiacSign sign, AppLanguage language) {
    final elementName = sign.element.localizedName(language);
    return L10nService.getWithParams('kozmoz.responses.love_period', language, params: {
      'element': elementName,
    });
  }
  String _getLoveRitual(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.love_ritual', language);
  String _getLoveAdvice(zodiac.ZodiacSign sign, AppLanguage language) {
    final signName = sign.localizedName(language);
    final elementName = sign.element.localizedName(language);
    return L10nService.getWithParams('kozmoz.responses.cosmic_love_advice', language, params: {
      'sign': signName,
      'element': elementName,
    });
  }

  // KARİYER FONKSİYONLARI
  String _getDetailedCareerTalents(zodiac.ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('kozmoz.career_talents.$signKey', language);
  }

  String _getBestCareerPaths(zodiac.ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('kozmoz.career_paths.$signKey', language);
  }

  String _getIndustryRecommendations(zodiac.ZodiacSign sign, AppLanguage language) {
    final elementName = sign.element.localizedName(language);
    final strengths = _getCareerStrengths(sign, language);
    return '$elementName: $strengths';
  }
  String _getFinancialTendencies(zodiac.ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('kozmoz.financial_tendencies.$signKey', language);
  }

  String _getInvestmentStyle(zodiac.ZodiacSign sign, AppLanguage language) {
    final elementName = sign.element.localizedName(language);
    return '$elementName';
  }
  String _getBusinessPartners(zodiac.ZodiacSign sign, AppLanguage language) => _getCompatibleSigns(sign, language);
  String _getCareerTimings(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.career_important_periods', language);
  String _getPromotionAdvice(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.promotion_opportunities', language);
  String _getCareerWarnings(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.career_warnings', language);
  String _getSuccessStrategy(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.success_strategy', language);
  String _getShortTermGoals(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.short_term_goals', language);
  String _getLongTermVision(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.long_term_vision', language);

  // AY FONKSİYONLARI

  // Helper to map phase names to JSON keys
  String _getPhaseKey(String phase) {
    if (phase.contains('Yeni') || phase.toLowerCase().contains('new')) {
      return 'new_moon';
    } else if (phase.contains('İlk') || phase.toLowerCase().contains('first')) {
      return 'first_quarter';
    } else if (phase.contains('Dolunay') || phase.toLowerCase().contains('full')) {
      return 'full_moon';
    } else if (phase.contains('Son') || phase.toLowerCase().contains('last')) {
      return 'last_quarter';
    }
    return 'new_moon'; // default
  }

  String _getDetailedMoonPhaseEffect(String phase, zodiac.ZodiacSign sign, AppLanguage language) {
    final phaseKey = _getPhaseKey(phase);
    final title = L10nService.get('kozmoz.moon_phase_effects.$phaseKey.title', language);
    final description = L10nService.get('kozmoz.moon_phase_effects.$phaseKey.description', language);
    final effects = L10nService.get('kozmoz.moon_phase_effects.$phaseKey.effects', language);
    final forSignLabel = L10nService.getWithParams('kozmoz.responses.for_sign_effects', language, params: {
      'sign': sign.localizedName(language),
    });

    final emoji = phaseKey == 'new_moon' ? '🌑' :
                  phaseKey == 'first_quarter' ? '🌓' :
                  phaseKey == 'full_moon' ? '🌕' : '🌗';

    return '''$emoji $title
━━━━━━━━━━━━━━━━
$description

$forSignLabel
$effects''';
  }

  String _getMoonPhaseDontList(String phase, AppLanguage language) {
    final phaseKey = _getPhaseKey(phase);
    return L10nService.get('kozmoz.moon_dont_list.$phaseKey', language);
  }

  String _getDetailedMoonRitual(String phase, zodiac.ZodiacSign sign, AppLanguage language) {
    final phaseKey = _getPhaseKey(phase);
    return L10nService.get('kozmoz.moon_rituals.$phaseKey', language);
  }

  String _getMoonCrystals(String phase, AppLanguage language) {
    final phaseKey = _getPhaseKey(phase);
    return L10nService.get('kozmoz.moon_crystals.$phaseKey', language);
  }

  String _getMoonColors(String phase, AppLanguage language) {
    final phaseKey = _getPhaseKey(phase);
    return L10nService.get('kozmoz.moon_colors.$phaseKey', language);
  }

  String _getMoonMantra(String phase, AppLanguage language) {
    final phaseKey = _getPhaseKey(phase);
    return L10nService.get('kozmoz.moon_mantras.$phaseKey', language);
  }

  String _getMoonSignEffect(String moonSign, zodiac.ZodiacSign sign, AppLanguage language) {
    return L10nService.getWithParams('kozmoz.responses.moon_sign_effect_detail', language, params: {
      'moon_sign': moonSign,
      'sign': sign.localizedName(language),
    });
  }

  String _getUpcomingMoonDates(AppLanguage language) {
    return L10nService.get('kozmoz.responses.upcoming_moon_dates_detail', language);
  }

  // TRANSİT FONKSİYONLARI
  String _getSaturnTransit(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.transit.saturn_detail', language);
  String _getJupiterTransit(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.transit.jupiter_detail', language);
  String _getPlutoTransit(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.transit.pluto_detail', language);
  String _getUranusTransit(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.transit.uranus_detail', language);
  String _getNeptuneTransit(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.transit.neptune_detail', language);
  String _getMercuryStatus(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.transit.mercury_detail', language);
  String _getVenusStatus(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.transit.venus_detail', language);
  String _getMarsStatus(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.transit.mars_detail', language);
  String _getCriticalPeriods(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.transit.critical_periods', language);
  String _getOpportunityWindows(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.transit.opportunity_windows', language);
  String _getTransitSummary(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.getWithParams('kozmoz.transit.summary', language, params: {
    'sign': sign.localizedName(language),
  });
  String _getTransitRecommendations(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.transit.recommendations', language);

  // YÜKSELEN BURÇ FONKSİYONLARI
  String _getRisingSignDetails(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.getWithParams('kozmoz.rising.details', language, params: {
    'sign': sign.localizedName(language),
  });
  String _getRisingAriesEffect(AppLanguage language) => L10nService.get('kozmoz.rising.aries', language);
  String _getRisingTaurusEffect(AppLanguage language) => L10nService.get('kozmoz.rising.taurus', language);
  String _getRisingGeminiEffect(AppLanguage language) => L10nService.get('kozmoz.rising.gemini', language);
  String _getRisingCancerEffect(AppLanguage language) => L10nService.get('kozmoz.rising.cancer', language);
  String _getRisingLeoEffect(AppLanguage language) => L10nService.get('kozmoz.rising.leo', language);
  String _getRisingVirgoEffect(AppLanguage language) => L10nService.get('kozmoz.rising.virgo', language);
  String _getRisingLibraEffect(AppLanguage language) => L10nService.get('kozmoz.rising.libra', language);
  String _getRisingScorpioEffect(AppLanguage language) => L10nService.get('kozmoz.rising.scorpio', language);
  String _getRisingSagittariusEffect(AppLanguage language) => L10nService.get('kozmoz.rising.sagittarius', language);
  String _getRisingCapricornEffect(AppLanguage language) => L10nService.get('kozmoz.rising.capricorn', language);
  String _getRisingAquariusEffect(AppLanguage language) => L10nService.get('kozmoz.rising.aquarius', language);
  String _getRisingPiscesEffect(AppLanguage language) => L10nService.get('kozmoz.rising.pisces', language);

  // UYUM FONKSİYONLARI
  String _getElementCompatibility(zodiac.ZodiacSign sign, AppLanguage language) {
    final elementKey = sign.element.name.toLowerCase();
    return L10nService.get('kozmoz.element_compatibility.$elementKey', language);
  }

  String _getAllSignCompatibility(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('synastry.title', language);
  String _getTop3Compatible(zodiac.ZodiacSign sign, AppLanguage language) => _getCompatibleSigns(sign, language);
  String _getTop3Challenging(zodiac.ZodiacSign sign, AppLanguage language) => _getChallengingSigns(sign, language);
  String _getRomanticVsBusiness(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.romantic_vs_business', language);
  String _getSynastryTips(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.synastry_tips', language);
  String _getCompatibilityTips(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.compatibility_tips', language);

  // NUMEROLOJİ FONKSİYONLARI
  String _getLifePath1Details(AppLanguage language) => L10nService.get('kozmoz.numerology.life_path_1', language);
  String _getLifePath2Details(AppLanguage language) => L10nService.get('kozmoz.numerology.life_path_2', language);
  String _getLifePath3Details(AppLanguage language) => L10nService.get('kozmoz.numerology.life_path_3', language);
  String _getLifePath4Details(AppLanguage language) => L10nService.get('kozmoz.numerology.life_path_4', language);
  String _getLifePath5Details(AppLanguage language) => L10nService.get('kozmoz.numerology.life_path_5', language);
  String _getLifePath6Details(AppLanguage language) => L10nService.get('kozmoz.numerology.life_path_6', language);
  String _getLifePath7Details(AppLanguage language) => L10nService.get('kozmoz.numerology.life_path_7', language);
  String _getLifePath8Details(AppLanguage language) => L10nService.get('kozmoz.numerology.life_path_8', language);
  String _getLifePath9Details(AppLanguage language) => L10nService.get('kozmoz.numerology.life_path_9', language);
  String _getMasterNumbers(AppLanguage language) => L10nService.get('kozmoz.numerology.master_numbers', language);
  String _getPersonalYearInfo(AppLanguage language) => L10nService.get('kozmoz.numerology.personal_year_info', language);
  String _getSignNumerologyConnection(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.getWithParams('kozmoz.numerology.sign_connection', language, params: {
    'sign': sign.localizedName(language),
  });

  // TAROT FONKSİYONLARI
  String _getDetailedTarotMeaning(String card, AppLanguage language) {
    // Map card names to localization keys
    final cardKeyMap = {
      'Sihirbaz': 'magician', 'The Magician': 'magician',
      'Yüksek Rahibe': 'high_priestess', 'The High Priestess': 'high_priestess',
      'İmparatoriçe': 'empress', 'The Empress': 'empress',
      'İmparator': 'emperor', 'The Emperor': 'emperor',
      'Hierofant': 'hierophant', 'The Hierophant': 'hierophant',
      'Aşıklar': 'lovers', 'The Lovers': 'lovers',
      'Savaş Arabası': 'chariot', 'The Chariot': 'chariot',
      'Güç': 'strength', 'Strength': 'strength',
      'Ermiş': 'hermit', 'The Hermit': 'hermit',
      'Kader Çarkı': 'wheel', 'Wheel of Fortune': 'wheel',
      'Adalet': 'justice', 'Justice': 'justice',
      'Asılan Adam': 'hanged_man', 'The Hanged Man': 'hanged_man',
      'Ölüm': 'death', 'Death': 'death',
      'Denge': 'temperance', 'Temperance': 'temperance',
      'Şeytan': 'devil', 'The Devil': 'devil',
      'Kule': 'tower', 'The Tower': 'tower',
      'Yıldız': 'star', 'The Star': 'star',
      'Ay': 'moon', 'The Moon': 'moon',
      'Güneş': 'sun', 'The Sun': 'sun',
      'Yargı': 'judgement', 'Judgement': 'judgement',
      'Dünya': 'world', 'The World': 'world',
    };
    final cardKey = cardKeyMap[card] ?? 'default';
    return L10nService.get('kozmoz.tarot.meanings.$cardKey', language);
  }

  String _getTarotReading(String card1, String card2, String card3, zodiac.ZodiacSign sign, AppLanguage language) => L10nService.getWithParams('kozmoz.tarot.reading', language, params: {
    'card1': card1,
    'card2': card2,
    'card3': card3,
  });
  String _getTarotAdvice(String card, zodiac.ZodiacSign sign, AppLanguage language) => L10nService.getWithParams('kozmoz.tarot.advice', language, params: {
    'card': card,
    'sign': sign.localizedName(language),
  });
  String _getSignTarotConnection(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.getWithParams('kozmoz.tarot.sign_connection', language, params: {
    'sign': sign.localizedName(language),
  });
  String _getTarotMessage(String card, AppLanguage language) => L10nService.get('kozmoz.tarot.message', language);

  // AURA FONKSİYONLARI
  String _getDetailedAuraColors(zodiac.ZodiacSign sign, AppLanguage language) {
    final elementKey = sign.element.name.toLowerCase();
    return L10nService.get('kozmoz.aura.colors.$elementKey', language);
  }

  String _getEnergyFrequency(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.getWithParams('kozmoz.aura.energy_frequency', language, params: {
    'element': sign.element.localizedName(language),
  });
  String _getEnergyLevel(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.getWithParams('kozmoz.aura.energy_level', language, params: {
    'sign': sign.localizedName(language),
  });
  String _getAuraLayers(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.aura.layers', language);
  String _getEnergyBlocks(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.aura.blocks', language);
  String _getAuraStrengthening(zodiac.Element element, AppLanguage language) {
    final elementKey = element.name.toLowerCase();
    return L10nService.get('kozmoz.aura.strengthening.$elementKey', language);
  }
  String _getAuraStrengtheningDetailed(zodiac.ZodiacSign sign, AppLanguage language) => _getAuraStrengthening(sign.element, language);
  String _getEnergyCleansing(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.aura.cleansing', language);
  String _getProtectionShield(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.aura.protection', language);
  String _getAuraCrystals(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.aura.crystals', language);
  String _getColorTherapy(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.getWithParams('kozmoz.aura.color_therapy', language, params: {
    'element': sign.element.localizedName(language),
  });
  String _getEnergyMeditation(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.aura.meditation', language);

  // SPİRİTÜEL FONKSİYONLAR
  String _getSpiritualLevel(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.spiritual_evolution_level', language);
  String _getLifeMission(zodiac.ZodiacSign sign, AppLanguage language) => _getLifePurposeDescription(sign, language);
  String _getKarmicLessons(zodiac.ZodiacSign sign, AppLanguage language) => '${sign.localizedName(language)}: ${_getLifeLesson(sign, language)}';
  String _getRepeatingPatterns(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.repeating_patterns', language);
  String _getSpiritualGifts(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.spiritual_powers', language);
  String _getSpiritualPracticesDetailed(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.meditation_practices', language);
  String _getMantras(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.mantra_affirmation', language);
  String _getNightRituals(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.night_rituals', language);
  String _getMorningRituals(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.morning_rituals', language);
  String _getSpiritualTools(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.spiritual_tools', language);
  String _getHigherSelfConnection(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.higher_self_connection', language);
  String _getAuraCleansing(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.aura_cleansing', language);

  // HAYAT AMACI FONKSİYONLARI
  String _getDetailedLifeMission(zodiac.ZodiacSign sign, AppLanguage language) => '${sign.localizedName(language)}: ${_getLifePurposeDescription(sign, language)}';
  String _getLifePurposeDetails(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.purpose_details', language);
  String _getLifeLessonsDetailed(zodiac.ZodiacSign sign, AppLanguage language) => _getLifeLesson(sign, language);
  String _getStrengthsForPurpose(zodiac.ZodiacSign sign, AppLanguage language) => _getCareerStrengths(sign, language);
  String _getObstaclesForPurpose(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.obstacles_to_overcome', language);
  String _getPotentialUnlocks(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.potential_unlocks', language);
  String _getJourneyStages(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.journey_stages', language);
  String _getUniversalContribution(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.universal_contribution', language);
  String _getLifeRoadmap(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.life_roadmap', language);

  // YETENEK FONKSİYONLARI
  String _getInbornTalents(zodiac.ZodiacSign sign, AppLanguage language) => _getNaturalTalents(sign, language);
  String _getHiddenPotentials(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.hidden_potentials', language);
  String _getWaitingActivation(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.waiting_activation', language);
  String _getStrongestAreas(zodiac.ZodiacSign sign, AppLanguage language) => _getCareerStrengths(sign, language);
  String _getImprovementAreas(zodiac.ZodiacSign sign, AppLanguage language) => _getLifeLesson(sign, language);
  String _getUnlockingPotential(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.unlocking_potential', language);
  String _getTalentCareerUse(zodiac.ZodiacSign sign, AppLanguage language) => _getCareerStrengths(sign, language);
  String _getTalentRelationshipUse(zodiac.ZodiacSign sign, AppLanguage language) => _getElementLoveStyle(sign.element, language);
  String _getTalentSpiritualUse(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.spiritual_use', language);
  String _getActivationCalendar(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.activation_calendar', language);

  // GENEL BİLGELİK FONKSİYONLARI
  String _getDeepWisdom(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.cosmic_perspective', language);
  String _getElementMessage(zodiac.ZodiacSign sign, AppLanguage language) => _getElementDailyNote(sign.element, language);
  String _getUniversalGuidance(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.universal_guidance', language);
  String _getPracticalAdvice(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.practical_advice', language);
  String _getWisdomAffirmation(zodiac.ZodiacSign sign, AppLanguage language) => L10nService.get('kozmoz.responses.wisdom_affirmation', language);

  // ═══════════════════════════════════════════════════════════════
  // 10x GELİŞTİRME: YENİ YANIT FONKSİYONLARI
  // ═══════════════════════════════════════════════════════════════

  String _getDreamResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    return '''${sign.symbol} ${sign.localizedName(language).toUpperCase()} RÜYA & BİLİNÇALTI ANALİZİ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌙 RÜYA ELEMENTİN
${_getDreamElement(sign)}

💭 BİLİNÇALTI MESAJLARIN
${_getSubconsciousMessages(sign)}

🔮 RÜYA SEMBOLLERİN
${_getDreamSymbols(sign)}

🌌 LÜSİD RÜYA REHBERİ
${_getLucidDreamGuide(sign)}

🌊 UYKU RİTÜELLERİN
${_getSleepRituals(sign)}

📖 RÜYA GÜNLÜĞÜ TAVSİYESİ
• Uyanır uyanmaz yaz
• Duyguları not al
• Tekrarlayan temaları takip et
• Ay fazlarıyla ilişkilendir

✨ GECE AFİRMASYONU
"Bu gece bilinçaltımın bilgeliğini alıyorum. Rüyalarım bana rehberlik ediyor."

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌙 Rüyalarını paylaş, birlikte yorumlayalım!''';
  }

  String _getTantraResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    return '''${sign.symbol} ${sign.localizedName(language).toUpperCase()} TANTRA & ENERJİ REHBERİ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

༄ TANTRA PRATİĞİN
${_getTantraPractice(sign)}

🔥 KUNDALİNİ DURUMUN
${_getKundaliniStatus(sign)}

🌬️ NEFES ÇALIŞMASI
${_getBreathWork(sign)}

💫 ENERJİ DÖNÜŞÜMÜ
${_getEnergyTransformation(sign)}

🧘 MEDİTASYON TEKNİĞİN
${_getMeditationTechnique(sign)}

⚡ ÇAKRA AKTİVASYONU
${_getChakraActivation(sign)}

🌸 GÜNLÜK PRATİK
1. Sabah: 5 dk nefes çalışması
2. Öğle: Farkındalık molası
3. Akşam: Enerji temizliği
4. Gece: Minnettarlık meditasyonu

✨ TANTRA AFİRMASYONU
"Yaşam gücüm özgürce akıyor. Enerjimi bilinçli yönetiyorum."

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
༄ Enerji bedenin sana teşekkür ediyor!''';
  }

  String _getHealthResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    return '''${sign.symbol} ${sign.localizedName(language).toUpperCase()} SAĞLIK & ŞİFA ANALİZİ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🏥 HASSAS BÖLGELERİN
${_getSensitiveAreas(sign)}

🌿 BİTKİSEL ŞİFA
${_getHerbalHealing(sign)}

🥗 ASTROLOJİK BESLENME
${_getAstroNutrition(sign)}

🧪 DETOKS DÖNEMLERİN
${_getDetoxPeriods(sign)}

💪 FİZİKSEL HAREKET
${_getPhysicalMovement(sign)}

🧘 ZİHİNSEL SAĞLIK
${_getMentalWellness(sign)}

💊 ELEMENT DENGESİ
${sign.element.localizedName(language)} elementi olarak:
${_getElementBalance(sign)}

✨ SAĞLIK AFİRMASYONU
"Bedenim şifa buluyor, zihnim huzur buluyor, ruhum parıldıyor."

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌿 Sağlığın en değerli sermayendir!''';
  }

  String _getHomeResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    return '''${sign.symbol} ${sign.localizedName(language).toUpperCase()} EV & AİLE REHBERİ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🏠 TAŞINMA ZAMANLARI
${_getMovingTimes(sign)}

👨‍👩‍👧‍👦 AİLE DİNAMİKLERİN
${_getFamilyDynamics(sign)}

👶 ÇOCUK PLANLAMASI
${_getChildPlanning(sign)}

🐕 EVCİL HAYVAN UYUMU
${_getPetCompatibility(sign)}

🏡 İDEAL EV ENERJİSİ
${_getIdealHomeEnergy(sign)}

🪴 FENG SHUI ÖNERİLERİ
${_getFengShuiTips(sign)}

🕯️ EV KORUMA RİTÜELİ
1. Kapıda tuz bırak
2. Adaçayı ile duman
3. Kristallerle grid oluştur
4. Düzenli havalandır

✨ EV AFİRMASYONU
"Evim kutsal alanımdır. Sevgi ve huzur ile dolduruyorum."

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🏠 Evlerin enerjisi sakinlerine yansır!''';
  }

  String _getTravelResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    return '''${sign.symbol} ${sign.localizedName(language).toUpperCase()} SEYAHAT & MACERA REHBERİ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌍 ŞANSLI DESTİNASYONLARIN
${_getLuckyDestinations(sign)}

✈️ SEYAHAT ZAMANLARI
${_getTravelTimes(sign)}

🏖️ TATİL TİPİN
${_getVacationType(sign)}

🧳 KAÇINILACAK DÖNEMLER
${_getAvoidTravelTimes(sign)}

🌏 ASTROLOJİK COĞRAFYA
${_getAstroGeography(sign)}

🗺️ RUHSAL YOLCULUKLAR
${_getSpiritualJourneys(sign)}

📍 2024 ÖNERİLERİ
${_get2024Recommendations(sign)}

✨ SEYAHAT AFİRMASYONU
"Her yolculuk beni dönüştürüyor. Evren beni koruyarak taşıyor."

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✈️ Dünya senin keşfetmeni bekliyor!''';
  }

  String _getEducationResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    return '''${sign.symbol} ${sign.localizedName(language).toUpperCase()} EĞİTİM & ÖĞRENME REHBERİ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📚 DOĞAL ÖĞRENİM ALANIN
${_getNaturalLearning(sign)}

🎓 SINAV ZAMANLARI
${_getExamTimes(sign)}

✍️ YARATICI İFADE
${_getCreativeExpression(sign)}

🧠 ÖĞRENME STİLİN
${_getLearningStyle(sign)}

📖 ÖNERİLEN KONULAR
${_getRecommendedSubjects(sign)}

🎯 ODAKLANMA TEKNİKLERİ
${_getFocusTechniques(sign)}

⏰ VERİMLİ SAATLERİN
${_getProductiveHours(sign)}

✨ EĞİTİM AFİRMASYONU
"Bilgi özgürlüktür. Her gün büyüyor ve gelişiyorum."

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📚 Öğrenme yolculuğun sonsuz!''';
  }

  String _getShadowResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    return '''${sign.symbol} ${sign.localizedName(language).toUpperCase()} GÖLGE ÇALIŞMASI
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🖤 GÖLGE BENLİĞİN
${_getShadowSelf(sign)}

😈 GİZLİ KORKULARIN
${_getHiddenFears(sign)}

🌑 BASTIRILMIŞ DUYGULAR
${_getSuppressedEmotions(sign)}

🪞 PROJEKSİYON KALIPLARIN
${_getProjectionPatterns(sign)}

🦋 DÖNÜŞÜM YOLU
${_getTransformationPath(sign)}

🌙 KARANLIK AY RİTÜELİ
${_getDarkMoonRitual(sign)}

💔 İYİLEŞME PRATİKLERİ
1. Gölgenle diyalog kur
2. Günlük yazımı yap
3. Şefkat meditasyonu
4. İç çocuk çalışması

✨ GÖLGE AFİRMASYONU
"Karanlığımı kucaklıyorum. Gölgem benim parçam ve öğretmenim."

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌑 Karanlıktan korkmayan, ışığı bulur!''';
  }

  String _getManifestationResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    return '''${sign.symbol} ${sign.localizedName(language).toUpperCase()} MANİFESTASYON REHBERİ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✨ MANİFESTASYON GÜCÜN
${_getManifestationPower(sign)}

🌙 GÜÇLÜ PENCERELER
${_getPowerfulWindows(sign)}

📝 NİYET BELİRLEME
${_getIntentionSetting(sign)}

🎯 VİZYON PANOSU
${_getVisionBoard(sign)}

💫 BOLLUK ENERJİSİ
${_getAbundanceEnergy(sign)}

🕯️ MANİFESTASYON RİTÜELİ
${_getManifestationRitual(sign)}

🌈 ÇEKİM YASASI TEKNİKLERİ
1. Net niyet belirle
2. Görselleştirme yap
3. "Sanki" yaşa
4. Bırak ve güven

✨ MANİFESTASYON AFİRMASYONU
"İsteklerim zaten gerçekleşiyor. Evren benimle işbirliği yapıyor."

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✨ Sen yaratıcısın, hayatını tasarla!''';
  }

  String _getMysticResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    return '''${sign.symbol} ${sign.localizedName(language).toUpperCase()} MİSTİK BİLGELİK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌀 GEÇMİŞ YAŞAMLARIN
${_getPastLives(sign)}

👼 KORUYUCU MELEKLERİN
${_getGuardianAngels(sign)}

🌠 YILDIZ TOHUMLARIN
${_getStarSeeds(sign)}

📜 AKASHİK KAYITLARIN
${_getAkashicRecords(sign)}

🔮 RUHSAL REHBERLERİN
${_getSpiritGuides(sign)}

🌟 KOZMİK MİSYONUN
${_getCosmicMission(sign)}

🌌 EVRENSEL BAĞLANTIN
${sign.element.localizedName(language)} elementi aracılığıyla kozmik akışa bağlısın.
Galaktik kökenin: ${_getGalacticOrigin(sign)}

✨ MİSTİK AFİRMASYON
"Yıldızlardan geldim, yıldızlara döneceğim. Bu yolculuk kutsal."

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌌 Evrenin gizemlerine açıksın!''';
  }

  String _getCrystalResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    return '''${sign.symbol} ${sign.localizedName(language).toUpperCase()} KRİSTAL & TAŞ REHBERİ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💎 ANA GÜÇ TAŞLARIN
${_getMainPowerStones(sign)}

🔮 KORUYUCU KRİSTALLER
${_getProtectiveCrystals(sign)}

💕 AŞK KRİSTALLERİN
${_getLoveCrystals(sign)}

💰 BOLLUK TAŞLARIN
${_getAbundanceStones(sign)}

🧘 MEDİTASYON KRİSTALLERİ
${_getMeditationCrystals(sign)}

⚠️ KAÇINILACAK TAŞLAR
${_getAvoidStones(sign)}

🌙 AKTİVASYON REHBERİ
1. Dolunay'da temizle
2. Yeni Ay'da niyetlendir
3. Güneş/Ay ışığında şarj et
4. Düzenli programla

✨ KRİSTAL AFİRMASYONU
"Taşların bilgeliği beni güçlendiriyor. Dünya Ana'nın enerjisini taşıyorum."

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💎 Kristaller enerji yoğunlaştırıcılardır!''';
  }

  String _getRitualResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    return '''${sign.symbol} ${sign.localizedName(language).toUpperCase()} RİTÜEL & TÖRENSELLİK REHBERİ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🕯️ DOLUNAY RİTÜELİN
${_getFullMoonRitual(sign)}

🌑 YENİ AY RİTÜELİN
${_getNewMoonRitual(sign)}

🌸 MEVSİMSEL GEÇİŞLER
${_getSeasonalTransitions(sign)}

🔥 ENERJİ TEMİZLİĞİ
${_getEnergyCleansingRitual(sign)}

🌿 ADAÇAYI PROTOKOLÜ
1. Niyetini belirle
2. Doğudan başla, saat yönünde
3. Köşelere özellikle dikkat
4. Kapı ve pencerelerden dışarı

💫 GÜNLÜK MİNİ RİTÜELLER
${_getDailyMiniRituals(sign)}

🌙 AY FAZINA GÖRE
${_getMoonPhaseRituals(sign)}

✨ RİTÜEL AFİRMASYONU
"Her eylemim kutsal. Yaşamımı törenselleştiriyorum."

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🕯️ Ritüeller niyeti güçlendirir!''';
  }

  String _getChakraResponse(zodiac.ZodiacSign sign, AppLanguage language) {
    return '''${sign.symbol} ${sign.localizedName(language).toUpperCase()} ÇAKRA ANALİZİ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔴 KÖK ÇAKRA (Muladhara)
${_getRootChakra(sign)}

🟠 SAKRAL ÇAKRA (Svadhisthana)
${_getSacralChakra(sign)}

💛 SOLAR PLEKSUS (Manipura)
${_getSolarPlexus(sign)}

💚 KALP ÇAKRA (Anahata)
${_getHeartChakra(sign)}

🔵 BOĞAZ ÇAKRA (Vishuddha)
${_getThroatChakra(sign)}

💜 ÜÇÜNCÜ GÖZ (Ajna)
${_getThirdEye(sign)}

🤍 TAÇ ÇAKRA (Sahasrara)
${_getCrownChakra(sign)}

⚖️ GENEL DENGE
${_getOverallBalance(sign)}

✨ ÇAKRA AFİRMASYONU
"Yedi enerji merkezim uyum içinde çalışıyor. Enerjim özgürce akıyor."

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌈 Enerji bedeni sağlıklı, fiziksel beden sağlıklı!''';
  }

  // YARDIMCI FONKSİYONLAR - YENİ KATEGORİLER
  String _getDreamElement(zodiac.ZodiacSign sign) => '${sign.element.nameTr} elementi: Rüyaların ${_getElementDreamStyle(sign.element)} temaları taşır.';
  String _getSubconsciousMessages(zodiac.ZodiacSign sign) => '${sign.nameTr} bilinçaltı: ${_getSignSubconscious(sign)}';
  String _getDreamSymbols(zodiac.ZodiacSign sign) => '${sign.symbol}: ${_getSignDreamSymbols(sign)}';
  String _getLucidDreamGuide(zodiac.ZodiacSign sign) => 'Element ${sign.element.nameTr}: ${_getElementLucidTip(sign.element)}';
  String _getSleepRituals(zodiac.ZodiacSign sign) => '• Lavanta yağı\n• ${_getSignHerb(sign)} çayı\n• Ametist yastık altında\n• Rüya niyeti belirle';

  String _getTantraPractice(zodiac.ZodiacSign sign) => '${sign.element.nameTr} elementi tantrası: ${_getElementTantra(sign.element)}';
  String _getKundaliniStatus(zodiac.ZodiacSign sign) => '${sign.nameTr} kundalini: Uyanış seviyesi ve öneriler.';
  String _getBreathWork(zodiac.ZodiacSign sign) => '${sign.element.nameTr} nefesi: ${_getElementBreath(sign.element)}';
  String _getEnergyTransformation(zodiac.ZodiacSign sign) => 'Yaratıcı enerji dönüşümü için ${sign.element.nameTr} bilgeliğini kullan.';
  String _getMeditationTechnique(zodiac.ZodiacSign sign) => '${sign.nameTr} meditasyonu: ${_getSignMeditation(sign)}';
  String _getChakraActivation(zodiac.ZodiacSign sign) => '${sign.nameTr} için aktif çakra: ${_getSignChakra(sign)}';

  String _getSensitiveAreas(zodiac.ZodiacSign sign) => _getHealthWeakness(sign);
  String _getHerbalHealing(zodiac.ZodiacSign sign) => '${sign.nameTr} şifa bitkileri: ${_getSignHerbs(sign)}';
  String _getAstroNutrition(zodiac.ZodiacSign sign) => '${sign.element.nameTr} beslenme: ${_getElementNutrition(sign.element)}';
  String _getDetoxPeriods(zodiac.ZodiacSign sign) => 'Yeni Ay ve Merkür retro sonları ideal.';
  String _getPhysicalMovement(zodiac.ZodiacSign sign) => '${sign.element.nameTr} hareketi: ${_getElementExercise(sign.element)}';
  String _getMentalWellness(zodiac.ZodiacSign sign) => '${sign.nameTr} zihinsel sağlık: Meditasyon ve nefes çalışması önerilir.';
  String _getElementBalance(zodiac.ZodiacSign sign) => '${sign.element.nameTr} dengesini korumak için: ${_getElementHealthTip(sign.element)}';

  String _getMovingTimes(zodiac.ZodiacSign sign) => 'Venüs uyumlu, Merkür direkt dönemleri ideal.';
  String _getFamilyDynamics(zodiac.ZodiacSign sign) => '4. ev analizi: Aile kalıpların ve köklerin.';
  String _getChildPlanning(zodiac.ZodiacSign sign) => '5. ev ve Jüpiter transitlerini takip et.';
  String _getPetCompatibility(zodiac.ZodiacSign sign) => '${sign.element.nameTr}: ${_getElementPet(sign.element)}';
  String _getIdealHomeEnergy(zodiac.ZodiacSign sign) => '${sign.element.nameTr} evi: ${_getElementHome(sign.element)}';
  String _getFengShuiTips(zodiac.ZodiacSign sign) => '${sign.element.nameTr} elementi için feng shui önerileri.';

  String _getLuckyDestinations(zodiac.ZodiacSign sign) => '${sign.nameTr} için: ${_getSignDestinations(sign)}';
  String _getTravelTimes(zodiac.ZodiacSign sign) => 'Jüpiter ve 9. ev transitlerinde seyahat güçlü.';
  String _getVacationType(zodiac.ZodiacSign sign) => '${sign.element.nameTr}: ${_getElementVacation(sign.element)}';
  String _getAvoidTravelTimes(zodiac.ZodiacSign sign) => 'Merkür retro ve Mars karesi dönemlerinde dikkat.';
  String _getAstroGeography(zodiac.ZodiacSign sign) => 'Astrokartografi: Senin için güçlü enerji çizgileri.';
  String _getSpiritualJourneys(zodiac.ZodiacSign sign) => '${sign.nameTr} ruhsal yolculuk: Kutsal mekanlar ve hac.';
  String _get2024Recommendations(zodiac.ZodiacSign sign) => 'Jüpiter\'in etkisiyle bu yıl seyahat enerjisi güçlü.';

  String _getNaturalLearning(zodiac.ZodiacSign sign) => '${sign.element.nameTr} öğrenimi: ${_getElementLearning(sign.element)}';
  String _getExamTimes(zodiac.ZodiacSign sign) => 'Merkür uyumlu, Ay Başak/İkizler dönemleri.';
  String _getCreativeExpression(zodiac.ZodiacSign sign) => '${sign.nameTr} yaratıcılık: ${_getSignCreativity(sign)}';
  String _getLearningStyle(zodiac.ZodiacSign sign) => '${sign.element.nameTr}: ${_getElementLearningStyle(sign.element)}';
  String _getRecommendedSubjects(zodiac.ZodiacSign sign) => '${sign.nameTr} için: ${_getSignSubjects(sign)}';
  String _getFocusTechniques(zodiac.ZodiacSign sign) => '${sign.element.nameTr}: Meditasyon, Pomodoro, doğa molası.';
  String _getProductiveHours(zodiac.ZodiacSign sign) => '${sign.element.nameTr}: ${_getElementProductiveTime(sign.element)}';

  String _getShadowSelf(zodiac.ZodiacSign sign) => '${sign.nameTr} gölgesi: ${_getSignShadow(sign)}';
  String _getHiddenFears(zodiac.ZodiacSign sign) => '${sign.nameTr} korkuları: ${_getSignFears(sign)}';
  String _getSuppressedEmotions(zodiac.ZodiacSign sign) => '${sign.element.nameTr} bastırılmış: ${_getElementSuppressed(sign.element)}';
  String _getProjectionPatterns(zodiac.ZodiacSign sign) => '7. ev karşıtı: ${_getOppositeSign(sign)} özellikleri.';
  String _getTransformationPath(zodiac.ZodiacSign sign) => '${sign.nameTr} dönüşümü: Kabul, anlama, entegrasyon.';
  String _getDarkMoonRitual(zodiac.ZodiacSign sign) => 'Balzamik Ay: Bırakma, affetme, temizlik.';

  String _getManifestationPower(zodiac.ZodiacSign sign) => '${sign.element.nameTr}: ${_getElementManifesting(sign.element)}';
  String _getPowerfulWindows(zodiac.ZodiacSign sign) => 'Yeni Ay ${sign.nameTr}\'da, Jüpiter uyumları.';
  String _getIntentionSetting(zodiac.ZodiacSign sign) => '${sign.element.nameTr} niyeti: ${_getElementIntention(sign.element)}';
  String _getVisionBoard(zodiac.ZodiacSign sign) => '${sign.nameTr} vizyonu: Görselleştirme ve yazılı niyet.';
  String _getAbundanceEnergy(zodiac.ZodiacSign sign) => '2. ve 8. ev enerjisi: Maddi ve ruhsal bolluk.';
  String _getManifestationRitual(zodiac.ZodiacSign sign) => 'Yeni Ay ritüeli + kristal grid + yazılı niyet.';

  String _getPastLives(zodiac.ZodiacSign sign) => 'Güney Ay Düğümü ve 12. ev: Geçmiş yaşam izleri.';
  String _getGuardianAngels(zodiac.ZodiacSign sign) => '${sign.nameTr} koruyucusu: ${_getSignAngel(sign)}';
  String _getStarSeeds(zodiac.ZodiacSign sign) => '${sign.element.nameTr}: Galaktik bağlantılar.';
  String _getAkashicRecords(zodiac.ZodiacSign sign) => 'Ruh sözleşmesi ve yaşam derslerin.';
  String _getSpiritGuides(zodiac.ZodiacSign sign) => '${sign.element.nameTr} rehberleri: ${_getElementGuides(sign.element)}';
  String _getCosmicMission(zodiac.ZodiacSign sign) => 'Kuzey Ay Düğümü: Ruhsal evrim yönün.';
  String _getGalacticOrigin(zodiac.ZodiacSign sign) => '${sign.nameTr} yıldız sistemi: ${_getSignConstellation(sign)}';

  String _getMainPowerStones(zodiac.ZodiacSign sign) => '${sign.nameTr}: ${_getSignMainStones(sign)}';
  String _getProtectiveCrystals(zodiac.ZodiacSign sign) => 'Siyah turmalin, obsidiyen, hematit.';
  String _getLoveCrystals(zodiac.ZodiacSign sign) => 'Gül kuvarsı, rodokrozit, kunzit.';
  String _getAbundanceStones(zodiac.ZodiacSign sign) => 'Sitrin, yeşil aventurin, pirrit.';
  String _getMeditationCrystals(zodiac.ZodiacSign sign) => 'Ametist, labradorit, selenite.';
  String _getAvoidStones(zodiac.ZodiacSign sign) => '${sign.element.nameTr} için: ${_getElementAvoidStones(sign.element)}';

  String _getFullMoonRitual(zodiac.ZodiacSign sign) => 'Bırakma, tamamlama, kutlama, minnettarlık.';
  String _getNewMoonRitual(zodiac.ZodiacSign sign) => 'Niyet belirleme, tohum ekme, yeni başlangıçlar.';
  String _getSeasonalTransitions(zodiac.ZodiacSign sign) => 'Ekinoks ve gündönümü ritüelleri.';
  String _getEnergyCleansingRitual(zodiac.ZodiacSign sign) => 'Adaçayı, palo santo, tuz banyosu.';
  String _getDailyMiniRituals(zodiac.ZodiacSign sign) => '• Sabah niyeti\n• Öğle şükür\n• Akşam yansıma\n• Gece affetme';
  String _getMoonPhaseRituals(zodiac.ZodiacSign sign) => 'Her ay fazının kendi ritüel enerjisi var.';

  String _getRootChakra(zodiac.ZodiacSign sign) => 'Güvenlik, topraklama, temel ihtiyaçlar.';
  String _getSacralChakra(zodiac.ZodiacSign sign) => 'Yaratıcılık, duygular, cinsellik.';
  String _getSolarPlexus(zodiac.ZodiacSign sign) => 'Güç, irade, özgüven.';
  String _getHeartChakra(zodiac.ZodiacSign sign) => 'Sevgi, şefkat, bağlantı.';
  String _getThroatChakra(zodiac.ZodiacSign sign) => 'İletişim, ifade, doğruluk.';
  String _getThirdEye(zodiac.ZodiacSign sign) => 'Sezgi, vizyon, bilgelik.';
  String _getCrownChakra(zodiac.ZodiacSign sign) => 'Ruhsal bağlantı, aydınlanma.';
  String _getOverallBalance(zodiac.ZodiacSign sign) => '${sign.element.nameTr}: ${_getElementChakraBalance(sign.element)}';

  // Element bazlı yardımcı fonksiyonlar
  String _getElementDreamStyle(zodiac.Element e) => e == zodiac.Element.fire ? 'aksiyon, savaş, liderlik' : e == zodiac.Element.earth ? 'doğa, ev, maddi' : e == zodiac.Element.air ? 'uçuş, iletişim, seyahat' : 'su, duygular, sezgiler';
  String _getElementLucidTip(zodiac.Element e) => e == zodiac.Element.fire ? 'Enerji yüksekken, geceyarısı öncesi' : e == zodiac.Element.earth ? 'Dolunay gecelerinde' : e == zodiac.Element.air ? 'Rüzgarlı gecelerde' : 'Yeni Ay döneminde';
  String _getElementTantra(zodiac.Element e) => e == zodiac.Element.fire ? 'Nefes ateşi, enerji hareketi' : e == zodiac.Element.earth ? 'Duyusal farkındalık, topraklama' : e == zodiac.Element.air ? 'Pranayama, nefes kontrolü' : 'Duygusal akış, su meditasyonu';
  String _getElementBreath(zodiac.Element e) => e == zodiac.Element.fire ? 'Kapalı Burun (Bhastrika)' : e == zodiac.Element.earth ? '4-7-8 Nefesi' : e == zodiac.Element.air ? 'Alternatif Burun' : 'Okyanus Nefesi (Ujjayi)';
  String _getElementNutrition(zodiac.Element e) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.element_nutrition.${e.name}', language);
  }
  String _getElementExercise(zodiac.Element e) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.element_exercise.${e.name}', language);
  }
  String _getElementHealthTip(zodiac.Element e) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.element_health_tip.${e.name}', language);
  }
  String _getElementPet(zodiac.Element e) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.element_pet.${e.name}', language);
  }
  String _getElementHome(zodiac.Element e) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.element_home.${e.name}', language);
  }
  String _getElementVacation(zodiac.Element e) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.element_vacation.${e.name}', language);
  }
  String _getElementLearning(zodiac.Element e) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.element_learning.${e.name}', language);
  }
  String _getElementLearningStyle(zodiac.Element e) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.element_learning_style.${e.name}', language);
  }
  String _getElementProductiveTime(zodiac.Element e) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.element_productive_time.${e.name}', language);
  }
  String _getElementSuppressed(zodiac.Element e) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.element_suppressed.${e.name}', language);
  }
  String _getElementManifesting(zodiac.Element e) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.element_manifesting.${e.name}', language);
  }
  String _getElementIntention(zodiac.Element e) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.element_intention.${e.name}', language);
  }
  String _getElementGuides(zodiac.Element e) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.element_guides.${e.name}', language);
  }
  String _getElementAvoidStones(zodiac.Element e) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.element_avoid_stones.${e.name}', language);
  }
  String _getElementChakraBalance(zodiac.Element e) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.element_chakra_balance.${e.name}', language);
  }

  // Burç bazlı yardımcı fonksiyonlar
  String _getSignSubconscious(zodiac.ZodiacSign s) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.sign_subconscious.${s.name}', language);
  }
  String _getSignDreamSymbols(zodiac.ZodiacSign s) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.sign_dream_symbols.${s.name}', language);
  }
  String _getSignHerb(zodiac.ZodiacSign s) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.sign_herb.${s.name}', language);
  }
  String _getSignMeditation(zodiac.ZodiacSign s) {
    final language = ref.read(languageProvider);
    final signName = language == AppLanguage.tr ? s.nameTr : s.name;
    return L10nService.getWithParams('kozmoz.sign_meditation', language, params: {'sign': signName});
  }
  String _getSignChakra(zodiac.ZodiacSign s) {
    final language = ref.read(languageProvider);
    final elementName = language == AppLanguage.tr ? s.element.nameTr : s.element.name;
    return L10nService.getWithParams('kozmoz.sign_chakra', language, params: {'element': elementName});
  }
  String _getSignHerbs(zodiac.ZodiacSign s) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.sign_herbs.${s.name}', language);
  }
  String _getSignDestinations(zodiac.ZodiacSign s) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.sign_destinations.${s.name}', language);
  }
  String _getSignCreativity(zodiac.ZodiacSign s) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.sign_creativity.${s.name}', language);
  }
  String _getSignSubjects(zodiac.ZodiacSign s) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.sign_subjects.${s.name}', language);
  }
  String _getSignShadow(zodiac.ZodiacSign s) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.sign_shadow.${s.name}', language);
  }
  String _getSignFears(zodiac.ZodiacSign s) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.sign_fears.${s.name}', language);
  }
  String _getOppositeSign(zodiac.ZodiacSign s) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.opposite_sign.${s.name}', language);
  }
  String _getSignAngel(zodiac.ZodiacSign s) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.sign_angel.${s.name}', language);
  }
  String _getSignConstellation(zodiac.ZodiacSign s) {
    final language = ref.read(languageProvider);
    final signName = language == AppLanguage.tr ? s.nameTr : s.name;
    return L10nService.getWithParams('kozmoz.sign_constellation', language, params: {'sign': signName});
  }
  String _getSignMainStones(zodiac.ZodiacSign s) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.sign_main_stones.${s.name}', language);
  }
  String _getHealthWeakness(zodiac.ZodiacSign s) {
    final language = ref.read(languageProvider);
    return L10nService.get('kozmoz.health_weakness.${s.name}', language);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ═══════════════════════════════════════════════════════════════
  // UI BUILD METHODLARı
  // ═══════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(child: _buildChatArea()),
              if (_messages.length <= 1) _buildSuggestedQuestions(),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.nebulaPurple.withValues(alpha: 0.5),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 8),
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF9D4EDD).withValues(alpha: 0.5 + _pulseController.value * 0.3),
                      AppColors.nebulaPurple.withValues(alpha: 0.3),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9D4EDD).withValues(alpha: 0.4 * _pulseController.value),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Text('🌌', style: TextStyle(fontSize: 24)),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFF6B9D), Color(0xFF9D4EDD)],
                  ).createShader(bounds),
                  child: Text(
                    L10nService.get('kozmoz.header_title', ref.read(languageProvider)),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  L10nService.get('kozmoz.header_subtitle', ref.read(languageProvider)),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showFeaturesSheet(context),
            icon: const Icon(Icons.apps_rounded, color: AppColors.starGold),
            tooltip: L10nService.get('kozmoz.all_analyses', ref.read(languageProvider)),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildChatArea() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length && _isTyping) {
          return _buildTypingIndicator();
        }
        return _buildMessageBubble(_messages[index], index);
      },
    );
  }

  Widget _buildMessageBubble(_ChatMessage message, int index) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF9D4EDD).withValues(alpha: 0.5),
                    AppColors.nebulaPurple.withValues(alpha: 0.3),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Text('🌌', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isUser
                      ? [
                          AppColors.cosmicPurple.withValues(alpha: 0.4),
                          AppColors.nebulaPurple.withValues(alpha: 0.3),
                        ]
                      : [
                          const Color(0xFF9D4EDD).withValues(alpha: 0.2),
                          const Color(0xFF1A1A2E).withValues(alpha: 0.8),
                        ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                border: Border.all(
                  color: isUser
                      ? AppColors.cosmicPurple.withValues(alpha: 0.3)
                      : const Color(0xFF9D4EDD).withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Text(
                message.text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(
          begin: isUser ? 0.2 : -0.2,
          end: 0,
          duration: 300.ms,
        );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF9D4EDD).withValues(alpha: 0.5),
                  AppColors.nebulaPurple.withValues(alpha: 0.3),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Text('🌌', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF9D4EDD).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF9D4EDD).withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: const Text('✨', style: TextStyle(fontSize: 14)),
                )
                    .animate(onComplete: (c) => c.repeat())
                    .fadeIn(duration: 400.ms, delay: (200 * index).ms)
                    .then()
                    .fadeOut(duration: 400.ms, delay: 400.ms);
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedQuestions() {
    final language = ref.read(languageProvider);
    final localizedQuestions = _getLocalizedQuestions(language);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💡 ${L10nService.get('kozmoz.suggested_questions', language)}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: localizedQuestions.length,
              itemBuilder: (context, index) {
                final q = localizedQuestions[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => _sendMessage(q['text']),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 160,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF9D4EDD).withValues(alpha: 0.2),
                            AppColors.cosmicPurple.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF9D4EDD).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(q['emoji'], style: const TextStyle(fontSize: 20)),
                          const SizedBox(height: 6),
                          Expanded(
                            child: Text(
                              q['text'],
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppColors.nebulaPurple.withValues(alpha: 0.5),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF9D4EDD).withValues(alpha: 0.15),
                    const Color(0xFF1A1A2E).withValues(alpha: 0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF9D4EDD).withValues(alpha: 0.3)),
              ),
              child: RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (event) {
                  if (event.isKeyPressed(LogicalKeyboardKey.enter) &&
                      !event.isShiftPressed) {
                    _sendMessage();
                  }
                },
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  maxLines: 5,
                  minLines: 1,
                  textInputAction: TextInputAction.send,
                  decoration: InputDecoration(
                    hintText: L10nService.get('kozmoz.ask_placeholder', ref.read(languageProvider)),
                    hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.6)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _sendMessage(),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9D4EDD), Color(0xFFFF6B9D)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9D4EDD).withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
            ),
          )
              .animate(onComplete: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 1500.ms),
        ],
      ),
    );
  }

  void _showFeaturesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _FeaturesSheet(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CHAT MESSAGE MODEL
// ═══════════════════════════════════════════════════════════════

class _ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  _ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

// ═══════════════════════════════════════════════════════════════
// FEATURES SHEET - Tüm özelliklere hızlı erişim
// ═══════════════════════════════════════════════════════════════

class _FeaturesSheet extends ConsumerWidget {
  final List<Map<String, dynamic>> _features = [
    {'emoji': '⭐', 'nameKey': 'kozmoz.features.zodiac_readings', 'route': Routes.horoscope},
    {'emoji': '🗺️', 'nameKey': 'kozmoz.features.birth_chart', 'route': Routes.birthChart},
    {'emoji': '💕', 'nameKey': 'kozmoz.features.zodiac_compatibility', 'route': Routes.compatibility},
    {'emoji': '🪐', 'nameKey': 'kozmoz.features.transits', 'route': Routes.transits},
    {'emoji': '🔢', 'nameKey': 'kozmoz.features.numerology', 'route': Routes.numerology},
    {'emoji': '🎴', 'nameKey': 'kozmoz.features.tarot', 'route': Routes.tarot},
    {'emoji': '🌙', 'nameKey': 'kozmoz.features.dream_trace', 'route': Routes.dreamInterpretation},
    {'emoji': '✨', 'nameKey': 'kozmoz.features.aura_analysis', 'route': Routes.aura},
    {'emoji': '🔮', 'nameKey': 'kozmoz.features.chakra_analysis', 'route': Routes.chakraAnalysis},
    {'emoji': '📅', 'nameKey': 'kozmoz.features.timing', 'route': Routes.timing},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.nebulaPurple, const Color(0xFF0D0D1A)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text('🚀', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Text(
                  L10nService.get('kozmoz.quick_access', language),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _features.length,
              itemBuilder: (context, index) {
                final feature = _features[index];
                return InkWell(
                  onTap: () {
                    context.pop();
                    context.push(feature['route']);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF9D4EDD).withValues(alpha: 0.2),
                          AppColors.cosmicPurple.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF9D4EDD).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(feature['emoji'], style: const TextStyle(fontSize: 28)),
                        const SizedBox(height: 8),
                        Text(
                          L10nService.get(feature['nameKey'], language),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
