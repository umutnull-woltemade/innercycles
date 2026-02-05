import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart' as zodiac;
import '../../../data/providers/app_providers.dart';
import '../../../data/services/ai_content_service.dart';
import '../../../data/services/l10n_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/entertainment_disclaimer.dart';
import '../../../shared/widgets/quiz_cta_card.dart';

/// Kozmik Iletisim - AI-Powered Dream Chatbot
/// Sohbet formatinda mistik ruya yorumlama deneyimi
class DreamInterpretationScreen extends ConsumerStatefulWidget {
  const DreamInterpretationScreen({super.key});

  @override
  ConsumerState<DreamInterpretationScreen> createState() =>
      _DreamInterpretationScreenState();
}

class _DreamInterpretationScreenState
    extends ConsumerState<DreamInterpretationScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _dreamController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  late AnimationController _pulseController;

  // APEX Dream Intelligence Engine State
  DreamInterpretationSession? _currentSession;
  int _currentQuestionIndex = 0;
  final Map<String, String> _contextAnswers = {};
  bool _awaitingAnswer = false;

  // Suggested dream prompts - i18n method
  List<Map<String, dynamic>> _getSuggestedDreamPrompts(AppLanguage language) {
    return [
      // Water & Nature dreams
      {'emoji': '🌊', 'text': L10nService.get('widgets.dreams.prompts.water_breathing', language), 'category': 'su'},
      {'emoji': '🌧️', 'text': L10nService.get('widgets.dreams.prompts.rain_running', language), 'category': 'su'},
      {'emoji': '🏊', 'text': L10nService.get('widgets.dreams.prompts.lake_diving', language), 'category': 'su'},
      {'emoji': '🌈', 'text': L10nService.get('widgets.dreams.prompts.waterfall_passage', language), 'category': 'su'},

      // Animal dreams
      {'emoji': '🐍', 'text': L10nService.get('widgets.dreams.prompts.snake_approaching', language), 'category': 'hayvan'},
      {'emoji': '🦅', 'text': L10nService.get('widgets.dreams.prompts.eagle_riding', language), 'category': 'hayvan'},
      {'emoji': '🐺', 'text': L10nService.get('widgets.dreams.prompts.wolf_pack', language), 'category': 'hayvan'},
      {'emoji': '🦋', 'text': L10nService.get('widgets.dreams.prompts.butterfly_transform', language), 'category': 'hayvan'},
      {'emoji': '🐱', 'text': L10nService.get('widgets.dreams.prompts.talking_cat', language), 'category': 'hayvan'},

      // Flying & Falling dreams
      {'emoji': '🦸', 'text': L10nService.get('widgets.dreams.prompts.flying_free', language), 'category': 'ucmak'},
      {'emoji': '⬇️', 'text': L10nService.get('widgets.dreams.prompts.falling_high', language), 'category': 'dusmek'},
      {'emoji': '🎈', 'text': L10nService.get('widgets.dreams.prompts.balloon_floating', language), 'category': 'ucmak'},
      {'emoji': '🪂', 'text': L10nService.get('widgets.dreams.prompts.parachute_fail', language), 'category': 'dusmek'},

      // Chase dreams
      {'emoji': '🏃', 'text': L10nService.get('widgets.dreams.prompts.running_stuck', language), 'category': 'kovalanmak'},
      {'emoji': '👤', 'text': L10nService.get('widgets.dreams.prompts.shadow_follower', language), 'category': 'kovalanmak'},
      {'emoji': '🚪', 'text': L10nService.get('widgets.dreams.prompts.corridor_doors', language), 'category': 'kovalanmak'},
      {'emoji': '🌑', 'text': L10nService.get('widgets.dreams.prompts.darkness_escape', language), 'category': 'kovalanmak'},

      // House & Place dreams
      {'emoji': '🏠', 'text': L10nService.get('widgets.dreams.prompts.secret_rooms', language), 'category': 'ev'},
      {'emoji': '🏚️', 'text': L10nService.get('widgets.dreams.prompts.childhood_home', language), 'category': 'ev'},
      {'emoji': '🏰', 'text': L10nService.get('widgets.dreams.prompts.palace_lost', language), 'category': 'ev'},
      {'emoji': '🛗', 'text': L10nService.get('widgets.dreams.prompts.elevator_wrong', language), 'category': 'ev'},

      // People & Relationship dreams
      {'emoji': '👨‍👩‍👧', 'text': L10nService.get('widgets.dreams.prompts.deceased_relative', language), 'category': 'insan'},
      {'emoji': '💔', 'text': L10nService.get('widgets.dreams.prompts.ex_stranger', language), 'category': 'insan'},
      {'emoji': '👶', 'text': L10nService.get('widgets.dreams.prompts.unknown_baby', language), 'category': 'bebek'},
      {'emoji': '👰', 'text': L10nService.get('widgets.dreams.prompts.wedding_blur', language), 'category': 'gelin'},
      {'emoji': '👯', 'text': L10nService.get('widgets.dreams.prompts.watching_self', language), 'category': 'insan'},

      // Body dreams
      {'emoji': '🦷', 'text': L10nService.get('widgets.dreams.prompts.teeth_falling', language), 'category': 'dis'},
      {'emoji': '💇', 'text': L10nService.get('widgets.dreams.prompts.hair_change', language), 'category': 'beden'},
      {'emoji': '👁️', 'text': L10nService.get('widgets.dreams.prompts.mirror_other', language), 'category': 'beden'},
      {'emoji': '🫀', 'text': L10nService.get('widgets.dreams.prompts.body_frozen', language), 'category': 'beden'},

      // Element dreams
      {'emoji': '🔥', 'text': L10nService.get('widgets.dreams.prompts.fire_immune', language), 'category': 'ates'},
      {'emoji': '⚡', 'text': L10nService.get('widgets.dreams.prompts.lightning_power', language), 'category': 'element'},
      {'emoji': '🌪️', 'text': L10nService.get('widgets.dreams.prompts.tornado_calm', language), 'category': 'element'},
      {'emoji': '❄️', 'text': L10nService.get('widgets.dreams.prompts.ice_walking', language), 'category': 'element'},

      // Exam & Performance dreams
      {'emoji': '📝', 'text': L10nService.get('widgets.dreams.prompts.exam_unprepared', language), 'category': 'sinav'},
      {'emoji': '🎤', 'text': L10nService.get('widgets.dreams.prompts.stage_voiceless', language), 'category': 'sinav'},
      {'emoji': '🏃‍♂️', 'text': L10nService.get('widgets.dreams.prompts.race_stuck', language), 'category': 'sinav'},
      {'emoji': '🎭', 'text': L10nService.get('widgets.dreams.prompts.acting_forgot', language), 'category': 'sinav'},

      // Death & Transformation dreams
      {'emoji': '💀', 'text': L10nService.get('widgets.dreams.prompts.death_watching', language), 'category': 'olum'},
      {'emoji': '⚰️', 'text': L10nService.get('widgets.dreams.prompts.funeral_crying', language), 'category': 'olum'},
      {'emoji': '🔄', 'text': L10nService.get('widgets.dreams.prompts.death_rebirth', language), 'category': 'olum'},
      {'emoji': '👻', 'text': L10nService.get('widgets.dreams.prompts.ghost_invisible', language), 'category': 'olum'},

      // Money & Abundance dreams
      {'emoji': '💰', 'text': L10nService.get('widgets.dreams.prompts.gold_uncollectable', language), 'category': 'para'},
      {'emoji': '🏆', 'text': L10nService.get('widgets.dreams.prompts.lottery_lost', language), 'category': 'para'},
      {'emoji': '💎', 'text': L10nService.get('widgets.dreams.prompts.treasure_chest', language), 'category': 'para'},

      // Vehicle & Journey dreams
      {'emoji': '🚗', 'text': L10nService.get('widgets.dreams.prompts.car_brakes_fail', language), 'category': 'araba'},
      {'emoji': '✈️', 'text': L10nService.get('widgets.dreams.prompts.plane_calm', language), 'category': 'yolculuk'},
      {'emoji': '🚂', 'text': L10nService.get('widgets.dreams.prompts.train_missed', language), 'category': 'yolculuk'},
      {'emoji': '🛤️', 'text': L10nService.get('widgets.dreams.prompts.endless_road', language), 'category': 'yolculuk'},

      // Mystical & Spiritual dreams
      {'emoji': '🔮', 'text': L10nService.get('widgets.dreams.prompts.seeing_future', language), 'category': 'mistik'},
      {'emoji': '👼', 'text': L10nService.get('widgets.dreams.prompts.angel_light', language), 'category': 'mistik'},
      {'emoji': '🌙', 'text': L10nService.get('widgets.dreams.prompts.moon_message', language), 'category': 'mistik'},
      {'emoji': '⭐', 'text': L10nService.get('widgets.dreams.prompts.stars_rising', language), 'category': 'mistik'},
      {'emoji': '🪬', 'text': L10nService.get('widgets.dreams.prompts.portal_world', language), 'category': 'mistik'},
    ];
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Add welcome message
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _dreamController.dispose();
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    final userProfile = ref.read(userProfileProvider);
    final sign = userProfile?.sunSign ?? zodiac.ZodiacSign.aries;
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language);

    final welcomeText = L10nService.get('widgets.dreams.welcome_message', language)
        .replaceAll('{signName}', signName);

    setState(() {
      _messages.add(ChatMessage(
        text: '$welcomeText⚠️ ${DisclaimerTexts.dreams(language)}',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _sendMessage() async {
    final text = _dreamController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    _dreamController.clear();
    _scrollToBottom();

    // Check if we're awaiting an answer to a context question
    if (_awaitingAnswer && _currentSession != null) {
      await _handleContextAnswer(text);
    } else {
      // Start new dream interpretation with APEX approach
      await _startApexInterpretation(text);
    }
  }

  /// APEX Step 1: Acknowledge symbol and ask context questions
  Future<void> _startApexInterpretation(String dreamText) async {
    final userProfile = ref.read(userProfileProvider);
    final aiService = ref.read(aiContentServiceProvider);

    try {
      // Start session
      final session = await aiService.startDreamInterpretation(
        dreamDescription: dreamText,
        userSign: userProfile?.sunSign,
      );

      _currentSession = session;
      _currentQuestionIndex = 0;
      _contextAnswers.clear();

      // Add acknowledgment message
      final acknowledgment = aiService.getDreamAcknowledgment(session.dreamSymbol);

      await Future.delayed(const Duration(milliseconds: 800));

      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: acknowledgment,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();

      // Ask first context question after delay
      if (session.contextQuestions.isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 1000));
        setState(() {
          _messages.add(ChatMessage(
            text: session.contextQuestions[0],
            isUser: false,
            timestamp: DateTime.now(),
            isQuestion: true,
          ));
          _awaitingAnswer = true;
        });
        _scrollToBottom();
      } else {
        // No questions, generate interpretation directly
        await _generateApexInterpretation();
      }
    } catch (e) {
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: L10nService.get('widgets.dreams.error_try_again', ref.read(languageProvider)),
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    }
  }

  /// APEX Step 2: Handle context answers
  Future<void> _handleContextAnswer(String answer) async {
    if (_currentSession == null) return;

    final question = _currentSession!.contextQuestions[_currentQuestionIndex];
    _contextAnswers[question] = answer;

    // Check if more questions
    if (_currentQuestionIndex < _currentSession!.contextQuestions.length - 1) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _isTyping = false;
        _currentQuestionIndex++;
        _messages.add(ChatMessage(
          text: _currentSession!.contextQuestions[_currentQuestionIndex],
          isUser: false,
          timestamp: DateTime.now(),
          isQuestion: true,
        ));
      });
      _scrollToBottom();
    } else {
      // All questions answered, generate interpretation
      setState(() {
        _awaitingAnswer = false;
      });
      await _generateApexInterpretation();
    }
  }

  /// APEX Step 3 & 4: Generate conditional interpretation
  Future<void> _generateApexInterpretation() async {
    if (_currentSession == null) return;

    final userProfile = ref.read(userProfileProvider);
    final aiService = ref.read(aiContentServiceProvider);

    setState(() {
      _isTyping = true;
    });

    try {
      final interpretedSession = await aiService.interpretDream(
        session: _currentSession!,
        contextAnswers: _contextAnswers,
        userSign: userProfile?.sunSign,
      );

      _currentSession = interpretedSession;

      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: interpretedSession.interpretation ?? L10nService.get('widgets.dreams.interpretation_failed', ref.read(languageProvider)),
          isUser: false,
          timestamp: DateTime.now(),
          isInterpretation: true,
        ));
      });
      _scrollToBottom();

      // Add follow-up message
      await Future.delayed(const Duration(milliseconds: 1500));
      setState(() {
        _messages.add(ChatMessage(
          text: L10nService.get('widgets.dreams.share_another', ref.read(languageProvider)),
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();

    } catch (e) {
      // Fallback to local interpretation
      _generateInterpretation(_currentSession!.dreamSymbol);
    }
  }


  void _generateInterpretation(String dreamText) {
    final userProfile = ref.read(userProfileProvider);
    final sign = userProfile?.sunSign ?? zodiac.ZodiacSign.aries;

    // Generate interpretation based on dream content and zodiac
    final interpretation = _interpretDream(dreamText, sign);

    setState(() {
      _isTyping = false;
      _messages.add(ChatMessage(
        text: interpretation,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });

    _scrollToBottom();
  }

  String _interpretDream(String dreamText, zodiac.ZodiacSign sign) {
    final lowerDream = dreamText.toLowerCase();

    // Analyze dream themes
    final themes = <String, String>{};

    // Water themes
    if (lowerDream.contains('su') ||
        lowerDream.contains('deniz') ||
        lowerDream.contains('okyanus') ||
        lowerDream.contains('nehir') ||
        lowerDream.contains('yagmur')) {
      themes['water'] = _getWaterInterpretation(sign);
    }

    // Flying themes
    if (lowerDream.contains('ucmak') ||
        lowerDream.contains('uctum') ||
        lowerDream.contains('ucuyordum') ||
        lowerDream.contains('havada')) {
      themes['flying'] = _getFlyingInterpretation(sign);
    }

    // Falling themes
    if (lowerDream.contains('dusmek') ||
        lowerDream.contains('dustum') ||
        lowerDream.contains('dusuyordum') ||
        lowerDream.contains('ucurum')) {
      themes['falling'] = _getFallingInterpretation(sign);
    }

    // Death/Transformation themes
    if (lowerDream.contains('olum') ||
        lowerDream.contains('oldum') ||
        lowerDream.contains('oldu') ||
        lowerDream.contains('cenaze')) {
      themes['death'] = _getDeathInterpretation(sign);
    }

    // Chase themes
    if (lowerDream.contains('kovalamak') ||
        lowerDream.contains('kacmak') ||
        lowerDream.contains('takip') ||
        lowerDream.contains('kaciyordum')) {
      themes['chase'] = _getChaseInterpretation(sign);
    }

    // Animal themes
    if (lowerDream.contains('yilan') ||
        lowerDream.contains('kopek') ||
        lowerDream.contains('kedi') ||
        lowerDream.contains('hayvan') ||
        lowerDream.contains('kus')) {
      themes['animal'] = _getAnimalInterpretation(sign);
    }

    // House/Building themes
    if (lowerDream.contains('ev') ||
        lowerDream.contains('bina') ||
        lowerDream.contains('oda') ||
        lowerDream.contains('kapi')) {
      themes['house'] = _getHouseInterpretation(sign);
    }

    // Love/Relationship themes
    if (lowerDream.contains('ask') ||
        lowerDream.contains('sevgili') ||
        lowerDream.contains('opusmek') ||
        lowerDream.contains('iliski')) {
      themes['love'] = _getLoveInterpretation(sign);
    }

    // Money/Wealth themes
    if (lowerDream.contains('para') ||
        lowerDream.contains('altin') ||
        lowerDream.contains('zengin') ||
        lowerDream.contains('hazine')) {
      themes['money'] = _getMoneyInterpretation(sign);
    }

    // Build final interpretation
    final buffer = StringBuffer();

    if (themes.isEmpty) {
      // Generic interpretation based on zodiac
      buffer.writeln(_getGenericInterpretation(sign, dreamText));
    } else {
      buffer.writeln('${sign.symbol} ${sign.localizedName(ref.read(languageProvider))} burcunun kozmik perspektifinden ruya yorumun:\n');

      for (final entry in themes.entries) {
        buffer.writeln(entry.value);
        buffer.writeln();
      }

      buffer.writeln(_getZodiacAdvice(sign));
    }

    return buffer.toString().trim();
  }

  String _getWaterInterpretation(zodiac.ZodiacSign sign) {
    final interpretations = {
      zodiac.ZodiacSign.aries: '''🌊 SU RÜYASI - ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} YORUMU
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💧 TEMEL ANLAM
Su, ateş burcun için duygusal derinliklere inme çağrısıdır. Bilinçdışı enerjilerin yüzeye çıkmak istiyor.

🔥 ATEŞ ELEMENTİ PERSPEKTİFİ
Suyun yatıştırıcı enerjisi, ateş doğanı dengelemek için gelmiş. Sabır ve dinlenme zamanı. Aksiyondan önce düşünme dönemi.

🌙 PSİKOLOJİK BOYUT
Su: Bilinçaltı, duygular, anne arketipi
Koç olarak: Bastırdığın duygular yüzeye çıkmak istiyor
Mesaj: Sadece koşmak değil, bazen duraksayıp hissetmek de gerekir

✨ PRATİK UYGULAMA
• Su kenarında meditasyon yap
• Duş alırken niyetini belirle
• Gözyaşlarına izin ver
• Duygularını yazıya dök''',

      zodiac.ZodiacSign.taurus: '''🌊 SU RÜYASI - ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} YORUMU
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💧 TEMEL ANLAM
Su, toprak burcun için bereket ve bolluğun sembolü. Maddi ve duygusal akış hayatına giriyor.

🌍 TOPRAK ELEMENTİ PERSPEKTİFİ
Su toprağı besler - bu rüya büyüme ve bereket habercisi. Doğal ritmine güven, zorlamadan akışa bırak.

🌙 PSİKOLOJİK BOYUT
Su: Duygusal güvenlik, konfor, beslenme
Boğa olarak: İç huzurun maddi güvenlikle bağlantısı
Mesaj: Duygusal zenginlik maddi zenginliği çeker

✨ PRATİK UYGULAMA
• Bitkilerini sula, bahçeyle ilgilen
• Banyo ritüeli yap
• Finansal akışı görselleştir
• Rahatlama ve konfor önceliğin olsun''',

      zodiac.ZodiacSign.cancer: '''🌊 SU RÜYASI - ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} YORUMU
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💧 KENDİ ELEMENTİN - ÇOK GÜÇLÜ!
Su senin elementi - bu rüya son derece anlamlı! Ruhsal derinliklerinden gelen güçlü bir mesaj var.

🌊 SU ELEMENTİ DERİNLİĞİ
Bu rüya ev, aile ve köklerinle derin bir bağlantıyı işaret ediyor. Anne arketipi aktif. İçsel yuvan çağırıyor.

🌙 PSİKOLOJİK BOYUT
Su: Bilinçaltı, sezgi, koruyucu içgüdü
Yengeç olarak: Ruhsal koruma ve yuva ihtiyacı
Mesaj: Eve dön - iç evine, ruhsal evine

✨ PRATİK UYGULAMA
• Ay ışığında su doldur ve iç
• Aile fotoğraflarına bak
• Deniz tuzu banyosu al
• Ev temizliği yap - enerjiyi yenile
• Annevi figürlerle bağlantı kur''',

      zodiac.ZodiacSign.scorpio: '''🌊 SU RÜYASI - ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} YORUMU
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💧 KENDİ ELEMENTİN - TRANSFORMASYON!
Su senin elementi ve bu rüya derin dönüşümü işaret ediyor! Yenilenme zamanı geldi.

🦂 AKREP DERİNLİĞİ
Suyun derinliklerine dalmaktan korkma. Orada hazineler var. Ölüm ve yeniden doğuş döngüsü aktif.

🌙 PSİKOLOJİK BOYUT
Su: Bilinçaltının en derin katmanları
Akrep olarak: Gölge çalışması zamanı
Mesaj: Karanlıktan korkmak yerine, onu aydınlat

✨ PRATİK UYGULAMA
• Derin meditasyonlar yap
• Gölge jurnal tut
• Bırakma ritüeli uygula
• Plutonyen dönüşümü kucakla
• Terapi veya danışmanlık düşün''',

      zodiac.ZodiacSign.pisces: '''🌊 SU RÜYASI - ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} YORUMU
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💧 KENDİ ELEMENTİN - SPİRİTÜEL BAĞLANTI!
Su senin elementi - spiritüel alemlerle bağlantın çok güçlü! Sezgilerine tamamen güvenebilirsin.

🐟 BALIK MİSTİSİZMİ
Evrenle bir olma deneyimi yaşıyorsun. Yaratıcı ilham akıyor. Sanatsal ifade için ideal dönem.

🌙 PSİKOLOJİK BOYUT
Su: Evrensel bilinç, şifa, kolektif bilinçaltı
Balık olarak: Mistik deneyimler ve içsel rehberlik
Mesaj: Sen sudan ötesin - okyanussun

✨ PRATİK UYGULAMA
• Sanatsal yaratım - resim, müzik, yazı
• Deniz veya göl kenarında meditasyon
• Lucid rüya pratikleri
• Şifa çalışmaları
• Spiritüel rehberliğe açık ol'''
    };

    // Default interpretation for other signs
    return interpretations[sign] ?? '''🌊 SU RÜYASI - ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} YORUMU
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💧 TEMEL ANLAM
Su, ${sign.element.localizedName(ref.read(languageProvider))} burcun için duygusal mesajlar taşıyor. Bilinçaltı akışa geçmek istiyor.

🌙 ${sign.element.localizedName(ref.read(languageProvider)).toUpperCase()} ELEMENTİ PERSPEKTİFİ
Suyun akışkan enerjisi seninle iletişim kuruyor. Duygusal derinliklere inme çağrısı.

✨ PRATİK UYGULAMA
• Su kenarında zaman geçir
• Duygularını ifade et
• Akışa güven, zorlamayı bırak
• Sezgilerine kulak ver''';
  }

  String _getFlyingInterpretation(zodiac.ZodiacSign sign) {
    return '''✈️ UÇMA RÜYASI - ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} YORUMU
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🦅 TEMEL ANLAM
Uçmak, özgürlük ve sınırları aşma arzusunu temsil eder. Ruhun yükselişi ve bilinç genişlemesi.

${sign.symbol} ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} İÇİN ÖZEL YORUM
Bu rüya sana hayatında yeni zirveler fethetme potansiyelini gösteriyor. Kendini sınırlayan inançlardan kurtulma zamanı geldi.

🌙 PSİKOLOJİK BOYUT
• Uçuş yüksekliği: Bilinç seviyeni gösterir
• Uçuş hızı: Değişim hızını simgeler
• Zorluk: Yaşadığın engelleri yansıtır
• Kolaylık: İçsel özgürlük seviyeni gösterir

📍 UÇUŞ STİLİNE GÖRE
• Süzülerek: Hayatta akışta olma hali
• Çırpınarak: Zorlu ama başarılan hedefler
• Yükselememe: Bastırılmış potansiyel
• Düşme: Kontrolü kaybetme korkusu

✨ PRATİK UYGULAMA
• Korkularını yaz ve yak
• Yüksek bir yere çık, manzaraya bak
• "Uçabiliyorum" afirmasyonu tekrarla
• Lucid rüya için niyet koy

💫 KOZMIK MESAJ
Evren sana "kanatların var, kullan" diyor. ${sign.element.localizedName(ref.read(languageProvider))} elementi olarak ${_getElementFlyingMessage(sign.element)}.''';
  }

  String _getElementFlyingMessage(zodiac.Element element) {
    switch (element) {
      case zodiac.Element.fire:
        return 'cesaretle yükselme zamanı';
      case zodiac.Element.earth:
        return 'pratik hedeflerini yükselt';
      case zodiac.Element.air:
        return 'fikirlerinin kanatlarıyla uç';
      case zodiac.Element.water:
        return 'duygusal özgürlüğünü yakala';
    }
  }

  String _getFallingInterpretation(zodiac.ZodiacSign sign) {
    return '''⬇️ DÜŞME RÜYASI - ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} YORUMU
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌪️ TEMEL ANLAM
Düşmek, kontrolü kaybetme korkusunu veya hayatındaki bir alanda güvensizliği yansıtır.

${sign.symbol} ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} İÇİN ÖZEL YORUM
Temellendirme çalışmalarına odaklan. Bu rüya sana "ayaklarının yere basması gerekiyor" mesajı veriyor.

🌙 PSİKOLOJİK BOYUT
• Nereden düştün: Hangi alanda güvensizlik
• Düşüş hızı: Kontrolsüzlük seviyesi
• Yere çarpma: Korkuların realize olma endişesi
• Uyanma öncesi: Kaçış mekanizması aktif

⚠️ DİKKAT EDİLECEKLER
• Hayatında kontrolü kaybettiğin alanlar
• Aşırı stres ve kaygı belirtileri
• Temel ihtiyaçların karşılanması
• İş-yaşam dengesi

✨ PRATİK UYGULAMA
• Çıplak ayakla toprağa bas
• Kök çakra meditasyonu yap
• Güvenlik ihtiyaçlarını listele
• Nefes egzersizleri uygula

💫 KOZMIK MESAJ
Düşmek aslında bırakmaktır. Kontrol illüzyonunu bırak, evrene güven. ${sign.element.localizedName(ref.read(languageProvider))} elementi olarak topraklanma pratiği özellikle önemli.''';
  }

  String _getDeathInterpretation(zodiac.ZodiacSign sign) {
    return '''💀 ÖLÜM RÜYASI - ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} YORUMU
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🦋 TEMEL ANLAM - KORKULACAK BİR ŞEY DEĞİL!
Rüyalarda ölüm, transformasyonun ve yeni başlangıçların sembolüdür. Bu bir son değil, dönüşümdür!

${sign.symbol} ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} İÇİN ÖZEL YORUM
Bu rüya eski kalıpların ölmesi ve yeni benliğin doğması anlamına gelir. Hayatında neyi bırakman gerektiğini düşün.

🌙 PSİKOLOJİK BOYUT
• Kendi ölümün: Ego dönüşümü, yeni benlik
• Başkasının ölümü: O kişinin temsil ettiği şey bitiyor
• Tanımadık birinin ölümü: Genel yaşam değişimi
• Ölümden dönüş: Yenilenme ve güç kazanma

🔄 DÖNÜŞÜM ALANLARI
• Kariyer değişimi
• İlişki dönüşümü
• İnançların yenilenmesi
• Kimlik evrimi
• Yaşam tarzı değişikliği

✨ PRATİK UYGULAMA
• Neyi bırakman gerekiyor - liste yap
• Eski fotoğrafları gözden geçir
• Kıyafet dolabını temizle
• "Ölmesi gereken" alışkanlıkları belirle

💫 KOZMIK MESAJ
Anka kuşu gibi küllerinden doğuyorsun. ${sign.localizedName(ref.read(languageProvider))} enerjisi bu dönüşümü güçlendiriyor. Yeni sen doğuyor!''';
  }

  String _getChaseInterpretation(zodiac.ZodiacSign sign) {
    return '''🏃 KOVALANMA RÜYASI - ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} YORUMU
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

😰 TEMEL ANLAM
Kovalanmak, hayatında kaçtığın bir konuyla yüzleşme çağrısıdır. Kaçtıkça kovalayan büyür!

${sign.symbol} ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} İÇİN ÖZEL YORUM
${sign.element.localizedName(ref.read(languageProvider))} enerjinle, cesaretle dön ve neyin peşinde olduğunu sor. Genellikle kaçtığımız şey, en çok ihtiyacımız olan derslerdir.

🌙 PSİKOLOJİK BOYUT (JUNG ANALİZİ)
• Kovalayan: Gölge arketipi - reddedilen yönlerin
• Kaçış: Yüzleşmekten kaçınma
• Yakalanma: Gölgeyle entegrasyon fırsatı
• Kaçamama: İnkar artık işe yaramıyor

🔍 KOVALAYAN NE OLABİLİR?
• Korku veya kaygı
• Bastırılmış öfke
• Ertelenen sorumluluklar
• Kaçınılan ilişki meseleleri
• Karşılanmamış ihtiyaçlar

✨ PRATİK UYGULAMA
• Rüyanda dur ve kovalayıcıyla konuş
• "Ne istiyorsun?" diye sor
• Aktif hayal tekniği uygula
• Kaçtığın konuyu belirle ve küçük adımlar at

💫 KOZMIK MESAJ
Kovalayan aslında sensin - bastırdığın bir yönün. Kucakla ve entegre et. Düşmanın dostun olabilir.''';
  }

  String _getAnimalInterpretation(zodiac.ZodiacSign sign) {
    return '''🐾 HAYVAN RÜYASI - ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} YORUMU
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🦁 TEMEL ANLAM
Hayvanlar, içgüdüsel doğamızı ve bastırılmış enerjileri temsil eder. Her hayvan bir totem mesajı taşır.

${sign.symbol} ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} İÇİN ÖZEL YORUM
Bu rüya, doğal içgüdülerinle yeniden bağlanma çağrısı. Hangi hayvan gördüysen, onun totem enerjisini araştır.

🐍 YAYGIN HAYVAN SEMBOLLERİ
• Yılan: Dönüşüm, şifa, kundalini
• Köpek: Sadakat, koruma, arkadaşlık
• Kedi: Bağımsızlık, gizem, sezgi
• Kuş: Özgürlük, ruhsal mesajlar
• Kurt: Topluluk, liderlik, öğretmen
• Ayı: Güç, koruma, içe dönüş
• At: Özgürlük, güç, tutku

🌙 PSİKOLOJİK BOYUT
• Hayvan davranışı: Senin bastırdığın davranış
• Hayvanla ilişkin: İçgüdülerinle ilişkin
• Hayvanın rengi: Duygusal ton
• Hayvan saldırıyorsa: Bastırılmış enerji patlaması

✨ PRATİK UYGULAMA
• O hayvanı araştır - mitoloji, sembolizm
• Hayvan meditasyonu yap
• Totem kartları çek
• O hayvanla ilgili bir nesne edin

💫 KOZMIK MESAJ
Hayvan rehberin seninle iletişim kuruyor. ${sign.element.localizedName(ref.read(languageProvider))} elementi olarak bu bağlantı özellikle güçlü.''';
  }

  String _getHouseInterpretation(zodiac.ZodiacSign sign) {
    return '''🏠 EV/BİNA RÜYASI - ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} YORUMU
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🏛️ TEMEL ANLAM
Ev ve binalar, ruhsal yapını ve iç dünyayı sembolize eder. Her oda benliğinin farklı yönlerini temsil eder.

${sign.symbol} ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} İÇİN ÖZEL YORUM
Hangi "odaya" girmekten kaçındığını düşün. ${sign.element.localizedName(ref.read(languageProvider))} elementi olarak iç dünyanın yapısı önemli.

🚪 ODA ANLAMLARI
• Bodrum: Bilinçaltı, bastırılmış anılar
• Çatı katı: Yüksek bilinç, spiritüellik
• Mutfak: Beslenme, yaratıcılık
• Yatak odası: Mahremiyet, cinsellik
• Banyo: Arınma, duygusal temizlik
• Salon: Sosyal yön, dış dünya ilişkisi
• Gizli odalar: Keşfedilmemiş potansiyel

🔑 EV DURUMLARI
• Yeni ev: Yeni benlik, değişim
• Harap ev: İhmal edilen yönler
• Çocukluk evi: Kökler, geçmiş
• Yabancı ev: Bilinmeyen potansiyel

✨ PRATİK UYGULAMA
• Evinizde en az gittiğiniz odayı temizle
• Ev köşelerini enerjiyle yenile
• İç dünyanın haritasını çiz
• "Ruhsal evin" meditasyonu yap

💫 KOZMIK MESAJ
Evin sensin. Her odası bir yönün. Hepsini keşfet ve sahiplen.''';
  }

  String _getLoveInterpretation(zodiac.ZodiacSign sign) {
    return '''💕 AŞK RÜYASI - ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} YORUMU
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❤️ TEMEL ANLAM
Aşk temalı rüyalar, ilişki dinamiklerini ve duygusal ihtiyaçları yansıtır.

${sign.symbol} ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} İÇİN ÖZEL YORUM
Bu rüya, aşk hayatında yeni bir dönemin habercisi olabilir. "Kendinle olan ilişkim nasıl?" sorusunu sor.

💑 AŞK RÜYASI TİPLERİ
• Eski sevgili: Tamamlanmamış duygular
• Yabancı biri: Yeni potansiyel veya arzu
• Partnerin: İlişki dinamikleri
• Ünlü biri: Arzu edilen özellikler
• Platonik aşk: Duygusal ihtiyaçlar

🌹 RÜYA SENARYOLARI
• Öpüşmek: Birleşme arzusu
• Ayrılık: Kaybetme korkusu
• Evlilik: Taahhüt isteği
• Aldatılma: Güvensizlik
• Kavga: İç çatışma

🌙 PSİKOLOJİK BOYUT
• Anima/Animus: Karşı cins arketipi
• Projeksiyon: Kendi özelliklerini görme
• İhtiyaç: Karşılanmamış duygusal gereksinimler

✨ PRATİK UYGULAMA
• Aşk dili testini yap
• İlişki ihtiyaçlarını listele
• Özdeğer çalışması yap
• Kalp çakrası meditasyonu

💫 KOZMIK MESAJ
Önce kendini sev. ${sign.element.localizedName(ref.read(languageProvider))} elementi aşk yaşamında ${_getElementLoveMessage(sign.element)}.''';
  }

  String _getElementLoveMessage(zodiac.Element element) {
    switch (element) {
      case zodiac.Element.fire:
        return 'tutku ve heyecan istiyor';
      case zodiac.Element.earth:
        return 'güvenlik ve sadakat arıyor';
      case zodiac.Element.air:
        return 'iletişim ve zihinsel bağ öncelikli';
      case zodiac.Element.water:
        return 'derin duygusal bağ kurmak istiyor';
    }
  }

  String _getMoneyInterpretation(zodiac.ZodiacSign sign) {
    return '''💰 PARA/ZENGİNLİK RÜYASI - ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} YORUMU
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🏆 TEMEL ANLAM
Para ve zenginlik rüyaları, öz değer ve bolluk bilincini temsil eder. Maddi değil, içsel zenginlik mesajı taşır.

${sign.symbol} ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} İÇİN ÖZEL YORUM
Bu rüya, maddi dünyayla ilişkini sorgulamaya davet ediyor. Gerçek zenginlik içsel huzur ve minnettarlıktır.

💎 PARA RÜYASI TİPLERİ
• Para bulmak: Gelen fırsatlar, şans
• Para kaybetmek: Güvensizlik, kayıp korkusu
• Zengin olmak: Potansiyelin farkındalığı
• Para saymak: Kontrol ihtiyacı
• Para vermek: Cömertlik veya güç kaybı

🪙 SEMBOLLER
• Altın: Ruhsal zenginlik, bilgelik
• Nakit: Günlük güvenlik
• Hazine: Gizli potansiyel
• Mücevher: Öz değer
• Banka: Güvenlik ve yapı

🌙 PSİKOLOJİK BOYUT
• Para = Enerji alışverişi
• Zenginlik = Öz değer algısı
• Yoksulluk = Yetersizlik hissi
• Bolluk = Evrenle uyum

✨ PRATİK UYGULAMA
• Bolluk afirmasyonları tekrarla
• Şükran listesi tut
• Para ile ilişkini sorgula
• Cömertlik pratiği yap

💫 KOZMIK MESAJ
Evren bolluk sunar - alıcı ol. ${sign.element.localizedName(ref.read(languageProvider))} elementi finansal konularda ${_getElementMoneyMessage(sign.element)}.''';
  }

  String _getElementMoneyMessage(zodiac.Element element) {
    switch (element) {
      case zodiac.Element.fire:
        return 'cesaretli yatırımlar önerir';
      case zodiac.Element.earth:
        return 'güvenli ve kararlı birikimi destekler';
      case zodiac.Element.air:
        return 'çoklu gelir kaynaklarını işaret eder';
      case zodiac.Element.water:
        return 'sezgisel finansal kararlar önerir';
    }
  }

  String _getGenericInterpretation(zodiac.ZodiacSign sign, String dreamText) {
    return '''${sign.symbol} ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} KOZMİK RÜYA YORUMU
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔮 BİLİNÇALTI MESAJI
Anlattığın rüya, bilinçaltının sana önemli mesajlar ilettiğini gösteriyor.

💫 ${sign.element.localizedName(ref.read(languageProvider)).toUpperCase()} ELEMENTİ PERSPEKTİFİ
${sign.element.localizedName(ref.read(languageProvider))} elementinin enerjisiyle, bu rüyanın temel mesajı ${_getElementMessage(sign)} ile ilgili görünüyor.

🌙 DUYGU ANALİZİ
Rüyandaki duygulara odaklan:
• Korku: Güvenlik ihtiyacı
• Mutluluk: Doğru yoldasın işareti
• Şaşkınlık: Bilinmeyen keşfediliyor
• Üzüntü: Tamamlanmamış duygu
• Öfke: Bastırılmış enerji

📍 SEMBOL OKUMA
Rüyandaki ana sembolleri not et:
• Kişiler: Senin yönlerini temsil ediyor
• Mekanlar: İç dünyanın haritası
• Objeler: Araçlar ve kaynaklar
• Eylemler: Hayat yaklaşımın

✨ PRATİK UYGULAMA
• Rüya defteri tut
• Uyumadan önce niyet koy
• Sembolleri araştır
• Meditasyonla bağlan

💫 ${sign.localizedName(ref.read(languageProvider)).toUpperCase()} TAVSİYESİ
${_getZodiacAdvice(sign)}''';
  }

  String _getElementMessage(zodiac.ZodiacSign sign) {
    switch (sign.element) {
      case zodiac.Element.fire:
        return 'tutku, aksiyon ve yaratici güc';
      case zodiac.Element.earth:
        return 'güvenlik, maddi dünya ve pratik adimlar';
      case zodiac.Element.air:
        return 'iletisim, fikirler ve sosyal baglantilar';
      case zodiac.Element.water:
        return 'duygular, sezgi ve ruhsal derinlik';
    }
  }

  String _getZodiacAdvice(zodiac.ZodiacSign sign) {
    final advice = {
      zodiac.ZodiacSign.aries:
          'Tavsiyem: Sabah uyandığında ilk düsüncelerini not al. Ates enerjin, bilinçaltı mesajları hızla unutturabilir.',
      zodiac.ZodiacSign.taurus:
          'Tavsiyem: Ruyalarını bir ruya defterine yaz. Toprak enerjin, somut kayıtlarla daha iyi çalısır.',
      zodiac.ZodiacSign.gemini:
          'Tavsiyem: Rüyanı birine anlat. Hava enerjin, sözel ifadeyle anlam bulmayı sever.',
      zodiac.ZodiacSign.cancer:
          'Tavsiyem: Ay fazlarına dikkat et. Dolunay ve yeniay zamanları ruyaların daha güçlü olacak.',
      zodiac.ZodiacSign.leo:
          'Tavsiyem: Rüyalarını yaratıcı bir sekilde ifade et - çiz, yaz, paylas. Ates enerjin ifadeyi sever.',
      zodiac.ZodiacSign.virgo:
          'Tavsiyem: Ruya sembolleri listesi tut. Toprak enerjin, sistematik analizi takdir eder.',
      zodiac.ZodiacSign.libra:
          'Tavsiyem: Rüyalarındaki iliskilere odaklan. Hava enerjin, sosyal dinamiklerden ders çıkarır.',
      zodiac.ZodiacSign.scorpio:
          'Tavsiyem: Derin meditasyon yap. Su enerjin, bilincalti derinliklerine dalmak icin cok güclü.',
      zodiac.ZodiacSign.sagittarius:
          'Tavsiyem: Rüyalarını felsefi açıdan yorumla. Ates enerjin, büyük resmi görmeyi sever.',
      zodiac.ZodiacSign.capricorn:
          'Tavsiyem: Ruyalarini pratik yaşama nasıl uygularsın düsün. Toprak enerjin, somut sonuclar ister.',
      zodiac.ZodiacSign.aquarius:
          'Tavsiyem: Ruya toplulukarina katıl. Hava enerjin, kolektif bilgelikten beslenİr.',
      zodiac.ZodiacSign.pisces:
          'Tavsiyem: Uyumadan önce niyet koy. Su enerjin, spiritüel rehberlikle doğrudan bağlanabilir.',
    };
    return advice[sign] ?? advice[zodiac.ZodiacSign.aries]!;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildChatArea(),
              ),
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
            AppColors.mystic.withOpacity(0.3),
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
          // Animated dream icon
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      AppColors.mystic.withOpacity(0.5 + _pulseController.value * 0.3),
                      AppColors.nebulaPurple.withOpacity(0.3),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mystic.withOpacity(0.4 * _pulseController.value),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Text(
                  '\u{1F319}', // Crescent moon emoji
                  style: TextStyle(fontSize: 24),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10nService.get('dreams.interpretation_title', ref.watch(languageProvider)),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  L10nService.get('dreams.interpretation_subtitle', ref.watch(languageProvider)),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          // Quick symbols button
          IconButton(
            onPressed: () => _showDreamSymbolsSheet(context),
            icon: const Icon(Icons.auto_stories, color: AppColors.starGold),
            tooltip: L10nService.get('dreams.symbols_found', ref.watch(languageProvider)),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildChatArea() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isTyping ? 1 : 0) + (_messages.length == 1 ? 1 : 0),
      itemBuilder: (context, index) {
        // Show suggested prompts after welcome message
        if (_messages.length == 1 && index == 1 && !_isTyping) {
          return _buildSuggestedDreamPrompts();
        }
        if (index == _messages.length + (_messages.length == 1 ? 1 : 0) && _isTyping) {
          return _buildTypingIndicator();
        }
        if (index < _messages.length) {
          return _buildMessageBubble(_messages[index], index);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSuggestedDreamPrompts() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quiz CTA - Google Discover Funnel
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: QuizCTACard.dream(compact: true),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                const Text('💭', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text(
                  L10nService.get('dreams.example_prompts_label', ref.read(languageProvider)),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _getSuggestedDreamPrompts(ref.read(languageProvider)).length,
              itemBuilder: (context, index) {
                final prompt = _getSuggestedDreamPrompts(ref.read(languageProvider))[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () {
                      _dreamController.text = prompt['text'];
                      _sendMessage();
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 180,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.mystic.withOpacity(0.25),
                            AppColors.nebulaPurple.withOpacity(0.15),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.mystic.withOpacity(0.35),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mystic.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(prompt['emoji'], style: const TextStyle(fontSize: 22)),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Text(
                              prompt['text'],
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textPrimary,
                                height: 1.3,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: (50 * index).ms).slideX(begin: 0.1, end: 0);
              },
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              L10nService.get('widgets.dreams.tap_or_write_hint', ref.read(languageProvider)),
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary.withOpacity(0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms);
  }

  Widget _buildMessageBubble(ChatMessage message, int index) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.mystic.withOpacity(0.5),
                    AppColors.nebulaPurple.withOpacity(0.3),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Text('\u{1F319}', style: TextStyle(fontSize: 18)),
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
                          AppColors.cosmicPurple.withOpacity(0.4),
                          AppColors.nebulaPurple.withOpacity(0.3),
                        ]
                      : [
                          AppColors.mystic.withOpacity(0.2),
                          const Color(0xFF1A1A2E).withOpacity(0.8),
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
                      ? AppColors.cosmicPurple.withOpacity(0.3)
                      : AppColors.mystic.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isUser ? AppColors.cosmicPurple : AppColors.mystic)
                        .withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.isInterpretation) ...[
                    Row(
                      children: [
                        const Text('\u{2728}', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 6),
                        Text(
                          L10nService.get('widgets.dreams.interpretation_label', ref.watch(languageProvider)),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.starGold,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (message.isQuestion) ...[
                    Row(
                      children: [
                        const Text('\u{2753}', style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          L10nService.get('widgets.dreams.question_label', ref.watch(languageProvider)),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.mystic,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    message.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: (50 * index).ms).slideX(
          begin: isUser ? 0.2 : -0.2,
          end: 0,
          duration: 300.ms,
          delay: (50 * index).ms,
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
                  AppColors.mystic.withOpacity(0.5),
                  AppColors.nebulaPurple.withOpacity(0.3),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Text('\u{1F319}', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.mystic.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.mystic.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: const Text('\u{2728}', style: TextStyle(fontSize: 14)),
                )
                    .animate(
                      onComplete: (controller) => controller.repeat(),
                    )
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

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppColors.nebulaPurple.withOpacity(0.5),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quick answer buttons when awaiting context answer
          if (_awaitingAnswer && _currentSession != null) _buildQuickAnswers(),
          Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.mystic.withOpacity(0.15),
                    const Color(0xFF1A1A2E).withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.mystic.withOpacity(0.3),
                ),
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
                  controller: _dreamController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  maxLines: 5,
                  minLines: 1,
                  textInputAction: TextInputAction.send,
                  decoration: InputDecoration(
                    hintText: L10nService.get('dreams.input_placeholder', ref.read(languageProvider)),
                    hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.6)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.mystic,
                    AppColors.cosmicPurple,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mystic.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          )
              .animate(
                onComplete: (controller) => controller.repeat(reverse: true),
              )
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.05, 1.05),
                duration: 1500.ms,
              ),
        ],
      ),
        ],
      ),
    );
  }

  /// Quick answer buttons for context questions - ENHANCED
  Widget _buildQuickAnswers() {
    if (_currentSession == null || _currentQuestionIndex >= _currentSession!.contextQuestions.length) {
      return const SizedBox.shrink();
    }

    final currentQuestion = _currentSession!.contextQuestions[_currentQuestionIndex].toLowerCase();
    List<Map<String, String>> quickAnswers = [];

    final language = ref.read(languageProvider);
    // Generate rich contextual quick answers based on question type
    if (currentQuestion.contains('korku') ||
        currentQuestion.contains('duygu') ||
        currentQuestion.contains('hissett') ||
        currentQuestion.contains('nasıl') ||
        currentQuestion.contains('fear') ||
        currentQuestion.contains('feel')) {
      quickAnswers = [
        {'emoji': '😨', 'text': L10nService.get('widgets.dreams.quick_answers.fear_anxiety', language)},
        {'emoji': '😌', 'text': L10nService.get('widgets.dreams.quick_answers.peace_trust', language)},
        {'emoji': '🤔', 'text': L10nService.get('widgets.dreams.quick_answers.curiosity_surprise', language)},
        {'emoji': '😢', 'text': L10nService.get('widgets.dreams.quick_answers.sadness_melancholy', language)},
        {'emoji': '😊', 'text': L10nService.get('widgets.dreams.quick_answers.happiness_joy', language)},
        {'emoji': '😤', 'text': L10nService.get('widgets.dreams.quick_answers.anger_frustration', language)},
      ];
    } else if (currentQuestion.contains('ortam') ||
               currentQuestion.contains('nerede') ||
               currentQuestion.contains('mekan') ||
               currentQuestion.contains('yer') ||
               currentQuestion.contains('where') ||
               currentQuestion.contains('place')) {
      quickAnswers = [
        {'emoji': '🏠', 'text': L10nService.get('widgets.dreams.quick_answers.home_familiar', language)},
        {'emoji': '🌳', 'text': L10nService.get('widgets.dreams.quick_answers.nature_forest', language)},
        {'emoji': '🌊', 'text': L10nService.get('widgets.dreams.quick_answers.water_seaside', language)},
        {'emoji': '🏔️', 'text': L10nService.get('widgets.dreams.quick_answers.mountain_high', language)},
        {'emoji': '🌑', 'text': L10nService.get('widgets.dreams.quick_answers.dark_uncertain', language)},
        {'emoji': '❓', 'text': L10nService.get('widgets.dreams.quick_answers.strange_unknown', language)},
      ];
    } else if (currentQuestion.contains('kim') ||
               currentQuestion.contains('biri') ||
               currentQuestion.contains('kişi') ||
               currentQuestion.contains('başka') ||
               currentQuestion.contains('who') ||
               currentQuestion.contains('person')) {
      quickAnswers = [
        {'emoji': '🚶', 'text': L10nService.get('widgets.dreams.quick_answers.completely_alone', language)},
        {'emoji': '👨‍👩‍👧', 'text': L10nService.get('widgets.dreams.quick_answers.family_member', language)},
        {'emoji': '💑', 'text': L10nService.get('widgets.dreams.quick_answers.partner_spouse', language)},
        {'emoji': '👥', 'text': L10nService.get('widgets.dreams.quick_answers.friends_present', language)},
        {'emoji': '👤', 'text': L10nService.get('widgets.dreams.quick_answers.strangers_present', language)},
        {'emoji': '😶', 'text': L10nService.get('widgets.dreams.quick_answers.faceless_person', language)},
      ];
    } else if (currentQuestion.contains('renk') ||
               currentQuestion.contains('görün') ||
               currentQuestion.contains('color') ||
               currentQuestion.contains('appear')) {
      quickAnswers = [
        {'emoji': '⚫', 'text': L10nService.get('widgets.dreams.quick_answers.dark_black', language)},
        {'emoji': '⚪', 'text': L10nService.get('widgets.dreams.quick_answers.bright_white', language)},
        {'emoji': '🔵', 'text': L10nService.get('widgets.dreams.quick_answers.blue_peaceful', language)},
        {'emoji': '🔴', 'text': L10nService.get('widgets.dreams.quick_answers.red_warm', language)},
        {'emoji': '🌈', 'text': L10nService.get('widgets.dreams.quick_answers.colorful_vibrant', language)},
        {'emoji': '🌫️', 'text': L10nService.get('widgets.dreams.quick_answers.foggy_blurry', language)},
      ];
    } else if (currentQuestion.contains('doğru') ||
               currentQuestion.contains('sana') ||
               currentQuestion.contains('yaklaş') ||
               currentQuestion.contains('hareket') ||
               currentQuestion.contains('toward') ||
               currentQuestion.contains('move')) {
      quickAnswers = [
        {'emoji': '➡️', 'text': L10nService.get('widgets.dreams.quick_answers.yes_approaching', language)},
        {'emoji': '⬅️', 'text': L10nService.get('widgets.dreams.quick_answers.no_leaving', language)},
        {'emoji': '⏸️', 'text': L10nService.get('widgets.dreams.quick_answers.just_standing', language)},
        {'emoji': '🔄', 'text': L10nService.get('widgets.dreams.quick_answers.circling_around', language)},
        {'emoji': '🏃', 'text': L10nService.get('widgets.dreams.quick_answers.moving_fast', language)},
        {'emoji': '❓', 'text': L10nService.get('widgets.dreams.quick_answers.dont_remember', language)},
      ];
    } else if (currentQuestion.contains('ses') ||
               currentQuestion.contains('konuş') ||
               currentQuestion.contains('duy') ||
               currentQuestion.contains('sound') ||
               currentQuestion.contains('hear')) {
      quickAnswers = [
        {'emoji': '🔇', 'text': L10nService.get('widgets.dreams.quick_answers.silence_present', language)},
        {'emoji': '🗣️', 'text': L10nService.get('widgets.dreams.quick_answers.voices_talking', language)},
        {'emoji': '🎵', 'text': L10nService.get('widgets.dreams.quick_answers.music_melodies', language)},
        {'emoji': '😱', 'text': L10nService.get('widgets.dreams.quick_answers.scary_sounds', language)},
        {'emoji': '💭', 'text': L10nService.get('widgets.dreams.quick_answers.inner_voice', language)},
        {'emoji': '❓', 'text': L10nService.get('widgets.dreams.quick_answers.cant_remember', language)},
      ];
    } else if (currentQuestion.contains('son') ||
               currentQuestion.contains('bit') ||
               currentQuestion.contains('uyan') ||
               currentQuestion.contains('end') ||
               currentQuestion.contains('wake')) {
      quickAnswers = [
        {'emoji': '😰', 'text': L10nService.get('widgets.dreams.quick_answers.woke_scared', language)},
        {'emoji': '😊', 'text': L10nService.get('widgets.dreams.quick_answers.woke_peaceful', language)},
        {'emoji': '❓', 'text': L10nService.get('widgets.dreams.quick_answers.dream_ended', language)},
        {'emoji': '🔄', 'text': L10nService.get('widgets.dreams.quick_answers.dream_shifted', language)},
        {'emoji': '⏰', 'text': L10nService.get('widgets.dreams.quick_answers.alarm_interrupted', language)},
        {'emoji': '💭', 'text': L10nService.get('widgets.dreams.quick_answers.wanted_continue', language)},
      ];
    } else {
      quickAnswers = [
        {'emoji': '💭', 'text': L10nService.get('widgets.dreams.quick_answers.add_detail', language)},
        {'emoji': '🔮', 'text': L10nService.get('widgets.dreams.quick_answers.interpret_now', language)},
        {'emoji': '🤷', 'text': L10nService.get('widgets.dreams.quick_answers.not_sure', language)},
        {'emoji': '❓', 'text': L10nService.get('widgets.dreams.quick_answers.cant_remember', language)},
      ];
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: quickAnswers.map((answer) => InkWell(
          onTap: () {
            _dreamController.text = answer['text']!;
            _sendMessage();
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.cosmicPurple.withOpacity(0.3),
                  AppColors.mystic.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.mystic.withOpacity(0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.mystic.withOpacity(0.1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(answer['emoji']!, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text(
                  answer['text']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        )).toList(),
      ),
    );
  }

  void _showDreamSymbolsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const _DreamSymbolsSheet(),
    );
  }
}

/// Chat message model
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isQuestion;
  final bool isInterpretation;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isQuestion = false,
    this.isInterpretation = false,
  });
}

/// Dream symbols reference sheet
class _DreamSymbolsSheet extends ConsumerWidget {
  const _DreamSymbolsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final symbols = [
      {'emoji': '\u{1F40D}', 'name': L10nService.get('widgets.dreams.symbols.snake_name', language), 'meaning': L10nService.get('widgets.dreams.symbols.snake_meaning', language)},
      {'emoji': '\u{1F30A}', 'name': L10nService.get('widgets.dreams.symbols.water_name', language), 'meaning': L10nService.get('widgets.dreams.symbols.water_meaning', language)},
      {'emoji': '\u{1F525}', 'name': L10nService.get('widgets.dreams.symbols.fire_name', language), 'meaning': L10nService.get('widgets.dreams.symbols.fire_meaning', language)},
      {'emoji': '\u{1F3E0}', 'name': L10nService.get('widgets.dreams.symbols.house_name', language), 'meaning': L10nService.get('widgets.dreams.symbols.house_meaning', language)},
      {'emoji': '\u{2708}', 'name': L10nService.get('widgets.dreams.symbols.flying_name', language), 'meaning': L10nService.get('widgets.dreams.symbols.flying_meaning', language)},
      {'emoji': '\u{1F319}', 'name': L10nService.get('widgets.dreams.symbols.moon_name', language), 'meaning': L10nService.get('widgets.dreams.symbols.moon_meaning', language)},
      {'emoji': '\u{2600}', 'name': L10nService.get('widgets.dreams.symbols.sun_name', language), 'meaning': L10nService.get('widgets.dreams.symbols.sun_meaning', language)},
      {'emoji': '\u{1F480}', 'name': L10nService.get('widgets.dreams.symbols.death_name', language), 'meaning': L10nService.get('widgets.dreams.symbols.death_meaning', language)},
      {'emoji': '\u{1F436}', 'name': L10nService.get('widgets.dreams.symbols.dog_name', language), 'meaning': L10nService.get('widgets.dreams.symbols.dog_meaning', language)},
      {'emoji': '\u{1F431}', 'name': L10nService.get('widgets.dreams.symbols.cat_name', language), 'meaning': L10nService.get('widgets.dreams.symbols.cat_meaning', language)},
      {'emoji': '\u{1F4B0}', 'name': L10nService.get('widgets.dreams.symbols.money_name', language), 'meaning': L10nService.get('widgets.dreams.symbols.money_meaning', language)},
      {'emoji': '\u{2764}', 'name': L10nService.get('widgets.dreams.symbols.love_name', language), 'meaning': L10nService.get('widgets.dreams.symbols.love_meaning', language)},
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.nebulaPurple,
            const Color(0xFF0D0D1A),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text('\u{1F52E}', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Text(
                  L10nService.get('widgets.dreams.symbols_guide_title', language),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          // Symbols grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: symbols.length,
              itemBuilder: (context, index) {
                final symbol = symbols[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.mystic.withOpacity(0.2),
                        const Color(0xFF1A1A2E).withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.mystic.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        symbol['emoji']!,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              symbol['name']!,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              symbol['meaning']!,
                              style: TextStyle(
                                color: AppColors.textSecondary.withOpacity(0.8),
                                fontSize: 10,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: (50 * index).ms).slideY(begin: 0.1, end: 0);
              },
            ),
          ),
        ],
      ),
    );
  }
}
