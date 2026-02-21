// ════════════════════════════════════════════════════════════════════════════
// QUIZ CONTENT - InnerCycles Self-Reflection Quiz Definitions
// ════════════════════════════════════════════════════════════════════════════
// Six thoughtful, psychologically-grounded quizzes for personal awareness.
// NOT clinical assessments. All language uses safe framing:
// "tends to", "you may notice", "patterns suggest".
// ════════════════════════════════════════════════════════════════════════════

import 'dart:ui';
import '../../core/theme/app_colors.dart';
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
    return allQuizzes.where((q) => q.id == id).firstOrNull;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 1) EMOTIONAL INTELLIGENCE QUIZ (10 questions)
  // ══════════════════════════════════════════════════════════════════════════

  static const emotionalIntelligenceQuiz = QuizDefinition(
    id: 'emotional_intelligence',
    title: 'Emotional Intelligence',
    titleTr: 'Duygusal Zeka',
    description: 'Explore how you navigate emotions — yours and others\'.',
    descriptionTr:
        'Duyguları nasıl yönettiğinizi keşfedin — sizin ve başkalarının.',
    emoji: '\u{1F9E0}',
    scoringType: QuizScoringType.multiDimension,
    dimensions: {
      'self_awareness': QuizDimensionMeta(
        key: 'self_awareness',
        nameEn: 'Self-Awareness',
        nameTr: 'Öz Farkındalık',
        emoji: '\u{1F52D}',
        color: AppColors.auroraStart,
        descriptionEn:
            'You may tend to have a clear sense of your own emotional landscape. People with this strength often notice shifts in their mood early and understand what drives their reactions.',
        descriptionTr:
            'Kendi duygusal manzaranız hakkında net bir algınız olabilir. Bu güce sahip kişiler genellikle ruh hallerindeki değişimleri erken fark eder.',
        strengthsEn: [
          'Recognizes emotional triggers quickly',
          'Comfortable with self-reflection',
          'Honest about personal limitations',
        ],
        strengthsTr: [
          'Duygusal tetikleyicileri hızla tanır',
          'Öz yansıtma konusunda rahat',
          'Kişisel sınırlamalar hakkında dürüst',
        ],
        growthAreasEn: [
          'Translating self-knowledge into action',
          'Sharing inner awareness with others',
        ],
        growthAreasTr: [
          'Öz bilgiyi eyleme dönüştürme',
          'İç farkındalığı başkalarıyla paylaşma',
        ],
      ),
      'empathy': QuizDimensionMeta(
        key: 'empathy',
        nameEn: 'Empathy',
        nameTr: 'Empati',
        emoji: '\u{1F49C}',
        color: AppColors.amethyst,
        descriptionEn:
            'You may tend to naturally tune into what others are feeling. This quality often helps you build deep, trusting connections with people around you.',
        descriptionTr:
            'Başkalarının ne hissettiğine doğal olarak uyum sağlama eğiliminde olabilirsiniz. Bu özellik genellikle derin, güvenilir bağlantılar kurmanıza yardımcı olur.',
        strengthsEn: [
          'Reads emotional cues with ease',
          'Creates safe space for others',
          'Strong active listening skills',
        ],
        strengthsTr: [
          'Duygusal ipuçlarını kolayca okur',
          'Başkaları için güvenli alan yaratır',
          'Güçlü aktif dinleme becerileri',
        ],
        growthAreasEn: [
          'Setting boundaries while staying empathic',
          'Avoiding emotional exhaustion from over-absorbing',
        ],
        growthAreasTr: [
          'Empatik kalırken sınır koyma',
          'Aşırı absorbe olmaktan kaynaklanan duygusal tükenmeyi önleme',
        ],
      ),
      'regulation': QuizDimensionMeta(
        key: 'regulation',
        nameEn: 'Emotional Regulation',
        nameTr: 'Duygusal Düzenleme',
        emoji: '\u{1F3AF}',
        color: AppColors.greenAccent,
        descriptionEn:
            'You may tend to stay composed even when emotions run high. This capacity often means you can think clearly during stressful moments and recover from setbacks relatively quickly.',
        descriptionTr:
            'Duygular yoğun olduğunda bile sakin kalma eğiliminde olabilirsiniz. Bu kapasite genellikle stresli anlarda net düşünebileceğiniz anlamına gelir.',
        strengthsEn: [
          'Stays grounded under pressure',
          'Recovers from upsets relatively fast',
          'Models calm for those around you',
        ],
        strengthsTr: [
          'Baskı altında sağlam kalır',
          'Üzüntülerden nispeten hızlı toparlanır',
          'Çevresindekiler için sakinlik modeli olur',
        ],
        growthAreasEn: [
          'Allowing yourself to fully feel before regulating',
          'Checking that composure isn\'t emotional suppression',
        ],
        growthAreasTr: [
          'Düzenlemeden önce tam olarak hissetmeye izin verme',
          'Sakinliğin duygusal bastırma olmadığını kontrol etme',
        ],
      ),
      'motivation': QuizDimensionMeta(
        key: 'motivation',
        nameEn: 'Inner Motivation',
        nameTr: 'İç Motivasyon',
        emoji: '\u{1F525}',
        color: AppColors.warmAccent,
        descriptionEn:
            'You may tend to draw energy from an internal compass rather than external rewards. This drive often helps you persist through challenges with a sense of purpose.',
        descriptionTr:
            'Dış ödüllerden ziyade iç pusulanızdan enerji alma eğiliminde olabilirsiniz. Bu dürtünün genellikle zorluklarda amaç duygusuyla devam etmenize yardımcı olduğu görülür.',
        strengthsEn: [
          'Self-directed and purposeful',
          'Resilient in the face of setbacks',
          'Finds meaning in effort itself',
        ],
        strengthsTr: [
          'Öz yönetimli ve amaçlı',
          'Aksilikler karşısında dirençli',
          'Çabanın kendisinde anlam bulur',
        ],
        growthAreasEn: [
          'Balancing drive with rest and recovery',
          'Celebrating small wins along the way',
        ],
        growthAreasTr: [
          'Dürtünün dinlenme ve iyileşme ile dengelenmesi',
          'Yol boyunca küçük başarıları kutlama',
        ],
      ),
      'social_skills': QuizDimensionMeta(
        key: 'social_skills',
        nameEn: 'Social Skills',
        nameTr: 'Sosyal Beceriler',
        emoji: '\u{1F91D}',
        color: AppColors.blueAccent,
        descriptionEn:
            'You may tend to navigate social dynamics with confidence and warmth. This ability often makes collaboration feel natural and helps you build rapport quickly.',
        descriptionTr:
            'Sosyal dinamikleri güven ve sıcaklıkla yönetme eğiliminde olabilirsiniz. Bu yetenek genellikle iş birliğini doğal hissettirir.',
        strengthsEn: [
          'Builds rapport naturally',
          'Navigates group dynamics with ease',
          'Communicates needs clearly and kindly',
        ],
        strengthsTr: [
          'Doğal olarak yakınlık kurar',
          'Grup dinamiklerini kolaylıkla yönetir',
          'İhtiyaçlarını açık ve nazikçe iletir',
        ],
        growthAreasEn: [
          'Deepening relationships beyond surface warmth',
          'Being authentic even when it risks social friction',
        ],
        growthAreasTr: [
          'İlişkileri yüzeysel sıcaklığın ötesine derinleştirme',
          'Sosyal sürtüşmeyi riske etse bile otantik olma',
        ],
      ),
    },
    questions: [
      // Q1 - Self-Awareness
      QuizQuestion(
        text:
            'When you notice a sudden mood shift during your day, what tends to happen next?',
        textTr:
            'Gün içinde ani bir ruh hali değişikliği fark ettiğinizde, sonra ne olma eğilimindedir?',
        category: 'self_awareness',
        options: [
          QuizOption(
            text: 'I pause and try to name the feeling before reacting.',
            textTr:
                'Tepki vermeden önce durur ve duyguyu adlandırmaya çalışırım.',
            scores: {'self_awareness': 3, 'regulation': 1},
          ),
          QuizOption(
            text: 'I check in with someone I trust to process it together.',
            textTr:
                'Birlikte işlemek için güvendiğim biriyle iletişim kurarım.',
            scores: {'empathy': 2, 'social_skills': 2},
          ),
          QuizOption(
            text: 'I push through it — I can deal with feelings later.',
            textTr: 'Devam ederim — duygularla sonra ilgilenebilirim.',
            scores: {'motivation': 2, 'regulation': 1},
          ),
          QuizOption(
            text:
                'I often don\'t notice the shift until someone else points it out.',
            textTr:
                'Değişimi genellikle başkası işaret edene kadar fark etmem.',
            scores: {'social_skills': 1},
          ),
        ],
      ),
      // Q2 - Empathy
      QuizQuestion(
        text: 'A friend is upset but says "I\'m fine." What do you tend to do?',
        textTr:
            'Bir arkadasiniz uzgun ama "iyiyim" diyor. Ne yapma eğiliminde olursunuz?',
        category: 'empathy',
        options: [
          QuizOption(
            text:
                'I gently let them know I can sense something is off and I\'m here if they want to talk.',
            textTr:
                'Bir şeyler olduğunu hissettiğimi nazikçe bildirip, konuşmak isterlerse burada olduğumu söylerim.',
            scores: {'empathy': 3, 'social_skills': 1},
          ),
          QuizOption(
            text:
                'I take them at their word — if they say they\'re fine, I respect that.',
            textTr:
                'Sözlerine güvenip — iyi olduklarını söylerlerse buna saygı gösteririm.',
            scores: {'regulation': 2, 'self_awareness': 1},
          ),
          QuizOption(
            text: 'I share a similar experience of my own to show solidarity.',
            textTr:
                'Dayanışma göstermek için benzer bir deneyimimi paylaşırım.',
            scores: {'social_skills': 2, 'empathy': 1},
          ),
          QuizOption(
            text: 'I try to cheer them up with a distraction or humour.',
            textTr: 'Dikkat dağıtma veya mizahla neşelendirmeye çalışırım.',
            scores: {'motivation': 2, 'social_skills': 1},
          ),
        ],
      ),
      // Q3 - Regulation
      QuizQuestion(
        text:
            'When something makes you really angry, which pattern do you notice most?',
        textTr:
            'Bir şey sizi gerçekten kızdırdığında, en çok hangi örüntüyü fark edersiniz?',
        category: 'regulation',
        options: [
          QuizOption(
            text:
                'I feel the heat but can usually take a breath before responding.',
            textTr:
                'Sıcaklığı hissederim ama genellikle cevap vermeden önce nefes alabilirim.',
            scores: {'regulation': 3, 'self_awareness': 1},
          ),
          QuizOption(
            text:
                'I tend to express it quickly — I\'d rather get it out than hold it in.',
            textTr:
                'Hızlıca ifade etme eğilimindeyim — içimde tutmaktansa çıkarmayı tercih ederim.',
            scores: {'motivation': 2, 'self_awareness': 1},
          ),
          QuizOption(
            text:
                'I go quiet and process it internally before talking about it.',
            textTr: 'Sessizleşirim ve konuşmadan önce içsel olarak işlerim.',
            scores: {'self_awareness': 2, 'regulation': 1},
          ),
          QuizOption(
            text:
                'I channel it into something productive — exercise, cleaning, work.',
            textTr: 'Üretken bir şeye yönlendiririm — egzersiz, temizlik, iş.',
            scores: {'regulation': 2, 'motivation': 2},
          ),
        ],
      ),
      // Q4 - Motivation
      QuizQuestion(
        text:
            'What tends to keep you going when a personal goal feels difficult?',
        textTr:
            'Kişisel bir hedef zor hissettiğinde sizi devam ettirme eğiliminde olan şey nedir?',
        category: 'motivation',
        options: [
          QuizOption(
            text:
                'Remembering why I started and what it means to me personally.',
            textTr:
                'Neden başladığımı ve benim için ne anlama geldiğini hatırlamak.',
            scores: {'motivation': 3, 'self_awareness': 1},
          ),
          QuizOption(
            text: 'Support and encouragement from people I care about.',
            textTr: 'Önem verdiğim insanlardan destek ve teşvik.',
            scores: {'social_skills': 2, 'empathy': 1},
          ),
          QuizOption(
            text: 'Breaking it into smaller steps so it feels manageable.',
            textTr:
                'Yönetilebilir hissettirmek için daha küçük adımlara bölme.',
            scores: {'regulation': 2, 'motivation': 1},
          ),
          QuizOption(
            text:
                'Honestly, I may tend to shift focus to something new if it gets too hard.',
            textTr:
                'Dürüst olmak gerekirse, çok zorlaşırsa yeni bir şeye odaklanma eğiliminde olabilirim.',
            scores: {'self_awareness': 2},
          ),
        ],
      ),
      // Q5 - Social Skills
      QuizQuestion(
        text:
            'In a group where two people disagree, what role do you tend to play?',
        textTr:
            'İki kişinin anlaşmadığı bir grupta, hangi rolü oynama eğiliminde olursunuz?',
        category: 'social_skills',
        options: [
          QuizOption(
            text: 'I naturally mediate — helping both sides feel heard.',
            textTr:
                'Doğal olarak arabuluculuk yaparım — her iki tarafın da duyulmasına yardımcı olurum.',
            scores: {'social_skills': 3, 'empathy': 1},
          ),
          QuizOption(
            text: 'I tend to support the person I think is right.',
            textTr:
                'Haklı olduğunu düşündüğüm kişiyi destekleme eğilimindeyim.',
            scores: {'motivation': 2, 'self_awareness': 1},
          ),
          QuizOption(
            text: 'I observe quietly and only speak up if asked.',
            textTr: 'Sessizce gözlemler ve sadece sorulursa konuşurum.',
            scores: {'self_awareness': 2, 'regulation': 1},
          ),
          QuizOption(
            text: 'I try to lighten the mood and move past the tension.',
            textTr: 'Havayı yumuşatma ve gerilimi aşma eğilimindeyim.',
            scores: {'social_skills': 2, 'regulation': 1},
          ),
        ],
      ),
      // Q6 - Self-Awareness
      QuizQuestion(
        text:
            'How would you describe your relationship with your own emotions?',
        textTr: 'Kendi duygularınızla ilişkinizi nasıl tanımlarsınız?',
        category: 'self_awareness',
        options: [
          QuizOption(
            text:
                'I feel like I know them well — they\'re familiar companions.',
            textTr:
                'Onları iyi tanıdığımı hissediyorum — tanıdık yol arkadaşları.',
            scores: {'self_awareness': 3},
          ),
          QuizOption(
            text:
                'I understand them better when I talk them through with someone.',
            textTr: 'Biriyle konuşarak işlerken daha iyi anlıyorum.',
            scores: {'empathy': 2, 'social_skills': 1},
          ),
          QuizOption(
            text:
                'I notice them but tend to focus more on actions than feelings.',
            textTr:
                'Fark ederim ama duygulardan çok eylemlere odaklanma eğilimindeyim.',
            scores: {'motivation': 2, 'regulation': 1},
          ),
          QuizOption(
            text:
                'They sometimes surprise me — I\'m still learning to read them.',
            textTr: 'Bazen şaşırtırlar — onları okumayı hâlâ öğreniyorum.',
            scores: {'self_awareness': 1, 'empathy': 1},
          ),
        ],
      ),
      // Q7 - Empathy
      QuizQuestion(
        text:
            'When you watch a movie with an emotional scene, what tends to happen?',
        textTr:
            'Duygusal bir sahne olan bir film izlediğinizde, ne olma eğilimindedir?',
        category: 'empathy',
        options: [
          QuizOption(
            text: 'I may feel deeply moved — sometimes tears come easily.',
            textTr:
                'Derinden etkilenebilirim — bazen gözyaşları kolayca gelir.',
            scores: {'empathy': 3},
          ),
          QuizOption(
            text:
                'I appreciate the storytelling but stay emotionally composed.',
            textTr:
                'Hikaye anlatımını takdir ederim ama duygusal olarak sakin kalırım.',
            scores: {'regulation': 2, 'self_awareness': 1},
          ),
          QuizOption(
            text:
                'I notice what the characters could do differently to solve the problem.',
            textTr:
                'Karakterlerin sorunu çözmek için farklı neler yapabileceklerini fark ederim.',
            scores: {'motivation': 2, 'self_awareness': 1},
          ),
          QuizOption(
            text:
                'I pay attention to how the people I\'m watching with are reacting.',
            textTr:
                'Birlikte izlediğim insanların nasıl tepki verdiğine dikkat ederim.',
            scores: {'social_skills': 2, 'empathy': 1},
          ),
        ],
      ),
      // Q8 - Regulation
      QuizQuestion(
        text:
            'After a stressful week, what tends to restore your emotional balance?',
        textTr:
            'Stresli bir haftadan sonra, duygusal dengenizi ne yeniden kurma eğilimindedir?',
        category: 'regulation',
        options: [
          QuizOption(
            text: 'Quiet time alone to decompress and reflect.',
            textTr: 'Rahatlama ve düşünme için sessiz yalnız zaman.',
            scores: {'regulation': 3, 'self_awareness': 1},
          ),
          QuizOption(
            text: 'Connecting with someone who understands and just listens.',
            textTr: 'Anlayan ve sadece dinleyen biriyle bağlantı kurma.',
            scores: {'empathy': 2, 'social_skills': 1},
          ),
          QuizOption(
            text: 'Diving into a hobby or project that absorbs my attention.',
            textTr: 'Dikkatimi çeken bir hobi veya projeye dalma.',
            scores: {'motivation': 2, 'regulation': 1},
          ),
          QuizOption(
            text: 'Social plans — being around people lifts my energy.',
            textTr:
                'Sosyal planlar — insanların yanında olmak enerjimi yükseltir.',
            scores: {'social_skills': 3},
          ),
        ],
      ),
      // Q9 - Motivation
      QuizQuestion(
        text:
            'When you achieve something meaningful, which response feels most like you?',
        textTr:
            'Anlamlı bir şey başardığınızda, hangi tepki size en çok benziyor?',
        category: 'motivation',
        options: [
          QuizOption(
            text:
                'A quiet sense of satisfaction — I set a new goal soon after.',
            textTr:
                'Sessiz bir tatmin duygusu — kısa sürede yeni bir hedef belirlerim.',
            scores: {'motivation': 3},
          ),
          QuizOption(
            text: 'I want to share the moment with people who supported me.',
            textTr: 'Beni destekleyen insanlarla anı paylaşmak isterim.',
            scores: {'social_skills': 2, 'empathy': 1},
          ),
          QuizOption(
            text: 'I take time to sit with the feeling and journal about it.',
            textTr: 'Duyguyla oturmak ve günlüğe yazmak için zaman ayırırım.',
            scores: {'self_awareness': 2, 'regulation': 1},
          ),
          QuizOption(
            text:
                'I feel proud but quickly notice what I could have done better.',
            textTr:
                'Gurur duyarım ama hızla daha iyi ne yapabileceklerimi fark ederim.',
            scores: {'self_awareness': 2, 'motivation': 1},
          ),
        ],
      ),
      // Q10 - Social Skills
      QuizQuestion(
        text:
            'When meeting someone for the first time, what do you tend to notice about yourself?',
        textTr:
            'Biriyle ilk kez tanışırken, kendinizde ne fark etme eğiliminde olursunuz?',
        category: 'social_skills',
        options: [
          QuizOption(
            text:
                'I focus on making them feel comfortable and finding common ground.',
            textTr:
                'Onları rahat hissettirmeye ve ortak noktalar bulmaya odaklanırım.',
            scores: {'social_skills': 3, 'empathy': 1},
          ),
          QuizOption(
            text:
                'I pay attention to their energy and body language for unspoken cues.',
            textTr:
                'Söylenmemiş ipuçları için enerjilerine ve beden dillerine dikkat ederim.',
            scores: {'empathy': 3},
          ),
          QuizOption(
            text:
                'I let the conversation flow naturally without overthinking it.',
            textTr: 'Çok düşünmeden konuşmanın doğal akmasına izin veririm.',
            scores: {'regulation': 2, 'social_skills': 1},
          ),
          QuizOption(
            text: 'I observe more than I speak — I prefer to listen first.',
            textTr:
                'Konuşmaktan çok gözlemlerim — önce dinlemeyi tercih ederim.',
            scores: {'self_awareness': 2, 'regulation': 1},
          ),
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
    titleTr: 'Rüya Kişiliğim',
    description: 'What kind of dreamer are you? Explore your nighttime mind.',
    descriptionTr: 'Nasıl bir rüyacısınız? Gece zihninizi keşfedin.',
    emoji: '\u{1F319}',
    scoringType: QuizScoringType.categorical,
    dimensions: {
      'vivid_visionary': QuizDimensionMeta(
        key: 'vivid_visionary',
        nameEn: 'Vivid Visionary',
        nameTr: 'Canlı Vizyoner',
        emoji: '\u{1F308}',
        color: AppColors.warmAccent,
        descriptionEn:
            'Your dreams may tend to be rich sensory experiences — full of color, detail, and atmosphere. You might notice that your dream world often feels as real as waking life.',
        descriptionTr:
            'Rüyalarınız zengin duyusal deneyimler olma eğiliminde olabilir — renk, detay ve atmosfer dolu. Rüya dünyanızın uyanık hayat kadar gerçek hissettiğini fark edebilirsiniz.',
        strengthsEn: [
          'Rich imaginative inner world',
          'Strong visual memory',
          'Creative problem-solving through imagery',
        ],
        strengthsTr: [
          'Zengin hayal gücü iç dünyası',
          'Güçlü görsel bellek',
          'Görseller yoluyla yaratıcı problem çözme',
        ],
        growthAreasEn: [
          'Grounding vivid dream energy into daytime creativity',
          'Journaling dreams before the details fade',
        ],
        growthAreasTr: [
          'Canlı rüya enerjisini gündüz yaratıcılığına temellendirme',
          'Detaylar solmadan önce rüyaları günlüğe yazma',
        ],
      ),
      'symbolic_seeker': QuizDimensionMeta(
        key: 'symbolic_seeker',
        nameEn: 'Symbolic Seeker',
        nameTr: 'Sembolik Arayan',
        emoji: '\u{1F52E}',
        color: AppColors.amethyst,
        descriptionEn:
            'Your dreams may tend to speak in metaphor and symbol. You might notice recurring images or themes that seem to carry deeper personal meaning over time.',
        descriptionTr:
            'Rüyalarınız mecaz ve sembollerle konuşma eğiliminde olabilir. Zaman içinde daha derin kişisel anlam taşıyan tekrarlayan görüntüleri fark edebilirsiniz.',
        strengthsEn: [
          'Natural pattern recognition',
          'Intuitive meaning-making',
          'Deep capacity for self-reflection',
        ],
        strengthsTr: [
          'Doğal örüntü tanıma',
          'Sezgisel anlam oluşturma',
          'Derin öz yansıtma kapasitesi',
        ],
        growthAreasEn: [
          'Balancing interpretation with simply experiencing',
          'Trusting your first instinct about a symbol\'s meaning',
        ],
        growthAreasTr: [
          'Yorumlamayı basitçe deneyimleme ile dengeleme',
          'Bir sembolün anlamı hakkında ilk içgüdünüze güvenmek',
        ],
      ),
      'lucid_explorer': QuizDimensionMeta(
        key: 'lucid_explorer',
        nameEn: 'Lucid Explorer',
        nameTr: 'Bilinçli Kaşif',
        emoji: '\u{1F680}',
        color: AppColors.blueAccent,
        descriptionEn:
            'You may tend to have awareness within your dreams — sometimes knowing you\'re dreaming or even directing the action. Your dream world may feel like a playground for your conscious mind.',
        descriptionTr:
            'Rüyalarınız içinde farkındalık sahibi olma eğiliminde olabilirsiniz — bazen rüya gördüğünü bilmek veya olayları yönlendirmek. Rüya dünyanız bilinciniz için bir oyun alanı gibi hissedebilir.',
        strengthsEn: [
          'High self-awareness even in sleep',
          'Natural curiosity and adventurousness',
          'Strong metacognitive abilities',
        ],
        strengthsTr: [
          'Uykuda bile yüksek öz farkındalık',
          'Doğal merak ve maceracılık',
          'Güçlü üstbilişsel yetenekler',
        ],
        growthAreasEn: [
          'Letting some dreams unfold without control',
          'Using lucid states for emotional processing, not just adventure',
        ],
        growthAreasTr: [
          'Bazı rüyaların kontrol olmadan açılmasına izin verme',
          'Bilinçli durumları sadece macera için değil duygusal işleme için kullanma',
        ],
      ),
      'emotional_processor': QuizDimensionMeta(
        key: 'emotional_processor',
        nameEn: 'Emotional Processor',
        nameTr: 'Duygusal İşlemci',
        emoji: '\u{1F30A}',
        color: AppColors.greenAccent,
        descriptionEn:
            'Your dreams may tend to be emotional landscapes — processing feelings, relationships, and unresolved experiences. You might notice your dreams often reflect what you\'re going through emotionally.',
        descriptionTr:
            'Rüyalarınız duygusal manzaralar olma eğiliminde olabilir — duyguları, ilişkileri ve çözülmemiş deneyimleri işler. Rüyalarınızın genellikle duygusal olarak yaşadıklarınızı yansıttığını fark edebilirsiniz.',
        strengthsEn: [
          'Deep emotional intelligence during sleep',
          'Natural capacity for processing difficult feelings',
          'Dreams often provide clarity on waking concerns',
        ],
        strengthsTr: [
          'Uyku sırasında derin duygusal zeka',
          'Zor duyguları işleme için doğal kapasite',
          'Rüyalar genellikle uyanık endişeler hakkında netlik sağlar',
        ],
        growthAreasEn: [
          'Creating a calming bedtime routine for intense dream nights',
          'Journaling emotions after waking to capture the processing',
        ],
        growthAreasTr: [
          'Yoğun rüya geceleri için sakinleştirici uyku öncesi rutini oluşturma',
          'İşlemeyi yakalamak için uyandıktan sonra duyguları günlüğe yazma',
        ],
      ),
    },
    questions: [
      QuizQuestion(
        text: 'When you remember a dream, what aspect stands out most?',
        textTr: 'Bir rüyayı hatırladığınızda, en çok hangi yönü öne çıkar?',
        options: [
          QuizOption(
            text:
                'The vivid colors, textures, and sensory details — it felt incredibly real.',
            textTr:
                'Canlı renkler, dokular ve duyusal detaylar — inanılmaz gerçek hissettirdi.',
            scores: {'vivid_visionary': 3},
          ),
          QuizOption(
            text:
                'Recurring symbols or objects that seem to carry a deeper meaning.',
            textTr:
                'Daha derin bir anlam taşıyor gibi görünen tekrarlayan semboller veya nesneler.',
            scores: {'symbolic_seeker': 3},
          ),
          QuizOption(
            text:
                'The feeling that I was aware I was dreaming, or could influence it.',
            textTr:
                'Rüya gördüğümün farkında olduğum veya onu etkileyebildiğim hissi.',
            scores: {'lucid_explorer': 3},
          ),
          QuizOption(
            text:
                'The emotions I felt — the dream was processing something I\'m going through.',
            textTr: 'Hissettiğim duygular — rüya yaşadığım bir şeyi işliyordu.',
            scores: {'emotional_processor': 3},
          ),
        ],
      ),
      QuizQuestion(
        text: 'How often do you tend to remember your dreams?',
        textTr: 'Rüyalarınızı ne sıklıkla hatırlama eğiliminde olursunuz?',
        options: [
          QuizOption(
            text:
                'Almost every morning — they stay with me like a movie I just watched.',
            textTr:
                'Neredeyse her sabah — az önce izlediğim bir film gibi benimle kalırlar.',
            scores: {'vivid_visionary': 3},
          ),
          QuizOption(
            text: 'Certain images or symbols linger even when the story fades.',
            textTr:
                'Hikaye solsa bile belirli görüntüler veya semboller kalır.',
            scores: {'symbolic_seeker': 3},
          ),
          QuizOption(
            text:
                'I remember them best when I "wake up" inside the dream first.',
            textTr:
                'Onları en iyi önce rüyanın içinde "uyandığımda" hatırlıyorum.',
            scores: {'lucid_explorer': 3},
          ),
          QuizOption(
            text:
                'I remember the feeling more than the plot — the emotion lingers.',
            textTr: 'Olaylardan çok duyguyu hatırlıyorum — duygu kalıyor.',
            scores: {'emotional_processor': 3},
          ),
        ],
      ),
      QuizQuestion(
        text: 'If you could choose one dream ability, which appeals most?',
        textTr:
            'Bir rüya yeteneği seçebilseydiniz, hangisi en çok ilginizi çekerdi?',
        options: [
          QuizOption(
            text:
                'Photographic dream recall — remembering every detail perfectly.',
            textTr:
                'Fotografik rüya hatırlaması — her detayı mükemmel hatırlamak.',
            scores: {'vivid_visionary': 3},
          ),
          QuizOption(
            text: 'A dream dictionary tuned to my personal symbol language.',
            textTr: 'Kişisel sembol dilime ayarlanmış bir rüya sözlüğü.',
            scores: {'symbolic_seeker': 3},
          ),
          QuizOption(
            text: 'Full lucid control — flying, exploring, creating worlds.',
            textTr: 'Tam bilinçli kontrol — uçma, keşif, dünya yaratma.',
            scores: {'lucid_explorer': 3},
          ),
          QuizOption(
            text:
                'The ability to consciously resolve emotional knots in my sleep.',
            textTr:
                'Uykumda duygusal düğümleri bilinçli olarak çözme yeteneği.',
            scores: {'emotional_processor': 3},
          ),
        ],
      ),
      QuizQuestion(
        text: 'After a particularly intense dream, what do you tend to do?',
        textTr:
            'Özellikle yoğun bir rüyadan sonra, ne yapma eğiliminde olursunuz?',
        options: [
          QuizOption(
            text:
                'I try to sketch or describe the visual scene before it fades.',
            textTr:
                'Solmadan önce görsel sahneyi çizmeye veya tarif etmeye çalışırım.',
            scores: {'vivid_visionary': 3},
          ),
          QuizOption(
            text:
                'I look up the symbols or think about what they might represent.',
            textTr:
                'Sembolleri ararır veya neyi temsil edebileceklerini düşünürüm.',
            scores: {'symbolic_seeker': 3},
          ),
          QuizOption(
            text:
                'I try to go back to sleep and re-enter the dream consciously.',
            textTr:
                'Tekrar uyumaya ve rüyaya bilinçli olarak geri girmeye çalışırım.',
            scores: {'lucid_explorer': 3},
          ),
          QuizOption(
            text:
                'I sit with the feelings for a while — they often tell me something important.',
            textTr:
                'Bir süre duygularla otururum — genellikle bana önemli bir şey söylerler.',
            scores: {'emotional_processor': 3},
          ),
        ],
      ),
      QuizQuestion(
        text: 'What kind of dreams do you tend to have most often?',
        textTr: 'En sık hangi tür rüyaları görme eğiliminde olursunuz?',
        options: [
          QuizOption(
            text:
                'Elaborate, cinematic dreams with detailed landscapes and stories.',
            textTr: 'Detaylı manzaralar ve hikayelerle dolu sinematik rüyalar.',
            scores: {'vivid_visionary': 3},
          ),
          QuizOption(
            text:
                'Dreams with recurring themes, places, or objects that keep appearing.',
            textTr: 'Tekrarlayan temalar, yerler veya nesneler içeren rüyalar.',
            scores: {'symbolic_seeker': 3},
          ),
          QuizOption(
            text: 'Dreams where I realize I\'m dreaming and can make choices.',
            textTr: 'Rüya gördüğümü fark edip seçim yapabildiğim rüyalar.',
            scores: {'lucid_explorer': 3},
          ),
          QuizOption(
            text:
                'Dreams centred around relationships, conversations, or emotional situations.',
            textTr:
                'İlişkiler, konuşmalar veya duygusal durumlar etrafında yoğunlaşan rüyalar.',
            scores: {'emotional_processor': 3},
          ),
        ],
      ),
      QuizQuestion(
        text:
            'When you try to describe a dream to someone, what is easiest to convey?',
        textTr:
            'Bir rüyayı birine anlatmaya çalıştığınızda, en kolay ne aktarılır?',
        options: [
          QuizOption(
            text: 'The visual details — "It looked like..." comes naturally.',
            textTr: '"Şöyle göründüğü..." ifadesi doğal olarak gelir.',
            scores: {'vivid_visionary': 3},
          ),
          QuizOption(
            text:
                'The meaning behind it — "I think it was about..." is my instinct.',
            textTr: '"Bence şu konudaydı..." deme içgüdüm vardır.',
            scores: {'symbolic_seeker': 3},
          ),
          QuizOption(
            text: 'The actions I took — "I decided to..." because I was aware.',
            textTr: '"...yapmaya karar verdim" çünkü farkındaydım.',
            scores: {'lucid_explorer': 3},
          ),
          QuizOption(
            text:
                'The way it made me feel — the emotion translates easily into words.',
            textTr:
                'Bana nasıl hissettirdiği — duygu kolayca kelimelere dönüşür.',
            scores: {'emotional_processor': 3},
          ),
        ],
      ),
      QuizQuestion(
        text: 'What is your relationship with nightmares or unsettling dreams?',
        textTr: 'Kabuslar veya rahatsız edici rüyalarla ilişkiniz nasıl?',
        options: [
          QuizOption(
            text:
                'They\'re rare but incredibly vivid when they happen — hard to shake.',
            textTr: 'Nadir ama olduklarında inanılmaz canlı — atlatması zor.',
            scores: {'vivid_visionary': 3},
          ),
          QuizOption(
            text:
                'I try to decode them — even scary dreams may carry useful messages.',
            textTr:
                'Onları çözmeye çalışırım — korkutucu rüyalar bile yararlı mesajlar taşıyabilir.',
            scores: {'symbolic_seeker': 3},
          ),
          QuizOption(
            text:
                'I sometimes realize mid-nightmare that it\'s a dream and can shift it.',
            textTr:
                'Bazen kabusun ortasında bunun bir rüya olduğunu fark edip değiştirebiliyorum.',
            scores: {'lucid_explorer': 3},
          ),
          QuizOption(
            text:
                'They usually reflect stress or unprocessed emotions from my day.',
            textTr:
                'Genellikle günümdeki stresi veya işlenmemiş duyguları yansıtır.',
            scores: {'emotional_processor': 3},
          ),
        ],
      ),
      QuizQuestion(
        text: 'If your dreams had a "genre," which would fit best?',
        textTr: 'Rüyalarınızın bir "türü" olsaydı, hangisi en iyi uyar?',
        options: [
          QuizOption(
            text: 'Fantasy or sci-fi — worlds that feel real but impossible.',
            textTr:
                'Fantastik veya bilim kurgu — gerçek hisseden ama imkansız dünyalar.',
            scores: {'vivid_visionary': 3},
          ),
          QuizOption(
            text:
                'Mystery — full of clues, patterns, and things to figure out.',
            textTr: 'Gizem — ipuçları, örüntüler ve çözülecek şeylerle dolu.',
            scores: {'symbolic_seeker': 3},
          ),
          QuizOption(
            text:
                'Adventure — where I\'m the main character making active choices.',
            textTr: 'Macera — aktif seçimler yapan ana karakter olduğum.',
            scores: {'lucid_explorer': 3},
          ),
          QuizOption(
            text: 'Drama — the emotional arcs are the real story.',
            textTr: 'Drama — duygusal yolculuklar asıl hikaye.',
            scores: {'emotional_processor': 3},
          ),
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
    descriptionTr: 'Nasıl şarj olduğunuzu ve neyin tükettiğini keşfedin.',
    emoji: '\u{1F50B}',
    scoringType: QuizScoringType.categorical,
    dimensions: {
      'introvert': QuizDimensionMeta(
        key: 'introvert',
        nameEn: 'Reflective Introvert',
        nameTr: 'Düşünsel İntrovert',
        emoji: '\u{1F4D6}',
        color: AppColors.blueAccent,
        descriptionEn:
            'You may tend to recharge through solitude and inner reflection. Your energy often flows best in calm, quiet environments where you can think deeply without interruption.',
        descriptionTr:
            'Yalnızlık ve iç düşünce yoluyla şarj olma eğiliminde olabilirsiniz. Enerjiniz genellikle sakin, sessiz ortamlarda en iyi akar.',
        strengthsEn: [
          'Deep thinking and careful observation',
          'Rich inner life and creativity',
          'Quality over quantity in relationships',
        ],
        strengthsTr: [
          'Derin düşünme ve dikkatli gözlem',
          'Zengin iç dünya ve yaratıcılık',
          'İlişkilerde nicelikten çok nitelik',
        ],
        growthAreasEn: [
          'Reaching out before your battery hits zero',
          'Sharing your inner world with trusted people',
        ],
        growthAreasTr: [
          'Bataryanız sıfıra düşmeden ulaşma',
          'İç dünyanızı güvenilir insanlarla paylaşma',
        ],
      ),
      'extrovert': QuizDimensionMeta(
        key: 'extrovert',
        nameEn: 'Social Energizer',
        nameTr: 'Sosyal Enerjizer',
        emoji: '\u{26A1}',
        color: AppColors.warmAccent,
        descriptionEn:
            'You may tend to gain energy from being around others. Social interaction often feels naturally stimulating, and you might notice that too much alone time can leave you feeling flat.',
        descriptionTr:
            'Başkalarının yanında olmaktan enerji kazanma eğiliminde olabilirsiniz. Sosyal etkileşim genellikle doğal olarak canlandırıcı hissettirir.',
        strengthsEn: [
          'Natural connector who brings people together',
          'Energized by collaboration and brainstorming',
          'Comfortable in new social situations',
        ],
        strengthsTr: [
          'İnsanları bir araya getiren doğal bağlayıcı',
          'İş birliği ve beyin fırtınası ile enerjilenen',
          'Yeni sosyal durumlarda rahat',
        ],
        growthAreasEn: [
          'Building comfort with solitude and stillness',
          'Listening deeply rather than filling silences',
        ],
        growthAreasTr: [
          'Yalnızlık ve durgunlukla rahatlık oluşturma',
          'Sessizlikleri doldurmak yerine derinden dinleme',
        ],
      ),
      'ambivert': QuizDimensionMeta(
        key: 'ambivert',
        nameEn: 'Adaptive Ambivert',
        nameTr: 'Uyumlu Ambivert',
        emoji: '\u{1F300}',
        color: AppColors.greenAccent,
        descriptionEn:
            'You may tend to adapt your social energy to the situation. You might notice that you can enjoy both lively gatherings and quiet evenings, and your ideal balance shifts with your mood and needs.',
        descriptionTr:
            'Sosyal enerjinizi duruma uyarlama eğiliminde olabilirsiniz. Hem canlı toplantıların hem de sessiz akşamların tadını çıkarabildiğinizi fark edebilirsiniz.',
        strengthsEn: [
          'Flexible in diverse social settings',
          'Reads the room and adapts naturally',
          'Balanced approach to alone time and togetherness',
        ],
        strengthsTr: [
          'Farklı sosyal ortamlarda esnek',
          'Ortamı okur ve doğal olarak uyum sağlar',
          'Yalnız zaman ve birliktelik arasında dengeli yaklaşım',
        ],
        growthAreasEn: [
          'Noticing which mode you actually need vs. defaulting to what others expect',
          'Honouring your energy needs even when the group wants something different',
        ],
        growthAreasTr: [
          'Aslında hangi moda ihtiyacınız olduğunu başkalarının beklentisinden ayırma',
          'Grup farklı bir şey istediğinde bile enerji ihtiyaçlarınızı onurlandırma',
        ],
      ),
      'selective_social': QuizDimensionMeta(
        key: 'selective_social',
        nameEn: 'Selective Connector',
        nameTr: 'Seçici Bağlayıcı',
        emoji: '\u{1F48E}',
        color: AppColors.amethyst,
        descriptionEn:
            'You may tend to be very intentional about where you invest your social energy. You might notice that you thrive in meaningful one-on-one connections but find large groups or surface-level socializing draining.',
        descriptionTr:
            'Sosyal enerjinizi nereye yatırdığınız konusunda çok niyetli olma eğiliminde olabilirsiniz. Anlamlı bire bir bağlantılardan beslenirken büyük grupların tüketici olduğunu fark edebilirsiniz.',
        strengthsEn: [
          'Deep, loyal friendships',
          'High emotional presence in conversations',
          'Intentional about energy investment',
        ],
        strengthsTr: [
          'Derin, sadık arkadaşlıklar',
          'Konuşmalarda yüksek duygusal varlık',
          'Enerji yatırımı konusunda niyetli',
        ],
        growthAreasEn: [
          'Staying open to unexpected connections',
          'Being gentle with yourself when social situations feel tiring',
        ],
        growthAreasTr: [
          'Beklenmedik bağlantılara açık kalma',
          'Sosyal durumlar yorucu hissettiğinde kendinize karşı nazik olma',
        ],
      ),
    },
    questions: [
      QuizQuestion(
        text: 'After a long social event, what tends to happen to your energy?',
        textTr:
            'Uzun bir sosyal etkinlikten sonra, enerjinize ne olma eğilimindedir?',
        options: [
          QuizOption(
            text: 'I feel drained and need quiet time alone to recover.',
            textTr:
                'Tükendiğimi hissederim ve toparlanmak için sessiz yalnız zamana ihtiyaç duyarım.',
            scores: {'introvert': 3},
          ),
          QuizOption(
            text:
                'I feel energized and could keep going — I don\'t want the night to end.',
            textTr:
                'Enerjik hissederim ve devam edebilirim — gecenin bitmesini istemem.',
            scores: {'extrovert': 3},
          ),
          QuizOption(
            text:
                'It depends on the people — some groups energize me, others drain me.',
            textTr:
                'İnsanlara bağlı — bazı gruplar beni enerjik kılar, diğerleri tüketir.',
            scores: {'ambivert': 3},
          ),
          QuizOption(
            text:
                'I\'m fine if I had meaningful conversations, but small talk exhausts me.',
            textTr:
                'Anlamlı konuşmalar yaptıysam iyiyim, ama havadan sudan konuşmak tüketiyor.',
            scores: {'selective_social': 3},
          ),
        ],
      ),
      QuizQuestion(
        text: 'Your ideal weekend looks like:',
        textTr: 'İdeal hafta sonunuz şöyle görünür:',
        options: [
          QuizOption(
            text: 'A quiet day with a book, a walk, and no obligations.',
            textTr: 'Kitap, yürüyüş ve zorunluluk olmayan sessiz bir gün.',
            scores: {'introvert': 3},
          ),
          QuizOption(
            text: 'Plans with friends — brunch, an outing, maybe a party.',
            textTr: 'Arkadaşlarla planlar — brunch, gezi, belki parti.',
            scores: {'extrovert': 3},
          ),
          QuizOption(
            text: 'A mix — social time one day, recharging the next.',
            textTr: 'Karışım — bir gün sosyal zaman, ertesi gün şarj.',
            scores: {'ambivert': 3},
          ),
          QuizOption(
            text:
                'One-on-one time with my closest friend or partner, and space for myself.',
            textTr:
                'En yakın arkadaşım veya partnerimle bire bir zaman ve kendim için alan.',
            scores: {'selective_social': 3},
          ),
        ],
      ),
      QuizQuestion(
        text: 'When your phone rings unexpectedly, your first instinct is:',
        textTr:
            'Telefonunuz beklenmedik bir şekilde çaldığında, ilk içgüdünüz:',
        options: [
          QuizOption(
            text:
                'A slight internal groan — I prefer texts where I can respond on my own time.',
            textTr:
                'Hafif bir iç inleme — kendi zamanımda yanıt verebildiğim mesajları tercih ederim.',
            scores: {'introvert': 3},
          ),
          QuizOption(
            text: 'Excitement — I love a spontaneous catch-up call.',
            textTr: 'Heyecan — spontan bir sohbet aramasını seviyorum.',
            scores: {'extrovert': 3},
          ),
          QuizOption(
            text: 'It depends on my mood and who\'s calling.',
            textTr: 'Ruh halime ve kimin aradığına bağlı.',
            scores: {'ambivert': 3},
          ),
          QuizOption(
            text:
                'I only want to answer if it\'s someone I\'m really close to.',
            textTr:
                'Sadece gerçekten yakın olduğum biriyse cevaplamak istiyorum.',
            scores: {'selective_social': 3},
          ),
        ],
      ),
      QuizQuestion(
        text: 'In a group conversation, you tend to:',
        textTr: 'Bir grup sohbetinde, eğilim olarak:',
        options: [
          QuizOption(
            text:
                'Listen more than I speak, contributing when I have something specific to say.',
            textTr:
                'Konuşmaktan çok dinlerim, söyleyecek belirli bir şeyim olduğunda katkı sağlarım.',
            scores: {'introvert': 3},
          ),
          QuizOption(
            text: 'Jump in naturally — I enjoy the flow of conversation.',
            textTr: 'Doğal olarak katılırım — konuşma akışından keyif alırım.',
            scores: {'extrovert': 3},
          ),
          QuizOption(
            text: 'Shift between active and quiet depending on the topic.',
            textTr: 'Konuya bağlı olarak aktif ve sessiz arasında geçerim.',
            scores: {'ambivert': 3},
          ),
          QuizOption(
            text: 'I prefer when the conversation goes deep rather than wide.',
            textTr: 'Konuşmanın genişe değil derine gitmesini tercih ederim.',
            scores: {'selective_social': 3},
          ),
        ],
      ),
      QuizQuestion(
        text: 'When you need to process a difficult experience, you tend to:',
        textTr: 'Zor bir deneyimi işlemeniz gerektiğinde, eğilim olarak:',
        options: [
          QuizOption(
            text:
                'Retreat and reflect alone — I need space to think it through.',
            textTr:
                'Çekilir ve yalnız düşünürüm — düşünmek için alana ihtiyacım var.',
            scores: {'introvert': 3},
          ),
          QuizOption(
            text:
                'Talk it out with multiple friends to get different perspectives.',
            textTr:
                'Farklı bakış açıları almak için birden fazla arkadaşla konuşurum.',
            scores: {'extrovert': 3},
          ),
          QuizOption(
            text:
                'Start alone, then talk to someone when I\'ve sorted my initial thoughts.',
            textTr:
                'Yalnız başlarım, sonra ilk düşüncelerimi düzenlediğimde biriyle konuşurum.',
            scores: {'ambivert': 3},
          ),
          QuizOption(
            text: 'Confide in one trusted person who really understands me.',
            textTr: 'Beni gerçekten anlayan güvenilir bir kişiye açarım.',
            scores: {'selective_social': 3},
          ),
        ],
      ),
      QuizQuestion(
        text: 'How do you feel about working from a busy cafe?',
        textTr: 'Kalabalık bir kafeden çalışmak hakkında ne hissedersiniz?',
        options: [
          QuizOption(
            text:
                'I\'d rather work somewhere quiet — noise and people are distracting.',
            textTr:
                'Sessiz bir yerde çalışmayı tercih ederim — gürültü ve insanlar dikkat dağıtıyor.',
            scores: {'introvert': 3},
          ),
          QuizOption(
            text:
                'I love it — the background buzz of people keeps me energized.',
            textTr:
                'Severim — insanların arka plan uğultusu beni enerjik tutar.',
            scores: {'extrovert': 3},
          ),
          QuizOption(
            text:
                'Sometimes yes, sometimes no — depends on the task and my mood.',
            textTr: 'Bazen evet, bazen hayır — göreve ve ruh halime bağlı.',
            scores: {'ambivert': 3},
          ),
          QuizOption(
            text:
                'Only if I\'m there with a friend — anonymous crowds don\'t appeal to me.',
            textTr:
                'Sadece bir arkadaşımla ordaysam — anonim kalabalıklar bana ilgi çekici gelmiyor.',
            scores: {'selective_social': 3},
          ),
        ],
      ),
      QuizQuestion(
        text: 'When meeting new people at a gathering, you tend to:',
        textTr: 'Bir toplantıda yeni insanlarla tanışırken, eğilim olarak:',
        options: [
          QuizOption(
            text: 'Warm up slowly — I observe first and open up gradually.',
            textTr: 'Yavaş yavaş ısınırım — önce gözlemler yavaşça açılırım.',
            scores: {'introvert': 3},
          ),
          QuizOption(
            text:
                'Introduce myself confidently — I enjoy making new connections.',
            textTr:
                'Kendimi güvenle tanıtırım — yeni bağlantılar kurmaktan keyif alırım.',
            scores: {'extrovert': 3},
          ),
          QuizOption(
            text: 'I can do both — I read the room and match the energy.',
            textTr:
                'İkisini de yapabilirim — ortamı okur ve enerjiyle eşleşirim.',
            scores: {'ambivert': 3},
          ),
          QuizOption(
            text:
                'I gravitate toward one or two people for deeper conversation.',
            textTr: 'Daha derin sohbet için bir veya iki kişiye yönelirim.',
            scores: {'selective_social': 3},
          ),
        ],
      ),
      QuizQuestion(
        text:
            'Which statement feels most true about your social life right now?',
        textTr:
            'Mevcut sosyal hayatınız hakkında hangi ifade en doğru hissettiriyor?',
        options: [
          QuizOption(
            text:
                'I could use more alone time — my social calendar has been too full.',
            textTr:
                'Daha fazla yalnız zamana ihtiyacım var — sosyal takvimim çok dolu.',
            scores: {'introvert': 3},
          ),
          QuizOption(
            text:
                'I want more plans — I feel best when my week is full of people.',
            textTr:
                'Daha fazla plan istiyorum — haftam insanlarla dolu olduğunda en iyi hissediyorum.',
            scores: {'extrovert': 3},
          ),
          QuizOption(
            text:
                'I\'m in a good balance right now between social time and solo time.',
            textTr:
                'Şu anda sosyal zaman ve yalnız zaman arasında iyi bir dengedeyim.',
            scores: {'ambivert': 3},
          ),
          QuizOption(
            text:
                'I want fewer but deeper connections — quality matters more than quantity.',
            textTr:
                'Daha az ama daha derin bağlantılar istiyorum — nitelik nicelikten önemli.',
            scores: {'selective_social': 3},
          ),
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
    descriptionTr: 'Baskı altındaki varsayılan örüntülerinizi anlayın.',
    emoji: '\u{1F32A}',
    scoringType: QuizScoringType.categorical,
    dimensions: {
      'fight': QuizDimensionMeta(
        key: 'fight',
        nameEn: 'The Protector (Fight)',
        nameTr: 'Koruyucu (Savaş)',
        emoji: '\u{1F525}',
        color: AppColors.warmAccent,
        descriptionEn:
            'Under stress, you may tend to move toward the challenge — confronting it head-on with energy and determination. This response pattern often makes you a natural advocate and problem-solver.',
        descriptionTr:
            'Stres altında, meydan okumaya doğru hareket etme eğiliminde olabilirsiniz — enerji ve kararlılıkla doğrudan yüzleşerek. Bu tepki örüntüsü sizi genellikle doğal bir savunucu ve problem çözücü yapar.',
        strengthsEn: [
          'Takes decisive action under pressure',
          'Advocates strongly for self and others',
          'Doesn\'t shy away from difficult conversations',
        ],
        strengthsTr: [
          'Baskı altında kararlı hareket eder',
          'Kendisi ve başkaları için güçlü savunuculuk yapar',
          'Zor konuşmalardan kaçınmaz',
        ],
        growthAreasEn: [
          'Pausing before reacting to assess the full picture',
          'Softening intensity when the situation calls for gentleness',
        ],
        growthAreasTr: [
          'Tam resmi değerlendirmek için tepki vermeden önce durma',
          'Durum yumuşaklık gerektirdiğinde yoğunluğu yumuşatma',
        ],
      ),
      'flight': QuizDimensionMeta(
        key: 'flight',
        nameEn: 'The Strategist (Flight)',
        nameTr: 'Stratejist (Kaçış)',
        emoji: '\u{1F3C3}',
        color: AppColors.blueAccent,
        descriptionEn:
            'Under stress, you may tend to seek distance — physically, mentally, or emotionally — to gain perspective. This response pattern often reflects a strong self-preservation instinct and strategic thinking.',
        descriptionTr:
            'Stres altında, perspektif kazanmak için fiziksel, zihinsel veya duygusal olarak mesafe arama eğiliminde olabilirsiniz. Bu tepki örüntüsü genellikle güçlü bir kendini koruma içgüdüsünü ve stratejik düşünmeyi yansıtır.',
        strengthsEn: [
          'Quick to assess risk and find alternatives',
          'Protects emotional wellbeing instinctively',
          'Often finds creative escape routes from problems',
        ],
        strengthsTr: [
          'Riski değerlendirmede ve alternatif bulmada hızlı',
          'Duygusal iyiliği içgüdüsel olarak korur',
          'Sorunlardan yaratıcı çıkış yolları bulur',
        ],
        growthAreasEn: [
          'Distinguishing healthy retreat from avoidance',
          'Building tolerance for staying present in discomfort',
        ],
        growthAreasTr: [
          'Sağlıklı geri çekilmeyi kaçınmadan ayırt etme',
          'Rahatsızlıkta mevcut kalmak için tolerans oluşturma',
        ],
      ),
      'freeze': QuizDimensionMeta(
        key: 'freeze',
        nameEn: 'The Observer (Freeze)',
        nameTr: 'Gözlemci (Don)',
        emoji: '\u{2744}',
        color: Color(0xFF95A5A6),
        descriptionEn:
            'Under stress, you may tend to go still — mentally or physically pausing as your system takes in information. This response pattern often reflects deep processing and careful analysis before action.',
        descriptionTr:
            'Stres altında, hareketsiz kalma eğiliminde olabilirsiniz — sisteminiz bilgi alırken zihinsel veya fiziksel olarak duraklar. Bu tepki örüntüsü genellikle eylemden önce derin işleme ve dikkatli analizi yansıtır.',
        strengthsEn: [
          'Careful and thorough decision-making',
          'Observes details others miss',
          'Rarely makes impulsive mistakes',
        ],
        strengthsTr: [
          'Dikkatli ve kapsamlı karar verme',
          'Başkalarının kaçırdığı detayları gözlemler',
          'Nadiren dürtüsel hatalar yapar',
        ],
        growthAreasEn: [
          'Recognizing when stillness becomes being stuck',
          'Building small, gentle action steps to break the pause',
        ],
        growthAreasTr: [
          'Hareketsizliğin takılı kalmaya dönüştüğünü fark etme',
          'Duraklamayı kırmak için küçük, nazik eylem adımları oluşturma',
        ],
      ),
      'fawn': QuizDimensionMeta(
        key: 'fawn',
        nameEn: 'The Harmonizer (Fawn)',
        nameTr: 'Uyumcu (Boyun Eğme)',
        emoji: '\u{1F54A}',
        color: AppColors.greenAccent,
        descriptionEn:
            'Under stress, you may tend to focus on others\' needs and keeping the peace. This response pattern often reflects strong empathy and a desire to maintain connection even in difficult moments.',
        descriptionTr:
            'Stres altında, başkalarının ihtiyaçlarına ve barışı korumaya odaklanma eğiliminde olabilirsiniz. Bu tepki örüntüsü genellikle güçlü empatiyi ve zor anlarda bile bağlantıyı sürdürme arzusunu yansıtır.',
        strengthsEn: [
          'Highly attuned to others\' emotional states',
          'Natural peacemaker and mediator',
          'Creates safety and comfort for those around you',
        ],
        strengthsTr: [
          'Başkalarının duygusal durumlarına yüksek uyum',
          'Doğal barış yapıcı ve arabulucu',
          'Çevresindekilere için güvenlik ve konfor yaratır',
        ],
        growthAreasEn: [
          'Checking whether peacemaking is serving you or just avoiding conflict',
          'Practicing saying what you actually need, even when it\'s uncomfortable',
        ],
        growthAreasTr: [
          'Barış yapmanın size mi hizmet ettiğini yoksa sadece çatışmadan mı kaçtığını kontrol etme',
          'Rahatsız olsa bile gerçekten ne istediğinizi söyleme pratiği',
        ],
      ),
    },
    questions: [
      QuizQuestion(
        text:
            'You receive unexpectedly harsh feedback at work. Your first internal response tends to be:',
        textTr:
            'İşte beklenmedik sert bir geri bildirim alıyorsunuz. İlk iç tepkiniz eğilim olarak:',
        options: [
          QuizOption(
            text:
                'Frustration — I want to defend my work and push back immediately.',
            textTr:
                'Hayal kırıklığı — işimi savunmak ve hemen karşılık vermek istiyorum.',
            scores: {'fight': 3},
          ),
          QuizOption(
            text: 'A need to leave the room or take a walk to clear my head.',
            textTr:
                'Odayı terk etme veya kafamı toplamak için yürüyüş yapma ihtiyacı.',
            scores: {'flight': 3},
          ),
          QuizOption(
            text:
                'My mind goes blank — I nod along but can\'t form a response in the moment.',
            textTr:
                'Aklım boşlukla — başımla onaylarım ama o an yanıt oluşturamam.',
            scores: {'freeze': 3},
          ),
          QuizOption(
            text:
                'I find myself agreeing and apologizing, even if I\'m not sure I should.',
            textTr:
                'Yapıp yapmamam gerektiğinden emin olmasam bile katılır ve özür dilerim.',
            scores: {'fawn': 3},
          ),
        ],
      ),
      QuizQuestion(
        text:
            'During an argument with someone you care about, you notice yourself:',
        textTr:
            'Önem verdiğiniz biriyle tartışma sırasında, kendinizi şu şekilde fark edersiniz:',
        options: [
          QuizOption(
            text: 'Getting louder or more intense — I need to be heard.',
            textTr: 'Daha yüksek sesle veya daha yoğun — duyulmam gerekiyor.',
            scores: {'fight': 3},
          ),
          QuizOption(
            text:
                'Wanting to leave the conversation and come back when I\'m calmer.',
            textTr: 'Konuşmayı bırakıp sakinleştiğimde geri dönmek istiyorum.',
            scores: {'flight': 3},
          ),
          QuizOption(
            text: 'Going quiet, feeling unable to find the right words.',
            textTr: 'Sessizleşiyorum, doğru kelimeleri bulamıyorum.',
            scores: {'freeze': 3},
          ),
          QuizOption(
            text:
                'Shifting focus to their feelings and what they need from me.',
            textTr:
                'Odağı onların duygularına ve benden ne istediklerine kaydırıyorum.',
            scores: {'fawn': 3},
          ),
        ],
      ),
      QuizQuestion(
        text:
            'When you\'re overwhelmed with too many responsibilities, you tend to:',
        textTr: 'Çok fazla sorumlulukla bunaldığınızda, eğilim olarak:',
        options: [
          QuizOption(
            text: 'Push harder — I\'ll power through even if it\'s exhausting.',
            textTr:
                'Daha sert iterim — tüketici olsa bile güçle devam edeceğim.',
            scores: {'fight': 3},
          ),
          QuizOption(
            text: 'Withdraw or distract myself — I need an escape valve.',
            textTr:
                'Geri çekilirim veya dikkatimi dağıtırım — bir çıkış vanasına ihtiyacım var.',
            scores: {'flight': 3},
          ),
          QuizOption(
            text:
                'Shut down — everything feels impossible and I can\'t decide where to start.',
            textTr:
                'Kapanırım — her şey imkansız hissediyor ve nereden başlayacağıma karar veremiyorum.',
            scores: {'freeze': 3},
          ),
          QuizOption(
            text:
                'Say yes to everyone else\'s requests before attending to my own needs.',
            textTr:
                'Kendi ihtiyaçlarımı gidermeden önce herkesin isteklerine evet derim.',
            scores: {'fawn': 3},
          ),
        ],
      ),
      QuizQuestion(
        text:
            'A friend cancels plans last minute for a vague reason. You tend to:',
        textTr:
            'Bir arkadaş belirsiz bir nedenle son dakika planları iptal ediyor. Eğilim olarak:',
        options: [
          QuizOption(
            text: 'Feel annoyed and want to address it directly.',
            textTr: 'Rahatsız hissederim ve doğrudan ele almak isterim.',
            scores: {'fight': 3},
          ),
          QuizOption(
            text:
                'Shrug it off and make alternative plans — it\'s not worth the energy.',
            textTr:
                'Omuz silker ve alternatif planlar yaparım — enerjiye değmez.',
            scores: {'flight': 3},
          ),
          QuizOption(
            text:
                'Feel stuck wondering what I did wrong, replaying our last interactions.',
            textTr:
                'Ne yanlış yaptığımı merak ederek takılıyorum, son etkileşimlerimi tekrarlıyorum.',
            scores: {'freeze': 3},
          ),
          QuizOption(
            text:
                'Immediately reassure them that it\'s totally fine, even if I\'m disappointed.',
            textTr:
                'Hayal kırıklığına uğramış olsam bile hemen tamamen iyi olduğuna dair güvence veririm.',
            scores: {'fawn': 3},
          ),
        ],
      ),
      QuizQuestion(
        text: 'When you sense tension in a room, your instinct is to:',
        textTr: 'Bir odada gerilim hissettiğinizde, içgüdünüz:',
        options: [
          QuizOption(
            text: 'Name it — "Something feels off, let\'s talk about it."',
            textTr: 'Adını koyma — "Bir şeyler ters hissettiriyor, konuşalım."',
            scores: {'fight': 3},
          ),
          QuizOption(
            text: 'Quietly excuse myself or shift my attention elsewhere.',
            textTr: 'Sessizce ayrılırım veya dikkatimi başka yere kaydırırım.',
            scores: {'flight': 3},
          ),
          QuizOption(
            text:
                'Become hyper-aware of every detail but unsure how to respond.',
            textTr:
                'Her detayın aşırı farkında olurum ama nasıl yanıt vereceğimden emin değilim.',
            scores: {'freeze': 3},
          ),
          QuizOption(
            text:
                'Try to ease the mood — cracking a joke or changing the subject.',
            textTr:
                'Havayı yumuşatmaya çalışırım — şaka yaparım veya konuyu değiştiririm.',
            scores: {'fawn': 3},
          ),
        ],
      ),
      QuizQuestion(
        text:
            'If someone crosses a personal boundary, your typical response pattern is:',
        textTr: 'Biri kişisel bir sınırı aşarsa, tipik tepki örüntünüz:',
        options: [
          QuizOption(
            text: 'I call it out clearly — I won\'t let that slide.',
            textTr: 'Açıkça belirtirim — bunu geçiştirmem.',
            scores: {'fight': 3},
          ),
          QuizOption(
            text:
                'I create distance and limit future interactions with that person.',
            textTr:
                'Mesafe yaratırım ve o kişiyle gelecekteki etkileşimleri sınırlarım.',
            scores: {'flight': 3},
          ),
          QuizOption(
            text:
                'I feel uncomfortable but struggle to articulate what happened.',
            textTr:
                'Rahatsız hissederim ama ne olduğunu ifade etmekte zorlanırım.',
            scores: {'freeze': 3},
          ),
          QuizOption(
            text: 'I downplay it to keep the peace — maybe I\'m overreacting.',
            textTr:
                'Barışı korumak için küçültürüm — belki aşırı tepki veriyorum.',
            scores: {'fawn': 3},
          ),
        ],
      ),
      QuizQuestion(
        text:
            'When you can\'t sleep because something is worrying you, your mind tends to:',
        textTr:
            'Bir şey sizi endişelendirdiği için uyuyamadığınızda, zihniniz eğilim olarak:',
        options: [
          QuizOption(
            text: 'Plan how I\'ll tackle the problem first thing tomorrow.',
            textTr: 'Yarın ilk iş sorunu nasıl ele alacağımı planlarım.',
            scores: {'fight': 3},
          ),
          QuizOption(
            text:
                'Fantasize about a different life or scenario where this problem doesn\'t exist.',
            textTr:
                'Bu sorunun olmadığı farklı bir hayat veya senaryo hayal ederim.',
            scores: {'flight': 3},
          ),
          QuizOption(
            text:
                'Loop on the worry without reaching any conclusion — just circling.',
            textTr:
                'Herhangi bir sonuca ulaşmadan endişe üzerinde döngüye girerim — sadece dönüyorum.',
            scores: {'freeze': 3},
          ),
          QuizOption(
            text:
                'Worry about how the situation is affecting the other people involved.',
            textTr:
                'Durumun dahil olan diğer insanları nasıl etkilediğini merak ederim.',
            scores: {'fawn': 3},
          ),
        ],
      ),
      QuizQuestion(
        text:
            'Which recovery pattern do you tend to fall into during stressful periods?',
        textTr:
            'Stresli dönemlerde hangi toparlanma örüntüsüne düşme eğiliminde olursunuz?',
        options: [
          QuizOption(
            text:
                'Intense exercise or physical outlets to burn off the tension.',
            textTr:
                'Gerilimi atmak için yoğun egzersiz veya fiziksel çıkışlar.',
            scores: {'fight': 3},
          ),
          QuizOption(
            text:
                'Escapism — binge-watching, scrolling, or anything to disconnect.',
            textTr:
                'Kaçış — dizi maratonu, kaydırma veya bağlantıyı koparan herhangi bir şey.',
            scores: {'flight': 3},
          ),
          QuizOption(
            text:
                'Struggling to take any recovery action at all — feeling paralyzed.',
            textTr:
                'Herhangi bir toparlanma eylemi yapmakta zorlanma — felç hissetme.',
            scores: {'freeze': 3},
          ),
          QuizOption(
            text:
                'Taking care of everyone else and forgetting about my own needs.',
            textTr: 'Herkese bakmak ve kendi ihtiyaçlarımı unutmak.',
            scores: {'fawn': 3},
          ),
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
    descriptionTr: 'Seçimleri nasıl yönetiyorsunuz? Karar pusulanuzu keşfedin.',
    emoji: '\u{1F9ED}',
    scoringType: QuizScoringType.categorical,
    dimensions: {
      'analytical': QuizDimensionMeta(
        key: 'analytical',
        nameEn: 'The Analyst',
        nameTr: 'Analist',
        emoji: '\u{1F4CA}',
        color: AppColors.blueAccent,
        descriptionEn:
            'You may tend to approach decisions methodically — weighing pros and cons, gathering data, and thinking things through carefully before committing. Your strength lies in thorough, evidence-based choices.',
        descriptionTr:
            'Kararlara yöntemli yaklaşma eğiliminde olabilirsiniz — artıları ve eksileri tartar, veri toplar ve taahhüt etmeden önce dikkatlice düşünürsünüz.',
        strengthsEn: [
          'Makes well-researched, thoughtful choices',
          'Spots flaws and risks others may miss',
          'Confident in decisions backed by evidence',
        ],
        strengthsTr: [
          'İyi araştırılmış, düşünceli seçimler yapar',
          'Başkalarının kaçırabileceği kusurları ve riskleri fark eder',
          'Kanıtlarla desteklenen kararlardan emin',
        ],
        growthAreasEn: [
          'Setting a deadline to decide — analysis can become paralysis',
          'Trusting that good enough is sometimes better than perfect',
        ],
        growthAreasTr: [
          'Karar vermek için son tarih belirleme — analiz felce dönüşebilir',
          'Yeterince iyinin bazen mükemmelden daha iyi olduğuna güvenmek',
        ],
      ),
      'intuitive': QuizDimensionMeta(
        key: 'intuitive',
        nameEn: 'The Intuitive',
        nameTr: 'Sezgisel',
        emoji: '\u{2728}',
        color: AppColors.amethyst,
        descriptionEn:
            'You may tend to trust your gut feelings when making decisions. You often "just know" the right path, even before you can explain why. Your strength lies in rapid, values-aligned decision-making.',
        descriptionTr:
            'Karar verirken iç sesinize güvenme eğiliminde olabilirsiniz. Nedenini açıklayamadan önce doğru yolu genellikle "hissedersiniz".',
        strengthsEn: [
          'Quick, confident decision-making',
          'Aligned choices with deep personal values',
          'Reads situations holistically rather than just the facts',
        ],
        strengthsTr: [
          'Hızlı, güvenli karar verme',
          'Derin kişisel değerlerle uyumlu seçimler',
          'Durumları sadece gerçeklere değil bütünsel olarak okur',
        ],
        growthAreasEn: [
          'Pausing to check intuition against available information',
          'Communicating the reasoning behind intuitive choices to others',
        ],
        growthAreasTr: [
          'Sezgiyi mevcut bilgilerle kontrol etmek için durakma',
          'Sezgisel seçimlerin arkasındaki mantığı başkalarına iletme',
        ],
      ),
      'collaborative': QuizDimensionMeta(
        key: 'collaborative',
        nameEn: 'The Collaborator',
        nameTr: 'İş Birlikçi',
        emoji: '\u{1F91D}',
        color: AppColors.greenAccent,
        descriptionEn:
            'You may tend to seek input from others before making decisions. Hearing different perspectives helps you feel grounded, and your choices often reflect collective wisdom rather than a single viewpoint.',
        descriptionTr:
            'Karar vermeden önce başkalarından görüş alma eğiliminde olabilirsiniz. Farklı bakış açılarını duymak kendinizi temellenmiş hissettirir.',
        strengthsEn: [
          'Inclusive and considerate decision-maker',
          'Builds buy-in and trust through shared process',
          'Catches blind spots by gathering diverse input',
        ],
        strengthsTr: [
          'Kapsayıcı ve düşünceli karar verici',
          'Paylaşılan süreç yoluyla güven ve katılım sağlar',
          'Çeşitli girdiler toplayarak kör noktaları yakalar',
        ],
        growthAreasEn: [
          'Deciding even when consensus isn\'t possible',
          'Trusting your own voice when advice conflicts',
        ],
        growthAreasTr: [
          'Konsensüs mümkün olmadığında bile karar verme',
          'Tavsiyeler çeliştiğinde kendi sesinize güvenmek',
        ],
      ),
      'spontaneous': QuizDimensionMeta(
        key: 'spontaneous',
        nameEn: 'The Spontaneous',
        nameTr: 'Spontan',
        emoji: '\u{1F680}',
        color: AppColors.warmAccent,
        descriptionEn:
            'You may tend to decide quickly and adapt on the fly. You trust the process of learning through action and often prefer moving forward imperfectly over waiting for the "right" moment.',
        descriptionTr:
            'Hızla karar verme ve anında uyum sağlama eğiliminde olabilirsiniz. Eylem yoluyla öğrenme sürecine güvenirsiniz ve genellikle "doğru" anı beklemek yerine eksik de olsa ilerlemeyi tercih edersiniz.',
        strengthsEn: [
          'Decisive and action-oriented',
          'Thrives in fast-paced, changing environments',
          'Embraces learning from mistakes',
        ],
        strengthsTr: [
          'Kararlı ve eylem odaklı',
          'Hızlı tempolu, değişen ortamlarda gelişir',
          'Hatalardan öğrenmeyi benimser',
        ],
        growthAreasEn: [
          'Pausing for high-stakes decisions that warrant more thought',
          'Reflecting on past decisions to build pattern awareness',
        ],
        growthAreasTr: [
          'Daha fazla düşünce gerektiren yüksek riskli kararlar için durakma',
          'Örüntü farkındalığı oluşturmak için geçmiş kararlar üzerine düşünme',
        ],
      ),
    },
    questions: [
      QuizQuestion(
        text:
            'You\'re choosing between two equally appealing options. How do you tend to decide?',
        textTr:
            'Eşit derecede çekici iki seçenek arasında seçim yapıyorsunuz. Nasıl karar verme eğiliminde olursunuz?',
        options: [
          QuizOption(
            text: 'I make a pros and cons list and evaluate systematically.',
            textTr:
                'Artı ve eksi listesi yapar ve sistematik olarak değerlendiririm.',
            scores: {'analytical': 3},
          ),
          QuizOption(
            text:
                'I go with whichever one "feels right" — my gut usually knows.',
            textTr:
                'Hangisi "doğru hissettiriyorsa" onu seçerim — içgüdüm genellikle bilir.',
            scores: {'intuitive': 3},
          ),
          QuizOption(
            text: 'I ask trusted friends or family what they think.',
            textTr:
                'Güvenilir arkadaşları veya aileye ne düşündüklerini sorarım.',
            scores: {'collaborative': 3},
          ),
          QuizOption(
            text:
                'I pick one quickly and adjust course if needed — no point overthinking.',
            textTr:
                'Hızlıca birini seçer ve gerekirse rotayı ayarlarım — aşırı düşünmenin anlamı yok.',
            scores: {'spontaneous': 3},
          ),
        ],
      ),
      QuizQuestion(
        text: 'When buying something significant, your process tends to be:',
        textTr: 'Önemli bir şey satın alırken, süreciniz eğilim olarak:',
        options: [
          QuizOption(
            text:
                'Extensive research — I read reviews, compare specs, and sleep on it.',
            textTr:
                'Kapsamlı araştırma — yorumları okur, özellikleri karşılaştırır ve üzerine uyurum.',
            scores: {'analytical': 3},
          ),
          QuizOption(
            text: 'I browse until something catches my eye and feels right.',
            textTr: 'Bir şey gözüme çarpıp doğru hissedene kadar göz atarım.',
            scores: {'intuitive': 3},
          ),
          QuizOption(
            text: 'I ask people I respect what they\'d recommend.',
            textTr: 'Saygı duyduğum insanlara ne önerirlerini sorarım.',
            scores: {'collaborative': 3},
          ),
          QuizOption(
            text:
                'If I like it, I buy it — life is too short for decision fatigue.',
            textTr: 'Beğenirsem alırım — hayat karar yorgunluğu için çok kısa.',
            scores: {'spontaneous': 3},
          ),
        ],
      ),
      QuizQuestion(
        text:
            'A decision you made turned out badly. How do you tend to process it?',
        textTr:
            'Verdiğiniz bir karar kötü sonuçlandı. Bunu nasıl işleme eğiliminde olursunuz?',
        options: [
          QuizOption(
            text: 'I analyze what went wrong to prevent repeating the mistake.',
            textTr:
                'Hatayı tekrarlamamak için neyin yanlış gittiğini analiz ederim.',
            scores: {'analytical': 3},
          ),
          QuizOption(
            text:
                'I reflect on whether I ignored my instincts and promise to trust them next time.',
            textTr:
                'İçgüdülerimi görmezden gelip gelmediğimi düşünür ve bir dahaki sefere onlara güvenmeye söz veririm.',
            scores: {'intuitive': 3},
          ),
          QuizOption(
            text: 'I discuss it with people close to me to gain perspective.',
            textTr: 'Bakış açısı kazanmak için yakın çevremle tartışırım.',
            scores: {'collaborative': 3},
          ),
          QuizOption(
            text:
                'I move on quickly — dwelling on it doesn\'t change the outcome.',
            textTr:
                'Hızlıca devam ederim — üzerine takılmak sonucu değiştirmez.',
            scores: {'spontaneous': 3},
          ),
        ],
      ),
      QuizQuestion(
        text: 'When planning a trip, your approach tends to be:',
        textTr: 'Bir seyahat planlarken, yaklaşımınız eğilim olarak:',
        options: [
          QuizOption(
            text:
                'Detailed itinerary with research on every destination and restaurant.',
            textTr:
                'Her destinasyon ve restoran hakkında araştırmayla detaylı program.',
            scores: {'analytical': 3},
          ),
          QuizOption(
            text:
                'I choose a destination that calls to me and figure out the rest as I go.',
            textTr:
                'Beni çağıran bir destinasyon seçer ve geri kalanını gittikçe hallederim.',
            scores: {'intuitive': 3},
          ),
          QuizOption(
            text:
                'I plan with travel companions and incorporate everyone\'s wishes.',
            textTr:
                'Seyahat arkadaşlarıyla planlar ve herkesin isteklerini dahil ederim.',
            scores: {'collaborative': 3},
          ),
          QuizOption(
            text:
                'Minimal planning — the best experiences are unplanned discoveries.',
            textTr: 'Minimal planlama — en iyi deneyimler plansız keşiflerdir.',
            scores: {'spontaneous': 3},
          ),
        ],
      ),
      QuizQuestion(
        text: 'At a restaurant with a long menu, you tend to:',
        textTr: 'Uzun menülü bir restoranda, eğilim olarak:',
        options: [
          QuizOption(
            text:
                'Read the entire menu carefully before narrowing down options.',
            textTr:
                'Seçenekleri daraltmadan önce tüm menüyü dikkatlice okurum.',
            scores: {'analytical': 3},
          ),
          QuizOption(
            text: 'Quickly scan and choose whatever jumps out at me.',
            textTr:
                'Hızlıca gözden geçirir ve bana ne öne çıkarsa onu seçerim.',
            scores: {'intuitive': 3},
          ),
          QuizOption(
            text:
                'Ask the server for recommendations or check what others are ordering.',
            textTr:
                'Garsondan öneriler isterim veya başkalarının ne sipariş ettiğini kontrol ederim.',
            scores: {'collaborative': 3},
          ),
          QuizOption(
            text: 'Pick the first thing that sounds good — it\'s just dinner.',
            textTr: 'Kulağa iyi gelen ilk şeyi seçerim — sadece akşam yemeği.',
            scores: {'spontaneous': 3},
          ),
        ],
      ),
      QuizQuestion(
        text:
            'When facing a major life decision (career change, moving, etc.), you tend to:',
        textTr:
            'Büyük bir yaşam kararıyla (kariyer değişikliği, taşınma vb.) karşı karşıya kaldığınızda, eğilim olarak:',
        options: [
          QuizOption(
            text:
                'Create a spreadsheet or framework to evaluate all factors objectively.',
            textTr:
                'Tüm faktörleri nesnel olarak değerlendirmek için bir tablo veya çerçeve oluştururum.',
            scores: {'analytical': 3},
          ),
          QuizOption(
            text:
                'Sit with the question and wait for clarity to emerge from within.',
            textTr:
                'Soruyla oturur ve içinizden netliğin ortaya çıkmasını beklerim.',
            scores: {'intuitive': 3},
          ),
          QuizOption(
            text: 'Have deep conversations with mentors, friends, and family.',
            textTr:
                'Mentörlar, arkadaşlar ve aileyle derin konuşmalar yaparım.',
            scores: {'collaborative': 3},
          ),
          QuizOption(
            text:
                'Lean toward the option that excites me most, even if it\'s risky.',
            textTr:
                'Riskli olsa bile beni en çok heyecanlandıran seçeneğe yaslanırım.',
            scores: {'spontaneous': 3},
          ),
        ],
      ),
      QuizQuestion(
        text: 'When someone asks you for advice on a decision, you tend to:',
        textTr:
            'Biri sizden bir karar hakkında tavsiye istediğinde, eğilim olarak:',
        options: [
          QuizOption(
            text: 'Help them think through the logic and weigh the trade-offs.',
            textTr:
                'Mantığı düşünmelerine ve artıları eksileri tartmalarına yardımcı olurum.',
            scores: {'analytical': 3},
          ),
          QuizOption(
            text:
                'Ask them what their heart is telling them beneath the noise.',
            textTr:
                'Gürültünün altında kalplerinin onlara ne söylediğini sorarım.',
            scores: {'intuitive': 3},
          ),
          QuizOption(
            text:
                'Suggest they talk to a few more people to broaden their perspective.',
            textTr:
                'Bakış açılarını genişletmek için birkaç kişi daha ile konuşmalarını öneririm.',
            scores: {'collaborative': 3},
          ),
          QuizOption(
            text:
                'Encourage them to just try something and course-correct later.',
            textTr:
                'Bir şeyler denemelerini ve sonra rotayı düzeltmelerini teşvik ederim.',
            scores: {'spontaneous': 3},
          ),
        ],
      ),
      QuizQuestion(
        text: 'Looking back at your best decisions, they were usually made by:',
        textTr:
            'En iyi kararlarınıza geri baktığınızda, genellikle şunlarla yapılmışlardı:',
        options: [
          QuizOption(
            text: 'Careful research and logical evaluation of all options.',
            textTr:
                'Dikkatli araştırma ve tüm seçeneklerin mantıksal değerlendirmesi.',
            scores: {'analytical': 3},
          ),
          QuizOption(
            text:
                'Trusting a deep inner knowing, even when the logic wasn\'t clear.',
            textTr:
                'Mantık net olmadığında bile derin bir iç bilgiye güvenmek.',
            scores: {'intuitive': 3},
          ),
          QuizOption(
            text:
                'Listening to wise people around me and synthesizing their input.',
            textTr:
                'Etrafımdaki bilge insanları dinlemek ve girdilerini sentezlemek.',
            scores: {'collaborative': 3},
          ),
          QuizOption(
            text: 'Acting boldly and figuring things out along the way.',
            textTr: 'Cesurca hareket etmek ve yol boyunca halletmek.',
            scores: {'spontaneous': 3},
          ),
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
    titleTr: 'Enerji Döngüsü',
    description: 'When does your energy peak? Discover your natural rhythm.',
    descriptionTr: 'Enerjiniz ne zaman zirve yapar? Doğal ritminizi keşfedin.',
    emoji: '\u{2600}',
    scoringType: QuizScoringType.categorical,
    dimensions: {
      'morning': QuizDimensionMeta(
        key: 'morning',
        nameEn: 'Morning Riser',
        nameTr: 'Sabahçı',
        emoji: '\u{1F305}',
        color: AppColors.warning,
        descriptionEn:
            'You may tend to feel most alive and focused in the early hours of the day. Your clarity and energy often peak before noon, making mornings your natural time for meaningful work and reflection.',
        descriptionTr:
            'Günün erken saatlerinde en canlı ve odaklı hissetme eğiliminde olabilirsiniz. Netliğiniz ve enerjiniz genellikle öğle öncesinde zirve yapar.',
        strengthsEn: [
          'Consistent, early-day productivity',
          'Natural alignment with conventional schedules',
          'Tends to start the day with intention and clarity',
        ],
        strengthsTr: [
          'Tutarlı, erken gün verimliliği',
          'Geleneksel programlarla doğal uyum',
          'Güne niyet ve netlikle başlama eğilimi',
        ],
        growthAreasEn: [
          'Protecting evening energy for wind-down rather than pushing through',
          'Being patient with night-owl friends and collaborators',
        ],
        growthAreasTr: [
          'Akşam enerjisini zorlamak yerine yavaşlama için koruma',
          'Gece kuşu arkadaşlara ve iş arkadaşlarına karşı sabırlı olma',
        ],
      ),
      'night': QuizDimensionMeta(
        key: 'night',
        nameEn: 'Night Owl',
        nameTr: 'Gece Kuşu',
        emoji: '\u{1F319}',
        color: AppColors.cosmicAmethyst,
        descriptionEn:
            'You may tend to come alive as the day winds down. Your best thinking, creativity, and focus often emerge in the evening or late at night, when the world quiets and distractions fade.',
        descriptionTr:
            'Gün ilerledikçe canlanma eğiliminde olabilirsiniz. En iyi düşünceniz, yaratıcılığınız ve odağınız genellikle akşam veya geç saatlerde ortaya çıkar.',
        strengthsEn: [
          'Creative and productive during quiet hours',
          'Deep focus when the world is asleep',
          'Comfortable with non-conventional schedules',
        ],
        strengthsTr: [
          'Sessiz saatlerde yaratıcı ve verimli',
          'Dünya uyurken derin odak',
          'Geleneksel olmayan programlarla rahat',
        ],
        growthAreasEn: [
          'Creating a morning routine that honours your slower start',
          'Ensuring enough sleep even when inspiration strikes late',
        ],
        growthAreasTr: [
          'Daha yavaş başlangıcınızı onurlandıran bir sabah rutini oluşturma',
          'İlham geç gelse bile yeterli uyku sağlama',
        ],
      ),
      'steady': QuizDimensionMeta(
        key: 'steady',
        nameEn: 'Steady Current',
        nameTr: 'Sabit Akım',
        emoji: '\u{1F30A}',
        color: AppColors.greenAccent,
        descriptionEn:
            'You may tend to maintain a relatively even energy level throughout the day. Rather than dramatic peaks and valleys, you might notice a sustainable, consistent flow that helps you pace yourself well.',
        descriptionTr:
            'Gün boyunca nispeten eşit bir enerji seviyesi sürdürme eğiliminde olabilirsiniz. Dramatik zirveler ve vadiler yerine kendinizi iyi ayarlamanıza yardımcı olan sürdürülebilir, tutarlı bir akış fark edebilirsiniz.',
        strengthsEn: [
          'Reliable and consistent energy output',
          'Naturally good at pacing and sustainability',
          'Less affected by time-of-day variations',
        ],
        strengthsTr: [
          'Güvenilir ve tutarlı enerji çıktısı',
          'Doğal olarak hız ve sürdürülebilirlikte iyi',
          'Gün-için-zaman varyasyonlarından daha az etkilenir',
        ],
        growthAreasEn: [
          'Creating intentional energy peaks for creative or challenging tasks',
          'Noticing subtle energy dips before they become exhaustion',
        ],
        growthAreasTr: [
          'Yaratıcı veya zorlu görevler için niyetli enerji zirveleri oluşturma',
          'Tükenmeye dönüşmeden önce ince enerji düşüşlerini fark etme',
        ],
      ),
      'burst': QuizDimensionMeta(
        key: 'burst',
        nameEn: 'Burst Creator',
        nameTr: 'Patlama Yaratıcı',
        emoji: '\u{1F4A5}',
        color: AppColors.warmAccent,
        descriptionEn:
            'You may tend to experience intense bursts of energy and focus followed by periods of rest. Your productivity often comes in powerful waves, and you might notice that forcing a steady pace feels unnatural.',
        descriptionTr:
            'Yoğun enerji ve odak patlamaları yaşama eğiliminde olabilirsiniz, ardından dinlenme dönemleri gelir. Verimliliğiniz genellikle güçlü dalgalar halinde gelir.',
        strengthsEn: [
          'Capable of extraordinary focus during peak moments',
          'Produces high-quality work in concentrated sessions',
          'Natural creative rhythm that mirrors inspiration cycles',
        ],
        strengthsTr: [
          'Zirve anlarda olağanüstü odak kapasitesi',
          'Yoğunlaştırılmış oturumlarda yüksek kaliteli iş üretir',
          'İlham döngülerini yansıtan doğal yaratıcı ritim',
        ],
        growthAreasEn: [
          'Honouring rest between bursts without guilt',
          'Planning around your rhythm rather than fighting it',
        ],
        growthAreasTr: [
          'Patlamalar arasındaki dinlenmeyi suçluluk olmadan onurlandırma',
          'Ritminize karşı savaşmak yerine etrafında planlama',
        ],
      ),
    },
    questions: [
      QuizQuestion(
        text: 'What time of day do you tend to feel most mentally sharp?',
        textTr:
            'Günün hangi saatinde kendinizi zihinsel olarak en keskin hissetme eğiliminde olursunuz?',
        options: [
          QuizOption(
            text:
                'Early morning — my mind is clearest before the world wakes up.',
            textTr: 'Erken sabah — dünya uyanmadan önce zihnim en berrak.',
            scores: {'morning': 3},
          ),
          QuizOption(
            text:
                'Late evening or night — I hit my stride when things quiet down.',
            textTr:
                'Geç akşam veya gece — işler sakinleştiğinde hızıma kavuşurum.',
            scores: {'night': 3},
          ),
          QuizOption(
            text:
                'I feel fairly consistent throughout the day — no dramatic peak.',
            textTr:
                'Gün boyunca oldukça tutarlı hissediyorum — dramatik zirve yok.',
            scores: {'steady': 3},
          ),
          QuizOption(
            text:
                'It varies unpredictably — sometimes I\'m sharp at 10am, sometimes at 10pm.',
            textTr:
                'Öngörülemez şekilde değişir — bazen sabah 10da, bazen gece 10da keskinim.',
            scores: {'burst': 3},
          ),
        ],
      ),
      QuizQuestion(
        text:
            'Your alarm goes off on a free day with no obligations. You tend to:',
        textTr:
            'Zorunluluğu olmayan boş bir günde alarmınız çalıyor. Eğilim olarak:',
        options: [
          QuizOption(
            text:
                'Wake up at roughly the same time anyway — my body clock is set.',
            textTr:
                'Yine de yaklaşık aynı saatte uyanırım — vücudum saat kurulmuştur.',
            scores: {'morning': 3},
          ),
          QuizOption(
            text:
                'Sleep in without guilt — I know I\'ll be productive later tonight.',
            textTr:
                'Suçluluk duymadan uyurum — bu gece verimli olacağımı biliyorum.',
            scores: {'night': 3},
          ),
          QuizOption(
            text: 'Wake up at my usual time, maybe sleep in 30 minutes.',
            textTr: 'Normal zamanımda uyanir, belki 30 dakika daha uyurum.',
            scores: {'steady': 3},
          ),
          QuizOption(
            text:
                'It completely depends on what I was doing last night — no pattern.',
            textTr: 'Tamamen dün gece ne yaptığıma bağlı — örüntü yok.',
            scores: {'burst': 3},
          ),
        ],
      ),
      QuizQuestion(
        text: 'When do you tend to get your most creative ideas?',
        textTr: 'En yaratıcı fikirlerinizi ne zaman alma eğiliminde olursunuz?',
        options: [
          QuizOption(
            text: 'During my morning routine — shower thoughts, morning walks.',
            textTr:
                'Sabah rutinim sırasında — duş düşünceleri, sabah yürüyüşleri.',
            scores: {'morning': 3},
          ),
          QuizOption(
            text:
                'Late at night when the house is quiet and I can think freely.',
            textTr:
                'Ev sessiz olduğunda ve özgürce düşünebileceğim gece geç saatlerde.',
            scores: {'night': 3},
          ),
          QuizOption(
            text: 'They come gradually throughout the day at a steady pace.',
            textTr: 'Gün boyunca sabit bir tempoda yavaşça gelirler.',
            scores: {'steady': 3},
          ),
          QuizOption(
            text:
                'In sudden flashes — inspiration strikes randomly and intensely.',
            textTr: 'Ani parlamalarda — ilham rastgele ve yoğun şekilde vurur.',
            scores: {'burst': 3},
          ),
        ],
      ),
      QuizQuestion(
        text:
            'How would you describe your typical energy pattern across a day?',
        textTr: 'Bir gün boyunca tipik enerji örüntünüzü nasıl tanımlarsınız?',
        options: [
          QuizOption(
            text: 'High in the morning, gradually declining by evening.',
            textTr: 'Sabah yüksek, akşama doğru kademeli olarak düşen.',
            scores: {'morning': 3},
          ),
          QuizOption(
            text:
                'Slow to start, building momentum as the day goes on, peaking at night.',
            textTr:
                'Yavaş başlayan, gün ilerledikçe ivme kazanan, gece zirve yapan.',
            scores: {'night': 3},
          ),
          QuizOption(
            text: 'A gentle, even line — no dramatic ups or downs.',
            textTr: 'Nazik, eşit bir çizgi — dramatik inişler ve çıkışlar yok.',
            scores: {'steady': 3},
          ),
          QuizOption(
            text:
                'Spiky — intense energy, then flat, then intense again unpredictably.',
            textTr:
                'Sivri — yoğun enerji, sonra düz, sonra tekrar öngörülemez şekilde yoğun.',
            scores: {'burst': 3},
          ),
        ],
      ),
      QuizQuestion(
        text:
            'When you have an important task to complete, when do you tend to schedule it?',
        textTr:
            'Tamamlanacak önemli bir göreviniz olduğunda, ne zaman programlama eğiliminde olursunuz?',
        options: [
          QuizOption(
            text:
                'First thing in the morning — tackle the hardest thing when I\'m fresh.',
            textTr: 'Sabah ilk iş — en zor şeyi taze olduğumda hallederim.',
            scores: {'morning': 3},
          ),
          QuizOption(
            text:
                'Evening — that\'s when I can really focus without distraction.',
            textTr:
                'Akşam — dikkat dağıtmadan gerçekten odaklanabildiğim zaman.',
            scores: {'night': 3},
          ),
          QuizOption(
            text:
                'Whenever it fits in my schedule — my energy is fairly stable.',
            textTr: 'Programıma ne zaman uyarsa — enerjim oldukça stabil.',
            scores: {'steady': 3},
          ),
          QuizOption(
            text:
                'When I feel the energy hit — I\'ve learned to ride the wave when it comes.',
            textTr: 'Enerji vurduğunda — geldiğinde dalgayı sürmeyi öğrendim.',
            scores: {'burst': 3},
          ),
        ],
      ),
      QuizQuestion(
        text: 'How does exercise fit into your energy pattern?',
        textTr: 'Egzersiz enerji örüntünüze nasıl uyar?',
        options: [
          QuizOption(
            text:
                'Morning workouts feel natural and set a great tone for the day.',
            textTr:
                'Sabah antrenmanları doğal hissettirir ve güne harika bir ton verir.',
            scores: {'morning': 3},
          ),
          QuizOption(
            text:
                'I prefer evening exercise — it\'s when my body feels most ready.',
            textTr:
                'Akşam egzersizini tercih ederim — vücudumun en hazır hissettiği zaman.',
            scores: {'night': 3},
          ),
          QuizOption(
            text:
                'I can exercise at any time — my energy doesn\'t fluctuate much.',
            textTr:
                'Herhangi bir zamanda egzersiz yapabilirim — enerjim çok dalgalanmaz.',
            scores: {'steady': 3},
          ),
          QuizOption(
            text:
                'I exercise when I feel a surge of energy — sometimes at odd hours.',
            textTr:
                'Enerji dalgası hissettiğimde egzersiz yaparım — bazen garip saatlerde.',
            scores: {'burst': 3},
          ),
        ],
      ),
      QuizQuestion(
        text: 'When working on a project, your productivity style tends to be:',
        textTr:
            'Bir proje üzerinde çalışırken, verimlilik stiliniz eğilim olarak:',
        options: [
          QuizOption(
            text:
                'Best in focused morning sessions — I front-load my productive hours.',
            textTr:
                'Odaklı sabah oturumlarında en iyi — verimli saatlerimi öne yüklerim.',
            scores: {'morning': 3},
          ),
          QuizOption(
            text: 'I do my deepest work after dinner when interruptions stop.',
            textTr:
                'En derin işimi akşam yemeğinden sonra kesintiler durduğunda yaparım.',
            scores: {'night': 3},
          ),
          QuizOption(
            text:
                'I work steadily throughout the day, maintaining a consistent pace.',
            textTr:
                'Gün boyunca istikrarlı çalışırım, tutarlı bir tempo sürdürerek.',
            scores: {'steady': 3},
          ),
          QuizOption(
            text:
                'I work in intense sprints followed by breaks — it\'s how I\'m wired.',
            textTr:
                'Yoğun sprintler ve ardından molalar halinde çalışırım — böyle bağlantılıyım.',
            scores: {'burst': 3},
          ),
        ],
      ),
      QuizQuestion(
        text:
            'If you could design your ideal daily schedule with no constraints, it would be:',
        textTr:
            'Hiçbir kısıtlama olmadan ideal günlük programınızı tasarlayabilseydiniz:',
        options: [
          QuizOption(
            text:
                'Up with the sun, productive morning, relaxed afternoon, early to bed.',
            textTr:
                'Güneşle kalkış, verimli sabah, rahat öğle sonrası, erken yatma.',
            scores: {'morning': 3},
          ),
          QuizOption(
            text:
                'Sleep late, ease into the day, peak productivity from evening into night.',
            textTr:
                'Geç uyuma, güne yavaş girme, akşamdan geceye zirve verimlilik.',
            scores: {'night': 3},
          ),
          QuizOption(
            text:
                'A balanced rhythm — work, rest, and play evenly distributed.',
            textTr:
                'Dengeli bir ritim — iş, dinlenme ve eğlence eşit dağıtılmış.',
            scores: {'steady': 3},
          ),
          QuizOption(
            text:
                'No fixed schedule — I\'d work when inspired and rest when I need to.',
            textTr:
                'Sabit program yok — ilham geldiğinde çalışır, ihtiyacım olduğunda dinlenirim.',
            scores: {'burst': 3},
          ),
        ],
      ),
    ],
  );
}
