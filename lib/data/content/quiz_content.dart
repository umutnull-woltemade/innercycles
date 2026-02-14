// ════════════════════════════════════════════════════════════════════════════
// QUIZ CONTENT - InnerCycles Self-Reflection Quiz Definitions
// ════════════════════════════════════════════════════════════════════════════
// Six thoughtful, psychologically-grounded quizzes for personal awareness.
// NOT clinical assessments. All language uses safe framing:
// "tends to", "you may notice", "patterns suggest".
// ════════════════════════════════════════════════════════════════════════════

import 'dart:ui';
import '../models/quiz_models.dart';

/// All available quizzes in the app
class QuizContent {
  QuizContent._();

  static List<QuizDefinition> get allQuizzes => [
        emotionalIntelligenceQuiz,
        dreamPersonalityQuiz,
        socialBatteryQuiz,
        stressResponseQuiz,
        decisionMakingQuiz,
        energyCycleQuiz,
      ];

  static QuizDefinition? getById(String id) {
    try {
      return allQuizzes.firstWhere((q) => q.id == id);
    } catch (_) {
      return null;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 1) EMOTIONAL INTELLIGENCE QUIZ (10 questions)
  // ══════════════════════════════════════════════════════════════════════════

  static const emotionalIntelligenceQuiz = QuizDefinition(
    id: 'emotional_intelligence',
    title: 'Emotional Intelligence',
    titleTr: 'Duygusal Zeka',
    description: 'Explore how you navigate emotions — yours and others\'.',
    descriptionTr: 'Duyguları nasil yonettiginizi kesfedin — sizin ve baskalarin.',
    emoji: '\u{1F9E0}',
    scoringType: QuizScoringType.multiDimension,
    dimensions: {
      'self_awareness': QuizDimensionMeta(
        key: 'self_awareness',
        nameEn: 'Self-Awareness',
        nameTr: 'Oz Farkindalik',
        emoji: '\u{1F52D}',
        color: Color(0xFF667EEA),
        descriptionEn: 'You may tend to have a clear sense of your own emotional landscape. People with this strength often notice shifts in their mood early and understand what drives their reactions.',
        descriptionTr: 'Kendi duygusal manzaraniz hakkinda net bir alginiz olabilir. Bu guce sahip kisiler genellikle ruh hallerindeki degisimleri erken fark eder.',
        strengthsEn: ['Recognizes emotional triggers quickly', 'Comfortable with self-reflection', 'Honest about personal limitations'],
        strengthsTr: ['Duygusal tetikleyicileri hizla tanir', 'Oz yansitma konusunda rahat', 'Kisisel sinirlamalar hakkinda durust'],
        growthAreasEn: ['Translating self-knowledge into action', 'Sharing inner awareness with others'],
        growthAreasTr: ['Oz bilgiyi eyleme donusturme', 'Ic farkindaligi baskalariyla paylasma'],
      ),
      'empathy': QuizDimensionMeta(
        key: 'empathy',
        nameEn: 'Empathy',
        nameTr: 'Empati',
        emoji: '\u{1F49C}',
        color: Color(0xFF9B59B6),
        descriptionEn: 'You may tend to naturally tune into what others are feeling. This quality often helps you build deep, trusting connections with people around you.',
        descriptionTr: 'Baskalarin ne hissettigine dogal olarak uyum saglama egiliminde olabilirsiniz. Bu ozellik genellikle derin, guvenilir baglantilar kurmaniza yardimci olur.',
        strengthsEn: ['Reads emotional cues with ease', 'Creates safe space for others', 'Strong active listening skills'],
        strengthsTr: ['Duygusal ipuclarini kolayca okur', 'Baskalari icin guvenli alan yaratir', 'Guclu aktif dinleme becerileri'],
        growthAreasEn: ['Setting boundaries while staying empathic', 'Avoiding emotional exhaustion from over-absorbing'],
        growthAreasTr: ['Empatik kalirken sinir koyma', 'Asiri absorbe olmaktan kaynaklanan duygusal tukenmeyi onleme'],
      ),
      'regulation': QuizDimensionMeta(
        key: 'regulation',
        nameEn: 'Emotional Regulation',
        nameTr: 'Duygusal Duzenleme',
        emoji: '\u{1F3AF}',
        color: Color(0xFF27AE60),
        descriptionEn: 'You may tend to stay composed even when emotions run high. This capacity often means you can think clearly during stressful moments and recover from setbacks relatively quickly.',
        descriptionTr: 'Duygular yogun oldugunda bile sakin kalma egiliminde olabilirsiniz. Bu kapasite genellikle stresli anlarda net dusunebileceginiz anlamina gelir.',
        strengthsEn: ['Stays grounded under pressure', 'Recovers from upsets relatively fast', 'Models calm for those around you'],
        strengthsTr: ['Baski altinda saglam kalir', 'Uzuntulerden nispeten hizli toparlanir', 'Cevresindekiler icin sakinlik modeli olur'],
        growthAreasEn: ['Allowing yourself to fully feel before regulating', 'Checking that composure isn\'t emotional suppression'],
        growthAreasTr: ['Duzenlemeden once tam olarak hissetmeye izin verme', 'Sakinligin duygusal baskirma olmadigini kontrol etme'],
      ),
      'motivation': QuizDimensionMeta(
        key: 'motivation',
        nameEn: 'Inner Motivation',
        nameTr: 'Ic Motivasyon',
        emoji: '\u{1F525}',
        color: Color(0xFFE74C3C),
        descriptionEn: 'You may tend to draw energy from an internal compass rather than external rewards. This drive often helps you persist through challenges with a sense of purpose.',
        descriptionTr: 'Dis odullerden ziyade ic pusulanizdan enerji alma egiliminde olabilirsiniz. Bu durtunun genellikle zorluklarda amac duygusuyla devam etmenize yardimci oldugu gorulur.',
        strengthsEn: ['Self-directed and purposeful', 'Resilient in the face of setbacks', 'Finds meaning in effort itself'],
        strengthsTr: ['Oz yonetimli ve amacli', 'Aksilikler karsisinda direncli', 'Cabanin kendisinde anlam bulur'],
        growthAreasEn: ['Balancing drive with rest and recovery', 'Celebrating small wins along the way'],
        growthAreasTr: ['Durtunun dinlenme ve iyilesme ile dengelenmesi', 'Yol boyunca kucuk basarilari kutlama'],
      ),
      'social_skills': QuizDimensionMeta(
        key: 'social_skills',
        nameEn: 'Social Skills',
        nameTr: 'Sosyal Beceriler',
        emoji: '\u{1F91D}',
        color: Color(0xFF3498DB),
        descriptionEn: 'You may tend to navigate social dynamics with confidence and warmth. This ability often makes collaboration feel natural and helps you build rapport quickly.',
        descriptionTr: 'Sosyal dinamikleri guven ve sicaklikla yonetme egiliminde olabilirsiniz. Bu yetenek genellikle is birligini dogal hissettirir.',
        strengthsEn: ['Builds rapport naturally', 'Navigates group dynamics with ease', 'Communicates needs clearly and kindly'],
        strengthsTr: ['Dogal olarak yakinlik kurar', 'Grup dinamiklerini kolaylikla yonetir', 'Ihtiyaclarini acik ve nazikce iletir'],
        growthAreasEn: ['Deepening relationships beyond surface warmth', 'Being authentic even when it risks social friction'],
        growthAreasTr: ['Iliskileri yuzeysel sicakligin otesine derinlestirme', 'Sosyal surtusmeydi riske etse bile otantik olma'],
      ),
    },
    questions: [
      // Q1 - Self-Awareness
      QuizQuestion(
        text: 'When you notice a sudden mood shift during your day, what tends to happen next?',
        textTr: 'Gun icinde ani bir ruh hali degisikligi farkettiginizde, sonra ne olma egilimindedir?',
        category: 'self_awareness',
        options: [
          QuizOption(text: 'I pause and try to name the feeling before reacting.', textTr: 'Tepki vermeden once durur ve duyguyu adlandirmaya calisirim.', scores: {'self_awareness': 3, 'regulation': 1}),
          QuizOption(text: 'I check in with someone I trust to process it together.', textTr: 'Birlikte islemek icin guvendigim biriyle iletisim kurar.', scores: {'empathy': 2, 'social_skills': 2}),
          QuizOption(text: 'I push through it — I can deal with feelings later.', textTr: 'Devam ederim — duygularla sonra ilgilenebilirim.', scores: {'motivation': 2, 'regulation': 1}),
          QuizOption(text: 'I often don\'t notice the shift until someone else points it out.', textTr: 'Degisimi genellikle baskasi isaret edene kadar fark etmem.', scores: {'social_skills': 1}),
        ],
      ),
      // Q2 - Empathy
      QuizQuestion(
        text: 'A friend is upset but says "I\'m fine." What do you tend to do?',
        textTr: 'Bir arkadasiniz uzgun ama "iyiyim" diyor. Ne yapma egiliminde olursunuz?',
        category: 'empathy',
        options: [
          QuizOption(text: 'I gently let them know I can sense something is off and I\'m here if they want to talk.', textTr: 'Bir seyler oldugunu hissettigimi nazikce bildirip, konusmak isterlerse burada oldugumu soylerim.', scores: {'empathy': 3, 'social_skills': 1}),
          QuizOption(text: 'I take them at their word — if they say they\'re fine, I respect that.', textTr: 'Sozlerine guvenip — iyi olduklarini soylerlerse buna saygi gosteririm.', scores: {'regulation': 2, 'self_awareness': 1}),
          QuizOption(text: 'I share a similar experience of my own to show solidarity.', textTr: 'Dayanisma gostermek icin benzer bir deneyimimi paylusirim.', scores: {'social_skills': 2, 'empathy': 1}),
          QuizOption(text: 'I try to cheer them up with a distraction or humour.', textTr: 'Dikkat dagitma veya mizahla neselendirmeye calisirim.', scores: {'motivation': 2, 'social_skills': 1}),
        ],
      ),
      // Q3 - Regulation
      QuizQuestion(
        text: 'When something makes you really angry, which pattern do you notice most?',
        textTr: 'Bir sey sizi gercekten kizgdirdiginda, en cok hangi oruntuyunu fark edersiniz?',
        category: 'regulation',
        options: [
          QuizOption(text: 'I feel the heat but can usually take a breath before responding.', textTr: 'Sicakligi hissederim ama genellikle cevap vermeden once nefes alabilirim.', scores: {'regulation': 3, 'self_awareness': 1}),
          QuizOption(text: 'I tend to express it quickly — I\'d rather get it out than hold it in.', textTr: 'Hizlica ifade etme egilimindeyim — icimde tutmaktansa cikarmyi tercih ederim.', scores: {'motivation': 2, 'self_awareness': 1}),
          QuizOption(text: 'I go quiet and process it internally before talking about it.', textTr: 'Sessizlesirim ve konusmadan once icsel olarak islerim.', scores: {'self_awareness': 2, 'regulation': 1}),
          QuizOption(text: 'I channel it into something productive — exercise, cleaning, work.', textTr: 'Uretken bir seye yonlendiririm — egzersiz, temizlik, is.', scores: {'regulation': 2, 'motivation': 2}),
        ],
      ),
      // Q4 - Motivation
      QuizQuestion(
        text: 'What tends to keep you going when a personal goal feels difficult?',
        textTr: 'Kisisel bir hedef zor hissettiginde sizi devam ettirme egiliminde olan sey nedir?',
        category: 'motivation',
        options: [
          QuizOption(text: 'Remembering why I started and what it means to me personally.', textTr: 'Neden basladigimi ve benim icin ne anlama geldigini hatirlamak.', scores: {'motivation': 3, 'self_awareness': 1}),
          QuizOption(text: 'Support and encouragement from people I care about.', textTr: 'Onem verdigim insanlardan destek ve tesvik.', scores: {'social_skills': 2, 'empathy': 1}),
          QuizOption(text: 'Breaking it into smaller steps so it feels manageable.', textTr: 'Yonetilebilir hissettirmek icin daha kucuk adimlara bolme.', scores: {'regulation': 2, 'motivation': 1}),
          QuizOption(text: 'Honestly, I may tend to shift focus to something new if it gets too hard.', textTr: 'Durst olmak gerekirse, cok zorlasirsa yeni bir seye odaklanma egiliminde olabilirim.', scores: {'self_awareness': 2}),
        ],
      ),
      // Q5 - Social Skills
      QuizQuestion(
        text: 'In a group where two people disagree, what role do you tend to play?',
        textTr: 'Iki kisinin anlasmadigi bir grupta, hangi rolu oynama egiliminde olursunuz?',
        category: 'social_skills',
        options: [
          QuizOption(text: 'I naturally mediate — helping both sides feel heard.', textTr: 'Dogal olarak arabuluculuk yaparim — her iki tarafin da duyulmasina yardimci olurum.', scores: {'social_skills': 3, 'empathy': 1}),
          QuizOption(text: 'I tend to support the person I think is right.', textTr: 'Hakli oldugunu dusundugum kisiyi destekleme egilimindeyim.', scores: {'motivation': 2, 'self_awareness': 1}),
          QuizOption(text: 'I observe quietly and only speak up if asked.', textTr: 'Sessizce gozlemler ve sadece sorulursa konusurum.', scores: {'self_awareness': 2, 'regulation': 1}),
          QuizOption(text: 'I try to lighten the mood and move past the tension.', textTr: 'Havyi yumuatma ve gerilimi asma egilimindeyim.', scores: {'social_skills': 2, 'regulation': 1}),
        ],
      ),
      // Q6 - Self-Awareness
      QuizQuestion(
        text: 'How would you describe your relationship with your own emotions?',
        textTr: 'Kendi duygularinizla iliskinizi nasil tanimlarsiniz?',
        category: 'self_awareness',
        options: [
          QuizOption(text: 'I feel like I know them well — they\'re familiar companions.', textTr: 'Onlari iyi tanidigimi hissediyorum — tanidik yol arkadaslari.', scores: {'self_awareness': 3}),
          QuizOption(text: 'I understand them better when I talk them through with someone.', textTr: 'Biriyle konusarak islerken daha iyi anliyorum.', scores: {'empathy': 2, 'social_skills': 1}),
          QuizOption(text: 'I notice them but tend to focus more on actions than feelings.', textTr: 'Fark ederim ama duygulardan cok eylemlere odaklanma egilimindeyim.', scores: {'motivation': 2, 'regulation': 1}),
          QuizOption(text: 'They sometimes surprise me — I\'m still learning to read them.', textTr: 'Bazen sasirtirlar — onlari okumay hala ogreniyorum.', scores: {'self_awareness': 1, 'empathy': 1}),
        ],
      ),
      // Q7 - Empathy
      QuizQuestion(
        text: 'When you watch a movie with an emotional scene, what tends to happen?',
        textTr: 'Duygusal bir sahne olan bir film izlediginizde, ne olma egilimindedir?',
        category: 'empathy',
        options: [
          QuizOption(text: 'I may feel deeply moved — sometimes tears come easily.', textTr: 'Derinden etkilenebilirim — bazen gozyaslari kolayca gelir.', scores: {'empathy': 3}),
          QuizOption(text: 'I appreciate the storytelling but stay emotionally composed.', textTr: 'Hikaye anlatimini takdir ederim ama duygusal olarak sakin kalirim.', scores: {'regulation': 2, 'self_awareness': 1}),
          QuizOption(text: 'I notice what the characters could do differently to solve the problem.', textTr: 'Karakterlerin sorunu cozmek icin farkli neler yapabilecegini fark ederim.', scores: {'motivation': 2, 'self_awareness': 1}),
          QuizOption(text: 'I pay attention to how the people I\'m watching with are reacting.', textTr: 'Birlikte izledigim insanlarin nasil tepki verdigine dikkat ederim.', scores: {'social_skills': 2, 'empathy': 1}),
        ],
      ),
      // Q8 - Regulation
      QuizQuestion(
        text: 'After a stressful week, what tends to restore your emotional balance?',
        textTr: 'Stresli bir haftadan sonra, duygusal dengenizi ne yeniden kurma egilimindedir?',
        category: 'regulation',
        options: [
          QuizOption(text: 'Quiet time alone to decompress and reflect.', textTr: 'Rahatlama ve dusunme icin sessiz yalniz zaman.', scores: {'regulation': 3, 'self_awareness': 1}),
          QuizOption(text: 'Connecting with someone who understands and just listens.', textTr: 'Anlayan ve sadece dinleyen biriyle baglanti kurma.', scores: {'empathy': 2, 'social_skills': 1}),
          QuizOption(text: 'Diving into a hobby or project that absorbs my attention.', textTr: 'Dikkatimi ceken bir hobi veya projeye dalma.', scores: {'motivation': 2, 'regulation': 1}),
          QuizOption(text: 'Social plans — being around people lifts my energy.', textTr: 'Sosyal planlar — insanlarin yaninda olmak enerjimi yukseltir.', scores: {'social_skills': 3}),
        ],
      ),
      // Q9 - Motivation
      QuizQuestion(
        text: 'When you achieve something meaningful, which response feels most like you?',
        textTr: 'Anlamli bir sey basardiginizda, hangi tepki size en cok benziyor?',
        category: 'motivation',
        options: [
          QuizOption(text: 'A quiet sense of satisfaction — I set a new goal soon after.', textTr: 'Sessiz bir tatmin duygusu — kisa surede yeni bir hedef belirlerim.', scores: {'motivation': 3}),
          QuizOption(text: 'I want to share the moment with people who supported me.', textTr: 'Beni destekleyen insanlarla ani paylasmak isterim.', scores: {'social_skills': 2, 'empathy': 1}),
          QuizOption(text: 'I take time to sit with the feeling and journal about it.', textTr: 'Duyguyla oturmak ve gunluge yazmak icin zaman ayiririm.', scores: {'self_awareness': 2, 'regulation': 1}),
          QuizOption(text: 'I feel proud but quickly notice what I could have done better.', textTr: 'Gurur duyarim ama hizla daha iyi ne yapabilecegimi fark ederim.', scores: {'self_awareness': 2, 'motivation': 1}),
        ],
      ),
      // Q10 - Social Skills
      QuizQuestion(
        text: 'When meeting someone for the first time, what do you tend to notice about yourself?',
        textTr: 'Biriyle ilk kez tanisirken, kendinizde ne fark etme egiliminde olursunuz?',
        category: 'social_skills',
        options: [
          QuizOption(text: 'I focus on making them feel comfortable and finding common ground.', textTr: 'Onlari rahat hissettirmeye ve ortak noktalar bulmaya odaklanirim.', scores: {'social_skills': 3, 'empathy': 1}),
          QuizOption(text: 'I pay attention to their energy and body language for unspoken cues.', textTr: 'Soylenmemis ipuclari icin enerjilerine ve beden dillerine dikkat ederim.', scores: {'empathy': 3}),
          QuizOption(text: 'I let the conversation flow naturally without overthinking it.', textTr: 'Cok dusunmeden konusmanin dogal akmasina izin veririm.', scores: {'regulation': 2, 'social_skills': 1}),
          QuizOption(text: 'I observe more than I speak — I prefer to listen first.', textTr: 'Konusmaktan cok gozlemlerim — once dinlemeyi tercih ederim.', scores: {'self_awareness': 2, 'regulation': 1}),
        ],
      ),
    ],
  );

  // ══════════════════════════════════════════════════════════════════════════
  // 2) DREAM PERSONALITY QUIZ (8 questions)
  // ══════════════════════════════════════════════════════════════════════════

  static const dreamPersonalityQuiz = QuizDefinition(
    id: 'dream_personality',
    title: 'Dream Personality',
    titleTr: 'Ruya Kisiligim',
    description: 'What kind of dreamer are you? Explore your nighttime mind.',
    descriptionTr: 'Nasil bir ruyaci siniz? Gece zihninizi kesfedin.',
    emoji: '\u{1F319}',
    scoringType: QuizScoringType.categorical,
    dimensions: {
      'vivid_visionary': QuizDimensionMeta(
        key: 'vivid_visionary',
        nameEn: 'Vivid Visionary',
        nameTr: 'Canli Vizyoner',
        emoji: '\u{1F308}',
        color: Color(0xFFE74C3C),
        descriptionEn: 'Your dreams may tend to be rich sensory experiences — full of color, detail, and atmosphere. You might notice that your dream world often feels as real as waking life.',
        descriptionTr: 'Ruyalariniz zengin duyusal deneyimler olma egiliminde olabilir — renk, detay ve atmosfer dolu. Ruya dunyanizin uyanic hayat kadar gercek hissettigini fark edebilirsiniz.',
        strengthsEn: ['Rich imaginative inner world', 'Strong visual memory', 'Creative problem-solving through imagery'],
        strengthsTr: ['Zengin hayal gucu ic dunyasi', 'Guclu gorsel bellek', 'Gorseller yoluyla yaratici problem cozme'],
        growthAreasEn: ['Grounding vivid dream energy into daytime creativity', 'Journaling dreams before the details fade'],
        growthAreasTr: ['Canli ruya enerjisini gunduz yaraticililina temellendirme', 'Detaylar solmadan once ruyalari gunluge yazma'],
      ),
      'symbolic_seeker': QuizDimensionMeta(
        key: 'symbolic_seeker',
        nameEn: 'Symbolic Seeker',
        nameTr: 'Sembolik Arayan',
        emoji: '\u{1F52E}',
        color: Color(0xFF9B59B6),
        descriptionEn: 'Your dreams may tend to speak in metaphor and symbol. You might notice recurring images or themes that seem to carry deeper personal meaning over time.',
        descriptionTr: 'Ruyalariniz mecaz ve sembollerle konusma egiliminde olabilir. Zaman icinde daha derin kisisel anlam tasiyan tekrarlayan goruntuleri fark edebilirsiniz.',
        strengthsEn: ['Natural pattern recognition', 'Intuitive meaning-making', 'Deep capacity for self-reflection'],
        strengthsTr: ['Dogal oruntu tanima', 'Sezgisel anlam olusturma', 'Derin oz yansitma kapasitesi'],
        growthAreasEn: ['Balancing interpretation with simply experiencing', 'Trusting your first instinct about a symbol\'s meaning'],
        growthAreasTr: ['Yorumlamayi basitce deneyimleme ile dengeleme', 'Bir sembolun anlami hakkinda ilk icguddunuze guvenmek'],
      ),
      'lucid_explorer': QuizDimensionMeta(
        key: 'lucid_explorer',
        nameEn: 'Lucid Explorer',
        nameTr: 'Bilingli Kasif',
        emoji: '\u{1F680}',
        color: Color(0xFF3498DB),
        descriptionEn: 'You may tend to have awareness within your dreams — sometimes knowing you\'re dreaming or even directing the action. Your dream world may feel like a playground for your conscious mind.',
        descriptionTr: 'Ruyalariniz icinde farkindalik sahibi olma egiliminde olabilirsiniz — bazen ruya gordugunu bilmek veya olaylari yonlendirmek. Ruya dunyaniz bilinciniz icin bir oyun alani gibi hissedebilir.',
        strengthsEn: ['High self-awareness even in sleep', 'Natural curiosity and adventurousness', 'Strong metacognitive abilities'],
        strengthsTr: ['Uykuda bile yuksek oz farkindalik', 'Dogal merak ve maceracilik', 'Guclu ustbilissel yetenekler'],
        growthAreasEn: ['Letting some dreams unfold without control', 'Using lucid states for emotional processing, not just adventure'],
        growthAreasTr: ['Bazi ruyalarin kontrol olmadan acilmasina izin verme', 'Bilinli durumlari sadece macera icin degil duygusal isleme icin kullanma'],
      ),
      'emotional_processor': QuizDimensionMeta(
        key: 'emotional_processor',
        nameEn: 'Emotional Processor',
        nameTr: 'Duygusal Islemci',
        emoji: '\u{1F30A}',
        color: Color(0xFF27AE60),
        descriptionEn: 'Your dreams may tend to be emotional landscapes — processing feelings, relationships, and unresolved experiences. You might notice your dreams often reflect what you\'re going through emotionally.',
        descriptionTr: 'Ruyalariniz duygusal manzaralar olma egiliminde olabilir — duyguklari, iliskileri ve cozulmemis deneyimleri isler. Ruyalarinizin genellikle duygusal olarak yasadiklarinizi yansittigini fark edebilirsiniz.',
        strengthsEn: ['Deep emotional intelligence during sleep', 'Natural capacity for processing difficult feelings', 'Dreams often provide clarity on waking concerns'],
        strengthsTr: ['Uyku sirasinda derin duygusal zeka', 'Zor duyguylari isleme icin dogal kapasite', 'Ruyalar genellikle uyanic endiseler hakkinda netlik saglar'],
        growthAreasEn: ['Creating a calming bedtime routine for intense dream nights', 'Journaling emotions after waking to capture the processing'],
        growthAreasTr: ['Yogun ruya geceleri icin sakinlestirici uyku oncesi rutini olusturma', 'Islemeyi yakalamak icin uyaniktan sonra duyguylari gunluge yazma'],
      ),
    },
    questions: [
      QuizQuestion(
        text: 'When you remember a dream, what aspect stands out most?',
        textTr: 'Bir ruyayi hatirladiginizda, en cok hangi yonu one cikar?',
        options: [
          QuizOption(text: 'The vivid colors, textures, and sensory details — it felt incredibly real.', textTr: 'Canli renkler, dokular ve duyusal detaylar — inanilmaz gercek hissettirdi.', scores: {'vivid_visionary': 3}),
          QuizOption(text: 'Recurring symbols or objects that seem to carry a deeper meaning.', textTr: 'Daha derin bir anlam tasiyor gibi gorunen tekrarlayan semboller veya nesneler.', scores: {'symbolic_seeker': 3}),
          QuizOption(text: 'The feeling that I was aware I was dreaming, or could influence it.', textTr: 'Ruya gordugumun farkinda oldugum veya onu etkileyebildigim hissi.', scores: {'lucid_explorer': 3}),
          QuizOption(text: 'The emotions I felt — the dream was processing something I\'m going through.', textTr: 'Hissettigim duygular — ruya yasadigim bir seyi isliyordu.', scores: {'emotional_processor': 3}),
        ],
      ),
      QuizQuestion(
        text: 'How often do you tend to remember your dreams?',
        textTr: 'Ruyalarinizi ne siklikla hatarlama egiliminde olursunuz?',
        options: [
          QuizOption(text: 'Almost every morning — they stay with me like a movie I just watched.', textTr: 'Neredeyse her sabah — az once izledigim bir film gibi benimle kalirlar.', scores: {'vivid_visionary': 3}),
          QuizOption(text: 'Certain images or symbols linger even when the story fades.', textTr: 'Hikaye solsa bile belirli goruntler veya semboller kalir.', scores: {'symbolic_seeker': 3}),
          QuizOption(text: 'I remember them best when I "wake up" inside the dream first.', textTr: 'Onlari en iyi once ruyanin icinde "uyandlgimda" hatirliyorum.', scores: {'lucid_explorer': 3}),
          QuizOption(text: 'I remember the feeling more than the plot — the emotion lingers.', textTr: 'Olaylardan cok duyguyu hatlarlyorum — duygu kaliyor.', scores: {'emotional_processor': 3}),
        ],
      ),
      QuizQuestion(
        text: 'If you could choose one dream ability, which appeals most?',
        textTr: 'Bir ruya yetenegi secebilseydiniz, hangisi en cok ilginizi cekerdi?',
        options: [
          QuizOption(text: 'Photographic dream recall — remembering every detail perfectly.', textTr: 'Fotografik ruya hatirlamasi — her detayi mukemmel hatirlamak.', scores: {'vivid_visionary': 3}),
          QuizOption(text: 'A dream dictionary tuned to my personal symbol language.', textTr: 'Kisisel sembol dilime ayarlanmis bir ruya sozlugu.', scores: {'symbolic_seeker': 3}),
          QuizOption(text: 'Full lucid control — flying, exploring, creating worlds.', textTr: 'Tam bilinli kontrol — ucma, kesif, dunya yaratma.', scores: {'lucid_explorer': 3}),
          QuizOption(text: 'The ability to consciously resolve emotional knots in my sleep.', textTr: 'Uykumda duygusal dugumleri bilingli olarak cozme yetenegi.', scores: {'emotional_processor': 3}),
        ],
      ),
      QuizQuestion(
        text: 'After a particularly intense dream, what do you tend to do?',
        textTr: 'Ozellikle yogun bir ruyadan sonra, ne yapma egiliminde olursunuz?',
        options: [
          QuizOption(text: 'I try to sketch or describe the visual scene before it fades.', textTr: 'Solmadan once gorsel sahneyi cizmeye veya tarif etmeye calisirim.', scores: {'vivid_visionary': 3}),
          QuizOption(text: 'I look up the symbols or think about what they might represent.', textTr: 'Sembolleri ararir veya neyi temsil edebileceklerini dusunurum.', scores: {'symbolic_seeker': 3}),
          QuizOption(text: 'I try to go back to sleep and re-enter the dream consciously.', textTr: 'Tekrar uyumaya ve ruyaya bilingli olarak geri girmeye calisirim.', scores: {'lucid_explorer': 3}),
          QuizOption(text: 'I sit with the feelings for a while — they often tell me something important.', textTr: 'Bir sure duygularla otururum — genellikle bana onemli bir sey soylerler.', scores: {'emotional_processor': 3}),
        ],
      ),
      QuizQuestion(
        text: 'What kind of dreams do you tend to have most often?',
        textTr: 'En sik hangi tur ruyalari gorme egiliminde olursunuz?',
        options: [
          QuizOption(text: 'Elaborate, cinematic dreams with detailed landscapes and stories.', textTr: 'Detayli manzaralar ve hikayelerle dolu sinematik ruyalar.', scores: {'vivid_visionary': 3}),
          QuizOption(text: 'Dreams with recurring themes, places, or objects that keep appearing.', textTr: 'Tekrarlayan temalar, yerler veya nesneler iceren ruyalar.', scores: {'symbolic_seeker': 3}),
          QuizOption(text: 'Dreams where I realize I\'m dreaming and can make choices.', textTr: 'Ruya gordugumu fark edip secim yapabildigim ruyalar.', scores: {'lucid_explorer': 3}),
          QuizOption(text: 'Dreams centred around relationships, conversations, or emotional situations.', textTr: 'Iliskiler, konusmalar veya duygusal durumlar etrafinda yogunlasan ruyalar.', scores: {'emotional_processor': 3}),
        ],
      ),
      QuizQuestion(
        text: 'When you try to describe a dream to someone, what is easiest to convey?',
        textTr: 'Bir ruyayi birine anlatmaya calistiginizda, en kolay ne aktarilir?',
        options: [
          QuizOption(text: 'The visual details — "It looked like..." comes naturally.', textTr: '"Soyle gorundugu..." ifadesi dogal olarak gelir.', scores: {'vivid_visionary': 3}),
          QuizOption(text: 'The meaning behind it — "I think it was about..." is my instinct.', textTr: '"Bence su konudaydi..." deme icgudum vardir.', scores: {'symbolic_seeker': 3}),
          QuizOption(text: 'The actions I took — "I decided to..." because I was aware.', textTr: '"...yapmaya karar verdim" cunku farkindaydim.', scores: {'lucid_explorer': 3}),
          QuizOption(text: 'The way it made me feel — the emotion translates easily into words.', textTr: 'Bana nasil hissettirdigi — duygu kolayca kelimelere donusur.', scores: {'emotional_processor': 3}),
        ],
      ),
      QuizQuestion(
        text: 'What is your relationship with nightmares or unsettling dreams?',
        textTr: 'Kabuslar veya rahatsiz edici ruyalarla iliskiniz nasil?',
        options: [
          QuizOption(text: 'They\'re rare but incredibly vivid when they happen — hard to shake.', textTr: 'Nadir ama olduklarinda inanilmaz canli — atlatmasi zor.', scores: {'vivid_visionary': 3}),
          QuizOption(text: 'I try to decode them — even scary dreams may carry useful messages.', textTr: 'Onlari cozmeye calisirim — korkutucu ruyalar bile yararli mesajlar tasiyabilir.', scores: {'symbolic_seeker': 3}),
          QuizOption(text: 'I sometimes realize mid-nightmare that it\'s a dream and can shift it.', textTr: 'Bazen kabusun ortasinda bunun bir ruya oldugunu fark edip degistirebiliyorum.', scores: {'lucid_explorer': 3}),
          QuizOption(text: 'They usually reflect stress or unprocessed emotions from my day.', textTr: 'Genellikle gunumdeki stresi veya islenmemis duyguylari yansitir.', scores: {'emotional_processor': 3}),
        ],
      ),
      QuizQuestion(
        text: 'If your dreams had a "genre," which would fit best?',
        textTr: 'Ruyalarinizin bir "turu" olsaydi, hangisi en iyi uyar?',
        options: [
          QuizOption(text: 'Fantasy or sci-fi — worlds that feel real but impossible.', textTr: 'Fantastik veya bilim kurgu — gercek hisseden ama imkansiz dunyalar.', scores: {'vivid_visionary': 3}),
          QuizOption(text: 'Mystery — full of clues, patterns, and things to figure out.', textTr: 'Gizem — ipuclari, oruntuler ve cozulecek seylerle dolu.', scores: {'symbolic_seeker': 3}),
          QuizOption(text: 'Adventure — where I\'m the main character making active choices.', textTr: 'Macera — aktif secimler yapan ana karakter oldugum.', scores: {'lucid_explorer': 3}),
          QuizOption(text: 'Drama — the emotional arcs are the real story.', textTr: 'Drama — duygusal yolculuklar asil hikaye.', scores: {'emotional_processor': 3}),
        ],
      ),
    ],
  );

  // ══════════════════════════════════════════════════════════════════════════
  // 3) SOCIAL BATTERY QUIZ (8 questions)
  // ══════════════════════════════════════════════════════════════════════════

  static const socialBatteryQuiz = QuizDefinition(
    id: 'social_battery',
    title: 'Social Battery',
    titleTr: 'Sosyal Batarya',
    description: 'Discover how you recharge — and what drains you.',
    descriptionTr: 'Nasil sarj oldugunuzu ve neyin tukettigini kesfedin.',
    emoji: '\u{1F50B}',
    scoringType: QuizScoringType.categorical,
    dimensions: {
      'introvert': QuizDimensionMeta(
        key: 'introvert',
        nameEn: 'Reflective Introvert',
        nameTr: 'Dusunsel Introvert',
        emoji: '\u{1F4D6}',
        color: Color(0xFF3498DB),
        descriptionEn: 'You may tend to recharge through solitude and inner reflection. Your energy often flows best in calm, quiet environments where you can think deeply without interruption.',
        descriptionTr: 'Yalnizlik ve ic dusunce yoluyla sarj olma egiliminde olabilirsiniz. Enerjiniz genellikle sakin, sessiz ortamlarda en iyi akar.',
        strengthsEn: ['Deep thinking and careful observation', 'Rich inner life and creativity', 'Quality over quantity in relationships'],
        strengthsTr: ['Derin dusunme ve dikkatli gozlem', 'Zengin ic dunya ve yaraticilik', 'Iliskilerde nicelikten cok nitelik'],
        growthAreasEn: ['Reaching out before your battery hits zero', 'Sharing your inner world with trusted people'],
        growthAreasTr: ['Bataryaniz sifira dusmeden ulasma', 'Ic dunyanizi guvenilir insanlarla paylasma'],
      ),
      'extrovert': QuizDimensionMeta(
        key: 'extrovert',
        nameEn: 'Social Energizer',
        nameTr: 'Sosyal Enerjizer',
        emoji: '\u{26A1}',
        color: Color(0xFFE74C3C),
        descriptionEn: 'You may tend to gain energy from being around others. Social interaction often feels naturally stimulating, and you might notice that too much alone time can leave you feeling flat.',
        descriptionTr: 'Baskalarinin yaninda olmaktan enerji kazanma egiliminde olabilirsiniz. Sosyal etkilesim genellikle dogal olarak canlandirici hissettirir.',
        strengthsEn: ['Natural connector who brings people together', 'Energized by collaboration and brainstorming', 'Comfortable in new social situations'],
        strengthsTr: ['Insanlari bir araya getiren dogal baglayici', 'Is birligi ve beyin firtinasi ile enerjilenen', 'Yeni sosyal durumlarda rahat'],
        growthAreasEn: ['Building comfort with solitude and stillness', 'Listening deeply rather than filling silences'],
        growthAreasTr: ['Yalnizlik ve durgunlukla rahatlik olusturma', 'Sessizlikleri doldurmak yerine derinden dinleme'],
      ),
      'ambivert': QuizDimensionMeta(
        key: 'ambivert',
        nameEn: 'Adaptive Ambivert',
        nameTr: 'Uyumlu Ambivert',
        emoji: '\u{1F300}',
        color: Color(0xFF27AE60),
        descriptionEn: 'You may tend to adapt your social energy to the situation. You might notice that you can enjoy both lively gatherings and quiet evenings, and your ideal balance shifts with your mood and needs.',
        descriptionTr: 'Sosyal enerjinizi duruma uyarlama egiliminde olabilirsiniz. Hem canli toplantilarin hem de sessiz aksanlarin tadini cikrabildiginizi fark edebilirsiniz.',
        strengthsEn: ['Flexible in diverse social settings', 'Reads the room and adapts naturally', 'Balanced approach to alone time and togetherness'],
        strengthsTr: ['Farkli sosyal ortamlarda esnek', 'Ortami okur ve dogal olarak uyum saglar', 'Yalniz zaman ve birliktelik arasinda dengeli yaklasim'],
        growthAreasEn: ['Noticing which mode you actually need vs. defaulting to what others expect', 'Honouring your energy needs even when the group wants something different'],
        growthAreasTr: ['Aslinda hangi moda ihtiyaciniz oldugunu basklarinin beklentisinden ayirma', 'Grup farkli bir sey istediginde bile enerji ihtiyaclarinizi onurlandirma'],
      ),
      'selective_social': QuizDimensionMeta(
        key: 'selective_social',
        nameEn: 'Selective Connector',
        nameTr: 'Secici Baglayici',
        emoji: '\u{1F48E}',
        color: Color(0xFF9B59B6),
        descriptionEn: 'You may tend to be very intentional about where you invest your social energy. You might notice that you thrive in meaningful one-on-one connections but find large groups or surface-level socializing draining.',
        descriptionTr: 'Sosyal enerjinizi nereye yatirdiginiz konusunda cok niyetli olma egiliminde olabilirsiniz. Anlamli bire bir baglantilardan beslenirken buyuk gruplarin tuketici oldugunu fark edebilirsiniz.',
        strengthsEn: ['Deep, loyal friendships', 'High emotional presence in conversations', 'Intentional about energy investment'],
        strengthsTr: ['Derin, sadik arkadasliklar', 'Konusmalarda yuksek duygusal varlik', 'Enerji yatirimi konusunda niyetli'],
        growthAreasEn: ['Staying open to unexpected connections', 'Being gentle with yourself when social situations feel tiring'],
        growthAreasTr: ['Beklenmedik baglanilara acik kalma', 'Sosyal durumlar yorucu hissettiginde kendinize karsi nazik olma'],
      ),
    },
    questions: [
      QuizQuestion(
        text: 'After a long social event, what tends to happen to your energy?',
        textTr: 'Uzun bir sosyal etkinlikten sonra, enerjinize ne olma egilimindedir?',
        options: [
          QuizOption(text: 'I feel drained and need quiet time alone to recover.', textTr: 'Tukendigimi hissederim ve toparlanmak icin sessiz yalniz zamana ihtiyac duyarim.', scores: {'introvert': 3}),
          QuizOption(text: 'I feel energized and could keep going — I don\'t want the night to end.', textTr: 'Enerjik hissederim ve devam edebilirim — gecenin bitmesini istemem.', scores: {'extrovert': 3}),
          QuizOption(text: 'It depends on the people — some groups energize me, others drain me.', textTr: 'Insanlara bagli — bazi gruplar beni enerji verir, dierleri tuketir.', scores: {'ambivert': 3}),
          QuizOption(text: 'I\'m fine if I had meaningful conversations, but small talk exhausts me.', textTr: 'Anlamli konusmalar yaptiysam iyiyim, ama havadan sudan konusmak tuketiyor.', scores: {'selective_social': 3}),
        ],
      ),
      QuizQuestion(
        text: 'Your ideal weekend looks like:',
        textTr: 'Ideal hafta sonunuz soyle gorunur:',
        options: [
          QuizOption(text: 'A quiet day with a book, a walk, and no obligations.', textTr: 'Kitap, yuruyus ve zorunluluk olmayan sessiz bir gun.', scores: {'introvert': 3}),
          QuizOption(text: 'Plans with friends — brunch, an outing, maybe a party.', textTr: 'Arkadaslarla planlar — brunch, gezi, belki parti.', scores: {'extrovert': 3}),
          QuizOption(text: 'A mix — social time one day, recharging the next.', textTr: 'Karisim — bir gun sosyal zaman, ertesi gun sarj.', scores: {'ambivert': 3}),
          QuizOption(text: 'One-on-one time with my closest friend or partner, and space for myself.', textTr: 'En yakin arkadasim veya partnerimle bire bir zaman ve kendim icin alan.', scores: {'selective_social': 3}),
        ],
      ),
      QuizQuestion(
        text: 'When your phone rings unexpectedly, your first instinct is:',
        textTr: 'Telefonunuz beklenmedik bir sekilde caldiginda, ilk icguddunuz:',
        options: [
          QuizOption(text: 'A slight internal groan — I prefer texts where I can respond on my own time.', textTr: 'Hafif bir ic inleme — kendi zamanimda yanit verebildigim mesajlari tercih ederim.', scores: {'introvert': 3}),
          QuizOption(text: 'Excitement — I love a spontaneous catch-up call.', textTr: 'Heyecan — spontan bir sohbet aramasini seviyorum.', scores: {'extrovert': 3}),
          QuizOption(text: 'It depends on my mood and who\'s calling.', textTr: 'Ruh halime ve kimin aradigina bagli.', scores: {'ambivert': 3}),
          QuizOption(text: 'I only want to answer if it\'s someone I\'m really close to.', textTr: 'Sadece gercekten yakin oldugum biriyse cevaplamak istiyorum.', scores: {'selective_social': 3}),
        ],
      ),
      QuizQuestion(
        text: 'In a group conversation, you tend to:',
        textTr: 'Bir grup sohbetinde, egilim olarak:',
        options: [
          QuizOption(text: 'Listen more than I speak, contributing when I have something specific to say.', textTr: 'Konusmaktan cok dinlerim, soyleyecek belirli bir seyim oldugunda katki saglarim.', scores: {'introvert': 3}),
          QuizOption(text: 'Jump in naturally — I enjoy the flow of conversation.', textTr: 'Dogal olarak katilirim — konusma akisindan keyif alirim.', scores: {'extrovert': 3}),
          QuizOption(text: 'Shift between active and quiet depending on the topic.', textTr: 'Konuya bagli olarak aktif ve sessiz arasinda gecerim.', scores: {'ambivert': 3}),
          QuizOption(text: 'I prefer when the conversation goes deep rather than wide.', textTr: 'Konusmanin genise degil derine gitmesini tercih ederim.', scores: {'selective_social': 3}),
        ],
      ),
      QuizQuestion(
        text: 'When you need to process a difficult experience, you tend to:',
        textTr: 'Zor bir deneyimi islemeniz gerektiginde, egilim olarak:',
        options: [
          QuizOption(text: 'Retreat and reflect alone — I need space to think it through.', textTr: 'Cekilir ve yalniz dusunurum — dusunmek icin alana ihtiyacim var.', scores: {'introvert': 3}),
          QuizOption(text: 'Talk it out with multiple friends to get different perspectives.', textTr: 'Farkli bakis acilari almak icin birden fazla arkadasla konusurum.', scores: {'extrovert': 3}),
          QuizOption(text: 'Start alone, then talk to someone when I\'ve sorted my initial thoughts.', textTr: 'Yalniz baslarim, sonra ilk dusuncelerimi duzenledigimde biriyle konusurum.', scores: {'ambivert': 3}),
          QuizOption(text: 'Confide in one trusted person who really understands me.', textTr: 'Beni gercekten anlayan guvenilir bir kisiye acarim.', scores: {'selective_social': 3}),
        ],
      ),
      QuizQuestion(
        text: 'How do you feel about working from a busy cafe?',
        textTr: 'Kalabalik bir kafeden calismak hakkinda ne hissedersiniz?',
        options: [
          QuizOption(text: 'I\'d rather work somewhere quiet — noise and people are distracting.', textTr: 'Sessiz bir yerde calismay tercih ederim — gurultu ve insanlar dikkat dagitiyor.', scores: {'introvert': 3}),
          QuizOption(text: 'I love it — the background buzz of people keeps me energized.', textTr: 'Severim — insanlarin arka plan ugultusu beni enerjik tutar.', scores: {'extrovert': 3}),
          QuizOption(text: 'Sometimes yes, sometimes no — depends on the task and my mood.', textTr: 'Bazen evet, bazen hayir — goreve ve ruh halime bagli.', scores: {'ambivert': 3}),
          QuizOption(text: 'Only if I\'m there with a friend — anonymous crowds don\'t appeal to me.', textTr: 'Sadece bir arkadasimla oradalsaml — anonim kalabaliklar bana ilgi cekici gelmiyor.', scores: {'selective_social': 3}),
        ],
      ),
      QuizQuestion(
        text: 'When meeting new people at a gathering, you tend to:',
        textTr: 'Bir toplantida yeni insanlarla tanisirken, egilim olarak:',
        options: [
          QuizOption(text: 'Warm up slowly — I observe first and open up gradually.', textTr: 'Yavas yavas isimirim — once gozlemler yavasce acilirim.', scores: {'introvert': 3}),
          QuizOption(text: 'Introduce myself confidently — I enjoy making new connections.', textTr: 'Kendimi guvenle tanitrim — yeni baglantilar kurmaktan keyif alirim.', scores: {'extrovert': 3}),
          QuizOption(text: 'I can do both — I read the room and match the energy.', textTr: 'Ikisini de yapabilirim — ortami okur ve enerjiyle esleserim.', scores: {'ambivert': 3}),
          QuizOption(text: 'I gravitate toward one or two people for deeper conversation.', textTr: 'Daha derin sohbet icin bir veya iki kisiye yonelirim.', scores: {'selective_social': 3}),
        ],
      ),
      QuizQuestion(
        text: 'Which statement feels most true about your social life right now?',
        textTr: 'Mevcut sosyal hayatiniz hakkinda hangi ifade en dogru hissettiriyor?',
        options: [
          QuizOption(text: 'I could use more alone time — my social calendar has been too full.', textTr: 'Daha fazla yalniz zamana ihtiyacim var — sosyal takvimim cok dolu.', scores: {'introvert': 3}),
          QuizOption(text: 'I want more plans — I feel best when my week is full of people.', textTr: 'Daha fazla plan istiyorum — haftam insanlarla dolu oldugunda en iyi hissediyorum.', scores: {'extrovert': 3}),
          QuizOption(text: 'I\'m in a good balance right now between social time and solo time.', textTr: 'Su anda sosyal zaman ve yalniz zaman arasinda iyi bir dengedeyim.', scores: {'ambivert': 3}),
          QuizOption(text: 'I want fewer but deeper connections — quality matters more than quantity.', textTr: 'Daha az ama daha derin baglantilar istiyorum — nitelik nicelikten onemli.', scores: {'selective_social': 3}),
        ],
      ),
    ],
  );

  // ══════════════════════════════════════════════════════════════════════════
  // 4) STRESS RESPONSE QUIZ (8 questions)
  // ══════════════════════════════════════════════════════════════════════════

  static const stressResponseQuiz = QuizDefinition(
    id: 'stress_response',
    title: 'Stress Response',
    titleTr: 'Stres Tepkisi',
    description: 'Understand your default patterns under pressure.',
    descriptionTr: 'Baski altindaki varsayilan oruntuleriniizi anlayin.',
    emoji: '\u{1F32A}',
    scoringType: QuizScoringType.categorical,
    dimensions: {
      'fight': QuizDimensionMeta(
        key: 'fight',
        nameEn: 'The Protector (Fight)',
        nameTr: 'Koruyucu (Savas)',
        emoji: '\u{1F525}',
        color: Color(0xFFE74C3C),
        descriptionEn: 'Under stress, you may tend to move toward the challenge — confronting it head-on with energy and determination. This response pattern often makes you a natural advocate and problem-solver.',
        descriptionTr: 'Stres altinda, meydan okumaya dogru hareket etme egiliminde olabilirsiniz — enerji ve kararlilkla dogrudan yuzleserek. Bu tepki oruntsu sizi genellikle dogal bir savunucu ve problem cosucu yapar.',
        strengthsEn: ['Takes decisive action under pressure', 'Advocates strongly for self and others', 'Doesn\'t shy away from difficult conversations'],
        strengthsTr: ['Baski altinda karali hareket eder', 'Kendisi ve baskalari icin guclu savunuculuk yapar', 'Zor konusmalardan kacinmaz'],
        growthAreasEn: ['Pausing before reacting to assess the full picture', 'Softening intensity when the situation calls for gentleness'],
        growthAreasTr: ['Tam resmi degerlendirmek icin tepki vermeden once durma', 'Durum yumusklk gerektirdiginde yogunlugu yumusatma'],
      ),
      'flight': QuizDimensionMeta(
        key: 'flight',
        nameEn: 'The Strategist (Flight)',
        nameTr: 'Stratejist (Kacis)',
        emoji: '\u{1F3C3}',
        color: Color(0xFF3498DB),
        descriptionEn: 'Under stress, you may tend to seek distance — physically, mentally, or emotionally — to gain perspective. This response pattern often reflects a strong self-preservation instinct and strategic thinking.',
        descriptionTr: 'Stres altinda, perspektif kazanmak icin fiziksel, zihinsel veya duygusal olarak mesafe arama egiliminde olabilirsiniz. Bu tepki oruntsi genellikle guclu bir kendini koruma icgudusunu ve stratejik dusunmeyi yansitir.',
        strengthsEn: ['Quick to assess risk and find alternatives', 'Protects emotional wellbeing instinctively', 'Often finds creative escape routes from problems'],
        strengthsTr: ['Riski degerlendirmede ve alternatif bulmada hizli', 'Duygusal iyiligi icgudsel olarak korur', 'Sorunlardan yaratici cikis yollari bulur'],
        growthAreasEn: ['Distinguishing healthy retreat from avoidance', 'Building tolerance for staying present in discomfort'],
        growthAreasTr: ['Saglikli geri cekilmeyi kacinmadan ayirt etme', 'Rahatsizlikta mevcut kalmak icin tolerans olusturma'],
      ),
      'freeze': QuizDimensionMeta(
        key: 'freeze',
        nameEn: 'The Observer (Freeze)',
        nameTr: 'Gozlemci (Don)',
        emoji: '\u{2744}',
        color: Color(0xFF95A5A6),
        descriptionEn: 'Under stress, you may tend to go still — mentally or physically pausing as your system takes in information. This response pattern often reflects deep processing and careful analysis before action.',
        descriptionTr: 'Stres altinda, hareketsiz kalma egiliminde olabilirsiniz — sisteminiz bilgi alirken zihinsel veya fiziksel olarak duraklar. Bu tepki orntusu genellikle eylemden once derin isleme ve dikkatli analizi yansitir.',
        strengthsEn: ['Careful and thorough decision-making', 'Observes details others miss', 'Rarely makes impulsive mistakes'],
        strengthsTr: ['Dikkatli ve kapsamli karar verme', 'Basklarinin kacirdigi detaylari gozlemler', 'Nadiren durtgsel hatalar yapar'],
        growthAreasEn: ['Recognizing when stillness becomes being stuck', 'Building small, gentle action steps to break the pause'],
        growthAreasTr: ['Hareketsizligin takili kalmaya donustugunu fark etme', 'Duraklami kirmak icin kucuk, nazik eylem adimlari olusturma'],
      ),
      'fawn': QuizDimensionMeta(
        key: 'fawn',
        nameEn: 'The Harmonizer (Fawn)',
        nameTr: 'Uyumcu (Boyun Egme)',
        emoji: '\u{1F54A}',
        color: Color(0xFF27AE60),
        descriptionEn: 'Under stress, you may tend to focus on others\' needs and keeping the peace. This response pattern often reflects strong empathy and a desire to maintain connection even in difficult moments.',
        descriptionTr: 'Stres altinda, basklarinin ihtiyaclarina ve baris korumaya odaklanma egiliminde olabilirsiniz. Bu tepki orntusu genellikle guclu empatiyi ve zor anlarda bile baglntiyi surmurme arzusunu yansitir.',
        strengthsEn: ['Highly attuned to others\' emotional states', 'Natural peacemaker and mediator', 'Creates safety and comfort for those around you'],
        strengthsTr: ['Basklarinin duygusal durumlarina yuksek uyum', 'Dogal baris yapici ve arabulucu', 'Cevresindekilre icin guvenlik ve konfor yaratir'],
        growthAreasEn: ['Checking whether peacemaking is serving you or just avoiding conflict', 'Practicing saying what you actually need, even when it\'s uncomfortable'],
        growthAreasTr: ['Baris yapmanin size mi hizmet ettigini yoksa sadece catismadan mi kactigini kontrol etme', 'Rahatsiz olsa bile gercekten ne istediginizi soyleme pratioi'],
      ),
    },
    questions: [
      QuizQuestion(
        text: 'You receive unexpectedly harsh feedback at work. Your first internal response tends to be:',
        textTr: 'Iste beklenmedik sert bir geri bildirim aliyorsunuz. Ilk ic tepkiniz egilim olarak:',
        options: [
          QuizOption(text: 'Frustration — I want to defend my work and push back immediately.', textTr: 'Hayal kirilhgi — isimi savunmak ve hemen karsilik vermek istiyorum.', scores: {'fight': 3}),
          QuizOption(text: 'A need to leave the room or take a walk to clear my head.', textTr: 'Odayi terk etme veya kafami toplamak icin yuruyus yapma ihtiyaci.', scores: {'flight': 3}),
          QuizOption(text: 'My mind goes blank — I nod along but can\'t form a response in the moment.', textTr: 'Aklim boslukla — basimla onaylarim ama o an yanit olusturamam.', scores: {'freeze': 3}),
          QuizOption(text: 'I find myself agreeing and apologizing, even if I\'m not sure I should.', textTr: 'Yapip yapmamam gerektiginden emin olmasam bile katilir ve ozur dilerim.', scores: {'fawn': 3}),
        ],
      ),
      QuizQuestion(
        text: 'During an argument with someone you care about, you notice yourself:',
        textTr: 'Onem verdiginiz biriyle tartisma sirasinda, kendinizi su sekilde fark edersiniz:',
        options: [
          QuizOption(text: 'Getting louder or more intense — I need to be heard.', textTr: 'Daha yuksek sesle veya daha yogun — duyulmam gerekiyor.', scores: {'fight': 3}),
          QuizOption(text: 'Wanting to leave the conversation and come back when I\'m calmer.', textTr: 'Konusmayi birakip sakinlestigimde geri donmek istiyorum.', scores: {'flight': 3}),
          QuizOption(text: 'Going quiet, feeling unable to find the right words.', textTr: 'Sessizlesiyorum, dogru kelimeleri bulamiyorum.', scores: {'freeze': 3}),
          QuizOption(text: 'Shifting focus to their feelings and what they need from me.', textTr: 'Odagi onlarin duygularina ve benden ne istediklerine kaydiriyorum.', scores: {'fawn': 3}),
        ],
      ),
      QuizQuestion(
        text: 'When you\'re overwhelmed with too many responsibilities, you tend to:',
        textTr: 'Cok fazla sorumlulukla bunaldiginda, egilim olarak:',
        options: [
          QuizOption(text: 'Push harder — I\'ll power through even if it\'s exhausting.', textTr: 'Daha sert iteyi — tuketici olsa bile guclke devam edecegim.', scores: {'fight': 3}),
          QuizOption(text: 'Withdraw or distract myself — I need an escape valve.', textTr: 'Geri cekilirim veya dikkatimi dagitrim — bir cikis vanasina ihtiyacim var.', scores: {'flight': 3}),
          QuizOption(text: 'Shut down — everything feels impossible and I can\'t decide where to start.', textTr: 'Kapanirim — her sey imkansiz hissediyor ve nereden baslayacagima karar veremiyorum.', scores: {'freeze': 3}),
          QuizOption(text: 'Say yes to everyone else\'s requests before attending to my own needs.', textTr: 'Kendi ihtiyaclariml gidermeden once herkesin isteklerine evet deoirim.', scores: {'fawn': 3}),
        ],
      ),
      QuizQuestion(
        text: 'A friend cancels plans last minute for a vague reason. You tend to:',
        textTr: 'Bir arkadas belirsiz bir nedenle son dakika planlari iptal ediyor. Egilim olarak:',
        options: [
          QuizOption(text: 'Feel annoyed and want to address it directly.', textTr: 'Rahatsiz hissederim ve dogrudan ele almak isterim.', scores: {'fight': 3}),
          QuizOption(text: 'Shrug it off and make alternative plans — it\'s not worth the energy.', textTr: 'Omuz silker ve alternatif planlar yaparim — enerjiye deymeez.', scores: {'flight': 3}),
          QuizOption(text: 'Feel stuck wondering what I did wrong, replaying our last interactions.', textTr: 'Ne yanlis yaptigimi merak ederek takiliyorum, son etkilesimlerimi tekrarliyorum.', scores: {'freeze': 3}),
          QuizOption(text: 'Immediately reassure them that it\'s totally fine, even if I\'m disappointed.', textTr: 'Hayal kirikligina ugramis olsam bile hemen tamamen iyi olduguna dair guveece veririm.', scores: {'fawn': 3}),
        ],
      ),
      QuizQuestion(
        text: 'When you sense tension in a room, your instinct is to:',
        textTr: 'Bir odada gerilim hissettiginizde, icguddunuz:',
        options: [
          QuizOption(text: 'Name it — "Something feels off, let\'s talk about it."', textTr: 'Adini koyma — "Bir seyler ters hissettiriyor, konusalim."', scores: {'fight': 3}),
          QuizOption(text: 'Quietly excuse myself or shift my attention elsewhere.', textTr: 'Sessizce ayrilrim veya dikkatimi baska yere kaydiririm.', scores: {'flight': 3}),
          QuizOption(text: 'Become hyper-aware of every detail but unsure how to respond.', textTr: 'Her detayin asiri farkinda olurum ama nasil yanit verecegimden emin degilim.', scores: {'freeze': 3}),
          QuizOption(text: 'Try to ease the mood — cracking a joke or changing the subject.', textTr: 'Havafi yumusatmay calisirim — saka yaparim veya konuyu degistiririm.', scores: {'fawn': 3}),
        ],
      ),
      QuizQuestion(
        text: 'If someone crosses a personal boundary, your typical response pattern is:',
        textTr: 'Biri kisisel bir siniri asarsa, tipik tepki ornntunuz:',
        options: [
          QuizOption(text: 'I call it out clearly — I won\'t let that slide.', textTr: 'Acikca belirtirim — bunu gecistirmem.', scores: {'fight': 3}),
          QuizOption(text: 'I create distance and limit future interactions with that person.', textTr: 'Mesafe yaratrim ve o kisiyle gelecekteki etkilesimleri sinirlarim.', scores: {'flight': 3}),
          QuizOption(text: 'I feel uncomfortable but struggle to articulate what happened.', textTr: 'Rahatsiz hissederim ama ne oldugunu ifade etmekte zorlanirim.', scores: {'freeze': 3}),
          QuizOption(text: 'I downplay it to keep the peace — maybe I\'m overreacting.', textTr: 'Barisi korumak icin kucultirim — belki asiri tepki veriyorum.', scores: {'fawn': 3}),
        ],
      ),
      QuizQuestion(
        text: 'When you can\'t sleep because something is worrying you, your mind tends to:',
        textTr: 'Bir sey sizi endselendirdigi icin uyuyamadiginizda, zihniniz egilim olarak:',
        options: [
          QuizOption(text: 'Plan how I\'ll tackle the problem first thing tomorrow.', textTr: 'Yarin ilk is sorunu nasil ele alacagimi planlarim.', scores: {'fight': 3}),
          QuizOption(text: 'Fantasize about a different life or scenario where this problem doesn\'t exist.', textTr: 'Bu sorunun olmadigi farkli bir hayat veya senaryo hayal ederim.', scores: {'flight': 3}),
          QuizOption(text: 'Loop on the worry without reaching any conclusion — just circling.', textTr: 'Herhangi bir sonuca ulasmadan endise uzerinde donguiye girerim — sadece donuyorum.', scores: {'freeze': 3}),
          QuizOption(text: 'Worry about how the situation is affecting the other people involved.', textTr: 'Durumun dahil olan diger insanlari nasil etkiledigini merak ederim.', scores: {'fawn': 3}),
        ],
      ),
      QuizQuestion(
        text: 'Which self-care pattern do you tend to fall into during stressful periods?',
        textTr: 'Stresli donemlerde hangi oz bakim oruntusune dusme egiliminde olursunuz?',
        options: [
          QuizOption(text: 'Intense exercise or physical outlets to burn off the tension.', textTr: 'Gerilimi atmak icin yogun egzersiz veya fiziksel cikislar.', scores: {'fight': 3}),
          QuizOption(text: 'Escapism — binge-watching, scrolling, or anything to disconnect.', textTr: 'Kacis — dizi maratonu, kaydirma veya baglantiiyi koparan herhangi bir sey.', scores: {'flight': 3}),
          QuizOption(text: 'Struggling to take any self-care action at all — feeling paralyzed.', textTr: 'Herhangi bir oz bakim eylemi yapmakta zorlanma — felc hissetme.', scores: {'freeze': 3}),
          QuizOption(text: 'Taking care of everyone else and forgetting about my own needs.', textTr: 'Herkese bakmak ve kendi ihtiyaclarimi unutmak.', scores: {'fawn': 3}),
        ],
      ),
    ],
  );

  // ══════════════════════════════════════════════════════════════════════════
  // 5) DECISION-MAKING STYLE QUIZ (8 questions)
  // ══════════════════════════════════════════════════════════════════════════

  static const decisionMakingQuiz = QuizDefinition(
    id: 'decision_making',
    title: 'Decision-Making Style',
    titleTr: 'Karar Verme Stili',
    description: 'How do you navigate choices? Explore your decision compass.',
    descriptionTr: 'Secimleri nasil yonetiyorsunuz? Karar pusulaniuzi kesfedin.',
    emoji: '\u{1F9ED}',
    scoringType: QuizScoringType.categorical,
    dimensions: {
      'analytical': QuizDimensionMeta(
        key: 'analytical',
        nameEn: 'The Analyst',
        nameTr: 'Analist',
        emoji: '\u{1F4CA}',
        color: Color(0xFF3498DB),
        descriptionEn: 'You may tend to approach decisions methodically — weighing pros and cons, gathering data, and thinking things through carefully before committing. Your strength lies in thorough, evidence-based choices.',
        descriptionTr: 'Kararlara yontemli yaklasma egiliminde olabilirsiniz — artilari ve eksileri tartar, veri toplar ve taahhut etmeden once dikkatlice dusunursunuz.',
        strengthsEn: ['Makes well-researched, thoughtful choices', 'Spots flaws and risks others may miss', 'Confident in decisions backed by evidence'],
        strengthsTr: ['Iyi arastirilmis, dusunceli secimler yapar', 'Basklarinin kacirabilecegi kusurlari ve riskleri fark eder', 'Kanitlarla desteklenen kararlardan emin'],
        growthAreasEn: ['Setting a deadline to decide — analysis can become paralysis', 'Trusting that good enough is sometimes better than perfect'],
        growthAreasTr: ['Karar vermek icin son tarih belirleme — analiz felce donusebilir', 'Yeterince iyinin bazen mukemmelden daha iyi olduguna guvenmek'],
      ),
      'intuitive': QuizDimensionMeta(
        key: 'intuitive',
        nameEn: 'The Intuitive',
        nameTr: 'Sezgisel',
        emoji: '\u{2728}',
        color: Color(0xFF9B59B6),
        descriptionEn: 'You may tend to trust your gut feelings when making decisions. You often "just know" the right path, even before you can explain why. Your strength lies in rapid, values-aligned decision-making.',
        descriptionTr: 'Karar verirken ic sesine guvenmeegiliminde olabilirsiniz. Nedenini aciklayamadan once dogru yolu genellikle "hissedersiniz".',
        strengthsEn: ['Quick, confident decision-making', 'Aligned choices with deep personal values', 'Reads situations holistically rather than just the facts'],
        strengthsTr: ['Hizli, guvenli karar verme', 'Derin kisisel degerlerle uyumlu secimler', 'Durumlari sadece gerceklere degil butunsel olarak okur'],
        growthAreasEn: ['Pausing to check intuition against available information', 'Communicating the reasoning behind intuitive choices to others'],
        growthAreasTr: ['Sezgiyi mevcut bilgilerle kontrol etmek icin durakma', 'Sezgisel secimlerin arkasindaki mantigi baskalarina iletme'],
      ),
      'collaborative': QuizDimensionMeta(
        key: 'collaborative',
        nameEn: 'The Collaborator',
        nameTr: 'Is Birlici',
        emoji: '\u{1F91D}',
        color: Color(0xFF27AE60),
        descriptionEn: 'You may tend to seek input from others before making decisions. Hearing different perspectives helps you feel grounded, and your choices often reflect collective wisdom rather than a single viewpoint.',
        descriptionTr: 'Karar vermeden once basklarindan goruis alma egiliminde olabilirsiniz. Farkli bakis acilarini duymak kendinizi temellennis hissettirir.',
        strengthsEn: ['Inclusive and considerate decision-maker', 'Builds buy-in and trust through shared process', 'Catches blind spots by gathering diverse input'],
        strengthsTr: ['Kapsayici ve dusunceli karar verici', 'Paylasilan surec yoluyla guven ve katilim saglar', 'Cesitli girdiler toplayarak kor noktalari yakalar'],
        growthAreasEn: ['Deciding even when consensus isn\'t possible', 'Trusting your own voice when advice conflicts'],
        growthAreasTr: ['Konsensus mumkun olmadiginda bile karar verme', 'Tavsiyeler celisitginde kendi sesinize guvenmek'],
      ),
      'spontaneous': QuizDimensionMeta(
        key: 'spontaneous',
        nameEn: 'The Spontaneous',
        nameTr: 'Spontan',
        emoji: '\u{1F680}',
        color: Color(0xFFE74C3C),
        descriptionEn: 'You may tend to decide quickly and adapt on the fly. You trust the process of learning through action and often prefer moving forward imperfectly over waiting for the "right" moment.',
        descriptionTr: 'Hizla karar verme ve aninda uyum saglama egiliminde olabilirsiniz. Eylem yoluyla ogrenme surecine guvenirsiniz ve genellikle "dogru" ani beklmek yerine eksik de olsa ilerlemeyi tercih edersiniz.',
        strengthsEn: ['Decisive and action-oriented', 'Thrives in fast-paced, changing environments', 'Embraces learning from mistakes'],
        strengthsTr: ['Karali ve eylem odakli', 'Hizli tempolu, degisen ortamlarda gelisir', 'Hatalardan ogrenmeyi benimser'],
        growthAreasEn: ['Pausing for high-stakes decisions that warrant more thought', 'Reflecting on past decisions to build pattern awareness'],
        growthAreasTr: ['Daha fazla dusunce gerektiren yuksek riskli kararlar icin durakma', 'Oruntu farkindanligi olusturmak icin gecmis kararlar uzerine dusunme'],
      ),
    },
    questions: [
      QuizQuestion(
        text: 'You\'re choosing between two equally appealing options. How do you tend to decide?',
        textTr: 'Esit derecede cekici iki secenek arasinda secim yapiyorsunuz. Nasil karar verme egiliminde olursunuz?',
        options: [
          QuizOption(text: 'I make a pros and cons list and evaluate systematically.', textTr: 'Arti ve eksi listesi yapar ve sistematik olarak degerlendiririm.', scores: {'analytical': 3}),
          QuizOption(text: 'I go with whichever one "feels right" — my gut usually knows.', textTr: 'Hangisi "dogru hissettiriyorsa" onu secerim — iccgudum genellikle bilir.', scores: {'intuitive': 3}),
          QuizOption(text: 'I ask trusted friends or family what they think.', textTr: 'Guvenilir arkadaislari veya aileye ne dusunduklerin sorarim.', scores: {'collaborative': 3}),
          QuizOption(text: 'I pick one quickly and adjust course if needed — no point overthinking.', textTr: 'Hizlica birini secer ve gerekirse rotayi ayarlarim — asiri dusunmenin anlami yok.', scores: {'spontaneous': 3}),
        ],
      ),
      QuizQuestion(
        text: 'When buying something significant, your process tends to be:',
        textTr: 'Onemli bir sey satin alirken, sureiniz egilim olarak:',
        options: [
          QuizOption(text: 'Extensive research — I read reviews, compare specs, and sleep on it.', textTr: 'Kapsamli arastirma — yorumlari okur, ozellikleri karsilastirir ve uzerine uyurum.', scores: {'analytical': 3}),
          QuizOption(text: 'I browse until something catches my eye and feels right.', textTr: 'Bir sey gozume carpip dogru hissedene kadar gozatarim.', scores: {'intuitive': 3}),
          QuizOption(text: 'I ask people I respect what they\'d recommend.', textTr: 'Saygi duydugum insanlara ne onerirlerini sorarim.', scores: {'collaborative': 3}),
          QuizOption(text: 'If I like it, I buy it — life is too short for decision fatigue.', textTr: 'Begenirsem alirim — hayat karar yorgunlugu icin cok kisa.', scores: {'spontaneous': 3}),
        ],
      ),
      QuizQuestion(
        text: 'A decision you made turned out badly. How do you tend to process it?',
        textTr: 'Verdiginiz bir karar kotu sonuclandi. Bunu nasil isleme egiliminde olursunuz?',
        options: [
          QuizOption(text: 'I analyze what went wrong to prevent repeating the mistake.', textTr: 'Hatayi tekrarlamamak icin neyin yanlis gittigini analiz ederim.', scores: {'analytical': 3}),
          QuizOption(text: 'I reflect on whether I ignored my instincts and promise to trust them next time.', textTr: 'Icgudelerimi gormezden gelip gelmedigimi dusunur ve bir dahaki sefere onlara guvenmeye soz veririm.', scores: {'intuitive': 3}),
          QuizOption(text: 'I discuss it with people close to me to gain perspective.', textTr: 'Bakis acisi kazanmak icin yakin cevremle tartisirim.', scores: {'collaborative': 3}),
          QuizOption(text: 'I move on quickly — dwelling on it doesn\'t change the outcome.', textTr: 'Hizlica devam ederim — uzerine takilmak sonucu degistirmez.', scores: {'spontaneous': 3}),
        ],
      ),
      QuizQuestion(
        text: 'When planning a trip, your approach tends to be:',
        textTr: 'Bir seyahat planlarken, yaklasiminiz egilim olarak:',
        options: [
          QuizOption(text: 'Detailed itinerary with research on every destination and restaurant.', textTr: 'Her destinasyon ve restoran hakkinda arastirmayla detayli program.', scores: {'analytical': 3}),
          QuizOption(text: 'I choose a destination that calls to me and figure out the rest as I go.', textTr: 'Beni cagiran bir destinasyon secer ve geri kalanini gittikce hallederim.', scores: {'intuitive': 3}),
          QuizOption(text: 'I plan with travel companions and incorporate everyone\'s wishes.', textTr: 'Seyahat arkadaslariyla planlar ve herkesin isteklerini dahil ederim.', scores: {'collaborative': 3}),
          QuizOption(text: 'Minimal planning — the best experiences are unplanned discoveries.', textTr: 'Minimal planlama — en iyi deneyimler plansiz kesfilerdir.', scores: {'spontaneous': 3}),
        ],
      ),
      QuizQuestion(
        text: 'At a restaurant with a long menu, you tend to:',
        textTr: 'Uzun menulu bir restoranda, egilim olarak:',
        options: [
          QuizOption(text: 'Read the entire menu carefully before narrowing down options.', textTr: 'Secenekleri daraltmadan once tum menuyu dikkatlice okurum.', scores: {'analytical': 3}),
          QuizOption(text: 'Quickly scan and choose whatever jumps out at me.', textTr: 'Hizlica gozden gecirir ve bana ne one cikarsa onu secerim.', scores: {'intuitive': 3}),
          QuizOption(text: 'Ask the server for recommendations or check what others are ordering.', textTr: 'Garsondan oneriler isterim veya baskalrinin ne siparis ettigini kontrol ederim.', scores: {'collaborative': 3}),
          QuizOption(text: 'Pick the first thing that sounds good — it\'s just dinner.', textTr: 'Kulaga iyi gelen ilk seyi secerim — sadece aksam yemegi.', scores: {'spontaneous': 3}),
        ],
      ),
      QuizQuestion(
        text: 'When facing a major life decision (career change, moving, etc.), you tend to:',
        textTr: 'Buyuk bir yasam karariyla (kariyer degisikligi, tasima vb.) karsi karsya kaldiginda, egilim olarak:',
        options: [
          QuizOption(text: 'Create a spreadsheet or framework to evaluate all factors objectively.', textTr: 'Tum faktorleri nesnel olarak degerlendirmek icin bir tablo veya cerceve olustururum.', scores: {'analytical': 3}),
          QuizOption(text: 'Sit with the question and wait for clarity to emerge from within.', textTr: 'Soruyla oturur ve icinizden netligin ortaya cikmaisni beklerim.', scores: {'intuitive': 3}),
          QuizOption(text: 'Have deep conversations with mentors, friends, and family.', textTr: 'Mentorlar, arkadaslar ve aileyle derin konusmalar yaparim.', scores: {'collaborative': 3}),
          QuizOption(text: 'Lean toward the option that excites me most, even if it\'s risky.', textTr: 'Riskli olsa bile beni en cok heyecanlandiran secenege yaslanim.', scores: {'spontaneous': 3}),
        ],
      ),
      QuizQuestion(
        text: 'When someone asks you for advice on a decision, you tend to:',
        textTr: 'Biri sizden bir karar hakkinda tavsiye istediginde, egilim olarak:',
        options: [
          QuizOption(text: 'Help them think through the logic and weigh the trade-offs.', textTr: 'Mantigi dusunmelerine ve artilari eksileri tartmalarna yardimci olurum.', scores: {'analytical': 3}),
          QuizOption(text: 'Ask them what their heart is telling them beneath the noise.', textTr: 'Gurultunun altinda kalplerinin onlara ne soyledigini sorarim.', scores: {'intuitive': 3}),
          QuizOption(text: 'Suggest they talk to a few more people to broaden their perspective.', textTr: 'Bakis acilarini genisletmek icin birkac kisi daha ile konusmalrini oneiririm.', scores: {'collaborative': 3}),
          QuizOption(text: 'Encourage them to just try something and course-correct later.', textTr: 'Bir seyler denemelerini ve sonra rotayi duzeltmelerini tesvik ederim.', scores: {'spontaneous': 3}),
        ],
      ),
      QuizQuestion(
        text: 'Looking back at your best decisions, they were usually made by:',
        textTr: 'En iyi kararlariniza geri baktiginizda, genellikle sunlarla yapilmislardi:',
        options: [
          QuizOption(text: 'Careful research and logical evaluation of all options.', textTr: 'Dikkatli arastirma ve tum seceneklerin mantiksal degerlendirmesi.', scores: {'analytical': 3}),
          QuizOption(text: 'Trusting a deep inner knowing, even when the logic wasn\'t clear.', textTr: 'Mantik net olmadiginda bile derin bir ic bilgiye guvenmek.', scores: {'intuitive': 3}),
          QuizOption(text: 'Listening to wise people around me and synthesizing their input.', textTr: 'Etrafmdaki bilge insanlari dinlemek ve girdilerini sentezlemek.', scores: {'collaborative': 3}),
          QuizOption(text: 'Acting boldly and figuring things out along the way.', textTr: 'Cesurca hareket etmek ve yol boyunca hallletmek.', scores: {'spontaneous': 3}),
        ],
      ),
    ],
  );

  // ══════════════════════════════════════════════════════════════════════════
  // 6) ENERGY CYCLE QUIZ (8 questions)
  // ══════════════════════════════════════════════════════════════════════════

  static const energyCycleQuiz = QuizDefinition(
    id: 'energy_cycle',
    title: 'Energy Cycle',
    titleTr: 'Enerji Dongusu',
    description: 'When does your energy peak? Discover your natural rhythm.',
    descriptionTr: 'Enerjiniz ne zaman zirve yapar? Dogal ritminizi kesfedin.',
    emoji: '\u{2600}',
    scoringType: QuizScoringType.categorical,
    dimensions: {
      'morning': QuizDimensionMeta(
        key: 'morning',
        nameEn: 'Morning Riser',
        nameTr: 'Sabahci',
        emoji: '\u{1F305}',
        color: Color(0xFFF39C12),
        descriptionEn: 'You may tend to feel most alive and focused in the early hours of the day. Your clarity and energy often peak before noon, making mornings your natural time for meaningful work and reflection.',
        descriptionTr: 'Gunun erken saatlerinde en canli ve odakli hissetme egiliminde olabilirsiniz. Netliginiz ve enerjiniz genellikle ogle oncesinde zirve yapar.',
        strengthsEn: ['Consistent, early-day productivity', 'Natural alignment with conventional schedules', 'Tends to start the day with intention and clarity'],
        strengthsTr: ['Tutarli, erken gun verimliligi', 'Geleneksel programlarla dogal uyum', 'Gunue niyet ve netlikle baslama egilimi'],
        growthAreasEn: ['Protecting evening energy for wind-down rather than pushing through', 'Being patient with night-owl friends and collaborators'],
        growthAreasTr: ['Aksam enerjisini zorlamak yerine yavaslama icin koruma', 'Gece kusu arkadaslara ve is arkadaslarina karsi sabirl olma'],
      ),
      'night': QuizDimensionMeta(
        key: 'night',
        nameEn: 'Night Owl',
        nameTr: 'Gece Kusu',
        emoji: '\u{1F319}',
        color: Color(0xFF8E54E9),
        descriptionEn: 'You may tend to come alive as the day winds down. Your best thinking, creativity, and focus often emerge in the evening or late at night, when the world quiets and distractions fade.',
        descriptionTr: 'Gun ilerledikce canlanma egiliminde olabilirsiniz. En iyi dusunceniz, yaraticiliginiz ve odaginiz genellikle aksam veya gec saatlerde ortaya cikar.',
        strengthsEn: ['Creative and productive during quiet hours', 'Deep focus when the world is asleep', 'Comfortable with non-conventional schedules'],
        strengthsTr: ['Sessiz saatlerde yaratici ve verimli', 'Dunya uyurken derin odak', 'Geleneksel olmayan programlarla rahat'],
        growthAreasEn: ['Creating a morning routine that honours your slower start', 'Ensuring enough sleep even when inspiration strikes late'],
        growthAreasTr: ['Daha yavas baslangicinizi onurlandiran bir sabah rutini olusturma', 'Ilham gec gelse bile yeterli uyku saglama'],
      ),
      'steady': QuizDimensionMeta(
        key: 'steady',
        nameEn: 'Steady Current',
        nameTr: 'Sabit Akim',
        emoji: '\u{1F30A}',
        color: Color(0xFF27AE60),
        descriptionEn: 'You may tend to maintain a relatively even energy level throughout the day. Rather than dramatic peaks and valleys, you might notice a sustainable, consistent flow that helps you pace yourself well.',
        descriptionTr: 'Gun boyunca nispeten esit bir enerji seviyesi surdurmeegiliminde olabilirsiniz. Dramatik zirveler ve vadiler yerine kendinizi iyi ayarlamaniza yardimci olan surdurulebilir, tutarli bir akis fark edebilirsiniz.',
        strengthsEn: ['Reliable and consistent energy output', 'Naturally good at pacing and sustainability', 'Less affected by time-of-day variations'],
        strengthsTr: ['Guvenilir ve tutarli enerji ciktisi', 'Dogal olarak hiz ve surdurulebilirlikte iyi', 'Gun-icin-zaman varyasyonlarindan daha az etkilenir'],
        growthAreasEn: ['Creating intentional energy peaks for creative or challenging tasks', 'Noticing subtle energy dips before they become exhaustion'],
        growthAreasTr: ['Yaratici veya zorlu gorevler icin niyetli enerji zirveleri olusturma', 'Tukenmeye donusmeden once ince enerji dususlerini fark etme'],
      ),
      'burst': QuizDimensionMeta(
        key: 'burst',
        nameEn: 'Burst Creator',
        nameTr: 'Patlama Yaratici',
        emoji: '\u{1F4A5}',
        color: Color(0xFFE74C3C),
        descriptionEn: 'You may tend to experience intense bursts of energy and focus followed by periods of rest. Your productivity often comes in powerful waves, and you might notice that forcing a steady pace feels unnatural.',
        descriptionTr: 'Yogun enerji ve odak patlamalari yasama egiliminde olabilirsiniz, ardindan dinlenme donemleri gelir. Verimliligini genellikle guclu dalgalar halinde gelir.',
        strengthsEn: ['Capable of extraordinary focus during peak moments', 'Produces high-quality work in concentrated sessions', 'Natural creative rhythm that mirrors inspiration cycles'],
        strengthsTr: ['Zirve anlarda olaganustu odak kapasitesi', 'Yogunlastirilmis oturumlarda yuksek kaliteli is uretir', 'Ilham donglerini yansitan dogal yaratici ritim'],
        growthAreasEn: ['Honouring rest between bursts without guilt', 'Planning around your rhythm rather than fighting it'],
        growthAreasTr: ['Patlamalar arasindaki dinlenmeyi sucluluk olmadan onurlandirma', 'Ritminize karsi savasmak yerine etrafinda planlama'],
      ),
    },
    questions: [
      QuizQuestion(
        text: 'What time of day do you tend to feel most mentally sharp?',
        textTr: 'Gunun hangi saatinde kendinizi zihinsel olarak en keskin hissetme egiliminde olursunuz?',
        options: [
          QuizOption(text: 'Early morning — my mind is clearest before the world wakes up.', textTr: 'Erken sabah — dunya uyanmadan once zihnim en berrak.', scores: {'morning': 3}),
          QuizOption(text: 'Late evening or night — I hit my stride when things quiet down.', textTr: 'Gec aksam veya gece — isler sakinlestiginde hizima kavusurum.', scores: {'night': 3}),
          QuizOption(text: 'I feel fairly consistent throughout the day — no dramatic peak.', textTr: 'Gun boyunca oldukca tutarli hissediyorum — dramatik zirve yok.', scores: {'steady': 3}),
          QuizOption(text: 'It varies unpredictably — sometimes I\'m sharp at 10am, sometimes at 10pm.', textTr: 'Ongourulemez sekilde degisir — bazen sabah 10da, bazen gece 10da keskinim.', scores: {'burst': 3}),
        ],
      ),
      QuizQuestion(
        text: 'Your alarm goes off on a free day with no obligations. You tend to:',
        textTr: 'Zorunlulugu olmayan bos bir gunde alarminiz caliyor. Egilim olarak:',
        options: [
          QuizOption(text: 'Wake up at roughly the same time anyway — my body clock is set.', textTr: 'Yine de yaklasik ayni saatte uyanrim — vucudum saat kurulmustur.', scores: {'morning': 3}),
          QuizOption(text: 'Sleep in without guilt — I know I\'ll be productive later tonight.', textTr: 'Sucluluk duymadan uyurum — bu gece verimli olacagimi biliyorum.', scores: {'night': 3}),
          QuizOption(text: 'Wake up at my usual time, maybe sleep in 30 minutes.', textTr: 'Normal zamanımda uyanir, belki 30 dakika daha uyurum.', scores: {'steady': 3}),
          QuizOption(text: 'It completely depends on what I was doing last night — no pattern.', textTr: 'Tamamen dun gece ne yaptigima bagli — oruntu yok.', scores: {'burst': 3}),
        ],
      ),
      QuizQuestion(
        text: 'When do you tend to get your most creative ideas?',
        textTr: 'En yaratici fikirlerinizi ne zaman alma egiliminde olursunuz?',
        options: [
          QuizOption(text: 'During my morning routine — shower thoughts, morning walks.', textTr: 'Sabah rutinim sirasinda — dus dusunceleri, sabah yuruyusleri.', scores: {'morning': 3}),
          QuizOption(text: 'Late at night when the house is quiet and I can think freely.', textTr: 'Ev sessiz oldugunda ve ozgurce dusunebilecegim gece gec saatlerde.', scores: {'night': 3}),
          QuizOption(text: 'They come gradually throughout the day at a steady pace.', textTr: 'Gun boyunca sabit bir tempoda yavasce gelirler.', scores: {'steady': 3}),
          QuizOption(text: 'In sudden flashes — inspiration strikes randomly and intensely.', textTr: 'Ani parlmalarda — ilham rastgele ve yogun sekilde vurur.', scores: {'burst': 3}),
        ],
      ),
      QuizQuestion(
        text: 'How would you describe your typical energy pattern across a day?',
        textTr: 'Bir gun boyunca tipik enerji ornntunuzu nasil tanimlarsiniz?',
        options: [
          QuizOption(text: 'High in the morning, gradually declining by evening.', textTr: 'Sabah yuksek, aksam dogru kademeli olarak dusen.', scores: {'morning': 3}),
          QuizOption(text: 'Slow to start, building momentum as the day goes on, peaking at night.', textTr: 'Yavas baslayan, gun ilerledikce ivme kazanan, gece zirve yapan.', scores: {'night': 3}),
          QuizOption(text: 'A gentle, even line — no dramatic ups or downs.', textTr: 'Nazik, esit bir cizgi — dramatik inisler ve cikislar yok.', scores: {'steady': 3}),
          QuizOption(text: 'Spiky — intense energy, then flat, then intense again unpredictably.', textTr: 'Sivri — yogun enerji, sonra duz, sonra tekrar ongoulememz sekilde yogun.', scores: {'burst': 3}),
        ],
      ),
      QuizQuestion(
        text: 'When you have an important task to complete, when do you tend to schedule it?',
        textTr: 'Tamamlanacak onemli bir goeviniz oldugunda, ne zaman programlama egiliminde olursunuz?',
        options: [
          QuizOption(text: 'First thing in the morning — tackle the hardest thing when I\'m fresh.', textTr: 'Sabah ilk is — en zor seyi taze oldugunmda hallederim.', scores: {'morning': 3}),
          QuizOption(text: 'Evening — that\'s when I can really focus without distraction.', textTr: 'Aksam — dikkat dagitmadan gercekten odaklanabildigim zaman.', scores: {'night': 3}),
          QuizOption(text: 'Whenever it fits in my schedule — my energy is fairly stable.', textTr: 'Programma ne zaman uyarsa — enerjim oldukca stabil.', scores: {'steady': 3}),
          QuizOption(text: 'When I feel the energy hit — I\'ve learned to ride the wave when it comes.', textTr: 'Enerji vurdugunda — geldiginde dalgayi suermeyi ogrendim.', scores: {'burst': 3}),
        ],
      ),
      QuizQuestion(
        text: 'How does exercise fit into your energy pattern?',
        textTr: 'Egzersiz enerji oruntunuze nasil uyar?',
        options: [
          QuizOption(text: 'Morning workouts feel natural and set a great tone for the day.', textTr: 'Sabah antrenamanlari dogal hissettirior ve gune harika bir ton verir.', scores: {'morning': 3}),
          QuizOption(text: 'I prefer evening exercise — it\'s when my body feels most ready.', textTr: 'Aksam egzersizini tercih ederim — vucudumun en hazir hissettigi zaman.', scores: {'night': 3}),
          QuizOption(text: 'I can exercise at any time — my energy doesn\'t fluctuate much.', textTr: 'Herhangi bir zamanda egzersiz yapabilirim — enerjim cok dalgalanmaz.', scores: {'steady': 3}),
          QuizOption(text: 'I exercise when I feel a surge of energy — sometimes at odd hours.', textTr: 'Enerji dalgasi hissettigimde egzersiz yaparim — bazen garip saatlerde.', scores: {'burst': 3}),
        ],
      ),
      QuizQuestion(
        text: 'When working on a project, your productivity style tends to be:',
        textTr: 'Bir proje uzerinde calisirken, verimlilik stiliniz egilim olarak:',
        options: [
          QuizOption(text: 'Best in focused morning sessions — I front-load my productive hours.', textTr: 'Odakli sabah oturumlarinda en iyi — verimli saatlerimi one yuklerim.', scores: {'morning': 3}),
          QuizOption(text: 'I do my deepest work after dinner when interruptions stop.', textTr: 'En derin isimi aksam yemeginden sonra interuptions durdugunvda yaparim.', scores: {'night': 3}),
          QuizOption(text: 'I work steadily throughout the day, maintaining a consistent pace.', textTr: 'Gun boyunca istikrarli calisrim, tutarli bir tempo surdurerek.', scores: {'steady': 3}),
          QuizOption(text: 'I work in intense sprints followed by breaks — it\'s how I\'m wired.', textTr: 'Yogun sprintler ve ardindan molalar halinde calisirim — boyle baglantiylimi.', scores: {'burst': 3}),
        ],
      ),
      QuizQuestion(
        text: 'If you could design your ideal daily schedule with no constraints, it would be:',
        textTr: 'Hicbir kisitlama olmadan ideal gunluk programinizi tasarlayabilseydiniz:',
        options: [
          QuizOption(text: 'Up with the sun, productive morning, relaxed afternoon, early to bed.', textTr: 'Gunesle kalkis, verimli sabah, rahat ogle sonrasi, erken yatma.', scores: {'morning': 3}),
          QuizOption(text: 'Sleep late, ease into the day, peak productivity from evening into night.', textTr: 'Gec uyuma, gune yavas girme, aksamdan geceye zirve verimlilik.', scores: {'night': 3}),
          QuizOption(text: 'A balanced rhythm — work, rest, and play evenly distributed.', textTr: 'Dengeli bir ritim — is, dinlenme ve eglence esit dagitilmis.', scores: {'steady': 3}),
          QuizOption(text: 'No fixed schedule — I\'d work when inspired and rest when I need to.', textTr: 'Sabit program yok — ilham geldiginde calisir, ihtiyacim oldugunda dinlenirim.', scores: {'burst': 3}),
        ],
      ),
    ],
  );
}
