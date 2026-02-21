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
import 'package:flutter/foundation.dart';
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
  final List<String> growthAreasEn;
  final List<String> growthAreasTr;
  final String dailyIntentionStyleEn;
  final String dailyIntentionStyleTr;
  final List<String> compatibleArchetypes;

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
    this.growthAreasEn = const [],
    this.growthAreasTr = const [],
    this.dailyIntentionStyleEn = '',
    this.dailyIntentionStyleTr = '',
    this.compatibleArchetypes = const [],
  });

  String getName({bool isEnglish = true}) => isEnglish ? nameEn : nameTr;
  String getDescription({bool isEnglish = true}) =>
      isEnglish ? descriptionEn : descriptionTr;
  List<String> getStrengths({bool isEnglish = true}) =>
      isEnglish ? strengthsEn : strengthsTr;
  String getShadow({bool isEnglish = true}) => isEnglish ? shadowEn : shadowTr;
  String getGrowthTip({bool isEnglish = true}) =>
      isEnglish ? growthTipEn : growthTipTr;
  List<String> getGrowthAreas({bool isEnglish = true}) =>
      isEnglish ? growthAreasEn : growthAreasTr;
  String getDailyIntentionStyle({bool isEnglish = true}) =>
      isEnglish ? dailyIntentionStyleEn : dailyIntentionStyleTr;

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
        month: json['month'] as int? ?? 1,
        year: json['year'] as int? ?? 2024,
        archetypeId: json['archetypeId'] as String? ?? '',
        confidence: (json['confidence'] as num? ?? 0).toDouble(),
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
  // Each includes: description, strengths, shadow, growth tip, growth areas,
  // daily intention style, and compatible archetypes.
  // ══════════════════════════════════════════════════════════════════════════

  static const List<Archetype> archetypes = [
    Archetype(
      id: 'creator',
      nameEn: 'The Creator',
      nameTr: 'Yaratıcı',
      emoji: '\u{1F3A8}',
      descriptionEn:
          'Your entries suggest a drive to bring new ideas to life. '
          'You may resonate with building, designing, and transforming '
          'raw thoughts into something meaningful.',
      descriptionTr:
          'Kayıtların yeni fikirleri hayata geçirme dürtüsüne işaret '
          'ediyor. İnşa etmek, tasarlamak ve ham düşünceleri anlamlı '
          'bir şeye dönüştürmekle uyum içinde olabilirsin.',
      strengthsEn: ['Innovation', 'Vision', 'Self-expression', 'Imagination'],
      strengthsTr: ['Yenilik', 'Vizyon', 'Kendini ifade', 'Hayal gücü'],
      shadowEn:
          'Perfectionism or creative blocks may surface when you feel '
          'your output does not match your inner vision.',
      shadowTr:
          'Çıktın iç vizyonunla eşleşmediği hissettirdiği zamanlarda '
          'mükemmeliyetçilik veya yaratıcı tıkanıklar ortaya çıkabilir.',
      growthTipEn:
          'Allow yourself to create imperfectly. Your journal entries '
          'suggest growth comes when you release the need for a '
          'flawless result.',
      growthTipTr:
          'Kendine kusurlu yaratma izni ver. Kayıtların, kusursuz '
          'sonuç ihtiyacını bıraktığın zaman büyümenin geldiğine '
          'işaret ediyor.',
      growthAreasEn: [
        'Finishing projects before starting new ones',
        'Accepting constructive feedback with openness',
        'Sharing work before it feels perfectly ready',
      ],
      growthAreasTr: [
        'Yeni başlamadan projeleri bitirmek',
        'Yapıcı geri bildirimi açıklıkla kabul etmek',
        'İşini mükemmel hissetmeden önce paylaşmak',
      ],
      dailyIntentionStyleEn:
          'Set a creative micro-goal each morning — even a single '
          'sketch, sentence, or idea counts as progress.',
      dailyIntentionStyleTr:
          'Her sabah yaratıcı bir mikro hedef belirle — tek bir çizim, '
          'cümle veya fikir bile ilerleme sayılır.',
      compatibleArchetypes: ['explorer', 'magician', 'sage'],
    ),
    Archetype(
      id: 'explorer',
      nameEn: 'The Explorer',
      nameTr: 'Kaşif',
      emoji: '\u{1F9ED}',
      descriptionEn:
          'Your patterns tend to align with curiosity and a desire '
          'for new experiences. You may find meaning in pushing '
          'beyond familiar boundaries.',
      descriptionTr:
          'Kalıpların merak ve yeni deneyimler arzusuyla uyum içinde '
          'olma eğiliminde. Bilindik sınırların ötesine geçmekte '
          'anlam bulabilirsin.',
      strengthsEn: ['Curiosity', 'Adaptability', 'Courage', 'Independence'],
      strengthsTr: ['Merak', 'Uyum sağlama', 'Cesaret', 'Bağımsızlık'],
      shadowEn:
          'Restlessness or chronic dissatisfaction may appear when '
          'the current moment feels too confining.',
      shadowTr:
          'Mevcut an çok kısıtlayıcı hissettirdiğinde huzursuzluk '
          'veya kronik memnuniyetsizlik ortaya çıkabilir.',
      growthTipEn:
          'Balance exploration with presence. Your journal suggests '
          'that grounding practices help you integrate new '
          'discoveries more deeply.',
      growthTipTr:
          'Keşfi mevcudiyetle dengele. Kayıtların topraklama '
          'pratiklerinin yeni keşifleri daha derinden entegre etmene '
          'yardımcı olduğuna işaret ediyor.',
      growthAreasEn: [
        'Committing to a path long enough to see results',
        'Finding depth in familiar routines',
        'Building lasting roots alongside new adventures',
      ],
      growthAreasTr: [
        'Sonuçları görmek için bir yola yeterince bağlanmak',
        'Bilindik rutinlerde derinlik bulmak',
        'Yeni maceralarla birlikte kalıcı kökler oluşturmak',
      ],
      dailyIntentionStyleEn:
          'Choose one new perspective or micro-adventure to explore today, '
          'then journal what you discovered.',
      dailyIntentionStyleTr:
          'Bugün keşfetmek için yeni bir bakış açısı veya mikro-macera seç, '
          'sonra keşfettiklerini kaydet.',
      compatibleArchetypes: ['creator', 'hero', 'rebel'],
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
          'Kayıtların dünyayı düşünce ve bilgi yoluyla anlama '
          'konusunda derin bir dürtüye işaret ediyor. Netliği ve '
          'gerçeği her şeyden çok değerlendiriyor olabilirsin.',
      strengthsEn: ['Wisdom', 'Analytical mind', 'Objectivity', 'Insight'],
      strengthsTr: ['Bilgelik', 'Analitik düşünce', 'Objektivite', 'İçgörü'],
      shadowEn:
          'Over-analysis or emotional detachment may arise when you '
          'retreat too deeply into the mind.',
      shadowTr:
          'Zihne çok derine çekildiğin zamanlarda aşırı analiz veya '
          'duygusal kopukluk ortaya çıkabilir.',
      growthTipEn:
          'Let feeling guide you alongside thought. Your patterns '
          'suggest that emotional engagement enriches your '
          'understanding.',
      growthTipTr:
          'Duygunun düşüncenin yanında sana rehberlik etmesine izin '
          'ver. Kalıpların duygusal katılımın anlayışını '
          'zenginleştirdiğine işaret ediyor.',
      growthAreasEn: [
        'Trusting intuition alongside logic',
        'Taking action before having all the answers',
        'Expressing emotions without intellectualizing them',
      ],
      growthAreasTr: [
        'Mantık yanında sezgiye güven duymak',
        'Tüm cevaplara sahip olmadan harekete geçmek',
        'Duyguları entelektüelleştirmeden ifade etmek',
      ],
      dailyIntentionStyleEn:
          'Begin the day with a single question you want to sit with '
          '— not solve, just observe throughout the day.',
      dailyIntentionStyleTr:
          'Güne birlikte oturmak istediğin tek bir soruyla başla '
          '— çözmek değil, sadece gün boyunca gözlemlemek.',
      compatibleArchetypes: ['creator', 'ruler', 'magician'],
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
          'Günlük kalıpların kararlılık ve zorluklarla yüzyüze gelme '
          'isteğini yansıtma eğiliminde. Engelleri aşmakta güç '
          'buluyor olabilirsin.',
      strengthsEn: ['Courage', 'Discipline', 'Resilience', 'Determination'],
      strengthsTr: ['Cesaret', 'Disiplin', 'Dayanıklılık', 'Kararlılık'],
      shadowEn:
          'Burnout or an inability to ask for help may surface when '
          'the drive to prove yourself becomes relentless.',
      shadowTr:
          'Kendini kanıtlama dürtüsünün durmak bilmez hale geldiği '
          'zamanlarda tükenmişlik veya yardım isteyememe ortaya '
          'çıkabilir.',
      growthTipEn:
          'Rest is not retreat. Your entries suggest that recovery '
          'periods actually strengthen your capacity for future '
          'challenges.',
      growthTipTr:
          'Dinlenmek geri çekilme değildir. Kayıtların toparlanma '
          'dönemlerinin gelecek zorluklar için kapasiteni '
          'güçlendirdiğine işaret ediyor.',
      growthAreasEn: [
        'Accepting vulnerability as a form of strength',
        'Delegating instead of carrying everything alone',
        'Celebrating small wins, not only major victories',
      ],
      growthAreasTr: [
        'Savunmasızlığı bir güç formu olarak kabul etmek',
        'Her şeyi tek başına taşımak yerine yetki devretmek',
        'Sadece büyük zaferler değil, küçük kazanımları kutlamak',
      ],
      dailyIntentionStyleEn:
          'Identify one challenge to face today and one way to '
          'recover afterward — strength needs rhythm.',
      dailyIntentionStyleTr:
          'Bugün yüzleşecek bir zorluk ve sonrasında toparlanacak '
          'bir yol belirle — gücün ritme ihtiyacı var.',
      compatibleArchetypes: ['explorer', 'ruler', 'rebel'],
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
          'Kayıtların normları sorgulama ve kendi yolunu açma '
          'konusunda güçlü bir arzuya işaret ediyor. Anlamlı '
          'değişim yaratmak için mevcut durumu sarsmakla uyum '
          'içinde olabilirsin.',
      strengthsEn: ['Independence', 'Bravery', 'Authenticity', 'Conviction'],
      strengthsTr: ['Bağımsızlık', 'Yüreklilik', 'Otantiklik', 'İnanç'],
      shadowEn:
          'Isolation or self-sabotage may emerge when rebellion '
          'becomes its own end rather than a path to something '
          'constructive.',
      shadowTr:
          'İsyan yapıcı bir şeye giden yol yerine kendi amacı haline '
          'geldiğinde izolasyon veya kendine zarar verme ortaya '
          'çıkabilir.',
      growthTipEn:
          'Channel disruption into creation. Your journal suggests '
          'that your rebellious energy is most powerful when it '
          'builds something new.',
      growthTipTr:
          'Bozmayı yaratmaya kanalize et. Kayıtların asi enerjinin '
          'yeni bir şey inşa ettiğinde en güçlü olduğuna işaret '
          'ediyor.',
      growthAreasEn: [
        'Choosing battles that truly matter',
        'Building bridges alongside breaking barriers',
        'Channeling anger into constructive vision',
      ],
      growthAreasTr: [
        'Gerçekten önemli olan savaşları seçmek',
        'Bariyerleri kırarken köprüler de kurmak',
        'Öfkeyi yapıcı bir vizyona kanalize etmek',
      ],
      dailyIntentionStyleEn:
          'Ask yourself: "What do I want to change today, and what '
          'will I create in its place?"',
      dailyIntentionStyleTr:
          'Kendine sor: "Bugün neyi değiştirmek istiyorum ve yerine '
          'ne yaratacağım?"',
      compatibleArchetypes: ['explorer', 'hero', 'magician'],
    ),
    Archetype(
      id: 'magician',
      nameEn: 'The Magician',
      nameTr: 'Büyücü',
      emoji: '\u{2728}',
      descriptionEn:
          'Your patterns suggest a gift for transformation and '
          'seeing connections others miss. You may resonate with '
          'turning vision into reality through inner work.',
      descriptionTr:
          'Kalıpların dönüşüm ve başkalarının kaçırdığı bağlantıları '
          'görme konusunda bir yeteneğine işaret ediyor. İç çalışma '
          'yoluyla vizyonu gerçekliğe çevirmeyle uyum içinde '
          'olabilirsin.',
      strengthsEn: [
        'Adaptability',
        'Intuition',
        'Resourcefulness',
        'Awareness',
      ],
      strengthsTr: ['Dönüşüm', 'Sezgi', 'Beceriklilik', 'Farkındalık'],
      shadowEn:
          'Manipulation or disconnection from reality may arise when '
          'the desire for control overrides authentic connection.',
      shadowTr:
          'Kontrol arzusu otantik bağlantının önüne geçtiğinde '
          'manipülasyon veya gerçeklikten kopma ortaya çıkabilir.',
      growthTipEn:
          'Ground your vision in everyday action. Your entries '
          'suggest that small, consistent steps create the most '
          'lasting transformation.',
      growthTipTr:
          'Vizyonunu gündelik eyleme temelle. Kayıtların küçük, '
          'tutarlı adımların en kalıcı dönüşümü yarattığına işaret '
          'ediyor.',
      growthAreasEn: [
        'Staying grounded while pursuing transformation',
        'Sharing your process openly rather than keeping it hidden',
        'Accepting that some things cannot be changed by will alone',
      ],
      growthAreasTr: [
        'Dönüşümü takip ederken ayaklarını yere basmak',
        'Sürecini gizli tutmak yerine açıkça paylaşmak',
        'Bazı şeylerin sadece irade ile değiştirilemeyeceğini kabul etmek',
      ],
      dailyIntentionStyleEn:
          'Set a single transformative intention: "Today I will shift '
          'one small pattern that no longer serves me."',
      dailyIntentionStyleTr:
          'Tek bir dönüştürücü niyet belirle: "Bugün bana artık hizmet '
          'etmeyen küçük bir kalıbı değiştireceğim."',
      compatibleArchetypes: ['sage', 'creator', 'rebel'],
    ),
    Archetype(
      id: 'lover',
      nameEn: 'The Lover',
      nameTr: 'Aşık',
      emoji: '\u{1F49C}',
      descriptionEn:
          'Your journal entries tend to reflect deep emotional '
          'sensitivity and a desire for authentic connection. You '
          'may find meaning in intimacy, beauty, and passion.',
      descriptionTr:
          'Günlük kayıtların derin duygusal hassasiyet ve otantik '
          'bağlantı arzusunu yansıtma eğiliminde. Yakınlık, güzellik '
          've tutkuda anlam buluyor olabilirsin.',
      strengthsEn: ['Empathy', 'Passion', 'Devotion', 'Appreciation'],
      strengthsTr: ['Empati', 'Tutku', 'Adanmışlık', 'Takdir'],
      shadowEn:
          'People-pleasing or losing yourself in others may surface '
          'when the need for connection overshadows looking after yourself.',
      shadowTr:
          'Bağlantı ihtiyacı kendinize bakmanın önüne geçtiğinde başkalarını '
          'memnun etme veya başkaları içinde kaybolma ortaya '
          'çıkabilir.',
      growthTipEn:
          'Take care of yourself first. Your patterns suggest that the '
          'deepest connections grow from a place of inner '
          'stability.',
      growthTipTr:
          'Önce kendine dikkat et. Kalıpların en derin bağlantıların iç '
          'dengeden büyüdüğüne işaret ediyor.',
      growthAreasEn: [
        'Setting healthy boundaries in close relationships',
        'Distinguishing your emotions from those of others',
        'Allowing silence and solitude to nourish you',
      ],
      growthAreasTr: [
        'Yakın ilişkilerde sağlıklı sınırlar koymak',
        'Kendi duygularını başkalarınınkinden ayırt etmek',
        'Sessizlik ve yalnızlığın seni beslemesine izin vermek',
      ],
      dailyIntentionStyleEn:
          'Begin the day by naming one relationship you want to '
          'nurture and one way you might nurture yourself.',
      dailyIntentionStyleTr:
          'Güne beslemek istediğin bir ilişkiyi ve kendini '
          'besleyecek bir yolu adlandırarak başla.',
      compatibleArchetypes: ['caregiver', 'creator', 'innocent'],
    ),
    Archetype(
      id: 'caregiver',
      nameEn: 'The Caregiver',
      nameTr: 'Bakıcı',
      emoji: '\u{1F49A}',
      descriptionEn:
          'Your entries suggest a natural orientation toward '
          'nurturing and supporting others. You may find deep '
          'fulfillment in service and compassion.',
      descriptionTr:
          'Kayıtların başkalarına bakma ve destek olma konusunda '
          'doğal bir yönelime işaret ediyor. Hizmet ve merhamette '
          'derin tatmin buluyor olabilirsin.',
      strengthsEn: ['Compassion', 'Generosity', 'Nurturing', 'Loyalty'],
      strengthsTr: ['Merhamet', 'Cömertlik', 'Besleyicilik', 'Sadakat'],
      shadowEn:
          'Martyrdom or resentment may build when giving becomes '
          'depleting rather than fulfilling.',
      shadowTr:
          'Vermek tatmin edici olmaktan çıkıp tüketen hale '
          'geldiğinde şehitlik veya kızgınlık birikebilir.',
      growthTipEn:
          'Fill your own cup first. Your journal suggests that '
          'boundaries actually deepen your ability to care for '
          'others authentically.',
      growthTipTr:
          'Önce kendi kabını doldur. Kayıtların sınırların aslında '
          'başkalarına otantik bir şekilde bakma yeteneğini '
          'derinleştirdiğine işaret ediyor.',
      growthAreasEn: [
        'Saying no without guilt when your energy is low',
        'Receiving care as readily as you give it',
        'Recognizing when helping becomes enabling',
      ],
      growthAreasTr: [
        'Enerjin düşükken suçluluk duymadan hayır demek',
        'Verdiğin kadar kolaylıkla bakım almak',
        'Yardım etmenin bağımlılık yaratmaya dönüştüğünü fark etmek',
      ],
      dailyIntentionStyleEn:
          'Choose one act of care for someone else and one equal '
          'act of care for yourself today.',
      dailyIntentionStyleTr:
          'Bugün başkası için bir bakım eylemi ve kendin için eşit '
          'bir bakım eylemi seç.',
      compatibleArchetypes: ['lover', 'sage', 'innocent'],
    ),
    Archetype(
      id: 'ruler',
      nameEn: 'The Ruler',
      nameTr: 'Hükümdar',
      emoji: '\u{1F451}',
      descriptionEn:
          'Your patterns tend to reflect a desire for order, '
          'structure, and responsibility. You may resonate with '
          'taking charge and creating stability around you.',
      descriptionTr:
          'Kalıpların düzen, yapı ve sorumluluk arzusunu yansıtma '
          'eğiliminde. Kontrolü ele alma ve çevrenizde istikrar '
          'yaratmayla uyum içinde olabilirsin.',
      strengthsEn: ['Leadership', 'Organization', 'Confidence', 'Stability'],
      strengthsTr: ['Liderlik', 'Organizasyon', 'Güven', 'İstikrar'],
      shadowEn:
          'Rigidity or controlling behavior may emerge when '
          'uncertainty threatens your sense of order.',
      shadowTr:
          'Belirsizlik düzen hissini tehdit ettiğinde katılık veya '
          'kontrolcü davranış ortaya çıkabilir.',
      growthTipEn:
          'Lead by letting go. Your entries suggest that true '
          'authority comes from flexibility, not control.',
      growthTipTr:
          'Bırakarak liderlik et. Kayıtların gerçek otoritenin '
          'kontrolden değil esneklikten geldiğine işaret ediyor.',
      growthAreasEn: [
        'Allowing plans to shift without seeing it as failure',
        'Listening to others perspectives before deciding',
        'Embracing uncertainty as a source of possibility',
      ],
      growthAreasTr: [
        'Planların değişmesini başarısızlık olarak görmeden izin vermek',
        'Karar vermeden önce başkalarının bakış açılarını dinlemek',
        'Belirsizliği bir olasılık kaynağı olarak kucaklamak',
      ],
      dailyIntentionStyleEn:
          'Set your top three priorities for the day, then release '
          'attachment to how they unfold.',
      dailyIntentionStyleTr:
          'Günün ilk üç önceliğini belirle, sonra nasıl '
          'gelişeceklerine olan bağlılığını bırak.',
      compatibleArchetypes: ['hero', 'sage', 'caregiver'],
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
          'Kayıtların iyimser bir bakış açısı ve sadelik ve güvenlik '
          'arzusuna işaret ediyor. Anda mutluluk bulmak ve sürece '
          'güvenmeyle uyum içinde olabilirsin.',
      strengthsEn: ['Optimism', 'Trust', 'Simplicity', 'Joy'],
      strengthsTr: ['İyimserlik', 'Güven', 'Sadelik', 'Neşe'],
      shadowEn:
          'Naivety or denial may surface when avoiding difficult '
          'truths feels safer than confronting them.',
      shadowTr:
          'Zor gerçeklerden kaçınmak onlarla yüzleşmekten daha '
          'güvenli hissettirdiğinde saflık veya inkâr ortaya '
          'çıkabilir.',
      growthTipEn:
          'Hold your optimism and your awareness together. Your '
          'journal suggests that acknowledging shadows actually '
          'strengthens your light.',
      growthTipTr:
          'İyimserliğini ve farkındalığını birlikte tut. Kayıtların '
          'gölgeleri kabul etmenin aslında ışığını güçlendirdiğine '
          'işaret ediyor.',
      growthAreasEn: [
        'Facing uncomfortable truths with gentle courage',
        'Building resilience through small challenges',
        'Balancing hope with practical preparedness',
      ],
      growthAreasTr: [
        'Rahatsız edici gerçeklerle nazik cesaretle yüzleşmek',
        'Küçük zorluklar yoluyla dayanıklılık oluşturmak',
        'Umudu pratik hazırlıkla dengelemek',
      ],
      dailyIntentionStyleEn:
          'Start the day with gratitude for three simple things, '
          'then name one small discomfort you are willing to sit with.',
      dailyIntentionStyleTr:
          'Güne üç basit şey için minnettarlıkla başla, sonra '
          'birlikte oturmaya istekli olduğun küçük bir rahatsızlığı adlandır.',
      compatibleArchetypes: ['caregiver', 'lover', 'jester'],
    ),
    Archetype(
      id: 'jester',
      nameEn: 'The Jester',
      nameTr: 'Soytarı',
      emoji: '\u{1F3AD}',
      descriptionEn:
          'Your patterns suggest a gift for lightness and finding '
          'humor even in difficulty. You may resonate with using '
          'playfulness as a path to deeper truth.',
      descriptionTr:
          'Kalıpların hafiflik ve zorlukta bile mizah bulma '
          'konusunda bir yeteneğine işaret ediyor. Eğlenceyi daha '
          'derin gerçeğin yolu olarak kullanmakla uyum içinde '
          'olabilirsin.',
      strengthsEn: ['Humor', 'Playfulness', 'Perspective', 'Resilience'],
      strengthsTr: ['Mizah', 'Oyunculuk', 'Perspektif', 'Dayanıklılık'],
      shadowEn:
          'Avoidance through humor or difficulty being taken '
          'seriously may emerge when vulnerability feels unsafe.',
      shadowTr:
          'Savunmasızlık güvensiz hissettirdiğinde mizah yoluyla '
          'kaçınma veya ciddiye alınmama zorluğu ortaya çıkabilir.',
      growthTipEn:
          'Let yourself be seen beyond the humor. Your entries '
          'suggest that your most meaningful connections happen '
          'when you lower the mask.',
      growthTipTr:
          'Kendini mizahın ötesinde göstermeye izin ver. Kayıtların '
          'en anlamlı bağlantıların maskeyi indirdiğin zaman '
          'olduğuna işaret ediyor.',
      growthAreasEn: [
        'Allowing yourself to feel sadness without deflecting it',
        'Sharing a sincere thought without humor as a shield',
        'Sitting with silence instead of filling it with laughter',
      ],
      growthAreasTr: [
        'Hüznü saptırmadan hissetmenize izin vermek',
        'Mizahı kalkan olarak kullanmadan samimi bir düşünce paylaşmak',
        'Kahkahayla doldurmak yerine sessizlikle oturmak',
      ],
      dailyIntentionStyleEn:
          'Start the day with something that makes you smile, '
          'then write one honest sentence about how you really feel.',
      dailyIntentionStyleTr:
          'Güne seni güldüren bir şeyle başla, sonra gerçekten '
          'nasıl hissettiğin hakkında samimi bir cümle yaz.',
      compatibleArchetypes: ['innocent', 'explorer', 'lover'],
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
          'Kayıtların hayatın zorluklarının derin farkındalığına ve '
          'zor kazanılmış bir dayanıklılığa işaret ediyor. Paylaşılan '
          'deneyim yoluyla otantik aidiyet inşa etmeyle uyum içinde '
          'olabilirsin.',
      strengthsEn: ['Empathy', 'Realism', 'Resilience', 'Solidarity'],
      strengthsTr: ['Empati', 'Gerçekçilik', 'Dayanıklılık', 'Dayanışma'],
      shadowEn:
          'Victimhood or cynicism may arise when past wounds become '
          'the lens through which all new experiences are filtered.',
      shadowTr:
          'Geçmiş yaralar tüm yeni deneyimlerin filtrelendiği '
          'mercek haline geldiğinde mağdurluk veya kinizm ortaya '
          'çıkabilir.',
      growthTipEn:
          'Your wounds are your wisdom. Your journal suggests that '
          'sharing your story with trusted others transforms pain '
          'into connection.',
      growthTipTr:
          'Yaraların bilgeliğindir. Kayıtların hikâyeni güvendiğin '
          'insanlarla paylaşmanın acıyı bağlantıya dönüştürdüğüne '
          'işaret ediyor.',
      growthAreasEn: [
        'Trusting new experiences without projecting past hurt',
        'Accepting support without feeling like a burden',
        'Separating current reality from old patterns of pain',
      ],
      growthAreasTr: [
        'Geçmiş acıyı yansıtmadan yeni deneyimlere güvenmek',
        'Yük gibi hissetmeden destek kabul etmek',
        'Mevcut gerçekliği eski acı kalıplardan ayırmak',
      ],
      dailyIntentionStyleEn:
          'Name one thing from the past you are ready to release '
          'and one new experience you are open to receiving today.',
      dailyIntentionStyleTr:
          'Geçmişten bırakmaya hazır olduğun bir şeyi ve bugün '
          'almaya açık olduğun yeni bir deneyimi adlandır.',
      compatibleArchetypes: ['caregiver', 'hero', 'sage'],
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
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Snapshot date parse failed: $e');
        }
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
    final existingIdx = history.indexWhere(
      (s) => s.month == month && s.year == year,
    );
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

  /// Set initial archetype from onboarding quiz (before any journal data)
  Future<void> setInitialArchetype(String archetypeId) async {
    final now = DateTime.now();
    final snapshot = ArchetypeSnapshot(
      month: now.month,
      year: now.year,
      archetypeId: archetypeId,
      confidence: 0.5, // Low confidence — from quiz, not journal data
    );
    final history = getArchetypeHistory();
    history.add(snapshot);
    final jsonList = history
        .map(
          (s) => {
            'month': s.month,
            'year': s.year,
            'archetypeId': s.archetypeId,
            'confidence': s.confidence,
          },
        )
        .toList();
    await _prefs.setString(_historyKey, json.encode(jsonList));
  }

  /// Clear all archetype data
  Future<void> clearAll() async {
    await _prefs.remove(_historyKey);
    await _prefs.remove(_lastSnapshotKey);
  }
}
