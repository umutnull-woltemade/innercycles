import '../../data/providers/app_providers.dart';

/// Canonical dream content - English only, SEO-optimized
/// AI-quotable content for dream interpretation pages
class DreamCanonicalContent {
  DreamCanonicalContent._();

  /// Dream types enum for canonical pages
  static const List<String> dreamTypes = [
    'falling',
    'water',
    'recurring',
    'running',
    'losing',
    'flying',
    'darkness',
    'past',
    'searching',
    'voiceless',
    'lost',
    'unableToFly',
  ];

  /// Get dream content by type and language
  static DreamContentData getContent(String type, AppLanguage language) {
    final content = _content[type];
    if (content == null) {
      return DreamContentData.empty();
    }
    return DreamContentData(
      title: content['title'] as String? ?? '',
      sections:
          (content['sections'] as List?)?.map((section) {
            return DreamSection(
              title: section['title'] as String? ?? '',
              bullets: (section['bullets'] as List<String>?) ?? [],
            );
          }).toList() ??
          [],
      suggestion: DreamSuggestion(
        emoji: content['suggestion']?['emoji'] ?? '🔮',
        text: content['suggestion']?['text'] ?? '',
        route: content['suggestion']?['route'] ?? '',
      ),
    );
  }

  static final Map<String, Map<String, dynamic>> _content = {
    'falling': {
      'title': 'What does falling in a dream mean?',
      'sections': [
        {
          'title': 'Quick Answer',
          'bullets': [
            'Falling dreams usually reflect a feeling of losing control.',
            'They appear when we feel something is slipping away in life.',
            'Waking up while falling is your subconscious reflex to wake you.',
          ],
        },
        {
          'title': 'What Does It Mean?',
          'bullets': [
            'More common during periods of uncertainty.',
            'You may be worried about work, relationships, or health.',
            'The speed of the fall indicates the intensity of anxiety.',
          ],
        },
        {
          'title': 'What Emotion Does It Carry?',
          'bullets': [
            'Feelings of insecurity or inadequacy.',
            'Fear of failure.',
            'Seeking support.',
          ],
        },
        {
          'title': 'If It Recurs',
          'bullets': [
            'It points to unresolved anxiety.',
            'Look at what makes you feel unbalanced in life.',
            'Accepting situations you can\'t control may help.',
          ],
        },
      ],
      'suggestion': {
        'emoji': '💧',
        'text': 'What does water in a dream mean?',
        'route': '/dreams/water',
      },
    },
    'water': {
      'title': 'What does water in a dream mean?',
      'sections': [
        {
          'title': 'Quick Answer',
          'bullets': [
            'Water symbolizes the subconscious and emotions.',
            'The state of water reflects your inner world.',
            'Still water shows peace, turbulent water shows turmoil.',
          ],
        },
        {
          'title': 'What Does It Mean?',
          'bullets': [
            'Clear water suggests emotional clarity.',
            'Murky water indicates confusion or unresolved feelings.',
            'Drowning may represent feeling overwhelmed.',
          ],
        },
        {
          'title': 'What Emotion Does It Carry?',
          'bullets': [
            'Deep emotional processing.',
            'Cleansing and purification needs.',
            'Connection to the unconscious mind.',
          ],
        },
        {
          'title': 'If It Recurs',
          'bullets': [
            'Pay attention to the water\'s condition each time.',
            'Your emotional state is trying to communicate.',
            'Consider journaling your feelings regularly.',
          ],
        },
      ],
      'suggestion': {
        'emoji': '🔄',
        'text': 'Why do recurring dreams happen?',
        'route': '/dreams/recurring',
      },
    },
    'recurring': {
      'title': 'Why do recurring dreams happen?',
      'sections': [
        {
          'title': 'Quick Answer',
          'bullets': [
            'Recurring dreams signal unresolved issues.',
            'Your subconscious is trying to get your attention.',
            'They often stop once the underlying issue is addressed.',
          ],
        },
        {
          'title': 'What Does It Mean?',
          'bullets': [
            'An important message hasn\'t been received.',
            'There\'s an emotional pattern that needs attention.',
            'Something in your life needs to change.',
          ],
        },
        {
          'title': 'What Emotion Does It Carry?',
          'bullets': [
            'Persistent anxiety or worry.',
            'Unfinished emotional business.',
            'A call for self-reflection.',
          ],
        },
        {
          'title': 'How to Work With Them',
          'bullets': [
            'Keep a dream journal to track patterns.',
            'Try to change your response within the dream.',
            'Address the underlying life issue directly.',
          ],
        },
      ],
      'suggestion': {
        'emoji': '🏃',
        'text': 'What does running in a dream mean?',
        'route': '/dreams/running',
      },
    },
    'running': {
      'title': 'What does running in a dream mean?',
      'sections': [
        {
          'title': 'Quick Answer',
          'bullets': [
            'Running often represents avoidance or escape.',
            'It can also symbolize pursuit of goals.',
            'The context determines whether it\'s fear or ambition.',
          ],
        },
        {
          'title': 'What Does It Mean?',
          'bullets': [
            'Running away suggests avoiding something in life.',
            'Running toward something shows determination.',
            'Unable to run indicates feeling stuck.',
          ],
        },
        {
          'title': 'What Emotion Does It Carry?',
          'bullets': [
            'Fear of confrontation.',
            'Desire for progress or change.',
            'Frustration with current pace of life.',
          ],
        },
        {
          'title': 'If It Recurs',
          'bullets': [
            'Identify what you\'re running from or toward.',
            'Face the situation you\'ve been avoiding.',
            'Consider if you\'re pushing yourself too hard.',
          ],
        },
      ],
      'suggestion': {
        'emoji': '🔍',
        'text': 'What does losing something mean?',
        'route': '/dreams/losing',
      },
    },
    'losing': {
      'title': 'What does losing something in a dream mean?',
      'sections': [
        {
          'title': 'Quick Answer',
          'bullets': [
            'Losing things represents fear of loss or change.',
            'It often reflects anxiety about what\'s important to you.',
            'The lost item reveals what you value most.',
          ],
        },
        {
          'title': 'What Does It Mean?',
          'bullets': [
            'Fear of losing something precious in waking life.',
            'Feeling unprepared or disorganized.',
            'Transition periods often trigger these dreams.',
          ],
        },
        {
          'title': 'What Emotion Does It Carry?',
          'bullets': [
            'Anxiety about the future.',
            'Fear of forgetting something important.',
            'Grief or letting go processes.',
          ],
        },
        {
          'title': 'If It Recurs',
          'bullets': [
            'Note what you lose - it reveals your fears.',
            'Work on accepting impermanence.',
            'Secure what matters most to you.',
          ],
        },
      ],
      'suggestion': {
        'emoji': '✈️',
        'text': 'What does flying in a dream mean?',
        'route': '/dreams/flying',
      },
    },
    'flying': {
      'title': 'What does flying in a dream mean?',
      'sections': [
        {
          'title': 'Quick Answer',
          'bullets': [
            'Flying represents freedom and transcendence.',
            'It often indicates rising above problems.',
            'The ease of flight reflects your confidence level.',
          ],
        },
        {
          'title': 'What Does It Mean?',
          'bullets': [
            'Feeling liberated from constraints.',
            'Achieving a new perspective on life.',
            'Spiritual elevation or growth.',
          ],
        },
        {
          'title': 'What Emotion Does It Carry?',
          'bullets': [
            'Joy and exhilaration.',
            'Sense of power and possibility.',
            'Freedom from limitations.',
          ],
        },
        {
          'title': 'If It Recurs',
          'bullets': [
            'Your spirit craves more freedom.',
            'You may be ready for new heights.',
            'Trust your ability to soar above challenges.',
          ],
        },
      ],
      'suggestion': {
        'emoji': '🌑',
        'text': 'What does darkness in a dream mean?',
        'route': '/dreams/darkness',
      },
    },
    'darkness': {
      'title': 'What does darkness in a dream mean?',
      'sections': [
        {
          'title': 'Quick Answer',
          'bullets': [
            'Darkness symbolizes the unknown or unconscious.',
            'It often represents fear or uncertainty.',
            'Can also indicate potential waiting to emerge.',
          ],
        },
        {
          'title': 'What Does It Mean?',
          'bullets': [
            'Facing the unknown aspects of yourself.',
            'Uncertainty about the future.',
            'Hidden potential not yet realized.',
          ],
        },
        {
          'title': 'What Emotion Does It Carry?',
          'bullets': [
            'Fear of the unknown.',
            'Feeling lost or directionless.',
            'Mystery and untapped potential.',
          ],
        },
        {
          'title': 'If It Recurs',
          'bullets': [
            'Shine light on what you\'ve been avoiding.',
            'Embrace the unknown as opportunity.',
            'Trust that dawn follows darkness.',
          ],
        },
      ],
      'suggestion': {
        'emoji': '⏰',
        'text': 'What does dreaming about the past mean?',
        'route': '/dreams/past',
      },
    },
    'past': {
      'title': 'What does dreaming about the past mean?',
      'sections': [
        {
          'title': 'Quick Answer',
          'bullets': [
            'Past dreams indicate unresolved issues.',
            'Your psyche is processing old experiences.',
            'Nostalgia or regret may be surfacing.',
          ],
        },
        {
          'title': 'What Does It Mean?',
          'bullets': [
            'Unfinished business needs attention.',
            'Lessons from the past apply to present.',
            'Healing old wounds in progress.',
          ],
        },
        {
          'title': 'What Emotion Does It Carry?',
          'bullets': [
            'Nostalgia or longing.',
            'Regret or unresolved grief.',
            'Wisdom gained from experience.',
          ],
        },
        {
          'title': 'If It Recurs',
          'bullets': [
            'The past holds important messages.',
            'Consider what you need to release.',
            'Find closure where needed.',
          ],
        },
      ],
      'suggestion': {
        'emoji': '🔎',
        'text': 'What does searching in a dream mean?',
        'route': '/dreams/searching',
      },
    },
    'searching': {
      'title': 'What does searching in a dream mean?',
      'sections': [
        {
          'title': 'Quick Answer',
          'bullets': [
            'Searching represents seeking something missing.',
            'Could be purpose, love, answers, or identity.',
            'What you search for reveals your deepest needs.',
          ],
        },
        {
          'title': 'What Does It Mean?',
          'bullets': [
            'A quest for meaning or direction.',
            'Something important feels missing in life.',
            'The search itself may be the message.',
          ],
        },
        {
          'title': 'What Emotion Does It Carry?',
          'bullets': [
            'Longing and incompleteness.',
            'Determination and hope.',
            'Frustration with the unknown.',
          ],
        },
        {
          'title': 'If It Recurs',
          'bullets': [
            'Reflect on what you\'re truly seeking.',
            'The answer may already be within you.',
            'Sometimes we search for what we already have.',
          ],
        },
      ],
      'suggestion': {
        'emoji': '🤐',
        'text': 'What does being voiceless mean?',
        'route': '/dreams/voiceless',
      },
    },
    'voiceless': {
      'title': 'What does being voiceless in a dream mean?',
      'sections': [
        {
          'title': 'Quick Answer',
          'bullets': [
            'Being unable to speak reflects feeling unheard.',
            'Your voice matters but isn\'t being expressed.',
            'Communication blocks need attention.',
          ],
        },
        {
          'title': 'What Does It Mean?',
          'bullets': [
            'Suppressed expression in waking life.',
            'Fear of speaking your truth.',
            'Feeling powerless in a situation.',
          ],
        },
        {
          'title': 'What Emotion Does It Carry?',
          'bullets': [
            'Frustration with being unheard.',
            'Anxiety about self-expression.',
            'Powerlessness or helplessness.',
          ],
        },
        {
          'title': 'If It Recurs',
          'bullets': [
            'Find ways to express yourself.',
            'Speak up in situations that matter.',
            'Your voice deserves to be heard.',
          ],
        },
      ],
      'suggestion': {
        'emoji': '🗺️',
        'text': 'What does being lost mean?',
        'route': '/dreams/lost',
      },
    },
    'lost': {
      'title': 'What does being lost in a dream mean?',
      'sections': [
        {
          'title': 'Quick Answer',
          'bullets': [
            'Being lost reflects uncertainty about direction.',
            'Life transitions often trigger these dreams.',
            'The location reveals where you feel confused.',
          ],
        },
        {
          'title': 'What Does It Mean?',
          'bullets': [
            'Confusion about your path in life.',
            'Feeling disconnected from your goals.',
            'Need for guidance or clarity.',
          ],
        },
        {
          'title': 'What Emotion Does It Carry?',
          'bullets': [
            'Confusion and disorientation.',
            'Fear of making wrong choices.',
            'Desire for direction and purpose.',
          ],
        },
        {
          'title': 'If It Recurs',
          'bullets': [
            'Clarify your values and goals.',
            'Trust that being lost is part of finding.',
            'Seek guidance from trusted sources.',
          ],
        },
      ],
      'suggestion': {
        'emoji': '🦋',
        'text': 'What does unable to fly mean?',
        'route': '/dreams/unable-to-fly',
      },
    },
    'unableToFly': {
      'title': 'What does being unable to fly mean?',
      'sections': [
        {
          'title': 'Quick Answer',
          'bullets': [
            'Inability to fly shows blocked potential.',
            'Something is holding you back from freedom.',
            'Confidence or self-doubt may be the issue.',
          ],
        },
        {
          'title': 'What Does It Mean?',
          'bullets': [
            'Limitations feel too restrictive.',
            'Self-doubt is grounding your ambitions.',
            'External obstacles feel insurmountable.',
          ],
        },
        {
          'title': 'What Emotion Does It Carry?',
          'bullets': [
            'Frustration with limitations.',
            'Desire for freedom and achievement.',
            'Disappointment in unrealized potential.',
          ],
        },
        {
          'title': 'If It Recurs',
          'bullets': [
            'Identify what\'s holding you back.',
            'Build confidence step by step.',
            'Small flights lead to soaring.',
          ],
        },
      ],
      'suggestion': {
        'emoji': '⬇️',
        'text': 'What does falling mean?',
        'route': '/dreams/falling',
      },
    },
  };
}

/// Data class for dream content
class DreamContentData {
  final String title;
  final List<DreamSection> sections;
  final DreamSuggestion suggestion;

  const DreamContentData({
    required this.title,
    required this.sections,
    required this.suggestion,
  });

  factory DreamContentData.empty() => const DreamContentData(
    title: '',
    sections: [],
    suggestion: DreamSuggestion(emoji: '', text: '', route: ''),
  );
}

/// Data class for dream section
class DreamSection {
  final String title;
  final List<String> bullets;

  const DreamSection({required this.title, required this.bullets});
}

/// Data class for dream suggestion
class DreamSuggestion {
  final String emoji;
  final String text;
  final String route;

  const DreamSuggestion({
    required this.emoji,
    required this.text,
    required this.route,
  });
}

/// UI helper translations - English only
class DreamUIStrings {
  DreamUIStrings._();

  static String getExploreAlso(AppLanguage language) {
    return 'Explore also';
  }

  static String getBrandText(AppLanguage language) {
    return 'Dream Trace — InnerCycles';
  }
}
