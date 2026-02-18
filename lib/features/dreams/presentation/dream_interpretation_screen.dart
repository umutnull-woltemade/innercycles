import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/personality_archetype.dart' as archetype;
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';
import '../../../data/services/first_taste_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../data/services/smart_router_service.dart';
import '../../../data/services/ecosystem_analytics_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/content_disclaimer.dart';
import '../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';

/// Inner Dream Guide - Conversational Dream Reflection
/// Rule-based dream interpretation experience using symbol analysis
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
  final FocusNode _keyboardFocusNode = FocusNode();
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

      // Deep & Contemplative dreams
      {
        'emoji': '🔮',
        'text': L10nService.get(
          'widgets.dreams.prompts.seeing_future',
          language,
        ),
        'category': 'sezgisel',
      },
      {
        'emoji': '👼',
        'text': L10nService.get('widgets.dreams.prompts.angel_light', language),
        'category': 'sezgisel',
      },
      {
        'emoji': '🌙',
        'text': L10nService.get(
          'widgets.dreams.prompts.moon_message',
          language,
        ),
        'category': 'sezgisel',
      },
      {
        'emoji': '⭐',
        'text': L10nService.get(
          'widgets.dreams.prompts.stars_rising',
          language,
        ),
        'category': 'sezgisel',
      },
      {
        'emoji': '🪬',
        'text': L10nService.get(
          'widgets.dreams.prompts.portal_world',
          language,
        ),
        'category': 'sezgisel',
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(smartRouterServiceProvider)
          .whenData((s) => s.recordToolVisit('dreamInterpretation'));
      ref
          .read(ecosystemAnalyticsServiceProvider)
          .whenData(
            (s) => s.trackToolOpen('dreamInterpretation', source: 'direct'),
          );
    });
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
    _keyboardFocusNode.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  /// Resolve the user's personality archetype from their Jungian quiz/journal
  /// archetype (via ArchetypeService). Falls back to pioneer if unavailable.
  archetype.PersonalityArchetype _resolveArchetype() {
    final archetypeService = ref.read(archetypeServiceProvider).valueOrNull;
    if (archetypeService != null) {
      final history = archetypeService.getArchetypeHistory();
      if (history.isNotEmpty) {
        final jungianId = history.last.archetypeId;
        return archetype.PersonalityArchetypeExtension.fromJungianId(jungianId);
      }
    }
    return archetype.PersonalityArchetype.pioneer;
  }

  void _addWelcomeMessage() {
    final sign = _resolveArchetype();
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

  Future<void> _sendMessage() async {
    final text = _dreamController.text.trim();
    if (text.isEmpty) return;
    HapticFeedback.mediumImpact();

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
    if (!mounted) return;
    _generateInterpretation(dreamText);
  }

  void _generateInterpretation(String dreamText) {
    final sign = _resolveArchetype();
    final isPremium = ref.read(isPremiumUserProvider);

    // Generate interpretation based on dream content and personality profile
    final result = _interpretDreamWithPerspectives(dreamText, sign);
    final fullInterpretation = result.fullText;
    final perspectiveCount = result.perspectiveCount;

    // Check first-taste: first full interpretation is free
    final firstTaste = ref
        .read(firstTasteServiceProvider)
        .whenOrNull(data: (s) => s);
    final allowFirstTaste =
        firstTaste?.shouldAllowFree(
          FirstTasteFeature.fullDreamInterpretation,
        ) ??
        false;

    // For free users with multiple perspectives, show only the first perspective
    // UNLESS they have a free first-taste available
    final int lockedCount;
    final String displayText;
    if (!isPremium && perspectiveCount > 1 && !allowFirstTaste) {
      displayText = result.firstPerspective;
      lockedCount = perspectiveCount - 1;
    } else {
      displayText = fullInterpretation;
      lockedCount = 0;
      // Record first-taste use if applicable
      if (!isPremium && allowFirstTaste && perspectiveCount > 1) {
        firstTaste?.recordUse(FirstTasteFeature.fullDreamInterpretation);
      }
    }

    setState(() {
      _isTyping = false;
      _messages.add(
        ChatMessage(
          text: displayText,
          isUser: false,
          timestamp: DateTime.now(),
          lockedPerspectiveCount: lockedCount,
        ),
      );
    });

    // Track output for SmartRouter intelligence
    ref
        .read(smartRouterServiceProvider)
        .whenData(
          (s) => s.recordOutput('dreamInterpretation', 'interpretation'),
        );
    ref
        .read(ecosystemAnalyticsServiceProvider)
        .whenData(
          (s) => s.trackToolOutput('dreamInterpretation', 'interpretation'),
        );

    _scrollToBottom();
  }

  /// Generates interpretation and returns structured result with perspective count.
  _InterpretationResult _interpretDreamWithPerspectives(
    String dreamText,
    archetype.PersonalityArchetype sign,
  ) {
    final lowerDream = dreamText.toLowerCase();
    final language = ref.read(languageProvider);
    final themes = <String, String>{};

    // Water themes
    if (lowerDream.contains('su') ||
        lowerDream.contains('deniz') ||
        lowerDream.contains('okyanus') ||
        lowerDream.contains('nehir') ||
        lowerDream.contains('yagmur') ||
        lowerDream.contains('water') ||
        lowerDream.contains('ocean') ||
        lowerDream.contains('sea') ||
        lowerDream.contains('rain') ||
        lowerDream.contains('river')) {
      themes['water'] = _getWaterInterpretation(sign);
    }
    if (lowerDream.contains('ucmak') ||
        lowerDream.contains('uctum') ||
        lowerDream.contains('ucuyordum') ||
        lowerDream.contains('havada') ||
        lowerDream.contains('flying') ||
        lowerDream.contains('fly') ||
        lowerDream.contains('flew')) {
      themes['flying'] = _getFlyingInterpretation(sign);
    }
    if (lowerDream.contains('dusmek') ||
        lowerDream.contains('dustum') ||
        lowerDream.contains('dusuyordum') ||
        lowerDream.contains('ucurum') ||
        lowerDream.contains('falling') ||
        lowerDream.contains('fell') ||
        lowerDream.contains('fall')) {
      themes['falling'] = _getFallingInterpretation(sign);
    }
    if (lowerDream.contains('olum') ||
        lowerDream.contains('oldum') ||
        lowerDream.contains('oldu') ||
        lowerDream.contains('cenaze') ||
        lowerDream.contains('death') ||
        lowerDream.contains('died') ||
        lowerDream.contains('funeral')) {
      themes['death'] = _getDeathInterpretation(sign);
    }
    if (lowerDream.contains('kovalamak') ||
        lowerDream.contains('kacmak') ||
        lowerDream.contains('takip') ||
        lowerDream.contains('kaciyordum') ||
        lowerDream.contains('chase') ||
        lowerDream.contains('chasing') ||
        lowerDream.contains('running')) {
      themes['chase'] = _getChaseInterpretation(sign);
    }
    if (lowerDream.contains('yilan') ||
        lowerDream.contains('kopek') ||
        lowerDream.contains('kedi') ||
        lowerDream.contains('hayvan') ||
        lowerDream.contains('kus') ||
        lowerDream.contains('snake') ||
        lowerDream.contains('dog') ||
        lowerDream.contains('cat') ||
        lowerDream.contains('animal') ||
        lowerDream.contains('bird')) {
      themes['animal'] = _getAnimalInterpretation(sign);
    }
    if (lowerDream.contains('ev') ||
        lowerDream.contains('bina') ||
        lowerDream.contains('oda') ||
        lowerDream.contains('kapi') ||
        lowerDream.contains('house') ||
        lowerDream.contains('building') ||
        lowerDream.contains('room') ||
        lowerDream.contains('door')) {
      themes['house'] = _getHouseInterpretation(sign);
    }
    if (lowerDream.contains('ask') ||
        lowerDream.contains('sevgili') ||
        lowerDream.contains('opusmek') ||
        lowerDream.contains('iliski') ||
        lowerDream.contains('love') ||
        lowerDream.contains('kiss') ||
        lowerDream.contains('relationship')) {
      themes['love'] = _getLoveInterpretation(sign);
    }
    if (lowerDream.contains('para') ||
        lowerDream.contains('altin') ||
        lowerDream.contains('zengin') ||
        lowerDream.contains('hazine') ||
        lowerDream.contains('money') ||
        lowerDream.contains('gold') ||
        lowerDream.contains('treasure') ||
        lowerDream.contains('rich')) {
      themes['money'] = _getMoneyInterpretation(sign);
    }

    if (themes.isEmpty) {
      // Generic interpretation - counts as 1 perspective
      final text = _getGenericInterpretation(sign, dreamText);
      return _InterpretationResult(
        fullText: text,
        firstPerspective: text,
        perspectiveCount: 1,
      );
    }

    final signPerspective = L10nService.getWithParams(
      'widgets.dreams.interpretations.sign_perspective',
      language,
      params: {'archetype': sign.localizedName(language)},
    );

    // Build full interpretation with all themes
    final buffer = StringBuffer();
    buffer.writeln('$signPerspective\n');
    for (final entry in themes.entries) {
      buffer.writeln(entry.value);
      buffer.writeln();
    }
    buffer.writeln(_getPersonalAdvice(sign));

    // Build first perspective only
    final firstBuffer = StringBuffer();
    firstBuffer.writeln('$signPerspective\n');
    final firstEntry = themes.entries.first;
    firstBuffer.writeln(firstEntry.value);
    firstBuffer.writeln();
    firstBuffer.writeln(_getPersonalAdvice(sign));

    return _InterpretationResult(
      fullText: buffer.toString().trim(),
      firstPerspective: firstBuffer.toString().trim(),
      perspectiveCount: themes.length,
    );
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
        params: {'archetype': signName},
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
      params: {'archetype': signName},
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
      params: {'archetype': signName},
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
      params: {'archetype': signName},
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
      params: {'archetype': signName},
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
      params: {'archetype': signName},
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
      params: {'archetype': sign.localizedName(language)},
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
      params: {'archetype': signName},
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
      params: {'archetype': signName},
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
      params: {'archetype': signName},
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
      params: {'archetype': signName},
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
      params: {'archetype': signName},
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

  String _getGenericInterpretation(
    archetype.PersonalityArchetype sign,
    String dreamText,
  ) {
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
      params: {'archetype': signName},
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
      params: {'archetype': signName},
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
      if (!mounted) return;
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isDark),
              Expanded(child: _buildChatArea(isDark)),
              _buildInputArea(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.amethyst.withValues(alpha: 0.3),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.chevron_left,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
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
                      AppColors.amethyst.withValues(
                        alpha: 0.5 + _pulseController.value * 0.3,
                      ),
                      AppColors.nebulaPurple.withValues(alpha: 0.3),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.amethyst.withValues(
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
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  L10nService.get(
                    'dreams.interpretation_subtitle',
                    ref.watch(languageProvider),
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
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

  Widget _buildChatArea(bool isDark) {
    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.all(16),
      itemCount:
          _messages.length +
          (_isTyping ? 1 : 0) +
          (_messages.length == 1 ? 1 : 0),
      itemBuilder: (context, index) {
        // Show suggested prompts after welcome message
        if (_messages.length == 1 && index == 1 && !_isTyping) {
          return _buildSuggestedDreamPrompts(isDark);
        }
        if (index == _messages.length + (_messages.length == 1 ? 1 : 0) &&
            _isTyping) {
          return _buildTypingIndicator();
        }
        if (index < _messages.length) {
          return _buildMessageBubble(_messages[index], index, isDark);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSuggestedDreamPrompts(bool isDark) {
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
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Builder(
            builder: (context) {
              final prompts = _getSuggestedDreamPrompts(
                ref.read(languageProvider),
              );
              return SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemCount: prompts.length,
                  itemBuilder: (context, index) {
                    if (index >= prompts.length) return const SizedBox.shrink();
                    final prompt = prompts[index];
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
                          glowColor: AppColors.amethyst.withValues(alpha: 0.2),
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
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark
                                        ? AppColors.textPrimary
                                        : AppColors.lightTextPrimary,
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
                    ).glassListItem(context: context, index: index);
                  },
                ),
              );
            },
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
                color: isDark
                    ? AppColors.textSecondary.withValues(alpha: 0.7)
                    : AppColors.lightTextSecondary.withValues(alpha: 0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    ).glassReveal(context: context, delay: const Duration(milliseconds: 300));
  }

  Widget _buildMessageBubble(ChatMessage message, int index, bool isDark) {
    final isUser = message.isUser;
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                        AppColors.amethyst.withValues(alpha: 0.5),
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
                      : AppColors.amethyst.withValues(alpha: 0.2),
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
                                language,
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
                                language,
                              ),
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppColors.amethyst,
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
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
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
          // Premium lock card for locked perspectives
          if (message.lockedPerspectiveCount > 0) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 42),
              child: _buildLockedPerspectivesCard(
                message.lockedPerspectiveCount,
                isEn,
                isDark,
              ),
            ),
          ],
        ],
      ),
    ).glassListItem(context: context, index: index);
  }

  Widget _buildLockedPerspectivesCard(int lockedCount, bool isEn, bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // Blurred background hint
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: GlassPanel(
              elevation: GlassElevation.g1,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEn
                        ? 'Psychological Perspective\n━━━━━━━━━━━━━━━━━\nYour subconscious is revealing...'
                        : 'Psikolojik Perspektif\n━━━━━━━━━━━━━━━━━\nBilinaltiniz ortaya koyuyor...',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textPrimary.withValues(alpha: 0.5)
                          : AppColors.lightTextPrimary.withValues(alpha: 0.5),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Lock overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    isDark
                        ? AppColors.cosmicPurple.withValues(alpha: 0.85)
                        : AppColors.lightSurface.withValues(alpha: 0.85),
                    isDark
                        ? AppColors.cosmicPurple.withValues(alpha: 0.95)
                        : AppColors.lightSurface.withValues(alpha: 0.95),
                  ],
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
            ),
          ),
          // CTA content
          Positioned.fill(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      color: AppColors.mediumSlateBlue,
                      size: 28,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isEn
                          ? '$lockedCount more perspectives available'
                          : '$lockedCount perspektif daha mevcut',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : AppColors.lightTextPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isEn
                          ? 'See your dream through every lens'
                          : 'Ruyanizi her acidan gorun',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.6)
                            : Colors.black.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Semantics(
                      label: isEn ? 'Unlock all perspectives' : 'Tüm perspektifleri aç',
                      button: true,
                      child: GestureDetector(
                      onTap: () => showContextualPaywall(
                        context,
                        ref,
                        paywallContext: PaywallContext.dreams,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.mediumSlateBlue,
                              AppColors.amethyst,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.mediumSlateBlue.withValues(
                                alpha: 0.4,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          isEn
                              ? 'Unlock All Perspectives'
                              : 'Tum Perspektifleri Ac',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms);
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
                  AppColors.amethyst.withValues(alpha: 0.5),
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

  Widget _buildInputArea(bool isDark) {
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
                    focusNode: _keyboardFocusNode,
                    onKeyEvent: (event) {
                      if (event is KeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.enter &&
                          !HardwareKeyboard.instance.isShiftPressed) {
                        _sendMessage();
                      }
                    },
                    child: TextField(
                      controller: _dreamController,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                      maxLines: 5,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        hintText: L10nService.get(
                          'dreams.input_placeholder',
                          ref.read(languageProvider),
                        ),
                        hintStyle: TextStyle(
                          color: isDark
                              ? AppColors.textSecondary.withValues(alpha: 0.6)
                              : AppColors.lightTextSecondary.withValues(
                                  alpha: 0.6,
                                ),
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
              Semantics(
                label: 'Send message',
                button: true,
                child: GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.amethyst, AppColors.cosmicPurple],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.amethyst.withValues(alpha: 0.4),
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
  final int lockedPerspectiveCount;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isQuestion = false,
    this.isInterpretation = false,
    this.lockedPerspectiveCount = 0,
  });
}

/// Structured result from dream interpretation with perspective metadata
class _InterpretationResult {
  final String fullText;
  final String firstPerspective;
  final int perspectiveCount;

  const _InterpretationResult({
    required this.fullText,
    required this.firstPerspective,
    required this.perspectiveCount,
  });
}

/// Dream symbols reference sheet
class _DreamSymbolsSheet extends ConsumerWidget {
  const _DreamSymbolsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
          colors: isDark
              ? [AppColors.nebulaPurple, AppColors.deepSpace]
              : [AppColors.lightSurfaceVariant, AppColors.lightSurface],
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
              color: isDark
                  ? AppColors.textSecondary.withValues(alpha: 0.3)
                  : AppColors.lightTextSecondary.withValues(alpha: 0.3),
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
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
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
                        symbol['emoji'] ?? '',
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              symbol['name'] ?? '',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              symbol['meaning'] ?? '',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.textSecondary.withValues(
                                        alpha: 0.8,
                                      )
                                    : AppColors.lightTextSecondary.withValues(
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
                ).glassListItem(context: context, index: index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
