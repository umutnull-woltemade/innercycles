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
    final language = ref.read(languageProvider);

    if (themes.isEmpty) {
      // Generic interpretation based on zodiac
      buffer.writeln(_getGenericInterpretation(sign, dreamText));
    } else {
      final signPerspective = L10nService.getWithParams(
        'widgets.dreams.interpretations.sign_perspective',
        language,
        params: {'sign': sign.localizedName(language)},
      );
      buffer.writeln('${sign.symbol} $signPerspective\n');

      for (final entry in themes.entries) {
        buffer.writeln(entry.value);
        buffer.writeln();
      }

      buffer.writeln(_getZodiacAdvice(sign));
    }

    return buffer.toString().trim();
  }

  String _getWaterInterpretation(zodiac.ZodiacSign sign) {
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language).toUpperCase();
    final elementName = sign.element.localizedName(language);

    // Map sign to JSON key
    final signKeyMap = {
      zodiac.ZodiacSign.aries: 'aries',
      zodiac.ZodiacSign.taurus: 'taurus',
      zodiac.ZodiacSign.cancer: 'cancer',
      zodiac.ZodiacSign.scorpio: 'scorpio',
      zodiac.ZodiacSign.pisces: 'pisces',
    };

    final signKey = signKeyMap[sign];

    if (signKey != null) {
      final title = L10nService.getWithParams('widgets.dreams.interpretations.water.title', language, params: {'sign': signName});
      final divider = L10nService.get('widgets.dreams.interpretations.water.divider', language);
      final basicLabel = L10nService.get('widgets.dreams.interpretations.water.basic_meaning_label', language);
      final elementLabel = L10nService.getWithParams('widgets.dreams.interpretations.water.element_perspective_label', language, params: {'element': elementName.toUpperCase()});
      final psychLabel = L10nService.get('widgets.dreams.interpretations.water.psychological_label', language);
      final practiceLabel = L10nService.get('widgets.dreams.interpretations.water.practice_label', language);

      final basicMeaning = L10nService.get('widgets.dreams.interpretations.water.$signKey.basic_meaning', language);
      final elementPerspective = L10nService.get('widgets.dreams.interpretations.water.$signKey.element_perspective', language);
      final psychological = L10nService.get('widgets.dreams.interpretations.water.$signKey.psychological', language);
      final practice = L10nService.get('widgets.dreams.interpretations.water.$signKey.practice', language);

      return '''$title
$divider

$basicLabel
$basicMeaning

$elementLabel
$elementPerspective

$psychLabel
$psychological

$practiceLabel
$practice''';
    }

    // Default interpretation for other signs
    final title = L10nService.getWithParams('widgets.dreams.interpretations.water.title', language, params: {'sign': signName});
    final divider = L10nService.get('widgets.dreams.interpretations.water.divider', language);
    final basicLabel = L10nService.get('widgets.dreams.interpretations.water.basic_meaning_label', language);
    final elementLabel = L10nService.getWithParams('widgets.dreams.interpretations.water.element_perspective_label', language, params: {'element': elementName.toUpperCase()});
    final practiceLabel = L10nService.get('widgets.dreams.interpretations.water.practice_label', language);

    final basicMeaning = L10nService.getWithParams('widgets.dreams.interpretations.water.default.basic_meaning', language, params: {'element': elementName});
    final elementPerspective = L10nService.get('widgets.dreams.interpretations.water.default.element_perspective', language);
    final practice = L10nService.get('widgets.dreams.interpretations.water.default.practice', language);

    return '''$title
$divider

$basicLabel
$basicMeaning

$elementLabel
$elementPerspective

$practiceLabel
$practice''';
  }

  String _getFlyingInterpretation(zodiac.ZodiacSign sign) {
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language).toUpperCase();
    final elementName = sign.element.localizedName(language);
    final elementKey = _getElementKey(sign.element);
    final elementMessage = L10nService.get('widgets.dreams.interpretations.element_messages.${elementKey}_flying', language);

    final title = L10nService.getWithParams('widgets.dreams.interpretations.flying.title', language, params: {'sign': signName});
    final basicLabel = L10nService.get('widgets.dreams.interpretations.flying.basic_meaning_label', language);
    final basicMeaning = L10nService.get('widgets.dreams.interpretations.flying.basic_meaning', language);
    final specialLabel = L10nService.getWithParams('widgets.dreams.interpretations.flying.special_interpretation_label', language, params: {'sign': '${sign.symbol} $signName'});
    final specialInterpretation = L10nService.get('widgets.dreams.interpretations.flying.special_interpretation', language);
    final psychLabel = L10nService.get('widgets.dreams.interpretations.flying.psychological_label', language);
    final psychological = L10nService.get('widgets.dreams.interpretations.flying.psychological', language);
    final flightStyleLabel = L10nService.get('widgets.dreams.interpretations.flying.flight_style_label', language);
    final flightStyle = L10nService.get('widgets.dreams.interpretations.flying.flight_style', language);
    final practiceLabel = L10nService.get('widgets.dreams.interpretations.flying.practice_label', language);
    final practice = L10nService.get('widgets.dreams.interpretations.flying.practice', language);
    final cosmicLabel = L10nService.get('widgets.dreams.interpretations.flying.cosmic_message_label', language);
    final cosmicMessage = L10nService.getWithParams('widgets.dreams.interpretations.flying.cosmic_message', language, params: {'element': elementName, 'element_message': elementMessage});

    return '''$title
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$basicLabel
$basicMeaning

$specialLabel
$specialInterpretation

$psychLabel
$psychological

$flightStyleLabel
$flightStyle

$practiceLabel
$practice

$cosmicLabel
$cosmicMessage''';
  }

  String _getElementKey(zodiac.Element element) {
    switch (element) {
      case zodiac.Element.fire:
        return 'fire';
      case zodiac.Element.earth:
        return 'earth';
      case zodiac.Element.air:
        return 'air';
      case zodiac.Element.water:
        return 'water';
    }
  }

  String _getFallingInterpretation(zodiac.ZodiacSign sign) {
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language).toUpperCase();
    final elementName = sign.element.localizedName(language);

    final title = L10nService.getWithParams('widgets.dreams.interpretations.falling.title', language, params: {'sign': signName});
    final basicLabel = L10nService.get('widgets.dreams.interpretations.falling.basic_meaning_label', language);
    final basicMeaning = L10nService.get('widgets.dreams.interpretations.falling.basic_meaning', language);
    final specialInterpretation = L10nService.get('widgets.dreams.interpretations.falling.special_interpretation', language);
    final psychLabel = L10nService.get('widgets.dreams.interpretations.falling.psychological_label', language);
    final psychological = L10nService.get('widgets.dreams.interpretations.falling.psychological', language);
    final attentionLabel = L10nService.get('widgets.dreams.interpretations.falling.attention_label', language);
    final attention = L10nService.get('widgets.dreams.interpretations.falling.attention', language);
    final practiceLabel = L10nService.get('widgets.dreams.interpretations.falling.practice_label', language);
    final practice = L10nService.get('widgets.dreams.interpretations.falling.practice', language);
    final cosmicLabel = L10nService.get('widgets.dreams.interpretations.falling.cosmic_message_label', language);
    final cosmicMessage = L10nService.getWithParams('widgets.dreams.interpretations.falling.cosmic_message', language, params: {'element': elementName});

    return '''$title
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$basicLabel
$basicMeaning

${sign.symbol} $signName
$specialInterpretation

$psychLabel
$psychological

$attentionLabel
$attention

$practiceLabel
$practice

$cosmicLabel
$cosmicMessage''';
  }

  String _getDeathInterpretation(zodiac.ZodiacSign sign) {
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language).toUpperCase();

    final title = L10nService.getWithParams('widgets.dreams.interpretations.death.title', language, params: {'sign': signName});
    final notScaryLabel = L10nService.get('widgets.dreams.interpretations.death.not_scary_label', language);
    final notScary = L10nService.get('widgets.dreams.interpretations.death.not_scary', language);
    final specialInterpretation = L10nService.get('widgets.dreams.interpretations.death.special_interpretation', language);
    final psychLabel = L10nService.get('widgets.dreams.interpretations.death.psychological_label', language);
    final psychological = L10nService.get('widgets.dreams.interpretations.death.psychological', language);
    final transformLabel = L10nService.get('widgets.dreams.interpretations.death.transformation_label', language);
    final transformation = L10nService.get('widgets.dreams.interpretations.death.transformation', language);
    final practiceLabel = L10nService.get('widgets.dreams.interpretations.death.practice_label', language);
    final practice = L10nService.get('widgets.dreams.interpretations.death.practice', language);
    final cosmicLabel = L10nService.get('widgets.dreams.interpretations.death.cosmic_message_label', language);
    final cosmicMessage = L10nService.getWithParams('widgets.dreams.interpretations.death.cosmic_message', language, params: {'sign': sign.localizedName(language)});

    return '''$title
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$notScaryLabel
$notScary

${sign.symbol} $signName
$specialInterpretation

$psychLabel
$psychological

$transformLabel
$transformation

$practiceLabel
$practice

$cosmicLabel
$cosmicMessage''';
  }

  String _getChaseInterpretation(zodiac.ZodiacSign sign) {
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language).toUpperCase();
    final elementName = sign.element.localizedName(language);

    final title = L10nService.getWithParams('widgets.dreams.interpretations.chase.title', language, params: {'sign': signName});
    final basicLabel = L10nService.get('widgets.dreams.interpretations.chase.basic_meaning_label', language);
    final basicMeaning = L10nService.get('widgets.dreams.interpretations.chase.basic_meaning', language);
    final specialInterpretation = L10nService.getWithParams('widgets.dreams.interpretations.chase.special_interpretation', language, params: {'element': elementName});
    final psychLabel = L10nService.get('widgets.dreams.interpretations.chase.psychological_label', language);
    final psychological = L10nService.get('widgets.dreams.interpretations.chase.psychological', language);
    final chaserLabel = L10nService.get('widgets.dreams.interpretations.chase.chaser_label', language);
    final chaser = L10nService.get('widgets.dreams.interpretations.chase.chaser', language);
    final practiceLabel = L10nService.get('widgets.dreams.interpretations.chase.practice_label', language);
    final practice = L10nService.get('widgets.dreams.interpretations.chase.practice', language);
    final cosmicLabel = L10nService.get('widgets.dreams.interpretations.chase.cosmic_message_label', language);
    final cosmicMessage = L10nService.get('widgets.dreams.interpretations.chase.cosmic_message', language);

    return '''$title
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$basicLabel
$basicMeaning

${sign.symbol} $signName
$specialInterpretation

$psychLabel
$psychological

$chaserLabel
$chaser

$practiceLabel
$practice

$cosmicLabel
$cosmicMessage''';
  }

  String _getAnimalInterpretation(zodiac.ZodiacSign sign) {
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language).toUpperCase();
    final elementName = sign.element.localizedName(language);

    final title = L10nService.getWithParams('widgets.dreams.interpretations.animal.title', language, params: {'sign': signName});
    final basicLabel = L10nService.get('widgets.dreams.interpretations.animal.basic_meaning_label', language);
    final basicMeaning = L10nService.get('widgets.dreams.interpretations.animal.basic_meaning', language);
    final specialInterpretation = L10nService.get('widgets.dreams.interpretations.animal.special_interpretation', language);
    final symbolsLabel = L10nService.get('widgets.dreams.interpretations.animal.common_symbols_label', language);
    final symbols = L10nService.get('widgets.dreams.interpretations.animal.common_symbols', language);
    final psychLabel = L10nService.get('widgets.dreams.interpretations.animal.psychological_label', language);
    final psychological = L10nService.get('widgets.dreams.interpretations.animal.psychological', language);
    final practiceLabel = L10nService.get('widgets.dreams.interpretations.animal.practice_label', language);
    final practice = L10nService.get('widgets.dreams.interpretations.animal.practice', language);
    final cosmicLabel = L10nService.get('widgets.dreams.interpretations.animal.cosmic_message_label', language);
    final cosmicMessage = L10nService.getWithParams('widgets.dreams.interpretations.animal.cosmic_message', language, params: {'element': elementName});

    return '''$title
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$basicLabel
$basicMeaning

${sign.symbol} $signName
$specialInterpretation

$symbolsLabel
$symbols

$psychLabel
$psychological

$practiceLabel
$practice

$cosmicLabel
$cosmicMessage''';
  }

  String _getHouseInterpretation(zodiac.ZodiacSign sign) {
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language).toUpperCase();
    final elementName = sign.element.localizedName(language);

    final title = L10nService.getWithParams('widgets.dreams.interpretations.house.title', language, params: {'sign': signName});
    final basicLabel = L10nService.get('widgets.dreams.interpretations.house.basic_meaning_label', language);
    final basicMeaning = L10nService.get('widgets.dreams.interpretations.house.basic_meaning', language);
    final specialInterpretation = L10nService.getWithParams('widgets.dreams.interpretations.house.special_interpretation', language, params: {'element': elementName});
    final roomLabel = L10nService.get('widgets.dreams.interpretations.house.room_meanings_label', language);
    final roomMeanings = L10nService.get('widgets.dreams.interpretations.house.room_meanings', language);
    final statesLabel = L10nService.get('widgets.dreams.interpretations.house.house_states_label', language);
    final houseStates = L10nService.get('widgets.dreams.interpretations.house.house_states', language);
    final practiceLabel = L10nService.get('widgets.dreams.interpretations.house.practice_label', language);
    final practice = L10nService.get('widgets.dreams.interpretations.house.practice', language);
    final cosmicLabel = L10nService.get('widgets.dreams.interpretations.house.cosmic_message_label', language);
    final cosmicMessage = L10nService.get('widgets.dreams.interpretations.house.cosmic_message', language);

    return '''$title
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$basicLabel
$basicMeaning

${sign.symbol} $signName
$specialInterpretation

$roomLabel
$roomMeanings

$statesLabel
$houseStates

$practiceLabel
$practice

$cosmicLabel
$cosmicMessage''';
  }

  String _getLoveInterpretation(zodiac.ZodiacSign sign) {
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language).toUpperCase();
    final elementName = sign.element.localizedName(language);
    final elementKey = _getElementKey(sign.element);
    final elementMessage = L10nService.get('widgets.dreams.interpretations.element_messages.${elementKey}_love', language);

    final title = L10nService.getWithParams('widgets.dreams.interpretations.love.title', language, params: {'sign': signName});
    final basicLabel = L10nService.get('widgets.dreams.interpretations.love.basic_meaning_label', language);
    final basicMeaning = L10nService.get('widgets.dreams.interpretations.love.basic_meaning', language);
    final specialInterpretation = L10nService.get('widgets.dreams.interpretations.love.special_interpretation', language);
    final typesLabel = L10nService.get('widgets.dreams.interpretations.love.dream_types_label', language);
    final types = L10nService.get('widgets.dreams.interpretations.love.dream_types', language);
    final scenariosLabel = L10nService.get('widgets.dreams.interpretations.love.scenarios_label', language);
    final scenarios = L10nService.get('widgets.dreams.interpretations.love.scenarios', language);
    final psychLabel = L10nService.get('widgets.dreams.interpretations.love.psychological_label', language);
    final psychological = L10nService.get('widgets.dreams.interpretations.love.psychological', language);
    final practiceLabel = L10nService.get('widgets.dreams.interpretations.love.practice_label', language);
    final practice = L10nService.get('widgets.dreams.interpretations.love.practice', language);
    final cosmicLabel = L10nService.get('widgets.dreams.interpretations.love.cosmic_message_label', language);
    final cosmicMessage = L10nService.getWithParams('widgets.dreams.interpretations.love.cosmic_message', language, params: {'element': elementName, 'element_message': elementMessage});

    return '''$title
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$basicLabel
$basicMeaning

${sign.symbol} $signName
$specialInterpretation

$typesLabel
$types

$scenariosLabel
$scenarios

$psychLabel
$psychological

$practiceLabel
$practice

$cosmicLabel
$cosmicMessage''';
  }

  String _getMoneyInterpretation(zodiac.ZodiacSign sign) {
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language).toUpperCase();
    final elementName = sign.element.localizedName(language);
    final elementKey = _getElementKey(sign.element);
    final elementMessage = L10nService.get('widgets.dreams.interpretations.element_messages.${elementKey}_money', language);

    final title = L10nService.getWithParams('widgets.dreams.interpretations.money.title', language, params: {'sign': signName});
    final basicLabel = L10nService.get('widgets.dreams.interpretations.money.basic_meaning_label', language);
    final basicMeaning = L10nService.get('widgets.dreams.interpretations.money.basic_meaning', language);
    final specialInterpretation = L10nService.get('widgets.dreams.interpretations.money.special_interpretation', language);
    final typesLabel = L10nService.get('widgets.dreams.interpretations.money.dream_types_label', language);
    final types = L10nService.get('widgets.dreams.interpretations.money.dream_types', language);
    final symbolsLabel = L10nService.get('widgets.dreams.interpretations.money.symbols_label', language);
    final symbols = L10nService.get('widgets.dreams.interpretations.money.symbols', language);
    final psychLabel = L10nService.get('widgets.dreams.interpretations.money.psychological_label', language);
    final psychological = L10nService.get('widgets.dreams.interpretations.money.psychological', language);
    final practiceLabel = L10nService.get('widgets.dreams.interpretations.money.practice_label', language);
    final practice = L10nService.get('widgets.dreams.interpretations.money.practice', language);
    final cosmicLabel = L10nService.get('widgets.dreams.interpretations.money.cosmic_message_label', language);
    final cosmicMessage = L10nService.getWithParams('widgets.dreams.interpretations.money.cosmic_message', language, params: {'element': elementName, 'element_message': elementMessage});

    return '''$title
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$basicLabel
$basicMeaning

${sign.symbol} $signName
$specialInterpretation

$typesLabel
$types

$symbolsLabel
$symbols

$psychLabel
$psychological

$practiceLabel
$practice

$cosmicLabel
$cosmicMessage''';
  }

  String _getGenericInterpretation(zodiac.ZodiacSign sign, String dreamText) {
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language).toUpperCase();
    final elementName = sign.element.localizedName(language);
    final elementKey = _getElementKey(sign.element);
    final elementMessage = L10nService.get('widgets.dreams.interpretations.element_messages.${elementKey}_generic', language);

    final title = L10nService.getWithParams('widgets.dreams.interpretations.generic.title', language, params: {'sign': signName});
    final subconLabel = L10nService.get('widgets.dreams.interpretations.generic.subconscious_label', language);
    final subconscious = L10nService.get('widgets.dreams.interpretations.generic.subconscious', language);
    final elementLabel = L10nService.getWithParams('widgets.dreams.interpretations.generic.element_perspective_label', language, params: {'element': elementName.toUpperCase()});
    final elementPerspective = L10nService.getWithParams('widgets.dreams.interpretations.generic.element_perspective', language, params: {'element': elementName, 'element_message': elementMessage});
    final emotionLabel = L10nService.get('widgets.dreams.interpretations.generic.emotion_label', language);
    final emotion = L10nService.get('widgets.dreams.interpretations.generic.emotion', language);
    final symbolLabel = L10nService.get('widgets.dreams.interpretations.generic.symbol_reading_label', language);
    final symbolReading = L10nService.get('widgets.dreams.interpretations.generic.symbol_reading', language);
    final practiceLabel = L10nService.get('widgets.dreams.interpretations.generic.practice_label', language);
    final practice = L10nService.get('widgets.dreams.interpretations.generic.practice', language);
    final adviceLabel = L10nService.getWithParams('widgets.dreams.interpretations.generic.advice_label', language, params: {'sign': signName});

    return '''${sign.symbol} $title
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$subconLabel
$subconscious

$elementLabel
$elementPerspective

$emotionLabel
$emotion

$symbolLabel
$symbolReading

$practiceLabel
$practice

$adviceLabel
${_getZodiacAdvice(sign)}''';
  }

  String _getZodiacAdvice(zodiac.ZodiacSign sign) {
    final language = ref.read(languageProvider);
    final signKeyMap = {
      zodiac.ZodiacSign.aries: 'aries',
      zodiac.ZodiacSign.taurus: 'taurus',
      zodiac.ZodiacSign.gemini: 'gemini',
      zodiac.ZodiacSign.cancer: 'cancer',
      zodiac.ZodiacSign.leo: 'leo',
      zodiac.ZodiacSign.virgo: 'virgo',
      zodiac.ZodiacSign.libra: 'libra',
      zodiac.ZodiacSign.scorpio: 'scorpio',
      zodiac.ZodiacSign.sagittarius: 'sagittarius',
      zodiac.ZodiacSign.capricorn: 'capricorn',
      zodiac.ZodiacSign.aquarius: 'aquarius',
      zodiac.ZodiacSign.pisces: 'pisces',
    };
    final signKey = signKeyMap[sign] ?? 'aries';
    return L10nService.get('widgets.dreams.interpretations.zodiac_advice.$signKey', language);
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
            AppColors.mystic.withValues(alpha: 0.3),
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
                      AppColors.mystic.withValues(alpha: 0.5 + _pulseController.value * 0.3),
                      AppColors.nebulaPurple.withValues(alpha: 0.3),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mystic.withValues(alpha: 0.4 * _pulseController.value),
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
                            AppColors.mystic.withValues(alpha: 0.25),
                            AppColors.nebulaPurple.withValues(alpha: 0.15),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.mystic.withValues(alpha: 0.35),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mystic.withValues(alpha: 0.1),
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
                color: AppColors.textSecondary.withValues(alpha: 0.7),
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
                    AppColors.mystic.withValues(alpha: 0.5),
                    AppColors.nebulaPurple.withValues(alpha: 0.3),
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
                          AppColors.cosmicPurple.withValues(alpha: 0.4),
                          AppColors.nebulaPurple.withValues(alpha: 0.3),
                        ]
                      : [
                          AppColors.mystic.withValues(alpha: 0.2),
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
                      : AppColors.mystic.withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isUser ? AppColors.cosmicPurple : AppColors.mystic)
                        .withValues(alpha: 0.1),
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
                  AppColors.mystic.withValues(alpha: 0.5),
                  AppColors.nebulaPurple.withValues(alpha: 0.3),
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
              color: AppColors.mystic.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.mystic.withValues(alpha: 0.2),
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
            AppColors.nebulaPurple.withValues(alpha: 0.5),
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
                    AppColors.mystic.withValues(alpha: 0.15),
                    const Color(0xFF1A1A2E).withValues(alpha: 0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.mystic.withValues(alpha: 0.3),
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
                    hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.6)),
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
                    color: AppColors.mystic.withValues(alpha: 0.4),
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
                  AppColors.cosmicPurple.withValues(alpha: 0.3),
                  AppColors.mystic.withValues(alpha: 0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.mystic.withValues(alpha: 0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.mystic.withValues(alpha: 0.1),
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
              color: AppColors.textSecondary.withValues(alpha: 0.3),
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
                        AppColors.mystic.withValues(alpha: 0.2),
                        const Color(0xFF1A1A2E).withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.mystic.withValues(alpha: 0.2),
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
                                color: AppColors.textSecondary.withValues(alpha: 0.8),
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
