import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/personality_archetype.dart' as archetype;
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/entertainment_disclaimer.dart';
import '../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';

/// Inner Dream Guide - AI-Powered Dream Chatbot
/// Conversational dream interpretation experience
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


  // Suggested dream prompts - i18n method
  List<Map<String, dynamic>> _getSuggestedDreamPrompts(AppLanguage language) {
    return [
      // Water & Nature dreams
      {
        'emoji': '🌊',
        'text': L10nService.get(
          'widgets.dreams.prompts.water_breathing',
          language,
        ),
        'category': 'su',
      },
      {
        'emoji': '🌧️',
        'text': L10nService.get(
          'widgets.dreams.prompts.rain_running',
          language,
        ),
        'category': 'su',
      },
      {
        'emoji': '🏊',
        'text': L10nService.get('widgets.dreams.prompts.lake_diving', language),
        'category': 'su',
      },
      {
        'emoji': '🌈',
        'text': L10nService.get(
          'widgets.dreams.prompts.waterfall_passage',
          language,
        ),
        'category': 'su',
      },

      // Animal dreams
      {
        'emoji': '🐍',
        'text': L10nService.get(
          'widgets.dreams.prompts.snake_approaching',
          language,
        ),
        'category': 'hayvan',
      },
      {
        'emoji': '🦅',
        'text': L10nService.get(
          'widgets.dreams.prompts.eagle_riding',
          language,
        ),
        'category': 'hayvan',
      },
      {
        'emoji': '🐺',
        'text': L10nService.get('widgets.dreams.prompts.wolf_pack', language),
        'category': 'hayvan',
      },
      {
        'emoji': '🦋',
        'text': L10nService.get(
          'widgets.dreams.prompts.butterfly_transform',
          language,
        ),
        'category': 'hayvan',
      },
      {
        'emoji': '🐱',
        'text': L10nService.get('widgets.dreams.prompts.talking_cat', language),
        'category': 'hayvan',
      },

      // Flying & Falling dreams
      {
        'emoji': '🦸',
        'text': L10nService.get('widgets.dreams.prompts.flying_free', language),
        'category': 'ucmak',
      },
      {
        'emoji': '⬇️',
        'text': L10nService.get(
          'widgets.dreams.prompts.falling_high',
          language,
        ),
        'category': 'dusmek',
      },
      {
        'emoji': '🎈',
        'text': L10nService.get(
          'widgets.dreams.prompts.balloon_floating',
          language,
        ),
        'category': 'ucmak',
      },
      {
        'emoji': '🪂',
        'text': L10nService.get(
          'widgets.dreams.prompts.parachute_fail',
          language,
        ),
        'category': 'dusmek',
      },

      // Chase dreams
      {
        'emoji': '🏃',
        'text': L10nService.get(
          'widgets.dreams.prompts.running_stuck',
          language,
        ),
        'category': 'kovalanmak',
      },
      {
        'emoji': '👤',
        'text': L10nService.get(
          'widgets.dreams.prompts.shadow_follower',
          language,
        ),
        'category': 'kovalanmak',
      },
      {
        'emoji': '🚪',
        'text': L10nService.get(
          'widgets.dreams.prompts.corridor_doors',
          language,
        ),
        'category': 'kovalanmak',
      },
      {
        'emoji': '🌑',
        'text': L10nService.get(
          'widgets.dreams.prompts.darkness_escape',
          language,
        ),
        'category': 'kovalanmak',
      },

      // House & Place dreams
      {
        'emoji': '🏠',
        'text': L10nService.get(
          'widgets.dreams.prompts.secret_rooms',
          language,
        ),
        'category': 'ev',
      },
      {
        'emoji': '🏚️',
        'text': L10nService.get(
          'widgets.dreams.prompts.childhood_home',
          language,
        ),
        'category': 'ev',
      },
      {
        'emoji': '🏰',
        'text': L10nService.get('widgets.dreams.prompts.palace_lost', language),
        'category': 'ev',
      },
      {
        'emoji': '🛗',
        'text': L10nService.get(
          'widgets.dreams.prompts.elevator_wrong',
          language,
        ),
        'category': 'ev',
      },

      // People & Relationship dreams
      {
        'emoji': '👨‍👩‍👧',
        'text': L10nService.get(
          'widgets.dreams.prompts.deceased_relative',
          language,
        ),
        'category': 'insan',
      },
      {
        'emoji': '💔',
        'text': L10nService.get('widgets.dreams.prompts.ex_stranger', language),
        'category': 'insan',
      },
      {
        'emoji': '👶',
        'text': L10nService.get(
          'widgets.dreams.prompts.unknown_baby',
          language,
        ),
        'category': 'bebek',
      },
      {
        'emoji': '👰',
        'text': L10nService.get(
          'widgets.dreams.prompts.wedding_blur',
          language,
        ),
        'category': 'gelin',
      },
      {
        'emoji': '👯',
        'text': L10nService.get(
          'widgets.dreams.prompts.watching_self',
          language,
        ),
        'category': 'insan',
      },

      // Body dreams
      {
        'emoji': '🦷',
        'text': L10nService.get(
          'widgets.dreams.prompts.teeth_falling',
          language,
        ),
        'category': 'dis',
      },
      {
        'emoji': '💇',
        'text': L10nService.get('widgets.dreams.prompts.hair_change', language),
        'category': 'beden',
      },
      {
        'emoji': '👁️',
        'text': L10nService.get(
          'widgets.dreams.prompts.mirror_other',
          language,
        ),
        'category': 'beden',
      },
      {
        'emoji': '🫀',
        'text': L10nService.get('widgets.dreams.prompts.body_frozen', language),
        'category': 'beden',
      },

      // Element dreams
      {
        'emoji': '🔥',
        'text': L10nService.get('widgets.dreams.prompts.fire_immune', language),
        'category': 'ates',
      },
      {
        'emoji': '⚡',
        'text': L10nService.get(
          'widgets.dreams.prompts.lightning_power',
          language,
        ),
        'category': 'element',
      },
      {
        'emoji': '🌪️',
        'text': L10nService.get(
          'widgets.dreams.prompts.tornado_calm',
          language,
        ),
        'category': 'element',
      },
      {
        'emoji': '❄️',
        'text': L10nService.get('widgets.dreams.prompts.ice_walking', language),
        'category': 'element',
      },

      // Exam & Performance dreams
      {
        'emoji': '📝',
        'text': L10nService.get(
          'widgets.dreams.prompts.exam_unprepared',
          language,
        ),
        'category': 'sinav',
      },
      {
        'emoji': '🎤',
        'text': L10nService.get(
          'widgets.dreams.prompts.stage_voiceless',
          language,
        ),
        'category': 'sinav',
      },
      {
        'emoji': '🏃‍♂️',
        'text': L10nService.get('widgets.dreams.prompts.race_stuck', language),
        'category': 'sinav',
      },
      {
        'emoji': '🎭',
        'text': L10nService.get(
          'widgets.dreams.prompts.acting_forgot',
          language,
        ),
        'category': 'sinav',
      },

      // Death & Transformation dreams
      {
        'emoji': '💀',
        'text': L10nService.get(
          'widgets.dreams.prompts.death_watching',
          language,
        ),
        'category': 'olum',
      },
      {
        'emoji': '⚰️',
        'text': L10nService.get(
          'widgets.dreams.prompts.funeral_crying',
          language,
        ),
        'category': 'olum',
      },
      {
        'emoji': '🔄',
        'text': L10nService.get(
          'widgets.dreams.prompts.death_rebirth',
          language,
        ),
        'category': 'olum',
      },
      {
        'emoji': '👻',
        'text': L10nService.get(
          'widgets.dreams.prompts.ghost_invisible',
          language,
        ),
        'category': 'olum',
      },

      // Money & Abundance dreams
      {
        'emoji': '💰',
        'text': L10nService.get(
          'widgets.dreams.prompts.gold_uncollectable',
          language,
        ),
        'category': 'para',
      },
      {
        'emoji': '🏆',
        'text': L10nService.get(
          'widgets.dreams.prompts.lottery_lost',
          language,
        ),
        'category': 'para',
      },
      {
        'emoji': '💎',
        'text': L10nService.get(
          'widgets.dreams.prompts.treasure_chest',
          language,
        ),
        'category': 'para',
      },

      // Vehicle & Journey dreams
      {
        'emoji': '🚗',
        'text': L10nService.get(
          'widgets.dreams.prompts.car_brakes_fail',
          language,
        ),
        'category': 'araba',
      },
      {
        'emoji': '✈️',
        'text': L10nService.get('widgets.dreams.prompts.plane_calm', language),
        'category': 'yolculuk',
      },
      {
        'emoji': '🚂',
        'text': L10nService.get(
          'widgets.dreams.prompts.train_missed',
          language,
        ),
        'category': 'yolculuk',
      },
      {
        'emoji': '🛤️',
        'text': L10nService.get(
          'widgets.dreams.prompts.endless_road',
          language,
        ),
        'category': 'yolculuk',
      },

      // Mystical & Spiritual dreams
      {
        'emoji': '🔮',
        'text': L10nService.get(
          'widgets.dreams.prompts.seeing_future',
          language,
        ),
        'category': 'mistik',
      },
      {
        'emoji': '👼',
        'text': L10nService.get('widgets.dreams.prompts.angel_light', language),
        'category': 'mistik',
      },
      {
        'emoji': '🌙',
        'text': L10nService.get(
          'widgets.dreams.prompts.moon_message',
          language,
        ),
        'category': 'mistik',
      },
      {
        'emoji': '⭐',
        'text': L10nService.get(
          'widgets.dreams.prompts.stars_rising',
          language,
        ),
        'category': 'mistik',
      },
      {
        'emoji': '🪬',
        'text': L10nService.get(
          'widgets.dreams.prompts.portal_world',
          language,
        ),
        'category': 'mistik',
      },
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
    final sign = userProfile != null
        ? archetype.PersonalityArchetypeExtension.fromDate(userProfile.birthDate)
        : archetype.PersonalityArchetype.pioneer;
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language);

    final welcomeText = L10nService.get(
      'widgets.dreams.welcome_message',
      language,
    ).replaceAll('{signName}', signName);

    setState(() {
      _messages.add(
        ChatMessage(
          text: '$welcomeText⚠️ ${DisclaimerTexts.dreams(language)}',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  void _sendMessage() async {
    final text = _dreamController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
      );
      _isTyping = true;
    });

    _dreamController.clear();
    _scrollToBottom();

    // Start dream interpretation
    await _startApexInterpretation(text);
  }

  /// Start dream interpretation using local pattern-based engine
  Future<void> _startApexInterpretation(String dreamText) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _generateInterpretation(dreamText);
  }

  void _generateInterpretation(String dreamText) {
    final userProfile = ref.read(userProfileProvider);
    final sign = userProfile != null
        ? archetype.PersonalityArchetypeExtension.fromDate(userProfile.birthDate)
        : archetype.PersonalityArchetype.pioneer;

    // Generate interpretation based on dream content and personality profile
    final interpretation = _interpretDream(dreamText, sign);

    setState(() {
      _isTyping = false;
      _messages.add(
        ChatMessage(
          text: interpretation,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });

    _scrollToBottom();
  }

  String _interpretDream(String dreamText, archetype.PersonalityArchetype sign) {
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
      // Generic interpretation based on personality archetype
      buffer.writeln(_getGenericInterpretation(sign, dreamText));
    } else {
      final signPerspective = L10nService.getWithParams(
        'widgets.dreams.interpretations.sign_perspective',
        language,
        params: {'sign': sign.localizedName(language)},
      );
      buffer.writeln('$signPerspective\n');

      for (final entry in themes.entries) {
        buffer.writeln(entry.value);
        buffer.writeln();
      }

      buffer.writeln(_getPersonalAdvice(sign));
    }

    return buffer.toString().trim();
  }

  String _getWaterInterpretation(archetype.PersonalityArchetype sign) {
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language).toUpperCase();
    final elementName = sign.element.localizedName(language);

    // Map sign to JSON key
    final signKeyMap = {
      archetype.PersonalityArchetype.pioneer: 'pioneer',
      archetype.PersonalityArchetype.builder: 'builder',
      archetype.PersonalityArchetype.nurturer: 'nurturer',
      archetype.PersonalityArchetype.transformer: 'transformer',
      archetype.PersonalityArchetype.dreamer: 'dreamer',
    };

    final signKey = signKeyMap[sign];

    if (signKey != null) {
      final title = L10nService.getWithParams(
        'widgets.dreams.interpretations.water.title',
        language,
        params: {'sign': signName},
      );
      final divider = L10nService.get(
        'widgets.dreams.interpretations.water.divider',
        language,
      );
      final basicLabel = L10nService.get(
        'widgets.dreams.interpretations.water.basic_meaning_label',
        language,
      );
      final elementLabel = L10nService.getWithParams(
        'widgets.dreams.interpretations.water.element_perspective_label',
        language,
        params: {'element': elementName.toUpperCase()},
      );
      final psychLabel = L10nService.get(
        'widgets.dreams.interpretations.water.psychological_label',
        language,
      );
      final practiceLabel = L10nService.get(
        'widgets.dreams.interpretations.water.practice_label',
        language,
      );

      final basicMeaning = L10nService.get(
        'widgets.dreams.interpretations.water.$signKey.basic_meaning',
        language,
      );
      final elementPerspective = L10nService.get(
        'widgets.dreams.interpretations.water.$signKey.element_perspective',
        language,
      );
      final psychological = L10nService.get(
        'widgets.dreams.interpretations.water.$signKey.psychological',
        language,
      );
      final practice = L10nService.get(
        'widgets.dreams.interpretations.water.$signKey.practice',
        language,
      );

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
    final title = L10nService.getWithParams(
      'widgets.dreams.interpretations.water.title',
      language,
      params: {'sign': signName},
    );
    final divider = L10nService.get(
      'widgets.dreams.interpretations.water.divider',
      language,
    );
    final basicLabel = L10nService.get(
      'widgets.dreams.interpretations.water.basic_meaning_label',
      language,
    );
    final elementLabel = L10nService.getWithParams(
      'widgets.dreams.interpretations.water.element_perspective_label',
      language,
      params: {'element': elementName.toUpperCase()},
    );
    final practiceLabel = L10nService.get(
      'widgets.dreams.interpretations.water.practice_label',
      language,
    );

    final basicMeaning = L10nService.getWithParams(
      'widgets.dreams.interpretations.water.default.basic_meaning',
      language,
      params: {'element': elementName},
    );
    final elementPerspective = L10nService.get(
      'widgets.dreams.interpretations.water.default.element_perspective',
      language,
    );
    final practice = L10nService.get(
      'widgets.dreams.interpretations.water.default.practice',
      language,
    );

    return '''$title
$divider

$basicLabel
$basicMeaning

$elementLabel
$elementPerspective

$practiceLabel
$practice''';
  }

  String _getFlyingInterpretation(archetype.PersonalityArchetype sign) {
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language).toUpperCase();
    final elementName = sign.element.localizedName(language);
    final elementKey = _getElementKey(sign.element);
    final elementMessage = L10nService.get(
      'widgets.dreams.interpretations.element_messages.${elementKey}_flying',
      language,
    );

    final title = L10nService.getWithParams(
      'widgets.dreams.interpretations.flying.title',
      language,
      params: {'sign': signName},
    );
    final basicLabel = L10nService.get(
      'widgets.dreams.interpretations.flying.basic_meaning_label',
      language,
    );
    final basicMeaning = L10nService.get(
      'widgets.dreams.interpretations.flying.basic_meaning',
      language,
    );
    final specialLabel = L10nService.getWithParams(
      'widgets.dreams.interpretations.flying.special_interpretation_label',
      language,
      params: {'sign': signName},
    );
    final specialInterpretation = L10nService.get(
      'widgets.dreams.interpretations.flying.special_interpretation',
      language,
    );
    final psychLabel = L10nService.get(
      'widgets.dreams.interpretations.flying.psychological_label',
      language,
    );
    final psychological = L10nService.get(
      'widgets.dreams.interpretations.flying.psychological',
      language,
    );
    final flightStyleLabel = L10nService.get(
      'widgets.dreams.interpretations.flying.flight_style_label',
      language,
    );
    final flightStyle = L10nService.get(
      'widgets.dreams.interpretations.flying.flight_style',
      language,
    );
    final practiceLabel = L10nService.get(
      'widgets.dreams.interpretations.flying.practice_label',
      language,
    );
    final practice = L10nService.get(
      'widgets.dreams.interpretations.flying.practice',
      language,
    );
    final cosmicLabel = L10nService.get(
      'widgets.dreams.interpretations.flying.cosmic_message_label',
      language,
    );
    final cosmicMessage = L10nService.getWithParams(
      'widgets.dreams.interpretations.flying.cosmic_message',
      language,
      params: {'element': elementName, 'element_message': elementMessage},
    );

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

  String _getElementKey(archetype.Element element) {
    switch (element) {
      case archetype.Element.fire:
        return 'fire';
      case archetype.Element.earth:
        return 'earth';
      case archetype.Element.air:
        return 'air';
      case archetype.Element.water:
        return 'water';
    }
  }

  String _getFallingInterpretation(archetype.PersonalityArchetype sign) {
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language).toUpperCase();
    final elementName = sign.element.localizedName(language);

    final title = L10nService.getWithParams(
      'widgets.dreams.interpretations.falling.title',
      language,
      params: {'sign': signName},
    );
    final basicLabel = L10nService.get(
      'widgets.dreams.interpretations.falling.basic_meaning_label',
      language,
    );
    final basicMeaning = L10nService.get(
      'widgets.dreams.interpretations.falling.basic_meaning',
      language,
    );
    final specialInterpretation = L10nService.get(
      'widgets.dreams.interpretations.falling.special_interpretation',
      language,
    );
    final psychLabel = L10nService.get(
      'widgets.dreams.interpretations.falling.psychological_label',
      language,
    );
    final psychological = L10nService.get(
      'widgets.dreams.interpretations.falling.psychological',
      language,
    );
    final attentionLabel = L10nService.get(
      'widgets.dreams.interpretations.falling.attention_label',
      language,
    );
    final attention = L10nService.get(
      'widgets.dreams.interpretations.falling.attention',
      language,
    );
    final practiceLabel = L10nService.get(
      'widgets.dreams.interpretations.falling.practice_label',
      language,
    );
    final practice = L10nService.get(
      'widgets.dreams.interpretations.falling.practice',
      language,
    );
    final cosmicLabel = L10nService.get(
      'widgets.dreams.interpretations.falling.cosmic_message_label',
      language,
    );
    final cosmicMessage = L10nService.getWithParams(
      'widgets.dreams.interpretations.falling.cosmic_message',
      language,
      params: {'element': elementName},
    );

    return '''$title
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$basicLabel
$basicMeaning

$signName
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

  String _getDeathInterpretation(archetype.PersonalityArchetype sign) {
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language).toUpperCase();

    final title = L10nService.getWithParams(
      'widgets.dreams.interpretations.death.title',
      language,
      params: {'sign': signName},
    );
    final notScaryLabel = L10nService.get(
      'widgets.dreams.interpretations.death.not_scary_label',
      language,
    );
    final notScary = L10nService.get(
      'widgets.dreams.interpretations.death.not_scary',
      language,
    );
    final specialInterpretation = L10nService.get(
      'widgets.dreams.interpretations.death.special_interpretation',
      language,
    );
    final psychLabel = L10nService.get(
      'widgets.dreams.interpretations.death.psychological_label',
      language,
    );
    final psychological = L10nService.get(
      'widgets.dreams.interpretations.death.psychological',
      language,
    );
    final transformLabel = L10nService.get(
      'widgets.dreams.interpretations.death.transformation_label',
      language,
    );
    final transformation = L10nService.get(
      'widgets.dreams.interpretations.death.transformation',
      language,
    );
    final practiceLabel = L10nService.get(
      'widgets.dreams.interpretations.death.practice_label',
      language,
    );
    final practice = L10nService.get(
      'widgets.dreams.interpretations.death.practice',
      language,
    );
    final cosmicLabel = L10nService.get(
      'widgets.dreams.interpretations.death.cosmic_message_label',
      language,
    );
    final cosmicMessage = L10nService.getWithParams(
      'widgets.dreams.interpretations.death.cosmic_message',
      language,
      params: {'sign': sign.localizedName(language)},
    );

    return '''$title
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$notScaryLabel
$notScary

$signName
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

  String _getChaseInterpretation(archetype.PersonalityArchetype sign) {
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language).toUpperCase();
    final elementName = sign.element.localizedName(language);

    final title = L10nService.getWithParams(
      'widgets.dreams.interpretations.chase.title',
      language,
      params: {'sign': signName},
    );
    final basicLabel = L10nService.get(
      'widgets.dreams.interpretations.chase.basic_meaning_label',
      language,
    );
    final basicMeaning = L10nService.get(
      'widgets.dreams.interpretations.chase.basic_meaning',
      language,
    );
    final specialInterpretation = L10nService.getWithParams(
      'widgets.dreams.interpretations.chase.special_interpretation',
      language,
      params: {'element': elementName},
    );
    final psychLabel = L10nService.get(
      'widgets.dreams.interpretations.chase.psychological_label',
      language,
    );
    final psychological = L10nService.get(
      'widgets.dreams.interpretations.chase.psychological',
      language,
    );
    final chaserLabel = L10nService.get(
      'widgets.dreams.interpretations.chase.chaser_label',
      language,
    );
    final chaser = L10nService.get(
      'widgets.dreams.interpretations.chase.chaser',
      language,
    );
    final practiceLabel = L10nService.get(
      'widgets.dreams.interpretations.chase.practice_label',
      language,
    );
    final practice = L10nService.get(
      'widgets.dreams.interpretations.chase.practice',
      language,
    );
    final cosmicLabel = L10nService.get(
      'widgets.dreams.interpretations.chase.cosmic_message_label',
      language,
    );
    final cosmicMessage = L10nService.get(
      'widgets.dreams.interpretations.chase.cosmic_message',
      language,
    );

    return '''$title
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$basicLabel
$basicMeaning

$signName
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

  String _getAnimalInterpretation(archetype.PersonalityArchetype sign) {
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language).toUpperCase();
    final elementName = sign.element.localizedName(language);

    final title = L10nService.getWithParams(
      'widgets.dreams.interpretations.animal.title',
      language,
      params: {'sign': signName},
    );
    final basicLabel = L10nService.get(
      'widgets.dreams.interpretations.animal.basic_meaning_label',
      language,
    );
    final basicMeaning = L10nService.get(
      'widgets.dreams.interpretations.animal.basic_meaning',
      language,
    );
    final specialInterpretation = L10nService.get(
      'widgets.dreams.interpretations.animal.special_interpretation',
      language,
    );
    final symbolsLabel = L10nService.get(
      'widgets.dreams.interpretations.animal.common_symbols_label',
      language,
    );
    final symbols = L10nService.get(
      'widgets.dreams.interpretations.animal.common_symbols',
      language,
    );
    final psychLabel = L10nService.get(
      'widgets.dreams.interpretations.animal.psychological_label',
      language,
    );
    final psychological = L10nService.get(
      'widgets.dreams.interpretations.animal.psychological',
      language,
    );
    final practiceLabel = L10nService.get(
      'widgets.dreams.interpretations.animal.practice_label',
      language,
    );
    final practice = L10nService.get(
      'widgets.dreams.interpretations.animal.practice',
      language,
    );
    final cosmicLabel = L10nService.get(
      'widgets.dreams.interpretations.animal.cosmic_message_label',
      language,
    );
    final cosmicMessage = L10nService.getWithParams(
      'widgets.dreams.interpretations.animal.cosmic_message',
      language,
      params: {'element': elementName},
    );

    return '''$title
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$basicLabel
$basicMeaning

$signName
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

  String _getHouseInterpretation(archetype.PersonalityArchetype sign) {
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language).toUpperCase();
    final elementName = sign.element.localizedName(language);

    final title = L10nService.getWithParams(
      'widgets.dreams.interpretations.house.title',
      language,
      params: {'sign': signName},
    );
    final basicLabel = L10nService.get(
      'widgets.dreams.interpretations.house.basic_meaning_label',
      language,
    );
    final basicMeaning = L10nService.get(
      'widgets.dreams.interpretations.house.basic_meaning',
      language,
    );
    final specialInterpretation = L10nService.getWithParams(
      'widgets.dreams.interpretations.house.special_interpretation',
      language,
      params: {'element': elementName},
    );
    final roomLabel = L10nService.get(
      'widgets.dreams.interpretations.house.room_meanings_label',
      language,
    );
    final roomMeanings = L10nService.get(
      'widgets.dreams.interpretations.house.room_meanings',
      language,
    );
    final statesLabel = L10nService.get(
      'widgets.dreams.interpretations.house.house_states_label',
      language,
    );
    final houseStates = L10nService.get(
      'widgets.dreams.interpretations.house.house_states',
      language,
    );
    final practiceLabel = L10nService.get(
      'widgets.dreams.interpretations.house.practice_label',
      language,
    );
    final practice = L10nService.get(
      'widgets.dreams.interpretations.house.practice',
      language,
    );
    final cosmicLabel = L10nService.get(
      'widgets.dreams.interpretations.house.cosmic_message_label',
      language,
    );
    final cosmicMessage = L10nService.get(
      'widgets.dreams.interpretations.house.cosmic_message',
      language,
    );

    return '''$title
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$basicLabel
$basicMeaning

$signName
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

  String _getLoveInterpretation(archetype.PersonalityArchetype sign) {
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language).toUpperCase();
    final elementName = sign.element.localizedName(language);
    final elementKey = _getElementKey(sign.element);
    final elementMessage = L10nService.get(
      'widgets.dreams.interpretations.element_messages.${elementKey}_love',
      language,
    );

    final title = L10nService.getWithParams(
      'widgets.dreams.interpretations.love.title',
      language,
      params: {'sign': signName},
    );
    final basicLabel = L10nService.get(
      'widgets.dreams.interpretations.love.basic_meaning_label',
      language,
    );
    final basicMeaning = L10nService.get(
      'widgets.dreams.interpretations.love.basic_meaning',
      language,
    );
    final specialInterpretation = L10nService.get(
      'widgets.dreams.interpretations.love.special_interpretation',
      language,
    );
    final typesLabel = L10nService.get(
      'widgets.dreams.interpretations.love.dream_types_label',
      language,
    );
    final types = L10nService.get(
      'widgets.dreams.interpretations.love.dream_types',
      language,
    );
    final scenariosLabel = L10nService.get(
      'widgets.dreams.interpretations.love.scenarios_label',
      language,
    );
    final scenarios = L10nService.get(
      'widgets.dreams.interpretations.love.scenarios',
      language,
    );
    final psychLabel = L10nService.get(
      'widgets.dreams.interpretations.love.psychological_label',
      language,
    );
    final psychological = L10nService.get(
      'widgets.dreams.interpretations.love.psychological',
      language,
    );
    final practiceLabel = L10nService.get(
      'widgets.dreams.interpretations.love.practice_label',
      language,
    );
    final practice = L10nService.get(
      'widgets.dreams.interpretations.love.practice',
      language,
    );
    final cosmicLabel = L10nService.get(
      'widgets.dreams.interpretations.love.cosmic_message_label',
      language,
    );
    final cosmicMessage = L10nService.getWithParams(
      'widgets.dreams.interpretations.love.cosmic_message',
      language,
      params: {'element': elementName, 'element_message': elementMessage},
    );

    return '''$title
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$basicLabel
$basicMeaning

$signName
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

  String _getMoneyInterpretation(archetype.PersonalityArchetype sign) {
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language).toUpperCase();
    final elementName = sign.element.localizedName(language);
    final elementKey = _getElementKey(sign.element);
    final elementMessage = L10nService.get(
      'widgets.dreams.interpretations.element_messages.${elementKey}_money',
      language,
    );

    final title = L10nService.getWithParams(
      'widgets.dreams.interpretations.money.title',
      language,
      params: {'sign': signName},
    );
    final basicLabel = L10nService.get(
      'widgets.dreams.interpretations.money.basic_meaning_label',
      language,
    );
    final basicMeaning = L10nService.get(
      'widgets.dreams.interpretations.money.basic_meaning',
      language,
    );
    final specialInterpretation = L10nService.get(
      'widgets.dreams.interpretations.money.special_interpretation',
      language,
    );
    final typesLabel = L10nService.get(
      'widgets.dreams.interpretations.money.dream_types_label',
      language,
    );
    final types = L10nService.get(
      'widgets.dreams.interpretations.money.dream_types',
      language,
    );
    final symbolsLabel = L10nService.get(
      'widgets.dreams.interpretations.money.symbols_label',
      language,
    );
    final symbols = L10nService.get(
      'widgets.dreams.interpretations.money.symbols',
      language,
    );
    final psychLabel = L10nService.get(
      'widgets.dreams.interpretations.money.psychological_label',
      language,
    );
    final psychological = L10nService.get(
      'widgets.dreams.interpretations.money.psychological',
      language,
    );
    final practiceLabel = L10nService.get(
      'widgets.dreams.interpretations.money.practice_label',
      language,
    );
    final practice = L10nService.get(
      'widgets.dreams.interpretations.money.practice',
      language,
    );
    final cosmicLabel = L10nService.get(
      'widgets.dreams.interpretations.money.cosmic_message_label',
      language,
    );
    final cosmicMessage = L10nService.getWithParams(
      'widgets.dreams.interpretations.money.cosmic_message',
      language,
      params: {'element': elementName, 'element_message': elementMessage},
    );

    return '''$title
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$basicLabel
$basicMeaning

$signName
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

  String _getGenericInterpretation(archetype.PersonalityArchetype sign, String dreamText) {
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language).toUpperCase();
    final elementName = sign.element.localizedName(language);
    final elementKey = _getElementKey(sign.element);
    final elementMessage = L10nService.get(
      'widgets.dreams.interpretations.element_messages.${elementKey}_generic',
      language,
    );

    final title = L10nService.getWithParams(
      'widgets.dreams.interpretations.generic.title',
      language,
      params: {'sign': signName},
    );
    final subconLabel = L10nService.get(
      'widgets.dreams.interpretations.generic.subconscious_label',
      language,
    );
    final subconscious = L10nService.get(
      'widgets.dreams.interpretations.generic.subconscious',
      language,
    );
    final elementLabel = L10nService.getWithParams(
      'widgets.dreams.interpretations.generic.element_perspective_label',
      language,
      params: {'element': elementName.toUpperCase()},
    );
    final elementPerspective = L10nService.getWithParams(
      'widgets.dreams.interpretations.generic.element_perspective',
      language,
      params: {'element': elementName, 'element_message': elementMessage},
    );
    final emotionLabel = L10nService.get(
      'widgets.dreams.interpretations.generic.emotion_label',
      language,
    );
    final emotion = L10nService.get(
      'widgets.dreams.interpretations.generic.emotion',
      language,
    );
    final symbolLabel = L10nService.get(
      'widgets.dreams.interpretations.generic.symbol_reading_label',
      language,
    );
    final symbolReading = L10nService.get(
      'widgets.dreams.interpretations.generic.symbol_reading',
      language,
    );
    final practiceLabel = L10nService.get(
      'widgets.dreams.interpretations.generic.practice_label',
      language,
    );
    final practice = L10nService.get(
      'widgets.dreams.interpretations.generic.practice',
      language,
    );
    final adviceLabel = L10nService.getWithParams(
      'widgets.dreams.interpretations.generic.advice_label',
      language,
      params: {'sign': signName},
    );

    return '''$title
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
${_getPersonalAdvice(sign)}''';
  }

  String _getPersonalAdvice(archetype.PersonalityArchetype sign) {
    final language = ref.read(languageProvider);
    final signKeyMap = {
      archetype.PersonalityArchetype.pioneer: 'pioneer',
      archetype.PersonalityArchetype.builder: 'builder',
      archetype.PersonalityArchetype.communicator: 'communicator',
      archetype.PersonalityArchetype.nurturer: 'nurturer',
      archetype.PersonalityArchetype.performer: 'performer',
      archetype.PersonalityArchetype.analyst: 'analyst',
      archetype.PersonalityArchetype.harmonizer: 'harmonizer',
      archetype.PersonalityArchetype.transformer: 'transformer',
      archetype.PersonalityArchetype.explorer: 'explorer',
      archetype.PersonalityArchetype.achiever: 'achiever',
      archetype.PersonalityArchetype.visionary: 'visionary',
      archetype.PersonalityArchetype.dreamer: 'dreamer',
    };
    final signKey = signKeyMap[sign] ?? 'pioneer';
    return L10nService.get(
      'widgets.dreams.interpretations.personal_advice.$signKey',
      language,
    );
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
              Expanded(child: _buildChatArea()),
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
          colors: [AppColors.mystic.withValues(alpha: 0.3), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.textPrimary,
            ),
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
                      AppColors.mystic.withValues(
                        alpha: 0.5 + _pulseController.value * 0.3,
                      ),
                      AppColors.nebulaPurple.withValues(alpha: 0.3),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mystic.withValues(
                        alpha: 0.4 * _pulseController.value,
                      ),
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
                  L10nService.get(
                    'dreams.interpretation_title',
                    ref.watch(languageProvider),
                  ),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  L10nService.get(
                    'dreams.interpretation_subtitle',
                    ref.watch(languageProvider),
                  ),
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
            tooltip: L10nService.get(
              'dreams.symbols_found',
              ref.watch(languageProvider),
            ),
          ),
        ],
      ),
    ).glassReveal(context: context);
  }

  Widget _buildChatArea() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount:
          _messages.length +
          (_isTyping ? 1 : 0) +
          (_messages.length == 1 ? 1 : 0),
      itemBuilder: (context, index) {
        // Show suggested prompts after welcome message
        if (_messages.length == 1 && index == 1 && !_isTyping) {
          return _buildSuggestedDreamPrompts();
        }
        if (index == _messages.length + (_messages.length == 1 ? 1 : 0) &&
            _isTyping) {
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
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                const Text('💭', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text(
                  L10nService.get(
                    'dreams.example_prompts_label',
                    ref.read(languageProvider),
                  ),
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
              itemCount: _getSuggestedDreamPrompts(
                ref.read(languageProvider),
              ).length,
              itemBuilder: (context, index) {
                final prompt = _getSuggestedDreamPrompts(
                  ref.read(languageProvider),
                )[index];
                return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () {
                          _dreamController.text = prompt['text'];
                          _sendMessage();
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: GlassPanel(
                          elevation: GlassElevation.g2,
                          borderRadius: BorderRadius.circular(14),
                          padding: const EdgeInsets.all(12),
                          width: 180,
                          glowColor: AppColors.mystic.withValues(alpha: 0.2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prompt['emoji'],
                                style: const TextStyle(fontSize: 22),
                              ),
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
                    )
                    .glassListItem(context: context, index: index);
              },
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              L10nService.get(
                'widgets.dreams.tap_or_write_hint',
                ref.read(languageProvider),
              ),
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    ).glassReveal(context: context, delay: const Duration(milliseconds: 300));
  }

  Widget _buildMessageBubble(ChatMessage message, int index) {
    final isUser = message.isUser;

    return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
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
                  child: const Text(
                    '\u{1F319}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: GlassPanel(
                  elevation: isUser ? GlassElevation.g2 : GlassElevation.g2,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isUser ? 18 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 18),
                  ),
                  padding: const EdgeInsets.all(14),
                  glowColor: isUser
                      ? AppColors.cosmicPurple.withValues(alpha: 0.2)
                      : AppColors.mystic.withValues(alpha: 0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.isInterpretation) ...[
                        Row(
                          children: [
                            const Text(
                              '\u{2728}',
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              L10nService.get(
                                'widgets.dreams.interpretation_label',
                                ref.watch(languageProvider),
                              ),
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
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
                            const Text(
                              '\u{2753}',
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              L10nService.get(
                                'widgets.dreams.question_label',
                                ref.watch(languageProvider),
                              ),
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
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
        )
        .glassListItem(context: context, index: index);
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
          GlassPanel(
            elevation: GlassElevation.g1,
            borderRadius: BorderRadius.circular(18),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      child: const Text(
                        '\u{2728}',
                        style: TextStyle(fontSize: 14),
                      ),
                    )
                    .animate(onComplete: (controller) => controller.repeat())
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
          Row(
            children: [
              Expanded(
                child: GlassPanel(
                  elevation: GlassElevation.g2,
                  borderRadius: BorderRadius.circular(24),
                  padding: EdgeInsets.zero,
                  child: KeyboardListener(
                    focusNode: FocusNode(),
                    onKeyEvent: (event) {
                      if (event is KeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.enter &&
                          !HardwareKeyboard.instance.isShiftPressed) {
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
                        hintText: L10nService.get(
                          'dreams.input_placeholder',
                          ref.read(languageProvider),
                        ),
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.6),
                        ),
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
                          colors: [AppColors.mystic, AppColors.cosmicPurple],
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
                    onComplete: (controller) =>
                        controller.repeat(reverse: true),
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
      {
        'emoji': '\u{1F40D}',
        'name': L10nService.get('widgets.dreams.symbols.snake_name', language),
        'meaning': L10nService.get(
          'widgets.dreams.symbols.snake_meaning',
          language,
        ),
      },
      {
        'emoji': '\u{1F30A}',
        'name': L10nService.get('widgets.dreams.symbols.water_name', language),
        'meaning': L10nService.get(
          'widgets.dreams.symbols.water_meaning',
          language,
        ),
      },
      {
        'emoji': '\u{1F525}',
        'name': L10nService.get('widgets.dreams.symbols.fire_name', language),
        'meaning': L10nService.get(
          'widgets.dreams.symbols.fire_meaning',
          language,
        ),
      },
      {
        'emoji': '\u{1F3E0}',
        'name': L10nService.get('widgets.dreams.symbols.house_name', language),
        'meaning': L10nService.get(
          'widgets.dreams.symbols.house_meaning',
          language,
        ),
      },
      {
        'emoji': '\u{2708}',
        'name': L10nService.get('widgets.dreams.symbols.flying_name', language),
        'meaning': L10nService.get(
          'widgets.dreams.symbols.flying_meaning',
          language,
        ),
      },
      {
        'emoji': '\u{1F319}',
        'name': L10nService.get('widgets.dreams.symbols.moon_name', language),
        'meaning': L10nService.get(
          'widgets.dreams.symbols.moon_meaning',
          language,
        ),
      },
      {
        'emoji': '\u{2600}',
        'name': L10nService.get('widgets.dreams.symbols.sun_name', language),
        'meaning': L10nService.get(
          'widgets.dreams.symbols.sun_meaning',
          language,
        ),
      },
      {
        'emoji': '\u{1F480}',
        'name': L10nService.get('widgets.dreams.symbols.death_name', language),
        'meaning': L10nService.get(
          'widgets.dreams.symbols.death_meaning',
          language,
        ),
      },
      {
        'emoji': '\u{1F436}',
        'name': L10nService.get('widgets.dreams.symbols.dog_name', language),
        'meaning': L10nService.get(
          'widgets.dreams.symbols.dog_meaning',
          language,
        ),
      },
      {
        'emoji': '\u{1F431}',
        'name': L10nService.get('widgets.dreams.symbols.cat_name', language),
        'meaning': L10nService.get(
          'widgets.dreams.symbols.cat_meaning',
          language,
        ),
      },
      {
        'emoji': '\u{1F4B0}',
        'name': L10nService.get('widgets.dreams.symbols.money_name', language),
        'meaning': L10nService.get(
          'widgets.dreams.symbols.money_meaning',
          language,
        ),
      },
      {
        'emoji': '\u{2764}',
        'name': L10nService.get('widgets.dreams.symbols.love_name', language),
        'meaning': L10nService.get(
          'widgets.dreams.symbols.love_meaning',
          language,
        ),
      },
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.nebulaPurple, const Color(0xFF0D0D1A)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
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
                  L10nService.get(
                    'widgets.dreams.symbols_guide_title',
                    language,
                  ),
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
                return GlassPanel(
                      elevation: GlassElevation.g2,
                      borderRadius: BorderRadius.circular(14),
                      padding: const EdgeInsets.all(12),
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
                                    color: AppColors.textSecondary.withValues(
                                      alpha: 0.8,
                                    ),
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
                    )
                    .glassListItem(context: context, index: index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
