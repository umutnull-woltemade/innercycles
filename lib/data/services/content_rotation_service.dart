import '../content/reflection_prompts_content.dart';

/// Overnight content rotation service.
///
/// Deterministically selects daily content (prompts, insights, affirmations)
/// using date-seeded rotation. Ensures:
/// - Fresh content each day without server dependency
/// - Same content for same user on same day (deterministic)
/// - Full pool rotation before any repeat
/// - Focus-area weighting based on user's weakest area
class ContentRotationService {
  ContentRotationService._();

  /// Get today's reflection prompt.
  /// [weakestArea] optionally biases toward user's weakest focus area.
  static ReflectionPrompt getDailyPrompt({
    DateTime? date,
    String? weakestArea,
  }) {
    final today = date ?? DateTime.now();
    final dayIndex = _dateSeed(today);

    if (weakestArea != null) {
      // Filter to weakest area prompts, then rotate
      final areaPrompts = allReflectionPrompts
          .where((p) => p.focusArea == weakestArea)
          .toList();
      if (areaPrompts.isNotEmpty) {
        return areaPrompts[dayIndex % areaPrompts.length];
      }
    }

    return allReflectionPrompts[dayIndex % allReflectionPrompts.length];
  }

  /// Get the prompt for a specific day offset from today.
  /// [offset] = 0 is today, -1 is yesterday, 1 is tomorrow preview.
  static ReflectionPrompt getPromptForOffset(int offset) {
    final date = DateTime.now().add(Duration(days: offset));
    return getDailyPrompt(date: date);
  }

  /// Get N upcoming prompts (for preview/scheduling).
  static List<ReflectionPrompt> getUpcomingPrompts(int count) {
    return List.generate(count, (i) => getPromptForOffset(i));
  }

  /// Get today's focus area (rotates through all 7 areas weekly).
  static String getDailyFocusArea({DateTime? date}) {
    final today = date ?? DateTime.now();
    const areas = [
      'mood',
      'energy',
      'social',
      'creativity',
      'productivity',
      'health',
      'spirituality',
    ];
    return areas[today.weekday % areas.length];
  }

  /// Get a daily motivational seed phrase based on date.
  /// Returns (en, tr) tuple.
  static ({String en, String tr}) getDailyInsight({DateTime? date}) {
    final today = date ?? DateTime.now();
    final index = _dateSeed(today);

    const insights = [
      (
        en: 'Patterns reveal what words cannot.',
        tr: 'Örüntüler, kelimelerin söyleyemediğini ortaya çıkarır.',
      ),
      (
        en: 'Your journal remembers what you forget.',
        tr: 'Günlüğün, unuttuklarını hatırlar.',
      ),
      (
        en: 'Awareness is the first step to change.',
        tr: 'Farkındalık, değişimin ilk adımıdır.',
      ),
      (
        en: 'Every entry adds depth to your self-portrait.',
        tr: 'Her giriş, öz portrenize derinlik katar.',
      ),
      (
        en: 'Cycles repeat until understood.',
        tr: 'Döngüler anlaşılana kadar tekrarlar.',
      ),
      (
        en: 'The space between stimulus and response is freedom.',
        tr: 'Uyaran ile tepki arasındaki boşluk özgürlüktür.',
      ),
      (
        en: 'What you track, you transform.',
        tr: 'Takip ettiğini dönüştürürsün.',
      ),
      (
        en: 'Emotions are data, not directives.',
        tr: 'Duygular veri, yönerge değil.',
      ),
      (
        en: 'Growth happens in the spaces between entries.',
        tr: 'Büyüme, girişler arasındaki boşluklarda gerçekleşir.',
      ),
      (
        en: 'Your future self will thank you for recording today.',
        tr: 'Gelecekteki sen, bugünü kaydettiğin için teşekkür edecek.',
      ),
      (
        en: 'Notice without judgment. Observe without fixing.',
        tr: 'Yargılamadan fark et. Düzeltmeden gözlemle.',
      ),
      (
        en: 'Small reflections compound into deep insight.',
        tr: 'Küçük yansımalar derin içgörüye dönüşür.',
      ),
      (
        en: 'The rhythm of your emotions tells a story.',
        tr: 'Duygularının ritmi bir hikaye anlatır.',
      ),
      (
        en: 'What repeats in your journal repeats in your life.',
        tr: 'Günlüğünde tekrarlanan, hayatında tekrarlanır.',
      ),
      (
        en: 'Seven entries. First pattern. Keep going.',
        tr: 'Yedi giriş. İlk örüntü. Devam et.',
      ),
      (
        en: 'Dreams speak in symbols. Your journal decodes them.',
        tr: 'Rüyalar sembollerle konuşur. Günlüğün onları çözer.',
      ),
      (
        en: 'The quietest insights arrive after consistency.',
        tr: 'En sessiz içgörüler tutarlılıktan sonra gelir.',
      ),
      (
        en: 'Your emotional landscape is uniquely yours.',
        tr: 'Duygusal manzaran sana özgüdür.',
      ),
      (
        en: 'Reflection is not looking back — it is looking inward.',
        tr: 'Yansıma geriye bakmak değil, içe bakmaktır.',
      ),
      (
        en: 'Each day writes a new chapter. What will yours say?',
        tr: 'Her gün yeni bir bölüm yazar. Seninki ne diyecek?',
      ),
      (
        en: 'Trust the process. Patterns emerge with patience.',
        tr: 'Sürece güven. Örüntüler sabırla ortaya çıkar.',
      ),
      (
        en: 'Your mood is a compass, not a cage.',
        tr: 'Ruh halin bir pusula, kafes değil.',
      ),
      (
        en: 'The data of your days holds the wisdom of your years.',
        tr: 'Günlerinin verisi, yıllarının bilgeliğini barındırır.',
      ),
      (
        en: 'Notice what energizes you. Notice what drains you.',
        tr: 'Seni neyin enerjilendiğini fark et. Neyin tükettiğini fark et.',
      ),
      (
        en: 'Stillness is not stagnation. It is integration.',
        tr: 'Durgunluk durağanlık değil, bütünleşmedir.',
      ),
      (
        en: 'Your cycles are not flaws — they are rhythms.',
        tr: 'Döngülerin kusur değil — ritimdir.',
      ),
      (
        en: 'One honest sentence outweighs a thousand vague ones.',
        tr: 'Bir dürüst cümle, bin belirsiz cümleden ağır basar.',
      ),
      (
        en: 'The journal does not judge. Neither should you.',
        tr: 'Günlük yargılamaz. Sen de yargılamamalısın.',
      ),
      (
        en: 'Maps are made by those who walk.',
        tr: 'Haritalar yürüyenler tarafından yapılır.',
      ),
      (
        en: 'Insight is not given. It is earned through attention.',
        tr: 'İçgörü verilmez. Dikkatle kazanılır.',
      ),
      (
        en: 'Your emotions have seasons too.',
        tr: 'Senin duygularının da mevsimleri var.',
      ),
    ];

    return insights[index % insights.length];
  }

  /// Deterministic seed from date (ignores time component).
  static int _dateSeed(DateTime date) {
    // Use year * 1000 + dayOfYear for unique daily seed
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    return (date.year * 1000 + dayOfYear).abs();
  }
}
