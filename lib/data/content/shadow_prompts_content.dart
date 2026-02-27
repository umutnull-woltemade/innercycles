// ════════════════════════════════════════════════════════════════════════════
// SHADOW PROMPTS CONTENT - Archetype-Aware Bilingual Journal Prompts
// ════════════════════════════════════════════════════════════════════════════
// 64 guided shadow work prompts (8 per archetype × 8 archetypes)
// + 4 cross-archetype integration prompts.
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
    ShadowPrompt(
      promptEn: 'What achievement would finally silence your inner critic? Is that realistic?',
      promptTr: 'Hangi başarı iç eleştirmenini nihayet susturur? Bu gerçekçi mi?',
      archetype: ShadowArchetype.innerCritic,
      depth: ShadowDepth.deep,
    ),
    ShadowPrompt(
      promptEn: 'Notice the tone of your self-talk right now. Would you speak to a child that way?',
      promptTr: 'Şu an iç sesin tonunu fark et. Bir çocuğa böyle konuşur muydun?',
      archetype: ShadowArchetype.innerCritic,
      depth: ShadowDepth.gentle,
    ),
    ShadowPrompt(
      promptEn: 'What would your life look like if you replaced self-criticism with curiosity?',
      promptTr: 'Öz-eleştiriyi merakla değiştirsen hayatın neye benzerdi?',
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
    ShadowPrompt(
      promptEn: 'What would you do today if you did not care what anyone thought?',
      promptTr: 'Kimsenin ne düşündüğünü umursamasan bugün ne yapardın?',
      archetype: ShadowArchetype.peoplePleaser,
      depth: ShadowDepth.moderate,
    ),
    ShadowPrompt(
      promptEn: 'Recall a time you abandoned your own needs to keep the peace. What did it cost you?',
      promptTr: 'Barışı korumak için kendi ihtiyaçlarından vazgeçtiğin bir anı hatırla. Sana neye mal oldu?',
      archetype: ShadowArchetype.peoplePleaser,
      depth: ShadowDepth.deep,
    ),
    ShadowPrompt(
      promptEn: 'What is one boundary you could set this week that scares you a little?',
      promptTr: 'Bu hafta koyabileceğin ve seni biraz korkutan bir sınır ne olabilir?',
      archetype: ShadowArchetype.peoplePleaser,
      depth: ShadowDepth.gentle,
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
    ShadowPrompt(
      promptEn: 'What is one thing you could do badly on purpose today? How does that thought feel?',
      promptTr: 'Bugün bilerek kötü yapabileceğin bir şey ne? Bu düşünce nasıl hissettiriyor?',
      archetype: ShadowArchetype.perfectionist,
      depth: ShadowDepth.gentle,
    ),
    ShadowPrompt(
      promptEn: 'What part of your life has your perfectionism made smaller instead of better?',
      promptTr: 'Mükemmeliyetçiliğin hayatının hangi bölümünü daha iyi yerine daha küçük yaptı?',
      archetype: ShadowArchetype.perfectionist,
      depth: ShadowDepth.deep,
    ),
    ShadowPrompt(
      promptEn: 'Who taught you that mistakes are unforgivable? Was that lesson true?',
      promptTr: 'Hataların affedilemez olduğunu sana kim öğretti? O ders doğru muydu?',
      archetype: ShadowArchetype.perfectionist,
      depth: ShadowDepth.deep,
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
    ShadowPrompt(
      promptEn: 'What is the worst that could happen if you let go? Now, how likely is that really?',
      promptTr: 'Bırakırsan olabilecek en kötü şey ne? Şimdi, bu gerçekten ne kadar olası?',
      archetype: ShadowArchetype.controller,
      depth: ShadowDepth.moderate,
    ),
    ShadowPrompt(
      promptEn: 'When you micromanage a situation, what emotion are you actually managing?',
      promptTr: 'Bir durumu aşırı kontrol ettiğinde, aslında hangi duyguyu yönetiyorsun?',
      archetype: ShadowArchetype.controller,
      depth: ShadowDepth.deep,
    ),
    ShadowPrompt(
      promptEn: 'Describe a time when something went unplanned and turned out beautifully.',
      promptTr: 'Planlanmamış ama güzel sonuçlanan bir anı anlat.',
      archetype: ShadowArchetype.controller,
      depth: ShadowDepth.gentle,
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
    ShadowPrompt(
      promptEn: 'What is one thing you are responsible for in your current situation that you have been blaming on others?',
      promptTr: 'Mevcut durumunda başkalarını suçladığın ama aslında senin sorumlu olduğun bir şey nedir?',
      archetype: ShadowArchetype.victim,
      depth: ShadowDepth.deep,
    ),
    ShadowPrompt(
      promptEn: 'What does being a victim protect you from having to do?',
      promptTr: 'Mağdur olmak seni ne yapmaktan koruyor?',
      archetype: ShadowArchetype.victim,
      depth: ShadowDepth.deep,
    ),
    ShadowPrompt(
      promptEn: 'Name three things you chose freely this week. How does it feel to claim those choices?',
      promptTr: 'Bu hafta özgürce seçtiğin üç şeyi say. Bu seçimleri sahiplenmek nasıl hissettiriyor?',
      archetype: ShadowArchetype.victim,
      depth: ShadowDepth.gentle,
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
    ShadowPrompt(
      promptEn: 'What structure or routine secretly makes you feel safe even though you resist it?',
      promptTr: 'Karşı koysan da seni gizlice güvende hissettiren hangi yapı veya rutin var?',
      archetype: ShadowArchetype.rebel,
      depth: ShadowDepth.moderate,
    ),
    ShadowPrompt(
      promptEn: 'When you break a rule, are you moving toward something or running from something?',
      promptTr: 'Bir kuralı çiğnediğinde, bir şeye doğru mu gidiyorsun yoksa bir şeyden mi kaçıyorsun?',
      archetype: ShadowArchetype.rebel,
      depth: ShadowDepth.deep,
    ),
    ShadowPrompt(
      promptEn: 'What would healthy autonomy look like for you, without the anger?',
      promptTr: 'Öfke olmadan sağlıklı özerklik senin için neye benzerdi?',
      archetype: ShadowArchetype.rebel,
      depth: ShadowDepth.moderate,
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
    ShadowPrompt(
      promptEn: 'What is one thing you have been putting off that you could start with just two minutes?',
      promptTr: 'Ertelediğin ama sadece iki dakikayla başlayabileceğin bir şey nedir?',
      archetype: ShadowArchetype.avoider,
      depth: ShadowDepth.gentle,
    ),
    ShadowPrompt(
      promptEn: 'What does the fantasy of escape look like for you? What are you escaping from?',
      promptTr: 'Kaçış hayalin neye benziyor? Neden kaçıyorsun?',
      archetype: ShadowArchetype.avoider,
      depth: ShadowDepth.deep,
    ),
    ShadowPrompt(
      promptEn: 'What small act of showing up could you do today, even imperfectly?',
      promptTr: 'Bugün kusurlu da olsa yapabileceğin küçük bir var olma eylemi ne olabilir?',
      archetype: ShadowArchetype.avoider,
      depth: ShadowDepth.gentle,
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
    ShadowPrompt(
      promptEn: 'What happens to your identity when you are not helping someone?',
      promptTr: 'Birine yardım etmediğinde kimliğine ne oluyor?',
      archetype: ShadowArchetype.caretaker,
      depth: ShadowDepth.deep,
    ),
    ShadowPrompt(
      promptEn: 'When did you learn that your worth depends on what you give to others?',
      promptTr: 'Değerinin başkalarına verdiğine bağlı olduğunu ne zaman öğrendin?',
      archetype: ShadowArchetype.caretaker,
      depth: ShadowDepth.deep,
    ),
    ShadowPrompt(
      promptEn: 'What would it feel like to receive help without giving anything in return?',
      promptTr: 'Karşılığında bir şey vermeden yardım almak nasıl hissettirirdi?',
      archetype: ShadowArchetype.caretaker,
      depth: ShadowDepth.gentle,
    ),

    // ═══════════════════════════════════════════════════════════════════
    // CROSS-ARCHETYPE INTEGRATION
    // ═══════════════════════════════════════════════════════════════════
    ShadowPrompt(
      promptEn:
          'Your inner critic says you are not enough; your people pleaser tries to prove otherwise. What if neither voice is telling the truth?',
      promptTr:
          'İç eleştirmenin yeterli olmadığını söylüyor; insanları memnun eden yanın aksini kanıtlamaya çalışıyor. Ya ikisi de doğruyu söylemiyorsa?',
      archetype: ShadowArchetype.innerCritic,
      depth: ShadowDepth.deep,
    ),
    ShadowPrompt(
      promptEn:
          'How do your perfectionism and need for control work together? What are they both trying to prevent?',
      promptTr:
          'Mükemmeliyetçiliğin ve kontrol ihtiyacın nasıl birlikte çalışıyor? İkisi de neyi önlemeye çalışıyor?',
      archetype: ShadowArchetype.perfectionist,
      depth: ShadowDepth.deep,
    ),
    ShadowPrompt(
      promptEn:
          'Your avoider and victim sides both keep you still. What would movement look like if you honored both their fears?',
      promptTr:
          'Kaçınan ve mağdur yanların ikisi de seni yerinde tutuyor. Her ikisinin de korkularını onurlandırsan, hareket neye benzerdi?',
      archetype: ShadowArchetype.avoider,
      depth: ShadowDepth.deep,
    ),
    ShadowPrompt(
      promptEn:
          'Your rebel wants freedom; your caregiver wants to be needed. Where do these two meet? What compromise could honor both?',
      promptTr:
          'Asi yanın özgürlük istiyor; bakıcı yanın ihtiyaç duyulmak istiyor. Bu ikisi nerede buluşuyor? Her ikisini de onurlandıracak bir uzlaşı ne olabilir?',
      archetype: ShadowArchetype.rebel,
      depth: ShadowDepth.deep,
    ),
  ];
}
