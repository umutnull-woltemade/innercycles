import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/zodiac_sign.dart';
import '../content/cosmic_messages_content.dart';
import '../providers/app_providers.dart';
import 'analytics_service.dart';
import 'content_safety_filter.dart';
import 'l10n_service.dart';

/// AI-powered content generation service
/// Supports OpenAI, Anthropic, or falls back to local generation
class AiContentService {
  static const String _openAiBaseUrl = 'https://api.openai.com/v1';
  static const String _anthropicBaseUrl = 'https://api.anthropic.com/v1';

  // API keys - loaded from secure storage or environment
  String? _openAiApiKey;
  String? _anthropicApiKey;

  // Analytics
  AnalyticsService? _analytics;

  // Cache for generated content
  final Map<String, _CachedContent> _cache = {};
  static const Duration _cacheDuration = Duration(hours: 1);

  // Singleton pattern
  static final AiContentService _instance = AiContentService._internal();
  factory AiContentService() => _instance;
  AiContentService._internal();

  /// Initialize with API keys from secure storage
  Future<void> initialize({AnalyticsService? analytics}) async {
    _analytics = analytics;

    try {
      final prefs = await SharedPreferences.getInstance();
      _openAiApiKey = prefs.getString('openai_api_key');
      _anthropicApiKey = prefs.getString('anthropic_api_key');

      // You can also load from environment in debug mode
      // _openAiApiKey ??= const String.fromEnvironment('OPENAI_API_KEY');
      // _anthropicApiKey ??= const String.fromEnvironment('ANTHROPIC_API_KEY');

      if (kDebugMode) {
        debugPrint(
          'AiContentService: Initialized (AI available: $isAiAvailable)',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('AiContentService: Initialization error - $e');
      }
    }
  }

  /// Set API keys programmatically (for settings screen)
  Future<void> setApiKeys({String? openAiKey, String? anthropicKey}) async {
    _openAiApiKey = openAiKey;
    _anthropicApiKey = anthropicKey;

    final prefs = await SharedPreferences.getInstance();
    if (openAiKey != null) {
      await prefs.setString('openai_api_key', openAiKey);
    } else {
      await prefs.remove('openai_api_key');
    }

    if (anthropicKey != null) {
      await prefs.setString('anthropic_api_key', anthropicKey);
    } else {
      await prefs.remove('anthropic_api_key');
    }
  }

  /// Check if AI is available
  bool get isAiAvailable =>
      (_openAiApiKey?.isNotEmpty ?? false) ||
      (_anthropicApiKey?.isNotEmpty ?? false);

  /// Generate personalized daily reflection
  Future<PersonalizedHoroscope> generatePersonalizedHoroscope({
    required ZodiacSign sunSign,
    ZodiacSign? moonSign,
    ZodiacSign? risingSign,
    DateTime? birthDate,
    String? currentMoonPhase,
  }) async {
    final cacheKey = 'reflection_${sunSign.name}_${DateTime.now().day}';

    // Check cache first
    if (_cache.containsKey(cacheKey) && !_cache[cacheKey]!.isExpired) {
      return _cache[cacheKey]!.content as PersonalizedHoroscope;
    }

    // Try AI generation first
    if (isAiAvailable) {
      try {
        final prompt = _buildReflectionPrompt(
          sunSign: sunSign,
          moonSign: moonSign,
          risingSign: risingSign,
          birthDate: birthDate,
          currentMoonPhase: currentMoonPhase,
        );

        final response = await _generateWithAi(prompt);
        if (response != null) {
          final reflection = _parseReflectionResponse(response, sunSign);
          _cache[cacheKey] = _CachedContent(reflection);
          _analytics?.logEvent('ai_reflection_generated', {
            'sign': sunSign.name,
          });
          return reflection;
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('AiContentService: AI generation failed - $e');
        }
        _analytics?.logError('ai_generation', e.toString());
      }
    }

    // Fallback to local generation
    final localReflection = _generateLocalReflection(
      sunSign: sunSign,
      moonSign: moonSign,
      risingSign: risingSign,
    );
    _cache[cacheKey] = _CachedContent(localReflection);
    return localReflection;
  }

  /// Generate personalized inner message
  Future<String> generateCosmicMessage({
    required ZodiacSign sign,
    String? userName,
    String? mood,
    AppLanguage language = AppLanguage.en,
  }) async {
    if (isAiAvailable && userName != null) {
      try {
        final prompt = _buildInnerMessagePrompt(
          sign,
          userName,
          mood,
          language,
        );

        final response = await _generateWithAi(prompt);
        if (response != null && response.isNotEmpty) {
          _analytics?.logEvent('ai_inner_message_generated', {
            'sign': sign.name,
          });
          return response;
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('AiContentService: Inner message generation failed - $e');
        }
      }
    }

    return CosmicMessagesContent.getDailyCosmicMessage(DateTime.now());
  }

  String _buildInnerMessagePrompt(
    ZodiacSign sign,
    String userName,
    String? mood,
    AppLanguage language,
  ) {
    switch (language) {
      case AppLanguage.tr:
        return '''
Kullanıcı için kısa, ilham verici bir iç ses mesajı yaz.
Isim: $userName
Kişilik tipi: ${sign.nameTr}
${mood != null ? 'Ruh hali: $mood' : ''}

Mesaj 2-3 cümle olsun, destekleyici ve motive edici bir tonda yaz.
Turkce yaz, emoji kullanma.
''';
      case AppLanguage.de:
        return '''
Write a short, inspiring inner wellness message for the user.
Name: $userName
Personality type: ${sign.name}
${mood != null ? 'Mood: $mood' : ''}

Message should be 2-3 sentences, written in a warm and motivating tone.
Write in German, no emojis.
''';
      case AppLanguage.fr:
        return '''
Write a short, inspiring inner wellness message for the user.
Name: $userName
Personality type: ${sign.name}
${mood != null ? 'Mood: $mood' : ''}

Message should be 2-3 sentences, written in a warm and motivating tone.
Write in French, no emojis.
''';
      case AppLanguage.en:
      default:
        return '''
Write a short, inspiring inner wellness message for the user.
Name: $userName
Personality type: ${sign.name}
${mood != null ? 'Mood: $mood' : ''}

Message should be 2-3 sentences, written in a warm and motivating tone.
Write in English, no emojis.
''';
    }
  }

  /// Generate personalized advice for specific area
  Future<String> generatePersonalizedAdvice({
    required ZodiacSign sign,
    required AdviceArea area,
    String? context,
    AppLanguage language = AppLanguage.en,
  }) async {
    if (isAiAvailable) {
      try {
        final prompt = _buildAdvicePrompt(sign, area, context, language);

        final response = await _generateWithAi(prompt);
        if (response != null && response.isNotEmpty) {
          _analytics?.logEvent('ai_advice_generated', {
            'sign': sign.name,
            'area': area.name,
          });
          return response;
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('AiContentService: Advice generation failed - $e');
        }
      }
    }

    return _getLocalAdvice(sign, area);
  }

  String _buildAdvicePrompt(
    ZodiacSign sign,
    AdviceArea area,
    String? context,
    AppLanguage language,
  ) {
    final areaName = _getAreaName(area, language);
    final signName = language == AppLanguage.tr ? sign.nameTr : sign.name;

    switch (language) {
      case AppLanguage.tr:
        return '''
$signName kişilik tipi için $areaName konusunda kısa bir tavsiye yaz.
${context != null ? 'Bağlam: $context' : ''}

2-3 cümle olsun, pozitif ve destekleyici bir tonda.
Türkçe yaz, kişisel gelişim kavramlarını basit tut.
''';
      case AppLanguage.de:
        return '''
Write short advice for $signName personality type about $areaName.
${context != null ? 'Context: $context' : ''}

2-3 sentences, positive and supportive tone.
Write in German, keep personal growth terms simple.
''';
      case AppLanguage.fr:
        return '''
Write short advice for $signName personality type about $areaName.
${context != null ? 'Context: $context' : ''}

2-3 sentences, positive and supportive tone.
Write in French, keep personal growth terms simple.
''';
      case AppLanguage.en:
      default:
        return '''
Write short advice for $signName personality type about $areaName.
${context != null ? 'Context: $context' : ''}

2-3 sentences, positive and supportive tone.
Write in English, keep personal growth terms simple.
''';
    }
  }

  /// Generate daily affirmation
  Future<String> generateAffirmation({
    required ZodiacSign sign,
    String? focus,
    AppLanguage language = AppLanguage.en,
  }) async {
    if (isAiAvailable) {
      try {
        final prompt = _buildAffirmationPrompt(sign, focus, language);

        final response = await _generateWithAi(prompt);
        if (response != null && response.isNotEmpty) {
          return response;
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('AiContentService: Affirmation generation failed - $e');
        }
      }
    }

    return CosmicMessagesContent.getMorningAffirmation(DateTime.now());
  }

  String _buildAffirmationPrompt(
    ZodiacSign sign,
    String? focus,
    AppLanguage language,
  ) {
    final signName = language == AppLanguage.tr ? sign.nameTr : sign.name;

    switch (language) {
      case AppLanguage.tr:
        return '''
$signName kişilik tipi için güçlü bir günlük olumlama yaz.
${focus != null ? 'Odak: $focus' : ''}

"Bugün..." ile başlasın, kısa ve güçlü olsun (1 cümle).
Türkçe yaz.
''';
      case AppLanguage.de:
        return '''
Write a powerful daily affirmation for $signName personality type.
${focus != null ? 'Focus: $focus' : ''}

Start with "Today...", keep it short and powerful (1 sentence).
Write in German.
''';
      case AppLanguage.fr:
        return '''
Write a powerful daily affirmation for $signName personality type.
${focus != null ? 'Focus: $focus' : ''}

Start with "Aujourd'hui...", keep it short and powerful (1 sentence).
Write in French.
''';
      case AppLanguage.en:
      default:
        return '''
Write a powerful daily affirmation for $signName personality type.
${focus != null ? 'Focus: $focus' : ''}

Start with "Today...", keep it short and powerful (1 sentence).
Write in English.
''';
    }
  }

  /// Clear cached content
  void clearCache() {
    _cache.clear();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DREAM INTERPRETATION - APEX DREAM INTELLIGENCE ENGINE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Start dream interpretation session - Step 1: Acknowledge symbol
  Future<DreamInterpretationSession> startDreamInterpretation({
    required String dreamDescription,
    ZodiacSign? userSign,
  }) async {
    // Extract main symbol from dream
    final symbol = _extractDreamSymbol(dreamDescription);

    // Generate context questions based on symbol
    final questions = _generateContextQuestions(symbol, dreamDescription);

    // Create session
    final session = DreamInterpretationSession(
      dreamSymbol: symbol,
      contextQuestions: questions,
      state: DreamConversationState.awaitingContext,
    );

    _analytics?.logEvent('dream_interpretation_started', {
      'symbol': symbol,
      'has_sign': userSign != null ? 'true' : 'false',
    });

    return session;
  }

  /// Get acknowledgment message for the dream symbol
  String getDreamAcknowledgment(String symbol) {
    final acknowledgments =
        _dreamSymbolAcknowledgments[symbol.toLowerCase()] ??
        'Bu sembol rüyalarında önemli bir mesaj taşıyor olabilir.';
    return acknowledgments;
  }

  /// Interpret dream with context - Step 3 & 4: Conditional interpretation
  Future<DreamInterpretationSession> interpretDream({
    required DreamInterpretationSession session,
    required Map<String, String> contextAnswers,
    ZodiacSign? userSign,
  }) async {
    // Update session with answers
    var updatedSession = session.copyWith(contextAnswers: contextAnswers);

    String interpretation;

    if (isAiAvailable) {
      try {
        final prompt = _buildDreamInterpretationPrompt(
          symbol: session.dreamSymbol,
          contextAnswers: contextAnswers,
          userSign: userSign,
        );

        final response = await _generateWithAi(prompt);
        if (response != null && response.isNotEmpty) {
          // APEX FAIL CONDITION CHECK - Validate AI response
          if (_validateDreamInterpretation(response)) {
            interpretation = response;
            _analytics?.logEvent('dream_ai_interpreted', {
              'symbol': session.dreamSymbol,
              'has_sign': userSign != null ? 'true' : 'false',
            });
          } else {
            // AI response failed validation, use local fallback
            if (kDebugMode) {
              debugPrint(
                'Dream interpretation AI response failed APEX validation',
              );
            }
            interpretation = _generateLocalDreamInterpretation(
              symbol: session.dreamSymbol,
              contextAnswers: contextAnswers,
              userSign: userSign,
            );
            _analytics?.logEvent('dream_ai_validation_failed', {
              'symbol': session.dreamSymbol,
            });
          }
        } else {
          interpretation = _generateLocalDreamInterpretation(
            symbol: session.dreamSymbol,
            contextAnswers: contextAnswers,
            userSign: userSign,
          );
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Dream interpretation AI failed: $e');
        }
        interpretation = _generateLocalDreamInterpretation(
          symbol: session.dreamSymbol,
          contextAnswers: contextAnswers,
          userSign: userSign,
        );
      }
    } else {
      interpretation = _generateLocalDreamInterpretation(
        symbol: session.dreamSymbol,
        contextAnswers: contextAnswers,
        userSign: userSign,
      );
    }

    return updatedSession.copyWith(
      interpretation: interpretation,
      state: DreamConversationState.interpreted,
    );
  }

  /// APEX FAIL CONDITIONS - Validate dream interpretation
  /// Returns false if interpretation violates core APEX rules
  bool _validateDreamInterpretation(String interpretation) {
    return _validateInsightResponse(interpretation);
  }

  /// UNIFIED INSIGHT VALIDATION - Apple-Safe Response Validation
  /// Used for both dream interpretations and general insight responses
  /// Returns false if response violates App Store guidelines
  bool _validateInsightResponse(String response) {
    final lowerResponse = response.toLowerCase();
    final firstParagraph = response.split('\n').first.toLowerCase();

    // FAIL CONDITION 1: Starts with forbidden archetype/wellness terms (TR + EN)
    final forbiddenStarters = [
      // Turkish
      'burc',
      'burç',
      'koc',
      'koç',
      'boga',
      'boğa',
      'ikizler',
      'yengec',
      'yengeç',
      'aslan', 'basak', 'başak', 'terazi', 'akrep', 'yay', 'oglak', 'oğlak',
      'kova', 'balik', 'balık', 'astroloji', 'zodyak', 'gezegen',
      // English
      'aries', 'taurus', 'gemini', 'cancer', 'leo', 'virgo', 'libra',
      'scorpio', 'sagittarius', 'capricorn', 'aquarius', 'pisces',
      'zodiac', 'horoscope', 'astrology', 'astrological', 'natal chart', 'birth chart',
      // Planets (both)
      'mars', 'venus', 'merkur', 'merkür', 'mercury', 'jupiter', 'saturn',
      'satürn', 'neptun', 'neptün', 'neptune', 'uranüs', 'uranus',
      'pluto', 'pluton',
    ];

    for (final starter in forbiddenStarters) {
      if (firstParagraph.contains(starter)) {
        if (kDebugMode) {
          debugPrint(
            'INSIGHT FAIL: Response starts with forbidden term: $starter',
          );
        }
        return false;
      }
    }

    // FAIL CONDITION 2: Contains fortune-telling/prediction phrases (TR + EN)
    final forbiddenPhrases = [
      // Turkish prediction phrases
      'bugünün enerjisi', 'günün enerjisi', 'yıldızlar sana', 'yıldızlar sana',
      'kozmik enerji', 'evren sana', 'gezegenlerin etkileri',
      'astrolojik acidan', 'astrolojik açıdan', 'kaderin', 'kaderiniz',
      'gelecekte', 'geleceginde', 'geleceğinde', 'olacak', 'olacaktır',
      'kehanet', 'fal', 'tarot', 'numeroloji',
      // English prediction phrases
      'your destiny', 'the stars say', 'the universe is telling',
      'will happen', 'is destined', 'fate reveals', 'fortune tells',
      'cosmic energy', 'planetary influence', 'mercury retrograde',
      'the cards reveal', 'your horoscope', 'zodiac reading',
      'according to the stars', 'the planets indicate',
      'you are destined', 'prophecy', 'divination',
      'natal chart', 'birth chart', 'fortune-telling',
    ];

    for (final phrase in forbiddenPhrases) {
      if (lowerResponse.contains(phrase)) {
        if (kDebugMode) {
          debugPrint('INSIGHT FAIL: Contains forbidden phrase: $phrase');
        }
        return false;
      }
    }

    // FAIL CONDITION 3: Contains definitive/certain language (should use possibility language)
    final certaintyPhrases = [
      // Turkish
      'kesinlikle', 'mutlaka', 'su anlama gelir', 'şu anlama gelir',
      'demek ki', 'olmali', 'olmalı', 'yapman gerekir', 'yapmalısın',
      // English
      'definitely will', 'certainly going to', 'guaranteed to',
      'this means you will', 'you must', 'you need to',
      'without doubt', 'absolutely will',
    ];

    int certaintyCount = 0;
    for (final phrase in certaintyPhrases) {
      if (lowerResponse.contains(phrase)) {
        certaintyCount++;
      }
    }
    // Allow max 1 certainty phrase
    if (certaintyCount > 1) {
      if (kDebugMode) {
        debugPrint(
          'INSIGHT FAIL: Too much certainty language ($certaintyCount instances)',
        );
      }
      return false;
    }

    // FAIL CONDITION 4: Too short (less than 200 characters = likely generic)
    if (response.length < 200) {
      if (kDebugMode) {
        debugPrint(
          'INSIGHT FAIL: Response too short (${response.length} chars)',
        );
      }
      return false;
    }

    // FAIL CONDITION 5: Contains direct commands (should be reflective)
    final commandPhrases = [
      // Turkish
      'sunu yap', 'şunu yap', 'bunu yap', 'yapmalisin', 'yapmalısın',
      'git ve', 'hemen', 'derhal',
      // English
      'you should do', 'go and', 'immediately', 'right now',
      'do this', 'you have to',
    ];

    for (final phrase in commandPhrases) {
      if (lowerResponse.contains(phrase)) {
        if (kDebugMode) {
          debugPrint('INSIGHT FAIL: Contains direct command: $phrase');
        }
        return false;
      }
    }

    // PASS: Response is safe for App Store
    return true;
  }

  /// Sanitize AI response using ContentSafetyFilter.
  /// This is a secondary filter that catches edge cases and
  /// replaces any remaining risky phrases with safe alternatives.
  String _sanitizeResponse(String response) {
    // First check if content needs filtering
    if (ContentSafetyFilter.containsForbiddenContent(response)) {
      if (kDebugMode) {
        debugPrint('AI_SANITIZE: Filtering forbidden content from response');
      }
      return ContentSafetyFilter.validateAndFilter(
        response,
        context: 'AI_RESPONSE',
      );
    }
    return response;
  }

  /// Extract main symbol from dream description
  String _extractDreamSymbol(String dreamDescription) {
    final lowerDesc = dreamDescription.toLowerCase();

    // Common dream symbols in Turkish
    final symbols = {
      'yılan': ['yılan', 'yılan', 'kobra', 'boa', 'engerek'],
      'su': [
        'su',
        'deniz',
        'okyanus',
        'göl',
        'gol',
        'nehir',
        'irmak',
        'sel',
        'bogulma',
        'boğulma',
      ],
      'ucmak': [
        'ucmak',
        'uçmak',
        'ucuyorum',
        'uçuyorum',
        'havada',
        'gokyuzu',
        'gökyüzü',
      ],
      'dusmek': [
        'dusmek',
        'düşmek',
        'dusuyorum',
        'düşüyorum',
        'yüksekten',
        'yüksekten',
      ],
      'dis': [
        'dis',
        'diş',
        'disler',
        'dişler',
        'dis dokulmesi',
        'diş dökülmesi',
      ],
      'olum': [
        'olum',
        'ölüm',
        'olu',
        'ölü',
        'cenaze',
        'mezar',
        'oluyorum',
        'ölüyorum',
      ],
      'kovalanmak': [
        'kovalanmak',
        'kovaliyor',
        'kovalıyor',
        'kaciyorum',
        'kaçıyorum',
        'kacmak',
        'kaçmak',
      ],
      'bebek': ['bebek', 'cocuk', 'çocuk', 'hamile', 'dogum', 'doğum'],
      'ev': ['ev', 'oda', 'bina', 'apartman', 'kapi', 'kapı', 'pencere'],
      'araba': ['araba', 'arac', 'araç', 'surmek', 'sürmek', 'kaza', 'trafik'],
      'kopek': [
        'kopek',
        'köpek',
        'it',
        'havliyor',
        'havlıyor',
        'isiriyor',
        'ısırıyor',
      ],
      'kedi': ['kedi', 'miyavliyor', 'miyavlıyor', 'tirmaladi', 'tırmaladı'],
      'para': ['para', 'altin', 'altın', 'zenginlik', 'piyango', 'bulmak'],
      'sinav': [
        'sinav',
        'sınav',
        'okul',
        'test',
        'başarısizlik',
        'başarısızlık',
      ],
      'ciplaklık': ['ciplak', 'çıplak', 'utanc', 'utanç', 'mahcup'],
      'kaybolmak': [
        'kaybolmak',
        'kayip',
        'kayıp',
        'bulamiyorum',
        'bulamıyorum',
        'yolumu',
      ],
      'ates': [
        'ates',
        'ateş',
        'yangin',
        'yangın',
        'alev',
        'yaniyor',
        'yanıyor',
      ],
      'kan': ['kan', 'kanama', 'yarali', 'yaralı', 'yara'],
      'gelin': ['gelin', 'dugun', 'düğün', 'evlilik', 'nikah'],
      'hastalik': ['hasta', 'hastalik', 'hastalık', 'doktor', 'hastane'],
    };

    for (final entry in symbols.entries) {
      for (final keyword in entry.value) {
        if (lowerDesc.contains(keyword)) {
          return entry.key;
        }
      }
    }

    // If no specific symbol found, return generic
    return 'genel';
  }

  /// Generate context questions based on dream symbol
  List<String> _generateContextQuestions(
    String symbol,
    String dreamDescription,
  ) {
    final questions =
        _dreamContextQuestions[symbol] ??
        [
          'Rüyada nasıl bir duygu hissettin?',
          'Ortam nasıl görünüyordu?',
          'Rüyada baska kimler vardi?',
        ];

    // Return max 3 questions
    return questions.take(3).toList();
  }

  /// Build AI prompt for dream interpretation - APEX MASTER STRUCTURE
  String _buildDreamInterpretationPrompt({
    required String symbol,
    required Map<String, String> contextAnswers,
    ZodiacSign? userSign,
  }) {
    final contextText = contextAnswers.entries
        .map((e) => '- ${e.key}\n  Cevap: ${e.value}')
        .join('\n\n');

    return '''
ROL: Elite Dream Intelligence Architect ve Symbolic Psychologist.

YAPMA:
- Burc/yildiz yorumu ile BASLAMAK
- Bagnam olmadan yorum yapmak
- Tavsiye veya ongoruler vermek
- Rüya sozlukleri veya kliseler kullanmak
- Mistik veya genel gececer seyler soylemek
- Kesin ifadeler kullanmak

YAP:
- Sembollerden basla
- Kosullu (EGER/OLABILIR/ISARET EDEBILIR) yorumla
- Rüyaciyi merkeze al
- Süreçsel yaklaşım benimse (mesaj değil, sürec)

RUYA SEMBOLU: $symbol

KULLANICIDAN ALINAN BAĞLAM:
$contextText

═══════════════════════════════════════════════════════════════
ZORUNLU 8 BÖLÜMLÜ YORUM YAPISI (Bu sırayla yaz):
═══════════════════════════════════════════════════════════════

1) RÜYA YENİDEN OLUŞTURMA
   - Rüyayı tarafsız ve doğru bir şekilde özetle (1-2 cümle)

2) DUYGUSAL AĞIRLIK MERKEZİ
   - Duygusal ağırlığın nerede yoğunlaştığını belirt
   - Örneğin: "Rüyada en yoğun nokta... gibi görünüyor"

3) SEMBOL DİNAMİKLERİ
   - Sembollerin nasıl etkileştiğini analiz et
   - Hareket, gerilim, yakınlık

4) RÜYACI POZİSYONU
   - Gözlemci / katılımcı / kaçan / yüzleşen
   - "Rüyada sen... pozisyonundaydın"

5) ÖRÜNTÜ VE ZAMANLAMA
   - Bu rüya: başlangıç / geçiş / çözümsüz mü?
   - Tek başına mı yoksa seri içinde mi?

6) YAŞAM-DÜNYA REZONANSI
   - Uyanık hayattaki olası yansımalar (sadece hipotez)
   - "Bu rüya, gerçek hayatında... ile rezonans yapıyor olabilir"

7) ENTEGRASYON ODAĞI
   - Rüyanın rüyacıdan FARK ETMESİNİ istediği şey
   - "Bu rüya senden... fark etmeni istiyor olabilir"

8) YANSITICI SORULAR (maksimum 3)
   - Rüyacıyı düşünmeye davet eden sorular
   - Tavsiye değil, soru formunda

═══════════════════════════════════════════════════════════════

${userSign != null ? '''
KİŞİLİK NOTU (SADECE EN SONDA, OPSİYONEL):
Kullanıcının kişilik tipi: ${userSign.nameTr}
- Kişilik tipi sadece RENK KATAR, anlam vermez
- Yorum ZATEN tamamlandıktan sonra, eğer istersen kısa bir not ekle
- Format: "Eğer istersen, ${userSign.nameTr} enerjisi açısından bu rüya... olarak da okunabilir."
''' : ''}

CIKTI KURALLARI:
- Dogal Turkce
- Sakin, topraklanmis, insan tonu
- Olasılık dili (olabilir, çağrıştırabilir, işaret edebilir)
- Kisa paragraflar
- Emoji YOK
- Mistik klise YOK
- Her rüyaya uyan genel yorum YOK
''';
  }

  /// Generate local dream interpretation (fallback) - APEX 8-PART MASTER STRUCTURE
  String _generateLocalDreamInterpretation({
    required String symbol,
    required Map<String, String> contextAnswers,
    ZodiacSign? userSign,
  }) {
    final interpretations = _localDreamInterpretations[symbol];
    if (interpretations == null) {
      return _getGenericDreamInterpretation(contextAnswers, userSign);
    }

    final buffer = StringBuffer();

    // Analyze context answers for conditional interpretation
    final allAnswers = contextAnswers.values.join(' ').toLowerCase();
    final emotionType = _detectEmotionType(allAnswers);
    final positionType = _detectDreamerPosition(allAnswers);

    // 1) RUYA YENIDEN OLUSTURMA
    buffer.writeln('RÜYANIN ÖZETİ');
    buffer.writeln(
      interpretations['reconstruction'] ??
          'Bu rüyada $symbol sembolü merkezi bir rol oynuyor.',
    );
    buffer.writeln();

    // 2) DUYGUSAL AGIRLIK MERKEZI
    buffer.writeln('DUYGUSAL AGIRLIK');
    if (emotionType == 'fearful') {
      buffer.writeln(
        interpretations['emotionalCenter_fear'] ??
            'Rüyada duygusal ağırlık korku veya gerilim etrfinda toplanmış görünüyor.',
      );
    } else if (emotionType == 'peaceful') {
      buffer.writeln(
        interpretations['emotionalCenter_peace'] ??
            'Rüyada duygusal ağırlık huzur ve kabul etrafında toplanmış görünüyor.',
      );
    } else if (emotionType == 'curious') {
      buffer.writeln(
        interpretations['emotionalCenter_curiosity'] ??
            'Rüyada duygusal ağırlık merak ve kesif etrafında toplanmış görünüyor.',
      );
    } else {
      buffer.writeln(
        interpretations['emotionalCenter_neutral'] ??
            'Rüyada duygusal ton belirsiz veya karışık görünüyor.',
      );
    }
    buffer.writeln();

    // 3) SEMBOL DINAMIKLERI
    buffer.writeln('SEMBOL DINAMIGI');
    buffer.writeln(
      interpretations['symbolDynamics'] ??
          'Bu sembol, iç dünya ile dış dünya arasındaki bir dinamiği temsil ediyor olabilir.',
    );
    buffer.writeln();

    // 4) RUYACI POZISYONU
    buffer.writeln('SENIN POZISYONUN');
    if (positionType == 'observer') {
      buffer.writeln(
        interpretations['position_observer'] ??
            'Rüyada gözlemci pozisyonundaydin - olayları dışarıdan izliyordun.',
      );
    } else if (positionType == 'participant') {
      buffer.writeln(
        interpretations['position_participant'] ??
            'Rüyada aktif katılımcı pozisyonundaydin - olaylara dahildin.',
      );
    } else if (positionType == 'escaping') {
      buffer.writeln(
        interpretations['position_escaping'] ??
            'Rüyada kacan pozisyonundaydin - bir şeyden uzaklasiyordun.',
      );
    } else if (positionType == 'confronting') {
      buffer.writeln(
        interpretations['position_confronting'] ??
            'Rüyada yüzleşen pozisyonundaydin - bir seyle karsi karsiyaydin.',
      );
    } else {
      buffer.writeln(
        interpretations['position_neutral'] ??
            'Rüyada pozisyonun belirsiz veya degisen bir yapida.',
      );
    }
    buffer.writeln();

    // 5) ORUNTU VE ZAMANLAMA
    buffer.writeln('ORUNTU VE ZAMANLAMA');
    buffer.writeln(
      interpretations['timing'] ??
          'Bu rüya, bir geçiş dönemini veya işlenmekte olan bir sureci yansıtıyor olabilir.',
    );
    buffer.writeln();

    // 6) YASAM-DUNYA REZONANSI (Conditional)
    buffer.writeln('OLASI YASAM YANSIMASI');
    if (emotionType == 'fearful') {
      buffer.writeln(
        interpretations['lifeResonance_fear'] ??
            'Bu rüya, gerçek hayatında kontrol kaybı veya belirsizlikle ilgili bir durumla rezonans yapıyor olabilir.',
      );
    } else if (emotionType == 'peaceful') {
      buffer.writeln(
        interpretations['lifeResonance_peace'] ??
            'Bu rüya, hayatında bir kabul veya bırakma sureciyle rezonans yapıyor olabilir.',
      );
    } else {
      buffer.writeln(
        interpretations['lifeResonance_neutral'] ??
            'Bu rüya, hayatında dikkat bekleyen bir alanla rezonans yapıyor olabilir.',
      );
    }
    buffer.writeln();

    // 7) ENTEGRASYON ODAGI
    buffer.writeln('ENTEGRASYON ODAGI');
    buffer.writeln(
      interpretations['integration'] ??
          'Bu rüya, senden bir şeyi fark etmeni veya kabul etmeni istiyor olabilir.',
    );
    buffer.writeln();

    // 8) YANSITICI SORULAR
    buffer.writeln('YANSITICI SORULAR');
    final questions =
        interpretations['questions']?.split('|') ??
        [
          'Bu sembol senin için kişisel olarak ne ifade ediyor?',
          'Son zamanlarda benzer duygular yaşadığın bir durum var mi?',
          'Rüyadaki bu enerjiyi nerede hissediyorsun?',
        ];
    for (final q in questions.take(3)) {
      buffer.writeln('- $q');
    }

    // Optional personality note - ONLY AT THE END
    if (userSign != null) {
      buffer.writeln();
      buffer.writeln('---');
      buffer.writeln(_getPersonalityDreamNote(symbol, userSign));
    }

    return buffer.toString().trim();
  }

  /// Detect emotion type from context answers
  String _detectEmotionType(String allAnswers) {
    if (allAnswers.contains('korku') ||
        allAnswers.contains('endise') ||
        allAnswers.contains('panik') ||
        allAnswers.contains('korkutucu') ||
        allAnswers.contains('tehdit')) {
      return 'fearful';
    } else if (allAnswers.contains('huzur') ||
        allAnswers.contains('sakin') ||
        allAnswers.contains('rahat') ||
        allAnswers.contains('ozgur')) {
      return 'peaceful';
    } else if (allAnswers.contains('merak') ||
        allAnswers.contains('ilginc') ||
        allAnswers.contains('saskin')) {
      return 'curious';
    }
    return 'neutral';
  }

  /// Detect dreamer position from context answers
  String _detectDreamerPosition(String allAnswers) {
    if (allAnswers.contains('izliyordum') ||
        allAnswers.contains('gozlem') ||
        allAnswers.contains('dışarıdan')) {
      return 'observer';
    } else if (allAnswers.contains('kaciyordum') ||
        allAnswers.contains('kacti') ||
        allAnswers.contains('uzaklasiyordum')) {
      return 'escaping';
    } else if (allAnswers.contains('yüzleş') ||
        allAnswers.contains('karsi') ||
        allAnswers.contains('durdum')) {
      return 'confronting';
    } else if (allAnswers.contains('içinde') ||
        allAnswers.contains('yapıyordum') ||
        allAnswers.contains('suruyordum')) {
      return 'participant';
    }
    return 'neutral';
  }

  String _getGenericDreamInterpretation(
    Map<String, String> contextAnswers,
    ZodiacSign? userSign,
  ) {
    final allAnswers = contextAnswers.values.join(' ').toLowerCase();
    final emotionType = _detectEmotionType(allAnswers);

    final buffer = StringBuffer();

    buffer.writeln('RÜYANIN ÖZETİ');
    buffer.writeln('Bu rüyada önemli bir sembol veya deneyim var.');
    buffer.writeln();

    buffer.writeln('DUYGUSAL AGIRLIK');
    if (emotionType == 'fearful') {
      buffer.writeln('Rüyada duygusal ton gergin veya endiseli görünüyor.');
    } else if (emotionType == 'peaceful') {
      buffer.writeln('Rüyada duygusal ton huzurlu ve kabul edici görünüyor.');
    } else {
      buffer.writeln('Rüyada duygusal ton belirsiz veya karışık görünüyor.');
    }
    buffer.writeln();

    buffer.writeln('SEMBOL DINAMIGI');
    buffer.writeln(
      'Her rüya sembolü kişisel anlam taşır. Önemli olan, bu sembolün senin için ne ifade ettiğini keşfetmektir.',
    );
    buffer.writeln();

    buffer.writeln('OLASI YASAM YANSIMASI');
    buffer.writeln(
      'Bu rüya, su anki hayat döneminde dikkat etmen gereken bir konuya işaret ediyor olabilir.',
    );
    buffer.writeln();

    buffer.writeln('ENTEGRASYON ODAGI');
    buffer.writeln(
      'Rüyada hissettiğin duygular, gerçek hayattaki bir duruma nasıl tepki verdiğini gösteriyor olabilir.',
    );
    buffer.writeln();

    buffer.writeln('YANSITICI SORULAR');
    buffer.writeln('- Bu sembol senin için kişisel olarak ne ifade ediyor?');
    buffer.writeln(
      '- Son zamanlarda benzer duygular yaşadığın bir durum var mi?',
    );
    buffer.writeln('- Rüyadaki bu enerjiyi nerede hissediyorsun?');

    if (userSign != null) {
      buffer.writeln();
      buffer.writeln('---');
      buffer.writeln(
        'Eğer istersen, bu rüyanın ${userSign.nameTr} kişilik tipin açısından nasıl okunabileceğini konuşabiliriz.',
      );
    }

    return buffer.toString().trim();
  }

  String _getPersonalityDreamNote(String symbol, ZodiacSign sign) {
    final notes = {
      'yılan': {
        ZodiacSign.scorpio:
            'Kişilik tipin olarak yılan sembolü, doğal dönüşüm gücünle derin bir rezonans taşır.',
        ZodiacSign.aries:
            'Kişilik tipinin ateşli enerjisi, bu semboldeki meydan okuma yönünü güçlendiriyor olabilir.',
      },
      'su': {
        ZodiacSign.pisces:
            'Kişilik tipin olarak su elementi seninle doğal bir bağ kurar. Sezgilerin bu rüya hakkında sana daha fazlasını söylüyor olabilir.',
        ZodiacSign.cancer:
            'Kişilik tipin olarak duygusal derinlik ve su elementi sana çok tanıdık gelebilir.',
        ZodiacSign.scorpio:
            'Kişilik tipinin derin suları, bu rüyanın bilinçdışı katmanlarını keşfetmene yardımcı olabilir.',
      },
      'ates': {
        ZodiacSign.aries:
            'Kişilik tipinin ateş elementi, bu semboldeki enerji ve dönüşüm temalarını güçlendiriyor.',
        ZodiacSign.leo:
            'Kişilik tipin olarak ateş elementi seninle doğal bir bağ kurar.',
        ZodiacSign.sagittarius:
            'Kişilik tipinin ates enerjisi, bu rüyadaki özgürlük ve dönüşüm temalarını destekliyor olabilir.',
      },
    };

    final symbolNotes = notes[symbol];
    if (symbolNotes != null && symbolNotes.containsKey(sign)) {
      return 'Kişilik notu: ${symbolNotes[sign]}';
    }

    return 'Eğer istersen, bu rüyanın ${sign.nameTr} kişilik tipinle olan bağlantısını daha detaylı inceleyebiliriz.';
  }

  // Map Turkish symbol keys to localization keys
  static const Map<String, String> _symbolKeyMap = {
    'yılan': 'snake',
    'su': 'water',
    'ucmak': 'flying',
    'dusmek': 'falling',
    'dis': 'teeth',
    'olum': 'death',
    'kovalanmak': 'being_chased',
    'bebek': 'baby',
    'ev': 'house',
    'araba': 'car',
    'kopek': 'dog',
    'kedi': 'cat',
    'para': 'money',
    'sinav': 'exam',
    'ciplaklık': 'nakedness',
    'kaybolmak': 'getting_lost',
    'ates': 'fire',
    'kan': 'blood',
    'gelin': 'wedding',
    'hastalik': 'illness',
    'genel': 'general',
  };

  /// Get localized symbol acknowledgment
  static String getSymbolAcknowledgment(
    String symbolKey,
    AppLanguage language,
  ) {
    final localizedKey = _symbolKeyMap[symbolKey] ?? 'general';
    final localized = L10nService.get(
      'dreams.symbol_acknowledgments.$localizedKey',
      language,
    );
    // If localization exists, use it
    if (localized != 'dreams.symbol_acknowledgments.$localizedKey') {
      return localized;
    }
    // Fallback to hardcoded Turkish
    return _dreamSymbolAcknowledgments[symbolKey] ??
        _dreamSymbolAcknowledgments['genel']!;
  }

  /// Get localized context questions for a symbol
  static List<String> getContextQuestions(
    String symbolKey,
    AppLanguage language,
  ) {
    final localizedKey = _symbolKeyMap[symbolKey] ?? 'general';
    final localized = L10nService.getList(
      'dreams.context_questions.$localizedKey',
      language,
    );
    // If localization exists and has content, use it
    if (localized.isNotEmpty &&
        localized.first != 'dreams.context_questions.$localizedKey') {
      return localized;
    }
    // Fallback to hardcoded Turkish
    return _dreamContextQuestions[symbolKey] ??
        _dreamContextQuestions['genel']!;
  }

  // Dream symbol acknowledgments (fallback)
  static final Map<String, String> _dreamSymbolAcknowledgments = {
    'yılan':
        'Yılan, rüyaların en güçlü ve çok katmanlı sembollerinden biridir. Dönüşüm, şifa, gizli bilgi veya iç tehditler gibi pek çok anlam taşıyabilir.',
    'su':
        'Su, rüyalarda duygusal durumu ve bilinçdışını temsil eden evrensel bir semboldür. Suyun hali - durgun, dalgalı, temiz veya bulanık - önemli ipuçları taşır.',
    'ucmak':
        'Uçmak, rüyalarda özgürlük, yüksek hedefler veya gerçeklikten kaçış gibi temaları işaret edebilen güçlü bir deneyimdir.',
    'dusmek':
        'Düşme rüyaları, kontrol kaybetme, güvensizlik veya büyük bir değişim öncesi hissedilen korkuları yansıtabilir.',
    'dis':
        'Diş rüyaları, kayıp, değişim, görünüm kaygıları veya iletişim sorunlarıyla ilişkili olabilir.',
    'olum':
        'Ölüm rüyaları çoğunlukla literal değildir. Dönüşüm, bir dönemin sonu veya büyük bir değişimi simgeleyebilir.',
    'kovalanmak':
        'Kovalanma rüyaları, kaçılmaya çalışılan duygular, sorumluluklar veya korkuları temsil edebilir.',
    'bebek':
        'Bebek rüyaları, yeni başlangıçları, yaratıcılık projelerini veya iç çocuğunuzla bağlantınızı simgeleyebilir.',
    'ev':
        'Ev, rüyalarda benlik ve iç dünyanın bir yansıması olarak görülür. Evin durumu ve odaları farklı yaşam alanlarını temsil edebilir.',
    'araba':
        'Araba rüyaları, hayat yolculuğunda kontrol, yön ve ilerleme temalarını işaret eder.',
    'kopek':
        'Köpek, sadakat, dostluk veya içgüdüsel yanlarımızı temsil edebilir. Köpeğin davranışı önemli ipuçları taşır.',
    'kedi':
        'Kedi, bağımsızlık, sezgi ve gizemle ilişkilidir. Feminen enerji ve iç bilgeliği de simgeleyebilir.',
    'para':
        'Para rüyaları, değer, özsaygı ve kaynaklara erişim temalarını yansıtabilir.',
    'sinav':
        'Sınav rüyaları, performans kaygısı, değerlendirilme korkusu veya yaşam testleri hakkında olabilir.',
    'ciplaklık':
        'Çıplaklık rüyaları, savunmasızlık, otantik benliğin ifası veya maskelerden arınma ile ilişkilidir.',
    'kaybolmak':
        'Kaybolma rüyaları, hayatta yön kaybetme, kimlik arayışı veya belirsizlik hislerini yansıtabilir.',
    'ates':
        'Ateş, tutku, öfke, dönüşüm veya arınmayı temsil edebilir. Yangının kontrollü veya kontrolsüz olması önemlidir.',
    'kan':
        'Kan, yaşam enerjisi, duygusal yaralar veya aile bağlarıyla ilişkili temalar işaret edebilir.',
    'gelin':
        'Gelin/düğün rüyaları, birleşme, taahhüt veya hayatın yeni bir evresine geçişi simgeleyebilir.',
    'hastalik':
        'Hastalık rüyaları, duygusal veya ruhsal dengesizliklere, dikkat edilmesi gereken alanlara işaret edebilir.',
    'genel':
        'Her rüya sembolü kişisel anlam taşır. Önemli olan, bu sembolün senin için ne ifade ettiğini keşfetmektir.',
  };

  // Context questions for each symbol - APEX SYMBOL-SPECIFIC QUESTION SETS
  static final Map<String, List<String>> _dreamContextQuestions = {
    // YILAN - Snake
    'yılan': [
      'Yılan sana doğru mu geliyordu, sadece orada mı duruyordu, yoksa uzaklaşıyordu mu?',
      'Hâkim duygu neydi? (korku, gerilim, merak, sakinlik)',
      'Ortam kapalı mıydı (oda/ev) yoksa açık mıydı (doğa)?',
    ],
    // DUSMEK - Falling
    'dusmek': [
      'Düşüş kontrol kaybetme mi yoksa bırakma gibi mi hissettirdi?',
      'Yere çarptın mı yoksa ortada uyandın mı?',
      'Düşüş yüksek miydi yoksa kısa mı?',
    ],
    // KOVALANMAK - Chase
    'kovalanmak': [
      'Seni kovalayan kimdi veya neydi? (net mi, belirsiz mi)',
      'Kaçabildin mi yoksa saklanabildin mi?',
      'Hâkim duygu neydi? (korku, panik, öfke)',
    ],
    // OLUM - Death
    'olum': [
      'Kim ölüyordu rüyada? (sen mi, başkası mı)',
      'Ölüm şiddetli miydi yoksa huzurlu mu?',
      'Sonrasında ne hissettin? (rahatlama, korku, boşluk)',
    ],
    // ATES - Fire
    'ates': [
      'Ateş kontrollü müydü yoksa yayılıyor muydu?',
      'Isıtıcı mıydı yoksa yakıcı mı?',
      'Gözlemci miydin yoksa müdahale mi ediyordun?',
    ],
    // SU - Water
    'su': [
      'Su nasıl görünüyordu? (temiz, bulanık, dalgalı, durgun)',
      'Suyun içinde miydin, dışında mı?',
      'Su hareket halinde miydi yoksa durgun mu?',
    ],
    // UCMAK - Flying
    'ucmak': [
      'Uçmak nasıl hissettirdi? (korkutucu, özgürleştirici)',
      'Kontrol sende miydi yoksa rüzgâra mı kapıldın?',
      'Ne kadar yüksekte uçuyordun?',
    ],
    // DIS - Teeth
    'dis': [
      'Dişler nasıl dökülüyordu? (kendiliğinden, darbe ile, parçalanarak)',
      'Bunu gören veya fark eden başkası var mıydı?',
      'Dökülme sırasında ne hissettin?',
    ],
    // BEBEK - Baby
    'bebek': [
      'Bebek senin mi yoksa başkasının mıydı?',
      'Bebeğe nasıl davranıyordun? (koruyucu, endişeli, ilgisiz)',
      'Bebeğin durumu nasıldı? (mutlu, ağlıyor, hasta)',
    ],
    // EV - House
    'ev': [
      'Tanıdık bir ev miydi yoksa tanımadığın bir yer mi?',
      'Evin hangi bölümündeydin? (oturma odası, bodrum, çatı arası, koridor)',
      'Ev bakımlı mıydı yoksa harap mı?',
    ],
    // ARABA - Car
    'araba': [
      'Arabayı sen mi sürüyordun?',
      'Araç kontrol altında mıydı?',
      'Nereye gidiyordunuz? (belli bir yer, belirsiz)',
    ],
    // KOPEK - Dog
    'kopek': [
      'Köpek dost canlısı mıydı yoksa tehditkâr mı?',
      'Tanıdık bir köpek miydi?',
      'Köpek sana ne yapıyordu? (havlama, ısırma, oynama, takip)',
    ],
    // KEDI - Cat
    'kedi': [
      'Kedi sana yakın mıydı yoksa uzakta mı?',
      'Nasil bir tavri vardi? (sevecen, mesafeli, tehditkar)',
      'Kedi ne yapıyordu?',
    ],
    // PARA - Money
    'para': [
      'Para buldun mu, kaybettin mi, yoksa sadece gördün mü?',
      'Ne kadar para vardi? (cok, az, belirsiz)',
      'Parayla ne yaptin veya ne olmasi bekleniyordu?',
    ],
    // SINAV - Exam
    'sinav': [
      'Sınava hazır mıydın yoksa habersiz mi yakalandın?',
      'Soruları cevaplayabildin mi?',
      'Başkası da sınava giriyor muydu?',
    ],
    // CIPLAKLIK - Nudity
    'ciplaklık': [
      'Çıplaklığını başkası fark etti mi?',
      'Ne hissettin? (utanç, rahatlık, korku)',
      'Ortamda baska insanlar var miydi?',
    ],
    // KAYBOLMAK - Being Lost
    'kaybolmak': [
      'Tanıdık bir yerde mi kayboldun, yoksa tanımadığın bir yerde mi?',
      'Birisini mi arıyordun, yoksa bir yere mi ulaşmaya çalışıyordun?',
      'Yol sorabildin mi veya yardım bulabildin mi?',
    ],
    // KAN - Blood
    'kan': [
      'Kan senden mi akiyordu, baskasından mi?',
      'Bir yara var miydi?',
      'Kan miktarı çok muydu, az mı?',
    ],
    // HASTALIK - Illness
    'hastalik': [
      'Sen mi hastaydın, başkası mi?',
      'Hastalık ciddi miydi yoksa hafif mi?',
      'Tedavi var mıydı, iyileşme umudu var mıydı?',
    ],
    // GELIN/DUGUN - Wedding
    'gelin': [
      'Düğün senin mi yoksa başkasının mı?',
      'Mutlu bir tören miydi, yoksa bir sorun mu vardı?',
      'Damadi/gelini tanıyor muydun?',
    ],
    // GENEL - Generic
    'genel': [
      'Rüyada en çok dikkatini çeken şey neydi?',
      'Hâkim duygu neydi? (korku, merak, huzur, gerilim)',
      'Rüyadan uyandığında ne hissettin?',
    ],
  };

  // Local dream interpretations - APEX 8-PART MASTER STRUCTURE
  static final Map<String, Map<String, String>> _localDreamInterpretations = {
    'yılan': {
      'reconstruction': 'Bu rüyada yılan sembolü merkezi bir rol oynuyor.',
      'emotionalCenter_fear':
          'Duygusal ağırlık korku ve gerilim etrafında toplanmış görünüyor. Yılan, hayatında tehdit olarak algıladığın bir şeyi temsil ediyor olabilir.',
      'emotionalCenter_peace':
          'Duygusal ağırlık sakinlik ve kabul etrafında toplanmış. Yılan burada şifa veya dönüşüm enerjisi taşıyor olabilir.',
      'emotionalCenter_curiosity':
          'Duygusal ağırlık merak etrafında. Yılan, kesfedilmeyi bekleyen gizli bir bilgiyi temsil ediyor olabilir.',
      'emotionalCenter_neutral':
          'Duygusal ton belirsiz. Yılan sembolü, henüz tanımlanmamış bir değişim sürecine işaret ediyor olabilir.',
      'symbolDynamics':
          'Yılan, dönüşüm ve yenilenmenin evrensel sembolüdür. Hareket şekli - sana doğru, uzağa, durgun - önemli ipuçları taşır. Yaklaşıyor ise yüzleşme, uzaklaşıyorsa kaçış temasıni işaret edebilir.',
      'position_observer':
          'Gozlemci pozisyonundaydin - bu, durumu dışarıdan degerlendidigini gösteriyor olabilir.',
      'position_participant':
          'Aktif katılımcı pozisyonundaydin - bu dönüşüm sureci seni doğrudan ilgilendiriyor.',
      'position_escaping':
          'Kaçan pozisyonundaydin - bu, yüzleşmekten kaçındığın bir durumu yansıtıyor olabilir.',
      'position_confronting':
          'Yüzleşen pozisyonundaydin - bu, bir seyle hesaplaşma sürecinde olduğunu gösteriyor.',
      'position_neutral':
          'Pozisyonun belirsizdi - bu, duruma karsi henüz net bir tutum geliştirmediğini gösteriyor olabilir.',
      'timing':
          'Yılan rüyaları genellikle büyük değişim ve dönüşüm dönemlerinde ortaya çıkar. Bu, bir geçiş sürecinin başlangıcı, ortası veya sonu olabilir.',
      'lifeResonance_fear':
          'Bu rüya, hayatında bastırılan bir korku veya kaçınilan bir gerçekle rezonans yapıyor olabilir.',
      'lifeResonance_peace':
          'Bu rüya, hayatında doğal bir dönüşüm sürecinin sağlıklı ilerlediğini yansıtıyor olabilir.',
      'lifeResonance_neutral':
          'Bu rüya, hayatında farkinda olmadan işlenmekte olan bir temaya işaret ediyor olabilir.',
      'integration':
          'Bu rüya, senden dönüşümu kabul etmeni ve değişimden kaçmamani istiyor olabilir. Yılan, eski kabugu bırakmanin yeni buyumeye alan actigini hatırlatiyor.',
      'questions':
          'Hayatında şimdi sonlanmakta olan ne var?|Hangi korku veya gerçekle yüzleşmekten kaçıniyorsun?|Bu sembolü gördüğünde ilk aklına gelen kisi veya durum ne?',
    },
    'su': {
      'reconstruction': 'Bu rüyada su elementi merkezi bir rol oynuyor.',
      'emotionalCenter_fear':
          'Duygusal ağırlık korku etrafında toplanmış - bogulma, kontrolsuz akis veya karanlik sular gibi temalar duygusal bunalmisi yansıtıyor olabilir.',
      'emotionalCenter_peace':
          'Duygusal ağırlık huzur etrafında - berrak ve sakin sular, ic huzur ve duygusal netliği yansıtıyor olabilir.',
      'emotionalCenter_curiosity':
          'Duygusal ağırlık merak etrafında - suyun derinliklerine bakmak, ic dünyanı keşfetmeye hazır olduğunu gösteriyor.',
      'emotionalCenter_neutral':
          'Duygusal ton karışık - su hem sakinlestirici hem de tehditkar olabilir, bu ikiliği incele.',
      'symbolDynamics':
          'Su, bilinçdışı ve duyguların evrensel sembolüdür. Durumu - temiz/bulanık, durgun/dalgalı - önemli ipuçları taşır. Suyun içinde olmak ve dışında olmak arasındaki fark büyüktür.',
      'position_observer':
          'Suyu dışarıdan izliyordun - duygularını mesafeli bir yerden değerlendiriyorsun.',
      'position_participant':
          'Suyun içindeydin - duygularına tamamen dalmiş durumdasın.',
      'position_escaping':
          'Sudan kaçıyordun - duygusal yükten uzaklaşmaya çalışıyor olabilirsin.',
      'position_confronting':
          'Suyla yüzleşiyordun - duygusal derinlige inmeye hazirsin.',
      'position_neutral':
          'Pozisyonun değişken - duygularınla ilişkin henüz netleşmiyor olabilir.',
      'timing':
          'Su rüyaları genellikle duygusal geçiş dönemlerinde ortaya çıkar. Bir duygunun işlenmesi veya serbest bırakılması sürecinde olabilirsin.',
      'lifeResonance_fear':
          'Bu rüya, hayatında duygusal olarak bunaldığın veya kontrol edemediğin bir durumu yansıtıyor olabilir.',
      'lifeResonance_peace':
          'Bu rüya, duygusal netlik ve ic huzur döneminin basladigini yansıtıyor olabilir.',
      'lifeResonance_neutral':
          'Bu rüya, işlenmesi gereken duygusal bir temaya dikkat çekiyor olabilir.',
      'integration':
          'Bu rüya, duygularına dikkat etmeni ve onları akmasına izin vermeni istiyor olabilir. Suyun doğası akmaktır - tutmak yerine bırak.',
      'questions':
          'Hayatında su anda hangi duygu en yoğun?|Duygularini ifade etmekte zorlandigin bir alan var mi?|Su elementi seninle nasıl konusuyor?',
    },
    'ucmak': {
      'reconstruction': 'Bu rüyada ucma deneyimi merkezi bir rol oynuyor.',
      'emotionalCenter_fear':
          'Duygusal ağırlık korku etrafında - yükşeklik korkusu veya dusme endisesi, kontrol kaybetme korkusunu yansıtıyor olabilir.',
      'emotionalCenter_peace':
          'Duygusal ağırlık özgürlük etrafında - keyifli uçuş, potansiyelini kullandığının ve doğru yolda ilerlediğinin işareti olabilir.',
      'emotionalCenter_curiosity':
          'Duygusal ağırlık merak etrafında - yeni bakis açilari ve olasılıklara açık olduğunu gösteriyor.',
      'emotionalCenter_neutral':
          'Duygusal ton karışık - ucmak hem özgürleştirici hem de korkutucu olabilir.',
      'symbolDynamics':
          'Uçmak, sınırları asma ve özgürlük arzusunun sembolüdür. Kontrol sende mi değilmi - bu çok önemli. Yükseklik ve uçuş şekli de anlam taşır.',
      'position_observer':
          'Dışarıdan izliyordun - özgürlüğü veya potansiyeli mesafeli bir yerden değerlendiriyorsun.',
      'position_participant':
          'Aktif olarak uçuyordun - potansiyelinle doğrudan temas halindesin.',
      'position_escaping':
          'Uçarak kaçıyordun - bir şeyden uzaklaşmak istiyorsun.',
      'position_confronting':
          'Uçarak yüzleşiyordun - engellerle karsi karsiya gelmeye hazirsın.',
      'position_neutral':
          'Pozisyonun belirsizdi - özgürlüğünle ilişkin henüz netleşmiyor.',
      'timing':
          'Ucma rüyaları genellikle sınırları zorlama veya yeni ufuklara acılma dönemlerinde ortaya çıkar.',
      'lifeResonance_fear':
          'Bu rüya, başarınin getirdigi sorumluluktan veya yükselmekten duydugun endişeyi yansıtıyor olabilir.',
      'lifeResonance_peace':
          'Bu rüya, hayatında gerçeklestirdigin bir özgürlük veya yukselis dönemini yansıtıyor olabilir.',
      'lifeResonance_neutral':
          'Bu rüya, potansiyelinle ilgili keşfedilmemiş bir alana işaret ediyor olabilir.',
      'integration':
          'Bu rüya, potansiyelinin sınırsız olduğunu hatırlatiyor. Ama ayaklarını yere basan pratik adımlarla hayallerini dengelemen gerekebilir.',
      'questions':
          'Hayatında hangi sinirları aşmak istiyorsun?|Başarıveya yükselme seni endişelendirir mi?|Özgür hissettiğin anlar ne zaman?',
    },
    'dusmek': {
      'reconstruction': 'Bu rüyada dusme deneyimi merkezi bir rol oynuyor.',
      'emotionalCenter_fear':
          'Duygusal ağırlık korku ve panik etrafında - kontrol kaybı veya güvensizlik hissini yoğun yaşıyorsun.',
      'emotionalCenter_peace':
          'Duygusal ağırlık teslimiyet etrafında - düşüş huzurlu hissediyorsa, bırakma ve sürece güvenme cagrisı olabilir.',
      'emotionalCenter_curiosity':
          'Duygusal ağırlık merak etrafında - düşüşe merakla yaklasıyorsan, değişime açık olduğunu gösteriyor.',
      'emotionalCenter_neutral':
          'Duygusal ton belirsiz - düşüş hem korku hem de bırakma iceriyor olabilir.',
      'symbolDynamics':
          'Düşme, kontrol kaybı ve güvensizliğin evrensel sembolüdür. Düşmeden once ne oldu, yere çarptın mi, bu detaylar önemli.',
      'position_observer':
          'Dışarıdan izliyordun - kontrol kaybıni mesafeli değerlendiriyorsun.',
      'position_participant':
          'Dusen sendin - bu durum seni doğrudan etkiliyor.',
      'position_escaping':
          'Düşüş bir kaçış gibi hissettirdi - bir şeyden uzaklaşma isteği olabilir.',
      'position_confronting':
          'Düşüşe teslim oldun - sürece güvenmeyi öğreniyorsun.',
      'position_neutral':
          'Pozisyonun belirsizdi - kontrolle ilişkin henüz netleşmiyor.',
      'timing':
          'Düşme rüyaları genellikle büyük belirsizlik veya değişim dönemlerinde ortaya çıkar.',
      'lifeResonance_fear':
          'Bu rüya, hayatında zemin ayaklarının altindan kayiyor gibi hissettiğin bir durumu yansıtıyor olabilir.',
      'lifeResonance_peace':
          'Bu rüya, bırakma ve teslim olma sürecini yansıtıyor olabilir.',
      'lifeResonance_neutral':
          'Bu rüya, kontrol ve güvenlik temalarına dikkat çekiyor olabilir.',
      'integration':
          'Bu rüya, tutundugun seyleri gözden geçirmeni istiyor olabilir. Bazen bırakmak, ileri gitmek için gereklidir.',
      'questions':
          'Hayatında kontrolü kaybettiğini hissettiğin bir alan var mi?|Neyi tutuyorsun ve bırakamıyorsun?|Düşüş sana ne öğretiyor?',
    },
    'kovalanmak': {
      'reconstruction': 'Bu rüyada kovalanma deneyimi merkezi bir rol oynuyor.',
      'emotionalCenter_fear':
          'Duygusal ağırlık korku ve panik etrafında - kaçınilan bir sey seni takip ediyor.',
      'emotionalCenter_peace':
          'Duygusal ağırlık merak etrafında - kovalayani anlamaya çalışıyorsun.',
      'emotionalCenter_curiosity':
          'Duygusal ağırlık kesif etrafında - kovalayan aslinda ne istiyor?',
      'emotionalCenter_neutral':
          'Duygusal ton karışık - hem korku hem merak var.',
      'symbolDynamics':
          'Kovalanmak, kaçılan duygular, sorumluluklar veya gerçekleri temsil eder. Kovalayan kim/ne olduğu çok önemli.',
      'position_observer':
          'Dışarıdan izliyordun - kaçış mekanizmani değerlendiriyorsun.',
      'position_participant':
          'Kaçan sendin - bir şeyden aktif olarak uzaklaşıyorsun.',
      'position_escaping': 'Kacıyordun - yüzleşmekten kaçıniyorsun.',
      'position_confronting': 'Donup yüzleştin - cesaret gösteriyorsun.',
      'position_neutral':
          'Pozisyonun degisti - kaçınma ve yüzleşme arasinda gidip geliyorsun.',
      'timing':
          'Kovalanma rüyaları genellikle kaçınılan bir konu giderek acil hale geldiginde ortaya çıkar.',
      'lifeResonance_fear':
          'Bu rüya, hayatında kaçmaya çalıştığın bir sorumluluk, duygu veya gercegi yansıtıyor olabilir.',
      'lifeResonance_peace':
          'Bu rüya, kovalayani anlamaya ve entegre etmeye basladiğini gösteriyor olabilir.',
      'lifeResonance_neutral':
          'Bu rüya, yüzleşmemen gereken bir alana dikkat çekiyor olabilir.',
      'integration':
          'Bu rüya, don ve sor: Ne istiyorsun? Cogu zaman kactigimiz sey, en çokihtiyacımız olan ders.',
      'questions':
          'Hayatında neden kaçıyorsun?|Kovalayan sana tanıdık geliyor mu?|Dursan ve dönsen ne olurdu?',
    },
    'olum': {
      'reconstruction': 'Bu rüyada olum teması merkezi bir rol oynuyor.',
      'emotionalCenter_fear':
          'Duygusal ağırlık korku ve kaygi etrafında - kayip veya son korkusunu yansıtıyor olabilir.',
      'emotionalCenter_peace':
          'Duygusal ağırlık kabul etrafında - dönüşümu ve bitisin doğalligini kabul ediyorsun.',
      'emotionalCenter_curiosity':
          'Duygusal ağırlık merak etrafında - olumun otesinde ne var sorusu seni cezbediyor.',
      'emotionalCenter_neutral':
          'Duygusal ton karısik - hem korku hem kabul var.',
      'symbolDynamics':
          'Ölüm rüyaları nadiren literal. Dönüşüm, bir döneminin sonu, büyük değişimi temsil eder. Kim olduğu çok önemli - sen mi, başkası mi?',
      'position_observer':
          'Dışarıdan izliyordun - dönüşümu mesafeli değerlendiriyorsun.',
      'position_participant':
          'Sen oluyordun - büyük bir ic değişim yaşıyorsun.',
      'position_escaping':
          'Ölümden kaçıyordun - değişime direnç gösteriyorsun.',
      'position_confronting':
          'Ölümle yüzleşiyordun - dönüşümu kabul ediyorsun.',
      'position_neutral':
          'Pozisyonun belirsizdi - değişime karsi tutumun henüz netleşmiyor.',
      'timing':
          'Ölüm rüyaları genellikle hayatin büyük geçiş noktalarinda - iliskilerin sonu, kariyer değişimleri, kimlik dönüşümleri - ortaya çıkar.',
      'lifeResonance_fear':
          'Bu rüya, hayatında biten veya olmesi gereken bir şeyin korkusunu yansıtıyor olabilir.',
      'lifeResonance_peace':
          'Bu rüya, bir şeyin doğal olarak sona erdiğini ve bunun iyi olduğunu yansıtıyor olabilir.',
      'lifeResonance_neutral':
          'Bu rüya, hayatında dönüşüm bekleyen bir alana işaret ediyor olabilir.',
      'integration':
          'Bu rüya, eski kimligin, aliṣkanlıgın veya yasam biciminin olmesinin yeni bir baslangiça yer actığını hatirlatıyor.',
      'questions':
          'Hayatında şimdi ne bitiyor veya bitmesi gerekiyor?|Neyi bırakmaktan korkuyorsun?|Dönüşümu engelleyen ne?',
    },
    'genel': {
      'reconstruction': 'Bu rüyada önemli bir sembol veya deneyim var.',
      'emotionalCenter_fear':
          'Duygusal ağırlık gerginlik veya endise etrafında toplanmış görünüyor.',
      'emotionalCenter_peace':
          'Duygusal ağırlık huzur ve kabul etrafında toplanmış görünüyor.',
      'emotionalCenter_curiosity':
          'Duygusal ağırlık merak ve kesif etrafında toplanmış görünüyor.',
      'emotionalCenter_neutral':
          'Duygusal ton belirsiz veya karışık görünüyor.',
      'symbolDynamics':
          'Her sembol kişisel anlam taşır. Bu sembolin sana ozel ne ifade ettiğini keşfetmek önemli.',
      'position_observer':
          'Gozlemci pozisyonundaydin - olayları dışarıdan değerlendiriyorsun.',
      'position_participant': 'Katilimci pozisyonundaydin - olaylara dahilsin.',
      'position_escaping':
          'Kaçan pozisyonundaydin - bir şeyden uzaklaşıyorsun.',
      'position_confronting':
          'Yüzleşen pozisyonundaydin - bir seyle karsi karsiyasin.',
      'position_neutral':
          'Pozisyonun belirsiz - duruma karsi tutumun henüz netleşmiyor.',
      'timing':
          'Bu rüya, yasam yolculugunda belirli bir noktaya işaret ediyor olabilir.',
      'lifeResonance_fear':
          'Bu rüya, hayatında dikkat edilmesi gereken bir kaygi veya endişeyi yansıtıyor olabilir.',
      'lifeResonance_peace':
          'Bu rüya, ic huzur ve uyum dönemini yansıtıyor olabilir.',
      'lifeResonance_neutral':
          'Bu rüya, hayatında kesfedilmeyi bekleyen bir alana işaret ediyor olabilir.',
      'integration':
          'Bu rüya, dikkatini belirli bir alana cekmeye çalışıyor olabilir.',
      'questions':
          'Bu sembol senin için kişisel olarak ne ifade ediyor?|Son zamanlarda benzer duygular yaşadığın bir durum var mi?|Rüyadaki bu enerjiyi nerede hissediyorsun?',
    },
  };

  /// Private: Build reflection prompt
  String _buildReflectionPrompt({
    required ZodiacSign sunSign,
    ZodiacSign? moonSign,
    ZodiacSign? risingSign,
    DateTime? birthDate,
    String? currentMoonPhase,
  }) {
    return '''
Bir kişisel gelişim uzmanı olarak günlük ic yansıma yaz.

Kişilik Tipi: ${sunSign.nameTr}
${moonSign != null ? 'Duygusal Profil: ${moonSign.nameTr}' : ''}
${risingSign != null ? 'Sosyal Profil: ${risingSign.nameTr}' : ''}
${currentMoonPhase != null ? 'Guncel Dogal Dongu: $currentMoonPhase' : ''}
Tarih: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}

Su formatta JSON dondur:
{
  "summary": "Genel günlük refleksiyon teması (3-4 cümle)",
  "loveAdvice": "İlişkiler üzerine düşünme teması (2-3 cümle)",
  "careerAdvice": "Kariyer üzerine farkındalık teması (2-3 cümle)",
  "healthAdvice": "Saglik ve enerji farkindaliği (2-3 cümle)",
  "focusNumber": "1-99 arasi odak sayisi",
  "reflectionColor": "Turkce renk adi",
  "mood": "Günün enerjisi (tek kelime)"
}

Turkce yaz, sicak ve destekleyici bir ton kullan.
''';
  }

  /// Private: Generate content with AI
  Future<String?> _generateWithAi(String prompt) async {
    // Try OpenAI first
    if (_openAiApiKey != null && _openAiApiKey!.isNotEmpty) {
      try {
        final response = await http
            .post(
              Uri.parse('$_openAiBaseUrl/chat/completions'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $_openAiApiKey',
              },
              body: jsonEncode({
                'model': 'gpt-4o-mini',
                'messages': [
                  {
                    'role': 'system',
                    'content':
                        'Sen deneyimli bir kişisel gelişim uzmanısın. İlham verici ve destekleyici bir tonda yaziyorsun.',
                  },
                  {'role': 'user', 'content': prompt},
                ],
                'max_tokens': 500,
                'temperature': 0.8,
              }),
            )
            .timeout(const Duration(seconds: 30));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final content = data['choices'][0]['message']['content'] as String;
          // Apply safety filter to all AI responses
          return _sanitizeResponse(content);
        } else if (kDebugMode) {
          debugPrint(
            'OpenAI API error: ${response.statusCode} - ${response.body}',
          );
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('OpenAI request failed: $e');
        }
      }
    }

    // Try Anthropic
    if (_anthropicApiKey != null && _anthropicApiKey!.isNotEmpty) {
      try {
        final response = await http
            .post(
              Uri.parse('$_anthropicBaseUrl/messages'),
              headers: {
                'Content-Type': 'application/json',
                'x-api-key': _anthropicApiKey!,
                'anthropic-version': '2023-06-01',
              },
              body: jsonEncode({
                'model': 'claude-3-haiku-20240307',
                'max_tokens': 500,
                'messages': [
                  {'role': 'user', 'content': prompt},
                ],
                'system':
                    'Sen deneyimli bir kişisel gelişim uzmanısın. İlham verici ve destekleyici bir tonda yaziyorsun.',
              }),
            )
            .timeout(const Duration(seconds: 30));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final content = data['content'][0]['text'] as String;
          // Apply safety filter to all AI responses
          return _sanitizeResponse(content);
        } else if (kDebugMode) {
          debugPrint(
            'Anthropic API error: ${response.statusCode} - ${response.body}',
          );
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Anthropic request failed: $e');
        }
      }
    }

    return null;
  }

  /// Private: Parse reflection JSON response
  PersonalizedHoroscope _parseReflectionResponse(
    String response,
    ZodiacSign sign,
  ) {
    try {
      // Extract JSON from response if wrapped in markdown
      var jsonStr = response;
      if (response.contains('```json')) {
        jsonStr = response.split('```json')[1].split('```')[0].trim();
      } else if (response.contains('```')) {
        jsonStr = response.split('```')[1].split('```')[0].trim();
      }

      final data = jsonDecode(jsonStr);
      return PersonalizedHoroscope(
        sign: sign,
        summary: data['summary'] ?? '',
        loveAdvice: data['loveAdvice'] ?? '',
        careerAdvice: data['careerAdvice'] ?? '',
        healthAdvice: data['healthAdvice'] ?? '',
        focusNumber:
            data['focusNumber']?.toString() ??
            data['luckyNumber']?.toString() ??
            '7',
        reflectionColor:
            data['reflectionColor'] ?? data['luckyColor'] ?? 'Altin',
        mood: data['mood'] ?? 'Dengeli',
        isAiGenerated: true,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to parse AI response: $e');
      }
      return _generateLocalReflection(sunSign: sign);
    }
  }

  /// Private: Generate local reflection
  PersonalizedHoroscope _generateLocalReflection({
    required ZodiacSign sunSign,
    ZodiacSign? moonSign,
    ZodiacSign? risingSign,
  }) {
    final random = Random(DateTime.now().day + sunSign.index);

    final summaries = _localSummaries[sunSign] ?? _defaultSummaries;
    final loveAdvices = _localLoveAdvice[sunSign] ?? _defaultLoveAdvice;
    final careerAdvices = _localCareerAdvice[sunSign] ?? _defaultCareerAdvice;
    final healthAdvices = _localHealthAdvice[sunSign] ?? _defaultHealthAdvice;

    return PersonalizedHoroscope(
      sign: sunSign,
      summary: summaries[random.nextInt(summaries.length)],
      loveAdvice: loveAdvices[random.nextInt(loveAdvices.length)],
      careerAdvice: careerAdvices[random.nextInt(careerAdvices.length)],
      healthAdvice: healthAdvices[random.nextInt(healthAdvices.length)],
      focusNumber: (random.nextInt(99) + 1).toString(),
      reflectionColor:
          _reflectionColors[random.nextInt(_reflectionColors.length)],
      mood: _moods[random.nextInt(_moods.length)],
      isAiGenerated: false,
    );
  }

  String _getAreaName(
    AdviceArea area, [
    AppLanguage language = AppLanguage.en,
  ]) {
    switch (language) {
      case AppLanguage.tr:
        switch (area) {
          case AdviceArea.love:
            return 'ask ve iliskiler';
          case AdviceArea.career:
            return 'kariyer ve is';
          case AdviceArea.health:
            return 'saglik ve enerji';
          case AdviceArea.money:
            return 'para ve bolluk';
          case AdviceArea.spiritual:
            return 'spirituel gelişim';
        }
      case AppLanguage.de:
        switch (area) {
          case AdviceArea.love:
            return 'Liebe und Beziehungen';
          case AdviceArea.career:
            return 'Karriere und Arbeit';
          case AdviceArea.health:
            return 'Gesundheit und Energie';
          case AdviceArea.money:
            return 'Geld und Fülle';
          case AdviceArea.spiritual:
            return 'spirituelle Entwicklung';
        }
      case AppLanguage.fr:
        switch (area) {
          case AdviceArea.love:
            return 'amour et relations';
          case AdviceArea.career:
            return 'carrière et travail';
          case AdviceArea.health:
            return 'santé et énergie';
          case AdviceArea.money:
            return 'argent et abondance';
          case AdviceArea.spiritual:
            return 'développement spirituel';
        }
      case AppLanguage.en:
      default:
        switch (area) {
          case AdviceArea.love:
            return 'love and relationships';
          case AdviceArea.career:
            return 'career and work';
          case AdviceArea.health:
            return 'health and energy';
          case AdviceArea.money:
            return 'money and abundance';
          case AdviceArea.spiritual:
            return 'spiritual growth';
        }
    }
  }

  String _getLocalAdvice(ZodiacSign sign, AdviceArea area) {
    final random = Random(DateTime.now().day + sign.index + area.index);

    switch (area) {
      case AdviceArea.love:
        final advices = _localLoveAdvice[sign] ?? _defaultLoveAdvice;
        return advices[random.nextInt(advices.length)];
      case AdviceArea.career:
        final advices = _localCareerAdvice[sign] ?? _defaultCareerAdvice;
        return advices[random.nextInt(advices.length)];
      case AdviceArea.health:
        final advices = _localHealthAdvice[sign] ?? _defaultHealthAdvice;
        return advices[random.nextInt(advices.length)];
      case AdviceArea.money:
        return 'Bolluk enerjisi bugün seninle. Bilinçli harcamalar ve yeni gelir fırsatları için gözlerini aç.';
      case AdviceArea.spiritual:
        return CosmicMessagesContent.getDailyCosmicMessage(DateTime.now());
    }
  }

  // Local content data - colors for reflection themes
  static final List<String> _reflectionColors = [
    'Altin',
    'Mor',
    'Mavi',
    'Yesil',
    'Kirmizi',
    'Pembe',
    'Turuncu',
    'Gumus',
    'Turkuaz',
    'Lavanta',
    'Sampanya',
  ];

  static final List<String> _moods = [
    'Enerjik',
    'Huzurlu',
    'Yaratıcı',
    'Tutkulu',
    'Dengeli',
    'İlham Dolu',
    'Kararli',
    'Romantik',
    'Güçlü',
    'Sezgisel',
  ];

  static final List<String> _defaultSummaries = [
    'Bugün iç enerjin senin lehine çalışıyor. Firsatlari değerlendir, kalbinin sesini dinle.',
    'Pozitif değişim temaları öne çıkıyor. Beklenmedik sürprizlere hazir ol.',
    'İç güçun bugün sana enerji veriyor. Hedeflerine odaklan, başarı yakın.',
  ];

  static final List<String> _defaultLoveAdvice = [
    'Kalbini açmayı düşün. İlişkilerde dürüstlük önemli bir tema.',
    'Romantik enerjiler güçlü. Sevdiklerinle kaliteli zaman geçir.',
    'Duygusal baglar derinlesiyor. Kendini ifade etmekten çekinme.',
  ];

  static final List<String> _defaultCareerAdvice = [
    'Kariyer fırsatları beliriyor. Yeni projeler için mükemmel zamanlama.',
    'Profesyonel gelişim için kapılar açılıyor. Yeteneklerini sergile.',
    'Is hayatında pozitif gelişim temaları. Sabır ve emek önemli temalar.',
  ];

  static final List<String> _defaultHealthAdvice = [
    'Enerjin yüksek, dengeni koru. Hareket et, sağlıklı beslen.',
    'İç huzur temaları öne çıkıyor. Meditasyon ve nefes calismalari faydali olabilir.',
    'Bedenini dinle, ihtiyaclarina kulak ver. Dinlenme de önemli.',
  ];

  // Sign-specific local content (abbreviated for brevity - full content preserved)
  static final Map<ZodiacSign, List<String>> _localSummaries = {
    ZodiacSign.aries: [
      'Ateş enerjin bugün doruklarda. Liderlik yeteneğini göster, cesaretinle ileri atıl.',
      'İç güçun seni destekliyor. Yeni baslangiclar için mükemmel bir gun.',
      'Savasci ruhun uyaniyor. Hedeflerine kararlılıkla ilerle.',
    ],
    ZodiacSign.taurus: [
      'Toprak enerjisi seni besliyor. Maddi konularda dengelerin güçleniyor.',
      'Güzellik ve çekicilik temaları öne çıkıyor. Ask ve is alanlari uzerinde düşünebilirsin.',
      'Sabır ve kararlılık temaları öne çıkıyor. Güven ve devamlılık üzerine düşün.',
    ],
    ZodiacSign.gemini: [
      'Zihinsel çevikliğin bugün super guc. İletişimde parlıyorsun.',
      'Düşüncelerin keskinleşiyor. Yeni fikirler, yeni bağlantılar.',
      'Sosyal enerji temaları öne çıkıyor. Network kurmayi düşünebilirsin.',
    ],
    ZodiacSign.cancer: [
      'Ay isigi ruhunu aydinlatiyor. Sezgilerin çokgüçlü, dinle.',
      'Duygusal zekan bugün rehberin. Kalbinin sesini takip et.',
      'Aile ve yuva konulari öne çıkıyor. Sevdiklerine zaman ayir.',
    ],
    ZodiacSign.leo: [
      'Gunes enerjin maksimumda. Parla, sahneye cik, ilgi odagi ol.',
      'Yaratıcılığın volkanik. Sanatsal projeler için mükemmel gun.',
      'Kraliyet arketipi temaları öne çıkıyor. Liderlik üzerine düşünebilirsin.',
    ],
    ZodiacSign.virgo: [
      'Analitik zekan bugün lazer gibi. Detaylarda sihir gizli.',
      'Organizasyon yetenegin on planda. Duzen kur, verimlilik artacak.',
      'Saglik ve wellness konulari öne çıkıyor. Kendine iyi bak.',
    ],
    ZodiacSign.libra: [
      'Denge ve uyum enerjisi güçlü. İlişkilerde harmoni zamanı.',
      'Güzellik ve diplomasi yetenegin artis gösteriyor.',
      'Estetik duyarlılığım dorukta. Güzellik yarat, güzellik cek.',
    ],
    ZodiacSign.scorpio: [
      'Dönüşüm enerjisi yoğun. Derinlere dal, hazineleri bul.',
      'Sezgilerin bugün çokkeskin. Gizli gerçekler ortaya çıkıyor.',
      'Tutku ve guc birlesiyor. Istedigin her şeyi cekme kapasiten var.',
    ],
    ZodiacSign.sagittarius: [
      'Macera ruhu temaları öne çıkıyor. Yeni ufuklar ve deneyimler üzerine düşünebilirsin.',
      'Genisleme temaları öne çıkıyor. Firsat alanlari üzerine düşünebilirsin.',
      'Felsefi derinlik günü. Hayatin anlamını sorgula, bilgelik bul.',
    ],
    ZodiacSign.capricorn: [
      'Kariyer temaları öne çıkıyor. Profesyonel gelişim üzerine düşünebilirsin.',
      'Disiplin ve yapi temaları güçlü. Hedeflerine kararlılıkla ilerle.',
      'Uzun vadeli planlar için mükemmel gun. Temelleri saglam at.',
    ],
    ZodiacSign.aquarius: [
      'Yenilikçi enerjin bugün dorukta. Sıra dışı fikirler, devrimci çözümler.',
      'Beklenmedik fırsatlar temaları öne çıkıyor. Degisime açık ol.',
      'Topluluk enerjisi güçlü. Insanliga hizmet zamanı.',
    ],
    ZodiacSign.pisces: [
      'Spirituel bağlantın bugün çokgüçlü. İç dünya ile uyum içinde ol.',
      'Yaratıcılığın ve sezgilerin besleniyor. Sanatin aksin.',
      'Rüyalar ve hayal gucu on planda. İç dünyaina kulak ver.',
    ],
  };

  static final Map<ZodiacSign, List<String>> _localLoveAdvice = {
    ZodiacSign.aries: [
      'Tutku temaları ask hayatında öne çıkıyor. Romantik anlar üzerine düşünebilirsin.',
      'Iliskide inisiyatif teması öne çıkıyor. Cesur adimlar üzerine düşünebilirsin.',
    ],
    ZodiacSign.taurus: [
      'Duyusal zevkler ve romantik aksam yemekleri için ideal gun.',
      'Sadakat ve güven ilişkini güçlendiriyor. Sevgini somut göster.',
    ],
    ZodiacSign.gemini: [
      'İletişim askin anahtari. Derin sohbetler baglari kuvvetlendiriyor.',
      'Flort enerjin yüksek. Yeni tanisikliklar heyecan verici olabilir.',
    ],
    ZodiacSign.cancer: [
      'Duygusal derinlik ilişkini besliyor. Kalbini aç, sevgiyi kabul et.',
      'Yuva kurma içgüdüsu temaları öne çıkıyor. Partner ile ortak hedefler üzerine düşün.',
    ],
    ZodiacSign.leo: [
      'Romantik jestler ve dikkat cekici anlar temaları öne çıkıyor.',
      'Askta drama ve tutku var. Kalbini takip et, cesur ol.',
    ],
    ZodiacSign.virgo: [
      'Kucuk detaylar büyük anlamlar taşıyor. Pratik sevgi göster.',
      'Iliskide duzen ve rutin faydali. Saglikli sinirlar koy.',
    ],
    ZodiacSign.libra: [
      'Romantik uyum mükemmel. İlişkilerde denge ve harmoni zamanı.',
      'Estetik randevular ve guzel anlar temaları öne çıkıyor.',
    ],
    ZodiacSign.scorpio: [
      'Yogun tutkular ve derin bağlantılar günü. Güven insa et.',
      'Cinsel ve duygusal birliktelik güçleniyor. Dönüşüm zamanı.',
    ],
    ZodiacSign.sagittarius: [
      'Macera dolu romantizm temaları öne çıkıyor. Yeni yerler ve deneyimler üzerine düşünebilirsin.',
      'Entelektuel bağfiziksel çekimi artırıyor. Birlikte öğren.',
    ],
    ZodiacSign.capricorn: [
      'Ciddi iliskiler ve uzun vadeli planlar için mükemmel zaman.',
      'Sadakat ve bagliligin karsilik buluyor. Güven insa ediliyor.',
    ],
    ZodiacSign.aquarius: [
      'Sıra dışı romantik deneyimler temaları öne çıkıyor. Ozgünlük üzerine düşünebilirsin.',
      'Arkadaslik temelli ask güçleniyor. Entellektuel bağönemli.',
    ],
    ZodiacSign.pisces: [
      'Ruhani ask baglari derinlesiyor. Ruh esi enerjisi yoğun.',
      'Romantik rüyalar gercege donusuyor. Sezgilerine güven.',
    ],
  };

  static final Map<ZodiacSign, List<String>> _localCareerAdvice = {
    ZodiacSign.aries: [
      'Liderlik pozisyonları parliyor. Girişimci projeler baslat.',
      'Rekabet temaları öne çıkıyor. Cesaret üzerine düşünebilirsin.',
    ],
    ZodiacSign.taurus: [
      'Finansal fırsatlar beliriyor. Yatirimlar için uygun zaman.',
      'Sabırli calisma temaları öne çıkıyor. Bolluk üzerine düşünebilirsin.',
    ],
    ZodiacSign.gemini: [
      'İletişim ve network projeleri öne çıkıyor. Baglantilari kullan.',
      'Cok yonlu yeteneklerin talep goruyor. Kendini pazarla.',
    ],
    ZodiacSign.cancer: [
      'Ev tabanli isler ve duygusal zeka gerektiren roller parliyor.',
      'Takim calismasi ve destek rolleri için mükemmel gun.',
    ],
    ZodiacSign.leo: [
      'Yaratıcı projeler ve sahne onu roller için ideal zaman.',
      'Liderlik ve yöneticilik temaları öne çıkıyor. Parlamanın yollarını düşün.',
    ],
    ZodiacSign.virgo: [
      'Detay odakli islerde başarı potansiyeli yüksek. Analiz yeteneğini kullan.',
      'Organizasyon projeleri parliyor. Sistemler kur, verimlilik artir.',
    ],
    ZodiacSign.libra: [
      'Ortakliklar ve diplomasi alaninda fırsatlar var.',
      'Is birligi projeleri bereketli. Kopruler kur.',
    ],
    ZodiacSign.scorpio: [
      'Arastirma ve dönüşüm projeleri öne çıkıyor.',
      'Gizli fırsatları keşfet. Derin analiz avantaj sağlıyor.',
    ],
    ZodiacSign.sagittarius: [
      'Uluslararasi bağlantılar ve egitim alaninda gelismeler var.',
      'Genisleme fırsatları. Yeni pazarlar, yeni ufuklar.',
    ],
    ZodiacSign.capricorn: [
      'Kariyer gelişimi temaları öne çıkıyor. Disiplin üzerine düşünebilirsin.',
      'Yoneticilik ve otorite pozisyonları için mükemmel zaman.',
    ],
    ZodiacSign.aquarius: [
      'Teknoloji ve yenilik projeleri parliyor. Icat et, yenile.',
      'Sıra dışı fikirlerin deger kazaniyor. Vizyoner ol.',
    ],
    ZodiacSign.pisces: [
      'Yaratıcı ve spirituel alanlarda kariyer fırsatları var.',
      'Sezgisel karar temaları öne çıkıyor. İç sesini dinlemeyi düşün.',
    ],
  };

  static final Map<ZodiacSign, List<String>> _localHealthAdvice = {
    ZodiacSign.aries: [
      'Fiziksel aktivite enerjini dengele. Yogun sporlar faydali.',
      'Sabırsizligini yatistir. Nefes calismalari ve meditasyon onerilir.',
    ],
    ZodiacSign.taurus: [
      'Duyusal keyiflerle kendini simart. Spa ve masaj şifa verir.',
      'Beslenmeye dikkat et. Dogal, topraklanmis yiyecekler sec.',
    ],
    ZodiacSign.gemini: [
      'Zihinsel detoks zamanı. Bilgi bombardimanindan uzaklas.',
      'Hareket et! Yuruyus ve hafif egzersizler faydali.',
    ],
    ZodiacSign.cancer: [
      'Duygusal arınma günü. Gözyaşları şifa verir.',
      'Su terapisi ve deniz tuzu banyolari onerilir.',
    ],
    ZodiacSign.leo: [
      'Kalp sagligina dikkat. Kardiyovaskuler egzersizler faydali.',
      'Yaratıcı ifade enerjini dengeler. Dans et, ozgurce hareket et.',
    ],
    ZodiacSign.virgo: [
      'Detoks ve arınma rituelleri şifa verir.',
      'Mukemmeliyetciligi bırak, stresi azalt. Dinlen.',
    ],
    ZodiacSign.libra: [
      'Denge calismalari önemli. Yoga ve pilates onerilir.',
      'Güzellik rituelleri ruhunu besliyor. Kendine zaman ayir.',
    ],
    ZodiacSign.scorpio: [
      'Derin dönüşüm ve şifa calismalari faydali.',
      'Golge calismasi ve meditasyon gucunu artirir.',
    ],
    ZodiacSign.sagittarius: [
      'Hareket ve macera sart! Dogada vakit geçir.',
      'Kalca ve bacak sagligina dikkat. Stretching önemli.',
    ],
    ZodiacSign.capricorn: [
      'Kemik ve eklem sagligina dikkat et.',
      'Dinlenme ve rejenerasyon zamanı. Asiri calismaktan kaçın.',
    ],
    ZodiacSign.aquarius: [
      'Sinir sistemi dengelemesi gerekli. Teknolojiden uzaklas.',
      'Sosyal aktiviteler ruh sagligini destekler.',
    ],
    ZodiacSign.pisces: [
      'Su elementleriyle şifa bul. Yuzme ve banyo rituelleri onerilir.',
      'Rüya calismasi ve uyku kalitesine dikkat et.',
    ],
  };
}

/// Personalized reflection content model
/// This content is for self-reflection and personal growth only.
class PersonalizedHoroscope {
  final ZodiacSign sign;
  final String summary;
  final String loveAdvice;
  final String careerAdvice;
  final String healthAdvice;
  final String focusNumber;
  final String reflectionColor;
  final String mood;
  final bool isAiGenerated;

  PersonalizedHoroscope({
    required this.sign,
    required this.summary,
    required this.loveAdvice,
    required this.careerAdvice,
    required this.healthAdvice,
    required this.focusNumber,
    required this.reflectionColor,
    required this.mood,
    this.isAiGenerated = false,
  });
}

/// Advice areas
enum AdviceArea { love, career, health, money, spiritual }

/// Dream interpretation conversation state
enum DreamConversationState {
  initial, // User just shared a dream
  awaitingContext, // Waiting for context answers
  interpreted, // Interpretation provided
}

/// Dream interpretation session
class DreamInterpretationSession {
  final String dreamSymbol;
  final List<String> contextQuestions;
  final Map<String, String> contextAnswers;
  final String? interpretation;
  final DreamConversationState state;
  final DateTime createdAt;

  DreamInterpretationSession({
    required this.dreamSymbol,
    this.contextQuestions = const [],
    this.contextAnswers = const {},
    this.interpretation,
    this.state = DreamConversationState.initial,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  DreamInterpretationSession copyWith({
    String? dreamSymbol,
    List<String>? contextQuestions,
    Map<String, String>? contextAnswers,
    String? interpretation,
    DreamConversationState? state,
  }) {
    return DreamInterpretationSession(
      dreamSymbol: dreamSymbol ?? this.dreamSymbol,
      contextQuestions: contextQuestions ?? this.contextQuestions,
      contextAnswers: contextAnswers ?? this.contextAnswers,
      interpretation: interpretation ?? this.interpretation,
      state: state ?? this.state,
      createdAt: createdAt,
    );
  }
}

/// Cache helper class
class _CachedContent {
  final dynamic content;
  final DateTime createdAt;

  _CachedContent(this.content) : createdAt = DateTime.now();

  bool get isExpired =>
      DateTime.now().difference(createdAt) > AiContentService._cacheDuration;
}

/// AI Content Service Provider
final aiContentServiceProvider = Provider<AiContentService>((ref) {
  final analytics = ref.watch(analyticsServiceProvider);
  final service = AiContentService();
  service.initialize(analytics: analytics);
  return service;
});
