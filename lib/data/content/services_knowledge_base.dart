// SERVICES KNOWLEDGE BASE - HİZMETLER BİLGİ BANKASI
//
// Comprehensive service descriptions with maximum information density.
// Multilingual support: tr, en, fr, de, es, ru, ar, zh, el, bg
//
// Each service includes:
// - Core explanation & historical background
// - How it works (educational, non-medical)
// - What people commonly seek
// - What you receive
// - Safety disclaimers (what it does NOT do)
// - Example scenarios
// - FAQ (10+ questions)
// - Related practices
// - Micro-learning insights
//
// LEGAL: All content framed as entertainment, spiritual exploration,
// and self-reflection. No medical, legal, or financial advice.

// ═══════════════════════════════════════════════════════════════════════════════
// SERVICE CATEGORIES
// ═══════════════════════════════════════════════════════════════════════════════

enum ServiceCategory {
  astrology,
  tarot,
  numerology,
  reiki,
  pendulum,
  jaas,
  thetaHealing,
  crescentHealing,
}

extension ServiceCategoryExtension on ServiceCategory {
  String get id {
    switch (this) {
      case ServiceCategory.astrology: return 'astrology';
      case ServiceCategory.tarot: return 'tarot';
      case ServiceCategory.numerology: return 'numerology';
      case ServiceCategory.reiki: return 'reiki';
      case ServiceCategory.pendulum: return 'pendulum';
      case ServiceCategory.jaas: return 'jaas';
      case ServiceCategory.thetaHealing: return 'theta_healing';
      case ServiceCategory.crescentHealing: return 'crescent_healing';
    }
  }

  Map<String, String> get names => {
    'tr': _categoryNamesTr[this]!,
    'en': _categoryNamesEn[this]!,
    'fr': _categoryNamesFr[this]!,
    'de': _categoryNamesDe[this]!,
    'es': _categoryNamesEs[this]!,
    'ru': _categoryNamesRu[this]!,
    'ar': _categoryNamesAr[this]!,
    'zh': _categoryNamesZh[this]!,
    'el': _categoryNamesEl[this]!,
    'bg': _categoryNamesBg[this]!,
  };
}

const Map<ServiceCategory, String> _categoryNamesTr = {
  ServiceCategory.astrology: 'Astroloji',
  ServiceCategory.tarot: 'Tarot',
  ServiceCategory.numerology: 'Numeroloji',
  ServiceCategory.reiki: 'Reiki',
  ServiceCategory.pendulum: 'Sarkaç',
  ServiceCategory.jaas: 'JAAS',
  ServiceCategory.thetaHealing: 'Theta Healing',
  ServiceCategory.crescentHealing: 'Hilal Şifa',
};

const Map<ServiceCategory, String> _categoryNamesEn = {
  ServiceCategory.astrology: 'Astrology',
  ServiceCategory.tarot: 'Tarot',
  ServiceCategory.numerology: 'Numerology',
  ServiceCategory.reiki: 'Reiki',
  ServiceCategory.pendulum: 'Pendulum',
  ServiceCategory.jaas: 'JAAS',
  ServiceCategory.thetaHealing: 'Theta Healing',
  ServiceCategory.crescentHealing: 'Crescent Healing',
};

const Map<ServiceCategory, String> _categoryNamesFr = {
  ServiceCategory.astrology: 'Astrologie',
  ServiceCategory.tarot: 'Tarot',
  ServiceCategory.numerology: 'Numérologie',
  ServiceCategory.reiki: 'Reiki',
  ServiceCategory.pendulum: 'Pendule',
  ServiceCategory.jaas: 'JAAS',
  ServiceCategory.thetaHealing: 'Theta Healing',
  ServiceCategory.crescentHealing: 'Guérison du Croissant',
};

const Map<ServiceCategory, String> _categoryNamesDe = {
  ServiceCategory.astrology: 'Astrologie',
  ServiceCategory.tarot: 'Tarot',
  ServiceCategory.numerology: 'Numerologie',
  ServiceCategory.reiki: 'Reiki',
  ServiceCategory.pendulum: 'Pendel',
  ServiceCategory.jaas: 'JAAS',
  ServiceCategory.thetaHealing: 'Theta Healing',
  ServiceCategory.crescentHealing: 'Mondheilung',
};

const Map<ServiceCategory, String> _categoryNamesEs = {
  ServiceCategory.astrology: 'Astrología',
  ServiceCategory.tarot: 'Tarot',
  ServiceCategory.numerology: 'Numerología',
  ServiceCategory.reiki: 'Reiki',
  ServiceCategory.pendulum: 'Péndulo',
  ServiceCategory.jaas: 'JAAS',
  ServiceCategory.thetaHealing: 'Theta Healing',
  ServiceCategory.crescentHealing: 'Sanación Creciente',
};

const Map<ServiceCategory, String> _categoryNamesRu = {
  ServiceCategory.astrology: 'Астрология',
  ServiceCategory.tarot: 'Таро',
  ServiceCategory.numerology: 'Нумерология',
  ServiceCategory.reiki: 'Рейки',
  ServiceCategory.pendulum: 'Маятник',
  ServiceCategory.jaas: 'ЯААС',
  ServiceCategory.thetaHealing: 'Тета-Хилинг',
  ServiceCategory.crescentHealing: 'Полумесячное Исцеление',
};

const Map<ServiceCategory, String> _categoryNamesAr = {
  ServiceCategory.astrology: 'علم الفلك',
  ServiceCategory.tarot: 'التاروت',
  ServiceCategory.numerology: 'علم الأعداد',
  ServiceCategory.reiki: 'ريكي',
  ServiceCategory.pendulum: 'البندول',
  ServiceCategory.jaas: 'جاس',
  ServiceCategory.thetaHealing: 'ثيتا هيلينغ',
  ServiceCategory.crescentHealing: 'شفاء الهلال',
};

const Map<ServiceCategory, String> _categoryNamesZh = {
  ServiceCategory.astrology: '占星术',
  ServiceCategory.tarot: '塔罗牌',
  ServiceCategory.numerology: '数字命理学',
  ServiceCategory.reiki: '灵气疗法',
  ServiceCategory.pendulum: '灵摆',
  ServiceCategory.jaas: 'JAAS',
  ServiceCategory.thetaHealing: '西塔疗愈',
  ServiceCategory.crescentHealing: '新月疗愈',
};

const Map<ServiceCategory, String> _categoryNamesEl = {
  ServiceCategory.astrology: 'Αστρολογία',
  ServiceCategory.tarot: 'Ταρώ',
  ServiceCategory.numerology: 'Αριθμολογία',
  ServiceCategory.reiki: 'Ρέικι',
  ServiceCategory.pendulum: 'Εκκρεμές',
  ServiceCategory.jaas: 'JAAS',
  ServiceCategory.thetaHealing: 'Θεραπεία Θήτα',
  ServiceCategory.crescentHealing: 'Θεραπεία Ημισελήνου',
};

const Map<ServiceCategory, String> _categoryNamesBg = {
  ServiceCategory.astrology: 'Астрология',
  ServiceCategory.tarot: 'Таро',
  ServiceCategory.numerology: 'Нумерология',
  ServiceCategory.reiki: 'Рейки',
  ServiceCategory.pendulum: 'Махало',
  ServiceCategory.jaas: 'ЯААС',
  ServiceCategory.thetaHealing: 'Тета Хийлинг',
  ServiceCategory.crescentHealing: 'Полумесечно Изцеление',
};

// ═══════════════════════════════════════════════════════════════════════════════
// SERVICE MODEL
// ═══════════════════════════════════════════════════════════════════════════════

class ServiceContent {
  final String id;
  final ServiceCategory category;
  final Map<String, String> name;
  final Map<String, String> shortDescription;
  final Map<String, String> coreExplanation;
  final Map<String, String> historicalBackground;
  final Map<String, String> philosophicalFoundation;
  final Map<String, String> howItWorks;
  final Map<String, String> symbolicInterpretation;
  final Map<String, String> insightsProvided;
  final Map<String, List<String>> commonMotivations;
  final Map<String, List<String>> lifeThemes;
  final Map<String, String> whatYouReceive;
  final Map<String, String> perspectiveGained;
  final Map<String, List<String>> reflectionPoints;
  final Map<String, String> safetyDisclaimer;
  final Map<String, List<String>> doesNotDo;
  final Map<String, List<String>> exampleScenarios;
  final Map<String, List<FAQItem>> faq;
  final Map<String, List<String>> relatedPractices;
  final Map<String, String> differenceFromSimilar;
  final Map<String, List<String>> microLearning;
  final String icon;
  final int displayOrder;

  const ServiceContent({
    required this.id,
    required this.category,
    required this.name,
    required this.shortDescription,
    required this.coreExplanation,
    required this.historicalBackground,
    required this.philosophicalFoundation,
    required this.howItWorks,
    required this.symbolicInterpretation,
    required this.insightsProvided,
    required this.commonMotivations,
    required this.lifeThemes,
    required this.whatYouReceive,
    required this.perspectiveGained,
    required this.reflectionPoints,
    required this.safetyDisclaimer,
    required this.doesNotDo,
    required this.exampleScenarios,
    required this.faq,
    required this.relatedPractices,
    required this.differenceFromSimilar,
    required this.microLearning,
    required this.icon,
    required this.displayOrder,
  });
}

class FAQItem {
  final String question;
  final String answer;
  const FAQItem({required this.question, required this.answer});
}

// ═══════════════════════════════════════════════════════════════════════════════
// ASTROLOGY SERVICES
// ═══════════════════════════════════════════════════════════════════════════════

final astrologyConsultation = ServiceContent(
  id: 'astrology_consultation',
  category: ServiceCategory.astrology,
  icon: '🔮',
  displayOrder: 1,
  name: {
    'tr': 'Astroloji Danışmanlığı',
    'en': 'Astrology Consultation',
    'fr': 'Consultation Astrologique',
    'de': 'Astrologische Beratung',
    'es': 'Consulta Astrológica',
    'ru': 'Астрологическая Консультация',
    'ar': 'استشارة فلكية',
    'zh': '占星咨询',
    'el': 'Αστρολογική Συμβουλευτική',
    'bg': 'Астрологична Консултация',
  },
  shortDescription: {
    'tr': 'Doğum haritanızın derinlikli analizi ile yaşam yolculuğunuza ışık tutan kapsamlı bir keşif deneyimi.',
    'en': 'A comprehensive exploration experience illuminating your life journey through deep analysis of your birth chart.',
    'fr': 'Une expérience d\'exploration complète éclairant votre parcours de vie à travers l\'analyse approfondie de votre thème natal.',
    'de': 'Ein umfassendes Erkundungserlebnis, das Ihre Lebensreise durch tiefgehende Analyse Ihres Geburtshoroskops beleuchtet.',
    'es': 'Una experiencia de exploración integral que ilumina tu viaje de vida a través del análisis profundo de tu carta natal.',
    'ru': 'Комплексный опыт исследования, освещающий ваш жизненный путь через глубокий анализ натальной карты.',
    'ar': 'تجربة استكشاف شاملة تنير رحلة حياتك من خلال التحليل العميق لخريطة ميلادك.',
    'zh': '通过深入分析您的出生图表，照亮您生命旅程的全面探索体验。',
    'el': 'Μια ολοκληρωμένη εμπειρία εξερεύνησης που φωτίζει το ταξίδι της ζωής σας μέσω βαθιάς ανάλυσης του γενέθλιου χάρτη σας.',
    'bg': 'Цялостно изследователско преживяване, осветяващо вашето житейско пътешествие чрез задълбочен анализ на родилната карта.',
  },
  coreExplanation: {
    'tr': '''
Astroloji danışmanlığı, doğum anınızda gökyüzündeki gezegenlerin konumlarını haritalayan kadim bir bilgelik sisteminin modern uygulamasıdır.

Doğum haritanız (natal chart), yaşamınızın potansiyellerini, doğal yeteneklerinizi, zorluklarınızı ve gelişim alanlarınızı sembolik olarak yansıtan bir kozmik haritadır. Bu harita, güneş, ay ve gezegenlerin 12 burç ve 12 ev içindeki konumlarını, birbirleriyle oluşturdukları açıları (aspektler) içerir.

Bir astroloji danışmanlığı seansında, bu sembolik dil sizin için yorumlanır ve yaşam deneyimlerinizle ilişkilendirilir. Amaç, kendinizi daha iyi anlamanız, potansiyellerinizin farkına varmanız ve yaşam seçimlerinizde daha bilinçli kararlar almanıza yardımcı olacak içgörüler sunmaktır.

Bu uygulama, binlerce yıllık gözlem ve sembolizme dayanan bir perspektif sunar. Astroloji, kesin öngörüler yapmak yerine, yaşamınızdaki temaları ve potansiyel enerji akışlarını anlamanıza yardımcı olan bir yansıtma aracı olarak en iyi şekilde değerlendirilir.
''',
    'en': '''
Astrology consultation is a modern application of an ancient wisdom system that maps the positions of celestial bodies at the moment of your birth.

Your birth chart (natal chart) is a cosmic map that symbolically reflects the potentials, natural talents, challenges, and areas of growth in your life. This map includes the positions of the sun, moon, and planets within the 12 zodiac signs and 12 houses, as well as the angles (aspects) they form with each other.

In an astrology consultation session, this symbolic language is interpreted for you and related to your life experiences. The aim is to provide insights that help you understand yourself better, become aware of your potentials, and make more conscious decisions in your life choices.

This practice offers a perspective based on thousands of years of observation and symbolism. Astrology is best appreciated as a reflection tool that helps you understand themes and potential energy flows in your life, rather than making definite predictions.
''',
    'fr': '''
La consultation astrologique est une application moderne d'un système de sagesse ancien qui cartographie les positions des corps célestes au moment de votre naissance.

Votre thème natal est une carte cosmique qui reflète symboliquement les potentiels, les talents naturels, les défis et les domaines de croissance dans votre vie. Cette carte inclut les positions du soleil, de la lune et des planètes dans les 12 signes du zodiaque et les 12 maisons, ainsi que les angles (aspects) qu'ils forment entre eux.

Lors d'une séance de consultation astrologique, ce langage symbolique est interprété pour vous et mis en relation avec vos expériences de vie. L'objectif est de fournir des perspectives qui vous aident à mieux vous comprendre, à prendre conscience de vos potentiels et à prendre des décisions plus conscientes dans vos choix de vie.

Cette pratique offre une perspective basée sur des milliers d'années d'observation et de symbolisme. L'astrologie est mieux appréciée comme un outil de réflexion qui vous aide à comprendre les thèmes et les flux d'énergie potentiels dans votre vie, plutôt que de faire des prédictions définitives.
''',
    'de': '''
Die astrologische Beratung ist eine moderne Anwendung eines alten Weisheitssystems, das die Positionen der Himmelskörper zum Zeitpunkt Ihrer Geburt abbildet.

Ihr Geburtshoroskop (Natalhoroskop) ist eine kosmische Karte, die symbolisch die Potenziale, natürlichen Talente, Herausforderungen und Wachstumsbereiche in Ihrem Leben widerspiegelt. Diese Karte enthält die Positionen von Sonne, Mond und Planeten innerhalb der 12 Tierkreiszeichen und 12 Häuser sowie die Winkel (Aspekte), die sie zueinander bilden.

In einer astrologischen Beratungssitzung wird diese symbolische Sprache für Sie interpretiert und mit Ihren Lebenserfahrungen in Beziehung gesetzt. Das Ziel ist es, Einsichten zu vermitteln, die Ihnen helfen, sich selbst besser zu verstehen, sich Ihrer Potenziale bewusst zu werden und bewusstere Entscheidungen in Ihrem Leben zu treffen.

Diese Praxis bietet eine Perspektive, die auf Tausenden von Jahren der Beobachtung und Symbolik basiert. Astrologie wird am besten als Reflexionswerkzeug geschätzt, das Ihnen hilft, Themen und potenzielle Energieflüsse in Ihrem Leben zu verstehen, anstatt definitive Vorhersagen zu machen.
''',
    'es': '''
La consulta astrológica es una aplicación moderna de un sistema de sabiduría antiguo que mapea las posiciones de los cuerpos celestes en el momento de tu nacimiento.

Tu carta natal es un mapa cósmico que refleja simbólicamente los potenciales, talentos naturales, desafíos y áreas de crecimiento en tu vida. Este mapa incluye las posiciones del sol, la luna y los planetas dentro de los 12 signos del zodiaco y las 12 casas, así como los ángulos (aspectos) que forman entre sí.

En una sesión de consulta astrológica, este lenguaje simbólico se interpreta para ti y se relaciona con tus experiencias de vida. El objetivo es proporcionar perspectivas que te ayuden a entenderte mejor, tomar conciencia de tus potenciales y tomar decisiones más conscientes en tus elecciones de vida.

Esta práctica ofrece una perspectiva basada en miles de años de observación y simbolismo. La astrología se aprecia mejor como una herramienta de reflexión que te ayuda a comprender los temas y los flujos de energía potenciales en tu vida, en lugar de hacer predicciones definitivas.
''',
    'ru': '''
Астрологическая консультация — это современное применение древней системы мудрости, которая отображает положения небесных тел в момент вашего рождения.

Ваша натальная карта — это космическая карта, которая символически отражает потенциалы, природные таланты, трудности и области роста в вашей жизни. Эта карта включает положения солнца, луны и планет в 12 знаках зодиака и 12 домах, а также углы (аспекты), которые они образуют друг с другом.

На сеансе астрологической консультации этот символический язык интерпретируется для вас и соотносится с вашим жизненным опытом. Цель — предоставить идеи, которые помогут вам лучше понять себя, осознать свои потенциалы и принимать более осознанные решения в жизненных выборах.

Эта практика предлагает перспективу, основанную на тысячелетних наблюдениях и символизме. Астрологию лучше всего воспринимать как инструмент рефлексии, который помогает понять темы и потенциальные энергетические потоки в вашей жизни, а не делать определённые предсказания.
''',
    'ar': '''
الاستشارة الفلكية هي تطبيق حديث لنظام حكمة قديم يرسم خريطة مواقع الأجرام السماوية في لحظة ولادتك.

خريطة ولادتك (الخريطة الفلكية) هي خريطة كونية تعكس رمزياً الإمكانيات والمواهب الطبيعية والتحديات ومجالات النمو في حياتك. تتضمن هذه الخريطة مواقع الشمس والقمر والكواكب ضمن 12 برجاً و12 بيتاً، بالإضافة إلى الزوايا (الجوانب) التي تشكلها مع بعضها البعض.

في جلسة الاستشارة الفلكية، يتم تفسير هذه اللغة الرمزية لك وربطها بتجارب حياتك. الهدف هو تقديم رؤى تساعدك على فهم نفسك بشكل أفضل، وإدراك إمكانياتك، واتخاذ قرارات أكثر وعياً في اختياراتك الحياتية.

تقدم هذه الممارسة منظوراً يستند إلى آلاف السنين من الملاحظة والرمزية. يُقدَّر علم الفلك بشكل أفضل كأداة للتأمل تساعدك على فهم المواضيع وتدفقات الطاقة المحتملة في حياتك، بدلاً من إجراء تنبؤات قطعية.
''',
    'zh': '''
占星咨询是一种古老智慧系统的现代应用，它绘制了您出生时天体的位置。

您的出生图（本命盘）是一张宇宙地图，象征性地反映了您生活中的潜力、天赋、挑战和成长领域。这张图包括太阳、月亮和行星在12个星座和12宫内的位置，以及它们彼此形成的角度（相位）。

在占星咨询会议中，这种象征性语言会为您解读，并与您的生活经历相关联。目的是提供帮助您更好地了解自己、意识到自己的潜力并在生活选择中做出更有意识决定的见解。

这种做法提供了基于数千年观察和象征主义的视角。占星术最好被视为一种反思工具，帮助您理解生活中的主题和潜在能量流，而不是做出确定的预测。
''',
    'el': '''
Η αστρολογική συμβουλευτική είναι μια σύγχρονη εφαρμογή ενός αρχαίου συστήματος σοφίας που χαρτογραφεί τις θέσεις των ουράνιων σωμάτων τη στιγμή της γέννησής σας.

Ο γενέθλιος χάρτης σας είναι ένας κοσμικός χάρτης που αντικατοπτρίζει συμβολικά τις δυνατότητες, τα φυσικά ταλέντα, τις προκλήσεις και τους τομείς ανάπτυξης στη ζωή σας. Αυτός ο χάρτης περιλαμβάνει τις θέσεις του ήλιου, της σελήνης και των πλανητών εντός των 12 ζωδίων και 12 οίκων, καθώς και τις γωνίες (όψεις) που σχηματίζουν μεταξύ τους.

Σε μια συνεδρία αστρολογικής συμβουλευτικής, αυτή η συμβολική γλώσσα ερμηνεύεται για εσάς και συσχετίζεται με τις εμπειρίες της ζωής σας. Ο στόχος είναι να παρέχει γνώσεις που σας βοηθούν να κατανοήσετε καλύτερα τον εαυτό σας, να συνειδητοποιήσετε τις δυνατότητές σας και να λαμβάνετε πιο συνειδητές αποφάσεις στις επιλογές ζωής σας.

Αυτή η πρακτική προσφέρει μια προοπτική βασισμένη σε χιλιάδες χρόνια παρατήρησης και συμβολισμού. Η αστρολογία εκτιμάται καλύτερα ως εργαλείο αναστοχασμού που σας βοηθά να κατανοήσετε θέματα και πιθανές ενεργειακές ροές στη ζωή σας, αντί να κάνει οριστικές προβλέψεις.
''',
    'bg': '''
Астрологичната консултация е модерно приложение на древна система на мъдрост, която картографира позициите на небесните тела в момента на вашето раждане.

Вашата рождена карта (натална карта) е космическа карта, която символично отразява потенциалите, природните таланти, предизвикателствата и областите на растеж във вашия живот. Тази карта включва позициите на слънцето, луната и планетите в рамките на 12-те зодиакални знака и 12 дома, както и ъглите (аспекти), които формират помежду си.

По време на сесия за астрологична консултация този символичен език се интерпретира за вас и се свързва с вашия житейски опит. Целта е да се предоставят прозрения, които ви помагат да разберете по-добре себе си, да осъзнаете потенциалите си и да вземате по-съзнателни решения в житейските си избори.

Тази практика предлага перспектива, базирана на хиляди години наблюдение и символизъм. Астрологията се цени най-добре като инструмент за размисъл, който ви помага да разберете темите и потенциалните енергийни потоци в живота ви, вместо да прави категорични предсказания.
''',
  },
  historicalBackground: {
    'tr': '''
Astroloji, insanlık tarihinin en eski bilgi sistemlerinden biridir. Kökenleri MÖ 2000'li yıllara, antik Babil'e kadar uzanır. Sümerler gökyüzünü gözlemleyerek tarımsal döngüleri takip etmiş, zamanla bu gözlemler kozmik olaylarla dünyevi olaylar arasında bağlantı kuran bir sisteme dönüşmüştür.

Antik Mısır'da astroloji, dini ritüellerle iç içeydi. Piramitlerin yıldız takımyıldızlarına göre hizalandığı bilinmektedir. Yunanlılar, Babil astrolojisini aldılar ve ona felsefi bir çerçeve kazandırdılar. Ptolemy'nin "Tetrabiblos" eseri, Batı astrolojisinin temel metni olarak yüzyıllar boyunca referans kaynağı olmuştur.

Ortaçağ'da astroloji, Avrupa üniversitelerinde öğretilen saygın bir disiplindi. Rönesans döneminde sanat, bilim ve astroloji iç içe geçmişti. 17. yüzyılda bilimsel devrimin ardından astroloji akademik çevrelerden uzaklaştı, ancak halk arasında canlılığını korudu.

Modern dönemde, Carl Jung'un arketipler ve kolektif bilinçdışı teorileri, astrolojiye psikolojik bir derinlik kazandırdı. Bugün astroloji, kendini keşfetme ve kişisel gelişim aracı olarak milyonlarca insan tarafından kullanılmaktadır.
''',
    'en': '''
Astrology is one of the oldest knowledge systems in human history. Its origins can be traced back to around 2000 BCE in ancient Babylon. The Sumerians observed the sky to track agricultural cycles, and over time these observations evolved into a system that connected cosmic events with earthly occurrences.

In ancient Egypt, astrology was intertwined with religious rituals. The pyramids are known to be aligned with star constellations. The Greeks adopted Babylonian astrology and gave it a philosophical framework. Ptolemy's "Tetrabiblos" served as a reference for centuries as the foundational text of Western astrology.

In the Middle Ages, astrology was a respected discipline taught in European universities. During the Renaissance, art, science, and astrology were intertwined. After the scientific revolution of the 17th century, astrology distanced itself from academic circles, but maintained its vitality among the public.

In modern times, Carl Jung's theories of archetypes and the collective unconscious added psychological depth to astrology. Today, astrology is used by millions as a tool for self-discovery and personal development.
''',
    'fr': '''
L'astrologie est l'un des plus anciens systèmes de connaissance de l'histoire humaine. Ses origines remontent à environ 2000 avant J.-C. dans l'ancienne Babylone.
''',
    'de': '''
Die Astrologie ist eines der ältesten Wissenssysteme der Menschheitsgeschichte. Ihre Ursprünge lassen sich bis etwa 2000 v. Chr. im alten Babylon zurückverfolgen.
''',
    'es': '''
La astrología es uno de los sistemas de conocimiento más antiguos de la historia humana. Sus orígenes se remontan a alrededor del 2000 a.C. en la antigua Babilonia.
''',
    'ru': '''
Астрология — одна из древнейших систем знаний в истории человечества. Её истоки восходят к 2000 году до н.э. в древнем Вавилоне.
''',
    'ar': '''
علم الفلك هو أحد أقدم أنظمة المعرفة في تاريخ البشرية. تعود أصوله إلى حوالي عام 2000 قبل الميلاد في بابل القديمة.
''',
    'zh': '''
占星术是人类历史上最古老的知识系统之一。其起源可追溯到公元前2000年左右的古巴比伦。
''',
    'el': '''
Η αστρολογία είναι ένα από τα αρχαιότερα συστήματα γνώσης στην ανθρώπινη ιστορία. Οι ρίζες της εντοπίζονται γύρω στο 2000 π.Χ. στην αρχαία Βαβυλώνα.
''',
    'bg': '''
Астрологията е една от най-старите системи на знание в човешката история. Нейните корени водят началото си от около 2000 г. пр.н.е. в древен Вавилон.
''',
  },
  philosophicalFoundation: {
    'tr': '''
Astrolojinin felsefi temeli, "As above, so below" (Yukarıda ne varsa aşağıda da o) ilkesine dayanır. Bu Hermetik öğreti, makrokozmos (evren) ile mikrokozmos (birey) arasında bir yansıma ilişkisi olduğunu öne sürer.

Bu bakış açısına göre, evren tek bir bütünlüktür ve her parça bu bütünü yansıtır. Doğum anında gökyüzünün konfigürasyonu, bir bireyin potansiyel karakterini ve yaşam temalarını sembolik olarak temsil eder.

Modern psikolojik astroloji, bu sembolik sistemi bireyin bilinçdışı süreçlerini anlamak için bir araç olarak kullanır. Jung'un arketip teorisi, gezegen sembollerinin evrensel insan deneyimlerini temsil ettiği fikriyle uyum içindedir.

Önemli bir nokta: Astroloji determinizm önermez. Yıldızlar "zorlama" değil, "eğilim gösterme" olarak anlaşılır. Birey her zaman özgür iradeye sahiptir; astroloji yalnızca potansiyel enerji kalıplarını gösterir.
''',
    'en': '''
The philosophical foundation of astrology is based on the principle "As above, so below." This Hermetic teaching suggests there is a reflective relationship between the macrocosm (universe) and the microcosm (individual).

From this perspective, the universe is a single whole, and every part reflects this whole. The configuration of the sky at the moment of birth symbolically represents an individual's potential character and life themes.

Modern psychological astrology uses this symbolic system as a tool to understand an individual's unconscious processes. Jung's theory of archetypes aligns with the idea that planetary symbols represent universal human experiences.

An important point: Astrology does not propose determinism. The stars are understood as "inclining" rather than "compelling." The individual always has free will; astrology only shows potential energy patterns.
''',
    'fr': '''Le fondement philosophique de l'astrologie repose sur le principe "Ce qui est en haut est comme ce qui est en bas."''',
    'de': '''Die philosophische Grundlage der Astrologie basiert auf dem Prinzip "Wie oben, so unten."''',
    'es': '''El fundamento filosófico de la astrología se basa en el principio "Como arriba, así abajo."''',
    'ru': '''Философская основа астрологии базируется на принципе "Как вверху, так и внизу."''',
    'ar': '''الأساس الفلسفي لعلم الفلك يقوم على مبدأ "كما في الأعلى، كذلك في الأسفل."''',
    'zh': '''占星术的哲学基础基于"上如其上，下如其下"的原则。''',
    'el': '''Η φιλοσοφική βάση της αστρολογίας βασίζεται στην αρχή "Ό,τι πάνω, τόσο και κάτω."''',
    'bg': '''Философската основа на астрологията се основава на принципа "Както горе, така и долу."''',
  },
  howItWorks: {
    'tr': '''
Bir astroloji danışmanlığı seansı şu şekilde ilerler:

1. HARITA HESAPLAMA
Doğum tarihiniz, saatiniz ve yeriniz kullanılarak doğum haritanız hesaplanır. Bu harita, doğduğunuz anda gökyüzünün bir "fotoğrafı"dır.

2. TEMEL UNSURLAR
- Güneş Burcu: Temel kimlik ve yaşam amacı
- Ay Burcu: Duygusal doğa ve iç dünya
- Yükselen Burç: Dış görünüm ve ilk izlenim
- Gezegenler: Farklı yaşam alanlarını temsil eden enerjiler
- Evler: Yaşamın 12 farklı alanı (kariyer, ilişkiler, sağlık vb.)
- Aspektler: Gezegenler arasındaki açısal ilişkiler

3. YORUM SÜRECİ
Danışman, bu sembolleri bir bütün olarak okur ve anlamlı kalıpları ortaya çıkarır. Örneğin, Güneş'in konumu yaşam amacınızı, Ay'ın konumu duygusal ihtiyaçlarınızı gösterir.

4. DİYALOG
İyi bir danışmanlık, tek yönlü bilgi aktarımı değil, karşılıklı bir keşif sürecidir. Danışman sorular sorar, siz paylaşımda bulunursunuz ve birlikte anlamlar üretilir.

5. ENTEGRASYON
Seans sonunda, edindiğiniz içgörüleri günlük yaşamınıza nasıl uygulayabileceğinize dair öneriler sunulur.
''',
    'en': '''
An astrology consultation session proceeds as follows:

1. CHART CALCULATION
Your birth chart is calculated using your birth date, time, and place. This chart is a "photograph" of the sky at the moment you were born.

2. FUNDAMENTAL ELEMENTS
- Sun Sign: Core identity and life purpose
- Moon Sign: Emotional nature and inner world
- Rising Sign: External appearance and first impression
- Planets: Energies representing different areas of life
- Houses: 12 different areas of life (career, relationships, health, etc.)
- Aspects: Angular relationships between planets

3. INTERPRETATION PROCESS
The consultant reads these symbols as a whole and reveals meaningful patterns. For example, the Sun's position shows your life purpose, the Moon's position shows your emotional needs.

4. DIALOGUE
Good consultation is not one-way information transfer, but a mutual discovery process. The consultant asks questions, you share, and meanings are generated together.

5. INTEGRATION
At the end of the session, suggestions are offered on how to apply the insights you've gained to your daily life.
''',
    'fr': '''Une séance de consultation astrologique se déroule comme suit...''',
    'de': '''Eine astrologische Beratungssitzung verläuft wie folgt...''',
    'es': '''Una sesión de consulta astrológica procede de la siguiente manera...''',
    'ru': '''Сеанс астрологической консультации проходит следующим образом...''',
    'ar': '''تسير جلسة الاستشارة الفلكية على النحو التالي...''',
    'zh': '''占星咨询会议按以下方式进行...''',
    'el': '''Μια συνεδρία αστρολογικής συμβουλευτικής εξελίσσεται ως εξής...''',
    'bg': '''Сесията за астрологична консултация протича по следния начин...''',
  },
  symbolicInterpretation: {
    'tr': '''
Astroloji sembolik bir dildir. Her gezegen, burç ve ev belirli arketipsel anlamlar taşır:

GEZEGENLERİN SEMBOLİZMİ:
☉ Güneş - Ben, kimlik, yaşam gücü, baba figürü
☽ Ay - Duygular, bilinçdışı, anne figürü, ev
☿ Merkür - İletişim, düşünce, öğrenme
♀ Venüs - Aşk, güzellik, değerler, para
♂ Mars - Enerji, tutku, cesaret, öfke
♃ Jüpiter - Genişleme, şans, felsefe, yolculuk
♄ Satürn - Sınırlar, sorumluluk, olgunluk, zaman
♅ Uranüs - Özgürlük, devrim, beklenmedik değişim
♆ Neptün - Hayal gücü, ruhaniyet, illüzyon
♇ Plüton - Dönüşüm, güç, yeniden doğuş

Bu semboller, kesin anlamlar değil, yorum için bir çerçeve sunar. Her bireyin haritası benzersizdir ve kişisel bağlamda yorumlanmalıdır.
''',
    'en': '''
Astrology is a symbolic language. Each planet, sign, and house carries specific archetypal meanings:

PLANETARY SYMBOLISM:
☉ Sun - Self, identity, life force, father figure
☽ Moon - Emotions, unconscious, mother figure, home
☿ Mercury - Communication, thought, learning
♀ Venus - Love, beauty, values, money
♂ Mars - Energy, passion, courage, anger
♃ Jupiter - Expansion, luck, philosophy, travel
♄ Saturn - Boundaries, responsibility, maturity, time
♅ Uranus - Freedom, revolution, unexpected change
♆ Neptune - Imagination, spirituality, illusion
♇ Pluto - Transformation, power, rebirth

These symbols offer a framework for interpretation, not definite meanings. Each individual's chart is unique and should be interpreted in personal context.
''',
    'fr': '''L'astrologie est un langage symbolique...''',
    'de': '''Die Astrologie ist eine symbolische Sprache...''',
    'es': '''La astrología es un lenguaje simbólico...''',
    'ru': '''Астрология — это символический язык...''',
    'ar': '''علم الفلك هو لغة رمزية...''',
    'zh': '''占星术是一种象征性语言...''',
    'el': '''Η αστρολογία είναι μια συμβολική γλώσσα...''',
    'bg': '''Астрологията е символичен език...''',
  },
  insightsProvided: {
    'tr': 'Bir astroloji danışmanlığı size şunları sunabilir: Kendinizi daha derinlemesine anlama fırsatı, yaşam döngülerinizi ve temalarınızı kavrama, doğal yeteneklerinizi ve güçlü yönlerinizi keşfetme, zorlu alanlarınızı ve büyüme fırsatlarınızı görme, ilişki dinamiklerinizi anlama, kariyer ve yaşam yönünüz hakkında perspektif kazanma.',
    'en': 'An astrology consultation can offer you: An opportunity to understand yourself more deeply, comprehension of your life cycles and themes, discovery of your natural talents and strengths, insight into your challenging areas and growth opportunities, understanding of your relationship dynamics, gaining perspective on your career and life direction.',
    'fr': 'Une consultation astrologique peut vous offrir...',
    'de': 'Eine astrologische Beratung kann Ihnen bieten...',
    'es': 'Una consulta astrológica puede ofrecerte...',
    'ru': 'Астрологическая консультация может предложить вам...',
    'ar': 'يمكن أن تقدم لك الاستشارة الفلكية...',
    'zh': '占星咨询可以为您提供...',
    'el': 'Μια αστρολογική συμβουλευτική μπορεί να σας προσφέρει...',
    'bg': 'Астрологичната консултация може да ви предложи...',
  },
  commonMotivations: {
    'tr': ['Kendimi daha iyi tanımak istiyorum', 'Zor bir dönemden geçiyorum ve anlam arıyorum', 'Kariyer veya ilişki konusunda perspektif istiyorum', 'Yaşamımdaki kalıpları anlamak istiyorum', 'Potansiyelimi keşfetmek istiyorum', 'Astroloji hakkında merak ediyorum'],
    'en': ['I want to know myself better', 'I\'m going through a difficult period and seeking meaning', 'I want perspective on career or relationships', 'I want to understand patterns in my life', 'I want to discover my potential', 'I\'m curious about astrology'],
    'fr': ['Je veux mieux me connaître', 'Je traverse une période difficile'],
    'de': ['Ich möchte mich selbst besser kennen', 'Ich durchlebe eine schwierige Zeit'],
    'es': ['Quiero conocerme mejor', 'Estoy pasando por un período difícil'],
    'ru': ['Я хочу лучше узнать себя', 'Я переживаю трудный период'],
    'ar': ['أريد أن أعرف نفسي بشكل أفضل', 'أمر بفترة صعبة'],
    'zh': ['我想更好地了解自己', '我正经历一段困难时期'],
    'el': ['Θέλω να γνωρίσω καλύτερα τον εαυτό μου', 'Περνάω μια δύσκολη περίοδο'],
    'bg': ['Искам да се опозная по-добре', 'Преминавам през труден период'],
  },
  lifeThemes: {
    'tr': ['Kimlik ve kendilik', 'İlişkiler ve ortaklıklar', 'Kariyer ve yaşam amacı', 'Aile ve kökler', 'Sağlık ve yaşam tarzı', 'Ruhsal gelişim', 'Yaratıcılık ve ifade', 'Mali konular', 'Eğitim ve öğrenme', 'Yolculuklar ve keşif'],
    'en': ['Identity and selfhood', 'Relationships and partnerships', 'Career and life purpose', 'Family and roots', 'Health and lifestyle', 'Spiritual development', 'Creativity and expression', 'Financial matters', 'Education and learning', 'Journeys and exploration'],
    'fr': ['Identité et soi'],
    'de': ['Identität und Selbst'],
    'es': ['Identidad y yo'],
    'ru': ['Идентичность и самость'],
    'ar': ['الهوية والذات'],
    'zh': ['身份与自我'],
    'el': ['Ταυτότητα και εαυτός'],
    'bg': ['Идентичност и себе'],
  },
  whatYouReceive: {
    'tr': '''
Bir astroloji danışmanlığı seansından alacaklarınız:

• Kişisel doğum haritanızın detaylı açıklaması
• Temel karakter özelliklerinizin sembolik analizi
• Yaşam temalarınız ve potansiyel zorluklarınız hakkında içgörüler
• Mevcut yaşam döngünüze dair perspektif (transit analizi dahil edilirse)
• Sorularınıza yönelik özel yorumlar
• Uygulamaya dönük öneriler ve yansıtma noktaları

Not: Alacağınız içerikler danışmanın yaklaşımına ve seansın türüne göre değişebilir.
''',
    'en': '''
What you will receive from an astrology consultation session:

• Detailed explanation of your personal birth chart
• Symbolic analysis of your core character traits
• Insights about your life themes and potential challenges
• Perspective on your current life cycle (if transit analysis is included)
• Custom interpretations for your questions
• Actionable suggestions and reflection points

Note: Content may vary depending on the consultant's approach and session type.
''',
    'fr': '''Ce que vous recevrez d'une séance de consultation astrologique...''',
    'de': '''Was Sie von einer astrologischen Beratungssitzung erhalten werden...''',
    'es': '''Lo que recibirás de una sesión de consulta astrológica...''',
    'ru': '''Что вы получите от сеанса астрологической консультации...''',
    'ar': '''ما ستحصل عليه من جلسة استشارة فلكية...''',
    'zh': '''您将从占星咨询会议中获得什么...''',
    'el': '''Τι θα λάβετε από μια συνεδρία αστρολογικής συμβουλευτικής...''',
    'bg': '''Какво ще получите от сесия за астрологична консултация...''',
  },
  perspectiveGained: {
    'tr': 'Astroloji, yaşamınıza kuş bakışı bir perspektif sunar. Günlük rutinin içinde kaybolmuş kalıpları, farkında olmadığınız yetenekleri ve henüz keşfetmediğiniz potansiyelleri görmenize yardımcı olabilir. Bu perspektif, kim olduğunuza dair daha bütünsel bir anlayış geliştirmenizi sağlar.',
    'en': 'Astrology offers a bird\'s eye view of your life. It can help you see patterns lost in daily routine, talents you weren\'t aware of, and potentials you haven\'t yet discovered. This perspective enables you to develop a more holistic understanding of who you are.',
    'fr': 'L\'astrologie offre une vue d\'ensemble de votre vie...',
    'de': 'Die Astrologie bietet eine Vogelperspektive auf Ihr Leben...',
    'es': 'La astrología ofrece una vista panorámica de tu vida...',
    'ru': 'Астрология предлагает панорамный взгляд на вашу жизнь...',
    'ar': 'يقدم علم الفلك نظرة شاملة على حياتك...',
    'zh': '占星术提供了对您生活的鸟瞰视角...',
    'el': 'Η αστρολογία προσφέρει μια πανοραμική θέα της ζωής σας...',
    'bg': 'Астрологията предлага панорамен поглед върху живота ви...',
  },
  reflectionPoints: {
    'tr': ['Hangi yaşam alanlarında kendinizi en rahat hissediyorsunuz?', 'Tekrar eden kalıplar veya zorluklar neler?', 'Potansiyelinizi tam olarak kullandığınızı düşünüyor musunuz?', 'İlişkilerinizde hangi dinamikler ön plana çıkıyor?', 'Yaşam amacınız konusunda netlik mi, belirsizlik mi yaşıyorsunuz?'],
    'en': ['In which areas of life do you feel most comfortable?', 'What are the recurring patterns or challenges?', 'Do you think you\'re using your full potential?', 'Which dynamics stand out in your relationships?', 'Do you experience clarity or uncertainty about your life purpose?'],
    'fr': ['Dans quels domaines de vie vous sentez-vous le plus à l\'aise?'],
    'de': ['In welchen Lebensbereichen fühlen Sie sich am wohlsten?'],
    'es': ['¿En qué áreas de la vida te sientes más cómodo?'],
    'ru': ['В каких сферах жизни вы чувствуете себя наиболее комфортно?'],
    'ar': ['في أي مجالات الحياة تشعر براحة أكبر؟'],
    'zh': ['在生活的哪些领域您感觉最舒适？'],
    'el': ['Σε ποιους τομείς της ζωής νιώθετε πιο άνετα;'],
    'bg': ['В кои области на живота се чувствате най-комфортно?'],
  },
  safetyDisclaimer: {
    'tr': '''
⚠️ ÖNEMLİ UYARI

Astroloji danışmanlığı, eğlence ve kendini keşfetme amaçlı bir hizmettir. Bu hizmet:

• Tıbbi, psikolojik veya psikiyatrik tedavinin yerini ALMAZ
• Hukuki veya finansal danışmanlık DEĞİLDİR
• Kesin gelecek tahminleri YAPMAZ
• Kararlarınızı sizin yerinize ALMAZ

Ciddi sağlık, psikolojik veya hukuki sorunlar yaşıyorsanız, lütfen ilgili alanda lisanslı bir uzmana başvurun.

Astroloji, sembolik bir dil kullanır ve sunulan yorumlar olasılık ve potansiyel üzerinedir, kesinlik iddiası taşımaz. Her birey özgür iradeye sahiptir ve yaşam seçimleri kişinin kendi sorumluluğundadır.
''',
    'en': '''
⚠️ IMPORTANT NOTICE

Astrology consultation is a service for entertainment and self-discovery purposes. This service:

• Does NOT replace medical, psychological, or psychiatric treatment
• Is NOT legal or financial advice
• Does NOT make definite future predictions
• Does NOT make decisions on your behalf

If you are experiencing serious health, psychological, or legal issues, please consult a licensed professional in the relevant field.

Astrology uses symbolic language and interpretations offered are about possibilities and potentials, not certainties. Every individual has free will and life choices are one's own responsibility.
''',
    'fr': '''⚠️ AVIS IMPORTANT - La consultation astrologique est un service à des fins de divertissement et de découverte de soi...''',
    'de': '''⚠️ WICHTIGER HINWEIS - Die astrologische Beratung ist eine Dienstleistung zur Unterhaltung und Selbstentdeckung...''',
    'es': '''⚠️ AVISO IMPORTANTE - La consulta astrológica es un servicio con fines de entretenimiento y autodescubrimiento...''',
    'ru': '''⚠️ ВАЖНОЕ УВЕДОМЛЕНИЕ - Астрологическая консультация — это услуга для развлечения и самопознания...''',
    'ar': '''⚠️ إشعار هام - الاستشارة الفلكية هي خدمة للترفيه واكتشاف الذات...''',
    'zh': '''⚠️ 重要提示 - 占星咨询是一项用于娱乐和自我发现的服务...''',
    'el': '''⚠️ ΣΗΜΑΝΤΙΚΗ ΕΙΔΟΠΟΙΗΣΗ - Η αστρολογική συμβουλευτική είναι μια υπηρεσία για ψυχαγωγία και αυτογνωσία...''',
    'bg': '''⚠️ ВАЖНО СЪОБЩЕНИЕ - Астрологичната консултация е услуга за забавление и самопознание...''',
  },
  doesNotDo: {
    'tr': ['Kesin gelecek tahmini yapmaz', 'Tıbbi teşhis veya tedavi önermez', 'Psikolojik terapi yerine geçmez', 'Finansal yatırım tavsiyesi vermez', 'Hukuki danışmanlık sunmaz', 'Kararlarınızı sizin yerinize almaz', 'Kader veya kaçınılmazlık iddiasında bulunmaz', 'İlişkilerinizi yönlendirmez'],
    'en': ['Does not make definite future predictions', 'Does not diagnose or recommend medical treatment', 'Does not replace psychological therapy', 'Does not give financial investment advice', 'Does not provide legal counsel', 'Does not make decisions on your behalf', 'Does not claim fate or inevitability', 'Does not direct your relationships'],
    'fr': ['Ne fait pas de prédictions définitives'],
    'de': ['Macht keine definitiven Zukunftsvorhersagen'],
    'es': ['No hace predicciones definitivas del futuro'],
    'ru': ['Не делает определённых предсказаний будущего'],
    'ar': ['لا يقدم تنبؤات مستقبلية قطعية'],
    'zh': ['不做确定的未来预测'],
    'el': ['Δεν κάνει οριστικές προβλέψεις για το μέλλον'],
    'bg': ['Не прави категорични предсказания за бъдещето'],
  },
  exampleScenarios: {
    'tr': [
      'Bir seans sırasında, danışan Satürn transitinin kariyer evini etkilediğini öğrendi. Bu, mevcut iş zorluklarının bir "sınav" veya "olgunlaşma" dönemi olarak algılanabileceğine dair bir perspektif sundu. Danışan, bu dönemin sonlu olduğunu ve büyüme potansiyeli taşıdığını görerek rahatlama hissetti.',
      'Başka bir danışan, Ay burcunun Oğlak olduğunu keşfetti ve bu, duygusal ihtiyaçlarını ifade etmekte zorlanmasını farklı bir perspektiften anlamasına yardımcı oldu. Bu içgörü, kendi kendine daha şefkatli olması için bir kapı açtı.',
      'Bir çift, ilişki uyum analizi yaptırdı ve birbirlerini tamamlayan ama aynı zamanda sürtüşme yaratan noktaları gördü. Bu, birbirlerinin farklılıklarını bir tehdit değil, büyüme fırsatı olarak görmeye başlamalarına yardımcı oldu.',
    ],
    'en': [
      'During a session, the client learned that a Saturn transit was affecting their career house. This offered a perspective that current work challenges could be seen as a "test" or "maturation" period. The client felt relief seeing that this period was finite and held growth potential.',
      'Another client discovered their Moon sign was Capricorn, which helped them understand their difficulty expressing emotional needs from a different perspective. This insight opened a door to being more compassionate with themselves.',
      'A couple had a relationship compatibility analysis and saw points that complemented each other but also created friction. This helped them begin to see each other\'s differences as growth opportunities rather than threats.',
    ],
    'fr': ['Lors d\'une séance, le client a appris qu\'un transit de Saturne affectait sa maison de carrière...'],
    'de': ['Während einer Sitzung erfuhr der Klient, dass ein Saturn-Transit sein Karrierehaus beeinflusste...'],
    'es': ['Durante una sesión, el cliente aprendió que un tránsito de Saturno estaba afectando su casa de carrera...'],
    'ru': ['Во время сеанса клиент узнал, что транзит Сатурна влияет на его карьерный дом...'],
    'ar': ['خلال الجلسة، علم العميل أن عبور زحل كان يؤثر على بيت حياته المهنية...'],
    'zh': ['在一次会议期间，客户了解到土星过境正在影响他们的事业宫...'],
    'el': ['Κατά τη διάρκεια μιας συνεδρίας, ο πελάτης έμαθε ότι μια διέλευση του Κρόνου επηρέαζε τον οίκο καριέρας του...'],
    'bg': ['По време на сесия клиентът научи, че транзит на Сатурн засяга къщата на кариерата му...'],
  },
  faq: {
    'tr': [
      FAQItem(question: 'Astroloji gerçekten işe yarıyor mu?', answer: 'Astroloji, bilimsel olarak kanıtlanmış bir sistem değildir, ancak binlerce yıldır kendini keşfetme ve anlam arayışı için kullanılan sembolik bir dildir. Etkinliği, kişinin açıklığına ve danışmanın becerisine bağlı olarak değişir. En iyi şekilde bir yansıtma ve düşünme aracı olarak değerlendirilir.'),
      FAQItem(question: 'Doğum saatimi bilmiyorsam ne olur?', answer: 'Doğum saati, yükselen burç ve evlerin hesaplanması için gereklidir. Saat bilinmiyorsa, güneş ve ay konumları ile gezegen aspektleri hala yorumlanabilir, ancak analiz daha sınırlı olur. Bazı astrologlar doğum saati tahmini (rectification) tekniği kullanır.'),
      FAQItem(question: 'Astroloji gelecektimi söyleyebilir mi?', answer: 'Astroloji, kesin gelecek tahminleri yapmaz. Potansiyel enerji kalıplarını ve temaları gösterir, ancak sonuçlar her zaman bireyin özgür iradesine ve seçimlerine bağlıdır.'),
      FAQItem(question: 'Kötü bir haritam varsa ne olur?', answer: '"Kötü" harita yoktur. Her harita benzersiz zorluklara ve armağanlara sahiptir. Zorlayıcı aspektler, büyüme ve dönüşüm potansiyeli taşır.'),
      FAQItem(question: 'Her gün burç yorumu okumak astroloji mi?', answer: 'Günlük burç yorumları, astrolojinin çok basitleştirilmiş bir versiyonudur. Sadece güneş burcuna dayanır ve bireysel haritanızı dikkate almaz. Kişisel bir danışmanlık çok daha derinlikli ve kişiye özel içgörüler sunar.'),
      FAQItem(question: 'İkizler farklı kişiliklere sahipse astroloji nasıl çalışır?', answer: 'İkizler aynı doğum haritasına sahip olsalar da, özgür irade, çevre ve kişisel seçimler farklı kişilikler oluşturur. Astroloji potansiyelleri gösterir, determinizm iddia etmez.'),
      FAQItem(question: 'Astroloji ve astronomi aynı şey mi?', answer: 'Hayır. Astronomi, gök cisimlerini inceleyen bir bilimdir. Astroloji ise bu cisimlerin konumlarını sembolik yorumlama sistemidir. Tarihsel olarak bağlantılıdırlar, ancak bugün farklı disiplinlerdir.'),
      FAQItem(question: 'Burcum bana uymuyor gibi hissediyorum, neden?', answer: 'Muhtemelen sadece güneş burcunuzu biliyorsunuz. Ay burcu, yükselen burç ve diğer gezegen konumları da karakterinizi etkiler. Tam doğum haritası analizi daha bütünsel bir resim sunar.'),
      FAQItem(question: 'Astroloji ile terapi arasındaki fark nedir?', answer: 'Terapi, lisanslı profesyoneller tarafından sunulan, bilimsel temelli psikolojik tedavidir. Astroloji ise sembolik bir yansıtma aracıdır. Astroloji, terapinin yerini almaz ve ciddi psikolojik sorunlar için her zaman profesyonel yardım önerilir.'),
      FAQItem(question: 'Ne sıklıkta danışmanlık almalıyım?', answer: 'Bu tamamen kişisel tercihe bağlıdır. Bazı insanlar yılda bir kez genel bir bakış için, bazıları önemli yaşam geçişlerinde, bazıları ise düzenli olarak tercih eder. Bağımlılık yaratmayan, kendi içgörülerinizi geliştiren bir sıklık idealdir.'),
    ],
    'en': [
      FAQItem(question: 'Does astrology really work?', answer: 'Astrology is not a scientifically proven system, but it is a symbolic language that has been used for self-discovery and meaning-seeking for thousands of years. Its effectiveness varies depending on the person\'s openness and the consultant\'s skill. It is best appreciated as a reflection and contemplation tool.'),
      FAQItem(question: 'What if I don\'t know my birth time?', answer: 'Birth time is needed for calculating the rising sign and houses. Without it, sun and moon positions and planetary aspects can still be interpreted, but the analysis will be more limited. Some astrologers use birth time rectification techniques.'),
      FAQItem(question: 'Can astrology tell my future?', answer: 'Astrology does not make definite future predictions. It shows potential energy patterns and themes, but outcomes always depend on the individual\'s free will and choices.'),
      FAQItem(question: 'What if I have a bad chart?', answer: 'There is no "bad" chart. Every chart has unique challenges and gifts. Challenging aspects carry potential for growth and transformation.'),
      FAQItem(question: 'Is reading daily horoscopes astrology?', answer: 'Daily horoscopes are a very simplified version of astrology. They are based only on sun sign and do not consider your individual chart. A personal consultation offers much deeper and personalized insights.'),
      FAQItem(question: 'How does astrology work if twins have different personalities?', answer: 'Even though twins have the same birth chart, free will, environment, and personal choices create different personalities. Astrology shows potentials, it doesn\'t claim determinism.'),
      FAQItem(question: 'Are astrology and astronomy the same thing?', answer: 'No. Astronomy is a science that studies celestial bodies. Astrology is a system of symbolic interpretation of their positions. They are historically connected but are different disciplines today.'),
      FAQItem(question: 'I feel my sign doesn\'t fit me, why?', answer: 'You probably only know your sun sign. Your moon sign, rising sign, and other planet positions also affect your character. A full birth chart analysis offers a more holistic picture.'),
      FAQItem(question: 'What\'s the difference between astrology and therapy?', answer: 'Therapy is scientifically-based psychological treatment provided by licensed professionals. Astrology is a symbolic reflection tool. Astrology does not replace therapy and professional help is always recommended for serious psychological issues.'),
      FAQItem(question: 'How often should I get a consultation?', answer: 'This is entirely personal preference. Some people prefer once a year for a general overview, some during important life transitions, some regularly. An ideal frequency is one that doesn\'t create dependency and develops your own insights.'),
    ],
    'fr': [FAQItem(question: 'L\'astrologie fonctionne-t-elle vraiment?', answer: 'L\'astrologie n\'est pas un système scientifiquement prouvé...')],
    'de': [FAQItem(question: 'Funktioniert Astrologie wirklich?', answer: 'Astrologie ist kein wissenschaftlich bewiesenes System...')],
    'es': [FAQItem(question: '¿Funciona realmente la astrología?', answer: 'La astrología no es un sistema científicamente probado...')],
    'ru': [FAQItem(question: 'Действительно ли работает астрология?', answer: 'Астрология не является научно доказанной системой...')],
    'ar': [FAQItem(question: 'هل علم الفلك يعمل حقاً؟', answer: 'علم الفلك ليس نظاماً مثبتاً علمياً...')],
    'zh': [FAQItem(question: '占星术真的有用吗？', answer: '占星术不是一个经过科学证明的系统...')],
    'el': [FAQItem(question: 'Λειτουργεί πραγματικά η αστρολογία;', answer: 'Η αστρολογία δεν είναι ένα επιστημονικά αποδεδειγμένο σύστημα...')],
    'bg': [FAQItem(question: 'Работи ли наистина астрологията?', answer: 'Астрологията не е научно доказана система...')],
  },
  relatedPractices: {
    'tr': ['Tarot', 'Numeroloji', 'Kabala', 'Vedik Astroloji', 'Çin Astrolojisi'],
    'en': ['Tarot', 'Numerology', 'Kabbalah', 'Vedic Astrology', 'Chinese Astrology'],
    'fr': ['Tarot', 'Numérologie', 'Kabbale'],
    'de': ['Tarot', 'Numerologie', 'Kabbala'],
    'es': ['Tarot', 'Numerología', 'Cábala'],
    'ru': ['Таро', 'Нумерология', 'Каббала'],
    'ar': ['التاروت', 'علم الأعداد', 'الكابالا'],
    'zh': ['塔罗牌', '数字命理学', '卡巴拉'],
    'el': ['Ταρώ', 'Αριθμολογία', 'Καμπάλα'],
    'bg': ['Таро', 'Нумерология', 'Кабала'],
  },
  differenceFromSimilar: {
    'tr': 'Tarot, anlık enerji okuması sunarken, astroloji doğum anına dayalı sabit bir harita kullanır. Numeroloji sayılarla çalışırken, astroloji gezegen sembolleriyle çalışır. Psikolojik danışmanlık bilimsel temelliyken, astroloji sembolik bir sistemdir.',
    'en': 'Tarot offers an instant energy reading while astrology uses a fixed chart based on the moment of birth. Numerology works with numbers while astrology works with planetary symbols. Psychological counseling is scientifically based while astrology is a symbolic system.',
    'fr': 'Le tarot offre une lecture énergétique instantanée tandis que l\'astrologie utilise un thème fixe basé sur le moment de la naissance.',
    'de': 'Tarot bietet eine sofortige Energielesung, während Astrologie ein festes Horoskop basierend auf dem Geburtsmoment verwendet.',
    'es': 'El tarot ofrece una lectura energética instantánea mientras que la astrología usa una carta fija basada en el momento del nacimiento.',
    'ru': 'Таро предлагает мгновенное энергетическое чтение, тогда как астрология использует фиксированную карту, основанную на моменте рождения.',
    'ar': 'يقدم التاروت قراءة طاقة فورية بينما يستخدم علم الفلك خريطة ثابتة بناءً على لحظة الميلاد.',
    'zh': '塔罗牌提供即时能量解读，而占星术使用基于出生时刻的固定星盘。',
    'el': 'Το ταρώ προσφέρει μια άμεση ενεργειακή ανάγνωση ενώ η αστρολογία χρησιμοποιεί έναν σταθερό χάρτη βασισμένο στη στιγμή της γέννησης.',
    'bg': 'Таро предлага моментно енергийно четене, докато астрологията използва фиксирана карта, базирана на момента на раждане.',
  },
  microLearning: {
    'tr': [
      '💡 Biliyor muydunuz? "Astroloji" kelimesi Yunanca "astron" (yıldız) ve "logos" (bilgi) kelimelerinden gelir.',
      '💡 Biliyor muydunuz? Batlamyos\'un Tetrabiblos\'u, MÖ 2. yüzyılda yazılmış ve hala referans alınan bir astroloji metnidir.',
      '💡 Biliyor muydunuz? Yükselen burç, yaklaşık her 2 saatte bir değişir, bu yüzden doğum saati önemlidir.',
      '💡 Biliyor muydunuz? Carl Jung, astrolojiyi "tüm psikolojik bilginin toplamı" olarak tanımlamıştır.',
      '💡 Biliyor muydunuz? Uranüs, Neptün ve Plüton, teleskopun icadından sonra keşfedilmiş "modern" gezegenlerdir.',
    ],
    'en': [
      '💡 Did you know? The word "astrology" comes from the Greek words "astron" (star) and "logos" (knowledge).',
      '💡 Did you know? Ptolemy\'s Tetrabiblos, written in the 2nd century BCE, is still a referenced astrology text.',
      '💡 Did you know? The rising sign changes approximately every 2 hours, which is why birth time matters.',
      '💡 Did you know? Carl Jung described astrology as "the sum of all psychological knowledge."',
      '💡 Did you know? Uranus, Neptune, and Pluto are "modern" planets discovered after the invention of the telescope.',
    ],
    'fr': ['💡 Le saviez-vous? Le mot "astrologie" vient des mots grecs "astron" (étoile) et "logos" (connaissance).'],
    'de': ['💡 Wussten Sie? Das Wort "Astrologie" kommt von den griechischen Wörtern "astron" (Stern) und "logos" (Wissen).'],
    'es': ['💡 ¿Sabías que? La palabra "astrología" proviene de las palabras griegas "astron" (estrella) y "logos" (conocimiento).'],
    'ru': ['💡 Знаете ли вы? Слово "астрология" происходит от греческих слов "astron" (звезда) и "logos" (знание).'],
    'ar': ['💡 هل تعلم؟ كلمة "علم الفلك" تأتي من الكلمات اليونانية "astron" (نجم) و "logos" (معرفة).'],
    'zh': ['💡 你知道吗？"占星术"一词来自希腊语"astron"（星星）和"logos"（知识）。'],
    'el': ['💡 Το γνωρίζατε; Η λέξη "αστρολογία" προέρχεται από τις ελληνικές λέξεις "άστρον" (αστέρι) και "λόγος" (γνώση).'],
    'bg': ['💡 Знаете ли? Думата "астрология" произлиза от гръцките думи "astron" (звезда) и "logos" (знание).'],
  },
);

// ═══════════════════════════════════════════════════════════════════════════════
// ASTROLOGY - ANNUAL FORECAST
// ═══════════════════════════════════════════════════════════════════════════════

final astrologyAnnualForecast = ServiceContent(
  id: 'astrology_annual_forecast',
  category: ServiceCategory.astrology,
  icon: '📅',
  displayOrder: 2,
  name: {
    'tr': 'Yıllık Astroloji Tahmini',
    'en': 'Annual Astrology Forecast',
    'fr': 'Prévisions Astrologiques Annuelles',
    'de': 'Jährliche Astrologische Vorhersage',
    'es': 'Pronóstico Astrológico Anual',
    'ru': 'Годовой Астрологический Прогноз',
    'ar': 'التوقعات الفلكية السنوية',
    'zh': '年度占星预测',
    'el': 'Ετήσια Αστρολογική Πρόβλεψη',
    'bg': 'Годишна Астрологична Прогноза',
  },
  shortDescription: {
    'tr': 'Önümüzdeki 12 ay için kişiselleştirilmiş kozmik rehberlik ve tema analizi.',
    'en': 'Personalized cosmic guidance and theme analysis for the next 12 months.',
    'fr': 'Guidance cosmique personnalisée et analyse des thèmes pour les 12 prochains mois.',
    'de': 'Personalisierte kosmische Führung und Themenanalyse für die nächsten 12 Monate.',
    'es': 'Guía cósmica personalizada y análisis temático para los próximos 12 meses.',
    'ru': 'Персонализированное космическое руководство и анализ тем на следующие 12 месяцев.',
    'ar': 'إرشاد كوني مخصص وتحليل المواضيع للأشهر الـ 12 القادمة.',
    'zh': '未来12个月的个性化宇宙指导和主题分析。',
    'el': 'Εξατομικευμένη κοσμική καθοδήγηση και ανάλυση θεμάτων για τους επόμενους 12 μήνες.',
    'bg': 'Персонализирано космическо ръководство и анализ на теми за следващите 12 месеца.',
  },
  coreExplanation: {
    'tr': '''
Yıllık astroloji tahmini, doğum haritanızın önümüzdeki 12 ay boyunca aktif olacak transit (geçiş) gezegenlerle nasıl etkileşime gireceğini analiz eder.

Bu analiz, yılın hangi dönemlerinde hangi yaşam alanlarının ön plana çıkacağını, potansiyel fırsatları ve dikkat gerektiren zamanları gösterir. Her ay için ana temalar belirlenir ve yıl boyunca izleyebileceğiniz bir "kozmik harita" sunulur.

Yıllık tahmin, büyük gezegen transitlerini (Jüpiter, Satürn, Uranüs, Neptün, Plüton) ve bunların haritanızdaki önemli noktalarla ilişkisini inceler. Tutulmalar, retro dönemleri ve önemli aspektler de değerlendirilir.

Bu bilgiler kesin öngörüler değil, potansiyel enerji akışları olarak sunulur. Amaç, yıl boyunca bilinçli hareket etmenize ve fırsatları değerlendirmenize yardımcı olmaktır.
''',
    'en': '''
The annual astrology forecast analyzes how your birth chart will interact with transit (passing) planets that will be active over the next 12 months.

This analysis shows which life areas will come to the forefront during which periods of the year, potential opportunities, and times requiring attention. Main themes are identified for each month and a "cosmic map" you can follow throughout the year is presented.

The annual forecast examines major planetary transits (Jupiter, Saturn, Uranus, Neptune, Pluto) and their relationship with important points in your chart. Eclipses, retrograde periods, and significant aspects are also evaluated.

This information is presented as potential energy flows, not definite predictions. The aim is to help you act consciously throughout the year and take advantage of opportunities.
''',
    'fr': '''L'horoscope annuel analyse comment votre thème natal interagira avec les planètes en transit au cours des 12 prochains mois.''',
    'de': '''Die Jahresvorhersage analysiert, wie Ihr Geburtshoroskop mit den Transitplaneten in den nächsten 12 Monaten interagieren wird.''',
    'es': '''El pronóstico anual analiza cómo tu carta natal interactuará con los planetas en tránsito durante los próximos 12 meses.''',
    'ru': '''Годовой прогноз анализирует, как ваша натальная карта будет взаимодействовать с транзитными планетами в течение следующих 12 месяцев.''',
    'ar': '''تحلل التوقعات السنوية كيف ستتفاعل خريطة ميلادك مع الكواكب العابرة خلال الـ 12 شهرًا القادمة.''',
    'zh': '''年度预测分析您的出生图在未来12个月内将如何与过境行星互动。''',
    'el': '''Η ετήσια πρόβλεψη αναλύει πώς ο γενέθλιος χάρτης σας θα αλληλεπιδράσει με τους διερχόμενους πλανήτες τους επόμενους 12 μήνες.''',
    'bg': '''Годишната прогноза анализира как вашата рождена карта ще взаимодейства с транзитните планети през следващите 12 месеца.''',
  },
  historicalBackground: {
    'tr': 'Yıllık astroloji tahminleri, antik dönemden beri krallıklar ve devletler için yapılmaktadır. Babil astronomları yıllık döngüleri takip ederek tarımsal ve politik kararlar için danışmanlık verirdi.',
    'en': 'Annual astrology forecasts have been made for kingdoms and states since ancient times. Babylonian astronomers tracked yearly cycles to provide counsel for agricultural and political decisions.',
    'fr': 'Les prévisions astrologiques annuelles sont faites depuis l\'antiquité.',
    'de': 'Jährliche astrologische Vorhersagen werden seit der Antike gemacht.',
    'es': 'Los pronósticos astrológicos anuales se hacen desde la antigüedad.',
    'ru': 'Годовые астрологические прогнозы делаются с древних времён.',
    'ar': 'تُجرى التوقعات الفلكية السنوية منذ العصور القديمة.',
    'zh': '年度占星预测自古以来就一直在进行。',
    'el': 'Οι ετήσιες αστρολογικές προβλέψεις γίνονται από την αρχαιότητα.',
    'bg': 'Годишните астрологични прогнози се правят от древни времена.',
  },
  philosophicalFoundation: {
    'tr': 'Yıllık tahmin, kozmik döngülerin bireysel yaşamla nasıl rezonans oluşturduğunu inceler. "Zamanın kalitesi" kavramı, belirli dönemlerin belirli aktiviteler için daha uygun olduğu fikrine dayanır.',
    'en': 'Annual forecasting examines how cosmic cycles resonate with individual life. The concept of "quality of time" is based on the idea that certain periods are more suitable for certain activities.',
    'fr': 'Les prévisions annuelles examinent comment les cycles cosmiques résonnent avec la vie individuelle.',
    'de': 'Die Jahresvorhersage untersucht, wie kosmische Zyklen mit dem individuellen Leben resonieren.',
    'es': 'El pronóstico anual examina cómo los ciclos cósmicos resuenan con la vida individual.',
    'ru': 'Годовой прогноз исследует, как космические циклы резонируют с индивидуальной жизнью.',
    'ar': 'تدرس التوقعات السنوية كيف تتردد الدورات الكونية مع الحياة الفردية.',
    'zh': '年度预测研究宇宙周期如何与个人生活产生共鸣。',
    'el': 'Η ετήσια πρόβλεψη εξετάζει πώς οι κοσμικοί κύκλοι συντονίζονται με την ατομική ζωή.',
    'bg': 'Годишната прогноза изследва как космическите цикли резонират с индивидуалния живот.',
  },
  howItWorks: {
    'tr': '''
1. Doğum haritanız temel alınır
2. Önümüzdeki 12 ayın transit haritası hesaplanır
3. Büyük gezegen transitlerinin haritanıza etkileri belirlenir
4. Tutulma dönemleri ve retro fazları işaretlenir
5. Her ay için ana temalar ve odak alanları belirlenir
6. Kritik tarihler ve dönemler vurgulanır
''',
    'en': '''
1. Your birth chart is used as the foundation
2. The transit chart for the next 12 months is calculated
3. Effects of major planetary transits on your chart are identified
4. Eclipse periods and retrograde phases are marked
5. Main themes and focus areas are determined for each month
6. Critical dates and periods are highlighted
''',
    'fr': '''1. Votre thème natal sert de base...''',
    'de': '''1. Ihr Geburtshoroskop dient als Grundlage...''',
    'es': '''1. Tu carta natal se usa como base...''',
    'ru': '''1. Ваша натальная карта используется как основа...''',
    'ar': '''1. تُستخدم خريطة ميلادك كأساس...''',
    'zh': '''1. 以您的出生图为基础...''',
    'el': '''1. Ο γενέθλιος χάρτης σας χρησιμοποιείται ως βάση...''',
    'bg': '''1. Вашата рождена карта се използва като основа...''',
  },
  symbolicInterpretation: {
    'tr': 'Transit gezegenler, yaşamımıza giren dış enerjileri temsil eder. Natal gezegenlerle oluşturdukları aspektler, bu enerjilerin nasıl deneyimleneceğini gösterir.',
    'en': 'Transit planets represent external energies entering our lives. The aspects they form with natal planets show how these energies will be experienced.',
    'fr': 'Les planètes en transit représentent les énergies extérieures entrant dans notre vie.',
    'de': 'Transitplaneten repräsentieren externe Energien, die in unser Leben eintreten.',
    'es': 'Los planetas en tránsito representan energías externas que entran en nuestra vida.',
    'ru': 'Транзитные планеты представляют внешние энергии, входящие в нашу жизнь.',
    'ar': 'تمثل الكواكب العابرة الطاقات الخارجية التي تدخل حياتنا.',
    'zh': '过境行星代表进入我们生活的外部能量。',
    'el': 'Οι διερχόμενοι πλανήτες αντιπροσωπεύουν εξωτερικές ενέργειες που εισέρχονται στη ζωή μας.',
    'bg': 'Транзитните планети представляват външни енергии, влизащи в живота ни.',
  },
  insightsProvided: {
    'tr': 'Yılın hangi dönemlerinde hangi alanlara odaklanmanız gerektiği, fırsat pencereleri, dikkat gerektiren zamanlar ve genel yıllık temalar.',
    'en': 'Which areas to focus on during which periods of the year, opportunity windows, times requiring attention, and overall yearly themes.',
    'fr': 'Quels domaines privilégier à quelles périodes de l\'année.',
    'de': 'Auf welche Bereiche man sich in welchen Jahreszeiten konzentrieren sollte.',
    'es': 'En qué áreas enfocarse durante qué períodos del año.',
    'ru': 'На какие области сосредоточиться в какие периоды года.',
    'ar': 'المجالات التي يجب التركيز عليها خلال فترات السنة المختلفة.',
    'zh': '一年中哪些时期应关注哪些领域。',
    'el': 'Σε ποιους τομείς να εστιάσετε σε ποιες περιόδους του έτους.',
    'bg': 'В кои области да се съсредоточите през кои периоди на годината.',
  },
  commonMotivations: {
    'tr': ['Yeni yıla hazırlanmak', 'Önemli kararlar için zamanlama', 'Kariyer planlaması', 'İlişki döngülerini anlamak', 'Yıl boyunca bilinçli hareket etmek'],
    'en': ['Preparing for the new year', 'Timing for important decisions', 'Career planning', 'Understanding relationship cycles', 'Acting consciously throughout the year'],
    'fr': ['Préparer la nouvelle année'],
    'de': ['Vorbereitung auf das neue Jahr'],
    'es': ['Prepararse para el nuevo año'],
    'ru': ['Подготовка к новому году'],
    'ar': ['التحضير للعام الجديد'],
    'zh': ['为新年做准备'],
    'el': ['Προετοιμασία για το νέο έτος'],
    'bg': ['Подготовка за новата година'],
  },
  lifeThemes: {
    'tr': ['Kariyer', 'İlişkiler', 'Finans', 'Sağlık', 'Eğitim', 'Seyahat', 'Kişisel gelişim'],
    'en': ['Career', 'Relationships', 'Finance', 'Health', 'Education', 'Travel', 'Personal growth'],
    'fr': ['Carrière', 'Relations'],
    'de': ['Karriere', 'Beziehungen'],
    'es': ['Carrera', 'Relaciones'],
    'ru': ['Карьера', 'Отношения'],
    'ar': ['المهنة', 'العلاقات'],
    'zh': ['事业', '关系'],
    'el': ['Καριέρα', 'Σχέσεις'],
    'bg': ['Кариера', 'Отношения'],
  },
  whatYouReceive: {
    'tr': '''
• 12 aylık detaylı transit analizi
• Her ay için ana temalar ve odak alanları
• Önemli tarihler ve dönemler
• Tutulma etkileri
• Retro dönem rehberi
• Kişiselleştirilmiş öneriler
''',
    'en': '''
• Detailed 12-month transit analysis
• Main themes and focus areas for each month
• Important dates and periods
• Eclipse effects
• Retrograde period guide
• Personalized recommendations
''',
    'fr': '''• Analyse détaillée des transits sur 12 mois...''',
    'de': '''• Detaillierte 12-monatige Transitanalyse...''',
    'es': '''• Análisis detallado de tránsitos de 12 meses...''',
    'ru': '''• Детальный анализ транзитов на 12 месяцев...''',
    'ar': '''• تحليل مفصل للعبور لمدة 12 شهرًا...''',
    'zh': '''• 详细的12个月过境分析...''',
    'el': '''• Λεπτομερής ανάλυση διελεύσεων 12 μηνών...''',
    'bg': '''• Подробен 12-месечен транзитен анализ...''',
  },
  perspectiveGained: {
    'tr': 'Yılı bir bütün olarak görerek, reaktif değil proaktif hareket etme imkanı kazanırsınız.',
    'en': 'By seeing the year as a whole, you gain the ability to act proactively rather than reactively.',
    'fr': 'En voyant l\'année dans son ensemble, vous gagnez la capacité d\'agir de manière proactive.',
    'de': 'Indem Sie das Jahr als Ganzes sehen, gewinnen Sie die Fähigkeit, proaktiv zu handeln.',
    'es': 'Al ver el año como un todo, ganas la capacidad de actuar proactivamente.',
    'ru': 'Видя год как целое, вы получаете возможность действовать проактивно.',
    'ar': 'من خلال رؤية العام ككل، تكتسب القدرة على التصرف بشكل استباقي.',
    'zh': '通过将一年视为一个整体，您获得了主动行动的能力。',
    'el': 'Βλέποντας το έτος ως σύνολο, αποκτάτε την ικανότητα να δρείτε προληπτικά.',
    'bg': 'Виждайки годината като цяло, вие придобивате способността да действате проактивно.',
  },
  reflectionPoints: {
    'tr': ['Geçen yıl hangi temalar ön plandaydı?', 'Önümüzdeki yıl için hedefleriniz neler?', 'Hangi alanlarda büyümek istiyorsunuz?'],
    'en': ['What themes were prominent last year?', 'What are your goals for the coming year?', 'In which areas do you want to grow?'],
    'fr': ['Quels thèmes étaient prédominants l\'année dernière?'],
    'de': ['Welche Themen waren im letzten Jahr dominant?'],
    'es': ['¿Qué temas fueron prominentes el año pasado?'],
    'ru': ['Какие темы были ключевыми в прошлом году?'],
    'ar': ['ما الموضوعات التي كانت بارزة العام الماضي؟'],
    'zh': ['去年有哪些主题是突出的？'],
    'el': ['Ποια θέματα ήταν κυρίαρχα πέρυσι;'],
    'bg': ['Кои теми бяха доминиращи миналата година?'],
  },
  safetyDisclaimer: {
    'tr': '''
⚠️ ÖNEMLİ UYARI

Yıllık astroloji tahmini, eğlence ve kendini keşfetme amaçlıdır. Kesin gelecek tahmini yapmaz. Önemli kararlarınızı sadece astrolojiye dayandırmayın. Finansal, tıbbi veya hukuki konularda uzman desteği alın.
''',
    'en': '''
⚠️ IMPORTANT NOTICE

Annual astrology forecast is for entertainment and self-discovery purposes. It does not make definite predictions. Do not base important decisions solely on astrology. Seek expert support for financial, medical, or legal matters.
''',
    'fr': '''⚠️ AVIS IMPORTANT - Les prévisions astrologiques annuelles sont à des fins de divertissement...''',
    'de': '''⚠️ WICHTIGER HINWEIS - Die jährliche astrologische Vorhersage dient der Unterhaltung...''',
    'es': '''⚠️ AVISO IMPORTANTE - El pronóstico astrológico anual es con fines de entretenimiento...''',
    'ru': '''⚠️ ВАЖНОЕ УВЕДОМЛЕНИЕ - Годовой астрологический прогноз предназначен для развлечения...''',
    'ar': '''⚠️ إشعار هام - التوقعات الفلكية السنوية هي لأغراض الترفيه...''',
    'zh': '''⚠️ 重要提示 - 年度占星预测仅供娱乐和自我发现...''',
    'el': '''⚠️ ΣΗΜΑΝΤΙΚΗ ΕΙΔΟΠΟΙΗΣΗ - Η ετήσια αστρολογική πρόβλεψη είναι για ψυχαγωγία...''',
    'bg': '''⚠️ ВАЖНО СЪОБЩЕНИЕ - Годишната астрологична прогноза е за забавление...''',
  },
  doesNotDo: {
    'tr': ['Kesin gelecek tahmini yapmaz', 'Finansal yatırım tavsiyesi vermez', 'Tıbbi teşhis koymaz', 'Kararlarınızı sizin yerinize almaz'],
    'en': ['Does not make definite predictions', 'Does not give financial investment advice', 'Does not diagnose medical conditions', 'Does not make decisions for you'],
    'fr': ['Ne fait pas de prédictions définitives'],
    'de': ['Macht keine definitiven Vorhersagen'],
    'es': ['No hace predicciones definitivas'],
    'ru': ['Не делает определённых предсказаний'],
    'ar': ['لا يقدم تنبؤات قطعية'],
    'zh': ['不做确定的预测'],
    'el': ['Δεν κάνει οριστικές προβλέψεις'],
    'bg': ['Не прави категорични предсказания'],
  },
  exampleScenarios: {
    'tr': ['Bir danışan, Jüpiter transitinin kariyer evini etkileyeceğini öğrendi ve yıl boyunca iş fırsatlarına daha açık olmaya karar verdi.'],
    'en': ['A client learned that Jupiter transit would affect their career house and decided to be more open to job opportunities throughout the year.'],
    'fr': ['Un client a appris que le transit de Jupiter affecterait sa maison de carrière...'],
    'de': ['Ein Klient erfuhr, dass der Jupiter-Transit sein Karrierehaus beeinflussen würde...'],
    'es': ['Un cliente aprendió que el tránsito de Júpiter afectaría su casa de carrera...'],
    'ru': ['Клиент узнал, что транзит Юпитера повлияет на его карьерный дом...'],
    'ar': ['علم عميل أن عبور المشتري سيؤثر على بيت حياته المهنية...'],
    'zh': ['一位客户了解到木星过境将影响他们的事业宫...'],
    'el': ['Ένας πελάτης έμαθε ότι η διέλευση του Δία θα επηρέαζε τον οίκο καριέρας του...'],
    'bg': ['Клиент научи, че транзитът на Юпитер ще засегне къщата на кариерата му...'],
  },
  faq: {
    'tr': [
      FAQItem(question: 'Yıllık tahmin ne zaman yaptırılmalı?', answer: 'İdeal olarak doğum gününüze yakın veya yeni yıl başında. Ancak her zaman yaptırabilirsiniz.'),
      FAQItem(question: 'Tahminler kesin mi?', answer: 'Hayır, bunlar potansiyel enerji akışlarıdır. Sonuçlar özgür iradenize bağlıdır.'),
      FAQItem(question: 'Kötü bir yıl çıkarsa ne olur?', answer: 'Zorlayıcı dönemler bile büyüme fırsatı taşır. Hazırlıklı olmak avantaj sağlar.'),
    ],
    'en': [
      FAQItem(question: 'When should I get an annual forecast?', answer: 'Ideally near your birthday or at the start of the new year. But you can get one anytime.'),
      FAQItem(question: 'Are the predictions definite?', answer: 'No, these are potential energy flows. Outcomes depend on your free will.'),
      FAQItem(question: 'What if a bad year comes up?', answer: 'Even challenging periods carry growth opportunities. Being prepared gives you an advantage.'),
    ],
    'fr': [FAQItem(question: 'Quand dois-je faire mes prévisions annuelles?', answer: 'Idéalement près de votre anniversaire.')],
    'de': [FAQItem(question: 'Wann sollte ich eine Jahresvorhersage machen?', answer: 'Idealerweise nahe Ihrem Geburtstag.')],
    'es': [FAQItem(question: '¿Cuándo debo hacer mi pronóstico anual?', answer: 'Idealmente cerca de tu cumpleaños.')],
    'ru': [FAQItem(question: 'Когда делать годовой прогноз?', answer: 'Идеально - близко к вашему дню рождения.')],
    'ar': [FAQItem(question: 'متى يجب أن أحصل على توقعات سنوية؟', answer: 'من الأفضل بالقرب من عيد ميلادك.')],
    'zh': [FAQItem(question: '什么时候应该做年度预测？', answer: '最好在您生日前后。')],
    'el': [FAQItem(question: 'Πότε πρέπει να κάνω την ετήσια πρόβλεψή μου;', answer: 'Ιδανικά κοντά στα γενέθλιά σας.')],
    'bg': [FAQItem(question: 'Кога да направя годишна прогноза?', answer: 'В идеалния случай близо до рождения ви ден.')],
  },
  relatedPractices: {
    'tr': ['Solar Return', 'Transit Analizi', 'Progresyon'],
    'en': ['Solar Return', 'Transit Analysis', 'Progression'],
    'fr': ['Retour Solaire'],
    'de': ['Solar Return'],
    'es': ['Retorno Solar'],
    'ru': ['Солярный возврат'],
    'ar': ['العودة الشمسية'],
    'zh': ['太阳回归'],
    'el': ['Ηλιακή Επιστροφή'],
    'bg': ['Соларен Завръщане'],
  },
  differenceFromSimilar: {
    'tr': 'Yıllık tahmin, tek seans danışmanlığından farklı olarak 12 aylık bir perspektif sunar. Solar Return ile benzerdir ancak daha genel bir bakış açısı içerir.',
    'en': 'Annual forecast offers a 12-month perspective unlike a single session consultation. Similar to Solar Return but includes a more general overview.',
    'fr': 'Les prévisions annuelles offrent une perspective sur 12 mois.',
    'de': 'Die Jahresvorhersage bietet eine 12-monatige Perspektive.',
    'es': 'El pronóstico anual ofrece una perspectiva de 12 meses.',
    'ru': 'Годовой прогноз предлагает 12-месячную перспективу.',
    'ar': 'تقدم التوقعات السنوية منظوراً لمدة 12 شهراً.',
    'zh': '年度预测提供12个月的视角。',
    'el': 'Η ετήσια πρόβλεψη προσφέρει μια προοπτική 12 μηνών.',
    'bg': 'Годишната прогноза предлага 12-месечна перспектива.',
  },
  microLearning: {
    'tr': ['💡 Jüpiter yaklaşık 12 yılda bir burcu gezer, her burçta yaklaşık 1 yıl kalır.', '💡 Satürn transitleri "Satürn dönüşü" olarak bilinen 29 yıllık döngülerde gelir.'],
    'en': ['💡 Jupiter travels through one sign approximately every 12 years, staying about 1 year in each.', '💡 Saturn transits come in 29-year cycles known as "Saturn return."'],
    'fr': ['💡 Jupiter traverse un signe environ tous les 12 ans.'],
    'de': ['💡 Jupiter durchläuft etwa alle 12 Jahre ein Zeichen.'],
    'es': ['💡 Júpiter atraviesa un signo aproximadamente cada 12 años.'],
    'ru': ['💡 Юпитер проходит один знак примерно каждые 12 лет.'],
    'ar': ['💡 يمر المشتري عبر برج واحد تقريبًا كل 12 عامًا.'],
    'zh': ['💡 木星大约每12年穿越一个星座。'],
    'el': ['💡 Ο Δίας διασχίζει ένα ζώδιο περίπου κάθε 12 χρόνια.'],
    'bg': ['💡 Юпитер преминава през един знак приблизително на всеки 12 години.'],
  },
);

// ═══════════════════════════════════════════════════════════════════════════════
// TAROT SERVICES
// ═══════════════════════════════════════════════════════════════════════════════

final tarotConsultation = ServiceContent(
  id: 'tarot_consultation',
  category: ServiceCategory.tarot,
  icon: '🃏',
  displayOrder: 10,
  name: {
    'tr': 'Tarot Danışmanlığı',
    'en': 'Tarot Consultation',
    'fr': 'Consultation de Tarot',
    'de': 'Tarot-Beratung',
    'es': 'Consulta de Tarot',
    'ru': 'Консультация Таро',
    'ar': 'استشارة التاروت',
    'zh': '塔罗咨询',
    'el': 'Συμβουλευτική Ταρώ',
    'bg': 'Консултация с Таро',
  },
  shortDescription: {
    'tr': 'Kadim tarot kartlarının sembolik diliyle içsel yolculuğunuza ışık tutan bir keşif deneyimi.',
    'en': 'An exploration experience illuminating your inner journey through the symbolic language of ancient tarot cards.',
    'fr': 'Une expérience d\'exploration éclairant votre voyage intérieur à travers le langage symbolique des cartes de tarot anciennes.',
    'de': 'Eine Entdeckungserfahrung, die Ihre innere Reise durch die symbolische Sprache der alten Tarotkarten beleuchtet.',
    'es': 'Una experiencia de exploración que ilumina tu viaje interior a través del lenguaje simbólico de las antiguas cartas del tarot.',
    'ru': 'Опыт исследования, освещающий ваше внутреннее путешествие через символический язык древних карт Таро.',
    'ar': 'تجربة استكشاف تنير رحلتك الداخلية من خلال اللغة الرمزية لبطاقات التاروت القديمة.',
    'zh': '通过古老塔罗牌的象征性语言照亮您内心旅程的探索体验。',
    'el': 'Μια εμπειρία εξερεύνησης που φωτίζει το εσωτερικό σας ταξίδι μέσω της συμβολικής γλώσσας των αρχαίων καρτών ταρώ.',
    'bg': 'Изследователско преживяване, осветяващо вътрешното ви пътуване чрез символичния език на древните карти Таро.',
  },
  coreExplanation: {
    'tr': '''
Tarot, 78 karttan oluşan kadim bir sembol sistemidir. 22 Major Arkana kartı büyük yaşam temalarını, 56 Minor Arkana kartı ise günlük deneyimleri temsil eder.

Bir tarot okumasında, kartlar belirli bir düzende (spread) açılır ve her pozisyon farklı bir yaşam alanını veya zaman dilimini temsil eder. Kartların sembolleri, soran kişinin mevcut durumunu, potansiyel gelişmeleri ve bilinçaltı dinamiklerini yansıtır.

Tarot, "kehanet" değil, bir "yansıtma aracı"dır. Kartlar, zaten içinizde olan bilgiyi yüzeye çıkarmanıza yardımcı olur. İyi bir tarot okuması, size ne yapmanız gerektiğini söylemez; kendi cevaplarınızı bulmanız için bir ayna tutar.

Tarot, psikolojik içgörü, yaratıcı problem çözme ve kişisel gelişim için değerli bir araç olabilir. Semboller evrenseldir ve her bireyin kendi deneyimiyle anlam bulur.
''',
    'en': '''
Tarot is an ancient symbol system consisting of 78 cards. The 22 Major Arcana cards represent major life themes, while the 56 Minor Arcana cards represent daily experiences.

In a tarot reading, cards are laid out in a specific pattern (spread) and each position represents a different life area or time period. The symbols on the cards reflect the querent's current situation, potential developments, and subconscious dynamics.

Tarot is not "fortune-telling" but a "reflection tool." The cards help bring to the surface knowledge that is already within you. A good tarot reading doesn't tell you what to do; it holds up a mirror for you to find your own answers.

Tarot can be a valuable tool for psychological insight, creative problem-solving, and personal development. The symbols are universal and find meaning through each individual's own experience.
''',
    'fr': '''Le tarot est un ancien système symbolique composé de 78 cartes...''',
    'de': '''Tarot ist ein altes Symbolsystem bestehend aus 78 Karten...''',
    'es': '''El tarot es un antiguo sistema de símbolos que consta de 78 cartas...''',
    'ru': '''Таро — это древняя система символов, состоящая из 78 карт...''',
    'ar': '''التاروت هو نظام رموز قديم يتكون من 78 بطاقة...''',
    'zh': '''塔罗是一个由78张牌组成的古老符号系统...''',
    'el': '''Το ταρώ είναι ένα αρχαίο σύστημα συμβόλων αποτελούμενο από 78 κάρτες...''',
    'bg': '''Таро е древна система от символи, състояща се от 78 карти...''',
  },
  historicalBackground: {
    'tr': '''
Tarot kartlarının kökeni 15. yüzyıl İtalya'sına dayanır. Başlangıçta "Tarocchi" adı verilen bir kart oyunu olarak ortaya çıkmıştır. Marseille Tarot, bilinen en eski tarot destelerinden biridir.

18. yüzyılda, Antoine Court de Gébelin tarot kartlarının antik Mısır bilgeliğini içerdiğini iddia etti. Bu teori tarihsel olarak doğrulanmamış olsa da, tarotun ezoterik kullanımının yayılmasına katkıda bulundu.

19. yüzyılda Altın Şafak Tarikatı, tarotı Kabala ve astroloji ile ilişkilendirerek modern okült tarotun temellerini attı. Arthur Edward Waite ve Pamela Colman Smith'in 1909'da yarattığı Rider-Waite destesi, bugün en yaygın kullanılan destedir.

Günümüzde tarot, kendini keşfetme, meditasyon ve psikolojik içgörü aracı olarak dünya genelinde milyonlarca kişi tarafından kullanılmaktadır.
''',
    'en': '''
The origins of tarot cards date back to 15th century Italy. They originally emerged as a card game called "Tarocchi." The Marseille Tarot is one of the oldest known tarot decks.

In the 18th century, Antoine Court de Gébelin claimed that tarot cards contained ancient Egyptian wisdom. Although this theory has not been historically verified, it contributed to the spread of tarot's esoteric use.

In the 19th century, the Order of the Golden Dawn laid the foundations of modern occult tarot by associating tarot with Kabbalah and astrology. The Rider-Waite deck created by Arthur Edward Waite and Pamela Colman Smith in 1909 is the most commonly used deck today.

Today, tarot is used by millions worldwide as a tool for self-discovery, meditation, and psychological insight.
''',
    'fr': '''Les origines des cartes de tarot remontent à l'Italie du 15ème siècle...''',
    'de': '''Die Ursprünge der Tarotkarten reichen bis ins Italien des 15. Jahrhunderts zurück...''',
    'es': '''Los orígenes de las cartas del tarot se remontan a la Italia del siglo XV...''',
    'ru': '''Происхождение карт Таро восходит к Италии 15 века...''',
    'ar': '''تعود أصول بطاقات التاروت إلى إيطاليا في القرن الخامس عشر...''',
    'zh': '''塔罗牌的起源可追溯到15世纪的意大利...''',
    'el': '''Οι ρίζες των καρτών ταρώ χρονολογούνται από την Ιταλία του 15ου αιώνα...''',
    'bg': '''Произходът на картите Таро датира от Италия през 15 век...''',
  },
  philosophicalFoundation: {
    'tr': 'Tarot, Jung\'un kolektif bilinçdışı ve arketip teorileriyle uyumludur. Her kart, evrensel insan deneyimlerini temsil eden bir arketiptir. Senkronisite ilkesi, "anlamlı tesadüfler"in sembolik mesajlar taşıyabileceğini önerir.',
    'en': 'Tarot aligns with Jung\'s theories of the collective unconscious and archetypes. Each card is an archetype representing universal human experiences. The principle of synchronicity suggests that "meaningful coincidences" can carry symbolic messages.',
    'fr': 'Le tarot s\'aligne sur les théories de Jung sur l\'inconscient collectif et les archétypes.',
    'de': 'Tarot stimmt mit Jungs Theorien des kollektiven Unbewussten und der Archetypen überein.',
    'es': 'El tarot se alinea con las teorías de Jung sobre el inconsciente colectivo y los arquetipos.',
    'ru': 'Таро согласуется с теориями Юнга о коллективном бессознательном и архетипах.',
    'ar': 'يتوافق التاروت مع نظريات يونغ حول اللاوعي الجمعي والنماذج الأصلية.',
    'zh': '塔罗与荣格的集体无意识和原型理论相一致。',
    'el': 'Το ταρώ ευθυγραμμίζεται με τις θεωρίες του Γιουνγκ για το συλλογικό ασυνείδητο και τα αρχέτυπα.',
    'bg': 'Таро е в съответствие с теориите на Юнг за колективното несъзнавано и архетипите.',
  },
  howItWorks: {
    'tr': '''
1. NİYET BELİRLEME
Okumaya başlamadan önce, keşfetmek istediğiniz konu veya soru netleştirilir.

2. DESTE KARISTIRMA
Kartlar karıştırılırken, enerji ve niyet aktarımı yapılır.

3. AÇILIM SEÇİMİ
Sorunun doğasına uygun bir açılım (spread) seçilir. Tek kart, üç kart, Celtic Cross gibi farklı açılımlar vardır.

4. KARTLARIN OKUNMASI
Her kart pozisyonuyla birlikte yorumlanır. Semboller, renkler, figürler ve kartların birbirleriyle ilişkisi değerlendirilir.

5. DİYALOG
İyi bir okuma, tek yönlü değil karşılıklı bir keşif sürecidir. Sorular sorulur, paylaşımlar yapılır.

6. ENTEGRASYON
Okuma sonunda, edinilen içgörüler günlük yaşama nasıl uygulanabileceği değerlendirilir.
''',
    'en': '''
1. SETTING INTENTION
Before starting the reading, the topic or question you want to explore is clarified.

2. SHUFFLING THE DECK
While shuffling the cards, energy and intention are transferred.

3. CHOOSING A SPREAD
A spread suitable for the nature of the question is selected. There are different spreads like single card, three cards, Celtic Cross.

4. READING THE CARDS
Each card is interpreted with its position. Symbols, colors, figures, and relationships between cards are evaluated.

5. DIALOGUE
A good reading is a mutual discovery process, not one-way. Questions are asked, sharing occurs.

6. INTEGRATION
At the end of the reading, how the insights gained can be applied to daily life is evaluated.
''',
    'fr': '''1. DÉFINIR L'INTENTION...''',
    'de': '''1. INTENTION FESTLEGEN...''',
    'es': '''1. ESTABLECER INTENCIÓN...''',
    'ru': '''1. ОПРЕДЕЛЕНИЕ НАМЕРЕНИЯ...''',
    'ar': '''1. تحديد النية...''',
    'zh': '''1. 设定意图...''',
    'el': '''1. ΚΑΘΟΡΙΣΜΟΣ ΠΡΟΘΕΣΗΣ...''',
    'bg': '''1. ОПРЕДЕЛЯНЕ НА НАМЕРЕНИЕ...''',
  },
  symbolicInterpretation: {
    'tr': '''
MAJOR ARKANA (22 KART)
Büyük yaşam temaları ve ruhsal yolculuk
0 - Fool: Yeni başlangıçlar, masumiyet
I - Magician: İrade, yaratıcılık
II - High Priestess: Sezgi, gizli bilgi
...

MINOR ARKANA (56 KART)
Günlük deneyimler ve pratik konular
- Asalar (Wands): Tutku, aksiyon, ateş elementi
- Kupalar (Cups): Duygular, ilişkiler, su elementi
- Kılıçlar (Swords): Düşünce, iletişim, hava elementi
- Pentakıller (Pentacles): Maddi dünya, toprak elementi
''',
    'en': '''
MAJOR ARCANA (22 CARDS)
Major life themes and spiritual journey
0 - Fool: New beginnings, innocence
I - Magician: Will, creativity
II - High Priestess: Intuition, hidden knowledge
...

MINOR ARCANA (56 CARDS)
Daily experiences and practical matters
- Wands: Passion, action, fire element
- Cups: Emotions, relationships, water element
- Swords: Thought, communication, air element
- Pentacles: Material world, earth element
''',
    'fr': '''ARCANES MAJEURS (22 CARTES)...''',
    'de': '''GROSSE ARKANA (22 KARTEN)...''',
    'es': '''ARCANOS MAYORES (22 CARTAS)...''',
    'ru': '''СТАРШИЕ АРКАНЫ (22 КАРТЫ)...''',
    'ar': '''الأركانا الكبرى (22 بطاقة)...''',
    'zh': '''大阿尔卡纳（22张牌）...''',
    'el': '''ΜΕΓΑΛΑ ΑΡΚΑΝΑ (22 ΚΑΡΤΕΣ)...''',
    'bg': '''ГОЛЕМИ АРКАНИ (22 КАРТИ)...''',
  },
  insightsProvided: {
    'tr': 'Tarot okuması şunları sunabilir: Mevcut durumunuza yeni bir bakış açısı, bilinçaltı dinamiklerinize farkındalık, karar verme süreçlerinize destek, yaratıcı çözüm önerileri, kişisel gelişim için yansıtma noktaları.',
    'en': 'A tarot reading can offer: A new perspective on your current situation, awareness of your subconscious dynamics, support for your decision-making processes, creative solution suggestions, reflection points for personal growth.',
    'fr': 'Une lecture de tarot peut offrir: Une nouvelle perspective...',
    'de': 'Eine Tarot-Lesung kann bieten: Eine neue Perspektive...',
    'es': 'Una lectura de tarot puede ofrecer: Una nueva perspectiva...',
    'ru': 'Чтение Таро может предложить: Новую перспективу...',
    'ar': 'يمكن أن تقدم قراءة التاروت: منظوراً جديداً...',
    'zh': '塔罗解读可以提供：新的视角...',
    'el': 'Μια ανάγνωση ταρώ μπορεί να προσφέρει: Μια νέα οπτική...',
    'bg': 'Четенето на Таро може да предложи: Нова перспектива...',
  },
  commonMotivations: {
    'tr': ['Bir konuda netlik arıyorum', 'Karar vermekte zorlanıyorum', 'İçsel rehberlik istiyorum', 'Merak ediyorum', 'Zor bir dönemden geçiyorum'],
    'en': ['I\'m seeking clarity on a matter', 'I\'m having difficulty making a decision', 'I want inner guidance', 'I\'m curious', 'I\'m going through a difficult period'],
    'fr': ['Je cherche de la clarté'],
    'de': ['Ich suche Klarheit'],
    'es': ['Busco claridad'],
    'ru': ['Я ищу ясность'],
    'ar': ['أبحث عن الوضوح'],
    'zh': ['我在寻求清晰'],
    'el': ['Αναζητώ σαφήνεια'],
    'bg': ['Търся яснота'],
  },
  lifeThemes: {
    'tr': ['İlişkiler', 'Kariyer', 'Kişisel gelişim', 'Karar verme', 'Ruhsal yolculuk'],
    'en': ['Relationships', 'Career', 'Personal growth', 'Decision making', 'Spiritual journey'],
    'fr': ['Relations'],
    'de': ['Beziehungen'],
    'es': ['Relaciones'],
    'ru': ['Отношения'],
    'ar': ['العلاقات'],
    'zh': ['关系'],
    'el': ['Σχέσεις'],
    'bg': ['Отношения'],
  },
  whatYouReceive: {
    'tr': '''
• Seçilen açılıma göre kart yorumu
• Her kartın anlamı ve pozisyon ilişkisi
• Genel tema ve mesaj özeti
• Pratik öneriler ve yansıtma soruları
''',
    'en': '''
• Card interpretation according to chosen spread
• Meaning of each card and position relationship
• Overall theme and message summary
• Practical suggestions and reflection questions
''',
    'fr': '''• Interprétation des cartes selon le tirage choisi...''',
    'de': '''• Karteninterpretation nach gewählter Legung...''',
    'es': '''• Interpretación de cartas según la tirada elegida...''',
    'ru': '''• Интерпретация карт по выбранному раскладу...''',
    'ar': '''• تفسير البطاقات حسب النشر المختار...''',
    'zh': '''• 根据所选牌阵进行牌解读...''',
    'el': '''• Ερμηνεία καρτών σύμφωνα με το επιλεγμένο άνοιγμα...''',
    'bg': '''• Тълкуване на карти според избраното разтваряне...''',
  },
  perspectiveGained: {
    'tr': 'Tarot, durumunuza "dışarıdan" bakmanızı sağlar. Bilinçaltı kalıpları, kör noktaları ve dikkate almadığınız alternatifleri görebilirsiniz.',
    'en': 'Tarot allows you to look at your situation "from the outside." You can see subconscious patterns, blind spots, and alternatives you haven\'t considered.',
    'fr': 'Le tarot vous permet de regarder votre situation "de l\'extérieur."',
    'de': 'Tarot ermöglicht es Ihnen, Ihre Situation "von außen" zu betrachten.',
    'es': 'El tarot te permite ver tu situación "desde afuera."',
    'ru': 'Таро позволяет взглянуть на вашу ситуацию "со стороны."',
    'ar': 'يتيح لك التاروت النظر إلى وضعك "من الخارج."',
    'zh': '塔罗让您从"外部"看待自己的情况。',
    'el': 'Το ταρώ σας επιτρέπει να δείτε την κατάστασή σας "από έξω."',
    'bg': 'Таро ви позволява да погледнете ситуацията си "отвън."',
  },
  reflectionPoints: {
    'tr': ['Bu konu hakkında gerçekten ne hissediyorum?', 'Hangi seçenekleri görmezden geliyorum?', 'Korkularım kararlarımı nasıl etkiliyor?'],
    'en': ['What do I really feel about this matter?', 'Which options am I ignoring?', 'How are my fears affecting my decisions?'],
    'fr': ['Que ressens-je vraiment à ce sujet?'],
    'de': ['Was fühle ich wirklich dabei?'],
    'es': ['¿Qué siento realmente sobre esto?'],
    'ru': ['Что я действительно чувствую по этому поводу?'],
    'ar': ['ما الذي أشعر به حقًا تجاه هذا الموضوع؟'],
    'zh': ['我对此事真正的感受是什么？'],
    'el': ['Τι νιώθω πραγματικά για αυτό το θέμα;'],
    'bg': ['Какво наистина чувствам за това?'],
  },
  safetyDisclaimer: {
    'tr': '''
⚠️ ÖNEMLİ UYARI

Tarot okuması, eğlence ve kendini keşfetme amaçlıdır. Bu hizmet:
• Kesin gelecek tahmini YAPMAZ
• Tıbbi, hukuki veya finansal danışmanlık DEĞİLDİR
• Profesyonel psikolojik desteğin yerini ALMAZ
• Kararlarınızı sizin yerinize ALMAZ

Tarot, sembolik bir dildir ve sunulan yorumlar olasılık ve potansiyel üzerinedir.
''',
    'en': '''
⚠️ IMPORTANT NOTICE

Tarot reading is for entertainment and self-discovery purposes. This service:
• Does NOT make definite future predictions
• Is NOT medical, legal, or financial advice
• Does NOT replace professional psychological support
• Does NOT make decisions on your behalf

Tarot is a symbolic language and interpretations offered are about possibilities and potential.
''',
    'fr': '''⚠️ AVIS IMPORTANT - La lecture de tarot est à des fins de divertissement...''',
    'de': '''⚠️ WICHTIGER HINWEIS - Das Tarot-Lesen dient der Unterhaltung...''',
    'es': '''⚠️ AVISO IMPORTANTE - La lectura del tarot es con fines de entretenimiento...''',
    'ru': '''⚠️ ВАЖНОЕ УВЕДОМЛЕНИЕ - Чтение Таро предназначено для развлечения...''',
    'ar': '''⚠️ إشعار هام - قراءة التاروت هي لأغراض الترفيه...''',
    'zh': '''⚠️ 重要提示 - 塔罗解读仅供娱乐和自我发现...''',
    'el': '''⚠️ ΣΗΜΑΝΤΙΚΗ ΕΙΔΟΠΟΙΗΣΗ - Η ανάγνωση ταρώ είναι για ψυχαγωγία...''',
    'bg': '''⚠️ ВАЖНО СЪОБЩЕНИЕ - Четенето на Таро е за забавление...''',
  },
  doesNotDo: {
    'tr': ['Kesin gelecek tahmini yapmaz', 'Tıbbi teşhis koymaz', 'Hukuki tavsiye vermez', 'Finansal yatırım önerisi sunmaz', 'Kararlarınızı sizin yerinize almaz'],
    'en': ['Does not make definite predictions', 'Does not diagnose medical conditions', 'Does not give legal advice', 'Does not offer financial investment suggestions', 'Does not make decisions for you'],
    'fr': ['Ne fait pas de prédictions définitives'],
    'de': ['Macht keine definitiven Vorhersagen'],
    'es': ['No hace predicciones definitivas'],
    'ru': ['Не делает определённых предсказаний'],
    'ar': ['لا يقدم تنبؤات قطعية'],
    'zh': ['不做确定的预测'],
    'el': ['Δεν κάνει οριστικές προβλέψεις'],
    'bg': ['Не прави категорични предсказания'],
  },
  exampleScenarios: {
    'tr': ['Kariyer değişikliği düşünen biri, üç kart açılımında mevcut durumunu, engellerini ve potansiyel sonucu gösteren kartlar aldı. Kartlar, korkuların ötesine geçme ve risk alma temalarını vurguladı.'],
    'en': ['Someone considering a career change received cards showing their current situation, obstacles, and potential outcome in a three-card spread. The cards emphasized themes of moving beyond fears and taking risks.'],
    'fr': ['Une personne envisageant un changement de carrière...'],
    'de': ['Jemand, der einen Karrierewechsel in Betracht zieht...'],
    'es': ['Alguien que consideraba un cambio de carrera...'],
    'ru': ['Кто-то, размышляющий о смене карьеры...'],
    'ar': ['شخص يفكر في تغيير مهنته...'],
    'zh': ['一个考虑换工作的人...'],
    'el': ['Κάποιος που σκέφτεται αλλαγή καριέρας...'],
    'bg': ['Някой, който обмисля промяна на кариерата...'],
  },
  faq: {
    'tr': [
      FAQItem(question: 'Tarot kartları gerçekten geleceği gösterir mi?', answer: 'Tarot kesin gelecek tahmini yapmaz. Potansiyel enerji akışlarını ve olasılıkları gösterir. Sonuç her zaman bireyin özgür iradesine bağlıdır.'),
      FAQItem(question: 'Kendi kartlarımı okuyabilir miyim?', answer: 'Evet, tarot kendi kendine okuma için de kullanılabilir. Ancak objektif olmak zor olabilir; bu nedenle başkasından okutmak farklı bir perspektif sunabilir.'),
      FAQItem(question: 'Ters çıkan kartlar kötü mü demek?', answer: 'Hayır, ters kartlar "kötü" değildir. Enerjinin bloke olduğunu, içselleştirildiğini veya farklı bir şekilde ifade edildiğini gösterebilir.'),
      FAQItem(question: 'Tarot dinle çelişir mi?', answer: 'Bu kişisel bir inanç meselesidir. Bazı kişiler tarotı inanç sistemleriyle uyumlu bulurken, bazıları bulmaz. Karar tamamen size aittir.'),
      FAQItem(question: 'Aynı soruyu tekrar sorabilir miyim?', answer: 'Tekrar sormak genellikle önerilmez çünkü ilk okumadaki mesajı kabullenmemekten kaynaklanabilir. Ancak zaman geçtikten sonra yeni bir okuma yapılabilir.'),
    ],
    'en': [
      FAQItem(question: 'Do tarot cards really show the future?', answer: 'Tarot does not make definite future predictions. It shows potential energy flows and possibilities. The outcome always depends on the individual\'s free will.'),
      FAQItem(question: 'Can I read my own cards?', answer: 'Yes, tarot can be used for self-reading too. However, being objective can be difficult; therefore getting a reading from someone else can offer a different perspective.'),
      FAQItem(question: 'Do reversed cards mean something bad?', answer: 'No, reversed cards are not "bad." They can indicate that energy is blocked, internalized, or expressed differently.'),
      FAQItem(question: 'Does tarot conflict with religion?', answer: 'This is a matter of personal belief. Some people find tarot compatible with their belief systems, others don\'t. The decision is entirely yours.'),
      FAQItem(question: 'Can I ask the same question again?', answer: 'Asking again is generally not recommended as it may stem from not accepting the message in the first reading. However, a new reading can be done after time has passed.'),
    ],
    'fr': [FAQItem(question: 'Les cartes de tarot montrent-elles vraiment l\'avenir?', answer: 'Le tarot ne fait pas de prédictions définitives...')],
    'de': [FAQItem(question: 'Zeigen Tarotkarten wirklich die Zukunft?', answer: 'Tarot macht keine definitiven Vorhersagen...')],
    'es': [FAQItem(question: '¿Las cartas del tarot realmente muestran el futuro?', answer: 'El tarot no hace predicciones definitivas...')],
    'ru': [FAQItem(question: 'Карты Таро действительно показывают будущее?', answer: 'Таро не делает определённых предсказаний...')],
    'ar': [FAQItem(question: 'هل بطاقات التاروت تظهر المستقبل حقًا؟', answer: 'التاروت لا يقدم تنبؤات قطعية...')],
    'zh': [FAQItem(question: '塔罗牌真的能显示未来吗？', answer: '塔罗不做确定的预测...')],
    'el': [FAQItem(question: 'Οι κάρτες ταρώ δείχνουν πραγματικά το μέλλον;', answer: 'Το ταρώ δεν κάνει οριστικές προβλέψεις...')],
    'bg': [FAQItem(question: 'Картите Таро наистина ли показват бъдещето?', answer: 'Таро не прави категорични предсказания...')],
  },
  relatedPractices: {
    'tr': ['Astroloji', 'Numeroloji', 'Oracle Kartları', 'Rün Okuma'],
    'en': ['Astrology', 'Numerology', 'Oracle Cards', 'Rune Reading'],
    'fr': ['Astrologie', 'Numérologie'],
    'de': ['Astrologie', 'Numerologie'],
    'es': ['Astrología', 'Numerología'],
    'ru': ['Астрология', 'Нумерология'],
    'ar': ['علم الفلك', 'علم الأعداد'],
    'zh': ['占星术', '数字命理学'],
    'el': ['Αστρολογία', 'Αριθμολογία'],
    'bg': ['Астрология', 'Нумерология'],
  },
  differenceFromSimilar: {
    'tr': 'Astroloji doğum anına dayalı sabit bir harita kullanırken, tarot anlık enerji okuması sunar. Oracle kartları tarottan farklı olarak standart bir yapıya sahip değildir.',
    'en': 'Astrology uses a fixed chart based on the moment of birth, while tarot offers an instant energy reading. Oracle cards, unlike tarot, do not have a standard structure.',
    'fr': 'L\'astrologie utilise un thème fixe basé sur le moment de la naissance, tandis que le tarot offre une lecture énergétique instantanée.',
    'de': 'Astrologie verwendet ein festes Horoskop basierend auf dem Geburtsmoment, während Tarot eine sofortige Energielesung bietet.',
    'es': 'La astrología usa una carta fija basada en el momento del nacimiento, mientras que el tarot ofrece una lectura energética instantánea.',
    'ru': 'Астрология использует фиксированную карту, основанную на моменте рождения, тогда как Таро предлагает мгновенное энергетическое чтение.',
    'ar': 'يستخدم علم الفلك خريطة ثابتة بناءً على لحظة الميلاد، بينما يقدم التاروت قراءة طاقة فورية.',
    'zh': '占星术使用基于出生时刻的固定星盘，而塔罗提供即时能量解读。',
    'el': 'Η αστρολογία χρησιμοποιεί έναν σταθερό χάρτη βασισμένο στη στιγμή της γέννησης, ενώ το ταρώ προσφέρει μια άμεση ενεργειακή ανάγνωση.',
    'bg': 'Астрологията използва фиксирана карта, базирана на момента на раждане, докато Таро предлага моментно енергийно четене.',
  },
  microLearning: {
    'tr': ['💡 Standart tarot destesi 78 karttan oluşur: 22 Major Arkana ve 56 Minor Arkana.', '💡 En popüler tarot destesi 1909\'da yaratılan Rider-Waite destesidir.', '💡 "Arkana" kelimesi Latince "gizli" anlamına gelir.'],
    'en': ['💡 A standard tarot deck consists of 78 cards: 22 Major Arcana and 56 Minor Arcana.', '💡 The most popular tarot deck is the Rider-Waite deck created in 1909.', '💡 The word "Arcana" comes from Latin meaning "secret."'],
    'fr': ['💡 Un jeu de tarot standard comprend 78 cartes.'],
    'de': ['💡 Ein Standard-Tarot-Deck besteht aus 78 Karten.'],
    'es': ['💡 Una baraja de tarot estándar consta de 78 cartas.'],
    'ru': ['💡 Стандартная колода Таро состоит из 78 карт.'],
    'ar': ['💡 تتكون مجموعة التاروت القياسية من 78 بطاقة.'],
    'zh': ['💡 标准塔罗牌组由78张牌组成。'],
    'el': ['💡 Μια τυπική τράπουλα ταρώ αποτελείται από 78 κάρτες.'],
    'bg': ['💡 Стандартното тесте Таро се състои от 78 карти.'],
  },
);

// ═══════════════════════════════════════════════════════════════════════════════
// NUMEROLOGY SERVICES
// ═══════════════════════════════════════════════════════════════════════════════

final numerologyAnalysis = ServiceContent(
  id: 'numerology_analysis',
  category: ServiceCategory.numerology,
  icon: '🔢',
  displayOrder: 20,
  name: {
    'tr': 'Numeroloji Analizi',
    'en': 'Numerology Analysis',
    'fr': 'Analyse Numérologique',
    'de': 'Numerologische Analyse',
    'es': 'Análisis Numerológico',
    'ru': 'Нумерологический Анализ',
    'ar': 'تحليل الأرقام',
    'zh': '数字命理分析',
    'el': 'Αριθμολογική Ανάλυση',
    'bg': 'Нумерологичен Анализ',
  },
  shortDescription: {
    'tr': 'Doğum tarihiniz ve isminizin sayısal titreşimlerini keşfederek yaşam amacınızı ve potansiyelinizi anlayın.',
    'en': 'Understand your life purpose and potential by exploring the numerical vibrations of your birth date and name.',
    'fr': 'Comprenez votre but de vie et votre potentiel en explorant les vibrations numériques de votre date de naissance et de votre nom.',
    'de': 'Verstehen Sie Ihren Lebenszweck und Ihr Potenzial, indem Sie die numerischen Schwingungen Ihres Geburtsdatums und Namens erforschen.',
    'es': 'Comprende tu propósito de vida y potencial explorando las vibraciones numéricas de tu fecha de nacimiento y nombre.',
    'ru': 'Поймите цель своей жизни и потенциал, исследуя числовые вибрации вашей даты рождения и имени.',
    'ar': 'افهم غرض حياتك وإمكانياتك من خلال استكشاف الاهتزازات العددية لتاريخ ميلادك واسمك.',
    'zh': '通过探索您出生日期和姓名的数字振动来了解您的人生目的和潜力。',
    'el': 'Κατανοήστε τον σκοπό της ζωής σας και τις δυνατότητές σας εξερευνώντας τις αριθμητικές δονήσεις της ημερομηνίας γέννησής σας και του ονόματός σας.',
    'bg': 'Разберете целта на живота си и потенциала си, изследвайки числовите вибрации на датата на раждане и името си.',
  },
  coreExplanation: {
    'tr': '''
Numeroloji, sayıların sembolik anlamlarını ve titreşimlerini inceleyen kadim bir bilgi sistemidir. Temel ilkesi, her sayının benzersiz bir enerji ve anlam taşıdığı fikridir.

Numeroloji analizinde üç temel sayı hesaplanır:
1. Yaşam Yolu Sayısı (Life Path): Doğum tarihinizden hesaplanır, yaşam amacınızı gösterir
2. İfade Sayısı (Expression): Tam adınızdan hesaplanır, doğal yeteneklerinizi gösterir
3. Ruh Dürtüsü Sayısı (Soul Urge): Adınızdaki sesli harflerden hesaplanır, iç motivasyonlarınızı gösterir

Bu sayılar 1-9 arasında tek haneli sayılara (ve özel anlam taşıyan 11, 22, 33 "master" sayılarına) indirgenir. Her sayının kendine özgü karakteristikleri vardır.

Numeroloji, deterministik değil, sembolik bir sistemdir. Sayılar potansiyelleri gösterir, kader belirlemez.
''',
    'en': '''
Numerology is an ancient knowledge system that examines the symbolic meanings and vibrations of numbers. Its fundamental principle is that each number carries a unique energy and meaning.

In numerology analysis, three basic numbers are calculated:
1. Life Path Number: Calculated from your birth date, shows your life purpose
2. Expression Number: Calculated from your full name, shows your natural talents
3. Soul Urge Number: Calculated from vowels in your name, shows your inner motivations

These numbers are reduced to single digits between 1-9 (and special meaning "master" numbers 11, 22, 33). Each number has its own characteristics.

Numerology is a symbolic system, not deterministic. Numbers show potentials, they don't determine fate.
''',
    'fr': '''La numérologie est un ancien système de connaissance qui examine les significations symboliques des nombres...''',
    'de': '''Numerologie ist ein altes Wissenssystem, das die symbolischen Bedeutungen von Zahlen untersucht...''',
    'es': '''La numerología es un antiguo sistema de conocimiento que examina los significados simbólicos de los números...''',
    'ru': '''Нумерология — это древняя система знаний, изучающая символические значения чисел...''',
    'ar': '''علم الأعداد هو نظام معرفة قديم يدرس المعاني الرمزية للأرقام...''',
    'zh': '''数字命理学是一个研究数字象征意义和振动的古老知识系统...''',
    'el': '''Η αριθμολογία είναι ένα αρχαίο σύστημα γνώσης που εξετάζει τις συμβολικές έννοιες των αριθμών...''',
    'bg': '''Нумерологията е древна система от знания, която изследва символичните значения на числата...''',
  },
  historicalBackground: {
    'tr': 'Numerolojinin kökleri antik Babil, Mısır ve Yunanistan\'a uzanır. Pythagoras, sayıların evrenin temelini oluşturduğuna inanıyordu. Modern Batı numerolojisi 20. yüzyılda L. Dow Balliett tarafından popülerleştirildi.',
    'en': 'The roots of numerology extend to ancient Babylon, Egypt, and Greece. Pythagoras believed that numbers formed the foundation of the universe. Modern Western numerology was popularized by L. Dow Balliett in the 20th century.',
    'fr': 'Les racines de la numérologie remontent à l\'ancienne Babylone, l\'Égypte et la Grèce.',
    'de': 'Die Wurzeln der Numerologie reichen bis ins alte Babylon, Ägypten und Griechenland zurück.',
    'es': 'Las raíces de la numerología se extienden a la antigua Babilonia, Egipto y Grecia.',
    'ru': 'Корни нумерологии уходят в древний Вавилон, Египет и Грецию.',
    'ar': 'تمتد جذور علم الأعداد إلى بابل القديمة ومصر واليونان.',
    'zh': '数字命理学的根源可追溯到古巴比伦、埃及和希腊。',
    'el': 'Οι ρίζες της αριθμολογίας εκτείνονται στην αρχαία Βαβυλώνα, την Αίγυπτο και την Ελλάδα.',
    'bg': 'Корените на нумерологията се простират до древен Вавилон, Египет и Гърция.',
  },
  philosophicalFoundation: {
    'tr': 'Pythagoras\'ın "Her şey sayıdır" felsefesi numerolojinin temelini oluşturur. Sayılar, evrenin matematiksel düzeninin sembolik ifadeleri olarak görülür.',
    'en': 'Pythagoras\' philosophy "Everything is number" forms the foundation of numerology. Numbers are seen as symbolic expressions of the mathematical order of the universe.',
    'fr': 'La philosophie de Pythagore "Tout est nombre" forme la base de la numérologie.',
    'de': 'Pythagoras\' Philosophie "Alles ist Zahl" bildet die Grundlage der Numerologie.',
    'es': 'La filosofía de Pitágoras "Todo es número" forma la base de la numerología.',
    'ru': 'Философия Пифагора "Всё есть число" составляет основу нумерологии.',
    'ar': 'فلسفة فيثاغورس "كل شيء رقم" تشكل أساس علم الأعداد.',
    'zh': '毕达哥拉斯的"万物皆数"哲学构成了数字命理学的基础。',
    'el': 'Η φιλοσοφία του Πυθαγόρα "Τα πάντα είναι αριθμός" αποτελεί τη βάση της αριθμολογίας.',
    'bg': 'Философията на Питагор "Всичко е число" съставлява основата на нумерологията.',
  },
  howItWorks: {
    'tr': '''
1. YAŞAM YOLU SAYISI HESAPLAMA
Doğum tarihiniz tek haneli sayıya indirgenir.
Örnek: 15/03/1990 → 1+5+0+3+1+9+9+0 = 28 → 2+8 = 10 → 1+0 = 1

2. İFADE SAYISI HESAPLAMA
Tam adınızdaki harfler sayılara dönüştürülür (A=1, B=2... I=9, J=1...)

3. RUH DÜRTÜSÜ HESAPLAMA
Sadece adınızdaki sesli harfler (A, E, I, O, U) hesaplanır.

4. YORUM
Her sayının anlamı ve birbirleriyle ilişkisi analiz edilir.
''',
    'en': '''
1. LIFE PATH NUMBER CALCULATION
Your birth date is reduced to a single digit.
Example: 15/03/1990 → 1+5+0+3+1+9+9+0 = 28 → 2+8 = 10 → 1+0 = 1

2. EXPRESSION NUMBER CALCULATION
Letters in your full name are converted to numbers (A=1, B=2... I=9, J=1...)

3. SOUL URGE CALCULATION
Only vowels (A, E, I, O, U) in your name are calculated.

4. INTERPRETATION
The meaning of each number and their relationships are analyzed.
''',
    'fr': '''1. CALCUL DU CHEMIN DE VIE...''',
    'de': '''1. BERECHNUNG DER LEBENSZAHL...''',
    'es': '''1. CÁLCULO DEL NÚMERO DE VIDA...''',
    'ru': '''1. РАСЧЁТ ЧИСЛА ЖИЗНЕННОГО ПУТИ...''',
    'ar': '''1. حساب رقم مسار الحياة...''',
    'zh': '''1. 生命路径数计算...''',
    'el': '''1. ΥΠΟΛΟΓΙΣΜΟΣ ΑΡΙΘΜΟΥ ΔΙΑΔΡΟΜΗΣ ΖΩΗΣ...''',
    'bg': '''1. ИЗЧИСЛЯВАНЕ НА ЧИСЛОТО НА ЖИЗНЕНИЯ ПЪТ...''',
  },
  symbolicInterpretation: {
    'tr': '''
TEMEL SAYILAR:
1 - Liderlik, bağımsızlık, yenilik
2 - İşbirliği, denge, diplomasi
3 - Yaratıcılık, ifade, sosyallik
4 - Pratiklik, düzen, istikrar
5 - Özgürlük, değişim, macera
6 - Sorumluluk, aile, uyum
7 - Analiz, maneviyat, içgözlem
8 - Güç, başarı, maddi dünya
9 - İnsancıllık, tamamlama, bilgelik

MASTER SAYILAR:
11 - Sezgi, ilham, ruhsal aydınlanma
22 - Master inşaatçı, büyük vizyon
33 - Master öğretmen, şefkat
''',
    'en': '''
CORE NUMBERS:
1 - Leadership, independence, innovation
2 - Cooperation, balance, diplomacy
3 - Creativity, expression, sociability
4 - Practicality, order, stability
5 - Freedom, change, adventure
6 - Responsibility, family, harmony
7 - Analysis, spirituality, introspection
8 - Power, success, material world
9 - Humanitarianism, completion, wisdom

MASTER NUMBERS:
11 - Intuition, inspiration, spiritual enlightenment
22 - Master builder, great vision
33 - Master teacher, compassion
''',
    'fr': '''NOMBRES FONDAMENTAUX...''',
    'de': '''GRUNDZAHLEN...''',
    'es': '''NÚMEROS BÁSICOS...''',
    'ru': '''ОСНОВНЫЕ ЧИСЛА...''',
    'ar': '''الأرقام الأساسية...''',
    'zh': '''核心数字...''',
    'el': '''ΒΑΣΙΚΟΙ ΑΡΙΘΜΟΙ...''',
    'bg': '''ОСНОВНИ ЧИСЛА...''',
  },
  insightsProvided: {
    'tr': 'Yaşam amacınız ve potansiyel güçlü yönleriniz, doğal yetenekleriniz, iç motivasyonlarınız, kişisel yılınızın enerjisi.',
    'en': 'Your life purpose and potential strengths, natural talents, inner motivations, your personal year energy.',
    'fr': 'Votre but de vie et vos forces potentielles...',
    'de': 'Ihr Lebenszweck und potenzielle Stärken...',
    'es': 'Tu propósito de vida y fortalezas potenciales...',
    'ru': 'Цель вашей жизни и потенциальные сильные стороны...',
    'ar': 'غرض حياتك ونقاط قوتك المحتملة...',
    'zh': '您的人生目的和潜在优势...',
    'el': 'Ο σκοπός της ζωής σας και οι δυνητικές δυνάμεις σας...',
    'bg': 'Целта на живота ви и потенциалните ви силни страни...',
  },
  commonMotivations: {
    'tr': ['Yaşam amacımı anlamak', 'Güçlü yönlerimi keşfetmek', 'Yıllık enerjimi öğrenmek', 'Kendimi daha iyi tanımak'],
    'en': ['Understanding my life purpose', 'Discovering my strengths', 'Learning my yearly energy', 'Knowing myself better'],
    'fr': ['Comprendre mon but de vie'],
    'de': ['Meinen Lebenszweck verstehen'],
    'es': ['Entender mi propósito de vida'],
    'ru': ['Понять цель моей жизни'],
    'ar': ['فهم غرض حياتي'],
    'zh': ['了解我的人生目的'],
    'el': ['Κατανόηση του σκοπού της ζωής μου'],
    'bg': ['Разбиране на целта на живота ми'],
  },
  lifeThemes: {
    'tr': ['Yaşam amacı', 'Kariyer', 'İlişkiler', 'Kişisel gelişim', 'Yıllık döngüler'],
    'en': ['Life purpose', 'Career', 'Relationships', 'Personal growth', 'Yearly cycles'],
    'fr': ['But de vie'],
    'de': ['Lebenszweck'],
    'es': ['Propósito de vida'],
    'ru': ['Цель жизни'],
    'ar': ['غرض الحياة'],
    'zh': ['人生目的'],
    'el': ['Σκοπός ζωής'],
    'bg': ['Цел на живота'],
  },
  whatYouReceive: {
    'tr': '''
• Yaşam Yolu Sayısı analizi
• İfade Sayısı analizi
• Ruh Dürtüsü Sayısı analizi
• Kişisel Yıl hesaplaması
• Sayıların birbirleriyle ilişkisi
• Pratik öneriler
''',
    'en': '''
• Life Path Number analysis
• Expression Number analysis
• Soul Urge Number analysis
• Personal Year calculation
• Relationship between numbers
• Practical suggestions
''',
    'fr': '''• Analyse du Chemin de Vie...''',
    'de': '''• Analyse der Lebenszahl...''',
    'es': '''• Análisis del Número de Vida...''',
    'ru': '''• Анализ числа жизненного пути...''',
    'ar': '''• تحليل رقم مسار الحياة...''',
    'zh': '''• 生命路径数分析...''',
    'el': '''• Ανάλυση Αριθμού Διαδρομής Ζωής...''',
    'bg': '''• Анализ на числото на жизнения път...''',
  },
  perspectiveGained: {
    'tr': 'Sayılar aracılığıyla kendinizi ve yaşam kalıplarınızı yeni bir perspektiften görürsünüz.',
    'en': 'Through numbers, you see yourself and your life patterns from a new perspective.',
    'fr': 'À travers les nombres, vous voyez vous-même d\'une nouvelle perspective.',
    'de': 'Durch Zahlen sehen Sie sich selbst aus einer neuen Perspektive.',
    'es': 'A través de los números, te ves desde una nueva perspectiva.',
    'ru': 'Через числа вы видите себя с новой перспективы.',
    'ar': 'من خلال الأرقام، ترى نفسك من منظور جديد.',
    'zh': '通过数字，您从新的角度看待自己。',
    'el': 'Μέσω των αριθμών, βλέπετε τον εαυτό σας από μια νέα οπτική.',
    'bg': 'Чрез числата виждате себе си от нова перспектива.',
  },
  reflectionPoints: {
    'tr': ['Sayılarınız size ne söylüyor?', 'Güçlü yönlerinizi nasıl kullanıyorsunuz?', 'Zorlu alanlarınız neler?'],
    'en': ['What do your numbers tell you?', 'How are you using your strengths?', 'What are your challenging areas?'],
    'fr': ['Que vous disent vos nombres?'],
    'de': ['Was sagen Ihnen Ihre Zahlen?'],
    'es': ['¿Qué te dicen tus números?'],
    'ru': ['Что говорят вам ваши числа?'],
    'ar': ['ماذا تخبرك أرقامك؟'],
    'zh': ['您的数字告诉您什么？'],
    'el': ['Τι σας λένε οι αριθμοί σας;'],
    'bg': ['Какво ви казват числата ви?'],
  },
  safetyDisclaimer: {
    'tr': '''
⚠️ ÖNEMLİ UYARI

Numeroloji analizi eğlence ve kendini keşfetme amaçlıdır. Kesin yaşam yönlendirmesi yapmaz. Önemli kararlarınızı sadece numerolojiye dayandırmayın.
''',
    'en': '''
⚠️ IMPORTANT NOTICE

Numerology analysis is for entertainment and self-discovery purposes. It does not provide definite life guidance. Do not base important decisions solely on numerology.
''',
    'fr': '''⚠️ AVIS IMPORTANT - L'analyse numérologique est à des fins de divertissement...''',
    'de': '''⚠️ WICHTIGER HINWEIS - Die numerologische Analyse dient der Unterhaltung...''',
    'es': '''⚠️ AVISO IMPORTANTE - El análisis numerológico es con fines de entretenimiento...''',
    'ru': '''⚠️ ВАЖНОЕ УВЕДОМЛЕНИЕ - Нумерологический анализ предназначен для развлечения...''',
    'ar': '''⚠️ إشعار هام - تحليل الأرقام هو لأغراض الترفيه...''',
    'zh': '''⚠️ 重要提示 - 数字命理分析仅供娱乐和自我发现...''',
    'el': '''⚠️ ΣΗΜΑΝΤΙΚΗ ΕΙΔΟΠΟΙΗΣΗ - Η αριθμολογική ανάλυση είναι για ψυχαγωγία...''',
    'bg': '''⚠️ ВАЖНО СЪОБЩЕНИЕ - Нумерологичният анализ е за забавление...''',
  },
  doesNotDo: {
    'tr': ['Kesin gelecek tahmini yapmaz', 'Tıbbi teşhis koymaz', 'Finansal tavsiye vermez', 'Kader belirlemez'],
    'en': ['Does not make definite predictions', 'Does not diagnose medical conditions', 'Does not give financial advice', 'Does not determine fate'],
    'fr': ['Ne fait pas de prédictions définitives'],
    'de': ['Macht keine definitiven Vorhersagen'],
    'es': ['No hace predicciones definitivas'],
    'ru': ['Не делает определённых предсказаний'],
    'ar': ['لا يقدم تنبؤات قطعية'],
    'zh': ['不做确定的预测'],
    'el': ['Δεν κάνει οριστικές προβλέψεις'],
    'bg': ['Не прави категорични предсказания'],
  },
  exampleScenarios: {
    'tr': ['Yaşam yolu 8 olan bir kişi, kariyer başarısına doğal yatkınlığını keşfetti ve liderlik rollerine daha bilinçli yaklaşmaya başladı.'],
    'en': ['A person with life path 8 discovered their natural inclination toward career success and began approaching leadership roles more consciously.'],
    'fr': ['Une personne avec un chemin de vie 8 a découvert...'],
    'de': ['Eine Person mit Lebenszahl 8 entdeckte...'],
    'es': ['Una persona con camino de vida 8 descubrió...'],
    'ru': ['Человек с числом жизненного пути 8 обнаружил...'],
    'ar': ['اكتشف شخص يحمل رقم مسار حياة 8...'],
    'zh': ['一个生命路径8的人发现了...'],
    'el': ['Ένα άτομο με αριθμό διαδρομής ζωής 8 ανακάλυψε...'],
    'bg': ['Човек с число на жизнения път 8 откри...'],
  },
  faq: {
    'tr': [
      FAQItem(question: 'Numeroloji bilimsel mi?', answer: 'Numeroloji bilimsel olarak kanıtlanmış bir sistem değildir. Sembolik bir dildir ve kendini keşfetme aracı olarak kullanılır.'),
      FAQItem(question: 'İsim değişikliği sayıları etkiler mi?', answer: 'Evet, yeni isminiz yeni titreşimler taşır. Ancak doğum isminiz hala temel enerjinizi temsil eder.'),
      FAQItem(question: 'Master sayılar özel mi?', answer: '11, 22, 33 sayıları güçlü potansiyeller taşır ancak bu potansiyelin gerçekleşmesi kişiye bağlıdır.'),
    ],
    'en': [
      FAQItem(question: 'Is numerology scientific?', answer: 'Numerology is not a scientifically proven system. It is a symbolic language used as a self-discovery tool.'),
      FAQItem(question: 'Does name change affect numbers?', answer: 'Yes, your new name carries new vibrations. However, your birth name still represents your core energy.'),
      FAQItem(question: 'Are master numbers special?', answer: 'Numbers 11, 22, 33 carry strong potentials but realizing this potential depends on the individual.'),
    ],
    'fr': [FAQItem(question: 'La numérologie est-elle scientifique?', answer: 'La numérologie n\'est pas un système scientifiquement prouvé.')],
    'de': [FAQItem(question: 'Ist Numerologie wissenschaftlich?', answer: 'Numerologie ist kein wissenschaftlich bewiesenes System.')],
    'es': [FAQItem(question: '¿Es científica la numerología?', answer: 'La numerología no es un sistema científicamente probado.')],
    'ru': [FAQItem(question: 'Нумерология научна?', answer: 'Нумерология не является научно доказанной системой.')],
    'ar': [FAQItem(question: 'هل علم الأعداد علمي؟', answer: 'علم الأعداد ليس نظامًا مثبتًا علميًا.')],
    'zh': [FAQItem(question: '数字命理学是科学的吗？', answer: '数字命理学不是一个经过科学证明的系统。')],
    'el': [FAQItem(question: 'Είναι η αριθμολογία επιστημονική;', answer: 'Η αριθμολογία δεν είναι ένα επιστημονικά αποδεδειγμένο σύστημα.')],
    'bg': [FAQItem(question: 'Научна ли е нумерологията?', answer: 'Нумерологията не е научно доказана система.')],
  },
  relatedPractices: {
    'tr': ['Astroloji', 'Kabala', 'Tarot'],
    'en': ['Astrology', 'Kabbalah', 'Tarot'],
    'fr': ['Astrologie'],
    'de': ['Astrologie'],
    'es': ['Astrología'],
    'ru': ['Астрология'],
    'ar': ['علم الفلك'],
    'zh': ['占星术'],
    'el': ['Αστρολογία'],
    'bg': ['Астрология'],
  },
  differenceFromSimilar: {
    'tr': 'Numeroloji sayılarla çalışırken, astroloji gezegen sembolleriyle çalışır. Tarot kartlarla anlık okuma yaparken, numeroloji sabit sayısal değerler kullanır.',
    'en': 'Numerology works with numbers while astrology works with planetary symbols. Tarot does instant readings with cards while numerology uses fixed numerical values.',
    'fr': 'La numérologie travaille avec les nombres tandis que l\'astrologie travaille avec les symboles planétaires.',
    'de': 'Numerologie arbeitet mit Zahlen, während Astrologie mit Planetensymbolen arbeitet.',
    'es': 'La numerología trabaja con números mientras que la astrología trabaja con símbolos planetarios.',
    'ru': 'Нумерология работает с числами, тогда как астрология работает с планетарными символами.',
    'ar': 'يعمل علم الأعداد مع الأرقام بينما يعمل علم الفلك مع الرموز الكوكبية.',
    'zh': '数字命理学使用数字，而占星术使用行星符号。',
    'el': 'Η αριθμολογία εργάζεται με αριθμούς ενώ η αστρολογία εργάζεται με πλανητικά σύμβολα.',
    'bg': 'Нумерологията работи с числа, докато астрологията работи с планетарни символи.',
  },
  microLearning: {
    'tr': ['💡 Pythagoras sayıların evrenin temelini oluşturduğuna inanıyordu.', '💡 Master sayılar (11, 22, 33) tek haneye indirgenmez.'],
    'en': ['💡 Pythagoras believed numbers formed the foundation of the universe.', '💡 Master numbers (11, 22, 33) are not reduced to single digits.'],
    'fr': ['💡 Pythagore croyait que les nombres formaient la base de l\'univers.'],
    'de': ['💡 Pythagoras glaubte, dass Zahlen die Grundlage des Universums bildeten.'],
    'es': ['💡 Pitágoras creía que los números formaban la base del universo.'],
    'ru': ['💡 Пифагор верил, что числа составляют основу вселенной.'],
    'ar': ['💡 اعتقد فيثاغورس أن الأرقام تشكل أساس الكون.'],
    'zh': ['💡 毕达哥拉斯相信数字构成了宇宙的基础。'],
    'el': ['💡 Ο Πυθαγόρας πίστευε ότι οι αριθμοί αποτελούσαν τη βάση του σύμπαντος.'],
    'bg': ['💡 Питагор вярваше, че числата съставляват основата на вселената.'],
  },
);

// ═══════════════════════════════════════════════════════════════════════════════
// REIKI SERVICES
// ═══════════════════════════════════════════════════════════════════════════════

final reikiUsui = ServiceContent(
  id: 'reiki_usui',
  category: ServiceCategory.reiki,
  icon: '✋',
  displayOrder: 30,
  name: {
    'tr': 'Usui Reiki',
    'en': 'Usui Reiki',
    'fr': 'Reiki Usui',
    'de': 'Usui Reiki',
    'es': 'Reiki Usui',
    'ru': 'Усуи Рейки',
    'ar': 'ريكي أوسوي',
    'zh': '臼井灵气',
    'el': 'Usui Ρέικι',
    'bg': 'Усуи Рейки',
  },
  shortDescription: {
    'tr': 'Japon kökenli geleneksel enerji şifa yöntemi ile rahatlama ve denge deneyimi.',
    'en': 'A relaxation and balance experience with the traditional Japanese energy healing method.',
    'fr': 'Une expérience de relaxation et d\'équilibre avec la méthode de guérison énergétique traditionnelle japonaise.',
    'de': 'Eine Entspannungs- und Gleichgewichtserfahrung mit der traditionellen japanischen Energieheilungsmethode.',
    'es': 'Una experiencia de relajación y equilibrio con el método tradicional japonés de sanación energética.',
    'ru': 'Опыт расслабления и баланса с традиционным японским методом энергетического исцеления.',
    'ar': 'تجربة استرخاء وتوازن مع طريقة الشفاء بالطاقة اليابانية التقليدية.',
    'zh': '通过传统的日本能量疗愈方法体验放松和平衡。',
    'el': 'Μια εμπειρία χαλάρωσης και ισορροπίας με την παραδοσιακή ιαπωνική μέθοδο ενεργειακής θεραπείας.',
    'bg': 'Преживяване на релаксация и баланс с традиционния японски метод за енергийно изцеление.',
  },
  coreExplanation: {
    'tr': '''
Usui Reiki, 1920'lerde Japonya'da Mikao Usui tarafından geliştirilen bir enerji çalışması yöntemidir. "Rei" evrensel enerjiyi, "Ki" ise yaşam gücünü ifade eder.

Reiki uygulayıcısı, elleri aracılığıyla enerji aktarımı yapar. Alıcı kişi genellikle giyinik olarak rahat bir pozisyonda uzanır. Uygulayıcı, vücudun belirli noktalarına ellerini yerleştirerek veya yaklaştırarak çalışır.

Reiki seanslarında insanlar genellikle derin rahatlama, sıcaklık, hafiflik veya karıncalanma hissi yaşadığını bildirir. Bu deneyimler kişiden kişiye değişir.

Reiki, tıbbi tedavinin yerine geçmez. Rahatlama ve wellness pratiği olarak sunulur ve stresin azaltılması, genel iyilik hali artışı amacıyla kullanılır.
''',
    'en': '''
Usui Reiki is an energy work method developed by Mikao Usui in Japan in the 1920s. "Rei" refers to universal energy, and "Ki" to life force.

The Reiki practitioner transfers energy through their hands. The recipient usually lies in a comfortable position while clothed. The practitioner works by placing or hovering their hands over specific points on the body.

People often report experiencing deep relaxation, warmth, lightness, or tingling sensations during Reiki sessions. These experiences vary from person to person.

Reiki does not replace medical treatment. It is offered as a relaxation and wellness practice and is used for stress reduction and increasing overall well-being.
''',
    'fr': '''Le Usui Reiki est une méthode de travail énergétique développée par Mikao Usui au Japon dans les années 1920...''',
    'de': '''Usui Reiki ist eine Energiearbeitsmethode, die von Mikao Usui in Japan in den 1920er Jahren entwickelt wurde...''',
    'es': '''El Usui Reiki es un método de trabajo energético desarrollado por Mikao Usui en Japón en la década de 1920...''',
    'ru': '''Усуи Рейки — это метод энергетической работы, разработанный Микао Усуи в Японии в 1920-х годах...''',
    'ar': '''ريكي أوسوي هو طريقة عمل الطاقة التي طورها ميكاو أوسوي في اليابان في عشرينيات القرن العشرين...''',
    'zh': '''臼井灵气是一种由日本的臼井甕男在1920年代开发的能量工作方法...''',
    'el': '''Το Usui Reiki είναι μια μέθοδος ενεργειακής εργασίας που αναπτύχθηκε από τον Mikao Usui στην Ιαπωνία στη δεκαετία του 1920...''',
    'bg': '''Усуи Рейки е метод за енергийна работа, разработен от Микао Усуи в Япония през 1920-те години...''',
  },
  historicalBackground: {
    'tr': 'Mikao Usui (1865-1926) Reiki sistemini 1922\'de Japonya\'da kurdu. Kurama Dağı\'nda 21 günlük meditasyon sonrası bu sistemi geliştirdiği söylenir. Sistem Hawayo Takata aracılığıyla Batı\'ya yayıldı.',
    'en': 'Mikao Usui (1865-1926) founded the Reiki system in Japan in 1922. It is said he developed this system after 21 days of meditation on Mount Kurama. The system spread to the West through Hawayo Takata.',
    'fr': 'Mikao Usui (1865-1926) a fondé le système Reiki au Japon en 1922.',
    'de': 'Mikao Usui (1865-1926) gründete das Reiki-System in Japan im Jahr 1922.',
    'es': 'Mikao Usui (1865-1926) fundó el sistema Reiki en Japón en 1922.',
    'ru': 'Микао Усуи (1865-1926) основал систему Рейки в Японии в 1922 году.',
    'ar': 'أسس ميكاو أوسوي (1865-1926) نظام ريكي في اليابان عام 1922.',
    'zh': '臼井甕男（1865-1926）于1922年在日本创立了灵气系统。',
    'el': 'Ο Mikao Usui (1865-1926) ίδρυσε το σύστημα Reiki στην Ιαπωνία το 1922.',
    'bg': 'Микао Усуи (1865-1926) основа системата Рейки в Япония през 1922 г.',
  },
  philosophicalFoundation: {
    'tr': 'Reiki, evrensel yaşam enerjisinin herkes tarafından erişilebilir olduğu fikrine dayanır. Beş Reiki ilkesi (sadece bugün için: kızma, endişelenme, minnettar ol, dürüst çalış, nazik ol) pratiklerin temelidir.',
    'en': 'Reiki is based on the idea that universal life energy is accessible to everyone. The five Reiki principles (just for today: don\'t be angry, don\'t worry, be grateful, work honestly, be kind) form the foundation of the practice.',
    'fr': 'Le Reiki repose sur l\'idée que l\'énergie vitale universelle est accessible à tous.',
    'de': 'Reiki basiert auf der Idee, dass universelle Lebensenergie für jeden zugänglich ist.',
    'es': 'El Reiki se basa en la idea de que la energía vital universal es accesible para todos.',
    'ru': 'Рейки основано на идее, что универсальная жизненная энергия доступна каждому.',
    'ar': 'يعتمد الريكي على فكرة أن طاقة الحياة العالمية متاحة للجميع.',
    'zh': '灵气基于普遍生命能量人人可及的理念。',
    'el': 'Το Ρέικι βασίζεται στην ιδέα ότι η παγκόσμια ενέργεια ζωής είναι προσβάσιμη σε όλους.',
    'bg': 'Рейки се основава на идеята, че универсалната жизнена енергия е достъпна за всички.',
  },
  howItWorks: {
    'tr': '''
1. HAZIRLIK
Rahat kıyafetler giyilir. Sessiz, huzurlu bir ortam oluşturulur.

2. SEANS BAŞLANGICI
Alıcı rahat bir pozisyonda uzanır. Uygulayıcı niyetini belirler.

3. ENERJI ÇALIŞMASI
Uygulayıcı, elleri belirli pozisyonlara yerleştirerek veya yaklaştırarak çalışır. Her pozisyonda birkaç dakika kalınır.

4. TAMAMLAMA
Seans nazikçe sonlandırılır. Alıcıya su içmesi ve dinlenmesi önerilir.
''',
    'en': '''
1. PREPARATION
Comfortable clothes are worn. A quiet, peaceful environment is created.

2. SESSION START
The recipient lies in a comfortable position. The practitioner sets their intention.

3. ENERGY WORK
The practitioner works by placing or hovering hands over specific positions. Several minutes are spent at each position.

4. COMPLETION
The session ends gently. The recipient is advised to drink water and rest.
''',
    'fr': '''1. PRÉPARATION...''',
    'de': '''1. VORBEREITUNG...''',
    'es': '''1. PREPARACIÓN...''',
    'ru': '''1. ПОДГОТОВКА...''',
    'ar': '''1. التحضير...''',
    'zh': '''1. 准备...''',
    'el': '''1. ΠΡΟΕΤΟΙΜΑΣΙΑ...''',
    'bg': '''1. ПОДГОТОВКА...''',
  },
  symbolicInterpretation: {
    'tr': 'Reiki sembolleri, enerji yönlendirmek için kullanılan kutsal şekillerdir. Cho Ku Rei (güç), Sei He Ki (duygusal şifa), Hon Sha Ze Sho Nen (uzaktan şifa) en bilinen sembollerdir.',
    'en': 'Reiki symbols are sacred shapes used to direct energy. Cho Ku Rei (power), Sei He Ki (emotional healing), Hon Sha Ze Sho Nen (distance healing) are the most known symbols.',
    'fr': 'Les symboles Reiki sont des formes sacrées utilisées pour diriger l\'énergie.',
    'de': 'Reiki-Symbole sind heilige Formen, die verwendet werden, um Energie zu lenken.',
    'es': 'Los símbolos Reiki son formas sagradas usadas para dirigir la energía.',
    'ru': 'Символы Рейки — это священные формы, используемые для направления энергии.',
    'ar': 'رموز الريكي هي أشكال مقدسة تستخدم لتوجيه الطاقة.',
    'zh': '灵气符号是用于引导能量的神圣形状。',
    'el': 'Τα σύμβολα Ρέικι είναι ιερά σχήματα που χρησιμοποιούνται για να κατευθύνουν την ενέργεια.',
    'bg': 'Символите на Рейки са свещени форми, използвани за насочване на енергия.',
  },
  insightsProvided: {
    'tr': 'Derin rahatlama deneyimi, stres azaltımı, enerji blokajlarının farkındalığı, genel iyilik hali artışı.',
    'en': 'Deep relaxation experience, stress reduction, awareness of energy blockages, increased overall well-being.',
    'fr': 'Expérience de relaxation profonde, réduction du stress.',
    'de': 'Tiefe Entspannungserfahrung, Stressabbau.',
    'es': 'Experiencia de relajación profunda, reducción del estrés.',
    'ru': 'Опыт глубокого расслабления, снижение стресса.',
    'ar': 'تجربة استرخاء عميقة، تقليل التوتر.',
    'zh': '深度放松体验，减压。',
    'el': 'Εμπειρία βαθιάς χαλάρωσης, μείωση του στρες.',
    'bg': 'Преживяване на дълбока релаксация, намаляване на стреса.',
  },
  commonMotivations: {
    'tr': ['Stresi azaltmak', 'Rahatlama aramak', 'Enerji dengesini sağlamak', 'Wellness rutini oluşturmak'],
    'en': ['Reducing stress', 'Seeking relaxation', 'Achieving energy balance', 'Creating a wellness routine'],
    'fr': ['Réduire le stress'],
    'de': ['Stress abbauen'],
    'es': ['Reducir el estrés'],
    'ru': ['Снижение стресса'],
    'ar': ['تقليل التوتر'],
    'zh': ['减轻压力'],
    'el': ['Μείωση του στρες'],
    'bg': ['Намаляване на стреса'],
  },
  lifeThemes: {
    'tr': ['Rahatlama', 'Stres yönetimi', 'Enerji dengesi', 'Öz bakım'],
    'en': ['Relaxation', 'Stress management', 'Energy balance', 'Self-care'],
    'fr': ['Relaxation'],
    'de': ['Entspannung'],
    'es': ['Relajación'],
    'ru': ['Расслабление'],
    'ar': ['الاسترخاء'],
    'zh': ['放松'],
    'el': ['Χαλάρωση'],
    'bg': ['Релаксация'],
  },
  whatYouReceive: {
    'tr': '''
• Bireysel Reiki seansı
• Rahatlatıcı ortam deneyimi
• Seans sonrası öneriler
• İsteğe bağlı uzaktan seans seçeneği
''',
    'en': '''
• Individual Reiki session
• Relaxing environment experience
• Post-session recommendations
• Optional distance session
''',
    'fr': '''• Séance de Reiki individuelle...''',
    'de': '''• Individuelle Reiki-Sitzung...''',
    'es': '''• Sesión de Reiki individual...''',
    'ru': '''• Индивидуальный сеанс Рейки...''',
    'ar': '''• جلسة ريكي فردية...''',
    'zh': '''• 个人灵气疗程...''',
    'el': '''• Ατομική συνεδρία Ρέικι...''',
    'bg': '''• Индивидуална сесия Рейки...''',
  },
  perspectiveGained: {
    'tr': 'Bedeninizle ve enerjinizle daha bağlantılı hissedebilir, rahatlama ve yenilenme deneyimi yaşayabilirsiniz.',
    'en': 'You may feel more connected to your body and energy, experiencing relaxation and renewal.',
    'fr': 'Vous pouvez vous sentir plus connecté à votre corps et à votre énergie.',
    'de': 'Sie fühlen sich möglicherweise mehr mit Ihrem Körper und Ihrer Energie verbunden.',
    'es': 'Puedes sentirte más conectado con tu cuerpo y energía.',
    'ru': 'Вы можете почувствовать большую связь со своим телом и энергией.',
    'ar': 'قد تشعر بمزيد من الاتصال بجسمك وطاقتك.',
    'zh': '您可能会感到与身体和能量更加连接。',
    'el': 'Μπορεί να νιώσετε πιο συνδεδεμένοι με το σώμα και την ενέργειά σας.',
    'bg': 'Може да се почувствате по-свързани с тялото и енергията си.',
  },
  reflectionPoints: {
    'tr': ['Bedenimde nerede gerginlik hissediyorum?', 'Nasıl daha fazla rahatlama yaratabilirim?', 'Enerji dengem nasıl?'],
    'en': ['Where do I feel tension in my body?', 'How can I create more relaxation?', 'How is my energy balance?'],
    'fr': ['Où est-ce que je ressens de la tension dans mon corps?'],
    'de': ['Wo fühle ich Spannung in meinem Körper?'],
    'es': ['¿Dónde siento tensión en mi cuerpo?'],
    'ru': ['Где я чувствую напряжение в своём теле?'],
    'ar': ['أين أشعر بالتوتر في جسمي؟'],
    'zh': ['我在身体哪里感到紧张？'],
    'el': ['Πού νιώθω ένταση στο σώμα μου;'],
    'bg': ['Къде усещам напрежение в тялото си?'],
  },
  safetyDisclaimer: {
    'tr': '''
⚠️ ÖNEMLİ UYARI

Reiki bir wellness ve rahatlama pratiğidir. TIBBİ TEDAVİNİN YERİNE GEÇMEZ. Hiçbir hastalığı tedavi etme iddiasında değildir. Sağlık sorunlarınız için her zaman doktora danışın.
''',
    'en': '''
⚠️ IMPORTANT NOTICE

Reiki is a wellness and relaxation practice. It DOES NOT REPLACE MEDICAL TREATMENT. It does not claim to cure any illness. Always consult a doctor for your health issues.
''',
    'fr': '''⚠️ AVIS IMPORTANT - Le Reiki est une pratique de bien-être. IL NE REMPLACE PAS LE TRAITEMENT MÉDICAL...''',
    'de': '''⚠️ WICHTIGER HINWEIS - Reiki ist eine Wellness-Praxis. ES ERSETZT KEINE MEDIZINISCHE BEHANDLUNG...''',
    'es': '''⚠️ AVISO IMPORTANTE - El Reiki es una práctica de bienestar. NO REEMPLAZA EL TRATAMIENTO MÉDICO...''',
    'ru': '''⚠️ ВАЖНОЕ УВЕДОМЛЕНИЕ - Рейки — это оздоровительная практика. ОНА НЕ ЗАМЕНЯЕТ МЕДИЦИНСКОЕ ЛЕЧЕНИЕ...''',
    'ar': '''⚠️ إشعار هام - الريكي هو ممارسة صحية. لا يحل محل العلاج الطبي...''',
    'zh': '''⚠️ 重要提示 - 灵气是一种健康和放松练习。它不能替代医疗治疗...''',
    'el': '''⚠️ ΣΗΜΑΝΤΙΚΗ ΕΙΔΟΠΟΙΗΣΗ - Το Ρέικι είναι μια πρακτική ευεξίας. ΔΕΝ ΑΝΤΙΚΑΘΙΣΤΑ ΤΗΝ ΙΑΤΡΙΚΗ ΘΕΡΑΠΕΙΑ...''',
    'bg': '''⚠️ ВАЖНО СЪОБЩЕНИЕ - Рейки е практика за уелнес. НЕ ЗАМЕСТВА МЕДИЦИНСКОТО ЛЕЧЕНИЕ...''',
  },
  doesNotDo: {
    'tr': ['Tıbbi tedavi değildir', 'Hastalık tedavi etmez', 'Teşhis koymaz', 'İlaç yerine geçmez', 'Profesyonel sağlık hizmeti değildir'],
    'en': ['Is not medical treatment', 'Does not cure illness', 'Does not diagnose', 'Does not replace medication', 'Is not professional healthcare'],
    'fr': ['N\'est pas un traitement médical'],
    'de': ['Ist keine medizinische Behandlung'],
    'es': ['No es tratamiento médico'],
    'ru': ['Не является медицинским лечением'],
    'ar': ['ليس علاجاً طبياً'],
    'zh': ['不是医疗治疗'],
    'el': ['Δεν είναι ιατρική θεραπεία'],
    'bg': ['Не е медицинско лечение'],
  },
  exampleScenarios: {
    'tr': ['Stresli bir dönemden geçen biri, düzenli Reiki seanslarıyla daha sakin ve dengeli hissettiğini bildirdi.'],
    'en': ['Someone going through a stressful period reported feeling calmer and more balanced with regular Reiki sessions.'],
    'fr': ['Une personne traversant une période stressante a rapporté se sentir plus calme...'],
    'de': ['Jemand, der eine stressige Phase durchmachte, berichtete, sich ruhiger zu fühlen...'],
    'es': ['Alguien que pasaba por un período estresante reportó sentirse más calmado...'],
    'ru': ['Кто-то, переживающий стрессовый период, сообщил, что чувствует себя спокойнее...'],
    'ar': ['أفاد شخص يمر بفترة مرهقة أنه يشعر بالهدوء...'],
    'zh': ['一个经历压力期的人报告说通过定期灵气疗程感到更加平静...'],
    'el': ['Κάποιος που περνούσε μια αγχωτική περίοδο ανέφερε ότι ένιωθε πιο ήρεμος...'],
    'bg': ['Човек, преминаващ през стресов период, съобщи, че се чувства по-спокоен...'],
  },
  faq: {
    'tr': [
      FAQItem(question: 'Reiki ağrı kesici mi?', answer: 'Hayır, Reiki ağrı kesici değildir. Rahatlama deneyimi sunabilir ancak tıbbi tedavi yerine geçmez.'),
      FAQItem(question: 'Reiki uzaktan yapılabilir mi?', answer: 'Evet, uzaktan Reiki seansları sunulmaktadır. Enerji çalışmasının mesafe tanımadığına inanılır.'),
      FAQItem(question: 'Reiki herkes için uygun mu?', answer: 'Reiki genel olarak güvenli kabul edilir, ancak ciddi sağlık sorunlarınız varsa önce doktorunuza danışın.'),
    ],
    'en': [
      FAQItem(question: 'Is Reiki a pain reliever?', answer: 'No, Reiki is not a pain reliever. It can offer a relaxation experience but does not replace medical treatment.'),
      FAQItem(question: 'Can Reiki be done remotely?', answer: 'Yes, distance Reiki sessions are offered. It is believed that energy work knows no distance.'),
      FAQItem(question: 'Is Reiki suitable for everyone?', answer: 'Reiki is generally considered safe, but if you have serious health issues, consult your doctor first.'),
    ],
    'fr': [FAQItem(question: 'Le Reiki est-il un analgésique?', answer: 'Non, le Reiki n\'est pas un analgésique.')],
    'de': [FAQItem(question: 'Ist Reiki ein Schmerzmittel?', answer: 'Nein, Reiki ist kein Schmerzmittel.')],
    'es': [FAQItem(question: '¿Es el Reiki un analgésico?', answer: 'No, el Reiki no es un analgésico.')],
    'ru': [FAQItem(question: 'Является ли Рейки обезболивающим?', answer: 'Нет, Рейки не является обезболивающим.')],
    'ar': [FAQItem(question: 'هل الريكي مسكن للألم؟', answer: 'لا، الريكي ليس مسكناً للألم.')],
    'zh': [FAQItem(question: '灵气是止痛药吗？', answer: '不，灵气不是止痛药。')],
    'el': [FAQItem(question: 'Είναι το Ρέικι παυσίπονο;', answer: 'Όχι, το Ρέικι δεν είναι παυσίπονο.')],
    'bg': [FAQItem(question: 'Рейки болкоуспокояващо ли е?', answer: 'Не, Рейки не е болкоуспокояващо.')],
  },
  relatedPractices: {
    'tr': ['Yoga', 'Meditasyon', 'Akupunktur', 'Kristal Terapi'],
    'en': ['Yoga', 'Meditation', 'Acupuncture', 'Crystal Therapy'],
    'fr': ['Yoga', 'Méditation'],
    'de': ['Yoga', 'Meditation'],
    'es': ['Yoga', 'Meditación'],
    'ru': ['Йога', 'Медитация'],
    'ar': ['اليوغا', 'التأمل'],
    'zh': ['瑜伽', '冥想'],
    'el': ['Γιόγκα', 'Διαλογισμός'],
    'bg': ['Йога', 'Медитация'],
  },
  differenceFromSimilar: {
    'tr': 'Usui Reiki, orijinal Japon Reiki geleneğidir. Diğer Reiki türleri (Karuna, Kundalini Reiki vb.) bu temelden geliştirilen varyasyonlardır.',
    'en': 'Usui Reiki is the original Japanese Reiki tradition. Other Reiki types (Karuna, Kundalini Reiki, etc.) are variations developed from this foundation.',
    'fr': 'Le Usui Reiki est la tradition japonaise originale du Reiki.',
    'de': 'Usui Reiki ist die ursprüngliche japanische Reiki-Tradition.',
    'es': 'El Usui Reiki es la tradición japonesa original del Reiki.',
    'ru': 'Усуи Рейки — это оригинальная японская традиция Рейки.',
    'ar': 'ريكي أوسوي هو التقليد الياباني الأصلي للريكي.',
    'zh': '臼井灵气是日本原始的灵气传统。',
    'el': 'Το Usui Reiki είναι η αρχική ιαπωνική παράδοση Ρέικι.',
    'bg': 'Усуи Рейки е оригиналната японска традиция на Рейки.',
  },
  microLearning: {
    'tr': ['💡 "Reiki" kelimesi Japonca "evrensel yaşam enerjisi" anlamına gelir.', '💡 Mikao Usui, Reiki sistemini 1922\'de kurdu.'],
    'en': ['💡 The word "Reiki" means "universal life energy" in Japanese.', '💡 Mikao Usui founded the Reiki system in 1922.'],
    'fr': ['💡 Le mot "Reiki" signifie "énergie de vie universelle" en japonais.'],
    'de': ['💡 Das Wort "Reiki" bedeutet auf Japanisch "universelle Lebensenergie".'],
    'es': ['💡 La palabra "Reiki" significa "energía de vida universal" en japonés.'],
    'ru': ['💡 Слово "Рейки" означает "универсальная жизненная энергия" на японском.'],
    'ar': ['💡 كلمة "ريكي" تعني "طاقة الحياة العالمية" باليابانية.'],
    'zh': ['💡 "灵气"一词在日语中意为"宇宙生命能量"。'],
    'el': ['💡 Η λέξη "Ρέικι" σημαίνει "παγκόσμια ενέργεια ζωής" στα ιαπωνικά.'],
    'bg': ['💡 Думата "Рейки" означава "универсална жизнена енергия" на японски.'],
  },
);

// ═══════════════════════════════════════════════════════════════════════════════
// PENDULUM SERVICES
// ═══════════════════════════════════════════════════════════════════════════════

final pendulumConsultation = ServiceContent(
  id: 'pendulum_consultation',
  category: ServiceCategory.pendulum,
  icon: '🔮',
  displayOrder: 40,
  name: {
    'tr': 'Sarkaç Danışmanlığı',
    'en': 'Pendulum Consultation',
    'fr': 'Consultation au Pendule',
    'de': 'Pendel-Beratung',
    'es': 'Consulta con Péndulo',
    'ru': 'Консультация с Маятником',
    'ar': 'استشارة البندول',
    'zh': '灵摆咨询',
    'el': 'Συμβουλευτική με Εκκρεμές',
    'bg': 'Консултация с Махало',
  },
  shortDescription: {
    'tr': 'Sarkacın hareketlerini kullanarak sezgisel içgörüler ve evet/hayır yanıtları alın.',
    'en': 'Receive intuitive insights and yes/no answers using the movements of the pendulum.',
    'fr': 'Recevez des aperçus intuitifs et des réponses oui/non en utilisant les mouvements du pendule.',
    'de': 'Erhalten Sie intuitive Einblicke und Ja/Nein-Antworten durch die Bewegungen des Pendels.',
    'es': 'Recibe percepciones intuitivas y respuestas sí/no usando los movimientos del péndulo.',
    'ru': 'Получайте интуитивные прозрения и ответы да/нет, используя движения маятника.',
    'ar': 'احصل على رؤى حدسية وإجابات نعم/لا باستخدام حركات البندول.',
    'zh': '通过灵摆的运动获得直觉洞察和是/否答案。',
    'el': 'Λάβετε διαισθητικές γνώσεις και απαντήσεις ναι/όχι χρησιμοποιώντας τις κινήσεις του εκκρεμούς.',
    'bg': 'Получете интуитивни прозрения и отговори да/не, използвайки движенията на махалото.',
  },
  coreExplanation: {
    'tr': '''
Sarkaç çalışması, bir ağırlığın (kristal, metal veya ahşap) bir zincir veya ip ucuna bağlanarak oluşturulan aracın hareketlerini yorumlama pratiğidir.

Sarkaç, bilinçaltı zihin ile iletişim kurmanın bir yolu olarak kabul edilir. Soran kişinin bilinçaltındaki cevaplar, kasların mikro hareketleri (ideomotor yanıt) aracılığıyla sarkaca aktarılır ve salınım kalıpları oluşturur.

Sarkaç seansında genellikle evet/hayır soruları sorulur. Sarkacın belirli yönlerde salınması (örn. saat yönünde = evet, saat yönünün tersine = hayır) olarak yorumlanır. Karmaşık sorular için özel şemalar (sarkaç panoları) kullanılabilir.

Bu pratik, sezgisel bir keşif aracı olarak değerlendirilir ve kesin bilgi kaynağı olarak görülmemelidir.
''',
    'en': '''
Pendulum work is the practice of interpreting the movements of a tool created by attaching a weight (crystal, metal, or wood) to a chain or string.

The pendulum is considered a way to communicate with the subconscious mind. The answers in the querent's subconscious are transmitted to the pendulum through micro-movements of muscles (ideomotor response) and create oscillation patterns.

In a pendulum session, yes/no questions are typically asked. The pendulum swinging in certain directions (e.g., clockwise = yes, counter-clockwise = no) is interpreted. Special charts (pendulum boards) can be used for complex questions.

This practice is considered an intuitive exploration tool and should not be seen as a definitive source of information.
''',
    'fr': """Le travail au pendule est la pratique d'interprétation des mouvements d'un outil...""",
    'de': '''Pendelarbeit ist die Praxis der Interpretation der Bewegungen eines Werkzeugs...''',
    'es': '''El trabajo con péndulo es la práctica de interpretar los movimientos de una herramienta...''',
    'ru': '''Работа с маятником — это практика интерпретации движений инструмента...''',
    'ar': '''عمل البندول هو ممارسة تفسير حركات أداة...''',
    'zh': '''灵摆工作是解读工具运动的做法...''',
    'el': '''Η εργασία με εκκρεμές είναι η πρακτική ερμηνείας των κινήσεων ενός εργαλείου...''',
    'bg': '''Работата с махало е практика на тълкуване на движенията на инструмент...''',
  },
  historicalBackground: {
    'tr': 'Sarkaç kullanımı (radiezestezi) yüzyıllar öncesine dayanır. Su ve maden arama (dowsing) için kullanılmıştır. Modern dönemde kişisel rehberlik ve sezgisel çalışmalar için popülerleşmiştir.',
    'en': 'Pendulum use (radiesthesia) dates back centuries. It was used for finding water and minerals (dowsing). In modern times, it has become popular for personal guidance and intuitive work.',
    'fr': 'L\'utilisation du pendule (radiesthésie) remonte à des siècles.',
    'de': 'Die Pendelverwendung (Radiästhesie) reicht Jahrhunderte zurück.',
    'es': 'El uso del péndulo (radiestesia) se remonta siglos.',
    'ru': 'Использование маятника (радиэстезия) восходит к векам.',
    'ar': 'يعود استخدام البندول (الراديستيزيا) إلى قرون.',
    'zh': '灵摆的使用（放射感应学）可追溯到几个世纪前。',
    'el': 'Η χρήση του εκκρεμούς (ραδιαισθησία) χρονολογείται αιώνες πίσω.',
    'bg': 'Използването на махало (радиестезия) датира от векове.',
  },
  philosophicalFoundation: {
    'tr': 'Sarkaç, bilinçaltı zihinle bilinç arasında bir köprü olarak görülür. İdeomotor yanıt teorisi, sarkacın kasların görünmez mikro hareketlerine tepki verdiğini öne sürer.',
    'en': 'The pendulum is seen as a bridge between the subconscious mind and conscious awareness. The ideomotor response theory suggests the pendulum responds to invisible micro-movements of muscles.',
    'fr': 'Le pendule est vu comme un pont entre l\'esprit subconscient et la conscience.',
    'de': 'Das Pendel wird als Brücke zwischen dem Unterbewusstsein und dem Bewusstsein gesehen.',
    'es': 'El péndulo se ve como un puente entre la mente subconsciente y la conciencia.',
    'ru': 'Маятник рассматривается как мост между подсознанием и сознанием.',
    'ar': 'يُنظر إلى البندول كجسر بين العقل الباطن والوعي.',
    'zh': '灵摆被视为潜意识与意识之间的桥梁。',
    'el': 'Το εκκρεμές θεωρείται γέφυρα μεταξύ του υποσυνείδητου και της συνείδησης.',
    'bg': 'Махалото се разглежда като мост между подсъзнанието и съзнанието.',
  },
  howItWorks: {
    'tr': '''
1. HAZIRLIK
Sakin bir ortam oluşturulur. Sarkaç tutulur ve stabilize edilir.

2. KALİBRASYON
Sarkacın evet ve hayır yanıtları için hangi yönde hareket edeceği belirlenir.

3. SORU SORMA
Net, spesifik sorular sorulur. En iyi sonuçlar evet/hayır formatındaki sorularla alınır.

4. YORUM
Sarkacın hareketi gözlemlenir ve yorumlanır.

5. DOĞRULAMA
Gerekirse sorular farklı şekillerde sorularak cevaplar doğrulanır.
''',
    'en': '''
1. PREPARATION
A calm environment is created. The pendulum is held and stabilized.

2. CALIBRATION
Which direction the pendulum will move for yes and no answers is determined.

3. ASKING QUESTIONS
Clear, specific questions are asked. Best results come from yes/no format questions.

4. INTERPRETATION
The movement of the pendulum is observed and interpreted.

5. VERIFICATION
If needed, answers are verified by asking questions in different ways.
''',
    'fr': '''1. PRÉPARATION...''',
    'de': '''1. VORBEREITUNG...''',
    'es': '''1. PREPARACIÓN...''',
    'ru': '''1. ПОДГОТОВКА...''',
    'ar': '''1. التحضير...''',
    'zh': '''1. 准备...''',
    'el': '''1. ΠΡΟΕΤΟΙΜΑΣΙΑ...''',
    'bg': '''1. ПОДГОТОВКА...''',
  },
  symbolicInterpretation: {
    'tr': 'Sarkacın farklı hareketleri farklı anlamlar taşır: Saat yönünde dönüş genellikle evet/pozitif, saat yönünün tersi hayır/negatif, ileri-geri salınım tarafsız veya belirsiz olarak yorumlanır.',
    'en': 'Different movements of the pendulum carry different meanings: Clockwise rotation typically means yes/positive, counter-clockwise means no/negative, back-and-forth swinging is interpreted as neutral or uncertain.',
    'fr': 'Les différents mouvements du pendule portent des significations différentes.',
    'de': 'Verschiedene Bewegungen des Pendels tragen unterschiedliche Bedeutungen.',
    'es': 'Los diferentes movimientos del péndulo tienen diferentes significados.',
    'ru': 'Различные движения маятника несут разные значения.',
    'ar': 'تحمل حركات البندول المختلفة معاني مختلفة.',
    'zh': '灵摆的不同运动有不同的含义。',
    'el': 'Διαφορετικές κινήσεις του εκκρεμούς έχουν διαφορετικές σημασίες.',
    'bg': 'Различните движения на махалото носят различни значения.',
  },
  insightsProvided: {
    'tr': 'Belirli sorulara sezgisel yanıtlar, karar verme desteği, iç bilgeliğinize erişim.',
    'en': 'Intuitive answers to specific questions, decision-making support, access to your inner wisdom.',
    'fr': 'Réponses intuitives à des questions spécifiques.',
    'de': 'Intuitive Antworten auf spezifische Fragen.',
    'es': 'Respuestas intuitivas a preguntas específicas.',
    'ru': 'Интуитивные ответы на конкретные вопросы.',
    'ar': 'إجابات حدسية على أسئلة محددة.',
    'zh': '对特定问题的直觉回答。',
    'el': 'Διαισθητικές απαντήσεις σε συγκεκριμένες ερωτήσεις.',
    'bg': 'Интуитивни отговори на конкретни въпроси.',
  },
  commonMotivations: {
    'tr': ['Karar vermede yardım', 'Sezgilerimi test etmek', 'İç rehberlik aramak', 'Merak'],
    'en': ['Help with decision making', 'Testing my intuitions', 'Seeking inner guidance', 'Curiosity'],
    'fr': ['Aide à la prise de décision'],
    'de': ['Hilfe bei Entscheidungen'],
    'es': ['Ayuda para tomar decisiones'],
    'ru': ['Помощь в принятии решений'],
    'ar': ['المساعدة في اتخاذ القرارات'],
    'zh': ['帮助做决定'],
    'el': ['Βοήθεια στη λήψη αποφάσεων'],
    'bg': ['Помощ при вземане на решения'],
  },
  lifeThemes: {
    'tr': ['Karar verme', 'Sezgi geliştirme', 'Kişisel rehberlik'],
    'en': ['Decision making', 'Intuition development', 'Personal guidance'],
    'fr': ['Prise de décision'],
    'de': ['Entscheidungsfindung'],
    'es': ['Toma de decisiones'],
    'ru': ['Принятие решений'],
    'ar': ['اتخاذ القرارات'],
    'zh': ['决策'],
    'el': ['Λήψη αποφάσεων'],
    'bg': ['Вземане на решения'],
  },
  whatYouReceive: {
    'tr': '''
• Sorularınıza sarkaç yanıtları
• Sezgisel içgörüler
• Karar verme desteği
''',
    'en': '''
• Pendulum answers to your questions
• Intuitive insights
• Decision-making support
''',
    'fr': '''• Réponses du pendule à vos questions...''',
    'de': '''• Pendelantworten auf Ihre Fragen...''',
    'es': '''• Respuestas del péndulo a tus preguntas...''',
    'ru': '''• Ответы маятника на ваши вопросы...''',
    'ar': '''• إجابات البندول على أسئلتك...''',
    'zh': '''• 灵摆对您问题的回答...''',
    'el': '''• Απαντήσεις εκκρεμούς στις ερωτήσεις σας...''',
    'bg': '''• Отговори на махалото на вашите въпроси...''',
  },
  perspectiveGained: {
    'tr': 'Bilinçaltınızın "bildiği" cevaplara farklı bir yoldan erişebilirsiniz.',
    'en': 'You can access answers your subconscious "knows" through a different route.',
    'fr': 'Vous pouvez accéder aux réponses que votre subconscient "connaît" par un chemin différent.',
    'de': 'Sie können auf Antworten zugreifen, die Ihr Unterbewusstsein "kennt", auf einem anderen Weg.',
    'es': 'Puedes acceder a respuestas que tu subconsciente "conoce" por un camino diferente.',
    'ru': 'Вы можете получить доступ к ответам, которые ваше подсознание "знает", другим путём.',
    'ar': 'يمكنك الوصول إلى الإجابات التي "يعرفها" عقلك الباطن من خلال طريق مختلف.',
    'zh': '您可以通过不同的途径获得您的潜意识"知道"的答案。',
    'el': 'Μπορείτε να αποκτήσετε πρόσβαση σε απαντήσεις που το υποσυνείδητό σας "γνωρίζει" μέσω διαφορετικής οδού.',
    'bg': 'Можете да получите достъп до отговори, които подсъзнанието ви "знае", по различен път.',
  },
  reflectionPoints: {
    'tr': ['Hangi sorulara cevap arıyorum?', 'Sezgilerime ne kadar güveniyorum?', 'Bilinçaltım ne söylüyor?'],
    'en': ['What questions am I seeking answers to?', 'How much do I trust my intuitions?', 'What is my subconscious saying?'],
    'fr': ['Quelles questions cherché-je des réponses?'],
    'de': ['Nach welchen Fragen suche ich Antworten?'],
    'es': ['¿A qué preguntas busco respuestas?'],
    'ru': ['На какие вопросы я ищу ответы?'],
    'ar': ['ما الأسئلة التي أبحث عن إجابات لها؟'],
    'zh': ['我在寻找什么问题的答案？'],
    'el': ['Σε ποιες ερωτήσεις αναζητώ απαντήσεις;'],
    'bg': ['На какви въпроси търся отговори?'],
  },
  safetyDisclaimer: {
    'tr': '''
⚠️ ÖNEMLİ UYARI

Sarkaç danışmanlığı eğlence ve sezgisel keşif amaçlıdır. Kesin bilgi kaynağı değildir. Önemli yaşam kararlarınızı sadece sarkaç cevaplarına dayandırmayın.
''',
    'en': '''
⚠️ IMPORTANT NOTICE

Pendulum consultation is for entertainment and intuitive exploration purposes. It is not a definitive source of information. Do not base important life decisions solely on pendulum answers.
''',
    'fr': '''⚠️ AVIS IMPORTANT - La consultation au pendule est à des fins de divertissement...''',
    'de': '''⚠️ WICHTIGER HINWEIS - Die Pendelberatung dient der Unterhaltung...''',
    'es': '''⚠️ AVISO IMPORTANTE - La consulta con péndulo es con fines de entretenimiento...''',
    'ru': '''⚠️ ВАЖНОЕ УВЕДОМЛЕНИЕ - Консультация с маятником предназначена для развлечения...''',
    'ar': '''⚠️ إشعار هام - استشارة البندول هي لأغراض الترفيه...''',
    'zh': '''⚠️ 重要提示 - 灵摆咨询仅供娱乐和直觉探索...''',
    'el': '''⚠️ ΣΗΜΑΝΤΙΚΗ ΕΙΔΟΠΟΙΗΣΗ - Η συμβουλευτική με εκκρεμές είναι για ψυχαγωγία...''',
    'bg': '''⚠️ ВАЖНО СЪОБЩЕНИЕ - Консултацията с махало е за забавление...''',
  },
  doesNotDo: {
    'tr': ['Kesin gelecek tahmini yapmaz', 'Tıbbi teşhis koymaz', 'Bilimsel olarak kanıtlanmış değildir', 'Garantili cevaplar vermez'],
    'en': ['Does not make definite predictions', 'Does not diagnose medical conditions', 'Is not scientifically proven', 'Does not give guaranteed answers'],
    'fr': ['Ne fait pas de prédictions définitives'],
    'de': ['Macht keine definitiven Vorhersagen'],
    'es': ['No hace predicciones definitivas'],
    'ru': ['Не делает определённых предсказаний'],
    'ar': ['لا يقدم تنبؤات قطعية'],
    'zh': ['不做确定的预测'],
    'el': ['Δεν κάνει οριστικές προβλέψεις'],
    'bg': ['Не прави категорични предсказания'],
  },
  exampleScenarios: {
    'tr': ['Kariyer seçimi arasında kararsız kalan biri, sarkaç seansında seçenekleri sordu ve sezgilerini netleştirmeye yardımcı olacak içgörüler aldı.'],
    'en': ['Someone undecided between career choices asked about options in a pendulum session and received insights to help clarify their intuitions.'],
    'fr': ['Une personne indécise entre des choix de carrière a demandé...'],
    'de': ['Jemand, der zwischen Karriereentscheidungen unentschlossen war...'],
    'es': ['Alguien indeciso entre opciones de carrera preguntó...'],
    'ru': ['Кто-то, колеблющийся между карьерными выборами...'],
    'ar': ['شخص متردد بين خيارات مهنية...'],
    'zh': ['一个在职业选择之间犹豫不决的人...'],
    'el': ['Κάποιος αναποφάσιστος μεταξύ επιλογών καριέρας...'],
    'bg': ['Някой, който се колебае между кариерни избори...'],
  },
  faq: {
    'tr': [
      FAQItem(question: 'Sarkaç cevapları güvenilir mi?', answer: 'Sarkaç sezgisel bir araçtır, bilimsel olarak kanıtlanmış değildir. Cevaplar yansıtma için kullanılabilir ancak kesin bilgi olarak görülmemelidir.'),
      FAQItem(question: 'Kendi sarkacımı kullanabilir miyim?', answer: 'Evet, herkes sarkaç kullanmayı öğrenebilir. Pratik ve niyet önemlidir.'),
    ],
    'en': [
      FAQItem(question: 'Are pendulum answers reliable?', answer: 'The pendulum is an intuitive tool, it is not scientifically proven. Answers can be used for reflection but should not be seen as definitive information.'),
      FAQItem(question: 'Can I use my own pendulum?', answer: 'Yes, anyone can learn to use a pendulum. Practice and intention are important.'),
    ],
    'fr': [FAQItem(question: 'Les réponses du pendule sont-elles fiables?', answer: 'Le pendule est un outil intuitif...')],
    'de': [FAQItem(question: 'Sind Pendelantworten zuverlässig?', answer: 'Das Pendel ist ein intuitives Werkzeug...')],
    'es': [FAQItem(question: '¿Son confiables las respuestas del péndulo?', answer: 'El péndulo es una herramienta intuitiva...')],
    'ru': [FAQItem(question: 'Надёжны ли ответы маятника?', answer: 'Маятник — интуитивный инструмент...')],
    'ar': [FAQItem(question: 'هل إجابات البندول موثوقة؟', answer: 'البندول أداة حدسية...')],
    'zh': [FAQItem(question: '灵摆的答案可靠吗？', answer: '灵摆是一种直觉工具...')],
    'el': [FAQItem(question: 'Είναι αξιόπιστες οι απαντήσεις του εκκρεμούς;', answer: 'Το εκκρεμές είναι ένα διαισθητικό εργαλείο...')],
    'bg': [FAQItem(question: 'Надеждни ли са отговорите на махалото?', answer: 'Махалото е интуитивен инструмент...')],
  },
  relatedPractices: {
    'tr': ['Tarot', 'Dowsing', 'Meditasyon'],
    'en': ['Tarot', 'Dowsing', 'Meditation'],
    'fr': ['Tarot', 'Radiesthésie'],
    'de': ['Tarot', 'Wünschelrute'],
    'es': ['Tarot', 'Radiestesia'],
    'ru': ['Таро', 'Лозоходство'],
    'ar': ['التاروت', 'البحث بالقضيب'],
    'zh': ['塔罗牌', '探测术'],
    'el': ['Ταρώ', 'Ραβδοσκοπία'],
    'bg': ['Таро', 'Жезлоходство'],
  },
  differenceFromSimilar: {
    'tr': 'Sarkaç evet/hayır soruları için idealken, tarot daha karmaşık durumları analiz eder. Dowsing su/maden bulma için kullanılırken, sarkaç danışmanlığı kişisel sorular içindir.',
    'en': 'Pendulum is ideal for yes/no questions while tarot analyzes more complex situations. Dowsing is used for finding water/minerals while pendulum consultation is for personal questions.',
    'fr': 'Le pendule est idéal pour les questions oui/non tandis que le tarot analyse des situations plus complexes.',
    'de': 'Das Pendel ist ideal für Ja/Nein-Fragen, während Tarot komplexere Situationen analysiert.',
    'es': 'El péndulo es ideal para preguntas sí/no mientras que el tarot analiza situaciones más complejas.',
    'ru': 'Маятник идеален для вопросов да/нет, тогда как Таро анализирует более сложные ситуации.',
    'ar': 'البندول مثالي لأسئلة نعم/لا بينما التاروت يحلل المواقف الأكثر تعقيدًا.',
    'zh': '灵摆适合是/否问题，而塔罗分析更复杂的情况。',
    'el': 'Το εκκρεμές είναι ιδανικό για ερωτήσεις ναι/όχι ενώ το ταρώ αναλύει πιο σύνθετες καταστάσεις.',
    'bg': 'Махалото е идеално за въпроси да/не, докато Таро анализира по-сложни ситуации.',
  },
  microLearning: {
    'tr': ['💡 Sarkaç kullanımı "radiezestezi" olarak da bilinir.', '💡 İdeomotor yanıt, kasların bilinçsiz mikro hareketleridir.'],
    'en': ['💡 Pendulum use is also known as "radiesthesia."', '💡 Ideomotor response is unconscious micro-movements of muscles.'],
    'fr': ['💡 L\'utilisation du pendule est également connue sous le nom de "radiesthésie."'],
    'de': ['💡 Pendelverwendung ist auch als "Radiästhesie" bekannt.'],
    'es': ['💡 El uso del péndulo también se conoce como "radiestesia."'],
    'ru': ['💡 Использование маятника также известно как "радиэстезия."'],
    'ar': ['💡 استخدام البندول يُعرف أيضًا باسم "الراديستيزيا."'],
    'zh': ['💡 灵摆的使用也被称为"放射感应学"。'],
    'el': ['💡 Η χρήση του εκκρεμούς είναι επίσης γνωστή ως "ραδιαισθησία."'],
    'bg': ['💡 Използването на махало е известно също като "радиестезия."'],
  },
);

// ═══════════════════════════════════════════════════════════════════════════════
// THETA HEALING SERVICES
// ═══════════════════════════════════════════════════════════════════════════════

final thetaHealingConsultation = ServiceContent(
  id: 'theta_healing_consultation',
  category: ServiceCategory.thetaHealing,
  icon: '🧠',
  displayOrder: 50,
  name: {
    'tr': 'Theta Healing',
    'en': 'Theta Healing',
    'fr': 'Theta Healing',
    'de': 'Theta Healing',
    'es': 'Theta Healing',
    'ru': 'Тета-Хилинг',
    'ar': 'ثيتا هيلينغ',
    'zh': '西塔疗愈',
    'el': 'Θεραπεία Θήτα',
    'bg': 'Тета Хийлинг',
  },
  shortDescription: {
    'tr': 'Theta beyin dalgası durumunda bilinçaltı inançları keşfetme ve dönüştürme pratiği.',
    'en': 'A practice of exploring and transforming subconscious beliefs in the theta brainwave state.',
    'fr': 'Une pratique d\'exploration et de transformation des croyances subconscientes dans l\'état des ondes cérébrales thêta.',
    'de': 'Eine Praxis zur Erforschung und Transformation von unterbewussten Überzeugungen im Theta-Gehirnwellenzustand.',
    'es': 'Una práctica de exploración y transformación de creencias subconscientes en el estado de ondas cerebrales theta.',
    'ru': 'Практика исследования и трансформации подсознательных убеждений в состоянии тета-волн мозга.',
    'ar': 'ممارسة استكشاف وتحويل المعتقدات اللاواعية في حالة موجات الدماغ ثيتا.',
    'zh': '在西塔脑波状态下探索和转化潜意识信念的实践。',
    'el': 'Μια πρακτική εξερεύνησης και μετασχηματισμού υποσυνείδητων πεποιθήσεων στην κατάσταση εγκεφαλικών κυμάτων θήτα.',
    'bg': 'Практика за изследване и трансформиране на подсъзнателни вярвания в състояние на тета мозъчни вълни.',
  },
  coreExplanation: {
    'tr': '''
Theta Healing, 1995 yılında Vianna Stibal tarafından geliştirilen bir meditasyon ve enerji çalışması tekniğidir.

Teknik, beynin theta dalgası durumuna (4-7 Hz) erişerek bilinçaltı inançların keşfedilmesi ve dönüştürülmesi üzerine kuruludur. Theta durumu, uyku ile uyanıklık arasındaki gevşemiş farkındalık hali olarak tanımlanır.

Bir seansda, uygulayıcı ve danışan birlikte "kök inanç"ları (örn. "ben değersizim", "para kötüdür") belirlemeye çalışır. Ardından meditasyon yoluyla bu inançların dönüştürülmesi amaçlanır.

Bu yaklaşım, bilimsel olarak kanıtlanmış bir tedavi yöntemi değildir ve wellness/kişisel gelişim pratiği olarak sunulmaktadır.
''',
    'en': '''
Theta Healing is a meditation and energy work technique developed by Vianna Stibal in 1995.

The technique is based on accessing the brain's theta wave state (4-7 Hz) to explore and transform subconscious beliefs. The theta state is described as the relaxed awareness state between sleep and wakefulness.

In a session, the practitioner and client work together to identify "root beliefs" (e.g., "I am worthless," "money is bad"). Then through meditation, the transformation of these beliefs is aimed.

This approach is not a scientifically proven treatment method and is offered as a wellness/personal development practice.
''',
    'fr': '''Le Theta Healing est une technique de méditation et de travail énergétique développée par Vianna Stibal en 1995...''',
    'de': '''Theta Healing ist eine Meditations- und Energiearbeitstechnik, die 1995 von Vianna Stibal entwickelt wurde...''',
    'es': '''Theta Healing es una técnica de meditación y trabajo energético desarrollada por Vianna Stibal en 1995...''',
    'ru': '''Тета-Хилинг — это техника медитации и энергетической работы, разработанная Вианой Стайбл в 1995 году...''',
    'ar': '''ثيتا هيلينغ هي تقنية تأمل وعمل طاقة طورتها فيانا ستيبال في عام 1995...''',
    'zh': '''西塔疗愈是维安娜·斯蒂巴尔于1995年开发的冥想和能量工作技术...''',
    'el': '''Το Theta Healing είναι μια τεχνική διαλογισμού και ενεργειακής εργασίας που αναπτύχθηκε από τη Vianna Stibal το 1995...''',
    'bg': '''Тета Хийлинг е техника за медитация и енергийна работа, разработена от Виана Стибал през 1995 г...''',
  },
  historicalBackground: {
    'tr': 'Theta Healing, 1995 yılında ABD\'de Vianna Stibal tarafından geliştirildi. Stibal\'ın kendi sağlık deneyimlerinden yola çıkarak oluşturduğu bir sistem olarak sunulmaktadır.',
    'en': 'Theta Healing was developed in the USA in 1995 by Vianna Stibal. It is presented as a system created from Stibal\'s own health experiences.',
    'fr': 'Le Theta Healing a été développé aux États-Unis en 1995 par Vianna Stibal.',
    'de': 'Theta Healing wurde 1995 in den USA von Vianna Stibal entwickelt.',
    'es': 'Theta Healing fue desarrollado en EE.UU. en 1995 por Vianna Stibal.',
    'ru': 'Тета-Хилинг был разработан в США в 1995 году Вианой Стайбл.',
    'ar': 'تم تطوير ثيتا هيلينغ في الولايات المتحدة عام 1995 بواسطة فيانا ستيبال.',
    'zh': '西塔疗愈于1995年由维安娜·斯蒂巴尔在美国开发。',
    'el': 'Το Theta Healing αναπτύχθηκε στις ΗΠΑ το 1995 από τη Vianna Stibal.',
    'bg': 'Тета Хийлинг е разработен в САЩ през 1995 г. от Виана Стибал.',
  },
  philosophicalFoundation: {
    'tr': 'Theta Healing, bilinçaltı inançların yaşam deneyimlerimizi şekillendirdiği fikrine dayanır. Theta beyin dalgası durumunda bu inançlara erişilebileceği ve dönüştürülebileceği öne sürülür.',
    'en': 'Theta Healing is based on the idea that subconscious beliefs shape our life experiences. It is suggested that in the theta brainwave state, these beliefs can be accessed and transformed.',
    'fr': 'Le Theta Healing repose sur l\'idée que les croyances subconscientes façonnent nos expériences de vie.',
    'de': 'Theta Healing basiert auf der Idee, dass unterbewusste Überzeugungen unsere Lebenserfahrungen formen.',
    'es': 'Theta Healing se basa en la idea de que las creencias subconscientes moldean nuestras experiencias de vida.',
    'ru': 'Тета-Хилинг основан на идее, что подсознательные убеждения формируют наш жизненный опыт.',
    'ar': 'يعتمد ثيتا هيلينغ على فكرة أن المعتقدات اللاواعية تشكل تجاربنا الحياتية.',
    'zh': '西塔疗愈基于潜意识信念塑造我们生活经历的理念。',
    'el': 'Το Theta Healing βασίζεται στην ιδέα ότι οι υποσυνείδητες πεποιθήσεις διαμορφώνουν τις εμπειρίες ζωής μας.',
    'bg': 'Тета Хийлинг се основава на идеята, че подсъзнателните вярвания оформят житейските ни преживявания.',
  },
  howItWorks: {
    'tr': '''
1. GÖRÜŞME
Danışanın üzerinde çalışmak istediği konu belirlenir.

2. MEDITASYON
Uygulayıcı ve danışan birlikte theta durumuna geçer.

3. İNANÇ ÇALIŞMASI
Kök inançlar keşfedilir ve sorgulanır.

4. DÖNÜŞÜM
Sınırlayıcı inançların dönüştürülmesi için meditasyon yapılır.

5. ENTEGRASYON
Seans sonrası deneyimler değerlendirilir.
''',
    'en': '''
1. CONSULTATION
The topic the client wants to work on is identified.

2. MEDITATION
The practitioner and client enter the theta state together.

3. BELIEF WORK
Root beliefs are explored and questioned.

4. TRANSFORMATION
Meditation is done to transform limiting beliefs.

5. INTEGRATION
Post-session experiences are evaluated.
''',
    'fr': '''1. CONSULTATION...''',
    'de': '''1. BERATUNG...''',
    'es': '''1. CONSULTA...''',
    'ru': '''1. КОНСУЛЬТАЦИЯ...''',
    'ar': '''1. الاستشارة...''',
    'zh': '''1. 咨询...''',
    'el': '''1. ΣΥΜΒΟΥΛΕΥΤΙΚΗ...''',
    'bg': '''1. КОНСУЛТАЦИЯ...''',
  },
  symbolicInterpretation: {
    'tr': 'Theta dalgaları (4-7 Hz), derin rahatlama ve meditasyon durumlarıyla ilişkilendirilir. Bu durumda bilinçaltına erişimin kolaylaştığı düşünülür.',
    'en': 'Theta waves (4-7 Hz) are associated with deep relaxation and meditation states. In this state, access to the subconscious is thought to be easier.',
    'fr': 'Les ondes thêta (4-7 Hz) sont associées à des états de relaxation profonde et de méditation.',
    'de': 'Theta-Wellen (4-7 Hz) werden mit tiefer Entspannung und Meditationszuständen in Verbindung gebracht.',
    'es': 'Las ondas theta (4-7 Hz) están asociadas con estados de relajación profunda y meditación.',
    'ru': 'Тета-волны (4-7 Гц) связаны с состояниями глубокого расслабления и медитации.',
    'ar': 'ترتبط موجات ثيتا (4-7 هرتز) بحالات الاسترخاء العميق والتأمل.',
    'zh': '西塔波（4-7赫兹）与深度放松和冥想状态相关。',
    'el': 'Τα κύματα θήτα (4-7 Hz) συνδέονται με καταστάσεις βαθιάς χαλάρωσης και διαλογισμού.',
    'bg': 'Тета вълните (4-7 Hz) са свързани със състояния на дълбока релаксация и медитация.',
  },
  insightsProvided: {
    'tr': 'Bilinçaltı inanç kalıplarının farkındalığı, sınırlayıcı düşüncelerin keşfi, yeni perspektifler.',
    'en': 'Awareness of subconscious belief patterns, discovery of limiting thoughts, new perspectives.',
    'fr': 'Conscience des schémas de croyances subconscientes.',
    'de': 'Bewusstsein für unterbewusste Glaubensmuster.',
    'es': 'Conciencia de patrones de creencias subconscientes.',
    'ru': 'Осознание подсознательных паттернов убеждений.',
    'ar': 'الوعي بأنماط المعتقدات اللاواعية.',
    'zh': '对潜意识信念模式的认识。',
    'el': 'Επίγνωση των υποσυνείδητων μοτίβων πεποιθήσεων.',
    'bg': 'Осъзнаване на подсъзнателните модели на вярване.',
  },
  commonMotivations: {
    'tr': ['Sınırlayıcı inançları dönüştürmek', 'Kişisel gelişim', 'Duygusal blokajları çözmek', 'Yaşam kalitesini artırmak'],
    'en': ['Transforming limiting beliefs', 'Personal development', 'Resolving emotional blockages', 'Improving quality of life'],
    'fr': ['Transformer les croyances limitantes'],
    'de': ['Limitierende Überzeugungen transformieren'],
    'es': ['Transformar creencias limitantes'],
    'ru': ['Трансформация ограничивающих убеждений'],
    'ar': ['تحويل المعتقدات المحدودة'],
    'zh': ['转化限制性信念'],
    'el': ['Μεταμόρφωση περιοριστικών πεποιθήσεων'],
    'bg': ['Трансформиране на ограничаващи вярвания'],
  },
  lifeThemes: {
    'tr': ['İnançlar', 'Kişisel gelişim', 'Duygusal iyilik', 'Yaşam kalitesi'],
    'en': ['Beliefs', 'Personal development', 'Emotional well-being', 'Quality of life'],
    'fr': ['Croyances'],
    'de': ['Überzeugungen'],
    'es': ['Creencias'],
    'ru': ['Убеждения'],
    'ar': ['المعتقدات'],
    'zh': ['信念'],
    'el': ['Πεποιθήσεις'],
    'bg': ['Вярвания'],
  },
  whatYouReceive: {
    'tr': '''
• Bireysel Theta Healing seansı
• İnanç keşfi ve çalışması
• Meditasyon rehberliği
• Seans sonrası öneriler
''',
    'en': '''
• Individual Theta Healing session
• Belief discovery and work
• Meditation guidance
• Post-session recommendations
''',
    'fr': '''• Séance individuelle de Theta Healing...''',
    'de': '''• Individuelle Theta Healing Sitzung...''',
    'es': '''• Sesión individual de Theta Healing...''',
    'ru': '''• Индивидуальный сеанс Тета-Хилинга...''',
    'ar': '''• جلسة ثيتا هيلينغ فردية...''',
    'zh': '''• 个人西塔疗愈疗程...''',
    'el': '''• Ατομική συνεδρία Theta Healing...''',
    'bg': '''• Индивидуална сесия Тета Хийлинг...''',
  },
  perspectiveGained: {
    'tr': 'Bilinçaltı programlarınızı fark ederek, yaşam deneyimlerinizi şekillendiren faktörlere yeni bir bakış açısı kazanabilirsiniz.',
    'en': 'By recognizing your subconscious programs, you can gain a new perspective on factors shaping your life experiences.',
    'fr': 'En reconnaissant vos programmes subconscients, vous pouvez acquérir une nouvelle perspective.',
    'de': 'Indem Sie Ihre unterbewussten Programme erkennen, können Sie eine neue Perspektive gewinnen.',
    'es': 'Al reconocer tus programas subconscientes, puedes ganar una nueva perspectiva.',
    'ru': 'Распознавая свои подсознательные программы, вы можете получить новую перспективу.',
    'ar': 'من خلال التعرف على برامجك اللاواعية، يمكنك اكتساب منظور جديد.',
    'zh': '通过认识您的潜意识程序，您可以获得新的视角。',
    'el': 'Αναγνωρίζοντας τα υποσυνείδητα προγράμματά σας, μπορείτε να αποκτήσετε μια νέα οπτική.',
    'bg': 'Като разпознаете подсъзнателните си програми, можете да придобиете нова перспектива.',
  },
  reflectionPoints: {
    'tr': ['Hangi inançlar beni sınırlıyor?', 'Bu inançlar nereden geliyor?', 'Ne tür düşünceler tekrarlıyor?'],
    'en': ['What beliefs are limiting me?', 'Where do these beliefs come from?', 'What kinds of thoughts keep repeating?'],
    'fr': ['Quelles croyances me limitent?'],
    'de': ['Welche Überzeugungen schränken mich ein?'],
    'es': ['¿Qué creencias me limitan?'],
    'ru': ['Какие убеждения меня ограничивают?'],
    'ar': ['ما المعتقدات التي تحدني؟'],
    'zh': ['什么信念在限制我？'],
    'el': ['Ποιες πεποιθήσεις με περιορίζουν;'],
    'bg': ['Кои вярвания ме ограничават?'],
  },
  safetyDisclaimer: {
    'tr': '''
⚠️ ÖNEMLİ UYARI

Theta Healing bir wellness ve kişisel gelişim pratiğidir. TIBBİ TEDAVİNİN YERİNE GEÇMEZ. Bilimsel olarak kanıtlanmış bir tedavi yöntemi değildir. Sağlık sorunlarınız için her zaman doktora danışın.
''',
    'en': '''
⚠️ IMPORTANT NOTICE

Theta Healing is a wellness and personal development practice. It DOES NOT REPLACE MEDICAL TREATMENT. It is not a scientifically proven treatment method. Always consult a doctor for your health issues.
''',
    'fr': '''⚠️ AVIS IMPORTANT - Le Theta Healing est une pratique de bien-être. IL NE REMPLACE PAS LE TRAITEMENT MÉDICAL...''',
    'de': '''⚠️ WICHTIGER HINWEIS - Theta Healing ist eine Wellness-Praxis. ES ERSETZT KEINE MEDIZINISCHE BEHANDLUNG...''',
    'es': '''⚠️ AVISO IMPORTANTE - Theta Healing es una práctica de bienestar. NO REEMPLAZA EL TRATAMIENTO MÉDICO...''',
    'ru': '''⚠️ ВАЖНОЕ УВЕДОМЛЕНИЕ - Тета-Хилинг — это оздоровительная практика. ОНА НЕ ЗАМЕНЯЕТ МЕДИЦИНСКОЕ ЛЕЧЕНИЕ...''',
    'ar': '''⚠️ إشعار هام - ثيتا هيلينغ هو ممارسة صحية. لا يحل محل العلاج الطبي...''',
    'zh': '''⚠️ 重要提示 - 西塔疗愈是一种健康和个人发展练习。它不能替代医疗治疗...''',
    'el': '''⚠️ ΣΗΜΑΝΤΙΚΗ ΕΙΔΟΠΟΙΗΣΗ - Το Theta Healing είναι μια πρακτική ευεξίας. ΔΕΝ ΑΝΤΙΚΑΘΙΣΤΑ ΤΗΝ ΙΑΤΡΙΚΗ ΘΕΡΑΠΕΙΑ...''',
    'bg': '''⚠️ ВАЖНО СЪОБЩЕНИЕ - Тета Хийлинг е практика за уелнес. НЕ ЗАМЕСТВА МЕДИЦИНСКОТО ЛЕЧЕНИЕ...''',
  },
  doesNotDo: {
    'tr': ['Tıbbi tedavi değildir', 'Hastalık tedavi etmez', 'Bilimsel olarak kanıtlanmış değildir', 'Psikoterapi yerine geçmez'],
    'en': ['Is not medical treatment', 'Does not cure illness', 'Is not scientifically proven', 'Does not replace psychotherapy'],
    'fr': ['N\'est pas un traitement médical'],
    'de': ['Ist keine medizinische Behandlung'],
    'es': ['No es tratamiento médico'],
    'ru': ['Не является медицинским лечением'],
    'ar': ['ليس علاجاً طبياً'],
    'zh': ['不是医疗治疗'],
    'el': ['Δεν είναι ιατρική θεραπεία'],
    'bg': ['Не е медицинско лечение'],
  },
  exampleScenarios: {
    'tr': ['Özgüven sorunları yaşayan biri, Theta Healing seansında "yeterli değilim" kök inancını keşfetti ve bu farkındalık kişisel gelişim yolculuğunda yardımcı oldu.'],
    'en': ['Someone experiencing self-confidence issues discovered the root belief "I am not enough" in a Theta Healing session, and this awareness helped in their personal development journey.'],
    'fr': ['Quelqu\'un ayant des problèmes de confiance en soi a découvert...'],
    'de': ['Jemand mit Selbstvertrauensproblemen entdeckte...'],
    'es': ['Alguien con problemas de autoconfianza descubrió...'],
    'ru': ['Кто-то с проблемами уверенности в себе обнаружил...'],
    'ar': ['اكتشف شخص يعاني من مشاكل الثقة بالنفس...'],
    'zh': ['一个有自信问题的人发现了...'],
    'el': ['Κάποιος με προβλήματα αυτοπεποίθησης ανακάλυψε...'],
    'bg': ['Някой с проблеми със самочувствието откри...'],
  },
  faq: {
    'tr': [
      FAQItem(question: 'Theta Healing bilimsel mi?', answer: 'Theta Healing bilimsel olarak kanıtlanmış bir tedavi yöntemi değildir. Wellness ve kişisel gelişim pratiği olarak sunulmaktadır.'),
      FAQItem(question: 'Bir seansta ne olur?', answer: 'Uygulayıcı rehberliğinde meditasyon yapılır ve bilinçaltı inanç kalıpları keşfedilir.'),
    ],
    'en': [
      FAQItem(question: 'Is Theta Healing scientific?', answer: 'Theta Healing is not a scientifically proven treatment method. It is offered as a wellness and personal development practice.'),
      FAQItem(question: 'What happens in a session?', answer: 'Meditation is done under the practitioner\'s guidance and subconscious belief patterns are explored.'),
    ],
    'fr': [FAQItem(question: 'Le Theta Healing est-il scientifique?', answer: 'Le Theta Healing n\'est pas une méthode de traitement scientifiquement prouvée.')],
    'de': [FAQItem(question: 'Ist Theta Healing wissenschaftlich?', answer: 'Theta Healing ist keine wissenschaftlich bewiesene Behandlungsmethode.')],
    'es': [FAQItem(question: '¿Es científico el Theta Healing?', answer: 'Theta Healing no es un método de tratamiento científicamente probado.')],
    'ru': [FAQItem(question: 'Является ли Тета-Хилинг научным?', answer: 'Тета-Хилинг не является научно доказанным методом лечения.')],
    'ar': [FAQItem(question: 'هل ثيتا هيلينغ علمي؟', answer: 'ثيتا هيلينغ ليس طريقة علاج مثبتة علمياً.')],
    'zh': [FAQItem(question: '西塔疗愈是科学的吗？', answer: '西塔疗愈不是一种经过科学证明的治疗方法。')],
    'el': [FAQItem(question: 'Είναι το Theta Healing επιστημονικό;', answer: 'Το Theta Healing δεν είναι μια επιστημονικά αποδεδειγμένη μέθοδος θεραπείας.')],
    'bg': [FAQItem(question: 'Научен ли е Тета Хийлинг?', answer: 'Тета Хийлинг не е научно доказан метод на лечение.')],
  },
  relatedPractices: {
    'tr': ['NLP', 'Hipnoterapi', 'Meditasyon', 'Reiki'],
    'en': ['NLP', 'Hypnotherapy', 'Meditation', 'Reiki'],
    'fr': ['PNL', 'Hypnothérapie'],
    'de': ['NLP', 'Hypnotherapie'],
    'es': ['PNL', 'Hipnoterapia'],
    'ru': ['НЛП', 'Гипнотерапия'],
    'ar': ['البرمجة اللغوية العصبية', 'العلاج بالتنويم'],
    'zh': ['神经语言程序学', '催眠疗法'],
    'el': ['NLP', 'Υπνοθεραπεία'],
    'bg': ['НЛП', 'Хипнотерапия'],
  },
  differenceFromSimilar: {
    'tr': 'Theta Healing inanç çalışmasına odaklanırken, Reiki enerji akışı üzerinde çalışır. Hipnoterapi trans durumunu kullanırken, Theta Healing meditasyon temelli bir yaklaşım sunar.',
    'en': 'Theta Healing focuses on belief work while Reiki works on energy flow. Hypnotherapy uses trance states while Theta Healing offers a meditation-based approach.',
    'fr': 'Le Theta Healing se concentre sur le travail sur les croyances tandis que le Reiki travaille sur le flux d\'énergie.',
    'de': 'Theta Healing konzentriert sich auf Glaubensarbeit, während Reiki am Energiefluss arbeitet.',
    'es': 'Theta Healing se enfoca en el trabajo de creencias mientras que Reiki trabaja en el flujo de energía.',
    'ru': 'Тета-Хилинг фокусируется на работе с убеждениями, тогда как Рейки работает с потоком энергии.',
    'ar': 'يركز ثيتا هيلينغ على عمل المعتقدات بينما يعمل الريكي على تدفق الطاقة.',
    'zh': '西塔疗愈专注于信念工作，而灵气专注于能量流动。',
    'el': 'Το Theta Healing επικεντρώνεται στην εργασία πεποιθήσεων ενώ το Ρέικι εργάζεται στη ροή ενέργειας.',
    'bg': 'Тета Хийлинг се фокусира върху работата с вярвания, докато Рейки работи върху енергийния поток.',
  },
  microLearning: {
    'tr': ['💡 Theta beyin dalgaları 4-7 Hz arasında salınır.', '💡 Theta durumu, uyku ile uyanıklık arasındaki geçiş halidir.'],
    'en': ['💡 Theta brainwaves oscillate between 4-7 Hz.', '💡 The theta state is the transition state between sleep and wakefulness.'],
    'fr': ['💡 Les ondes cérébrales thêta oscillent entre 4-7 Hz.'],
    'de': ['💡 Theta-Gehirnwellen schwingen zwischen 4-7 Hz.'],
    'es': ['💡 Las ondas cerebrales theta oscilan entre 4-7 Hz.'],
    'ru': ['💡 Тета-волны мозга колеблются между 4-7 Гц.'],
    'ar': ['💡 تتذبذب موجات الدماغ ثيتا بين 4-7 هرتز.'],
    'zh': ['💡 西塔脑波在4-7赫兹之间振荡。'],
    'el': ['💡 Τα εγκεφαλικά κύματα θήτα ταλαντώνονται μεταξύ 4-7 Hz.'],
    'bg': ['💡 Тета мозъчните вълни осцилират между 4-7 Hz.'],
  },
);

// ═══════════════════════════════════════════════════════════════════════════════
// CRESCENT HEALING SERVICES
// ═══════════════════════════════════════════════════════════════════════════════

final crescentHealingConsultation = ServiceContent(
  id: 'crescent_healing_consultation',
  category: ServiceCategory.crescentHealing,
  icon: '🌙',
  displayOrder: 60,
  name: {
    'tr': 'Hilal Şifa',
    'en': 'Crescent Healing',
    'fr': 'Guérison du Croissant',
    'de': 'Mondheilung',
    'es': 'Sanación Creciente',
    'ru': 'Полумесячное Исцеление',
    'ar': 'شفاء الهلال',
    'zh': '新月疗愈',
    'el': 'Θεραπεία Ημισελήνου',
    'bg': 'Полумесечно Изцеление',
  },
  shortDescription: {
    'tr': 'Ay döngüleri ve kozmik enerjilerle uyumlanarak denge ve yenilenme deneyimi.',
    'en': 'A balance and renewal experience by aligning with lunar cycles and cosmic energies.',
    'fr': 'Une expérience d\'équilibre et de renouvellement en s\'alignant sur les cycles lunaires et les énergies cosmiques.',
    'de': 'Eine Gleichgewichts- und Erneuerungserfahrung durch Ausrichtung auf Mondzyklen und kosmische Energien.',
    'es': 'Una experiencia de equilibrio y renovación al alinearse con los ciclos lunares y las energías cósmicas.',
    'ru': 'Опыт баланса и обновления через настройку на лунные циклы и космические энергии.',
    'ar': 'تجربة توازن وتجديد من خلال التناغم مع دورات القمر والطاقات الكونية.',
    'zh': '通过与月球周期和宇宙能量对齐获得平衡和更新体验。',
    'el': 'Μια εμπειρία ισορροπίας και ανανέωσης ευθυγραμμιζόμενοι με τους σεληνιακούς κύκλους και τις κοσμικές ενέργειες.',
    'bg': 'Преживяване на баланс и обновление чрез съгласуване с лунните цикли и космическите енергии.',
  },
  coreExplanation: {
    'tr': '''
Hilal Şifa, ay döngülerinin enerjisini kullanarak denge ve uyum arayışı üzerine kurulu bir wellness pratiğidir.

Bu yaklaşımda, ayın farklı evrelerinin (yeni ay, hilal, dolunay, azalan ay) farklı enerji kaliteleri taşıdığına inanılır. Seanslar genellikle bu döngülere uygun şekilde planlanır.

Yeni ay dönemleri yeni başlangıçlar ve niyet belirleme için, dolunay dönemleri tamamlama ve salıverme için uygun görülür. Hilal Şifa seansları meditasyon, nefes çalışması ve enerji dengeleme tekniklerini içerebilir.

Bu pratik, bilimsel olarak kanıtlanmış bir tedavi yöntemi değildir ve wellness/rahatlama deneyimi olarak sunulmaktadır.
''',
    'en': '''
Crescent Healing is a wellness practice based on seeking balance and harmony using the energy of lunar cycles.

In this approach, different phases of the moon (new moon, crescent, full moon, waning moon) are believed to carry different energy qualities. Sessions are typically planned in accordance with these cycles.

New moon periods are seen as suitable for new beginnings and setting intentions, while full moon periods are for completion and release. Crescent Healing sessions may include meditation, breathwork, and energy balancing techniques.

This practice is not a scientifically proven treatment method and is offered as a wellness/relaxation experience.
''',
    'fr': """La Guérison du Croissant est une pratique de bien-être basée sur la recherche d'équilibre en utilisant l'énergie des cycles lunaires...""",
    'de': '''Mondheilung ist eine Wellness-Praxis, die auf der Suche nach Gleichgewicht durch die Energie der Mondzyklen basiert...''',
    'es': '''La Sanación Creciente es una práctica de bienestar basada en buscar el equilibrio usando la energía de los ciclos lunares...''',
    'ru': '''Полумесячное Исцеление — это оздоровительная практика, основанная на поиске баланса с использованием энергии лунных циклов...''',
    'ar': '''شفاء الهلال هو ممارسة صحية تعتمد على البحث عن التوازن باستخدام طاقة دورات القمر...''',
    'zh': '''新月疗愈是一种利用月球周期能量寻求平衡的健康实践...''',
    'el': '''Η Θεραπεία Ημισελήνου είναι μια πρακτική ευεξίας βασισμένη στην αναζήτηση ισορροπίας χρησιμοποιώντας την ενέργεια των σεληνιακών κύκλων...''',
    'bg': '''Полумесечното Изцеление е практика за уелнес, базирана на търсенето на баланс, използвайки енергията на лунните цикли...''',
  },
  historicalBackground: {
    'tr': 'Ay döngülerine uyum sağlama pratiği birçok kültürde kadim geleneklere dayanır. Modern Hilal Şifa, bu geleneklerden ilham alan çağdaş bir wellness yaklaşımıdır.',
    'en': 'The practice of aligning with lunar cycles is rooted in ancient traditions across many cultures. Modern Crescent Healing is a contemporary wellness approach inspired by these traditions.',
    'fr': 'La pratique de l\'alignement avec les cycles lunaires est enracinée dans des traditions anciennes.',
    'de': 'Die Praxis der Ausrichtung auf Mondzyklen ist in alten Traditionen verwurzelt.',
    'es': 'La práctica de alinearse con los ciclos lunares está arraigada en tradiciones antiguas.',
    'ru': 'Практика настройки на лунные циклы уходит корнями в древние традиции.',
    'ar': 'ممارسة التناغم مع دورات القمر متجذرة في التقاليد القديمة.',
    'zh': '与月球周期对齐的做法源于古老的传统。',
    'el': 'Η πρακτική της ευθυγράμμισης με τους σεληνιακούς κύκλους έχει ρίζες σε αρχαίες παραδόσεις.',
    'bg': 'Практиката на съгласуване с лунните цикли е вкоренена в древни традиции.',
  },
  philosophicalFoundation: {
    'tr': 'Ayın döngüsel enerjisinin insan deneyimini etkilediği inancı, birçok ruhani gelenekte mevcuttur. Hilal Şifa, bu kozmik ritimlerle bilinçli uyumlanma pratiğidir.',
    'en': 'The belief that the moon\'s cyclical energy affects human experience exists in many spiritual traditions. Crescent Healing is the practice of consciously aligning with these cosmic rhythms.',
    'fr': 'La croyance que l\'énergie cyclique de la lune affecte l\'expérience humaine existe dans de nombreuses traditions spirituelles.',
    'de': 'Der Glaube, dass die zyklische Energie des Mondes die menschliche Erfahrung beeinflusst, existiert in vielen spirituellen Traditionen.',
    'es': 'La creencia de que la energía cíclica de la luna afecta la experiencia humana existe en muchas tradiciones espirituales.',
    'ru': 'Вера в то, что циклическая энергия луны влияет на человеческий опыт, существует во многих духовных традициях.',
    'ar': 'الاعتقاد بأن الطاقة الدورية للقمر تؤثر على التجربة البشرية موجود في العديد من التقاليد الروحية.',
    'zh': '月球周期性能量影响人类体验的信念存在于许多灵性传统中。',
    'el': 'Η πεποίθηση ότι η κυκλική ενέργεια της σελήνης επηρεάζει την ανθρώπινη εμπειρία υπάρχει σε πολλές πνευματικές παραδόσεις.',
    'bg': 'Вярването, че цикличната енергия на луната влияе на човешкия опит, съществува в много духовни традиции.',
  },
  howItWorks: {
    'tr': '''
1. AY EVRESİ BELİRLEME
Mevcut ay evresi ve enerjisi değerlendirilir.

2. NİYET BELİRLEME
Ay evresine uygun bir niyet veya odak belirlenir.

3. MEDİTASYON VE NEFES ÇALIŞMASI
Rehberli meditasyon ve nefes teknikleri uygulanır.

4. ENERJİ DENGELİK
Enerji dengeleme çalışması yapılır.

5. ENTEGRASYON
Deneyim değerlendirilir ve günlük yaşama taşınır.
''',
    'en': '''
1. DETERMINING MOON PHASE
The current moon phase and its energy are evaluated.

2. SETTING INTENTION
An intention or focus appropriate to the moon phase is set.

3. MEDITATION AND BREATHWORK
Guided meditation and breathing techniques are applied.

4. ENERGY BALANCING
Energy balancing work is performed.

5. INTEGRATION
The experience is evaluated and carried into daily life.
''',
    'fr': '''1. DÉTERMINATION DE LA PHASE LUNAIRE...''',
    'de': '''1. BESTIMMUNG DER MONDPHASE...''',
    'es': '''1. DETERMINAR LA FASE LUNAR...''',
    'ru': '''1. ОПРЕДЕЛЕНИЕ ФАЗЫ ЛУНЫ...''',
    'ar': '''1. تحديد مرحلة القمر...''',
    'zh': '''1. 确定月相...''',
    'el': '''1. ΚΑΘΟΡΙΣΜΟΣ ΤΗΣ ΦΑΣΗΣ ΤΗΣ ΣΕΛΗΝΗΣ...''',
    'bg': '''1. ОПРЕДЕЛЯНЕ НА ЛУННАТА ФАЗА...''',
  },
  symbolicInterpretation: {
    'tr': '''
AY EVRELERİ:
🌑 Yeni Ay - Yeni başlangıçlar, niyet belirleme
🌒 Hilal - Büyüme, harekete geçme
🌕 Dolunay - Tamamlama, aydınlanma
🌘 Azalan Ay - Salıverme, içe dönüş
''',
    'en': '''
MOON PHASES:
🌑 New Moon - New beginnings, setting intentions
🌒 Crescent - Growth, taking action
🌕 Full Moon - Completion, illumination
🌘 Waning Moon - Release, turning inward
''',
    'fr': '''PHASES LUNAIRES...''',
    'de': '''MONDPHASEN...''',
    'es': '''FASES LUNARES...''',
    'ru': '''ФАЗЫ ЛУНЫ...''',
    'ar': '''مراحل القمر...''',
    'zh': '''月相...''',
    'el': '''ΦΑΣΕΙΣ ΤΗΣ ΣΕΛΗΝΗΣ...''',
    'bg': '''ЛУННИ ФАЗИ...''',
  },
  insightsProvided: {
    'tr': 'Ay döngüleriyle uyum, döngüsel yaşam farkındalığı, rahatlama ve yenilenme.',
    'en': 'Alignment with lunar cycles, awareness of cyclical living, relaxation and renewal.',
    'fr': 'Alignement avec les cycles lunaires, conscience de la vie cyclique.',
    'de': 'Ausrichtung auf Mondzyklen, Bewusstsein für zyklisches Leben.',
    'es': 'Alineación con los ciclos lunares, conciencia de la vida cíclica.',
    'ru': 'Настройка на лунные циклы, осознание цикличной жизни.',
    'ar': 'التناغم مع دورات القمر، الوعي بالحياة الدورية.',
    'zh': '与月球周期对齐，对周期性生活的认识。',
    'el': 'Ευθυγράμμιση με τους σεληνιακούς κύκλους, επίγνωση της κυκλικής ζωής.',
    'bg': 'Съгласуване с лунните цикли, осъзнаване на цикличния живот.',
  },
  commonMotivations: {
    'tr': ['Doğal ritimlerle uyum', 'Rahatlama ve yenilenme', 'Döngüsel yaşam pratiği', 'Ruhsal bağlantı'],
    'en': ['Alignment with natural rhythms', 'Relaxation and renewal', 'Cyclical living practice', 'Spiritual connection'],
    'fr': ['Alignement avec les rythmes naturels'],
    'de': ['Ausrichtung auf natürliche Rhythmen'],
    'es': ['Alineación con los ritmos naturales'],
    'ru': ['Настройка на природные ритмы'],
    'ar': ['التناغم مع الإيقاعات الطبيعية'],
    'zh': ['与自然节奏对齐'],
    'el': ['Ευθυγράμμιση με τους φυσικούς ρυθμούς'],
    'bg': ['Съгласуване с естествените ритми'],
  },
  lifeThemes: {
    'tr': ['Döngüler', 'Yenilenme', 'Denge', 'Ruhsal pratik'],
    'en': ['Cycles', 'Renewal', 'Balance', 'Spiritual practice'],
    'fr': ['Cycles'],
    'de': ['Zyklen'],
    'es': ['Ciclos'],
    'ru': ['Циклы'],
    'ar': ['الدورات'],
    'zh': ['周期'],
    'el': ['Κύκλοι'],
    'bg': ['Цикли'],
  },
  whatYouReceive: {
    'tr': '''
• Ay evresine uygun seans
• Rehberli meditasyon
• Nefes çalışması
• Niyet belirleme desteği
• Enerji dengeleme
''',
    'en': '''
• Session appropriate to moon phase
• Guided meditation
• Breathwork
• Intention setting support
• Energy balancing
''',
    'fr': '''• Séance adaptée à la phase lunaire...''',
    'de': '''• Sitzung passend zur Mondphase...''',
    'es': '''• Sesión apropiada para la fase lunar...''',
    'ru': '''• Сеанс, соответствующий фазе луны...''',
    'ar': '''• جلسة مناسبة لمرحلة القمر...''',
    'zh': '''• 适合月相的疗程...''',
    'el': '''• Συνεδρία κατάλληλη για τη φάση της σελήνης...''',
    'bg': '''• Сесия, подходяща за лунната фаза...''',
  },
  perspectiveGained: {
    'tr': 'Yaşamın döngüsel doğasıyla uyum sağlayarak daha dengeli ve ritmik bir yaşam perspektifi kazanabilirsiniz.',
    'en': 'By aligning with the cyclical nature of life, you can gain a more balanced and rhythmic life perspective.',
    'fr': 'En vous alignant sur la nature cyclique de la vie, vous pouvez acquérir une perspective plus équilibrée.',
    'de': 'Indem Sie sich auf die zyklische Natur des Lebens ausrichten, können Sie eine ausgewogenere Perspektive gewinnen.',
    'es': 'Al alinearte con la naturaleza cíclica de la vida, puedes ganar una perspectiva más equilibrada.',
    'ru': 'Настраиваясь на циклическую природу жизни, вы можете обрести более сбалансированную перспективу.',
    'ar': 'من خلال التناغم مع الطبيعة الدورية للحياة، يمكنك اكتساب منظور أكثر توازناً.',
    'zh': '通过与生命的周期性本质对齐，您可以获得更平衡的生活视角。',
    'el': 'Ευθυγραμμίζοντας με την κυκλική φύση της ζωής, μπορείτε να αποκτήσετε μια πιο ισορροπημένη προοπτική.',
    'bg': 'Съгласувайки се с цикличната природа на живота, можете да придобиете по-балансирана перспектива.',
  },
  reflectionPoints: {
    'tr': ['Hayatımda hangi döngüleri fark ediyorum?', 'Neyi salıvermeye hazırım?', 'Yeni başlangıçlar için ne istiyorum?'],
    'en': ['What cycles do I notice in my life?', 'What am I ready to release?', 'What do I want for new beginnings?'],
    'fr': ['Quels cycles remarqué-je dans ma vie?'],
    'de': ['Welche Zyklen bemerke ich in meinem Leben?'],
    'es': ['¿Qué ciclos noto en mi vida?'],
    'ru': ['Какие циклы я замечаю в своей жизни?'],
    'ar': ['ما الدورات التي ألاحظها في حياتي؟'],
    'zh': ['我在生活中注意到什么周期？'],
    'el': ['Ποιους κύκλους παρατηρώ στη ζωή μου;'],
    'bg': ['Какви цикли забелязвам в живота си?'],
  },
  safetyDisclaimer: {
    'tr': '''
⚠️ ÖNEMLİ UYARI

Hilal Şifa bir wellness ve rahatlama pratiğidir. TIBBİ TEDAVİNİN YERİNE GEÇMEZ. Bilimsel olarak kanıtlanmış bir tedavi yöntemi değildir.
''',
    'en': '''
⚠️ IMPORTANT NOTICE

Crescent Healing is a wellness and relaxation practice. It DOES NOT REPLACE MEDICAL TREATMENT. It is not a scientifically proven treatment method.
''',
    'fr': '''⚠️ AVIS IMPORTANT - La Guérison du Croissant est une pratique de bien-être. IL NE REMPLACE PAS LE TRAITEMENT MÉDICAL...''',
    'de': '''⚠️ WICHTIGER HINWEIS - Mondheilung ist eine Wellness-Praxis. ES ERSETZT KEINE MEDIZINISCHE BEHANDLUNG...''',
    'es': '''⚠️ AVISO IMPORTANTE - La Sanación Creciente es una práctica de bienestar. NO REEMPLAZA EL TRATAMIENTO MÉDICO...''',
    'ru': '''⚠️ ВАЖНОЕ УВЕДОМЛЕНИЕ - Полумесячное Исцеление — это оздоровительная практика. ОНА НЕ ЗАМЕНЯЕТ МЕДИЦИНСКОЕ ЛЕЧЕНИЕ...''',
    'ar': '''⚠️ إشعار هام - شفاء الهلال هو ممارسة صحية. لا يحل محل العلاج الطبي...''',
    'zh': '''⚠️ 重要提示 - 新月疗愈是一种健康和放松练习。它不能替代医疗治疗...''',
    'el': '''⚠️ ΣΗΜΑΝΤΙΚΗ ΕΙΔΟΠΟΙΗΣΗ - Η Θεραπεία Ημισελήνου είναι μια πρακτική ευεξίας. ΔΕΝ ΑΝΤΙΚΑΘΙΣΤΑ ΤΗΝ ΙΑΤΡΙΚΗ ΘΕΡΑΠΕΙΑ...''',
    'bg': '''⚠️ ВАЖНО СЪОБЩЕНИЕ - Полумесечното Изцеление е практика за уелнес. НЕ ЗАМЕСТВА МЕДИЦИНСКОТО ЛЕЧЕНИЕ...''',
  },
  doesNotDo: {
    'tr': ['Tıbbi tedavi değildir', 'Hastalık tedavi etmez', 'Bilimsel olarak kanıtlanmış değildir', 'Kesin sonuçlar garanti etmez'],
    'en': ['Is not medical treatment', 'Does not cure illness', 'Is not scientifically proven', 'Does not guarantee definite results'],
    'fr': ['N\'est pas un traitement médical'],
    'de': ['Ist keine medizinische Behandlung'],
    'es': ['No es tratamiento médico'],
    'ru': ['Не является медицинским лечением'],
    'ar': ['ليس علاجاً طبياً'],
    'zh': ['不是医疗治疗'],
    'el': ['Δεν είναι ιατρική θεραπεία'],
    'bg': ['Не е медицинско лечение'],
  },
  exampleScenarios: {
    'tr': ['Yeni ay döneminde yapılan seansta, danışan yeni yıl niyetlerini belirledi ve bu süreci destekleyen meditasyon pratiği yaptı.'],
    'en': ['In a session during the new moon period, the client set their new year intentions and did meditation practice supporting this process.'],
    'fr': ['Lors d\'une séance pendant la période de nouvelle lune...'],
    'de': ['In einer Sitzung während der Neumondphase...'],
    'es': ['En una sesión durante el período de luna nueva...'],
    'ru': ['На сеансе в период новолуния...'],
    'ar': ['في جلسة خلال فترة القمر الجديد...'],
    'zh': ['在新月期间的疗程中...'],
    'el': ['Σε μια συνεδρία κατά την περίοδο της νέας σελήνης...'],
    'bg': ['На сесия по време на периода на новолуние...'],
  },
  faq: {
    'tr': [
      FAQItem(question: 'Ay evresi gerçekten etkili mi?', answer: 'Ayın insan deneyimine etkisi bilimsel olarak kanıtlanmış değildir. Bu pratik, sembolik ve ruhani bir çerçeve sunmaktadır.'),
      FAQItem(question: 'Hangi ay evresinde seans yapılmalı?', answer: 'Her ay evresi farklı temalar için uygundur. Yeni ay yeni başlangıçlar, dolunay salıverme için idealdir.'),
    ],
    'en': [
      FAQItem(question: 'Is the moon phase really effective?', answer: 'The moon\'s effect on human experience is not scientifically proven. This practice offers a symbolic and spiritual framework.'),
      FAQItem(question: 'Which moon phase should I have a session in?', answer: 'Each moon phase is suitable for different themes. New moon is ideal for new beginnings, full moon for release.'),
    ],
    'fr': [FAQItem(question: 'La phase lunaire est-elle vraiment efficace?', answer: 'L\'effet de la lune sur l\'expérience humaine n\'est pas scientifiquement prouvé.')],
    'de': [FAQItem(question: 'Ist die Mondphase wirklich wirksam?', answer: 'Die Wirkung des Mondes auf die menschliche Erfahrung ist wissenschaftlich nicht bewiesen.')],
    'es': [FAQItem(question: '¿Es realmente efectiva la fase lunar?', answer: 'El efecto de la luna en la experiencia humana no está científicamente probado.')],
    'ru': [FAQItem(question: 'Действительно ли фаза луны эффективна?', answer: 'Влияние луны на человеческий опыт научно не доказано.')],
    'ar': [FAQItem(question: 'هل مرحلة القمر فعالة حقاً؟', answer: 'تأثير القمر على التجربة البشرية ليس مثبتاً علمياً.')],
    'zh': [FAQItem(question: '月相真的有效吗？', answer: '月球对人类体验的影响在科学上没有得到证明。')],
    'el': [FAQItem(question: 'Είναι πραγματικά αποτελεσματική η φάση της σελήνης;', answer: 'Η επίδραση της σελήνης στην ανθρώπινη εμπειρία δεν έχει αποδειχθεί επιστημονικά.')],
    'bg': [FAQItem(question: 'Наистина ли е ефективна лунната фаза?', answer: 'Въздействието на луната върху човешкия опит не е научно доказано.')],
  },
  relatedPractices: {
    'tr': ['Astroloji', 'Meditasyon', 'Ritüel Çalışması', 'Enerji Çalışması'],
    'en': ['Astrology', 'Meditation', 'Ritual Work', 'Energy Work'],
    'fr': ['Astrologie', 'Méditation'],
    'de': ['Astrologie', 'Meditation'],
    'es': ['Astrología', 'Meditación'],
    'ru': ['Астрология', 'Медитация'],
    'ar': ['علم الفلك', 'التأمل'],
    'zh': ['占星术', '冥想'],
    'el': ['Αστρολογία', 'Διαλογισμός'],
    'bg': ['Астрология', 'Медитация'],
  },
  differenceFromSimilar: {
    'tr': 'Hilal Şifa özellikle ay döngülerine odaklanırken, Reiki genel enerji çalışmasıdır. Astroloji gezegen etkilerini incelerken, Hilal Şifa spesifik olarak ay enerjisi üzerinde çalışır.',
    'en': 'Crescent Healing specifically focuses on lunar cycles while Reiki is general energy work. Astrology examines planetary influences while Crescent Healing specifically works with lunar energy.',
    'fr': 'La Guérison du Croissant se concentre spécifiquement sur les cycles lunaires tandis que le Reiki est un travail énergétique général.',
    'de': 'Mondheilung konzentriert sich speziell auf Mondzyklen, während Reiki allgemeine Energiearbeit ist.',
    'es': 'La Sanación Creciente se enfoca específicamente en los ciclos lunares mientras que Reiki es trabajo energético general.',
    'ru': 'Полумесячное Исцеление специально фокусируется на лунных циклах, тогда как Рейки — это общая энергетическая работа.',
    'ar': 'يركز شفاء الهلال بشكل خاص على دورات القمر بينما الريكي هو عمل طاقة عام.',
    'zh': '新月疗愈特别关注月球周期，而灵气是一般的能量工作。',
    'el': 'Η Θεραπεία Ημισελήνου επικεντρώνεται ειδικά στους σεληνιακούς κύκλους ενώ το Ρέικι είναι γενική ενεργειακή εργασία.',
    'bg': 'Полумесечното Изцеление се фокусира специално върху лунните цикли, докато Рейки е обща енергийна работа.',
  },
  microLearning: {
    'tr': ['💡 Ay yaklaşık 29.5 günlük bir döngüde evrelerini tamamlar.', '💡 Yeni ay, güneş ve ayın aynı yönde olduğu dönemdir.'],
    'en': ['💡 The moon completes its phases in a cycle of approximately 29.5 days.', '💡 New moon is the period when the sun and moon are in the same direction.'],
    'fr': ['💡 La lune complète ses phases en un cycle d\'environ 29,5 jours.'],
    'de': ['💡 Der Mond durchläuft seine Phasen in einem Zyklus von etwa 29,5 Tagen.'],
    'es': ['💡 La luna completa sus fases en un ciclo de aproximadamente 29,5 días.'],
    'ru': ['💡 Луна завершает свои фазы за цикл примерно в 29,5 дней.'],
    'ar': ['💡 يكمل القمر مراحله في دورة تبلغ حوالي 29.5 يومًا.'],
    'zh': ['💡 月球大约在29.5天的周期内完成其相位。'],
    'el': ['💡 Η σελήνη ολοκληρώνει τις φάσεις της σε κύκλο περίπου 29,5 ημερών.'],
    'bg': ['💡 Луната завършва фазите си в цикъл от приблизително 29,5 дни.'],
  },
);

// ═══════════════════════════════════════════════════════════════════════════════
// JAAS SERVICES
// ═══════════════════════════════════════════════════════════════════════════════

final jaasConsultation = ServiceContent(
  id: 'jaas_consultation',
  category: ServiceCategory.jaas,
  icon: '🔷',
  displayOrder: 45,
  name: {
    'tr': 'JAAS Danışmanlığı',
    'en': 'JAAS Consultation',
    'fr': 'Consultation JAAS',
    'de': 'JAAS Beratung',
    'es': 'Consulta JAAS',
    'ru': 'Консультация ЯААС',
    'ar': 'استشارة جاس',
    'zh': 'JAAS咨询',
    'el': 'Συμβουλευτική JAAS',
    'bg': 'Консултация ЯААС',
  },
  shortDescription: {
    'tr': 'Bütünsel enerji değerlendirmesi ve denge çalışması ile içsel uyum deneyimi.',
    'en': 'Inner harmony experience through holistic energy assessment and balance work.',
    'fr': 'Expérience d\'harmonie intérieure grâce à l\'évaluation énergétique holistique et au travail d\'équilibre.',
    'de': 'Innere Harmonie-Erfahrung durch ganzheitliche Energiebewertung und Gleichgewichtsarbeit.',
    'es': 'Experiencia de armonía interior a través de evaluación energética holística y trabajo de equilibrio.',
    'ru': 'Опыт внутренней гармонии через целостную оценку энергии и работу по балансировке.',
    'ar': 'تجربة الانسجام الداخلي من خلال تقييم الطاقة الشامل وعمل التوازن.',
    'zh': '通过整体能量评估和平衡工作获得内在和谐体验。',
    'el': 'Εμπειρία εσωτερικής αρμονίας μέσω ολιστικής αξιολόγησης ενέργειας και εργασίας ισορροπίας.',
    'bg': 'Преживяване на вътрешна хармония чрез холистична оценка на енергията и работа за баланс.',
  },
  coreExplanation: {
    'tr': '''
JAAS, bütünsel bir enerji değerlendirme ve dengeleme yaklaşımıdır. Bu sistem, bireyin enerji alanını çok boyutlu olarak değerlendirir.

Seanslar, enerji okuma, blokaj tespiti ve dengeleme çalışmalarını içerir. Uygulayıcı, danışanın enerji alanını tarayarak harmonik olmayan alanları belirler ve dengeleme teknikleri uygular.

Bu yaklaşım, geleneksel şifa pratiklerinden ilham alan modern bir wellness sistemidir. Bilimsel olarak kanıtlanmış bir tedavi yöntemi değildir ve kişisel gelişim/wellness pratiği olarak sunulmaktadır.
''',
    'en': '''
JAAS is a holistic energy assessment and balancing approach. This system evaluates an individual's energy field multi-dimensionally.

Sessions include energy reading, blockage detection, and balancing work. The practitioner scans the client's energy field to identify areas that are not in harmony and applies balancing techniques.

This approach is a modern wellness system inspired by traditional healing practices. It is not a scientifically proven treatment method and is offered as a personal development/wellness practice.
''',
    'fr': """JAAS est une approche holistique d'évaluation et d'équilibrage de l'énergie...""",
    'de': '''JAAS ist ein ganzheitlicher Ansatz zur Energiebewertung und -ausgleichung...''',
    'es': '''JAAS es un enfoque holístico de evaluación y equilibrio energético...''',
    'ru': '''ЯААС — это целостный подход к оценке и балансировке энергии...''',
    'ar': '''جاس هو نهج شامل لتقييم الطاقة وتوازنها...''',
    'zh': '''JAAS是一种整体能量评估和平衡方法...''',
    'el': '''Το JAAS είναι μια ολιστική προσέγγιση αξιολόγησης και εξισορρόπησης ενέργειας...''',
    'bg': '''ЯААС е холистичен подход за оценка и балансиране на енергията...''',
  },
  historicalBackground: {
    'tr': 'JAAS, çeşitli geleneksel enerji şifa yöntemlerinden ilham alan modern bir wellness sistemidir.',
    'en': 'JAAS is a modern wellness system inspired by various traditional energy healing methods.',
    'fr': 'JAAS est un système de bien-être moderne inspiré de diverses méthodes traditionnelles de guérison énergétique.',
    'de': 'JAAS ist ein modernes Wellness-System, das von verschiedenen traditionellen Energieheilmethoden inspiriert ist.',
    'es': 'JAAS es un sistema de bienestar moderno inspirado en varios métodos tradicionales de sanación energética.',
    'ru': 'ЯААС — это современная оздоровительная система, вдохновлённая различными традиционными методами энергетического исцеления.',
    'ar': 'جاس هو نظام صحي حديث مستوحى من طرق الشفاء بالطاقة التقليدية المختلفة.',
    'zh': 'JAAS是一个受各种传统能量疗愈方法启发的现代健康系统。',
    'el': 'Το JAAS είναι ένα σύγχρονο σύστημα ευεξίας εμπνευσμένο από διάφορες παραδοσιακές μεθόδους ενεργειακής θεραπείας.',
    'bg': 'ЯААС е модерна уелнес система, вдъхновена от различни традиционни методи за енергийно изцеление.',
  },
  philosophicalFoundation: {
    'tr': 'JAAS, bireyin enerji alanının fiziksel, duygusal, zihinsel ve ruhsal katmanlardan oluştuğu görüşüne dayanır.',
    'en': 'JAAS is based on the view that an individual\'s energy field consists of physical, emotional, mental, and spiritual layers.',
    'fr': 'JAAS repose sur l\'idée que le champ énergétique d\'un individu est composé de couches physiques, émotionnelles, mentales et spirituelles.',
    'de': 'JAAS basiert auf der Ansicht, dass das Energiefeld eines Individuums aus physischen, emotionalen, mentalen und spirituellen Schichten besteht.',
    'es': 'JAAS se basa en la idea de que el campo energético de un individuo consta de capas físicas, emocionales, mentales y espirituales.',
    'ru': 'ЯААС основан на представлении о том, что энергетическое поле человека состоит из физического, эмоционального, ментального и духовного слоёв.',
    'ar': 'يعتمد جاس على فكرة أن مجال الطاقة للفرد يتكون من طبقات جسدية وعاطفية وعقلية وروحية.',
    'zh': 'JAAS基于个体能量场由物理、情感、心理和精神层组成的观点。',
    'el': 'Το JAAS βασίζεται στην άποψη ότι το ενεργειακό πεδίο ενός ατόμου αποτελείται από φυσικά, συναισθηματικά, νοητικά και πνευματικά στρώματα.',
    'bg': 'ЯААС се основава на разбирането, че енергийното поле на индивида се състои от физически, емоционални, умствени и духовни слоеве.',
  },
  howItWorks: {
    'tr': '''
1. ENERJİ DEĞERLENDİRME
Danışanın enerji alanı taranır.

2. BLOKAJ TESPİTİ
Harmonik olmayan alanlar belirlenir.

3. DENGELEME ÇALIŞMASI
Çeşitli tekniklerle enerji dengelenir.

4. ENTEGRASYON
Seans deneyimi değerlendirilir.
''',
    'en': '''
1. ENERGY ASSESSMENT
The client's energy field is scanned.

2. BLOCKAGE DETECTION
Areas that are not in harmony are identified.

3. BALANCING WORK
Energy is balanced with various techniques.

4. INTEGRATION
The session experience is evaluated.
''',
    'fr': '''1. ÉVALUATION DE L'ÉNERGIE...''',
    'de': '''1. ENERGIEBEWERTUNG...''',
    'es': '''1. EVALUACIÓN DE ENERGÍA...''',
    'ru': '''1. ОЦЕНКА ЭНЕРГИИ...''',
    'ar': '''1. تقييم الطاقة...''',
    'zh': '''1. 能量评估...''',
    'el': '''1. ΑΞΙΟΛΟΓΗΣΗ ΕΝΕΡΓΕΙΑΣ...''',
    'bg': '''1. ОЦЕНКА НА ЕНЕРГИЯТА...''',
  },
  symbolicInterpretation: {
    'tr': 'Enerji alanı, çakralar ve meridyenler gibi geleneksel kavramlarla yorumlanır.',
    'en': 'The energy field is interpreted with traditional concepts like chakras and meridians.',
    'fr': 'Le champ énergétique est interprété avec des concepts traditionnels comme les chakras et les méridiens.',
    'de': 'Das Energiefeld wird mit traditionellen Konzepten wie Chakren und Meridianen interpretiert.',
    'es': 'El campo energético se interpreta con conceptos tradicionales como chakras y meridianos.',
    'ru': 'Энергетическое поле интерпретируется с помощью традиционных концепций, таких как чакры и меридианы.',
    'ar': 'يتم تفسير مجال الطاقة بمفاهيم تقليدية مثل الشاكرات والميريديان.',
    'zh': '能量场用脉轮和经络等传统概念来解释。',
    'el': 'Το ενεργειακό πεδίο ερμηνεύεται με παραδοσιακές έννοιες όπως τα τσάκρα και οι μεσημβρινοί.',
    'bg': 'Енергийното поле се интерпретира с традиционни концепции като чакри и меридиани.',
  },
  insightsProvided: {
    'tr': 'Enerji dengesi farkındalığı, blokaj alanlarının keşfi, dengeleme sonrası iyilik hali.',
    'en': 'Awareness of energy balance, discovery of blockage areas, well-being after balancing.',
    'fr': 'Conscience de l\'équilibre énergétique.',
    'de': 'Bewusstsein für Energiegleichgewicht.',
    'es': 'Conciencia del equilibrio energético.',
    'ru': 'Осознание энергетического баланса.',
    'ar': 'الوعي بتوازن الطاقة.',
    'zh': '能量平衡意识。',
    'el': 'Επίγνωση της ενεργειακής ισορροπίας.',
    'bg': 'Осъзнаване на енергийния баланс.',
  },
  commonMotivations: {
    'tr': ['Enerji dengesizliği hissi', 'Genel yorgunluk', 'Wellness arayışı', 'Bütünsel yaklaşım istemi'],
    'en': ['Feeling of energy imbalance', 'General fatigue', 'Seeking wellness', 'Desire for holistic approach'],
    'fr': ['Sentiment de déséquilibre énergétique'],
    'de': ['Gefühl des Energieungleichgewichts'],
    'es': ['Sensación de desequilibrio energético'],
    'ru': ['Ощущение энергетического дисбаланса'],
    'ar': ['شعور بعدم توازن الطاقة'],
    'zh': ['能量失衡感'],
    'el': ['Αίσθημα ενεργειακής ανισορροπίας'],
    'bg': ['Усещане за енергиен дисбаланс'],
  },
  lifeThemes: {
    'tr': ['Enerji dengesi', 'Wellness', 'Bütünsel sağlık'],
    'en': ['Energy balance', 'Wellness', 'Holistic health'],
    'fr': ['Équilibre énergétique'],
    'de': ['Energiegleichgewicht'],
    'es': ['Equilibrio energético'],
    'ru': ['Энергетический баланс'],
    'ar': ['توازن الطاقة'],
    'zh': ['能量平衡'],
    'el': ['Ενεργειακή ισορροπία'],
    'bg': ['Енергиен баланс'],
  },
  whatYouReceive: {
    'tr': '''
• Bütünsel enerji değerlendirmesi
• Dengeleme çalışması
• Seans sonrası öneriler
''',
    'en': '''
• Holistic energy assessment
• Balancing work
• Post-session recommendations
''',
    'fr': '''• Évaluation énergétique holistique...''',
    'de': '''• Ganzheitliche Energiebewertung...''',
    'es': '''• Evaluación energética holística...''',
    'ru': '''• Целостная оценка энергии...''',
    'ar': '''• تقييم الطاقة الشامل...''',
    'zh': '''• 整体能量评估...''',
    'el': '''• Ολιστική αξιολόγηση ενέργειας...''',
    'bg': '''• Холистична оценка на енергията...''',
  },
  perspectiveGained: {
    'tr': 'Enerji bedeninizi ve dengenizi daha iyi anlayabilirsiniz.',
    'en': 'You can better understand your energy body and balance.',
    'fr': 'Vous pouvez mieux comprendre votre corps énergétique et votre équilibre.',
    'de': 'Sie können Ihren Energiekörper und Ihr Gleichgewicht besser verstehen.',
    'es': 'Puedes entender mejor tu cuerpo energético y equilibrio.',
    'ru': 'Вы можете лучше понять своё энергетическое тело и баланс.',
    'ar': 'يمكنك فهم جسمك الطاقي وتوازنك بشكل أفضل.',
    'zh': '您可以更好地了解您的能量身体和平衡。',
    'el': 'Μπορείτε να κατανοήσετε καλύτερα το ενεργειακό σας σώμα και την ισορροπία σας.',
    'bg': 'Можете да разберете по-добре енергийното си тяло и баланса си.',
  },
  reflectionPoints: {
    'tr': ['Enerji seviyem nasıl?', 'Nerede blokaj hissediyorum?', 'Dengeye ne getirebilirim?'],
    'en': ['How is my energy level?', 'Where do I feel blockage?', 'What can I bring to balance?'],
    'fr': ['Comment est mon niveau d\'énergie?'],
    'de': ['Wie ist mein Energieniveau?'],
    'es': ['¿Cómo está mi nivel de energía?'],
    'ru': ['Каков мой уровень энергии?'],
    'ar': ['كيف مستوى طاقتي؟'],
    'zh': ['我的能量水平如何？'],
    'el': ['Πώς είναι το επίπεδο ενέργειάς μου;'],
    'bg': ['Какво е нивото на енергията ми?'],
  },
  safetyDisclaimer: {
    'tr': '''
⚠️ ÖNEMLİ UYARI

JAAS bir wellness pratiğidir. TIBBİ TEDAVİNİN YERİNE GEÇMEZ. Bilimsel olarak kanıtlanmış değildir.
''',
    'en': '''
⚠️ IMPORTANT NOTICE

JAAS is a wellness practice. It DOES NOT REPLACE MEDICAL TREATMENT. It is not scientifically proven.
''',
    'fr': '''⚠️ AVIS IMPORTANT - JAAS est une pratique de bien-être. IL NE REMPLACE PAS LE TRAITEMENT MÉDICAL...''',
    'de': '''⚠️ WICHTIGER HINWEIS - JAAS ist eine Wellness-Praxis. ES ERSETZT KEINE MEDIZINISCHE BEHANDLUNG...''',
    'es': '''⚠️ AVISO IMPORTANTE - JAAS es una práctica de bienestar. NO REEMPLAZA EL TRATAMIENTO MÉDICO...''',
    'ru': '''⚠️ ВАЖНОЕ УВЕДОМЛЕНИЕ - ЯААС — это оздоровительная практика. ОНА НЕ ЗАМЕНЯЕТ МЕДИЦИНСКОЕ ЛЕЧЕНИЕ...''',
    'ar': '''⚠️ إشعار هام - جاس هو ممارسة صحية. لا يحل محل العلاج الطبي...''',
    'zh': '''⚠️ 重要提示 - JAAS是一种健康练习。它不能替代医疗治疗...''',
    'el': '''⚠️ ΣΗΜΑΝΤΙΚΗ ΕΙΔΟΠΟΙΗΣΗ - Το JAAS είναι μια πρακτική ευεξίας. ΔΕΝ ΑΝΤΙΚΑΘΙΣΤΑ ΤΗΝ ΙΑΤΡΙΚΗ ΘΕΡΑΠΕΙΑ...''',
    'bg': '''⚠️ ВАЖНО СЪОБЩЕНИЕ - ЯААС е практика за уелнес. НЕ ЗАМЕСТВА МЕДИЦИНСКОТО ЛЕЧЕНИЕ...''',
  },
  doesNotDo: {
    'tr': ['Tıbbi tedavi değildir', 'Hastalık tedavi etmez', 'Bilimsel olarak kanıtlanmış değildir'],
    'en': ['Is not medical treatment', 'Does not cure illness', 'Is not scientifically proven'],
    'fr': ['N\'est pas un traitement médical'],
    'de': ['Ist keine medizinische Behandlung'],
    'es': ['No es tratamiento médico'],
    'ru': ['Не является медицинским лечением'],
    'ar': ['ليس علاجاً طبياً'],
    'zh': ['不是医疗治疗'],
    'el': ['Δεν είναι ιατρική θεραπεία'],
    'bg': ['Не е медицинско лечение'],
  },
  exampleScenarios: {
    'tr': ['Kronik yorgunluk hisseden biri, JAAS seansında enerji dengeleme çalışması yaptı ve rahatlama hissetti.'],
    'en': ['Someone feeling chronic fatigue did energy balancing work in a JAAS session and felt relaxed.'],
    'fr': ['Quelqu\'un ressentant une fatigue chronique...'],
    'de': ['Jemand, der chronische Müdigkeit verspürte...'],
    'es': ['Alguien sintiendo fatiga crónica...'],
    'ru': ['Кто-то, чувствующий хроническую усталость...'],
    'ar': ['شخص يشعر بالتعب المزمن...'],
    'zh': ['一个感到慢性疲劳的人...'],
    'el': ['Κάποιος που αισθανόταν χρόνια κόπωση...'],
    'bg': ['Някой, който усещаше хронична умора...'],
  },
  faq: {
    'tr': [
      FAQItem(question: 'JAAS bilimsel mi?', answer: 'JAAS bilimsel olarak kanıtlanmış bir sistem değildir. Wellness pratiği olarak sunulmaktadır.'),
    ],
    'en': [
      FAQItem(question: 'Is JAAS scientific?', answer: 'JAAS is not a scientifically proven system. It is offered as a wellness practice.'),
    ],
    'fr': [FAQItem(question: 'JAAS est-il scientifique?', answer: 'JAAS n\'est pas un système scientifiquement prouvé.')],
    'de': [FAQItem(question: 'Ist JAAS wissenschaftlich?', answer: 'JAAS ist kein wissenschaftlich bewiesenes System.')],
    'es': [FAQItem(question: '¿Es científico JAAS?', answer: 'JAAS no es un sistema científicamente probado.')],
    'ru': [FAQItem(question: 'Является ли ЯААС научным?', answer: 'ЯААС не является научно доказанной системой.')],
    'ar': [FAQItem(question: 'هل جاس علمي؟', answer: 'جاس ليس نظاماً مثبتاً علمياً.')],
    'zh': [FAQItem(question: 'JAAS是科学的吗？', answer: 'JAAS不是一个经过科学证明的系统。')],
    'el': [FAQItem(question: 'Είναι το JAAS επιστημονικό;', answer: 'Το JAAS δεν είναι ένα επιστημονικά αποδεδειγμένο σύστημα.')],
    'bg': [FAQItem(question: 'Научен ли е ЯААС?', answer: 'ЯААС не е научно доказана система.')],
  },
  relatedPractices: {
    'tr': ['Reiki', 'Çakra Dengeleme', 'Enerji Terapisi'],
    'en': ['Reiki', 'Chakra Balancing', 'Energy Therapy'],
    'fr': ['Reiki'],
    'de': ['Reiki'],
    'es': ['Reiki'],
    'ru': ['Рейки'],
    'ar': ['ريكي'],
    'zh': ['灵气'],
    'el': ['Ρέικι'],
    'bg': ['Рейки'],
  },
  differenceFromSimilar: {
    'tr': 'JAAS bütünsel bir değerlendirme sunarken, Reiki spesifik pozisyonlarda çalışır.',
    'en': 'JAAS offers a holistic assessment while Reiki works in specific positions.',
    'fr': 'JAAS offre une évaluation holistique tandis que le Reiki travaille dans des positions spécifiques.',
    'de': 'JAAS bietet eine ganzheitliche Bewertung, während Reiki in bestimmten Positionen arbeitet.',
    'es': 'JAAS ofrece una evaluación holística mientras que Reiki trabaja en posiciones específicas.',
    'ru': 'ЯААС предлагает целостную оценку, тогда как Рейки работает в определённых позициях.',
    'ar': 'يقدم جاس تقييماً شاملاً بينما يعمل الريكي في مواضع محددة.',
    'zh': 'JAAS提供整体评估，而灵气在特定位置工作。',
    'el': 'Το JAAS προσφέρει μια ολιστική αξιολόγηση ενώ το Ρέικι εργάζεται σε συγκεκριμένες θέσεις.',
    'bg': 'ЯААС предлага холистична оценка, докато Рейки работи в определени позиции.',
  },
  microLearning: {
    'tr': ['💡 Enerji alanı biyoenerji olarak da bilinir.'],
    'en': ['💡 The energy field is also known as bioenergy.'],
    'fr': ['💡 Le champ énergétique est également connu sous le nom de bioénergie.'],
    'de': ['💡 Das Energiefeld ist auch als Bioenergie bekannt.'],
    'es': ['💡 El campo energético también se conoce como bioenergía.'],
    'ru': ['💡 Энергетическое поле также известно как биоэнергия.'],
    'ar': ['💡 مجال الطاقة يُعرف أيضًا بالطاقة الحيوية.'],
    'zh': ['💡 能量场也被称为生物能量。'],
    'el': ['💡 Το ενεργειακό πεδίο είναι επίσης γνωστό ως βιοενέργεια.'],
    'bg': ['💡 Енергийното поле е известно също като биоенергия.'],
  },
);

// ═══════════════════════════════════════════════════════════════════════════════
// ASTROLOGY - MONTHLY FORECAST
// ═══════════════════════════════════════════════════════════════════════════════

final astrologyMonthlyForecast = ServiceContent(
  id: 'astrology_monthly_forecast',
  category: ServiceCategory.astrology,
  icon: '📆',
  displayOrder: 3,
  name: {
    'tr': 'Aylık Astroloji Tahmini',
    'en': 'Monthly Astrology Forecast',
    'fr': 'Prévisions Astrologiques Mensuelles',
    'de': 'Monatliche Astrologische Vorhersage',
    'es': 'Pronóstico Astrológico Mensual',
    'ru': 'Ежемесячный Астрологический Прогноз',
    'ar': 'التوقعات الفلكية الشهرية',
    'zh': '月度占星预测',
    'el': 'Μηνιαία Αστρολογική Πρόβλεψη',
    'bg': 'Месечна Астрологична Прогноза',
  },
  shortDescription: {
    'tr': 'Önümüzdeki ay için kişiselleştirilmiş kozmik rehberlik ve günlük enerji akışı.',
    'en': 'Personalized cosmic guidance and daily energy flow for the upcoming month.',
    'fr': 'Guidance cosmique personnalisée pour le mois à venir.',
    'de': 'Personalisierte kosmische Führung für den kommenden Monat.',
    'es': 'Guía cósmica personalizada para el próximo mes.',
    'ru': 'Персонализированное космическое руководство на предстоящий месяц.',
    'ar': 'إرشاد كوني مخصص للشهر القادم.',
    'zh': '未来一个月的个性化宇宙指导。',
    'el': 'Εξατομικευμένη κοσμική καθοδήγηση για τον επόμενο μήνα.',
    'bg': 'Персонализирано космическо ръководство за предстоящия месец.',
  },
  coreExplanation: {
    'tr': 'Aylık astroloji tahmini, doğum haritanızın önümüzdeki 30 gün boyunca aktif olacak transit gezegenlerle etkileşimini analiz eder.',
    'en': 'The monthly astrology forecast analyzes how your birth chart will interact with transit planets active over the next 30 days.',
    'fr': 'Les prévisions mensuelles analysent comment votre thème natal interagira avec les planètes en transit.',
    'de': 'Die monatliche Vorhersage analysiert, wie Ihr Horoskop mit Transitplaneten interagieren wird.',
    'es': 'El pronóstico mensual analiza cómo tu carta natal interactuará con los planetas en tránsito.',
    'ru': 'Ежемесячный прогноз анализирует взаимодействие вашей карты с транзитными планетами.',
    'ar': 'تحلل التوقعات الشهرية تفاعل خريطة ميلادك مع الكواكب العابرة.',
    'zh': '月度预测分析您的出生图与过境行星的互动。',
    'el': 'Η μηνιαία πρόβλεψη αναλύει την αλληλεπίδραση με τους διερχόμενους πλανήτες.',
    'bg': 'Месечната прогноза анализира взаимодействието с транзитните планети.',
  },
  historicalBackground: {'tr': 'Aylık döngüler antik çağlardan beri takip edilmiştir.', 'en': 'Monthly cycles have been tracked since ancient times.', 'fr': 'Les cycles mensuels sont suivis depuis l\'antiquité.', 'de': 'Monatliche Zyklen werden seit der Antike verfolgt.', 'es': 'Los ciclos mensuales se han seguido desde la antigüedad.', 'ru': 'Месячные циклы отслеживаются с древних времён.', 'ar': 'تُتابع الدورات الشهرية منذ العصور القديمة.', 'zh': '自古以来就一直追踪月度周期。', 'el': 'Οι μηνιαίοι κύκλοι παρακολουθούνται από την αρχαιότητα.', 'bg': 'Месечните цикли се проследяват от древни времена.'},
  philosophicalFoundation: {'tr': 'Ay döngüleri yaşamın ritmik doğasını yansıtır.', 'en': 'Lunar cycles reflect the rhythmic nature of life.', 'fr': 'Les cycles lunaires reflètent la nature rythmique de la vie.', 'de': 'Mondzyklen spiegeln die rhythmische Natur des Lebens wider.', 'es': 'Los ciclos lunares reflejan la naturaleza rítmica de la vida.', 'ru': 'Лунные циклы отражают ритмичную природу жизни.', 'ar': 'تعكس دورات القمر الطبيعة الإيقاعية للحياة.', 'zh': '月球周期反映了生命的节奏性。', 'el': 'Οι σεληνιακοί κύκλοι αντικατοπτρίζουν τη ρυθμική φύση της ζωής.', 'bg': 'Лунните цикли отразяват ритмичната природа на живота.'},
  howItWorks: {'tr': '1. Doğum haritanız temel alınır\n2. 30 günlük transit hesaplanır\n3. Günlük ay transitlerinin etkileri belirlenir', 'en': '1. Your birth chart is used as foundation\n2. 30-day transit is calculated\n3. Effects of daily moon transits are determined', 'fr': '1. Votre thème natal sert de base...', 'de': '1. Ihr Geburtshoroskop dient als Grundlage...', 'es': '1. Tu carta natal se usa como base...', 'ru': '1. Ваша натальная карта используется как основа...', 'ar': '1. تُستخدم خريطة ميلادك كأساس...', 'zh': '1. 以您的出生图为基础...', 'el': '1. Ο γενέθλιος χάρτης σας χρησιμοποιείται ως βάση...', 'bg': '1. Вашата рождена карта се използва като основа...'},
  symbolicInterpretation: {'tr': 'Ay transitlerinin günlük etkileri analiz edilir.', 'en': 'Daily effects of moon transits are analyzed.', 'fr': 'Les effets quotidiens des transits lunaires sont analysés.', 'de': 'Die täglichen Auswirkungen der Mondtransite werden analysiert.', 'es': 'Se analizan los efectos diarios de los tránsitos lunares.', 'ru': 'Анализируются ежедневные эффекты лунных транзитов.', 'ar': 'يتم تحليل التأثيرات اليومية لعبور القمر.', 'zh': '分析月球过境的每日影响。', 'el': 'Αναλύονται οι καθημερινές επιδράσεις των διελεύσεων της σελήνης.', 'bg': 'Анализират се ежедневните ефекти на лунните транзити.'},
  insightsProvided: {'tr': 'Günlük enerji akışı, haftalık temalar, önemli tarihler.', 'en': 'Daily energy flow, weekly themes, important dates.', 'fr': 'Flux d\'énergie quotidien, thèmes hebdomadaires.', 'de': 'Täglicher Energiefluss, wöchentliche Themen.', 'es': 'Flujo de energía diario, temas semanales.', 'ru': 'Ежедневный поток энергии, еженедельные темы.', 'ar': 'تدفق الطاقة اليومي، المواضيع الأسبوعية.', 'zh': '每日能量流，每周主题。', 'el': 'Καθημερινή ροή ενέργειας, εβδομαδιαία θέματα.', 'bg': 'Ежедневен енергиен поток, седмични теми.'},
  commonMotivations: {'tr': ['Ay planlaması yapmak', 'Önemli günleri bilmek'], 'en': ['Planning the month', 'Knowing important days'], 'fr': ['Planifier le mois'], 'de': ['Den Monat planen'], 'es': ['Planificar el mes'], 'ru': ['Планирование месяца'], 'ar': ['تخطيط الشهر'], 'zh': ['规划月份'], 'el': ['Σχεδιασμός του μήνα'], 'bg': ['Планиране на месеца']},
  lifeThemes: {'tr': ['Günlük planlama', 'Enerji yönetimi'], 'en': ['Daily planning', 'Energy management'], 'fr': ['Planification quotidienne'], 'de': ['Tägliche Planung'], 'es': ['Planificación diaria'], 'ru': ['Ежедневное планирование'], 'ar': ['التخطيط اليومي'], 'zh': ['每日规划'], 'el': ['Καθημερινός σχεδιασμός'], 'bg': ['Ежедневно планиране']},
  whatYouReceive: {'tr': '• 30 günlük detaylı transit analizi\n• Haftalık tema özetleri\n• Önemli günler listesi', 'en': '• Detailed 30-day transit analysis\n• Weekly theme summaries\n• List of important days', 'fr': '• Analyse des transits sur 30 jours...', 'de': '• 30-tägige Transitanalyse...', 'es': '• Análisis de tránsitos de 30 días...', 'ru': '• Анализ транзитов на 30 дней...', 'ar': '• تحليل العبور لمدة 30 يومًا...', 'zh': '• 30天过境分析...', 'el': '• Ανάλυση διελεύσεων 30 ημερών...', 'bg': '• 30-дневен транзитен анализ...'},
  perspectiveGained: {'tr': 'Ayı bir bütün olarak görerek günlük aktivitelerinizi planlayabilirsiniz.', 'en': 'By seeing the month as a whole, you can plan your daily activities.', 'fr': 'En voyant le mois dans son ensemble, vous pouvez planifier.', 'de': 'Indem Sie den Monat als Ganzes sehen, können Sie planen.', 'es': 'Al ver el mes como un todo, puedes planificar.', 'ru': 'Видя месяц как целое, вы можете планировать.', 'ar': 'من خلال رؤية الشهر ككل، يمكنك التخطيط.', 'zh': '将一个月视为整体，您可以进行规划。', 'el': 'Βλέποντας τον μήνα ως σύνολο, μπορείτε να σχεδιάσετε.', 'bg': 'Виждайки месеца като цяло, можете да планирате.'},
  reflectionPoints: {'tr': ['Bu ay için önceliklerim neler?'], 'en': ['What are my priorities this month?'], 'fr': ['Quelles sont mes priorités ce mois-ci?'], 'de': ['Was sind meine Prioritäten diesen Monat?'], 'es': ['¿Cuáles son mis prioridades este mes?'], 'ru': ['Каковы мои приоритеты в этом месяце?'], 'ar': ['ما هي أولوياتي هذا الشهر؟'], 'zh': ['这个月我的优先事项是什么？'], 'el': ['Ποιες είναι οι προτεραιότητές μου αυτόν τον μήνα;'], 'bg': ['Какви са приоритетите ми този месец?']},
  safetyDisclaimer: {'tr': '⚠️ Aylık tahmin eğlence amaçlıdır. Kesin gelecek tahmini yapmaz.', 'en': '⚠️ Monthly forecast is for entertainment purposes. It does not make definite predictions.', 'fr': '⚠️ Les prévisions mensuelles sont à des fins de divertissement.', 'de': '⚠️ Die monatliche Vorhersage dient der Unterhaltung.', 'es': '⚠️ El pronóstico mensual es con fines de entretenimiento.', 'ru': '⚠️ Ежемесячный прогноз предназначен для развлечения.', 'ar': '⚠️ التوقعات الشهرية هي لأغراض الترفيه.', 'zh': '⚠️ 月度预测仅供娱乐目的。', 'el': '⚠️ Η μηνιαία πρόβλεψη είναι για ψυχαγωγία.', 'bg': '⚠️ Месечната прогноза е за забавление.'},
  doesNotDo: {'tr': ['Kesin tahmin yapmaz'], 'en': ['Does not make definite predictions'], 'fr': ['Ne fait pas de prédictions définitives'], 'de': ['Macht keine definitiven Vorhersagen'], 'es': ['No hace predicciones definitivas'], 'ru': ['Не делает определённых предсказаний'], 'ar': ['لا يقدم تنبؤات قطعية'], 'zh': ['不做确定的预测'], 'el': ['Δεν κάνει οριστικές προβλέψεις'], 'bg': ['Не прави категорични предсказания']},
  exampleScenarios: {'tr': ['Bir danışan önemli görüşmesini olumlu transit dönemine planladı.'], 'en': ['A client planned their important meeting during a positive transit period.'], 'fr': ['Un client a planifié sa réunion importante...'], 'de': ['Ein Klient plante sein wichtiges Treffen...'], 'es': ['Un cliente planificó su reunión importante...'], 'ru': ['Клиент запланировал важную встречу...'], 'ar': ['خطط عميل لاجتماعه المهم...'], 'zh': ['一位客户将重要会议安排在...'], 'el': ['Ένας πελάτης προγραμμάτισε τη σημαντική συνάντησή του...'], 'bg': ['Клиент планира важната си среща...']},
  faq: {'tr': [FAQItem(question: 'Aylık tahmin ne zaman yaptırılmalı?', answer: 'Ayın başında veya önceki ayın sonunda.')], 'en': [FAQItem(question: 'When should I get a monthly forecast?', answer: 'At the beginning of the month or end of the previous month.')], 'fr': [FAQItem(question: 'Quand obtenir une prévision mensuelle?', answer: 'Au début du mois.')], 'de': [FAQItem(question: 'Wann monatliche Vorhersage erhalten?', answer: 'Zu Beginn des Monats.')], 'es': [FAQItem(question: '¿Cuándo obtener pronóstico mensual?', answer: 'Al comienzo del mes.')], 'ru': [FAQItem(question: 'Когда получить ежемесячный прогноз?', answer: 'В начале месяца.')], 'ar': [FAQItem(question: 'متى أحصل على توقعات شهرية?', answer: 'في بداية الشهر.')], 'zh': [FAQItem(question: '什么时候获取月度预测？', answer: '月初。')], 'el': [FAQItem(question: 'Πότε να λάβω μηνιαία πρόβλεψη;', answer: 'Στην αρχή του μήνα.')], 'bg': [FAQItem(question: 'Кога да получа месечна прогноза?', answer: 'В началото на месеца.')]},
  relatedPractices: {'tr': ['Yıllık Tahmin'], 'en': ['Annual Forecast'], 'fr': ['Prévisions Annuelles'], 'de': ['Jahresvorhersage'], 'es': ['Pronóstico Anual'], 'ru': ['Годовой прогноз'], 'ar': ['التوقعات السنوية'], 'zh': ['年度预测'], 'el': ['Ετήσια Πρόβλεψη'], 'bg': ['Годишна Прогноза']},
  differenceFromSimilar: {'tr': 'Aylık tahmin yıllık tahmine göre daha detaylı ve günlük odaklıdır.', 'en': 'Monthly forecast is more detailed and daily-focused than annual forecast.', 'fr': 'La prévision mensuelle est plus détaillée que l\'annuelle.', 'de': 'Die monatliche Vorhersage ist detaillierter als die jährliche.', 'es': 'El pronóstico mensual es más detallado que el anual.', 'ru': 'Ежемесячный прогноз более детальный, чем годовой.', 'ar': 'التوقعات الشهرية أكثر تفصيلاً من السنوية.', 'zh': '月度预测比年度预测更详细。', 'el': 'Η μηνιαία πρόβλεψη είναι πιο λεπτομερής από την ετήσια.', 'bg': 'Месечната прогноза е по-подробна от годишната.'},
  microLearning: {'tr': ['💡 Ay yaklaşık 2.5 günde bir burç değiştirir.'], 'en': ['💡 The moon changes signs approximately every 2.5 days.'], 'fr': ['💡 La lune change de signe tous les 2,5 jours.'], 'de': ['💡 Der Mond wechselt alle 2,5 Tage das Zeichen.'], 'es': ['💡 La luna cambia de signo cada 2,5 días.'], 'ru': ['💡 Луна меняет знак каждые 2,5 дня.'], 'ar': ['💡 يغير القمر برجه كل 2.5 يوم.'], 'zh': ['💡 月亮每2.5天换一个星座。'], 'el': ['💡 Η σελήνη αλλάζει ζώδιο κάθε 2,5 μέρες.'], 'bg': ['💡 Луната сменя знак на всеки 2,5 дни.']},
);

// ═══════════════════════════════════════════════════════════════════════════════
// ASTROLOGY - SYNASTRY (RELATIONSHIP)
// ═══════════════════════════════════════════════════════════════════════════════

final astrologySynastry = ServiceContent(
  id: 'astrology_synastry',
  category: ServiceCategory.astrology,
  icon: '💑',
  displayOrder: 4,
  name: {
    'tr': 'İlişki Astrolojisi (Sinastri)',
    'en': 'Relationship Astrology (Synastry)',
    'fr': 'Astrologie Relationnelle (Synastrie)',
    'de': 'Beziehungsastrologie (Synastrie)',
    'es': 'Astrología de Relaciones (Sinastría)',
    'ru': 'Астрология Отношений (Синастрия)',
    'ar': 'علم فلك العلاقات (السيناستري)',
    'zh': '关系占星术（合盘）',
    'el': 'Αστρολογία Σχέσεων (Συναστρία)',
    'bg': 'Астрология на Отношенията (Синастрия)',
  },
  shortDescription: {
    'tr': 'İki kişinin doğum haritalarını karşılaştırarak ilişki dinamiklerini keşfedin.',
    'en': 'Explore relationship dynamics by comparing birth charts of two people.',
    'fr': 'Explorez les dynamiques relationnelles en comparant les thèmes natals.',
    'de': 'Entdecken Sie Beziehungsdynamiken durch Vergleich der Geburtshoroskope.',
    'es': 'Explora las dinámicas de relación comparando las cartas natales.',
    'ru': 'Исследуйте динамику отношений, сравнивая натальные карты.',
    'ar': 'استكشف ديناميكيات العلاقة من خلال مقارنة خرائط الميلاد.',
    'zh': '通过比较两个人的出生图来探索关系动态。',
    'el': 'Εξερευνήστε τις δυναμικές σχέσεων συγκρίνοντας τους γενέθλιους χάρτες.',
    'bg': 'Изследвайте динамиката на отношенията, сравнявайки рождените карти.',
  },
  coreExplanation: {
    'tr': 'Sinastri, iki kişinin doğum haritalarını üst üste bindirerek ilişki dinamiklerini analiz eder. Gezegen aspektleri ve ev yerleşimleri değerlendirilir.',
    'en': 'Synastry analyzes relationship dynamics by overlaying birth charts of two people. Planetary aspects and house placements are evaluated.',
    'fr': 'La synastrie analyse les dynamiques relationnelles en superposant les thèmes natals.',
    'de': 'Synastrie analysiert Beziehungsdynamiken durch Überlagerung der Geburtshoroskope.',
    'es': 'La sinastría analiza las dinámicas de relación superponiendo las cartas natales.',
    'ru': 'Синастрия анализирует динамику отношений, накладывая натальные карты.',
    'ar': 'تحلل السيناستري ديناميكيات العلاقة من خلال تراكب خرائط الميلاد.',
    'zh': '合盘通过叠加两人的出生图来分析关系动态。',
    'el': 'Η συναστρία αναλύει τις δυναμικές σχέσεων επικαλύπτοντας τους γενέθλιους χάρτες.',
    'bg': 'Синастрията анализира динамиката на отношенията, наслагвайки рождените карти.',
  },
  historicalBackground: {'tr': 'İlişki astrolojisi antik çağlardan beri kullanılmaktadır.', 'en': 'Relationship astrology has been used since ancient times.', 'fr': 'L\'astrologie relationnelle est utilisée depuis l\'antiquité.', 'de': 'Beziehungsastrologie wird seit der Antike verwendet.', 'es': 'La astrología de relaciones se usa desde la antigüedad.', 'ru': 'Астрология отношений используется с древних времён.', 'ar': 'يُستخدم علم فلك العلاقات منذ العصور القديمة.', 'zh': '关系占星术自古以来就被使用。', 'el': 'Η αστρολογία σχέσεων χρησιμοποιείται από την αρχαιότητα.', 'bg': 'Астрологията на отношенията се използва от древни времена.'},
  philosophicalFoundation: {'tr': 'İlişkiler, iki evrenin buluşma noktası olarak görülür.', 'en': 'Relationships are seen as the meeting point of two universes.', 'fr': 'Les relations sont vues comme le point de rencontre de deux univers.', 'de': 'Beziehungen werden als Treffpunkt zweier Universen gesehen.', 'es': 'Las relaciones se ven como el punto de encuentro de dos universos.', 'ru': 'Отношения рассматриваются как точка встречи двух вселенных.', 'ar': 'تُنظر إلى العلاقات كنقطة التقاء كونين.', 'zh': '关系被视为两个宇宙的交汇点。', 'el': 'Οι σχέσεις θεωρούνται το σημείο συνάντησης δύο συμπάντων.', 'bg': 'Отношенията се разглеждат като точка на среща на две вселени.'},
  howItWorks: {'tr': '1. Her iki harita hesaplanır\n2. Haritalar üst üste bindirilir\n3. Aspektler analiz edilir', 'en': '1. Both charts are calculated\n2. Charts are overlaid\n3. Aspects are analyzed', 'fr': '1. Les deux thèmes sont calculés...', 'de': '1. Beide Horoskope werden berechnet...', 'es': '1. Ambas cartas se calculan...', 'ru': '1. Обе карты рассчитываются...', 'ar': '1. تُحسب كلتا الخريطتين...', 'zh': '1. 计算两张星盘...', 'el': '1. Υπολογίζονται και οι δύο χάρτες...', 'bg': '1. Изчисляват се двете карти...'},
  symbolicInterpretation: {'tr': 'Venüs-Mars aspektleri romantik kimyayı, Güneş-Ay aspektleri temel uyumu gösterir.', 'en': 'Venus-Mars aspects show romantic chemistry, Sun-Moon aspects show basic compatibility.', 'fr': 'Les aspects Vénus-Mars montrent la chimie romantique.', 'de': 'Venus-Mars-Aspekte zeigen romantische Chemie.', 'es': 'Los aspectos Venus-Marte muestran química romántica.', 'ru': 'Аспекты Венера-Марс показывают романтическую химию.', 'ar': 'جوانب الزهرة-المريخ تُظهر الكيمياء الرومانسية.', 'zh': '金星-火星相位显示浪漫化学反应。', 'el': 'Οι όψεις Αφροδίτης-Άρη δείχνουν ρομαντική χημεία.', 'bg': 'Аспектите Венера-Марс показват романтична химия.'},
  insightsProvided: {'tr': 'İlişkideki uyum alanları, büyüme fırsatları, potansiyel zorluklar.', 'en': 'Areas of harmony, growth opportunities, potential challenges.', 'fr': 'Zones d\'harmonie, opportunités de croissance.', 'de': 'Harmoniebereiche, Wachstumschancen.', 'es': 'Áreas de armonía, oportunidades de crecimiento.', 'ru': 'Области гармонии, возможности роста.', 'ar': 'مجالات الانسجام، فرص النمو.', 'zh': '和谐领域，成长机会。', 'el': 'Τομείς αρμονίας, ευκαιρίες ανάπτυξης.', 'bg': 'Области на хармония, възможности за растеж.'},
  commonMotivations: {'tr': ['Yeni ilişkiyi anlamak', 'Mevcut ilişkiyi derinleştirmek'], 'en': ['Understanding a new relationship', 'Deepening existing relationship'], 'fr': ['Comprendre une nouvelle relation'], 'de': ['Eine neue Beziehung verstehen'], 'es': ['Entender una nueva relación'], 'ru': ['Понимание новых отношений'], 'ar': ['فهم علاقة جديدة'], 'zh': ['理解新关系'], 'el': ['Κατανόηση μιας νέας σχέσης'], 'bg': ['Разбиране на нова връзка']},
  lifeThemes: {'tr': ['Romantik ilişkiler', 'İş ortaklıkları', 'Aile'], 'en': ['Romantic relationships', 'Business partnerships', 'Family'], 'fr': ['Relations romantiques'], 'de': ['Romantische Beziehungen'], 'es': ['Relaciones románticas'], 'ru': ['Романтические отношения'], 'ar': ['العلاقات العاطفية'], 'zh': ['浪漫关系'], 'el': ['Ρομαντικές σχέσεις'], 'bg': ['Романтични отношения']},
  whatYouReceive: {'tr': '• İki harita karşılaştırması\n• Aspekt analizi\n• Uyum ve zorluk alanları', 'en': '• Two chart comparison\n• Aspect analysis\n• Areas of harmony and challenge', 'fr': '• Comparaison de deux thèmes...', 'de': '• Vergleich zweier Horoskope...', 'es': '• Comparación de dos cartas...', 'ru': '• Сравнение двух карт...', 'ar': '• مقارنة خريطتين...', 'zh': '• 两张星盘比较...', 'el': '• Σύγκριση δύο χαρτών...', 'bg': '• Сравнение на две карти...'},
  perspectiveGained: {'tr': 'İlişkinize kozmik bir bakış açısı kazanırsınız.', 'en': 'You gain a cosmic perspective on your relationship.', 'fr': 'Vous gagnez une perspective cosmique sur votre relation.', 'de': 'Sie gewinnen eine kosmische Perspektive auf Ihre Beziehung.', 'es': 'Ganas una perspectiva cósmica de tu relación.', 'ru': 'Вы получаете космическую перспективу на ваши отношения.', 'ar': 'تكتسب منظوراً كونياً لعلاقتك.', 'zh': '您获得对关系的宇宙视角。', 'el': 'Αποκτάτε μια κοσμική προοπτική για τη σχέση σας.', 'bg': 'Придобивате космическа перспектива за връзката си.'},
  reflectionPoints: {'tr': ['İlişkide güçlü yönlerimiz neler?'], 'en': ['What are our strengths in the relationship?'], 'fr': ['Quelles sont nos forces dans la relation?'], 'de': ['Was sind unsere Stärken in der Beziehung?'], 'es': ['¿Cuáles son nuestras fortalezas?'], 'ru': ['Каковы наши сильные стороны?'], 'ar': ['ما هي نقاط قوتنا؟'], 'zh': ['我们的优势是什么？'], 'el': ['Ποια είναι τα δυνατά μας σημεία;'], 'bg': ['Какви са силните ни страни?']},
  safetyDisclaimer: {'tr': '⚠️ Sinastri eğlence amaçlıdır. İlişki kararlarınızı sadece astrolojiye dayandırmayın.', 'en': '⚠️ Synastry is for entertainment purposes. Do not base relationship decisions solely on astrology.', 'fr': '⚠️ La synastrie est à des fins de divertissement.', 'de': '⚠️ Synastrie dient der Unterhaltung.', 'es': '⚠️ La sinastría es con fines de entretenimiento.', 'ru': '⚠️ Синастрия предназначена для развлечения.', 'ar': '⚠️ السيناستري هي لأغراض الترفيه.', 'zh': '⚠️ 合盘仅供娱乐目的。', 'el': '⚠️ Η συναστρία είναι για ψυχαγωγία.', 'bg': '⚠️ Синастрията е за забавление.'},
  doesNotDo: {'tr': ['İlişkinin başarılı olup olmayacağını söylemez'], 'en': ['Does not say if relationship will succeed'], 'fr': ['Ne dit pas si la relation réussira'], 'de': ['Sagt nicht, ob die Beziehung erfolgreich sein wird'], 'es': ['No dice si la relación tendrá éxito'], 'ru': ['Не говорит, будут ли отношения успешными'], 'ar': ['لا يقول إذا كانت العلاقة ستنجح'], 'zh': ['不会说关系是否会成功'], 'el': ['Δεν λέει αν η σχέση θα πετύχει'], 'bg': ['Не казва дали връзката ще успее']},
  exampleScenarios: {'tr': ['Bir çift sinastri ile iletişim zorluklarının kaynağını anladı.'], 'en': ['A couple understood the source of communication difficulties through synastry.'], 'fr': ['Un couple a compris les difficultés de communication...'], 'de': ['Ein Paar verstand die Kommunikationsschwierigkeiten...'], 'es': ['Una pareja entendió las dificultades de comunicación...'], 'ru': ['Пара поняла трудности в общении...'], 'ar': ['فهم زوجان صعوبات التواصل...'], 'zh': ['一对夫妇理解了沟通困难...'], 'el': ['Ένα ζευγάρι κατάλαβε τις δυσκολίες επικοινωνίας...'], 'bg': ['Двойка разбра комуникационните затруднения...']},
  faq: {'tr': [FAQItem(question: 'Partnerimin doğum saatini bilmiyorsam?', answer: 'Tam analiz için önemli, ama temel aspektler yine de incelenebilir.')], 'en': [FAQItem(question: 'What if I don\'t know my partner\'s birth time?', answer: 'Important for full analysis, but basic aspects can still be examined.')], 'fr': [FAQItem(question: 'Et si je ne connais pas l\'heure de mon partenaire?', answer: 'Important pour l\'analyse complète.')], 'de': [FAQItem(question: 'Was wenn ich die Geburtszeit nicht kenne?', answer: 'Wichtig für vollständige Analyse.')], 'es': [FAQItem(question: '¿Qué si no sé la hora de nacimiento?', answer: 'Importante para análisis completo.')], 'ru': [FAQItem(question: 'Что если не знаю время рождения партнёра?', answer: 'Важно для полного анализа.')], 'ar': [FAQItem(question: 'ماذا لو لم أعرف وقت ميلاد شريكي?', answer: 'مهم للتحليل الكامل.')], 'zh': [FAQItem(question: '如果不知道伴侣的出生时间？', answer: '对完整分析很重要。')], 'el': [FAQItem(question: 'Αν δεν ξέρω την ώρα γέννησης;', answer: 'Σημαντικό για πλήρη ανάλυση.')], 'bg': [FAQItem(question: 'Ако не знам часа на раждане?', answer: 'Важно за пълен анализ.')]},
  relatedPractices: {'tr': ['Composite Harita'], 'en': ['Composite Chart'], 'fr': ['Thème Composite'], 'de': ['Composite-Horoskop'], 'es': ['Carta Compuesta'], 'ru': ['Композитная карта'], 'ar': ['الخريطة المركبة'], 'zh': ['组合盘'], 'el': ['Σύνθετος Χάρτης'], 'bg': ['Композитна Карта']},
  differenceFromSimilar: {'tr': 'Sinastri iki haritayı üst üste bindirir. Composite harita matematiksel ortalamadır.', 'en': 'Synastry overlays two charts. Composite chart is mathematical average.', 'fr': 'La synastrie superpose deux thèmes. Le composite est une moyenne.', 'de': 'Synastrie überlagert zwei Horoskope. Composite ist Durchschnitt.', 'es': 'La sinastría superpone dos cartas. Compuesta es promedio.', 'ru': 'Синастрия накладывает две карты. Композит — среднее.', 'ar': 'تراكب السيناستري خريطتين. المركبة هي المتوسط.', 'zh': '合盘叠加两张星盘。组合盘是平均值。', 'el': 'Η συναστρία επικαλύπτει δύο χάρτες. Το σύνθετο είναι μέσος.', 'bg': 'Синастрията наслагва две карти. Композитът е средна стойност.'},
  microLearning: {'tr': ['💡 Venüs-Mars aspektleri romantik kimyayı gösterir.'], 'en': ['💡 Venus-Mars aspects indicate romantic chemistry.'], 'fr': ['💡 Les aspects Vénus-Mars indiquent la chimie romantique.'], 'de': ['💡 Venus-Mars-Aspekte zeigen romantische Chemie.'], 'es': ['💡 Los aspectos Venus-Marte indican química romántica.'], 'ru': ['💡 Аспекты Венера-Марс указывают на романтическую химию.'], 'ar': ['💡 جوانب الزهرة-المريخ تشير إلى الكيمياء الرومانسية.'], 'zh': ['💡 金星-火星相位表示浪漫化学反应。'], 'el': ['💡 Οι όψεις Αφροδίτης-Άρη δείχνουν ρομαντική χημεία.'], 'bg': ['💡 Аспектите Венера-Марс показват романтична химия.']},
);

// ═══════════════════════════════════════════════════════════════════════════════
// ASTROLOGY - SOLAR RETURN
// ═══════════════════════════════════════════════════════════════════════════════

final astrologySolarReturn = ServiceContent(
  id: 'astrology_solar_return',
  category: ServiceCategory.astrology,
  icon: '☀️',
  displayOrder: 5,
  name: {
    'tr': 'Solar Return (Güneş Dönüşü)',
    'en': 'Solar Return',
    'fr': 'Retour Solaire',
    'de': 'Solar Return',
    'es': 'Retorno Solar',
    'ru': 'Солярный Возврат',
    'ar': 'العودة الشمسية',
    'zh': '太阳回归',
    'el': 'Ηλιακή Επιστροφή',
    'bg': 'Соларен Завръщане',
  },
  shortDescription: {
    'tr': 'Doğum gününüzdeki güneş konumunu analiz ederek yeni yaşınızın temalarını keşfedin.',
    'en': 'Discover themes of your new year by analyzing the sun position on your birthday.',
    'fr': 'Découvrez les thèmes de votre nouvelle année en analysant la position du soleil.',
    'de': 'Entdecken Sie Themen Ihres neuen Jahres durch Analyse der Sonnenposition.',
    'es': 'Descubre los temas de tu nuevo año analizando la posición del sol.',
    'ru': 'Откройте темы нового года, анализируя положение солнца.',
    'ar': 'اكتشف موضوعات عامك الجديد من خلال تحليل موقع الشمس.',
    'zh': '通过分析生日时的太阳位置来发现新一年的主题。',
    'el': 'Ανακαλύψτε τα θέματα του νέου σας έτους αναλύοντας τη θέση του ήλιου.',
    'bg': 'Открийте темите на новата си година, анализирайки позицията на слънцето.',
  },
  coreExplanation: {
    'tr': 'Solar Return, güneşin doğum haritanızdaki orijinal pozisyonuna geri döndüğü anı temsil eder. Bu yıllık harita kişisel yılınızın enerjisini yansıtır.',
    'en': 'Solar Return represents the moment when the sun returns to its original position in your birth chart. This yearly chart reflects your personal year\'s energy.',
    'fr': 'Le Retour Solaire représente le moment où le soleil revient à sa position originale.',
    'de': 'Solar Return repräsentiert den Moment, in dem die Sonne zu ihrer ursprünglichen Position zurückkehrt.',
    'es': 'El Retorno Solar representa el momento en que el sol regresa a su posición original.',
    'ru': 'Солярный возврат представляет момент возвращения солнца в исходную позицию.',
    'ar': 'تمثل العودة الشمسية لحظة عودة الشمس إلى موقعها الأصلي.',
    'zh': '太阳回归代表太阳回到出生图中原始位置的时刻。',
    'el': 'Η Ηλιακή Επιστροφή αντιπροσωπεύει τη στιγμή που ο ήλιος επιστρέφει στην αρχική του θέση.',
    'bg': 'Соларното Завръщане представлява моментът на връщане на слънцето в оригиналната позиция.',
  },
  historicalBackground: {'tr': 'Solar Return tekniği Orta Çağ\'dan beri kullanılmaktadır.', 'en': 'The Solar Return technique has been used since the Middle Ages.', 'fr': 'La technique du Retour Solaire est utilisée depuis le Moyen Âge.', 'de': 'Die Solar Return-Technik wird seit dem Mittelalter verwendet.', 'es': 'La técnica del Retorno Solar se usa desde la Edad Media.', 'ru': 'Техника Солярного возврата используется со Средних веков.', 'ar': 'تُستخدم تقنية العودة الشمسية منذ العصور الوسطى.', 'zh': '太阳回归技术自中世纪以来就一直在使用。', 'el': 'Η τεχνική χρησιμοποιείται από τον Μεσαίωνα.', 'bg': 'Техниката се използва от Средновековието.'},
  philosophicalFoundation: {'tr': 'Her yıl güneşin doğum pozisyonuna dönüşü yeni bir yaşam döngüsünün başlangıcını simgeler.', 'en': 'Each year the sun\'s return to birth position symbolizes the beginning of a new life cycle.', 'fr': 'Chaque année, le retour du soleil symbolise le début d\'un nouveau cycle.', 'de': 'Jedes Jahr symbolisiert die Rückkehr der Sonne den Beginn eines neuen Zyklus.', 'es': 'Cada año, el regreso del sol simboliza el comienzo de un nuevo ciclo.', 'ru': 'Ежегодное возвращение солнца символизирует начало нового цикла.', 'ar': 'كل عام تعود الشمس ترمز إلى بداية دورة جديدة.', 'zh': '每年太阳回归象征着新生命周期的开始。', 'el': 'Κάθε χρόνο η επιστροφή του ήλιου συμβολίζει νέο κύκλο.', 'bg': 'Всяка година връщането на слънцето символизира нов цикъл.'},
  howItWorks: {'tr': '1. Güneşin dönüş zamanı hesaplanır\n2. O an için harita çıkarılır\n3. Güneşin ev pozisyonu belirlenir', 'en': '1. Sun\'s return time is calculated\n2. A chart for that moment is drawn\n3. Sun\'s house position is determined', 'fr': '1. Le moment du retour du soleil est calculé...', 'de': '1. Der Zeitpunkt der Sonnenrückkehr wird berechnet...', 'es': '1. Se calcula el momento del retorno del sol...', 'ru': '1. Рассчитывается время возврата солнца...', 'ar': '1. يُحسب وقت عودة الشمس...', 'zh': '1. 计算太阳回归的时间...', 'el': '1. Υπολογίζεται η ώρα επιστροφής του ήλιου...', 'bg': '1. Изчислява се времето на завръщане на слънцето...'},
  symbolicInterpretation: {'tr': 'Güneşin ev pozisyonu yılın ana temasını gösterir.', 'en': 'The house position of the sun shows the main theme of the year.', 'fr': 'La position du soleil en maison montre le thème principal.', 'de': 'Die Hausposition der Sonne zeigt das Hauptthema.', 'es': 'La posición del sol muestra el tema principal.', 'ru': 'Позиция солнца в доме показывает главную тему.', 'ar': 'موقع الشمس في البيت يُظهر الموضوع الرئيسي.', 'zh': '太阳的宫位显示一年的主要主题。', 'el': 'Η θέση του ήλιου δείχνει το κύριο θέμα.', 'bg': 'Позицията на слънцето показва основната тема.'},
  insightsProvided: {'tr': 'Yılın ana temaları, odak alanları, enerji akışı.', 'en': 'Main themes of the year, focus areas, energy flow.', 'fr': 'Thèmes principaux de l\'année.', 'de': 'Hauptthemen des Jahres.', 'es': 'Temas principales del año.', 'ru': 'Основные темы года.', 'ar': 'المواضيع الرئيسية للسنة.', 'zh': '一年的主要主题。', 'el': 'Κύρια θέματα του έτους.', 'bg': 'Основни теми на годината.'},
  commonMotivations: {'tr': ['Yeni yaşımda neler beklediğimi öğrenmek'], 'en': ['Learning what to expect in my new year'], 'fr': ['Apprendre à quoi m\'attendre'], 'de': ['Lernen, was mich erwartet'], 'es': ['Aprender qué esperar'], 'ru': ['Узнать, чего ожидать'], 'ar': ['معرفة ما يمكن توقعه'], 'zh': ['了解会有什么期待'], 'el': ['Μαθαίνοντας τι να περιμένω'], 'bg': ['Да науча какво да очаквам']},
  lifeThemes: {'tr': ['Yıllık temalar', 'Kariyer', 'İlişkiler'], 'en': ['Yearly themes', 'Career', 'Relationships'], 'fr': ['Thèmes annuels'], 'de': ['Jährliche Themen'], 'es': ['Temas anuales'], 'ru': ['Годовые темы'], 'ar': ['مواضيع سنوية'], 'zh': ['年度主题'], 'el': ['Ετήσια θέματα'], 'bg': ['Годишни теми']},
  whatYouReceive: {'tr': '• Solar Return haritası analizi\n• Yılın ana temaları\n• Ev pozisyonu yorumu', 'en': '• Solar Return chart analysis\n• Main themes of the year\n• House position interpretation', 'fr': '• Analyse du thème de Retour Solaire...', 'de': '• Analyse des Solar Return Horoskops...', 'es': '• Análisis de la carta de Retorno Solar...', 'ru': '• Анализ карты Солярного возврата...', 'ar': '• تحليل خريطة العودة الشمسية...', 'zh': '• 太阳回归盘分析...', 'el': '• Ανάλυση χάρτη Ηλιακής Επιστροφής...', 'bg': '• Анализ на карта на Соларно Завръщане...'},
  perspectiveGained: {'tr': 'Yeni yaşınızın enerjisini anlayarak bilinçli seçimler yapabilirsiniz.', 'en': 'By understanding your new year\'s energy, you can make conscious choices.', 'fr': 'En comprenant l\'énergie de votre nouvelle année, vous pouvez faire des choix conscients.', 'de': 'Indem Sie die Energie Ihres neuen Jahres verstehen, können Sie bewusste Entscheidungen treffen.', 'es': 'Al entender la energía de tu nuevo año, puedes hacer elecciones conscientes.', 'ru': 'Понимая энергию нового года, вы можете делать осознанный выбор.', 'ar': 'من خلال فهم طاقة عامك الجديد، يمكنك اتخاذ خيارات واعية.', 'zh': '通过了解新一年的能量，您可以做出有意识的选择。', 'el': 'Κατανοώντας την ενέργεια του νέου έτους, μπορείτε να κάνετε συνειδητές επιλογές.', 'bg': 'Като разбирате енергията на новата година, можете да правите съзнателни избори.'},
  reflectionPoints: {'tr': ['Bu yıl hangi alanlara odaklanmak istiyorum?'], 'en': ['What areas do I want to focus on this year?'], 'fr': ['Sur quels domaines veux-je me concentrer?'], 'de': ['Auf welche Bereiche möchte ich mich konzentrieren?'], 'es': ['¿En qué áreas quiero enfocarme?'], 'ru': ['На каких областях я хочу сосредоточиться?'], 'ar': ['ما المجالات التي أريد التركيز عليها؟'], 'zh': ['今年我想关注哪些领域？'], 'el': ['Σε ποιους τομείς θέλω να επικεντρωθώ;'], 'bg': ['В кои области искам да се съсредоточа?']},
  safetyDisclaimer: {'tr': '⚠️ Solar Return eğlence amaçlıdır. Kesin olayları tahmin etmez.', 'en': '⚠️ Solar Return is for entertainment purposes. It does not predict exact events.', 'fr': '⚠️ Le Retour Solaire est à des fins de divertissement.', 'de': '⚠️ Solar Return dient der Unterhaltung.', 'es': '⚠️ El Retorno Solar es con fines de entretenimiento.', 'ru': '⚠️ Солярный возврат предназначен для развлечения.', 'ar': '⚠️ العودة الشمسية هي لأغراض الترفيه.', 'zh': '⚠️ 太阳回归仅供娱乐目的。', 'el': '⚠️ Η Ηλιακή Επιστροφή είναι για ψυχαγωγία.', 'bg': '⚠️ Соларното Завръщане е за забавление.'},
  doesNotDo: {'tr': ['Kesin olayları tahmin etmez'], 'en': ['Does not predict exact events'], 'fr': ['Ne prédit pas des événements exacts'], 'de': ['Sagt keine genauen Ereignisse voraus'], 'es': ['No predice eventos exactos'], 'ru': ['Не предсказывает точные события'], 'ar': ['لا يتنبأ بأحداث دقيقة'], 'zh': ['不预测确切事件'], 'el': ['Δεν προβλέπει ακριβή γεγονότα'], 'bg': ['Не предсказва точни събития']},
  exampleScenarios: {'tr': ['Bir danışan güneşin 10. evde olduğunu öğrenerek kariyer fırsatlarına odaklandı.'], 'en': ['A client learned the sun was in 10th house and focused on career opportunities.'], 'fr': ['Un client a appris que le soleil était dans la 10ème maison...'], 'de': ['Ein Klient erfuhr, dass die Sonne im 10. Haus war...'], 'es': ['Un cliente aprendió que el sol estaba en la casa 10...'], 'ru': ['Клиент узнал, что солнце было в 10-м доме...'], 'ar': ['علم عميل أن الشمس كانت في البيت العاشر...'], 'zh': ['一位客户了解到太阳在第10宫...'], 'el': ['Ένας πελάτης έμαθε ότι ο ήλιος ήταν στον 10ο οίκο...'], 'bg': ['Клиент научи, че слънцето е в 10-ия дом...']},
  faq: {'tr': [FAQItem(question: 'Solar Return ne zaman yapılmalı?', answer: 'Doğum gününüzden önce veya hemen sonra.')], 'en': [FAQItem(question: 'When should Solar Return be done?', answer: 'Before or right after your birthday.')], 'fr': [FAQItem(question: 'Quand faire le Retour Solaire?', answer: 'Avant ou juste après votre anniversaire.')], 'de': [FAQItem(question: 'Wann Solar Return machen?', answer: 'Vor oder direkt nach Ihrem Geburtstag.')], 'es': [FAQItem(question: '¿Cuándo hacer el Retorno Solar?', answer: 'Antes o justo después de tu cumpleaños.')], 'ru': [FAQItem(question: 'Когда делать Солярный возврат?', answer: 'До или сразу после дня рождения.')], 'ar': [FAQItem(question: 'متى إجراء العودة الشمسية?', answer: 'قبل أو بعد عيد ميلادك مباشرة.')], 'zh': [FAQItem(question: '什么时候做太阳回归？', answer: '生日之前或之后。')], 'el': [FAQItem(question: 'Πότε να γίνει η Ηλιακή Επιστροφή;', answer: 'Πριν ή αμέσως μετά τα γενέθλιά σας.')], 'bg': [FAQItem(question: 'Кога да се направи Соларното Завръщане?', answer: 'Преди или след рождения ден.')]},
  relatedPractices: {'tr': ['Yıllık Tahmin'], 'en': ['Annual Forecast'], 'fr': ['Prévisions Annuelles'], 'de': ['Jahresvorhersage'], 'es': ['Pronóstico Anual'], 'ru': ['Годовой прогноз'], 'ar': ['التوقعات السنوية'], 'zh': ['年度预测'], 'el': ['Ετήσια Πρόβλεψη'], 'bg': ['Годишна Прогноза']},
  differenceFromSimilar: {'tr': 'Solar Return yıllık bir haritadır, yıllık tahmin transit analizidir.', 'en': 'Solar Return is a yearly chart, annual forecast is transit analysis.', 'fr': 'Le Retour Solaire est un thème annuel.', 'de': 'Solar Return ist ein jährliches Horoskop.', 'es': 'El Retorno Solar es una carta anual.', 'ru': 'Солярный возврат — годовая карта.', 'ar': 'العودة الشمسية هي خريطة سنوية.', 'zh': '太阳回归是年度星盘。', 'el': 'Η Ηλιακή Επιστροφή είναι ετήσιος χάρτης.', 'bg': 'Соларното Завръщане е годишна карта.'},
  microLearning: {'tr': ['💡 Güneş her yıl doğum pozisyonunuza geri döner.'], 'en': ['💡 The sun returns to your birth position every year.'], 'fr': ['💡 Le soleil revient à votre position de naissance chaque année.'], 'de': ['💡 Die Sonne kehrt jedes Jahr zu Ihrer Geburtsposition zurück.'], 'es': ['💡 El sol regresa a tu posición de nacimiento cada año.'], 'ru': ['💡 Солнце возвращается в вашу позицию каждый год.'], 'ar': ['💡 تعود الشمس إلى موقع ميلادك كل عام.'], 'zh': ['💡 太阳每年都会回到你出生时的位置。'], 'el': ['💡 Ο ήλιος επιστρέφει στη θέση γέννησής σας κάθε χρόνο.'], 'bg': ['💡 Слънцето се връща в позицията на раждането всяка година.']},
);

// ═══════════════════════════════════════════════════════════════════════════════
// TAROT - 3 QUESTIONS SPREAD
// ═══════════════════════════════════════════════════════════════════════════════

final tarot3Questions = ServiceContent(
  id: 'tarot_3_questions',
  category: ServiceCategory.tarot,
  icon: '🃏',
  displayOrder: 7,
  name: {
    'tr': 'Tarot 3 Soru Açılımı',
    'en': 'Tarot 3 Questions Spread',
    'fr': 'Tirage Tarot 3 Questions',
    'de': 'Tarot 3 Fragen Legung',
    'es': 'Tirada Tarot 3 Preguntas',
    'ru': 'Таро 3 Вопроса',
    'ar': 'تاروت 3 أسئلة',
    'zh': '塔罗三问牌阵',
    'el': 'Ταρώ 3 Ερωτήσεις',
    'bg': 'Таро 3 Въпроса',
  },
  shortDescription: {
    'tr': 'Üç farklı konuda özel tarot açılımı ile içgörü kazanın.',
    'en': 'Gain insight on three different topics with a specialized tarot spread.',
    'fr': 'Obtenez des aperçus sur trois sujets différents.',
    'de': 'Gewinnen Sie Einblick in drei verschiedene Themen.',
    'es': 'Obtén perspectiva sobre tres temas diferentes.',
    'ru': 'Получите понимание по трём разным темам.',
    'ar': 'احصل على رؤية في ثلاثة مواضيع مختلفة.',
    'zh': '在三个不同主题上获得洞察。',
    'el': 'Αποκτήστε εικόνα σε τρία διαφορετικά θέματα.',
    'bg': 'Получете прозрение по три различни теми.',
  },
  coreExplanation: {
    'tr': '3 Soru Açılımı, hayatınızdaki üç farklı alanı veya soruyu ayrı ayrı ele alır. Her soru için özel bir kart dizilimi yapılır ve derinlemesine yorumlanır. Bu format, birden fazla konuda rehberlik arayanlar için idealdir.',
    'en': 'The 3 Questions Spread addresses three different areas or questions in your life separately. A specialized card layout is created for each question and interpreted in depth. This format is ideal for those seeking guidance on multiple topics.',
    'fr': 'Le tirage 3 Questions aborde trois domaines différents de votre vie séparément.',
    'de': 'Die 3-Fragen-Legung behandelt drei verschiedene Bereiche Ihres Lebens separat.',
    'es': 'La tirada de 3 Preguntas aborda tres áreas diferentes de tu vida por separado.',
    'ru': 'Расклад на 3 вопроса отдельно рассматривает три разные области вашей жизни.',
    'ar': 'يتناول انتشار 3 أسئلة ثلاثة مجالات مختلفة في حياتك بشكل منفصل.',
    'zh': '三问牌阵分别处理您生活中的三个不同领域或问题。',
    'el': 'Το άπλωμα 3 Ερωτήσεων εξετάζει ξεχωριστά τρεις διαφορετικές περιοχές.',
    'bg': 'Разстилката на 3 Въпроса разглежда три различни области от живота ви поотделно.',
  },
  historicalBackground: {'tr': 'Çoklu soru açılımları modern tarot pratiğinde popülerleşmiştir.', 'en': 'Multiple question spreads became popular in modern tarot practice.', 'fr': 'Les tirages à questions multiples sont devenus populaires dans la pratique moderne.', 'de': 'Mehrfachfragen-Legungen wurden in der modernen Praxis populär.', 'es': 'Las tiradas de preguntas múltiples se popularizaron en la práctica moderna.', 'ru': 'Расклады на несколько вопросов стали популярны в современной практике.', 'ar': 'أصبحت فروق الأسئلة المتعددة شائعة في الممارسة الحديثة.', 'zh': '多问牌阵在现代塔罗实践中变得流行。', 'el': 'Τα απλώματα πολλαπλών ερωτήσεων έγιναν δημοφιλή στη σύγχρονη πρακτική.', 'bg': 'Разстилките с множество въпроси станаха популярни в съвременната практика.'},
  philosophicalFoundation: {'tr': 'Yaşam çok boyutludur; farklı alanlar farklı rehberlik gerektirir.', 'en': 'Life is multidimensional; different areas require different guidance.', 'fr': 'La vie est multidimensionnelle; différents domaines nécessitent différentes orientations.', 'de': 'Das Leben ist mehrdimensional; verschiedene Bereiche erfordern verschiedene Führung.', 'es': 'La vida es multidimensional; diferentes áreas requieren diferente orientación.', 'ru': 'Жизнь многомерна; разные области требуют разного руководства.', 'ar': 'الحياة متعددة الأبعاد؛ تتطلب مجالات مختلفة توجيهات مختلفة.', 'zh': '生活是多维的；不同领域需要不同的指导。', 'el': 'Η ζωή είναι πολυδιάστατη· διαφορετικοί τομείς χρειάζονται διαφορετική καθοδήγηση.', 'bg': 'Животът е многоизмерен; различни области изискват различно ръководство.'},
  howItWorks: {'tr': '1. Üç sorunuzu belirleyin\n2. Her soru için kart çekilir\n3. Her açılım ayrı ayrı yorumlanır\n4. Bağlantılar ve temalar belirlenir', 'en': '1. Determine your three questions\n2. Cards are drawn for each question\n3. Each spread is interpreted separately\n4. Connections and themes are identified', 'fr': '1. Déterminez vos trois questions...', 'de': '1. Bestimmen Sie Ihre drei Fragen...', 'es': '1. Determina tus tres preguntas...', 'ru': '1. Определите ваши три вопроса...', 'ar': '1. حدد أسئلتك الثلاثة...', 'zh': '1. 确定您的三个问题...', 'el': '1. Καθορίστε τις τρεις ερωτήσεις σας...', 'bg': '1. Определете трите си въпроса...'},
  symbolicInterpretation: {'tr': 'Her soru için çekilen kartlar o alana özgü mesajlar taşır.', 'en': 'Cards drawn for each question carry messages specific to that area.', 'fr': 'Les cartes tirées pour chaque question portent des messages spécifiques.', 'de': 'Die für jede Frage gezogenen Karten tragen spezifische Botschaften.', 'es': 'Las cartas sacadas para cada pregunta llevan mensajes específicos.', 'ru': 'Карты для каждого вопроса несут специфические послания.', 'ar': 'تحمل البطاقات المسحوبة لكل سؤال رسائل محددة.', 'zh': '为每个问题抽取的牌承载特定于该领域的信息。', 'el': 'Οι κάρτες που τραβήχτηκαν για κάθε ερώτηση φέρουν συγκεκριμένα μηνύματα.', 'bg': 'Картите, изтеглени за всеки въпрос, носят специфични послания.'},
  insightsProvided: {'tr': 'Üç farklı yaşam alanına dair derinlemesine perspektif.', 'en': 'In-depth perspective on three different life areas.', 'fr': 'Perspective approfondie sur trois domaines de vie différents.', 'de': 'Tiefgehende Perspektive auf drei verschiedene Lebensbereiche.', 'es': 'Perspectiva profunda sobre tres áreas de vida diferentes.', 'ru': 'Глубокая перспектива на три разные области жизни.', 'ar': 'منظور متعمق على ثلاثة مجالات حياتية مختلفة.', 'zh': '对三个不同生活领域的深入视角。', 'el': 'Εις βάθος προοπτική σε τρεις διαφορετικούς τομείς ζωής.', 'bg': 'Задълбочена перспектива върху три различни области от живота.'},
  commonMotivations: {'tr': ['Birden fazla konuda rehberlik', 'Kapsamlı yaşam görünümü', 'Karar verme desteği'], 'en': ['Guidance on multiple topics', 'Comprehensive life overview', 'Decision-making support'], 'fr': ['Orientation sur plusieurs sujets'], 'de': ['Führung zu mehreren Themen'], 'es': ['Orientación sobre múltiples temas'], 'ru': ['Руководство по нескольким темам'], 'ar': ['إرشادات حول مواضيع متعددة'], 'zh': ['多个主题的指导'], 'el': ['Καθοδήγηση σε πολλαπλά θέματα'], 'bg': ['Ръководство по множество теми']},
  lifeThemes: {'tr': ['Kariyer', 'Aşk', 'Sağlık', 'Para', 'Aile'], 'en': ['Career', 'Love', 'Health', 'Money', 'Family'], 'fr': ['Carrière', 'Amour', 'Santé'], 'de': ['Karriere', 'Liebe', 'Gesundheit'], 'es': ['Carrera', 'Amor', 'Salud'], 'ru': ['Карьера', 'Любовь', 'Здоровье'], 'ar': ['مهنة', 'حب', 'صحة'], 'zh': ['事业', '爱情', '健康'], 'el': ['Καριέρα', 'Αγάπη', 'Υγεία'], 'bg': ['Кариера', 'Любов', 'Здраве']},
  whatYouReceive: {'tr': '• Üç ayrı kart açılımı\n• Her soru için detaylı yorum\n• Temalar arası bağlantılar\n• Genel değerlendirme', 'en': '• Three separate card spreads\n• Detailed interpretation for each question\n• Cross-theme connections\n• Overall assessment', 'fr': '• Trois tirages séparés...', 'de': '• Drei separate Kartenlegungen...', 'es': '• Tres tiradas separadas...', 'ru': '• Три отдельных расклада...', 'ar': '• ثلاث فروق منفصلة...', 'zh': '• 三个独立的牌阵...', 'el': '• Τρία ξεχωριστά απλώματα...', 'bg': '• Три отделни разстилки...'},
  perspectiveGained: {'tr': 'Hayatınızın farklı alanlarına bütüncül bir bakış açısı kazanırsınız.', 'en': 'You gain a holistic perspective on different areas of your life.', 'fr': 'Vous gagnez une perspective holistique sur différents domaines.', 'de': 'Sie gewinnen eine ganzheitliche Perspektive auf verschiedene Bereiche.', 'es': 'Ganas una perspectiva holística sobre diferentes áreas.', 'ru': 'Вы получаете целостную перспективу на разные области.', 'ar': 'تكتسب منظوراً شاملاً لمجالات مختلفة.', 'zh': '您获得对生活不同领域的整体视角。', 'el': 'Αποκτάτε μια ολιστική προοπτική σε διαφορετικούς τομείς.', 'bg': 'Придобивате холистична перспектива върху различни области.'},
  reflectionPoints: {'tr': ['Hangi üç alan şu an en önemli?', 'Bu alanlar nasıl birbirine bağlı?'], 'en': ['Which three areas are most important now?', 'How are these areas connected?'], 'fr': ['Quels trois domaines sont les plus importants?'], 'de': ['Welche drei Bereiche sind jetzt am wichtigsten?'], 'es': ['¿Cuáles tres áreas son más importantes ahora?'], 'ru': ['Какие три области сейчас наиболее важны?'], 'ar': ['أي ثلاثة مجالات هي الأهم الآن؟'], 'zh': ['哪三个领域现在最重要？'], 'el': ['Ποιοι τρεις τομείς είναι πιο σημαντικοί τώρα;'], 'bg': ['Кои три области са най-важни сега?']},
  safetyDisclaimer: {'tr': '⚠️ Tarot okuması eğlence amaçlıdır ve profesyonel danışmanlık yerine geçmez. Önemli kararlar için uzman görüşü alınız.', 'en': '⚠️ Tarot reading is for entertainment purposes and does not replace professional advice. Seek expert opinion for important decisions.', 'fr': '⚠️ La lecture du tarot est à des fins de divertissement.', 'de': '⚠️ Tarot-Lesen dient der Unterhaltung.', 'es': '⚠️ La lectura del tarot es con fines de entretenimiento.', 'ru': '⚠️ Чтение таро предназначено для развлечения.', 'ar': '⚠️ قراءة التاروت هي لأغراض الترفيه.', 'zh': '⚠️ 塔罗牌阅读仅供娱乐目的。', 'el': '⚠️ Η ανάγνωση ταρώ είναι για ψυχαγωγία.', 'bg': '⚠️ Четенето на таро е за забавление.'},
  doesNotDo: {'tr': ['Geleceği kesin olarak tahmin etmez', 'Profesyonel danışmanlık yerine geçmez'], 'en': ['Does not predict the future with certainty', 'Does not replace professional advice'], 'fr': ['Ne prédit pas l\'avenir avec certitude'], 'de': ['Sagt die Zukunft nicht mit Sicherheit voraus'], 'es': ['No predice el futuro con certeza'], 'ru': ['Не предсказывает будущее с уверенностью'], 'ar': ['لا يتنبأ بالمستقبل بيقين'], 'zh': ['不能确定地预测未来'], 'el': ['Δεν προβλέπει το μέλλον με βεβαιότητα'], 'bg': ['Не предсказва бъдещето със сигурност']},
  exampleScenarios: {'tr': ['Bir danışan kariyer, ilişki ve sağlık konularında 3 soru sorarak net bir yol haritası elde etti.'], 'en': ['A client gained a clear roadmap by asking 3 questions about career, relationship, and health.'], 'fr': ['Un client a obtenu une feuille de route claire avec 3 questions.'], 'de': ['Ein Kunde erhielt eine klare Roadmap mit 3 Fragen.'], 'es': ['Un cliente obtuvo una hoja de ruta clara con 3 preguntas.'], 'ru': ['Клиент получил чёткую дорожную карту с 3 вопросами.'], 'ar': ['حصل عميل على خريطة طريق واضحة بـ 3 أسئلة.'], 'zh': ['一位客户通过提出3个问题获得了清晰的路线图。'], 'el': ['Ένας πελάτης απέκτησε σαφή οδικό χάρτη με 3 ερωτήσεις.'], 'bg': ['Клиент получи ясна пътна карта с 3 въпроса.']},
  faq: {'tr': [FAQItem(question: 'Sorularım birbirine bağlı olmak zorunda mı?', answer: 'Hayır, tamamen farklı konularda olabilir.'), FAQItem(question: 'Kaç kart çekilir?', answer: 'Her soru için genellikle 3-5 kart çekilir.')], 'en': [FAQItem(question: 'Do my questions need to be related?', answer: 'No, they can be about completely different topics.'), FAQItem(question: 'How many cards are drawn?', answer: 'Usually 3-5 cards for each question.')], 'fr': [FAQItem(question: 'Mes questions doivent-elles être liées?', answer: 'Non, elles peuvent être sur des sujets différents.')], 'de': [FAQItem(question: 'Müssen meine Fragen zusammenhängen?', answer: 'Nein, sie können verschiedene Themen betreffen.')], 'es': [FAQItem(question: '¿Mis preguntas deben estar relacionadas?', answer: 'No, pueden ser sobre temas diferentes.')], 'ru': [FAQItem(question: 'Должны ли мои вопросы быть связаны?', answer: 'Нет, они могут быть на разные темы.')], 'ar': [FAQItem(question: 'هل يجب أن تكون أسئلتي مرتبطة؟', answer: 'لا، يمكن أن تكون عن مواضيع مختلفة.')], 'zh': [FAQItem(question: '我的问题需要相关吗？', answer: '不，它们可以是完全不同的主题。')], 'el': [FAQItem(question: 'Πρέπει οι ερωτήσεις μου να σχετίζονται;', answer: 'Όχι, μπορούν να είναι για διαφορετικά θέματα.')], 'bg': [FAQItem(question: 'Трябва ли въпросите ми да са свързани?', answer: 'Не, могат да бъдат за различни теми.')]},
  relatedPractices: {'tr': ['Tarot Konsültasyonu', 'Yıllık Tarot'], 'en': ['Tarot Consultation', 'Annual Tarot'], 'fr': ['Consultation Tarot', 'Tarot Annuel'], 'de': ['Tarot-Beratung', 'Jahrestarot'], 'es': ['Consulta de Tarot', 'Tarot Anual'], 'ru': ['Консультация Таро', 'Годовое Таро'], 'ar': ['استشارة التاروت', 'التاروت السنوي'], 'zh': ['塔罗咨询', '年度塔罗'], 'el': ['Συμβουλευτική Ταρώ', 'Ετήσιο Ταρώ'], 'bg': ['Таро Консултация', 'Годишно Таро']},
  differenceFromSimilar: {'tr': '3 Soru açılımı odaklı ve spesifiktir; genel tarot okuması daha geniş kapsamlıdır.', 'en': '3 Questions spread is focused and specific; general tarot reading has broader scope.', 'fr': 'Le tirage 3 Questions est focalisé; la lecture générale a une portée plus large.', 'de': 'Die 3-Fragen-Legung ist fokussiert; allgemeines Lesen hat größeren Umfang.', 'es': 'La tirada de 3 Preguntas es enfocada; la lectura general tiene alcance más amplio.', 'ru': 'Расклад на 3 вопроса сфокусирован; общее чтение имеет более широкий охват.', 'ar': 'انتشار 3 أسئلة مركز؛ القراءة العامة لها نطاق أوسع.', 'zh': '三问牌阵专注且具体；一般塔罗阅读范围更广。', 'el': 'Το άπλωμα 3 Ερωτήσεων είναι εστιασμένο· η γενική ανάγνωση έχει ευρύτερο πεδίο.', 'bg': 'Разстилката на 3 Въпроса е фокусирана; общото четене има по-широк обхват.'},
  microLearning: {'tr': ['💡 Sorularınızı net ve özgün tutun.', '💡 Her alan için ayrı bir niyet belirleyin.'], 'en': ['💡 Keep your questions clear and specific.', '💡 Set a separate intention for each area.'], 'fr': ['💡 Gardez vos questions claires et spécifiques.'], 'de': ['💡 Halten Sie Ihre Fragen klar und spezifisch.'], 'es': ['💡 Mantén tus preguntas claras y específicas.'], 'ru': ['💡 Держите вопросы ясными и конкретными.'], 'ar': ['💡 حافظ على أسئلتك واضحة ومحددة.'], 'zh': ['💡 保持问题清晰和具体。'], 'el': ['💡 Κρατήστε τις ερωτήσεις σας σαφείς και συγκεκριμένες.'], 'bg': ['💡 Дръжте въпросите си ясни и конкретни.']},
);

// ═══════════════════════════════════════════════════════════════════════════════
// TAROT - ANNUAL FORECAST
// ═══════════════════════════════════════════════════════════════════════════════

final tarotAnnualForecast = ServiceContent(
  id: 'tarot_annual_forecast',
  category: ServiceCategory.tarot,
  icon: '📅',
  displayOrder: 8,
  name: {
    'tr': 'Yıllık Tarot Açılımı',
    'en': 'Annual Tarot Forecast',
    'fr': 'Tarot Annuel',
    'de': 'Jahrestarot',
    'es': 'Tarot Anual',
    'ru': 'Годовое Таро',
    'ar': 'تاروت سنوي',
    'zh': '年度塔罗预测',
    'el': 'Ετήσιο Ταρώ',
    'bg': 'Годишно Таро',
  },
  shortDescription: {
    'tr': '12 aylık dönem için kapsamlı tarot okuması ile yılınızı planlayın.',
    'en': 'Plan your year with a comprehensive tarot reading for the 12-month period.',
    'fr': 'Planifiez votre année avec une lecture complète pour les 12 mois.',
    'de': 'Planen Sie Ihr Jahr mit einer umfassenden Legung für 12 Monate.',
    'es': 'Planifica tu año con una lectura completa para los 12 meses.',
    'ru': 'Спланируйте год с комплексным раскладом на 12 месяцев.',
    'ar': 'خطط لعامك مع قراءة شاملة لفترة 12 شهراً.',
    'zh': '通过12个月的综合塔罗阅读来规划您的一年。',
    'el': 'Σχεδιάστε τη χρονιά σας με μια ολοκληρωμένη ανάγνωση για 12 μήνες.',
    'bg': 'Планирайте годината си с цялостно четене за 12 месеца.',
  },
  coreExplanation: {
    'tr': 'Yıllık Tarot Açılımı, önümüzdeki 12 ay için ay ay rehberlik sunar. Her ay için çekilen kartlar, o dönemin enerjisini, fırsatlarını ve dikkat edilmesi gereken noktaları ortaya koyar. Bu kapsamlı açılım, yılınızı bilinçli bir şekilde planlamanıza yardımcı olur.',
    'en': 'The Annual Tarot Spread offers month-by-month guidance for the next 12 months. Cards drawn for each month reveal the energy, opportunities, and points of attention for that period. This comprehensive spread helps you consciously plan your year.',
    'fr': 'Le Tarot Annuel offre une guidance mois par mois pour les 12 prochains mois.',
    'de': 'Das Jahrestarot bietet monatliche Führung für die nächsten 12 Monate.',
    'es': 'El Tarot Anual ofrece guía mes a mes para los próximos 12 meses.',
    'ru': 'Годовое Таро предлагает помесячное руководство на 12 месяцев.',
    'ar': 'يقدم التاروت السنوي توجيهات شهرية للـ 12 شهراً القادمة.',
    'zh': '年度塔罗为未来12个月提供逐月指导。',
    'el': 'Το Ετήσιο Ταρώ προσφέρει καθοδήγηση μήνα προς μήνα για 12 μήνες.',
    'bg': 'Годишното Таро предлага ръководство месец по месец за 12 месеца.',
  },
  historicalBackground: {'tr': '12 kart açılımı yıllık döngüleri temsil eden antik bir pratiktir.', 'en': 'The 12-card spread is an ancient practice representing yearly cycles.', 'fr': 'Le tirage de 12 cartes est une pratique ancienne représentant les cycles annuels.', 'de': 'Die 12-Karten-Legung ist eine alte Praxis, die Jahreszyklen darstellt.', 'es': 'La tirada de 12 cartas es una práctica antigua que representa ciclos anuales.', 'ru': 'Расклад на 12 карт — древняя практика, представляющая годовые циклы.', 'ar': 'انتشار 12 بطاقة هو ممارسة قديمة تمثل الدورات السنوية.', 'zh': '12张牌阵是代表年度周期的古老做法。', 'el': 'Το άπλωμα 12 καρτών είναι μια αρχαία πρακτική που αντιπροσωπεύει ετήσιους κύκλους.', 'bg': 'Разстилката от 12 карти е древна практика, представяща годишни цикли.'},
  philosophicalFoundation: {'tr': 'Yıl, 12 evrelik bir yolculuktur; her ay kendi enerjisini taşır.', 'en': 'The year is a journey of 12 phases; each month carries its own energy.', 'fr': 'L\'année est un voyage de 12 phases; chaque mois porte sa propre énergie.', 'de': 'Das Jahr ist eine Reise von 12 Phasen; jeder Monat trägt seine eigene Energie.', 'es': 'El año es un viaje de 12 fases; cada mes lleva su propia energía.', 'ru': 'Год — это путешествие из 12 фаз; каждый месяц несёт свою энергию.', 'ar': 'السنة رحلة من 12 مرحلة؛ كل شهر يحمل طاقته الخاصة.', 'zh': '一年是12个阶段的旅程；每个月都有自己的能量。', 'el': 'Ο χρόνος είναι ένα ταξίδι 12 φάσεων· κάθε μήνας φέρει τη δική του ενέργεια.', 'bg': 'Годината е пътуване от 12 фази; всеки месец носи своята енергия.'},
  howItWorks: {'tr': '1. Her ay için bir kart çekilir\n2. Yıllık tema kartı belirlenir\n3. Ay ay yorumlama yapılır\n4. Genel yıl enerjisi değerlendirilir', 'en': '1. One card is drawn for each month\n2. Annual theme card is determined\n3. Month-by-month interpretation is made\n4. Overall year energy is assessed', 'fr': '1. Une carte est tirée pour chaque mois...', 'de': '1. Für jeden Monat wird eine Karte gezogen...', 'es': '1. Se saca una carta para cada mes...', 'ru': '1. Для каждого месяца вытягивается карта...', 'ar': '1. تُسحب بطاقة لكل شهر...', 'zh': '1. 每个月抽一张牌...', 'el': '1. Τραβιέται μια κάρτα για κάθε μήνα...', 'bg': '1. Изтегля се карта за всеки месец...'},
  symbolicInterpretation: {'tr': '12 kart burçların ve yılın evrimini simgeler.', 'en': '12 cards symbolize the zodiac and the evolution of the year.', 'fr': '12 cartes symbolisent le zodiaque et l\'évolution de l\'année.', 'de': '12 Karten symbolisieren den Tierkreis und die Entwicklung des Jahres.', 'es': '12 cartas simbolizan el zodiaco y la evolución del año.', 'ru': '12 карт символизируют зодиак и эволюцию года.', 'ar': '12 بطاقة ترمز إلى الأبراج وتطور السنة.', 'zh': '12张牌象征黄道十二宫和一年的演变。', 'el': '12 κάρτες συμβολίζουν τον ζωδιακό και την εξέλιξη του έτους.', 'bg': '12 карти символизират зодиака и еволюцията на годината.'},
  insightsProvided: {'tr': 'Her ay için enerji, fırsatlar, zorluklar ve tavsiyeler.', 'en': 'Energy, opportunities, challenges, and advice for each month.', 'fr': 'Énergie, opportunités, défis et conseils pour chaque mois.', 'de': 'Energie, Chancen, Herausforderungen und Ratschläge für jeden Monat.', 'es': 'Energía, oportunidades, desafíos y consejos para cada mes.', 'ru': 'Энергия, возможности, вызовы и советы на каждый месяц.', 'ar': 'الطاقة والفرص والتحديات والنصائح لكل شهر.', 'zh': '每个月的能量、机会、挑战和建议。', 'el': 'Ενέργεια, ευκαιρίες, προκλήσεις και συμβουλές για κάθε μήνα.', 'bg': 'Енергия, възможности, предизвикателства и съвети за всеки месец.'},
  commonMotivations: {'tr': ['Yılı planlamak', 'Önemli dönemleri belirlemek', 'Stratejik kararlar almak'], 'en': ['Planning the year', 'Identifying important periods', 'Making strategic decisions'], 'fr': ['Planifier l\'année'], 'de': ['Das Jahr planen'], 'es': ['Planificar el año'], 'ru': ['Планирование года'], 'ar': ['التخطيط للسنة'], 'zh': ['规划一年'], 'el': ['Σχεδιασμός της χρονιάς'], 'bg': ['Планиране на годината']},
  lifeThemes: {'tr': ['Kariyer gelişimi', 'İlişkiler', 'Sağlık', 'Finans', 'Kişisel büyüme'], 'en': ['Career development', 'Relationships', 'Health', 'Finance', 'Personal growth'], 'fr': ['Développement de carrière'], 'de': ['Karriereentwicklung'], 'es': ['Desarrollo profesional'], 'ru': ['Карьерное развитие'], 'ar': ['تطوير المهنة'], 'zh': ['职业发展'], 'el': ['Επαγγελματική ανάπτυξη'], 'bg': ['Кариерно развитие']},
  whatYouReceive: {'tr': '• 12 aylık kart açılımı\n• Yıllık tema kartı\n• Her ay için detaylı yorum\n• Kritik dönem uyarıları\n• Yıl sonu değerlendirmesi', 'en': '• 12-month card spread\n• Annual theme card\n• Detailed interpretation for each month\n• Critical period warnings\n• Year-end assessment', 'fr': '• Tirage de 12 mois...', 'de': '• 12-Monats-Legung...', 'es': '• Tirada de 12 meses...', 'ru': '• Расклад на 12 месяцев...', 'ar': '• انتشار 12 شهراً...', 'zh': '• 12个月牌阵...', 'el': '• Άπλωμα 12 μηνών...', 'bg': '• Разстилка за 12 месеца...'},
  perspectiveGained: {'tr': 'Yılınızı kuş bakışı görerek bilinçli kararlar alabilirsiniz.', 'en': 'By seeing your year from a bird\'s eye view, you can make conscious decisions.', 'fr': 'En voyant votre année d\'une vue d\'ensemble, vous pouvez prendre des décisions conscientes.', 'de': 'Indem Sie Ihr Jahr aus der Vogelperspektive sehen, können Sie bewusste Entscheidungen treffen.', 'es': 'Al ver tu año desde una vista panorámica, puedes tomar decisiones conscientes.', 'ru': 'Видя год с высоты птичьего полёта, вы можете принимать осознанные решения.', 'ar': 'برؤية عامك من منظور شامل، يمكنك اتخاذ قرارات واعية.', 'zh': '从鸟瞰视角看您的一年，您可以做出有意识的决定。', 'el': 'Βλέποντας τη χρονιά σας από ψηλά, μπορείτε να πάρετε συνειδητές αποφάσεις.', 'bg': 'Виждайки годината си от птичи поглед, можете да вземате съзнателни решения.'},
  reflectionPoints: {'tr': ['Bu yıl neyi başarmak istiyorum?', 'Hangi aylarda dikkatli olmalıyım?'], 'en': ['What do I want to achieve this year?', 'Which months should I be careful?'], 'fr': ['Que veux-je accomplir cette année?'], 'de': ['Was möchte ich dieses Jahr erreichen?'], 'es': ['¿Qué quiero lograr este año?'], 'ru': ['Чего я хочу достичь в этом году?'], 'ar': ['ماذا أريد تحقيقه هذا العام؟'], 'zh': ['今年我想实现什么？'], 'el': ['Τι θέλω να επιτύχω φέτος;'], 'bg': ['Какво искам да постигна тази година?']},
  safetyDisclaimer: {'tr': '⚠️ Yıllık tarot okuması eğlence amaçlıdır. Kesin olayları tahmin etmez ve profesyonel danışmanlık yerine geçmez.', 'en': '⚠️ Annual tarot reading is for entertainment purposes. It does not predict exact events and does not replace professional advice.', 'fr': '⚠️ La lecture annuelle du tarot est à des fins de divertissement.', 'de': '⚠️ Jahrestarot-Lesung dient der Unterhaltung.', 'es': '⚠️ La lectura anual del tarot es con fines de entretenimiento.', 'ru': '⚠️ Годовое чтение таро предназначено для развлечения.', 'ar': '⚠️ القراءة السنوية للتاروت هي لأغراض الترفيه.', 'zh': '⚠️ 年度塔罗阅读仅供娱乐目的。', 'el': '⚠️ Η ετήσια ανάγνωση ταρώ είναι για ψυχαγωγία.', 'bg': '⚠️ Годишното четене на таро е за забавление.'},
  doesNotDo: {'tr': ['Kesin tarihler vermez', 'Olayları garanti etmez'], 'en': ['Does not give exact dates', 'Does not guarantee events'], 'fr': ['Ne donne pas de dates exactes'], 'de': ['Gibt keine genauen Daten an'], 'es': ['No da fechas exactas'], 'ru': ['Не даёт точных дат'], 'ar': ['لا يعطي تواريخ دقيقة'], 'zh': ['不提供确切日期'], 'el': ['Δεν δίνει ακριβείς ημερομηνίες'], 'bg': ['Не дава точни дати']},
  exampleScenarios: {'tr': ['Bir girişimci yıllık tarot ile iş genişletme için en uygun dönemleri belirledi.'], 'en': ['An entrepreneur identified the best periods for business expansion through annual tarot.'], 'fr': ['Un entrepreneur a identifié les meilleures périodes pour l\'expansion avec le tarot annuel.'], 'de': ['Ein Unternehmer identifizierte die besten Zeiträume für Expansion durch Jahrestarot.'], 'es': ['Un emprendedor identificó los mejores períodos para expansión con el tarot anual.'], 'ru': ['Предприниматель определил лучшие периоды для расширения через годовое таро.'], 'ar': ['حدد رائد أعمال أفضل فترات التوسع من خلال التاروت السنوي.'], 'zh': ['一位企业家通过年度塔罗确定了业务扩展的最佳时期。'], 'el': ['Ένας επιχειρηματίας εντόπισε τις καλύτερες περιόδους για επέκταση μέσω ετήσιου ταρώ.'], 'bg': ['Предприемач идентифицира най-добрите периоди за разширяване чрез годишно таро.']},
  faq: {'tr': [FAQItem(question: 'Yıllık tarot ne zaman yapılmalı?', answer: 'Yılbaşında veya doğum gününüzde ideal olarak.'), FAQItem(question: 'Aylar tam olarak örtüşür mü?', answer: 'Enerji dönemlerini temsil eder, kesin tarihleri değil.')], 'en': [FAQItem(question: 'When should annual tarot be done?', answer: 'Ideally at New Year or on your birthday.'), FAQItem(question: 'Do months overlap exactly?', answer: 'They represent energy periods, not exact dates.')], 'fr': [FAQItem(question: 'Quand faire le tarot annuel?', answer: 'Idéalement au Nouvel An ou à votre anniversaire.')], 'de': [FAQItem(question: 'Wann sollte Jahrestarot gemacht werden?', answer: 'Idealerweise zu Neujahr oder an Ihrem Geburtstag.')], 'es': [FAQItem(question: '¿Cuándo hacer el tarot anual?', answer: 'Idealmente en Año Nuevo o en tu cumpleaños.')], 'ru': [FAQItem(question: 'Когда делать годовое таро?', answer: 'В идеале на Новый год или в день рождения.')], 'ar': [FAQItem(question: 'متى إجراء التاروت السنوي؟', answer: 'في رأس السنة أو عيد ميلادك بشكل مثالي.')], 'zh': [FAQItem(question: '什么时候做年度塔罗？', answer: '理想情况下在新年或生日。')], 'el': [FAQItem(question: 'Πότε να γίνει το ετήσιο ταρώ;', answer: 'Ιδανικά την Πρωτοχρονιά ή στα γενέθλιά σας.')], 'bg': [FAQItem(question: 'Кога да се прави годишно таро?', answer: 'Идеално на Нова година или на рождения ви ден.')]},
  relatedPractices: {'tr': ['Aylık Tarot', 'Astroloji Yıllık Tahmin'], 'en': ['Monthly Tarot', 'Astrology Annual Forecast'], 'fr': ['Tarot Mensuel', 'Prévisions Astrologiques Annuelles'], 'de': ['Monatstarot', 'Astrologische Jahresvorhersage'], 'es': ['Tarot Mensual', 'Pronóstico Astrológico Anual'], 'ru': ['Ежемесячное Таро', 'Астрологический Годовой Прогноз'], 'ar': ['التاروت الشهري', 'التوقعات الفلكية السنوية'], 'zh': ['月度塔罗', '占星年度预测'], 'el': ['Μηνιαίο Ταρώ', 'Αστρολογική Ετήσια Πρόβλεψη'], 'bg': ['Месечно Таро', 'Астрологична Годишна Прогноза']},
  differenceFromSimilar: {'tr': 'Yıllık tarot kartlarla çalışır; yıllık astroloji gezegen hareketlerine dayanır.', 'en': 'Annual tarot works with cards; annual astrology is based on planetary movements.', 'fr': 'Le tarot annuel fonctionne avec des cartes; l\'astrologie annuelle est basée sur les mouvements planétaires.', 'de': 'Jahrestarot arbeitet mit Karten; Jahresastrologie basiert auf Planetenbewegungen.', 'es': 'El tarot anual trabaja con cartas; la astrología anual se basa en movimientos planetarios.', 'ru': 'Годовое таро работает с картами; годовая астрология основана на движении планет.', 'ar': 'التاروت السنوي يعمل بالبطاقات؛ علم الفلك السنوي يعتمد على حركات الكواكب.', 'zh': '年度塔罗使用卡牌；年度占星术基于行星运动。', 'el': 'Το ετήσιο ταρώ λειτουργεί με κάρτες· η ετήσια αστρολογία βασίζεται σε πλανητικές κινήσεις.', 'bg': 'Годишното таро работи с карти; годишната астрология се основава на планетарни движения.'},
  microLearning: {'tr': ['💡 Her ayın kartını o ayın başında tekrar gözden geçirin.', '💡 Tekrarlayan kartlar önemli temalara işaret eder.'], 'en': ['💡 Review each month\'s card at the beginning of that month.', '💡 Recurring cards point to important themes.'], 'fr': ['💡 Révisez la carte de chaque mois au début de ce mois.'], 'de': ['💡 Überprüfen Sie die Karte jedes Monats zu Beginn dieses Monats.'], 'es': ['💡 Revisa la carta de cada mes al comienzo de ese mes.'], 'ru': ['💡 Пересматривайте карту каждого месяца в начале этого месяца.'], 'ar': ['💡 راجع بطاقة كل شهر في بداية ذلك الشهر.'], 'zh': ['💡 在每个月初回顾该月的牌。'], 'el': ['💡 Αναθεωρήστε την κάρτα κάθε μήνα στην αρχή του.'], 'bg': ['💡 Прегледайте картата на всеки месец в началото на този месец.']},
);

// ═══════════════════════════════════════════════════════════════════════════════
// TAROT - MONTHLY FORECAST
// ═══════════════════════════════════════════════════════════════════════════════

final tarotMonthlyForecast = ServiceContent(
  id: 'tarot_monthly_forecast',
  category: ServiceCategory.tarot,
  icon: '🌙',
  displayOrder: 9,
  name: {
    'tr': 'Aylık Tarot Açılımı',
    'en': 'Monthly Tarot Forecast',
    'fr': 'Tarot Mensuel',
    'de': 'Monatstarot',
    'es': 'Tarot Mensual',
    'ru': 'Ежемесячное Таро',
    'ar': 'تاروت شهري',
    'zh': '月度塔罗预测',
    'el': 'Μηνιαίο Ταρώ',
    'bg': 'Месечно Таро',
  },
  shortDescription: {
    'tr': 'Önümüzdeki 4 hafta için haftalık tarot rehberliği alın.',
    'en': 'Get weekly tarot guidance for the next 4 weeks.',
    'fr': 'Obtenez une guidance tarot hebdomadaire pour les 4 prochaines semaines.',
    'de': 'Erhalten Sie wöchentliche Tarot-Führung für die nächsten 4 Wochen.',
    'es': 'Obtén guía semanal de tarot para las próximas 4 semanas.',
    'ru': 'Получите еженедельное руководство таро на 4 недели.',
    'ar': 'احصل على إرشادات تاروت أسبوعية للأسابيع الأربعة القادمة.',
    'zh': '获取未来4周的每周塔罗指导。',
    'el': 'Λάβετε εβδομαδιαία καθοδήγηση ταρώ για τις επόμενες 4 εβδομάδες.',
    'bg': 'Получете седмично ръководство за следващите 4 седмици.',
  },
  coreExplanation: {
    'tr': 'Aylık Tarot Açılımı, önümüzdeki ayı hafta hafta analiz eder. Her hafta için çekilen kartlar, o dönemin enerjisini ve dikkat edilmesi gereken konuları gösterir. Ay ortasında bir genel bakış kartı ile tüm ayın teması belirlenir.',
    'en': 'Monthly Tarot Spread analyzes the upcoming month week by week. Cards drawn for each week show the energy of that period and topics requiring attention. A mid-month overview card determines the overall theme of the month.',
    'fr': 'Le Tarot Mensuel analyse le mois à venir semaine par semaine.',
    'de': 'Das Monatstarot analysiert den kommenden Monat Woche für Woche.',
    'es': 'El Tarot Mensual analiza el mes próximo semana por semana.',
    'ru': 'Ежемесячное Таро анализирует предстоящий месяц неделя за неделей.',
    'ar': 'يحلل التاروت الشهري الشهر القادم أسبوعاً بأسبوع.',
    'zh': '月度塔罗牌阵逐周分析即将到来的月份。',
    'el': 'Το Μηνιαίο Ταρώ αναλύει τον επόμενο μήνα εβδομάδα προς εβδομάδα.',
    'bg': 'Месечното Таро анализира идващия месец седмица по седмица.',
  },
  historicalBackground: {'tr': 'Haftalık tarot açılımları pratik rehberlik için geliştirilmiştir.', 'en': 'Weekly tarot spreads were developed for practical guidance.', 'fr': 'Les tirages hebdomadaires ont été développés pour une guidance pratique.', 'de': 'Wöchentliche Legungen wurden für praktische Führung entwickelt.', 'es': 'Las tiradas semanales se desarrollaron para orientación práctica.', 'ru': 'Еженедельные расклады были разработаны для практического руководства.', 'ar': 'تم تطوير فروق أسبوعية للتوجيه العملي.', 'zh': '每周牌阵是为实践指导而开发的。', 'el': 'Τα εβδομαδιαία απλώματα αναπτύχθηκαν για πρακτική καθοδήγηση.', 'bg': 'Седмичните разстилки са разработени за практическо ръководство.'},
  philosophicalFoundation: {'tr': 'Ay döngüsü doğal bir zaman birimi olarak yaşamımızı etkiler.', 'en': 'The lunar cycle as a natural time unit influences our lives.', 'fr': 'Le cycle lunaire en tant qu\'unité de temps naturelle influence nos vies.', 'de': 'Der Mondzyklus als natürliche Zeiteinheit beeinflusst unser Leben.', 'es': 'El ciclo lunar como unidad de tiempo natural influye en nuestras vidas.', 'ru': 'Лунный цикл как естественная единица времени влияет на нашу жизнь.', 'ar': 'دورة القمر كوحدة زمنية طبيعية تؤثر على حياتنا.', 'zh': '月亮周期作为自然时间单位影响我们的生活。', 'el': 'Ο σεληνιακός κύκλος ως φυσική μονάδα χρόνου επηρεάζει τη ζωή μας.', 'bg': 'Лунният цикъл като естествена единица време влияе на живота ни.'},
  howItWorks: {'tr': '1. Her hafta için kart çekilir\n2. Ay teması belirlenir\n3. Haftalık enerjiler yorumlanır\n4. Geçişler ve bağlantılar değerlendirilir', 'en': '1. Cards are drawn for each week\n2. Monthly theme is determined\n3. Weekly energies are interpreted\n4. Transitions and connections are assessed', 'fr': '1. Des cartes sont tirées pour chaque semaine...', 'de': '1. Karten werden für jede Woche gezogen...', 'es': '1. Se sacan cartas para cada semana...', 'ru': '1. Карты вытягиваются для каждой недели...', 'ar': '1. تُسحب بطاقات لكل أسبوع...', 'zh': '1. 每周抽牌...', 'el': '1. Τραβιούνται κάρτες για κάθε εβδομάδα...', 'bg': '1. Изтеглят се карти за всяка седмица...'},
  symbolicInterpretation: {'tr': 'Dört hafta, ayın dört evresini simgeler.', 'en': 'Four weeks symbolize the four phases of the moon.', 'fr': 'Quatre semaines symbolisent les quatre phases de la lune.', 'de': 'Vier Wochen symbolisieren die vier Mondphasen.', 'es': 'Cuatro semanas simbolizan las cuatro fases de la luna.', 'ru': 'Четыре недели символизируют четыре фазы луны.', 'ar': 'أربعة أسابيع ترمز إلى المراحل الأربع للقمر.', 'zh': '四周象征月亮的四个阶段。', 'el': 'Τέσσερις εβδομάδες συμβολίζουν τις τέσσερις φάσεις της σελήνης.', 'bg': 'Четири седмици символизират четирите фази на луната.'},
  insightsProvided: {'tr': 'Haftalık enerji akışı, önemli günler ve genel ay teması.', 'en': 'Weekly energy flow, important days, and overall month theme.', 'fr': 'Flux d\'énergie hebdomadaire, jours importants et thème du mois.', 'de': 'Wöchentlicher Energiefluss, wichtige Tage und Monatsthema.', 'es': 'Flujo de energía semanal, días importantes y tema del mes.', 'ru': 'Еженедельный поток энергии, важные дни и тема месяца.', 'ar': 'تدفق الطاقة الأسبوعي والأيام المهمة وموضوع الشهر.', 'zh': '每周能量流、重要日子和整月主题。', 'el': 'Εβδομαδιαία ροή ενέργειας, σημαντικές ημέρες και θέμα μήνα.', 'bg': 'Седмичен поток на енергия, важни дни и тема на месеца.'},
  commonMotivations: {'tr': ['Ayı planlamak', 'Haftalık rehberlik', 'Kısa vadeli karar desteği'], 'en': ['Planning the month', 'Weekly guidance', 'Short-term decision support'], 'fr': ['Planifier le mois'], 'de': ['Den Monat planen'], 'es': ['Planificar el mes'], 'ru': ['Планирование месяца'], 'ar': ['التخطيط للشهر'], 'zh': ['规划月份'], 'el': ['Σχεδιασμός του μήνα'], 'bg': ['Планиране на месеца']},
  lifeThemes: {'tr': ['İş', 'İlişkiler', 'Sağlık', 'Yaratıcılık'], 'en': ['Work', 'Relationships', 'Health', 'Creativity'], 'fr': ['Travail', 'Relations'], 'de': ['Arbeit', 'Beziehungen'], 'es': ['Trabajo', 'Relaciones'], 'ru': ['Работа', 'Отношения'], 'ar': ['عمل', 'علاقات'], 'zh': ['工作', '关系'], 'el': ['Εργασία', 'Σχέσεις'], 'bg': ['Работа', 'Отношения']},
  whatYouReceive: {'tr': '• 4 haftalık kart açılımı\n• Ay tema kartı\n• Her hafta için detaylı yorum\n• Ay sonu değerlendirmesi', 'en': '• 4-week card spread\n• Month theme card\n• Detailed interpretation for each week\n• Month-end assessment', 'fr': '• Tirage de 4 semaines...', 'de': '• 4-Wochen-Legung...', 'es': '• Tirada de 4 semanas...', 'ru': '• Расклад на 4 недели...', 'ar': '• انتشار 4 أسابيع...', 'zh': '• 4周牌阵...', 'el': '• Άπλωμα 4 εβδομάδων...', 'bg': '• Разстилка за 4 седмици...'},
  perspectiveGained: {'tr': 'Ayınızı daha bilinçli ve hazırlıklı geçirirsiniz.', 'en': 'You spend your month more consciously and prepared.', 'fr': 'Vous passez votre mois plus consciemment et préparé.', 'de': 'Sie verbringen Ihren Monat bewusster und vorbereiteter.', 'es': 'Pasas tu mes más conscientemente y preparado.', 'ru': 'Вы проводите месяц более осознанно и подготовленно.', 'ar': 'تقضي شهرك بوعي أكبر واستعداد.', 'zh': '您更有意识和准备地度过这个月。', 'el': 'Περνάτε τον μήνα σας πιο συνειδητά και προετοιμασμένα.', 'bg': 'Прекарвате месеца си по-съзнателно и подготвено.'},
  reflectionPoints: {'tr': ['Bu ay hangi hedeflere odaklanacağım?', 'Hangi hafta daha dikkatli olmalıyım?'], 'en': ['What goals will I focus on this month?', 'Which week should I be more careful?'], 'fr': ['Sur quels objectifs vais-je me concentrer ce mois-ci?'], 'de': ['Auf welche Ziele werde ich mich diesen Monat konzentrieren?'], 'es': ['¿En qué metas me enfocaré este mes?'], 'ru': ['На каких целях я сосредоточусь в этом месяце?'], 'ar': ['ما الأهداف التي سأركز عليها هذا الشهر؟'], 'zh': ['这个月我将关注哪些目标？'], 'el': ['Σε ποιους στόχους θα επικεντρωθώ αυτόν τον μήνα;'], 'bg': ['На кои цели ще се съсредоточа този месец?']},
  safetyDisclaimer: {'tr': '⚠️ Aylık tarot okuması eğlence amaçlıdır ve profesyonel danışmanlık yerine geçmez.', 'en': '⚠️ Monthly tarot reading is for entertainment purposes and does not replace professional advice.', 'fr': '⚠️ La lecture mensuelle du tarot est à des fins de divertissement.', 'de': '⚠️ Monatliche Tarot-Lesung dient der Unterhaltung.', 'es': '⚠️ La lectura mensual del tarot es con fines de entretenimiento.', 'ru': '⚠️ Ежемесячное чтение таро предназначено для развлечения.', 'ar': '⚠️ القراءة الشهرية للتاروت هي لأغراض الترفيه.', 'zh': '⚠️ 月度塔罗阅读仅供娱乐目的。', 'el': '⚠️ Η μηνιαία ανάγνωση ταρώ είναι για ψυχαγωγία.', 'bg': '⚠️ Месечното четене на таро е за забавление.'},
  doesNotDo: {'tr': ['Kesin tarihlerde olaylar öngörmez', 'Garantili sonuçlar vermez'], 'en': ['Does not predict events on exact dates', 'Does not give guaranteed results'], 'fr': ['Ne prédit pas d\'événements à des dates exactes'], 'de': ['Sagt keine Ereignisse an genauen Daten voraus'], 'es': ['No predice eventos en fechas exactas'], 'ru': ['Не предсказывает события на точные даты'], 'ar': ['لا يتنبأ بأحداث في تواريخ محددة'], 'zh': ['不预测确切日期的事件'], 'el': ['Δεν προβλέπει γεγονότα σε ακριβείς ημερομηνίες'], 'bg': ['Не предсказва събития на точни дати']},
  exampleScenarios: {'tr': ['Bir yönetici aylık tarot ile ekip toplantıları için en verimli haftaları belirledi.'], 'en': ['A manager identified the most productive weeks for team meetings through monthly tarot.'], 'fr': ['Un gestionnaire a identifié les semaines les plus productives pour les réunions d\'équipe.'], 'de': ['Ein Manager identifizierte die produktivsten Wochen für Teammeetings.'], 'es': ['Un gerente identificó las semanas más productivas para reuniones de equipo.'], 'ru': ['Менеджер определил наиболее продуктивные недели для командных встреч.'], 'ar': ['حدد مدير أكثر الأسابيع إنتاجية لاجتماعات الفريق.'], 'zh': ['一位经理确定了团队会议最高效的周次。'], 'el': ['Ένας διευθυντής εντόπισε τις πιο παραγωγικές εβδομάδες για συναντήσεις ομάδας.'], 'bg': ['Мениджър идентифицира най-продуктивните седмици за екипни срещи.']},
  faq: {'tr': [FAQItem(question: 'Aylık tarot ne zaman yapılmalı?', answer: 'Ayın başında veya önceki ayın sonunda.'), FAQItem(question: 'Her hafta için kaç kart çekilir?', answer: 'Genellikle 2-3 kart çekilir.')], 'en': [FAQItem(question: 'When should monthly tarot be done?', answer: 'At the beginning of the month or end of the previous month.'), FAQItem(question: 'How many cards are drawn for each week?', answer: 'Usually 2-3 cards.')], 'fr': [FAQItem(question: 'Quand faire le tarot mensuel?', answer: 'Au début du mois ou à la fin du mois précédent.')], 'de': [FAQItem(question: 'Wann sollte Monatstarot gemacht werden?', answer: 'Zu Beginn des Monats oder Ende des vorherigen Monats.')], 'es': [FAQItem(question: '¿Cuándo hacer el tarot mensual?', answer: 'Al comienzo del mes o al final del mes anterior.')], 'ru': [FAQItem(question: 'Когда делать месячное таро?', answer: 'В начале месяца или в конце предыдущего месяца.')], 'ar': [FAQItem(question: 'متى إجراء التاروت الشهري؟', answer: 'في بداية الشهر أو نهاية الشهر السابق.')], 'zh': [FAQItem(question: '什么时候做月度塔罗？', answer: '月初或上月末。')], 'el': [FAQItem(question: 'Πότε να γίνει το μηνιαίο ταρώ;', answer: 'Στην αρχή του μήνα ή στο τέλος του προηγούμενου.')], 'bg': [FAQItem(question: 'Кога да се прави месечно таро?', answer: 'В началото на месеца или края на предходния месец.')]},
  relatedPractices: {'tr': ['Yıllık Tarot', 'Tarot Konsültasyonu'], 'en': ['Annual Tarot', 'Tarot Consultation'], 'fr': ['Tarot Annuel', 'Consultation Tarot'], 'de': ['Jahrestarot', 'Tarot-Beratung'], 'es': ['Tarot Anual', 'Consulta de Tarot'], 'ru': ['Годовое Таро', 'Консультация Таро'], 'ar': ['التاروت السنوي', 'استشارة التاروت'], 'zh': ['年度塔罗', '塔罗咨询'], 'el': ['Ετήσιο Ταρώ', 'Συμβουλευτική Ταρώ'], 'bg': ['Годишно Таро', 'Таро Консултация']},
  differenceFromSimilar: {'tr': 'Aylık tarot 4 haftaya odaklanır; yıllık tarot 12 aya bakar.', 'en': 'Monthly tarot focuses on 4 weeks; annual tarot looks at 12 months.', 'fr': 'Le tarot mensuel se concentre sur 4 semaines; l\'annuel sur 12 mois.', 'de': 'Monatstarot konzentriert sich auf 4 Wochen; Jahrestarot auf 12 Monate.', 'es': 'El tarot mensual se enfoca en 4 semanas; el anual en 12 meses.', 'ru': 'Месячное таро фокусируется на 4 неделях; годовое на 12 месяцах.', 'ar': 'التاروت الشهري يركز على 4 أسابيع؛ السنوي على 12 شهراً.', 'zh': '月度塔罗关注4周；年度塔罗关注12个月。', 'el': 'Το μηνιαίο ταρώ εστιάζει σε 4 εβδομάδες· το ετήσιο σε 12 μήνες.', 'bg': 'Месечното таро се фокусира върху 4 седмици; годишното върху 12 месеца.'},
  microLearning: {'tr': ['💡 Haftanın başında o haftanın kartını tekrar gözden geçirin.', '💡 Ay sonu kartlarınızı değerlendirin.'], 'en': ['💡 Review that week\'s card at the beginning of the week.', '💡 Evaluate your cards at the end of the month.'], 'fr': ['💡 Révisez la carte de la semaine au début de la semaine.'], 'de': ['💡 Überprüfen Sie die Wochenkarte zu Beginn der Woche.'], 'es': ['💡 Revisa la carta de la semana al comienzo de la semana.'], 'ru': ['💡 Пересматривайте карту недели в начале недели.'], 'ar': ['💡 راجع بطاقة الأسبوع في بداية الأسبوع.'], 'zh': ['💡 在周初回顾该周的牌。'], 'el': ['💡 Αναθεωρήστε την κάρτα της εβδομάδας στην αρχή της.'], 'bg': ['💡 Прегледайте картата на седмицата в началото ѝ.']},
);

// ═══════════════════════════════════════════════════════════════════════════════
// TAROT - ZEN TAROT (OSHO)
// ═══════════════════════════════════════════════════════════════════════════════

final tarotZen = ServiceContent(
  id: 'tarot_zen',
  category: ServiceCategory.tarot,
  icon: '🧘',
  displayOrder: 10,
  name: {
    'tr': 'Zen Tarot (Osho)',
    'en': 'Zen Tarot (Osho)',
    'fr': 'Tarot Zen (Osho)',
    'de': 'Zen Tarot (Osho)',
    'es': 'Tarot Zen (Osho)',
    'ru': 'Дзен Таро (Ошо)',
    'ar': 'تاروت زن (أوشو)',
    'zh': '禅宗塔罗（奥修）',
    'el': 'Ζεν Ταρώ (Όσο)',
    'bg': 'Дзен Таро (Ошо)',
  },
  shortDescription: {
    'tr': 'Osho Zen Tarot ile şimdiki ana odaklanın ve içsel farkındalık kazanın.',
    'en': 'Focus on the present moment and gain inner awareness with Osho Zen Tarot.',
    'fr': 'Concentrez-vous sur le moment présent et gagnez en conscience intérieure.',
    'de': 'Konzentrieren Sie sich auf den Moment und gewinnen Sie inneres Bewusstsein.',
    'es': 'Enfócate en el momento presente y gana conciencia interior.',
    'ru': 'Сосредоточьтесь на настоящем моменте и обретите внутреннее осознание.',
    'ar': 'ركز على اللحظة الحالية واكتسب وعياً داخلياً.',
    'zh': '专注于当下，获得内在觉知。',
    'el': 'Επικεντρωθείτε στο παρόν και αποκτήστε εσωτερική επίγνωση.',
    'bg': 'Съсредоточете се върху настоящия момент и придобийте вътрешно осъзнаване.',
  },
  coreExplanation: {
    'tr': 'Osho Zen Tarot, geleneksel tarottan farklı olarak geleceği tahmin etmeye değil, şimdiki ana odaklanmaya yöneliktir. Zen felsefesine dayanan bu deste, içsel farkındalığı artırmak, meditasyona yardımcı olmak ve yaşamın akışına güvenmeyi öğretmek için tasarlanmıştır. Kartlar, Buda\'nın öğretilerinden ve Zen hikayelerinden ilham alır.',
    'en': 'Osho Zen Tarot, unlike traditional tarot, focuses on the present moment rather than predicting the future. Based on Zen philosophy, this deck is designed to increase inner awareness, aid meditation, and teach trust in the flow of life. The cards are inspired by Buddha\'s teachings and Zen stories.',
    'fr': 'Le Tarot Zen d\'Osho se concentre sur le moment présent plutôt que sur la prédiction.',
    'de': 'Osho Zen Tarot konzentriert sich auf den Moment statt auf Vorhersagen.',
    'es': 'El Tarot Zen de Osho se centra en el momento presente en lugar de predecir.',
    'ru': 'Таро Ошо Дзен фокусируется на настоящем моменте, а не на предсказаниях.',
    'ar': 'يركز تاروت زن أوشو على اللحظة الحالية بدلاً من التنبؤ.',
    'zh': '奥修禅宗塔罗专注于当下而非预测。',
    'el': 'Το Ζεν Ταρώ του Όσο επικεντρώνεται στο παρόν αντί να προβλέπει.',
    'bg': 'Ошо Дзен Таро се фокусира върху настоящия момент, а не върху предсказания.',
  },
  historicalBackground: {'tr': 'Osho Zen Tarot, Hint mistik Osho\'nun öğretilerine dayanır ve 1994\'te yayınlandı. Zen Budizmi felsefesini tarot formatına uyarlar.', 'en': 'Osho Zen Tarot is based on the teachings of Indian mystic Osho and was published in 1994. It adapts Zen Buddhism philosophy to tarot format.', 'fr': 'Le Tarot Zen d\'Osho est basé sur les enseignements du mystique indien Osho, publié en 1994.', 'de': 'Osho Zen Tarot basiert auf den Lehren des indischen Mystikers Osho, veröffentlicht 1994.', 'es': 'El Tarot Zen de Osho se basa en las enseñanzas del místico indio Osho, publicado en 1994.', 'ru': 'Таро Ошо Дзен основано на учениях индийского мистика Ошо, опубликовано в 1994 году.', 'ar': 'يستند تاروت زن أوشو إلى تعاليم الصوفي الهندي أوشو، نُشر عام 1994.', 'zh': '奥修禅宗塔罗基于印度神秘主义者奥修的教导，于1994年出版。', 'el': 'Το Ζεν Ταρώ του Όσο βασίζεται στις διδασκαλίες του Ινδού μυστικιστή Oshο, εκδόθηκε το 1994.', 'bg': 'Ошо Дзен Таро е базирано на ученията на индийския мистик Ошо, публикувано през 1994 г.'},
  philosophicalFoundation: {'tr': 'Zen felsefesi, aydınlanmanın geçmişte veya gelecekte değil, şimdiki anda olduğunu öğretir. Zihni boşaltarak gerçeği görmek mümkündür.', 'en': 'Zen philosophy teaches that enlightenment is in the present moment, not in the past or future. By emptying the mind, it is possible to see the truth.', 'fr': 'La philosophie Zen enseigne que l\'illumination est dans le moment présent.', 'de': 'Die Zen-Philosophie lehrt, dass Erleuchtung im gegenwärtigen Moment liegt.', 'es': 'La filosofía Zen enseña que la iluminación está en el momento presente.', 'ru': 'Философия Дзен учит, что просветление находится в настоящем моменте.', 'ar': 'تعلم فلسفة الزن أن التنوير يكون في اللحظة الحالية.', 'zh': '禅宗哲学教导开悟在当下，而非过去或未来。', 'el': 'Η φιλοσοφία Ζεν διδάσκει ότι η φώτιση είναι στο παρόν.', 'bg': 'Дзен философията учи, че просветлението е в настоящия момент.'},
  howItWorks: {'tr': '1. Meditasyonla hazırlık\n2. Kartın şimdiki ana odaklanarak çekilmesi\n3. Sembolizmin içsel yansımasının araştırılması\n4. Sessizlik ve kabul ile mesajın alınması', 'en': '1. Preparation with meditation\n2. Drawing the card while focusing on the present moment\n3. Exploring the inner reflection of the symbolism\n4. Receiving the message with silence and acceptance', 'fr': '1. Préparation avec méditation...', 'de': '1. Vorbereitung mit Meditation...', 'es': '1. Preparación con meditación...', 'ru': '1. Подготовка с медитацией...', 'ar': '1. التحضير بالتأمل...', 'zh': '1. 以冥想准备...', 'el': '1. Προετοιμασία με διαλογισμό...', 'bg': '1. Подготовка с медитация...'},
  symbolicInterpretation: {'tr': 'Zen Tarot sembolleri doğu felsefesinden gelir: Lotus aydınlanmayı, boşluk potansiyeli, dağ durağanlığı simgeler.', 'en': 'Zen Tarot symbols come from Eastern philosophy: Lotus represents enlightenment, void represents potential, mountain represents stillness.', 'fr': 'Les symboles du Tarot Zen viennent de la philosophie orientale.', 'de': 'Zen Tarot-Symbole stammen aus der östlichen Philosophie.', 'es': 'Los símbolos del Tarot Zen provienen de la filosofía oriental.', 'ru': 'Символы Дзен Таро происходят из восточной философии.', 'ar': 'رموز تاروت الزن تأتي من الفلسفة الشرقية.', 'zh': '禅宗塔罗符号来自东方哲学。', 'el': 'Τα σύμβολα Ζεν Ταρώ προέρχονται από την ανατολική φιλοσοφία.', 'bg': 'Символите на Дзен Таро идват от източната философия.'},
  insightsProvided: {'tr': 'Şimdiki anın mesajı, içsel engeller, meditasyon rehberliği, yaşam akışına güven.', 'en': 'Message of the present moment, inner blocks, meditation guidance, trust in life\'s flow.', 'fr': 'Message du moment présent, blocages intérieurs, guidance de méditation.', 'de': 'Botschaft des Augenblicks, innere Blockaden, Meditationsführung.', 'es': 'Mensaje del momento presente, bloqueos internos, guía de meditación.', 'ru': 'Послание настоящего момента, внутренние блоки, медитативное руководство.', 'ar': 'رسالة اللحظة الحالية، العوائق الداخلية، توجيه التأمل.', 'zh': '当下的信息、内在障碍、冥想指导。', 'el': 'Μήνυμα του παρόντος, εσωτερικά μπλοκαρίσματα, καθοδήγηση διαλογισμού.', 'bg': 'Послание на настоящия момент, вътрешни блокажи, медитативно ръководство.'},
  commonMotivations: {'tr': ['Meditasyon derinleştirme', 'İçsel huzur arayışı', 'Zihinsel netlik', 'Spiritüel gelişim'], 'en': ['Deepening meditation', 'Seeking inner peace', 'Mental clarity', 'Spiritual development'], 'fr': ['Approfondir la méditation'], 'de': ['Meditation vertiefen'], 'es': ['Profundizar la meditación'], 'ru': ['Углубление медитации'], 'ar': ['تعميق التأمل'], 'zh': ['深化冥想'], 'el': ['Εμβάθυνση διαλογισμού'], 'bg': ['Задълбочаване на медитацията']},
  lifeThemes: {'tr': ['Farkındalık', 'Kabul', 'Bırakma', 'Şimdiki an', 'İçsel yolculuk'], 'en': ['Awareness', 'Acceptance', 'Letting go', 'Present moment', 'Inner journey'], 'fr': ['Conscience', 'Acceptation'], 'de': ['Bewusstsein', 'Akzeptanz'], 'es': ['Conciencia', 'Aceptación'], 'ru': ['Осознанность', 'Принятие'], 'ar': ['الوعي', 'القبول'], 'zh': ['觉知', '接纳'], 'el': ['Επίγνωση', 'Αποδοχή'], 'bg': ['Осъзнатост', 'Приемане']},
  whatYouReceive: {'tr': '• Şimdiki an okuması\n• Zen öğretisi bağlamında yorum\n• Meditasyon önerisi\n• İçsel farkındalık egzersizi', 'en': '• Present moment reading\n• Interpretation in context of Zen teachings\n• Meditation suggestion\n• Inner awareness exercise', 'fr': '• Lecture du moment présent...', 'de': '• Momentan-Lesung...', 'es': '• Lectura del momento presente...', 'ru': '• Чтение настоящего момента...', 'ar': '• قراءة اللحظة الحالية...', 'zh': '• 当下解读...', 'el': '• Ανάγνωση του παρόντος...', 'bg': '• Четене на настоящия момент...'},
  perspectiveGained: {'tr': 'Zihinsel gürültüyü susturarak içsel netliğe ulaşırsınız.', 'en': 'You reach inner clarity by silencing mental noise.', 'fr': 'Vous atteignez la clarté intérieure en faisant taire le bruit mental.', 'de': 'Sie erreichen innere Klarheit, indem Sie den mentalen Lärm zum Schweigen bringen.', 'es': 'Alcanzas claridad interior silenciando el ruido mental.', 'ru': 'Вы достигаете внутренней ясности, заглушая ментальный шум.', 'ar': 'تصل إلى الوضوح الداخلي بإسكات الضجيج الذهني.', 'zh': '通过平息心理噪音，您达到内在清明。', 'el': 'Φτάνετε σε εσωτερική διαύγεια σιωπώντας τον νοητικό θόρυβο.', 'bg': 'Достигате вътрешна яснота, заглушавайки умствения шум.'},
  reflectionPoints: {'tr': ['Şu an ne hissediyorum?', 'Neye tutunuyorum?', 'Neyi bırakmam gerekiyor?'], 'en': ['What am I feeling right now?', 'What am I holding onto?', 'What do I need to let go of?'], 'fr': ['Qu\'est-ce que je ressens maintenant?'], 'de': ['Was fühle ich gerade?'], 'es': ['¿Qué estoy sintiendo ahora?'], 'ru': ['Что я чувствую сейчас?'], 'ar': ['ماذا أشعر الآن؟'], 'zh': ['我现在感觉如何？'], 'el': ['Τι νιώθω τώρα;'], 'bg': ['Какво чувствам сега?']},
  safetyDisclaimer: {'tr': '⚠️ Zen Tarot spiritüel farkındalık aracıdır, psikolojik tedavi yerine geçmez. Eğlence ve meditasyon amaçlıdır.', 'en': '⚠️ Zen Tarot is a spiritual awareness tool, it does not replace psychological treatment. It is for entertainment and meditation purposes.', 'fr': '⚠️ Le Tarot Zen est un outil de conscience spirituelle, ne remplace pas le traitement psychologique.', 'de': '⚠️ Zen Tarot ist ein spirituelles Bewusstseinswerkzeug, ersetzt keine psychologische Behandlung.', 'es': '⚠️ El Tarot Zen es una herramienta de conciencia espiritual, no reemplaza el tratamiento psicológico.', 'ru': '⚠️ Дзен Таро — инструмент духовного осознания, не заменяет психологическое лечение.', 'ar': '⚠️ تاروت الزن أداة للوعي الروحي، لا يحل محل العلاج النفسي.', 'zh': '⚠️ 禅宗塔罗是灵性觉知工具，不能替代心理治疗。', 'el': '⚠️ Το Ζεν Ταρώ είναι εργαλείο πνευματικής επίγνωσης, δεν αντικαθιστά ψυχολογική θεραπεία.', 'bg': '⚠️ Дзен Таро е инструмент за духовно осъзнаване, не заменя психологическо лечение.'},
  doesNotDo: {'tr': ['Geleceği tahmin etmez', 'Kesin cevaplar vermez', 'Psikolojik tedavi sağlamaz'], 'en': ['Does not predict the future', 'Does not give definite answers', 'Does not provide psychological treatment'], 'fr': ['Ne prédit pas l\'avenir'], 'de': ['Sagt die Zukunft nicht voraus'], 'es': ['No predice el futuro'], 'ru': ['Не предсказывает будущее'], 'ar': ['لا يتنبأ بالمستقبل'], 'zh': ['不预测未来'], 'el': ['Δεν προβλέπει το μέλλον'], 'bg': ['Не предсказва бъдещето']},
  exampleScenarios: {'tr': ['Bir kişi Zen Tarot ile "Bırakma" kartı çekerek eski bir kırgınlığı serbest bırakma zamanının geldiğini fark etti.'], 'en': ['A person drew the "Letting Go" card with Zen Tarot and realized it was time to release an old resentment.'], 'fr': ['Une personne a tiré la carte "Lâcher prise" avec le Tarot Zen.'], 'de': ['Eine Person zog die Karte "Loslassen" mit Zen Tarot.'], 'es': ['Una persona sacó la carta "Soltar" con el Tarot Zen.'], 'ru': ['Человек вытянул карту "Отпускание" с Дзен Таро.'], 'ar': ['سحب شخص بطاقة "التخلي" مع تاروت الزن.'], 'zh': ['一个人用禅宗塔罗抽到了"放下"牌。'], 'el': ['Ένα άτομο τράβηξε την κάρτα "Αφήνοντας" με το Ζεν Ταρώ.'], 'bg': ['Човек изтегли картата "Пускане" с Дзен Таро.']},
  faq: {'tr': [FAQItem(question: 'Zen Tarot normal tarottan farklı mı?', answer: 'Evet, geleceğe değil şimdiki ana odaklanır ve Zen felsefesini kullanır.'), FAQItem(question: 'Meditasyon deneyimim olmalı mı?', answer: 'Şart değil, ancak faydalı olabilir.')], 'en': [FAQItem(question: 'Is Zen Tarot different from regular tarot?', answer: 'Yes, it focuses on the present moment not the future and uses Zen philosophy.'), FAQItem(question: 'Do I need meditation experience?', answer: 'Not required, but can be beneficial.')], 'fr': [FAQItem(question: 'Le Tarot Zen est-il différent du tarot normal?', answer: 'Oui, il se concentre sur le moment présent et utilise la philosophie Zen.')], 'de': [FAQItem(question: 'Ist Zen Tarot anders als normales Tarot?', answer: 'Ja, es konzentriert sich auf den Moment und verwendet Zen-Philosophie.')], 'es': [FAQItem(question: '¿El Tarot Zen es diferente del tarot normal?', answer: 'Sí, se enfoca en el momento presente y usa filosofía Zen.')], 'ru': [FAQItem(question: 'Дзен Таро отличается от обычного таро?', answer: 'Да, оно фокусируется на настоящем моменте и использует философию Дзен.')], 'ar': [FAQItem(question: 'هل تاروت الزن مختلف عن التاروت العادي؟', answer: 'نعم، يركز على اللحظة الحالية ويستخدم فلسفة الزن.')], 'zh': [FAQItem(question: '禅宗塔罗与普通塔罗不同吗？', answer: '是的，它专注于当下而非未来，并使用禅宗哲学。')], 'el': [FAQItem(question: 'Είναι το Ζεν Ταρώ διαφορετικό από το κανονικό ταρώ;', answer: 'Ναι, επικεντρώνεται στο παρόν και χρησιμοποιεί φιλοσοφία Ζεν.')], 'bg': [FAQItem(question: 'Дзен Таро различно ли е от обикновеното таро?', answer: 'Да, фокусира се върху настоящия момент и използва Дзен философия.')]},
  relatedPractices: {'tr': ['Meditasyon', 'Mindfulness', 'Zen Budizm'], 'en': ['Meditation', 'Mindfulness', 'Zen Buddhism'], 'fr': ['Méditation', 'Pleine conscience', 'Bouddhisme Zen'], 'de': ['Meditation', 'Achtsamkeit', 'Zen-Buddhismus'], 'es': ['Meditación', 'Mindfulness', 'Budismo Zen'], 'ru': ['Медитация', 'Осознанность', 'Дзен-буддизм'], 'ar': ['التأمل', 'اليقظة الذهنية', 'بوذية الزن'], 'zh': ['冥想', '正念', '禅宗佛教'], 'el': ['Διαλογισμός', 'Mindfulness', 'Ζεν Βουδισμός'], 'bg': ['Медитация', 'Осъзнатост', 'Дзен будизъм']},
  differenceFromSimilar: {'tr': 'Zen Tarot şimdiki ana odaklanır; geleneksel tarot geçmiş-şimdi-gelecek zaman çizgisi kullanır.', 'en': 'Zen Tarot focuses on the present moment; traditional tarot uses past-present-future timeline.', 'fr': 'Le Tarot Zen se concentre sur le présent; le tarot traditionnel utilise le passé-présent-futur.', 'de': 'Zen Tarot konzentriert sich auf den Moment; traditionelles Tarot nutzt Vergangenheit-Gegenwart-Zukunft.', 'es': 'El Tarot Zen se enfoca en el presente; el tarot tradicional usa pasado-presente-futuro.', 'ru': 'Дзен Таро фокусируется на настоящем; традиционное таро использует прошлое-настоящее-будущее.', 'ar': 'تاروت الزن يركز على الحاضر؛ التاروت التقليدي يستخدم الماضي-الحاضر-المستقبل.', 'zh': '禅宗塔罗专注于当下；传统塔罗使用过去-现在-未来时间线。', 'el': 'Το Ζεν Ταρώ επικεντρώνεται στο παρόν· το παραδοσιακό ταρώ χρησιμοποιεί παρελθόν-παρόν-μέλλον.', 'bg': 'Дзен Таро се фокусира върху настоящето; традиционното таро използва минало-настояще-бъдеще.'},
  microLearning: {'tr': ['💡 Zen\'de önemli olan kart değil, farkındalıktır.', '💡 Her kart meditasyon için bir kapıdır.', '💡 "Sorma, sadece ol" - Zen ilkesi.'], 'en': ['💡 In Zen, awareness is important, not the card.', '💡 Each card is a door for meditation.', '💡 "Don\'t ask, just be" - Zen principle.'], 'fr': ['💡 En Zen, la conscience est importante, pas la carte.'], 'de': ['💡 Im Zen ist Bewusstsein wichtig, nicht die Karte.'], 'es': ['💡 En Zen, la conciencia es importante, no la carta.'], 'ru': ['💡 В Дзен важно осознание, а не карта.'], 'ar': ['💡 في الزن، الوعي مهم، وليس البطاقة.'], 'zh': ['💡 在禅宗中，重要的是觉知，而非牌本身。'], 'el': ['💡 Στο Ζεν, η επίγνωση είναι σημαντική, όχι η κάρτα.'], 'bg': ['💡 В Дзен осъзнаването е важно, а не картата.']},
);

// ═══════════════════════════════════════════════════════════════════════════════
// ASTROLOGY - SINGLE QUESTION (HORARY)
// ═══════════════════════════════════════════════════════════════════════════════

final astrologySingleQuestion = ServiceContent(
  id: 'astrology_single_question',
  category: ServiceCategory.astrology,
  icon: '❓',
  displayOrder: 6,
  name: {
    'tr': 'Soru Astrolojisi (Horary)',
    'en': 'Horary Astrology (Single Question)',
    'fr': 'Astrologie Horaire (Question Unique)',
    'de': 'Stundenastrologie (Einzelfrage)',
    'es': 'Astrología Horaria (Pregunta Única)',
    'ru': 'Хорарная Астрология (Один Вопрос)',
    'ar': 'علم الفلك الساعي (سؤال واحد)',
    'zh': '卜卦占星（单一问题）',
    'el': 'Ωριαία Αστρολογία (Μονή Ερώτηση)',
    'bg': 'Хорарна Астрология (Един Въпрос)',
  },
  shortDescription: {
    'tr': 'Belirli bir sorunuza astrolojik metodlarla içgörü kazanın.',
    'en': 'Gain insight into your specific question through astrological methods.',
    'fr': 'Obtenez des aperçus sur votre question spécifique par des méthodes astrologiques.',
    'de': 'Gewinnen Sie Einblick in Ihre spezifische Frage durch astrologische Methoden.',
    'es': 'Obtén perspectiva sobre tu pregunta específica mediante métodos astrológicos.',
    'ru': 'Получите понимание вашего конкретного вопроса через астрологические методы.',
    'ar': 'احصل على رؤية لسؤالك المحدد من خلال الطرق الفلكية.',
    'zh': '通过占星方法获得对您具体问题的洞察。',
    'el': 'Αποκτήστε εικόνα για τη συγκεκριμένη ερώτησή σας μέσω αστρολογικών μεθόδων.',
    'bg': 'Получете прозрение за конкретния си въпрос чрез астрологични методи.',
  },
  coreExplanation: {
    'tr': 'Horary Astroloji, belirli bir sorunun sorulduğu ana ait haritayı analiz eder. "Bu işi kabul etmeli miyim?", "Kayıp eşyamı bulabilir miyim?" gibi somut sorulara odaklanır. Sorunun sorulduğu anın haritası çıkarılarak gezegen konumları ve aspektler yorumlanır.',
    'en': 'Horary Astrology analyzes the chart for the moment a specific question is asked. It focuses on concrete questions like "Should I accept this job?", "Can I find my lost item?" The chart is drawn for the moment the question is asked and planetary positions and aspects are interpreted.',
    'fr': 'L\'Astrologie Horaire analyse le thème du moment où une question spécifique est posée.',
    'de': 'Die Stundenastrologie analysiert das Horoskop für den Moment, in dem eine Frage gestellt wird.',
    'es': 'La Astrología Horaria analiza la carta del momento en que se hace una pregunta específica.',
    'ru': 'Хорарная астрология анализирует карту момента, когда задаётся конкретный вопрос.',
    'ar': 'يحلل علم الفلك الساعي خريطة اللحظة التي يُطرح فيها سؤال محدد.',
    'zh': '卜卦占星分析提出具体问题时刻的星盘。',
    'el': 'Η Ωριαία Αστρολογία αναλύει το χάρτη της στιγμής που τίθεται μια συγκεκριμένη ερώτηση.',
    'bg': 'Хорарната астрология анализира картата за момента, когато е зададен конкретен въпрос.',
  },
  historicalBackground: {'tr': 'Horary Astroloji Orta Çağ Avrupa\'sında gelişti. 17. yüzyılda William Lilly gibi astrologlar bu tekniği sistematize etti.', 'en': 'Horary Astrology developed in Medieval Europe. In the 17th century, astrologers like William Lilly systematized this technique.', 'fr': 'L\'Astrologie Horaire s\'est développée dans l\'Europe médiévale.', 'de': 'Die Stundenastrologie entwickelte sich im mittelalterlichen Europa.', 'es': 'La Astrología Horaria se desarrolló en la Europa medieval.', 'ru': 'Хорарная астрология развилась в средневековой Европе.', 'ar': 'تطور علم الفلك الساعي في أوروبا في العصور الوسطى.', 'zh': '卜卦占星在中世纪欧洲发展起来。', 'el': 'Η Ωριαία Αστρολογία αναπτύχθηκε στη μεσαιωνική Ευρώπη.', 'bg': 'Хорарната астрология се развива в средновековна Европа.'},
  philosophicalFoundation: {'tr': 'Soru sorulduğu an kozmosla uyumlu bir bağlantı kurulur ve cevap o anın haritasında kodlanmıştır.', 'en': 'At the moment a question is asked, a harmonious connection is made with the cosmos and the answer is encoded in that moment\'s chart.', 'fr': 'Au moment où une question est posée, une connexion harmonieuse avec le cosmos est établie.', 'de': 'Im Moment der Frage wird eine harmonische Verbindung mit dem Kosmos hergestellt.', 'es': 'En el momento de hacer la pregunta, se establece una conexión armónica con el cosmos.', 'ru': 'В момент вопроса устанавливается гармоничная связь с космосом.', 'ar': 'في لحظة طرح السؤال، يتم إنشاء اتصال متناغم مع الكون.', 'zh': '在提出问题的时刻，与宇宙建立和谐的联系。', 'el': 'Τη στιγμή που τίθεται μια ερώτηση, δημιουργείται μια αρμονική σύνδεση με τον κόσμο.', 'bg': 'В момента на въпроса се установява хармонична връзка с космоса.'},
  howItWorks: {'tr': '1. Sorunuz net bir şekilde formüle edilir\n2. Sorunun sorulduğu anın haritası çıkarılır\n3. Ev sistemleri ve gezegenler analiz edilir\n4. Aspektler ve işaretler yorumlanır', 'en': '1. Your question is clearly formulated\n2. Chart for the moment of question is drawn\n3. House systems and planets are analyzed\n4. Aspects and signs are interpreted', 'fr': '1. Votre question est clairement formulée...', 'de': '1. Ihre Frage wird klar formuliert...', 'es': '1. Su pregunta se formula claramente...', 'ru': '1. Ваш вопрос чётко формулируется...', 'ar': '1. يتم صياغة سؤالك بوضوح...', 'zh': '1. 您的问题被清晰地表述...', 'el': '1. Η ερώτησή σας διατυπώνεται καθαρά...', 'bg': '1. Вашият въпрос е ясно формулиран...'},
  symbolicInterpretation: {'tr': 'Ay soruyu soran kişiyi, 7. ev karşı tarafı temsil eder. Gezegen aspektleri sonucu gösterir.', 'en': 'Moon represents the person asking, 7th house represents the other party. Planetary aspects show the outcome.', 'fr': 'La Lune représente la personne qui demande, la 7e maison représente l\'autre partie.', 'de': 'Der Mond repräsentiert den Fragenden, das 7. Haus die andere Partei.', 'es': 'La Luna representa al que pregunta, la casa 7 representa a la otra parte.', 'ru': 'Луна представляет спрашивающего, 7-й дом — другую сторону.', 'ar': 'القمر يمثل السائل، البيت السابع يمثل الطرف الآخر.', 'zh': '月亮代表提问者，第七宫代表另一方。', 'el': 'Η Σελήνη αντιπροσωπεύει τον ερωτώντα, ο 7ος οίκος την άλλη πλευρά.', 'bg': 'Луната представлява питащия, 7-мият дом — другата страна.'},
  insightsProvided: {'tr': 'Belirli bir durumun potansiyel sonucu, zamanlama ipuçları, dikkat edilmesi gereken faktörler.', 'en': 'Potential outcome of a specific situation, timing clues, factors to consider.', 'fr': 'Résultat potentiel d\'une situation spécifique, indices de timing.', 'de': 'Potenzielles Ergebnis einer spezifischen Situation, Timing-Hinweise.', 'es': 'Resultado potencial de una situación específica, pistas de tiempo.', 'ru': 'Потенциальный результат конкретной ситуации, подсказки о времени.', 'ar': 'النتيجة المحتملة لموقف معين، إشارات التوقيت.', 'zh': '特定情况的潜在结果，时机线索。', 'el': 'Πιθανό αποτέλεσμα μιας συγκεκριμένης κατάστασης, ενδείξεις χρονισμού.', 'bg': 'Потенциален резултат от конкретна ситуация, указания за времето.'},
  commonMotivations: {'tr': ['Belirli bir kararda rehberlik', 'Kayıp eşya sorusu', 'İş ve kariyer kararları', 'İlişki soruları'], 'en': ['Guidance on a specific decision', 'Lost item questions', 'Work and career decisions', 'Relationship questions'], 'fr': ['Orientation sur une décision spécifique'], 'de': ['Führung bei einer spezifischen Entscheidung'], 'es': ['Orientación sobre una decisión específica'], 'ru': ['Руководство по конкретному решению'], 'ar': ['توجيه بشأن قرار محدد'], 'zh': ['关于特定决定的指导'], 'el': ['Καθοδήγηση σε μια συγκεκριμένη απόφαση'], 'bg': ['Ръководство за конкретно решение']},
  lifeThemes: {'tr': ['Kariyer kararları', 'İlişki soruları', 'Finansal durumlar', 'Sağlık endişeleri'], 'en': ['Career decisions', 'Relationship questions', 'Financial situations', 'Health concerns'], 'fr': ['Décisions de carrière'], 'de': ['Karriereentscheidungen'], 'es': ['Decisiones de carrera'], 'ru': ['Карьерные решения'], 'ar': ['قرارات مهنية'], 'zh': ['职业决定'], 'el': ['Αποφάσεις καριέρας'], 'bg': ['Кариерни решения']},
  whatYouReceive: {'tr': '• Horary harita analizi\n• Soru odaklı yorum\n• Zamanlama ipuçları\n• Olası sonuçların değerlendirmesi', 'en': '• Horary chart analysis\n• Question-focused interpretation\n• Timing clues\n• Assessment of possible outcomes', 'fr': '• Analyse du thème horaire...', 'de': '• Stundenhoroskop-Analyse...', 'es': '• Análisis de carta horaria...', 'ru': '• Анализ хорарной карты...', 'ar': '• تحليل الخريطة الساعية...', 'zh': '• 卜卦星盘分析...', 'el': '• Ανάλυση ωριαίου χάρτη...', 'bg': '• Анализ на хорарна карта...'},
  perspectiveGained: {'tr': 'Belirli bir sorunuz hakkında astrolojik perspektif kazanırsınız.', 'en': 'You gain astrological perspective on your specific question.', 'fr': 'Vous gagnez une perspective astrologique sur votre question spécifique.', 'de': 'Sie gewinnen eine astrologische Perspektive auf Ihre spezifische Frage.', 'es': 'Ganas una perspectiva astrológica sobre tu pregunta específica.', 'ru': 'Вы получаете астрологическую перспективу на ваш конкретный вопрос.', 'ar': 'تكتسب منظوراً فلكياً لسؤالك المحدد.', 'zh': '您获得对具体问题的占星视角。', 'el': 'Αποκτάτε αστρολογική προοπτική για τη συγκεκριμένη ερώτησή σας.', 'bg': 'Придобивате астрологична перспектива за конкретния си въпрос.'},
  reflectionPoints: {'tr': ['Sorumdaki temel endişe ne?', 'Olası sonuçlara nasıl hazırlanabilirim?'], 'en': ['What is the core concern in my question?', 'How can I prepare for possible outcomes?'], 'fr': ['Quelle est la préoccupation principale de ma question?'], 'de': ['Was ist das Hauptanliegen meiner Frage?'], 'es': ['¿Cuál es la preocupación principal de mi pregunta?'], 'ru': ['Какова основная забота в моём вопросе?'], 'ar': ['ما هو القلق الأساسي في سؤالي؟'], 'zh': ['我问题的核心关注是什么？'], 'el': ['Ποια είναι η κύρια ανησυχία στην ερώτησή μου;'], 'bg': ['Каква е основната загриженост в въпроса ми?']},
  safetyDisclaimer: {'tr': '⚠️ Horary Astroloji eğlence amaçlıdır. Kesin olayları tahmin etmez ve önemli kararlarda profesyonel danışmanlık alınmalıdır.', 'en': '⚠️ Horary Astrology is for entertainment purposes. It does not predict exact events and professional advice should be sought for important decisions.', 'fr': '⚠️ L\'Astrologie Horaire est à des fins de divertissement.', 'de': '⚠️ Stundenastrologie dient der Unterhaltung.', 'es': '⚠️ La Astrología Horaria es con fines de entretenimiento.', 'ru': '⚠️ Хорарная астрология предназначена для развлечения.', 'ar': '⚠️ علم الفلك الساعي هو لأغراض الترفيه.', 'zh': '⚠️ 卜卦占星仅供娱乐目的。', 'el': '⚠️ Η Ωριαία Αστρολογία είναι για ψυχαγωγία.', 'bg': '⚠️ Хорарната астрология е за забавление.'},
  doesNotDo: {'tr': ['Kesin olayları garanti etmez', 'Tıbbi veya hukuki tavsiye vermez'], 'en': ['Does not guarantee exact events', 'Does not give medical or legal advice'], 'fr': ['Ne garantit pas des événements exacts'], 'de': ['Garantiert keine genauen Ereignisse'], 'es': ['No garantiza eventos exactos'], 'ru': ['Не гарантирует точные события'], 'ar': ['لا يضمن أحداثاً دقيقة'], 'zh': ['不保证确切事件'], 'el': ['Δεν εγγυάται ακριβή γεγονότα'], 'bg': ['Не гарантира точни събития']},
  exampleScenarios: {'tr': ['Bir kişi iş teklifini kabul edip etmemek konusunda horary okuması yaptırdı.'], 'en': ['A person had a horary reading about whether to accept a job offer.'], 'fr': ['Une personne a fait une lecture horaire sur l\'acceptation d\'une offre d\'emploi.'], 'de': ['Eine Person hatte eine Stundenlesung über die Annahme eines Jobangebots.'], 'es': ['Una persona tuvo una lectura horaria sobre aceptar una oferta de trabajo.'], 'ru': ['Человек сделал хорарное чтение о принятии предложения работы.'], 'ar': ['قام شخص بقراءة ساعية حول قبول عرض عمل.'], 'zh': ['一个人做了关于是否接受工作邀请的卜卦解读。'], 'el': ['Ένα άτομο έκανε ωριαία ανάγνωση για την αποδοχή προσφοράς εργασίας.'], 'bg': ['Човек направи хорарно четене относно приемане на предложение за работа.']},
  faq: {'tr': [FAQItem(question: 'Hangi sorular uygun değildir?', answer: 'Test amaçlı sorular, çok genel sorular veya aynı anda birden fazla soru.')], 'en': [FAQItem(question: 'What questions are not suitable?', answer: 'Test questions, very general questions, or multiple questions at once.')], 'fr': [FAQItem(question: 'Quelles questions ne sont pas appropriées?', answer: 'Questions de test, questions très générales.')], 'de': [FAQItem(question: 'Welche Fragen sind nicht geeignet?', answer: 'Testfragen, sehr allgemeine Fragen.')], 'es': [FAQItem(question: '¿Qué preguntas no son apropiadas?', answer: 'Preguntas de prueba, preguntas muy generales.')], 'ru': [FAQItem(question: 'Какие вопросы не подходят?', answer: 'Тестовые вопросы, очень общие вопросы.')], 'ar': [FAQItem(question: 'ما الأسئلة غير المناسبة؟', answer: 'أسئلة اختبار، أسئلة عامة جداً.')], 'zh': [FAQItem(question: '哪些问题不适合？', answer: '测试问题，非常笼统的问题。')], 'el': [FAQItem(question: 'Ποιες ερωτήσεις δεν είναι κατάλληλες;', answer: 'Ερωτήσεις δοκιμής, πολύ γενικές ερωτήσεις.')], 'bg': [FAQItem(question: 'Кои въпроси не са подходящи?', answer: 'Тестови въпроси, много общи въпроси.')]},
  relatedPractices: {'tr': ['Doğum Haritası', 'Elektif Astroloji'], 'en': ['Birth Chart', 'Electional Astrology'], 'fr': ['Thème Natal', 'Astrologie Élective'], 'de': ['Geburtshoroskop', 'Elektive Astrologie'], 'es': ['Carta Natal', 'Astrología Electiva'], 'ru': ['Натальная Карта', 'Элективная Астрология'], 'ar': ['خريطة الميلاد', 'علم الفلك الانتخابي'], 'zh': ['出生图', '择日占星'], 'el': ['Γενέθλιος Χάρτης', 'Εκλεκτική Αστρολογία'], 'bg': ['Рождена Карта', 'Елективна Астрология']},
  differenceFromSimilar: {'tr': 'Horary belirli bir soruya odaklanır; doğum haritası kişinin genel karakterini gösterir.', 'en': 'Horary focuses on a specific question; birth chart shows person\'s general character.', 'fr': 'L\'horaire se concentre sur une question spécifique; le thème natal montre le caractère général.', 'de': 'Stunden fokussiert auf eine spezifische Frage; Geburtshoroskop zeigt allgemeinen Charakter.', 'es': 'La horaria se enfoca en una pregunta específica; la carta natal muestra el carácter general.', 'ru': 'Хорар фокусируется на конкретном вопросе; натальная карта показывает общий характер.', 'ar': 'الساعي يركز على سؤال محدد؛ خريطة الميلاد تُظهر الشخصية العامة.', 'zh': '卜卦专注于具体问题；出生图显示一般性格。', 'el': 'Η ωριαία εστιάζει σε συγκεκριμένη ερώτηση· ο γενέθλιος χάρτης δείχνει τον γενικό χαρακτήρα.', 'bg': 'Хорарната се фокусира върху конкретен въпрос; рождената карта показва общия характер.'},
  microLearning: {'tr': ['💡 Horary\'de sorunun net olması çok önemlidir.', '💡 Aynı soruyu tekrar sormak önerilmez.'], 'en': ['💡 In horary, having a clear question is very important.', '💡 Asking the same question again is not recommended.'], 'fr': ['💡 En horaire, avoir une question claire est très important.'], 'de': ['💡 Bei Stundenastrologie ist eine klare Frage sehr wichtig.'], 'es': ['💡 En horaria, tener una pregunta clara es muy importante.'], 'ru': ['💡 В хораре чёткий вопрос очень важен.'], 'ar': ['💡 في الساعي، السؤال الواضح مهم جداً.'], 'zh': ['💡 在卜卦中，问题清晰非常重要。'], 'el': ['💡 Στην ωριαία, η σαφής ερώτηση είναι πολύ σημαντική.'], 'bg': ['💡 В хорара ясният въпрос е много важен.']},
);

// ═══════════════════════════════════════════════════════════════════════════════
// ASTROLOGY - ASTROCARTOGRAPHY
// ═══════════════════════════════════════════════════════════════════════════════

final astrologyAstrocartography = ServiceContent(
  id: 'astrology_astrocartography',
  category: ServiceCategory.astrology,
  icon: '🗺️',
  displayOrder: 7,
  name: {
    'tr': 'Astrokartografi (Lokasyon Astrolojisi)',
    'en': 'Astrocartography (Location Astrology)',
    'fr': 'Astrocartographie (Astrologie de Localisation)',
    'de': 'Astrokartografie (Standort-Astrologie)',
    'es': 'Astrocartografía (Astrología de Ubicación)',
    'ru': 'Астрокартография (Локационная Астрология)',
    'ar': 'خرائطية النجوم (علم فلك الموقع)',
    'zh': '星图学（位置占星术）',
    'el': 'Αστροχαρτογράφηση (Αστρολογία Τοποθεσίας)',
    'bg': 'Астрокартография (Локационна Астрология)',
  },
  shortDescription: {
    'tr': 'Doğum haritanıza göre dünyanın farklı yerlerinde nasıl enerjiler yaşayacağınızı keşfedin.',
    'en': 'Discover what energies you would experience in different places around the world based on your birth chart.',
    'fr': 'Découvrez quelles énergies vous vivriez dans différents endroits du monde.',
    'de': 'Entdecken Sie, welche Energien Sie an verschiedenen Orten der Welt erleben würden.',
    'es': 'Descubre qué energías experimentarías en diferentes lugares del mundo.',
    'ru': 'Откройте, какие энергии вы испытаете в разных местах мира.',
    'ar': 'اكتشف ما هي الطاقات التي ستختبرها في أماكن مختلفة حول العالم.',
    'zh': '发现您在世界不同地方会体验到什么能量。',
    'el': 'Ανακαλύψτε τι ενέργειες θα βιώνατε σε διαφορετικά μέρη του κόσμου.',
    'bg': 'Открийте какви енергии бихте изпитали на различни места по света.',
  },
  coreExplanation: {
    'tr': 'Astrokartografi, doğum haritanızdaki gezegen çizgilerinin dünya haritası üzerinde nereye düştüğünü gösterir. Her gezegen çizgisi, o bölgede o gezegenin enerjisinin güçleneceğini işaret eder. Örneğin, Venüs çizginizin geçtiği yerler aşk ve güzellik için, Jüpiter çizgisi bolluk ve şans için destekleyici olabilir. Jim Lewis tarafından 1970\'lerde geliştirilen bu teknik, taşınma, seyahat ve iş kararlarında kullanılır.',
    'en': 'Astrocartography shows where the planetary lines in your birth chart fall on a world map. Each planetary line indicates that the energy of that planet will be strengthened in that region. For example, places where your Venus line passes may be supportive for love and beauty, Jupiter line for abundance and luck. Developed by Jim Lewis in the 1970s, this technique is used for relocation, travel, and business decisions.',
    'fr': 'L\'Astrocartographie montre où les lignes planétaires de votre thème natal tombent sur une carte du monde.',
    'de': 'Astrokartografie zeigt, wo die Planetenlinien Ihres Geburtshoroskops auf einer Weltkarte fallen.',
    'es': 'La Astrocartografía muestra dónde caen las líneas planetarias de tu carta natal en un mapa mundial.',
    'ru': 'Астрокартография показывает, где планетарные линии вашей карты рождения падают на карту мира.',
    'ar': 'تُظهر خرائطية النجوم أين تقع خطوط الكواكب في خريطة ميلادك على خريطة العالم.',
    'zh': '星图学显示您出生图中的行星线落在世界地图上的位置。',
    'el': 'Η Αστροχαρτογράφηση δείχνει πού πέφτουν οι πλανητικές γραμμές του χάρτη γέννησης στον παγκόσμιο χάρτη.',
    'bg': 'Астрокартографията показва къде планетарните линии на вашата карта на раждане падат на световната карта.',
  },
  historicalBackground: {'tr': 'Jim Lewis 1970\'lerde astrokartografiyi geliştirdi. Bilgisayar teknolojisiyle birlikte popülerleşti ve modern lokasyon astrolojisinin temelini oluşturdu.', 'en': 'Jim Lewis developed astrocartography in the 1970s. It became popular with computer technology and formed the basis of modern location astrology.', 'fr': 'Jim Lewis a développé l\'astrocartographie dans les années 1970.', 'de': 'Jim Lewis entwickelte die Astrokartografie in den 1970er Jahren.', 'es': 'Jim Lewis desarrolló la astrocartografía en la década de 1970.', 'ru': 'Джим Льюис разработал астрокартографию в 1970-х годах.', 'ar': 'طوّر جيم لويس خرائطية النجوم في السبعينيات.', 'zh': 'Jim Lewis 在1970年代开发了星图学。', 'el': 'Ο Jim Lewis ανέπτυξε την αστροχαρτογράφηση στη δεκαετία του 1970.', 'bg': 'Джим Люис разработи астрокартографията през 1970-те години.'},
  philosophicalFoundation: {'tr': 'Farklı coğrafi konumlar, doğum haritanızdaki gezegen enerjilerini farklı şekillerde aktive eder.', 'en': 'Different geographical locations activate the planetary energies in your birth chart in different ways.', 'fr': 'Différents emplacements géographiques activent les énergies planétaires de votre thème différemment.', 'de': 'Verschiedene geografische Standorte aktivieren die Planetenenergien Ihres Horoskops auf unterschiedliche Weise.', 'es': 'Diferentes ubicaciones geográficas activan las energías planetarias de tu carta de formas diferentes.', 'ru': 'Различные географические места активируют планетарные энергии вашей карты по-разному.', 'ar': 'المواقع الجغرافية المختلفة تنشط طاقات الكواكب في خريطتك بطرق مختلفة.', 'zh': '不同的地理位置以不同的方式激活您出生图中的行星能量。', 'el': 'Διαφορετικές γεωγραφικές τοποθεσίες ενεργοποιούν τις πλανητικές ενέργειες του χάρτη σας με διαφορετικούς τρόπους.', 'bg': 'Различните географски местоположения активират планетарните енергии в картата ви по различни начини.'},
  howItWorks: {'tr': '1. Doğum haritanız dünya haritası üzerine yansıtılır\n2. Gezegen çizgileri belirlenir (AC, DC, MC, IC)\n3. İlgilendiğiniz bölgeler analiz edilir\n4. Gezegen enerjileri yorumlanır', 'en': '1. Your birth chart is projected onto a world map\n2. Planetary lines are determined (AC, DC, MC, IC)\n3. Regions of interest are analyzed\n4. Planetary energies are interpreted', 'fr': '1. Votre thème est projeté sur une carte du monde...', 'de': '1. Ihr Horoskop wird auf eine Weltkarte projiziert...', 'es': '1. Tu carta natal se proyecta en un mapa mundial...', 'ru': '1. Ваша карта проецируется на карту мира...', 'ar': '1. تُسقط خريطة ميلادك على خريطة العالم...', 'zh': '1. 您的出生图投射到世界地图上...', 'el': '1. Ο χάρτης σας προβάλλεται σε έναν παγκόσμιο χάρτη...', 'bg': '1. Вашата карта се проектира върху карта на света...'},
  symbolicInterpretation: {'tr': 'Güneş çizgisi: Tanınma ve başarı. Ay çizgisi: Ev ve aile. Venüs: Aşk ve güzellik. Mars: Enerji ve cesaret. Jüpiter: Şans ve genişleme.', 'en': 'Sun line: Recognition and success. Moon line: Home and family. Venus: Love and beauty. Mars: Energy and courage. Jupiter: Luck and expansion.', 'fr': 'Ligne du Soleil: Reconnaissance et succès. Ligne de la Lune: Maison et famille.', 'de': 'Sonnenlinie: Anerkennung und Erfolg. Mondlinie: Heim und Familie.', 'es': 'Línea del Sol: Reconocimiento y éxito. Línea de la Luna: Hogar y familia.', 'ru': 'Линия Солнца: Признание и успех. Линия Луны: Дом и семья.', 'ar': 'خط الشمس: الاعتراف والنجاح. خط القمر: المنزل والعائلة.', 'zh': '太阳线：认可和成功。月亮线：家和家庭。', 'el': 'Γραμμή Ήλιου: Αναγνώριση και επιτυχία. Γραμμή Σελήνης: Σπίτι και οικογένεια.', 'bg': 'Слънчева линия: Признание и успех. Лунна линия: Дом и семейство.'},
  insightsProvided: {'tr': 'En uygun yaşam yerleri, kariyer için ideal lokasyonlar, aşk için destekleyici bölgeler, kaçınılması gereken alanlar.', 'en': 'Best places to live, ideal locations for career, supportive regions for love, areas to avoid.', 'fr': 'Meilleurs endroits pour vivre, emplacements idéaux pour la carrière.', 'de': 'Beste Wohnorte, ideale Karrierestandorte.', 'es': 'Mejores lugares para vivir, ubicaciones ideales para la carrera.', 'ru': 'Лучшие места для жизни, идеальные места для карьеры.', 'ar': 'أفضل الأماكن للعيش، المواقع المثالية للمهنة.', 'zh': '最适合居住的地方，理想的职业地点。', 'el': 'Καλύτερα μέρη για να ζήσετε, ιδανικές τοποθεσίες για καριέρα.', 'bg': 'Най-добри места за живеене, идеални места за кариера.'},
  commonMotivations: {'tr': ['Taşınma kararı', 'Seyahat planlaması', 'İş yeri seçimi', 'Emeklilik lokasyonu'], 'en': ['Relocation decision', 'Travel planning', 'Business location choice', 'Retirement location'], 'fr': ['Décision de déménagement'], 'de': ['Umzugsentscheidung'], 'es': ['Decisión de mudanza'], 'ru': ['Решение о переезде'], 'ar': ['قرار الانتقال'], 'zh': ['搬迁决定'], 'el': ['Απόφαση μετεγκατάστασης'], 'bg': ['Решение за преместване']},
  lifeThemes: {'tr': ['Kariyer', 'Aşk', 'Sağlık', 'Zenginlik', 'Kişisel gelişim'], 'en': ['Career', 'Love', 'Health', 'Wealth', 'Personal development'], 'fr': ['Carrière', 'Amour'], 'de': ['Karriere', 'Liebe'], 'es': ['Carrera', 'Amor'], 'ru': ['Карьера', 'Любовь'], 'ar': ['مهنة', 'حب'], 'zh': ['事业', '爱情'], 'el': ['Καριέρα', 'Αγάπη'], 'bg': ['Кариера', 'Любов']},
  whatYouReceive: {'tr': '• Kişisel astrokartografi haritası\n• Gezegen çizgilerinin yorumu\n• İlgilendiğiniz bölgelerin analizi\n• Lokasyon önerileri', 'en': '• Personal astrocartography map\n• Interpretation of planetary lines\n• Analysis of regions of interest\n• Location recommendations', 'fr': '• Carte d\'astrocartographie personnelle...', 'de': '• Persönliche Astrokartografie-Karte...', 'es': '• Mapa de astrocartografía personal...', 'ru': '• Персональная астрокартографическая карта...', 'ar': '• خريطة النجوم الشخصية...', 'zh': '• 个人星图...', 'el': '• Προσωπικός χάρτης αστροχαρτογράφησης...', 'bg': '• Лична астрокартографска карта...'},
  perspectiveGained: {'tr': 'Dünya haritasında sizin için en destekleyici ve zorlayıcı bölgeleri keşfedersiniz.', 'en': 'You discover the most supportive and challenging regions for you on the world map.', 'fr': 'Vous découvrez les régions les plus favorables et difficiles pour vous sur la carte du monde.', 'de': 'Sie entdecken die unterstützendsten und herausforderndsten Regionen für Sie auf der Weltkarte.', 'es': 'Descubres las regiones más favorables y desafiantes para ti en el mapa mundial.', 'ru': 'Вы откроете самые благоприятные и сложные регионы для вас на карте мира.', 'ar': 'تكتشف المناطق الأكثر دعماً وتحدياً لك على خريطة العالم.', 'zh': '您在世界地图上发现对您最有支持和挑战的地区。', 'el': 'Ανακαλύπτετε τις πιο υποστηρικτικές και απαιτητικές περιοχές για εσάς στον παγκόσμιο χάρτη.', 'bg': 'Откривате най-подкрепящите и предизвикателни региони за вас на световната карта.'},
  reflectionPoints: {'tr': ['Hangi şehirlerde kendimi iyi hissediyorum?', 'Nereye taşınmayı veya seyahat etmeyi düşünüyorum?'], 'en': ['In which cities do I feel good?', 'Where am I considering moving or traveling to?'], 'fr': ['Dans quelles villes est-ce que je me sens bien?'], 'de': ['In welchen Städten fühle ich mich wohl?'], 'es': ['¿En qué ciudades me siento bien?'], 'ru': ['В каких городах я чувствую себя хорошо?'], 'ar': ['في أي مدن أشعر بالراحة؟'], 'zh': ['在哪些城市我感觉良好？'], 'el': ['Σε ποιες πόλεις αισθάνομαι καλά;'], 'bg': ['В кои градове се чувствам добре?']},
  safetyDisclaimer: {'tr': '⚠️ Astrokartografi eğlence amaçlıdır. Taşınma veya seyahat kararlarınızı sadece astrolojiye dayandırmayın, pratik faktörleri de göz önünde bulundurun.', 'en': '⚠️ Astrocartography is for entertainment purposes. Do not base your relocation or travel decisions solely on astrology, consider practical factors as well.', 'fr': '⚠️ L\'astrocartographie est à des fins de divertissement.', 'de': '⚠️ Astrokartografie dient der Unterhaltung.', 'es': '⚠️ La astrocartografía es con fines de entretenimiento.', 'ru': '⚠️ Астрокартография предназначена для развлечения.', 'ar': '⚠️ خرائطية النجوم هي لأغراض الترفيه.', 'zh': '⚠️ 星图学仅供娱乐目的。', 'el': '⚠️ Η αστροχαρτογράφηση είναι για ψυχαγωγία.', 'bg': '⚠️ Астрокартографията е за забавление.'},
  doesNotDo: {'tr': ['Kesin olayları tahmin etmez', 'Taşınma garantisi vermez', 'Pratik faktörleri değerlendirmez'], 'en': ['Does not predict exact events', 'Does not guarantee relocation success', 'Does not evaluate practical factors'], 'fr': ['Ne prédit pas des événements exacts'], 'de': ['Sagt keine genauen Ereignisse voraus'], 'es': ['No predice eventos exactos'], 'ru': ['Не предсказывает точные события'], 'ar': ['لا يتنبأ بأحداث دقيقة'], 'zh': ['不预测确切事件'], 'el': ['Δεν προβλέπει ακριβή γεγονότα'], 'bg': ['Не предсказва точни събития']},
  exampleScenarios: {'tr': ['Bir kişi Jüpiter çizgisinin geçtiği şehre taşınarak kariyer fırsatlarının arttığını gözlemledi.'], 'en': ['A person moved to a city where their Jupiter line passes and observed increased career opportunities.'], 'fr': ['Une personne a déménagé dans une ville où passe sa ligne de Jupiter et a observé des opportunités accrues.'], 'de': ['Eine Person zog in eine Stadt, durch die ihre Jupiter-Linie verläuft, und beobachtete mehr Karrierechancen.'], 'es': ['Una persona se mudó a una ciudad donde pasa su línea de Júpiter y observó mayores oportunidades.'], 'ru': ['Человек переехал в город, где проходит его линия Юпитера, и заметил увеличение возможностей.'], 'ar': ['انتقل شخص إلى مدينة يمر فيها خط المشتري ولاحظ زيادة الفرص.'], 'zh': ['一个人搬到了木星线经过的城市，观察到职业机会增加。'], 'el': ['Ένα άτομο μετακόμισε σε μια πόλη όπου περνά η γραμμή του Δία και παρατήρησε αυξημένες ευκαιρίες.'], 'bg': ['Човек се премести в град, където минава линията на Юпитер, и наблюдава увеличени възможности.']},
  faq: {'tr': [FAQItem(question: 'Gezegen çizgisinin tam üzerinde mi yaşamalıyım?', answer: 'Hayır, yaklaşık 700 km yarıçapında etki hissedilir.'), FAQItem(question: 'Zor gezegen çizgilerinden kaçınmalı mıyım?', answer: 'Her çizgi büyüme fırsatı sunar, mutlak iyi veya kötü yoktur.')], 'en': [FAQItem(question: 'Do I need to live exactly on the planetary line?', answer: 'No, the effect is felt within approximately 700km radius.'), FAQItem(question: 'Should I avoid difficult planetary lines?', answer: 'Every line offers growth opportunities, there is no absolute good or bad.')], 'fr': [FAQItem(question: 'Dois-je vivre exactement sur la ligne planétaire?', answer: 'Non, l\'effet se fait sentir dans un rayon d\'environ 700 km.')], 'de': [FAQItem(question: 'Muss ich genau auf der Planetenlinie leben?', answer: 'Nein, die Wirkung wird in etwa 700 km Radius gespürt.')], 'es': [FAQItem(question: '¿Necesito vivir exactamente en la línea planetaria?', answer: 'No, el efecto se siente en un radio de aproximadamente 700 km.')], 'ru': [FAQItem(question: 'Нужно ли жить точно на планетарной линии?', answer: 'Нет, эффект ощущается в радиусе примерно 700 км.')], 'ar': [FAQItem(question: 'هل يجب أن أعيش على خط الكوكب بالضبط؟', answer: 'لا، يُشعر بالتأثير في دائرة نصف قطرها حوالي 700 كم.')], 'zh': [FAQItem(question: '我需要住在行星线上吗？', answer: '不，效果在大约700公里半径内感受到。')], 'el': [FAQItem(question: 'Πρέπει να ζω ακριβώς στην πλανητική γραμμή;', answer: 'Όχι, η επίδραση γίνεται αισθητή σε ακτίνα περίπου 700 χλμ.')], 'bg': [FAQItem(question: 'Трябва ли да живея точно на планетарната линия?', answer: 'Не, ефектът се усеща в радиус от около 700 км.')]},
  relatedPractices: {'tr': ['Doğum Haritası', 'Yıllık Tahmin', 'Lokasyon Danışmanlığı'], 'en': ['Birth Chart', 'Annual Forecast', 'Location Consulting'], 'fr': ['Thème Natal', 'Prévisions Annuelles'], 'de': ['Geburtshoroskop', 'Jahresvorhersage'], 'es': ['Carta Natal', 'Pronóstico Anual'], 'ru': ['Натальная Карта', 'Годовой Прогноз'], 'ar': ['خريطة الميلاد', 'التوقعات السنوية'], 'zh': ['出生图', '年度预测'], 'el': ['Γενέθλιος Χάρτης', 'Ετήσια Πρόβλεψη'], 'bg': ['Рождена Карта', 'Годишна Прогноза']},
  differenceFromSimilar: {'tr': 'Astrokartografi coğrafi konumlara odaklanır; doğum haritası genel kişilik ve yaşam temalarını gösterir.', 'en': 'Astrocartography focuses on geographical locations; birth chart shows general personality and life themes.', 'fr': 'L\'astrocartographie se concentre sur les emplacements géographiques.', 'de': 'Astrokartografie konzentriert sich auf geografische Standorte.', 'es': 'La astrocartografía se enfoca en ubicaciones geográficas.', 'ru': 'Астрокартография фокусируется на географических местах.', 'ar': 'تركز خرائطية النجوم على المواقع الجغرافية.', 'zh': '星图学专注于地理位置。', 'el': 'Η αστροχαρτογράφηση εστιάζει σε γεωγραφικές τοποθεσίες.', 'bg': 'Астрокартографията се фокусира върху географски местоположения.'},
  microLearning: {'tr': ['💡 AC çizgisi kendinizi ifade ettiğiniz yerleri gösterir.', '💡 MC çizgisi kariyer başarısı için güçlü bölgeleri gösterir.', '💡 Venüs çizgisi romantizm için ideal yerleri işaret eder.'], 'en': ['💡 AC line shows places where you express yourself.', '💡 MC line shows strong regions for career success.', '💡 Venus line indicates ideal places for romance.'], 'fr': ['💡 La ligne AC montre les endroits où vous vous exprimez.'], 'de': ['💡 AC-Linie zeigt Orte, an denen Sie sich ausdrücken.'], 'es': ['💡 La línea AC muestra lugares donde te expresas.'], 'ru': ['💡 Линия AC показывает места, где вы выражаете себя.'], 'ar': ['💡 خط AC يُظهر الأماكن التي تعبر فيها عن نفسك.'], 'zh': ['💡 AC线显示您表达自己的地方。'], 'el': ['💡 Η γραμμή AC δείχνει τόπους όπου εκφράζεστε.'], 'bg': ['💡 Линията AC показва места, където се изразявате.']},
);

// ═══════════════════════════════════════════════════════════════════════════════
// ASTROLOGY - BIRTH TIME RECTIFICATION
// ═══════════════════════════════════════════════════════════════════════════════

final astrologyRectification = ServiceContent(
  id: 'astrology_rectification',
  category: ServiceCategory.astrology,
  icon: '⏰',
  displayOrder: 8,
  name: {
    'tr': 'Doğum Saati Rektifikasyonu',
    'en': 'Birth Time Rectification',
    'fr': 'Rectification de l\'Heure de Naissance',
    'de': 'Geburtszeit-Rektifikation',
    'es': 'Rectificación de Hora de Nacimiento',
    'ru': 'Ректификация Времени Рождения',
    'ar': 'تصحيح وقت الميلاد',
    'zh': '出生时间校正',
    'el': 'Διόρθωση Ώρας Γέννησης',
    'bg': 'Ректификация на Час на Раждане',
  },
  shortDescription: {
    'tr': 'Kesin doğum saatinizi bilmiyorsanız, yaşam olaylarınızı kullanarak doğum saatinizi tahmin edin.',
    'en': 'If you don\'t know your exact birth time, estimate your birth time using your life events.',
    'fr': 'Si vous ne connaissez pas votre heure de naissance exacte, estimez-la à l\'aide de vos événements de vie.',
    'de': 'Wenn Sie Ihre genaue Geburtszeit nicht kennen, schätzen Sie sie anhand Ihrer Lebensereignisse.',
    'es': 'Si no conoces tu hora de nacimiento exacta, estímala usando tus eventos de vida.',
    'ru': 'Если вы не знаете точное время рождения, оцените его с помощью событий вашей жизни.',
    'ar': 'إذا كنت لا تعرف وقت ميلادك الدقيق، قدّره باستخدام أحداث حياتك.',
    'zh': '如果您不知道确切的出生时间，请使用您的生活事件来估计。',
    'el': 'Αν δεν γνωρίζετε την ακριβή ώρα γέννησης, εκτιμήστε την χρησιμοποιώντας τα γεγονότα της ζωής σας.',
    'bg': 'Ако не знаете точния час на раждане, оценете го, използвайки събитията от живота си.',
  },
  coreExplanation: {
    'tr': 'Doğum Saati Rektifikasyonu, kesin doğum saati bilinmediğinde yaşamdaki önemli olayları (evlilik, iş değişikliği, kaza, hastalık vb.) kullanarak doğum saatini tahmin etme tekniğidir. Astrolog, bu olayların tarihleriyle gezegen geçişlerini ve ilerleme tekniklerini karşılaştırarak en olası doğum saatini belirler. Bu karmaşık bir süreçtir ve %100 kesinlik garanti edilemez.',
    'en': 'Birth Time Rectification is a technique for estimating birth time when the exact time is unknown by using significant life events (marriage, job change, accident, illness, etc.). The astrologer compares the dates of these events with planetary transits and progression techniques to determine the most likely birth time. This is a complex process and 100% accuracy cannot be guaranteed.',
    'fr': 'La Rectification de l\'Heure de Naissance est une technique pour estimer l\'heure de naissance quand l\'heure exacte est inconnue.',
    'de': 'Die Geburtszeit-Rektifikation ist eine Technik zur Schätzung der Geburtszeit, wenn die genaue Zeit unbekannt ist.',
    'es': 'La Rectificación de Hora de Nacimiento es una técnica para estimar la hora de nacimiento cuando se desconoce.',
    'ru': 'Ректификация времени рождения — техника оценки времени рождения, когда точное время неизвестно.',
    'ar': 'تصحيح وقت الميلاد هو تقنية لتقدير وقت الميلاد عندما يكون الوقت الدقيق غير معروف.',
    'zh': '出生时间校正是一种在确切时间未知时估计出生时间的技术。',
    'el': 'Η Διόρθωση Ώρας Γέννησης είναι μια τεχνική εκτίμησης της ώρας γέννησης όταν δεν είναι γνωστή.',
    'bg': 'Ректификацията на час на раждане е техника за оценка на часа на раждане, когато точното време е неизвестно.',
  },
  historicalBackground: {'tr': 'Rektifikasyon, astrolojinin en eski tekniklerinden biridir. Antik dönemde Ptolemy ve ortaçağda William Lilly gibi astrologlar bu yöntemi kullandı.', 'en': 'Rectification is one of the oldest techniques in astrology. Ancient astrologers like Ptolemy and medieval ones like William Lilly used this method.', 'fr': 'La rectification est l\'une des plus anciennes techniques en astrologie.', 'de': 'Rektifikation ist eine der ältesten Techniken in der Astrologie.', 'es': 'La rectificación es una de las técnicas más antiguas de la astrología.', 'ru': 'Ректификация — одна из древнейших техник в астрологии.', 'ar': 'التصحيح هو أحد أقدم التقنيات في علم الفلك.', 'zh': '校正是占星术中最古老的技术之一。', 'el': 'Η διόρθωση είναι μία από τις παλαιότερες τεχνικές στην αστρολογία.', 'bg': 'Ректификацията е една от най-старите техники в астрологията.'},
  philosophicalFoundation: {'tr': 'Doğum haritası ancak doğru doğum saatiyle anlamlıdır. Ascendant ve ev konumları dakikalara bağlıdır.', 'en': 'Birth chart is only meaningful with correct birth time. Ascendant and house positions depend on minutes.', 'fr': 'Le thème natal n\'a de sens qu\'avec l\'heure de naissance correcte.', 'de': 'Das Geburtshoroskop ist nur mit korrekter Geburtszeit sinnvoll.', 'es': 'La carta natal solo tiene sentido con la hora de nacimiento correcta.', 'ru': 'Натальная карта имеет смысл только с правильным временем рождения.', 'ar': 'خريطة الميلاد ذات معنى فقط مع وقت الميلاد الصحيح.', 'zh': '出生图只有在出生时间正确时才有意义。', 'el': 'Ο γενέθλιος χάρτης έχει νόημα μόνο με τη σωστή ώρα γέννησης.', 'bg': 'Рождената карта има смисъл само с правилния час на раждане.'},
  howItWorks: {'tr': '1. Önemli yaşam olayları toplanır (tarihlerle)\n2. Olası doğum saati aralığı belirlenir\n3. Her olası saat için harita çıkarılır\n4. Olaylar geçiş ve ilerleme teknikleriyle test edilir\n5. En tutarlı saat belirlenir', 'en': '1. Important life events are collected (with dates)\n2. Possible birth time range is determined\n3. Chart is drawn for each possible time\n4. Events are tested with transit and progression techniques\n5. Most consistent time is determined', 'fr': '1. Les événements importants de la vie sont collectés...', 'de': '1. Wichtige Lebensereignisse werden gesammelt...', 'es': '1. Se recopilan eventos importantes de la vida...', 'ru': '1. Собираются важные жизненные события...', 'ar': '1. تُجمع الأحداث الحياتية المهمة...', 'zh': '1. 收集重要的生活事件...', 'el': '1. Συλλέγονται σημαντικά γεγονότα ζωής...', 'bg': '1. Събират се важни житейски събития...'},
  symbolicInterpretation: {'tr': 'Ascendant fiziksel görünüm ve kişilik ifadesini gösterir. MC kariyer ve toplumsal konumu temsil eder.', 'en': 'Ascendant shows physical appearance and personality expression. MC represents career and social position.', 'fr': 'L\'Ascendant montre l\'apparence physique et l\'expression de la personnalité.', 'de': 'Der Aszendent zeigt das körperliche Erscheinungsbild und den Persönlichkeitsausdruck.', 'es': 'El Ascendente muestra la apariencia física y expresión de personalidad.', 'ru': 'Асцендент показывает внешность и выражение личности.', 'ar': 'يُظهر الطالع المظهر الجسدي والتعبير عن الشخصية.', 'zh': '上升星座显示外貌和人格表达。', 'el': 'Ο Ωροσκόπος δείχνει τη φυσική εμφάνιση και την έκφραση της προσωπικότητας.', 'bg': 'Асцендентът показва физическия вид и изразяването на личността.'},
  insightsProvided: {'tr': 'Tahmini doğum saati, güvenilirlik derecesi, doğrulama testleri.', 'en': 'Estimated birth time, reliability degree, verification tests.', 'fr': 'Heure de naissance estimée, degré de fiabilité.', 'de': 'Geschätzte Geburtszeit, Zuverlässigkeitsgrad.', 'es': 'Hora de nacimiento estimada, grado de confiabilidad.', 'ru': 'Предполагаемое время рождения, степень надёжности.', 'ar': 'وقت الميلاد المقدر، درجة الموثوقية.', 'zh': '估计的出生时间，可靠性程度。', 'el': 'Εκτιμώμενη ώρα γέννησης, βαθμός αξιοπιστίας.', 'bg': 'Приблизителен час на раждане, степен на надеждност.'},
  commonMotivations: {'tr': ['Doğum saati bilinmiyor', 'Hastanenin verdiği saat yaklaşık', 'Evde doğum yapılmış'], 'en': ['Birth time is unknown', 'Hospital-given time is approximate', 'Home birth occurred'], 'fr': ['L\'heure de naissance est inconnue'], 'de': ['Geburtszeit ist unbekannt'], 'es': ['La hora de nacimiento es desconocida'], 'ru': ['Время рождения неизвестно'], 'ar': ['وقت الميلاد غير معروف'], 'zh': ['出生时间未知'], 'el': ['Η ώρα γέννησης είναι άγνωστη'], 'bg': ['Часът на раждане е неизвестен']},
  lifeThemes: {'tr': ['Doğum haritası doğruluğu', 'Tahmin geçerliliği', 'Kişisel analiz'], 'en': ['Birth chart accuracy', 'Prediction validity', 'Personal analysis'], 'fr': ['Précision du thème natal'], 'de': ['Horoskop-Genauigkeit'], 'es': ['Precisión de carta natal'], 'ru': ['Точность натальной карты'], 'ar': ['دقة خريطة الميلاد'], 'zh': ['出生图准确性'], 'el': ['Ακρίβεια γενέθλιου χάρτη'], 'bg': ['Точност на рождената карта']},
  whatYouReceive: {'tr': '• Kapsamlı rektifikasyon analizi\n• Tahmini doğum saati\n• Güvenilirlik değerlendirmesi\n• Test sonuçları ve açıklamalar', 'en': '• Comprehensive rectification analysis\n• Estimated birth time\n• Reliability assessment\n• Test results and explanations', 'fr': '• Analyse de rectification complète...', 'de': '• Umfassende Rektifikationsanalyse...', 'es': '• Análisis de rectificación completo...', 'ru': '• Комплексный анализ ректификации...', 'ar': '• تحليل تصحيح شامل...', 'zh': '• 综合校正分析...', 'el': '• Ολοκληρωμένη ανάλυση διόρθωσης...', 'bg': '• Цялостен анализ на ректификация...'},
  perspectiveGained: {'tr': 'Doğum haritanızı daha güvenilir bir temel üzerine kurarak daha doğru yorumlar alabilirsiniz.', 'en': 'By building your birth chart on a more reliable foundation, you can get more accurate interpretations.', 'fr': 'En construisant votre thème sur une base plus fiable, vous pouvez obtenir des interprétations plus précises.', 'de': 'Indem Sie Ihr Horoskop auf einer zuverlässigeren Grundlage aufbauen, können Sie genauere Interpretationen erhalten.', 'es': 'Al construir tu carta sobre una base más confiable, puedes obtener interpretaciones más precisas.', 'ru': 'Построив свою карту на более надёжной основе, вы можете получить более точные интерпретации.', 'ar': 'من خلال بناء خريطتك على أساس أكثر موثوقية، يمكنك الحصول على تفسيرات أكثر دقة.', 'zh': '通过在更可靠的基础上建立您的出生图，您可以获得更准确的解释。', 'el': 'Χτίζοντας τον χάρτη σας σε πιο αξιόπιστη βάση, μπορείτε να πάρετε πιο ακριβείς ερμηνείες.', 'bg': 'Изграждайки картата си на по-надеждна основа, можете да получите по-точни тълкувания.'},
  reflectionPoints: {'tr': ['Hayatımdaki önemli olayların tarihlerini hatırlıyor muyum?', 'Doğum saatim hakkında ne biliyorum?'], 'en': ['Do I remember the dates of important events in my life?', 'What do I know about my birth time?'], 'fr': ['Est-ce que je me souviens des dates des événements importants de ma vie?'], 'de': ['Erinnere ich mich an die Daten wichtiger Ereignisse in meinem Leben?'], 'es': ['¿Recuerdo las fechas de eventos importantes en mi vida?'], 'ru': ['Помню ли я даты важных событий в моей жизни?'], 'ar': ['هل أتذكر تواريخ الأحداث المهمة في حياتي؟'], 'zh': ['我记得生活中重要事件的日期吗？'], 'el': ['Θυμάμαι τις ημερομηνίες σημαντικών γεγονότων στη ζωή μου;'], 'bg': ['Помня ли датите на важни събития в живота ми?']},
  safetyDisclaimer: {'tr': '⚠️ Rektifikasyon tahmini bir tekniktir ve %100 doğruluk garanti edilemez. Eğlence amaçlıdır ve bilimsel olarak kanıtlanmamıştır.', 'en': '⚠️ Rectification is an estimation technique and 100% accuracy cannot be guaranteed. It is for entertainment purposes and is not scientifically proven.', 'fr': '⚠️ La rectification est une technique d\'estimation et la précision à 100% ne peut être garantie.', 'de': '⚠️ Rektifikation ist eine Schätztechnik und 100% Genauigkeit kann nicht garantiert werden.', 'es': '⚠️ La rectificación es una técnica de estimación y no se puede garantizar 100% de precisión.', 'ru': '⚠️ Ректификация — это техника оценки, и 100% точность не гарантируется.', 'ar': '⚠️ التصحيح تقنية تقدير ولا يمكن ضمان دقة 100%.', 'zh': '⚠️ 校正是一种估计技术，无法保证100%准确。', 'el': '⚠️ Η διόρθωση είναι μια τεχνική εκτίμησης και δεν μπορεί να εγγυηθεί 100% ακρίβεια.', 'bg': '⚠️ Ректификацията е техника за оценка и 100% точност не може да бъде гарантирана.'},
  doesNotDo: {'tr': ['%100 kesin doğum saati vermez', 'Resmi belgelerin yerini almaz'], 'en': ['Does not give 100% certain birth time', 'Does not replace official documents'], 'fr': ['Ne donne pas une heure de naissance 100% certaine'], 'de': ['Gibt keine 100% sichere Geburtszeit'], 'es': ['No da hora de nacimiento 100% segura'], 'ru': ['Не даёт 100% точное время рождения'], 'ar': ['لا يعطي وقت ميلاد مؤكد 100%'], 'zh': ['不提供100%确定的出生时间'], 'el': ['Δεν δίνει 100% βέβαιη ώρα γέννησης'], 'bg': ['Не дава 100% сигурен час на раждане']},
  exampleScenarios: {'tr': ['Doğum saatini bilmeyen bir kişi, evlilik ve kariyer değişikliği tarihlerini kullanarak ±15 dakikalık bir tahmin elde etti.'], 'en': ['A person who didn\'t know their birth time got an estimate within ±15 minutes using their marriage and career change dates.'], 'fr': ['Une personne ne connaissant pas son heure de naissance a obtenu une estimation de ±15 minutes.'], 'de': ['Eine Person, die ihre Geburtszeit nicht kannte, erhielt eine Schätzung von ±15 Minuten.'], 'es': ['Una persona que no conocía su hora de nacimiento obtuvo una estimación de ±15 minutos.'], 'ru': ['Человек, не знавший время рождения, получил оценку ±15 минут.'], 'ar': ['شخص لم يكن يعرف وقت ميلاده حصل على تقدير ±15 دقيقة.'], 'zh': ['一个不知道出生时间的人获得了±15分钟的估计。'], 'el': ['Ένα άτομο που δεν ήξερε την ώρα γέννησής του πήρε μια εκτίμηση ±15 λεπτά.'], 'bg': ['Човек, който не знаеше часа си на раждане, получи оценка ±15 минути.']},
  faq: {'tr': [FAQItem(question: 'Rektifikasyon için kaç olay gerekli?', answer: 'En az 5-7 önemli yaşam olayı tarihiyle önerilir.'), FAQItem(question: 'Sonuç ne kadar güvenilir?', answer: 'Teknik ve olayların sayısına bağlı olarak değişir, genellikle ±15-30 dakika hassasiyet hedeflenir.')], 'en': [FAQItem(question: 'How many events are needed for rectification?', answer: 'At least 5-7 important life event dates are recommended.'), FAQItem(question: 'How reliable is the result?', answer: 'Varies depending on technique and number of events, usually ±15-30 minute accuracy is targeted.')], 'fr': [FAQItem(question: 'Combien d\'événements sont nécessaires?', answer: 'Au moins 5-7 dates d\'événements importants sont recommandées.')], 'de': [FAQItem(question: 'Wie viele Ereignisse werden benötigt?', answer: 'Mindestens 5-7 wichtige Lebensereignisdaten werden empfohlen.')], 'es': [FAQItem(question: '¿Cuántos eventos se necesitan?', answer: 'Se recomiendan al menos 5-7 fechas de eventos importantes.')], 'ru': [FAQItem(question: 'Сколько событий нужно?', answer: 'Рекомендуется минимум 5-7 дат важных событий.')], 'ar': [FAQItem(question: 'كم عدد الأحداث المطلوبة؟', answer: 'يُوصى بما لا يقل عن 5-7 تواريخ أحداث مهمة.')], 'zh': [FAQItem(question: '需要多少事件？', answer: '建议至少5-7个重要生活事件日期。')], 'el': [FAQItem(question: 'Πόσα γεγονότα χρειάζονται;', answer: 'Συνιστώνται τουλάχιστον 5-7 ημερομηνίες σημαντικών γεγονότων.')], 'bg': [FAQItem(question: 'Колко събития са необходими?', answer: 'Препоръчват се поне 5-7 дати на важни събития.')]},
  relatedPractices: {'tr': ['Doğum Haritası', 'Transit Analizi', 'Progresyon'], 'en': ['Birth Chart', 'Transit Analysis', 'Progression'], 'fr': ['Thème Natal', 'Analyse des Transits', 'Progression'], 'de': ['Geburtshoroskop', 'Transit-Analyse', 'Progression'], 'es': ['Carta Natal', 'Análisis de Tránsitos', 'Progresión'], 'ru': ['Натальная Карта', 'Анализ Транзитов', 'Прогрессия'], 'ar': ['خريطة الميلاد', 'تحليل العبور', 'التقدم'], 'zh': ['出生图', '过境分析', '推运'], 'el': ['Γενέθλιος Χάρτης', 'Ανάλυση Διελεύσεων', 'Πρόοδος'], 'bg': ['Рождена Карта', 'Транзитен Анализ', 'Прогресия']},
  differenceFromSimilar: {'tr': 'Rektifikasyon bilinmeyen doğum saatini tahmin eder; normal harita analizi kesin doğum saati gerektirir.', 'en': 'Rectification estimates unknown birth time; normal chart analysis requires exact birth time.', 'fr': 'La rectification estime l\'heure de naissance inconnue; l\'analyse normale nécessite l\'heure exacte.', 'de': 'Rektifikation schätzt unbekannte Geburtszeit; normale Analyse erfordert genaue Geburtszeit.', 'es': 'La rectificación estima la hora desconocida; el análisis normal requiere hora exacta.', 'ru': 'Ректификация оценивает неизвестное время; обычный анализ требует точного времени.', 'ar': 'التصحيح يقدر وقت الميلاد غير المعروف؛ التحليل العادي يتطلب الوقت الدقيق.', 'zh': '校正估计未知的出生时间；普通分析需要确切时间。', 'el': 'Η διόρθωση εκτιμά την άγνωστη ώρα· η κανονική ανάλυση απαιτεί την ακριβή ώρα.', 'bg': 'Ректификацията оценява неизвестния час; нормалният анализ изисква точния час.'},
  microLearning: {'tr': ['💡 Ascendant her 4 dakikada yaklaşık 1 derece hareket eder.', '💡 Daha fazla olay daha güvenilir rektifikasyon sağlar.'], 'en': ['💡 Ascendant moves approximately 1 degree every 4 minutes.', '💡 More events provide more reliable rectification.'], 'fr': ['💡 L\'Ascendant se déplace d\'environ 1 degré toutes les 4 minutes.'], 'de': ['💡 Der Aszendent bewegt sich etwa alle 4 Minuten um 1 Grad.'], 'es': ['💡 El Ascendente se mueve aproximadamente 1 grado cada 4 minutos.'], 'ru': ['💡 Асцендент движется примерно на 1 градус каждые 4 минуты.'], 'ar': ['💡 يتحرك الطالع حوالي درجة واحدة كل 4 دقائق.'], 'zh': ['💡 上升星座每4分钟移动约1度。'], 'el': ['💡 Ο Ωροσκόπος κινείται περίπου 1 μοίρα κάθε 4 λεπτά.'], 'bg': ['💡 Асцендентът се движи приблизително 1 градус на всеки 4 минути.']},
);

// ═══════════════════════════════════════════════════════════════════════════════
// NUMEROLOGY - ANNUAL FORECAST
// ═══════════════════════════════════════════════════════════════════════════════

final numerologyAnnual = ServiceContent(
  id: 'numerology_annual',
  category: ServiceCategory.numerology,
  icon: '📅',
  displayOrder: 12,
  name: {
    'tr': 'Yıllık Numeroloji Tahmini',
    'en': 'Annual Numerology Forecast',
    'fr': 'Prévisions Numérologique Annuelle',
    'de': 'Jährliche Numerologie-Vorhersage',
    'es': 'Pronóstico Numerológico Anual',
    'ru': 'Годовой Нумерологический Прогноз',
    'ar': 'التوقعات العددية السنوية',
    'zh': '年度数字预测',
    'el': 'Ετήσια Αριθμολογική Πρόβλεψη',
    'bg': 'Годишна Нумерологична Прогноза',
  },
  shortDescription: {
    'tr': 'Kişisel yıl numaranızı hesaplayarak yılınızın enerjisini ve temalarını keşfedin.',
    'en': 'Discover your year\'s energy and themes by calculating your personal year number.',
    'fr': 'Découvrez l\'énergie et les thèmes de votre année en calculant votre nombre d\'année personnelle.',
    'de': 'Entdecken Sie die Energie und Themen Ihres Jahres durch Berechnung Ihrer persönlichen Jahreszahl.',
    'es': 'Descubre la energía y los temas de tu año calculando tu número de año personal.',
    'ru': 'Откройте энергию и темы года, рассчитав число личного года.',
    'ar': 'اكتشف طاقة عامك وموضوعاته من خلال حساب رقم عامك الشخصي.',
    'zh': '通过计算您的个人年数来发现一年的能量和主题。',
    'el': 'Ανακαλύψτε την ενέργεια και τα θέματα του έτους υπολογίζοντας τον προσωπικό αριθμό έτους.',
    'bg': 'Открийте енергията и темите на годината, изчислявайки личното си годишно число.',
  },
  coreExplanation: {
    'tr': 'Yıllık Numeroloji, kişisel yıl numaranızı (1-9) hesaplayarak yılın ana temalarını ve enerjisini belirlir. Her yıl, 9 yıllık döngüde farklı bir enerji taşır. Kişisel yıl numarası, doğum gününüz ve ayınız ile mevcut yılın toplamıyla hesaplanır.',
    'en': 'Annual Numerology determines the main themes and energy of the year by calculating your personal year number (1-9). Each year carries different energy in the 9-year cycle. Personal year number is calculated by adding your birth day and month with the current year.',
    'fr': 'La Numérologie Annuelle détermine les thèmes et l\'énergie de l\'année en calculant votre nombre d\'année personnelle.',
    'de': 'Die jährliche Numerologie bestimmt die Themen und Energie des Jahres durch Berechnung Ihrer persönlichen Jahreszahl.',
    'es': 'La Numerología Anual determina los temas y energía del año calculando tu número de año personal.',
    'ru': 'Годовая нумерология определяет темы и энергию года, рассчитывая число личного года.',
    'ar': 'تحدد علم الأعداد السنوي موضوعات وطاقة العام من خلال حساب رقم عامك الشخصي.',
    'zh': '年度数字学通过计算您的个人年数来确定一年的主题和能量。',
    'el': 'Η Ετήσια Αριθμολογία καθορίζει τα θέματα και την ενέργεια του έτους υπολογίζοντας τον προσωπικό αριθμό έτους.',
    'bg': 'Годишната нумерология определя темите и енергията на годината, изчислявайки личното годишно число.',
  },
  historicalBackground: {'tr': 'Kişisel yıl hesaplama, modern numeroloji pratiğinin temel parçasıdır ve 20. yüzyılda popülerleşti.', 'en': 'Personal year calculation is a fundamental part of modern numerology practice and became popular in the 20th century.', 'fr': 'Le calcul de l\'année personnelle est une partie fondamentale de la pratique moderne de numérologie.', 'de': 'Die Berechnung des persönlichen Jahres ist ein grundlegender Teil der modernen Numerologie-Praxis.', 'es': 'El cálculo del año personal es una parte fundamental de la práctica moderna de numerología.', 'ru': 'Расчёт личного года — фундаментальная часть современной практики нумерологии.', 'ar': 'حساب السنة الشخصية جزء أساسي من ممارسة علم الأعداد الحديث.', 'zh': '个人年计算是现代数字学实践的基本部分。', 'el': 'Ο υπολογισμός προσωπικού έτους είναι θεμελιώδες μέρος της σύγχρονης πρακτικής.', 'bg': 'Изчисляването на лично годишно число е фундаментална част от съвременната практика.'},
  philosophicalFoundation: {'tr': 'Yaşam 9 yıllık döngülerde ilerler; her yıl benzersiz bir enerji ve öğrenme fırsatı sunar.', 'en': 'Life progresses in 9-year cycles; each year offers unique energy and learning opportunities.', 'fr': 'La vie progresse par cycles de 9 ans; chaque année offre une énergie unique.', 'de': 'Das Leben schreitet in 9-Jahres-Zyklen voran; jedes Jahr bietet einzigartige Energie.', 'es': 'La vida progresa en ciclos de 9 años; cada año ofrece energía única.', 'ru': 'Жизнь развивается в 9-летних циклах; каждый год предлагает уникальную энергию.', 'ar': 'تتقدم الحياة في دورات من 9 سنوات؛ كل عام يقدم طاقة فريدة.', 'zh': '生命以9年周期前进；每年提供独特的能量。', 'el': 'Η ζωή προχωρά σε κύκλους 9 ετών· κάθε έτος προσφέρει μοναδική ενέργεια.', 'bg': 'Животът напредва в 9-годишни цикли; всяка година предлага уникална енергия.'},
  howItWorks: {'tr': '1. Doğum günü ve ayı belirlenir\n2. Mevcut yıl eklenir\n3. Rakamlar tek haneye indirilir\n4. Kişisel yıl numarası yorumlanır', 'en': '1. Birth day and month are determined\n2. Current year is added\n3. Numbers are reduced to single digit\n4. Personal year number is interpreted', 'fr': '1. Le jour et mois de naissance sont déterminés...', 'de': '1. Geburtstag und -monat werden bestimmt...', 'es': '1. Se determina el día y mes de nacimiento...', 'ru': '1. Определяется день и месяц рождения...', 'ar': '1. يُحدد يوم وشهر الميلاد...', 'zh': '1. 确定出生日和月...', 'el': '1. Καθορίζονται η ημέρα και ο μήνας γέννησης...', 'bg': '1. Определя се денят и месецът на раждане...'},
  symbolicInterpretation: {'tr': '1: Yeni başlangıçlar. 5: Değişim. 9: Tamamlanma ve bırakma.', 'en': '1: New beginnings. 5: Change. 9: Completion and release.', 'fr': '1: Nouveaux débuts. 5: Changement. 9: Accomplissement.', 'de': '1: Neuanfänge. 5: Veränderung. 9: Vollendung.', 'es': '1: Nuevos comienzos. 5: Cambio. 9: Finalización.', 'ru': '1: Новые начинания. 5: Изменения. 9: Завершение.', 'ar': '1: بدايات جديدة. 5: تغيير. 9: اكتمال.', 'zh': '1：新的开始。5：变化。9：完成和释放。', 'el': '1: Νέες αρχές. 5: Αλλαγή. 9: Ολοκλήρωση.', 'bg': '1: Нови начала. 5: Промяна. 9: Завършване.'},
  insightsProvided: {'tr': 'Yılın ana teması, odak alanları, döngüsel konum.', 'en': 'Main theme of year, focus areas, cyclical position.', 'fr': 'Thème principal de l\'année, domaines de concentration.', 'de': 'Hauptthema des Jahres, Fokusbereich.', 'es': 'Tema principal del año, áreas de enfoque.', 'ru': 'Главная тема года, области фокуса.', 'ar': 'الموضوع الرئيسي للسنة، مجالات التركيز.', 'zh': '一年的主要主题，关注领域。', 'el': 'Κύριο θέμα του έτους, τομείς εστίασης.', 'bg': 'Основна тема на годината, области на фокус.'},
  commonMotivations: {'tr': ['Yılı planlamak', 'Döngüsel konumu anlamak', 'Enerjiyle uyum sağlamak'], 'en': ['Planning the year', 'Understanding cyclical position', 'Aligning with energy'], 'fr': ['Planifier l\'année'], 'de': ['Das Jahr planen'], 'es': ['Planificar el año'], 'ru': ['Планирование года'], 'ar': ['التخطيط للسنة'], 'zh': ['规划一年'], 'el': ['Σχεδιασμός του έτους'], 'bg': ['Планиране на годината']},
  lifeThemes: {'tr': ['Kariyer', 'İlişkiler', 'Kişisel büyüme', 'Değişim'], 'en': ['Career', 'Relationships', 'Personal growth', 'Change'], 'fr': ['Carrière', 'Relations'], 'de': ['Karriere', 'Beziehungen'], 'es': ['Carrera', 'Relaciones'], 'ru': ['Карьера', 'Отношения'], 'ar': ['مهنة', 'علاقات'], 'zh': ['事业', '关系'], 'el': ['Καριέρα', 'Σχέσεις'], 'bg': ['Кариера', 'Отношения']},
  whatYouReceive: {'tr': '• Kişisel yıl numarası hesaplama\n• Yıl enerjisi yorumu\n• Ay ay vurgular\n• Döngüsel konum analizi', 'en': '• Personal year number calculation\n• Year energy interpretation\n• Month-by-month highlights\n• Cyclical position analysis', 'fr': '• Calcul du nombre d\'année personnelle...', 'de': '• Berechnung der persönlichen Jahreszahl...', 'es': '• Cálculo del número de año personal...', 'ru': '• Расчёт числа личного года...', 'ar': '• حساب رقم السنة الشخصية...', 'zh': '• 个人年数计算...', 'el': '• Υπολογισμός αριθμού προσωπικού έτους...', 'bg': '• Изчисление на лично годишно число...'},
  perspectiveGained: {'tr': 'Yılınızın enerjisiyle uyumlu hareket ederek akışta kalabilirsiniz.', 'en': 'By moving in harmony with your year\'s energy, you can stay in flow.', 'fr': 'En vous harmonisant avec l\'énergie de votre année, vous pouvez rester en flux.', 'de': 'Indem Sie sich mit der Energie Ihres Jahres harmonisieren, können Sie im Fluss bleiben.', 'es': 'Al moverte en armonía con la energía de tu año, puedes mantenerte en flujo.', 'ru': 'Двигаясь в гармонии с энергией года, вы можете оставаться в потоке.', 'ar': 'من خلال التحرك بانسجام مع طاقة عامك، يمكنك البقاء في التدفق.', 'zh': '通过与一年的能量和谐相处，您可以保持顺流。', 'el': 'Κινούμενοι σε αρμονία με την ενέργεια του έτους, μπορείτε να παραμείνετε στη ροή.', 'bg': 'Като се движите в хармония с енергията на годината, можете да останете в потока.'},
  reflectionPoints: {'tr': ['Bu yıl hangi numaradayım?', 'Yılın enerjisiyle nasıl çalışabilirim?'], 'en': ['What number am I in this year?', 'How can I work with the year\'s energy?'], 'fr': ['Quel numéro suis-je cette année?'], 'de': ['Welche Zahl bin ich dieses Jahr?'], 'es': ['¿Qué número soy este año?'], 'ru': ['Какое число у меня в этом году?'], 'ar': ['ما رقمي هذا العام؟'], 'zh': ['今年我的数字是什么？'], 'el': ['Ποιος αριθμός είμαι φέτος;'], 'bg': ['Какво число съм тази година?']},
  safetyDisclaimer: {'tr': '⚠️ Yıllık numeroloji eğlence amaçlıdır ve bilimsel olarak kanıtlanmamıştır. Profesyonel danışmanlık yerine geçmez.', 'en': '⚠️ Annual numerology is for entertainment purposes and is not scientifically proven. It does not replace professional advice.', 'fr': '⚠️ La numérologie annuelle est à des fins de divertissement.', 'de': '⚠️ Jährliche Numerologie dient der Unterhaltung.', 'es': '⚠️ La numerología anual es con fines de entretenimiento.', 'ru': '⚠️ Годовая нумерология предназначена для развлечения.', 'ar': '⚠️ علم الأعداد السنوي هو لأغراض الترفيه.', 'zh': '⚠️ 年度数字学仅供娱乐目的。', 'el': '⚠️ Η ετήσια αριθμολογία είναι για ψυχαγωγία.', 'bg': '⚠️ Годишната нумерология е за забавление.'},
  doesNotDo: {'tr': ['Kesin olayları tahmin etmez', 'Bilimsel temel sunmaz'], 'en': ['Does not predict exact events', 'Does not offer scientific basis'], 'fr': ['Ne prédit pas des événements exacts'], 'de': ['Sagt keine genauen Ereignisse voraus'], 'es': ['No predice eventos exactos'], 'ru': ['Не предсказывает точные события'], 'ar': ['لا يتنبأ بأحداث دقيقة'], 'zh': ['不预测确切事件'], 'el': ['Δεν προβλέπει ακριβή γεγονότα'], 'bg': ['Не предсказва точни събития']},
  exampleScenarios: {'tr': ['Bir kişi kişisel yıl 1\'de olduğunu öğrenerek yeni projelere başlamaya karar verdi.'], 'en': ['A person learned they were in personal year 1 and decided to start new projects.'], 'fr': ['Une personne a appris qu\'elle était en année personnelle 1 et a décidé de commencer de nouveaux projets.'], 'de': ['Eine Person erfuhr, dass sie im persönlichen Jahr 1 war und entschied sich, neue Projekte zu starten.'], 'es': ['Una persona aprendió que estaba en año personal 1 y decidió comenzar nuevos proyectos.'], 'ru': ['Человек узнал, что находится в личном году 1, и решил начать новые проекты.'], 'ar': ['علم شخص أنه في السنة الشخصية 1 وقرر بدء مشاريع جديدة.'], 'zh': ['一个人了解到自己处于个人年1，决定开始新项目。'], 'el': ['Ένα άτομο έμαθε ότι ήταν σε προσωπικό έτος 1 και αποφάσισε να ξεκινήσει νέα έργα.'], 'bg': ['Човек научи, че е в лична година 1 и реши да започне нови проекти.']},
  faq: {'tr': [FAQItem(question: 'Kişisel yıl ne zaman başlar?', answer: 'Genellikle doğum gününüzde veya yılbaşında.')], 'en': [FAQItem(question: 'When does personal year start?', answer: 'Usually on your birthday or New Year.')], 'fr': [FAQItem(question: 'Quand commence l\'année personnelle?', answer: 'Généralement à votre anniversaire ou au Nouvel An.')], 'de': [FAQItem(question: 'Wann beginnt das persönliche Jahr?', answer: 'Normalerweise an Ihrem Geburtstag oder Neujahr.')], 'es': [FAQItem(question: '¿Cuándo comienza el año personal?', answer: 'Generalmente en tu cumpleaños o Año Nuevo.')], 'ru': [FAQItem(question: 'Когда начинается личный год?', answer: 'Обычно в день рождения или Новый год.')], 'ar': [FAQItem(question: 'متى تبدأ السنة الشخصية؟', answer: 'عادة في عيد ميلادك أو رأس السنة.')], 'zh': [FAQItem(question: '个人年何时开始？', answer: '通常在您的生日或新年。')], 'el': [FAQItem(question: 'Πότε ξεκινά το προσωπικό έτος;', answer: 'Συνήθως στα γενέθλιά σας ή την Πρωτοχρονιά.')], 'bg': [FAQItem(question: 'Кога започва личната година?', answer: 'Обикновено на рождения ви ден или Нова година.')]},
  relatedPractices: {'tr': ['Numeroloji Analizi', 'Astroloji Yıllık Tahmin'], 'en': ['Numerology Analysis', 'Astrology Annual Forecast'], 'fr': ['Analyse Numérologique', 'Prévisions Astrologique Annuelle'], 'de': ['Numerologie-Analyse', 'Astrologische Jahresvorhersage'], 'es': ['Análisis Numerológico', 'Pronóstico Astrológico Anual'], 'ru': ['Нумерологический Анализ', 'Астрологический Годовой Прогноз'], 'ar': ['تحليل علم الأعداد', 'التوقعات الفلكية السنوية'], 'zh': ['数字分析', '占星年度预测'], 'el': ['Αριθμολογική Ανάλυση', 'Αστρολογική Ετήσια Πρόβλεψη'], 'bg': ['Нумерологичен Анализ', 'Астрологична Годишна Прогноза']},
  differenceFromSimilar: {'tr': 'Yıllık numeroloji sayılara odaklanır; yıllık astroloji gezegen transitlerini kullanır.', 'en': 'Annual numerology focuses on numbers; annual astrology uses planetary transits.', 'fr': 'La numérologie annuelle se concentre sur les nombres; l\'astrologie annuelle utilise les transits planétaires.', 'de': 'Jährliche Numerologie konzentriert sich auf Zahlen; jährliche Astrologie nutzt Planetentransite.', 'es': 'La numerología anual se enfoca en números; la astrología anual usa tránsitos planetarios.', 'ru': 'Годовая нумерология фокусируется на числах; годовая астрология использует транзиты планет.', 'ar': 'علم الأعداد السنوي يركز على الأرقام؛ علم الفلك السنوي يستخدم عبور الكواكب.', 'zh': '年度数字学关注数字；年度占星使用行星过境。', 'el': 'Η ετήσια αριθμολογία εστιάζει σε αριθμούς· η ετήσια αστρολογία χρησιμοποιεί διελεύσεις πλανητών.', 'bg': 'Годишната нумерология се фокусира върху числа; годишната астрология използва планетарни транзити.'},
  microLearning: {'tr': ['💡 Kişisel yıl 9\'da sonra yıl 1 gelir — döngü tamamlanır.', '💡 Her sayı özel bir enerji taşır.'], 'en': ['💡 After personal year 9 comes year 1 — the cycle completes.', '💡 Each number carries special energy.'], 'fr': ['💡 Après l\'année personnelle 9 vient l\'année 1 — le cycle se complète.'], 'de': ['💡 Nach dem persönlichen Jahr 9 kommt Jahr 1 — der Zyklus endet.'], 'es': ['💡 Después del año personal 9 viene el año 1 — el ciclo se completa.'], 'ru': ['💡 После личного года 9 наступает год 1 — цикл завершается.'], 'ar': ['💡 بعد السنة الشخصية 9 تأتي السنة 1 — تكتمل الدورة.'], 'zh': ['💡 个人年9之后是年1——周期完成。'], 'el': ['💡 Μετά το προσωπικό έτος 9 έρχεται το έτος 1 — ο κύκλος ολοκληρώνεται.'], 'bg': ['💡 След лична година 9 идва година 1 — цикълът завършва.']},
);

// ═══════════════════════════════════════════════════════════════════════════════
// NUMEROLOGY - RELATIONSHIP COMPATIBILITY
// ═══════════════════════════════════════════════════════════════════════════════

final numerologyRelationship = ServiceContent(
  id: 'numerology_relationship',
  category: ServiceCategory.numerology,
  icon: '💕',
  displayOrder: 13,
  name: {
    'tr': 'Numeroloji İlişki Uyumu',
    'en': 'Numerology Relationship Compatibility',
    'fr': 'Compatibilité Numérologique',
    'de': 'Numerologie Beziehungskompatibilität',
    'es': 'Compatibilidad Numerológica',
    'ru': 'Нумерологическая Совместимость',
    'ar': 'التوافق العددي في العلاقات',
    'zh': '数字关系兼容性',
    'el': 'Αριθμολογική Συμβατότητα Σχέσεων',
    'bg': 'Нумерологична Съвместимост в Отношенията',
  },
  shortDescription: {
    'tr': 'İki kişinin yaşam yolu numaralarını karşılaştırarak ilişki dinamiklerini keşfedin.',
    'en': 'Discover relationship dynamics by comparing life path numbers of two people.',
    'fr': 'Découvrez les dynamiques relationnelles en comparant les nombres de chemin de vie.',
    'de': 'Entdecken Sie Beziehungsdynamiken durch Vergleich der Lebenspfadzahlen.',
    'es': 'Descubre las dinámicas de relación comparando los números de camino de vida.',
    'ru': 'Откройте динамику отношений, сравнивая числа жизненного пути.',
    'ar': 'اكتشف ديناميكيات العلاقة من خلال مقارنة أرقام مسار الحياة.',
    'zh': '通过比较两个人的生命路径数来发现关系动态。',
    'el': 'Ανακαλύψτε τις δυναμικές σχέσεων συγκρίνοντας τους αριθμούς διαδρομής ζωής.',
    'bg': 'Открийте динамиката на отношенията, сравнявайки числата на жизнения път.',
  },
  coreExplanation: {
    'tr': 'Numeroloji İlişki Uyumu, iki kişinin yaşam yolu numaralarını karşılaştırarak uyum ve potansiyel zorlukları analiz eder. Her sayı farklı özellikler taşır ve belirli sayı kombinasyonları doğal uyum veya büyüme fırsatları sunar.',
    'en': 'Numerology Relationship Compatibility analyzes harmony and potential challenges by comparing life path numbers of two people. Each number carries different characteristics and certain number combinations offer natural harmony or growth opportunities.',
    'fr': 'La Compatibilité Numérologique analyse l\'harmonie et les défis potentiels en comparant les nombres de chemin de vie.',
    'de': 'Numerologie-Beziehungskompatibilität analysiert Harmonie und Herausforderungen durch Vergleich der Lebenspfadzahlen.',
    'es': 'La Compatibilidad Numerológica analiza armonía y desafíos comparando números de camino de vida.',
    'ru': 'Нумерологическая совместимость анализирует гармонию и вызовы, сравнивая числа жизненного пути.',
    'ar': 'يحلل التوافق العددي الانسجام والتحديات من خلال مقارنة أرقام مسار الحياة.',
    'zh': '数字关系兼容性通过比较生命路径数来分析和谐和潜在挑战。',
    'el': 'Η Αριθμολογική Συμβατότητα αναλύει την αρμονία και τις προκλήσεις συγκρίνοντας αριθμούς διαδρομής ζωής.',
    'bg': 'Нумерологичната съвместимост анализира хармонията и предизвикателствата, сравнявайки числата на жизнения път.',
  },
  historicalBackground: {'tr': 'Sayı uyumu kavramı modern numeroloji geleneğinde gelişti. İlişki analizi için yaygın olarak kullanılır.', 'en': 'The concept of number compatibility developed in modern numerology tradition. It is widely used for relationship analysis.', 'fr': 'Le concept de compatibilité des nombres s\'est développé dans la tradition numérologique moderne.', 'de': 'Das Konzept der Zahlenkompatibilität entwickelte sich in der modernen Numerologie-Tradition.', 'es': 'El concepto de compatibilidad de números se desarrolló en la tradición numerológica moderna.', 'ru': 'Концепция совместимости чисел развилась в современной нумерологической традиции.', 'ar': 'تطور مفهوم توافق الأرقام في تقليد علم الأعداد الحديث.', 'zh': '数字兼容性的概念在现代数字学传统中发展起来。', 'el': 'Η έννοια της συμβατότητας αριθμών αναπτύχθηκε στη σύγχρονη παράδοση.', 'bg': 'Концепцията за съвместимост на числата се разви в съвременната традиция.'},
  philosophicalFoundation: {'tr': 'Her sayı benzersiz bir titreşim taşır. Uyumlu titreşimler harmonik ilişkiler yaratır.', 'en': 'Each number carries unique vibration. Compatible vibrations create harmonic relationships.', 'fr': 'Chaque nombre porte une vibration unique. Les vibrations compatibles créent des relations harmoniques.', 'de': 'Jede Zahl trägt eine einzigartige Schwingung. Kompatible Schwingungen schaffen harmonische Beziehungen.', 'es': 'Cada número tiene una vibración única. Las vibraciones compatibles crean relaciones armónicas.', 'ru': 'Каждое число несёт уникальную вибрацию. Совместимые вибрации создают гармоничные отношения.', 'ar': 'كل رقم يحمل اهتزازاً فريداً. الاهتزازات المتوافقة تخلق علاقات متناغمة.', 'zh': '每个数字都有独特的振动。兼容的振动创造和谐的关系。', 'el': 'Κάθε αριθμός φέρει μοναδική δόνηση. Οι συμβατές δονήσεις δημιουργούν αρμονικές σχέσεις.', 'bg': 'Всяко число носи уникална вибрация. Съвместимите вибрации създават хармонични отношения.'},
  howItWorks: {'tr': '1. Her kişinin yaşam yolu numarası hesaplanır\n2. Sayıların özellikleri değerlendirilir\n3. Uyum ve potansiyel zorluklar analiz edilir\n4. İlişki dinamikleri yorumlanır', 'en': '1. Life path number of each person is calculated\n2. Characteristics of numbers are evaluated\n3. Harmony and potential challenges are analyzed\n4. Relationship dynamics are interpreted', 'fr': '1. Le nombre de chemin de vie de chaque personne est calculé...', 'de': '1. Die Lebenspfadzahl jeder Person wird berechnet...', 'es': '1. Se calcula el número de camino de vida de cada persona...', 'ru': '1. Рассчитывается число жизненного пути каждого...', 'ar': '1. يُحسب رقم مسار الحياة لكل شخص...', 'zh': '1. 计算每个人的生命路径数...', 'el': '1. Υπολογίζεται ο αριθμός διαδρομής ζωής κάθε ατόμου...', 'bg': '1. Изчислява се числото на жизнения път на всеки...'},
  symbolicInterpretation: {'tr': 'Benzer sayılar anlayış sunar; farklı sayılar büyüme fırsatı yaratır.', 'en': 'Similar numbers offer understanding; different numbers create growth opportunities.', 'fr': 'Les nombres similaires offrent compréhension; les différents créent des opportunités de croissance.', 'de': 'Ähnliche Zahlen bieten Verständnis; unterschiedliche schaffen Wachstumsmöglichkeiten.', 'es': 'Números similares ofrecen comprensión; diferentes crean oportunidades de crecimiento.', 'ru': 'Похожие числа предлагают понимание; разные создают возможности роста.', 'ar': 'الأرقام المتشابهة تقدم تفاهماً؛ المختلفة تخلق فرص نمو.', 'zh': '相似的数字提供理解；不同的数字创造成长机会。', 'el': 'Παρόμοιοι αριθμοί προσφέρουν κατανόηση· διαφορετικοί δημιουργούν ευκαιρίες ανάπτυξης.', 'bg': 'Подобни числа предлагат разбиране; различни създават възможности за растеж.'},
  insightsProvided: {'tr': 'İlişki uyumu, güçlü yönler, potansiyel zorluklar, büyüme alanları.', 'en': 'Relationship harmony, strengths, potential challenges, growth areas.', 'fr': 'Harmonie relationnelle, forces, défis potentiels.', 'de': 'Beziehungsharmonie, Stärken, potenzielle Herausforderungen.', 'es': 'Armonía en relación, fortalezas, desafíos potenciales.', 'ru': 'Гармония отношений, сильные стороны, потенциальные вызовы.', 'ar': 'انسجام العلاقة، نقاط القوة، التحديات المحتملة.', 'zh': '关系和谐，优势，潜在挑战。', 'el': 'Αρμονία σχέσης, δυνατά σημεία, πιθανές προκλήσεις.', 'bg': 'Хармония в отношенията, силни страни, потенциални предизвикателства.'},
  commonMotivations: {'tr': ['Yeni ilişkiyi anlamak', 'Mevcut ilişkiyi derinleştirmek', 'İş ortaklığı uyumu'], 'en': ['Understanding a new relationship', 'Deepening existing relationship', 'Business partnership compatibility'], 'fr': ['Comprendre une nouvelle relation'], 'de': ['Eine neue Beziehung verstehen'], 'es': ['Entender una nueva relación'], 'ru': ['Понимание новых отношений'], 'ar': ['فهم علاقة جديدة'], 'zh': ['理解新关系'], 'el': ['Κατανόηση μιας νέας σχέσης'], 'bg': ['Разбиране на нова връзка']},
  lifeThemes: {'tr': ['Romantik ilişkiler', 'Arkadaşlık', 'İş ortaklıkları', 'Aile'], 'en': ['Romantic relationships', 'Friendship', 'Business partnerships', 'Family'], 'fr': ['Relations romantiques'], 'de': ['Romantische Beziehungen'], 'es': ['Relaciones románticas'], 'ru': ['Романтические отношения'], 'ar': ['العلاقات العاطفية'], 'zh': ['浪漫关系'], 'el': ['Ρομαντικές σχέσεις'], 'bg': ['Романтични отношения']},
  whatYouReceive: {'tr': '• İki kişinin yaşam yolu hesaplaması\n• Uyum analizi\n• Güçlü yönler ve zorluklar\n• İlişki dinamikleri yorumu', 'en': '• Life path calculation for two people\n• Compatibility analysis\n• Strengths and challenges\n• Relationship dynamics interpretation', 'fr': '• Calcul du chemin de vie pour deux personnes...', 'de': '• Lebenspfadberechnung für zwei Personen...', 'es': '• Cálculo de camino de vida para dos personas...', 'ru': '• Расчёт жизненного пути для двух людей...', 'ar': '• حساب مسار الحياة لشخصين...', 'zh': '• 两人的生命路径计算...', 'el': '• Υπολογισμός διαδρομής ζωής για δύο άτομα...', 'bg': '• Изчисление на жизнен път за двама...'},
  perspectiveGained: {'tr': 'İlişkinize numerolojik bir bakış açısı kazanarak dinamikleri daha iyi anlarsınız.', 'en': 'By gaining a numerological perspective on your relationship, you better understand the dynamics.', 'fr': 'En gagnant une perspective numérologique, vous comprenez mieux les dynamiques.', 'de': 'Mit einer numerologischen Perspektive verstehen Sie die Dynamik besser.', 'es': 'Al ganar una perspectiva numerológica, entiendes mejor las dinámicas.', 'ru': 'Получив нумерологическую перспективу, вы лучше понимаете динамику.', 'ar': 'من خلال الحصول على منظور عددي، تفهم الديناميكيات بشكل أفضل.', 'zh': '通过获得数字学视角，您更好地理解动态。', 'el': 'Αποκτώντας μια αριθμολογική προοπτική, καταλαβαίνετε καλύτερα τις δυναμικές.', 'bg': 'Придобивайки нумерологична перспектива, по-добре разбирате динамиката.'},
  reflectionPoints: {'tr': ['Partnerimle benzer yönlerimiz neler?', 'Farklılıklarımız nasıl büyüme fırsatı olabilir?'], 'en': ['What are our similarities with my partner?', 'How can our differences be growth opportunities?'], 'fr': ['Quelles sont nos similitudes avec mon partenaire?'], 'de': ['Was sind unsere Gemeinsamkeiten mit meinem Partner?'], 'es': ['¿Cuáles son nuestras similitudes con mi pareja?'], 'ru': ['Каковы наши сходства с партнёром?'], 'ar': ['ما هي أوجه التشابه مع شريكي؟'], 'zh': ['我和伴侣有什么相似之处？'], 'el': ['Ποιες είναι οι ομοιότητές μας με τον σύντροφό μου;'], 'bg': ['Какви са приликите ни с партньора ми?']},
  safetyDisclaimer: {'tr': '⚠️ Numeroloji ilişki uyumu eğlence amaçlıdır. İlişki kararlarını sadece sayılara dayandırmayın.', 'en': '⚠️ Numerology relationship compatibility is for entertainment purposes. Do not base relationship decisions solely on numbers.', 'fr': '⚠️ La compatibilité numérologique est à des fins de divertissement.', 'de': '⚠️ Numerologie-Kompatibilität dient der Unterhaltung.', 'es': '⚠️ La compatibilidad numerológica es con fines de entretenimiento.', 'ru': '⚠️ Нумерологическая совместимость предназначена для развлечения.', 'ar': '⚠️ التوافق العددي هو لأغراض الترفيه.', 'zh': '⚠️ 数字关系兼容性仅供娱乐目的。', 'el': '⚠️ Η αριθμολογική συμβατότητα είναι για ψυχαγωγία.', 'bg': '⚠️ Нумерологичната съвместимост е за забавление.'},
  doesNotDo: {'tr': ['İlişkinin başarılı olup olmayacağını söylemez', 'Kişilik değerlendirmesi yapmaz'], 'en': ['Does not say if relationship will succeed', 'Does not make personality assessments'], 'fr': ['Ne dit pas si la relation réussira'], 'de': ['Sagt nicht, ob die Beziehung erfolgreich sein wird'], 'es': ['No dice si la relación tendrá éxito'], 'ru': ['Не говорит, будут ли отношения успешными'], 'ar': ['لا يقول إذا كانت العلاقة ستنجح'], 'zh': ['不会说关系是否会成功'], 'el': ['Δεν λέει αν η σχέση θα πετύχει'], 'bg': ['Не казва дали връзката ще успее']},
  exampleScenarios: {'tr': ['Bir çift numeroloji uyumu ile iletişim farklılıklarının kaynağını anladı.'], 'en': ['A couple understood the source of communication differences through numerology compatibility.'], 'fr': ['Un couple a compris la source des différences de communication grâce à la compatibilité numérologique.'], 'de': ['Ein Paar verstand die Quelle der Kommunikationsunterschiede durch Numerologie-Kompatibilität.'], 'es': ['Una pareja entendió la fuente de las diferencias de comunicación a través de compatibilidad numerológica.'], 'ru': ['Пара поняла источник различий в общении через нумерологическую совместимость.'], 'ar': ['فهم زوجان مصدر اختلافات التواصل من خلال التوافق العددي.'], 'zh': ['一对夫妇通过数字兼容性了解了沟通差异的来源。'], 'el': ['Ένα ζευγάρι κατάλαβε την πηγή των επικοινωνιακών διαφορών μέσω αριθμολογικής συμβατότητας.'], 'bg': ['Двойка разбра източника на комуникационни различия чрез нумерологична съвместимост.']},
  faq: {'tr': [FAQItem(question: 'Düşük uyum kötü bir ilişki mi demek?', answer: 'Hayır, sadece farklı dinamikler ve büyüme fırsatları gösterir.')], 'en': [FAQItem(question: 'Does low compatibility mean a bad relationship?', answer: 'No, it just shows different dynamics and growth opportunities.')], 'fr': [FAQItem(question: 'Une faible compatibilité signifie-t-elle une mauvaise relation?', answer: 'Non, cela montre simplement des dynamiques différentes.')], 'de': [FAQItem(question: 'Bedeutet geringe Kompatibilität eine schlechte Beziehung?', answer: 'Nein, es zeigt nur verschiedene Dynamiken.')], 'es': [FAQItem(question: '¿Baja compatibilidad significa mala relación?', answer: 'No, solo muestra dinámicas diferentes.')], 'ru': [FAQItem(question: 'Низкая совместимость означает плохие отношения?', answer: 'Нет, это показывает разные динамики.')], 'ar': [FAQItem(question: 'هل التوافق المنخفض يعني علاقة سيئة؟', answer: 'لا، إنه يُظهر فقط ديناميكيات مختلفة.')], 'zh': [FAQItem(question: '低兼容性意味着糟糕的关系吗？', answer: '不，它只是显示不同的动态。')], 'el': [FAQItem(question: 'Χαμηλή συμβατότητα σημαίνει κακή σχέση;', answer: 'Όχι, δείχνει απλώς διαφορετικές δυναμικές.')], 'bg': [FAQItem(question: 'Ниска съвместимост означава ли лоша връзка?', answer: 'Не, просто показва различни динамики.')]},
  relatedPractices: {'tr': ['Astroloji Sinastri', 'Numeroloji Analizi'], 'en': ['Astrology Synastry', 'Numerology Analysis'], 'fr': ['Synastrie Astrologique', 'Analyse Numérologique'], 'de': ['Astrologie-Synastrie', 'Numerologie-Analyse'], 'es': ['Sinastría Astrológica', 'Análisis Numerológico'], 'ru': ['Астрологическая Синастрия', 'Нумерологический Анализ'], 'ar': ['السيناستري الفلكي', 'تحليل علم الأعداد'], 'zh': ['占星合盘', '数字分析'], 'el': ['Αστρολογική Συναστρία', 'Αριθμολογική Ανάλυση'], 'bg': ['Астрологична Синастрия', 'Нумерологичен Анализ']},
  differenceFromSimilar: {'tr': 'Numeroloji uyumu sayılara odaklanır; sinastri gezegen aspektlerine bakar.', 'en': 'Numerology compatibility focuses on numbers; synastry looks at planetary aspects.', 'fr': 'La compatibilité numérologique se concentre sur les nombres; la synastrie examine les aspects planétaires.', 'de': 'Numerologie-Kompatibilität konzentriert sich auf Zahlen; Synastrie betrachtet Planetenaspekte.', 'es': 'La compatibilidad numerológica se enfoca en números; la sinastría mira aspectos planetarios.', 'ru': 'Нумерологическая совместимость фокусируется на числах; синастрия смотрит на аспекты планет.', 'ar': 'التوافق العددي يركز على الأرقام؛ السيناستري ينظر إلى جوانب الكواكب.', 'zh': '数字兼容性关注数字；合盘关注行星相位。', 'el': 'Η αριθμολογική συμβατότητα εστιάζει σε αριθμούς· η συναστρία εξετάζει πλανητικές όψεις.', 'bg': 'Нумерологичната съвместимост се фокусира върху числа; синастрията разглежда планетарни аспекти.'},
  microLearning: {'tr': ['💡 1 ve 9 numaralar doğal çekime sahiptir.', '💡 Aynı sayılar anlayış sunar, ama monoton olabilir.'], 'en': ['💡 Numbers 1 and 9 have natural attraction.', '💡 Same numbers offer understanding but can be monotonous.'], 'fr': ['💡 Les nombres 1 et 9 ont une attraction naturelle.'], 'de': ['💡 Die Zahlen 1 und 9 haben natürliche Anziehung.'], 'es': ['💡 Los números 1 y 9 tienen atracción natural.'], 'ru': ['💡 Числа 1 и 9 имеют естественное притяжение.'], 'ar': ['💡 الأرقام 1 و 9 لها جاذبية طبيعية.'], 'zh': ['💡 数字1和9有自然的吸引力。'], 'el': ['💡 Οι αριθμοί 1 και 9 έχουν φυσική έλξη.'], 'bg': ['💡 Числата 1 и 9 имат естествено привличане.']},
);

// ═══════════════════════════════════════════════════════════════════════════════
// REIKI - KUNDALINI REIKI
// ═══════════════════════════════════════════════════════════════════════════════

final reikiKundalini = ServiceContent(
  id: 'reiki_kundalini',
  category: ServiceCategory.reiki,
  icon: '🐍',
  displayOrder: 14,
  name: {
    'tr': 'Kundalini Reiki',
    'en': 'Kundalini Reiki',
    'fr': 'Reiki Kundalini',
    'de': 'Kundalini Reiki',
    'es': 'Reiki Kundalini',
    'ru': 'Кундалини Рейки',
    'ar': 'ريكي الكونداليني',
    'zh': '昆达里尼灵气',
    'el': 'Κουνταλίνι Ρέικι',
    'bg': 'Кундалини Рейки',
  },
  shortDescription: {
    'tr': 'Kundalini enerjisini uyandırarak derin spiritüel dönüşüm deneyimleyin.',
    'en': 'Experience deep spiritual transformation by awakening Kundalini energy.',
    'fr': 'Vivez une transformation spirituelle profonde en éveillant l\'énergie Kundalini.',
    'de': 'Erleben Sie tiefe spirituelle Transformation durch Erweckung der Kundalini-Energie.',
    'es': 'Experimenta una transformación espiritual profunda al despertar la energía Kundalini.',
    'ru': 'Испытайте глубокую духовную трансформацию, пробуждая энергию Кундалини.',
    'ar': 'اختبر تحولاً روحياً عميقاً من خلال إيقاظ طاقة الكونداليني.',
    'zh': '通过唤醒昆达里尼能量体验深刻的灵性转化。',
    'el': 'Βιώστε βαθιά πνευματική μεταμόρφωση ξυπνώντας την ενέργεια Κουνταλίνι.',
    'bg': 'Преживейте дълбока духовна трансформация, събуждайки Кундалини енергията.',
  },
  coreExplanation: {
    'tr': 'Kundalini Reiki, omurganın tabanında uyuyan kundalini enerjisini nazikçe uyandırmak için geliştirilen bir Reiki formudur. Ole Gabrielsen tarafından sistemleştirilen bu teknik, kundalini yükselişini güvenli ve kontrollü bir şekilde destekler. Enerji kanallarının açılması ve çakraların dengelenmesi üzerine odaklanır.',
    'en': 'Kundalini Reiki is a form of Reiki developed to gently awaken the kundalini energy dormant at the base of the spine. Systematized by Ole Gabrielsen, this technique supports kundalini rising in a safe and controlled manner. It focuses on opening energy channels and balancing chakras.',
    'fr': 'Le Reiki Kundalini est développé pour éveiller doucement l\'énergie kundalini dormante.',
    'de': 'Kundalini Reiki wurde entwickelt, um die schlafende Kundalini-Energie sanft zu erwecken.',
    'es': 'El Reiki Kundalini está desarrollado para despertar suavemente la energía kundalini dormida.',
    'ru': 'Кундалини Рейки развито для мягкого пробуждения дремлющей энергии кундалини.',
    'ar': 'تم تطوير ريكي الكونداليني لإيقاظ طاقة الكونداليني النائمة بلطف.',
    'zh': '昆达里尼灵气旨在温和地唤醒脊柱底部沉睡的昆达里尼能量。',
    'el': 'Το Κουνταλίνι Ρέικι αναπτύχθηκε για να ξυπνήσει απαλά την κοιμισμένη ενέργεια κουνταλίνι.',
    'bg': 'Кундалини Рейки е разработено за нежно събуждане на дремещата кундалини енергия.',
  },
  historicalBackground: {'tr': 'Kundalini kavramı Hint yogik geleneğinden gelir. Kundalini Reiki, Ole Gabrielsen tarafından 1990\'larda sistemleştirildi ve geleneksel Reiki ile Kundalini yoga prensiplerini birleştirdi.', 'en': 'The concept of Kundalini comes from Indian yogic tradition. Kundalini Reiki was systematized by Ole Gabrielsen in the 1990s, combining traditional Reiki with Kundalini yoga principles.', 'fr': 'Le concept de Kundalini vient de la tradition yogique indienne.', 'de': 'Das Konzept der Kundalini stammt aus der indischen yogischen Tradition.', 'es': 'El concepto de Kundalini proviene de la tradición yóguica india.', 'ru': 'Концепция Кундалини происходит из индийской йогической традиции.', 'ar': 'مفهوم الكونداليني يأتي من التقليد اليوغي الهندي.', 'zh': '昆达里尼的概念来自印度瑜伽传统。', 'el': 'Η έννοια Κουνταλίνι προέρχεται από την ινδική γιόγκα παράδοση.', 'bg': 'Концепцията за Кундалини идва от индийската йога традиция.'},
  philosophicalFoundation: {'tr': 'Kundalini, yaşam gücünün en saf hali olarak kabul edilir. Uyandığında tüm çakralar boyunca yükselir ve spiritüel aydınlanmaya yol açar.', 'en': 'Kundalini is considered the purest form of life force. When awakened, it rises through all chakras and leads to spiritual enlightenment.', 'fr': 'Kundalini est considérée comme la forme la plus pure de la force vitale.', 'de': 'Kundalini gilt als die reinste Form der Lebenskraft.', 'es': 'Kundalini se considera la forma más pura de la fuerza vital.', 'ru': 'Кундалини считается чистейшей формой жизненной силы.', 'ar': 'تُعتبر الكونداليني أنقى شكل من أشكال قوة الحياة.', 'zh': '昆达里尼被认为是生命力的最纯净形式。', 'el': 'Η Κουνταλίνι θεωρείται η καθαρότερη μορφή ζωτικής δύναμης.', 'bg': 'Кундалини се счита за най-чистата форма на жизнена сила.'},
  howItWorks: {'tr': '1. Enerji kanalları (nadiler) temizlenir\n2. Ana çakralar dengelenir\n3. Kundalini enerjisi nazikçe uyandırılır\n4. Enerji güvenli bir şekilde yükseltilir\n5. Üst çakralarda bütünleşme sağlanır', 'en': '1. Energy channels (nadis) are cleansed\n2. Main chakras are balanced\n3. Kundalini energy is gently awakened\n4. Energy is safely raised\n5. Integration is achieved in upper chakras', 'fr': '1. Les canaux d\'énergie (nadis) sont nettoyés...', 'de': '1. Energiekanäle (Nadis) werden gereinigt...', 'es': '1. Los canales de energía (nadis) se limpian...', 'ru': '1. Энергетические каналы (нади) очищаются...', 'ar': '1. قنوات الطاقة (النادي) تُنظف...', 'zh': '1. 能量通道（纳迪）被清洁...', 'el': '1. Τα ενεργειακά κανάλια (ναντί) καθαρίζονται...', 'bg': '1. Енергийните канали (надис) се пречистват...'},
  symbolicInterpretation: {'tr': 'Yılan sembolü kundalininin spiral yükselişini temsil eder; lotus çiçeği üst çakralarda açan farkındalığı simgeler.', 'en': 'The serpent symbol represents the spiral rise of kundalini; the lotus flower symbolizes awareness blooming in upper chakras.', 'fr': 'Le symbole du serpent représente la montée spirale de la kundalini.', 'de': 'Das Schlangensymbol repräsentiert den spiralförmigen Aufstieg der Kundalini.', 'es': 'El símbolo de la serpiente representa el ascenso espiral de kundalini.', 'ru': 'Символ змеи представляет спиральный подъём кундалини.', 'ar': 'رمز الثعبان يمثل الصعود الحلزوني للكونداليني.', 'zh': '蛇的符号代表昆达里尼的螺旋上升。', 'el': 'Το σύμβολο του φιδιού αντιπροσωπεύει τη σπειροειδή άνοδο της κουνταλίνι.', 'bg': 'Символът на змията представлява спиралното издигане на кундалини.'},
  insightsProvided: {'tr': 'Derin spiritüel bağlantı, çakra dengeleme, enerji kanalı açılışı, bilinç genişlemesi.', 'en': 'Deep spiritual connection, chakra balancing, energy channel opening, consciousness expansion.', 'fr': 'Connexion spirituelle profonde, équilibrage des chakras.', 'de': 'Tiefe spirituelle Verbindung, Chakra-Ausgleich.', 'es': 'Conexión espiritual profunda, equilibrio de chakras.', 'ru': 'Глубокая духовная связь, балансировка чакр.', 'ar': 'اتصال روحي عميق، توازن الشاكرات.', 'zh': '深度灵性连接，脉轮平衡。', 'el': 'Βαθιά πνευματική σύνδεση, εξισορρόπηση τσάκρα.', 'bg': 'Дълбока духовна връзка, балансиране на чакрите.'},
  commonMotivations: {'tr': ['Spiritüel uyanış', 'Derin meditasyon deneyimi', 'Enerji blokajlarını çözme', 'Bilinç genişletme'], 'en': ['Spiritual awakening', 'Deep meditation experience', 'Releasing energy blockages', 'Expanding consciousness'], 'fr': ['Éveil spirituel'], 'de': ['Spirituelles Erwachen'], 'es': ['Despertar espiritual'], 'ru': ['Духовное пробуждение'], 'ar': ['الصحوة الروحية'], 'zh': ['灵性觉醒'], 'el': ['Πνευματική αφύπνιση'], 'bg': ['Духовно пробуждане']},
  lifeThemes: {'tr': ['Spiritüel gelişim', 'İç dönüşüm', 'Farkındalık', 'Enerji çalışması'], 'en': ['Spiritual development', 'Inner transformation', 'Awareness', 'Energy work'], 'fr': ['Développement spirituel'], 'de': ['Spirituelle Entwicklung'], 'es': ['Desarrollo espiritual'], 'ru': ['Духовное развитие'], 'ar': ['التطور الروحي'], 'zh': ['灵性发展'], 'el': ['Πνευματική ανάπτυξη'], 'bg': ['Духовно развитие']},
  whatYouReceive: {'tr': '• Kundalini Reiki enerji aktarımı\n• Çakra temizliği ve dengeleme\n• Nadi (enerji kanalı) açılışı\n• Kundalini yükseliş desteği\n• Meditasyon rehberliği', 'en': '• Kundalini Reiki energy transmission\n• Chakra cleansing and balancing\n• Nadi (energy channel) opening\n• Kundalini rising support\n• Meditation guidance', 'fr': '• Transmission d\'énergie Reiki Kundalini...', 'de': '• Kundalini Reiki Energieübertragung...', 'es': '• Transmisión de energía Reiki Kundalini...', 'ru': '• Передача энергии Кундалини Рейки...', 'ar': '• نقل طاقة ريكي الكونداليني...', 'zh': '• 昆达里尼灵气能量传输...', 'el': '• Μετάδοση ενέργειας Κουνταλίνι Ρέικι...', 'bg': '• Предаване на Кундалини Рейки енергия...'},
  perspectiveGained: {'tr': 'Derin içsel dönüşüm ve spiritüel bağlantı deneyimi yaşarsınız.', 'en': 'You experience deep inner transformation and spiritual connection.', 'fr': 'Vous vivez une transformation intérieure profonde et une connexion spirituelle.', 'de': 'Sie erleben tiefe innere Transformation und spirituelle Verbindung.', 'es': 'Experimentas una transformación interior profunda y conexión espiritual.', 'ru': 'Вы переживаете глубокую внутреннюю трансформацию и духовную связь.', 'ar': 'تختبر تحولاً داخلياً عميقاً واتصالاً روحياً.', 'zh': '您体验深刻的内在转化和灵性连接。', 'el': 'Βιώνετε βαθιά εσωτερική μεταμόρφωση και πνευματική σύνδεση.', 'bg': 'Преживявате дълбока вътрешна трансформация и духовна връзка.'},
  reflectionPoints: {'tr': ['Spiritüel yolculuğumda neredeyim?', 'Hangi enerji blokajlarını serbest bırakmam gerekiyor?'], 'en': ['Where am I on my spiritual journey?', 'What energy blockages do I need to release?'], 'fr': ['Où suis-je dans mon parcours spirituel?'], 'de': ['Wo bin ich auf meiner spirituellen Reise?'], 'es': ['¿Dónde estoy en mi viaje espiritual?'], 'ru': ['Где я на своём духовном пути?'], 'ar': ['أين أنا في رحلتي الروحية؟'], 'zh': ['我在灵性之旅的哪个阶段？'], 'el': ['Πού είμαι στο πνευματικό μου ταξίδι;'], 'bg': ['Къде съм в духовното си пътуване?']},
  safetyDisclaimer: {'tr': '⚠️ Kundalini Reiki spiritüel refah aracıdır ve tıbbi tedavi yerine geçmez. Eğlence amaçlıdır ve bilimsel olarak kanıtlanmamıştır. Ciddi sağlık sorunlarında profesyonel yardım alınız.', 'en': '⚠️ Kundalini Reiki is a spiritual wellness tool and does not replace medical treatment. It is for entertainment purposes and is not scientifically proven. Seek professional help for serious health issues.', 'fr': '⚠️ Le Reiki Kundalini est un outil de bien-être spirituel et ne remplace pas le traitement médical.', 'de': '⚠️ Kundalini Reiki ist ein spirituelles Wellness-Tool und ersetzt keine medizinische Behandlung.', 'es': '⚠️ El Reiki Kundalini es una herramienta de bienestar espiritual y no reemplaza el tratamiento médico.', 'ru': '⚠️ Кундалини Рейки — инструмент духовного благополучия и не заменяет медицинское лечение.', 'ar': '⚠️ ريكي الكونداليني أداة للرفاهية الروحية ولا يحل محل العلاج الطبي.', 'zh': '⚠️ 昆达里尼灵气是灵性健康工具，不能替代医疗。', 'el': '⚠️ Το Κουνταλίνι Ρέικι είναι εργαλείο πνευματικής ευεξίας και δεν αντικαθιστά ιατρική θεραπεία.', 'bg': '⚠️ Кундалини Рейки е инструмент за духовно благополучие и не заменя медицинско лечение.'},
  doesNotDo: {'tr': ['Tıbbi tedavi sağlamaz', 'Fiziksel hastalıkları tedavi etmez', 'Garantili sonuçlar vadetmez'], 'en': ['Does not provide medical treatment', 'Does not cure physical diseases', 'Does not promise guaranteed results'], 'fr': ['Ne fournit pas de traitement médical'], 'de': ['Bietet keine medizinische Behandlung'], 'es': ['No proporciona tratamiento médico'], 'ru': ['Не обеспечивает медицинское лечение'], 'ar': ['لا يوفر علاجاً طبياً'], 'zh': ['不提供医疗'], 'el': ['Δεν παρέχει ιατρική θεραπεία'], 'bg': ['Не осигурява медицинско лечение']},
  exampleScenarios: {'tr': ['Uzun süredir meditasyon yapan bir kişi Kundalini Reiki ile daha derin spiritüel deneyimler yaşadığını hissetti.'], 'en': ['A long-time meditator felt deeper spiritual experiences after Kundalini Reiki sessions.'], 'fr': ['Un méditant de longue date a ressenti des expériences spirituelles plus profondes.'], 'de': ['Ein langjähriger Meditierender fühlte tiefere spirituelle Erfahrungen.'], 'es': ['Un meditador de mucho tiempo sintió experiencias espirituales más profundas.'], 'ru': ['Давно медитирующий почувствовал более глубокие духовные переживания.'], 'ar': ['شعر متأمل طويل الأمد بتجارب روحية أعمق.'], 'zh': ['一位长期冥想者感受到更深的灵性体验。'], 'el': ['Ένας μακροχρόνιος διαλογιστής ένιωσε βαθύτερες πνευματικές εμπειρίες.'], 'bg': ['Дългогодишен медитатор почувства по-дълбоки духовни преживявания.']},
  faq: {'tr': [FAQItem(question: 'Kundalini Reiki tehlikeli mi?', answer: 'Bu sistemde kundalini nazikçe ve kontrollü uyandırılır, agresif yöntemler kullanılmaz.'), FAQItem(question: 'Kundalini yoga deneyimim olmalı mı?', answer: 'Hayır, önceden deneyim gerekmez.')], 'en': [FAQItem(question: 'Is Kundalini Reiki dangerous?', answer: 'In this system, kundalini is awakened gently and controlled, no aggressive methods are used.'), FAQItem(question: 'Do I need Kundalini yoga experience?', answer: 'No, prior experience is not required.')], 'fr': [FAQItem(question: 'Le Reiki Kundalini est-il dangereux?', answer: 'Dans ce système, kundalini est éveillée doucement et contrôlée.')], 'de': [FAQItem(question: 'Ist Kundalini Reiki gefährlich?', answer: 'In diesem System wird Kundalini sanft und kontrolliert erweckt.')], 'es': [FAQItem(question: '¿Es peligroso el Reiki Kundalini?', answer: 'En este sistema, kundalini se despierta suave y controladamente.')], 'ru': [FAQItem(question: 'Опасно ли Кундалини Рейки?', answer: 'В этой системе кундалини пробуждается мягко и контролируемо.')], 'ar': [FAQItem(question: 'هل ريكي الكونداليني خطير؟', answer: 'في هذا النظام، يتم إيقاظ الكونداليني بلطف وسيطرة.')], 'zh': [FAQItem(question: '昆达里尼灵气危险吗？', answer: '在这个系统中，昆达里尼被温和和受控地唤醒。')], 'el': [FAQItem(question: 'Είναι επικίνδυνο το Κουνταλίνι Ρέικι;', answer: 'Σε αυτό το σύστημα η κουνταλίνι ξυπνά απαλά και ελεγχόμενα.')], 'bg': [FAQItem(question: 'Опасно ли е Кундалини Рейки?', answer: 'В тази система кундалини се събужда нежно и контролирано.')]},
  relatedPractices: {'tr': ['Usui Reiki', 'Kundalini Yoga', 'Çakra Dengeleme'], 'en': ['Usui Reiki', 'Kundalini Yoga', 'Chakra Balancing'], 'fr': ['Reiki Usui', 'Yoga Kundalini', 'Équilibrage des Chakras'], 'de': ['Usui Reiki', 'Kundalini Yoga', 'Chakra-Ausgleich'], 'es': ['Reiki Usui', 'Yoga Kundalini', 'Equilibrio de Chakras'], 'ru': ['Усуи Рейки', 'Кундалини Йога', 'Балансировка Чакр'], 'ar': ['ريكي أوسوي', 'يوغا الكونداليني', 'توازن الشاكرات'], 'zh': ['臼井灵气', '昆达里尼瑜伽', '脉轮平衡'], 'el': ['Ρέικι Ουσούι', 'Κουνταλίνι Γιόγκα', 'Εξισορρόπηση Τσάκρα'], 'bg': ['Усуи Рейки', 'Кундалини Йога', 'Балансиране на Чакри']},
  differenceFromSimilar: {'tr': 'Kundalini Reiki özellikle kundalini enerjisine odaklanır; Usui Reiki daha genel enerji çalışmasıdır.', 'en': 'Kundalini Reiki specifically focuses on kundalini energy; Usui Reiki is more general energy work.', 'fr': 'Le Reiki Kundalini se concentre spécifiquement sur l\'énergie kundalini; le Reiki Usui est un travail énergétique plus général.', 'de': 'Kundalini Reiki konzentriert sich speziell auf Kundalini-Energie; Usui Reiki ist allgemeinere Energiearbeit.', 'es': 'El Reiki Kundalini se enfoca específicamente en la energía kundalini; el Reiki Usui es trabajo energético más general.', 'ru': 'Кундалини Рейки специально фокусируется на энергии кундалини; Усуи Рейки — более общая энергетическая работа.', 'ar': 'ريكي الكونداليني يركز تحديداً على طاقة الكونداليني؛ ريكي أوسوي هو عمل طاقة أكثر عمومية.', 'zh': '昆达里尼灵气专门关注昆达里尼能量；臼井灵气是更一般的能量工作。', 'el': 'Το Κουνταλίνι Ρέικι επικεντρώνεται ειδικά στην ενέργεια κουνταλίνι· το Ρέικι Ουσούι είναι πιο γενική ενεργειακή εργασία.', 'bg': 'Кундалини Рейки специално се фокусира върху кундалини енергията; Усуи Рейки е по-обща енергийна работа.'},
  microLearning: {'tr': ['💡 Kundalini yılan şeklinde temsil edilir çünkü spiral olarak yükselir.', '💡 Kundalini uyanışı kademeli ve nazik olmalıdır.'], 'en': ['💡 Kundalini is represented as a snake because it rises in a spiral.', '💡 Kundalini awakening should be gradual and gentle.'], 'fr': ['💡 Kundalini est représentée comme un serpent car elle s\'élève en spirale.'], 'de': ['💡 Kundalini wird als Schlange dargestellt, weil sie spiralförmig aufsteigt.'], 'es': ['💡 Kundalini se representa como una serpiente porque se eleva en espiral.'], 'ru': ['💡 Кундалини изображается как змея, потому что она поднимается по спирали.'], 'ar': ['💡 تُمثل الكونداليني كثعبان لأنها ترتفع بشكل حلزوني.'], 'zh': ['💡 昆达里尼被表示为蛇，因为它以螺旋形上升。'], 'el': ['💡 Η Κουνταλίνι αναπαρίσταται ως φίδι γιατί ανεβαίνει σπειροειδώς.'], 'bg': ['💡 Кундалини се представя като змия, защото се издига спираловидно.']},
);

// ═══════════════════════════════════════════════════════════════════════════════
// REIKI - LOVE REIKI
// ═══════════════════════════════════════════════════════════════════════════════

final reikiLove = ServiceContent(
  id: 'reiki_love',
  category: ServiceCategory.reiki,
  icon: '💗',
  displayOrder: 15,
  name: {
    'tr': 'Aşk Reikisi',
    'en': 'Love Reiki',
    'fr': 'Reiki d\'Amour',
    'de': 'Liebes-Reiki',
    'es': 'Reiki del Amor',
    'ru': 'Рейки Любви',
    'ar': 'ريكي الحب',
    'zh': '爱情灵气',
    'el': 'Ρέικι Αγάπης',
    'bg': 'Рейки на Любовта',
  },
  shortDescription: {
    'tr': 'Kalp çakrasını iyileştirerek sevgi enerjisini artırın ve ilişkilerinizi dönüştürün.',
    'en': 'Heal your heart chakra to increase love energy and transform your relationships.',
    'fr': 'Guérissez votre chakra du cœur pour augmenter l\'énergie d\'amour.',
    'de': 'Heilen Sie Ihr Herzchakra, um Liebesenergie zu erhöhen.',
    'es': 'Sana tu chakra del corazón para aumentar la energía del amor.',
    'ru': 'Исцелите свою сердечную чакру, чтобы увеличить энергию любви.',
    'ar': 'اشفِ شاكرا قلبك لزيادة طاقة الحب.',
    'zh': '治愈您的心轮以增加爱的能量。',
    'el': 'Θεραπεύστε το τσάκρα της καρδιάς για να αυξήσετε την ενέργεια αγάπης.',
    'bg': 'Изцелете сърдечната си чакра, за да увеличите енергията на любовта.',
  },
  coreExplanation: {
    'tr': 'Aşk Reikisi, kalp çakrasına ve sevgi enerjisine odaklanan özel bir Reiki formudur. Bu uygulama, geçmiş kalp yaralarını iyileştirmeye, kendine sevgiyi artırmaya, romantik ilişkilerde uyumu desteklemeye ve koşulsuz sevgi enerjisini aktive etmeye yardımcı olur. Hem kendinize hem de başkalarına karşı daha derin bir şefkat geliştirmenizi sağlar.',
    'en': 'Love Reiki is a specialized form of Reiki focusing on the heart chakra and love energy. This practice helps heal past heart wounds, increase self-love, support harmony in romantic relationships, and activate unconditional love energy. It enables you to develop deeper compassion towards both yourself and others.',
    'fr': 'Le Reiki d\'Amour est une forme spécialisée de Reiki axée sur le chakra du cœur.',
    'de': 'Liebes-Reiki ist eine spezialisierte Form, die sich auf das Herzchakra konzentriert.',
    'es': 'El Reiki del Amor es una forma especializada enfocada en el chakra del corazón.',
    'ru': 'Рейки Любви — специализированная форма Рейки, фокусирующаяся на сердечной чакре.',
    'ar': 'ريكي الحب هو شكل متخصص من الريكي يركز على شاكرا القلب.',
    'zh': '爱情灵气是专注于心轮和爱的能量的特殊灵气形式。',
    'el': 'Το Ρέικι Αγάπης είναι μια εξειδικευμένη μορφή που εστιάζει στο τσάκρα της καρδιάς.',
    'bg': 'Рейки на Любовта е специализирана форма, фокусирана върху сърдечната чакра.',
  },
  historicalBackground: {'tr': 'Aşk odaklı enerji çalışmaları, kalp çakrasının önemine vurgu yapan Hint ve Tibet geleneklerinden kaynaklanır.', 'en': 'Love-focused energy work stems from Indian and Tibetan traditions emphasizing the importance of the heart chakra.', 'fr': 'Le travail énergétique axé sur l\'amour provient des traditions indiennes et tibétaines.', 'de': 'Liebesorientierte Energiearbeit stammt aus indischen und tibetischen Traditionen.', 'es': 'El trabajo energético enfocado en el amor proviene de tradiciones indias y tibetanas.', 'ru': 'Энергетическая работа с любовью происходит из индийских и тибетских традиций.', 'ar': 'العمل الطاقي المركز على الحب ينبع من التقاليد الهندية والتبتية.', 'zh': '以爱为焦点的能量工作源于印度和西藏传统。', 'el': 'Η ενεργειακή εργασία εστιασμένη στην αγάπη προέρχεται από ινδικές και θιβετιανές παραδόσεις.', 'bg': 'Енергийната работа, фокусирана върху любовта, произлиза от индийски и тибетски традиции.'},
  philosophicalFoundation: {'tr': 'Sevgi, evrenin temel enerjisidir. Kalp çakrası açıldığında, bu evrensel sevgiye bağlanırız.', 'en': 'Love is the fundamental energy of the universe. When the heart chakra opens, we connect to this universal love.', 'fr': 'L\'amour est l\'énergie fondamentale de l\'univers.', 'de': 'Liebe ist die fundamentale Energie des Universums.', 'es': 'El amor es la energía fundamental del universo.', 'ru': 'Любовь — фундаментальная энергия вселенной.', 'ar': 'الحب هو الطاقة الأساسية للكون.', 'zh': '爱是宇宙的基本能量。', 'el': 'Η αγάπη είναι η θεμελιώδης ενέργεια του σύμπαντος.', 'bg': 'Любовта е фундаменталната енергия на вселената.'},
  howItWorks: {'tr': '1. Kalp çakrası temizlenir ve açılır\n2. Geçmiş duygusal yaralar iyileştirilir\n3. Koşulsuz sevgi enerjisi aktive edilir\n4. İlişki kalıpları dönüştürülür', 'en': '1. Heart chakra is cleansed and opened\n2. Past emotional wounds are healed\n3. Unconditional love energy is activated\n4. Relationship patterns are transformed', 'fr': '1. Le chakra du cœur est nettoyé et ouvert...', 'de': '1. Das Herzchakra wird gereinigt und geöffnet...', 'es': '1. El chakra del corazón se limpia y abre...', 'ru': '1. Сердечная чакра очищается и открывается...', 'ar': '1. شاكرا القلب تُنظف وتُفتح...', 'zh': '1. 心轮被清洁和打开...', 'el': '1. Το τσάκρα της καρδιάς καθαρίζεται και ανοίγει...', 'bg': '1. Сърдечната чакра се пречиства и отваря...'},
  symbolicInterpretation: {'tr': 'Pembe ve yeşil renkler kalp çakrasını; gül ve lotus çiçeği açan sevgiyi simgeler.', 'en': 'Pink and green colors represent the heart chakra; rose and lotus flowers symbolize blooming love.', 'fr': 'Les couleurs rose et verte représentent le chakra du cœur.', 'de': 'Rosa und Grün repräsentieren das Herzchakra.', 'es': 'Los colores rosa y verde representan el chakra del corazón.', 'ru': 'Розовый и зелёный цвета представляют сердечную чакру.', 'ar': 'اللون الوردي والأخضر يمثلان شاكرا القلب.', 'zh': '粉色和绿色代表心轮。', 'el': 'Το ροζ και πράσινο αντιπροσωπεύουν το τσάκρα της καρδιάς.', 'bg': 'Розовият и зеленият цвят представляват сърдечната чакра.'},
  insightsProvided: {'tr': 'Kalp iyileşmesi, kendine sevgi, ilişki uyumu, duygusal blokaj çözümü.', 'en': 'Heart healing, self-love, relationship harmony, emotional blockage resolution.', 'fr': 'Guérison du cœur, amour de soi, harmonie relationnelle.', 'de': 'Herzheilung, Selbstliebe, Beziehungsharmonie.', 'es': 'Sanación del corazón, amor propio, armonía en relaciones.', 'ru': 'Исцеление сердца, самолюбие, гармония в отношениях.', 'ar': 'شفاء القلب، حب الذات، انسجام العلاقات.', 'zh': '心灵治愈，自爱，关系和谐。', 'el': 'Θεραπεία καρδιάς, αυτοαγάπη, αρμονία σχέσεων.', 'bg': 'Изцеление на сърцето, себелюбие, хармония в отношенията.'},
  commonMotivations: {'tr': ['Kalp kırıklığını iyileştirme', 'Kendine sevgiyi artırma', 'İlişki çekmek', 'Duygusal blokajları çözme'], 'en': ['Healing heartbreak', 'Increasing self-love', 'Attracting relationships', 'Releasing emotional blockages'], 'fr': ['Guérir d\'une peine de cœur'], 'de': ['Herzschmerz heilen'], 'es': ['Sanar el corazón roto'], 'ru': ['Исцеление от разбитого сердца'], 'ar': ['شفاء كسر القلب'], 'zh': ['治愈心碎'], 'el': ['Θεραπεία καρδιακού πόνου'], 'bg': ['Изцеление на разбито сърце']},
  lifeThemes: {'tr': ['Romantik ilişkiler', 'Aile', 'Arkadaşlık', 'Kendine sevgi'], 'en': ['Romantic relationships', 'Family', 'Friendship', 'Self-love'], 'fr': ['Relations romantiques'], 'de': ['Romantische Beziehungen'], 'es': ['Relaciones románticas'], 'ru': ['Романтические отношения'], 'ar': ['العلاقات العاطفية'], 'zh': ['浪漫关系'], 'el': ['Ρομαντικές σχέσεις'], 'bg': ['Романтични отношения']},
  whatYouReceive: {'tr': '• Kalp çakrası iyileştirmesi\n• Duygusal blokaj temizliği\n• Koşulsuz sevgi aktivasyonu\n• İlişki enerji harmonizasyonu\n• Kendine sevgi meditasyonu', 'en': '• Heart chakra healing\n• Emotional blockage cleansing\n• Unconditional love activation\n• Relationship energy harmonization\n• Self-love meditation', 'fr': '• Guérison du chakra du cœur...', 'de': '• Herzchakra-Heilung...', 'es': '• Sanación del chakra del corazón...', 'ru': '• Исцеление сердечной чакры...', 'ar': '• شفاء شاكرا القلب...', 'zh': '• 心轮治愈...', 'el': '• Θεραπεία τσάκρα καρδιάς...', 'bg': '• Изцеление на сърдечната чакра...'},
  perspectiveGained: {'tr': 'Kendinize ve başkalarına daha derin bir sevgi ve şefkat geliştirirsiniz.', 'en': 'You develop deeper love and compassion towards yourself and others.', 'fr': 'Vous développez un amour et une compassion plus profonds envers vous-même et les autres.', 'de': 'Sie entwickeln tiefere Liebe und Mitgefühl für sich selbst und andere.', 'es': 'Desarrollas amor y compasión más profundos hacia ti mismo y los demás.', 'ru': 'Вы развиваете более глубокую любовь и сострадание к себе и другим.', 'ar': 'تطور حباً وتعاطفاً أعمق تجاه نفسك والآخرين.', 'zh': '您对自己和他人发展更深的爱和同情。', 'el': 'Αναπτύσσετε βαθύτερη αγάπη και συμπόνια για τον εαυτό σας και τους άλλους.', 'bg': 'Развивате по-дълбока любов и състрадание към себе си и другите.'},
  reflectionPoints: {'tr': ['Kendime ne kadar sevgi gösteriyorum?', 'Hangi kalp yaralarını iyileştirmem gerekiyor?'], 'en': ['How much love do I show myself?', 'What heart wounds do I need to heal?'], 'fr': ['Combien d\'amour est-ce que je me montre?'], 'de': ['Wie viel Liebe zeige ich mir selbst?'], 'es': ['¿Cuánto amor me muestro a mí mismo?'], 'ru': ['Сколько любви я проявляю к себе?'], 'ar': ['كم من الحب أظهر لنفسي؟'], 'zh': ['我给自己多少爱？'], 'el': ['Πόση αγάπη δείχνω στον εαυτό μου;'], 'bg': ['Колко любов показвам на себе си?']},
  safetyDisclaimer: {'tr': '⚠️ Aşk Reikisi spiritüel refah aracıdır ve psikoterapi veya ilişki danışmanlığı yerine geçmez. Eğlence amaçlıdır ve bilimsel olarak kanıtlanmamıştır.', 'en': '⚠️ Love Reiki is a spiritual wellness tool and does not replace psychotherapy or relationship counseling. It is for entertainment purposes and is not scientifically proven.', 'fr': '⚠️ Le Reiki d\'Amour est un outil de bien-être spirituel et ne remplace pas la psychothérapie.', 'de': '⚠️ Liebes-Reiki ist ein spirituelles Wellness-Tool und ersetzt keine Psychotherapie.', 'es': '⚠️ El Reiki del Amor es una herramienta de bienestar espiritual y no reemplaza la psicoterapia.', 'ru': '⚠️ Рейки Любви — инструмент духовного благополучия и не заменяет психотерапию.', 'ar': '⚠️ ريكي الحب أداة للرفاهية الروحية ولا يحل محل العلاج النفسي.', 'zh': '⚠️ 爱情灵气是灵性健康工具，不能替代心理治疗。', 'el': '⚠️ Το Ρέικι Αγάπης είναι εργαλείο πνευματικής ευεξίας και δεν αντικαθιστά ψυχοθεραπεία.', 'bg': '⚠️ Рейки на Любовта е инструмент за духовно благополучие и не заменя психотерапия.'},
  doesNotDo: {'tr': ['Psikolojik tedavi sağlamaz', 'İlişki garantisi vermez', 'Birini size aşık yapmaz'], 'en': ['Does not provide psychological treatment', 'Does not guarantee relationships', 'Does not make someone fall in love with you'], 'fr': ['Ne fournit pas de traitement psychologique'], 'de': ['Bietet keine psychologische Behandlung'], 'es': ['No proporciona tratamiento psicológico'], 'ru': ['Не обеспечивает психологическое лечение'], 'ar': ['لا يوفر علاجاً نفسياً'], 'zh': ['不提供心理治疗'], 'el': ['Δεν παρέχει ψυχολογική θεραπεία'], 'bg': ['Не осигурява психологическо лечение']},
  exampleScenarios: {'tr': ['Bir kişi uzun bir ilişkinin bitiminden sonra Aşk Reikisi ile kalp iyileşmesi deneyimledi ve kendine sevgisini artırdı.'], 'en': ['A person experienced heart healing after a long relationship ended with Love Reiki and increased their self-love.'], 'fr': ['Une personne a vécu une guérison du cœur après la fin d\'une longue relation avec le Reiki d\'Amour.'], 'de': ['Eine Person erlebte Herzheilung nach dem Ende einer langen Beziehung mit Liebes-Reiki.'], 'es': ['Una persona experimentó sanación del corazón después del fin de una relación larga con Reiki del Amor.'], 'ru': ['Человек пережил исцеление сердца после окончания долгих отношений с Рейки Любви.'], 'ar': ['شخص اختبر شفاء القلب بعد انتهاء علاقة طويلة مع ريكي الحب.'], 'zh': ['一个人在长期关系结束后通过爱情灵气体验了心灵治愈。'], 'el': ['Ένα άτομο βίωσε θεραπεία καρδιάς μετά το τέλος μιας μακράς σχέσης με Ρέικι Αγάπης.'], 'bg': ['Човек преживя изцеление на сърцето след края на дълга връзка с Рейки на Любовта.']},
  faq: {'tr': [FAQItem(question: 'Aşk Reikisi romantik ilişki getirir mi?', answer: 'Enerji dengenizi iyileştirerek ilişkilere açık olmanızı destekler, ancak garanti vermez.'), FAQItem(question: 'Bekar olmam gerekiyor mu?', answer: 'Hayır, ilişkide olanlar da kalp iyileştirmesi için yaptırabilir.')], 'en': [FAQItem(question: 'Will Love Reiki bring me a romantic relationship?', answer: 'It supports your openness to relationships by improving your energy balance, but does not guarantee.'), FAQItem(question: 'Do I need to be single?', answer: 'No, those in relationships can also do it for heart healing.')], 'fr': [FAQItem(question: 'Le Reiki d\'Amour m\'apportera-t-il une relation?', answer: 'Il soutient votre ouverture aux relations mais ne garantit pas.')], 'de': [FAQItem(question: 'Wird mir Liebes-Reiki eine Beziehung bringen?', answer: 'Es unterstützt Ihre Offenheit für Beziehungen, garantiert aber nicht.')], 'es': [FAQItem(question: '¿El Reiki del Amor me traerá una relación?', answer: 'Apoya tu apertura a las relaciones pero no garantiza.')], 'ru': [FAQItem(question: 'Принесёт ли мне Рейки Любви отношения?', answer: 'Оно поддерживает вашу открытость к отношениям, но не гарантирует.')], 'ar': [FAQItem(question: 'هل سيجلب لي ريكي الحب علاقة؟', answer: 'يدعم انفتاحك على العلاقات لكن لا يضمن.')], 'zh': [FAQItem(question: '爱情灵气会给我带来浪漫关系吗？', answer: '它支持您对关系的开放，但不保证。')], 'el': [FAQItem(question: 'Θα μου φέρει το Ρέικι Αγάπης μια σχέση;', answer: 'Υποστηρίζει την ανοιχτότητά σας στις σχέσεις αλλά δεν εγγυάται.')], 'bg': [FAQItem(question: 'Ще ми донесе ли Рейки на Любовта връзка?', answer: 'Подкрепя откритостта ви към връзки, но не гарантира.')]},
  relatedPractices: {'tr': ['Usui Reiki', 'Kalp Çakra Meditasyonu', 'Ho\'oponopono'], 'en': ['Usui Reiki', 'Heart Chakra Meditation', 'Ho\'oponopono'], 'fr': ['Reiki Usui', 'Méditation du Chakra du Cœur', 'Ho\'oponopono'], 'de': ['Usui Reiki', 'Herzchakra-Meditation', 'Ho\'oponopono'], 'es': ['Reiki Usui', 'Meditación del Chakra del Corazón', 'Ho\'oponopono'], 'ru': ['Усуи Рейки', 'Медитация Сердечной Чакры', 'Хоопонопоно'], 'ar': ['ريكي أوسوي', 'تأمل شاكرا القلب', 'هوبونوبونو'], 'zh': ['臼井灵气', '心轮冥想', 'Ho\'oponopono'], 'el': ['Ρέικι Ουσούι', 'Διαλογισμός Τσάκρα Καρδιάς', 'Ho\'oponopono'], 'bg': ['Усуи Рейки', 'Медитация на Сърдечната Чакра', 'Ho\'oponopono']},
  differenceFromSimilar: {'tr': 'Aşk Reikisi özellikle kalp çakrasına ve sevgi enerjisine odaklanır; Usui Reiki tüm bedeni dengeler.', 'en': 'Love Reiki specifically focuses on the heart chakra and love energy; Usui Reiki balances the entire body.', 'fr': 'Le Reiki d\'Amour se concentre sur le chakra du cœur; le Reiki Usui équilibre tout le corps.', 'de': 'Liebes-Reiki fokussiert auf das Herzchakra; Usui Reiki balanciert den ganzen Körper.', 'es': 'El Reiki del Amor se enfoca en el chakra del corazón; el Reiki Usui equilibra todo el cuerpo.', 'ru': 'Рейки Любви фокусируется на сердечной чакре; Усуи Рейки балансирует всё тело.', 'ar': 'ريكي الحب يركز على شاكرا القلب؛ ريكي أوسوي يوازن الجسم كله.', 'zh': '爱情灵气专注于心轮；臼井灵气平衡整个身体。', 'el': 'Το Ρέικι Αγάπης εστιάζει στο τσάκρα καρδιάς· το Ρέικι Ουσούι εξισορροπεί όλο το σώμα.', 'bg': 'Рейки на Любовта се фокусира върху сърдечната чакра; Усуи Рейки балансира цялото тяло.'},
  microLearning: {'tr': ['💡 Kalp çakrası yeşil ve pembe renklerle ilişkilidir.', '💡 Kendine sevgi, başkalarını sevmenin temelidir.'], 'en': ['💡 Heart chakra is associated with green and pink colors.', '💡 Self-love is the foundation of loving others.'], 'fr': ['💡 Le chakra du cœur est associé aux couleurs verte et rose.'], 'de': ['💡 Das Herzchakra ist mit Grün und Rosa verbunden.'], 'es': ['💡 El chakra del corazón está asociado con los colores verde y rosa.'], 'ru': ['💡 Сердечная чакра связана с зелёным и розовым цветами.'], 'ar': ['💡 شاكرا القلب مرتبطة باللون الأخضر والوردي.'], 'zh': ['💡 心轮与绿色和粉色相关。'], 'el': ['💡 Το τσάκρα της καρδιάς συνδέεται με πράσινο και ροζ.'], 'bg': ['💡 Сърдечната чакра е свързана със зелен и розов цвят.']},
);

// ═══════════════════════════════════════════════════════════════════════════════
// REIKI - MONEY/ABUNDANCE REIKI
// ═══════════════════════════════════════════════════════════════════════════════

final reikiMoney = ServiceContent(
  id: 'reiki_money',
  category: ServiceCategory.reiki,
  icon: '💰',
  displayOrder: 16,
  name: {
    'tr': 'Bolluk Reikisi',
    'en': 'Abundance Reiki',
    'fr': 'Reiki d\'Abondance',
    'de': 'Fülle-Reiki',
    'es': 'Reiki de Abundancia',
    'ru': 'Рейки Изобилия',
    'ar': 'ريكي الوفرة',
    'zh': '丰盛灵气',
    'el': 'Ρέικι Αφθονίας',
    'bg': 'Рейки на Изобилието',
  },
  shortDescription: {
    'tr': 'Bolluk blokajlarını çözerek finansal ve maddi akışı destekleyin.',
    'en': 'Support financial and material flow by releasing abundance blockages.',
    'fr': 'Soutenez le flux financier en libérant les blocages d\'abondance.',
    'de': 'Unterstützen Sie den finanziellen Fluss, indem Sie Fülle-Blockaden lösen.',
    'es': 'Apoya el flujo financiero liberando bloqueos de abundancia.',
    'ru': 'Поддержите финансовый поток, освобождая блокировки изобилия.',
    'ar': 'ادعم التدفق المالي بتحرير عوائق الوفرة.',
    'zh': '通过释放丰盛障碍来支持财务和物质流动。',
    'el': 'Υποστηρίξτε τη χρηματοοικονομική ροή απελευθερώνοντας μπλοκαρίσματα αφθονίας.',
    'bg': 'Подкрепете финансовия поток, освобождавайки блокажи на изобилието.',
  },
  coreExplanation: {
    'tr': 'Bolluk Reikisi, parayla ve maddi dünyayla ilgili enerji blokajlarını çözmeye odaklanır. Bu uygulama, kısıtlayıcı finansal inançları dönüştürmeye, bolluk titreşimini yükseltmeye ve bereket enerjisini aktive etmeye yardımcı olur. Amaç zenginlik çekmek değil, bolluk akışına engel olan enerjetik kalıpları temizlemektir.',
    'en': 'Abundance Reiki focuses on releasing energy blockages related to money and the material world. This practice helps transform limiting financial beliefs, raise abundance vibration, and activate prosperity energy. The goal is not to attract wealth, but to clear energetic patterns that obstruct the flow of abundance.',
    'fr': 'Le Reiki d\'Abondance se concentre sur la libération des blocages énergétiques liés à l\'argent.',
    'de': 'Fülle-Reiki konzentriert sich auf die Lösung von Energieblockaden im Zusammenhang mit Geld.',
    'es': 'El Reiki de Abundancia se enfoca en liberar bloqueos energéticos relacionados con el dinero.',
    'ru': 'Рейки Изобилия фокусируется на освобождении энергетических блоков, связанных с деньгами.',
    'ar': 'ريكي الوفرة يركز على تحرير العوائق الطاقية المتعلقة بالمال.',
    'zh': '丰盛灵气专注于释放与金钱和物质世界相关的能量障碍。',
    'el': 'Το Ρέικι Αφθονίας επικεντρώνεται στην απελευθέρωση ενεργειακών μπλοκαρισμάτων σχετικών με τα χρήματα.',
    'bg': 'Рейки на Изобилието се фокусира върху освобождаване на енергийни блокажи, свързани с парите.',
  },
  historicalBackground: {'tr': 'Bolluk enerji çalışması, evrenin sınırsız bereket sunduğu inancına dayanan spiritüel geleneklerden gelir.', 'en': 'Abundance energy work comes from spiritual traditions based on the belief that the universe offers unlimited prosperity.', 'fr': 'Le travail énergétique d\'abondance vient des traditions spirituelles basées sur la croyance en la prospérité illimitée.', 'de': 'Fülle-Energiearbeit kommt aus spirituellen Traditionen, die an unbegrenzten Wohlstand glauben.', 'es': 'El trabajo energético de abundancia proviene de tradiciones espirituales basadas en la prosperidad ilimitada.', 'ru': 'Энергетическая работа с изобилием происходит из духовных традиций веры в безграничное процветание.', 'ar': 'العمل الطاقي للوفرة يأتي من التقاليد الروحية القائمة على الإيمان بالازدهار غير المحدود.', 'zh': '丰盛能量工作来自相信宇宙提供无限繁荣的灵性传统。', 'el': 'Η ενεργειακή εργασία αφθονίας προέρχεται από πνευματικές παραδόσεις βασισμένες στην απεριόριστη ευημερία.', 'bg': 'Енергийната работа за изобилие идва от духовни традиции, основани на вярата в неограничен просперитет.'},
  philosophicalFoundation: {'tr': 'Evren sonsuz bolluğa sahiptir; kısıtlılık inancı bir yanılsamadır. Bolluk zihinsel ve enerjetik bir durumdur.', 'en': 'The universe has infinite abundance; belief in scarcity is an illusion. Abundance is a mental and energetic state.', 'fr': 'L\'univers a une abondance infinie; la croyance en la rareté est une illusion.', 'de': 'Das Universum hat unendliche Fülle; der Glaube an Mangel ist eine Illusion.', 'es': 'El universo tiene abundancia infinita; la creencia en la escasez es una ilusión.', 'ru': 'Вселенная имеет бесконечное изобилие; вера в нехватку — иллюзия.', 'ar': 'الكون لديه وفرة لانهائية؛ الإيمان بالندرة وهم.', 'zh': '宇宙拥有无限的丰盛；稀缺的信念是幻觉。', 'el': 'Το σύμπαν έχει άπειρη αφθονία· η πίστη στην έλλειψη είναι ψευδαίσθηση.', 'bg': 'Вселената има безкрайно изобилие; вярата в недостига е илюзия.'},
  howItWorks: {'tr': '1. Kısıtlayıcı finansal inançlar belirlenir\n2. Enerji blokajları temizlenir\n3. Bolluk titreşimi yükseltilir\n4. Bereket enerjisi aktive edilir\n5. Alıcılık kapasitesi genişletilir', 'en': '1. Limiting financial beliefs are identified\n2. Energy blockages are cleansed\n3. Abundance vibration is raised\n4. Prosperity energy is activated\n5. Receiving capacity is expanded', 'fr': '1. Les croyances financières limitantes sont identifiées...', 'de': '1. Begrenzende finanzielle Überzeugungen werden identifiziert...', 'es': '1. Las creencias financieras limitantes se identifican...', 'ru': '1. Ограничивающие финансовые убеждения определяются...', 'ar': '1. تُحدد المعتقدات المالية المقيدة...', 'zh': '1. 识别限制性的财务信念...', 'el': '1. Οι περιοριστικές οικονομικές πεποιθήσεις εντοπίζονται...', 'bg': '1. Ограничаващите финансови вярвания се идентифицират...'},
  symbolicInterpretation: {'tr': 'Altın rengi bolluğu; akan su serbest enerji akışını; tohumlar büyüme potansiyelini simgeler.', 'en': 'Golden color symbolizes abundance; flowing water represents free energy flow; seeds symbolize growth potential.', 'fr': 'La couleur dorée symbolise l\'abondance; l\'eau qui coule représente le flux d\'énergie libre.', 'de': 'Goldene Farbe symbolisiert Fülle; fließendes Wasser repräsentiert freien Energiefluss.', 'es': 'El color dorado simboliza abundancia; el agua que fluye representa flujo de energía libre.', 'ru': 'Золотой цвет символизирует изобилие; текущая вода представляет свободный поток энергии.', 'ar': 'اللون الذهبي يرمز للوفرة؛ الماء الجاري يمثل تدفق الطاقة الحر.', 'zh': '金色象征丰盛；流水代表自由的能量流动。', 'el': 'Το χρυσό χρώμα συμβολίζει αφθονία· το τρεχούμενο νερό αντιπροσωπεύει ελεύθερη ροή ενέργειας.', 'bg': 'Златният цвят символизира изобилие; течащата вода представлява свободен поток на енергия.'},
  insightsProvided: {'tr': 'Finansal blokaj farkındalığı, bolluk zihniyeti, alıcılık kapasitesi, bereket akışı.', 'en': 'Financial blockage awareness, abundance mindset, receiving capacity, prosperity flow.', 'fr': 'Conscience des blocages financiers, mentalité d\'abondance.', 'de': 'Bewusstsein für finanzielle Blockaden, Fülle-Mentalität.', 'es': 'Conciencia de bloqueos financieros, mentalidad de abundancia.', 'ru': 'Осознание финансовых блоков, мышление изобилия.', 'ar': 'وعي العوائق المالية، عقلية الوفرة.', 'zh': '财务障碍意识，丰盛心态。', 'el': 'Επίγνωση οικονομικών μπλοκαρισμάτων, νοοτροπία αφθονίας.', 'bg': 'Осъзнаване на финансови блокажи, мислене за изобилие.'},
  commonMotivations: {'tr': ['Finansal blokajları çözme', 'Bolluk zihniyeti geliştirme', 'Kariyer desteği', 'İş fırsatlarına açılma'], 'en': ['Releasing financial blockages', 'Developing abundance mindset', 'Career support', 'Opening to business opportunities'], 'fr': ['Libérer les blocages financiers'], 'de': ['Finanzielle Blockaden lösen'], 'es': ['Liberar bloqueos financieros'], 'ru': ['Освобождение финансовых блоков'], 'ar': ['تحرير العوائق المالية'], 'zh': ['释放财务障碍'], 'el': ['Απελευθέρωση οικονομικών μπλοκαρισμάτων'], 'bg': ['Освобождаване на финансови блокажи']},
  lifeThemes: {'tr': ['Finans', 'Kariyer', 'İş', 'Maddi güvenlik'], 'en': ['Finance', 'Career', 'Business', 'Material security'], 'fr': ['Finance', 'Carrière'], 'de': ['Finanzen', 'Karriere'], 'es': ['Finanzas', 'Carrera'], 'ru': ['Финансы', 'Карьера'], 'ar': ['المالية', 'المهنة'], 'zh': ['财务', '职业'], 'el': ['Οικονομικά', 'Καριέρα'], 'bg': ['Финанси', 'Кариера']},
  whatYouReceive: {'tr': '• Bolluk enerji aktarımı\n• Finansal blokaj temizliği\n• Kısıtlayıcı inanç dönüşümü\n• Alıcılık aktivasyonu\n• Bolluk meditasyonu', 'en': '• Abundance energy transmission\n• Financial blockage cleansing\n• Limiting belief transformation\n• Receiving activation\n• Abundance meditation', 'fr': '• Transmission d\'énergie d\'abondance...', 'de': '• Fülle-Energieübertragung...', 'es': '• Transmisión de energía de abundancia...', 'ru': '• Передача энергии изобилия...', 'ar': '• نقل طاقة الوفرة...', 'zh': '• 丰盛能量传输...', 'el': '• Μετάδοση ενέργειας αφθονίας...', 'bg': '• Предаване на енергия на изобилието...'},
  perspectiveGained: {'tr': 'Para ve bollukla ilgili sınırlayıcı kalıplarınızı fark eder ve dönüştürürsünüz.', 'en': 'You become aware of and transform your limiting patterns related to money and abundance.', 'fr': 'Vous prenez conscience de vos schémas limitants et les transformez.', 'de': 'Sie werden sich Ihrer begrenzenden Muster bewusst und transformieren sie.', 'es': 'Te das cuenta de tus patrones limitantes y los transformas.', 'ru': 'Вы осознаёте и трансформируете свои ограничивающие паттерны.', 'ar': 'تدرك وتحول أنماطك المقيدة.', 'zh': '您意识到并转化与金钱和丰盛相关的限制性模式。', 'el': 'Συνειδητοποιείτε και μετασχηματίζετε τα περιοριστικά σας πρότυπα.', 'bg': 'Осъзнавате и трансформирате ограничаващите си модели.'},
  reflectionPoints: {'tr': ['Para hakkında hangi inançlarım var?', 'Almaya ne kadar açığım?'], 'en': ['What beliefs do I have about money?', 'How open am I to receiving?'], 'fr': ['Quelles croyances ai-je sur l\'argent?'], 'de': ['Welche Überzeugungen habe ich über Geld?'], 'es': ['¿Qué creencias tengo sobre el dinero?'], 'ru': ['Какие у меня убеждения о деньгах?'], 'ar': ['ما معتقداتي عن المال؟'], 'zh': ['我对金钱有什么信念？'], 'el': ['Τι πιστεύω για τα χρήματα;'], 'bg': ['Какви вярвания имам за парите?']},
  safetyDisclaimer: {'tr': '⚠️ Bolluk Reikisi spiritüel refah aracıdır ve finansal danışmanlık yerine geçmez. Eğlence amaçlıdır, bilimsel olarak kanıtlanmamıştır ve para kazanmayı garanti etmez.', 'en': '⚠️ Abundance Reiki is a spiritual wellness tool and does not replace financial advice. It is for entertainment purposes, is not scientifically proven, and does not guarantee making money.', 'fr': '⚠️ Le Reiki d\'Abondance est un outil spirituel et ne remplace pas les conseils financiers.', 'de': '⚠️ Fülle-Reiki ist ein spirituelles Tool und ersetzt keine Finanzberatung.', 'es': '⚠️ El Reiki de Abundancia es una herramienta espiritual y no reemplaza el asesoramiento financiero.', 'ru': '⚠️ Рейки Изобилия — духовный инструмент и не заменяет финансовые консультации.', 'ar': '⚠️ ريكي الوفرة أداة روحية ولا يحل محل المشورة المالية.', 'zh': '⚠️ 丰盛灵气是灵性工具，不能替代财务建议。', 'el': '⚠️ Το Ρέικι Αφθονίας είναι πνευματικό εργαλείο και δεν αντικαθιστά οικονομικές συμβουλές.', 'bg': '⚠️ Рейки на Изобилието е духовен инструмент и не заменя финансови съвети.'},
  doesNotDo: {'tr': ['Para kazanmayı garanti etmez', 'Yatırım tavsiyesi vermez', 'Ani zenginlik sağlamaz'], 'en': ['Does not guarantee making money', 'Does not give investment advice', 'Does not provide sudden wealth'], 'fr': ['Ne garantit pas de gagner de l\'argent'], 'de': ['Garantiert kein Geld verdienen'], 'es': ['No garantiza ganar dinero'], 'ru': ['Не гарантирует заработок денег'], 'ar': ['لا يضمن كسب المال'], 'zh': ['不保证赚钱'], 'el': ['Δεν εγγυάται να κερδίσετε χρήματα'], 'bg': ['Не гарантира печелене на пари']},
  exampleScenarios: {'tr': ['Bir girişimci Bolluk Reikisi sonrası para konusundaki olumsuz inançlarını fark edip dönüştürdü.'], 'en': ['An entrepreneur recognized and transformed negative beliefs about money after Abundance Reiki.'], 'fr': ['Un entrepreneur a reconnu et transformé ses croyances négatives sur l\'argent.'], 'de': ['Ein Unternehmer erkannte und transformierte negative Überzeugungen über Geld.'], 'es': ['Un emprendedor reconoció y transformó creencias negativas sobre el dinero.'], 'ru': ['Предприниматель осознал и трансформировал негативные убеждения о деньгах.'], 'ar': ['أدرك رائد أعمال وحول معتقداته السلبية عن المال.'], 'zh': ['一位企业家认识到并转化了关于金钱的负面信念。'], 'el': ['Ένας επιχειρηματίας αναγνώρισε και μετασχημάτισε αρνητικές πεποιθήσεις για τα χρήματα.'], 'bg': ['Предприемач разпозна и трансформира негативни вярвания за парите.']},
  faq: {'tr': [FAQItem(question: 'Bolluk Reikisi zengin yapar mı?', answer: 'Enerji blokajlarını çözmeye yardımcı olur, ancak zenginlik garantisi vermez.'), FAQItem(question: 'Ne sıklıkla yapılmalı?', answer: 'İhtiyaca göre düzenli seanslar faydalı olabilir.')], 'en': [FAQItem(question: 'Will Abundance Reiki make me rich?', answer: 'It helps release energy blockages but does not guarantee wealth.'), FAQItem(question: 'How often should it be done?', answer: 'Regular sessions based on need can be beneficial.')], 'fr': [FAQItem(question: 'Le Reiki d\'Abondance me rendra-t-il riche?', answer: 'Il aide à libérer les blocages énergétiques mais ne garantit pas la richesse.')], 'de': [FAQItem(question: 'Macht mich Fülle-Reiki reich?', answer: 'Es hilft, Energieblockaden zu lösen, garantiert aber keinen Reichtum.')], 'es': [FAQItem(question: '¿El Reiki de Abundancia me hará rico?', answer: 'Ayuda a liberar bloqueos energéticos pero no garantiza riqueza.')], 'ru': [FAQItem(question: 'Сделает ли меня Рейки Изобилия богатым?', answer: 'Помогает освободить энергетические блоки, но не гарантирует богатство.')], 'ar': [FAQItem(question: 'هل سيجعلني ريكي الوفرة غنياً؟', answer: 'يساعد في تحرير العوائق الطاقية لكن لا يضمن الثروة.')], 'zh': [FAQItem(question: '丰盛灵气会让我变富吗？', answer: '它帮助释放能量障碍，但不保证财富。')], 'el': [FAQItem(question: 'Θα με κάνει πλούσιο το Ρέικι Αφθονίας;', answer: 'Βοηθά να απελευθερωθούν ενεργειακά μπλοκαρίσματα αλλά δεν εγγυάται πλούτο.')], 'bg': [FAQItem(question: 'Ще ме направи ли Рейки на Изобилието богат?', answer: 'Помага да се освободят енергийни блокажи, но не гарантира богатство.')]},
  relatedPractices: {'tr': ['Usui Reiki', 'Bolluk Meditasyonu', 'Feng Shui'], 'en': ['Usui Reiki', 'Abundance Meditation', 'Feng Shui'], 'fr': ['Reiki Usui', 'Méditation d\'Abondance', 'Feng Shui'], 'de': ['Usui Reiki', 'Fülle-Meditation', 'Feng Shui'], 'es': ['Reiki Usui', 'Meditación de Abundancia', 'Feng Shui'], 'ru': ['Усуи Рейки', 'Медитация Изобилия', 'Фэн-шуй'], 'ar': ['ريكي أوسوي', 'تأمل الوفرة', 'فنغ شوي'], 'zh': ['臼井灵气', '丰盛冥想', '风水'], 'el': ['Ρέικι Ουσούι', 'Διαλογισμός Αφθονίας', 'Φενγκ Σούι'], 'bg': ['Усуи Рейки', 'Медитация за Изобилие', 'Фън Шуй']},
  differenceFromSimilar: {'tr': 'Bolluk Reikisi özellikle finansal ve maddi konulara odaklanır; Usui Reiki genel enerji dengesi sağlar.', 'en': 'Abundance Reiki specifically focuses on financial and material topics; Usui Reiki provides general energy balance.', 'fr': 'Le Reiki d\'Abondance se concentre sur les sujets financiers; le Reiki Usui équilibre général.', 'de': 'Fülle-Reiki fokussiert auf finanzielle Themen; Usui Reiki bietet allgemeine Balance.', 'es': 'El Reiki de Abundancia se enfoca en temas financieros; el Reiki Usui equilibra en general.', 'ru': 'Рейки Изобилия фокусируется на финансовых темах; Усуи Рейки обеспечивает общий баланс.', 'ar': 'ريكي الوفرة يركز على المواضيع المالية؛ ريكي أوسوي يوفر توازن عام.', 'zh': '丰盛灵气专注于财务和物质主题；臼井灵气提供一般能量平衡。', 'el': 'Το Ρέικι Αφθονίας εστιάζει σε οικονομικά θέματα· το Ρέικι Ουσούι παρέχει γενική ισορροπία.', 'bg': 'Рейки на Изобилието се фокусира върху финансови теми; Усуи Рейки осигурява общ баланс.'},
  microLearning: {'tr': ['💡 Bolluk bir zihniyet durumudur, sadece para değil.', '💡 Vermek ve almak arasında denge önemlidir.'], 'en': ['💡 Abundance is a mindset, not just money.', '💡 Balance between giving and receiving is important.'], 'fr': ['💡 L\'abondance est un état d\'esprit, pas seulement de l\'argent.'], 'de': ['💡 Fülle ist eine Denkweise, nicht nur Geld.'], 'es': ['💡 La abundancia es una mentalidad, no solo dinero.'], 'ru': ['💡 Изобилие — это мышление, а не только деньги.'], 'ar': ['💡 الوفرة هي عقلية، ليست مجرد مال.'], 'zh': ['💡 丰盛是一种心态，不仅仅是金钱。'], 'el': ['💡 Η αφθονία είναι νοοτροπία, όχι μόνο χρήματα.'], 'bg': ['💡 Изобилието е начин на мислене, не само пари.']},
);

// ═══════════════════════════════════════════════════════════════════════════════
// REIKI - CHAKRA BALANCING
// ═══════════════════════════════════════════════════════════════════════════════

final reikiChakra = ServiceContent(
  id: 'reiki_chakra',
  category: ServiceCategory.reiki,
  icon: '🌈',
  displayOrder: 17,
  name: {
    'tr': 'Çakra Dengeleme Reikisi',
    'en': 'Chakra Balancing Reiki',
    'fr': 'Reiki d\'Équilibrage des Chakras',
    'de': 'Chakra-Ausgleichs-Reiki',
    'es': 'Reiki de Equilibrio de Chakras',
    'ru': 'Рейки Балансировки Чакр',
    'ar': 'ريكي توازن الشاكرات',
    'zh': '脉轮平衡灵气',
    'el': 'Ρέικι Εξισορρόπησης Τσάκρα',
    'bg': 'Рейки за Балансиране на Чакри',
  },
  shortDescription: {
    'tr': 'Yedi ana çakranızı temizleyerek ve dengeleyerek enerji akışınızı optimize edin.',
    'en': 'Optimize your energy flow by cleansing and balancing your seven main chakras.',
    'fr': 'Optimisez votre flux d\'énergie en nettoyant et équilibrant vos sept chakras principaux.',
    'de': 'Optimieren Sie Ihren Energiefluss durch Reinigung und Ausgleich Ihrer sieben Hauptchakren.',
    'es': 'Optimiza tu flujo de energía limpiando y equilibrando tus siete chakras principales.',
    'ru': 'Оптимизируйте поток энергии, очищая и балансируя семь основных чакр.',
    'ar': 'حسّن تدفق طاقتك من خلال تنظيف وموازنة الشاكرات السبع الرئيسية.',
    'zh': '通过清洁和平衡七个主要脉轮来优化您的能量流动。',
    'el': 'Βελτιστοποιήστε τη ροή ενέργειάς σας καθαρίζοντας και εξισορροπώντας τα επτά κύρια τσάκρα.',
    'bg': 'Оптимизирайте енергийния си поток, почиствайки и балансирайки седемте основни чакри.',
  },
  coreExplanation: {
    'tr': 'Çakra Dengeleme Reikisi, yedi ana enerji merkezini sistematik olarak temizler, aktive eder ve dengeler. Her çakra belirli fiziksel, duygusal ve spiritüel işlevlerle ilişkilidir. Bu uygulama, tıkanmış enerji merkezlerini açar, aşırı aktif olanları sakinleştirir ve tüm sistemin uyumlu çalışmasını sağlar.',
    'en': 'Chakra Balancing Reiki systematically cleanses, activates, and balances the seven main energy centers. Each chakra is associated with specific physical, emotional, and spiritual functions. This practice opens blocked energy centers, calms overactive ones, and ensures harmonious functioning of the entire system.',
    'fr': 'Le Reiki d\'Équilibrage des Chakras nettoie, active et équilibre systématiquement les sept centres d\'énergie.',
    'de': 'Chakra-Ausgleichs-Reiki reinigt, aktiviert und balanciert systematisch die sieben Hauptenergiezentren.',
    'es': 'El Reiki de Equilibrio de Chakras limpia, activa y equilibra sistemáticamente los siete centros de energía.',
    'ru': 'Рейки Балансировки Чакр систематически очищает, активирует и балансирует семь основных энергетических центров.',
    'ar': 'ريكي توازن الشاكرات ينظف وينشط ويوازن مراكز الطاقة السبع بشكل منهجي.',
    'zh': '脉轮平衡灵气系统地清洁、激活和平衡七个主要能量中心。',
    'el': 'Το Ρέικι Εξισορρόπησης Τσάκρα καθαρίζει, ενεργοποιεί και εξισορροπεί συστηματικά τα επτά κύρια ενεργειακά κέντρα.',
    'bg': 'Рейки за Балансиране на Чакри систематично почиства, активира и балансира седемте основни енергийни центъра.',
  },
  historicalBackground: {'tr': 'Çakra sistemi binlerce yıllık Hint yogik geleneğinden gelir. Modern çakra dengeleme, Reiki ile entegre edilerek güçlü bir enerji çalışması oluşturur.', 'en': 'The chakra system comes from thousands of years of Indian yogic tradition. Modern chakra balancing integrates with Reiki to create powerful energy work.', 'fr': 'Le système des chakras vient de milliers d\'années de tradition yogique indienne.', 'de': 'Das Chakra-System stammt aus tausenden Jahren indischer yogischer Tradition.', 'es': 'El sistema de chakras proviene de miles de años de tradición yóguica india.', 'ru': 'Система чакр происходит из тысячелетней индийской йогической традиции.', 'ar': 'نظام الشاكرات يأتي من آلاف السنين من التقليد اليوغي الهندي.', 'zh': '脉轮系统来自数千年的印度瑜伽传统。', 'el': 'Το σύστημα τσάκρα προέρχεται από χιλιάδες χρόνια ινδικής γιόγκα παράδοσης.', 'bg': 'Системата на чакрите идва от хилядолетната индийска йога традиция.'},
  philosophicalFoundation: {'tr': 'İnsan bedeni yedi ana enerji merkezinden oluşur. Her çakra dengede olduğunda, fiziksel ve spiritüel sağlık optimal hale gelir.', 'en': 'The human body consists of seven main energy centers. When each chakra is balanced, physical and spiritual health becomes optimal.', 'fr': 'Le corps humain se compose de sept centres d\'énergie principaux.', 'de': 'Der menschliche Körper besteht aus sieben Hauptenergiezentren.', 'es': 'El cuerpo humano consta de siete centros de energía principales.', 'ru': 'Человеческое тело состоит из семи основных энергетических центров.', 'ar': 'يتكون جسم الإنسان من سبعة مراكز طاقة رئيسية.', 'zh': '人体由七个主要能量中心组成。', 'el': 'Το ανθρώπινο σώμα αποτελείται από επτά κύρια ενεργειακά κέντρα.', 'bg': 'Човешкото тяло се състои от седем основни енергийни центъра.'},
  howItWorks: {'tr': '1. Her çakranın durumu değerlendirilir\n2. Bloke çakralar temizlenir\n3. Zayıf çakralar güçlendirilir\n4. Aşırı aktif çakralar sakinleştirilir\n5. Tüm sistem harmonize edilir', 'en': '1. Status of each chakra is assessed\n2. Blocked chakras are cleansed\n3. Weak chakras are strengthened\n4. Overactive chakras are calmed\n5. Entire system is harmonized', 'fr': '1. L\'état de chaque chakra est évalué...', 'de': '1. Der Zustand jedes Chakras wird bewertet...', 'es': '1. Se evalúa el estado de cada chakra...', 'ru': '1. Оценивается состояние каждой чакры...', 'ar': '1. يُقيَّم حالة كل شاكرا...', 'zh': '1. 评估每个脉轮的状态...', 'el': '1. Αξιολογείται η κατάσταση κάθε τσάκρα...', 'bg': '1. Оценява се състоянието на всяка чакра...'},
  symbolicInterpretation: {'tr': 'Her çakra belirli bir renkle temsil edilir: Kök-Kırmızı, Sakral-Turuncu, Solar Pleksus-Sarı, Kalp-Yeşil, Boğaz-Mavi, Üçüncü Göz-Çivit, Taç-Mor.', 'en': 'Each chakra is represented by a specific color: Root-Red, Sacral-Orange, Solar Plexus-Yellow, Heart-Green, Throat-Blue, Third Eye-Indigo, Crown-Violet.', 'fr': 'Chaque chakra est représenté par une couleur spécifique.', 'de': 'Jedes Chakra wird durch eine bestimmte Farbe repräsentiert.', 'es': 'Cada chakra está representado por un color específico.', 'ru': 'Каждая чакра представлена определённым цветом.', 'ar': 'كل شاكرا تُمثَّل بلون محدد.', 'zh': '每个脉轮由特定颜色代表。', 'el': 'Κάθε τσάκρα αντιπροσωπεύεται από ένα συγκεκριμένο χρώμα.', 'bg': 'Всяка чакра е представена от определен цвят.'},
  insightsProvided: {'tr': 'Çakra durumu farkındalığı, enerji akış optimizasyonu, beden-zihin-ruh uyumu.', 'en': 'Chakra status awareness, energy flow optimization, body-mind-spirit harmony.', 'fr': 'Conscience de l\'état des chakras, optimisation du flux d\'énergie.', 'de': 'Chakra-Status-Bewusstsein, Energiefluss-Optimierung.', 'es': 'Conciencia del estado de chakras, optimización del flujo de energía.', 'ru': 'Осознание состояния чакр, оптимизация потока энергии.', 'ar': 'وعي حالة الشاكرات، تحسين تدفق الطاقة.', 'zh': '脉轮状态意识，能量流优化。', 'el': 'Επίγνωση κατάστασης τσάκρα, βελτιστοποίηση ροής ενέργειας.', 'bg': 'Осъзнаване на състоянието на чакрите, оптимизиране на енергийния поток.'},
  commonMotivations: {'tr': ['Genel enerji dengesi', 'Fiziksel iyilik hali', 'Duygusal denge', 'Spiritüel gelişim'], 'en': ['General energy balance', 'Physical wellness', 'Emotional balance', 'Spiritual development'], 'fr': ['Équilibre énergétique général'], 'de': ['Allgemeines Energiegleichgewicht'], 'es': ['Equilibrio energético general'], 'ru': ['Общий энергетический баланс'], 'ar': ['التوازن الطاقي العام'], 'zh': ['一般能量平衡'], 'el': ['Γενική ενεργειακή ισορροπία'], 'bg': ['Общ енергиен баланс']},
  lifeThemes: {'tr': ['Sağlık', 'Duygusal denge', 'İlişkiler', 'Yaratıcılık', 'İletişim', 'Sezgi', 'Spiritüel bağlantı'], 'en': ['Health', 'Emotional balance', 'Relationships', 'Creativity', 'Communication', 'Intuition', 'Spiritual connection'], 'fr': ['Santé', 'Équilibre émotionnel'], 'de': ['Gesundheit', 'Emotionales Gleichgewicht'], 'es': ['Salud', 'Equilibrio emocional'], 'ru': ['Здоровье', 'Эмоциональный баланс'], 'ar': ['الصحة', 'التوازن العاطفي'], 'zh': ['健康', '情绪平衡'], 'el': ['Υγεία', 'Συναισθηματική ισορροπία'], 'bg': ['Здраве', 'Емоционален баланс']},
  whatYouReceive: {'tr': '• Yedi çakra değerlendirmesi\n• Çakra temizliği ve aktivasyonu\n• Enerji dengeleme\n• Çakra harmonizasyonu\n• Kök çakradan taç çakraya tam seans', 'en': '• Seven chakra assessment\n• Chakra cleansing and activation\n• Energy balancing\n• Chakra harmonization\n• Full session from root to crown chakra', 'fr': '• Évaluation des sept chakras...', 'de': '• Beurteilung der sieben Chakren...', 'es': '• Evaluación de siete chakras...', 'ru': '• Оценка семи чакр...', 'ar': '• تقييم الشاكرات السبع...', 'zh': '• 七脉轮评估...', 'el': '• Αξιολόγηση επτά τσάκρα...', 'bg': '• Оценка на седемте чакри...'},
  perspectiveGained: {'tr': 'Enerji sisteminizi daha iyi anlayarak kendi kendine bakım pratiği geliştirirsiniz.', 'en': 'By better understanding your energy system, you develop self-care practice.', 'fr': 'En mieux comprenant votre système énergétique, vous développez des pratiques d\'auto-soin.', 'de': 'Indem Sie Ihr Energiesystem besser verstehen, entwickeln Sie Selbstfürsorge-Praktiken.', 'es': 'Al comprender mejor tu sistema energético, desarrollas prácticas de autocuidado.', 'ru': 'Лучше понимая свою энергетическую систему, вы развиваете практики самопомощи.', 'ar': 'بفهم نظامك الطاقي بشكل أفضل، تطور ممارسات الرعاية الذاتية.', 'zh': '通过更好地了解您的能量系统，您发展自我护理实践。', 'el': 'Κατανοώντας καλύτερα το ενεργειακό σας σύστημα, αναπτύσσετε πρακτικές αυτοφροντίδας.', 'bg': 'Като разбирате по-добре енергийната си система, развивате практики за самогрижа.'},
  reflectionPoints: {'tr': ['Hangi çakralarım dengesiz hissettiriyor?', 'Bedenimin hangi bölgeleri dikkat istiyor?'], 'en': ['Which of my chakras feel imbalanced?', 'Which areas of my body need attention?'], 'fr': ['Lesquels de mes chakras semblent déséquilibrés?'], 'de': ['Welche meiner Chakren fühlen sich unausgewogen an?'], 'es': ['¿Cuáles de mis chakras se sienten desequilibrados?'], 'ru': ['Какие из моих чакр чувствуются несбалансированными?'], 'ar': ['أي من شاكراتي تشعر بعدم التوازن؟'], 'zh': ['我的哪些脉轮感觉不平衡？'], 'el': ['Ποια από τα τσάκρα μου αισθάνονται ανισόρροπα;'], 'bg': ['Кои от чакрите ми се чувстват небалансирани?']},
  safetyDisclaimer: {'tr': '⚠️ Çakra Dengeleme Reikisi spiritüel refah aracıdır ve tıbbi tedavi yerine geçmez. Eğlence amaçlıdır ve bilimsel olarak kanıtlanmamıştır.', 'en': '⚠️ Chakra Balancing Reiki is a spiritual wellness tool and does not replace medical treatment. It is for entertainment purposes and is not scientifically proven.', 'fr': '⚠️ Le Reiki d\'Équilibrage des Chakras est un outil spirituel et ne remplace pas le traitement médical.', 'de': '⚠️ Chakra-Ausgleichs-Reiki ist ein spirituelles Tool und ersetzt keine medizinische Behandlung.', 'es': '⚠️ El Reiki de Equilibrio de Chakras es una herramienta espiritual y no reemplaza el tratamiento médico.', 'ru': '⚠️ Рейки Балансировки Чакр — духовный инструмент и не заменяет медицинское лечение.', 'ar': '⚠️ ريكي توازن الشاكرات أداة روحية ولا يحل محل العلاج الطبي.', 'zh': '⚠️ 脉轮平衡灵气是灵性工具，不能替代医疗。', 'el': '⚠️ Το Ρέικι Εξισορρόπησης Τσάκρα είναι πνευματικό εργαλείο και δεν αντικαθιστά ιατρική θεραπεία.', 'bg': '⚠️ Рейки за Балансиране на Чакри е духовен инструмент и не заменя медицинско лечение.'},
  doesNotDo: {'tr': ['Tıbbi teşhis koymaz', 'Fiziksel hastalıkları tedavi etmez', 'Garantili sonuçlar sağlamaz'], 'en': ['Does not make medical diagnoses', 'Does not treat physical diseases', 'Does not provide guaranteed results'], 'fr': ['Ne pose pas de diagnostic médical'], 'de': ['Stellt keine medizinischen Diagnosen'], 'es': ['No hace diagnósticos médicos'], 'ru': ['Не ставит медицинские диагнозы'], 'ar': ['لا يقوم بتشخيص طبي'], 'zh': ['不进行医学诊断'], 'el': ['Δεν κάνει ιατρικές διαγνώσεις'], 'bg': ['Не поставя медицински диагнози']},
  exampleScenarios: {'tr': ['Kronik yorgunluk yaşayan bir kişi, çakra dengeleme seansı sonrası enerjisinin arttığını hissetti.'], 'en': ['A person experiencing chronic fatigue felt increased energy after a chakra balancing session.'], 'fr': ['Une personne souffrant de fatigue chronique a ressenti une augmentation d\'énergie après une séance.'], 'de': ['Eine Person mit chronischer Müdigkeit fühlte nach einer Sitzung mehr Energie.'], 'es': ['Una persona con fatiga crónica sintió más energía después de una sesión.'], 'ru': ['Человек с хронической усталостью почувствовал прилив энергии после сеанса.'], 'ar': ['شخص يعاني من التعب المزمن شعر بزيادة الطاقة بعد جلسة.'], 'zh': ['一位经历慢性疲劳的人在脉轮平衡疗程后感到能量增加。'], 'el': ['Ένα άτομο με χρόνια κόπωση ένιωσε αυξημένη ενέργεια μετά από μια συνεδρία.'], 'bg': ['Човек с хронична умора почувства увеличена енергия след сеанс.']},
  faq: {'tr': [FAQItem(question: 'Hangi çakramın dengesiz olduğunu nasıl anlarım?', answer: 'Seans sırasında uygulayıcı değerlendirme yapar, ancak semptomlar da ipucu verebilir.'), FAQItem(question: 'Ne sıklıkla yapılmalı?', answer: 'Başlangıçta haftalık, sonra aylık seanslar önerilir.')], 'en': [FAQItem(question: 'How do I know which chakra is imbalanced?', answer: 'The practitioner assesses during the session, but symptoms can also give clues.'), FAQItem(question: 'How often should it be done?', answer: 'Weekly initially, then monthly sessions are recommended.')], 'fr': [FAQItem(question: 'Comment savoir quel chakra est déséquilibré?', answer: 'Le praticien évalue pendant la séance, mais les symptômes peuvent aussi donner des indices.')], 'de': [FAQItem(question: 'Wie weiß ich, welches Chakra unausgewogen ist?', answer: 'Der Praktizierende bewertet während der Sitzung, aber Symptome können auch Hinweise geben.')], 'es': [FAQItem(question: '¿Cómo sé qué chakra está desequilibrado?', answer: 'El practicante evalúa durante la sesión, pero los síntomas también pueden dar pistas.')], 'ru': [FAQItem(question: 'Как узнать, какая чакра несбалансирована?', answer: 'Практик оценивает во время сеанса, но симптомы тоже могут дать подсказки.')], 'ar': [FAQItem(question: 'كيف أعرف أي شاكرا غير متوازنة؟', answer: 'يقيّم الممارس أثناء الجلسة، لكن الأعراض يمكن أن تعطي أدلة.')], 'zh': [FAQItem(question: '我怎么知道哪个脉轮不平衡？', answer: '治疗师在疗程中评估，但症状也可以提供线索。')], 'el': [FAQItem(question: 'Πώς ξέρω ποιο τσάκρα είναι ανισόρροπο;', answer: 'Ο θεραπευτής αξιολογεί κατά τη συνεδρία, αλλά τα συμπτώματα μπορούν επίσης να δώσουν ενδείξεις.')], 'bg': [FAQItem(question: 'Как да разбера коя чакра е небалансирана?', answer: 'Практикуващият оценява по време на сеанса, но симптомите също могат да дадат указания.')]},
  relatedPractices: {'tr': ['Usui Reiki', 'Kundalini Reiki', 'Çakra Meditasyonu', 'Yoga'], 'en': ['Usui Reiki', 'Kundalini Reiki', 'Chakra Meditation', 'Yoga'], 'fr': ['Reiki Usui', 'Reiki Kundalini', 'Méditation des Chakras', 'Yoga'], 'de': ['Usui Reiki', 'Kundalini Reiki', 'Chakra-Meditation', 'Yoga'], 'es': ['Reiki Usui', 'Reiki Kundalini', 'Meditación de Chakras', 'Yoga'], 'ru': ['Усуи Рейки', 'Кундалини Рейки', 'Медитация Чакр', 'Йога'], 'ar': ['ريكي أوسوي', 'ريكي الكونداليني', 'تأمل الشاكرات', 'يوغا'], 'zh': ['臼井灵气', '昆达里尼灵气', '脉轮冥想', '瑜伽'], 'el': ['Ρέικι Ουσούι', 'Κουνταλίνι Ρέικι', 'Διαλογισμός Τσάκρα', 'Γιόγκα'], 'bg': ['Усуи Рейки', 'Кундалини Рейки', 'Медитация на Чакри', 'Йога']},
  differenceFromSimilar: {'tr': 'Çakra Dengeleme Reikisi yedi ana çakraya sistematik olarak odaklanır; Usui Reiki genel enerji akışını dengeler.', 'en': 'Chakra Balancing Reiki systematically focuses on seven main chakras; Usui Reiki balances general energy flow.', 'fr': 'Le Reiki d\'Équilibrage se concentre systématiquement sur sept chakras; le Reiki Usui équilibre le flux général.', 'de': 'Chakra-Ausgleichs-Reiki fokussiert systematisch auf sieben Chakren; Usui Reiki balanciert den allgemeinen Fluss.', 'es': 'El Reiki de Equilibrio se enfoca sistemáticamente en siete chakras; el Reiki Usui equilibra el flujo general.', 'ru': 'Рейки Балансировки систематически фокусируется на семи чакрах; Усуи Рейки балансирует общий поток.', 'ar': 'ريكي التوازن يركز بشكل منهجي على سبع شاكرات؛ ريكي أوسوي يوازن التدفق العام.', 'zh': '脉轮平衡灵气系统地专注于七个主要脉轮；臼井灵气平衡一般能量流。', 'el': 'Το Ρέικι Εξισορρόπησης εστιάζει συστηματικά σε επτά τσάκρα· το Ρέικι Ουσούι εξισορροπεί τη γενική ροή.', 'bg': 'Рейки за Балансиране систематично се фокусира върху седем чакри; Усуи Рейки балансира общия поток.'},
  microLearning: {'tr': ['💡 Her çakra belirli bir frekans ve renkle titreşir.', '💡 Çakralar birbirine bağlıdır; bir tane dengesizse diğerlerini etkiler.', '💡 Kök çakra güvenliği, taç çakra spiritüel bağlantıyı yönetir.'], 'en': ['💡 Each chakra vibrates at a specific frequency and color.', '💡 Chakras are interconnected; if one is imbalanced, it affects others.', '💡 Root chakra governs security, crown chakra governs spiritual connection.'], 'fr': ['💡 Chaque chakra vibre à une fréquence et couleur spécifiques.'], 'de': ['💡 Jedes Chakra vibriert mit einer bestimmten Frequenz und Farbe.'], 'es': ['💡 Cada chakra vibra a una frecuencia y color específicos.'], 'ru': ['💡 Каждая чакра вибрирует на определённой частоте и цвете.'], 'ar': ['💡 كل شاكرا تهتز بتردد ولون محددين.'], 'zh': ['💡 每个脉轮以特定频率和颜色振动。'], 'el': ['💡 Κάθε τσάκρα δονείται σε συγκεκριμένη συχνότητα και χρώμα.'], 'bg': ['💡 Всяка чакра вибрира на определена честота и цвят.']},
);

// ═══════════════════════════════════════════════════════════════════════════════
// MASTER SERVICE LIST - All services registry
// ═══════════════════════════════════════════════════════════════════════════════

/// Complete list of all services
final List<ServiceContent> allServices = [
  // Astrology Services
  astrologyConsultation,
  astrologyAnnualForecast,
  astrologyMonthlyForecast,
  astrologySynastry,
  astrologySolarReturn,
  astrologySingleQuestion,
  astrologyAstrocartography,
  astrologyRectification,
  // Tarot Services
  tarotConsultation,
  tarot3Questions,
  tarotAnnualForecast,
  tarotMonthlyForecast,
  tarotZen,
  // Numerology Services
  numerologyAnalysis,
  numerologyAnnual,
  numerologyRelationship,
  // Energy Healing Services - Reiki
  reikiUsui,
  reikiKundalini,
  reikiLove,
  reikiMoney,
  reikiChakra,
  // Energy Healing Services - Other
  pendulumConsultation,
  jaasConsultation,
  thetaHealingConsultation,
  crescentHealingConsultation,
];

/// Get service by ID
ServiceContent? getServiceById(String id) {
  try {
    return allServices.firstWhere((s) => s.id == id);
  } catch (_) {
    return null;
  }
}

/// Get services by category
List<ServiceContent> getServicesByCategory(ServiceCategory category) {
  return allServices.where((s) => s.category == category).toList()
    ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
}

/// Get localized name for service
String getLocalizedServiceName(ServiceContent service, String languageCode) {
  return service.name[languageCode] ?? service.name['en'] ?? service.id;
}
