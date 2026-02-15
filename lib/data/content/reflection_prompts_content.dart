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
        'Bu hafta en sık taşıdığınız duygu nedir ve onu bedeninizde nerede hissediyorsunuz?',
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
        'Bu hafta gerçekten huzurlu hissettiğiniz bir an düşünün — heyecanlı değil, sadece barışçıl bir tatmin. Neler oluyordu?',
    followUpEn:
        'How often do you pause to register contentment, versus only noticing strong emotions?',
    followUpTr:
        'Yalnızca güçlü duyguları fark etmek yerine, huzuru ne sıklıkla kayıt altına almak için duraklarsınız?',
  ),
  ReflectionPrompt(
    id: 'mo_003',
    focusArea: 'mood',
    promptEn:
        'Is there an emotion you tend to label as "bad" or try to push away? What happens when you sit with it instead?',
    promptTr:
        'Kötü olarak etiketlediğiniz veya uzaklaştırmaya çalıştığınız bir duygu var mı? Onunla birlikte oturduğunuzda ne oluyor?',
    followUpEn:
        'Consider exploring that emotion with curiosity rather than judgment for the next few days.',
    followUpTr:
        'Önümüzdeki birkaç gün bu duyguyu yargı yerine merakla keşfetmeyi deneyin.',
  ),
  ReflectionPrompt(
    id: 'mo_004',
    focusArea: 'mood',
    promptEn:
        'When you feel anxious, what is usually the underlying concern — loss of control, fear of judgment, or something else?',
    promptTr:
        'Endişeli hissettiğinizde, altta yatan kaygı genellikle nedir — kontrol kaybı, yargılanma korkusu veya başka bir şey?',
    followUpEn:
        'What is one grounding action you can take the next time that feeling arises?',
    followUpTr:
        'Bu his bir dahaki sefere ortaya çıktığında yapabileceğiniz bir topraklayıcı eylem nedir?',
  ),
  ReflectionPrompt(
    id: 'mo_005',
    focusArea: 'mood',
    promptEn:
        'Reflect on how you typically respond to disappointment. Do you withdraw, rationalize, blame, or feel it fully?',
    promptTr:
        'Hayal kırıklığına genellikle nasıl tepki verdiğinizi düşünün. Geri mi çekilirsiniz, rasyonalize mi edersiniz, suçlama mı yaparsınız, yoksa tamamen mi hissedersiniz?',
    followUpEn:
        'Is that response something you chose, or something you inherited from how you were raised?',
    followUpTr:
        'Bu tepki sizin seçtiğiniz bir şey mi, yoksa yetiştirilme şeklinizden miras mı?',
  ),
  ReflectionPrompt(
    id: 'mo_006',
    focusArea: 'mood',
    promptEn:
        'What is the difference between how you feel and how you present yourself to others today?',
    promptTr:
        'Bugün nasıl hissettiğiniz ile kendinizi başkalarına nasıl sunduğunuz arasındaki fark nedir?',
    followUpEn:
        'What would it cost — and what would it give you — to close that gap even slightly?',
    followUpTr:
        'Bu arayı biraz bile kapatmak size ne kaybettirir — ve ne kazandırır?',
  ),
  ReflectionPrompt(
    id: 'mo_007',
    focusArea: 'mood',
    promptEn:
        'Notice whether you tend to process emotions through talking, writing, movement, or solitude. Which one serves you best?',
    promptTr:
        'Duygularınızı konuşarak, yazarak, hareketle veya yalnızlıkla mı işlediğinizi fark edin. Hangisi size en iyi hizmet ediyor?',
    followUpEn:
        'When was the last time you intentionally chose that method, rather than defaulting to it?',
    followUpTr:
        'Bu yöntemi otomatik olarak değil, bilinçli olarak en son ne zaman seçtiniz?',
  ),
  ReflectionPrompt(
    id: 'mo_008',
    focusArea: 'mood',
    promptEn:
        'What emotion do you wish you felt more often? What conditions seem to invite it in?',
    promptTr:
        'Hangi duyguyu daha sık hissetmek isterdiniz? Hangi koşullar onu davet ediyor gibi görünüyor?',
    followUpEn:
        'How could you gently cultivate more of those conditions without forcing the feeling?',
    followUpTr:
        'Hissi zorlamadan bu koşullardan daha fazlasını nazikçe nasıl geliştirebilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'mo_009',
    focusArea: 'mood',
    promptEn:
        'Have you noticed any emotional patterns that repeat during certain seasons, months, or life transitions?',
    promptTr:
        'Belirli mevsimlerde, aylarda veya yaşam geçişlerinde tekrarlanan duygusal örüntüler fark ettiniz mi?',
    followUpEn:
        'Understanding these cycles can help you prepare — what support could you put in place ahead of time?',
    followUpTr:
        'Bu döngüleri anlamak hazırlanmanıza yardımcı olabilir — önceden hangi desteği koyabilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'mo_010',
    focusArea: 'mood',
    promptEn:
        'If you could send a message to yourself at your most emotionally overwhelmed, what would you want to hear?',
    promptTr:
        'Duygusal olarak en bunaldığınız halinize bir mesaj gönderebilseydiniz, ne duymak isterdiniz?',
    followUpEn:
        'Write that message down and keep it somewhere you can find it when you need it.',
    followUpTr:
        'Bu mesajı yazın ve ihtiyacınız olduğunda bulabileceğiniz bir yerde saklayın.',
  ),
  ReflectionPrompt(
    id: 'mo_011',
    focusArea: 'mood',
    promptEn:
        'Who in your life do you feel safest expressing your full range of emotions with? What makes that space safe?',
    promptTr:
        'Hayatınızda tüm duygularınızı en güvenle ifade edebildiğiniz kişi kim? Bu alanı güvenli kılan nedir?',
    followUpEn:
        'How could you create more of that safety for yourself, even when you are alone?',
    followUpTr:
        'Yalnızken bile kendiniz için bu güvenliği nasıl daha fazla yaratabilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'mo_012',
    focusArea: 'mood',
    promptEn:
        'When did you last cry, and what was it about? If it has been a long time, reflect on why that might be.',
    promptTr:
        'En son ne zaman ağladınız ve nedeniyle? Uzun zamandır ağlamadıysanız, bunun nedenini düşünün.',
    followUpEn:
        'What do you believe about showing vulnerability, and where did that belief come from?',
    followUpTr:
        'Savunmasızlık göstermek hakkında ne inanıyorsunuz ve bu inanç nereden geliyor?',
  ),
  ReflectionPrompt(
    id: 'mo_013',
    focusArea: 'mood',
    promptEn:
        'How does your mood shift between morning and evening? What tends to influence the change?',
    promptTr:
        'Ruh haliniz sabah ile akşam arasında nasıl değişiyor? Değişimi genellikle ne etkiliyor?',
    followUpEn:
        'Is there a time of day when you feel most like yourself?',
    followUpTr:
        'Kendinize en çok benzediğinizi hissettiğiniz bir gün zamanı var mı?',
  ),
  ReflectionPrompt(
    id: 'mo_014',
    focusArea: 'mood',
    promptEn:
        'What small thing unexpectedly lifted your spirits recently? Why do you think it had that effect?',
    promptTr:
        'Yakın zamanda beklenmedik bir şekilde ruh halinizi ne yükseltti? Neden bu etkiye sahip olduğunu düşünüyorsunuz?',
    followUpEn:
        'How could you intentionally invite more of those small moments into your week?',
    followUpTr:
        'Bu küçük anları haftanıza daha bilinçli olarak nasıl davet edebilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'mo_015',
    focusArea: 'mood',
    promptEn:
        'Describe your emotional state right now using a weather metaphor. Is it sunny, cloudy, stormy, or calm?',
    promptTr:
        'Şu anki duygusal durumunuzu bir hava durumu metaforuyla tanımlayın. Güneşli mi, bulutlu mu, fırtınalı mı, yoksa sakin mi?',
    followUpEn:
        'What kind of weather would you like to move toward, and what might help you get there?',
    followUpTr:
        'Hangi hava durumuna doğru ilerlemek isterdiniz ve oraya ulaşmanıza ne yardımcı olabilir?',
  ),
  ReflectionPrompt(
    id: 'mo_016',
    focusArea: 'mood',
    promptEn:
        'When you feel emotionally stuck, what usually helps you move forward — time, conversation, or action?',
    promptTr:
        'Duygusal olarak takıldığınızı hissettiğinizde, genellikle ne ileriye gitmenize yardımcı olur — zaman, sohbet veya eylem?',
    followUpEn:
        'What would it look like to try a different approach next time?',
    followUpTr:
        'Bir dahaki sefere farklı bir yaklaşım denemek nasıl görünürdü?',
  ),
  ReflectionPrompt(
    id: 'mo_017',
    focusArea: 'mood',
    promptEn:
        'What role does gratitude play in your emotional life? When do you feel it most naturally?',
    promptTr:
        'Şükranın duygusal yaşamınızda nasıl bir rolü var? En doğal olarak ne zaman hissediyorsunuz?',
    followUpEn:
        'Can you name three things you are grateful for right now, even small ones?',
    followUpTr:
        'Şu anda minnettar olduğunuz küçük şeyler dahil üç şey sayabilir misiniz?',
  ),
  ReflectionPrompt(
    id: 'mo_018',
    focusArea: 'mood',
    promptEn:
        'How do you typically react when someone asks how you are feeling? Do you give an honest answer or an automatic one?',
    promptTr:
        'Biri size nasıl hissettiğinizi sorduğunda genellikle nasıl tepki veriyorsunuz? Dürüstçe mi yoksa otomatik mi cevap veriyorsunuz?',
    followUpEn:
        'What would change if you practiced answering that question honestly, at least to yourself?',
    followUpTr:
        'Bu soruya en azından kendinize karşı dürüstçe cevap vermeyi pratikte uygulasanız ne değişirdi?',
  ),

  // ═══════════════════════════════════════════════════════════════
  // ENERGY — 18 prompts (en_001 – en_018)
  // ═══════════════════════════════════════════════════════════════
  ReflectionPrompt(
    id: 'en_001',
    focusArea: 'energy',
    promptEn: 'What time of day do you typically feel most alive and engaged?',
    promptTr:
        'Günün hangi saatlerinde kendinizi en canlı ve ilgili hissediyorsunuz?',
    followUpEn:
        'What patterns do you notice about what you tend to do during those peak hours?',
    followUpTr:
        'Bu zirve saatlerinde genellikle ne yaptığınız konusunda hangi örüntüleri fark ediyorsunuz?',
  ),
  ReflectionPrompt(
    id: 'en_002',
    focusArea: 'energy',
    promptEn:
        'When you wake up feeling drained before the day has even started, what might your body be trying to communicate?',
    promptTr:
        'Gün başlamadan yorgun uyandığınızda, bedeniniz size ne anlatmaya çalışıyor olabilir?',
    followUpEn:
        'Consider what you did the evening before — is there a connection between your night routine and morning energy?',
    followUpTr:
        'Bir önceki akşam ne yaptığınızı düşünün — gece rutininiz ile sabah enerjiniz arasında bir bağlantı var mı?',
  ),
  ReflectionPrompt(
    id: 'en_003',
    focusArea: 'energy',
    promptEn:
        'Which activities consistently leave you feeling more energized after doing them than before?',
    promptTr:
        'Hangi aktiviteler sizi yapmadan öncesine kıyasla sürekli olarak daha enerjik bırakıyor?',
    followUpEn:
        'How often do you intentionally schedule these activities into your week?',
    followUpTr:
        'Bu aktiviteleri haftanıza bilinçli olarak ne sıklıkla dahil ediyorsunuz?',
  ),
  ReflectionPrompt(
    id: 'en_004',
    focusArea: 'energy',
    promptEn:
        'Reflect on a recent moment when you felt completely absorbed in something. What were you doing?',
    promptTr:
        'Yakın zamanda bir şeye tamamen daldığınız bir anı düşünün. Ne yapıyordunuz?',
    followUpEn:
        'What does that experience reveal about the kind of engagement that nourishes you?',
    followUpTr:
        'Bu deneyim, sizi besleyen katılım türü hakkında ne ortaya koyuyor?',
  ),
  ReflectionPrompt(
    id: 'en_005',
    focusArea: 'energy',
    promptEn:
        'Notice whether your energy shifts when you spend time outdoors versus indoors. What do you observe?',
    promptTr:
        'Dış mekanda vakit geçirdiğinizde enerjinizin iç mekana kıyasla değişip değişmediğini fark edin. Ne gözlemliyorsunuz?',
    followUpEn:
        'What is one small way you could bring more of that outdoor quality into your daily life?',
    followUpTr:
        'O dış mekan hissini günlük hayatınıza taşıyabilecek küçük bir yol ne olabilir?',
  ),
  ReflectionPrompt(
    id: 'en_006',
    focusArea: 'energy',
    promptEn:
        'What does rest actually look like for you — not what you think it should look like, but what genuinely restores you?',
    promptTr:
        'Dinlenme sizin için gerçekte neye benziyor — nasıl olması gerektiğini düşündüğü şekilde değil, sizi gerçekten yenileyen nedir?',
    followUpEn:
        'How is that different from what you usually default to when you have free time?',
    followUpTr:
        'Bu, boş zamanınız olduğunda genellikle yaptığınız şeyden nasıl farklı?',
  ),
  ReflectionPrompt(
    id: 'en_007',
    focusArea: 'energy',
    promptEn:
        'Think of a person whose presence tends to leave you feeling lighter. What quality do they bring?',
    promptTr:
        'Varlığıyla sizi daha hafif hissettiren bir kişiyi düşünün. Hangi niteliği taşıyorlar?',
    followUpEn:
        'Reflect on whether you also bring that quality to others, and what that means to you.',
    followUpTr:
        'Siz de bu niteliği başkalarına taşıyıp taşımadığınızı ve bunun sizin için ne anlama geldiğini düşünün.',
  ),
  ReflectionPrompt(
    id: 'en_008',
    focusArea: 'energy',
    promptEn:
        'When your energy drops in the middle of the day, what is usually happening around you or inside you?',
    promptTr:
        'Enerjiniz günün ortasında düştüğünde, etrafınızdaki veya içinizdeki durum genellikle nasıl?',
    followUpEn:
        'Is the drop more physical, mental, or emotional? What might each type be asking of you?',
    followUpTr:
        'Bu düşüş daha çok fiziksel mi, zihinsel mi, yoksa duygusal mı? Her biri sizden ne istiyor olabilir?',
  ),
  ReflectionPrompt(
    id: 'en_009',
    focusArea: 'energy',
    promptEn:
        'How do you typically respond when you notice you are pushing past your limits? What signals do you tend to ignore?',
    promptTr:
        'Sınırlarınızı aştığınızı fark ettiğinizde nasıl tepki veriyorsunuz? Hangi sinyalleri görmezden geliyorsunuz?',
    followUpEn:
        'What would change if you treated those signals as information rather than obstacles?',
    followUpTr:
        'Bu sinyalleri engel yerine bilgi olarak görseniz ne değişirdi?',
  ),
  ReflectionPrompt(
    id: 'en_010',
    focusArea: 'energy',
    promptEn:
        'Consider a week when you felt consistently energized. What was different about your routine, sleep, or mindset?',
    promptTr:
        'Sürekli enerjik hissettiğiniz bir haftayı düşünün. Rutininiz, uykunuz veya zihniyet durumunuz nasıl farklıydı?',
    followUpEn:
        'Which one of those factors do you have the most control over right now?',
    followUpTr:
        'Bu faktörlerden hangisi üzerinde şu anda en fazla kontrolünüz var?',
  ),
  ReflectionPrompt(
    id: 'en_011',
    focusArea: 'energy',
    promptEn:
        'What role does music, silence, or ambient sound play in how your energy moves throughout the day?',
    promptTr:
        'Müzik, sessizlik veya ortam sesi, enerjinizin gün boyunca akışında nasıl bir rol oynuyor?',
    followUpEn:
        'Experiment with changing your soundscape tomorrow and notice what shifts.',
    followUpTr:
        'Yarın ses ortamınızı değiştirmeyi deneyin ve nelerin değiştiğini fark edin.',
  ),
  ReflectionPrompt(
    id: 'en_012',
    focusArea: 'energy',
    promptEn:
        'If your energy had a color today, what would it be and why does that color come to mind?',
    promptTr:
        'Bugün enerjinizin bir rengi olsaydı, ne olurdu ve neden bu renk aklınıza geliyor?',
    followUpEn:
        'What color would you like it to be, and what one action might help you move toward that?',
    followUpTr:
        'Hangi renk olmasını isterdiniz ve o yöne doğru ilerlemenize yardımcı olabilecek bir eylem ne olabilir?',
  ),
  ReflectionPrompt(
    id: 'en_013',
    focusArea: 'energy',
    promptEn:
        'What gave you energy today, and what drained it? Notice the ratio between the two.',
    promptTr:
        'Bugün size ne enerji verdi, ne tüketti? İkisi arasındaki oranı fark edin.',
    followUpEn:
        'What is one small adjustment you could make tomorrow to tip the balance toward more energy?',
    followUpTr:
        'Yarın dengeyi daha fazla enerjiye doğru çevirmek için yapabileceğiniz küçük bir ayarlama nedir?',
  ),
  ReflectionPrompt(
    id: 'en_014',
    focusArea: 'energy',
    promptEn:
        'How does your physical environment affect your energy levels? Think about light, temperature, and space.',
    promptTr:
        'Fiziksel ortamınız enerji seviyenizi nasıl etkiliyor? Işık, sıcaklık ve mekan hakkında düşünün.',
    followUpEn:
        'What is one environmental change you could make to support your natural energy rhythm?',
    followUpTr:
        'Doğal enerji ritminizi desteklemek için yapabileceğiniz bir çevre değişikliği nedir?',
  ),
  ReflectionPrompt(
    id: 'en_015',
    focusArea: 'energy',
    promptEn:
        'When you feel a surge of motivation, what tends to trigger it? Is it a thought, a person, or a situation?',
    promptTr:
        'Bir motivasyon dalgası hissettiğinizde, genellikle ne tetikler? Bir düşünce mi, bir kişi mi, yoksa bir durum mu?',
    followUpEn:
        'How can you create more of those trigger conditions in your daily life?',
    followUpTr:
        'Bu tetikleme koşullarını günlük hayatınızda nasıl daha fazla yaratabilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'en_016',
    focusArea: 'energy',
    promptEn:
        'Do you tend to give your best energy to work, relationships, or personal projects? Which area feels neglected?',
    promptTr:
        'En iyi enerjinizi işe mi, ilişkilere mi, yoksa kişisel projelere mi verme eğilimindesiniz? Hangi alan ihmal edilmiş hissediliyor?',
    followUpEn:
        'What would a more balanced energy distribution look like for you this week?',
    followUpTr:
        'Bu hafta sizin için daha dengeli bir enerji dağılımı nasıl görülürdü?',
  ),
  ReflectionPrompt(
    id: 'en_017',
    focusArea: 'energy',
    promptEn:
        'How does caffeine, sugar, or food in general affect your energy patterns throughout the day?',
    promptTr:
        'Kafein, şeker veya genel olarak yemek gün boyunca enerji kalıplarınızı nasıl etkiliyor?',
    followUpEn:
        'What have you noticed about the connection between what you eat and how you feel two hours later?',
    followUpTr:
        'Yediğiniz şey ile iki saat sonra nasıl hissettiğiniz arasındaki bağlantı hakkında ne fark ettiniz?',
  ),
  ReflectionPrompt(
    id: 'en_018',
    focusArea: 'energy',
    promptEn:
        'Imagine you have unlimited energy for one day. How would you spend it? What does that tell you about what matters most?',
    promptTr:
        'Bir gün için sınırsız enerjiniz olduğunu hayal edin. Nasıl harcardınız? Bu en çok neyin önemli olduğu hakkında ne söylüyor?',
    followUpEn:
        'Is there a way to bring even a small piece of that ideal day into your real week?',
    followUpTr:
        'O ideal günün küçük bir parçasını bile gerçek haftanıza taşımanın bir yolu var mı?',
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
        'Sosyal etkileşimlerden sonra genellikle enerjik mi, yorgun mu, yoksa arada bir yerde mi hissediyorsunuz? Farkı yaratan faktörler nelerdir?',
    followUpEn:
        'How could you design your social life to include more of the interactions that recharge you?',
    followUpTr:
        'Sosyal hayatınızı sizi şarj eden etkileşimleri daha fazla içermek için nasıl tasarlayabilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'so_002',
    focusArea: 'social',
    promptEn:
        'Is there a relationship in your life where you consistently show up differently than who you actually are? What drives that?',
    promptTr:
        'Hayatınızda sürekli olarak gerçek halinizden farklı göründüğünüz bir ilişki var mı? Bunu ne yönlendiriyor?',
    followUpEn:
        'What would it feel like to let one small piece of your authentic self into that relationship?',
    followUpTr:
        'Otantik benliğinizden küçük bir parçayı o ilişkiye bırakmanız nasıl hissettirir?',
  ),
  ReflectionPrompt(
    id: 'so_003',
    focusArea: 'social',
    promptEn:
        'Think of someone who challenged you recently. What did the friction reveal about your own patterns or triggers?',
    promptTr:
        'Yakın zamanda sizi zorlayan birini düşünün. Bu sürtünme kendi örüntüleriniz veya tetikleyicileriniz hakkında ne ortaya çıkardı?',
    followUpEn:
        'Can you find gratitude for what that challenge taught you, even if the experience was uncomfortable?',
    followUpTr:
        'Deneyim rahatsız edici olsa bile, bu zorluktan öğrendiğiniz şey için minnet bulabilir misiniz?',
  ),
  ReflectionPrompt(
    id: 'so_004',
    focusArea: 'social',
    promptEn:
        'How comfortable are you with asking for help? Reflect on what happens internally when you consider reaching out.',
    promptTr:
        'Yardım istemek konusunda ne kadar rahatsınız? Birine ulaşmayı düşündüğünüzde içsel olarak ne olduğunu düşünün.',
    followUpEn:
        'What story do you tell yourself about needing support, and is that story actually true?',
    followUpTr:
        'Desteğe ihtiyaç duymak hakkında kendinize hangi hikayeyi anlatıyorsunuz ve bu hikaye gerçekten doğru mu?',
  ),
  ReflectionPrompt(
    id: 'so_005',
    focusArea: 'social',
    promptEn:
        'When was the last time you had a conversation that genuinely changed how you think about something?',
    promptTr:
        'En son ne zaman bir şey hakkındaki düşüncenizi gerçekten değiştiren bir konuşma yaptınız?',
    followUpEn:
        'What made that conversation different from your usual interactions?',
    followUpTr:
        'O konuşmayı olağan etkileşimlerinizden farklı kılan neydi?',
  ),
  ReflectionPrompt(
    id: 'so_006',
    focusArea: 'social',
    promptEn:
        'Reflect on how you handle conflict. Do you tend to confront, avoid, accommodate, or compromise?',
    promptTr:
        'Çatışmayla nasıl başa çıktığınızı düşünün. Yüzleşmek, kaçınmak, uyum sağlamak veya uzlaşmak mı eğilimindesiniz?',
    followUpEn:
        'In what situations does your default style serve you well, and when does it create problems?',
    followUpTr:
        'Varsayılan tarzınız hangi durumlarda size iyi hizmet ediyor ve ne zaman sorun yaratıyor?',
  ),
  ReflectionPrompt(
    id: 'so_007',
    focusArea: 'social',
    promptEn:
        'Who in your life consistently makes you feel seen and heard? What do they do that creates that experience?',
    promptTr:
        'Hayatınızda sizi sürekli olarak görülmüş ve duyulmuş hissettiren kim? Bu deneyimi yaratan ne yapıyorlar?',
    followUpEn:
        'How intentionally do you offer that same quality of presence to the people you care about?',
    followUpTr:
        'Aynı varlık kalitesini önem verdiğiniz insanlara ne kadar bilinçli olarak sunuyorsunuz?',
  ),
  ReflectionPrompt(
    id: 'so_008',
    focusArea: 'social',
    promptEn:
        'What role do you most often play in groups — the leader, the listener, the mediator, the entertainer, or something else?',
    promptTr:
        'Gruplarda en sık hangi rolü üstleniyorsunuz — lider, dinleyici, arabulucu, eğlendirici veya başka bir şey?',
    followUpEn:
        'Is that role one you choose, or one you fall into? How does it feel to consider stepping into a different role?',
    followUpTr:
        'Bu rol sizin seçtiğiniz mi, yoksa içine düştüğünüz mü? Farklı bir role adım atmayı düşünmek nasıl hissettiriyor?',
  ),
  ReflectionPrompt(
    id: 'so_009',
    focusArea: 'social',
    promptEn:
        'How do you feel about spending extended time alone? Does solitude refresh you or make you uneasy?',
    promptTr:
        'Uzun süre yalnız vakit geçirmek konusunda nasıl hissediyorsunuz? Yalnızlık sizi tazeler mi yoksa tedirgin mi eder?',
    followUpEn:
        'What is the quality of your relationship with yourself when no one else is around?',
    followUpTr:
        'Etrafta kimse yokken kendinizle ilişkinizin kalitesi nasıl?',
  ),
  ReflectionPrompt(
    id: 'so_010',
    focusArea: 'social',
    promptEn:
        'Think about a friendship that faded over time. What do you understand about that ending now that you could not see then?',
    promptTr:
        'Zamanla solan bir arkadaşlığı düşünün. O zaman göremediğiniz, şimdi anladığınız nedir?',
    followUpEn:
        'What did that friendship teach you about what you need from your closest relationships?',
    followUpTr:
        'Bu arkadaşlık, en yakın ilişkilerinizden ne istediğiniz hakkında size ne öğretti?',
  ),
  ReflectionPrompt(
    id: 'so_011',
    focusArea: 'social',
    promptEn:
        'How do you typically express appreciation to the people in your life? Is it through words, actions, gifts, time, or something else?',
    promptTr:
        'Hayatınızdaki insanlara minnettarlığınızı genellikle nasıl ifade ediyorsunuz? Sözcüklerle, eylemlerle, hediyelerle, zamanla veya başka bir şeyle mi?',
    followUpEn:
        'Does your way of showing appreciation match what the other person most values receiving?',
    followUpTr:
        'Minnettarlık gösterme şekliniz, karşı tarafın en çok almaktan değer verdiği şeyle uyuşuyor mu?',
  ),
  ReflectionPrompt(
    id: 'so_012',
    focusArea: 'social',
    promptEn:
        'If you could improve one thing about how you communicate with others, what would it be?',
    promptTr:
        'Başkalarıyla iletişiminizde bir şeyi iyileştirebilseydiniz, ne olurdu?',
    followUpEn:
        'What is one small experiment you could try in your next conversation to practice that improvement?',
    followUpTr:
        'Bir sonraki konuşmanızda bu iyileştirmeyi pratikte denemek için yapabileceğiniz küçük bir deney nedir?',
  ),
  ReflectionPrompt(
    id: 'so_013',
    focusArea: 'social',
    promptEn:
        'How did your social interactions affect your mood today? Did they lift you up or weigh you down?',
    promptTr:
        'Bugün sosyal etkileşimleriniz ruh halinizi nasıl etkiledi? Sizi yükseltti mi yoksa ağırlık mı verdi?',
    followUpEn:
        'What is one boundary you could set to protect your emotional energy in social settings?',
    followUpTr:
        'Sosyal ortamlarda duygusal enerjinizi korumak için koyabileceğiniz bir sınır nedir?',
  ),
  ReflectionPrompt(
    id: 'so_014',
    focusArea: 'social',
    promptEn:
        'When was the last time you reached out to someone just to check in, with no agenda? How did it feel?',
    promptTr:
        'En son ne zaman sadece hal hatır sormak için, bir gündemi olmadan birine ulaştınız? Nasıl hissettirdi?',
    followUpEn:
        'Who comes to mind right now as someone who might appreciate hearing from you?',
    followUpTr:
        'Sizden haber almaktan mutlu olacak biri olarak şu anda aklınıza kim geliyor?',
  ),
  ReflectionPrompt(
    id: 'so_015',
    focusArea: 'social',
    promptEn:
        'Do you find it easier to give support or receive it? What does that tendency reveal about your relationship patterns?',
    promptTr:
        'Destek vermeyi mi yoksa almayı mı daha kolay buluyorsunuz? Bu eğilim ilişki kalıplarınız hakkında ne ortaya koyuyor?',
    followUpEn:
        'What would it look like to practice the side that feels less natural to you?',
    followUpTr:
        'Size daha az doğal gelen tarafı pratik yapmak nasıl görülürdü?',
  ),
  ReflectionPrompt(
    id: 'so_016',
    focusArea: 'social',
    promptEn:
        'Think about the people you spend the most time with. Do they reflect the person you want to become?',
    promptTr:
        'En çok vakit geçirdiğiniz insanları düşünün. Olmak istediğiniz kişiyi yansıtıyorlar mı?',
    followUpEn:
        'What qualities would you like to see more of in your inner circle?',
    followUpTr:
        'Yakın çevrenizde hangi nitelikleri daha fazla görmek isterdiniz?',
  ),
  ReflectionPrompt(
    id: 'so_017',
    focusArea: 'social',
    promptEn:
        'How do you respond when someone shares a vulnerable moment with you? Do you fix, listen, or deflect?',
    promptTr:
        'Biri sizinle savunmasız bir anı paylaştığında nasıl karşılık veriyorsunuz? Düzeltir, dinler veya saptırırsınız?',
    followUpEn:
        'What do you wish people would do when you share something vulnerable?',
    followUpTr:
        'Siz savunmasız bir şeyler paylaştığınızda insanların ne yapmasını isterdiniz?',
  ),
  ReflectionPrompt(
    id: 'so_018',
    focusArea: 'social',
    promptEn:
        'Is there an unspoken tension in any of your current relationships? What might happen if you addressed it gently?',
    promptTr:
        'Mevcut ilişkilerinizden herhangi birinde söylenmedik bir gerilim var mı? Onu nazikçe ele alsaydınız ne olabilirdi?',
    followUpEn:
        'What is the kindest way you could start that conversation?',
    followUpTr:
        'Bu konuşmayı başlatabileceğiniz en nazik yol nedir?',
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
        'En son ne zaman seyirci veya sonuç düşünmeden, sadece keyfi için bir şey yarattığınız?',
    followUpEn:
        'What would it take to give yourself that kind of creative freedom more often?',
    followUpTr:
        'Kendinize bu tür yaratıcı özgürlüğü daha sık vermeniz için ne gerekir?',
  ),
  ReflectionPrompt(
    id: 'cr_002',
    focusArea: 'creativity',
    promptEn:
        'What creative activity did you love as a child that you have since abandoned? What drew you to it then?',
    promptTr:
        'Çocukken sevdiğiniz ve sonradan bıraktığınız bir yaratıcı aktivite neydi? O zaman sizi oraya ne çekti?',
    followUpEn:
        'Is there a way to revisit that activity in a form that fits your life now?',
    followUpTr:
        'Bu aktiviteyi şu anki hayatınıza uyan bir biçimiyle yeniden ziyaret etmenin bir yolu var mı?',
  ),
  ReflectionPrompt(
    id: 'cr_003',
    focusArea: 'creativity',
    promptEn:
        'What does your inner critic say when you try to create something new? Where did that voice come from?',
    promptTr:
        'Yeni bir şey yaratmayı denediğinizde iç eleştirmeniniz ne söylüyor? Bu ses nereden geliyor?',
    followUpEn:
        'How would you respond to a friend who shared those same self-doubts?',
    followUpTr:
        'Aynı öz-şüpheleri paylaşan bir arkadaşınıza nasıl karşılık verirdiniz?',
  ),
  ReflectionPrompt(
    id: 'cr_004',
    focusArea: 'creativity',
    promptEn:
        'Describe a place — real or imagined — where you feel most creatively inspired. What qualities does it have?',
    promptTr:
        'Yaratıcı olarak en çok ilham aldığınız bir yeri — gerçek veya hayali — tanımlayın. Hangi niteliklere sahip?',
    followUpEn:
        'How could you bring elements of that place into your everyday environment?',
    followUpTr:
        'O yerin unsurlarını gündelik ortamınıza nasıl taşıyabilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'cr_005',
    focusArea: 'creativity',
    promptEn:
        'What is an idea you have been sitting on but have not yet acted on? What is holding you back?',
    promptTr:
        'Üzerinde oturduğunuz ama henüz harekete geçmediğiniz bir fikir nedir? Sizi ne engelliyor?',
    followUpEn:
        'What is the smallest possible first step you could take toward that idea today?',
    followUpTr:
        'Bu fikre doğru bugün atabileceğiniz en küçük ilk adım nedir?',
  ),
  ReflectionPrompt(
    id: 'cr_006',
    focusArea: 'creativity',
    promptEn:
        'How do you respond when a creative project does not turn out as you imagined? Does imperfection discourage or redirect you?',
    promptTr:
        'Yaratıcı bir proje hayal ettiğiniz gibi çıkmayınca nasıl tepki veriyorsunuz? Kusur sizi cesaret mi kırdırıyor yoksa yönlendiriyor mu?',
    followUpEn:
        'Think of a time when a "mistake" led to something unexpected and good.',
    followUpTr:
        'Bir "hatanın" beklenmedik ve iyi bir şeye yol açtığı bir zamanı düşünün.',
  ),
  ReflectionPrompt(
    id: 'cr_007',
    focusArea: 'creativity',
    promptEn:
        'What inspires you most right now — music, nature, conversations, art, movement, or something else entirely?',
    promptTr:
        'Şu anda sizi en çok ne ilham veriyor — müzik, doğa, sohbetler, sanat, hareket veya tamamen başka bir şey?',
    followUpEn:
        'When did you last intentionally expose yourself to that source of inspiration?',
    followUpTr:
        'Bu ilham kaynağına kendinizi en son ne zaman bilinçli olarak maruz bıraktınız?',
  ),
  ReflectionPrompt(
    id: 'cr_008',
    focusArea: 'creativity',
    promptEn:
        'If you had an entire afternoon free with no obligations, what would you create, build, or explore?',
    promptTr:
        'Hiç yükümlülüğü olmayan boş bir öğle sonranız olsa, ne yaratır, inşa eder veya keşfederdiniz?',
    followUpEn:
        'What does your answer reveal about unfulfilled creative needs?',
    followUpTr:
        'Cevabınız karşılanmamış yaratıcı ihtiyaçlar hakkında ne ortaya koyuyor?',
  ),
  ReflectionPrompt(
    id: 'cr_009',
    focusArea: 'creativity',
    promptEn:
        'Do you consider yourself a creative person? Regardless of your answer, what does creativity mean to you?',
    promptTr:
        'Kendinizi yaratıcı biri olarak görüyor musunuz? Cevabınız ne olursa olsun, yaratıcılık sizin için ne anlama geliyor?',
    followUpEn:
        'How might your life change if you expanded your definition of creativity?',
    followUpTr:
        'Yaratıcılık tanımınızı genişletseydiniz hayatınız nasıl değişebilirdi?',
  ),
  ReflectionPrompt(
    id: 'cr_010',
    focusArea: 'creativity',
    promptEn:
        'What is the relationship between your creativity and your mood? Do you create more when you feel good, or does creating improve how you feel?',
    promptTr:
        'Yaratıcılığınız ile ruh haliniz arasındaki ilişki nedir? İyi hissettiğinizde mi daha çok yaratırsınız, yoksa yaratmak nasıl hissettiğinizi mi iyileştirir?',
    followUpEn:
        'Try creating something small the next time your mood dips, and notice what happens.',
    followUpTr:
        'Ruh haliniz bir dahaki sefere düştüğünde küçük bir şey yaratmayı deneyin ve ne olduğunu fark edin.',
  ),
  ReflectionPrompt(
    id: 'cr_011',
    focusArea: 'creativity',
    promptEn:
        'What creative skill have you always wanted to learn but never started? What is the real barrier?',
    promptTr:
        'Her zaman öğrenmek istediğiniz ama hiç başlamadığınız bir yaratıcı beceri nedir? Gerçek engel nedir?',
    followUpEn:
        'What if the goal was not mastery but simply the experience of learning?',
    followUpTr:
        'Amaç ustalaşmak değil de sadece öğrenme deneyimi olsaydı ne olurdu?',
  ),
  ReflectionPrompt(
    id: 'cr_012',
    focusArea: 'creativity',
    promptEn:
        'Think of a problem you are currently facing. What would happen if you approached it creatively instead of logically?',
    promptTr:
        'Şu anda karşılaştığınız bir sorunu düşünün. Mantıksal yerine yaratıcı bir şekilde yaklaşırsanız ne olurdu?',
    followUpEn:
        'Draw, sketch, or write freely about the problem for five minutes. What surfaces?',
    followUpTr:
        'Sorun hakkında beş dakika serbestçe çizin, eskiz yapın veya yazın. Ne ortaya çıkıyor?',
  ),
  ReflectionPrompt(
    id: 'cr_013',
    focusArea: 'creativity',
    promptEn:
        'How does comparison with others affect your creative expression? Does seeing others\' work inspire or inhibit you?',
    promptTr:
        'Başkalarıyla karşılaştırma yaratıcı ifadenizi nasıl etkiliyor? Başkalarının çalışmasını görmek sizi ilham mı veriyor yoksa engelliyor mu?',
    followUpEn:
        'What would your creative life look like if you only compared yourself to your past self?',
    followUpTr:
        'Sadece geçmiş benliklerinizle karşılaştırsanız yaratıcı hayatınız nasıl görülürdü?',
  ),
  ReflectionPrompt(
    id: 'cr_014',
    focusArea: 'creativity',
    promptEn:
        'What role does boredom play in your creative process? Do you ever allow yourself to be bored?',
    promptTr:
        'Yaratıcı sürecinizde can sıkıntısının rolü nedir? Kendinizin sıkılması için izin veriyor musunuz?',
    followUpEn:
        'Try spending ten minutes without any input tomorrow and notice what ideas emerge.',
    followUpTr:
        'Yarın hiçbir girdi olmadan on dakika geçirmeyi deneyin ve hangi fikirlerin ortaya çıktığını fark edin.',
  ),
  ReflectionPrompt(
    id: 'cr_015',
    focusArea: 'creativity',
    promptEn:
        'If you could collaborate with anyone — living or historical — on a creative project, who would it be and what would you make?',
    promptTr:
        'Yaratıcı bir projede herhangi biriyle — yaşayan veya tarihi — iş birliği yapabilseydiniz, kim olurdu ve ne yapardınız?',
    followUpEn:
        'What does your choice reveal about the kind of creative energy you crave?',
    followUpTr:
        'Seçiminiz arzuladığınız yaratıcı enerji türü hakkında ne ortaya koyuyor?',
  ),
  ReflectionPrompt(
    id: 'cr_016',
    focusArea: 'creativity',
    promptEn:
        'What everyday activity could you turn into a more creative experience — cooking, walking, writing, arranging your space?',
    promptTr:
        'Hangi gündelik aktiviteyi daha yaratıcı bir deneyime dönüştürebilirsiniz — yemek pişirmek, yürümek, yazmak, mekanınızı düzenlemek?',
    followUpEn:
        'Choose one and try it with fresh eyes tomorrow.',
    followUpTr:
        'Birini seçin ve yarın taze gözlerle deneyin.',
  ),
  ReflectionPrompt(
    id: 'cr_017',
    focusArea: 'creativity',
    promptEn:
        'What is the most creative solution you have ever come up with for a real-life challenge?',
    promptTr:
        'Gerçek bir yaşam zorluğu için geldiğiniz en yaratıcı çözüm neydi?',
    followUpEn:
        'What mindset were you in when that solution came to you?',
    followUpTr:
        'Bu çözüm aklınıza geldiğinde hangi zihin durumundaydınız?',
  ),
  ReflectionPrompt(
    id: 'cr_018',
    focusArea: 'creativity',
    promptEn:
        'What would you create if you knew nobody would ever judge it? Let yourself dream freely.',
    promptTr:
        'Kimsenin yargılamayacağını bilseniz ne yaratırdınız? Kendinize özgürce hayal kurma izni verin.',
    followUpEn:
        'Write down what came to mind. That answer holds a clue about your authentic creative voice.',
    followUpTr:
        'Aklınıza geleni yazın. Bu cevap otantik yaratıcı sesiniz hakkında bir ipucu taşıyor.',
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
        'Sürekli odaklanmak isteyip de kaçtığınız tek şey nedir? Bu kaçınmanın arkasında ne olabilir?',
    followUpEn:
        'If you removed all judgment, what would a five-minute start on that thing look like?',
    followUpTr:
        'Tüm yargıları kaldırırsanız, o şeye beş dakikalık bir başlangıç nasıl görülürdü?',
  ),
  ReflectionPrompt(
    id: 'pr_002',
    focusArea: 'productivity',
    promptEn:
        'When you lose focus, where does your attention usually go first? Social media, daydreaming, snacking, or something else?',
    promptTr:
        'Odağınızı kaybettiğinizde dikkatiniz genellikle ilk nereye gidiyor? Sosyal medya, hayal kurma, atıştırma veya başka bir şey?',
    followUpEn:
        'What unmet need might that default behavior be trying to satisfy?',
    followUpTr:
        'Bu varsayılan davranış hangi karşılanmamış ihtiyacı gidermeye çalışıyor olabilir?',
  ),
  ReflectionPrompt(
    id: 'pr_003',
    focusArea: 'productivity',
    promptEn:
        'Describe the physical environment where you do your best thinking. What elements make it work?',
    promptTr:
        'En iyi düşündüğünüz fiziksel ortamı tanımlayın. Hangi unsurlar onu etkili kılıyor?',
    followUpEn:
        'How closely does your current workspace match that ideal, and what one change could close the gap?',
    followUpTr:
        'Mevcut çalışma alanınız bu ideale ne kadar yakın ve arayı kapatabilecek bir değişiklik ne olabilir?',
  ),
  ReflectionPrompt(
    id: 'pr_004',
    focusArea: 'productivity',
    promptEn:
        'Think about a project you completed that you are genuinely proud of. How did you maintain focus during it?',
    promptTr:
        'Gerçekten gurur duyduğunuz tamamlanmış bir projeyi düşünün. Odağınızı nasıl korudunuz?',
    followUpEn:
        'Which of those focus strategies could you apply to what you are working on now?',
    followUpTr:
        'Bu odak stratejilerinden hangisini şu an üzerinde çalıştığınız şeye uygulayabilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'pr_005',
    focusArea: 'productivity',
    promptEn:
        'How do you feel about having multiple things on your plate at once — energized or scattered?',
    promptTr:
        'Aynı anda birden fazla işle uğraşma konusunda kendinizi nasıl hissediyorsunuz — enerjik mi yoksa dağınık mı?',
    followUpEn:
        'What is your personal threshold between productive multitasking and overwhelm?',
    followUpTr:
        'Verimli çoklu görev ile bunalma arasındaki kişisel eşiğiniz nedir?',
  ),
  ReflectionPrompt(
    id: 'pr_006',
    focusArea: 'productivity',
    promptEn:
        'When you sit down to work, how long does it typically take before you feel truly immersed?',
    promptTr:
        'Çalışmaya oturduğunuzda, kendinizi gerçekten dalgınlaşana kadar genellikle ne kadar zaman geçiyor?',
    followUpEn:
        'What rituals or habits seem to shorten that ramp-up time for you?',
    followUpTr:
        'Hangi ritüel veya alışkanlıklar bu hazırlık süresini kısaltıyor gibi görünüyor?',
  ),
  ReflectionPrompt(
    id: 'pr_007',
    focusArea: 'productivity',
    promptEn:
        'Notice what happens to your focus when you are working on something that aligns with your values versus something that does not.',
    promptTr:
        'Değerlerinizle örtüşen bir şey üzerinde çalışırken odağınıza ne olduğunu, örtüşmeyen bir şeyle karşılaştırın.',
    followUpEn:
        'What does that difference teach you about the relationship between meaning and concentration?',
    followUpTr:
        'Bu fark, anlam ve konsantrasyon arasındaki ilişki hakkında size ne öğretiyor?',
  ),
  ReflectionPrompt(
    id: 'pr_008',
    focusArea: 'productivity',
    promptEn:
        'What is one thing you recently learned that captured your attention completely? What made it so compelling?',
    promptTr:
        'Yakın zamanda dikkatinizi tamamen çeken öğrendiğiniz bir şey nedir? Onu bu kadar ilgi çekici yapan neydi?',
    followUpEn:
        'How can you bring more of that quality of curiosity into areas where you struggle to focus?',
    followUpTr:
        'Bu merak kalitesini odaklanmakta zorlandığınız alanlara nasıl daha fazla taşıyabilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'pr_009',
    focusArea: 'productivity',
    promptEn:
        'Do you focus better with a deadline or with open-ended time? What does that tell you about how you structure your days?',
    promptTr:
        'Son tarihle mi yoksa açık uçlu zamanla mı daha iyi odaklanıyorsunuz? Bu, günlerinizi nasıl yapılandırdığınız hakkında ne söylüyor?',
    followUpEn:
        'Experiment with the opposite approach this week and reflect on what you notice.',
    followUpTr:
        'Bu hafta ters yaklaşımı deneyin ve ne fark ettiğinizi düşünün.',
  ),
  ReflectionPrompt(
    id: 'pr_010',
    focusArea: 'productivity',
    promptEn:
        'What mental clutter are you carrying today that makes it harder to be present with one task?',
    promptTr:
        'Bugün bir göreve odaklanmanızı zorlaştıran hangi zihinsel karışıklığı taşıyorsunuz?',
    followUpEn:
        'If you wrote those worries down and set them aside for one hour, what might open up for you?',
    followUpTr:
        'Bu endişeleri yazıp bir saatliğine bir kenara koysanız, sizin için ne açılabilir?',
  ),
  ReflectionPrompt(
    id: 'pr_011',
    focusArea: 'productivity',
    promptEn:
        'How do you decide what deserves your attention on a given day? Is it planned or reactive?',
    promptTr:
        'Belirli bir günde neyin dikkatinizi hak ettiğine nasıl karar veriyorsunuz? Planlı mı yoksa tepkisel mi?',
    followUpEn:
        'What would shift if you protected your first focused hour each morning for your most important task?',
    followUpTr:
        'Her sabah ilk odaklı saatinizi en önemli görev için koruma altına alsanız ne değişirdi?',
  ),
  ReflectionPrompt(
    id: 'pr_012',
    focusArea: 'productivity',
    promptEn:
        'Reflect on the difference between being busy and being focused. Which one describes your typical day?',
    promptTr:
        'Meşgul olmak ile odaklı olmak arasındaki farkı düşünün. Hangisi tipik gününüzü tanımlıyor?',
    followUpEn:
        'What is one commitment you could release this week to create space for deeper focus?',
    followUpTr:
        'Daha derin odak için alan yaratmak adına bu hafta bırakabileceğiniz bir taahhüt nedir?',
  ),
  ReflectionPrompt(
    id: 'pr_013',
    focusArea: 'productivity',
    promptEn:
        'What tasks do you tend to procrastinate on? Is there a common thread between them?',
    promptTr:
        'Hangi görevleri erteleme eğilimindesiniz? Aralarında ortak bir iplik var mı?',
    followUpEn:
        'What emotion surfaces right before you procrastinate — boredom, fear, overwhelm, or something else?',
    followUpTr:
        'Erteleme yapmadan hemen önce hangi duygu yüzeyine çıkıyor — can sıkıntısı, korku, bunalma veya başka bir şey?',
  ),
  ReflectionPrompt(
    id: 'pr_014',
    focusArea: 'productivity',
    promptEn:
        'When you accomplish something meaningful, how do you celebrate it? Or do you immediately move to the next thing?',
    promptTr:
        'Anlamlı bir şey başardığınızda bunu nasıl kutluyorsunuz? Yoksa hemen bir sonraki şeye mi geçiyorsunuz?',
    followUpEn:
        'What would change if you paused to acknowledge your completions before starting something new?',
    followUpTr:
        'Yeni bir şeye başlamadan önce tamamlamalarınızı takdir etmek için duraklaşsaydınız ne değişirdi?',
  ),
  ReflectionPrompt(
    id: 'pr_015',
    focusArea: 'productivity',
    promptEn:
        'How do you define a "productive day"? Is that definition serving your well-being or undermining it?',
    promptTr:
        'Verimli bir günü nasıl tanımlıyorsunuz? Bu tanım iyiliğinize hizmet ediyor mu yoksa baltalıyor mu?',
    followUpEn:
        'What if productivity included rest, play, and connection alongside output?',
    followUpTr:
        'Verimlilik çıktı yanında dinlenme, oyun ve bağlantı da içerseydi ne olurdu?',
  ),
  ReflectionPrompt(
    id: 'pr_016',
    focusArea: 'productivity',
    promptEn:
        'What systems or tools help you stay organized? Are they working, or have they become their own burden?',
    promptTr:
        'Organize kalmanıza hangi sistemler veya araçlar yardımcı oluyor? Çalışıyor mu, yoksa kendi yükü mü haline geldi?',
    followUpEn:
        'What would your ideal simple system look like if you could start fresh?',
    followUpTr:
        'Sıfırdan başlasaydınız ideal basit sisteminiz nasıl görülürdü?',
  ),
  ReflectionPrompt(
    id: 'pr_017',
    focusArea: 'productivity',
    promptEn:
        'How do breaks affect your productivity? Do you take them intentionally, or only when forced?',
    promptTr:
        'Molalar verimliliğinizi nasıl etkiliyor? Bilinçli mi alıyorsunuz, yoksa yalnızca mecbur kaldığınızda mı?',
    followUpEn:
        'Try scheduling two short breaks today and notice what happens to your focus afterward.',
    followUpTr:
        'Bugün iki kısa mola planlamayı deneyin ve sonrasında odağınıza ne olduğunu fark edin.',
  ),
  ReflectionPrompt(
    id: 'pr_018',
    focusArea: 'productivity',
    promptEn:
        'What decision are you postponing that, once made, would free up significant mental space?',
    promptTr:
        'Bir kere verildiğinde önemli zihinsel alan açabilecek hangi kararı erteliyorsunuz?',
    followUpEn:
        'What is the cost of continuing to postpone, and how does that compare to the risk of deciding?',
    followUpTr:
        'Ertelemeye devam etmenin bedeli nedir ve bu, karar verme riskiyle nasıl karşılaştırılır?',
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
        'Bedeniniz şu anda nasıl hissediyor? Tepeden tırnağa tara ve ne bulduğunuzu fark edin.',
    followUpEn:
        'What is one thing your body might be asking for that you have been ignoring?',
    followUpTr:
        'Bedeninizin görmezden geldiğiniz ne istiyor olabilir?',
  ),
  ReflectionPrompt(
    id: 'he_002',
    focusArea: 'health',
    promptEn:
        'What is your relationship with sleep like? Do you approach bedtime with ease or resistance?',
    promptTr:
        'Uykuyla ilişkiniz nasıl? Yatma saatine kolaylıkla mı yoksa dirençle mi yaklaşıyorsunuz?',
    followUpEn:
        'What would your ideal wind-down routine look like in the last hour before sleep?',
    followUpTr:
        'Uykudan önceki son saat için ideal rahatlama rutininiz nasıl görülürdü?',
  ),
  ReflectionPrompt(
    id: 'he_003',
    focusArea: 'health',
    promptEn:
        'How do you nourish yourself beyond food — through rest, movement, nature, or connection?',
    promptTr:
        'Kendinizi yiyecek dışında nasıl besliyorsunuz — dinlenme, hareket, doğa veya bağlantı yoluyla?',
    followUpEn:
        'Which of these nourishment sources has been most neglected recently?',
    followUpTr:
        'Bu beslenme kaynaklarından hangisi son zamanlarda en çok ihmal edildi?',
  ),
  ReflectionPrompt(
    id: 'he_004',
    focusArea: 'health',
    promptEn:
        'What signals does your body send you when stress is building? Tight shoulders, headaches, shallow breathing, or something else?',
    promptTr:
        'Stres yükseldiğinde bedeniniz size hangi sinyalleri gönderiyor? Gergin omuzlar, baş ağrısı, sığ nefes alma veya başka bir şey?',
    followUpEn:
        'What is one action you can take as soon as you notice those early signals?',
    followUpTr:
        'Bu erken sinyalleri fark ettiğinizde yapabileceğiniz bir eylem nedir?',
  ),
  ReflectionPrompt(
    id: 'he_005',
    focusArea: 'health',
    promptEn:
        'How much time did you spend moving your body today? Not exercising necessarily, but simply moving?',
    promptTr:
        'Bugün bedeninizi hareket ettirmek için ne kadar zaman harcadınız? Egzersiz değil, sadece hareket.',
    followUpEn:
        'What type of movement feels like a gift rather than a chore to you?',
    followUpTr:
        'Hangi tür hareket sizin için bir zorunluluk değil bir hediye gibi hissettiriyor?',
  ),
  ReflectionPrompt(
    id: 'he_006',
    focusArea: 'health',
    promptEn:
        'When you feel physically unwell, how do you treat yourself? With patience and care, or frustration and pushing through?',
    promptTr:
        'Fiziksel olarak iyi hissetmediğinizde kendinize nasıl davranıyorsunuz? Sabır ve özenle mi, yoksa hayal kırıklığı ve zorlamayla mı?',
    followUpEn:
        'What would a compassionate response to your body look like the next time you feel off?',
    followUpTr:
        'Bir dahaki sefere kendinizi iyi hissetmediğinizde bedeninize şefkatli bir tepki nasıl görülürdü?',
  ),
  ReflectionPrompt(
    id: 'he_007',
    focusArea: 'health',
    promptEn:
        'What is one healthy habit you have been meaning to start? What keeps getting in the way?',
    promptTr:
        'Başlamak istediğiniz bir sağlıklı alışkanlık nedir? Sürekli ne engel oluyor?',
    followUpEn:
        'What if you committed to that habit for just five minutes a day for one week?',
    followUpTr:
        'Bu alışkanlığı bir hafta boyunca günde sadece beş dakika için taahhüt etseydiniz ne olurdu?',
  ),
  ReflectionPrompt(
    id: 'he_008',
    focusArea: 'health',
    promptEn:
        'How does your hydration, nutrition, and sleep interact with your emotional state? What connections do you notice?',
    promptTr:
        'Hidrasyon, beslenme ve uykunuz duygusal durumunuzla nasıl etkileşiyor? Hangi bağlantıları fark ediyorsunuz?',
    followUpEn:
        'Choose one basic need to prioritize this week and observe how it affects everything else.',
    followUpTr:
        'Bu hafta öncelik verecek bir temel ihtiyaç seçin ve her şeyi nasıl etkilediğini gözlemleyin.',
  ),
  ReflectionPrompt(
    id: 'he_009',
    focusArea: 'health',
    promptEn:
        'What does "wellness" mean to you personally? Is it about the absence of illness, or something more holistic?',
    promptTr:
        'Sağlık sizin için kişisel olarak ne anlama geliyor? Hastalık yokluğu mu, yoksa daha bütüncül bir şey mi?',
    followUpEn:
        'How closely does your daily life reflect your personal definition of wellness?',
    followUpTr:
        'Günlük hayatınız kişisel sağlık tanımınızı ne kadar yakından yansıtıyor?',
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
        'Hayatınıza anlam veya amaç hissi veren nedir? Bu kaynak zamanla değişti mi?',
    followUpEn:
        'How do you nurture that sense of meaning in your daily routine?',
    followUpTr:
        'Bu anlam hissini günlük rutininizde nasıl besliyorsunuz?',
  ),
  ReflectionPrompt(
    id: 'sp_002',
    focusArea: 'spirituality',
    promptEn:
        'When do you feel most connected to something larger than yourself — in nature, meditation, community, or elsewhere?',
    promptTr:
        'Kendinizden büyük bir şeye en çok ne zaman bağlanmış hissediyorsunuz — doğada, meditasyonda, toplulukta veya başka bir yerde?',
    followUpEn:
        'How could you create more opportunities for that feeling of connection?',
    followUpTr:
        'Bu bağlantı hissi için daha fazla fırsat nasıl yaratabilirsiniz?',
  ),
  ReflectionPrompt(
    id: 'sp_003',
    focusArea: 'spirituality',
    promptEn:
        'What does silence or stillness bring up for you? Comfort, restlessness, insight, or something else?',
    promptTr:
        'Sessizlik veya durgunluk sizde ne uyandırıyor? Rahatlık, huzursuzluk, içgörü veya başka bir şey?',
    followUpEn:
        'Try sitting in silence for three minutes and journal about what surfaces.',
    followUpTr:
        'Üç dakika sessizlikte oturmayı deneyin ve ortaya çıkanları not edin.',
  ),
  ReflectionPrompt(
    id: 'sp_004',
    focusArea: 'spirituality',
    promptEn:
        'What are you grateful for that money cannot buy? Reflect on the intangible gifts in your life.',
    promptTr:
        'Paranın satamayacağı neye minnettarsınız? Hayatınızdaki soyut hediyeleri düşünün.',
    followUpEn:
        'How does acknowledging these gifts affect your perspective on what you lack?',
    followUpTr:
        'Bu hediyeleri kabul etmek eksikliklerinize bakış açınızı nasıl etkiliyor?',
  ),
  ReflectionPrompt(
    id: 'sp_005',
    focusArea: 'spirituality',
    promptEn:
        'What beliefs or values guide your decisions, even when nobody is watching?',
    promptTr:
        'Kimse izlemezken bile kararlarınızı hangi inançlar veya değerler yönlendiriyor?',
    followUpEn:
        'When was the last time those values were tested, and how did you respond?',
    followUpTr:
        'Bu değerler en son ne zaman test edildi ve nasıl karşılık verdiniz?',
  ),
  ReflectionPrompt(
    id: 'sp_006',
    focusArea: 'spirituality',
    promptEn:
        'How do you make sense of difficult experiences? Do you look for lessons, acceptance, or meaning?',
    promptTr:
        'Zor deneyimleri nasıl anlamlandırıyorsunuz? Ders mi, kabul mü, yoksa anlam mı arıyorsunuz?',
    followUpEn:
        'Reflect on a past hardship that, with time, taught you something valuable.',
    followUpTr:
        'Zamanla size değerli bir şey öğreten geçmiş bir zorluğu düşünün.',
  ),
  ReflectionPrompt(
    id: 'sp_007',
    focusArea: 'spirituality',
    promptEn:
        'What does your inner wisdom sound like? When you quiet everything else, what voice remains?',
    promptTr:
        'İç bilgeliğiniz neye benziyor? Her şeyi susturduğunuzda hangi ses kalıyor?',
    followUpEn:
        'How often do you follow that voice versus overriding it with logic or fear?',
    followUpTr:
        'Bu sesi ne sıklıkla mantık veya korkuyla bastırmak yerine takip ediyorsunuz?',
  ),
  ReflectionPrompt(
    id: 'sp_008',
    focusArea: 'spirituality',
    promptEn:
        'What rituals or practices help you feel grounded and centered? How consistently do you practice them?',
    promptTr:
        'Hangi ritüel veya pratikler kendinizi topraklanmış ve merkezlenmiş hissetmenize yardımcı oluyor? Ne kadar tutarlı uyguluyorsunuz?',
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
        'Evrene bir soru sorup dürüstçe cevap alabilseydiniz, ne sorardınız?',
    followUpEn:
        'What does your question reveal about what you are truly searching for in this season of life?',
    followUpTr:
        'Sorunuz, hayatın bu döneminde gerçekten ne aradığınız hakkında ne ortaya koyuyor?',
  ),
];
