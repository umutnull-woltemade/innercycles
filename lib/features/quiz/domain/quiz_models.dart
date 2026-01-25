/// Quiz Segmentation Models
/// Google Discover → Quiz → Premium funnel için model sınıfları

/// Quiz segmentasyonu - kullanıcının premium'a dönüşüm olasılığı
enum QuizSegment {
  low,    // Düşük - Soft CTA veya skip
  medium, // Orta - Normal premium teklifi
  high,   // Yüksek - Agresif premium teklif (%30-40 dönüşüm hedefi)
}

/// Quiz tipi
enum QuizType {
  dream,      // Rüya yorumu quiz'i
  astrology,  // Astroloji quiz'i
  numerology, // Numeroloji quiz'i
  general,    // Genel keşif quiz'i
  personality, // Kişilik testi
}

/// Tek bir quiz cevabı
class QuizAnswer {
  final String text;
  final String? emoji;
  final int weight; // Segment hesaplama için ağırlık (1-5)
  final Map<String, dynamic>? metadata;

  const QuizAnswer({
    required this.text,
    this.emoji,
    this.weight = 3,
    this.metadata,
  });
}

/// Tek bir quiz sorusu
class QuizQuestion {
  final String text;
  final String? emoji;
  final List<QuizAnswer> answers;
  final String? hint;

  const QuizQuestion({
    required this.text,
    this.emoji,
    required this.answers,
    this.hint,
  });
}

/// Quiz sonucu
class QuizResult {
  final String title;
  final String description;
  final String emoji;
  final QuizSegment segment;
  final int score;
  final Map<String, dynamic>? insights;
  final String? recommendedRoute; // Premium sonrası yönlendirme

  const QuizResult({
    required this.title,
    required this.description,
    required this.emoji,
    required this.segment,
    required this.score,
    this.insights,
    this.recommendedRoute,
  });
}

/// Tam quiz yapısı
class Quiz {
  final String id;
  final String title;
  final String description;
  final QuizType type;
  final List<QuizQuestion> questions;
  final String? coverImage; // Discover cover image
  final Map<String, dynamic>? metadata;

  const Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.questions,
    this.coverImage,
    this.metadata,
  });

  int get questionCount => questions.length;
}

/// Quiz CTA içeriği - sayfalarda gösterilecek
class QuizCTA {
  final String headline;
  final String subtext;
  final String buttonText;
  final String quizType;
  final String? emoji;

  const QuizCTA({
    required this.headline,
    required this.subtext,
    required this.buttonText,
    required this.quizType,
    this.emoji,
  });

  /// Rüya sayfası için varsayılan CTA
  static const QuizCTA dream = QuizCTA(
    headline: 'Bu rüya herkeste aynı anlama gelmez...',
    subtext: 'Kısa bir test, bunun sana özel olup olmadığını gösterebilir.',
    buttonText: 'Kısa Testi Gör',
    quizType: 'dream',
    emoji: '🔮',
  );

  /// Burç sayfası için CTA
  static const QuizCTA astrology = QuizCTA(
    headline: 'Burç yorumun sana ne kadar uyuyor?',
    subtext: '3 soruluk test ile kozmik uyumunu keşfet.',
    buttonText: 'Testi Başlat',
    quizType: 'astrology',
    emoji: '⭐',
  );

  /// Numeroloji sayfası için CTA
  static const QuizCTA numerology = QuizCTA(
    headline: 'Sayılar sana ne söylüyor?',
    subtext: 'Yaşam yolunu keşfetmek için kısa bir test.',
    buttonText: 'Sayı Testini Gör',
    quizType: 'numerology',
    emoji: '🔢',
  );

  /// Genel keşif CTA
  static const QuizCTA general = QuizCTA(
    headline: 'Kozmik profilini keşfet',
    subtext: 'Kısa bir test ile ruhsal yolculuğuna başla.',
    buttonText: 'Teste Başla',
    quizType: 'general',
    emoji: '✨',
  );
}
