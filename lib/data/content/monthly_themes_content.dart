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
    themeNameTr: 'Yeni Baslangiclar',
    descriptionEn:
        'January invites a fresh start. Rather than rigid resolutions, consider setting gentle intentions rooted in self-awareness. What do you want to carry into this new chapter?',
    descriptionTr:
        'Ocak taze bir baslangica davet eder. Kati kararlar yerine, oz farkindaliliga dayali nazik niyetler belirlemeyi dusunun. Bu yeni bolume ne tasimak istiyorsunuz?',
    weeklyPromptsEn: [
      'What are you most hoping to feel more of this year? Not achieve — feel.',
      'What pattern from last year are you ready to gently release?',
      'If this month had a single theme for you, what word would capture it?',
      'Write a short letter to yourself to open again in December. What do you want to remember?',
    ],
    weeklyPromptsTr: [
      'Bu yil en cok ne hissetmek istiyorsunuz? Basarmak degil — hissetmek.',
      'Gecen yildan nazikce birakmaya hazir oldugunuz bir kalip nedir?',
      'Bu ayin sizin icin tek bir temasi olsaydi, hangi kelime onu yakalardi?',
      'Aralikta tekrar acmak uzere kendinize kisa bir mektup yazin. Ne hatirlamak istiyorsunuz?',
    ],
    wellnessTipEn:
        'Winter tends to call for rest. Consider honoring your body\'s natural desire to slow down rather than pushing for maximum output.',
    wellnessTipTr:
        'Kis dinlenmeye davet etme egilimindedir. Maksimum verim icin zorlamak yerine bedeninizin dogal yavasama arzusunu onurlandirmayi dusunun.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // FEBRUARY — Heart Patterns
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 2,
    themeNameEn: 'Heart Patterns',
    themeNameTr: 'Kalp Kaliplari',
    descriptionEn:
        'February is a time to explore the patterns of your emotional life. How do you connect, love, and protect your heart? Look beneath the surface of your relationships — with others and with yourself.',
    descriptionTr:
        'Subat, duygusal hayatinizin kaliplarini kesfetmek icin bir zamandir. Nasil baglaniyorsunuz, seviyorsunuz ve kalbinizi koruyorsunuz? Iliskilerinizin yuzeyinin altina bakin — baskalariyla ve kendinizle.',
    weeklyPromptsEn: [
      'What does love look like in your daily life — not grand gestures, but the quiet, consistent kind?',
      'Which relationship in your life feels most nourishing right now, and what makes it so?',
      'Where do you tend to withhold love or affection? What fear lives underneath that holding back?',
      'Write yourself a kind message as if you were your own best friend. What does that friend say?',
    ],
    weeklyPromptsTr: [
      'Gunluk hayatinizda ask neye benziyor — buyuk jestler degil, sessiz ve tutarli tur?',
      'Hayatinizdaki hangi iliski su anda en besleyici hissediyor ve onu ne yapyor?',
      'Sevgi veya sefkati nerede tutma egilimindesniz? Bu geri durmanin altinda hangi korku yasiyor?',
      'Kendinize en iyi arkadasinizmis gibi nazik bir mesaj yazin. Bu arkadas ne soyluyor?',
    ],
    wellnessTipEn:
        'Self-compassion tends to strengthen emotional resilience. Consider treating yourself with the same kindness you offer to someone you care about.',
    wellnessTipTr:
        'Oz-sefkat duygusal dayanikliligi guclendirme egilimindedir. Onemsediginiz birine sundunuz ayni naziklikle kendinize davranmayi dusunun.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // MARCH — Emerging Growth
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 3,
    themeNameEn: 'Emerging Growth',
    themeNameTr: 'Ortaya Cikan Buyume',
    descriptionEn:
        'As the world begins to thaw, so might something inside you. March invites you to notice what is stirring — new energy, new curiosity, new readiness. Growth does not need to be dramatic to be real.',
    descriptionTr:
        'Dunya erime baslarken, icinizdeki bir sey de eriyebilir. Mart, neyin kipirdadigini fark etmenize davet eder — yeni enerji, yeni merak, yeni hazirlik. Buyumenin gercek olmasi icin dramatik olmasi gerekmez.',
    weeklyPromptsEn: [
      'What new interest or curiosity has been quietly growing in you recently?',
      'Where in your life do you sense something is ready to shift?',
      'What "seed" did you plant earlier this year that is starting to show signs of life?',
      'As the equinox approaches, where do you need more balance between doing and being?',
    ],
    weeklyPromptsTr: [
      'Son zamanlarda icinizdeki sessizce buyuyen yeni bir ilgi veya merak nedir?',
      'Hayatinizin neresinde bir seyin degismeye hazir oldugunu hissediyorsunuz?',
      'Bu yilin baslarinda ektiginiz hangi "tohum" yasam belirtileri gostermeye basliyor?',
      'Ekinoks yaklasirken, yapma ve olma arasinda nerede daha fazla dengeye ihtiyaciniz var?',
    ],
    wellnessTipEn:
        'Spring equinox is a natural point of balance. Consider checking in on the equilibrium between rest and activity in your own life.',
    wellnessTipTr:
        'Bahar ekinoksu dogal bir denge noktasidir. Kendi hayatinizdaki dinlenme ve aktivite arasindaki dengeyi kontrol etmeyi dusunun.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // APRIL — Inner Clarity
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 4,
    themeNameEn: 'Inner Clarity',
    themeNameTr: 'Ic Berraklik',
    descriptionEn:
        'April brings longer days and a natural invitation to see things more clearly. This month, turn your attention to the mental and emotional fog that may have accumulated, and gently clear it.',
    descriptionTr:
        'Nisan daha uzun gunler ve seyleri daha net gormeye dogal bir davet getirir. Bu ay, dikkatinizi biriken zihinsel ve duygusal sise cevirin ve nazikce temizleyin.',
    weeklyPromptsEn: [
      'What decision have you been avoiding that, once made, might bring you relief?',
      'Is there a story you tell yourself that no longer serves you? What would replace it?',
      'What becomes clearer when you remove the noise of others\' opinions from your thinking?',
      'If you trusted your gut completely for one day, what would you do differently?',
    ],
    weeklyPromptsTr: [
      'Bir kere verildiginde size rahatlama getirebilecek hangi karardan kaciniyorsunuz?',
      'Artik size hizmet etmeyen, kendinize anlattiniz bir hikaye var mi? Onun yerine ne koyardiniz?',
      'Baskalarin fikirlerinin gurultusunu dusuncenizden cikardiginizda ne daha net oluyor?',
      'Bir gun boyunca icguduelerinize tamamen guenseydiniz, ne farkli yapardiniz?',
    ],
    wellnessTipEn:
        'Mental clutter tends to affect sleep and mood. Consider a short "brain dump" — writing all thoughts on paper — as a way to create inner space.',
    wellnessTipTr:
        'Zihinsel karisiklik uyku ve ruh halini etkileme egilimindedir. Ic alan yaratmanin bir yolu olarak kisa bir "beyin bosaltma" — tum dusunceleri kagida yazma — dusunun.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // MAY — Creative Renewal
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 5,
    themeNameEn: 'Creative Renewal',
    themeNameTr: 'Yaratici Yenilenme',
    descriptionEn:
        'May is a month of blossoming. What creative energy have you been holding back? This is a time to play, experiment, and express without perfectionism.',
    descriptionTr:
        'Mayis cicek acma ayidir. Hangi yaratici enerjiyi geri tutuyordunuz? Bu, mukemmeliyetcilik olmadan oynamak, denemek ve ifade etmek icin bir zamandir.',
    weeklyPromptsEn: [
      'What form of creative expression calls to you right now, even if you have never tried it?',
      'When was the last time you made something with your hands? What did it feel like?',
      'What would you create if perfectionism were not a factor?',
      'How can you bring more play into your daily routine this week?',
    ],
    weeklyPromptsTr: [
      'Hic denemediyseniz bile, su anda hangi yaratici ifade biciminiz sizi cagirir?',
      'En son ne zaman ellerinizle bir sey yaptiniz? Nasil hissettirdi?',
      'Mukemmeliyetcilik bir faktor olmasaydi ne yaratirdiniz?',
      'Bu hafta gunluk rutininize daha fazla oyunu nasil sokabilirsiniz?',
    ],
    wellnessTipEn:
        'Creative expression — even five minutes of doodling or humming — tends to reduce stress hormones. Consider making space for unstructured play.',
    wellnessTipTr:
        'Yaratici ifade — bes dakikalik karalama veya mirildanma bile — stres hormonlarini azaltma egilimindedir. Yapisiz oyun icin alan yapmayi dusunun.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // JUNE — Energy & Light
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 6,
    themeNameEn: 'Energy & Light',
    themeNameTr: 'Enerji & Isik',
    descriptionEn:
        'June brings the longest days. This is a time of peak energy and visibility. How are you using this abundant light — both externally and within yourself?',
    descriptionTr:
        'Haziran en uzun gunleri getirir. Bu, doruk enerji ve gorunurlugun zamanidir. Bu bol isigi nasil kullaniyorsunuz — hem disarida hem de icinizdeki?',
    weeklyPromptsEn: [
      'What are you pouring your energy into right now? Does it align with what matters most to you?',
      'The solstice marks peak light. What is becoming most visible or clear in your life?',
      'Where in your life do you need to turn up the brightness — give more attention, more care?',
      'What would it feel like to end this month having honored your energy instead of depleted it?',
    ],
    weeklyPromptsTr: [
      'Su anda enerjinizi neye harciyorsunuz? En cok onemli olan seyle uyumlu mu?',
      'Gundonumu doruk isigi isaret eder. Hayatinizda en cok ne gorunur veya net hale geliyor?',
      'Hayatinizin neresinde parlakligi artirmaniz gerekiyor — daha fazla dikkat, daha fazla ozen?',
      'Bu ayi enerjinizi tukemmek yerine onurlandirarak bitirmek nasil hissettirir?',
    ],
    wellnessTipEn:
        'Longer days tend to shift sleep patterns. Consider maintaining a consistent bedtime even as sunlight extends, to support your natural rest cycle.',
    wellnessTipTr:
        'Daha uzun gunler uyku kaliplarini degistirme egilimindedir. Dogal dinlenme dongunuzu desteklemek icin gunes uzadikca bile tutarli bir yatma saati surdurmeyun dusunun.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // JULY — Connection & Joy
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 7,
    themeNameEn: 'Connection & Joy',
    themeNameTr: 'Baglanti & Nese',
    descriptionEn:
        'July is the heart of summer — a natural time for warmth, connection, and joy. This month, notice what brings you genuine happiness and what relationships feed your spirit.',
    descriptionTr:
        'Temmuz yazin kalbidir — sicaklik, baglanti ve nese icin dogal bir zaman. Bu ay, size gercek mutluluk getiren seyi ve ruhunuzu besleyen iliskileri fark edin.',
    weeklyPromptsEn: [
      'What brought you the most genuine joy this week? Was it planned or spontaneous?',
      'Which relationships feel most alive and reciprocal in your life right now?',
      'What simple pleasure have you been overlooking or taking for granted?',
      'How do you define "enough" when it comes to social connection? Are you getting what you need?',
    ],
    weeklyPromptsTr: [
      'Bu hafta size en gercek neseyi ne getirdi? Planli miydi yoksa kendiligindenmi?',
      'Hayatinizda su anda hangi iliskiler en canli ve karsilikli hissediliyor?',
      'Hangi basit zevki gozden kaciriyorsunuz veya hafife aliyorsunuz?',
      'Sosyal baglanti soz konusu oldugunda "yeterli"yi nasil tanimliyorsunuz? Ihtiyaciniz olani aliyor musunuz?',
    ],
    wellnessTipEn:
        'Spending time in nature, even briefly, tends to boost mood and reduce mental fatigue. Consider adding a few minutes outdoors to your daily rhythm.',
    wellnessTipTr:
        'Dogada vakit gecirmek, kisa da olsa, ruh halini yukseltme ve zihinsel yorgunlugu azaltma egilimindedir. Gunluk ritminize birkaç dakika dis mekan eklemeyi dusunun.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // AUGUST — Depth & Presence
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 8,
    themeNameEn: 'Depth & Presence',
    themeNameTr: 'Derinlik & Varlik',
    descriptionEn:
        'As summer begins to peak, August offers an invitation to go deeper rather than wider. Slow down, be present, and explore what lies beneath the surface of your daily life.',
    descriptionTr:
        'Yaz doruk noktasina ulasirken, Agustos daha genis degil daha derine gitmeniz icin bir davet sunar. Yavasin, var olun ve gunluk hayatinizin yuzeyinin altinda ne oldugunu kesfedin.',
    weeklyPromptsEn: [
      'What topic or feeling have you been skimming over that deserves deeper attention?',
      'When do you feel most fully present — not thinking about the past or future?',
      'What would your life look like if you did fewer things but with more intention?',
      'Reflect on a moment this month when time seemed to slow down. What was different?',
    ],
    weeklyPromptsTr: [
      'Daha derin dikkat hak eden hangi konuyu veya duyguyu gozden geciriyorsunuz?',
      'Gecmisi veya gelecegi dusunmeden en tamamen var oldugunuzu ne zaman hissediyorsunuz?',
      'Daha az sey yapsaniz ama daha fazla niyetle yapsaniz hayatiniz nasil gorulurdu?',
      'Bu ay zamanin yavaslamis gibi gokundugu bir ani dusunun. Farkli olan neydi?',
    ],
    wellnessTipEn:
        'Presence tends to reduce anxiety. Consider setting aside five minutes daily to do nothing — no phone, no task, just being.',
    wellnessTipTr:
        'Varlik kaygıyı azaltma egilimindedir. Gunluk bes dakika hicbir sey yapmama — telefon yok, gorev yok, sadece var olma — icin ayirmayi dusunun.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // SEPTEMBER — Harvest & Gratitude
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 9,
    themeNameEn: 'Harvest & Gratitude',
    themeNameTr: 'Hasat & Sukran',
    descriptionEn:
        'September marks the shift toward autumn — a time to gather what you have grown and appreciate what you have built. Before rushing into the next chapter, pause to honor this one.',
    descriptionTr:
        'Eylul sonbahara gecisi isaret eder — buyuttugunuzu toplayacak ve insa ettiginizi takdir edecek bir zaman. Bir sonraki bolume kosumadan once, bu boluumu onurlandirmak icin durun.',
    weeklyPromptsEn: [
      'What have you accomplished or experienced this year that you have not fully acknowledged?',
      'Who deserves your gratitude for their role in your growth? Have you told them?',
      'What did you learn about yourself between June and now that surprised you?',
      'As the equinox arrives, what needs to be balanced before the quieter months ahead?',
    ],
    weeklyPromptsTr: [
      'Bu yil tamamen kabul etmediginiz hangi basariyi veya deneyimi yasadiniz?',
      'Buyumeninizdeki rolleri icin kim sukraninizi hak ediyor? Onlara soylediniz mi?',
      'Hazirandan simidye kadar kendiniz hakkinda sizi sasirtan ne ogrendiniz?',
      'Ekinoks gelirken, onumuzdeki sessiz aylardan once neyin dengelenmesi gerekiyor?',
    ],
    wellnessTipEn:
        'Gratitude practice tends to strengthen emotional well-being. Consider writing three specific things you appreciate at the end of each week this month.',
    wellnessTipTr:
        'Sukran pratigi duygusal iyiligi guclendirme egilimindedir. Bu ay her haftanin sonunda takdir ettiginiz uc spesifik seyi yazmayi dusunun.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // OCTOBER — Inner Shadows
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 10,
    themeNameEn: 'Inner Shadows',
    themeNameTr: 'Ic Golgeler',
    descriptionEn:
        'As days shorten and darkness grows, October invites you to explore what you usually avoid — the shadow side of your personality, the feelings you suppress, the truths you resist.',
    descriptionTr:
        'Gunler kisaldikca ve karanlik buyudukce, Ekim genellikle kacindiginiz seyi kesfetmenize davet eder — kisilinizin golge tarafi, bastirdiginiz duygular, direnmediginiz gercekler.',
    weeklyPromptsEn: [
      'What part of yourself do you tend to hide from others? What would happen if you let it be seen?',
      'What emotion do you most frequently avoid feeling? What might it be trying to tell you?',
      'Reflect on a time you judged someone harshly. What does that judgment reveal about you?',
      'What would self-acceptance look like if it included the parts of you that you dislike?',
    ],
    weeklyPromptsTr: [
      'Kendinizin hangi kismini genellikle baskalrindan gizliyorsunuz? Gorulmezsine izin verseydiniz ne olurdu?',
      'En sik hissetmekten kacindiginiz duygu nedir? Size ne anlatmaya calisiyor olabilir?',
      'Birini sertce yargiladiginiz bir zamani dusunun. Bu yargi sizin hakkindza ne ortaya koyuyor?',
      'Oz-kabul, begenmedigniz kismlarinizi da icerseydi nasil gorulurdu?',
    ],
    wellnessTipEn:
        'Journaling about difficult emotions tends to reduce their grip. Consider writing freely for five minutes about something you have been avoiding.',
    wellnessTipTr:
        'Zor duygular hakkinda gunluk tutma onlarin etkisini azaltma egilimindedir. Kacindiginiz bir sey hakkinda bes dakika serbestce yazmayi dusunun.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // NOVEMBER — Resilience
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 11,
    themeNameEn: 'Resilience',
    themeNameTr: 'Dayaniklilik',
    descriptionEn:
        'November is a bridge between the richness of autumn and the stillness of winter. This month, reflect on your capacity to endure, adapt, and recover. You have made it through more than you realize.',
    descriptionTr:
        'Kasim, sonbaharin zenginligi ile kisin sessizligi arasinda bir koprudur. Bu ay, dayanma, uyum saglama ve toparlanma kapasitenizi dusunun. Farkindan oldugunuzdan daha fazlasinin ustesinden geldiniz.',
    weeklyPromptsEn: [
      'What is the hardest thing you have navigated this year, and what did it teach you about yourself?',
      'Who or what has been your greatest source of strength during challenging times?',
      'What does resilience look like for you — pushing through, or knowing when to rest?',
      'Write a message to someone going through what you went through. What wisdom would you share?',
    ],
    weeklyPromptsTr: [
      'Bu yil ustesinden geldiginiz en zor sey neydi ve kendiniz hakkinda ne ogretti?',
      'Zorlu zamanlarda en buyuk guc kaynaginiz kim veya ne oldu?',
      'Dayaniklilik sizin icin neye benziyor — zorlamak mi, yoksa ne zaman dinleneceginizi bilmek mi?',
      'Sizin yasadiginizi yasayan birine bir mesaj yazin. Hangi bilgeligi paylasirdiniz?',
    ],
    wellnessTipEn:
        'Building resilience tends to include rest, not just endurance. Consider creating intentional downtime this month as an act of strength, not weakness.',
    wellnessTipTr:
        'Dayaniklilik olusturma sadece dayanmayi degil, dinlenmeyi de icerme egilimindedir. Bu ay zayiflik degil guc eylemi olarak bilinçli dinlenme zamani yaratmayi dusunun.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // DECEMBER — Year Reflection
  // ═══════════════════════════════════════════════════════════════
  MonthlyTheme(
    month: 12,
    themeNameEn: 'Year Reflection',
    themeNameTr: 'Yil Degerlendirmesi',
    descriptionEn:
        'December is the closing chapter. Before the new year begins, give yourself the gift of looking back with honesty and compassion. Celebrate how far you have come, and set intentions — not resolutions — for what lies ahead.',
    descriptionTr:
        'Aralik kapaniis bolumudir. Yeni yil baslamadan once, kendinize durustluk ve sefkatle geriye bakma hediyesi verin. Ne kadar ilerlediginizi kutlayin ve onunuzdekiler icin niyetler belirleyin — kararlar degil.',
    weeklyPromptsEn: [
      'What are the three most meaningful moments from this year? Why do they stand out?',
      'What did you let go of this year that you thought you could not live without?',
      'If this year were a chapter in your life story, what would its title be?',
      'What intention do you want to carry into the new year? Make it one sentence.',
    ],
    weeklyPromptsTr: [
      'Bu yilin en anlamli uc ani nelerdir? Neden one cikiyorlar?',
      'Bu yil onsuz yasayamadiginizi dusundugunuz neyi biraktiniz?',
      'Bu yil hayat hikayenizin bir bolumu olsaydi, basligi ne olurdu?',
      'Yeni yila hangi niyeti tasimak istiyorsunuz? Tek cumle yapin.',
    ],
    wellnessTipEn:
        'The year-end rush tends to increase stress. Consider protecting at least one quiet evening per week in December for reflection and rest.',
    wellnessTipTr:
        'Yil sonu kosuturmasi stresi artirma egilimindedir. Aralik ayinda haftada en az bir sessiz aksami dusunme ve dinlenme icin koruma altina almayi dusunun.',
  ),
];
