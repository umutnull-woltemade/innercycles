// ════════════════════════════════════════════════════════════════════════════
// REFLECTION PROMPT ENGINE - Context-aware daily prompts
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math';
import 'mood_checkin_service.dart';
import '../models/journal_entry.dart';

class ReflectionPrompt {
  final String textEn;
  final String textTr;
  final String category; // 'low', 'neutral', 'high', 'growth'
  final FocusArea? focusArea;

  const ReflectionPrompt({
    required this.textEn,
    required this.textTr,
    required this.category,
    this.focusArea,
  });

  String text(bool isEn) => isEn ? textEn : textTr;
}

class ReflectionPromptEngine {
  final MoodCheckinService _moodService;
  static final _random = Random();

  ReflectionPromptEngine(this._moodService);

  static const _prompts = <ReflectionPrompt>[
    // ── LOW MOOD ──
    ReflectionPrompt(
      textEn: 'What is one small thing that brought you comfort today?',
      textTr: 'Bug\u00fcn sana teselli veren k\u00fc\u00e7\u00fck bir \u015fey ne oldu?',
      category: 'low',
    ),
    ReflectionPrompt(
      textEn: 'If you could give yourself permission for one thing right now, what would it be?',
      textTr: '\u015eu an kendine bir \u015fey i\u00e7in izin verebilsen, ne olurdu?',
      category: 'low',
    ),
    ReflectionPrompt(
      textEn: 'What would you tell a friend going through what you\'re feeling?',
      textTr: 'Senin hissettiklerini ya\u015fayan bir arkada\u015f\u0131na ne s\u00f6ylerdin?',
      category: 'low',
    ),
    ReflectionPrompt(
      textEn: 'What part of today was hardest? What got you through it?',
      textTr: 'Bug\u00fcn\u00fcn en zor k\u0131sm\u0131 neydi? Seni ne ayakta tuttu?',
      category: 'low',
    ),
    ReflectionPrompt(
      textEn: 'Name one thing your body is telling you right now.',
      textTr: 'Bedenin \u015fu an sana ne s\u00f6yl\u00fcyor?',
      category: 'low',
    ),

    // ── NEUTRAL MOOD ──
    ReflectionPrompt(
      textEn: 'What are you looking forward to this week?',
      textTr: 'Bu hafta neler bekliyorsun?',
      category: 'neutral',
    ),
    ReflectionPrompt(
      textEn: 'What pattern are you noticing in your recent days?',
      textTr: 'Son g\u00fcnlerde fark etti\u011fin bir kal\u0131p var m\u0131?',
      category: 'neutral',
    ),
    ReflectionPrompt(
      textEn: 'If today had a color, what would it be and why?',
      textTr: 'Bug\u00fcn\u00fcn bir rengi olsayd\u0131 ne olurdu ve neden?',
      category: 'neutral',
    ),
    ReflectionPrompt(
      textEn: 'What conversation stayed with you today?',
      textTr: 'Bug\u00fcn hangi konu\u015fma akl\u0131nda kald\u0131?',
      category: 'neutral',
    ),
    ReflectionPrompt(
      textEn: 'What did you learn about yourself recently?',
      textTr: 'Son zamanlarda kendine dair ne \u00f6\u011frendin?',
      category: 'neutral',
    ),
    ReflectionPrompt(
      textEn: 'What boundary did you hold or wish you had set?',
      textTr: 'Hangi s\u0131n\u0131r\u0131 tuttun ya da ke\u015fke koysayd\u0131m dedin?',
      category: 'neutral',
    ),

    // ── HIGH MOOD ──
    ReflectionPrompt(
      textEn: 'What made this a good day? How can you create more of these?',
      textTr: 'Bug\u00fcn\u00fc g\u00fczel yapan ne? Bunlar\u0131 nas\u0131l \u00e7o\u011faltabilirsin?',
      category: 'high',
    ),
    ReflectionPrompt(
      textEn: 'Who contributed to your joy today? Have you told them?',
      textTr: 'Bug\u00fcn sevincine kim katk\u0131da bulundu? Ona s\u00f6yledin mi?',
      category: 'high',
    ),
    ReflectionPrompt(
      textEn: 'What strength showed up in you today that you\'re proud of?',
      textTr: 'Bug\u00fcn sende ortaya \u00e7\u0131kan ve gurur duydu\u011fun g\u00fc\u00e7 neydi?',
      category: 'high',
    ),
    ReflectionPrompt(
      textEn: 'If you could bottle this feeling, what would you name it?',
      textTr: 'Bu duyguyu \u015fi\u015feleyebilsen, ad\u0131n\u0131 ne koyardın?',
      category: 'high',
    ),
    ReflectionPrompt(
      textEn: 'What dream feels more possible on days like today?',
      textTr: 'Bug\u00fcnk\u00fc gibi g\u00fcnlerde hangi hayal daha m\u00fcmk\u00fcn hissettiriyor?',
      category: 'high',
    ),

    // ── GROWTH PROMPTS (any mood) ──
    ReflectionPrompt(
      textEn: 'What would the "you" from a year ago think of where you are now?',
      textTr: 'Bir y\u0131l \u00f6nceki sen, \u015fimdiki durumun hakk\u0131nda ne d\u00fc\u015f\u00fcn\u00fcrd\u00fc?',
      category: 'growth',
    ),
    ReflectionPrompt(
      textEn: 'What fear did you face recently, even in a small way?',
      textTr: 'Son zamanlarda k\u00fc\u00e7\u00fck de olsa y\u00fczle\u015fti\u011fin bir korku var m\u0131?',
      category: 'growth',
    ),
    ReflectionPrompt(
      textEn: 'What habit is quietly shaping who you\'re becoming?',
      textTr: 'Sessizce oldu\u011fun ki\u015fiyi \u015fekillendiren hangi al\u0131\u015fkanl\u0131k?',
      category: 'growth',
    ),
    ReflectionPrompt(
      textEn: 'What would you like to be known for?',
      textTr: 'Ne ile an\u0131lmak istersin?',
      category: 'growth',
    ),
    ReflectionPrompt(
      textEn: 'What are you holding onto that no longer serves you?',
      textTr: 'Art\u0131k sana hizmet etmeyen neyi tutuyorsun?',
      category: 'growth',
    ),
  ];

  /// Get today's contextual prompt based on recent mood
  ReflectionPrompt getTodayPrompt() {
    final today = _moodService.getTodayMood();
    final week = _moodService.getWeekMoods();

    String category;
    if (today != null) {
      if (today.mood <= 2) {
        category = 'low';
      } else if (today.mood >= 4) {
        category = 'high';
      } else {
        category = 'neutral';
      }
    } else {
      // Use week average
      final moods = week.whereType<MoodEntry>().toList();
      if (moods.isEmpty) {
        category = 'neutral';
      } else {
        final avg = moods.map((m) => m.mood).reduce((a, b) => a + b) / moods.length;
        if (avg <= 2.5) {
          category = 'low';
        } else if (avg >= 3.5) {
          category = 'high';
        } else {
          category = 'neutral';
        }
      }
    }

    // Mix in growth prompts sometimes (30% chance)
    if (_random.nextDouble() < 0.3) category = 'growth';

    final pool = _prompts.where((p) => p.category == category).toList();
    // Deterministic daily rotation using day of year
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    return pool[dayOfYear % pool.length];
  }

  /// Get all prompts for a category
  static List<ReflectionPrompt> getPromptsByCategory(String category) {
    return _prompts.where((p) => p.category == category).toList();
  }
}
