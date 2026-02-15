/// Emotional Vocabulary — 36 granular emotion labels
/// Organized by 6 core emotion families (joy, sadness, anger, fear, surprise, calm).
/// Each emotion has bilingual names, descriptions, intensity levels,
/// and body sensation mapping for enhanced emotional literacy.
/// Apple App Store 4.3(b) compliant. Educational and reflective only.
library;

// ═══════════════════════════════════════════════════════════════════════════
// ENUMS
// ═══════════════════════════════════════════════════════════════════════════

enum EmotionFamily {
  joy,
  sadness,
  anger,
  fear,
  surprise,
  calm;

  String get displayNameEn {
    switch (this) {
      case joy:
        return 'Joy';
      case sadness:
        return 'Sadness';
      case anger:
        return 'Anger';
      case fear:
        return 'Fear';
      case surprise:
        return 'Surprise';
      case calm:
        return 'Calm';
    }
  }

  String get displayNameTr {
    switch (this) {
      case joy:
        return 'Sevinç';
      case sadness:
        return 'Üzüntü';
      case anger:
        return 'Öfke';
      case fear:
        return 'Korku';
      case surprise:
        return 'Şaşkınlık';
      case calm:
        return 'Huzur';
    }
  }

  String get emoji {
    switch (this) {
      case joy:
        return '😊';
      case sadness:
        return '😢';
      case anger:
        return '😤';
      case fear:
        return '😰';
      case surprise:
        return '😮';
      case calm:
        return '😌';
    }
  }
}

enum EmotionIntensity {
  low,
  medium,
  high;

  String get displayNameEn {
    switch (this) {
      case low:
        return 'Mild';
      case medium:
        return 'Moderate';
      case high:
        return 'Intense';
    }
  }

  String get displayNameTr {
    switch (this) {
      case low:
        return 'Hafif';
      case medium:
        return 'Orta';
      case high:
        return 'Yoğun';
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MODEL
// ═══════════════════════════════════════════════════════════════════════════

class GranularEmotion {
  final String id;
  final EmotionFamily family;
  final EmotionIntensity intensity;
  final String nameEn;
  final String nameTr;
  final String descriptionEn;
  final String descriptionTr;
  final String bodySensationEn; // where you might feel it
  final String bodySensationTr;
  final String emoji;

  const GranularEmotion({
    required this.id,
    required this.family,
    required this.intensity,
    required this.nameEn,
    required this.nameTr,
    required this.descriptionEn,
    required this.descriptionTr,
    required this.bodySensationEn,
    required this.bodySensationTr,
    required this.emoji,
  });
}

// ═══════════════════════════════════════════════════════════════════════════
// CONTENT — 36 Granular Emotions (6 per family)
// ═══════════════════════════════════════════════════════════════════════════

const List<GranularEmotion> allGranularEmotions = [
  // ═══════════════════════════════════════════════════════════════
  // JOY FAMILY — 6 emotions
  // ═══════════════════════════════════════════════════════════════
  GranularEmotion(
    id: 'joy_content',
    family: EmotionFamily.joy,
    intensity: EmotionIntensity.low,
    nameEn: 'Content',
    nameTr: 'Memnun',
    descriptionEn: 'A quiet satisfaction with the present moment, without needing anything to change.',
    descriptionTr: 'Hiçbir şeyin değişmesine gerek duymadan şu anla sessiz bir memnuniyet.',
    bodySensationEn: 'Relaxed shoulders, steady breathing, soft belly',
    bodySensationTr: 'Gevşemiş omuzlar, düzenli nefes, yumuşak karın',
    emoji: '😌',
  ),
  GranularEmotion(
    id: 'joy_grateful',
    family: EmotionFamily.joy,
    intensity: EmotionIntensity.low,
    nameEn: 'Grateful',
    nameTr: 'Minnettar',
    descriptionEn: 'A warm recognition of something good in your life that you do not take for granted.',
    descriptionTr: 'Hayatınızda hafife almadığınız güzel bir şeyin sıcak farkındalığı.',
    bodySensationEn: 'Warmth in the chest, gentle smile, open hands',
    bodySensationTr: 'Göğüste sıcaklık, hafif gülümseme, açık eller',
    emoji: '🙏',
  ),
  GranularEmotion(
    id: 'joy_excited',
    family: EmotionFamily.joy,
    intensity: EmotionIntensity.high,
    nameEn: 'Excited',
    nameTr: 'Heyecanlı',
    descriptionEn: 'A buzzing anticipation for something you are looking forward to.',
    descriptionTr: 'Sabırsızlıkla beklediğiniz bir şey için vızıldayan bir beklenti.',
    bodySensationEn: 'Butterfly feeling in stomach, restless energy, wide eyes',
    bodySensationTr: 'Mide de kelebek hissi, yerinde duramama, açık gözler',
    emoji: '🤩',
  ),
  GranularEmotion(
    id: 'joy_proud',
    family: EmotionFamily.joy,
    intensity: EmotionIntensity.medium,
    nameEn: 'Proud',
    nameTr: 'Gururlu',
    descriptionEn: 'A sense of accomplishment and self-respect for something you did or who you are.',
    descriptionTr: 'Yaptığınız bir şey veya kim olduğunuz için başarı ve öz saygı duygusu.',
    bodySensationEn: 'Upright posture, lifted chin, expansive chest',
    bodySensationTr: 'Dik duruş, kaldırılmış çene, genişlemiş göğüs',
    emoji: '💪',
  ),
  GranularEmotion(
    id: 'joy_playful',
    family: EmotionFamily.joy,
    intensity: EmotionIntensity.medium,
    nameEn: 'Playful',
    nameTr: 'Eğlenceli',
    descriptionEn: 'A light, carefree energy that wants to laugh, create, or be spontaneous.',
    descriptionTr: 'Gülmek, yaratmak veya spontan olmak isteyen hafif, kaygısız bir enerji.',
    bodySensationEn: 'Light feet, energized limbs, easy laughter',
    bodySensationTr: 'Hafif ayaklar, enerjik uzuvlar, kolay kahkaha',
    emoji: '😄',
  ),
  GranularEmotion(
    id: 'joy_hopeful',
    family: EmotionFamily.joy,
    intensity: EmotionIntensity.low,
    nameEn: 'Hopeful',
    nameTr: 'Umutlu',
    descriptionEn: 'A gentle belief that things can improve, even when the current situation is difficult.',
    descriptionTr: 'Mevcut durum zor olsa bile işlerin iyileşebileceğine dair yumuşak bir inanç.',
    bodySensationEn: 'Lightness in the chest, forward-leaning posture',
    bodySensationTr: 'Göğüste hafiflik, ileriye eğik duruş',
    emoji: '🌱',
  ),

  // ═══════════════════════════════════════════════════════════════
  // SADNESS FAMILY — 6 emotions
  // ═══════════════════════════════════════════════════════════════
  GranularEmotion(
    id: 'sad_melancholy',
    family: EmotionFamily.sadness,
    intensity: EmotionIntensity.low,
    nameEn: 'Melancholic',
    nameTr: 'Melankolik',
    descriptionEn: 'A gentle, bittersweet sadness — not sharp pain, but a wistful awareness of loss or impermanence.',
    descriptionTr: 'Yumuşak, tatlı-acı bir üzüntü — keskin acı değil, kayıp veya geçiciliğin hüzünlü farkındalığı.',
    bodySensationEn: 'Heavy eyelids, slow movements, sighing',
    bodySensationTr: 'Ağır göz kapakları, yavaş hareketler, iç çekme',
    emoji: '🥀',
  ),
  GranularEmotion(
    id: 'sad_lonely',
    family: EmotionFamily.sadness,
    intensity: EmotionIntensity.medium,
    nameEn: 'Lonely',
    nameTr: 'Yalnız',
    descriptionEn: 'A longing for connection that feels out of reach, even when others are physically present.',
    descriptionTr: 'Başkaları fiziksel olarak orada olsa bile ulaşılamaz hissedilen bir bağlantı özlemi.',
    bodySensationEn: 'Hollowness in the chest, desire to curl inward',
    bodySensationTr: 'Göğüste boşluk, içe doğru kıvrılma isteği',
    emoji: '😔',
  ),
  GranularEmotion(
    id: 'sad_disappointed',
    family: EmotionFamily.sadness,
    intensity: EmotionIntensity.medium,
    nameEn: 'Disappointed',
    nameTr: 'Hayal Kırıklığı',
    descriptionEn: 'The gap between what you expected and what actually happened.',
    descriptionTr: 'Beklentileriniz ile gerçekte olanlar arasındaki boşluk.',
    bodySensationEn: 'Sinking feeling in stomach, dropped shoulders',
    bodySensationTr: 'Midede çökme hissi, düşmüş omuzlar',
    emoji: '😞',
  ),
  GranularEmotion(
    id: 'sad_grief',
    family: EmotionFamily.sadness,
    intensity: EmotionIntensity.high,
    nameEn: 'Grieving',
    nameTr: 'Yas Tutan',
    descriptionEn: 'A deep sorrow for something or someone you have lost. This is a natural, necessary process.',
    descriptionTr: 'Kaybettiğiniz bir şey veya biri için derin bir üzüntü. Bu doğal ve gerekli bir süreçtir.',
    bodySensationEn: 'Heaviness everywhere, tightness in the throat, waves of tears',
    bodySensationTr: 'Her yerde ağırlık, boğazda sıkılma, gözyaşı dalgaları',
    emoji: '💔',
  ),
  GranularEmotion(
    id: 'sad_nostalgic',
    family: EmotionFamily.sadness,
    intensity: EmotionIntensity.low,
    nameEn: 'Nostalgic',
    nameTr: 'Nostaljik',
    descriptionEn: 'A wistful longing for a time, place, or feeling from the past.',
    descriptionTr: 'Geçmişten bir zaman, yer veya duygu için hüzünlü bir özlem.',
    bodySensationEn: 'Distant gaze, warmth mixed with aching',
    bodySensationTr: 'Uzak bakış, sızıyla karışmış sıcaklık',
    emoji: '🕰️',
  ),
  GranularEmotion(
    id: 'sad_empty',
    family: EmotionFamily.sadness,
    intensity: EmotionIntensity.high,
    nameEn: 'Empty',
    nameTr: 'Boş',
    descriptionEn: 'An absence of feeling — not peace, but a flatness where emotions usually live.',
    descriptionTr: 'Duygu yokluğu — huzur değil, duyguların genellikle yaşadığı yerde bir düzlük.',
    bodySensationEn: 'Numbness, detached feeling, low energy',
    bodySensationTr: 'Uyuşukluk, kopuk hissetme, düşük enerji',
    emoji: '🫥',
  ),

  // ═══════════════════════════════════════════════════════════════
  // ANGER FAMILY — 6 emotions
  // ═══════════════════════════════════════════════════════════════
  GranularEmotion(
    id: 'ang_irritated',
    family: EmotionFamily.anger,
    intensity: EmotionIntensity.low,
    nameEn: 'Irritated',
    nameTr: 'Sinirli',
    descriptionEn: 'A mild annoyance at something that is not going as expected or desired.',
    descriptionTr: 'Beklendiği veya istendiği gibi gitmeyen bir şeye karşı hafif bir rahatsızlık.',
    bodySensationEn: 'Slight jaw tension, impatience, restlessness',
    bodySensationTr: 'Hafif çene gerginliği, sabırsızlık, huzursuzluk',
    emoji: '😒',
  ),
  GranularEmotion(
    id: 'ang_frustrated',
    family: EmotionFamily.anger,
    intensity: EmotionIntensity.medium,
    nameEn: 'Frustrated',
    nameTr: 'Hayal Kırıklığına Uğramış',
    descriptionEn: 'The tension of wanting to move forward but being blocked by obstacles.',
    descriptionTr: 'İlerlemek istemek ama engellerle bloke edilmenin gerilimi.',
    bodySensationEn: 'Clenched fists, tense forehead, grinding teeth',
    bodySensationTr: 'Sıkılmış yumruklar, gergin alın, gıcırdayan dişler',
    emoji: '😤',
  ),
  GranularEmotion(
    id: 'ang_resentful',
    family: EmotionFamily.anger,
    intensity: EmotionIntensity.medium,
    nameEn: 'Resentful',
    nameTr: 'Kırgın',
    descriptionEn: 'A lingering bitterness about a perceived unfairness or unresolved hurt.',
    descriptionTr: 'Algılanan bir adaletsizlik veya çözülmemiş bir acı hakkında süregelen bir acılık.',
    bodySensationEn: 'Tightness in the chest, bitter taste, guarded posture',
    bodySensationTr: 'Göğüste sıkılma, acı tat, korunma duruşu',
    emoji: '😠',
  ),
  GranularEmotion(
    id: 'ang_overwhelmed',
    family: EmotionFamily.anger,
    intensity: EmotionIntensity.high,
    nameEn: 'Overwhelmed',
    nameTr: 'Bunalmış',
    descriptionEn: 'Too much input, too many demands — a system overload that often disguises itself as anger.',
    descriptionTr: 'Çok fazla girdi, çok fazla talep — kendini çoğu zaman öfke olarak gizleyen bir sistem aşırı yüklenmesi.',
    bodySensationEn: 'Racing heartbeat, shallow breathing, desire to escape',
    bodySensationTr: 'Hızlı kalp atışı, yüzeysel nefes, kaçma isteği',
    emoji: '🤯',
  ),
  GranularEmotion(
    id: 'ang_boundary',
    family: EmotionFamily.anger,
    intensity: EmotionIntensity.medium,
    nameEn: 'Boundary-Crossed',
    nameTr: 'Sınır Aşılmış',
    descriptionEn: 'The protective fire that rises when something important to you has been violated.',
    descriptionTr: 'Sizin için önemli bir şey ihlal edildiğinde yükselen koruyucu ateş.',
    bodySensationEn: 'Heat in the face, tension in arms, protective stance',
    bodySensationTr: 'Yüzde sıcaklık, kollarda gerilim, koruyucu duruş',
    emoji: '🛡️',
  ),
  GranularEmotion(
    id: 'ang_jealous',
    family: EmotionFamily.anger,
    intensity: EmotionIntensity.low,
    nameEn: 'Envious',
    nameTr: 'Kıskanç',
    descriptionEn: 'A painful awareness that someone has something you deeply want for yourself.',
    descriptionTr: 'Birinin kendiniz için derinden istediğiniz bir şeye sahip olduğunun acı verici farkındalığı.',
    bodySensationEn: 'Sinking stomach, comparing thoughts, inner discomfort',
    bodySensationTr: 'Çöken mide, karşılaştıran düşünceler, iç huzursuzluk',
    emoji: '😒',
  ),

  // ═══════════════════════════════════════════════════════════════
  // FEAR FAMILY — 6 emotions
  // ═══════════════════════════════════════════════════════════════
  GranularEmotion(
    id: 'fear_anxious',
    family: EmotionFamily.fear,
    intensity: EmotionIntensity.medium,
    nameEn: 'Anxious',
    nameTr: 'Kaygılı',
    descriptionEn: 'A future-oriented worry about something that may or may not happen.',
    descriptionTr: 'Olabilecek veya olmayabilecek bir şey hakkında geleceğe yönelik bir endişe.',
    bodySensationEn: 'Chest tightness, racing thoughts, stomach churning',
    bodySensationTr: 'Göğüs sıkışması, hızlı düşünceler, mide bulanması',
    emoji: '😰',
  ),
  GranularEmotion(
    id: 'fear_vulnerable',
    family: EmotionFamily.fear,
    intensity: EmotionIntensity.low,
    nameEn: 'Vulnerable',
    nameTr: 'Savunmasız',
    descriptionEn: 'A sense of being exposed or unprotected, often accompanied by tenderness.',
    descriptionTr: 'Açık veya korumasız olma hissi, genellikle hassasiyetle birlikte.',
    bodySensationEn: 'Open chest, urge to cover or hide, heightened sensitivity',
    bodySensationTr: 'Açık göğüs, örtünme veya saklanma dürtüsü, artmış hassasiyet',
    emoji: '🥺',
  ),
  GranularEmotion(
    id: 'fear_uncertain',
    family: EmotionFamily.fear,
    intensity: EmotionIntensity.low,
    nameEn: 'Uncertain',
    nameTr: 'Belirsiz',
    descriptionEn: 'The discomfort of not knowing what will happen next or which choice to make.',
    descriptionTr: 'Bundan sonra ne olacağını veya hangi seçimi yapacağını bilmemenin rahatsızlığı.',
    bodySensationEn: 'Unsettled stomach, wandering focus, slight tension',
    bodySensationTr: 'Tedirgin mide, dağınık odak, hafif gerilim',
    emoji: '🤔',
  ),
  GranularEmotion(
    id: 'fear_insecure',
    family: EmotionFamily.fear,
    intensity: EmotionIntensity.medium,
    nameEn: 'Insecure',
    nameTr: 'Güvensiz',
    descriptionEn: 'Doubting your own worth, abilities, or place — often triggered by comparison or rejection.',
    descriptionTr: 'Kendi değerinizi, yeteneklerinizi veya yerinizi sorgulamak — genellikle karşılaştırma veya reddedilme tarafından tetiklenir.',
    bodySensationEn: 'Hunched posture, avoiding eye contact, shrinking feeling',
    bodySensationTr: 'Kamburlaşmış duruş, göz temasından kaçınma, küçülme hissi',
    emoji: '😟',
  ),
  GranularEmotion(
    id: 'fear_dread',
    family: EmotionFamily.fear,
    intensity: EmotionIntensity.high,
    nameEn: 'Dread',
    nameTr: 'Dehşet',
    descriptionEn: 'A heavy anticipation of something you believe will be painful or harmful.',
    descriptionTr: 'Acı verici veya zararlı olacağına inandığınız bir şeyin ağır beklentisi.',
    bodySensationEn: 'Pit in stomach, cold hands, frozen feeling',
    bodySensationTr: 'Mide çukurunda boşluk, soğuk eller, donmuş hissetme',
    emoji: '😨',
  ),
  GranularEmotion(
    id: 'fear_shame',
    family: EmotionFamily.fear,
    intensity: EmotionIntensity.high,
    nameEn: 'Ashamed',
    nameTr: 'Utanmış',
    descriptionEn: 'A painful feeling of being fundamentally flawed, not just that you did something wrong.',
    descriptionTr: 'Temel olarak kusurlu olma hissi, sadece yanlış bir şey yaptığınız değil.',
    bodySensationEn: 'Heat in face, desire to disappear, hunched posture',
    bodySensationTr: 'Yüzde sıcaklık, yok olma isteği, kamburlaşmış duruş',
    emoji: '😣',
  ),

  // ═══════════════════════════════════════════════════════════════
  // SURPRISE FAMILY — 6 emotions
  // ═══════════════════════════════════════════════════════════════
  GranularEmotion(
    id: 'sur_curious',
    family: EmotionFamily.surprise,
    intensity: EmotionIntensity.low,
    nameEn: 'Curious',
    nameTr: 'Meraklı',
    descriptionEn: 'An open, engaged interest in something new or unknown.',
    descriptionTr: 'Yeni veya bilinmeyen bir şeye açık, meşgul bir ilgi.',
    bodySensationEn: 'Leaning forward, wide eyes, alert but relaxed',
    bodySensationTr: 'İleriye eğilme, açık gözler, uyanık ama rahat',
    emoji: '🧐',
  ),
  GranularEmotion(
    id: 'sur_amazed',
    family: EmotionFamily.surprise,
    intensity: EmotionIntensity.high,
    nameEn: 'Amazed',
    nameTr: 'Hayret',
    descriptionEn: 'A state of wonder when something exceeds your expectations in a positive way.',
    descriptionTr: 'Bir şey beklentilerinizi olumlu bir şekilde aştığında hayranlık durumu.',
    bodySensationEn: 'Jaw drop, goosebumps, expanded awareness',
    bodySensationTr: 'Çene düşmesi, tüyler diken diken, genişlemiş farkındalık',
    emoji: '🤯',
  ),
  GranularEmotion(
    id: 'sur_confused',
    family: EmotionFamily.surprise,
    intensity: EmotionIntensity.medium,
    nameEn: 'Confused',
    nameTr: 'Kafası Karışmış',
    descriptionEn: 'The mental fog of not being able to make sense of what is happening.',
    descriptionTr: 'Olan biteni anlamlandıramamanın zihinsel sisi.',
    bodySensationEn: 'Furrowed brow, head tilt, mental fog',
    bodySensationTr: 'Çatılmış kaşlar, baş eğme, zihinsel sis',
    emoji: '😵‍💫',
  ),
  GranularEmotion(
    id: 'sur_awe',
    family: EmotionFamily.surprise,
    intensity: EmotionIntensity.high,
    nameEn: 'Awestruck',
    nameTr: 'Huşu İçinde',
    descriptionEn: 'A profound sense of wonder in the presence of something vast or deeply meaningful.',
    descriptionTr: 'Büyük veya derinden anlamlı bir şeyin varlığında derin bir hayranlık duygusu.',
    bodySensationEn: 'Stillness, tears of wonder, feeling small but connected',
    bodySensationTr: 'Durgunluk, hayranlık gözyaşları, küçük ama bağlı hissetme',
    emoji: '✨',
  ),
  GranularEmotion(
    id: 'sur_inspired',
    family: EmotionFamily.surprise,
    intensity: EmotionIntensity.medium,
    nameEn: 'Inspired',
    nameTr: 'İlham Almış',
    descriptionEn: 'A surge of creative energy sparked by something you witnessed or experienced.',
    descriptionTr: 'Tanık olduğunuz veya deneyimlediğiniz bir şeyin ateşlediği yaratıcı enerji dalgası.',
    bodySensationEn: 'Tingling excitement, urge to create, mental clarity',
    bodySensationTr: 'Karıncalanan heyecan, yaratma dürtüsü, zihinsel netlik',
    emoji: '💡',
  ),
  GranularEmotion(
    id: 'sur_moved',
    family: EmotionFamily.surprise,
    intensity: EmotionIntensity.medium,
    nameEn: 'Moved',
    nameTr: 'Duygulanmış',
    descriptionEn: 'A deep emotional response to something beautiful, kind, or meaningful.',
    descriptionTr: 'Güzel, nazik veya anlamlı bir şeye derin bir duygusal yanıt.',
    bodySensationEn: 'Tears welling, warmth in chest, catch in throat',
    bodySensationTr: 'Gözyaşlarının birikmesi, göğüste sıcaklık, boğazda düğümlenme',
    emoji: '🥹',
  ),

  // ═══════════════════════════════════════════════════════════════
  // CALM FAMILY — 6 emotions
  // ═══════════════════════════════════════════════════════════════
  GranularEmotion(
    id: 'calm_peaceful',
    family: EmotionFamily.calm,
    intensity: EmotionIntensity.low,
    nameEn: 'Peaceful',
    nameTr: 'Huzurlu',
    descriptionEn: 'A quiet stillness where nothing needs to be fixed, achieved, or worried about.',
    descriptionTr: 'Hiçbir şeyin düzeltilmesi, başarılması veya endişelenilmesi gerekmeyen sessiz bir dinginlik.',
    bodySensationEn: 'Soft breath, relaxed muscles, gentle awareness',
    bodySensationTr: 'Yumuşak nefes, gevşemiş kaslar, nazik farkındalık',
    emoji: '☮️',
  ),
  GranularEmotion(
    id: 'calm_centered',
    family: EmotionFamily.calm,
    intensity: EmotionIntensity.medium,
    nameEn: 'Centered',
    nameTr: 'Merkezlenmiş',
    descriptionEn: 'A grounded stability where you feel connected to yourself and your values.',
    descriptionTr: 'Kendinize ve değerlerinize bağlı hissettiğiniz topraklanmış bir istikrar.',
    bodySensationEn: 'Feet on ground, balanced posture, clear mind',
    bodySensationTr: 'Yerde ayaklar, dengeli duruş, berrak zihin',
    emoji: '🧘',
  ),
  GranularEmotion(
    id: 'calm_safe',
    family: EmotionFamily.calm,
    intensity: EmotionIntensity.low,
    nameEn: 'Safe',
    nameTr: 'Güvende',
    descriptionEn: 'A deep sense of security — physical, emotional, or relational.',
    descriptionTr: 'Derin bir güvenlik duygusu — fiziksel, duygusal veya ilişkisel.',
    bodySensationEn: 'Soft shoulders, unclenched jaw, steady heartbeat',
    bodySensationTr: 'Yumuşak omuzlar, gevşemiş çene, düzenli kalp atışı',
    emoji: '🏠',
  ),
  GranularEmotion(
    id: 'calm_accepted',
    family: EmotionFamily.calm,
    intensity: EmotionIntensity.medium,
    nameEn: 'Accepted',
    nameTr: 'Kabul Görmüş',
    descriptionEn: 'Feeling seen and welcomed as you are, without needing to perform or prove.',
    descriptionTr: 'Performans göstermeye veya kanıtlamaya gerek duymadan olduğunuz gibi görüldüğünüzü ve kabul edildiğinizi hissetmek.',
    bodySensationEn: 'Relaxed face, open body, warmth in the heart',
    bodySensationTr: 'Gevşemiş yüz, açık beden, kalpte sıcaklık',
    emoji: '🤗',
  ),
  GranularEmotion(
    id: 'calm_relieved',
    family: EmotionFamily.calm,
    intensity: EmotionIntensity.medium,
    nameEn: 'Relieved',
    nameTr: 'Rahatlamış',
    descriptionEn: 'The release of tension after a stressful situation passes or resolves.',
    descriptionTr: 'Stresli bir durum geçtikten veya çözüldükten sonra gerginliğin bırakılması.',
    bodySensationEn: 'Deep exhale, dropping shoulders, lightness',
    bodySensationTr: 'Derin nefes verme, düşen omuzlar, hafiflik',
    emoji: '😮‍💨',
  ),
  GranularEmotion(
    id: 'calm_flow',
    family: EmotionFamily.calm,
    intensity: EmotionIntensity.high,
    nameEn: 'In Flow',
    nameTr: 'Akışta',
    descriptionEn: 'Complete absorption in an activity where challenge meets skill perfectly.',
    descriptionTr: 'Meydan okumanın beceriyle mükemmel bir şekilde buluştuğu bir aktiviteye tam dalış.',
    bodySensationEn: 'Loss of time awareness, effortless focus, quiet joy',
    bodySensationTr: 'Zaman algısı kaybı, zahmetsiz odak, sessiz sevinç',
    emoji: '🌊',
  ),
];

/// Helper to get emotions by family
List<GranularEmotion> getEmotionsByFamily(EmotionFamily family) {
  return allGranularEmotions.where((e) => e.family == family).toList();
}

/// Helper to get emotions by intensity
List<GranularEmotion> getEmotionsByIntensity(EmotionIntensity intensity) {
  return allGranularEmotions.where((e) => e.intensity == intensity).toList();
}
