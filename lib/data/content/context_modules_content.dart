/// Context Injection Modules — 36 educational insight modules
/// Psychological context, myth vs reality, pattern recognition,
/// self-awareness checklists, and "why this matters" education layers.
/// Apple App Store 4.3(b) compliant. No predictions. Educational only.
library;

// ═══════════════════════════════════════════════════════════════════════════
// ENUMS
// ═══════════════════════════════════════════════════════════════════════════

enum ContextModuleCategory {
  emotionalLiteracy,
  mythVsReality,
  patternRecognition,
  selfAwareness,
  cyclicalWellness,
  journalScience;

  String get displayNameEn {
    switch (this) {
      case emotionalLiteracy:
        return 'Emotional Literacy';
      case mythVsReality:
        return 'Myth vs Reality';
      case patternRecognition:
        return 'Pattern Recognition';
      case selfAwareness:
        return 'Self-Awareness';
      case cyclicalWellness:
        return 'Cyclical Wellness';
      case journalScience:
        return 'Journal Science';
    }
  }

  String get displayNameTr {
    switch (this) {
      case emotionalLiteracy:
        return 'Duygusal Okuryazarlık';
      case mythVsReality:
        return 'Mit ve Gerçek';
      case patternRecognition:
        return 'Örüntü Tanıma';
      case selfAwareness:
        return 'Öz Farkındalık';
      case cyclicalWellness:
        return 'Döngüsel İyi Oluş';
      case journalScience:
        return 'Günlük Bilimi';
    }
  }
}

enum ContextModuleDepth {
  beginner,
  intermediate,
  advanced;

  String get displayNameEn {
    switch (this) {
      case beginner:
        return 'Beginner';
      case intermediate:
        return 'Intermediate';
      case advanced:
        return 'Advanced';
    }
  }

  String get displayNameTr {
    switch (this) {
      case beginner:
        return 'Başlangıç';
      case intermediate:
        return 'Orta';
      case advanced:
        return 'İleri';
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MODEL
// ═══════════════════════════════════════════════════════════════════════════

class ContextModule {
  final String id;
  final ContextModuleCategory category;
  final ContextModuleDepth depth;
  final String titleEn;
  final String titleTr;
  final String summaryEn;
  final String summaryTr;
  final String bodyEn;
  final String bodyTr;
  final String whyItMattersEn;
  final String whyItMattersTr;
  final String? screenshotLineEn; // short shareable insight
  final String? screenshotLineTr;
  final List<String> relatedFocusAreas; // mood, energy, social, etc.
  final List<String> relatedModuleIds; // cross-references

  const ContextModule({
    required this.id,
    required this.category,
    required this.depth,
    required this.titleEn,
    required this.titleTr,
    required this.summaryEn,
    required this.summaryTr,
    required this.bodyEn,
    required this.bodyTr,
    required this.whyItMattersEn,
    required this.whyItMattersTr,
    this.screenshotLineEn,
    this.screenshotLineTr,
    this.relatedFocusAreas = const [],
    this.relatedModuleIds = const [],
  });
}

// ═══════════════════════════════════════════════════════════════════════════
// CONTENT — 36 Context Modules
// ═══════════════════════════════════════════════════════════════════════════

const List<ContextModule> allContextModules = [
  // ═══════════════════════════════════════════════════════════════
  // EMOTIONAL LITERACY — 6 modules (el_001 – el_006)
  // ═══════════════════════════════════════════════════════════════
  ContextModule(
    id: 'el_001',
    category: ContextModuleCategory.emotionalLiteracy,
    depth: ContextModuleDepth.beginner,
    titleEn: 'Emotions Are Data, Not Directives',
    titleTr: 'Duygular Veridir, Emir Değil',
    summaryEn:
        'Your emotions carry information about your needs and environment. Learning to read them without reacting changes everything.',
    summaryTr:
        'Duygularınız ihtiyaçlarınız ve çevreniz hakkında bilgi taşır. Tepki vermeden onları okumayı öğrenmek her şeyi değiştirir.',
    bodyEn:
        'Psychologist Susan David calls this "emotional agility" — the ability to experience feelings without being controlled by them. When you feel anxious before a meeting, that anxiety is not telling you to cancel. It is signaling that you care about the outcome. When you feel angry after a conversation, that anger may be pointing to a boundary that was crossed. The practice is simple: notice the emotion, name it specifically, then ask "what is this telling me?" instead of "how do I make this stop?"',
    bodyTr:
        'Psikolog Susan David buna "duygusal çeviklik" diyor — duyguları, onlar tarafından kontrol edilmeden deneyimleme yeteneği. Bir toplantıdan önce kaygılı hissediyorsanız, bu kaygı size iptal etmenizi söylemiyor. Sonucu önemsediğinizi işaret ediyor. Bir konuşmadan sonra kızgın hissediyorsanız, bu kızgınlık aşılmış bir sınıra işaret ediyor olabilir. Pratik basit: duyguyu fark edin, onu spesifik olarak adlandırın, sonra "bunu nasıl durdururum?" yerine "bu bana ne söylüyor?" diye sorun.',
    whyItMattersEn:
        'Research shows that people who can specifically name their emotions make better decisions and experience less prolonged distress.',
    whyItMattersTr:
        'Araştırmalar, duygularını spesifik olarak adlandırabilen kişilerin daha iyi kararlar aldığını ve daha az uzun süreli sıkıntı yaşadığını göstermektedir.',
    screenshotLineEn: 'Emotions are messengers. The message matters more than the volume.',
    screenshotLineTr: 'Duygular habercilerdir. Mesaj, ses seviyesinden daha önemlidir.',
    relatedFocusAreas: ['mood'],
    relatedModuleIds: ['el_002', 'sa_001'],
  ),
  ContextModule(
    id: 'el_002',
    category: ContextModuleCategory.emotionalLiteracy,
    depth: ContextModuleDepth.beginner,
    titleEn: 'The Mood-Emotion Difference',
    titleTr: 'Ruh Hali ve Duygu Farkı',
    summaryEn:
        'Moods and emotions are not the same thing. Understanding the difference helps you respond to each one appropriately.',
    summaryTr:
        'Ruh halleri ve duygular aynı şey değildir. Farkı anlamak, her birine uygun şekilde yanıt vermenize yardımcı olur.',
    bodyEn:
        'An emotion is a quick, specific response to an event — you feel fear when a car brakes suddenly. A mood is a longer, diffuse state that colors your whole day — you wake up feeling "off" without knowing why. Emotions have clear triggers. Moods often do not. This matters because the strategies for each are different: emotions benefit from naming and processing in the moment, while moods often respond better to environmental changes like movement, light exposure, or social connection.',
    bodyTr:
        'Duygu, bir olaya verilen hızlı ve spesifik bir yanıttır — bir araba aniden fren yaptığında korku hissedersiniz. Ruh hali ise tüm gününüzü renklendiren daha uzun ve yaygın bir durumdur — nedenini bilmeden "kötü" uyanırsınız. Duyguların net tetikleyicileri vardır. Ruh hallerinin çoğu zaman yoktur. Bu önemlidir çünkü her biri için stratejiler farklıdır: duygular o anda adlandırma ve işlemeden yararlanırken, ruh halleri hareket, ışık maruziyeti veya sosyal bağlantı gibi çevresel değişikliklere daha iyi yanıt verir.',
    whyItMattersEn:
        'When you track your mood over time, you start to see which environmental factors shape your baseline — and which ones you can actually change.',
    whyItMattersTr:
        'Ruh halinizi zaman içinde takip ettiğinizde, hangi çevresel faktörlerin temelinizi şekillendirdiğini ve hangilerini gerçekten değiştirebileceğinizi görmeye başlarsınız.',
    screenshotLineEn: 'Emotions flash. Moods linger. Knowing which is which changes the response.',
    screenshotLineTr: 'Duygular parlar. Ruh halleri kalır. Hangisinin hangisi olduğunu bilmek yanıtı değiştirir.',
    relatedFocusAreas: ['mood', 'energy'],
    relatedModuleIds: ['el_001', 'el_003'],
  ),
  ContextModule(
    id: 'el_003',
    category: ContextModuleCategory.emotionalLiteracy,
    depth: ContextModuleDepth.intermediate,
    titleEn: 'Emotional Granularity',
    titleTr: 'Duygusal Ayrıntı Düzeyi',
    summaryEn:
        'The more precisely you can label your feelings, the better your brain can regulate them. This is called emotional granularity.',
    summaryTr:
        'Duygularınızı ne kadar kesin etiketleyebilirseniz, beyniniz onları o kadar iyi düzenleyebilir. Buna duygusal ayrıntı düzeyi denir.',
    bodyEn:
        'Neuroscientist Lisa Feldman Barrett found that people who distinguish between "irritated," "frustrated," and "disappointed" — rather than just saying "I feel bad" — show measurably better emotional regulation. The act of finding the precise word activates your prefrontal cortex, which naturally dampens the amygdala response. This is not about being poetic. It is about giving your brain specific enough information to choose the right response. "I feel anxious" and "I feel overwhelmed" point to very different needs.',
    bodyTr:
        'Nörobilimci Lisa Feldman Barrett, sadece "kötü hissediyorum" demek yerine "sinirli," "hayal kırıklığına uğramış" ve "hayal kırıklığına uğramış" arasında ayrım yapan kişilerin ölçülebilir şekilde daha iyi duygusal düzenleme gösterdiğini buldu. Doğru kelimeyi bulma eylemi prefrontal korteksinizi aktive eder ve bu da doğal olarak amigdala yanıtını azaltır. Bu şiirsel olmakla ilgili değil. Beyninize doğru yanıtı seçmesi için yeterince spesifik bilgi vermekle ilgili.',
    whyItMattersEn:
        'Your journal entries become more useful over time when you practice granularity — patterns emerge that "good" and "bad" alone could never reveal.',
    whyItMattersTr:
        'Ayrıntı düzeyini pratik ettikçe günlük kayıtlarınız zamanla daha kullanışlı hale gelir — sadece "iyi" ve "kötü" ile asla ortaya çıkamayacak örüntüler belirir.',
    screenshotLineEn: 'The word you choose to name a feeling can change how your brain processes it.',
    screenshotLineTr: 'Bir duyguyu adlandırmak için seçtiğiniz kelime, beyninizin onu nasıl işlediğini değiştirebilir.',
    relatedFocusAreas: ['mood'],
    relatedModuleIds: ['el_001', 'el_002'],
  ),
  ContextModule(
    id: 'el_004',
    category: ContextModuleCategory.emotionalLiteracy,
    depth: ContextModuleDepth.intermediate,
    titleEn: 'The Body Keeps the Score',
    titleTr: 'Beden Her Şeyi Kaydeder',
    summaryEn:
        'Your body often registers emotions before your conscious mind does. Learning to read physical signals builds emotional awareness.',
    summaryTr:
        'Bedeniniz genellikle duyguları bilinçli zihninizden önce kaydeder. Fiziksel sinyalleri okumayı öğrenmek duygusal farkındalık oluşturur.',
    bodyEn:
        'Before you consciously realize you are stressed, your shoulders may have already tensed. Before you recognize anger, your jaw may have clenched. This body-first pattern exists because emotional processing starts in the limbic system, which responds faster than the analytical prefrontal cortex. A body scan practice — pausing to notice tension, temperature, tightness, or heaviness — can reveal emotions that you have not yet named. Many people find that tracking physical sensations alongside mood entries reveals connections they had missed for years.',
    bodyTr:
        'Stresli olduğunuzu bilinçli olarak fark etmeden önce omuzlarınız çoktan gerilmiş olabilir. Öfkeyi tanımadan önce çeneniz sıkılmış olabilir. Bu beden-önce örüntüsü, duygusal işlemenin analitik prefrontal korteksten daha hızlı yanıt veren limbik sistemde başlaması nedeniyle vardır. Beden tarama pratiği — gerginlik, sıcaklık, sıkılık veya ağırlığı fark etmek için duraklama — henüz adlandırmadığınız duyguları ortaya çıkarabilir. Birçok kişi fiziksel duyumları ruh hali kayıtlarıyla birlikte takip etmenin yıllardır kaçırdıkları bağlantıları ortaya çıkardığını fark eder.',
    whyItMattersEn:
        'Connecting body sensations to emotions creates an early warning system that helps you respond before stress accumulates.',
    whyItMattersTr:
        'Beden duyumlarını duygulara bağlamak, stres birikmeden yanıt vermenize yardımcı olan bir erken uyarı sistemi oluşturur.',
    screenshotLineEn: 'Your body notices stress before your mind does. Learn to listen.',
    screenshotLineTr: 'Bedeniniz stresi zihninizden önce fark eder. Dinlemeyi öğrenin.',
    relatedFocusAreas: ['mood', 'health', 'energy'],
    relatedModuleIds: ['el_003', 'sa_002'],
  ),
  ContextModule(
    id: 'el_005',
    category: ContextModuleCategory.emotionalLiteracy,
    depth: ContextModuleDepth.advanced,
    titleEn: 'Mixed Emotions Are Normal',
    titleTr: 'Karışık Duygular Normaldir',
    summaryEn:
        'Feeling two contradictory emotions at once is not confusion — it is a sign of emotional complexity and depth.',
    summaryTr:
        'Aynı anda iki çelişkili duygu hissetmek kafa karışıklığı değil — duygusal karmaşıklığın ve derinliğin bir işaretidir.',
    bodyEn:
        'You can feel relieved and sad when a difficult relationship ends. Excited and terrified about a new opportunity. Proud and guilty about setting a boundary. Research in affective science calls this "emotional co-occurrence" — and it is completely normal. Problems arise when we try to force ourselves into feeling only one thing, or when we judge the "wrong" feeling. Journaling about mixed emotions helps because writing naturally separates them out. You can hold both feelings on the page without choosing one over the other.',
    bodyTr:
        'Zor bir ilişki bittiğinde hem rahatlamış hem de üzgün hissedebilirsiniz. Yeni bir fırsat karşısında hem heyecanlı hem de korkmuş. Bir sınır koymaktan hem gururlu hem de suçlu. Duygu biliminde buna "duygusal birlikte oluşum" denir — ve tamamen normaldir. Sorunlar kendimizi tek bir şey hissetmeye zorlamaya çalıştığımızda veya "yanlış" duyguyu yargıladığımızda ortaya çıkar. Karışık duygular hakkında günlük tutmak yardımcı olur çünkü yazı doğal olarak onları ayırır.',
    whyItMattersEn:
        'Acknowledging mixed emotions reduces internal conflict and helps you make decisions that honor all parts of your experience.',
    whyItMattersTr:
        'Karışık duyguları kabul etmek iç çatışmayı azaltır ve deneyiminizin tüm yönlerini onurlandıran kararlar vermenize yardımcı olur.',
    screenshotLineEn: 'You do not have to pick one feeling. You can hold two truths at once.',
    screenshotLineTr: 'Tek bir duygu seçmek zorunda değilsiniz. Aynı anda iki gerçeği tutabilirsiniz.',
    relatedFocusAreas: ['mood', 'social'],
    relatedModuleIds: ['el_003', 'el_006'],
  ),
  ContextModule(
    id: 'el_006',
    category: ContextModuleCategory.emotionalLiteracy,
    depth: ContextModuleDepth.advanced,
    titleEn: 'Emotional Hangovers',
    titleTr: 'Duygusal Akşamdan Kalmalar',
    summaryEn:
        'Intense emotions from yesterday can linger into today, coloring your mood without a current trigger.',
    summaryTr:
        'Dünden kalan yoğun duygular bugüne sızarak mevcut bir tetikleyici olmadan ruh halinizi renklendirebilir.',
    bodyEn:
        'Neuroscience research shows that strong emotional experiences create residual activation patterns that can persist for 24-48 hours. A stressful argument on Monday evening can leave you feeling irritable on Tuesday morning, even if nothing went wrong. This is not weakness — it is your nervous system processing the event. Recognizing an emotional hangover prevents misattribution: you do not blame Tuesday for Monday feelings. Tracking your entries across consecutive days often reveals these carry-over patterns clearly.',
    bodyTr:
        'Nörobilim araştırmaları, güçlü duygusal deneyimlerin 24-48 saat boyunca devam edebilen artık aktivasyon örüntüleri yarattığını göstermektedir. Pazartesi akşamki stresli bir tartışma, hiçbir şey yanlış gitmese bile Salı sabahı sizi sinirli bırakabilir. Bu zayıflık değil — sinir sisteminizin olayı işlemesidir. Duygusal akşamdan kalmayı tanımak yanlış atıfı önler: Pazartesi duygularını Salı gününe yüklemezsiniz.',
    whyItMattersEn:
        'When you see a low-mood entry that lacks a clear trigger, check the previous day. Context from yesterday often explains today.',
    whyItMattersTr:
        'Net bir tetikleyicisi olmayan düşük ruh hali kaydı gördüğünüzde, önceki günü kontrol edin. Dünden gelen bağlam genellikle bugünü açıklar.',
    screenshotLineEn: 'Sometimes today\'s mood is just yesterday\'s unfinished processing.',
    screenshotLineTr: 'Bazen bugünün ruh hali sadece dünün tamamlanmamış işlemesidir.',
    relatedFocusAreas: ['mood', 'energy'],
    relatedModuleIds: ['el_004', 'pr_001'],
  ),

  // ═══════════════════════════════════════════════════════════════
  // MYTH VS REALITY — 6 modules (mr_001 – mr_006)
  // ═══════════════════════════════════════════════════════════════
  ContextModule(
    id: 'mr_001',
    category: ContextModuleCategory.mythVsReality,
    depth: ContextModuleDepth.beginner,
    titleEn: 'Myth: Positive Thinking Fixes Everything',
    titleTr: 'Mit: Pozitif Düşünce Her Şeyi Çözer',
    summaryEn:
        'Forced positivity can backfire. Genuine self-awareness includes acknowledging difficulty without drowning in it.',
    summaryTr:
        'Zorla pozitiflik geri tepebilir. Gerçek öz farkındalık, zorluğu içinde boğulmadan kabul etmeyi içerir.',
    bodyEn:
        'The "just think positive" advice sounds harmless, but research by psychologist Gabriele Oettingen shows that unrealistic optimism can actually decrease motivation and increase disappointment. What works better is a practice called "mental contrasting" — honestly acknowledging where you are now AND imagining where you want to be. This creates productive tension that drives action, rather than the passive hope that positive thinking alone offers. Your journal is a space for honesty, not performance.',
    bodyTr:
        '"Sadece pozitif düşün" tavsiyesi zararsız görünür, ancak psikolog Gabriele Oettingen araştırması gerçekçi olmayan iyimserliğin motivasyonu azaltabileceğini ve hayal kırıklığını artırabileceğini göstermektedir. Daha iyi çalışan şey "zihinsel karşılaştırma" pratiğidir — şu an nerede olduğunuzu dürüstçe kabul etmek VE olmak istediğiniz yeri hayal etmek. Bu, yalnızca pozitif düşüncenin sunduğu pasif umut yerine eylemi yönlendiren üretken gerilim yaratır.',
    whyItMattersEn:
        'Journaling works best when it is honest. Permission to write about difficulty is what makes growth entries possible later.',
    whyItMattersTr:
        'Günlük tutmak dürüst olduğunda en iyi şekilde çalışır. Zorluklar hakkında yazma izni, daha sonra büyüme kayıtlarını mümkün kılan şeydir.',
    screenshotLineEn: 'Honest journaling beats forced positivity every time.',
    screenshotLineTr: 'Dürüst günlük tutmak, zoraki pozitifliği her zaman yener.',
    relatedFocusAreas: ['mood', 'productivity'],
    relatedModuleIds: ['mr_002', 'el_005'],
  ),
  ContextModule(
    id: 'mr_002',
    category: ContextModuleCategory.mythVsReality,
    depth: ContextModuleDepth.beginner,
    titleEn: 'Myth: You Should Feel Happy Every Day',
    titleTr: 'Mit: Her Gün Mutlu Hissetmelisiniz',
    summaryEn:
        'The expectation of constant happiness creates suffering. Emotional variation is a sign of a healthy, responsive system.',
    summaryTr:
        'Sürekli mutluluk beklentisi acı yaratır. Duygusal çeşitlilik sağlıklı ve duyarlı bir sistemin işaretidir.',
    bodyEn:
        'Studies in positive psychology reveal that people who accept the full range of emotional experience — including sadness, frustration, and boredom — report higher overall life satisfaction than those who chase constant happiness. The reason is that emotional variety serves important functions: sadness deepens empathy, frustration signals needed change, and even boredom drives creativity. A mood tracker that shows variation is not broken. It is showing you a healthy emotional life.',
    bodyTr:
        'Pozitif psikoloji çalışmaları, üzüntü, hayal kırıklığı ve can sıkıntısı dahil tam duygusal deneyim yelpazesini kabul eden kişilerin sürekli mutluluk peşinde koşanlara göre daha yüksek genel yaşam memnuniyeti bildirdiğini ortaya koymaktadır. Bunun nedeni duygusal çeşitliliğin önemli işlevlere hizmet etmesidir: üzüntü empatiyi derinleştirir, hayal kırıklığı gerekli değişimi işaret eder ve can sıkıntısı bile yaratıcılığı yönlendirir.',
    whyItMattersEn:
        'When your mood chart shows ups and downs, that is not failure — it is the shape of a fully lived life.',
    whyItMattersTr:
        'Ruh hali grafiğiniz iniş çıkışlar gösterdiğinde, bu başarısızlık değil — tam yaşanmış bir hayatın şeklidir.',
    screenshotLineEn: 'Emotional variety is not instability. It is vitality.',
    screenshotLineTr: 'Duygusal çeşitlilik dengesizlik değil, canlılıktır.',
    relatedFocusAreas: ['mood'],
    relatedModuleIds: ['mr_001', 'el_005'],
  ),
  ContextModule(
    id: 'mr_003',
    category: ContextModuleCategory.mythVsReality,
    depth: ContextModuleDepth.intermediate,
    titleEn: 'Myth: Stress Is Always Harmful',
    titleTr: 'Mit: Stres Her Zaman Zararlıdır',
    summaryEn:
        'Your belief about stress matters as much as the stress itself. Reframing stress as a challenge response can change its physical effects.',
    summaryTr:
        'Stres hakkındaki inancınız, stresin kendisi kadar önemlidir. Stresi bir meydan okuma yanıtı olarak yeniden çerçevelemek fiziksel etkilerini değiştirebilir.',
    bodyEn:
        'Stanford psychologist Alia Crum found that people who view stress as enhancing — rather than debilitating — show different hormonal responses: more DHEA (which aids growth) and less cortisol. Health psychologist Kelly McGonigal demonstrated that the belief "stress is harmful" increased mortality risk by 43%, while stress itself did not. This does not mean you should seek out stress. It means that when stress arrives, how you frame it changes what it does to your body. Journaling about stressful events with a "what am I learning" lens activates this reframing naturally.',
    bodyTr:
        'Stanford psikoloğu Alia Crum, stresi zayıflatıcı yerine güçlendirici olarak gören kişilerin farklı hormonal yanıtlar gösterdiğini buldu: daha fazla DHEA (büyümeye yardımcı olan) ve daha az kortizol. Sağlık psikoloğu Kelly McGonigal, "stres zararlıdır" inancının ölüm riskini %43 artırdığını, stresin kendisinin artırmadığını gösterdi. Bu stres aramanız gerektiği anlamına gelmiyor. Stres geldiğinde onu nasıl çerçevelediğiniz, bedeninize ne yaptığını değiştirir.',
    whyItMattersEn:
        'Rewriting your stress narrative in your journal is not just venting — it is actively changing your physiological stress response.',
    whyItMattersTr:
        'Stres anlatınızı günlüğünüzde yeniden yazmak sadece dert dökmek değil — fizyolojik stres yanıtınızı aktif olarak değiştirmektir.',
    screenshotLineEn: 'Stress is not the enemy. Your story about stress might be.',
    screenshotLineTr: 'Stres düşman değil. Stres hakkındaki hikayeniz olabilir.',
    relatedFocusAreas: ['mood', 'energy', 'health'],
    relatedModuleIds: ['mr_004', 'el_001'],
  ),
  ContextModule(
    id: 'mr_004',
    category: ContextModuleCategory.mythVsReality,
    depth: ContextModuleDepth.intermediate,
    titleEn: 'Myth: Willpower Is Unlimited',
    titleTr: 'Mit: İrade Gücü Sınırsızdır',
    summaryEn:
        'Decision fatigue is real. Your ability to make good choices decreases throughout the day, which is why routines and environments matter.',
    summaryTr:
        'Karar yorgunluğu gerçektir. İyi seçimler yapma yeteneğiniz gün boyunca azalır, bu yüzden rutinler ve çevre önemlidir.',
    bodyEn:
        'Roy Baumeister\'s research on ego depletion — while debated in scope — revealed a practical truth: the more decisions you make, the worse later decisions become. A judge grants parole more often in the morning than afternoon. You reach for junk food after a mentally exhausting day. The insight for journaling is that tracking your energy alongside your choices reveals when you are in a depleted state. If your "worst" journal entries happen at night, it may not be a mood problem — it may be a timing problem.',
    bodyTr:
        'Roy Baumeister ego tükenmesi araştırması — kapsamı tartışılsa da — pratik bir gerçeği ortaya koydu: ne kadar çok karar verirseniz, sonraki kararlar o kadar kötüleşir. Bir hakim öğleden sonra yerine sabah daha sık şartlı tahliye verir. Zihinsel olarak yorucu bir günden sonra abur cubura uzanırsınız. Günlük tutma için içgörü, enerji seviyenizi seçimlerinizle birlikte takip etmenin tükenmiş bir durumda ne zaman olduğunuzu ortaya çıkarmasıdır.',
    whyItMattersEn:
        'Noticing your energy patterns helps you place important decisions — and journaling — at times when your mind is freshest.',
    whyItMattersTr:
        'Enerji örüntülerinizi fark etmek, önemli kararları ve günlük yazmayı zihninizin en taze olduğu zamanlara yerleştirmenize yardımcı olur.',
    screenshotLineEn: 'You do not lack willpower at 9 PM. You have spent it all by then.',
    screenshotLineTr: 'Akşam 9\'da irade gücünüz eksik değil. O zamana kadar hepsini harcamışsınızdır.',
    relatedFocusAreas: ['energy', 'productivity'],
    relatedModuleIds: ['mr_003', 'pr_003'],
  ),
  ContextModule(
    id: 'mr_005',
    category: ContextModuleCategory.mythVsReality,
    depth: ContextModuleDepth.advanced,
    titleEn: 'Myth: Personality Is Fixed',
    titleTr: 'Mit: Kişilik Sabittir',
    summaryEn:
        'Longitudinal research shows that personality traits shift meaningfully across a lifetime, especially with intentional effort.',
    summaryTr:
        'Uzunlamasına araştırmalar, kişilik özelliklerinin özellikle bilinçli çabayla yaşam boyunca anlamlı şekilde değiştiğini göstermektedir.',
    bodyEn:
        'The myth that personality is set in stone by age 25 has been thoroughly debunked. A meta-analysis of 92 longitudinal studies found that agreeableness, conscientiousness, and emotional stability all increase significantly between ages 20 and 60. More importantly, intentional interventions — like coaching, journaling, and deliberate practice — can accelerate these changes. Your journal is a record of who you are becoming, not a fixed description of who you are.',
    bodyTr:
        '25 yaşına kadar kişiliğin taşa oyulduğu efsanesi tamamen çürütülmüştür. 92 uzunlamasına çalışmanın meta analizi, uyumluluk, öz disiplin ve duygusal istikrarın 20-60 yaşları arasında önemli ölçüde arttığını buldu. Daha da önemlisi, koçluk, günlük tutma ve kasıtlı pratik gibi bilinçli müdahaleler bu değişiklikleri hızlandırabilir. Günlüğünüz kim olduğunuzun sabit bir açıklaması değil, kim olduğunuzun bir kaydıdır.',
    whyItMattersEn:
        'Looking back at journal entries from months ago often reveals growth you cannot see day-to-day.',
    whyItMattersTr:
        'Aylar önceki günlük kayıtlarına bakmak, günlük olarak göremediğiniz büyümeyi sıklıkla ortaya çıkarır.',
    screenshotLineEn: 'You are not the same person you were six months ago. Your journal proves it.',
    screenshotLineTr: 'Altı ay önceki aynı kişi değilsiniz. Günlüğünüz bunu kanıtlıyor.',
    relatedFocusAreas: ['mood', 'creativity'],
    relatedModuleIds: ['mr_002', 'sa_005'],
  ),
  ContextModule(
    id: 'mr_006',
    category: ContextModuleCategory.mythVsReality,
    depth: ContextModuleDepth.advanced,
    titleEn: 'Myth: Multitasking Makes You Productive',
    titleTr: 'Mit: Çoklu Görev Sizi Üretken Yapar',
    summaryEn:
        'What feels like multitasking is actually rapid task-switching, which reduces quality and increases stress.',
    summaryTr:
        'Çoklu görev gibi hissedilen şey aslında hızlı görev değiştirmedir, bu da kaliteyi düşürür ve stresi artırır.',
    bodyEn:
        'Neuroscience is clear: the human brain cannot truly perform two cognitive tasks simultaneously. What we call "multitasking" is actually rapid switching between tasks, and each switch costs 15-25 minutes of refocusing time. Research from the University of London found that multitasking during cognitive tasks reduces effective IQ by 10-15 points. When you journal about your productivity patterns, look for days where you attempted many things versus days where you focused deeply on fewer. The difference in satisfaction is often dramatic.',
    bodyTr:
        'Nörobilim açık: insan beyni gerçekten iki bilişsel görevi aynı anda yapamaz. "Çoklu görev" dediğimiz şey aslında görevler arasında hızlı geçiştir ve her geçiş 15-25 dakikalık yeniden odaklanma süresine mal olur. Londra Üniversitesi araştırması, bilişsel görevler sırasında çoklu görev yapmanın efektif IQ\'yu 10-15 puan düşürdüğünü buldu.',
    whyItMattersEn:
        'Tracking your focus patterns reveals that your most satisfying days usually involve depth, not breadth.',
    whyItMattersTr:
        'Odak örüntülerinizi takip etmek, en tatmin edici günlerinizin genellikle genişlik değil derinlik içerdiğini ortaya çıkarır.',
    screenshotLineEn: 'Depth beats breadth. Your best days prove it.',
    screenshotLineTr: 'Derinlik genişliği yener. En iyi günleriniz bunu kanıtlar.',
    relatedFocusAreas: ['productivity', 'energy'],
    relatedModuleIds: ['mr_004', 'pr_004'],
  ),

  // ═══════════════════════════════════════════════════════════════
  // PATTERN RECOGNITION — 6 modules (pr_001 – pr_006)
  // ═══════════════════════════════════════════════════════════════
  ContextModule(
    id: 'pr_001',
    category: ContextModuleCategory.patternRecognition,
    depth: ContextModuleDepth.beginner,
    titleEn: 'Weekly Emotional Rhythms',
    titleTr: 'Haftalık Duygusal Ritimler',
    summaryEn:
        'Most people have predictable emotional patterns across the week that they have never noticed.',
    summaryTr:
        'Çoğu insanın hafta boyunca hiç fark etmediği öngörülebilir duygusal örüntüleri vardır.',
    bodyEn:
        'Large-scale mood research using Twitter data from millions of users found that positive affect peaks on weekends and dips midweek, with Tuesday and Wednesday showing the lowest mood for most people. However, your personal pattern may differ entirely — and that is the point. By tracking your entries over several weeks, you begin to see YOUR rhythm. Maybe you feel creative on Thursdays. Maybe Sunday evenings bring anxiety. These are not problems to fix — they are patterns to work with. Schedule demanding tasks for your high-energy days. Protect your low days with gentler routines.',
    bodyTr:
        'Milyonlarca kullanıcının Twitter verilerini kullanan büyük ölçekli ruh hali araştırması, pozitif etkinin hafta sonları zirve yaptığını ve hafta ortasında düştüğünü, Salı ve Çarşamba gününün çoğu insan için en düşük ruh halini gösterdiğini buldu. Ancak kişisel örüntünüz tamamen farklı olabilir — ve mesele de bu. Birkaç hafta boyunca kayıtlarınızı takip ederek SİZİN ritminizi görmeye başlarsınız.',
    whyItMattersEn:
        'Knowing your weekly rhythm lets you plan ahead instead of being surprised by predictable dips.',
    whyItMattersTr:
        'Haftalık ritminizi bilmek, öngörülebilir düşüşlerden şaşırmak yerine önceden planlamanıza olanak tanır.',
    screenshotLineEn: 'Your week has a rhythm. Once you see it, you can work with it.',
    screenshotLineTr: 'Haftanızın bir ritmi var. Onu gördüğünüzde, onunla çalışabilirsiniz.',
    relatedFocusAreas: ['mood', 'energy', 'productivity'],
    relatedModuleIds: ['pr_002', 'cw_001'],
  ),
  ContextModule(
    id: 'pr_002',
    category: ContextModuleCategory.patternRecognition,
    depth: ContextModuleDepth.beginner,
    titleEn: 'The Sleep-Mood Connection',
    titleTr: 'Uyku-Ruh Hali Bağlantısı',
    summaryEn:
        'Sleep quality is the single strongest indicator of next-day mood, yet most people underestimate its impact.',
    summaryTr:
        'Uyku kalitesi ertesi gün ruh halinin en güçlü tek belirleyicisidir, ancak çoğu insan etkisini hafife alır.',
    bodyEn:
        'Matthew Walker\'s research at UC Berkeley demonstrates that even one night of poor sleep reduces the prefrontal cortex\'s ability to regulate the amygdala by up to 60%. This means you are literally less able to manage emotions after bad sleep — not because you are weak, but because the brain region responsible for regulation is offline. Tracking sleep quality alongside mood creates one of the most actionable patterns in personal data. Most people discover after 2-3 weeks of tracking that their "unexplained" bad moods correlate almost perfectly with poor sleep.',
    bodyTr:
        'UC Berkeley\'deki Matthew Walker araştırması, tek bir gece kötü uykunun bile prefrontal korteksin amigdalayı düzenleme yeteneğini %60\'a kadar azalttığını göstermektedir. Bu, kötü uykudan sonra duyguları yönetmede gerçekten daha az yetenekli olduğunuz anlamına gelir — zayıf olduğunuz için değil, düzenlemeden sorumlu beyin bölgesi çevrimdışı olduğu için. Uyku kalitesini ruh haliyle birlikte takip etmek, kişisel verilerdeki en eyleme geçirilebilir örüntülerden birini oluşturur.',
    whyItMattersEn:
        'When you see the sleep-mood correlation in your own data, protecting your sleep becomes a clear priority rather than a vague "should."',
    whyItMattersTr:
        'Kendi verilerinizde uyku-ruh hali korelasyonunu gördüğünüzde, uykunuzu korumak belirsiz bir "yapmalıyım" yerine net bir öncelik haline gelir.',
    screenshotLineEn: 'Bad sleep does not just make you tired. It makes emotions harder to manage.',
    screenshotLineTr: 'Kötü uyku sadece sizi yormaz. Duyguları yönetmeyi zorlaştırır.',
    relatedFocusAreas: ['health', 'mood', 'energy'],
    relatedModuleIds: ['pr_001', 'pr_003'],
  ),
  ContextModule(
    id: 'pr_003',
    category: ContextModuleCategory.patternRecognition,
    depth: ContextModuleDepth.intermediate,
    titleEn: 'Energy Windows',
    titleTr: 'Enerji Pencereleri',
    summaryEn:
        'Everyone has natural peak and trough energy periods throughout the day. Identifying yours transforms how you structure your time.',
    summaryTr:
        'Herkesin gün boyunca doğal zirve ve dip enerji dönemleri vardır. Kendinizinkini belirlemek zamanınızı yapılandırma şeklinizi dönüştürür.',
    bodyEn:
        'Daniel Pink\'s research on chronotype reveals that most people follow a peak-trough-rebound pattern throughout the day. For most, analytical ability peaks in the morning, dips in the early afternoon, and rebounds in the late afternoon — but night owls experience the reverse. Tracking your energy levels at different times of day for two weeks reveals your personal pattern. The insight is not to fight your chronotype but to align tasks with it: deep work during peaks, routine tasks during troughs, creative work during rebounds.',
    bodyTr:
        'Daniel Pink\'in kronotip araştırması, çoğu insanın gün boyunca bir zirve-dip-toparlanma örüntüsü izlediğini ortaya koymaktadır. Çoğu için analitik yetenek sabah zirve yapar, öğleden sonra erken saatlerde düşer ve öğleden sonra geç saatlerde toparlanır — ancak gece kuşları tam tersini yaşar. Enerji seviyenizi iki hafta boyunca günün farklı saatlerinde takip etmek kişisel örüntünüzü ortaya çıkarır.',
    whyItMattersEn:
        'Aligning your most demanding tasks with your peak energy windows can increase productivity without increasing effort.',
    whyItMattersTr:
        'En zorlu görevlerinizi zirve enerji pencerelerinizle hizalamak, çabayı artırmadan üretkenliği artırabilir.',
    screenshotLineEn: 'Work with your energy, not against it. Your body already knows the schedule.',
    screenshotLineTr: 'Enerjinizle çalışın, ona karşı değil. Bedeniniz programı zaten biliyor.',
    relatedFocusAreas: ['energy', 'productivity'],
    relatedModuleIds: ['pr_001', 'mr_004'],
  ),
  ContextModule(
    id: 'pr_004',
    category: ContextModuleCategory.patternRecognition,
    depth: ContextModuleDepth.intermediate,
    titleEn: 'Social Battery Patterns',
    titleTr: 'Sosyal Batarya Örüntüleri',
    summaryEn:
        'Your social energy is not random. Tracking which interactions drain versus recharge you reveals actionable patterns.',
    summaryTr:
        'Sosyal enerjiniz rastgele değildir. Hangi etkileşimlerin sizi tükettiğini ve hangilerinin şarj ettiğini takip etmek eyleme geçirilebilir örüntüler ortaya çıkarır.',
    bodyEn:
        'Introversion and extraversion are not binary — they are spectrums that shift based on context, relationship quality, and current energy levels. You might feel energized by a one-on-one coffee with a close friend but drained by the same duration of group socializing. Tracking social interactions alongside your energy and mood entries reveals your specific patterns: which people, settings, group sizes, and conversation types leave you feeling better or worse. This is not about avoiding people — it is about designing your social life intentionally.',
    bodyTr:
        'İçe dönüklük ve dışa dönüklük ikili değildir — bağlama, ilişki kalitesine ve mevcut enerji seviyelerine göre değişen spektrumlardır. Yakın bir arkadaşla birebir kahve içmekle enerji kazanabilir ancak aynı süre grup sosyalleşmesiyle tükenebilirsiniz. Sosyal etkileşimleri enerji ve ruh hali kayıtlarınızla birlikte takip etmek spesifik örüntülerinizi ortaya çıkarır.',
    whyItMattersEn:
        'Understanding your social battery helps you say yes to interactions that energize and set boundaries around ones that drain.',
    whyItMattersTr:
        'Sosyal bataryanızı anlamak, enerji veren etkileşimlere evet demenize ve tüketen etkileşimler etrafında sınırlar koymanıza yardımcı olur.',
    screenshotLineEn: 'Not all social time is equal. Track which interactions refuel you.',
    screenshotLineTr: 'Tüm sosyal zaman eşit değildir. Hangi etkileşimlerin sizi yeniden doldurduğunu takip edin.',
    relatedFocusAreas: ['social', 'energy'],
    relatedModuleIds: ['pr_003', 'sa_003'],
  ),
  ContextModule(
    id: 'pr_005',
    category: ContextModuleCategory.patternRecognition,
    depth: ContextModuleDepth.advanced,
    titleEn: 'Seasonal Emotional Shifts',
    titleTr: 'Mevsimsel Duygusal Değişimler',
    summaryEn:
        'Seasonal patterns in mood and energy affect most people to some degree, not just those with seasonal affective disorder.',
    summaryTr:
        'Ruh hali ve enerjideki mevsimsel örüntüler sadece mevsimsel duygulanım bozukluğu olanları değil, çoğu insanı bir dereceye kadar etkiler.',
    bodyEn:
        'Research shows that serotonin production varies with daylight exposure, melatonin cycles shift with season length, and vitamin D levels fluctuate throughout the year — all affecting mood and energy. A full year of mood tracking often reveals patterns invisible to monthly views: winter introspection, spring restlessness, summer sociability, autumn creativity. These are not universal — they are personal. But they are remarkably consistent year to year once you identify your own.',
    bodyTr:
        'Araştırmalar serotonin üretiminin gün ışığı maruziyetiyle değiştiğini, melatonin döngülerinin mevsim uzunluğuyla kaydığını ve D vitamini seviyelerinin yıl boyunca dalgalandığını göstermektedir — bunların hepsi ruh halini ve enerjiyi etkiler. Tam bir yıllık ruh hali takibi, aylık görünümlere görünmez olan örüntüleri sıklıkla ortaya çıkarır.',
    whyItMattersEn:
        'Long-term tracking transforms seasonal shifts from surprises into familiar phases you can prepare for.',
    whyItMattersTr:
        'Uzun vadeli takip, mevsimsel değişimleri sürprizlerden hazırlanabileceğiniz öngörülebilir fazlara dönüştürür.',
    screenshotLineEn: 'Your year has seasons too. Track long enough to see them.',
    screenshotLineTr: 'Yılınızın da mevsimleri var. Onları görecek kadar uzun takip edin.',
    relatedFocusAreas: ['mood', 'energy', 'health'],
    relatedModuleIds: ['pr_001', 'cw_002'],
  ),
  ContextModule(
    id: 'pr_006',
    category: ContextModuleCategory.patternRecognition,
    depth: ContextModuleDepth.advanced,
    titleEn: 'The Trigger-Response Gap',
    titleTr: 'Tetikleyici-Yanıt Boşluğu',
    summaryEn:
        'Between what happens to you and how you react, there is a gap. Journaling expands that gap, giving you more choice.',
    summaryTr:
        'Size olanlar ile nasıl tepki verdiğiniz arasında bir boşluk vardır. Günlük tutmak o boşluğu genişleterek size daha fazla seçenek sunar.',
    bodyEn:
        'Viktor Frankl wrote: "Between stimulus and response there is a space. In that space is our freedom and power to choose our response." Journaling is one of the most effective ways to expand this space. When you write about a triggering event after the fact, you naturally slow down and examine the sequence: what happened, what you felt, what you did, and what you could have done differently. Over time, this retrospective practice begins to appear in real-time — you start noticing the gap as it happens, giving you time to choose rather than react.',
    bodyTr:
        'Viktor Frankl yazdı: "Uyaran ile yanıt arasında bir alan vardır. O alanda yanıtımızı seçme özgürlüğümüz ve gücümüz yatar." Günlük tutmak bu alanı genişletmenin en etkili yollarından biridir. Tetikleyici bir olay hakkında sonradan yazdığınızda, doğal olarak yavaşlar ve diziyi incelersiniz: ne oldu, ne hissettiniz, ne yaptınız ve neyi farklı yapabilirdiniz.',
    whyItMattersEn:
        'Regular journaling about trigger-response sequences measurably increases the pause between stimulus and reaction.',
    whyItMattersTr:
        'Tetikleyici-yanıt dizileri hakkında düzenli günlük tutmak, uyaran ile tepki arasındaki duraklamayı ölçülebilir şekilde artırır.',
    screenshotLineEn: 'The pause between trigger and response is where growth lives.',
    screenshotLineTr: 'Tetikleyici ile yanıt arasındaki duraklama, büyümenin yaşadığı yerdir.',
    relatedFocusAreas: ['mood', 'social'],
    relatedModuleIds: ['el_001', 'sa_004'],
  ),

  // ═══════════════════════════════════════════════════════════════
  // SELF-AWARENESS — 6 modules (sa_001 – sa_006)
  // ═══════════════════════════════════════════════════════════════
  ContextModule(
    id: 'sa_001',
    category: ContextModuleCategory.selfAwareness,
    depth: ContextModuleDepth.beginner,
    titleEn: 'The Observer Self',
    titleTr: 'Gözlemci Benlik',
    summaryEn:
        'There is a part of you that can watch your own thoughts and emotions without getting caught up in them.',
    summaryTr:
        'Kendi düşüncelerinizi ve duygularınızı onlara kapılmadan izleyebilen bir parçanız var.',
    bodyEn:
        'Acceptance and Commitment Training (ACT) calls this the "observing self" — the perspective that notices you are thinking without becoming the thought. When you write "I feel anxious," something interesting happens: the part of you doing the writing is not anxious. It is observing anxiety. This distinction matters because it creates distance between you and your experience. You are not your mood. You are the one noticing your mood. Journaling naturally strengthens this observer perspective, which is why it consistently shows benefits in psychological research.',
    bodyTr:
        'Kabul ve Kararlılık Eğitimi (ACT) buna "gözlemleyen benlik" der — düşünce olmadan düşündüğünüzü fark eden bakış açısı. "Kaygılı hissediyorum" yazdığınızda ilginç bir şey olur: yazan parçanız kaygılı değildir. Kaygıyı gözlemlemektedir. Bu ayrım önemlidir çünkü siz ile deneyiminiz arasında mesafe yaratır. Siz ruh haliniz değilsiniz. Siz ruh halinizi fark edensiniz.',
    whyItMattersEn:
        'Strengthening the observer self through journaling helps you respond to difficult emotions with curiosity instead of panic.',
    whyItMattersTr:
        'Günlük tutma yoluyla gözlemci benliği güçlendirmek, zor duygulara panik yerine merakla yanıt vermenize yardımcı olur.',
    screenshotLineEn: 'You are not your mood. You are the one who notices it.',
    screenshotLineTr: 'Siz ruh haliniz değilsiniz. Siz onu fark edensiniz.',
    relatedFocusAreas: ['mood', 'spirituality'],
    relatedModuleIds: ['el_001', 'sa_002'],
  ),
  ContextModule(
    id: 'sa_002',
    category: ContextModuleCategory.selfAwareness,
    depth: ContextModuleDepth.beginner,
    titleEn: 'Values vs Goals',
    titleTr: 'Değerler ve Hedefler',
    summaryEn:
        'Goals can be completed and checked off. Values are directions you travel in continuously. Both matter, but values sustain you.',
    summaryTr:
        'Hedefler tamamlanabilir ve işaretlenebilir. Değerler sürekli olarak yolculuk ettiğiniz yönlerdir. İkisi de önemlidir, ancak değerler sizi sürdürür.',
    bodyEn:
        'A goal is "run a marathon." A value is "take care of my physical health." The difference matters because goals end — and when they do, people often feel lost. Values never end. They provide continuous direction regardless of whether any specific goal has been met or missed. When your journal entries consistently reflect dissatisfaction despite achieving goals, it often signals a values misalignment. You may be climbing a ladder leaned against the wrong wall. Periodic values reflection in journaling helps ensure your daily actions align with what actually matters to you.',
    bodyTr:
        'Hedef "maraton koşmak"tır. Değer "fiziksel sağlığıma özen göstermek"tir. Fark önemlidir çünkü hedefler biter — ve bittiğinde insanlar çoğu zaman kendilerini kaybolmuş hisseder. Değerler asla bitmez. Herhangi bir hedefin karşılanıp karşılanmadığından bağımsız olarak sürekli yön sağlar.',
    whyItMattersEn:
        'Journaling about what matters to you — not just what you did — keeps your compass calibrated over time.',
    whyItMattersTr:
        'Sadece ne yaptığınız hakkında değil, sizin için neyin önemli olduğu hakkında günlük tutmak pusulanızı zamanla kalibre tutar.',
    screenshotLineEn: 'Goals have finish lines. Values have horizons.',
    screenshotLineTr: 'Hedeflerin bitiş çizgileri var. Değerlerin ufukları var.',
    relatedFocusAreas: ['productivity', 'spirituality'],
    relatedModuleIds: ['sa_001', 'sa_003'],
  ),
  ContextModule(
    id: 'sa_003',
    category: ContextModuleCategory.selfAwareness,
    depth: ContextModuleDepth.intermediate,
    titleEn: 'Your Inner Critic vs Inner Mentor',
    titleTr: 'İç Eleştirmeniniz ve İç Akıl Hocanız',
    summaryEn:
        'Most people have a loud inner critic and a quiet inner mentor. Journaling can help rebalance which voice you hear.',
    summaryTr:
        'Çoğu insanın sesli bir iç eleştirmeni ve sessiz bir iç akıl hocası vardır. Günlük tutmak hangi sesi duyduğunuzu yeniden dengelemeye yardımcı olabilir.',
    bodyEn:
        'The inner critic speaks in absolutes: "You always fail. You are not good enough. You should have known better." The inner mentor speaks in nuance: "That was hard, and you are learning. What would you do differently next time?" Psychologist Kristin Neff\'s research on self-compassion shows that the mentor voice — not the critic — produces better outcomes: more motivation, more resilience, more willingness to try again. A journaling technique: after writing a self-critical passage, pause and rewrite it from the perspective of a wise, caring friend. This is not about ignoring problems — it is about addressing them without self-destruction.',
    bodyTr:
        'İç eleştirmen mutlaklar kullanır: "Her zaman başarısız olursun. Yeterince iyi değilsin." İç akıl hocası nüanslarla konuşur: "Bu zordu ve öğreniyorsun. Bir dahaki sefere neyi farklı yapardın?" Psikolog Kristin Neff öz-şefkat araştırması, eleştirmen değil akıl hocası sesinin daha iyi sonuçlar ürettiğini göstermektedir.',
    whyItMattersEn:
        'Self-compassion in journaling is not softness. Research shows it produces more accountability than self-criticism.',
    whyItMattersTr:
        'Günlükte öz-şefkat yumuşaklık değildir. Araştırmalar, öz-eleştiriden daha fazla hesap verebilirlik ürettiğini göstermektedir.',
    screenshotLineEn: 'Talk to yourself like someone you are responsible for helping.',
    screenshotLineTr: 'Kendinizle, yardım etmekten sorumlu olduğunuz biri gibi konuşun.',
    relatedFocusAreas: ['mood', 'social'],
    relatedModuleIds: ['sa_001', 'el_005'],
  ),
  ContextModule(
    id: 'sa_004',
    category: ContextModuleCategory.selfAwareness,
    depth: ContextModuleDepth.intermediate,
    titleEn: 'Cognitive Distortions to Watch For',
    titleTr: 'Dikkat Edilmesi Gereken Bilişsel Çarpıtmalar',
    summaryEn:
        'Your brain has common thinking traps. Recognizing them in your journal entries is the first step to freedom.',
    summaryTr:
        'Beyninizin öngörülebilir düşünce tuzakları vardır. Onları günlük kayıtlarınızda tanımak özgürlüğe giden ilk adımdır.',
    bodyEn:
        'Cognitive behavioral research identifies common thinking patterns that distort reality: all-or-nothing thinking ("If it is not perfect, it is a failure"), catastrophizing ("This mistake will ruin everything"), mind-reading ("They probably think I am incompetent"), and emotional reasoning ("I feel stupid, so I must be stupid"). These are not character flaws — they are default brain shortcuts that everyone uses. The power of journaling is that these distortions become visible on the page. When you read back "everything went wrong today," you can ask: did literally everything go wrong, or are you filtering?',
    bodyTr:
        'Bilişsel davranışçı araştırmalar, gerçeği çarpıtan yaygın düşünce kalıplarını tanımlar: ya hep ya hiç düşüncesi, felaketleştirme, zihin okuma ve duygusal muhakeme. Bunlar karakter kusurları değil — herkesin kullandığı varsayılan beyin kısayollarıdır. Günlük tutmanın gücü, bu çarpıtmaların sayfada görünür hale gelmesidir.',
    whyItMattersEn:
        'Spotting distortions in your own writing trains your brain to catch them in real-time. This is the core mechanism of CBT.',
    whyItMattersTr:
        'Kendi yazınızdaki çarpıtmaları fark etmek beyninizi onları gerçek zamanlı yakalaması için eğitir. Bu, BDT\'nin temel mekanizmasıdır.',
    screenshotLineEn: 'Your brain has thinking shortcuts that sometimes lie. Learn to spot them.',
    screenshotLineTr: 'Beyninizin bazen yalan söyleyen düşünce kısayolları var. Onları fark etmeyi öğrenin.',
    relatedFocusAreas: ['mood', 'productivity'],
    relatedModuleIds: ['sa_003', 'pr_006'],
  ),
  ContextModule(
    id: 'sa_005',
    category: ContextModuleCategory.selfAwareness,
    depth: ContextModuleDepth.advanced,
    titleEn: 'The Narrative Identity',
    titleTr: 'Anlatısal Kimlik',
    summaryEn:
        'The story you tell about your life shapes your identity more than the events themselves. Journaling lets you become the author.',
    summaryTr:
        'Hayatınız hakkında anlattığınız hikaye, kimliğinizi olayların kendisinden daha fazla şekillendirir. Günlük tutmak sizi yazar yapmanızı sağlar.',
    bodyEn:
        'Psychologist Dan McAdams pioneered narrative identity research, showing that the stories we construct about our lives — not the raw events — determine our sense of meaning and well-being. Two people can experience identical setbacks, but one frames it as "a chapter where I grew" while the other frames it as "proof that life is unfair." Both narratives are valid, but they produce vastly different psychological outcomes. Journaling gives you editorial power over your own narrative. When you write about experiences, you are not just recording — you are actively constructing the story of who you are.',
    bodyTr:
        'Psikolog Dan McAdams, hayatlarımız hakkında inşa ettiğimiz hikayelerin — ham olayların değil — anlam ve iyi oluş duygumumuzu belirlediğini gösteren anlatısal kimlik araştırmasına öncülük etti. İki kişi aynı aksilikleri yaşayabilir, ancak biri bunu "büyüdüğüm bir bölüm" olarak çerçevelerken diğeri "hayatın adaletsiz olduğunun kanıtı" olarak çerçeveler.',
    whyItMattersEn:
        'Your journal is not a passive record. It is where you actively shape the story of your life.',
    whyItMattersTr:
        'Günlüğünüz pasif bir kayıt değildir. Hayat hikayenizi aktif olarak şekillendirdiğiniz yerdir.',
    screenshotLineEn: 'You are not just recording your life. You are writing it.',
    screenshotLineTr: 'Hayatınızı sadece kaydetmiyorsunuz. Onu yazıyorsunuz.',
    relatedFocusAreas: ['mood', 'creativity', 'spirituality'],
    relatedModuleIds: ['sa_001', 'mr_005'],
  ),
  ContextModule(
    id: 'sa_006',
    category: ContextModuleCategory.selfAwareness,
    depth: ContextModuleDepth.advanced,
    titleEn: 'Blind Spots and Projection',
    titleTr: 'Kör Noktalar ve Yansıtma',
    summaryEn:
        'What irritates you most in others often reveals something unexamined in yourself. This is not a flaw — it is useful data.',
    summaryTr:
        'Başkalarında sizi en çok rahatsız eden şey, genellikle kendinizde incelenmemiş bir şeyi ortaya koyar. Bu bir kusur değil — kullanışlı veridir.',
    bodyEn:
        'Carl Jung called it the "shadow" — the parts of ourselves we deny or disown that we then project onto others. When someone\'s behavior triggers disproportionate irritation, it is worth asking: "Is this touching something in me?" This is not about excusing poor behavior from others. It is about using your emotional reactions as a mirror. Journal entries that describe strong negative reactions to others are goldmines for self-discovery. The question "What does this person represent that I am uncomfortable with in myself?" often produces breakthrough insights.',
    bodyTr:
        'Carl Jung buna "gölge" dedi — inkar ettiğimiz veya sahiplenmediğimiz, sonra başkalarına yansıttığımız parçalarımız. Birinin davranışı orantısız tahriş tetiklediğinde, sormaya değer: "Bu bende bir şeye mi dokunuyor?" Bu başkalarından gelen kötü davranışı mazur görmekle ilgili değil. Duygusal tepkilerinizi ayna olarak kullanmakla ilgili.',
    whyItMattersEn:
        'Regular reflection on projections is one of the fastest paths to genuine self-knowledge.',
    whyItMattersTr:
        'Yansıtmalar üzerine düzenli düşünme, gerçek öz bilgiye giden en hızlı yollardan biridir.',
    screenshotLineEn: 'What bothers you about others is often a message about yourself.',
    screenshotLineTr: 'Başkalarında sizi rahatsız eden şey, genellikle kendinizle ilgili bir mesajdır.',
    relatedFocusAreas: ['social', 'mood'],
    relatedModuleIds: ['sa_004', 'el_001'],
  ),

  // ═══════════════════════════════════════════════════════════════
  // CYCLICAL WELLNESS — 6 modules (cw_001 – cw_006)
  // ═══════════════════════════════════════════════════════════════
  ContextModule(
    id: 'cw_001',
    category: ContextModuleCategory.cyclicalWellness,
    depth: ContextModuleDepth.beginner,
    titleEn: 'Life Moves in Cycles',
    titleTr: 'Hayat Döngüler Halinde Hareket Eder',
    summaryEn:
        'Growth is not linear. Periods of expansion naturally alternate with periods of rest, reflection, and consolidation.',
    summaryTr:
        'Büyüme doğrusal değildir. Genişleme dönemleri doğal olarak dinlenme, yansıtma ve pekiştirme dönemleriyle değişir.',
    bodyEn:
        'Nature runs on cycles: seasons, tides, circadian rhythms, sleep stages. Human emotional life follows the same principle. You will have periods of high energy, creativity, and social engagement — followed by periods where you need solitude, rest, and inner processing. The problem is that modern culture treats the "up" phase as normal and the "down" phase as a problem to fix. Both are essential. A farmer does not panic when winter comes — they know spring follows. Your emotional cycles work the same way. Tracking them over time helps you stop fighting the current phase and start working with it.',
    bodyTr:
        'Doğa döngülerle çalışır: mevsimler, gelgitler, sirkadiyen ritimler, uyku aşamaları. İnsan duygusal hayatı aynı prensibi izler. Yüksek enerji, yaratıcılık ve sosyal katılım dönemleriniz olacak — ardından yalnızlık, dinlenme ve iç işleme ihtiyacı duyduğunuz dönemler gelecek. Sorun şu ki modern kültür "yukarı" fazı normal, "aşağı" fazı düzeltilmesi gereken bir sorun olarak ele alır. Her ikisi de esastır.',
    whyItMattersEn:
        'InnerCycles is built on this principle: when you see your emotional life as cyclical rather than linear, low periods lose their power to frighten.',
    whyItMattersTr:
        'InnerCycles bu prensip üzerine kurulmuştur: duygusal hayatınızı doğrusal yerine döngüsel olarak gördüğünüzde, düşük dönemler korkutma güçlerini kaybeder.',
    screenshotLineEn: 'Growth is not a straight line up. It spirals.',
    screenshotLineTr: 'Büyüme düz bir çizgi değildir. Spiral çizer.',
    relatedFocusAreas: ['mood', 'energy', 'spirituality'],
    relatedModuleIds: ['cw_002', 'pr_005'],
  ),
  ContextModule(
    id: 'cw_002',
    category: ContextModuleCategory.cyclicalWellness,
    depth: ContextModuleDepth.beginner,
    titleEn: 'Rest Is Not Laziness',
    titleTr: 'Dinlenme Tembellik Değildir',
    summaryEn:
        'Deliberate rest is an active investment in your capacity, not a failure of productivity.',
    summaryTr:
        'Bilinçli dinlenme, kapasitenize yapılan aktif bir yatırımdır, üretkenlik başarısızlığı değildir.',
    bodyEn:
        'Alex Soojung-Kim Pang\'s research on deliberate rest shows that history\'s most productive minds — Darwin, Dickens, mathematicians, scientists — worked intensely for about 4 hours a day, then rested deliberately. The rest was not wasted time — it was when the subconscious mind consolidated learning, made creative connections, and prepared for the next cycle of deep work. When your journal entries show guilt about rest days, this context reframes them: rest is the other half of the productivity cycle, not its opposite.',
    bodyTr:
        'Alex Soojung-Kim Pang\'ın bilinçli dinlenme araştırması, tarihin en üretken zihinlerinin — Darwin, Dickens, matematikçiler, bilim insanları — günde yaklaşık 4 saat yoğun çalıştığını, ardından bilinçli olarak dinlendiğini göstermektedir. Dinlenme boşa harcanan zaman değildi — bilinçaltı zihnin öğrenmeyi pekiştirdiği, yaratıcı bağlantılar kurduğu ve bir sonraki derin çalışma döngüsüne hazırlandığı zamandı.',
    whyItMattersEn:
        'Tracking your rest-to-productivity ratio often reveals that your most creative days follow deliberate rest, not grind.',
    whyItMattersTr:
        'Dinlenme-üretkenlik oranınızı takip etmek, en yaratıcı günlerinizin didinmeyi değil bilinçli dinlenmeyi takip ettiğini sıklıkla ortaya çıkarır.',
    screenshotLineEn: 'Rest is not the opposite of productivity. It is the other half.',
    screenshotLineTr: 'Dinlenme üretkenliğin tersi değildir. Diğer yarısıdır.',
    relatedFocusAreas: ['energy', 'productivity', 'health'],
    relatedModuleIds: ['cw_001', 'cw_003'],
  ),
  ContextModule(
    id: 'cw_003',
    category: ContextModuleCategory.cyclicalWellness,
    depth: ContextModuleDepth.intermediate,
    titleEn: 'The Renewal Cycle',
    titleTr: 'Yenilenme Döngüsü',
    summaryEn:
        'Every growth phase follows a pattern: challenge, struggle, adaptation, and integration. Recognizing where you are in the cycle reduces suffering.',
    summaryTr:
        'Her büyüme fazı bir örüntü izler: meydan okuma, mücadele, adaptasyon ve entegrasyon. Döngüde nerede olduğunuzu tanımak acıyı azaltır.',
    bodyEn:
        'The renewal cycle appears in athletic training (stress, recovery, supercompensation), learning science (confusion, practice, mastery), and emotional growth (disruption, processing, integration). When you are in the struggle phase, it feels like failure — but it is actually the most critical part of the cycle. Without struggle, there is no adaptation. Journal entries from struggle phases often look dark and frustrated. But when viewed in context of the full cycle, they reveal the exact moment growth was happening. Labeling your current phase helps: "I am in the struggle phase" is more bearable than "something is wrong with me."',
    bodyTr:
        'Yenilenme döngüsü atletik antrenmanda (stres, toparlanma, süperkompanzasyon), öğrenme biliminde (kafa karışıklığı, pratik, ustalık) ve duygusal büyümede (bozulma, işleme, entegrasyon) görülür. Mücadele fazındayken başarısızlık gibi hisseder — ancak aslında döngünün en kritik parçasıdır. Mücadele olmadan adaptasyon olmaz.',
    whyItMattersEn:
        'Naming your current phase of the cycle removes the anxiety of not knowing where you are in the process.',
    whyItMattersTr:
        'Mevcut döngü fazınızı adlandırmak, süreçte nerede olduğunuzu bilmemenin kaygısını ortadan kaldırır.',
    screenshotLineEn: 'Struggle is not failure. It is the growth phase in disguise.',
    screenshotLineTr: 'Mücadele başarısızlık değildir. Kılık değiştirmiş büyüme fazıdır.',
    relatedFocusAreas: ['mood', 'energy', 'productivity'],
    relatedModuleIds: ['cw_001', 'cw_004'],
  ),
  ContextModule(
    id: 'cw_004',
    category: ContextModuleCategory.cyclicalWellness,
    depth: ContextModuleDepth.intermediate,
    titleEn: 'Micro-Cycles Within Your Day',
    titleTr: 'Gün İçi Mikro Döngüler',
    summaryEn:
        'Your attention and energy cycle in 90-minute waves throughout the day. Working with these ultradian rhythms prevents burnout.',
    summaryTr:
        'Dikkatiniz ve enerjiniz gün boyunca 90 dakikalık dalgalar halinde döner. Bu ultradian ritimlerle çalışmak tükenmişliği önler.',
    bodyEn:
        'Sleep researcher Nathaniel Kleitman discovered that the 90-minute sleep cycles continue during waking hours as "ultradian rhythms." Your brain naturally cycles between higher and lower alertness approximately every 90 minutes. After 90 minutes of focused work, your body sends signals: yawning, fidgeting, difficulty concentrating, hunger. Most people override these signals with caffeine or willpower. Instead, taking a 15-20 minute break at these natural pause points — moving, hydrating, looking at a distance — allows the next 90-minute cycle to start fresh.',
    bodyTr:
        'Uyku araştırmacısı Nathaniel Kleitman, 90 dakikalık uyku döngülerinin uyanık saatlerde "ultradian ritimler" olarak devam ettiğini keşfetti. Beyniniz yaklaşık her 90 dakikada bir doğal olarak daha yüksek ve daha düşük uyanıklık arasında döner. 90 dakikalık odaklanmış çalışmadan sonra bedeniniz sinyaller gönderir: esneme, kıpırdanma, konsantre olmada zorluk.',
    whyItMattersEn:
        'Tracking your productivity in 90-minute blocks often reveals that forced long sessions produce less than rhythmic work-rest cycles.',
    whyItMattersTr:
        'Üretkenliğinizi 90 dakikalık bloklarda takip etmek, zorla uzun seansların ritmik çalışma-dinlenme döngülerinden daha az ürettiğini sıklıkla ortaya çıkarır.',
    screenshotLineEn: 'Your brain works in 90-minute waves. Ride them, do not fight them.',
    screenshotLineTr: 'Beyniniz 90 dakikalık dalgalar halinde çalışır. Onlara binin, onlarla savaşmayın.',
    relatedFocusAreas: ['energy', 'productivity'],
    relatedModuleIds: ['pr_003', 'cw_002'],
  ),
  ContextModule(
    id: 'cw_005',
    category: ContextModuleCategory.cyclicalWellness,
    depth: ContextModuleDepth.advanced,
    titleEn: 'Emotional Seasons of Life',
    titleTr: 'Hayatın Duygusal Mevsimleri',
    summaryEn:
        'Beyond daily and weekly cycles, life itself has larger emotional seasons that last months or years.',
    summaryTr:
        'Günlük ve haftalık döngülerin ötesinde, hayatın kendisinin aylar veya yıllar süren daha büyük duygusal mevsimleri vardır.',
    bodyEn:
        'Developmental psychologists describe life transitions — career changes, relationship shifts, identity questioning — as "liminal periods." These are neither the old life nor the new one, but the uncomfortable space between. These emotional seasons can last months and feel like something is wrong. Nothing is wrong. You are between chapters. The courage to stay in the discomfort of transition, rather than rushing to resolve it, often leads to more authentic outcomes. Long-term journaling captures these transitions beautifully — you can see in retrospect what was invisible while living through it.',
    bodyTr:
        'Gelişim psikologları hayat geçişlerini — kariyer değişiklikleri, ilişki kaymaları, kimlik sorgulaması — "eşik dönemleri" olarak tanımlar. Bunlar ne eski hayat ne de yeni hayattır, aralarındaki rahatsız edici alandır. Bu duygusal mevsimler aylarca sürebilir ve bir şeylerin yanlış olduğunu hissettirebilir. Hiçbir şey yanlış değil. Bölümler arasındasınız.',
    whyItMattersEn:
        'Recognizing that you are in a life season — not having a bad month — transforms how you relate to the experience.',
    whyItMattersTr:
        'Kötü bir ay geçirmediğinizi, bir hayat mevsiminde olduğunuzu tanımak, deneyimle ilişkinizi dönüştürür.',
    screenshotLineEn: 'You are not lost. You are between chapters.',
    screenshotLineTr: 'Kaybolmuş değilsiniz. Bölümler arasındasınız.',
    relatedFocusAreas: ['mood', 'spirituality'],
    relatedModuleIds: ['cw_001', 'pr_005'],
  ),
  ContextModule(
    id: 'cw_006',
    category: ContextModuleCategory.cyclicalWellness,
    depth: ContextModuleDepth.advanced,
    titleEn: 'The Integration Phase',
    titleTr: 'Entegrasyon Fazı',
    summaryEn:
        'After intense experiences — positive or negative — your mind needs time to integrate what happened. This quiet phase is productive.',
    summaryTr:
        'Yoğun deneyimlerden sonra — olumlu veya olumsuz — zihninizin olanları entegre etmek için zamana ihtiyacı vardır. Bu sessiz faz üretkendir.',
    bodyEn:
        'After a big project completion, a significant life event, or an emotional breakthrough, many people feel unexpectedly flat. This is not depression — it is integration. Your brain is reorganizing neural pathways, updating your mental models, and filing new experiences into long-term memory. This process requires low stimulation and feels like "nothing is happening." But it is actually one of the most productive phases of the cycle. Journaling during integration often produces the deepest insights because the conscious mind is quiet enough to hear the subconscious processing.',
    bodyTr:
        'Büyük bir proje tamamlaması, önemli bir yaşam olayı veya duygusal bir atılımdan sonra birçok kişi beklenmedik şekilde düz hisseder. Bu depresyon değildir — entegrasyondur. Beyniniz sinir yollarını yeniden organize ediyor, zihinsel modellerinizi güncelliyor ve yeni deneyimleri uzun süreli belleğe yerleştiriyor.',
    whyItMattersEn:
        'When your journal shows a "quiet" phase after intensity, trust the process. Your mind is building something.',
    whyItMattersTr:
        'Günlüğünüz yoğunluktan sonra "sessiz" bir faz gösterdiğinde, sürece güvenin. Zihniniz bir şeyler inşa ediyor.',
    screenshotLineEn: 'Feeling flat after intensity is not failure. It is integration.',
    screenshotLineTr: 'Yoğunluktan sonra düz hissetmek başarısızlık değil, entegrasyondur.',
    relatedFocusAreas: ['mood', 'energy', 'creativity'],
    relatedModuleIds: ['cw_003', 'cw_005'],
  ),

  // ═══════════════════════════════════════════════════════════════
  // JOURNAL SCIENCE — 6 modules (js_001 – js_006)
  // ═══════════════════════════════════════════════════════════════
  ContextModule(
    id: 'js_001',
    category: ContextModuleCategory.journalScience,
    depth: ContextModuleDepth.beginner,
    titleEn: 'Why Writing Heals',
    titleTr: 'Yazmanın Neden İyileştirdiği',
    summaryEn:
        'Expressive writing has over 200 published studies showing measurable benefits for physical and mental health.',
    summaryTr:
        'İfade edici yazmanın fiziksel ve zihinsel sağlık için ölçülebilir faydalar gösteren 200\'den fazla yayınlanmış çalışması vardır.',
    bodyEn:
        'James Pennebaker\'s landmark research at the University of Texas found that writing about emotional experiences for just 15-20 minutes over 3-4 days produced measurable improvements in immune function, blood pressure, liver function, and psychological well-being. The mechanism appears to be cognitive: writing forces you to organize chaotic emotional experience into a coherent narrative, which reduces the cognitive load of carrying unprocessed emotions. Your brain no longer needs to keep working on the problem because writing has done the processing work.',
    bodyTr:
        'James Pennebaker\'ın Teksas Üniversitesi\'ndeki dönüm noktası araştırması, 3-4 gün boyunca günde sadece 15-20 dakika duygusal deneyimler hakkında yazmanın bağışıklık fonksiyonu, kan basıncı, karaciğer fonksiyonu ve psikolojik iyi oluşta ölçülebilir iyileşmeler ürettiğini buldu. Mekanizma bilişsel görünmektedir: yazma sizi kaotik duygusal deneyimi tutarlı bir anlatıya düzenlemeye zorlar.',
    whyItMattersEn:
        'Your daily journal practice is not just self-reflection — it is one of the most evidence-backed wellness practices available.',
    whyItMattersTr:
        'Günlük günlük tutma pratiğiniz sadece öz yansıtma değil — mevcut en kanıt destekli sağlıklı yaşam pratiklerinden biridir.',
    screenshotLineEn: 'Writing about emotions is not venting. It is the brain processing what happened.',
    screenshotLineTr: 'Duygular hakkında yazmak dert dökmek değil. Beyinin olanları işlemesidir.',
    relatedFocusAreas: ['mood', 'health'],
    relatedModuleIds: ['js_002', 'js_003'],
  ),
  ContextModule(
    id: 'js_002',
    category: ContextModuleCategory.journalScience,
    depth: ContextModuleDepth.beginner,
    titleEn: 'The 15-Minute Sweet Spot',
    titleTr: '15 Dakika Tatlı Noktası',
    summaryEn:
        'Research shows that most journaling benefits occur within the first 15-20 minutes. Longer is not necessarily better.',
    summaryTr:
        'Araştırmalar, günlük tutma faydalarının çoğunun ilk 15-20 dakikada oluştuğunu göstermektedir. Daha uzun zorunlu olarak daha iyi değildir.',
    bodyEn:
        'Pennebaker\'s studies found that 15-20 minutes of focused writing produces the majority of benefits. Writing for much longer can actually become counterproductive, as rumination replaces processing. The key is depth, not duration — writing that engages with both facts and feelings is more effective than lengthy descriptions of events alone. If you have 5 minutes, write for 5 minutes. If you have 20, use 20. Consistency matters far more than length. A daily 5-minute practice will serve you better than an occasional 60-minute session.',
    bodyTr:
        'Pennebaker çalışmaları, 15-20 dakikalık odaklanmış yazmanın faydaların çoğunu ürettiğini buldu. Çok daha uzun yazmak aslında verimsiz hale gelebilir, çünkü ruminasyon işlemenin yerini alır. Anahtar süre değil derinliktir — hem gerçekler hem de duygularla meşgul olan yazı, yalnızca olayların uzun açıklamalarından daha etkilidir. 5 dakikanız varsa, 5 dakika yazın. 20 dakikanız varsa 20 kullanın.',
    whyItMattersEn:
        'Permission to write briefly removes the perfectionism that stops many people from journaling consistently.',
    whyItMattersTr:
        'Kısa yazma izni, birçok insanın tutarlı bir şekilde günlük tutmasını engelleyen mükemmeliyetçiliği ortadan kaldırır.',
    screenshotLineEn: '5 minutes of honest writing beats 60 minutes of avoidance.',
    screenshotLineTr: '5 dakika dürüst yazma, 60 dakika kaçınmayı yener.',
    relatedFocusAreas: ['mood', 'productivity'],
    relatedModuleIds: ['js_001', 'js_004'],
  ),
  ContextModule(
    id: 'js_003',
    category: ContextModuleCategory.journalScience,
    depth: ContextModuleDepth.intermediate,
    titleEn: 'The Name-It-to-Tame-It Effect',
    titleTr: 'Adlandır ve Evcilleştir Etkisi',
    summaryEn:
        'Putting feelings into words reduces their intensity through a well-documented neurological mechanism.',
    summaryTr:
        'Duyguları kelimelere dökmek, iyi belgelenmiş bir nörolojik mekanizma aracılığıyla yoğunluklarını azaltır.',
    bodyEn:
        'UCLA researcher Matthew Lieberman discovered that labeling an emotion activates the right ventrolateral prefrontal cortex, which in turn reduces activity in the amygdala — the brain\'s alarm system. This effect, called "affect labeling," works even when people do not intend to regulate their emotions. Simply writing "I feel frustrated because..." begins the regulation process automatically. This is why journaling about difficult emotions often produces relief before you have "solved" anything. The act of articulating the feeling IS the intervention.',
    bodyTr:
        'UCLA araştırmacısı Matthew Lieberman, bir duyguyu etiketlemenin sağ ventrolateral prefrontal korteksi aktive ettiğini ve bunun da beyinin alarm sistemi olan amigdaladaki aktiviteyi azalttığını keşfetti. "Etki etiketleme" adı verilen bu etki, insanlar duygularını düzenleme niyetinde olmasalar bile çalışır. Sadece "Hayal kırıklığına uğradım çünkü..." yazmak düzenleme sürecini otomatik olarak başlatır.',
    whyItMattersEn:
        'Every time you name an emotion in your journal, your brain is literally calming itself down. Writing is not a metaphor for processing — it IS processing.',
    whyItMattersTr:
        'Günlüğünüzde bir duyguyu her adlandırdığınızda, beyniniz kelimenin tam anlamıyla kendini sakinleştirmektedir. Yazma, işlemenin metaforu değildir — işlemenin kendisidir.',
    screenshotLineEn: 'Naming an emotion literally calms the brain. This is neuroscience, not poetry.',
    screenshotLineTr: 'Bir duyguyu adlandırmak kelimenin tam anlamıyla beyni sakinleştirir. Bu nörobilim, şiir değil.',
    relatedFocusAreas: ['mood'],
    relatedModuleIds: ['el_003', 'js_001'],
  ),
  ContextModule(
    id: 'js_004',
    category: ContextModuleCategory.journalScience,
    depth: ContextModuleDepth.intermediate,
    titleEn: 'Gratitude Journaling: What Actually Works',
    titleTr: 'Şükran Günlüğü: Gerçekten Ne İşe Yarar',
    summaryEn:
        'Gratitude practice has real benefits — but only when done with specificity and genuine feeling, not as a rote checklist.',
    summaryTr:
        'Şükran pratiğinin gerçek faydaları vardır — ancak yalnızca belirginlik ve gerçek duyguyla yapıldığında, mekanik bir kontrol listesi olarak değil.',
    bodyEn:
        'Robert Emmons\' research shows that gratitude journaling increases well-being, but with important nuances: writing three specific things you are grateful for once per week is more effective than daily lists. Why? Daily practice risks becoming mechanical. The key is novelty and specificity — "I am grateful for the way my friend listened without trying to fix anything when I talked about my stress yesterday" works. "I am grateful for my family" becomes background noise after the third time. Depth over frequency. Specificity over generality.',
    bodyTr:
        'Robert Emmons araştırması, şükran günlüğünün iyi oluşu artırdığını, ancak önemli nüanslarla göstermektedir: haftada bir kez minnettar olduğunuz üç spesifik şeyi yazmak, günlük listelerden daha etkilidir. Neden? Günlük pratik mekanik hale gelme riskini taşır. Anahtar yenilik ve özgünlüktür.',
    whyItMattersEn:
        'Quality gratitude practice means fewer but deeper entries. Once a week, done well, outperforms daily, done mindlessly.',
    whyItMattersTr:
        'Kaliteli şükran pratiği daha az ama daha derin kayıtlar anlamına gelir. Haftada bir, iyi yapılmış, her gün dikkatsizce yapılmışı geçer.',
    screenshotLineEn: 'Gratitude works when it is specific. "I am grateful for my life" is too vague to feel.',
    screenshotLineTr: 'Şükran spesifik olduğunda işe yarar. "Hayatım için minnettarım" hissetmek için çok belirsiz.',
    relatedFocusAreas: ['mood', 'social', 'spirituality'],
    relatedModuleIds: ['js_002', 'js_005'],
  ),
  ContextModule(
    id: 'js_005',
    category: ContextModuleCategory.journalScience,
    depth: ContextModuleDepth.advanced,
    titleEn: 'Narrative Coherence and Healing',
    titleTr: 'Anlatısal Tutarlılık ve İyileşme',
    summaryEn:
        'The more coherently you can tell the story of a difficult experience, the more resolved it becomes psychologically.',
    summaryTr:
        'Zor bir deneyimin hikayesini ne kadar tutarlı anlatabilirseniz, psikolojik olarak o kadar çözülmüş olur.',
    bodyEn:
        'Pennebaker\'s linguistic analysis of thousands of journal entries found a striking pattern: people who showed increasing use of causal words ("because," "reason," "understand") and insight words ("realize," "know," "meaning") across writing sessions showed the greatest health improvements. The mechanism is narrative coherence — turning a fragmented emotional experience into a story with causes, connections, and meaning. This does not require forcing a "positive spin." It simply means developing a clear account: this happened, then this happened, and I think it affected me because... The story does not have to be happy. It just has to be coherent.',
    bodyTr:
        'Pennebaker\'ın binlerce günlük kaydının dilbilimsel analizi çarpıcı bir örüntü buldu: yazma seansları boyunca artan nedensel kelime kullanımı gösteren kişiler en büyük sağlık iyileşmelerini gösterdi. Mekanizma anlatısal tutarlılıktır — parçalanmış bir duygusal deneyimi nedenleri, bağlantıları ve anlamı olan bir hikayeye dönüştürmek.',
    whyItMattersEn:
        'Rereading old entries and adding new understanding creates the narrative coherence that research links to healing.',
    whyItMattersTr:
        'Eski kayıtları yeniden okumak ve yeni anlayış eklemek, araştırmanın iyileşmeyle ilişkilendirdiği anlatısal tutarlılığı oluşturur.',
    screenshotLineEn: 'You do not need a happy ending. You need a coherent story.',
    screenshotLineTr: 'Mutlu bir sona ihtiyacınız yok. Tutarlı bir hikayeye ihtiyacınız var.',
    relatedFocusAreas: ['mood', 'health'],
    relatedModuleIds: ['sa_005', 'js_003'],
  ),
  ContextModule(
    id: 'js_006',
    category: ContextModuleCategory.journalScience,
    depth: ContextModuleDepth.advanced,
    titleEn: 'The Spacing Effect in Reflection',
    titleTr: 'Yansıtmada Aralık Etkisi',
    summaryEn:
        'Revisiting journal entries at spaced intervals — 1 week, 1 month, 3 months — deepens insight in ways that daily writing alone cannot.',
    summaryTr:
        'Günlük kayıtlarını aralıklı olarak — 1 hafta, 1 ay, 3 ay — yeniden ziyaret etmek, sadece günlük yazmanın başaramayacağı şekillerde içgörüyü derinleştirir.',
    bodyEn:
        'The spacing effect is one of the most robust findings in cognitive science: information reviewed at increasing intervals is remembered and integrated more deeply than information crammed all at once. This applies to journaling too. When you read an entry from last week, you see it with slightly more distance. From last month, even more. From three months ago, you often notice patterns that were completely invisible in the moment. This is why InnerCycles surfaces past entries — not for nostalgia, but because spaced reflection transforms raw journaling into genuine self-knowledge.',
    bodyTr:
        'Aralık etkisi bilişsel bilimdeki en sağlam bulgulardan biridir: artan aralıklarla gözden geçirilen bilgi, bir seferde sıkıştırılan bilgiden daha derin hatırlanır ve entegre edilir. Bu günlük tutma için de geçerlidir. Geçen haftaki bir kaydı okuduğunuzda, onu biraz daha mesafeyle görürsünüz. Geçen aydan, daha da fazla. Üç ay öncesinden, genellikle o anda tamamen görünmez olan örüntüleri fark edersiniz.',
    whyItMattersEn:
        'The archive feature is not just storage. Reviewing past entries at intervals is where the deepest self-knowledge develops.',
    whyItMattersTr:
        'Arşiv özelliği sadece depolama değildir. Geçmiş kayıtları aralıklarla incelemek, en derin öz bilginin geliştiği yerdir.',
    screenshotLineEn: 'Rereading your journal at intervals reveals what daily writing cannot.',
    screenshotLineTr: 'Günlüğünüzü aralıklarla yeniden okumak, günlük yazmanın ortaya çıkaramadığını gösterir.',
    relatedFocusAreas: ['mood', 'creativity'],
    relatedModuleIds: ['js_005', 'pr_001'],
  ),
];
