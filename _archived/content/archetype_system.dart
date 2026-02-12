/// ARCHETYPE SYSTEM - Complete Archetypal Hierarchy for Self-Reflection
///
/// Defines the full archetype framework: planetary, elemental, and modal categories.
/// Each archetype includes bilingual (EN/TR) descriptions, themes, strengths,
/// growth areas, and daily reflection prompts.
///
/// Content is designed for self-reflection and personal exploration only.
/// No predictive language. Apple App Store 4.3(b) compliant.
library;

// =============================================================================
// CONTENT DISCLAIMER
// =============================================================================

const String archetypeSystemDisclaimer = '''
Archetypes are symbolic patterns found across cultures and traditions.
They do not predict behavior, events, or outcomes.

These descriptions are frameworks for self-exploration and journaling.
They are not scientific personality assessments.

This is not fortune-telling. It is a tool for inner reflection.
''';

// =============================================================================
// ARCHETYPE CATEGORIES
// =============================================================================

enum ArchetypeCategory {
  planetary,
  elemental,
  modal,
}

// =============================================================================
// PLANETARY ARCHETYPES
// =============================================================================

enum PlanetaryArchetype {
  sun(
    nameEn: 'Sun',
    nameTr: 'Güneş',
    symbol: '☉',
    themeEn: 'Identity & Creative Self-Expression',
    themeTr: 'Kimlik ve Yaratıcı Kendini İfade',
    elementAffinity: ElementalArchetype.fire,
  ),
  moon(
    nameEn: 'Moon',
    nameTr: 'Ay',
    symbol: '☽',
    themeEn: 'Emotions & Inner World',
    themeTr: 'Duygular ve İç Dünya',
    elementAffinity: ElementalArchetype.water,
  ),
  mercury(
    nameEn: 'Mercury',
    nameTr: 'Merkür',
    symbol: '☿',
    themeEn: 'Communication & Thought Patterns',
    themeTr: 'İletişim ve Düşünce Kalıpları',
    elementAffinity: ElementalArchetype.air,
  ),
  venus(
    nameEn: 'Venus',
    nameTr: 'Venüs',
    symbol: '♀',
    themeEn: 'Values & Relationships',
    themeTr: 'Değerler ve İlişkiler',
    elementAffinity: ElementalArchetype.earth,
  ),
  mars(
    nameEn: 'Mars',
    nameTr: 'Mars',
    symbol: '♂',
    themeEn: 'Drive & Assertive Energy',
    themeTr: 'Motivasyon ve Kararlı Enerji',
    elementAffinity: ElementalArchetype.fire,
  ),
  jupiter(
    nameEn: 'Jupiter',
    nameTr: 'Jüpiter',
    symbol: '♃',
    themeEn: 'Growth & Expansion of Meaning',
    themeTr: 'Büyüme ve Anlamın Genişlemesi',
    elementAffinity: ElementalArchetype.fire,
  ),
  saturn(
    nameEn: 'Saturn',
    nameTr: 'Satürn',
    symbol: '♄',
    themeEn: 'Structure & Personal Responsibility',
    themeTr: 'Yapı ve Kişisel Sorumluluk',
    elementAffinity: ElementalArchetype.earth,
  ),
  uranus(
    nameEn: 'Uranus',
    nameTr: 'Uranüs',
    symbol: '♅',
    themeEn: 'Innovation & Authentic Freedom',
    themeTr: 'Yenilik ve Otantik Özgürlük',
    elementAffinity: ElementalArchetype.air,
  ),
  neptune(
    nameEn: 'Neptune',
    nameTr: 'Neptün',
    symbol: '♆',
    themeEn: 'Imagination & Spiritual Sensitivity',
    themeTr: 'Hayal Gücü ve Ruhani Duyarlılık',
    elementAffinity: ElementalArchetype.water,
  ),
  pluto(
    nameEn: 'Pluto',
    nameTr: 'Plüton',
    symbol: '♇',
    themeEn: 'Transformation & Deep Renewal',
    themeTr: 'Dönüşüm ve Derin Yenilenme',
    elementAffinity: ElementalArchetype.water,
  );

  final String nameEn;
  final String nameTr;
  final String symbol;
  final String themeEn;
  final String themeTr;
  final ElementalArchetype elementAffinity;

  const PlanetaryArchetype({
    required this.nameEn,
    required this.nameTr,
    required this.symbol,
    required this.themeEn,
    required this.themeTr,
    required this.elementAffinity,
  });
}

// =============================================================================
// ELEMENTAL ARCHETYPES
// =============================================================================

enum ElementalArchetype {
  fire(
    nameEn: 'Fire',
    nameTr: 'Ateş',
    qualityEn: 'Passionate, dynamic, and action-oriented energy that sparks initiative and fuels creative vision.',
    qualityTr: 'Tutkulu, dinamik ve eylem odaklı enerji; inisiyatif kıvılcımını çakar ve yaratıcı vizyonu besler.',
  ),
  earth(
    nameEn: 'Earth',
    nameTr: 'Toprak',
    qualityEn: 'Grounded, patient, and resourceful energy that builds lasting foundations and honors the physical world.',
    qualityTr: 'Köklü, sabırlı ve becerikli enerji; kalıcı temeller inşa eder ve fiziksel dünyayı onurlandırır.',
  ),
  air(
    nameEn: 'Air',
    nameTr: 'Hava',
    qualityEn: 'Curious, communicative, and intellectually agile energy that connects ideas and bridges perspectives.',
    qualityTr: 'Meraklı, iletişimsel ve entelektüel olarak çevik enerji; fikirleri birbirine bağlar ve bakış açılarını köprüler.',
  ),
  water(
    nameEn: 'Water',
    nameTr: 'Su',
    qualityEn: 'Intuitive, empathic, and emotionally deep energy that nurtures compassion and inner knowing.',
    qualityTr: 'Sezgisel, empatik ve duygusal derinliği olan enerji; şefkati ve içsel bilgeliği besler.',
  );

  final String nameEn;
  final String nameTr;
  final String qualityEn;
  final String qualityTr;

  const ElementalArchetype({
    required this.nameEn,
    required this.nameTr,
    required this.qualityEn,
    required this.qualityTr,
  });
}

// =============================================================================
// MODAL ARCHETYPES
// =============================================================================

enum ModalArchetype {
  cardinal(
    nameEn: 'Cardinal',
    nameTr: 'Öncü',
    descEn: 'Cardinal energy initiates change and sets new directions. It is the spark that begins every cycle, thriving on fresh starts and the courage to step into uncharted territory.',
    descTr: 'Öncü enerji değişimi başlatır ve yeni yönler belirler. Her döngüyü başlatan kıvılcımdır; taze başlangıçlarda ve keşfedilmemiş alanlara adım atma cesaretinde gelişir.',
  ),
  fixed(
    nameEn: 'Fixed',
    nameTr: 'Sabit',
    descEn: 'Fixed energy sustains and deepens what has already begun. It provides the determination and focus needed to see things through, building resilience in the process.',
    descTr: 'Sabit enerji, başlamış olanı sürdürür ve derinleştirir. İşleri sonuna kadar götürmek için gereken kararlılığı ve odaklanmayı sağlar, bu süreçte dayanıklılık inşa eder.',
  ),
  mutable(
    nameEn: 'Mutable',
    nameTr: 'Değişken',
    descEn: 'Mutable energy adapts and transforms. It is the wisdom of flexibility, the ability to integrate experiences and prepare for what comes next with grace and openness.',
    descTr: 'Değişken enerji uyum sağlar ve dönüştürür. Esnekliğin bilgeliğidir; deneyimleri bütünleştirme ve bir sonrakine zarafet ve açıklıkla hazırlanma yeteneğidir.',
  );

  final String nameEn;
  final String nameTr;
  final String descEn;
  final String descTr;

  const ModalArchetype({
    required this.nameEn,
    required this.nameTr,
    required this.descEn,
    required this.descTr,
  });
}

// =============================================================================
// ARCHETYPE PROFILE
// =============================================================================

class ArchetypeProfile {
  final dynamic archetype; // PlanetaryArchetype, ElementalArchetype, or ModalArchetype
  final String descriptionEn;
  final String descriptionTr;
  final List<String> coreThemesEn;
  final List<String> coreThemesTr;
  final List<String> strengthsEn;
  final List<String> strengthsTr;
  final List<String> growthAreasEn;
  final List<String> growthAreasTr;
  final String dailyReflectionEn;
  final String dailyReflectionTr;

  const ArchetypeProfile({
    required this.archetype,
    required this.descriptionEn,
    required this.descriptionTr,
    required this.coreThemesEn,
    required this.coreThemesTr,
    required this.strengthsEn,
    required this.strengthsTr,
    required this.growthAreasEn,
    required this.growthAreasTr,
    required this.dailyReflectionEn,
    required this.dailyReflectionTr,
  });
}

// =============================================================================
// FULL ARCHETYPE PROFILES - PLANETARY (10)
// =============================================================================

const List<ArchetypeProfile> planetaryProfiles = [
  // ── SUN ──
  ArchetypeProfile(
    archetype: PlanetaryArchetype.sun,
    descriptionEn:
        'The Sun archetype represents the core of personal identity and creative self-expression. '
        'Those who resonate with solar energy often find themselves drawn to leadership, authenticity, '
        'and the pursuit of purpose. This archetype invites you to explore what makes you feel most '
        'alive and how you share your unique light with the world. When the Sun theme is active in '
        'your reflections, consider how your sense of self shapes the choices you make each day.',
    descriptionTr:
        'Güneş arketipi, kişisel kimliğin özünü ve yaratıcı kendini ifadeyi temsil eder. '
        'Güneş enerjisiyle rezonansa girenler genellikle liderlik, otantiklik ve amaç arayışına '
        'çekilir. Bu arketip, sizi en çok neyin canlı hissettirdiğini ve benzersiz ışığınızı '
        'dünyayla nasıl paylaştığınızı keşfetmeye davet eder. Güneş teması yansımalarınızda '
        'aktif olduğunda, benlik duygunuzun her gün yaptığınız seçimleri nasıl şekillendirdiğini '
        'düşünebilirsiniz.',
    coreThemesEn: [
      'Personal identity and sense of self',
      'Creative self-expression and vitality',
      'Leadership through authenticity',
      'The courage to be seen as you truly are',
      'Finding and following your core purpose',
    ],
    coreThemesTr: [
      'Kişisel kimlik ve benlik duygusu',
      'Yaratıcı kendini ifade ve canlılık',
      'Otantiklik yoluyla liderlik',
      'Gerçek halinizle görünme cesareti',
      'Temel amacınızı bulma ve takip etme',
    ],
    strengthsEn: [
      'Natural ability to inspire and energize others',
      'Strong connection to personal authenticity',
      'Creative confidence and expressive warmth',
      'Resilient sense of identity even under pressure',
    ],
    strengthsTr: [
      'Başkalarını ilham verme ve enerjilendirme yeteneği',
      'Kişisel otantiklikle güçlü bağ',
      'Yaratıcı özgüven ve ifade edici sıcaklık',
      'Baskı altında bile dayanıklı kimlik duygusu',
    ],
    growthAreasEn: [
      'Allowing others to shine without feeling diminished',
      'Distinguishing between ego needs and authentic expression',
      'Learning to rest without feeling unproductive',
    ],
    growthAreasTr: [
      'Küçüldüğünü hissetmeden başkalarının parlamasına izin verme',
      'Ego ihtiyaçları ile otantik ifade arasındaki farkı ayırt etme',
      'Verimsiz hissetmeden dinlenmeyi öğrenme',
    ],
    dailyReflectionEn:
        'What part of yourself did you express most fully today, and what part remained hidden?',
    dailyReflectionTr:
        'Bugün kendinizin hangi yönünü en tam şekilde ifade ettiniz ve hangi yönü gizli kaldı?',
  ),

  // ── MOON ──
  ArchetypeProfile(
    archetype: PlanetaryArchetype.moon,
    descriptionEn:
        'The Moon archetype holds the emotional landscape of the inner world. It speaks to the '
        'instinctive responses, deep feelings, and nurturing patterns that shape how you process '
        'experience. Those drawn to lunar themes may find comfort in introspection and emotional '
        'honesty. This archetype encourages you to honor your inner tides rather than override '
        'them, recognizing that emotional intelligence is a form of profound wisdom.',
    descriptionTr:
        'Ay arketipi, iç dünyanın duygusal manzarasını taşır. İçgüdüsel tepkilerden, derin '
        'duygulardan ve deneyimleri nasıl işlediğinizi şekillendiren besleyici kalıplardan '
        'bahseder. Ay temalarına çekilenler içe bakış ve duygusal dürüstlükte teselli bulabilir. '
        'Bu arketip, iç gelgitlerinizi bastırmak yerine onurlandırmanızı teşvik eder ve duygusal '
        'zekayı derin bir bilgelik biçimi olarak tanır.',
    coreThemesEn: [
      'Emotional depth and inner sensitivity',
      'Nurturing self and others with compassion',
      'Honoring instinctive responses and gut feelings',
      'The rhythm of emotional cycles',
      'Memory, belonging, and emotional roots',
    ],
    coreThemesTr: [
      'Duygusal derinlik ve iç duyarlılık',
      'Kendine ve başkalarına şefkatle bakma',
      'İçgüdüsel tepkileri ve sezgileri onurlandırma',
      'Duygusal döngülerin ritmi',
      'Hafıza, aidiyet ve duygusal kökler',
    ],
    strengthsEn: [
      'Deep empathy and emotional attunement',
      'Ability to create safe and nourishing spaces',
      'Intuitive understanding of unspoken needs',
      'Remarkable emotional memory and depth',
    ],
    strengthsTr: [
      'Derin empati ve duygusal uyum',
      'Güvenli ve besleyici alanlar yaratma yeteneği',
      'Söylenmemiş ihtiyaçları sezgisel anlama',
      'Dikkat çekici duygusal hafıza ve derinlik',
    ],
    growthAreasEn: [
      'Setting boundaries without guilt or self-blame',
      'Letting go of past emotional imprints that no longer serve you',
      'Trusting your emotional truth even when it is unpopular',
    ],
    growthAreasTr: [
      'Suçluluk veya öz-suçlama olmadan sınır koyma',
      'Artık size hizmet etmeyen geçmiş duygusal izleri bırakma',
      'Popüler olmasa bile duygusal gerçeğinize güvenme',
    ],
    dailyReflectionEn:
        'What emotion visited you most today, and what might it be trying to tell you?',
    dailyReflectionTr:
        'Bugün sizi en çok hangi duygu ziyaret etti ve size ne söylemeye çalışıyor olabilir?',
  ),

  // ── MERCURY ──
  ArchetypeProfile(
    archetype: PlanetaryArchetype.mercury,
    descriptionEn:
        'The Mercury archetype governs the realm of the mind: how you think, communicate, and '
        'make sense of the world. It is the inner translator that weaves observations into '
        'understanding. Those who resonate with Mercurial energy often enjoy learning, wordplay, '
        'and the exchange of ideas. This archetype invites you to notice how your thought patterns '
        'shape your perception and to explore the difference between information and wisdom.',
    descriptionTr:
        'Merkür arketipi zihin alanını yönetir: nasıl düşündüğünüzü, iletişim kurduğunuzu ve '
        'dünyayı nasıl anlamlandırdığınızı. Gözlemleri anlayışa dönüştüren iç tercümandır. '
        'Merkür enerjisiyle rezonansa girenler genellikle öğrenmekten, kelime oyunlarından ve '
        'fikir alışverişinden keyif alır. Bu arketip, düşünce kalıplarınızın algınızı nasıl '
        'şekillendirdiğini fark etmeye ve bilgi ile bilgelik arasındaki farkı keşfetmeye davet eder.',
    coreThemesEn: [
      'Clarity of thought and articulate expression',
      'The art of listening as much as speaking',
      'Curiosity as a path to self-understanding',
      'Patterns of mental chatter and inner dialogue',
      'The bridge between logic and intuition',
    ],
    coreThemesTr: [
      'Düşünce netliği ve açık ifade',
      'Konuşmak kadar dinleme sanatı',
      'Kendini anlamanın yolu olarak merak',
      'Zihinsel gevezelik ve iç diyalog kalıpları',
      'Mantık ile sezgi arasındaki köprü',
    ],
    strengthsEn: [
      'Quick and adaptive thinking under changing conditions',
      'Gift for translating complex ideas into accessible language',
      'Natural mediator who sees multiple sides of a situation',
      'Endless curiosity that keeps growth alive',
    ],
    strengthsTr: [
      'Değişen koşullarda hızlı ve uyarlanabilir düşünme',
      'Karmaşık fikirleri erişilebilir dile çevirme yeteneği',
      'Bir durumun birden fazla yönünü gören doğal arabulucu',
      'Büyümeyi canlı tutan sonsuz merak',
    ],
    growthAreasEn: [
      'Stilling the mind long enough to hear deeper knowing',
      'Moving from overthinking to embodied action',
      'Allowing silence to be as informative as words',
    ],
    growthAreasTr: [
      'Daha derin bilgiyi duyacak kadar zihni sakinleştirme',
      'Aşırı düşünmekten bedensel eyleme geçme',
      'Sessizliğin kelimeler kadar bilgilendirici olmasına izin verme',
    ],
    dailyReflectionEn:
        'What story did your mind tell you today, and how did it shape your experience?',
    dailyReflectionTr:
        'Bugün zihniniz size hangi hikayeyi anlattı ve bu deneyiminizi nasıl şekillendirdi?',
  ),

  // ── VENUS ──
  ArchetypeProfile(
    archetype: PlanetaryArchetype.venus,
    descriptionEn:
        'The Venus archetype embodies what you value, how you connect, and where you find beauty. '
        'It is not only about romantic love but about every form of attraction and appreciation '
        'that gives life its sweetness. Those who carry strong Venusian themes often have a refined '
        'aesthetic sense and a deep need for harmony. This archetype asks you to consider what you '
        'truly cherish and whether your daily life reflects those values.',
    descriptionTr:
        'Venüs arketipi, neye değer verdiğinizi, nasıl bağ kurduğunuzu ve güzelliği nerede '
        'bulduğunuzu somutlaştırır. Sadece romantik aşkla değil, hayata tatlılığını veren her '
        'türlü çekim ve takdirle ilgilidir. Güçlü Venüs temaları taşıyanlar genellikle rafine '
        'bir estetik anlayışa ve derin bir uyum ihtiyacına sahiptir. Bu arketip, gerçekten neye '
        'değer verdiğinizi ve günlük yaşamınızın bu değerleri yansıtıp yansıtmadığını '
        'düşünmenizi ister.',
    coreThemesEn: [
      'Personal values and what truly matters to you',
      'The quality of connection in your relationships',
      'Beauty as a reflection of inner harmony',
      'Giving and receiving with an open heart',
      'Self-worth beyond external validation',
    ],
    coreThemesTr: [
      'Kişisel değerler ve sizin için gerçekten neyin önemli olduğu',
      'İlişkilerinizdeki bağlantının kalitesi',
      'İç uyumun yansıması olarak güzellik',
      'Açık bir kalple verme ve alma',
      'Dışsal onayın ötesinde öz-değer',
    ],
    strengthsEn: [
      'Ability to create beauty and harmony in any environment',
      'Deep capacity for genuine connection and compassion',
      'Natural sense of fairness and diplomacy',
      'Gift for recognizing value in people and experiences',
    ],
    strengthsTr: [
      'Her ortamda güzellik ve uyum yaratma yeteneği',
      'Gerçek bağlantı ve şefkat için derin kapasite',
      'Doğal adalet duygusu ve diplomasi',
      'İnsanlarda ve deneyimlerde değeri tanıma yeteneği',
    ],
    growthAreasEn: [
      'Speaking your truth even when it disrupts harmony',
      'Recognizing that self-worth comes from within, not from being needed',
      'Allowing imperfection to coexist with beauty',
    ],
    growthAreasTr: [
      'Uyumu bozsa bile gerçeğinizi söyleme',
      'Öz-değerin ihtiyaç duyulmaktan değil, içten geldiğini fark etme',
      'Kusurluluğun güzellikle bir arada var olmasına izin verme',
    ],
    dailyReflectionEn:
        'What did you find beautiful today, and what does that choice reveal about your values?',
    dailyReflectionTr:
        'Bugün neyi güzel buldunuz ve bu seçim değerleriniz hakkında ne ortaya koyuyor?',
  ),

  // ── MARS ──
  ArchetypeProfile(
    archetype: PlanetaryArchetype.mars,
    descriptionEn:
        'The Mars archetype represents the drive to act, compete, and assert your will in the '
        'world. It is raw energy channeled through intention, the inner fire that motivates you '
        'to pursue what you want. Those with active Mars themes often have a direct approach to '
        'challenges and a strong sense of personal agency. This archetype invites you to explore '
        'the difference between reactive anger and conscious assertiveness.',
    descriptionTr:
        'Mars arketipi, dünyada harekete geçme, rekabet etme ve iradenizi ortaya koyma dürtüsünü '
        'temsil eder. Niyet yoluyla kanalize edilen ham enerjidir; istediğinizi takip etmeniz '
        'için sizi motive eden iç ateş. Aktif Mars temaları olanlar genellikle zorluklara doğrudan '
        'yaklaşır ve güçlü bir kişisel faillik duygusuna sahiptir. Bu arketip, tepkisel öfke ile '
        'bilinçli atılganlık arasındaki farkı keşfetmeye davet eder.',
    coreThemesEn: [
      'Taking initiative and honoring your desires',
      'The healthy expression of anger and frustration',
      'Courage to face conflict directly and honestly',
      'Physical vitality and embodied energy',
      'Competition as a mirror for self-knowledge',
    ],
    coreThemesTr: [
      'İnisiyatif alma ve arzularınızı onurlandırma',
      'Öfke ve hayal kırıklığının sağlıklı ifadesi',
      'Çatışmayla doğrudan ve dürüstçe yüzleşme cesareti',
      'Fiziksel canlılık ve bedensel enerji',
      'Öz-bilgi aynası olarak rekabet',
    ],
    strengthsEn: [
      'Ability to take decisive action when needed',
      'Powerful motivation and follow-through',
      'Courage to defend your boundaries and values',
      'Physical energy and capacity for hard work',
    ],
    strengthsTr: [
      'Gerektiğinde kararlı adım atma yeteneği',
      'Güçlü motivasyon ve sonuca kadar götürme',
      'Sınırlarınızı ve değerlerinizi savunma cesareti',
      'Fiziksel enerji ve zorlu çalışma kapasitesi',
    ],
    growthAreasEn: [
      'Pausing between impulse and action to check alignment',
      'Channeling intensity into constructive rather than destructive expression',
      'Accepting vulnerability as a form of strength',
    ],
    growthAreasTr: [
      'Dürtü ve eylem arasında durarak uyumu kontrol etme',
      'Yoğunluğu yıkıcı değil yapıcı ifadeye kanalize etme',
      'Kırılganlığı bir güç biçimi olarak kabul etme',
    ],
    dailyReflectionEn:
        'Where did you feel the strongest pull to act today, and did that action align with your deeper values?',
    dailyReflectionTr:
        'Bugün en güçlü harekete geçme dürtüsünü nerede hissettiniz ve bu eylem derin değerlerinizle uyumlu muydu?',
  ),

  // ── JUPITER ──
  ArchetypeProfile(
    archetype: PlanetaryArchetype.jupiter,
    descriptionEn:
        'The Jupiter archetype carries the impulse to grow, to seek meaning, and to expand beyond '
        'current limits. It is the part of you that reaches for something larger, whether through '
        'learning, travel, philosophy, or faith. Those with strong Jupiterian themes often feel '
        'a calling to understand the big picture and to share their insights generously. This '
        'archetype asks you to reflect on what gives your life a sense of meaning and abundance.',
    descriptionTr:
        'Jüpiter arketipi, büyüme, anlam arayışı ve mevcut sınırların ötesine genişleme '
        'dürtüsünü taşır. İster öğrenme, ister seyahat, felsefe veya inanç yoluyla olsun, daha '
        'büyük bir şeye uzanan yanınızdır. Güçlü Jüpiter temaları olanlar genellikle büyük '
        'resmi anlama ve içgörülerini cömertçe paylaşma çağrısı hisseder. Bu arketip, hayatınıza '
        'anlam ve bolluk duygusunu neyin verdiğini yansıtmanızı ister.',
    coreThemesEn: [
      'The search for meaning and philosophical truth',
      'Generosity of spirit and expansive vision',
      'Learning as a lifelong source of joy',
      'Optimism grounded in experience, not denial',
      'The balance between expansion and excess',
    ],
    coreThemesTr: [
      'Anlam ve felsefi gerçek arayışı',
      'Ruh cömertliği ve geniş vizyon',
      'Yaşam boyu bir neşe kaynağı olarak öğrenme',
      'İnkar değil, deneyime dayalı iyimserlik',
      'Genişleme ve aşırılık arasındaki denge',
    ],
    strengthsEn: [
      'Ability to find opportunity in challenging circumstances',
      'Contagious enthusiasm that lifts the spirits of others',
      'Broad perspective that connects disparate ideas',
      'Natural generosity and willingness to mentor',
    ],
    strengthsTr: [
      'Zorlu koşullarda fırsat bulma yeteneği',
      'Başkalarının moralini yükselten bulaşıcı coşku',
      'Farklı fikirleri birbirine bağlayan geniş perspektif',
      'Doğal cömertlik ve mentorluk istekliliği',
    ],
    growthAreasEn: [
      'Knowing when enough is truly enough',
      'Grounding big visions in practical steps',
      'Listening to details instead of always reaching for the horizon',
    ],
    growthAreasTr: [
      'Yeterliliğin gerçekten ne zaman yeterli olduğunu bilme',
      'Büyük vizyonları pratik adımlara temellendirme',
      'Her zaman ufka ulaşmak yerine ayrıntılara kulak verme',
    ],
    dailyReflectionEn:
        'What expanded your perspective today, and how might that new understanding serve you?',
    dailyReflectionTr:
        'Bugün perspektifinizi ne genişletti ve bu yeni anlayış size nasıl hizmet edebilir?',
  ),

  // ── SATURN ──
  ArchetypeProfile(
    archetype: PlanetaryArchetype.saturn,
    descriptionEn:
        'The Saturn archetype is the inner architect: the part of you that builds structures, '
        'sets boundaries, and earns mastery through patient effort. It may feel demanding, but it '
        'is also the source of your deepest integrity and lasting accomplishments. Those who engage '
        'honestly with Saturnian themes often develop remarkable resilience. This archetype invites '
        'you to consider where discipline has served you and where it has become rigidity.',
    descriptionTr:
        'Satürn arketipi iç mimardır: yapılar inşa eden, sınırlar koyan ve sabırlı çabayla '
        'ustalık kazanan yanınız. Talepkar hissedilebilir, ancak en derin bütünlüğünüzün ve '
        'kalıcı başarılarınızın da kaynağıdır. Satürn temalarıyla dürüstçe ilişki kuranlar '
        'genellikle dikkat çekici bir dayanıklılık geliştirir. Bu arketip, disiplinin size '
        'nerede hizmet ettiğini ve nerede katılığa dönüştüğünü düşünmenizi davet eder.',
    coreThemesEn: [
      'Personal responsibility and mature self-governance',
      'Building structures that support long-term growth',
      'The wisdom that comes from working through difficulty',
      'Healthy boundaries as an act of self-respect',
      'Time as an ally rather than an enemy',
    ],
    coreThemesTr: [
      'Kişisel sorumluluk ve olgun öz-yönetim',
      'Uzun vadeli büyümeyi destekleyen yapılar inşa etme',
      'Zorlukların üstesinden gelmekten gelen bilgelik',
      'Öz-saygının bir eylemi olarak sağlıklı sınırlar',
      'Düşman değil, müttefik olarak zaman',
    ],
    strengthsEn: [
      'Capacity for sustained effort and long-term commitment',
      'Reliable and trustworthy presence others can depend on',
      'Practical wisdom earned through real experience',
      'Strong sense of personal ethics and accountability',
    ],
    strengthsTr: [
      'Sürekli çaba ve uzun vadeli bağlılık kapasitesi',
      'Başkalarının güvenebileceği güvenilir varlık',
      'Gerçek deneyimle kazanılmış pratik bilgelik',
      'Güçlü kişisel etik ve hesap verebilirlik duygusu',
    ],
    growthAreasEn: [
      'Allowing yourself pleasure without needing to earn it first',
      'Releasing the belief that you must carry everything alone',
      'Embracing imperfection as part of the human experience',
    ],
    growthAreasTr: [
      'Önce hak etmeniz gerekmeden kendinize keyif verme',
      'Her şeyi tek başınıza taşımanız gerektiği inancını bırakma',
      'Kusursuzluğu insan deneyiminin bir parçası olarak kucaklama',
    ],
    dailyReflectionEn:
        'What commitment did you honor today, and what did that effort teach you about yourself?',
    dailyReflectionTr:
        'Bugün hangi taahhüdünüzü onurlandırdınız ve bu çaba size kendiniz hakkında ne öğretti?',
  ),

  // ── URANUS ──
  ArchetypeProfile(
    archetype: PlanetaryArchetype.uranus,
    descriptionEn:
        'The Uranus archetype represents the longing for freedom, originality, and the courage '
        'to break with convention when convention no longer serves truth. It is the inner rebel '
        'and the visionary, the part of you that refuses to conform simply for the sake of comfort. '
        'Those with prominent Uranian themes may feel like outsiders who carry insights the '
        'mainstream has not yet caught up with. This archetype asks where authentic individuality '
        'ends and mere contrarianism begins.',
    descriptionTr:
        'Uranüs arketipi, özgürlük, özgünlük ve gelenek artık gerçeğe hizmet etmediğinde '
        'gelenekten kopma cesareti özlemini temsil eder. İç asi ve vizyonerdir; sadece konfor '
        'uğruna uymayı reddeden yanınız. Belirgin Uranüs temaları olanlar, ana akımın henüz '
        'yetişemediği içgörüler taşıyan yabancılar gibi hissedebilir. Bu arketip, otantik '
        'bireyselliğin nerede bitip salt muhalifliğin nerede başladığını sorar.',
    coreThemesEn: [
      'Freedom to be authentically yourself',
      'Innovation born from seeing what others overlook',
      'The tension between belonging and independence',
      'Sudden insights that reframe your understanding',
      'The social responsibility of those who see differently',
    ],
    coreThemesTr: [
      'Otantik olarak kendiniz olma özgürlüğü',
      'Başkalarının gözden kaçırdığını görmekten doğan yenilik',
      'Aidiyet ve bağımsızlık arasındaki gerilim',
      'Anlayışınızı yeniden çerçeveleyen ani içgörüler',
      'Farklı görenlerin toplumsal sorumluluğu',
    ],
    strengthsEn: [
      'Ability to envision possibilities others cannot yet see',
      'Intellectual independence and original thinking',
      'Courage to stand apart when integrity demands it',
      'Gift for sparking positive disruption and needed change',
    ],
    strengthsTr: [
      'Başkalarının henüz göremediği olasılıkları tasavvur etme yeteneği',
      'Entelektüel bağımsızlık ve özgün düşünme',
      'Bütünlük gerektirdiğinde ayrı durma cesareti',
      'Olumlu bozulma ve gerekli değişimi kıvılcımlama yeteneği',
    ],
    growthAreasEn: [
      'Building bridges between your vision and the world that exists now',
      'Valuing consistency alongside innovation',
      'Recognizing that some traditions carry genuine wisdom',
    ],
    growthAreasTr: [
      'Vizyonunuz ile şu an var olan dünya arasında köprüler kurma',
      'Yeniliğin yanında tutarlılığa da değer verme',
      'Bazı geleneklerin gerçek bilgelik taşıdığını fark etme',
    ],
    dailyReflectionEn:
        'Where did you feel the urge to break a pattern today, and was that urge serving your growth or your resistance?',
    dailyReflectionTr:
        'Bugün bir kalıbı kırma dürtüsünü nerede hissettiniz ve bu dürtü büyümenize mi yoksa direncinize mi hizmet ediyordu?',
  ),

  // ── NEPTUNE ──
  ArchetypeProfile(
    archetype: PlanetaryArchetype.neptune,
    descriptionEn:
        'The Neptune archetype dissolves the boundaries between the tangible and the imaginal. '
        'It is the dreamer, the artist, the mystic, the part of you that senses a reality beyond '
        'what the five senses can confirm. Those with strong Neptunian themes often experience '
        'the world with extraordinary sensitivity and a longing for transcendence. This archetype '
        'invites you to explore the line between inspiration and escapism, between imagination '
        'and illusion.',
    descriptionTr:
        'Neptün arketipi, somut olan ile hayal gücüne ait olan arasındaki sınırları eritir. '
        'Hayalperest, sanatçı ve mistiktir; beş duyunun doğrulayabileceğinin ötesinde bir '
        'gerçekliği sezen yanınız. Güçlü Neptün temaları olanlar dünyayı olağanüstü bir '
        'duyarlılıkla ve aşkınlık özlemiyle deneyimler. Bu arketip, ilham ile kaçış arasındaki, '
        'hayal gücü ile yanılsama arasındaki çizgiyi keşfetmeye davet eder.',
    coreThemesEn: [
      'The power of imagination and creative vision',
      'Compassion that extends beyond personal boundaries',
      'The yearning for something transcendent and meaningful',
      'Distinguishing intuition from wishful thinking',
      'Surrender as a conscious spiritual practice',
    ],
    coreThemesTr: [
      'Hayal gücü ve yaratıcı vizyonun gücü',
      'Kişisel sınırların ötesine uzanan şefkat',
      'Aşkın ve anlamlı bir şey için özlem',
      'Sezgiyi hüsnükuruntuntan ayırt etme',
      'Bilinçli bir ruhani pratik olarak teslim olma',
    ],
    strengthsEn: [
      'Profound artistic and creative sensitivity',
      'Deep compassion and selfless empathy',
      'Ability to perceive subtle emotional currents others miss',
      'Natural connection to the imaginative and spiritual dimensions of life',
    ],
    strengthsTr: [
      'Derin sanatsal ve yaratıcı duyarlılık',
      'Derin şefkat ve özverili empati',
      'Başkalarının kaçırdığı ince duygusal akımları algılama yeteneği',
      'Yaşamın hayal gücüne ve ruhani boyutlarına doğal bağlantı',
    ],
    growthAreasEn: [
      'Grounding your visions in tangible, real-world action',
      'Maintaining clear boundaries even when compassion pulls you to merge',
      'Facing uncomfortable truths instead of retreating into fantasy',
    ],
    growthAreasTr: [
      'Vizyonlarınızı somut, gerçek dünya eylemine temellendirme',
      'Şefkat sizi birleşmeye çekse bile net sınırları koruma',
      'Fanteziye çekilmek yerine rahatsız edici gerçeklerle yüzleşme',
    ],
    dailyReflectionEn:
        'What stirred your imagination today, and how can you honor that inspiration without losing your footing?',
    dailyReflectionTr:
        'Bugün hayal gücünüzü ne harekete geçirdi ve ayaklarınızı kaybetmeden bu ilhamı nasıl onurlandırabilirsiniz?',
  ),

  // ── PLUTO ──
  ArchetypeProfile(
    archetype: PlanetaryArchetype.pluto,
    descriptionEn:
        'The Pluto archetype governs the deepest layers of transformation: the cycles of '
        'endings and beginnings, the stripping away of what is no longer true, and the '
        'emergence of something more authentic in its place. It is not comfortable, but it '
        'is profoundly honest. Those who work with Plutonian themes often develop extraordinary '
        'psychological depth and the ability to help others face their own shadows. This '
        'archetype asks what you are ready to release in order to become more fully yourself.',
    descriptionTr:
        'Plüton arketipi, dönüşümün en derin katmanlarını yönetir: bitişler ve başlangıçlar '
        'döngüleri, artık doğru olmayanın soyulması ve yerinde daha otantik bir şeyin ortaya '
        'çıkışı. Rahat değildir, ancak derinden dürüsttür. Plüton temalarıyla çalışanlar '
        'genellikle olağanüstü psikolojik derinlik ve başkalarının kendi gölgeleriyle yüzleşmesine '
        'yardım etme yeteneği geliştirir. Bu arketip, daha tam kendiniz olmak için neyi '
        'bırakmaya hazır olduğunuzu sorar.',
    coreThemesEn: [
      'The courage to face what lies beneath the surface',
      'Transformation through honest self-examination',
      'Power, control, and the wisdom of letting go',
      'The relationship between death of the old and birth of the new',
      'Emotional honesty as the foundation of personal power',
    ],
    coreThemesTr: [
      'Yüzeyin altında yatanla yüzleşme cesareti',
      'Dürüst öz-inceleme yoluyla dönüşüm',
      'Güç, kontrol ve bırakma bilgeliği',
      'Eskinin ölümü ile yeninin doğumu arasındaki ilişki',
      'Kişisel gücün temeli olarak duygusal dürüstlük',
    ],
    strengthsEn: [
      'Unflinching ability to face difficult truths',
      'Psychological depth and perceptive insight into hidden dynamics',
      'Remarkable capacity for regeneration and renewal',
      'Power to transform personal pain into wisdom that serves others',
    ],
    strengthsTr: [
      'Zor gerçeklerle yüzleşme konusunda gözünü kırpmayan yetenek',
      'Psikolojik derinlik ve gizli dinamiklere nüfuz eden içgörü',
      'Yenilenme ve yeniden doğuş için dikkat çekici kapasite',
      'Kişisel acıyı başkalarına hizmet eden bilgeliğe dönüştürme gücü',
    ],
    growthAreasEn: [
      'Trusting the process of transformation without needing to control every step',
      'Allowing lightness and joy alongside the deep inner work',
      'Sharing power rather than accumulating it as protection',
    ],
    growthAreasTr: [
      'Her adımı kontrol etmeye gerek kalmadan dönüşüm sürecine güvenme',
      'Derin iç çalışmanın yanında hafiflik ve neşeye izin verme',
      'Gücü koruma olarak biriktirmek yerine paylaşma',
    ],
    dailyReflectionEn:
        'What truth did you avoid today, and what might change if you allowed yourself to fully face it?',
    dailyReflectionTr:
        'Bugün hangi gerçekten kaçındınız ve kendinize tamamen yüzleşmenize izin verseniz ne değişebilir?',
  ),
];

// =============================================================================
// FULL ARCHETYPE PROFILES - ELEMENTAL (4)
// =============================================================================

const List<ArchetypeProfile> elementalProfiles = [
  // ── FIRE ──
  ArchetypeProfile(
    archetype: ElementalArchetype.fire,
    descriptionEn:
        'The Fire element represents the spark of initiative, creative passion, and the courage '
        'to take action. Fire energy is warm, expressive, and forward-moving. It is the part of '
        'you that dares to begin, that transforms vision into action. Those who resonate with Fire '
        'themes may notice a natural enthusiasm and a need to feel alive through engagement with '
        'the world.',
    descriptionTr:
        'Ateş elementi, inisiyatif kıvılcımını, yaratıcı tutkuyu ve harekete geçme cesaretini '
        'temsil eder. Ateş enerjisi sıcak, ifade edici ve ileri doğru hareket eder. Başlamaya '
        'cesaret eden, vizyonu eyleme dönüştüren yanınızdır. Ateş temalarıyla rezonansa girenler '
        'doğal bir coşku ve dünyayla etkileşim yoluyla canlı hissetme ihtiyacı fark edebilir.',
    coreThemesEn: [
      'Initiative and the courage to begin',
      'Passion as a compass for authentic living',
      'Creative expression without self-censorship',
      'Enthusiasm balanced with sustainability',
      'The warmth you bring to your relationships',
    ],
    coreThemesTr: [
      'İnisiyatif ve başlama cesareti',
      'Otantik yaşam için pusula olarak tutku',
      'Öz-sansür olmadan yaratıcı ifade',
      'Sürdürülebilirlikle dengelenmiş coşku',
      'İlişkilerinize getirdiğiniz sıcaklık',
    ],
    strengthsEn: [
      'Infectious energy that motivates and uplifts',
      'Willingness to take bold, decisive action',
      'Authentic self-expression and honesty',
      'Ability to bounce back quickly from setbacks',
    ],
    strengthsTr: [
      'Motive eden ve yükselten bulaşıcı enerji',
      'Cesur ve kararlı adım atma istekliliği',
      'Otantik kendini ifade ve dürüstlük',
      'Aksiliklerden hızla toparlanma yeteneği',
    ],
    growthAreasEn: [
      'Cultivating patience for processes that require slow growth',
      'Listening before reacting or speaking',
      'Sustaining energy over the long haul, not just in bursts',
    ],
    growthAreasTr: [
      'Yavaş büyüme gerektiren süreçler için sabır geliştirme',
      'Tepki vermeden veya konuşmadan önce dinleme',
      'Enerjiyi sadece patlamalar halinde değil, uzun vadede sürdürme',
    ],
    dailyReflectionEn:
        'Where did your passion lead you today, and did it bring warmth or burn?',
    dailyReflectionTr:
        'Bugün tutkunuz sizi nereye götürdü ve sıcaklık mı yoksa yanma mı getirdi?',
  ),

  // ── EARTH ──
  ArchetypeProfile(
    archetype: ElementalArchetype.earth,
    descriptionEn:
        'The Earth element embodies groundedness, patience, and the wisdom of building on solid '
        'foundations. Earth energy is steady, sensory, and deeply practical. It is the part of '
        'you that values reliability, appreciates the physical world, and understands that '
        'meaningful things take time. Those who resonate with Earth themes may find comfort in '
        'routine, nature, and tangible accomplishments.',
    descriptionTr:
        'Toprak elementi, köklülüğü, sabrı ve sağlam temeller üzerine inşa etme bilgeliğini '
        'somutlaştırır. Toprak enerjisi istikrarlı, duyusal ve derinden pratiktir. Güvenilirliğe '
        'değer veren, fiziksel dünyayı takdir eden ve anlamlı şeylerin zaman aldığını anlayan '
        'yanınızdır. Toprak temalarıyla rezonansa girenler rutinde, doğada ve somut başarılarda '
        'teselli bulabilir.',
    coreThemesEn: [
      'Building lasting foundations in work and life',
      'The body as a source of wisdom and grounding',
      'Patience as a form of strength, not passivity',
      'Material well-being as a reflection of inner stability',
      'The beauty of the tangible and the present moment',
    ],
    coreThemesTr: [
      'İş ve yaşamda kalıcı temeller inşa etme',
      'Bilgelik ve köklülük kaynağı olarak beden',
      'Pasiflik değil, bir güç biçimi olarak sabır',
      'İç istikrarın yansıması olarak maddi refah',
      'Somutun ve şu anın güzelliği',
    ],
    strengthsEn: [
      'Unwavering reliability that others trust deeply',
      'Practical intelligence that turns ideas into reality',
      'Deep sensory appreciation of beauty and nature',
      'Endurance and perseverance through challenges',
    ],
    strengthsTr: [
      'Başkalarının derinden güvendiği sarsılmaz güvenilirlik',
      'Fikirleri gerçeğe dönüştüren pratik zeka',
      'Güzellik ve doğanın derin duyusal takdiri',
      'Zorluklar karşısında dayanıklılık ve sebat',
    ],
    growthAreasEn: [
      'Embracing change when familiar structures no longer serve you',
      'Allowing emotional expression beyond practical problem-solving',
      'Valuing intangible experiences alongside material ones',
    ],
    growthAreasTr: [
      'Tanıdık yapılar artık size hizmet etmediğinde değişimi kucaklama',
      'Pratik problem çözmenin ötesinde duygusal ifadeye izin verme',
      'Maddi deneyimlerin yanında soyut deneyimlere de değer verme',
    ],
    dailyReflectionEn:
        'What gave you a feeling of stability today, and how did you honor the physical world around you?',
    dailyReflectionTr:
        'Bugün size istikrar duygusu ne verdi ve etrafınızdaki fiziksel dünyayı nasıl onurlandırdınız?',
  ),

  // ── AIR ──
  ArchetypeProfile(
    archetype: ElementalArchetype.air,
    descriptionEn:
        'The Air element represents the life of the mind: thoughts, ideas, communication, and '
        'the connections between people and concepts. Air energy is curious, social, and '
        'perpetually in motion. It is the part of you that asks questions, seeks variety, and '
        'finds delight in understanding how things connect. Those who resonate with Air themes '
        'may notice a constant inner dialogue and a deep need for intellectual stimulation.',
    descriptionTr:
        'Hava elementi zihnin yaşamını temsil eder: düşünceler, fikirler, iletişim ve insanlar '
        'ile kavramlar arasındaki bağlantılar. Hava enerjisi meraklı, sosyal ve sürekli hareket '
        'halindedir. Sorular soran, çeşitlilik arayan ve şeylerin nasıl bağlandığını anlamaktan '
        'keyif alan yanınızdır. Hava temalarıyla rezonansa girenler sürekli bir iç diyalog ve '
        'derin bir entelektüel uyarım ihtiyacı fark edebilir.',
    coreThemesEn: [
      'The quality of your inner dialogue and self-talk',
      'Communication as a bridge to understanding',
      'Curiosity as a driving force for personal growth',
      'The ability to see situations from multiple perspectives',
      'The relationship between thinking and feeling',
    ],
    coreThemesTr: [
      'İç diyalogunuzun ve öz-konuşmanızın kalitesi',
      'Anlaşmanın köprüsü olarak iletişim',
      'Kişisel büyüme için itici güç olarak merak',
      'Durumları birden fazla perspektiften görme yeteneği',
      'Düşünme ve hissetme arasındaki ilişki',
    ],
    strengthsEn: [
      'Quick-witted adaptability in new situations',
      'Gift for facilitating dialogue and understanding',
      'Ability to detach from emotion to see clearly',
      'Intellectual breadth that enriches every conversation',
    ],
    strengthsTr: [
      'Yeni durumlarda hızlı zekalı uyarlanabilirlik',
      'Diyalog ve anlayışı kolaylaştırma yeteneği',
      'Net görmek için duygudan ayrılma yeteneği',
      'Her konuşmayı zenginleştiren entelektüel genişlik',
    ],
    growthAreasEn: [
      'Grounding ideas in emotional and physical reality',
      'Following through on commitments rather than moving to the next idea',
      'Allowing yourself to feel deeply without intellectualizing the experience',
    ],
    growthAreasTr: [
      'Fikirleri duygusal ve fiziksel gerçeklikte temellendirme',
      'Bir sonraki fikre geçmek yerine taahhütleri sonuna kadar götürme',
      'Deneyimi entelektüelleştirmeden derinden hissetmeye izin verme',
    ],
    dailyReflectionEn:
        'What idea or conversation expanded your thinking today, and what did it stir beneath the surface?',
    dailyReflectionTr:
        'Bugün hangi fikir veya konuşma düşüncenizi genişletti ve yüzeyin altında ne harekete geçirdi?',
  ),

  // ── WATER ──
  ArchetypeProfile(
    archetype: ElementalArchetype.water,
    descriptionEn:
        'The Water element holds the realm of emotion, intuition, and the invisible currents that '
        'flow beneath conscious awareness. Water energy is receptive, healing, and endlessly deep. '
        'It is the part of you that feels before it thinks, that connects through empathy, and '
        'that carries the wisdom of the unconscious. Those who resonate with Water themes may '
        'experience the world with unusual emotional richness and sensitivity to atmosphere.',
    descriptionTr:
        'Su elementi duygu, sezgi ve bilinçli farkındalığın altında akan görünmez akımların '
        'alanını taşır. Su enerjisi alıcı, şifa verici ve sonsuz derinliktedir. Düşünmeden önce '
        'hisseden, empati yoluyla bağ kuran ve bilinçaltının bilgeliğini taşıyan yanınızdır. '
        'Su temalarıyla rezonansa girenler dünyayı olağandışı bir duygusal zenginlik ve atmosfere '
        'duyarlılıkla deneyimleyebilir.',
    coreThemesEn: [
      'The depth and complexity of your emotional life',
      'Intuition as a valid form of knowing',
      'Healing through acceptance and emotional flow',
      'The boundaries between your feelings and those of others',
      'Dreams, imagination, and the unconscious mind',
    ],
    coreThemesTr: [
      'Duygusal yaşamınızın derinliği ve karmaşıklığı',
      'Geçerli bir bilme biçimi olarak sezgi',
      'Kabul ve duygusal akış yoluyla şifa',
      'Duygularınız ile başkalarının duyguları arasındaki sınırlar',
      'Rüyalar, hayal gücü ve bilinçaltı',
    ],
    strengthsEn: [
      'Extraordinary empathy and emotional intelligence',
      'Intuitive perception that catches what logic misses',
      'Natural healing presence that comforts those around you',
      'Rich inner life that fuels creativity and spiritual depth',
    ],
    strengthsTr: [
      'Olağanüstü empati ve duygusal zeka',
      'Mantığın kaçırdığını yakalayan sezgisel algı',
      'Etrafındakileri rahatlatan doğal şifa varlığı',
      'Yaratıcılığı ve ruhani derinliği besleyen zengin iç yaşam',
    ],
    growthAreasEn: [
      'Protecting your energy without shutting down emotionally',
      'Distinguishing your feelings from those you absorb from others',
      'Finding structure and direction alongside emotional flow',
    ],
    growthAreasTr: [
      'Duygusal olarak kapanmadan enerjinizi koruma',
      'Kendi duygularınızı başkalarından absorbe ettiklerinizden ayırt etme',
      'Duygusal akışın yanında yapı ve yön bulma',
    ],
    dailyReflectionEn:
        'What did your feelings teach you today that your thoughts alone could not?',
    dailyReflectionTr:
        'Bugün duygularınız size düşüncelerinizin tek başına öğretemeyeceği ne öğretti?',
  ),
];

// =============================================================================
// FULL ARCHETYPE PROFILES - MODAL (3)
// =============================================================================

const List<ArchetypeProfile> modalProfiles = [
  // ── CARDINAL ──
  ArchetypeProfile(
    archetype: ModalArchetype.cardinal,
    descriptionEn:
        'Cardinal energy is the energy of initiation. It is the force that steps forward at the '
        'turning point, the impulse that says "let us begin." Those who resonate with Cardinal '
        'themes often feel a natural restlessness that is only soothed by starting something new. '
        'This mode invites you to reflect on how you relate to beginnings, leadership moments, '
        'and the vulnerability of taking the first step.',
    descriptionTr:
        'Öncü enerji, başlatma enerjisidir. Dönüm noktasında öne çıkan güç, "başlayalım" diyen '
        'dürtüdür. Öncü temalarıyla rezonansa girenler genellikle ancak yeni bir şey başlatarak '
        'yatışan doğal bir huzursuzluk hisseder. Bu mod, başlangıçlarla, liderlik anlarıyla ve '
        'ilk adımı atmanın kırılganlığıyla nasıl ilişkilendiğinizi yansıtmanızı davet eder.',
    coreThemesEn: [
      'The energy of new beginnings and fresh chapters',
      'Leadership that emerges naturally from conviction',
      'The creative tension of the starting line',
      'Turning points and the courage to change direction',
      'Initiative as an expression of personal truth',
    ],
    coreThemesTr: [
      'Yeni başlangıçların ve taze bölümlerin enerjisi',
      'İnançtan doğal olarak ortaya çıkan liderlik',
      'Başlangıç çizgisinin yaratıcı gerilimi',
      'Dönüm noktaları ve yön değiştirme cesareti',
      'Kişisel gerçeğin ifadesi olarak inisiyatif',
    ],
    strengthsEn: [
      'Natural ability to catalyze action and inspire movement',
      'Decisiveness that brings clarity to uncertain situations',
      'Entrepreneurial spirit and pioneering energy',
      'Comfort with the discomfort of new territory',
    ],
    strengthsTr: [
      'Eylemi katalize etme ve hareketi ilham verme yeteneği',
      'Belirsiz durumlara netlik getiren kararlılık',
      'Girişimcilik ruhu ve öncü enerji',
      'Yeni alanın rahatsızlığıyla rahat olma',
    ],
    growthAreasEn: [
      'Finishing what you start before moving to the next beginning',
      'Building the patience to nurture something past its initial excitement',
      'Recognizing that not every moment calls for a new direction',
    ],
    growthAreasTr: [
      'Bir sonraki başlangıca geçmeden önce başladığınızı bitirme',
      'Bir şeyi ilk heyecanının ötesinde beslemek için sabır geliştirme',
      'Her anın yeni bir yön gerektirmediğini fark etme',
    ],
    dailyReflectionEn:
        'What did you initiate today, and what did the act of beginning reveal about you?',
    dailyReflectionTr:
        'Bugün neyi başlattınız ve başlama eylemi sizin hakkınızda ne ortaya koydu?',
  ),

  // ── FIXED ──
  ArchetypeProfile(
    archetype: ModalArchetype.fixed,
    descriptionEn:
        'Fixed energy is the energy of consolidation. It is the force that digs in, deepens, and '
        'refuses to be moved until the work is done. Those who resonate with Fixed themes often '
        'possess remarkable willpower and the ability to sustain effort long after initial '
        'enthusiasm fades. This mode invites you to reflect on the difference between healthy '
        'determination and stubborn attachment to what no longer serves.',
    descriptionTr:
        'Sabit enerji, pekiştirme enerjisidir. Derine inen, derinleştiren ve iş bitene kadar '
        'hareket etmeyi reddeden güçtür. Sabit temalarıyla rezonansa girenler genellikle dikkat '
        'çekici bir irade gücüne ve ilk coşku söndükten çok sonra çabayı sürdürme yeteneğine '
        'sahiptir. Bu mod, sağlıklı kararlılık ile artık hizmet etmeyen şeye inatçı bağlılık '
        'arasındaki farkı yansıtmanızı davet eder.',
    coreThemesEn: [
      'The power of sustained commitment and follow-through',
      'Loyalty to people, projects, and principles',
      'Depth of focus and concentrated effort',
      'The challenge of knowing when to hold on and when to let go',
      'Inner stability as a foundation for outer achievement',
    ],
    coreThemesTr: [
      'Sürekli bağlılık ve sonuna kadar götürmenin gücü',
      'İnsanlara, projelere ve ilkelere sadakat',
      'Odaklanma derinliği ve yoğun çaba',
      'Ne zaman tutunacağını ve ne zaman bırakacağını bilmenin zorluğu',
      'Dış başarının temeli olarak iç istikrar',
    ],
    strengthsEn: [
      'Extraordinary perseverance and staying power',
      'Deep loyalty and reliability in relationships',
      'Ability to build and accumulate over time',
      'Emotional stability that anchors those around you',
    ],
    strengthsTr: [
      'Olağanüstü sebat ve dayanma gücü',
      'İlişkilerde derin sadakat ve güvenilirlik',
      'Zamanla inşa etme ve biriktirme yeteneği',
      'Etrafınızdakileri çapalayan duygusal istikrar',
    ],
    growthAreasEn: [
      'Recognizing when persistence has become resistance to necessary change',
      'Softening your grip enough to allow fresh possibilities in',
      'Embracing flexibility as a complement to your strength',
    ],
    growthAreasTr: [
      'Israrın ne zaman gerekli değişime direnç haline geldiğini fark etme',
      'Taze olasılıklara izin verecek kadar kavrayışınızı yumuşatma',
      'Esnekliği gücünüzün tamamlayıcısı olarak kucaklama',
    ],
    dailyReflectionEn:
        'What did you hold steady today, and is it something worth continuing to invest in?',
    dailyReflectionTr:
        'Bugün neyi sabit tuttunuz ve yatırım yapmaya devam etmeye değer bir şey mi?',
  ),

  // ── MUTABLE ──
  ArchetypeProfile(
    archetype: ModalArchetype.mutable,
    descriptionEn:
        'Mutable energy is the energy of transition. It is the force that adapts, integrates, and '
        'prepares the ground for what comes next. Those who resonate with Mutable themes often '
        'carry a chameleon-like ability to shift with circumstances and an intuitive understanding '
        'that nothing is permanent. This mode invites you to reflect on how you navigate endings, '
        'uncertainty, and the space between what was and what is becoming.',
    descriptionTr:
        'Değişken enerji, geçiş enerjisidir. Uyum sağlayan, bütünleştiren ve bir sonraki için '
        'zemini hazırlayan güçtür. Değişken temalarıyla rezonansa girenler genellikle koşullara '
        'göre kayma konusunda bukalemun benzeri bir yetenek ve hiçbir şeyin kalıcı olmadığına '
        'dair sezgisel bir anlayış taşır. Bu mod, bitişleri, belirsizliği ve olanla olmakta olan '
        'arasındaki boşluğu nasıl yönettiğinizi yansıtmanızı davet eder.',
    coreThemesEn: [
      'Adaptability and the grace of letting go',
      'The wisdom found in transitional spaces',
      'Versatility as a path to wholeness',
      'Processing and integrating life experiences',
      'The courage to exist in uncertainty without forcing resolution',
    ],
    coreThemesTr: [
      'Uyum sağlama ve bırakmanın zarafeti',
      'Geçiş alanlarında bulunan bilgelik',
      'Bütünlüğe giden yol olarak çok yönlülük',
      'Yaşam deneyimlerini işleme ve bütünleştirme',
      'Çözümü zorlamadan belirsizlikte var olma cesareti',
    ],
    strengthsEn: [
      'Fluid adaptability that finds a way through any situation',
      'Ability to synthesize diverse experiences into wisdom',
      'Natural empathy born from understanding many perspectives',
      'Grace under pressure and comfort with ambiguity',
    ],
    strengthsTr: [
      'Her durumda bir yol bulan akışkan uyum sağlama',
      'Çeşitli deneyimleri bilgeliğe sentezleme yeteneği',
      'Birçok perspektifi anlamaktan doğan doğal empati',
      'Baskı altında zarafet ve belirsizlikle rahat olma',
    ],
    growthAreasEn: [
      'Committing fully even when the outcome is uncertain',
      'Finding your own center instead of constantly adapting to others',
      'Trusting that your identity is solid even as you change',
    ],
    growthAreasTr: [
      'Sonuç belirsiz olsa bile tam olarak bağlanma',
      'Sürekli başkalarına uyum sağlamak yerine kendi merkezinizi bulma',
      'Değişseniz bile kimliğinizin sağlam olduğuna güvenme',
    ],
    dailyReflectionEn:
        'How did you adapt today, and did that flexibility serve your deepest self or just the expectations of others?',
    dailyReflectionTr:
        'Bugün nasıl uyum sağladınız ve bu esneklik en derin benliğinize mi yoksa sadece başkalarının beklentilerine mi hizmet etti?',
  ),
];

// =============================================================================
// HELPER: ACCESS ALL PROFILES
// =============================================================================

/// Returns all 17 archetype profiles (10 planetary + 4 elemental + 3 modal)
List<ArchetypeProfile> get allArchetypeProfiles => [
      ...planetaryProfiles,
      ...elementalProfiles,
      ...modalProfiles,
    ];
