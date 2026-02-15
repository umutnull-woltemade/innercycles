/// Monthly Themes — 12 months of themed reflection content
/// Each month: theme name, description, 4 weekly reflection prompts,
/// seasonal wellness tip
/// Apple App Store 4.3(b) compliant. No predictions. Reflective/educational only.
library;

class MonthlyTheme {
  final int month; // 1-12
  final String themeNameEn;
  final String themeNameTr;
  final String descriptionEn;
  final String descriptionTr;
  final List<String> weeklyPromptsEn; // 4 prompts
  final List<String> weeklyPromptsTr; // 4 prompts
  final String wellnessTipEn;
  final String wellnessTipTr;

  const MonthlyTheme({
    required this.month,
    required this.themeNameEn,
    required this.themeNameTr,
    required this.descriptionEn,
    required this.descriptionTr,
    required this.weeklyPromptsEn,
    required this.weeklyPromptsTr,
    required this.wellnessTipEn,
    required this.wellnessTipTr,
  });
}

const List<MonthlyTheme> allMonthlyThemes = [
  // ═══════════════════════════════════════════════════════════════
  // JANUARY — New Beginnings
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 1,
    themeNameEn: 'New Beginnings',
    themeNameTr: 'Yeni Başlangıçlar',
    descriptionEn:
        'January invites a fresh start. Rather than rigid resolutions, consider setting gentle intentions rooted in self-awareness. What do you want to carry into this new chapter?',
    descriptionTr:
        'Ocak taze bir başlangıca davet eder. Katı kararlar yerine, öz farkındalığa dayalı nazik niyetler belirlemeyi düşünün. Bu yeni bölüme ne taşımak istiyorsunuz?',
    weeklyPromptsEn: [
      'What are you most hoping to feel more of this year? Not achieve — feel.',
      'What pattern from last year are you ready to gently release?',
      'If this month had a single theme for you, what word would capture it?',
      'Write a short letter to yourself to open again in December. What do you want to remember?',
    ],
    weeklyPromptsTr: [
      'Bu yıl en çok ne hissetmek istiyorsunuz? Başarmak değil — hissetmek.',
      'Geçen yıldan nazikçe bırakmaya hazır olduğunuz bir kalıp nedir?',
      'Bu ayın sizin için tek bir teması olsaydı, hangi kelime onu yakalardı?',
      'Aralıkta tekrar açmak üzere kendinize kısa bir mektup yazın. Ne hatırlamak istiyorsunuz?',
    ],
    wellnessTipEn:
        'Winter tends to call for rest. Consider honoring your body\'s natural desire to slow down rather than pushing for maximum output.',
    wellnessTipTr:
        'Kış dinlenmeye davet etme eğilimindedir. Maksimum verim için zorlamak yerine bedeninizin doğal yavaşlama arzusunu onurlandırmayı düşünün.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // FEBRUARY — Heart Patterns
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 2,
    themeNameEn: 'Heart Patterns',
    themeNameTr: 'Kalp Kalıpları',
    descriptionEn:
        'February is a time to explore the patterns of your emotional life. How do you connect, love, and protect your heart? Look beneath the surface of your relationships — with others and with yourself.',
    descriptionTr:
        'Şubat, duygusal hayatınızın kalıplarını keşfetmek için bir zamandır. Nasıl bağlanıyorsunuz, seviyorsunuz ve kalbinizi koruyorsunuz? İlişkilerinizin yüzeyinin altına bakın — başkalarıyla ve kendinizle.',
    weeklyPromptsEn: [
      'What does love look like in your daily life — not grand gestures, but the quiet, consistent kind?',
      'Which relationship in your life feels most nourishing right now, and what makes it so?',
      'Where do you tend to withhold love or affection? What fear lives underneath that holding back?',
      'Write yourself a kind message as if you were your own best friend. What does that friend say?',
    ],
    weeklyPromptsTr: [
      'Günlük hayatınızda aşk neye benziyor — büyük jestler değil, sessiz ve tutarlı tür?',
      'Hayatınızdaki hangi ilişki şu anda en besleyici hissediyor ve onu ne yapıyor?',
      'Sevgi veya şefkati nerede tutma eğilimindesiniz? Bu geri durmanın altında hangi korku yaşıyor?',
      'Kendinize en iyi arkadaşınızmış gibi nazik bir mesaj yazın. Bu arkadaş ne söylüyor?',
    ],
    wellnessTipEn:
        'Self-compassion tends to strengthen emotional resilience. Consider treating yourself with the same kindness you offer to someone you care about.',
    wellnessTipTr:
        'Öz-şefkat duygusal dayanıklılığı güçlendirme eğilimindedir. Önemsediğiniz birine sunduğunuz aynı naziklikle kendinize davranmayı düşünün.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // MARCH — Emerging Growth
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 3,
    themeNameEn: 'Emerging Growth',
    themeNameTr: 'Ortaya Çıkan Büyüme',
    descriptionEn:
        'As the world begins to thaw, so might something inside you. March invites you to notice what is stirring — new energy, new curiosity, new readiness. Growth does not need to be dramatic to be real.',
    descriptionTr:
        'Dünya erimeye başlarken, içinizdeki bir şey de eriyebilir. Mart, neyin kıpırdadığını fark etmenize davet eder — yeni enerji, yeni merak, yeni hazırlık. Büyümenin gerçek olması için dramatik olması gerekmez.',
    weeklyPromptsEn: [
      'What new interest or curiosity has been quietly growing in you recently?',
      'Where in your life do you sense something is ready to shift?',
      'What "seed" did you plant earlier this year that is starting to show signs of life?',
      'As the equinox approaches, where do you need more balance between doing and being?',
    ],
    weeklyPromptsTr: [
      'Son zamanlarda içinizdeki sessizce büyüyen yeni bir ilgi veya merak nedir?',
      'Hayatınızın neresinde bir şeyin değişmeye hazır olduğunu hissediyorsunuz?',
      'Bu yılın başlarında ektiğiniz hangi "tohum" yaşam belirtileri göstermeye başlıyor?',
      'Ekinoks yaklaşırken, yapma ve olma arasında nerede daha fazla dengeye ihtiyacınız var?',
    ],
    wellnessTipEn:
        'Spring equinox is a natural point of balance. Consider checking in on the equilibrium between rest and activity in your own life.',
    wellnessTipTr:
        'Bahar ekinoksu doğal bir denge noktasıdır. Kendi hayatınızdaki dinlenme ve aktivite arasındaki dengeyi kontrol etmeyi düşünün.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // APRIL — Inner Clarity
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 4,
    themeNameEn: 'Inner Clarity',
    themeNameTr: 'İç Berraklık',
    descriptionEn:
        'April brings longer days and a natural invitation to see things more clearly. This month, turn your attention to the mental and emotional fog that may have accumulated, and gently clear it.',
    descriptionTr:
        'Nisan daha uzun günler ve şeyleri daha net görmeye doğal bir davet getirir. Bu ay, dikkatinizi biriken zihinsel ve duygusal sise çevirin ve nazikçe temizleyin.',
    weeklyPromptsEn: [
      'What decision have you been avoiding that, once made, might bring you relief?',
      'Is there a story you tell yourself that no longer serves you? What would replace it?',
      'What becomes clearer when you remove the noise of others\' opinions from your thinking?',
      'If you trusted your gut completely for one day, what would you do differently?',
    ],
    weeklyPromptsTr: [
      'Bir kere verildiğinde size rahatlama getirebilecek hangi karardan kaçınıyorsunuz?',
      'Artık size hizmet etmeyen, kendinize anlattığınız bir hikaye var mı? Onun yerine ne koyardınız?',
      'Başkalarının fikirlerinin gürültüsünü düşüncenizden çıkardığınızda ne daha net oluyor?',
      'Bir gün boyunca içgüdülerinize tamamen güvenseydiniz, ne farklı yapardınız?',
    ],
    wellnessTipEn:
        'Mental clutter tends to affect sleep and mood. Consider a short "brain dump" — writing all thoughts on paper — as a way to create inner space.',
    wellnessTipTr:
        'Zihinsel karışıklık uyku ve ruh halini etkileme eğilimindedir. İç alan yaratmanın bir yolu olarak kısa bir "beyin boşaltma" — tüm düşünceleri kağıda yazma — düşünün.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // MAY — Creative Renewal
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 5,
    themeNameEn: 'Creative Renewal',
    themeNameTr: 'Yaratıcı Yenilenme',
    descriptionEn:
        'May is a month of blossoming. What creative energy have you been holding back? This is a time to play, experiment, and express without perfectionism.',
    descriptionTr:
        'Mayıs çiçek açma ayıdır. Hangi yaratıcı enerjiyi geri tutuyordunuz? Bu, mükemmeliyetçilik olmadan oynamak, denemek ve ifade etmek için bir zamandır.',
    weeklyPromptsEn: [
      'What form of creative expression calls to you right now, even if you have never tried it?',
      'When was the last time you made something with your hands? What did it feel like?',
      'What would you create if perfectionism were not a factor?',
      'How can you bring more play into your daily routine this week?',
    ],
    weeklyPromptsTr: [
      'Hiç denemediyseniz bile, şu anda hangi yaratıcı ifade biçiminiz sizi çağırır?',
      'En son ne zaman ellerinizle bir şey yaptınız? Nasıl hissettirdi?',
      'Mükemmeliyetçilik bir faktör olmasaydı ne yaratırdınız?',
      'Bu hafta günlük rutininize daha fazla oyunu nasıl sokabilirsiniz?',
    ],
    wellnessTipEn:
        'Creative expression — even five minutes of doodling or humming — tends to reduce stress hormones. Consider making space for unstructured play.',
    wellnessTipTr:
        'Yaratıcı ifade — beş dakikalık karalama veya mırıldanma bile — stres hormonlarını azaltma eğilimindedir. Yapısız oyun için alan yapmayı düşünün.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // JUNE — Energy & Light
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 6,
    themeNameEn: 'Energy & Light',
    themeNameTr: 'Enerji & Işık',
    descriptionEn:
        'June brings the longest days. This is a time of peak energy and visibility. How are you using this abundant light — both externally and within yourself?',
    descriptionTr:
        'Haziran en uzun günleri getirir. Bu, doruk enerji ve görünürlüğün zamanıdır. Bu bol ışığı nasıl kullanıyorsunuz — hem dışarıda hem de içinizdeki?',
    weeklyPromptsEn: [
      'What are you pouring your energy into right now? Does it align with what matters most to you?',
      'The solstice marks peak light. What is becoming most visible or clear in your life?',
      'Where in your life do you need to turn up the brightness — give more attention, more care?',
      'What would it feel like to end this month having honored your energy instead of depleted it?',
    ],
    weeklyPromptsTr: [
      'Şu anda enerjinizi neye harcıyorsunuz? En çok önemli olan şeyle uyumlu mu?',
      'Gündönümü doruk ışığı işaret eder. Hayatınızda en çok ne görünür veya net hale geliyor?',
      'Hayatınızın neresinde parlaklığı artırmanız gerekiyor — daha fazla dikkat, daha fazla özen?',
      'Bu ayı enerjinizi tüketmek yerine onurlandırarak bitirmek nasıl hissettirir?',
    ],
    wellnessTipEn:
        'Longer days tend to shift sleep patterns. Consider maintaining a consistent bedtime even as sunlight extends, to support your natural rest cycle.',
    wellnessTipTr:
        'Daha uzun günler uyku kalıplarını değiştirme eğilimindedir. Doğal dinlenme döngünüzü desteklemek için güneş uzadıkça bile tutarlı bir yatma saati sürdürmeyi düşünün.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // JULY — Connection & Joy
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 7,
    themeNameEn: 'Connection & Joy',
    themeNameTr: 'Bağlantı & Neşe',
    descriptionEn:
        'July is the heart of summer — a natural time for warmth, connection, and joy. This month, notice what brings you genuine happiness and what relationships feed your spirit.',
    descriptionTr:
        'Temmuz yazın kalbidir — sıcaklık, bağlantı ve neşe için doğal bir zaman. Bu ay, size gerçek mutluluk getiren şeyi ve ruhunuzu besleyen ilişkileri fark edin.',
    weeklyPromptsEn: [
      'What brought you the most genuine joy this week? Was it planned or spontaneous?',
      'Which relationships feel most alive and reciprocal in your life right now?',
      'What simple pleasure have you been overlooking or taking for granted?',
      'How do you define "enough" when it comes to social connection? Are you getting what you need?',
    ],
    weeklyPromptsTr: [
      'Bu hafta size en gerçek neşeyi ne getirdi? Planlı mıydı yoksa kendiliğinden mi?',
      'Hayatınızda şu anda hangi ilişkiler en canlı ve karşılıklı hissediliyor?',
      'Hangi basit zevki gözden kaçırıyorsunuz veya hafife alıyorsunuz?',
      'Sosyal bağlantı söz konusu olduğunda "yeterli"yi nasıl tanımlıyorsunuz? İhtiyacınız olanı alıyor musunuz?',
    ],
    wellnessTipEn:
        'Spending time in nature, even briefly, tends to boost mood and reduce mental fatigue. Consider adding a few minutes outdoors to your daily rhythm.',
    wellnessTipTr:
        'Doğada vakit geçirmek, kısa da olsa, ruh halini yükseltme ve zihinsel yorgunluğu azaltma eğilimindedir. Günlük ritminize birkaç dakika dış mekan eklemeyi düşünün.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // AUGUST — Depth & Presence
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 8,
    themeNameEn: 'Depth & Presence',
    themeNameTr: 'Derinlik & Varlık',
    descriptionEn:
        'As summer begins to peak, August offers an invitation to go deeper rather than wider. Slow down, be present, and explore what lies beneath the surface of your daily life.',
    descriptionTr:
        'Yaz doruk noktasına ulaşırken, Ağustos daha geniş değil daha derine gitmeniz için bir davet sunar. Yavaşın, var olun ve günlük hayatınızın yüzeyinin altında ne olduğunu keşfedin.',
    weeklyPromptsEn: [
      'What topic or feeling have you been skimming over that deserves deeper attention?',
      'When do you feel most fully present — not thinking about the past or future?',
      'What would your life look like if you did fewer things but with more intention?',
      'Reflect on a moment this month when time seemed to slow down. What was different?',
    ],
    weeklyPromptsTr: [
      'Daha derin dikkat hak eden hangi konuyu veya duyguyu gözden geçiriyorsunuz?',
      'Geçmişi veya geleceği düşünmeden en tamamen var olduğunuzu ne zaman hissediyorsunuz?',
      'Daha az şey yapsanız ama daha fazla niyetle yapsanız hayatınız nasıl görünürdü?',
      'Bu ay zamanın yavaşlamış gibi göründüğü bir anı düşünün. Farklı olan neydi?',
    ],
    wellnessTipEn:
        'Presence tends to reduce anxiety. Consider setting aside five minutes daily to do nothing — no phone, no task, just being.',
    wellnessTipTr:
        'Varlık kaygıyı azaltma eğilimindedir. Günlük beş dakika hiçbir şey yapmama — telefon yok, görev yok, sadece var olma — için ayırmayı düşünün.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // SEPTEMBER — Harvest & Gratitude
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 9,
    themeNameEn: 'Harvest & Gratitude',
    themeNameTr: 'Hasat & Şükran',
    descriptionEn:
        'September marks the shift toward autumn — a time to gather what you have grown and appreciate what you have built. Before rushing into the next chapter, pause to honor this one.',
    descriptionTr:
        'Eylül sonbahara geçişi işaret eder — büyüttüğünüzü toplayacak ve inşa ettiğinizi takdir edecek bir zaman. Bir sonraki bölüme koşmadan önce, bu bölümü onurlandırmak için durun.',
    weeklyPromptsEn: [
      'What have you accomplished or experienced this year that you have not fully acknowledged?',
      'Who deserves your gratitude for their role in your growth? Have you told them?',
      'What did you learn about yourself between June and now that surprised you?',
      'As the equinox arrives, what needs to be balanced before the quieter months ahead?',
    ],
    weeklyPromptsTr: [
      'Bu yıl tamamen kabul etmediğiniz hangi başarıyı veya deneyimi yaşadınız?',
      'Büyümeninizdeki rolleri için kim şükranınızı hak ediyor? Onlara söylediniz mi?',
      'Hazirandan şimdiye kadar kendiniz hakkında sizi şaşırtan ne öğrendiniz?',
      'Ekinoks gelirken, önümüzdeki sessiz aylardan önce neyin dengelenmesi gerekiyor?',
    ],
    wellnessTipEn:
        'Gratitude practice tends to strengthen emotional well-being. Consider writing three specific things you appreciate at the end of each week this month.',
    wellnessTipTr:
        'Şükran pratiği duygusal iyiliği güçlendirme eğilimindedir. Bu ay her haftanın sonunda takdir ettiğiniz üç spesifik şeyi yazmayı düşünün.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // OCTOBER — Inner Shadows
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 10,
    themeNameEn: 'Inner Shadows',
    themeNameTr: 'İç Gölgeler',
    descriptionEn:
        'As days shorten and darkness grows, October invites you to explore what you usually avoid — the shadow side of your personality, the feelings you suppress, the truths you resist.',
    descriptionTr:
        'Günler kısaldıkça ve karanlık büyüdükçe, Ekim genellikle kaçındığınız şeyi keşfetmenize davet eder — kişiliğinizin gölge tarafı, bastırdığınız duygular, direndiğiniz gerçekler.',
    weeklyPromptsEn: [
      'What part of yourself do you tend to hide from others? What would happen if you let it be seen?',
      'What emotion do you most frequently avoid feeling? What might it be trying to tell you?',
      'Reflect on a time you judged someone harshly. What does that judgment reveal about you?',
      'What would self-acceptance look like if it included the parts of you that you dislike?',
    ],
    weeklyPromptsTr: [
      'Kendinizin hangi kısmını genellikle başkalarından gizliyorsunuz? Görülmesine izin verseydiniz ne olurdu?',
      'En sık hissetmekten kaçındığınız duygu nedir? Size ne anlatmaya çalışıyor olabilir?',
      'Birini sertçe yargıladığınız bir zamanı düşünün. Bu yargı sizin hakkınızda ne ortaya koyuyor?',
      'Öz-kabul, beğenmediğiniz kısımlarınızı da içerseydi nasıl görünürdü?',
    ],
    wellnessTipEn:
        'Journaling about difficult emotions tends to reduce their grip. Consider writing freely for five minutes about something you have been avoiding.',
    wellnessTipTr:
        'Zor duygular hakkında günlük tutma onların etkisini azaltma eğilimindedir. Kaçındığınız bir şey hakkında beş dakika serbestçe yazmayı düşünün.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // NOVEMBER — Resilience
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 11,
    themeNameEn: 'Resilience',
    themeNameTr: 'Dayanıklılık',
    descriptionEn:
        'November is a bridge between the richness of autumn and the stillness of winter. This month, reflect on your capacity to endure, adapt, and recover. You have made it through more than you realize.',
    descriptionTr:
        'Kasım, sonbaharın zenginliği ile kışın sessizliği arasında bir köprüdür. Bu ay, dayanma, uyum sağlama ve toparlanma kapasitenizi düşünün. Farkında olduğunuzdan daha fazlasının üstesinden geldiniz.',
    weeklyPromptsEn: [
      'What is the hardest thing you have navigated this year, and what did it teach you about yourself?',
      'Who or what has been your greatest source of strength during challenging times?',
      'What does resilience look like for you — pushing through, or knowing when to rest?',
      'Write a message to someone going through what you went through. What wisdom would you share?',
    ],
    weeklyPromptsTr: [
      'Bu yıl üstesinden geldiğiniz en zor şey neydi ve kendiniz hakkında ne öğretti?',
      'Zorlu zamanlarda en büyük güç kaynağınız kim veya ne oldu?',
      'Dayanıklılık sizin için neye benziyor — zorlamak mı, yoksa ne zaman dinleneceğinizi bilmek mi?',
      'Sizin yaşadığınızı yaşayan birine bir mesaj yazın. Hangi bilgeliği paylaşırdınız?',
    ],
    wellnessTipEn:
        'Building resilience tends to include rest, not just endurance. Consider creating intentional downtime this month as an act of strength, not weakness.',
    wellnessTipTr:
        'Dayanıklılık oluşturma sadece dayanmayı değil, dinlenmeyi de içerme eğilimindedir. Bu ay zayıflık değil güç eylemi olarak bilinçli dinlenme zamanı yaratmayı düşünün.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // DECEMBER — Year Reflection
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 12,
    themeNameEn: 'Year Reflection',
    themeNameTr: 'Yıl Değerlendirmesi',
    descriptionEn:
        'December is the closing chapter. Before the new year begins, give yourself the gift of looking back with honesty and compassion. Celebrate how far you have come, and set intentions — not resolutions — for what lies ahead.',
    descriptionTr:
        'Aralık kapanış bölümüdür. Yeni yıl başlamadan önce, kendinize dürüstlük ve şefkatle geriye bakma hediyesi verin. Ne kadar ilerlediğinizi kutlayın ve önünüzdekiler için niyetler belirleyin — kararlar değil.',
    weeklyPromptsEn: [
      'What are the three most meaningful moments from this year? Why do they stand out?',
      'What did you let go of this year that you thought you could not live without?',
      'If this year were a chapter in your life story, what would its title be?',
      'What intention do you want to carry into the new year? Make it one sentence.',
    ],
    weeklyPromptsTr: [
      'Bu yılın en anlamlı üç anı nelerdir? Neden öne çıkıyorlar?',
      'Bu yıl onsuz yaşayamadığınızı düşündüğünüz neyi bıraktınız?',
      'Bu yıl hayat hikayenizin bir bölümü olsaydı, başlığı ne olurdu?',
      'Yeni yıla hangi niyeti taşımak istiyorsunuz? Tek cümle yapın.',
    ],
    wellnessTipEn:
        'The year-end rush tends to increase stress. Consider protecting at least one quiet evening per week in December for reflection and rest.',
    wellnessTipTr:
        'Yıl sonu koşturması stresi artırma eğilimindedir. Aralık ayında haftada en az bir sessiz akşamı düşünme ve dinlenme için koruma altına almayı düşünün.',
  ),
];
