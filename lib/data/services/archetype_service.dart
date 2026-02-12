// ════════════════════════════════════════════════════════════════════════════
// ARCHETYPE EVOLUTION SERVICE - InnerCycles Jungian Self-Reflection Engine
// ════════════════════════════════════════════════════════════════════════════
// Analyzes journal entries to surface dominant Jungian archetypes based on
// focus area + mood patterns. Tracks archetype evolution via monthly snapshots
// stored in SharedPreferences (follows DailyHookService init pattern).
//
// IMPORTANT: This is a self-reflection tool for personal growth awareness.
// It is NOT a personality test or clinical instrument. All language uses
// safe framing: "your entries suggest", "tends to align with",
// "you may resonate with".
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journal_entry.dart';

// ════════════════════════════════════════════════════════════════════════════
// ARCHETYPE MODEL
// ════════════════════════════════════════════════════════════════════════════

class Archetype {
  final String id;
  final String nameEn;
  final String nameTr;
  final String emoji;
  final String descriptionEn;
  final String descriptionTr;
  final List<String> strengthsEn;
  final List<String> strengthsTr;
  final String shadowEn;
  final String shadowTr;
  final String growthTipEn;
  final String growthTipTr;

  const Archetype({
    required this.id,
    required this.nameEn,
    required this.nameTr,
    required this.emoji,
    required this.descriptionEn,
    required this.descriptionTr,
    required this.strengthsEn,
    required this.strengthsTr,
    required this.shadowEn,
    required this.shadowTr,
    required this.growthTipEn,
    required this.growthTipTr,
  });

  String getName({bool isEnglish = true}) => isEnglish ? nameEn : nameTr;
  String getDescription({bool isEnglish = true}) =>
      isEnglish ? descriptionEn : descriptionTr;
  List<String> getStrengths({bool isEnglish = true}) =>
      isEnglish ? strengthsEn : strengthsTr;
  String getShadow({bool isEnglish = true}) =>
      isEnglish ? shadowEn : shadowTr;
  String getGrowthTip({bool isEnglish = true}) =>
      isEnglish ? growthTipEn : growthTipTr;

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameEn': nameEn,
        'nameTr': nameTr,
        'emoji': emoji,
      };
}

// ════════════════════════════════════════════════════════════════════════════
// ARCHETYPE SNAPSHOT - Monthly evolution record
// ════════════════════════════════════════════════════════════════════════════

class ArchetypeSnapshot {
  final int month;
  final int year;
  final String archetypeId;
  final double confidence;

  const ArchetypeSnapshot({
    required this.month,
    required this.year,
    required this.archetypeId,
    required this.confidence,
  });

  Map<String, dynamic> toJson() => {
        'month': month,
        'year': year,
        'archetypeId': archetypeId,
        'confidence': confidence,
      };

  factory ArchetypeSnapshot.fromJson(Map<String, dynamic> json) =>
      ArchetypeSnapshot(
        month: json['month'] as int,
        year: json['year'] as int,
        archetypeId: json['archetypeId'] as String,
        confidence: (json['confidence'] as num).toDouble(),
      );
}

// ════════════════════════════════════════════════════════════════════════════
// ARCHETYPE RESULT - Analysis output for UI
// ════════════════════════════════════════════════════════════════════════════

class ArchetypeResult {
  final Archetype dominant;
  final double confidence;
  final Map<String, double> breakdown;

  const ArchetypeResult({
    required this.dominant,
    required this.confidence,
    required this.breakdown,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// ARCHETYPE SERVICE
// ════════════════════════════════════════════════════════════════════════════

class ArchetypeService {
  static const String _historyKey = 'inner_cycles_archetype_history';
  static const String _lastSnapshotKey = 'inner_cycles_archetype_last_snapshot';

  final SharedPreferences _prefs;

  ArchetypeService._(this._prefs);

  /// Initialize the archetype service
  static Future<ArchetypeService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return ArchetypeService._(prefs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // THE 12 JUNGIAN ARCHETYPES
  // ══════════════════════════════════════════════════════════════════════════

  static const List<Archetype> archetypes = [
    Archetype(
      id: 'creator',
      nameEn: 'The Creator',
      nameTr: 'Yaratici',
      emoji: '\u{1F3A8}',
      descriptionEn:
          'Your entries suggest a drive to bring new ideas to life. '
          'You may resonate with building, designing, and transforming '
          'raw thoughts into something meaningful.',
      descriptionTr:
          'Kayitlarin yeni fikirleri hayata gecirme durtusune isaret '
          'ediyor. Insa etmek, tasarlamak ve ham dusunceleri anlamli '
          'bir seye donusturmekle uyum icinde olabilirsin.',
      strengthsEn: ['Innovation', 'Vision', 'Self-expression', 'Imagination'],
      strengthsTr: ['Yenilik', 'Vizyon', 'Kendini ifade', 'Hayal gucu'],
      shadowEn:
          'Perfectionism or creative blocks may surface when you feel '
          'your output does not match your inner vision.',
      shadowTr:
          'Ciktin ic vizyonunla eslesmedigi hissettigi zamanlarda '
          'mukemmeliyetcilik veya yaratici ticaniklar ortaya cikabilir.',
      growthTipEn:
          'Allow yourself to create imperfectly. Your journal entries '
          'suggest growth comes when you release the need for a '
          'flawless result.',
      growthTipTr:
          'Kendine kusurlu yaratma izni ver. Kayitlarin, kusursuz '
          'sonuc ihtiyacini biraktigin zaman buyumenin geldigine '
          'isaret ediyor.',
    ),
    Archetype(
      id: 'explorer',
      nameEn: 'The Explorer',
      nameTr: 'Kasif',
      emoji: '\u{1F9ED}',
      descriptionEn:
          'Your patterns tend to align with curiosity and a desire '
          'for new experiences. You may find meaning in pushing '
          'beyond familiar boundaries.',
      descriptionTr:
          'Kaliplarin merak ve yeni deneyimler arzusuyla uyum icinde '
          'olma egiliminde. Bilindik sinirlarin otesine gecmekte '
          'anlam bulabilirsin.',
      strengthsEn: ['Curiosity', 'Adaptability', 'Courage', 'Independence'],
      strengthsTr: ['Merak', 'Uyum saglama', 'Cesaret', 'Bagimsizlik'],
      shadowEn:
          'Restlessness or chronic dissatisfaction may appear when '
          'the current moment feels too confining.',
      shadowTr:
          'Mevcut an cok kisitlayici hissettirdiginde huzursuzluk '
          'veya kronik memnuniyetsizlik ortaya cikabilir.',
      growthTipEn:
          'Balance exploration with presence. Your journal suggests '
          'that grounding practices help you integrate new '
          'discoveries more deeply.',
      growthTipTr:
          'Kesfi mevcudiyetle dengele. Kayitlarin topraklama '
          'pratiklerinin yeni kesileri daha derinden entegre etmene '
          'yardimci olduguna isaret ediyor.',
    ),
    Archetype(
      id: 'sage',
      nameEn: 'The Sage',
      nameTr: 'Bilge',
      emoji: '\u{1F4DA}',
      descriptionEn:
          'Your entries suggest a deep drive to understand the world '
          'through reflection and knowledge. You may value clarity '
          'and truth above all else.',
      descriptionTr:
          'Kayitlarin dunyayi dusunce ve bilgi yoluyla anlama '
          'konusunda derin bir durtiye isaret ediyor. Netligi ve '
          'geregi her seyden cok degerlendiriyor olabilirsin.',
      strengthsEn: ['Wisdom', 'Analytical mind', 'Objectivity', 'Insight'],
      strengthsTr: ['Bilgelik', 'Analitik dusunce', 'Objektivite', 'Icgoru'],
      shadowEn:
          'Over-analysis or emotional detachment may arise when you '
          'retreat too deeply into the mind.',
      shadowTr:
          'Zihne cok derine cekildigin zamanlarda asiri analiz veya '
          'duygusal kopukluk ortaya cikabilir.',
      growthTipEn:
          'Let feeling guide you alongside thought. Your patterns '
          'suggest that emotional engagement enriches your '
          'understanding.',
      growthTipTr:
          'Duygunun dusuncenin yaninda sana rehberlik etmesine izin '
          'ver. Kaliplarin duygusal katilimin anlavisini '
          'zenginlestirdigine isaret ediyor.',
    ),
    Archetype(
      id: 'hero',
      nameEn: 'The Hero',
      nameTr: 'Kahraman',
      emoji: '\u{1F6E1}\u{FE0F}',
      descriptionEn:
          'Your journal patterns tend to reflect determination and a '
          'willingness to face challenges head-on. You may find '
          'strength in overcoming obstacles.',
      descriptionTr:
          'Gunluk kaliplarin kararlilik ve zorluklarla yuzyuze gelme '
          'istegini yansitma egiliminde. Engelleri asmakta guc '
          'buluyor olabilirsin.',
      strengthsEn: ['Courage', 'Discipline', 'Resilience', 'Determination'],
      strengthsTr: ['Cesaret', 'Disiplin', 'Dayaniklilik', 'Kararlilik'],
      shadowEn:
          'Burnout or an inability to ask for help may surface when '
          'the drive to prove yourself becomes relentless.',
      shadowTr:
          'Kendini kanitlama durtusunun durmak bilmez hale geldigi '
          'zamanlarda tukenmislik veya yardim isteyememe ortaya '
          'cikabilir.',
      growthTipEn:
          'Rest is not retreat. Your entries suggest that recovery '
          'periods actually strengthen your capacity for future '
          'challenges.',
      growthTipTr:
          'Dinlenmek geri cekilme degildir. Kayitlarin toparlanma '
          'donemlerinin gelecek zorluklar icin kapasiteni '
          'guclendigine isaret ediyor.',
    ),
    Archetype(
      id: 'rebel',
      nameEn: 'The Rebel',
      nameTr: 'Asi',
      emoji: '\u{1F525}',
      descriptionEn:
          'Your entries suggest a strong desire to question norms '
          'and forge your own path. You may resonate with disrupting '
          'the status quo to create meaningful change.',
      descriptionTr:
          'Kayitlarin normlari sorgulama ve kendi yolunu acma '
          'konusunda guclu bir arzuya isaret ediyor. Anlamli '
          'degisim yaratmak icin mevcut durumu sarsmakla uyum '
          'icinde olabilirsin.',
      strengthsEn: ['Independence', 'Bravery', 'Authenticity', 'Conviction'],
      strengthsTr: ['Bagimsizlik', 'Yureklili', 'Otantiklik', 'Inanc'],
      shadowEn:
          'Isolation or self-sabotage may emerge when rebellion '
          'becomes its own end rather than a path to something '
          'constructive.',
      shadowTr:
          'Isyan yapici bir seye giden yol yerine kendi amaci haline '
          'geldiginde izolasyon veya kendine zarar verme ortaya '
          'cikabilir.',
      growthTipEn:
          'Channel disruption into creation. Your journal suggests '
          'that your rebellious energy is most powerful when it '
          'builds something new.',
      growthTipTr:
          'Bozmayi yaratmaya kanalize et. Kayitlarin asi enerjinin '
          'yeni bir sey insa ettiginde en guclu olduguna isaret '
          'ediyor.',
    ),
    Archetype(
      id: 'magician',
      nameEn: 'The Magician',
      nameTr: 'Buyucu',
      emoji: '\u{2728}',
      descriptionEn:
          'Your patterns suggest a gift for transformation and '
          'seeing connections others miss. You may resonate with '
          'turning vision into reality through inner work.',
      descriptionTr:
          'Kaliplarin donusum ve baskalarin kacirdigi baglantilari '
          'gorme konusunda bir yetenegine isaret ediyor. Ic calisma '
          'yoluyla vizyonu gerceklige cevirmeyle uyum icinde '
          'olabilirsin.',
      strengthsEn: [
        'Transformation',
        'Intuition',
        'Resourcefulness',
        'Awareness'
      ],
      strengthsTr: [
        'Donusum',
        'Sezgi',
        'Beceriklilik',
        'Farkindalik'
      ],
      shadowEn:
          'Manipulation or disconnection from reality may arise when '
          'the desire for control overrides authentic connection.',
      shadowTr:
          'Kontrol arzusu otantik baglantinin onune gectiginde '
          'manipulasyon veya gerceklikten kopma ortaya cikabilir.',
      growthTipEn:
          'Ground your vision in everyday action. Your entries '
          'suggest that small, consistent steps create the most '
          'lasting transformation.',
      growthTipTr:
          'Vizyonunu gundelik eyleme temelle. Kayitlarin kucuk, '
          'tutarli adimlarin en kalici donusumu yarattigina isaret '
          'ediyor.',
    ),
    Archetype(
      id: 'lover',
      nameEn: 'The Lover',
      nameTr: 'Asik',
      emoji: '\u{1F49C}',
      descriptionEn:
          'Your journal entries tend to reflect deep emotional '
          'sensitivity and a desire for authentic connection. You '
          'may find meaning in intimacy, beauty, and passion.',
      descriptionTr:
          'Gunluk kayitlarin derin duygusal hassasiyet ve otantik '
          'baglanti arzusunu yansitma egiliminde. Yakinlik, guzellik '
          've tutkuda anlam buluyor olabilirsin.',
      strengthsEn: ['Empathy', 'Passion', 'Devotion', 'Appreciation'],
      strengthsTr: ['Empati', 'Tutku', 'Adanmislik', 'Takdir'],
      shadowEn:
          'People-pleasing or losing yourself in others may surface '
          'when the need for connection overshadows self-care.',
      shadowTr:
          'Baglanti ihtiyaci oz bakimin onune gectiginde baskalarini '
          'memnun etme veya baskalari icinde kaybolma ortaya '
          'cikabilir.',
      growthTipEn:
          'Love yourself first. Your patterns suggest that the '
          'deepest connections grow from a place of inner '
          'wholeness.',
      growthTipTr:
          'Once kendini sev. Kaliplarin en derin baglantilarin ic '
          'butunluk yerinden buyudugune isaret ediyor.',
    ),
    Archetype(
      id: 'caregiver',
      nameEn: 'The Caregiver',
      nameTr: 'Bakici',
      emoji: '\u{1F49A}',
      descriptionEn:
          'Your entries suggest a natural orientation toward '
          'nurturing and supporting others. You may find deep '
          'fulfillment in service and compassion.',
      descriptionTr:
          'Kayitlarin baskalarina bakma ve destek olma konusunda '
          'dogal bir yonelime isaret ediyor. Hizmet ve merhamette '
          'derin tatmin buluyor olabilirsin.',
      strengthsEn: ['Compassion', 'Generosity', 'Nurturing', 'Loyalty'],
      strengthsTr: ['Merhamet', 'Comertlik', 'Besleyicilik', 'Sadakat'],
      shadowEn:
          'Martyrdom or resentment may build when giving becomes '
          'depleting rather than fulfilling.',
      shadowTr:
          'Vermek tatmin edici olmaktan cikip tuketen hale '
          'geldiginde sehitlik veya kizginlik birikebilir.',
      growthTipEn:
          'Fill your own cup first. Your journal suggests that '
          'boundaries actually deepen your ability to care for '
          'others authentically.',
      growthTipTr:
          'Once kendi kabini doldur. Kayitlarin sinirlarin aslinda '
          'baskalarina otantik bir sekilde bakma yetenegini '
          'derinlestirdigine isaret ediyor.',
    ),
    Archetype(
      id: 'ruler',
      nameEn: 'The Ruler',
      nameTr: 'Hukumdar',
      emoji: '\u{1F451}',
      descriptionEn:
          'Your patterns tend to reflect a desire for order, '
          'structure, and responsibility. You may resonate with '
          'taking charge and creating stability around you.',
      descriptionTr:
          'Kaliplarin duzen, yapi ve sorumluluk arzusunu yansitma '
          'egiliminde. Kontrolu ele alma ve cevrenizde istikrar '
          'yaratmayla uyum icinde olabilirsin.',
      strengthsEn: ['Leadership', 'Organization', 'Confidence', 'Stability'],
      strengthsTr: ['Liderlik', 'Organizasyon', 'Guven', 'Istikrar'],
      shadowEn:
          'Rigidity or controlling behavior may emerge when '
          'uncertainty threatens your sense of order.',
      shadowTr:
          'Belirsizlik duzen hissini tehdit ettiginde katilk veya '
          'kontrolcu davranis ortaya cikabilir.',
      growthTipEn:
          'Lead by letting go. Your entries suggest that true '
          'authority comes from flexibility, not control.',
      growthTipTr:
          'Birakarak liderlik et. Kayitlarin gercek otoritenin '
          'kontrolden degil esneklikten geldigine isaret ediyor.',
    ),
    Archetype(
      id: 'innocent',
      nameEn: 'The Innocent',
      nameTr: 'Masum',
      emoji: '\u{1F31F}',
      descriptionEn:
          'Your entries suggest an optimistic outlook and a desire '
          'for simplicity and safety. You may resonate with finding '
          'joy in the present moment and trusting the process.',
      descriptionTr:
          'Kayitlarin iyimser bir bakis acisi ve sadelik ve guvenlik '
          'arzusuna isaret ediyor. Anda mutluluk bulmak ve surece '
          'guvenmeyle uyum icinde olabilirsin.',
      strengthsEn: ['Optimism', 'Trust', 'Simplicity', 'Joy'],
      strengthsTr: ['Iyimserlik', 'Guven', 'Sadelik', 'Nese'],
      shadowEn:
          'Naivety or denial may surface when avoiding difficult '
          'truths feels safer than confronting them.',
      shadowTr:
          'Zor gerceklerden kacinmak onlarla yuzlesmekten daha '
          'guvenli hissettirdiginde saflk veya inkar ortaya '
          'cikabilir.',
      growthTipEn:
          'Hold your optimism and your awareness together. Your '
          'journal suggests that acknowledging shadows actually '
          'strengthens your light.',
      growthTipTr:
          'Iyimserligini ve farkindaligini birlikte tut. Kayitlarin '
          'golgeleri kabul etmenin aslinda isigini guclendigine '
          'isaret ediyor.',
    ),
    Archetype(
      id: 'jester',
      nameEn: 'The Jester',
      nameTr: 'Soytari',
      emoji: '\u{1F3AD}',
      descriptionEn:
          'Your patterns suggest a gift for lightness and finding '
          'humor even in difficulty. You may resonate with using '
          'playfulness as a path to deeper truth.',
      descriptionTr:
          'Kaliplarin hafiflik ve zorlukta bile mizah bulma '
          'konusunda bir yetenegine isaret ediyor. Eglenceyi daha '
          'derin gercegin yolu olarak kullanmakla uyum icinde '
          'olabilirsin.',
      strengthsEn: ['Humor', 'Playfulness', 'Perspective', 'Resilience'],
      strengthsTr: ['Mizah', 'Oyunculuk', 'Perspektif', 'Dayaniklilik'],
      shadowEn:
          'Avoidance through humor or difficulty being taken '
          'seriously may emerge when vulnerability feels unsafe.',
      shadowTr:
          'Savunmasizlik guvensi hissettirdiginde mizah yoluyla '
          'kacinma veya ciddiye alinmama zorlugu ortaya cikabilir.',
      growthTipEn:
          'Let yourself be seen beyond the humor. Your entries '
          'suggest that your most meaningful connections happen '
          'when you lower the mask.',
      growthTipTr:
          'Kendini mizahin otesinde gostermeye izin ver. Kayitlarin '
          'en anlamli baglantilarin maskeyi indirdigin zaman '
          'olduguna isaret ediyor.',
    ),
    Archetype(
      id: 'orphan',
      nameEn: 'The Orphan',
      nameTr: 'Yetim',
      emoji: '\u{1F30D}',
      descriptionEn:
          'Your entries suggest a deep awareness of life\'s '
          'challenges and a hard-won resilience. You may resonate '
          'with building authentic belonging through shared '
          'experience.',
      descriptionTr:
          'Kayitlarin hayatin zorluklarin derin farkindaligiina ve '
          'zor kazanilmis bir dayanikliliga isaret ediyor. Paylasilan '
          'deneyim yoluyla otantik aidiyet insa etmeyle uyum icinde '
          'olabilirsin.',
      strengthsEn: ['Empathy', 'Realism', 'Resilience', 'Solidarity'],
      strengthsTr: ['Empati', 'Gercekcilik', 'Dayaniklilik', 'Dayanisma'],
      shadowEn:
          'Victimhood or cynicism may arise when past wounds become '
          'the lens through which all new experiences are filtered.',
      shadowTr:
          'Gecmis yaralar tum yeni deneyimlerin filtrelendigi '
          'mercek haline geldiginde magdurluk veya kinizm ortaya '
          'cikabilir.',
      growthTipEn:
          'Your wounds are your wisdom. Your journal suggests that '
          'sharing your story with trusted others transforms pain '
          'into connection.',
      growthTipTr:
          'Yaralarin bilgelgindir. Kayitlarin hikayeni guvendiin '
          'insanlarla paylamasinin aciyi baglantyia donusturdugune '
          'isaret ediyor.',
    ),
  ];

  /// Get archetype by ID
  static Archetype getArchetypeById(String id) {
    return archetypes.firstWhere(
      (a) => a.id == id,
      orElse: () => archetypes.first,
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FOCUS AREA -> ARCHETYPE MAPPING
  // ══════════════════════════════════════════════════════════════════════════

  /// Maps FocusArea + sub-rating patterns to archetype weights.
  /// This is the core heuristic: each journal entry contributes weight
  /// to multiple archetypes based on what the user tracked.
  static Map<String, double> _getWeightsForEntry(JournalEntry entry) {
    final weights = <String, double>{};
    final rating = entry.overallRating;
    final subRatings = entry.subRatings;

    // Base weights from focus area
    switch (entry.focusArea) {
      case FocusArea.energy:
        weights['hero'] = (weights['hero'] ?? 0) + 1.5;
        weights['explorer'] = (weights['explorer'] ?? 0) + 1.0;
        weights['rebel'] = (weights['rebel'] ?? 0) + 0.8;
        break;
      case FocusArea.focus:
        weights['sage'] = (weights['sage'] ?? 0) + 1.5;
        weights['ruler'] = (weights['ruler'] ?? 0) + 1.2;
        weights['creator'] = (weights['creator'] ?? 0) + 0.8;
        break;
      case FocusArea.emotions:
        weights['lover'] = (weights['lover'] ?? 0) + 1.5;
        weights['caregiver'] = (weights['caregiver'] ?? 0) + 1.0;
        weights['orphan'] = (weights['orphan'] ?? 0) + 0.8;
        break;
      case FocusArea.decisions:
        weights['ruler'] = (weights['ruler'] ?? 0) + 1.5;
        weights['magician'] = (weights['magician'] ?? 0) + 1.2;
        weights['hero'] = (weights['hero'] ?? 0) + 0.8;
        break;
      case FocusArea.social:
        weights['caregiver'] = (weights['caregiver'] ?? 0) + 1.2;
        weights['lover'] = (weights['lover'] ?? 0) + 1.0;
        weights['jester'] = (weights['jester'] ?? 0) + 1.0;
        weights['innocent'] = (weights['innocent'] ?? 0) + 0.8;
        break;
    }

    // Mood modifiers based on overall rating
    if (rating >= 4) {
      // High mood: amplify optimistic archetypes
      weights['innocent'] = (weights['innocent'] ?? 0) + 0.6;
      weights['jester'] = (weights['jester'] ?? 0) + 0.4;
      weights['creator'] = (weights['creator'] ?? 0) + 0.5;
    } else if (rating <= 2) {
      // Low mood: amplify depth-seeking archetypes
      weights['orphan'] = (weights['orphan'] ?? 0) + 0.8;
      weights['sage'] = (weights['sage'] ?? 0) + 0.5;
      weights['magician'] = (weights['magician'] ?? 0) + 0.4;
    }

    // Sub-rating modifiers
    final motivation = subRatings['motivation'] ?? 0;
    if (motivation >= 4) {
      weights['hero'] = (weights['hero'] ?? 0) + 0.5;
      weights['explorer'] = (weights['explorer'] ?? 0) + 0.3;
    }

    final clarity = subRatings['clarity'] ?? 0;
    if (clarity >= 4) {
      weights['sage'] = (weights['sage'] ?? 0) + 0.5;
      weights['ruler'] = (weights['ruler'] ?? 0) + 0.3;
    }

    final stress = subRatings['stress'] ?? 0;
    if (stress >= 4) {
      // High stress tracked
      weights['rebel'] = (weights['rebel'] ?? 0) + 0.4;
      weights['orphan'] = (weights['orphan'] ?? 0) + 0.3;
    }

    final calm = subRatings['calm'] ?? 0;
    if (calm >= 4) {
      weights['innocent'] = (weights['innocent'] ?? 0) + 0.4;
      weights['sage'] = (weights['sage'] ?? 0) + 0.3;
    }

    final confidence = subRatings['confidence'] ?? 0;
    if (confidence >= 4) {
      weights['ruler'] = (weights['ruler'] ?? 0) + 0.5;
      weights['hero'] = (weights['hero'] ?? 0) + 0.3;
    }

    final connection = subRatings['connection'] ?? 0;
    if (connection >= 4) {
      weights['lover'] = (weights['lover'] ?? 0) + 0.5;
      weights['caregiver'] = (weights['caregiver'] ?? 0) + 0.4;
    }

    final isolation = subRatings['isolation'] ?? 0;
    if (isolation >= 4) {
      weights['explorer'] = (weights['explorer'] ?? 0) + 0.4;
      weights['rebel'] = (weights['rebel'] ?? 0) + 0.3;
    }

    final communication = subRatings['communication'] ?? 0;
    if (communication >= 4) {
      weights['jester'] = (weights['jester'] ?? 0) + 0.4;
      weights['magician'] = (weights['magician'] ?? 0) + 0.3;
    }

    final productivity = subRatings['productivity'] ?? 0;
    if (productivity >= 4) {
      weights['creator'] = (weights['creator'] ?? 0) + 0.5;
      weights['ruler'] = (weights['ruler'] ?? 0) + 0.3;
    }

    final regret = subRatings['regret'] ?? 0;
    if (regret >= 4) {
      weights['orphan'] = (weights['orphan'] ?? 0) + 0.4;
      weights['magician'] = (weights['magician'] ?? 0) + 0.3;
    }

    return weights;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ANALYSIS
  // ══════════════════════════════════════════════════════════════════════════

  /// Analyze entries and return the current dominant archetype.
  /// Uses the most recent 30 entries for freshness.
  ArchetypeResult? getCurrentArchetype(List<JournalEntry> entries) {
    if (entries.isEmpty) return null;

    // Use most recent 30 entries
    final sorted = List<JournalEntry>.from(entries)
      ..sort((a, b) => b.date.compareTo(a.date));
    final recent = sorted.take(30).toList();

    final breakdown = getArchetypeBreakdown(recent);
    if (breakdown.isEmpty) return null;

    // Find dominant
    final sortedEntries = breakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final dominantId = sortedEntries.first.key;
    final dominantPct = sortedEntries.first.value;

    return ArchetypeResult(
      dominant: getArchetypeById(dominantId),
      confidence: dominantPct / 100.0,
      breakdown: breakdown,
    );
  }

  /// Get percentage breakdown across all 12 archetypes.
  /// Returns a map of archetypeId to percentage (0-100).
  Map<String, double> getArchetypeBreakdown(List<JournalEntry> entries) {
    if (entries.isEmpty) return {};

    final totalWeights = <String, double>{};

    for (final entry in entries) {
      final entryWeights = _getWeightsForEntry(entry);
      for (final kv in entryWeights.entries) {
        totalWeights[kv.key] = (totalWeights[kv.key] ?? 0) + kv.value;
      }
    }

    // Normalize to percentages
    final sum = totalWeights.values.fold(0.0, (a, b) => a + b);
    if (sum == 0) return {};

    final percentages = <String, double>{};
    for (final archetype in archetypes) {
      final raw = totalWeights[archetype.id] ?? 0;
      percentages[archetype.id] = (raw / sum) * 100.0;
    }

    return percentages;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // EVOLUTION HISTORY
  // ══════════════════════════════════════════════════════════════════════════

  /// Get full archetype history (monthly snapshots).
  List<ArchetypeSnapshot> getArchetypeHistory() {
    final jsonString = _prefs.getString(_historyKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((j) => ArchetypeSnapshot.fromJson(j as Map<String, dynamic>))
          .toList()
        ..sort((a, b) {
          final yearCmp = a.year.compareTo(b.year);
          if (yearCmp != 0) return yearCmp;
          return a.month.compareTo(b.month);
        });
    } catch (_) {
      return [];
    }
  }

  /// Save a monthly snapshot. Called when the user views the archetype screen
  /// and a new month has started since the last snapshot.
  Future<void> saveMonthlySnapshot(
    List<JournalEntry> entries, {
    int? overrideMonth,
    int? overrideYear,
  }) async {
    final now = DateTime.now();
    final month = overrideMonth ?? now.month;
    final year = overrideYear ?? now.year;

    // Check if we already have a snapshot for this month
    final lastSnapshotStr = _prefs.getString(_lastSnapshotKey);
    if (lastSnapshotStr != null) {
      try {
        final lastDate = DateTime.parse(lastSnapshotStr);
        if (lastDate.year == year && lastDate.month == month) {
          return; // Already captured this month
        }
      } catch (_) {
        // Continue with save
      }
    }

    // Get entries for this month
    final monthEntries = entries
        .where((e) => e.date.year == year && e.date.month == month)
        .toList();

    if (monthEntries.isEmpty) return;

    final result = getCurrentArchetype(monthEntries);
    if (result == null) return;

    final snapshot = ArchetypeSnapshot(
      month: month,
      year: year,
      archetypeId: result.dominant.id,
      confidence: result.confidence,
    );

    final history = getArchetypeHistory();

    // Replace if existing for the same month, otherwise add
    final existingIdx =
        history.indexWhere((s) => s.month == month && s.year == year);
    if (existingIdx >= 0) {
      history[existingIdx] = snapshot;
    } else {
      history.add(snapshot);
    }

    // Keep only last 24 months
    if (history.length > 24) {
      history.removeRange(0, history.length - 24);
    }

    final jsonList = history.map((s) => s.toJson()).toList();
    await _prefs.setString(_historyKey, json.encode(jsonList));
    await _prefs.setString(
      _lastSnapshotKey,
      DateTime(year, month).toIso8601String(),
    );
  }

  /// Get the last N monthly snapshots for the evolution timeline.
  List<ArchetypeSnapshot> getRecentSnapshots({int count = 6}) {
    final history = getArchetypeHistory();
    if (history.length <= count) return history;
    return history.sublist(history.length - count);
  }

  /// Check if enough data exists for meaningful analysis.
  /// Requires at least 3 entries to produce an archetype.
  bool hasEnoughData(List<JournalEntry> entries) {
    return entries.length >= 3;
  }

  /// Clear all archetype data
  Future<void> clearAll() async {
    await _prefs.remove(_historyKey);
    await _prefs.remove(_lastSnapshotKey);
  }
}
