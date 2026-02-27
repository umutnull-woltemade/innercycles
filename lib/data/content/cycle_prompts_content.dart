// ════════════════════════════════════════════════════════════════════════════
// CYCLE PROMPTS CONTENT - Phase-Aware Bilingual Journal Prompts
// ════════════════════════════════════════════════════════════════════════════
// Each cycle phase has unique reflection prompts to help users
// understand how their hormonal rhythms shape emotional patterns.
// ════════════════════════════════════════════════════════════════════════════

import '../models/cycle_entry.dart';

class CyclePrompt {
  final String promptEn;
  final String promptTr;
  final CyclePhase phase;

  const CyclePrompt({
    required this.promptEn,
    required this.promptTr,
    required this.phase,
  });
}

class CyclePromptsContent {
  CyclePromptsContent._();

  /// Get prompts for a specific phase
  static List<CyclePrompt> getPromptsForPhase(CyclePhase phase) {
    return allPrompts.where((p) => p.phase == phase).toList();
  }

  /// Get a date-rotated prompt for a phase
  static CyclePrompt getPromptForDate(CyclePhase phase, DateTime date) {
    final prompts = getPromptsForPhase(phase);
    if (prompts.isEmpty) return allPrompts.first;
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    return prompts[dayOfYear % prompts.length];
  }

  static const List<CyclePrompt> allPrompts = [
    // ═══════════════════════════════════════════════════════════════════
    // MENSTRUAL PHASE - Rest & Renewal
    // ═══════════════════════════════════════════════════════════════════
    CyclePrompt(
      promptEn: 'What does your body need most right now?',
      promptTr: 'Bedenin şu an en çok neye ihtiyaç duyuyor?',
      phase: CyclePhase.menstrual,
    ),
    CyclePrompt(
      promptEn: 'What can you release or let go of during this rest phase?',
      promptTr:
          'Bu dinlenme evresinde nelerden vazgeçebilir veya bırakabilirsin?',
      phase: CyclePhase.menstrual,
    ),
    CyclePrompt(
      promptEn: 'How do you feel about slowing down? What emotions come up?',
      promptTr:
          'Yavaşlamak hakkında ne hissediyorsun? Hangi duygular ortaya çıkıyor?',
      phase: CyclePhase.menstrual,
    ),
    CyclePrompt(
      promptEn: 'What boundaries do you need to honor this week?',
      promptTr: 'Bu hafta hangi sınırlarına saygı göstermen gerekiyor?',
      phase: CyclePhase.menstrual,
    ),
    CyclePrompt(
      promptEn:
          'If your energy is low, what small comfort could nourish you today?',
      promptTr:
          'Enerjin düşükse, bugün seni besleyecek küçük bir konfor ne olabilir?',
      phase: CyclePhase.menstrual,
    ),
    CyclePrompt(
      promptEn: 'What are you ready to release from this cycle?',
      promptTr: 'Bu döngüden neyi bırakmaya hazırsın?',
      phase: CyclePhase.menstrual,
    ),
    CyclePrompt(
      promptEn: 'Where in your body do you hold tension right now?',
      promptTr: 'Şu an bedeninde gerginliği nerede tutuyorsun?',
      phase: CyclePhase.menstrual,
    ),
    CyclePrompt(
      promptEn: 'What would deep rest look like for you today?',
      promptTr: 'Bugün senin için derin dinlenme neye benzerdi?',
      phase: CyclePhase.menstrual,
    ),
    CyclePrompt(
      promptEn:
          'If you could ask your body one question, what would it be?',
      promptTr: 'Bedenine bir soru sorabilsen, ne sorardın?',
      phase: CyclePhase.menstrual,
    ),

    // ═══════════════════════════════════════════════════════════════════
    // FOLLICULAR PHASE - Rising Energy
    // ═══════════════════════════════════════════════════════════════════
    CyclePrompt(
      promptEn: 'What new idea or project excites you right now?',
      promptTr: 'Şu an seni heyecanlandıran yeni bir fikir veya proje ne?',
      phase: CyclePhase.follicular,
    ),
    CyclePrompt(
      promptEn:
          'Your energy is rising — what do you want to channel it toward?',
      promptTr: 'Enerjin yükseliyor — onu neye yönlendirmek istiyorsun?',
      phase: CyclePhase.follicular,
    ),
    CyclePrompt(
      promptEn:
          'What creative impulse have you been putting off? Today might be the day.',
      promptTr: 'Ertelediğin yaratıcı bir dürtü var mı? Bugün o gün olabilir.',
      phase: CyclePhase.follicular,
    ),
    CyclePrompt(
      promptEn: 'What would you start if you knew you could not fail?',
      promptTr: 'Başarısız olamayacağını bilsen neye başlardın?',
      phase: CyclePhase.follicular,
    ),
    CyclePrompt(
      promptEn:
          'How does it feel when your motivation returns? Notice the shift.',
      promptTr:
          'Motivasyonun geri döndüğünde nasıl hissediyorsun? Değişimi fark et.',
      phase: CyclePhase.follicular,
    ),
    CyclePrompt(
      promptEn: 'What skill or habit do you want to build while your energy is fresh?',
      promptTr: 'Enerjin tazeyken hangi beceri veya alışkanlığı geliştirmek istiyorsun?',
      phase: CyclePhase.follicular,
    ),
    CyclePrompt(
      promptEn: 'What does your most confident self look like this week?',
      promptTr: 'Bu hafta en özgüvenli halin neye benziyor?',
      phase: CyclePhase.follicular,
    ),
    CyclePrompt(
      promptEn: 'If you could plan the perfect day, what would it include?',
      promptTr: 'Mükemmel bir gün planlayabilsen, neler içerirdi?',
      phase: CyclePhase.follicular,
    ),
    CyclePrompt(
      promptEn: 'What small experiment could you try today?',
      promptTr: 'Bugün hangi küçük deneyi yapabilirsin?',
      phase: CyclePhase.follicular,
    ),

    // ═══════════════════════════════════════════════════════════════════
    // OVULATORY PHASE - Peak & Connection
    // ═══════════════════════════════════════════════════════════════════
    CyclePrompt(
      promptEn:
          'Who do you want to connect with today? What draws you to them?',
      promptTr:
          'Bugün kiminle bağlantı kurmak istiyorsun? Seni onlara çeken ne?',
      phase: CyclePhase.ovulatory,
    ),
    CyclePrompt(
      promptEn: 'Your social energy may be at its peak — how will you use it?',
      promptTr: 'Sosyal enerjin zirvede olabilir — onu nasıl kullanacaksın?',
      phase: CyclePhase.ovulatory,
    ),
    CyclePrompt(
      promptEn:
          'What conversation have you been avoiding? Now might feel easier.',
      promptTr: 'Hangi konuşmadan kaçınıyordun? Şimdi daha kolay hissedebilir.',
      phase: CyclePhase.ovulatory,
    ),
    CyclePrompt(
      promptEn: 'How do you express yourself when you feel most confident?',
      promptTr: 'En özgüvenli hissettiğinde kendini nasıl ifade edersin?',
      phase: CyclePhase.ovulatory,
    ),
    CyclePrompt(
      promptEn: 'What makes you feel truly seen by others?',
      promptTr: 'Başkaları tarafından gerçekten görüldüğünü hissettiren ne?',
      phase: CyclePhase.ovulatory,
    ),
    CyclePrompt(
      promptEn: 'What relationship in your life deserves more of your attention right now?',
      promptTr: 'Hayatında hangi ilişki şu an daha fazla ilgini hak ediyor?',
      phase: CyclePhase.ovulatory,
    ),
    CyclePrompt(
      promptEn: 'When you feel magnetic, what qualities are you radiating?',
      promptTr: 'Kendini çekici hissettiğinde hangi nitelikleri yayıyorsun?',
      phase: CyclePhase.ovulatory,
    ),
    CyclePrompt(
      promptEn: 'What bold step have you been considering? This might be the time.',
      promptTr: 'Düşündüğün cesur bir adım var mı? Şimdi tam zamanı olabilir.',
      phase: CyclePhase.ovulatory,
    ),
    CyclePrompt(
      promptEn: 'How can you celebrate yourself today, even in a small way?',
      promptTr: 'Bugün kendini küçük de olsa nasıl kutlayabilirsin?',
      phase: CyclePhase.ovulatory,
    ),

    // ═══════════════════════════════════════════════════════════════════
    // LUTEAL PHASE - Reflection & Inward Turn
    // ═══════════════════════════════════════════════════════════════════
    CyclePrompt(
      promptEn: 'What feelings are surfacing as your energy turns inward?',
      promptTr: 'Enerjin içe dönerken hangi duygular yüzeye çıkıyor?',
      phase: CyclePhase.luteal,
    ),
    CyclePrompt(
      promptEn:
          'Is there something bothering you that you have been pushing aside?',
      promptTr: 'Bir kenara ittiğin ama seni rahatsız eden bir şey var mı?',
      phase: CyclePhase.luteal,
    ),
    CyclePrompt(
      promptEn:
          'What patterns do you notice repeating at this point in your cycle?',
      promptTr:
          'Döngünün bu noktasında tekrarlanan hangi örüntüleri fark ediyorsun?',
      phase: CyclePhase.luteal,
    ),
    CyclePrompt(
      promptEn:
          'How can you be gentle with yourself during this reflective phase?',
      promptTr: 'Bu yansıma evresinde kendine nasıl nazik olabilirsin?',
      phase: CyclePhase.luteal,
    ),
    CyclePrompt(
      promptEn:
          'What truth becomes clearer when you slow down and listen inward?',
      promptTr: 'Yavaşlayıp içine kulak verdiğinde hangi gerçek netleşiyor?',
      phase: CyclePhase.luteal,
    ),
    CyclePrompt(
      promptEn: 'What unspoken need is asking for your attention?',
      promptTr: 'Dile getirilmemiş hangi ihtiyaç ilgini istiyor?',
      phase: CyclePhase.luteal,
    ),
    CyclePrompt(
      promptEn: 'What does your inner voice keep whispering that you have not acted on?',
      promptTr: 'İç sesin ne fısıldıyor da henüz harekete geçmedin?',
      phase: CyclePhase.luteal,
    ),
    CyclePrompt(
      promptEn: 'If frustration appears, what might it be protecting you from?',
      promptTr: 'Hayal kırıklığı beliriyorsa, seni neden koruyor olabilir?',
      phase: CyclePhase.luteal,
    ),
    CyclePrompt(
      promptEn: 'What would you say to yourself if you were your own best friend?',
      promptTr: 'Kendi en iyi arkadaşın olsan kendine ne söylerdin?',
      phase: CyclePhase.luteal,
    ),
  ];
}
