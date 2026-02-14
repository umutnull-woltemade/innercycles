/// Reflection Prompts — 108 guided journal prompts
/// Organized by 7 focus areas: mood, energy, social, creativity,
/// productivity, health, spirituality
/// Apple App Store 4.3(b) compliant. No predictions. Reflective/educational only.
library;

class ReflectionPrompt {
  final String id;
  final String focusArea; // mood, energy, social, creativity, productivity, health, spirituality
  final String promptEn;
  final String promptTr;
  final String followUpEn;
  final String followUpTr;

  const ReflectionPrompt({
    required this.id,
    required this.focusArea,
    required this.promptEn,
    required this.promptTr,
    required this.followUpEn,
    required this.followUpTr,
  });
}

const List<ReflectionPrompt> allReflectionPrompts = [
  // ═══════════════════════════════════════════════════════════════
  // MOOD — 18 prompts (mo_001 – mo_018)
  // ═══════════════════════════════════════════════════════════════
  ReflectionPrompt(
    id: 'mo_001',
    focusArea: 'mood',
    promptEn:
        'What emotion have you been carrying most frequently this week, and where do you feel it in your body?',
    promptTr:
        'Bu hafta en sik tasiginiz duygu nedir ve onu bedeninizde nerede hissediyorsunuz?',
    followUpEn:
        'If that emotion could speak, what would it be asking you to pay attention to?',
    followUpTr:
        'Bu duygu konusabilseydi, neye dikkat etmenizi isterdi?',
  ),
  ReflectionPrompt(
    id: 'mo_002',
    focusArea: 'mood',
    promptEn:
        'Think of a moment this week when you felt genuinely content — not excited, just peacefully satisfied. What was happening?',
    promptTr:
        'Bu hafta gercekten huzurlu hissettiginiz bir an dusunun — heyecanli degil, sadece bariscil bir tatmin. Neler oluyordu?',
    followUpEn:
        'How often do you pause to register contentment, versus only noticing strong emotions?',
    followUpTr:
        'Yalnizca guclu duygulari fark etmek yerine, huzuru ne siklikla kayit altina almak icin duraklisiniz?',
  ),
  ReflectionPrompt(
    id: 'mo_003',
    focusArea: 'mood',
    promptEn:
        'Is there an emotion you tend to label as "bad" or try to push away? What happens when you sit with it instead?',
    promptTr:
        'Kotu olarak etiketlediginiz veya uzaklastirmaya calistiginiz bir duygu var mi? Onunla birlikte oturdugunuzda ne oluyor?',
    followUpEn:
        'Consider exploring that emotion with curiosity rather than judgment for the next few days.',
    followUpTr:
        'Onumuzdeki birkac gun bu duyguyu yargi yerine merakla kesfetmeyi deneyin.',
  ),
  ReflectionPrompt(
    id: 'mo_004',
    focusArea: 'mood',
    promptEn:
        'When you feel anxious, what is usually the underlying concern — loss of control, fear of judgment, or something else?',
    promptTr:
        'Endiseli hissettiginizde, altta yatan kaygi genellikle nedir — kontrol kaybi, yargilanma korkusu veya baska bir sey?',
    followUpEn:
        'What is one grounding action you can take the next time that feeling arises?',
    followUpTr:
        'Bu his bir dahaki sefere ortaya ciktiginda yapabileceginiz bir topraklayici eylem nedir?',
  ),
  ReflectionPrompt(
    id: 'mo_005',
    focusArea: 'mood',
    promptEn:
        'Reflect on how you typically respond to disappointment. Do you withdraw, rationalize, blame, or feel it fully?',
    promptTr:
        'Hayal kirikligina genellikle nasil tepki verdiginizi dusunun. Geri mi cekilirsiniz, rasyonalize mi edersiniz, suclama mi yaparsiniz, yoksa tamamen mi hissedersiniz?',
    followUpEn:
        'Is that response something you chose, or something you inherited from how you were raised?',
    followUpTr:
        'Bu tepki sizin sectiginiz bir sey mi, yoksa yetistirilme seklinizden miras mi?',
  ),
  ReflectionPrompt(
    id: 'mo_006',
    focusArea: 'mood',
    promptEn:
        'What is the difference between how you feel and how you present yourself to others today?',
    promptTr:
        'Bugun nasil hissettiginiz ile kendinizi baskalarina nasil sundagunuz arasindaki fark nedir?',
    followUpEn:
        'What would it cost — and what would it give you — to close that gap even slightly?',
    followUpTr:
        'Bu arayi biraz bile kapatmak size ne kaybettirir — ve ne kazandirir?',
  ),
  ReflectionPrompt(
    id: 'mo_007',
    focusArea: 'mood',
    promptEn:
        'Notice whether you tend to process emotions through talking, writing, movement, or solitude. Which one serves you best?',
    promptTr:
        'Duygularinizi konusarak, yazarak, hareketle veya yalnizlikla mi islediginizi fark edin. Hangisi size en iyi hizmet ediyor?',
    followUpEn:
        'When was the last time you intentionally chose that method, rather than defaulting to it?',
    followUpTr:
        'Bu yontemi otomatik olarak degil, bilincli olarak en son ne zaman sectiniz?',
  ),
  ReflectionPrompt(
    id: 'mo_008',
    focusArea: 'mood',
    promptEn:
        'What emotion do you wish you felt more often? What conditions seem to invite it in?',
    promptTr:
        'Hangi duyguyu daha sik hissetmek isterdiniz? Hangi kosullar onu davet ediyor gibi gorunuyor?',
    followUpEn:
        'How could you gently cultivate more of those conditions without forcing the feeling?',
    followUpTr:
        'Hissi zorlamadan bu kosullardan daha fazlasini nazikce nasil gelistirebilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'mo_009',
    focusArea: 'mood',
    promptEn:
        'Have you noticed any emotional patterns that repeat during certain seasons, months, or life transitions?',
    promptTr:
        'Belirli mevsimlerde, aylarda veya yasam gecislerinde tekrarlanan duygusal oruntuler fark ettiniz mi?',
    followUpEn:
        'Understanding these cycles can help you prepare — what support could you put in place ahead of time?',
    followUpTr:
        'Bu donguları anlamak hazirlanmaniza yardimci olabilir — onceden hangi destegi koyabilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'mo_010',
    focusArea: 'mood',
    promptEn:
        'If you could send a message to yourself at your most emotionally overwhelmed, what would you want to hear?',
    promptTr:
        'Duygusal olarak en bunaldiginiz halinize bir mesaj gonderebilseydiniz, ne duymak isterdiniz?',
    followUpEn:
        'Write that message down and keep it somewhere you can find it when you need it.',
    followUpTr:
        'Bu mesaji yazin ve ihtiyaciniz oldugunda bulabileceginiz bir yerde saklayin.',
  ),
  ReflectionPrompt(
    id: 'mo_011',
    focusArea: 'mood',
    promptEn:
        'Who in your life do you feel safest expressing your full range of emotions with? What makes that space safe?',
    promptTr:
        'Hayatinizda tum duygularinizi en guvenle ifade edebildiginiz kisi kim? Bu alani guvenli kilan nedir?',
    followUpEn:
        'How could you create more of that safety for yourself, even when you are alone?',
    followUpTr:
        'Yalnizken bile kendiniz icin bu guvenligi nasil daha fazla yaratabilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'mo_012',
    focusArea: 'mood',
    promptEn:
        'When did you last cry, and what was it about? If it has been a long time, reflect on why that might be.',
    promptTr:
        'En son ne zaman agladiniz ve nedeniyle? Uzun zamandan beri aglamadiysiniz, bunun nedenini dusunun.',
    followUpEn:
        'What do you believe about showing vulnerability, and where did that belief come from?',
    followUpTr:
        'Savunmasizlik gostermek hakkinda ne inaniyorsunuz ve bu inanc nereden geliyor?',
  ),
  ReflectionPrompt(
    id: 'mo_013',
    focusArea: 'mood',
    promptEn:
        'How does your mood shift between morning and evening? What tends to influence the change?',
    promptTr:
        'Ruh haliniz sabah ile aksam arasinda nasil degisiyor? Degisimi genellikle ne etkiliyor?',
    followUpEn:
        'Is there a time of day when you feel most like yourself?',
    followUpTr:
        'Kendinize en cok benzediginizi hissettiginiz bir gun zamani var mi?',
  ),
  ReflectionPrompt(
    id: 'mo_014',
    focusArea: 'mood',
    promptEn:
        'What small thing unexpectedly lifted your spirits recently? Why do you think it had that effect?',
    promptTr:
        'Yakin zamanda beklenmedik bir sekilde ruh halinizi ne yikseltti? Neden bu etkiye sahip oldugunu dusunuyorsunuz?',
    followUpEn:
        'How could you intentionally invite more of those small moments into your week?',
    followUpTr:
        'Bu kucuk anlari haftaniza daha bilinçli olarak nasil davet edebilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'mo_015',
    focusArea: 'mood',
    promptEn:
        'Describe your emotional state right now using a weather metaphor. Is it sunny, cloudy, stormy, or calm?',
    promptTr:
        'Su anki duygusal durumunuzu bir hava durumu metaforuyla tanimlayin. Gunesli mi, bulutlu mu, firtinali mi, yoksa sakin mi?',
    followUpEn:
        'What kind of weather would you like to move toward, and what might help you get there?',
    followUpTr:
        'Hangi hava durumuna dogru ilerlemek isterdiniz ve oraya ulasmaniza ne yardimci olabilir?',
  ),
  ReflectionPrompt(
    id: 'mo_016',
    focusArea: 'mood',
    promptEn:
        'When you feel emotionally stuck, what usually helps you move forward — time, conversation, or action?',
    promptTr:
        'Duygusal olarak takildiginizi hissettiginizde, genellikle ne ileriye gitmenize yardimci olur — zaman, sohbet veya eylem?',
    followUpEn:
        'What would it look like to try a different approach next time?',
    followUpTr:
        'Bir dahaki sefere farkli bir yaklasim denemek nasil gorulurdu?',
  ),
  ReflectionPrompt(
    id: 'mo_017',
    focusArea: 'mood',
    promptEn:
        'What role does gratitude play in your emotional life? When do you feel it most naturally?',
    promptTr:
        'Sukranin duygusal yasaminizda nasil bir rolu var? En dogal olarak ne zaman hissediyorsunuz?',
    followUpEn:
        'Can you name three things you are grateful for right now, even small ones?',
    followUpTr:
        'Su anda minnettar oldugunuz kucuk seyler dahil uc sey sayabilir misiniz?',
  ),
  ReflectionPrompt(
    id: 'mo_018',
    focusArea: 'mood',
    promptEn:
        'How do you typically react when someone asks how you are feeling? Do you give an honest answer or an automatic one?',
    promptTr:
        'Biri size nasil hissettiginizi sordugunuzda genellikle nasil tepki veriyorsunuz? Durustce mi yoksa otomatik mi cevap veriyorsunuz?',
    followUpEn:
        'What would change if you practiced answering that question honestly, at least to yourself?',
    followUpTr:
        'Bu soruya en azindan kendinize karsi durustce cevap vermeyi pratikte uygulasaniz ne degisirdi?',
  ),

  // ═══════════════════════════════════════════════════════════════
  // ENERGY — 18 prompts (en_001 – en_018)
  // ═══════════════════════════════════════════════════════════════
  ReflectionPrompt(
    id: 'en_001',
    focusArea: 'energy',
    promptEn: 'What time of day do you typically feel most alive and engaged?',
    promptTr:
        'Gunun hangi saatlerinde kendinizi en canli ve ilgili hissediyorsunuz?',
    followUpEn:
        'What patterns do you notice about what you tend to do during those peak hours?',
    followUpTr:
        'Bu zirve saatlerinde genellikle ne yaptiginiz konusunda hangi oruntuleri fark ediyorsunuz?',
  ),
  ReflectionPrompt(
    id: 'en_002',
    focusArea: 'energy',
    promptEn:
        'When you wake up feeling drained before the day has even started, what might your body be trying to communicate?',
    promptTr:
        'Gun baslamadan yorgun uyandiginizda, bedeniniz size ne anlatmaya calisiyor olabilir?',
    followUpEn:
        'Consider what you did the evening before — is there a connection between your night routine and morning energy?',
    followUpTr:
        'Bir onceki aksam ne yaptiginizi dusunun — gece rutininiz ile sabah enerjiniz arasinda bir baglanti var mi?',
  ),
  ReflectionPrompt(
    id: 'en_003',
    focusArea: 'energy',
    promptEn:
        'Which activities consistently leave you feeling more energized after doing them than before?',
    promptTr:
        'Hangi aktiviteler sizi yapmadan oncesine kiyasla surekli olarak daha enerjik birakiyor?',
    followUpEn:
        'How often do you intentionally schedule these activities into your week?',
    followUpTr:
        'Bu aktiviteleri haftaniza bilincli olarak ne siklikla dahil ediyorsunuz?',
  ),
  ReflectionPrompt(
    id: 'en_004',
    focusArea: 'energy',
    promptEn:
        'Reflect on a recent moment when you felt completely absorbed in something. What were you doing?',
    promptTr:
        'Yakin zamanda bir seye tamamen daldiginiz bir ani dusunun. Ne yapiyordunuz?',
    followUpEn:
        'What does that experience reveal about the kind of engagement that nourishes you?',
    followUpTr:
        'Bu deneyim, sizi besleyen katilim turu hakkinda ne ortaya koyuyor?',
  ),
  ReflectionPrompt(
    id: 'en_005',
    focusArea: 'energy',
    promptEn:
        'Notice whether your energy shifts when you spend time outdoors versus indoors. What do you observe?',
    promptTr:
        'Dis mekanda vakit gecirdiginizde enerjinizin ic mekana kiyasla degisip degismedigini fark edin. Ne gozlemliyorsunuz?',
    followUpEn:
        'What is one small way you could bring more of that outdoor quality into your daily life?',
    followUpTr:
        'O dis mekan hissini gunluk hayatiniza tasiyabilecek kucuk bir yol ne olabilir?',
  ),
  ReflectionPrompt(
    id: 'en_006',
    focusArea: 'energy',
    promptEn:
        'What does rest actually look like for you — not what you think it should look like, but what genuinely restores you?',
    promptTr:
        'Dinlenme sizin icin gercekte neye benziyor — nasil olmasi gerektigini dusundugu sekilde degil, sizi gercekten yenileyen nedir?',
    followUpEn:
        'How is that different from what you usually default to when you have free time?',
    followUpTr:
        'Bu, bos zamaniniz oldugunda genellikle yaptiginiz seyden nasil farkli?',
  ),
  ReflectionPrompt(
    id: 'en_007',
    focusArea: 'energy',
    promptEn:
        'Think of a person whose presence tends to leave you feeling lighter. What quality do they bring?',
    promptTr:
        'Varligiyla sizi daha hafif hissettiren bir kisiyi dusunun. Hangi niteligi tasiyorlar?',
    followUpEn:
        'Reflect on whether you also bring that quality to others, and what that means to you.',
    followUpTr:
        'Siz de bu niteligi baskalarina tasiyip tasimadiginizi ve bunun sizin icin ne anlama geldigini dusunun.',
  ),
  ReflectionPrompt(
    id: 'en_008',
    focusArea: 'energy',
    promptEn:
        'When your energy drops in the middle of the day, what is usually happening around you or inside you?',
    promptTr:
        'Enerjiniz gunun ortasinda dustugunde, etrafinizdaki veya icinizdeki durum genellikle nasil?',
    followUpEn:
        'Is the drop more physical, mental, or emotional? What might each type be asking of you?',
    followUpTr:
        'Bu dusus daha cok fiziksel mi, zihinsel mi, yoksa duygusal mi? Her biri sizden ne istiyor olabilir?',
  ),
  ReflectionPrompt(
    id: 'en_009',
    focusArea: 'energy',
    promptEn:
        'How do you typically respond when you notice you are pushing past your limits? What signals do you tend to ignore?',
    promptTr:
        'Sinirlarinizi astiginizi fark ettiginizde nasil tepki veriyorsunuz? Hangi sinyalleri gormezden geliyorsunuz?',
    followUpEn:
        'What would change if you treated those signals as information rather than obstacles?',
    followUpTr:
        'Bu sinyalleri engel yerine bilgi olarak gorseniz ne degisirdi?',
  ),
  ReflectionPrompt(
    id: 'en_010',
    focusArea: 'energy',
    promptEn:
        'Consider a week when you felt consistently energized. What was different about your routine, sleep, or mindset?',
    promptTr:
        'Surekli enerjik hissettiginiz bir haftayi dusunun. Rutininiz, uykunuz veya zihniyet durumunuz nasil farkliydi?',
    followUpEn:
        'Which one of those factors do you have the most control over right now?',
    followUpTr:
        'Bu faktorlerden hangisi uzerinde su anda en fazla kontrolunuz var?',
  ),
  ReflectionPrompt(
    id: 'en_011',
    focusArea: 'energy',
    promptEn:
        'What role does music, silence, or ambient sound play in how your energy moves throughout the day?',
    promptTr:
        'Muzik, sessizlik veya ortam sesi, enerjinizin gun boyunca akisinda nasil bir rol oynuyor?',
    followUpEn:
        'Experiment with changing your soundscape tomorrow and notice what shifts.',
    followUpTr:
        'Yarin ses ortaminizi degistirmeyi deneyin ve nelerin degistigini fark edin.',
  ),
  ReflectionPrompt(
    id: 'en_012',
    focusArea: 'energy',
    promptEn:
        'If your energy had a color today, what would it be and why does that color come to mind?',
    promptTr:
        'Bugun enerjinizin bir rengi olsaydi, ne olurdu ve neden bu renk akliniza geliyor?',
    followUpEn:
        'What color would you like it to be, and what one action might help you move toward that?',
    followUpTr:
        'Hangi renk olmasini isterdiniz ve o yone dogru ilerlemenize yardimci olabilecek bir eylem ne olabilir?',
  ),
  ReflectionPrompt(
    id: 'en_013',
    focusArea: 'energy',
    promptEn:
        'What gave you energy today, and what drained it? Notice the ratio between the two.',
    promptTr:
        'Bugun size ne enerji verdi, ne tuketti? Ikisi arasindaki orani fark edin.',
    followUpEn:
        'What is one small adjustment you could make tomorrow to tip the balance toward more energy?',
    followUpTr:
        'Yarin dengeyi daha fazla enerjiye dogru cevirmek icin yapabileceginiz kucuk bir ayarlama nedir?',
  ),
  ReflectionPrompt(
    id: 'en_014',
    focusArea: 'energy',
    promptEn:
        'How does your physical environment affect your energy levels? Think about light, temperature, and space.',
    promptTr:
        'Fiziksel ortaminiz enerji seviyenizi nasil etkiliyor? Isik, sicaklik ve mekan hakkinda dusunun.',
    followUpEn:
        'What is one environmental change you could make to support your natural energy rhythm?',
    followUpTr:
        'Dogal enerji ritminizi desteklemek icin yapabileceginiz bir cevre degisikligi nedir?',
  ),
  ReflectionPrompt(
    id: 'en_015',
    focusArea: 'energy',
    promptEn:
        'When you feel a surge of motivation, what tends to trigger it? Is it a thought, a person, or a situation?',
    promptTr:
        'Bir motivasyon dalgasi hissettiginizde, genellikle ne tetikler? Bir dusunce mi, bir kisi mi, yoksa bir durum mu?',
    followUpEn:
        'How can you create more of those trigger conditions in your daily life?',
    followUpTr:
        'Bu tetikleme kosullarini gunluk hayatinizda nasil daha fazla yaratabilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'en_016',
    focusArea: 'energy',
    promptEn:
        'Do you tend to give your best energy to work, relationships, or personal projects? Which area feels neglected?',
    promptTr:
        'En iyi enerjinizi ise mi, iliskilere mi, yoksa kisisel projelere mi verme egilimindesniz? Hangi alan ihmal edilmis hissediliyor?',
    followUpEn:
        'What would a more balanced energy distribution look like for you this week?',
    followUpTr:
        'Bu hafta sizin icin daha dengeli bir enerji dagilimi nasil gorulurdu?',
  ),
  ReflectionPrompt(
    id: 'en_017',
    focusArea: 'energy',
    promptEn:
        'How does caffeine, sugar, or food in general affect your energy patterns throughout the day?',
    promptTr:
        'Kafein, seker veya genel olarak yemek gun boyunca enerji kaliplarnizi nasil etkiliyor?',
    followUpEn:
        'What have you noticed about the connection between what you eat and how you feel two hours later?',
    followUpTr:
        'Yediginiz sey ile iki saat sonra nasil hissettiginiz arasindaki baglanti hakkinda ne fark ettiniz?',
  ),
  ReflectionPrompt(
    id: 'en_018',
    focusArea: 'energy',
    promptEn:
        'Imagine you have unlimited energy for one day. How would you spend it? What does that tell you about what matters most?',
    promptTr:
        'Bir gun icin sinirsiz enerjiniz oldugunu hayal edin. Nasil harcardniz? Bu en cok neyin onemli oldugu hakkinda ne soyluyor?',
    followUpEn:
        'Is there a way to bring even a small piece of that ideal day into your real week?',
    followUpTr:
        'O ideal gunun kucuk bir parcasini bile gercek haftaniza tasmanin bir yolu var mi?',
  ),

  // ═══════════════════════════════════════════════════════════════
  // SOCIAL — 18 prompts (so_001 – so_018)
  // ═══════════════════════════════════════════════════════════════
  ReflectionPrompt(
    id: 'so_001',
    focusArea: 'social',
    promptEn:
        'After social interactions, do you generally feel energized, drained, or somewhere in between? What factors make the difference?',
    promptTr:
        'Sosyal etkilesimlerden sonra genellikle enerjik mi, yorgun mu, yoksa arada bir yerde mi hissediyorsunuz? Farki yaratan faktorler nelerdir?',
    followUpEn:
        'How could you design your social life to include more of the interactions that recharge you?',
    followUpTr:
        'Sosyal hayatinizi sizi sarj eden etkilesimleri daha fazla icermek icin nasil tasarlayabilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'so_002',
    focusArea: 'social',
    promptEn:
        'Is there a relationship in your life where you consistently show up differently than who you actually are? What drives that?',
    promptTr:
        'Hayatinizda surekli olarak gercek halinizden farkli gorundugunuz bir iliski var mi? Bunu ne yonlendiriyor?',
    followUpEn:
        'What would it feel like to let one small piece of your authentic self into that relationship?',
    followUpTr:
        'Otantik benliginizden kucuk bir parcayi o iliskiye birakmaniz nasil hissettirir?',
  ),
  ReflectionPrompt(
    id: 'so_003',
    focusArea: 'social',
    promptEn:
        'Think of someone who challenged you recently. What did the friction reveal about your own patterns or triggers?',
    promptTr:
        'Yakin zamanda sizi zorlayan birini dusunun. Bu surtunme kendi oruntulerini veya tetikleyicileriniz hakkinda ne ortaya cikardi?',
    followUpEn:
        'Can you find gratitude for what that challenge taught you, even if the experience was uncomfortable?',
    followUpTr:
        'Deneyim rahatsiz edici olsa bile, bu zorluktan ogrendiginiz sey icin minnet bulabilir misiniz?',
  ),
  ReflectionPrompt(
    id: 'so_004',
    focusArea: 'social',
    promptEn:
        'How comfortable are you with asking for help? Reflect on what happens internally when you consider reaching out.',
    promptTr:
        'Yardim istemek konusunda ne kadar rahatsiniz? Birine ulasmayi dusundunuzde icsel olarak ne oldugunu dusunun.',
    followUpEn:
        'What story do you tell yourself about needing support, and is that story actually true?',
    followUpTr:
        'Destege ihtiyac duymak hakkinda kendinize hangi hikayeyi anlatiyorsunuz ve bu hikaye gercekten dogru mu?',
  ),
  ReflectionPrompt(
    id: 'so_005',
    focusArea: 'social',
    promptEn:
        'When was the last time you had a conversation that genuinely changed how you think about something?',
    promptTr:
        'En son ne zaman bir sey hakkindaki dusuncenizi gercekten degistiren bir konusma yaptiniz?',
    followUpEn:
        'What made that conversation different from your usual interactions?',
    followUpTr:
        'O konusmayi olagan etkilesimlerinizden farkli kilan neydi?',
  ),
  ReflectionPrompt(
    id: 'so_006',
    focusArea: 'social',
    promptEn:
        'Reflect on how you handle conflict. Do you tend to confront, avoid, accommodate, or compromise?',
    promptTr:
        'Catismayla nasil basa ciktiginizi dusunun. Yuzlesmek, kacinmak, uyum saglamak veya uzlasmak mi egilimindesniz?',
    followUpEn:
        'In what situations does your default style serve you well, and when does it create problems?',
    followUpTr:
        'Varsayilan tarziniz hangi durumlarda size iyi hizmet ediyor ve ne zaman sorun yaratiyor?',
  ),
  ReflectionPrompt(
    id: 'so_007',
    focusArea: 'social',
    promptEn:
        'Who in your life consistently makes you feel seen and heard? What do they do that creates that experience?',
    promptTr:
        'Hayatinizda sizi surekli olarak gorulmus ve duyulmus hissettiren kim? Bu deneyimi yaratan ne yapiyorlar?',
    followUpEn:
        'How intentionally do you offer that same quality of presence to the people you care about?',
    followUpTr:
        'Ayni varlik kalitesini onem verdiginiz insanlara ne kadar bilincli olarak sunuyorsunuz?',
  ),
  ReflectionPrompt(
    id: 'so_008',
    focusArea: 'social',
    promptEn:
        'What role do you most often play in groups — the leader, the listener, the mediator, the entertainer, or something else?',
    promptTr:
        'Gruplarda en sik hangi rolu ustleniyorsunuz — lider, dinleyici, arabulucu, eglendirici veya baska bir sey?',
    followUpEn:
        'Is that role one you choose, or one you fall into? How does it feel to consider stepping into a different role?',
    followUpTr:
        'Bu rol sizin sectiginiz mi, yoksa icine dustugunuz mu? Farkli bir role adim atmayi dusunmek nasil hissettiriyor?',
  ),
  ReflectionPrompt(
    id: 'so_009',
    focusArea: 'social',
    promptEn:
        'How do you feel about spending extended time alone? Does solitude refresh you or make you uneasy?',
    promptTr:
        'Uzun sure yalniz vakit gecirmek konusunda nasil hissediyorsunuz? Yalnizlik sizi tazeler mi yoksa tedirgin mi eder?',
    followUpEn:
        'What is the quality of your relationship with yourself when no one else is around?',
    followUpTr:
        'Etrafta kimse yokken kendinizle iliskinizin kalitesi nasil?',
  ),
  ReflectionPrompt(
    id: 'so_010',
    focusArea: 'social',
    promptEn:
        'Think about a friendship that faded over time. What do you understand about that ending now that you could not see then?',
    promptTr:
        'Zamanla solan bir arkadasligi dusunun. O zaman goremediginiz, simdi anlaydiginiz nedir?',
    followUpEn:
        'What did that friendship teach you about what you need from your closest relationships?',
    followUpTr:
        'Bu arkadaslik, en yakin iliskilerinizden ne istediginiz hakkinda size ne ogretti?',
  ),
  ReflectionPrompt(
    id: 'so_011',
    focusArea: 'social',
    promptEn:
        'How do you typically express appreciation to the people in your life? Is it through words, actions, gifts, time, or something else?',
    promptTr:
        'Hayatinizdaki insanlara minnettarliginizi genellikle nasil ifade ediyorsunuz? Sozcuklerle, eylemlerle, hediyelerle, zamanla veya baska bir seyle mi?',
    followUpEn:
        'Does your way of showing appreciation match what the other person most values receiving?',
    followUpTr:
        'Minnettarlik gosterme sekliniz, karsi tarafin en cok almaktan deger verdigi seyle uyusuyor mu?',
  ),
  ReflectionPrompt(
    id: 'so_012',
    focusArea: 'social',
    promptEn:
        'If you could improve one thing about how you communicate with others, what would it be?',
    promptTr:
        'Baskalariyla iletisiminizde bir seyi iyilestirebilseydiniz, ne olurdu?',
    followUpEn:
        'What is one small experiment you could try in your next conversation to practice that improvement?',
    followUpTr:
        'Bir sonraki konusmanizda bu iyilestirmeyi pratikte denemek icin yapabileceginiz kucuk bir deney nedir?',
  ),
  ReflectionPrompt(
    id: 'so_013',
    focusArea: 'social',
    promptEn:
        'How did your social interactions affect your mood today? Did they lift you up or weigh you down?',
    promptTr:
        'Bugun sosyal etkilesimleriniz ruh halinizi nasil etkiledi? Sizi yikseltti mi yoksa agirlik mi verdi?',
    followUpEn:
        'What is one boundary you could set to protect your emotional energy in social settings?',
    followUpTr:
        'Sosyal ortamlarda duygusal enerjinizi korumak icin koyabileceginiz bir sinir nedir?',
  ),
  ReflectionPrompt(
    id: 'so_014',
    focusArea: 'social',
    promptEn:
        'When was the last time you reached out to someone just to check in, with no agenda? How did it feel?',
    promptTr:
        'En son ne zaman sadece hal hatir sormak icin, bir gundemi olmadan birine ulastiniz? Nasil hissettirdi?',
    followUpEn:
        'Who comes to mind right now as someone who might appreciate hearing from you?',
    followUpTr:
        'Sizden haber almaktan mutlu olacak biri olarak su anda aklniza kim geliyor?',
  ),
  ReflectionPrompt(
    id: 'so_015',
    focusArea: 'social',
    promptEn:
        'Do you find it easier to give support or receive it? What does that tendency reveal about your relationship patterns?',
    promptTr:
        'Destek vermeyi mi yoksa almayi mi daha kolay buluyorsunuz? Bu egilim iliski kaliplariniz hakkinda ne ortaya koyuyor?',
    followUpEn:
        'What would it look like to practice the side that feels less natural to you?',
    followUpTr:
        'Size daha az dogal gelen tarafi pratik yapmak nasil gorulurdu?',
  ),
  ReflectionPrompt(
    id: 'so_016',
    focusArea: 'social',
    promptEn:
        'Think about the people you spend the most time with. Do they reflect the person you want to become?',
    promptTr:
        'En cok vakit gecirdiginiz insanlari dusunun. Olmak istediginiz kisiyi yansitiyorlar mi?',
    followUpEn:
        'What qualities would you like to see more of in your inner circle?',
    followUpTr:
        'Yakin cevrenizde hangi nitelikleri daha fazla gormek isterdiniz?',
  ),
  ReflectionPrompt(
    id: 'so_017',
    focusArea: 'social',
    promptEn:
        'How do you respond when someone shares a vulnerable moment with you? Do you fix, listen, or deflect?',
    promptTr:
        'Biri sizinle savunmasiz bir ani paylastiginda nasil karsilik veriyorsunuz? Duzeltir, dinler veya saptarsiniz?',
    followUpEn:
        'What do you wish people would do when you share something vulnerable?',
    followUpTr:
        'Siz savunmasiz bir seyler paylastiginizda insanlarin ne yapmasini isterdiniz?',
  ),
  ReflectionPrompt(
    id: 'so_018',
    focusArea: 'social',
    promptEn:
        'Is there an unspoken tension in any of your current relationships? What might happen if you addressed it gently?',
    promptTr:
        'Mevcut iliskilerinizden herhangi birinde soylenmedik bir gerilim var mi? Onu nazikce ele alsaydiniz ne olabilirdi?',
    followUpEn:
        'What is the kindest way you could start that conversation?',
    followUpTr:
        'Bu konusmayi baslatabileceginiz en nazik yol nedir?',
  ),

  // ═══════════════════════════════════════════════════════════════
  // CREATIVITY — 18 prompts (cr_001 – cr_018)
  // ═══════════════════════════════════════════════════════════════
  ReflectionPrompt(
    id: 'cr_001',
    focusArea: 'creativity',
    promptEn:
        'When was the last time you created something purely for the joy of it, with no audience or outcome in mind?',
    promptTr:
        'En son ne zaman seyirci veya sonuc dusunmeden, sadece keyfi icin bir sey yarattiginiz?',
    followUpEn:
        'What would it take to give yourself that kind of creative freedom more often?',
    followUpTr:
        'Kendinize bu tur yaratici ozgurlugu daha sik vermeniz icin ne gerekir?',
  ),
  ReflectionPrompt(
    id: 'cr_002',
    focusArea: 'creativity',
    promptEn:
        'What creative activity did you love as a child that you have since abandoned? What drew you to it then?',
    promptTr:
        'Cocukken sevdiginiz ve sonradan bıraktiginiz bir yaratici aktivite neydi? O zaman sizi oraya ne cekti?',
    followUpEn:
        'Is there a way to revisit that activity in a form that fits your life now?',
    followUpTr:
        'Bu aktiviteyi su anki hayatiniza uyan bir bicimiyle yeniden ziyaret etmenin bir yolu var mi?',
  ),
  ReflectionPrompt(
    id: 'cr_003',
    focusArea: 'creativity',
    promptEn:
        'What does your inner critic say when you try to create something new? Where did that voice come from?',
    promptTr:
        'Yeni bir sey yaratmayi denediginizde ic elestrmeniniz ne soyluyor? Bu ses nereden geliyor?',
    followUpEn:
        'How would you respond to a friend who shared those same self-doubts?',
    followUpTr:
        'Ayni oz-supheleri paylasan bir arkadasiniza nasil karsilik verirdiniz?',
  ),
  ReflectionPrompt(
    id: 'cr_004',
    focusArea: 'creativity',
    promptEn:
        'Describe a place — real or imagined — where you feel most creatively inspired. What qualities does it have?',
    promptTr:
        'Yaratici olarak en cok ilham aldiginiz bir yeri — gercek veya hayali — tanimlayin. Hangi niteliklere sahip?',
    followUpEn:
        'How could you bring elements of that place into your everyday environment?',
    followUpTr:
        'O yerin unsurlarini gundelik ortaminiza nasil tasiyabilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'cr_005',
    focusArea: 'creativity',
    promptEn:
        'What is an idea you have been sitting on but have not yet acted on? What is holding you back?',
    promptTr:
        'Uzerinde oturdugunuz ama henuz harekete gecmediginiz bir fikir nedir? Sizi ne engelliyor?',
    followUpEn:
        'What is the smallest possible first step you could take toward that idea today?',
    followUpTr:
        'Bu fikre dogru bugun atabileceginiz en kucuk ilk adim nedir?',
  ),
  ReflectionPrompt(
    id: 'cr_006',
    focusArea: 'creativity',
    promptEn:
        'How do you respond when a creative project does not turn out as you imagined? Does imperfection discourage or redirect you?',
    promptTr:
        'Yaratici bir proje hayal ettiginiz gibi cikmayinca nasil tepki veriyorsunuz? Kusur sizi cesaret mi kirdiriyor yoksa yonlendiriyor mu?',
    followUpEn:
        'Think of a time when a "mistake" led to something unexpected and good.',
    followUpTr:
        'Bir "hatanin" beklenmedik ve iyi bir seye yol actigi bir zamani dusunun.',
  ),
  ReflectionPrompt(
    id: 'cr_007',
    focusArea: 'creativity',
    promptEn:
        'What inspires you most right now — music, nature, conversations, art, movement, or something else entirely?',
    promptTr:
        'Su anda sizi en cok ne ilham veriyor — muzik, doga, sohbetler, sanat, hareket veya tamamen baska bir sey?',
    followUpEn:
        'When did you last intentionally expose yourself to that source of inspiration?',
    followUpTr:
        'Bu ilham kaynagina kendinizi en son ne zaman bilincli olarak maruz biraktiniz?',
  ),
  ReflectionPrompt(
    id: 'cr_008',
    focusArea: 'creativity',
    promptEn:
        'If you had an entire afternoon free with no obligations, what would you create, build, or explore?',
    promptTr:
        'Hic yukumlulugu olmayan bos bir ogle sonraniz olsa, ne yaratir, insa eder veya kesfederdiniz?',
    followUpEn:
        'What does your answer reveal about unfulfilled creative needs?',
    followUpTr:
        'Cevabniz karsilanmamis yaratici ihtiyaclar hakkinda ne ortaya koyuyor?',
  ),
  ReflectionPrompt(
    id: 'cr_009',
    focusArea: 'creativity',
    promptEn:
        'Do you consider yourself a creative person? Regardless of your answer, what does creativity mean to you?',
    promptTr:
        'Kendinizi yaratici biri olarak goruyor musunuz? Cevabniz ne olursa olsun, yaraticilik sizin icin ne anlama geliyor?',
    followUpEn:
        'How might your life change if you expanded your definition of creativity?',
    followUpTr:
        'Yaraticilik taniminizi genisletseydiniz hayatiniz nasil degisebilirdi?',
  ),
  ReflectionPrompt(
    id: 'cr_010',
    focusArea: 'creativity',
    promptEn:
        'What is the relationship between your creativity and your mood? Do you create more when you feel good, or does creating improve how you feel?',
    promptTr:
        'Yaraticiliniz ile ruh haliniz arasindaki iliski nedir? Iyi hissettiginizde mi daha cok yaratirsiniz, yoksa yaratmak nasil hissettiginizi mi iyilestirir?',
    followUpEn:
        'Try creating something small the next time your mood dips, and notice what happens.',
    followUpTr:
        'Ruh haliniz bir dahaki sefere dustugunde kucuk bir sey yaratmayi deneyin ve ne oldugunu fark edin.',
  ),
  ReflectionPrompt(
    id: 'cr_011',
    focusArea: 'creativity',
    promptEn:
        'What creative skill have you always wanted to learn but never started? What is the real barrier?',
    promptTr:
        'Her zaman ogrenmek istediginiz ama hic baslamadiginiz bir yaratici beceri nedir? Gercek engel nedir?',
    followUpEn:
        'What if the goal was not mastery but simply the experience of learning?',
    followUpTr:
        'Amac ustalasmak degil de sadece ogrenme deneyimi olsaydi ne olurdu?',
  ),
  ReflectionPrompt(
    id: 'cr_012',
    focusArea: 'creativity',
    promptEn:
        'Think of a problem you are currently facing. What would happen if you approached it creatively instead of logically?',
    promptTr:
        'Su anda karsilastiginiz bir sorunu dusunun. Mantiksal yerine yaratici bir sekilde yaklasirsaniz ne olurdu?',
    followUpEn:
        'Draw, sketch, or write freely about the problem for five minutes. What surfaces?',
    followUpTr:
        'Sorun hakkinda bes dakika serbestce cizin, eskiz yapin veya yazin. Ne ortaya cikiyor?',
  ),
  ReflectionPrompt(
    id: 'cr_013',
    focusArea: 'creativity',
    promptEn:
        'How does comparison with others affect your creative expression? Does seeing others\' work inspire or inhibit you?',
    promptTr:
        'Baskalariyla karsilastirma yaratici ifadenizi nasil etkiliyor? Baskalarin calismasini gormek sizi ilham mi veriyor yoksa engelliyor mu?',
    followUpEn:
        'What would your creative life look like if you only compared yourself to your past self?',
    followUpTr:
        'Sadece gecmis benliklerinizle karsilastirsaniz yaratici hayatiniz nasil gorulurdu?',
  ),
  ReflectionPrompt(
    id: 'cr_014',
    focusArea: 'creativity',
    promptEn:
        'What role does boredom play in your creative process? Do you ever allow yourself to be bored?',
    promptTr:
        'Yaratici sureceinizde canin sikintisinin rolu nedir? Kendinizin sikildmasi icin izin veriyor musunuz?',
    followUpEn:
        'Try spending ten minutes without any input tomorrow and notice what ideas emerge.',
    followUpTr:
        'Yarin hicbir girdi olmadan on dakika gecirmeyi deneyin ve hangi fikirlerin ortaya ciktigini fark edin.',
  ),
  ReflectionPrompt(
    id: 'cr_015',
    focusArea: 'creativity',
    promptEn:
        'If you could collaborate with anyone — living or historical — on a creative project, who would it be and what would you make?',
    promptTr:
        'Yaratici bir projede herhangi biriyle — yasayan veya tarihi — is birligi yapabilseydiniz, kim olurdu ve ne yapardiniz?',
    followUpEn:
        'What does your choice reveal about the kind of creative energy you crave?',
    followUpTr:
        'Seciminiz arzuladiginiz yaratici enerji turu hakkinda ne ortaya koyuyor?',
  ),
  ReflectionPrompt(
    id: 'cr_016',
    focusArea: 'creativity',
    promptEn:
        'What everyday activity could you turn into a more creative experience — cooking, walking, writing, arranging your space?',
    promptTr:
        'Hangi gundelik aktiviteyi daha yaratici bir deneyime donusturebilirsiniz — yemek pisirmek, yurumek, yazmak, mekaninizi duzenlemek?',
    followUpEn:
        'Choose one and try it with fresh eyes tomorrow.',
    followUpTr:
        'Birini secin ve yarin taze gozlerle deneyin.',
  ),
  ReflectionPrompt(
    id: 'cr_017',
    focusArea: 'creativity',
    promptEn:
        'What is the most creative solution you have ever come up with for a real-life challenge?',
    promptTr:
        'Gercek bir yasam zorlugu icin geldiginiz en yaratici cozum neydi?',
    followUpEn:
        'What mindset were you in when that solution came to you?',
    followUpTr:
        'Bu cozum aklniza geldiginde hangi zihin durumundaydiniz?',
  ),
  ReflectionPrompt(
    id: 'cr_018',
    focusArea: 'creativity',
    promptEn:
        'What would you create if you knew nobody would ever judge it? Let yourself dream freely.',
    promptTr:
        'Kimsenin yargilamayacagini bilseniz ne yaratirdiniz? Kendinize ozgurce hayal kurma izni verin.',
    followUpEn:
        'Write down what came to mind. That answer holds a clue about your authentic creative voice.',
    followUpTr:
        'Akliniza geleni yazin. Bu cevap otantik yaratici sesiniz hakkinda bir ipucu tasiyor.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // PRODUCTIVITY — 18 prompts (pr_001 – pr_018)
  // ═══════════════════════════════════════════════════════════════
  ReflectionPrompt(
    id: 'pr_001',
    focusArea: 'productivity',
    promptEn:
        'What is the one thing you keep meaning to focus on but consistently avoid? What might be behind that avoidance?',
    promptTr:
        'Surekli odaklanmak isteyip de kactiginiz tek sey nedir? Bu kacinmanin arkasinda ne olabilir?',
    followUpEn:
        'If you removed all judgment, what would a five-minute start on that thing look like?',
    followUpTr:
        'Tum yargilari kaldirirsaniz, o seye bes dakikalik bir baslangic nasil gorulurdu?',
  ),
  ReflectionPrompt(
    id: 'pr_002',
    focusArea: 'productivity',
    promptEn:
        'When you lose focus, where does your attention usually go first? Social media, daydreaming, snacking, or something else?',
    promptTr:
        'Odaginizi kaybettiginizde dikkatiniz genellikle ilk nereye gidiyor? Sosyal medya, hayal kurma, atistrma veya baska bir sey?',
    followUpEn:
        'What unmet need might that default behavior be trying to satisfy?',
    followUpTr:
        'Bu varsayilan davranis hangi karsilanmamis ihtiyaci gidermeye calisiyor olabilir?',
  ),
  ReflectionPrompt(
    id: 'pr_003',
    focusArea: 'productivity',
    promptEn:
        'Describe the physical environment where you do your best thinking. What elements make it work?',
    promptTr:
        'En iyi dusundugunuz fiziksel ortami tanimlayin. Hangi unsurlar onu etkili kiliyor?',
    followUpEn:
        'How closely does your current workspace match that ideal, and what one change could close the gap?',
    followUpTr:
        'Mevcut calisma alaniniz bu ideale ne kadar yakin ve arayi kapatabilecek bir degisiklik ne olabilir?',
  ),
  ReflectionPrompt(
    id: 'pr_004',
    focusArea: 'productivity',
    promptEn:
        'Think about a project you completed that you are genuinely proud of. How did you maintain focus during it?',
    promptTr:
        'Gercekten gurur duydugunuz tamamlanmis bir projeyi dusunun. Odaginizi nasil korudunuz?',
    followUpEn:
        'Which of those focus strategies could you apply to what you are working on now?',
    followUpTr:
        'Bu odak stratejilerinden hangisini su an uzerinde calistiginiz seye uygulayabilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'pr_005',
    focusArea: 'productivity',
    promptEn:
        'How do you feel about having multiple things on your plate at once — energized or scattered?',
    promptTr:
        'Ayni anda birden fazla isle ugrasma konusunda kendinizi nasil hissediyorsunuz — enerjik mi yoksa dagink mi?',
    followUpEn:
        'What is your personal threshold between productive multitasking and overwhelm?',
    followUpTr:
        'Verimli coklu gorev ile bunalma arasindaki kisisel esiginiz nedir?',
  ),
  ReflectionPrompt(
    id: 'pr_006',
    focusArea: 'productivity',
    promptEn:
        'When you sit down to work, how long does it typically take before you feel truly immersed?',
    promptTr:
        'Calismaya oturdugunuzda, kendinizi gercekten dalginlasana kadar genellikle ne kadar zaman geciyor?',
    followUpEn:
        'What rituals or habits seem to shorten that ramp-up time for you?',
    followUpTr:
        'Hangi rituel veya aliskanliklar bu hazirlik suresini kisaltiyor gibi gorunuyor?',
  ),
  ReflectionPrompt(
    id: 'pr_007',
    focusArea: 'productivity',
    promptEn:
        'Notice what happens to your focus when you are working on something that aligns with your values versus something that does not.',
    promptTr:
        'Degerlerinizle otusen bir sey uzerinde calisirken odaginiza ne oldugunu, otusmeyen bir seyle karsilastirin.',
    followUpEn:
        'What does that difference teach you about the relationship between meaning and concentration?',
    followUpTr:
        'Bu fark, anlam ve konsantrasyon arasindaki iliski hakkinda size ne ogretiyor?',
  ),
  ReflectionPrompt(
    id: 'pr_008',
    focusArea: 'productivity',
    promptEn:
        'What is one thing you recently learned that captured your attention completely? What made it so compelling?',
    promptTr:
        'Yakin zamanda dikkatinizi tamamen ceken ogrendiginiz bir sey nedir? Onu bu kadar ilgi cekici yapan neydi?',
    followUpEn:
        'How can you bring more of that quality of curiosity into areas where you struggle to focus?',
    followUpTr:
        'Bu merak kalitesini odaklanmakta zorlandiginiz alanlara nasil daha fazla tasiyabilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'pr_009',
    focusArea: 'productivity',
    promptEn:
        'Do you focus better with a deadline or with open-ended time? What does that tell you about how you structure your days?',
    promptTr:
        'Son tarihle mi yoksa acik uclu zamanla mi daha iyi odaklaniyorsunuz? Bu, gunlerinizi nasil yapilandirdiginiz hakkinda ne soyluyor?',
    followUpEn:
        'Experiment with the opposite approach this week and reflect on what you notice.',
    followUpTr:
        'Bu hafta ters yaklasimi deneyin ve ne fark ettiginizi dusunun.',
  ),
  ReflectionPrompt(
    id: 'pr_010',
    focusArea: 'productivity',
    promptEn:
        'What mental clutter are you carrying today that makes it harder to be present with one task?',
    promptTr:
        'Bugun bir goreve odaklanmanizi zorlastiran hangi zihinsel karisikligi tasiyorsunuz?',
    followUpEn:
        'If you wrote those worries down and set them aside for one hour, what might open up for you?',
    followUpTr:
        'Bu endiseleri yazip bir saatligine bir kenara koysaniz, sizin icin ne acilabilir?',
  ),
  ReflectionPrompt(
    id: 'pr_011',
    focusArea: 'productivity',
    promptEn:
        'How do you decide what deserves your attention on a given day? Is it planned or reactive?',
    promptTr:
        'Belirli bir gunde neyin dikkatinizi hak ettigine nasil karar veriyorsunuz? Planli mi yoksa tepkisel mi?',
    followUpEn:
        'What would shift if you protected your first focused hour each morning for your most important task?',
    followUpTr:
        'Her sabah ilk odakli saatinizi en onemli gorev icin koruma altina alsaniz ne degisirdi?',
  ),
  ReflectionPrompt(
    id: 'pr_012',
    focusArea: 'productivity',
    promptEn:
        'Reflect on the difference between being busy and being focused. Which one describes your typical day?',
    promptTr:
        'Mesgul olmak ile odakli olmak arasindaki farki dusunun. Hangisi tipik gununuzu tanimliyor?',
    followUpEn:
        'What is one commitment you could release this week to create space for deeper focus?',
    followUpTr:
        'Daha derin odak icin alan yaratmak adina bu hafta birakabileceginiz bir taahhut nedir?',
  ),
  ReflectionPrompt(
    id: 'pr_013',
    focusArea: 'productivity',
    promptEn:
        'What tasks do you tend to procrastinate on? Is there a common thread between them?',
    promptTr:
        'Hangi gorevleri erteleme egilimindesniz? Aralarinda ortak bir iplik var mi?',
    followUpEn:
        'What emotion surfaces right before you procrastinate — boredom, fear, overwhelm, or something else?',
    followUpTr:
        'Erteleme yapmadan hemen once hangi duygu yuzeyine cikiyor — can sikintisi, korku, bunalma veya baska bir sey?',
  ),
  ReflectionPrompt(
    id: 'pr_014',
    focusArea: 'productivity',
    promptEn:
        'When you accomplish something meaningful, how do you celebrate it? Or do you immediately move to the next thing?',
    promptTr:
        'Anlamli bir sey basardiginizda bunu nasil kutluyorsunuz? Yoksa hemen bir sonraki seye mi geciyorsunuz?',
    followUpEn:
        'What would change if you paused to acknowledge your completions before starting something new?',
    followUpTr:
        'Yeni bir seye baslamadan once tamamlamaclarnizi takdir etmek icin duraklusaydniz ne degisirdi?',
  ),
  ReflectionPrompt(
    id: 'pr_015',
    focusArea: 'productivity',
    promptEn:
        'How do you define a "productive day"? Is that definition serving your well-being or undermining it?',
    promptTr:
        'Verimli bir gunu nasil tanimliyorsunuz? Bu tanim iyiliginize hizmet ediyor mu yoksa baltalyor mu?',
    followUpEn:
        'What if productivity included rest, play, and connection alongside output?',
    followUpTr:
        'Verimlilik cikti yaninda dinlenme, oyun ve baglanti da icerseydi ne olurdu?',
  ),
  ReflectionPrompt(
    id: 'pr_016',
    focusArea: 'productivity',
    promptEn:
        'What systems or tools help you stay organized? Are they working, or have they become their own burden?',
    promptTr:
        'Organize kalmaniza hangi sistemler veya araclar yardimci oluyor? Calisiyor mu, yoksa kendi yuku mu haline geldi?',
    followUpEn:
        'What would your ideal simple system look like if you could start fresh?',
    followUpTr:
        'Sifirdan baslasaydiniz ideal basit sisteminiz nasil gorulurdu?',
  ),
  ReflectionPrompt(
    id: 'pr_017',
    focusArea: 'productivity',
    promptEn:
        'How do breaks affect your productivity? Do you take them intentionally, or only when forced?',
    promptTr:
        'Molalar verimliliginizi nasil etkiliyor? Bilinçli mi aliyorsunuz, yoksa yalnizca mecbur kaldiginizda mi?',
    followUpEn:
        'Try scheduling two short breaks today and notice what happens to your focus afterward.',
    followUpTr:
        'Bugun iki kisa mola planlamayi deneyin ve sonrasinda odaginiza ne oldugunu fark edin.',
  ),
  ReflectionPrompt(
    id: 'pr_018',
    focusArea: 'productivity',
    promptEn:
        'What decision are you postponing that, once made, would free up significant mental space?',
    promptTr:
        'Bir kere verildiginde onemli zihinsel alan acabilecek hangi karari erteliyorsunuz?',
    followUpEn:
        'What is the cost of continuing to postpone, and how does that compare to the risk of deciding?',
    followUpTr:
        'Ertelemeye devam etmenin bedeli nedir ve bu, karar verme riskiyle nasil karsilastirilir?',
  ),

  // ═══════════════════════════════════════════════════════════════
  // HEALTH — 9 prompts (he_001 – he_009)
  // ═══════════════════════════════════════════════════════════════
  ReflectionPrompt(
    id: 'he_001',
    focusArea: 'health',
    promptEn:
        'How does your body feel right now? Scan from head to toe and notice what you find.',
    promptTr:
        'Bedeniniz su anda nasil hissediyor? Tepeden tirnaga tara ve ne buldugunuzu fark edin.',
    followUpEn:
        'What is one thing your body might be asking for that you have been ignoring?',
    followUpTr:
        'Bedeninizin gormezden geldiginiz ne istiyor olabilir?',
  ),
  ReflectionPrompt(
    id: 'he_002',
    focusArea: 'health',
    promptEn:
        'What is your relationship with sleep like? Do you approach bedtime with ease or resistance?',
    promptTr:
        'Uykuyla iliskiniz nasil? Yatma saatine kolaylikla mi yoksa direnisle mi yaklasiyorsunuz?',
    followUpEn:
        'What would your ideal wind-down routine look like in the last hour before sleep?',
    followUpTr:
        'Uykudan onceki son saat icin ideal rahatlama rutininiz nasil gorulurdu?',
  ),
  ReflectionPrompt(
    id: 'he_003',
    focusArea: 'health',
    promptEn:
        'How do you nourish yourself beyond food — through rest, movement, nature, or connection?',
    promptTr:
        'Kendinizi yiyecek disinda nasil besliyorsunuz — dinlenme, hareket, doga veya baglanti yoluyla?',
    followUpEn:
        'Which of these nourishment sources has been most neglected recently?',
    followUpTr:
        'Bu beslenme kaynaklardan hangisi son zamanlarda en cok ihmal edildi?',
  ),
  ReflectionPrompt(
    id: 'he_004',
    focusArea: 'health',
    promptEn:
        'What signals does your body send you when stress is building? Tight shoulders, headaches, shallow breathing, or something else?',
    promptTr:
        'Stres yukseldiginde bedeniniz size hangi sinyalleri gonderiyor? Gergin omuzlar, bas agrisi, sig nefes alma veya baska bir sey?',
    followUpEn:
        'What is one action you can take as soon as you notice those early signals?',
    followUpTr:
        'Bu erken sinyalleri fark ettiginizde yapabileceginiz bir eylem nedir?',
  ),
  ReflectionPrompt(
    id: 'he_005',
    focusArea: 'health',
    promptEn:
        'How much time did you spend moving your body today? Not exercising necessarily, but simply moving?',
    promptTr:
        'Bugun bedeninizi hareket ettirmek icin ne kadar zaman harcadiniz? Egzersiz degil, sadece hareket.',
    followUpEn:
        'What type of movement feels like a gift rather than a chore to you?',
    followUpTr:
        'Hangi tur hareket sizin icin bir zorunluluk degil bir hediye gibi hissettiriyor?',
  ),
  ReflectionPrompt(
    id: 'he_006',
    focusArea: 'health',
    promptEn:
        'When you feel physically unwell, how do you treat yourself? With patience and care, or frustration and pushing through?',
    promptTr:
        'Fiziksel olarak iyi hissetmediginizde kendinize nasil davraniyorsunuz? Sabir ve ozenle mi, yoksa hayal kirikligi ve zorlamayla mi?',
    followUpEn:
        'What would a compassionate response to your body look like the next time you feel off?',
    followUpTr:
        'Bir dahaki sefere kendinizi iyi hissetmediginizde bedeninize sefkatli bir tepki nasil gorulurdu?',
  ),
  ReflectionPrompt(
    id: 'he_007',
    focusArea: 'health',
    promptEn:
        'What is one healthy habit you have been meaning to start? What keeps getting in the way?',
    promptTr:
        'Baslamak istediginiz bir saglikli aliskanlik nedir? Surrekli ne engel oluyor?',
    followUpEn:
        'What if you committed to that habit for just five minutes a day for one week?',
    followUpTr:
        'Bu aliskanligi bir hafta boyunca gunde sadece bes dakika icin taahhut etseydiniz ne olurdu?',
  ),
  ReflectionPrompt(
    id: 'he_008',
    focusArea: 'health',
    promptEn:
        'How does your hydration, nutrition, and sleep interact with your emotional state? What connections do you notice?',
    promptTr:
        'Hidrasyon, beslenme ve uykunuz duygusal durumunuzla nasil etkilesiyor? Hangi baglantilari fark ediyorsunuz?',
    followUpEn:
        'Choose one basic need to prioritize this week and observe how it affects everything else.',
    followUpTr:
        'Bu hafta oncelik verecek bir temel ihtiyac secin ve her seyi nasil etkiledigini gozlemleyin.',
  ),
  ReflectionPrompt(
    id: 'he_009',
    focusArea: 'health',
    promptEn:
        'What does "wellness" mean to you personally? Is it about the absence of illness, or something more holistic?',
    promptTr:
        'Saglik sizin icin kisisel olarak ne anlama geliyor? Hastalik yoklugu mu, yoksa daha butuncul bir sey mi?',
    followUpEn:
        'How closely does your daily life reflect your personal definition of wellness?',
    followUpTr:
        'Gunluk hayatiniz kisisel saglik taniminizi ne kadar yakindan yansitiyor?',
  ),

  // ═══════════════════════════════════════════════════════════════
  // SPIRITUALITY — 9 prompts (sp_001 – sp_009)
  // ═══════════════════════════════════════════════════════════════
  ReflectionPrompt(
    id: 'sp_001',
    focusArea: 'spirituality',
    promptEn:
        'What gives your life a sense of meaning or purpose? Has that source changed over time?',
    promptTr:
        'Hayatiniza anlam veya amac hissi veren nedir? Bu kaynak zamanla degisti mi?',
    followUpEn:
        'How do you nurture that sense of meaning in your daily routine?',
    followUpTr:
        'Bu anlam hissini gunluk rutininizde nasil besliyorsunuz?',
  ),
  ReflectionPrompt(
    id: 'sp_002',
    focusArea: 'spirituality',
    promptEn:
        'When do you feel most connected to something larger than yourself — in nature, meditation, community, or elsewhere?',
    promptTr:
        'Kendinizden buyuk bir seye en cok ne zaman baglanmis hissediyorsunuz — dogada, meditasyonda, toplulukta veya baska bir yerde?',
    followUpEn:
        'How could you create more opportunities for that feeling of connection?',
    followUpTr:
        'Bu baglanti hissi icin daha fazla firsat nasil yaratabilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'sp_003',
    focusArea: 'spirituality',
    promptEn:
        'What does silence or stillness bring up for you? Comfort, restlessness, insight, or something else?',
    promptTr:
        'Sessizlik veya durgunluk sizde ne uyandiriyor? Rahatlk, huzursuzluk, icgoru veya baska bir sey?',
    followUpEn:
        'Try sitting in silence for three minutes and journal about what surfaces.',
    followUpTr:
        'Uc dakika sessizlikte oturmayi deneyin ve ortaya cikanlari not edin.',
  ),
  ReflectionPrompt(
    id: 'sp_004',
    focusArea: 'spirituality',
    promptEn:
        'What are you grateful for that money cannot buy? Reflect on the intangible gifts in your life.',
    promptTr:
        'Paranin satamayacagi neye minnettar siniz? Hayatinizdaki soyut hediyeleri dusunun.',
    followUpEn:
        'How does acknowledging these gifts affect your perspective on what you lack?',
    followUpTr:
        'Bu hediyeleri kabul etmek eksikliklerinize bakis acinizi nasil etkiliyor?',
  ),
  ReflectionPrompt(
    id: 'sp_005',
    focusArea: 'spirituality',
    promptEn:
        'What beliefs or values guide your decisions, even when nobody is watching?',
    promptTr:
        'Kimse izlemezken bile kararlarinizi hangi inanclar veya degerler yonlendiriyor?',
    followUpEn:
        'When was the last time those values were tested, and how did you respond?',
    followUpTr:
        'Bu degerler en son ne zaman test edildi ve nasil karsilik verdiniz?',
  ),
  ReflectionPrompt(
    id: 'sp_006',
    focusArea: 'spirituality',
    promptEn:
        'How do you make sense of difficult experiences? Do you look for lessons, acceptance, or meaning?',
    promptTr:
        'Zor deneyimleri nasil anlamlandiriyorsunuz? Ders mi, kabul mu, yoksa anlam mi ariyorsunuz?',
    followUpEn:
        'Reflect on a past hardship that, with time, taught you something valuable.',
    followUpTr:
        'Zamanla size degerli bir sey ogreten gecmis bir zorlugu dusunun.',
  ),
  ReflectionPrompt(
    id: 'sp_007',
    focusArea: 'spirituality',
    promptEn:
        'What does your inner wisdom sound like? When you quiet everything else, what voice remains?',
    promptTr:
        'Ic bilgeliginiz neye benziyor? Her seyi susturdugunuzda hangi ses kaliyor?',
    followUpEn:
        'How often do you follow that voice versus overriding it with logic or fear?',
    followUpTr:
        'Bu sesi ne siklikla mantik veya korkuyla bastirmak yerine takip ediyorsunuz?',
  ),
  ReflectionPrompt(
    id: 'sp_008',
    focusArea: 'spirituality',
    promptEn:
        'What rituals or practices help you feel grounded and centered? How consistently do you practice them?',
    promptTr:
        'Hangi rituel veya pratikler kendinizi topraklanmis ve merkezlenmis hissetmenize yardimci oluyor? Ne kadar tutarli uyguluyorsunuz?',
    followUpEn:
        'What is one practice you could return to this week that would help you feel more anchored?',
    followUpTr:
        'Bu hafta sizi daha demirli hissettirebilecek bir pratik nedir?',
  ),
  ReflectionPrompt(
    id: 'sp_009',
    focusArea: 'spirituality',
    promptEn:
        'If you could ask the universe one question and receive an honest answer, what would you ask?',
    promptTr:
        'Evrene bir soru sorup durustce cevap alabilseydiniz, ne sorardniz?',
    followUpEn:
        'What does your question reveal about what you are truly searching for in this season of life?',
    followUpTr:
        'Sorunuz, hayatin bu doneminde gercekten ne aradiginiz hakkinda ne ortaya koyuyor?',
  ),
];
