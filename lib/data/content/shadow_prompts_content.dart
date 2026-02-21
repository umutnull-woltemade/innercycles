// ════════════════════════════════════════════════════════════════════════════
// SHADOW PROMPTS CONTENT - Archetype-Aware Bilingual Journal Prompts
// ════════════════════════════════════════════════════════════════════════════
// 40 guided shadow work prompts (5 per archetype × 8 archetypes).
// Each prompt has a depth level: gentle → moderate → deep.
// ════════════════════════════════════════════════════════════════════════════

import '../models/shadow_work_entry.dart';

class ShadowPrompt {
  final String promptEn;
  final String promptTr;
  final ShadowArchetype archetype;
  final ShadowDepth depth;

  const ShadowPrompt({
    required this.promptEn,
    required this.promptTr,
    required this.archetype,
    required this.depth,
  });
}

class ShadowPromptsContent {
  ShadowPromptsContent._();

  /// Get prompts for a specific archetype
  static List<ShadowPrompt> getPromptsForArchetype(ShadowArchetype archetype) {
    return allPrompts.where((p) => p.archetype == archetype).toList();
  }

  /// Get prompts filtered by depth level
  static List<ShadowPrompt> getPromptsForDepth(ShadowDepth depth) {
    return allPrompts.where((p) => p.depth == depth).toList();
  }

  /// Get a date-rotated prompt for an archetype
  static ShadowPrompt getPromptForDate(
    ShadowArchetype archetype,
    DateTime date,
  ) {
    final prompts = getPromptsForArchetype(archetype);
    if (prompts.isEmpty) return allPrompts.first;
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    return prompts[dayOfYear % prompts.length];
  }

  /// Get a depth-appropriate prompt (gentle for new users, deeper over time)
  static ShadowPrompt getDepthAppropriatePrompt(
    ShadowArchetype archetype,
    int entryCount,
    DateTime date,
  ) {
    ShadowDepth targetDepth;
    if (entryCount < 3) {
      targetDepth = ShadowDepth.gentle;
    } else if (entryCount < 8) {
      targetDepth = ShadowDepth.moderate;
    } else {
      targetDepth = ShadowDepth.deep;
    }

    final filtered = allPrompts
        .where((p) => p.archetype == archetype && p.depth == targetDepth)
        .toList();
    if (filtered.isEmpty) return getPromptForDate(archetype, date);
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    return filtered[dayOfYear % filtered.length];
  }

  static const List<ShadowPrompt> allPrompts = [
    // ═══════════════════════════════════════════════════════════════════
    // INNER CRITIC
    // ═══════════════════════════════════════════════════════════════════
    ShadowPrompt(
      promptEn:
          'What does your inner critic say most often? Can you hear whose voice it echoes?',
      promptTr:
          'İç eleştirmenin en sık ne söylüyor? Kimin sesini yankıladığını duyabiliyor musun?',
      archetype: ShadowArchetype.innerCritic,
      depth: ShadowDepth.gentle,
    ),
    ShadowPrompt(
      promptEn: 'When did you first start believing you were not good enough?',
      promptTr: 'Yeterince iyi olmadığına ilk ne zaman inanmaya başladın?',
      archetype: ShadowArchetype.innerCritic,
      depth: ShadowDepth.moderate,
    ),
    ShadowPrompt(
      promptEn:
          'If your inner critic were trying to protect you, what would it be protecting you from?',
      promptTr:
          'İç eleştirmenin seni korumaya çalışıyor olsaydı, seni neden koruyor olurdu?',
      archetype: ShadowArchetype.innerCritic,
      depth: ShadowDepth.deep,
    ),
    ShadowPrompt(
      promptEn:
          'Write down three things your inner critic says. Now rewrite them with compassion.',
      promptTr:
          'İç eleştirmenin söylediği üç şeyi yaz. Şimdi onları şefkatle yeniden yaz.',
      archetype: ShadowArchetype.innerCritic,
      depth: ShadowDepth.gentle,
    ),
    ShadowPrompt(
      promptEn:
          'What would change if you treated yourself the way you treat your best friend?',
      promptTr:
          'Kendine en yakın arkadaşına davrandığın gibi davransaydın ne değişirdi?',
      archetype: ShadowArchetype.innerCritic,
      depth: ShadowDepth.moderate,
    ),

    // ═══════════════════════════════════════════════════════════════════
    // PEOPLE PLEASER
    // ═══════════════════════════════════════════════════════════════════
    ShadowPrompt(
      promptEn:
          'When was the last time you said yes when you wanted to say no?',
      promptTr: 'En son ne zaman hayır demek isterken evet dedin?',
      archetype: ShadowArchetype.peoplePleaser,
      depth: ShadowDepth.gentle,
    ),
    ShadowPrompt(
      promptEn: 'What do you fear will happen if people see the real you?',
      promptTr: 'İnsanlar gerçek seni görürse ne olacağından korkuyorsun?',
      archetype: ShadowArchetype.peoplePleaser,
      depth: ShadowDepth.moderate,
    ),
    ShadowPrompt(
      promptEn:
          'Whose approval are you still seeking? What would it feel like to stop?',
      promptTr: 'Hâlâ kimin onayını arıyorsun? Durduğunda nasıl hissederdin?',
      archetype: ShadowArchetype.peoplePleaser,
      depth: ShadowDepth.deep,
    ),
    ShadowPrompt(
      promptEn:
          'What need of yours gets ignored when you put everyone else first?',
      promptTr:
          'Herkesi kendinden önce koyduğunda hangi ihtiyacın göz ardı ediliyor?',
      archetype: ShadowArchetype.peoplePleaser,
      depth: ShadowDepth.gentle,
    ),
    ShadowPrompt(
      promptEn:
          'If saying no made someone love you less, what would that reveal about the relationship?',
      promptTr:
          'Hayır demek birinin seni daha az sevmesine neden olsaydı, bu ilişki hakkında ne ortaya çıkarırdı?',
      archetype: ShadowArchetype.peoplePleaser,
      depth: ShadowDepth.deep,
    ),

    // ═══════════════════════════════════════════════════════════════════
    // PERFECTIONIST
    // ═══════════════════════════════════════════════════════════════════
    ShadowPrompt(
      promptEn: 'What are you avoiding because you cannot do it perfectly?',
      promptTr: 'Mükemmel yapamayacağın için nelerden kaçınıyorsun?',
      archetype: ShadowArchetype.perfectionist,
      depth: ShadowDepth.gentle,
    ),
    ShadowPrompt(
      promptEn: 'When did "good enough" stop being enough for you?',
      promptTr: '"Yeterince iyi" senin için ne zaman yeterli olmayı bıraktı?',
      archetype: ShadowArchetype.perfectionist,
      depth: ShadowDepth.moderate,
    ),
    ShadowPrompt(
      promptEn:
          'What would happen if you let yourself be messy, imperfect, and human?',
      promptTr:
          'Kendinin dağınık, kusurlu ve insan olmasına izin versen ne olurdu?',
      archetype: ShadowArchetype.perfectionist,
      depth: ShadowDepth.deep,
    ),
    ShadowPrompt(
      promptEn:
          'Describe something imperfect that you love. Why does imperfection work there?',
      promptTr:
          'Sevdiğin kusurlu bir şeyi anlat. Neden orada kusursuzluk işe yarıyor?',
      archetype: ShadowArchetype.perfectionist,
      depth: ShadowDepth.gentle,
    ),
    ShadowPrompt(
      promptEn:
          'Is your perfectionism about excellence or about fear? Be honest.',
      promptTr:
          'Mükemmeliyetçiliğin mükemmellik mi yoksa korku mu ile ilgili? Dürüst ol.',
      archetype: ShadowArchetype.perfectionist,
      depth: ShadowDepth.moderate,
    ),

    // ═══════════════════════════════════════════════════════════════════
    // CONTROLLER
    // ═══════════════════════════════════════════════════════════════════
    ShadowPrompt(
      promptEn:
          'What happens in your body when things do not go according to plan?',
      promptTr: 'İşler planlandığı gibi gitmediğinde bedeninde ne oluyor?',
      archetype: ShadowArchetype.controller,
      depth: ShadowDepth.gentle,
    ),
    ShadowPrompt(
      promptEn: 'What are you most afraid of losing control over?',
      promptTr: 'En çok neyin kontrolünü kaybetmekten korkuyorsun?',
      archetype: ShadowArchetype.controller,
      depth: ShadowDepth.moderate,
    ),
    ShadowPrompt(
      promptEn:
          'When did you first learn that you had to be in control to feel safe?',
      promptTr:
          'Güvende hissetmek için kontrol altında olman gerektiğini ilk ne zaman öğrendin?',
      archetype: ShadowArchetype.controller,
      depth: ShadowDepth.deep,
    ),
    ShadowPrompt(
      promptEn:
          'Name one thing you could surrender today. How does that idea feel?',
      promptTr:
          'Bugün teslim edebileceğin bir şey söyle. Bu fikir nasıl hissettiriyor?',
      archetype: ShadowArchetype.controller,
      depth: ShadowDepth.gentle,
    ),
    ShadowPrompt(
      promptEn:
          'How does your need for control affect the people closest to you?',
      promptTr: 'Kontrol ihtiyacın sana en yakın insanları nasıl etkiliyor?',
      archetype: ShadowArchetype.controller,
      depth: ShadowDepth.moderate,
    ),

    // ═══════════════════════════════════════════════════════════════════
    // VICTIM
    // ═══════════════════════════════════════════════════════════════════
    ShadowPrompt(
      promptEn: 'When do you feel most powerless? What triggers that feeling?',
      promptTr:
          'En çok ne zaman güçsüz hissediyorsun? Bu duyguyu ne tetikliyor?',
      archetype: ShadowArchetype.victim,
      depth: ShadowDepth.gentle,
    ),
    ShadowPrompt(
      promptEn:
          'Is there a situation where you have more power than you admit?',
      promptTr: 'Kabul ettiğinden daha fazla gücün olduğu bir durum var mı?',
      archetype: ShadowArchetype.victim,
      depth: ShadowDepth.moderate,
    ),
    ShadowPrompt(
      promptEn:
          'What story do you tell yourself about why things happen to you?',
      promptTr:
          'Şeylerin sana neden olduğuna dair kendine hangi hikayeyi anlatıyorsun?',
      archetype: ShadowArchetype.victim,
      depth: ShadowDepth.deep,
    ),
    ShadowPrompt(
      promptEn:
          'What is one small step you could take to reclaim your power today?',
      promptTr:
          'Bugün gücünü geri almak için atabileceğin küçük bir adım nedir?',
      archetype: ShadowArchetype.victim,
      depth: ShadowDepth.gentle,
    ),
    ShadowPrompt(
      promptEn:
          'If you stopped seeing yourself as powerless in this situation, what would you do differently?',
      promptTr:
          'Bu durumda kendini güçsüz olarak görmeyi bıraksan, neyi farklı yapardın?',
      archetype: ShadowArchetype.victim,
      depth: ShadowDepth.moderate,
    ),

    // ═══════════════════════════════════════════════════════════════════
    // REBEL
    // ═══════════════════════════════════════════════════════════════════
    ShadowPrompt(
      promptEn: 'What rules or expectations do you resist most? Why?',
      promptTr:
          'En çok hangi kurallara veya beklentilere direniryorsun? Neden?',
      archetype: ShadowArchetype.rebel,
      depth: ShadowDepth.gentle,
    ),
    ShadowPrompt(
      promptEn:
          'Is your rebellion about freedom or about anger? Where does it come from?',
      promptTr:
          'İsyanın özgürlükle mi yoksa öfkeyle mi ilgili? Nereden geliyor?',
      archetype: ShadowArchetype.rebel,
      depth: ShadowDepth.moderate,
    ),
    ShadowPrompt(
      promptEn:
          'What would happen if you chose to follow a rule willingly, not out of obedience?',
      promptTr: 'İtaatten değil, isteyerek bir kurala uymayı seçsen ne olurdu?',
      archetype: ShadowArchetype.rebel,
      depth: ShadowDepth.deep,
    ),
    ShadowPrompt(
      promptEn:
          'When does your rebellious side serve you well, and when does it sabotage you?',
      promptTr:
          'Asi yanın sana ne zaman hizmet eder, ne zaman seni sabote eder?',
      archetype: ShadowArchetype.rebel,
      depth: ShadowDepth.gentle,
    ),
    ShadowPrompt(
      promptEn:
          'What authority figure from your past are you still fighting against?',
      promptTr: 'Geçmişindeki hangi otorite figürüne hâlâ karşı savaşıyorsun?',
      archetype: ShadowArchetype.rebel,
      depth: ShadowDepth.deep,
    ),

    // ═══════════════════════════════════════════════════════════════════
    // AVOIDER
    // ═══════════════════════════════════════════════════════════════════
    ShadowPrompt(
      promptEn:
          'What emotion do you avoid feeling the most? Why does it scare you?',
      promptTr:
          'En çok hangi duyguyu hissetmekten kaçınıyorsun? Neden seni korkutuyor?',
      archetype: ShadowArchetype.avoider,
      depth: ShadowDepth.gentle,
    ),
    ShadowPrompt(
      promptEn:
          'What would happen if you sat with your discomfort instead of running from it?',
      promptTr:
          'Rahatsızlığından kaçmak yerine onunla birlikte otursaydın ne olurdu?',
      archetype: ShadowArchetype.avoider,
      depth: ShadowDepth.moderate,
    ),
    ShadowPrompt(
      promptEn:
          'What important conversation or decision are you postponing right now?',
      promptTr: 'Şu an hangi önemli konuşmayı veya kararı erteliyorsun?',
      archetype: ShadowArchetype.avoider,
      depth: ShadowDepth.gentle,
    ),
    ShadowPrompt(
      promptEn:
          'What does avoidance cost you in the long run? Name three consequences.',
      promptTr: 'Kaçınmanın uzun vadede sana maliyeti nedir? Üç sonuç belirt.',
      archetype: ShadowArchetype.avoider,
      depth: ShadowDepth.moderate,
    ),
    ShadowPrompt(
      promptEn:
          'When you disappear from situations, what part of you are you trying to protect?',
      promptTr:
          'Durumlardan uzaklaştığında, kendinin hangi parçasını korumaya çalışıyorsun?',
      archetype: ShadowArchetype.avoider,
      depth: ShadowDepth.deep,
    ),

    // ═══════════════════════════════════════════════════════════════════
    // CARETAKER
    // ═══════════════════════════════════════════════════════════════════
    ShadowPrompt(
      promptEn:
          'When was the last time someone took care of you? How did it feel?',
      promptTr: 'En son ne zaman biri sana baktı? Nasıl hissettirdi?',
      archetype: ShadowArchetype.caretaker,
      depth: ShadowDepth.gentle,
    ),
    ShadowPrompt(
      promptEn: 'Do you believe you deserve the same care you give to others?',
      promptTr: 'Başkalarına verdiğin aynı ilgiyi hak ettiğine inanıyor musun?',
      archetype: ShadowArchetype.caretaker,
      depth: ShadowDepth.moderate,
    ),
    ShadowPrompt(
      promptEn:
          'What would it mean if you were not needed? Who would you be without your role as caretaker?',
      promptTr:
          'İhtiyaç duyulmasaydın ne anlam ifade ederdi? Bakıcı rolün olmadan kim olurdun?',
      archetype: ShadowArchetype.caretaker,
      depth: ShadowDepth.deep,
    ),
    ShadowPrompt(
      promptEn: 'What is one thing you need that you have not asked for?',
      promptTr: 'İstemediğin ama ihtiyacın olan bir şey nedir?',
      archetype: ShadowArchetype.caretaker,
      depth: ShadowDepth.gentle,
    ),
    ShadowPrompt(
      promptEn:
          'Is your caretaking about love or about being indispensable? Explore the difference.',
      promptTr:
          'Bakım vermen sevgiyle mi yoksa vazgeçilmez olmayla mı ilgili? Farkı keşfet.',
      archetype: ShadowArchetype.caretaker,
      depth: ShadowDepth.moderate,
    ),
  ];
}
