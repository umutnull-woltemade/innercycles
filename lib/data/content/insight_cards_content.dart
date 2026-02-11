/// INSIGHT CARDS CONTENT - Archetypal Reflection Cards
///
/// 120 insight cards organized by planetary archetype (12 per archetype).
/// Each card provides a unique reflective theme with bilingual content (EN/TR).
///
/// Content is designed for self-reflection only. No predictive language.
/// Apple App Store 4.3(b) compliant.
///
/// Split across multiple files for maintainability:
/// - insight_cards_content.dart (this file): class definition + Sun, Moon, Mercury cards
/// - insight_cards_content_part2.dart: Venus, Mars, Jupiter cards
/// - insight_cards_content_part3.dart: Saturn, Uranus, Neptune, Pluto cards
library;

// =============================================================================
// CONTENT DISCLAIMER
// =============================================================================

const String insightCardsDisclaimer = '''
Insight cards are reflective prompts based on archetypal themes.
They do not predict events, outcomes, or future circumstances.

Use these cards as journaling prompts and self-awareness tools.
This is not fortune-telling. It is a tool for inner reflection.
''';

// =============================================================================
// INSIGHT CARD CLASS
// =============================================================================

class InsightCard {
  final String id;
  final String categoryKey;
  final String titleEn;
  final String titleTr;
  final String bodyEn;
  final String bodyTr;
  final String reflectionEn;
  final String reflectionTr;
  final List<String> tagsEn;
  final List<String> tagsTr;

  const InsightCard({
    required this.id,
    required this.categoryKey,
    required this.titleEn,
    required this.titleTr,
    required this.bodyEn,
    required this.bodyTr,
    required this.reflectionEn,
    required this.reflectionTr,
    required this.tagsEn,
    required this.tagsTr,
  });
}

// =============================================================================
// SUN ARCHETYPE CARDS (12)
// =============================================================================

const List<InsightCard> sunInsightCards = [
  InsightCard(
    id: 'sun_01',
    categoryKey: 'sun',
    titleEn: 'The Power of Conscious Choice',
    titleTr: 'Bilinçli Seçimin Gücü',
    bodyEn:
        'When you notice recurring patterns in your decision-making, it can be a sign that deeper values are trying to surface. Rather than judging these patterns, consider them as messages from your inner wisdom. What might they be revealing about what truly matters to you?',
    bodyTr:
        'Karar alma sürecinizde tekrarlayan kalıplar fark ettiğinizde, bu daha derin değerlerin yüzeye çıkmaya çalıştığının bir işareti olabilir. Bu kalıpları yargılamak yerine, onları iç bilgeliğinizden gelen mesajlar olarak düşünebilirsiniz. Sizin için gerçekten neyin önemli olduğunu ortaya koyuyor olabilirler?',
    reflectionEn: 'What pattern in your choices have you noticed this week?',
    reflectionTr: 'Bu hafta seçimlerinizde hangi kalıbı fark ettiniz?',
    tagsEn: ['identity', 'choice', 'self-awareness'],
    tagsTr: ['kimlik', 'seçim', 'öz-farkındalık'],
  ),
  InsightCard(
    id: 'sun_02',
    categoryKey: 'sun',
    titleEn: 'Shining Without Permission',
    titleTr: 'İzin Almadan Parlamak',
    bodyEn:
        'Many people spend years waiting for external validation before allowing themselves to fully express who they are. The solar archetype reminds you that authenticity does not require an audience or approval. Your unique way of being has value simply because it is yours.',
    bodyTr:
        'Birçok insan, kim olduklarını tam olarak ifade etmeye izin vermeden önce yıllarca dışsal onay bekler. Güneş arketipi, otantikliğin bir izleyici veya onay gerektirmediğini hatırlatır. Benzersiz olma şekliniz, sadece sizin olduğu için değerlidir.',
    reflectionEn:
        'Where in your life are you still waiting for permission to be yourself?',
    reflectionTr:
        'Hayatınızın neresinde hala kendiniz olmak için izin bekliyorsunuz?',
    tagsEn: ['authenticity', 'self-expression', 'confidence'],
    tagsTr: ['otantiklik', 'kendini ifade', 'güven'],
  ),
  InsightCard(
    id: 'sun_03',
    categoryKey: 'sun',
    titleEn: 'The Quiet Center',
    titleTr: 'Sessiz Merkez',
    bodyEn:
        'At the heart of every busy day, there is a still point that remains uniquely you. This inner center does not change with circumstances or moods. It is the part of you that observes without reacting, the steady presence beneath all the noise. Learning to return to this place can be a source of profound resilience.',
    bodyTr:
        'Her yoğun günün kalbinde, benzersiz bir şekilde siz olarak kalan bir durağan nokta vardır. Bu iç merkez koşullar veya ruh halleriyle değişmez. Tepki vermeden gözlemleyen, tüm gürültünün altındaki istikrarlı varlığınızdır. Bu yere dönmeyi öğrenmek, derin bir dayanıklılık kaynağı olabilir.',
    reflectionEn:
        'When did you last feel connected to your inner stillness, even briefly?',
    reflectionTr:
        'En son ne zaman, kısa bir an bile olsa, iç durağanlığınızla bağlantı hissettiniz?',
    tagsEn: ['presence', 'identity', 'resilience'],
    tagsTr: ['mevcudiyet', 'kimlik', 'dayanıklılık'],
  ),
  InsightCard(
    id: 'sun_04',
    categoryKey: 'sun',
    titleEn: 'Creative Vitality',
    titleTr: 'Yaratıcı Canlılık',
    bodyEn:
        'Creativity is not limited to art or performance. It is present every time you bring something new into being, whether that is a conversation, a meal, a solution to a problem, or a new way of seeing an old situation. Noticing your creative acts, however small, can reconnect you to a sense of aliveness.',
    bodyTr:
        'Yaratıcılık sanat veya performansla sınırlı değildir. İster bir konuşma, ister bir yemek, bir soruna çözüm veya eski bir durumu görmenin yeni bir yolu olsun, her yeni bir şey ortaya koyduğunuzda mevcuttur. Yaratıcı eylemlerinizi ne kadar küçük olursa olsun fark etmek, sizi canlılık duygusuna yeniden bağlayabilir.',
    reflectionEn:
        'What small act of creation did you engage in today without even realizing it?',
    reflectionTr:
        'Bugün farkına bile varmadan hangi küçük yaratma eyleminde bulundunuz?',
    tagsEn: ['creativity', 'vitality', 'awareness'],
    tagsTr: ['yaratıcılık', 'canlılık', 'farkındalık'],
  ),
  InsightCard(
    id: 'sun_05',
    categoryKey: 'sun',
    titleEn: 'The Weight of Roles',
    titleTr: 'Rollerin Ağırlığı',
    bodyEn:
        'Throughout the day, you move between many roles: professional, friend, partner, caregiver, decision-maker. Each role carries its own expectations and pressures. The solar archetype invites you to notice which roles energize you and which ones feel like costumes you wear for others rather than expressions of who you truly are.',
    bodyTr:
        'Gün boyunca birçok rol arasında geçiş yaparsınız: profesyonel, arkadaş, partner, bakıcı, karar verici. Her rol kendi beklentilerini ve baskılarını taşır. Güneş arketipi, hangi rollerin size enerji verdiğini ve hangilerinin gerçek kimliğinizin ifadesi değil, başkaları için giydiğiniz kostümler gibi hissettirdiğini fark etmenizi davet eder.',
    reflectionEn:
        'Which role you played today felt most like the real you?',
    reflectionTr:
        'Bugün oynadığınız hangi rol en çok gerçek siz gibi hissettirdi?',
    tagsEn: ['identity', 'roles', 'authenticity'],
    tagsTr: ['kimlik', 'roller', 'otantiklik'],
  ),
  InsightCard(
    id: 'sun_06',
    categoryKey: 'sun',
    titleEn: 'Reclaiming Your Narrative',
    titleTr: 'Hikayenizi Geri Almak',
    bodyEn:
        'The stories you tell yourself about who you are shape your reality more than external events do. Some of these stories were written by you, while others were handed to you by family, culture, or past experiences. You may find it worthwhile to examine which stories still fit and which ones could be rewritten.',
    bodyTr:
        'Kim olduğunuz hakkında kendinize anlattığınız hikayeler, gerçekliğinizi dışsal olaylardan daha fazla şekillendirir. Bu hikayelerin bazıları sizin tarafınızdan yazılmışken, diğerleri aile, kültür veya geçmiş deneyimler tarafından size verilmiştir. Hangi hikayelerin hala uyduğunu ve hangilerinin yeniden yazılabileceğini incelemeye değer bulabilirsiniz.',
    reflectionEn:
        'What story about yourself are you ready to update or release?',
    reflectionTr:
        'Kendiniz hakkında hangi hikayeyi güncellemeye veya bırakmaya hazırsınız?',
    tagsEn: ['narrative', 'self-image', 'growth'],
    tagsTr: ['anlatı', 'benlik-imgesi', 'büyüme'],
  ),
  InsightCard(
    id: 'sun_07',
    categoryKey: 'sun',
    titleEn: 'Leadership as Listening',
    titleTr: 'Dinlemek Olarak Liderlik',
    bodyEn:
        'True leadership often begins not with speaking but with listening. The solar archetype in its most mature form understands that guiding others requires first understanding where they are. When you listen deeply, you create space for others to discover their own answers, which is perhaps the most generous form of influence.',
    bodyTr:
        'Gerçek liderlik çoğu zaman konuşmakla değil, dinlemekle başlar. En olgun halindeki güneş arketipi, başkalarına rehberlik etmenin önce onların nerede olduğunu anlamayı gerektirdiğini bilir. Derinden dinlediğinizde, başkalarının kendi cevaplarını keşfetmesi için alan yaratırsınız ki bu belki de en cömert etki biçimidir.',
    reflectionEn:
        'When was the last time you influenced someone by truly listening to them?',
    reflectionTr:
        'En son ne zaman birini gerçekten dinleyerek etkilediğiniz?',
    tagsEn: ['leadership', 'listening', 'influence'],
    tagsTr: ['liderlik', 'dinleme', 'etki'],
  ),
  InsightCard(
    id: 'sun_08',
    categoryKey: 'sun',
    titleEn: 'The Courage of Visibility',
    titleTr: 'Görünürlük Cesareti',
    bodyEn:
        'Being truly seen requires vulnerability. It means showing up as you are rather than as you think you should be. This can feel risky, yet it is also the doorway to genuine connection. Every time you allow yourself to be authentically visible, you give others quiet permission to do the same.',
    bodyTr:
        'Gerçekten görünmek kırılganlık gerektirir. Olmanız gerektiğini düşündüğünüz gibi değil, olduğunuz gibi ortaya çıkmak demektir. Bu riskli hissedebilir, ancak aynı zamanda gerçek bağlantının kapısıdır. Kendinizin otantik olarak görünmesine her izin verdiğinizde, başkalarına da aynısını yapmaları için sessiz bir izin verirsiniz.',
    reflectionEn:
        'What would change if you allowed yourself to be fully seen today?',
    reflectionTr:
        'Bugün kendinizin tamamen görünmesine izin verseniz ne değişirdi?',
    tagsEn: ['vulnerability', 'courage', 'connection'],
    tagsTr: ['kırılganlık', 'cesaret', 'bağlantı'],
  ),
  InsightCard(
    id: 'sun_09',
    categoryKey: 'sun',
    titleEn: 'Purpose Beyond Achievement',
    titleTr: 'Başarının Ötesinde Amaç',
    bodyEn:
        'Purpose and achievement are not the same thing. You can accomplish a great deal while feeling purposeless, and you can live with deep purpose without any outward markers of success. The solar archetype invites you to look past your accomplishments and ask what gives your life its sense of direction and meaning.',
    bodyTr:
        'Amaç ve başarı aynı şey değildir. Amaçsız hissederken çok şey başarabilirsiniz ve dışsal başarı göstergeleri olmadan derin bir amaçla yaşayabilirsiniz. Güneş arketipi, başarılarınızın ötesine bakmanızı ve hayatınıza yön ve anlam duygusunu neyin verdiğini sormanızı davet eder.',
    reflectionEn:
        'If all your titles and accomplishments were removed, what would remain as your purpose?',
    reflectionTr:
        'Tüm unvanlarınız ve başarılarınız kaldırılsaydı, amacınız olarak ne kalırdı?',
    tagsEn: ['purpose', 'meaning', 'identity'],
    tagsTr: ['amaç', 'anlam', 'kimlik'],
  ),
  InsightCard(
    id: 'sun_10',
    categoryKey: 'sun',
    titleEn: 'Generous Self-Expression',
    titleTr: 'Cömert Kendini İfade',
    bodyEn:
        'When you express yourself authentically, you are not taking up space that belongs to someone else. You are filling the exact space that only you can fill. Self-expression is not selfish; it is an offering. The world has a shape that only your particular light can illuminate.',
    bodyTr:
        'Kendinizi otantik olarak ifade ettiğinizde, başkasına ait bir alanı işgal etmiyorsunuz. Sadece sizin doldurabileceğiniz tam o alanı dolduruyorsunuz. Kendini ifade bencillik değildir; bir sunumdur. Dünyanın sadece sizin özel ışığınızın aydınlatabileceği bir şekli vardır.',
    reflectionEn:
        'How might your self-expression be a gift to someone around you?',
    reflectionTr:
        'Kendini ifadeniz etrafınızdaki birine nasıl bir hediye olabilir?',
    tagsEn: ['expression', 'generosity', 'authenticity'],
    tagsTr: ['ifade', 'cömertlik', 'otantiklik'],
  ),
  InsightCard(
    id: 'sun_11',
    categoryKey: 'sun',
    titleEn: 'Integrating Light and Shadow',
    titleTr: 'Işık ve Gölgeyi Bütünleştirmek',
    bodyEn:
        'The parts of yourself that you hide or deny do not disappear. They simply move underground, influencing your behavior in ways you may not recognize. The solar archetype in its fullness includes the willingness to acknowledge your shadow, not to glorify it, but to understand it as part of your complete self.',
    bodyTr:
        'Sakladığınız veya inkar ettiğiniz yanlarınız kaybolmaz. Sadece yeraltına iner ve davranışlarınızı fark etmeyebileceğiniz şekillerde etkiler. Bütünlüğündeki güneş arketipi, gölgenizi kabul etme istekliliğini içerir; onu yüceltmek için değil, tam benliğinizin bir parçası olarak anlamak için.',
    reflectionEn:
        'What part of yourself have you been avoiding that might hold valuable information?',
    reflectionTr:
        'Değerli bilgi taşıyor olabilecek hangi yanınızdan kaçınıyorsunuz?',
    tagsEn: ['shadow-work', 'self-awareness', 'integration'],
    tagsTr: ['gölge-çalışması', 'öz-farkındalık', 'bütünleşme'],
  ),
  InsightCard(
    id: 'sun_12',
    categoryKey: 'sun',
    titleEn: 'The Gift of Attention',
    titleTr: 'Dikkat Hediyesi',
    bodyEn:
        'Where you place your attention determines the quality of your experience. Like sunlight falling on a garden, your focused awareness nourishes whatever it touches. Noticing what draws your attention, and choosing where to direct it, may be one of the most powerful acts of personal agency you can practice each day.',
    bodyTr:
        'Dikkatinizi nereye yönlendirdiğiniz, deneyiminizin kalitesini belirler. Bir bahçeye düşen güneş ışığı gibi, odaklanmış farkındalığınız dokunduğu her şeyi besler. Dikkatinizi neyin çektiğini fark etmek ve onu nereye yönlendireceğinizi seçmek, her gün pratik edebileceğiniz en güçlü kişisel faillik eylemlerinden biri olabilir.',
    reflectionEn:
        'What received the most of your attention today, and was that choice intentional?',
    reflectionTr:
        'Bugün dikkatinizin çoğunu ne aldı ve bu seçim bilinçli miydi?',
    tagsEn: ['attention', 'presence', 'intentionality'],
    tagsTr: ['dikkat', 'mevcudiyet', 'niyetlilik'],
  ),
];

// =============================================================================
// MOON ARCHETYPE CARDS (12)
// =============================================================================

const List<InsightCard> moonInsightCards = [
  InsightCard(
    id: 'moon_01',
    categoryKey: 'moon',
    titleEn: 'The Language of Feelings',
    titleTr: 'Duyguların Dili',
    bodyEn:
        'Emotions are not problems to be solved but signals to be understood. Each feeling carries information about your needs, boundaries, and values. When you approach your emotional responses with curiosity rather than judgment, they become a rich source of self-knowledge.',
    bodyTr:
        'Duygular çözülmesi gereken sorunlar değil, anlaşılması gereken sinyallerdir. Her duygu ihtiyaçlarınız, sınırlarınız ve değerleriniz hakkında bilgi taşır. Duygusal tepkilerinize yargıyla değil merakla yaklaştığınızda, zengin bir öz-bilgi kaynağı haline gelirler.',
    reflectionEn:
        'What emotion surprised you today, and what need might it be pointing toward?',
    reflectionTr:
        'Bugün hangi duygu sizi şaşırttı ve hangi ihtiyaca işaret ediyor olabilir?',
    tagsEn: ['emotions', 'self-knowledge', 'needs'],
    tagsTr: ['duygular', 'öz-bilgi', 'ihtiyaçlar'],
  ),
  InsightCard(
    id: 'moon_02',
    categoryKey: 'moon',
    titleEn: 'Honoring Your Inner Tides',
    titleTr: 'İç Gelgitlerinizi Onurlandırmak',
    bodyEn:
        'Just as the ocean moves through cycles of high and low tide, your emotional energy naturally ebbs and flows. There are seasons for engagement and seasons for withdrawal, times of fullness and times of quiet. Resisting these natural rhythms often creates more suffering than the rhythm itself.',
    bodyTr:
        'Okyanusun yüksek ve alçak gelgit döngülerinden geçtiği gibi, duygusal enerjiniz de doğal olarak yükselir ve alçalır. Katılım mevsimi ve geri çekilme mevsimi, doluluk zamanları ve sessizlik zamanları vardır. Bu doğal ritimlere direnmek, çoğu zaman ritmin kendisinden daha fazla acı yaratır.',
    reflectionEn:
        'Are you in a high tide or low tide phase right now, and are you honoring that rhythm?',
    reflectionTr:
        'Şu anda yüksek gelgit mi alçak gelgit aşamasında mısınız ve bu ritmi onurlandırıyor musunuz?',
    tagsEn: ['cycles', 'self-care', 'acceptance'],
    tagsTr: ['döngüler', 'öz-bakım', 'kabul'],
  ),
  InsightCard(
    id: 'moon_03',
    categoryKey: 'moon',
    titleEn: 'The Comfort of Being Held',
    titleTr: 'Tutulmanın Huzuru',
    bodyEn:
        'There is a deep human need to feel held, whether by another person, a community, or a practice that makes you feel safe. The lunar archetype reminds you that seeking comfort is not weakness. It is a fundamental need that, when met, allows you to venture further into the world with greater courage.',
    bodyTr:
        'İster bir başka kişi, ister bir topluluk, ister sizi güvende hissettiren bir pratik tarafından olsun, tutulmuş hissetmek derin bir insan ihtiyacıdır. Ay arketipi, teselli aramanın zayıflık olmadığını hatırlatır. Karşılandığında, daha büyük cesaretle dünyaya daha uzağa çıkmanıza izin veren temel bir ihtiyaçtır.',
    reflectionEn:
        'What made you feel safe and held this week, even if it was something small?',
    reflectionTr:
        'Bu hafta küçük bir şey bile olsa ne sizi güvende ve tutulmuş hissettirdi?',
    tagsEn: ['safety', 'nurturing', 'comfort'],
    tagsTr: ['güvenlik', 'beslenme', 'konfor'],
  ),
  InsightCard(
    id: 'moon_04',
    categoryKey: 'moon',
    titleEn: 'Emotional Memory and Its Echoes',
    titleTr: 'Duygusal Hafıza ve Yankıları',
    bodyEn:
        'Your body and heart carry emotional memories that your mind may have filed away long ago. A scent, a song, or a tone of voice can unlock feelings that seem to belong to another time. These echoes are not malfunctions; they are your emotional history asking to be acknowledged and gently integrated.',
    bodyTr:
        'Bedeniniz ve kalbiniz, zihninizin çoktan dosyalamış olabileceği duygusal anıları taşır. Bir koku, bir şarkı veya bir ses tonu, başka bir zamana ait gibi görünen duyguları açabilir. Bu yankılar arıza değildir; kabul edilmeyi ve nazikçe bütünleştirilmeyi isteyen duygusal tarihinizdir.',
    reflectionEn:
        'What old feeling visited you recently, and what part of your history was it carrying?',
    reflectionTr:
        'Son zamanlarda hangi eski duygu sizi ziyaret etti ve tarihinizin hangi kısmını taşıyordu?',
    tagsEn: ['memory', 'emotions', 'healing'],
    tagsTr: ['hafıza', 'duygular', 'iyileşme'],
  ),
  InsightCard(
    id: 'moon_05',
    categoryKey: 'moon',
    titleEn: 'Nurturing Without Depleting',
    titleTr: 'Tükenmeden Beslemek',
    bodyEn:
        'The instinct to care for others is one of the most beautiful human qualities. Yet caring without boundaries can quietly drain your reserves until there is nothing left to give. The lunar archetype at its wisest understands that replenishing yourself is not selfish but necessary for sustained generosity.',
    bodyTr:
        'Başkalarına bakma içgüdüsü en güzel insan niteliklerinden biridir. Ancak sınırlar olmadan bakmak, verecek bir şey kalmayana kadar sessizce kaynaklarınızı tüketebilir. En bilge halindeki ay arketipi, kendinizi yenilemenin bencillik değil, sürdürülebilir cömertlik için gerekli olduğunu anlar.',
    reflectionEn:
        'How did you refill your own cup today so you can continue to give to others?',
    reflectionTr:
        'Bugün başkalarına vermeye devam edebilmek için kendi bardağınızı nasıl doldurdunuz?',
    tagsEn: ['boundaries', 'self-care', 'nurturing'],
    tagsTr: ['sınırlar', 'öz-bakım', 'beslenme'],
  ),
  InsightCard(
    id: 'moon_06',
    categoryKey: 'moon',
    titleEn: 'The Wisdom of Tears',
    titleTr: 'Gözyaşlarının Bilgeliği',
    bodyEn:
        'Tears are often misunderstood as weakness when they are actually a release valve for emotional pressure. Crying can mark moments of deep recognition, accumulated stress finding its way out, or beauty so striking it overwhelms the capacity for words. Allowing tears when they come is a way of honoring your emotional truth.',
    bodyTr:
        'Gözyaşları aslında duygusal baskı için bir tahliye vanası olduğu halde, çoğu zaman zayıflık olarak yanlış anlaşılır. Ağlamak, derin tanıma anlarını, çıkış yolunu bulan birikmiş stresi veya kelimelerin kapasitesini aşan çarpıcı güzelliği işaretleyebilir. Gözyaşlarına geldiklerinde izin vermek, duygusal gerçeğinizi onurlandırmanın bir yoludur.',
    reflectionEn:
        'When was the last time you allowed yourself to cry, and what did it release?',
    reflectionTr:
        'En son ne zaman kendinize ağlamanıza izin verdiniz ve ne serbest bıraktı?',
    tagsEn: ['vulnerability', 'release', 'emotional-truth'],
    tagsTr: ['kırılganlık', 'serbest-bırakma', 'duygusal-gerçek'],
  ),
  InsightCard(
    id: 'moon_07',
    categoryKey: 'moon',
    titleEn: 'The Inner Child Speaks',
    titleTr: 'İç Çocuk Konuşuyor',
    bodyEn:
        'Within every adult, there remains the child who once experienced the world with wonder, fear, and unfiltered honesty. This inner child still influences your reactions, especially in moments of stress or surprise. Listening to that younger voice with tenderness can help you understand reactions that otherwise seem disproportionate.',
    bodyTr:
        'Her yetişkinin içinde, dünyayı bir zamanlar hayranlık, korku ve filtresiz dürüstlükle deneyimleyen çocuk kalır. Bu iç çocuk, özellikle stres veya sürpriz anlarında tepkilerinizi hala etkiler. O genç sese şefkatle kulak vermek, aksi halde orantısız görünen tepkileri anlamanıza yardımcı olabilir.',
    reflectionEn:
        'What reaction did you have today that might have come from a much younger part of you?',
    reflectionTr:
        'Bugün çok daha genç bir yanınızdan gelmiş olabilecek hangi tepkiyi verdiniz?',
    tagsEn: ['inner-child', 'self-understanding', 'tenderness'],
    tagsTr: ['iç-çocuk', 'kendini-anlama', 'şefkat'],
  ),
  InsightCard(
    id: 'moon_08',
    categoryKey: 'moon',
    titleEn: 'The Safety of Solitude',
    titleTr: 'Yalnızlığın Güvenliği',
    bodyEn:
        'Solitude and loneliness are not the same. Loneliness is an ache for connection, while solitude is a chosen space where you can hear your own thoughts without the noise of others. The lunar archetype cherishes solitude as a sanctuary where emotional processing can happen undisturbed.',
    bodyTr:
        'Yalnızlık ve tek başına olma aynı şey değildir. Yalnızlık bağlantı özlemidir, tek başına olma ise başkalarının gürültüsü olmadan kendi düşüncelerinizi duyabileceğiniz seçilmiş bir alandır. Ay arketipi, tek başına olmayı duygusal işlemenin rahatsız edilmeden gerçekleşebileceği bir sığınak olarak değerlendirir.',
    reflectionEn:
        'Have you given yourself any true solitude this week, and what did you discover there?',
    reflectionTr:
        'Bu hafta kendinize gerçek bir yalnız zaman verdiniz mi ve orada ne keşfettiniz?',
    tagsEn: ['solitude', 'introspection', 'space'],
    tagsTr: ['yalnızlık', 'içe-bakış', 'alan'],
  ),
  InsightCard(
    id: 'moon_09',
    categoryKey: 'moon',
    titleEn: 'Roots and Belonging',
    titleTr: 'Kökler ve Aidiyet',
    bodyEn:
        'The sense of belonging is not always tied to a place or a family. It can be found in a practice, a community, a creative pursuit, or even in the relationship you build with yourself. The lunar archetype invites you to explore where you feel most at home and what creates that feeling.',
    bodyTr:
        'Aidiyet duygusu her zaman bir yere veya bir aileye bağlı değildir. Bir pratikte, bir toplulukta, yaratıcı bir uğraşta veya hatta kendinizle kurduğunuz ilişkide bulunabilir. Ay arketipi, kendinizi en çok nerede evinizde hissettiğinizi ve bu duyguyu neyin yarattığını keşfetmenizi davet eder.',
    reflectionEn:
        'Where do you feel most at home, and is it a place, a person, or a state of being?',
    reflectionTr:
        'Kendinizi en çok nerede evinizde hissediyorsunuz ve bu bir yer mi, bir kişi mi yoksa bir var olma hali mi?',
    tagsEn: ['belonging', 'roots', 'home'],
    tagsTr: ['aidiyet', 'kökler', 'yuva'],
  ),
  InsightCard(
    id: 'moon_10',
    categoryKey: 'moon',
    titleEn: 'Feeling Without Fixing',
    titleTr: 'Düzeltmeden Hissetmek',
    bodyEn:
        'Not every uncomfortable feeling needs to be fixed or resolved immediately. Sometimes the most healing thing you can do is simply sit with a feeling and let it be. The impulse to rush past discomfort can actually prevent the emotional processing that would bring genuine relief.',
    bodyTr:
        'Her rahatsız edici duygunun hemen düzeltilmesi veya çözülmesi gerekmez. Bazen yapabileceğiniz en iyileştirici şey, bir duyguyla oturmak ve olmasına izin vermektir. Rahatsızlığı aceleye getirme dürtüsü, aslında gerçek rahatlama getirecek duygusal işlemeyi engelleyebilir.',
    reflectionEn:
        'What feeling did you try to fix today instead of simply allowing it to pass through?',
    reflectionTr:
        'Bugün hangi duyguyu sadece geçmesine izin vermek yerine düzeltmeye çalıştınız?',
    tagsEn: ['acceptance', 'emotions', 'patience'],
    tagsTr: ['kabul', 'duygular', 'sabır'],
  ),
  InsightCard(
    id: 'moon_11',
    categoryKey: 'moon',
    titleEn: 'The Body Remembers',
    titleTr: 'Beden Hatırlar',
    bodyEn:
        'Your body often knows something before your mind catches up. A tightness in the chest, a knot in the stomach, or a sudden heaviness in the limbs can be your body communicating what your conscious mind has not yet registered. Paying attention to these physical sensations can unlock emotional awareness.',
    bodyTr:
        'Bedeniniz çoğu zaman zihniniz yetişmeden önce bir şey bilir. Göğüste bir sıkışma, midede bir düğüm veya uzuvlarda ani bir ağırlık, bilinçli zihninizin henüz kaydetmediği şeyi bedeninizin iletişimi olabilir. Bu fiziksel duyumlara dikkat etmek duygusal farkındalığın kilidini açabilir.',
    reflectionEn:
        'Where in your body did you notice tension today, and what might it have been holding?',
    reflectionTr:
        'Bugün bedeninizin neresinde gerginlik fark ettiniz ve ne tutuyor olabilir?',
    tagsEn: ['body-awareness', 'emotions', 'somatic'],
    tagsTr: ['beden-farkındalığı', 'duygular', 'somatik'],
  ),
  InsightCard(
    id: 'moon_12',
    categoryKey: 'moon',
    titleEn: 'Permission to Rest',
    titleTr: 'Dinlenme İzni',
    bodyEn:
        'In a culture that often equates worth with productivity, choosing to rest can feel like rebellion. Yet rest is not the absence of living; it is the foundation of sustainable living. The lunar archetype understands that restoration is not earned through exhaustion but practiced as a form of self-respect.',
    bodyTr:
        'Değeri üretkenlikle eşitleyen bir kültürde dinlenmeyi seçmek isyan gibi hissedebilir. Oysa dinlenme yaşamın yokluğu değil, sürdürülebilir yaşamın temelidir. Ay arketipi, restorasyon un tükenme yoluyla kazanılmadığını, öz-saygının bir biçimi olarak pratik edildiğini anlar.',
    reflectionEn:
        'Did you allow yourself true rest today, or did you rest while still feeling guilty about it?',
    reflectionTr:
        'Bugün kendinize gerçek dinlenme izni verdiniz mi, yoksa suçluluk hissederek mi dinlendiniz?',
    tagsEn: ['rest', 'self-worth', 'restoration'],
    tagsTr: ['dinlenme', 'öz-değer', 'restorasyon'],
  ),
];

// =============================================================================
// MERCURY ARCHETYPE CARDS (12)
// =============================================================================

const List<InsightCard> mercuryInsightCards = [
  InsightCard(
    id: 'mercury_01',
    categoryKey: 'mercury',
    titleEn: 'The Stories You Tell Yourself',
    titleTr: 'Kendinize Anlattığınız Hikayeler',
    bodyEn:
        'Your inner narrator is constantly crafting stories about what is happening and why. These stories feel like facts, but they are interpretations shaped by past experience and current mood. Noticing the gap between what actually happened and the story you built around it can be remarkably freeing.',
    bodyTr:
        'İç anlatıcınız sürekli olarak neler olduğu ve neden olduğu hakkında hikayeler oluşturur. Bu hikayeler gerçek gibi hisseder, ancak geçmiş deneyim ve mevcut ruh hali tarafından şekillendirilmiş yorumlardır. Gerçekte ne olduğu ile etrafında kurduğunuz hikaye arasındaki boşluğu fark etmek dikkat çekici ölçüde özgürleştirici olabilir.',
    reflectionEn:
        'What story did your mind construct today that might not be the whole truth?',
    reflectionTr:
        'Bugün zihniniz tüm gerçek olmayabilecek hangi hikayeyi oluşturdu?',
    tagsEn: ['narrative', 'perception', 'awareness'],
    tagsTr: ['anlatı', 'algı', 'farkındalık'],
  ),
  InsightCard(
    id: 'mercury_02',
    categoryKey: 'mercury',
    titleEn: 'Words as Bridges',
    titleTr: 'Köprü Olarak Kelimeler',
    bodyEn:
        'The words you choose shape not only how others understand you but how you understand yourself. Describing an experience as a "failure" creates a different inner landscape than calling it a "lesson." The Mercurial archetype invites you to notice the words you habitually use and to consider whether they reflect your truth or merely a habit.',
    bodyTr:
        'Seçtiğiniz kelimeler sadece başkalarının sizi anlama şeklini değil, kendinizi anlama şeklinizi de şekillendirir. Bir deneyimi "başarısızlık" olarak tanımlamak, onu "ders" olarak adlandırmaktan farklı bir iç manzara yaratır. Merkür arketipi, alışkanlıkla kullandığınız kelimeleri fark etmenizi ve gerçeğinizi mi yoksa sadece bir alışkanlığı mı yansıttığını düşünmenizi davet eder.',
    reflectionEn:
        'What word did you use today that shaped how you felt about a situation?',
    reflectionTr:
        'Bugün bir durumla ilgili hissetme şeklinizi şekillendiren hangi kelimeyi kullandınız?',
    tagsEn: ['language', 'self-talk', 'awareness'],
    tagsTr: ['dil', 'iç-konuşma', 'farkındalık'],
  ),
  InsightCard(
    id: 'mercury_03',
    categoryKey: 'mercury',
    titleEn: 'Listening Beyond Words',
    titleTr: 'Kelimelerin Ötesini Dinlemek',
    bodyEn:
        'Most communication happens beneath the surface of words. Tone, timing, body language, and what remains unsaid often carry more truth than the words themselves. The Mercurial archetype at its deepest teaches that genuine listening means attending to the whole message, not just the verbal content.',
    bodyTr:
        'İletişimin çoğu kelimelerin yüzeyinin altında gerçekleşir. Ton, zamanlama, beden dili ve söylenmeden kalanlar genellikle kelimelerin kendisinden daha fazla gerçek taşır. En derin halindeki Merkür arketipi, gerçek dinlemenin sadece sözlü içeriğe değil, tüm mesaja dikkat etmek anlamına geldiğini öğretir.',
    reflectionEn:
        'What did you hear today between the lines of what someone said to you?',
    reflectionTr:
        'Bugün birinin size söylediklerinin satır aralarında ne duydunuz?',
    tagsEn: ['listening', 'communication', 'perception'],
    tagsTr: ['dinleme', 'iletişim', 'algı'],
  ),
  InsightCard(
    id: 'mercury_04',
    categoryKey: 'mercury',
    titleEn: 'The Overthinking Trap',
    titleTr: 'Aşırı Düşünme Tuzağı',
    bodyEn:
        'A sharp mind is a wonderful tool, but left unchecked it can become a prison. Overthinking often disguises itself as thoroughness or responsibility, but it is usually anxiety wearing the mask of reason. Noticing when your thinking has shifted from productive to circular is the first step toward mental freedom.',
    bodyTr:
        'Keskin bir zihin harika bir araçtır, ancak kontrol edilmezse bir hapishaneye dönüşebilir. Aşırı düşünme çoğu zaman kendini titizlik veya sorumluluk olarak gizler, ancak genellikle aklın maskesini takmış kaygıdır. Düşüncenizin üretken olmaktan döngüsel olmaya ne zaman geçtiğini fark etmek, zihinsel özgürlüğe doğru ilk adımdır.',
    reflectionEn:
        'At what point today did your thinking shift from helpful to repetitive?',
    reflectionTr:
        'Bugün hangi noktada düşünceniz yardımcı olmaktan tekrarlayıcı olmaya geçti?',
    tagsEn: ['overthinking', 'mental-health', 'awareness'],
    tagsTr: ['aşırı-düşünme', 'zihinsel-sağlık', 'farkındalık'],
  ),
  InsightCard(
    id: 'mercury_05',
    categoryKey: 'mercury',
    titleEn: 'Curiosity as Compassion',
    titleTr: 'Şefkat Olarak Merak',
    bodyEn:
        'When someone does something you do not understand, your first response shapes everything that follows. Judgment closes the door; curiosity opens it. Asking "I wonder why they did that" instead of "How could they do that" is a small shift that can transform relationships and deepen your understanding of human nature.',
    bodyTr:
        'Birisi anlamadığınız bir şey yaptığında, ilk tepkiniz bundan sonraki her şeyi şekillendirir. Yargı kapıyı kapatır; merak açar. "Bunu nasıl yapabilirler" yerine "Acaba neden yaptılar" diye sormak, ilişkileri dönüştürebilecek ve insan doğası anlayışınızı derinleştirebilecek küçük bir değişimdir.',
    reflectionEn:
        'Where could curiosity have replaced judgment in one of your reactions today?',
    reflectionTr:
        'Bugünkü tepkilerinizden birinde merak yargının yerini nerede alabilirdi?',
    tagsEn: ['curiosity', 'compassion', 'judgment'],
    tagsTr: ['merak', 'şefkat', 'yargı'],
  ),
  InsightCard(
    id: 'mercury_06',
    categoryKey: 'mercury',
    titleEn: 'The Art of Asking Questions',
    titleTr: 'Soru Sorma Sanatı',
    bodyEn:
        'The quality of your questions determines the depth of your understanding. Surface questions yield surface answers. When you ask yourself deeper questions, like "What am I really afraid of here?" or "What does this situation remind me of?", you invite a different level of self-knowledge to emerge.',
    bodyTr:
        'Sorularınızın kalitesi, anlayışınızın derinliğini belirler. Yüzeysel sorular yüzeysel cevaplar verir. Kendinize "Burada gerçekten neden korkuyorum?" veya "Bu durum bana neyi hatırlatıyor?" gibi daha derin sorular sorduğunuzda, farklı bir öz-bilgi düzeyinin ortaya çıkmasını davet edersiniz.',
    reflectionEn:
        'What deeper question could you ask yourself about a situation you faced today?',
    reflectionTr:
        'Bugün karşılaştığınız bir durum hakkında kendinize hangi derin soruyu sorabilirsiniz?',
    tagsEn: ['questions', 'depth', 'self-inquiry'],
    tagsTr: ['sorular', 'derinlik', 'öz-sorgulama'],
  ),
  InsightCard(
    id: 'mercury_07',
    categoryKey: 'mercury',
    titleEn: 'Learning as Transformation',
    titleTr: 'Dönüşüm Olarak Öğrenme',
    bodyEn:
        'True learning changes you. It is not merely the accumulation of information but the reorganization of understanding. When you learn something that challenges your assumptions, the discomfort you feel is not failure but growth in progress. The Mercurial archetype honors this discomfort as a sign of real engagement.',
    bodyTr:
        'Gerçek öğrenme sizi değiştirir. Sadece bilgi birikimi değil, anlayışın yeniden düzenlenmesidir. Varsayımlarınıza meydan okuyan bir şey öğrendiğinizde, hissettiğiniz rahatsızlık başarısızlık değil, devam eden büyümedir. Merkür arketipi bu rahatsızlığı gerçek katılımın bir işareti olarak onurlandırır.',
    reflectionEn:
        'What did you learn recently that changed how you see something?',
    reflectionTr:
        'Son zamanlarda bir şeyi görme şeklinizi değiştiren ne öğrendiniz?',
    tagsEn: ['learning', 'growth', 'transformation'],
    tagsTr: ['öğrenme', 'büyüme', 'dönüşüm'],
  ),
  InsightCard(
    id: 'mercury_08',
    categoryKey: 'mercury',
    titleEn: 'The Gift of Silence',
    titleTr: 'Sessizliğin Hediyesi',
    bodyEn:
        'In conversation, silence is not emptiness but fullness. A pause allows meaning to settle, gives the other person space to go deeper, and lets your own wisdom catch up with your words. The impulse to fill every silence often comes from discomfort, but learning to let silence work can transform the quality of your connections.',
    bodyTr:
        'Konuşmada sessizlik boşluk değil, doluluktır. Bir duraklama anlamın yerleşmesine izin verir, karşı tarafa daha derine gitmesi için alan verir ve kendi bilgeliğinizin kelimelerinize yetişmesini sağlar. Her sessizliği doldurma dürtüsü çoğu zaman rahatsızlıktan gelir, ancak sessizliğin çalışmasına izin vermeyi öğrenmek bağlantılarınızın kalitesini dönüştürebilir.',
    reflectionEn:
        'When did silence feel uncomfortable today, and what might it have been making space for?',
    reflectionTr:
        'Bugün sessizlik ne zaman rahatsız hissettirdi ve neye alan açıyor olabilirdi?',
    tagsEn: ['silence', 'communication', 'presence'],
    tagsTr: ['sessizlik', 'iletişim', 'mevcudiyet'],
  ),
  InsightCard(
    id: 'mercury_09',
    categoryKey: 'mercury',
    titleEn: 'Perspective Shifting',
    titleTr: 'Perspektif Değiştirme',
    bodyEn:
        'Every situation looks different depending on where you stand. What feels like an ending from one angle may appear as a beginning from another. The Mercurial gift of perspective-shifting does not mean your original viewpoint was wrong; it means reality is richer than any single viewpoint can capture.',
    bodyTr:
        'Her durum, durduğunuz yere göre farklı görünür. Bir açıdan bitiş gibi hissedilen şey, başka bir açıdan başlangıç olarak görünebilir. Perspektif değiştirmenin Merkür hediyesi, orijinal bakış açınızın yanlış olduğu anlamına gelmez; gerçekliğin herhangi bir tek bakış açısının yakalayabileceğinden daha zengin olduğu anlamına gelir.',
    reflectionEn:
        'How might someone else see a situation that is currently troubling you?',
    reflectionTr:
        'Şu anda sizi rahatsız eden bir durumu başka biri nasıl görebilir?',
    tagsEn: ['perspective', 'flexibility', 'wisdom'],
    tagsTr: ['perspektif', 'esneklik', 'bilgelik'],
  ),
  InsightCard(
    id: 'mercury_10',
    categoryKey: 'mercury',
    titleEn: 'Writing as Discovery',
    titleTr: 'Keşif Olarak Yazma',
    bodyEn:
        'Writing is not just recording what you already know; it is a way of discovering what you think. The act of putting pen to paper, or fingers to keyboard, can reveal connections, feelings, and insights that were invisible before. You do not need to be a writer to benefit from writing. You simply need to begin.',
    bodyTr:
        'Yazmak sadece zaten bildiğiniz şeyi kaydetmek değildir; ne düşündüğünüzü keşfetmenin bir yoludur. Kalemi kağıda veya parmakları klavyeye koyma eylemi, daha önce görünmez olan bağlantıları, duyguları ve içgörüleri ortaya çıkarabilir. Yazmaktan faydalanmak için yazar olmanız gerekmez. Sadece başlamanız gerekir.',
    reflectionEn:
        'What might you discover if you wrote freely for five minutes about how you feel right now?',
    reflectionTr:
        'Şu an nasıl hissettiğiniz hakkında beş dakika serbestçe yazsanız ne keşfedebilirsiniz?',
    tagsEn: ['writing', 'journaling', 'self-discovery'],
    tagsTr: ['yazma', 'günlük-tutma', 'kendini-keşfetme'],
  ),
  InsightCard(
    id: 'mercury_11',
    categoryKey: 'mercury',
    titleEn: 'The Courage to Not Know',
    titleTr: 'Bilmeme Cesareti',
    bodyEn:
        'In a world that prizes certainty, admitting "I do not know" can feel vulnerable. Yet this honest acknowledgment opens the door to genuine learning and deeper connection. When you release the pressure to have all the answers, you create space for unexpected wisdom to arrive from sources you might not have considered.',
    bodyTr:
        'Kesinliğe değer veren bir dünyada, "bilmiyorum" demek kırılgan hissettirebilir. Ancak bu dürüst kabul, gerçek öğrenme ve daha derin bağlantı kapısını açar. Tüm cevaplara sahip olma baskısını bıraktığınızda, düşünmeyebileceğiniz kaynaklardan beklenmedik bilgeliğin gelmesi için alan yaratırsınız.',
    reflectionEn:
        'Where in your life would admitting "I do not know" actually be a relief?',
    reflectionTr:
        'Hayatınızın neresinde "bilmiyorum" demek aslında bir rahatlama olurdu?',
    tagsEn: ['humility', 'learning', 'openness'],
    tagsTr: ['alçakgönüllülük', 'öğrenme', 'açıklık'],
  ),
  InsightCard(
    id: 'mercury_12',
    categoryKey: 'mercury',
    titleEn: 'Thought Patterns as Weather',
    titleTr: 'Hava Durumu Olarak Düşünce Kalıpları',
    bodyEn:
        'Your thoughts are not permanent fixtures but passing weather patterns. A stormy thought does not mean you live in a storm. An anxious thought does not make you an anxious person. When you observe your thoughts as weather moving across the sky of your mind, you begin to identify less with their content and more with the awareness that notices them.',
    bodyTr:
        'Düşünceleriniz kalıcı sabitler değil, geçici hava kalıplarıdır. Fırtınalı bir düşünce, bir fırtınada yaşadığınız anlamına gelmez. Kaygılı bir düşünce sizi kaygılı bir kişi yapmaz. Düşüncelerinizi zihninizin gökyüzünde hareket eden hava durumu olarak gözlemlediğinizde, içerikleriyle daha az ve onları fark eden farkındalıkla daha çok özdeşleşmeye başlarsınız.',
    reflectionEn:
        'What was the weather like in your mind today, and were you the weather or the sky?',
    reflectionTr:
        'Bugün zihninizde hava durumu nasıldı ve siz hava mıydınız yoksa gökyüzü mü?',
    tagsEn: ['mindfulness', 'thoughts', 'detachment'],
    tagsTr: ['farkındalık', 'düşünceler', 'ayrışma'],
  ),
];

// =============================================================================
// COMBINED ACCESSOR - PART 1
// =============================================================================

/// All insight cards from Part 1 (Sun + Moon + Mercury = 36 cards)
const List<InsightCard> insightCardsPart1 = [
  ...sunInsightCards,
  ...moonInsightCards,
  ...mercuryInsightCards,
];
