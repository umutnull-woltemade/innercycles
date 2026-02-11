/// Reflection Prompts — 60 guided journal prompts
/// Organized by 5 focus areas: energy, focus, emotions, decisions, social
/// Apple App Store 4.3(b) compliant. No predictions. Reflective/educational only.
library;

class ReflectionPrompt {
  final String id;
  final String focusArea; // energy, focus, emotions, decisions, social
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
  // ENERGY — 12 prompts (en_001 – en_012)
  // ═══════════════════════════════════════════════════════════════
  ReflectionPrompt(
    id: 'en_001',
    focusArea: 'energy',
    promptEn: 'What time of day do you typically feel most alive and engaged?',
    promptTr: 'Gunun hangi saatlerinde kendinizi en canli ve ilgili hissediyorsunuz?',
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
        'Bu aktiviteleri haftaniza bilinçli olarak ne siklikla dahil ediyorsunuz?',
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

  // ═══════════════════════════════════════════════════════════════
  // FOCUS — 12 prompts (fo_001 – fo_012)
  // ═══════════════════════════════════════════════════════════════
  ReflectionPrompt(
    id: 'fo_001',
    focusArea: 'focus',
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
    id: 'fo_002',
    focusArea: 'focus',
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
    id: 'fo_003',
    focusArea: 'focus',
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
    id: 'fo_004',
    focusArea: 'focus',
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
    id: 'fo_005',
    focusArea: 'focus',
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
    id: 'fo_006',
    focusArea: 'focus',
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
    id: 'fo_007',
    focusArea: 'focus',
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
    id: 'fo_008',
    focusArea: 'focus',
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
    id: 'fo_009',
    focusArea: 'focus',
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
    id: 'fo_010',
    focusArea: 'focus',
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
    id: 'fo_011',
    focusArea: 'focus',
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
    id: 'fo_012',
    focusArea: 'focus',
    promptEn:
        'Reflect on the difference between being busy and being focused. Which one describes your typical day?',
    promptTr:
        'Mesgul olmak ile odakli olmak arasindaki farki dusunun. Hangisi tipik gununuzu tanimliyor?',
    followUpEn:
        'What is one commitment you could release this week to create space for deeper focus?',
    followUpTr:
        'Daha derin odak icin alan yaratmak adina bu hafta birakabileceginiz bir taahhut nedir?',
  ),

  // ═══════════════════════════════════════════════════════════════
  // EMOTIONS — 12 prompts (em_001 – em_012)
  // ═══════════════════════════════════════════════════════════════
  ReflectionPrompt(
    id: 'em_001',
    focusArea: 'emotions',
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
    id: 'em_002',
    focusArea: 'emotions',
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
    id: 'em_003',
    focusArea: 'emotions',
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
    id: 'em_004',
    focusArea: 'emotions',
    promptEn:
        'Is there an emotion you tend to label as "bad" or try to push away? What happens when you sit with it instead?',
    promptTr:
        'Kotu olarak etiketlediginiz veya uzaklastirmaya calistiginiz bir duygu var mi? Onunla birlikte oturdugunuzda ne oluyor?',
    followUpEn:
        'Consider exploring that emotion with curiosity rather than judgment for the next few days.',
    followUpTr:
        'Onumuzdeki birkaç gun bu duyguyu yargi yerine merakla kesfetmeyi deneyin.',
  ),
  ReflectionPrompt(
    id: 'em_005',
    focusArea: 'emotions',
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
    id: 'em_006',
    focusArea: 'emotions',
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
    id: 'em_007',
    focusArea: 'emotions',
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
    id: 'em_008',
    focusArea: 'emotions',
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
    id: 'em_009',
    focusArea: 'emotions',
    promptEn:
        'Notice whether you tend to process emotions through talking, writing, movement, or solitude. Which one serves you best?',
    promptTr:
        'Duygularinizi konusarak, yazarak, hareketle veya yalnizlikla mi islediginizi fark edin. Hangisi size en iyi hizmet ediyor?',
    followUpEn:
        'When was the last time you intentionally chose that method, rather than defaulting to it?',
    followUpTr:
        'Bu yontemi otomatik olarak degil, bilinçli olarak en son ne zaman sectiniz?',
  ),
  ReflectionPrompt(
    id: 'em_010',
    focusArea: 'emotions',
    promptEn:
        'What emotion do you wish you felt more often? What conditions seem to invite it in?',
    promptTr:
        'Hangi duyguyu daha sik hissetmek isterdiniz? Hangi kosullar onu davet ediyor gibi gorunuyor?',
    followUpEn:
        'How could you gently cultivate more of those conditions without forcing the feeling?',
    followUpTr:
        'Hissi zorlamadan bu kosullardan daha fazlasini nazikçe nasil gelistirebilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'em_011',
    focusArea: 'emotions',
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
    id: 'em_012',
    focusArea: 'emotions',
    promptEn:
        'If you could send a message to yourself at your most emotionally overwhelmed, what would you want to hear?',
    promptTr:
        'Duygusal olarak en bunaldiginiz halinize bir mesaj gonderebilseydiniz, ne duymak isterdiniz?',
    followUpEn:
        'Write that message down and keep it somewhere you can find it when you need it.',
    followUpTr:
        'Bu mesaji yazin ve ihtiyaciniz oldugunda bulabileceginiz bir yerde saklayin.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // DECISIONS — 12 prompts (de_001 – de_012)
  // ═══════════════════════════════════════════════════════════════
  ReflectionPrompt(
    id: 'de_001',
    focusArea: 'decisions',
    promptEn:
        'Think of a decision you have been postponing. What are you actually afraid of — the wrong choice, or making any choice at all?',
    promptTr:
        'Ertelediginiz bir karari dusunun. Aslinda neden korkuyorsunuz — yanlis secim mi, yoksa herhangi bir secim yapmak mi?',
    followUpEn:
        'What is the cost of continuing to postpone, and how does that compare to the risk of deciding?',
    followUpTr:
        'Ertelemeye devam etmenin bedeli nedir ve bu, karar verme riskiyle nasil karsilastirilir?',
  ),
  ReflectionPrompt(
    id: 'de_002',
    focusArea: 'decisions',
    promptEn:
        'When you face a tough choice, do you tend to rely more on logic, gut feeling, or the opinions of others?',
    promptTr:
        'Zor bir secimle karsilastiginizda, mantiga mi, ic sesinize mi, yoksa baskalarin goruslerine mi daha cok guvenirsiniz?',
    followUpEn:
        'Has there been a time when your less-used approach would have served you better?',
    followUpTr:
        'Daha az kullandiginiz yaklasiminizin size daha iyi hizmet edecegi bir zaman oldu mu?',
  ),
  ReflectionPrompt(
    id: 'de_003',
    focusArea: 'decisions',
    promptEn:
        'Reflect on a past decision that turned out well. What made you confident enough to commit to it?',
    promptTr:
        'Iyi sonuclanan gecmis bir karari dusunun. Ona baglanmaniz icin sizi yeterince ozguvenli kilan neydi?',
    followUpEn:
        'How can you access that same quality of confidence in decisions you are facing now?',
    followUpTr:
        'Su an karsilastiginiz kararlarda ayni ozguven kalitesine nasil erisebilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'de_004',
    focusArea: 'decisions',
    promptEn:
        'What values do you want your decisions to reflect? Are your recent choices aligned with those values?',
    promptTr:
        'Kararlarinizin hangi degerleri yansitmasini istiyorsunuz? Son secimleriniz bu degerlerle uyumlu mu?',
    followUpEn:
        'Name one recent decision that felt misaligned and consider what pulled you off course.',
    followUpTr:
        'Uyumsuz hissettiren yakin bir karari adlandirin ve sizi yoldan cikaran seyin ne oldugunu dusunun.',
  ),
  ReflectionPrompt(
    id: 'de_005',
    focusArea: 'decisions',
    promptEn:
        'How do you typically handle regret? Do you ruminate, learn, or try to forget?',
    promptTr:
        'Pismanlikla genellikle nasil basa cikiyorsunuz? Ruminasyon mu yapiyorsunuz, ders mi cikariyorsunuz, yoksa unutmaya mi calisiyorsunuz?',
    followUpEn:
        'What would a compassionate relationship with regret look like for you?',
    followUpTr:
        'Pismanlikla sefkatli bir iliski sizin icin nasil gorulurdu?',
  ),
  ReflectionPrompt(
    id: 'de_006',
    focusArea: 'decisions',
    promptEn:
        'Consider a decision you made quickly that you would make differently now. What new information changed your perspective?',
    promptTr:
        'Hizla verdiginiz ve simdi farkli vereceyiniz bir karari dusunun. Hangi yeni bilgi bakis acinizi degistirdi?',
    followUpEn:
        'How could you build more space for reflection into your decision-making process?',
    followUpTr:
        'Karar verme surecizine daha fazla dusunme alani nasil ekleyebilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'de_007',
    focusArea: 'decisions',
    promptEn:
        'When you say "yes" to something, what are you implicitly saying "no" to? Reflect on a recent example.',
    promptTr:
        'Bir seye evet dediginizde, dolayisiyla neye hayir demis oluyorsunuz? Yakin bir ornegi dusunun.',
    followUpEn:
        'Does awareness of that trade-off change how you feel about the decision?',
    followUpTr:
        'Bu takasin farkinda olmak, karar hakkindaki hislerinizi degistiriyor mu?',
  ),
  ReflectionPrompt(
    id: 'de_008',
    focusArea: 'decisions',
    promptEn:
        'Who do you turn to for advice on important decisions, and why do you trust their perspective?',
    promptTr:
        'Onemli kararlarda kime danisiyorsunuz ve neden onlarin bakis acisina guveniyorsunuz?',
    followUpEn:
        'Is there a perspective you consistently avoid seeking out? What might you be protecting yourself from?',
    followUpTr:
        'Surekli olarak kactiginiz bir bakis acisi var mi? Kendinizi neden koruyorsunuz olabilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'de_009',
    focusArea: 'decisions',
    promptEn:
        'Imagine a wiser version of yourself five years from now looking back at today. What decision would they encourage you to make?',
    promptTr:
        'Bes yil sonraki halinizin bugune baktigini hayal edin. Hangi karari almanizi tesvik ederlerdi?',
    followUpEn:
        'What is the smallest step you could take today that moves in that direction?',
    followUpTr:
        'Bugun o yone dogru ilerleyen en kucuk adim ne olabilir?',
  ),
  ReflectionPrompt(
    id: 'de_010',
    focusArea: 'decisions',
    promptEn:
        'Do you make better decisions when you are well-rested, or do you tend to decide under pressure? What pattern do you notice?',
    promptTr:
        'Dinlenmis oldugunuzda mi daha iyi kararlar veriyorsunuz, yoksa baski altinda mi karar verme egilimindesniz? Hangi oruntu fark ediyorsunuz?',
    followUpEn:
        'What conditions could you create to make important decisions from a clearer state of mind?',
    followUpTr:
        'Onemli kararlari daha berrak bir zihin durumuyla vermek icin hangi kosullari yaratabilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'de_011',
    focusArea: 'decisions',
    promptEn:
        'Think of a boundary you set recently. What made you decide it was necessary, and how did it feel afterward?',
    promptTr:
        'Yakin zamanda koydugunuz bir siniri dusunun. Gerekli olduguna nasil karar verdiniz ve sonrasinda nasil hissettiniz?',
    followUpEn:
        'Is there another boundary you sense you need to set but have not yet? What holds you back?',
    followUpTr:
        'Koymaniz gerektigini hissettiginiz ama henuz koymadginiz baska bir sinir var mi? Sizi ne engelliyor?',
  ),
  ReflectionPrompt(
    id: 'de_012',
    focusArea: 'decisions',
    promptEn:
        'How much of your decision-making is driven by what you want versus what you think others expect of you?',
    promptTr:
        'Karar verme surecizinin ne kadari istekleriniz tarafindan, ne kadari baskalarin beklentileri tarafindan yonlendiriliyor?',
    followUpEn:
        'Name one area of your life where you would like to reclaim more of your own voice in decisions.',
    followUpTr:
        'Kararlarda kendi sesinizi daha fazla geri kazanmak istediginiz bir yasam alaninizi adlandirin.',
  ),

  // ═══════════════════════════════════════════════════════════════
  // SOCIAL — 12 prompts (so_001 – so_012)
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
        'Destege ihtiyaç duymak hakkinda kendinize hangi hikayeyi anlatiyorsunuz ve bu hikaye gercekten dogru mu?',
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
        'Catismayla nasil basa çiktiginizi dusunun. Yuzlesmek, kacinmak, uyum saglamak veya uzlasmak mi egilimindesniz?',
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
        'Ayni varlik kalitesini onem verdiginiz insanlara ne kadar bilinçli olarak sunuyorsunuz?',
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
];
