/// INSIGHT CARDS CONTENT - Part 2: Venus, Mars, Jupiter
///
/// Continuation of insight cards. See insight_cards_content.dart for class definition.
/// Apple App Store 4.3(b) compliant. No predictive language.
library;

import 'insight_cards_content.dart';

// =============================================================================
// VENUS ARCHETYPE CARDS (12)
// =============================================================================

const List<InsightCard> venusInsightCards = [
  InsightCard(
    id: 'venus_01',
    categoryKey: 'venus',
    titleEn: 'What You Value Reveals Who You Are',
    titleTr: 'Neye Değer Verdiğiniz Kim Olduğunuzu Ortaya Koyar',
    bodyEn:
        'Your values are the invisible architecture of your life. They shape your choices, attract certain people, and determine what feels satisfying or hollow. Taking time to name your core values, rather than assuming you already know them, can reveal surprising gaps between what you believe you value and how you actually live.',
    bodyTr:
        'Değerleriniz hayatınızın görünmez mimarisidir. Seçimlerinizi şekillendirir, belirli insanları çeker ve neyin tatmin edici veya boş hissettirdiğini belirler. Zaten bildiğinizi varsaymak yerine temel değerlerinizi isimlendirmek için zaman ayırmak, değer verdiğinize inandığınız şey ile gerçekte nasıl yaşadığınız arasında şaşırtıcı boşluklar ortaya çıkarabilir.',
    reflectionEn:
        'If someone observed your last week without hearing your words, what would they say you value most?',
    reflectionTr:
        'Biri sözlerinizi duymadan geçen haftanızı gözlemlese, en çok neye değer verdiğinizi söylerdi?',
    tagsEn: ['values', 'self-knowledge', 'alignment'],
    tagsTr: ['değerler', 'öz-bilgi', 'uyum'],
  ),
  InsightCard(
    id: 'venus_02',
    categoryKey: 'venus',
    titleEn: 'The Art of Receiving',
    titleTr: 'Alma Sanatı',
    bodyEn:
        'Many people find it easier to give than to receive. Receiving a compliment, a gift, or help can trigger discomfort because it requires you to accept that you are worthy of kindness. The Venusian archetype reminds you that gracious receiving is not passive; it is an active practice of allowing yourself to be valued.',
    bodyTr:
        'Birçok insan vermeyi almaktan daha kolay bulur. Bir iltifat, hediye veya yardım almak rahatsızlığı tetikleyebilir çünkü nazikliğe layık olduğunuzu kabul etmenizi gerektirir. Venüs arketipi, zarif almanın pasif olmadığını; kendinize değer verilmesine izin vermenin aktif bir pratiği olduğunu hatırlatır.',
    reflectionEn:
        'When was the last time you deflected a compliment, and what would it feel like to simply accept it?',
    reflectionTr:
        'En son ne zaman bir iltifatı saptırdınız ve onu basitçe kabul etmek nasıl hissettirirdi?',
    tagsEn: ['receiving', 'self-worth', 'vulnerability'],
    tagsTr: ['alma', 'öz-değer', 'kırılganlık'],
  ),
  InsightCard(
    id: 'venus_03',
    categoryKey: 'venus',
    titleEn: 'Beauty as Nourishment',
    titleTr: 'Beslenme Olarak Güzellik',
    bodyEn:
        'Seeking beauty is not frivolous. It is a fundamental human need, as real as the need for food or shelter. Beauty, whether found in nature, art, music, or a well-arranged space, nourishes something deep within you. When you starve yourself of beauty, something essential begins to wither.',
    bodyTr:
        'Güzellik aramak anlamsız değildir. Yiyecek veya barınma ihtiyacı kadar gerçek, temel bir insan ihtiyacıdır. İster doğada, ister sanatta, müzikte veya iyi düzenlenmiş bir alanda bulunsun, güzellik içinizdeki derin bir şeyi besler. Kendinizi güzellikten mahrum bıraktığınızda, temel bir şey solmaya başlar.',
    reflectionEn:
        'Where did you encounter beauty today, and how did it affect your inner state?',
    reflectionTr:
        'Bugün güzellikle nerede karşılaştınız ve iç dünyanızı nasıl etkiledi?',
    tagsEn: ['beauty', 'nourishment', 'well-being'],
    tagsTr: ['güzellik', 'beslenme', 'refah'],
  ),
  InsightCard(
    id: 'venus_04',
    categoryKey: 'venus',
    titleEn: 'Love Languages of the Self',
    titleTr: 'Benliğin Sevgi Dilleri',
    bodyEn:
        'Just as you have preferred ways of receiving love from others, you have preferred ways of showing love to yourself. For some it is quiet time, for others it is movement, creativity, or nourishing food. Understanding your personal love language for self-care can help you replenish more efficiently and more joyfully.',
    bodyTr:
        'Başkalarından sevgi almanın tercih ettiğiniz yolları olduğu gibi, kendinize sevgi göstermenin de tercih ettiğiniz yolları vardır. Bazıları için sessiz zaman, diğerleri için hareket, yaratıcılık veya besleyici yiyecek olabilir. Öz-bakım için kişisel sevgi dilinizi anlamak, daha verimli ve daha neşeli şekilde yenilenmenize yardımcı olabilir.',
    reflectionEn:
        'What is the most effective way you show love to yourself, and did you practice it today?',
    reflectionTr:
        'Kendinize sevgi göstermenin en etkili yolu nedir ve bugün bunu pratik ettiniz mi?',
    tagsEn: ['self-love', 'self-care', 'awareness'],
    tagsTr: ['öz-sevgi', 'öz-bakım', 'farkındalık'],
  ),
  InsightCard(
    id: 'venus_05',
    categoryKey: 'venus',
    titleEn: 'Harmony Without Sacrifice',
    titleTr: 'Fedakarlık Olmadan Uyum',
    bodyEn:
        'The desire for harmony can sometimes lead you to suppress your own needs in favor of keeping the peace. But peace achieved through self-erasure is not true harmony; it is accommodation that builds resentment over time. Real harmony includes your voice, your needs, and your truth alongside those of others.',
    bodyTr:
        'Uyum arzusu bazen barışı korumak adına kendi ihtiyaçlarınızı bastırmanıza yol açabilir. Ancak kendini silme yoluyla elde edilen barış gerçek uyum değildir; zamanla kızgınlık biriktiren bir uygundur. Gerçek uyum, başkalarının yanında sizin sesinizi, ihtiyaçlarınızı ve gerçeğinizi de içerir.',
    reflectionEn:
        'Where have you been keeping the peace at the expense of your own truth?',
    reflectionTr:
        'Kendi gerçeğiniz pahasına nerede barışı koruyorsunuz?',
    tagsEn: ['harmony', 'boundaries', 'authenticity'],
    tagsTr: ['uyum', 'sınırlar', 'otantiklik'],
  ),
  InsightCard(
    id: 'venus_06',
    categoryKey: 'venus',
    titleEn: 'The Mirror of Relationships',
    titleTr: 'İlişkilerin Aynası',
    bodyEn:
        'The people who trigger the strongest reactions in you, both positive and negative, often reflect aspects of yourself that you have not fully acknowledged. Admiration can point to qualities you are ready to develop. Irritation may signal something in yourself you are not at peace with. Relationships, seen this way, become powerful teachers.',
    bodyTr:
        'Sizde en güçlü tepkileri tetikleyen insanlar, hem olumlu hem olumsuz, genellikle tam olarak kabul etmediğiniz kendinize ait yönleri yansıtır. Hayranlık, geliştirmeye hazır olduğunuz niteliklere işaret edebilir. Kızgınlık, kendinizde barışık olmadığınız bir şeyin sinyali olabilir. Bu şekilde bakıldığında ilişkiler güçlü öğretmenler haline gelir.',
    reflectionEn:
        'Who triggered a strong reaction in you recently, and what might they be mirroring?',
    reflectionTr:
        'Son zamanlarda kimde güçlü bir tepki tetiklendi ve neyi yansıtıyor olabilirler?',
    tagsEn: ['relationships', 'mirror', 'self-awareness'],
    tagsTr: ['ilişkiler', 'ayna', 'öz-farkındalık'],
  ),
  InsightCard(
    id: 'venus_07',
    categoryKey: 'venus',
    titleEn: 'Abundance Already Present',
    titleTr: 'Zaten Mevcut Olan Bolluk',
    bodyEn:
        'The feeling of scarcity, that there is never enough time, love, money, or opportunity, often has less to do with actual circumstances than with inner orientation. When you pause to notice what is already abundant in your life, even small things, the grip of scarcity loosens. This is not denial of real challenges but a rebalancing of attention.',
    bodyTr:
        'Asla yeterli zaman, sevgi, para veya fırsat olmadığı kıtlık hissi, genellikle gerçek koşullarla iç yönelimle olduğundan daha az ilgilidir. Hayatınızda zaten neyin bol olduğunu, küçük şeyler bile olsa, fark etmek için durduğunuzda, kıtlığın tutuşu gevşer. Bu gerçek zorlukların inkarı değil, dikkatin yeniden dengelenmesidir.',
    reflectionEn:
        'Name three things that are abundant in your life right now that you tend to overlook.',
    reflectionTr:
        'Şu anda hayatınızda bol olan ancak gözden kaçırma eğiliminde olduğunuz üç şeyi adlandırın.',
    tagsEn: ['abundance', 'gratitude', 'perspective'],
    tagsTr: ['bolluk', 'şükran', 'perspektif'],
  ),
  InsightCard(
    id: 'venus_08',
    categoryKey: 'venus',
    titleEn: 'Saying No as Self-Love',
    titleTr: 'Öz-Sevgi Olarak Hayır Demek',
    bodyEn:
        'Every "yes" to something is an implicit "no" to something else. When you say yes out of obligation rather than genuine desire, you diminish both the quality of your giving and your own well-being. The Venusian archetype teaches that a clear, kind "no" can be one of the most loving things you do for yourself and others.',
    bodyTr:
        'Bir şeye her "evet" bir başka şeye örtük bir "hayır"dır. Gerçek arzudan ziyade zorunluluk duygusuyla evet dediğinizde, hem vermenizin kalitesini hem de kendi refahınızı azaltırsınız. Venüs arketipi, net ve nazik bir "hayır"ın kendiniz ve başkaları için yapabileceğiniz en sevgi dolu şeylerden biri olabileceğini öğretir.',
    reflectionEn:
        'What did you say yes to recently that your heart was actually saying no to?',
    reflectionTr:
        'Son zamanlarda kalbinizin aslında hayır dediği neye evet dediniz?',
    tagsEn: ['boundaries', 'self-love', 'honesty'],
    tagsTr: ['sınırlar', 'öz-sevgi', 'dürüstlük'],
  ),
  InsightCard(
    id: 'venus_09',
    categoryKey: 'venus',
    titleEn: 'The Texture of Connection',
    titleTr: 'Bağlantının Dokusu',
    bodyEn:
        'Not all connections serve the same purpose. Some relationships are built for depth, others for lightness. Some sustain you through difficulty, others celebrate joy with you. Honoring the unique texture of each connection, rather than expecting every relationship to be everything, can bring more satisfaction and less disappointment.',
    bodyTr:
        'Tüm bağlantılar aynı amaca hizmet etmez. Bazı ilişkiler derinlik için, bazıları hafiflik için inşa edilmiştir. Bazıları zorluklar boyunca sizi destekler, diğerleri neşeyi sizinle kutlar. Her ilişkinin her şey olmasını beklemek yerine, her bağlantının benzersiz dokusunu onurlandırmak daha fazla tatmin ve daha az hayal kırıklığı getirebilir.',
    reflectionEn:
        'Which relationship in your life serves a purpose you have not fully appreciated?',
    reflectionTr:
        'Hayatınızdaki hangi ilişki tam olarak takdir etmediğiniz bir amaca hizmet ediyor?',
    tagsEn: ['relationships', 'connection', 'appreciation'],
    tagsTr: ['ilişkiler', 'bağlantı', 'takdir'],
  ),
  InsightCard(
    id: 'venus_10',
    categoryKey: 'venus',
    titleEn: 'Pleasure Without Guilt',
    titleTr: 'Suçluluk Olmadan Keyif',
    bodyEn:
        'The ability to fully enjoy pleasure, a delicious meal, a warm bath, a slow morning, without guilt is a sign of emotional health, not indulgence. When you allow yourself to be nourished by life\'s simple pleasures, you build an inner reservoir of well-being that sustains you through harder times.',
    bodyTr:
        'Keyiften tam olarak zevk alma yeteneği, lezzetli bir yemek, sıcak bir banyo, yavaş bir sabah, suçluluk olmadan duygusal sağlığın bir işaretidir, aşırılık değil. Hayatın basit keyiflerinden beslenmenize izin verdiğinizde, sizi daha zor zamanlardan geçiren bir iç refah rezervi oluşturursunuz.',
    reflectionEn:
        'What simple pleasure did you allow yourself today without rushing through it?',
    reflectionTr:
        'Bugün acele etmeden kendinize hangi basit keyfi yaşattınız?',
    tagsEn: ['pleasure', 'self-care', 'presence'],
    tagsTr: ['keyif', 'öz-bakım', 'mevcudiyet'],
  ),
  InsightCard(
    id: 'venus_11',
    categoryKey: 'venus',
    titleEn: 'Forgiveness as Freedom',
    titleTr: 'Özgürlük Olarak Affetme',
    bodyEn:
        'Forgiveness is often misunderstood as condoning harm or pretending it did not happen. In truth, forgiveness is primarily a gift to yourself. It is the decision to stop carrying the weight of resentment, not because the other person deserves it, but because you deserve the freedom that comes from releasing it.',
    bodyTr:
        'Affetme genellikle zararı hoşgörmek veya olmamış gibi davranmak olarak yanlış anlaşılır. Gerçekte affetme öncelikle kendinize bir hediyedir. Kızgınlığın ağırlığını taşımayı bırakma kararıdır, karşı taraf hak ettiği için değil, siz onu bırakmanın getireceği özgürlüğü hak ettiğiniz için.',
    reflectionEn:
        'What resentment are you still carrying that weighs more than the original wound?',
    reflectionTr:
        'Hala taşıdığınız hangi kızgınlık orijinal yaradan daha ağır basıyor?',
    tagsEn: ['forgiveness', 'freedom', 'healing'],
    tagsTr: ['affetme', 'özgürlük', 'iyileşme'],
  ),
  InsightCard(
    id: 'venus_12',
    categoryKey: 'venus',
    titleEn: 'Your Relationship with Enough',
    titleTr: 'Yeterlilikle İlişkiniz',
    bodyEn:
        'The concept of "enough" is deeply personal. Enough rest, enough love, enough success, enough growth. When you examine your own definition of "enough," you may find that it is shaped more by comparison and external expectations than by your actual needs. The Venusian archetype invites you to define "enough" from the inside out.',
    bodyTr:
        '"Yeterli" kavramı derinden kişiseldir. Yeterli dinlenme, yeterli sevgi, yeterli başarı, yeterli büyüme. Kendi "yeterli" tanımınızı incelediğinizde, gerçek ihtiyaçlarınızdan ziyade karşılaştırma ve dışsal beklentiler tarafından şekillendirildiğini görebilirsiniz. Venüs arketipi, "yeterli"yi içten dışa tanımlamanızı davet eder.',
    reflectionEn:
        'What does "enough" actually look like for you, independent of what others expect?',
    reflectionTr:
        'Başkalarının beklentilerinden bağımsız olarak "yeterli" sizin için gerçekte neye benziyor?',
    tagsEn: ['enough', 'self-knowledge', 'contentment'],
    tagsTr: ['yeterlilik', 'öz-bilgi', 'doyum'],
  ),
];

// =============================================================================
// MARS ARCHETYPE CARDS (12)
// =============================================================================

const List<InsightCard> marsInsightCards = [
  InsightCard(
    id: 'mars_01',
    categoryKey: 'mars',
    titleEn: 'Anger as Information',
    titleTr: 'Bilgi Olarak Öfke',
    bodyEn:
        'Anger is one of the most misunderstood emotions. When approached with awareness, it reveals where your boundaries have been crossed, what you care about deeply, and where injustice has touched your life. The Mars archetype invites you to treat anger not as something to suppress or unleash, but as valuable data about your inner world.',
    bodyTr:
        'Öfke en yanlış anlaşılan duygulardan biridir. Farkındalıkla yaklaşıldığında, sınırlarınızın nerede aşıldığını, neyi derinden önemsediğinizi ve adaletsizliğin hayatınıza nerede dokunduğunu ortaya koyar. Mars arketipi, öfkeyi bastırılması veya serbest bırakılması gereken bir şey olarak değil, iç dünyanız hakkında değerli veri olarak ele almanızı davet eder.',
    reflectionEn:
        'What made you angry recently, and what boundary or value was it protecting?',
    reflectionTr:
        'Son zamanlarda sizi ne kızdırdı ve hangi sınırı veya değeri koruyordu?',
    tagsEn: ['anger', 'boundaries', 'self-knowledge'],
    tagsTr: ['öfke', 'sınırlar', 'öz-bilgi'],
  ),
  InsightCard(
    id: 'mars_02',
    categoryKey: 'mars',
    titleEn: 'The Difference Between Reaction and Response',
    titleTr: 'Tepki ile Yanıt Arasındaki Fark',
    bodyEn:
        'A reaction is instant, automatic, driven by survival instinct. A response is chosen, considered, aligned with who you want to be. The space between a trigger and your behavior, even if it is just one breath, is where your personal power lives. Expanding that space is one of the most transformative things you can practice.',
    bodyTr:
        'Tepki anlıktır, otomatiktir, hayatta kalma içgüdüsüyle yönlendirilir. Yanıt seçilmiştir, düşünülmüştür, olmak istediğiniz kişiyle uyumludur. Bir tetikleyici ile davranışınız arasındaki boşluk, tek bir nefes bile olsa, kişisel gücünüzün yaşadığı yerdir. Bu boşluğu genişletmek pratik edebileceğiniz en dönüştürücü şeylerden biridir.',
    reflectionEn:
        'Where today did you react when you would have preferred to respond?',
    reflectionTr:
        'Bugün nerede yanıt vermeyi tercih edeceğiniz halde tepki verdiniz?',
    tagsEn: ['self-control', 'awareness', 'choice'],
    tagsTr: ['öz-kontrol', 'farkındalık', 'seçim'],
  ),
  InsightCard(
    id: 'mars_03',
    categoryKey: 'mars',
    titleEn: 'Competing with Yesterday',
    titleTr: 'Dünle Yarışmak',
    bodyEn:
        'The most productive form of competition is not against others but against your own limitations. When you measure progress by comparing yourself to who you were yesterday rather than to someone else today, growth becomes personal and sustainable rather than anxious and comparative.',
    bodyTr:
        'Rekabetin en verimli biçimi başkalarına karşı değil, kendi sınırlamalarınıza karşı olandır. İlerlemeyi bugün başka biriyle değil, dün kim olduğunuzla karşılaştırarak ölçtüğünüzde, büyüme kaygılı ve karşılaştırmalı yerine kişisel ve sürdürülebilir hale gelir.',
    reflectionEn:
        'In what area have you grown compared to where you were a year ago?',
    reflectionTr:
        'Bir yıl önceki yerinize kıyasla hangi alanda büyüdünüz?',
    tagsEn: ['growth', 'competition', 'self-improvement'],
    tagsTr: ['büyüme', 'rekabet', 'kendini-geliştirme'],
  ),
  InsightCard(
    id: 'mars_04',
    categoryKey: 'mars',
    titleEn: 'The Body as Ally',
    titleTr: 'Müttefik Olarak Beden',
    bodyEn:
        'Your physical body is not just a vehicle for your mind. It is a partner in every experience you have. When you move, sweat, stretch, or simply breathe deeply, you are not just maintaining health; you are processing emotions, releasing tension, and reconnecting with a form of intelligence that does not depend on words.',
    bodyTr:
        'Fiziksel bedeniniz sadece zihniniz için bir araç değildir. Yaşadığınız her deneyimde bir ortaktır. Hareket ettiğinizde, terleyip, gerilip veya sadece derin nefes aldığınızda, yalnızca sağlığı korumuyorsunuz; duyguları işliyor, gerginliği serbest bırakıyor ve kelimelere bağlı olmayan bir zeka biçimiyle yeniden bağlantı kuruyorsunuz.',
    reflectionEn:
        'How did your body communicate with you today, and did you listen?',
    reflectionTr:
        'Bugün bedeniniz sizinle nasıl iletişim kurdu ve dinlediniz mi?',
    tagsEn: ['body', 'movement', 'awareness'],
    tagsTr: ['beden', 'hareket', 'farkındalık'],
  ),
  InsightCard(
    id: 'mars_05',
    categoryKey: 'mars',
    titleEn: 'Courage Is Not Fearlessness',
    titleTr: 'Cesaret Korkusuzluk Değildir',
    bodyEn:
        'The common misconception about courage is that it means the absence of fear. In reality, courage is the decision to act in alignment with your values despite the fear. The Mars archetype at its most mature does not deny fear but integrates it, using the energy of fear as fuel rather than letting it become a cage.',
    bodyTr:
        'Cesaret hakkındaki yaygın yanılgı, korkunun yokluğu anlamına geldiğidir. Gerçekte cesaret, korkuya rağmen değerlerinizle uyumlu hareket etme kararıdır. En olgun halindeki Mars arketipi korkuyu inkar etmez, onu bütünleştirir; korkunun enerjisini bir kafes haline gelmesine izin vermek yerine yakıt olarak kullanır.',
    reflectionEn:
        'What did you do today despite being afraid, and what did that teach you about your own courage?',
    reflectionTr:
        'Bugün korkmana rağmen ne yaptınız ve bu size kendi cesaretiniz hakkında ne öğretti?',
    tagsEn: ['courage', 'fear', 'values'],
    tagsTr: ['cesaret', 'korku', 'değerler'],
  ),
  InsightCard(
    id: 'mars_06',
    categoryKey: 'mars',
    titleEn: 'Desire as a Compass',
    titleTr: 'Pusula Olarak Arzu',
    bodyEn:
        'Your desires are not random. They carry information about what your life is asking for. Rather than dismissing desires as distractions or indulgences, you might consider them as directional signals pointing toward experiences that could bring growth, fulfillment, or necessary change.',
    bodyTr:
        'Arzularınız rastgele değildir. Hayatınızın ne istediği hakkında bilgi taşırlar. Arzuları dikkat dağıtıcı veya aşırılık olarak görmek yerine, büyüme, tatmin veya gerekli değişim getirebilecek deneyimlere işaret eden yönlendirici sinyaller olarak düşünebilirsiniz.',
    reflectionEn:
        'What have you been wanting lately, and what deeper need might that desire be expressing?',
    reflectionTr:
        'Son zamanlarda ne istiyordunuz ve bu arzu hangi derin ihtiyacı ifade ediyor olabilir?',
    tagsEn: ['desire', 'direction', 'needs'],
    tagsTr: ['arzu', 'yön', 'ihtiyaçlar'],
  ),
  InsightCard(
    id: 'mars_07',
    categoryKey: 'mars',
    titleEn: 'The Discipline of Starting Over',
    titleTr: 'Yeniden Başlama Disiplini',
    bodyEn:
        'Starting over is often viewed as failure, but it is actually one of the most courageous acts available to you. Every restart carries with it the accumulated wisdom of previous attempts. The Mars archetype honors the strength it takes to say, "This is not working, and I am willing to begin again with what I now know."',
    bodyTr:
        'Yeniden başlamak genellikle başarısızlık olarak görülür, ancak aslında yapabileceğiniz en cesur eylemlerden biridir. Her yeniden başlangıç, önceki girişimlerin birikmiş bilgeliğini taşır. Mars arketipi, "Bu işe yaramıyor ve şimdi bildiklerimle yeniden başlamaya hazırım" demenin gerektirdiği gücü onurlandırır.',
    reflectionEn:
        'What are you willing to begin again, carrying only the wisdom from your previous attempt?',
    reflectionTr:
        'Sadece önceki girişiminizden gelen bilgeliği taşıyarak neyi yeniden başlamaya hazırsınız?',
    tagsEn: ['resilience', 'courage', 'fresh-start'],
    tagsTr: ['dayanıklılık', 'cesaret', 'yeni-başlangıç'],
  ),
  InsightCard(
    id: 'mars_08',
    categoryKey: 'mars',
    titleEn: 'Protecting What Matters',
    titleTr: 'Önemli Olanı Korumak',
    bodyEn:
        'There are things in your life worth fighting for: your peace, your integrity, the well-being of those you love, the boundaries that keep you whole. The Mars archetype asks you to be clear about what deserves your protective energy and what is simply draining it through battles that are not truly yours.',
    bodyTr:
        'Hayatınızda uğruna savaşmaya değer şeyler vardır: huzurunuz, bütünlüğünüz, sevdiklerinizin esenliği, sizi bütün tutan sınırlar. Mars arketipi, koruyucu enerjinizi neyin hak ettiği konusunda net olmanızı ve gerçekten sizin olmayan savaşlar yoluyla neyin tükettiğini ayırt etmenizi ister.',
    reflectionEn:
        'What are you currently defending, and is it worth the energy you are spending?',
    reflectionTr:
        'Şu anda neyi savunuyorsunuz ve harcadığınız enerjiye değer mi?',
    tagsEn: ['protection', 'priorities', 'energy'],
    tagsTr: ['koruma', 'öncelikler', 'enerji'],
  ),
  InsightCard(
    id: 'mars_09',
    categoryKey: 'mars',
    titleEn: 'The Strength in Vulnerability',
    titleTr: 'Kırılganlıktaki Güç',
    bodyEn:
        'It takes more strength to admit when you are struggling than to pretend everything is fine. The Mars archetype in its deepest form understands that vulnerability is not the opposite of strength but its most refined expression. When you allow yourself to be honest about your struggles, you open the door to support you did not know was available.',
    bodyTr:
        'Zorlandığınızı kabul etmek, her şey yolundaymış gibi davranmaktan daha fazla güç gerektirir. En derin halindeki Mars arketipi, kırılganlığın gücün zıttı değil, en rafine ifadesi olduğunu anlar. Zorluklarınız hakkında dürüst olmanıza izin verdiğinizde, var olduğunu bilmediğiniz desteğin kapısını açarsınız.',
    reflectionEn:
        'Where in your life would showing vulnerability actually demonstrate strength?',
    reflectionTr:
        'Hayatınızın neresinde kırılganlık göstermek aslında güç gösterisi olurdu?',
    tagsEn: ['vulnerability', 'strength', 'honesty'],
    tagsTr: ['kırılganlık', 'güç', 'dürüstlük'],
  ),
  InsightCard(
    id: 'mars_10',
    categoryKey: 'mars',
    titleEn: 'Action as Self-Knowledge',
    titleTr: 'Öz-Bilgi Olarak Eylem',
    bodyEn:
        'You can learn things about yourself through action that reflection alone cannot reveal. Sometimes you need to act, to try, to move, before you can know what you think or feel about something. The Mars archetype reminds you that not every question can be answered by thinking harder; some questions can only be answered by doing.',
    bodyTr:
        'Yansımanın tek başına ortaya koyamayacağı şeyleri eylem yoluyla kendiniz hakkında öğrenebilirsiniz. Bazen bir şey hakkında ne düşündüğünüzü veya hissettiğinizi bilmeden önce harekete geçmeniz, denemeniz gerekir. Mars arketipi, her sorunun daha çok düşünerek cevaplanamayacağını; bazı soruların ancak yaparak cevaplanabileceğini hatırlatır.',
    reflectionEn:
        'What action taught you something about yourself that thinking alone never could have?',
    reflectionTr:
        'Hangi eylem size tek başına düşünmenin asla öğretemeyeceği bir şeyi kendiniz hakkında öğretti?',
    tagsEn: ['action', 'self-knowledge', 'experiential'],
    tagsTr: ['eylem', 'öz-bilgi', 'deneyimsel'],
  ),
  InsightCard(
    id: 'mars_11',
    categoryKey: 'mars',
    titleEn: 'Healthy Competition',
    titleTr: 'Sağlıklı Rekabet',
    bodyEn:
        'Competition becomes toxic when it is rooted in comparison and scarcity. But in its healthy form, competition can be a catalyst for excellence. It pushes you to discover capacities you did not know you had. The key is whether competition makes you shrink with envy or expand with motivation.',
    bodyTr:
        'Rekabet, karşılaştırma ve kıtlığa dayandığında toksik hale gelir. Ancak sağlıklı biçiminde rekabet, mükemmellik için bir katalizör olabilir. Sahip olduğunuzu bilmediğiniz kapasiteleri keşfetmenizi sağlar. Anahtar, rekabetin sizi kıskançlıkla küçültmesi mi yoksa motivasyonla genişletmesi midir.',
    reflectionEn:
        'When does competition bring out your best, and when does it bring out your worst?',
    reflectionTr:
        'Rekabet ne zaman en iyi yanınızı ortaya çıkarır ve ne zaman en kötü yanınızı?',
    tagsEn: ['competition', 'motivation', 'growth'],
    tagsTr: ['rekabet', 'motivasyon', 'büyüme'],
  ),
  InsightCard(
    id: 'mars_12',
    categoryKey: 'mars',
    titleEn: 'Channeling Intensity',
    titleTr: 'Yoğunluğu Kanalize Etmek',
    bodyEn:
        'Intensity is a resource, not a problem. The same fire that can burn a house down can forge a blade. The Mars archetype invites you to explore how you channel your most intense energies. Whether it is passion, frustration, or restless drive, the question is not how to reduce the intensity but how to direct it toward something that matters.',
    bodyTr:
        'Yoğunluk bir sorun değil, bir kaynaktır. Bir evi yakabilecek aynı ateş bir kılıç dövebilir. Mars arketipi, en yoğun enerjilerinizi nasıl kanalize ettiğinizi keşfetmenizi davet eder. İster tutku, ister hayal kırıklığı, ister huzursuz dürtü olsun, soru yoğunluğu nasıl azaltacağınız değil, önemli bir şeye nasıl yönlendireceğinizdir.',
    reflectionEn:
        'What intense energy do you carry that is looking for a worthy channel?',
    reflectionTr:
        'Taşıdığınız hangi yoğun enerji layık bir kanal arıyor?',
    tagsEn: ['intensity', 'channeling', 'purpose'],
    tagsTr: ['yoğunluk', 'kanalize-etme', 'amaç'],
  ),
];

// =============================================================================
// JUPITER ARCHETYPE CARDS (12)
// =============================================================================

const List<InsightCard> jupiterInsightCards = [
  InsightCard(
    id: 'jupiter_01',
    categoryKey: 'jupiter',
    titleEn: 'Expanding Your Definition of Success',
    titleTr: 'Başarı Tanımınızı Genişletmek',
    bodyEn:
        'Success is a word that carries enormous cultural weight, yet its true meaning is deeply personal. If your definition of success was written by someone else, by parents, society, or comparison, it may not fit who you actually are. The Jupiter archetype invites you to redefine success on your own terms.',
    bodyTr:
        'Başarı muazzam kültürel ağırlık taşıyan bir kelimedir, ancak gerçek anlamı derinden kişiseldir. Başarı tanımınız başka biri tarafından, ebeveynler, toplum veya karşılaştırma tarafından yazıldıysa, aslında kim olduğunuza uymayabilir. Jüpiter arketipi, başarıyı kendi koşullarınızda yeniden tanımlamanızı davet eder.',
    reflectionEn:
        'If no one were watching, what would success look like for you?',
    reflectionTr:
        'Kimse izlemeseydi, başarı sizin için neye benzerdi?',
    tagsEn: ['success', 'meaning', 'authenticity'],
    tagsTr: ['başarı', 'anlam', 'otantiklik'],
  ),
  InsightCard(
    id: 'jupiter_02',
    categoryKey: 'jupiter',
    titleEn: 'The Teacher Within',
    titleTr: 'İçinizdeki Öğretmen',
    bodyEn:
        'You already carry more wisdom than you may realize. Every experience you have navigated, every difficulty you have moved through, has left deposits of understanding in you. The Jupiter archetype suggests that you do not always need to seek wisdom externally; sometimes the most relevant teacher is the one who looks back at you in the mirror.',
    bodyTr:
        'Farkında olabileceğinizden daha fazla bilgelik taşıyorsunuz. Yönettiğiniz her deneyim, geçtiğiniz her zorluk içinizde anlayış birikimleri bırakmıştır. Jüpiter arketipi, her zaman dışarıdan bilgelik aramanız gerekmediğini; bazen en ilgili öğretmenin aynada size geri bakan kişi olduğunu önerir.',
    reflectionEn:
        'What hard-earned wisdom do you carry that you tend to undervalue?',
    reflectionTr:
        'Küçümseme eğiliminde olduğunuz hangi zor kazanılmış bilgeliği taşıyorsunuz?',
    tagsEn: ['wisdom', 'experience', 'self-trust'],
    tagsTr: ['bilgelik', 'deneyim', 'öz-güven'],
  ),
  InsightCard(
    id: 'jupiter_03',
    categoryKey: 'jupiter',
    titleEn: 'Generosity That Fills You Up',
    titleTr: 'Sizi Dolduran Cömertlik',
    bodyEn:
        'There is a form of generosity that depletes and a form that replenishes. When giving flows from genuine abundance rather than obligation or guilt, it fills the giver as much as the receiver. Paying attention to how you feel after giving can tell you whether your generosity is aligned with your well-being or working against it.',
    bodyTr:
        'Tüketen bir cömertlik biçimi ve yenileyen bir biçim vardır. Verme, zorunluluk veya suçluluktan değil, gerçek bolluktan aktığında, vereni alıcı kadar doldurur. Verdikten sonra nasıl hissettiğinize dikkat etmek, cömertliğinizin refahınızla uyumlu mu yoksa ona karşı mı çalıştığını söyleyebilir.',
    reflectionEn:
        'Think of the last time you gave something freely. Did you feel fuller or emptier afterward?',
    reflectionTr:
        'En son özgürce bir şey verdiğiniz zamanı düşünün. Sonrasında daha dolu mu yoksa daha boş mu hissettiniz?',
    tagsEn: ['generosity', 'abundance', 'well-being'],
    tagsTr: ['cömertlik', 'bolluk', 'refah'],
  ),
  InsightCard(
    id: 'jupiter_04',
    categoryKey: 'jupiter',
    titleEn: 'Finding Meaning in Difficulty',
    titleTr: 'Zorlukta Anlam Bulmak',
    bodyEn:
        'Difficult experiences are not automatically meaningful, but meaning can be created from them. The Jupiter archetype does not romanticize suffering; it recognizes your capacity to extract insight, compassion, and direction from the hardest chapters of your life. Meaning is not found in the pain itself but in what you choose to build from it.',
    bodyTr:
        'Zor deneyimler otomatik olarak anlamlı değildir, ancak onlardan anlam yaratılabilir. Jüpiter arketipi acıyı romantize etmez; hayatınızın en zor bölümlerinden içgörü, şefkat ve yön çıkarma kapasitenizi tanır. Anlam acının kendisinde değil, ondan inşa etmeyi seçtiğiniz şeyde bulunur.',
    reflectionEn:
        'What meaning have you made from a difficult experience that now serves you well?',
    reflectionTr:
        'Şimdi size iyi hizmet eden zor bir deneyimden ne anlam çıkardınız?',
    tagsEn: ['meaning', 'resilience', 'growth'],
    tagsTr: ['anlam', 'dayanıklılık', 'büyüme'],
  ),
  InsightCard(
    id: 'jupiter_05',
    categoryKey: 'jupiter',
    titleEn: 'The Horizon Effect',
    titleTr: 'Ufuk Etkisi',
    bodyEn:
        'Humans are drawn to horizons, both literal and metaphorical. The pull toward something beyond your current reach is not restlessness or dissatisfaction; it is the natural growth instinct of the psyche. The Jupiter archetype invites you to honor this pull while also appreciating the ground beneath your feet.',
    bodyTr:
        'İnsanlar hem gerçek hem de metaforik ufuklara çekilir. Mevcut erişiminizin ötesindeki bir şeye çekim, huzursuzluk veya memnuniyetsizlik değil, psikenin doğal büyüme içgüdüsüdür. Jüpiter arketipi, ayaklarınızın altındaki zemini de takdir ederken bu çekimi onurlandırmanızı davet eder.',
    reflectionEn:
        'What horizon are you drawn toward, and what is keeping you from moving in that direction?',
    reflectionTr:
        'Hangi ufka çekiliyorsunuz ve o yönde ilerlemenizi ne engelliyor?',
    tagsEn: ['aspiration', 'growth', 'vision'],
    tagsTr: ['aspirasyon', 'büyüme', 'vizyon'],
  ),
  InsightCard(
    id: 'jupiter_06',
    categoryKey: 'jupiter',
    titleEn: 'Optimism That Includes Reality',
    titleTr: 'Gerçekliği İçeren İyimserlik',
    bodyEn:
        'Shallow optimism denies difficulty. Deep optimism acknowledges it fully and still chooses to engage with life. The Jupiter archetype at its best does not promise that everything will work out; it cultivates the inner resources to navigate whatever comes. This is not positive thinking but positive being.',
    bodyTr:
        'Sığ iyimserlik zorluğu reddeder. Derin iyimserlik zorluğu tam olarak kabul eder ve yine de hayatla etkileşmeyi seçer. En iyi halindeki Jüpiter arketipi her şeyin yoluna gireceğini vaat etmez; ne gelirse gelsin yönetmek için iç kaynakları geliştirir. Bu pozitif düşünme değil, pozitif var olmadır.',
    reflectionEn:
        'Where in your life could you practice optimism that does not deny difficulty?',
    reflectionTr:
        'Hayatınızın neresinde zorluğu inkar etmeyen bir iyimserlik pratik edebilirsiniz?',
    tagsEn: ['optimism', 'realism', 'resilience'],
    tagsTr: ['iyimserlik', 'gerçekçilik', 'dayanıklılık'],
  ),
  InsightCard(
    id: 'jupiter_07',
    categoryKey: 'jupiter',
    titleEn: 'The Joy of Not Knowing',
    titleTr: 'Bilmemenin Sevinci',
    bodyEn:
        'There is a particular freedom in acknowledging how much remains unknown. When you release the pressure to have everything figured out, curiosity can return. The Jupiter archetype finds joy in the question marks of life, recognizing that mystery is not a problem to solve but a space to inhabit with wonder.',
    bodyTr:
        'Bilinmeyenlerin ne kadar çok olduğunu kabul etmekte özel bir özgürlük vardır. Her şeyi çözmüş olma baskısını bıraktığınızda merak geri gelebilir. Jüpiter arketipi, gizemin çözülecek bir problem değil, hayranlıkla içinde yaşanacak bir alan olduğunu kabul ederek hayatın soru işaretlerinde neşe bulur.',
    reflectionEn:
        'What mystery in your life could you learn to enjoy rather than solve?',
    reflectionTr:
        'Hayatınızdaki hangi gizemi çözmek yerine keyfini çıkarmayı öğrenebilirsiniz?',
    tagsEn: ['mystery', 'curiosity', 'wonder'],
    tagsTr: ['gizem', 'merak', 'hayret'],
  ),
  InsightCard(
    id: 'jupiter_08',
    categoryKey: 'jupiter',
    titleEn: 'Mentorship in Both Directions',
    titleTr: 'İki Yönlü Mentorluk',
    bodyEn:
        'Mentorship is not a one-way street. While you may seek guidance from those with more experience, you also carry insights that could illuminate someone else\'s path. The Jupiter archetype recognizes that teaching and learning are intertwined: every teacher is still a student, and every student has something to teach.',
    bodyTr:
        'Mentorluk tek yönlü bir yol değildir. Daha deneyimli olanlardan rehberlik arayabilirsiniz, ancak siz de başka birinin yolunu aydınlatabilecek içgörüler taşıyorsunuz. Jüpiter arketipi, öğretme ve öğrenmenin iç içe geçtiğini kabul eder: her öğretmen hala bir öğrencidir ve her öğrencinin öğretecek bir şeyi vardır.',
    reflectionEn:
        'Who could benefit from something you have already learned through experience?',
    reflectionTr:
        'Deneyim yoluyla zaten öğrendiğiniz bir şeyden kim faydalanabilir?',
    tagsEn: ['mentorship', 'wisdom', 'connection'],
    tagsTr: ['mentorluk', 'bilgelik', 'bağlantı'],
  ),
  InsightCard(
    id: 'jupiter_09',
    categoryKey: 'jupiter',
    titleEn: 'The Courage to Dream Bigger',
    titleTr: 'Daha Büyük Hayal Etme Cesareti',
    bodyEn:
        'Many people limit their dreams to what feels realistic, but realism is often just familiarity in disguise. The Jupiter archetype encourages you to notice where you have unconsciously shrunk your vision to fit expectations. What would you aspire to if you knew you were capable of more than you currently believe?',
    bodyTr:
        'Birçok insan hayallerini gerçekçi hissedilen şeyle sınırlar, ancak gerçekçilik genellikle kılık değiştirmiş aşinalıktır. Jüpiter arketipi, vizyonunuzu beklentilere uydurmak için bilinçsizce nerede küçülttüğünüzü fark etmenizi teşvik eder. Şu anda inandığınızdan daha fazlasına muktedir olduğunuzu bilseniz neyi hedeflerdiniz?',
    reflectionEn:
        'What dream have you been keeping small, and what would it look like at full size?',
    reflectionTr:
        'Hangi hayali küçük tutuyorsunuz ve tam boyutunda neye benzerdi?',
    tagsEn: ['dreams', 'vision', 'expansion'],
    tagsTr: ['hayaller', 'vizyon', 'genişleme'],
  ),
  InsightCard(
    id: 'jupiter_10',
    categoryKey: 'jupiter',
    titleEn: 'Travel as Inner Journey',
    titleTr: 'İç Yolculuk Olarak Seyahat',
    bodyEn:
        'Travel does not require a passport. Every new conversation, every unfamiliar book, every challenging idea is a journey to a place you have never been. The Jupiter archetype values expansion in all its forms and recognizes that the most transformative journeys often happen within the mind and heart.',
    bodyTr:
        'Seyahat pasaport gerektirmez. Her yeni konuşma, her tanıdık olmayan kitap, her zorlayıcı fikir, daha önce hiç gitmediğiniz bir yere yapılan bir yolculuktur. Jüpiter arketipi tüm biçimleriyle genişlemeye değer verir ve en dönüştürücü yolculukların genellikle zihin ve kalp içinde gerçekleştiğini kabul eder.',
    reflectionEn:
        'Where did your mind travel today that expanded your inner world?',
    reflectionTr:
        'Bugün zihniniz iç dünyanızı genişleten nereye yolculuk etti?',
    tagsEn: ['travel', 'expansion', 'learning'],
    tagsTr: ['seyahat', 'genişleme', 'öğrenme'],
  ),
  InsightCard(
    id: 'jupiter_11',
    categoryKey: 'jupiter',
    titleEn: 'Gratitude as a Practice',
    titleTr: 'Bir Pratik Olarak Şükran',
    bodyEn:
        'Gratitude is not a feeling you wait for but a lens you choose to look through. When practiced regularly, it does not make problems disappear, but it changes the context in which you hold them. The Jupiter archetype finds that consistent gratitude quietly shifts the baseline of your emotional experience upward.',
    bodyTr:
        'Şükran beklediğiniz bir duygu değil, bakma seçtiğiniz bir mercektir. Düzenli olarak pratik edildiğinde sorunları ortadan kaldırmaz, ancak onları tuttuğunuz bağlamı değiştirir. Jüpiter arketipi, tutarlı şükranın duygusal deneyiminizin temel çizgisini sessizce yukarı kaydırdığını bulur.',
    reflectionEn:
        'Name three specific things from today that you are genuinely grateful for.',
    reflectionTr:
        'Bugünden gerçekten minnettar olduğunuz üç spesifik şeyi adlandırın.',
    tagsEn: ['gratitude', 'practice', 'perspective'],
    tagsTr: ['şükran', 'pratik', 'perspektif'],
  ),
  InsightCard(
    id: 'jupiter_12',
    categoryKey: 'jupiter',
    titleEn: 'Faith in Your Own Unfolding',
    titleTr: 'Kendi Açılımınıza İnanç',
    bodyEn:
        'Not everything reveals its purpose immediately. Some experiences only make sense in retrospect, when the pieces finally click together. The Jupiter archetype cultivates patience with your own unfolding, trusting that the understanding you seek may arrive in its own time rather than on your schedule.',
    bodyTr:
        'Her şey amacını hemen ortaya koymaz. Bazı deneyimler ancak geriye bakıldığında, parçalar nihayet bir araya geldiğinde anlam kazanır. Jüpiter arketipi, aradığınız anlayışın sizin programınıza göre değil kendi zamanında gelebileceğine güvenerek, kendi açılımınızla sabır geliştirir.',
    reflectionEn:
        'What past experience only made sense to you much later, and what might that teach you about patience now?',
    reflectionTr:
        'Hangi geçmiş deneyim size çok sonra anlam kazandı ve bu size şimdi sabır hakkında ne öğretebilir?',
    tagsEn: ['patience', 'trust', 'unfolding'],
    tagsTr: ['sabır', 'güven', 'açılım'],
  ),
];

// =============================================================================
// COMBINED ACCESSOR - PART 2
// =============================================================================

/// All insight cards from Part 2 (Venus + Mars + Jupiter = 36 cards)
const List<InsightCard> insightCardsPart2 = [
  ...venusInsightCards,
  ...marsInsightCards,
  ...jupiterInsightCards,
];
