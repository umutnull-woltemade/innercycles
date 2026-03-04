/// Dream Interpretation Service - 7-Dimensional Dream Interpretation Engine
/// Ancient wisdom + Jungian analysis + timing awareness
library;

import 'dart:math';
import 'package:uuid/uuid.dart';
import '../../core/constants/routes.dart';
import '../models/dream_interpretation_models.dart';
import '../content/dream_symbols_database.dart';
import '../content/dream_content_expanded.dart';
import '../content/dream_advanced_content.dart';
import '../providers/app_providers.dart';
import 'dream_memory_service.dart';
import 'l10n_service.dart';
import 'moon_phase_service.dart' as lunar;

/// Ana rüya yorumlama servisi
class DreamInterpretationService {
  final DreamMemoryService? memoryService;

  DreamInterpretationService({this.memoryService});

  /// Tam 7 boyutlu rüya yorumu oluştur (AI çıktısından)
  FullDreamInterpretation parseAIResponse(
    String dreamText,
    Map<String, dynamic> aiResponse,
    MoonPhase currentMoonPhase, {
    String? userId,
  }) {
    return FullDreamInterpretation(
      dreamId: const Uuid().v4(),
      oderId: userId ?? 'anonymous',
      dreamText: dreamText,
      interpretedAt: DateTime.now(),
      ancientIntro: aiResponse['ancientIntro'] ?? _generateKadimGiris(),
      coreMessage: aiResponse['coreMessage'] ?? '',
      symbols: (aiResponse['symbols'] as List? ?? [])
          .map((s) => SymbolInterpretation.fromJson(s))
          .toList(),
      archetypeConnection: aiResponse['archetypeConnection'] ?? '',
      archetypeName: aiResponse['archetypeName'] ?? 'Gölge',
      emotionalReading: aiResponse['emotionalReading'] != null
          ? EmotionalReading.fromJson(aiResponse['emotionalReading'])
          : _defaultEmotionalReading(),
      dreamTiming: DreamTiming(
        moonPhase: currentMoonPhase,
        emotionalTone: aiResponse['emotionalTone'],
        currentTheme: aiResponse['currentTheme'],
        timingMessage:
            aiResponse['timingMessage'] ??
            _getMoonPhaseMessage(currentMoonPhase),
        whyNow:
            aiResponse['whyNow'] ??
            L10nService.get(
              'dream_interpretation.why_now_simple',
              AppLanguage.tr,
            ),
        isIntense: aiResponse['isIntense'] ?? false,
      ),
      lightShadow: aiResponse['lightShadow'] != null
          ? LightShadowReading.fromJson(aiResponse['lightShadow'])
          : _defaultLightShadow(),
      guidance: aiResponse['guidance'] != null
          ? PracticalGuidance.fromJson(aiResponse['guidance'])
          : _defaultGuidance(),
      whisperQuote: aiResponse['whisperQuote'] ?? _generateWhisperQuote(),
      shareCard: aiResponse['shareCard'] != null
          ? ShareableCard.fromJson(aiResponse['shareCard'])
          : ShareableQuoteTemplates.getRandomQuote(),
      explorationLinks: _generateExplorationLinks(
        (aiResponse['symbols'] as List? ?? [])
            .map((s) => s['symbol'] as String? ?? '')
            .toList(),
      ),
      userRole: _parseRole(aiResponse['userRole']),
      timeLayer: _parseTimeLayer(aiResponse['timeLayer']),
      isRecurring: aiResponse['isRecurring'] ?? false,
      recurringCount: aiResponse['recurringCount'],
    );
  }

  /// Hızlı sembol tabanlı yorum (AI olmadan, yerel veritabanından)
  FullDreamInterpretation generateLocalInterpretation(
    DreamInput input,
    MoonPhase currentMoonPhase, {
    String? userId,
  }) {
    // Sembolleri tespit et
    final detectedSymbols = DreamSymbolsDatabase.detectSymbolsInText(
      input.dreamDescription,
    );

    // Dominant duyguyı belirle
    final dominantEmotion = input.dominantEmotion ?? EmotionalTone.merak;

    // Her sembol için yorum oluştur
    final symbolInterpretations = detectedSymbols.map((symbolData) {
      return SymbolInterpretation(
        symbol: symbolData.symbolTr,
        symbolEmoji: symbolData.emoji,
        universalMeaning: symbolData.universalMeanings.isNotEmpty
            ? symbolData.universalMeanings.first
            : symbolData.symbolTr,
        personalContext:
            symbolData.emotionVariants[dominantEmotion] ??
            (symbolData.universalMeanings.isNotEmpty
                ? symbolData.universalMeanings.first
                : symbolData.symbolTr),
        shadowAspect: symbolData.shadowAspect,
        lightAspect: symbolData.lightAspect,
        relatedSymbols: symbolData.relatedSymbols,
      );
    }).toList();

    // Arketip bağlantısı
    final archetype = _detectDominantArchetype(
      detectedSymbols,
      dominantEmotion,
    );
    final archetypeData = ArchetypeDatabase.findArchetype(archetype);

    // Zaman katmanı
    final timeLayer = input.isRecurring
        ? TimeLayer.dongusel
        : _inferTimeLayer(input);

    // Rol
    final role = input.perceivedRole ?? _inferRole(input.dreamDescription);

    return FullDreamInterpretation(
      dreamId: const Uuid().v4(),
      oderId: userId ?? 'anonymous',
      dreamText: input.dreamDescription,
      interpretedAt: DateTime.now(),
      ancientIntro: _generateKadimGiris(
        moonPhase: currentMoonPhase,
        emotion: dominantEmotion,
        symbolCategory: detectedSymbols.isNotEmpty
            ? detectedSymbols.first.category
            : null,
      ),
      coreMessage: _generateCoreMessage(
        detectedSymbols,
        dominantEmotion,
        timeLayer,
        currentMoonPhase,
      ),
      symbols: symbolInterpretations,
      archetypeConnection:
          archetypeData?.description ??
          L10nService.get(
            'dream_interpretation.archetype_fallback',
            AppLanguage.tr,
          ),
      archetypeName: archetypeData?.nameTr ?? archetype,
      emotionalReading: EmotionalReading(
        dominantEmotion: dominantEmotion,
        surfaceMessage: _getSurfaceMessage(dominantEmotion),
        deeperMeaning: _getDeeperMeaning(dominantEmotion),
        shadowQuestion: _getShadowQuestion(dominantEmotion),
        integrationPath: _getIntegrationPath(dominantEmotion),
      ),
      dreamTiming: DreamTiming(
        moonPhase: currentMoonPhase,
        timingMessage: _getMoonPhaseMessage(currentMoonPhase),
        whyNow: _getWhyNowMessage(currentMoonPhase, timeLayer),
      ),
      lightShadow: LightShadowReading(
        lightMessage: _generateLightMessage(detectedSymbols),
        shadowMessage: _generateShadowMessage(detectedSymbols),
        integrationPath: _generateIntegrationPath(archetype),
        archetype: archetype,
      ),
      guidance: PracticalGuidance(
        todayAction: _generateTodayAction(detectedSymbols, dominantEmotion),
        reflectionQuestion: _generateReflectionQuestion(detectedSymbols),
        weeklyFocus: _generateWeeklyFocus(archetype, currentMoonPhase),
        avoidance: _generateAvoidance(dominantEmotion),
      ),
      whisperQuote: _generateWhisperQuote(),
      shareCard: ShareableQuoteTemplates.getQuoteForEmotion(dominantEmotion),
      explorationLinks: _generateExplorationLinks(
        detectedSymbols.map((s) => s.symbol).toList(),
      ),
      userRole: role,
      timeLayer: timeLayer,
      isRecurring: input.isRecurring,
      recurringCount: input.recurringCount,
      recurringPattern: input.isRecurring
          ? RecurringDreamAnalyzer.detectPattern(input.dreamDescription)?.title
          : null,
      nightmareType: _detectNightmare(input.dreamDescription),
      lucidPotential: _calculateLucidPotential(
        dominantEmotion,
        currentMoonPhase,
      ),
    );
  }

  /// Kâbus tipi tespit et
  String? _detectNightmare(String dreamText) {
    final nightmare = NightmareTransformationService.detectNightmareType(
      dreamText,
    );
    return nightmare?.title;
  }

  /// Lucid potansiyeli hesapla
  String _calculateLucidPotential(EmotionalTone emotion, MoonPhase phase) {
    // Dolunay en yüksek potansiyel
    int score = 0;

    switch (phase) {
      case MoonPhase.dolunay:
        score += 3;
        break;
      case MoonPhase.ilkDordun:
        score += 2;
        break;
      case MoonPhase.hilal:
      case MoonPhase.sonDordun:
        score += 1;
        break;
      default:
        break;
    }

    // Merak ve heyecan lucid'i artırır
    if (emotion == EmotionalTone.merak || emotion == EmotionalTone.heyecan) {
      score += 2;
    } else if (emotion == EmotionalTone.huzur) {
      score += 1;
    }

    if (score >= 4)
      return L10nService.get(
        'dream_interpretation.lucid_potential.very_high',
        AppLanguage.tr,
      );
    if (score >= 3)
      return L10nService.get(
        'dream_interpretation.lucid_potential.high',
        AppLanguage.tr,
      );
    if (score >= 2)
      return L10nService.get(
        'dream_interpretation.lucid_potential.medium',
        AppLanguage.tr,
      );
    return L10nService.get(
      'dream_interpretation.lucid_potential.low',
      AppLanguage.tr,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // AI PROMPT GENERATOR
  // ═══════════════════════════════════════════════════════════════

  /// AI için detaylı prompt oluştur
  String generateAIPrompt(DreamInput input, MoonPhase moonPhase) {
    final detectedSymbols = DreamSymbolsDatabase.detectSymbolsInText(
      input.dreamDescription,
    );

    return '''
SEN: Modern rüya analisti. Jung, Campbell ve derinlik psikolojisinin bakış açısıyla rüyaları 7 boyutta analiz eder, şiirsel ama derin içgörüler sunarsın.

KULLANICI RÜYASI:
"${input.dreamDescription}"

ALGILANAN DUYGUSAL TON: ${input.dominantEmotion?.label ?? 'Belirtilmedi'}
UYANDIKTAN SONRAKİ HİS: ${input.wakingFeeling ?? 'Belirtilmedi'}
TEKRARLAYAN MI: ${input.isRecurring ? 'Evet (${input.recurringCount ?? '?'} kez)' : 'Hayır'}
AY FAZI: ${moonPhase.label} ${moonPhase.emoji}
TESPİT EDİLEN SEMBOLLER: ${detectedSymbols.map((s) => '${s.emoji} ${s.symbolTr}').join(', ')}

7 BOYUTLU ANALİZ FORMATI:

1. KADİM GİRİŞ (3-4 cümle, mitolojik/şiirsel):
Rüyanın evrensel bağlamını anlat. "Kadim bilgeler derler ki..." veya "Binlerce yıldır rüya okuyucuları..." gibi başla.

2. ANA MESAJ (2-3 cümle):
Bu rüya tek bir cümleyle ne söylüyor? Doğrudan ve güçlü.

3. SEMBOL ANALİZİ (her sembol için):
- Evrensel anlam
- Bu rüyadaki kişisel bağlam
- Gölge yönü
- Işık yönü

4. ARKETİP BAĞLANTISI:
Hangi Jungian arketip aktif? (Gölge, Anima/Animus, Bilge Yaşlı, Kahraman, vs.)
Bu arketipin şu anki mesajı ne?

5. DUYGUSAL OKUMA:
- Yüzey mesajı (ilk his)
- Derin anlam (altta yatan)
- Gölge sorusu (sormaktan kaçınılan)
- Entegrasyon yolu

6. TIMING AWARENESS:
- Why might this dream have come NOW?
- Seasonal or life-stage reflection
- Timing insight message

7. IŞIK/GÖLGE:
- Işık mesajı (olumlu potansiyel)
- Gölge mesajı (farkındalık gerektiren)
- Entegrasyon yolu

8. PRATİK REHBERLİK:
- Bugün ne yap?
- Bu hafta neye odaklan?
- Neden kaçın?
- Yansıtma sorusu

9. FISILDAYAN CÜMLE:
Tek bir aforizma. Paylaşılabilir. Hafızada kalıcı.

10. VİRAL KART:
Emoji + 10-15 kelimelik etkileyici alıntı

KURALLAR:
- ASLA tıbbi/psikolojik teşhis koyma
- Ezotetik ama bilimsel görünme
- Her yorumu kişiselleştir
- Şiirsel ama pratik ol
- Türkçe zengin, akıcı, derin

JSON FORMATI:
{
  "ancientIntro": "...",
  "coreMessage": "...",
  "symbols": [
    {
      "symbol": "...",
      "symbolEmoji": "...",
      "universalMeaning": "...",
      "personalContext": "...",
      "shadowAspect": "...",
      "lightAspect": "..."
    }
  ],
  "archetypeName": "...",
  "archetypeConnection": "...",
  "emotionalReading": {
    "dominantEmotion": "korku|huzur|merak|sucluluk|ozlem|heyecan|donukluk|ofke",
    "surfaceMessage": "...",
    "deeperMeaning": "...",
    "shadowQuestion": "...",
    "integrationPath": "..."
  },
  "timingMessage": "...",
  "whyNow": "...",
  "lightShadow": {
    "lightMessage": "...",
    "shadowMessage": "...",
    "integrationPath": "...",
    "archetype": "..."
  },
  "guidance": {
    "todayAction": "...",
    "reflectionQuestion": "...",
    "weeklyFocus": "...",
    "avoidance": "..."
  },
  "whisperQuote": "...",
  "shareCard": {
    "emoji": "...",
    "quote": "...",
    "category": "..."
  },
  "userRole": "izleyici|kahraman|kacan|arayan|saklanan|kurtarici|kurban",
  "timeLayer": "gecmis|simdi|gelecek|dongusel"
}
''';
  }

  // ═══════════════════════════════════════════════════════════════
  // YARDIMCI FONKSİYONLAR
  // ═══════════════════════════════════════════════════════════════

  String _generateKadimGiris({
    MoonPhase? moonPhase,
    SymbolCategory? symbolCategory,
    EmotionalTone? emotion,
  }) {
    // KadimGirisTemplates.rastgeleSecim kullan
    return KadimGirisTemplates.rastgeleSecim(
      ayFazi: moonPhase,
      kategori: symbolCategory,
      duygu: emotion,
    );
  }

  String _generateCoreMessage(
    List<DreamSymbolData> symbols,
    EmotionalTone emotion,
    TimeLayer timeLayer,
    MoonPhase moonPhase, {
    AppLanguage language = AppLanguage.tr,
  }) {
    if (symbols.isEmpty) {
      final key = 'dream_interpretation.core_message.empty';
      final localized = L10nService.get(key, language);
      return localized != key
          ? localized
          : 'Your subconscious is speaking directly to you without symbols. There is an emotional message at the core of this dream.';
    }

    final mainSymbol = symbols.first;
    final symbolName = language == AppLanguage.tr
        ? mainSymbol.symbolTr
        : mainSymbol.symbol;
    final timeMessage = _getTimeLayerMessage(timeLayer, language: language);
    final emotionMessage = emotion.hint;

    final key = 'dream_interpretation.core_message.with_symbol';
    final localized = L10nService.get(key, language);
    final template = localized != key
        ? localized
        : '{emoji} The {symbol} symbol is the main messenger of your subconscious. {timeMessage} {emotionMessage} {moonMeaning}';
    return template
        .replaceAll('{emoji}', mainSymbol.emoji)
        .replaceAll('{symbol}', symbolName)
        .replaceAll('{timeMessage}', timeMessage)
        .replaceAll('{emotionMessage}', emotionMessage)
        .replaceAll('{moonMeaning}', moonPhase.meaning);
  }

  String _getTimeLayerMessage(
    TimeLayer layer, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final key = 'dream_interpretation.time_layers.${layer.name}';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;

    // English fallback
    switch (layer) {
      case TimeLayer.gecmis:
        return 'This dream carries unfinished business from the past.';
      case TimeLayer.simdi:
        return 'This dream reflects a situation in your current life.';
      case TimeLayer.gelecek:
        return 'This dream may reflect an approaching change in your life.';
      case TimeLayer.dongusel:
        return 'This recurring pattern points to a cycle that needs to be broken.';
    }
  }

  String _getMoonPhaseMessage(MoonPhase phase) {
    // Gelişmiş ay fazı detaylarını kullan
    final phaseKey = _getMoonPhaseKey(phase);
    final phaseDetail = PsikolojikRuyaTemalari.uykuDongusuNotlari[phaseKey];

    if (phaseDetail != null) {
      return '${phaseDetail.emoji} ${phaseDetail.phase}: ${phaseDetail.dreamQuality}. '
          '${phaseDetail.advice}';
    }

    // Fallback with localization support
    String getLocalizedPhaseMessage(
      String phaseKey,
      String fallback, {
      AppLanguage language = AppLanguage.tr,
    }) {
      final key = 'dream_interpretation.moon_phases.$phaseKey';
      final localized = L10nService.get(key, language);
      return localized != key ? localized : fallback;
    }

    switch (phase) {
      case MoonPhase.yeniay:
        return getLocalizedPhaseMessage(
          'new_moon',
          'You may find this is a good time for setting new intentions. Consider what you want to invite in.',
        );
      case MoonPhase.hilal:
        return getLocalizedPhaseMessage(
          'crescent',
          'This may be a time of growing clarity. Move forward with courage.',
        );
      case MoonPhase.ilkDordun:
        return getLocalizedPhaseMessage(
          'first_quarter',
          'You may notice a decision point emerging. Consider the two paths before you.',
        );
      case MoonPhase.dolunay:
        return getLocalizedPhaseMessage(
          'full_moon',
          'You may find heightened awareness right now. Accept what you see with openness.',
        );
      case MoonPhase.sonDordun:
        return getLocalizedPhaseMessage(
          'last_quarter',
          'You may find it helpful to let go of something. What do you need to release?',
        );
      case MoonPhase.karanlikAy:
        return getLocalizedPhaseMessage(
          'dark_moon',
          'This may be a time for rest and deep reflection. Listen to your inner voice.',
        );
    }
  }

  String _getMoonPhaseKey(MoonPhase phase) {
    switch (phase) {
      case MoonPhase.yeniay:
        return 'derinUyku';
      case MoonPhase.hilal:
        return 'hafifUyku';
      case MoonPhase.ilkDordun:
        return 'remBaslangic';
      case MoonPhase.dolunay:
        return 'remDoruk';
      case MoonPhase.sonDordun:
        return 'uyanmaOncesi';
      case MoonPhase.karanlikAy:
        return 'derinDinlenme';
    }
  }

  String _getWhyNowMessage(
    MoonPhase phase,
    TimeLayer layer, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final phaseContext = phase.meaning;
    final layerContext = layer.meaning;
    final key = 'dream_interpretation.why_now';
    final localized = L10nService.get(key, language);
    final template = localized != key
        ? localized
        : 'This dream may have surfaced now because {phaseContext} and {layerContext} Your mind tends to process what matters most at the right time.';
    return template
        .replaceAll('{phaseContext}', phaseContext)
        .replaceAll('{layerContext}', layerContext);
  }

  String _detectDominantArchetype(
    List<DreamSymbolData> symbols,
    EmotionalTone emotion,
  ) {
    // Sembol arketiplerini say
    final archetypeCounts = <String, int>{};
    for (final symbol in symbols) {
      for (final archetype in symbol.archetypes) {
        archetypeCounts[archetype] = (archetypeCounts[archetype] ?? 0) + 1;
      }
    }

    // Duygu bazlı ağırlık ekle
    if (emotion == EmotionalTone.korku) {
      archetypeCounts['Gölge'] = (archetypeCounts['Gölge'] ?? 0) + 2;
    } else if (emotion == EmotionalTone.ozlem) {
      archetypeCounts['Anima'] = (archetypeCounts['Anima'] ?? 0) + 2;
      archetypeCounts['Animus'] = (archetypeCounts['Animus'] ?? 0) + 2;
    } else if (emotion == EmotionalTone.heyecan) {
      archetypeCounts['Kahraman'] = (archetypeCounts['Kahraman'] ?? 0) + 2;
    }

    if (archetypeCounts.isEmpty) return 'Gölge';

    return archetypeCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  TimeLayer _inferTimeLayer(DreamInput input) {
    final text = input.dreamDescription.toLowerCase();

    if (text.contains('çocukluğumda') ||
        text.contains('eskiden') ||
        text.contains('eski evim') ||
        text.contains('annem') ||
        text.contains('babam')) {
      return TimeLayer.gecmis;
    }

    if (text.contains('yarın') ||
        text.contains('gelecekte') ||
        text.contains('olacak')) {
      return TimeLayer.gelecek;
    }

    if (input.isRecurring) {
      return TimeLayer.dongusel;
    }

    return TimeLayer.simdi;
  }

  DreamRole _inferRole(String dreamText) {
    final text = dreamText.toLowerCase();

    if (text.contains('kaçıyordum') ||
        text.contains('kovalıyordu') ||
        text.contains('kaçtım')) {
      return DreamRole.kacan;
    }

    if (text.contains('izliyordum') ||
        text.contains('seyrediyordum') ||
        text.contains('gözlemliyordum')) {
      return DreamRole.izleyici;
    }

    if (text.contains('arıyordum') ||
        text.contains('bulamadım') ||
        text.contains('kayboldum')) {
      return DreamRole.arayan;
    }

    if (text.contains('kurtardım') || text.contains('yardım ettim')) {
      return DreamRole.kurtarici;
    }

    if (text.contains('saklanıyordum') || text.contains('gizleniyordum')) {
      return DreamRole.saklanan;
    }

    return DreamRole.kahraman;
  }

  // Duygusal okuma yardımcıları
  String _getSurfaceMessage(
    EmotionalTone tone, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final key = 'dream_interpretation.surface_messages.${tone.name}';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;

    // English fallback
    final fallbacks = {
      EmotionalTone.korku:
          'An alarm is sounding on the surface - there is a threat getting your attention.',
      EmotionalTone.huzur:
          'You feel a balance in your inner world - this is valuable.',
      EmotionalTone.merak:
          'The urge to explore is active - questions are more important than answers.',
      EmotionalTone.sucluluk: 'Something feels wrong - but is it really?',
      EmotionalTone.ozlem:
          'There is an emptiness in your heart - needing to be filled.',
      EmotionalTone.heyecan:
          'Energy is rising - something new is on the horizon.',
      EmotionalTone.donukluk:
          'Emotions are temporarily muted - a protection mechanism.',
      EmotionalTone.ofke:
          'Boundaries have been pushed - power wants to be reclaimed.',
    };
    return fallbacks[tone] ?? fallbacks.values.first;
  }

  String _getDeeperMeaning(
    EmotionalTone tone, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final key = 'dream_interpretation.deeper_meanings.${tone.name}';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;

    // English fallback
    final fallbacks = {
      EmotionalTone.korku:
          'Beneath fear there is usually love. What are you afraid of losing?',
      EmotionalTone.huzur:
          'This peace signals conflict resolved. Which inner war has ended?',
      EmotionalTone.merak:
          'Curiosity is the mind\'s call to grow. You are ready to open to the unknown.',
      EmotionalTone.sucluluk:
          'Guilt is sometimes internalizing others\' voices. Whose voice is this?',
      EmotionalTone.ozlem:
          'Longing is the desire to return to lost wholeness. When did you feel whole?',
      EmotionalTone.heyecan:
          'Excitement is the peak of life energy. Where will you direct this energy?',
      EmotionalTone.donukluk:
          'Numbness is protection from feeling too much. What are you avoiding feeling?',
      EmotionalTone.ofke:
          'Anger is the voice of suppressed power. Where do you want your power back?',
    };
    return fallbacks[tone] ?? fallbacks.values.first;
  }

  String _getShadowQuestion(
    EmotionalTone tone, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final key = 'dream_interpretation.shadow_questions.${tone.name}';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;

    // English fallback
    final fallbacks = {
      EmotionalTone.korku: 'What would happen if what you fear came true?',
      EmotionalTone.huzur: 'Which thought sabotages this peace?',
      EmotionalTone.merak:
          'What question are you afraid to find the answer to?',
      EmotionalTone.sucluluk: 'What would change if you forgave yourself?',
      EmotionalTone.ozlem:
          'If what you long for returned, could you accept it?',
      EmotionalTone.heyecan: 'What remains when this excitement fades?',
      EmotionalTone.donukluk: 'If you were to feel, what would you feel?',
      EmotionalTone.ofke: 'What pain lies beneath the anger?',
    };
    return fallbacks[tone] ?? fallbacks.values.first;
  }

  String _getIntegrationPath(
    EmotionalTone tone, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final key = 'dream_interpretation.integration_paths.${tone.name}';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;

    // English fallback
    final fallbacks = {
      EmotionalTone.korku:
          'Face your fear, but be gentle. Approach what you fear in small steps.',
      EmotionalTone.huzur:
          'Remember this peace and carry it into daily life. Reinforce with meditation.',
      EmotionalTone.merak:
          'Write down your questions, learn to live with questions rather than seeking answers.',
      EmotionalTone.sucluluk:
          'Examine the guilt: is it real or learned? Write a letter to yourself.',
      EmotionalTone.ozlem:
          'Honor the longing but stay present. Accepting loss opens doors to the future.',
      EmotionalTone.heyecan:
          'Channel excitement into action. Take a step today.',
      EmotionalTone.donukluk:
          'Return to your body. Move, breathe, slowly begin to feel.',
      EmotionalTone.ofke:
          'Express anger healthily: sports, writing, creativity. But don\'t hurt anyone.',
    };
    return fallbacks[tone] ?? fallbacks.values.first;
  }

  // Işık/Gölge mesajları
  String _generateLightMessage(
    List<DreamSymbolData> symbols, {
    AppLanguage language = AppLanguage.tr,
  }) {
    if (symbols.isEmpty) {
      final key = 'dream_interpretation.light_shadow.empty_light';
      final localized = L10nService.get(key, language);
      return localized != key
          ? localized
          : 'This dream comes from a clean and bright area of your inner world.';
    }
    final lightAspects = symbols.map((s) => s.lightAspect).take(2).join(' ');
    final key = 'dream_interpretation.light_shadow.light_aspect';
    final localized = L10nService.get(key, language);
    final template = localized != key
        ? localized
        : 'Light aspect: {aspects} Embrace this potential.';
    return template.replaceAll('{aspects}', lightAspects);
  }

  String _generateShadowMessage(
    List<DreamSymbolData> symbols, {
    AppLanguage language = AppLanguage.tr,
  }) {
    if (symbols.isEmpty) {
      final key = 'dream_interpretation.light_shadow.empty_shadow';
      final localized = L10nService.get(key, language);
      return localized != key
          ? localized
          : 'Shadow is always there, but in this dream it waits gently.';
    }
    final shadowAspects = symbols.map((s) => s.shadowAspect).take(2).join(' ');
    final key = 'dream_interpretation.light_shadow.shadow_aspect';
    final localized = L10nService.get(key, language);
    final template = localized != key
        ? localized
        : 'Shadow warning: {aspects} Be aware, but don\'t fear.';
    return template.replaceAll('{aspects}', shadowAspects);
  }

  String _generateIntegrationPath(
    String archetype, {
    AppLanguage language = AppLanguage.tr,
  }) {
    // Map Turkish archetype names to English keys
    final archetypeKeyMap = {
      'Gölge': 'shadow',
      'Anima': 'anima',
      'Animus': 'animus',
      'Kahraman': 'hero',
      'Bilge Yaşlı': 'wise_old',
      'Büyük Anne': 'great_mother',
      'Düzenbaz': 'trickster',
      'Çocuk': 'child',
    };

    final archetypeKey =
        archetypeKeyMap[archetype] ??
        archetype.toLowerCase().replaceAll(' ', '_');
    final key = 'dream_interpretation.archetype_integration.$archetypeKey';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;

    // English fallback
    final fallbacks = {
      'Gölge':
          'Befriend the Shadow. Recognize and accept the parts you reject.',
      'Anima': 'Honor the feminine wisdom within. Trust your intuition.',
      'Animus':
          'Use the masculine power within you in balance. Be decisive but gentle.',
      'Kahraman': 'Your courage is valuable but don\'t forget humility.',
      'Bilge Yaşlı': 'Share your wisdom but stay open to learning.',
      'Büyük Anne':
          'Direct your nurturing capacity to both yourself and others.',
      'Düzenbaz': 'Use your playfulness creatively, not destructively.',
      'Çocuk':
          'Maintain your connection with your inner child, nurture your curiosity.',
    };
    return fallbacks[archetype] ??
        'Recognize this archetype and integrate it into daily life.';
  }

  // Pratik rehberlik
  String _generateTodayAction(
    List<DreamSymbolData> symbols,
    EmotionalTone emotion, {
    AppLanguage language = AppLanguage.tr,
  }) {
    if (emotion == EmotionalTone.korku) {
      final key = 'dream_interpretation.today_action.fear';
      final localized = L10nService.get(key, language);
      return localized != key
          ? localized
          : 'Today, take a small step toward something you fear.';
    }
    if (emotion == EmotionalTone.ozlem) {
      final key = 'dream_interpretation.today_action.longing';
      final localized = L10nService.get(key, language);
      return localized != key
          ? localized
          : 'Today, write a memory about the person/situation you long for.';
    }
    if (symbols.isNotEmpty) {
      final symbolName = language == AppLanguage.tr
          ? symbols.first.symbolTr
          : symbols.first.symbol;
      final key = 'dream_interpretation.today_action.symbol';
      final localized = L10nService.get(key, language);
      final template = localized != key
          ? localized
          : 'Today, spend 5 minutes thinking about the {symbol} symbol.';
      return template.replaceAll('{symbol}', symbolName);
    }
    final key = 'dream_interpretation.today_action.default';
    final localized = L10nService.get(key, language);
    return localized != key
        ? localized
        : 'Today, write this dream in a journal and record your feelings.';
  }

  String _generateReflectionQuestion(
    List<DreamSymbolData> symbols, {
    AppLanguage language = AppLanguage.tr,
  }) {
    if (symbols.isEmpty) {
      final key = 'dream_interpretation.reflection.empty';
      final localized = L10nService.get(key, language);
      return localized != key
          ? localized
          : 'What is this dream trying to tell me?';
    }
    final symbolName = language == AppLanguage.tr
        ? symbols.first.symbolTr
        : symbols.first.symbol;
    final key = 'dream_interpretation.reflection.symbol';
    final localized = L10nService.get(key, language);
    final template = localized != key
        ? localized
        : 'What does the {symbol} symbol represent in my life?';
    return template.replaceAll('{symbol}', symbolName);
  }

  String _generateWeeklyFocus(
    String archetype,
    MoonPhase phase, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final key = 'dream_interpretation.weekly_focus';
    final localized = L10nService.get(key, language);
    final template = localized != key
        ? localized
        : 'This week, focus on the {archetype} archetype\'s message. Use the {phase} energy.';
    return template
        .replaceAll('{archetype}', archetype)
        .replaceAll('{phase}', phase.label);
  }

  String _generateAvoidance(
    EmotionalTone emotion, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final key = 'dream_interpretation.avoidances.${emotion.name}';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;

    // English fallback
    final fallbacks = {
      EmotionalTone.korku:
          'This week, avoid impulsive decisions made to escape fear.',
      EmotionalTone.huzur:
          'Gently distance yourself from those who want to disturb your peace.',
      EmotionalTone.merak: 'Avoid impatience with unanswered questions.',
      EmotionalTone.sucluluk: 'Avoid judging yourself excessively.',
      EmotionalTone.ozlem: 'Avoid getting stuck in the past.',
      EmotionalTone.heyecan: 'Avoid scattering your energy, stay focused.',
      EmotionalTone.donukluk: 'Avoid normalizing numbness.',
      EmotionalTone.ofke: 'Avoid projecting anger onto others.',
    };
    return fallbacks[emotion] ?? fallbacks.values.first;
  }

  String _generateWhisperQuote({AppLanguage language = AppLanguage.tr}) {
    final index = Random().nextInt(6);
    final key = 'dream_interpretation.whisper_quotes.$index';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;

    // English fallback
    final fallbacks = [
      'The night spoke for you, now you speak during the day.',
      'One who remembers dreams has begun to listen to their inner self.',
      'Every symbol is a key, every emotion a door.',
      'The subconscious doesn\'t lie, it just speaks in code.',
      'You can\'t escape your shadow, but you can dance with it.',
      'Ancient wisdom whispers, the one who hears in silence listens.',
    ];
    return fallbacks[index];
  }

  List<DreamExplorationLink> _generateExplorationLinks(
    List<String> symbols, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final links = <DreamExplorationLink>[
      DreamExplorationLink(
        title: L10nService.get(
          'dream_interpretation.exploration.personal_profile_title',
          language,
        ),
        description: L10nService.get(
          'dream_interpretation.exploration.personal_profile_desc',
          language,
        ),
        route: Routes.insight,
        emoji: '🗺️',
        category: L10nService.get(
          'dream_interpretation.exploration.category_self_awareness',
          language,
        ),
      ),
      // moonCalendar exploration link removed (killed feature)
      DreamExplorationLink(
        title: L10nService.get(
          'dream_interpretation.exploration.timing_insights_title',
          language,
        ),
        description: L10nService.get(
          'dream_interpretation.exploration.timing_insights_desc',
          language,
        ),
        route: Routes.insightsDiscovery,
        emoji: '🪐',
        category: L10nService.get(
          'dream_interpretation.exploration.category_self_awareness',
          language,
        ),
      ),
      DreamExplorationLink(
        title: L10nService.get(
          'dream_interpretation.exploration.journal_title',
          language,
        ),
        description: L10nService.get(
          'dream_interpretation.exploration.journal_desc',
          language,
        ),
        route: Routes.journal,
        emoji: '📝',
        category: L10nService.get(
          'dream_interpretation.exploration.category_symbols',
          language,
        ),
      ),
    ];

    // Add special links based on symbols
    if (symbols.contains('water') || symbols.contains('ocean')) {
      links.add(
        DreamExplorationLink(
          title: L10nService.get(
            'dream_interpretation.exploration.neptune_title',
            language,
          ),
          description: L10nService.get(
            'dream_interpretation.exploration.neptune_desc',
            language,
          ),
          route: Routes.insightsDiscovery,
          emoji: '🌊',
          category: L10nService.get(
            'dream_interpretation.exploration.category_self_awareness',
            language,
          ),
        ),
      );
    }

    if (symbols.contains('death') || symbols.contains('transformation')) {
      links.add(
        DreamExplorationLink(
          title: L10nService.get(
            'dream_interpretation.exploration.pluto_title',
            language,
          ),
          description: L10nService.get(
            'dream_interpretation.exploration.pluto_desc',
            language,
          ),
          route: Routes.insightsDiscovery,
          emoji: '🦋',
          category: L10nService.get(
            'dream_interpretation.exploration.category_self_awareness',
            language,
          ),
        ),
      );
    }

    return links.take(4).toList();
  }

  // Yardımcı parserlar
  DreamRole? _parseRole(String? role) {
    if (role == null) return null;
    return DreamRole.values.where((r) => r.name == role).firstOrNull;
  }

  TimeLayer? _parseTimeLayer(String? layer) {
    if (layer == null) return null;
    return TimeLayer.values.where((t) => t.name == layer).firstOrNull;
  }

  EmotionalReading _defaultEmotionalReading({
    AppLanguage language = AppLanguage.tr,
  }) {
    return EmotionalReading(
      dominantEmotion: EmotionalTone.merak,
      surfaceMessage: L10nService.get(
        'dream_interpretation.defaults.surface_message',
        language,
      ),
      deeperMeaning: L10nService.get(
        'dream_interpretation.defaults.deeper_meaning',
        language,
      ),
      shadowQuestion: L10nService.get(
        'dream_interpretation.defaults.shadow_question',
        language,
      ),
      integrationPath: L10nService.get(
        'dream_interpretation.defaults.integration_path',
        language,
      ),
    );
  }

  LightShadowReading _defaultLightShadow({
    AppLanguage language = AppLanguage.tr,
  }) {
    return LightShadowReading(
      lightMessage: L10nService.get(
        'dream_interpretation.defaults.light_message',
        language,
      ),
      shadowMessage: L10nService.get(
        'dream_interpretation.defaults.shadow_message',
        language,
      ),
      integrationPath: L10nService.get(
        'dream_interpretation.defaults.light_shadow_integration',
        language,
      ),
      archetype: L10nService.get(
        'dream_interpretation.defaults.archetype',
        language,
      ),
    );
  }

  PracticalGuidance _defaultGuidance({AppLanguage language = AppLanguage.tr}) {
    return PracticalGuidance(
      todayAction: L10nService.get(
        'dream_interpretation.defaults.today_action',
        language,
      ),
      reflectionQuestion: L10nService.get(
        'dream_interpretation.defaults.reflection_question',
        language,
      ),
      weeklyFocus: L10nService.get(
        'dream_interpretation.defaults.weekly_focus',
        language,
      ),
      avoidance: L10nService.get(
        'dream_interpretation.defaults.avoidance',
        language,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════
// TEKRARLAYAN RÜYA ANALİZİ
// ═══════════════════════════════════════════════════════════════

/// Tekrarlayan rüya kalıplarını analiz et
class RecurringDreamAnalyzer {
  /// Rüya metninden kalıp tespit et
  static RecurringDreamPattern? detectPattern(String dreamText) {
    final text = dreamText.toLowerCase();

    for (final pattern in TekrarlayanRuyaKaliplari.kaliplar) {
      for (final keyword in pattern.commonSymbols) {
        if (text.contains(keyword.toLowerCase())) {
          return pattern;
        }
      }
    }

    return null;
  }

  /// Tüm olası kalıpları kontrol et ve eşleşenleri döndür
  static List<RecurringDreamPattern> detectAllPatterns(String dreamText) {
    final text = dreamText.toLowerCase();
    final matchedPatterns = <RecurringDreamPattern>[];

    for (final pattern in TekrarlayanRuyaKaliplari.kaliplar) {
      for (final keyword in pattern.commonSymbols) {
        if (text.contains(keyword.toLowerCase())) {
          matchedPatterns.add(pattern);
          break;
        }
      }
    }

    return matchedPatterns;
  }

  /// Kalıp için kırma yöntemi öner
  static String getBreakingAdvice(RecurringDreamPattern pattern) {
    return pattern.breakingAdvice;
  }
}

// ═══════════════════════════════════════════════════════════════
// KÂBUS DÖNÜŞÜM SERVİSİ
// ═══════════════════════════════════════════════════════════════

/// Kâbusları şifa fırsatına dönüştürme
class NightmareTransformationService {
  /// Kâbus tipini tespit et
  static NightmareGuide? detectNightmareType(String dreamText) {
    final text = dreamText.toLowerCase();

    for (final nightmare in KabusDonusumRehberi.rehberler) {
      if (text.contains(nightmare.nightmareType.toLowerCase()) ||
          text.contains(nightmare.title.toLowerCase())) {
        return nightmare;
      }
    }

    return null;
  }

  /// Dönüşüm affirmasyonu
  static String getTransformationMessage(NightmareGuide nightmare) {
    return nightmare.transformationMessage;
  }

  /// Entegrasyon adımları
  static List<String> getIntegrationSteps(NightmareGuide nightmare) {
    return nightmare.integrationSteps;
  }

  /// Güçlendirme notu
  static String getEmpowermentNote(NightmareGuide nightmare) {
    return nightmare.empowermentNote;
  }
}

// ═══════════════════════════════════════════════════════════════
// AY FAZI HESAPLAMA
// ═══════════════════════════════════════════════════════════════

/// Ay fazı hesaplama yardımcısı — delegates to MoonPhaseService
class MoonPhaseCalculator {
  /// Verilen tarih için ay fazını hesapla
  static MoonPhase calculate(DateTime date) {
    final data = lunar.MoonPhaseService.calculate(date);
    switch (data.phase) {
      case lunar.MoonPhase.newMoon:
        return MoonPhase.yeniay;
      case lunar.MoonPhase.waxingCrescent:
        return MoonPhase.hilal;
      case lunar.MoonPhase.firstQuarter:
        return MoonPhase.ilkDordun;
      case lunar.MoonPhase.waxingGibbous:
        return MoonPhase.dolunay;
      case lunar.MoonPhase.fullMoon:
        return MoonPhase.dolunay;
      case lunar.MoonPhase.waningGibbous:
        return MoonPhase.sonDordun;
      case lunar.MoonPhase.lastQuarter:
        return MoonPhase.sonDordun;
      case lunar.MoonPhase.waningCrescent:
        return MoonPhase.karanlikAy;
    }
  }

  /// Bugünün ay fazı
  static MoonPhase get today => calculate(DateTime.now());
}
