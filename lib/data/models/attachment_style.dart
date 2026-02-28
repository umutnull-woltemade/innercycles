import 'package:innercycles/data/providers/app_providers.dart';
// ════════════════════════════════════════════════════════════════════════════
// ATTACHMENT STYLE MODEL - InnerCycles Self-Reflection Quiz
// ════════════════════════════════════════════════════════════════════════════
// Defines the four attachment style archetypes and quiz result storage.
// This is a self-reflection tool, NOT a clinical diagnostic instrument.
// Language: safe, reflective, non-prescriptive.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:ui';
import '../../core/theme/app_colors.dart';

/// The four primary attachment style archetypes used for self-reflection
enum AttachmentStyle {
  secure,
  anxiousPreoccupied,
  dismissiveAvoidant,
  fearfulAvoidant;

  // ══════════════════════════════════════════════════════════════════════════
  // DISPLAY NAMES
  // ══════════════════════════════════════════════════════════════════════════

  String get displayNameEn {
    switch (this) {
      case AttachmentStyle.secure:
        return 'Secure';
      case AttachmentStyle.anxiousPreoccupied:
        return 'Anxious-Preoccupied';
      case AttachmentStyle.dismissiveAvoidant:
        return 'Dismissive-Avoidant';
      case AttachmentStyle.fearfulAvoidant:
        return 'Fearful-Avoidant';
    }
  }

  String get displayNameTr {
    switch (this) {
      case AttachmentStyle.secure:
        return 'Güvenli';
      case AttachmentStyle.anxiousPreoccupied:
        return 'Kaygılı-Saplantılı';
      case AttachmentStyle.dismissiveAvoidant:
        return 'Kayıtsız-Kaçıngan';
      case AttachmentStyle.fearfulAvoidant:
        return 'Korkulu-Kaçıngan';
    }

  }

  String localizedName(AppLanguage language) => language.isEn ? displayNameEn : displayNameTr;

  // ══════════════════════════════════════════════════════════════════════════
  // DESCRIPTIONS
  // ══════════════════════════════════════════════════════════════════════════

  String get descriptionEn {
    switch (this) {
      case AttachmentStyle.secure:
        return 'You may tend to feel comfortable with emotional closeness and '
            'interdependence. You might notice that trust comes relatively '
            'naturally to you in relationships.';
      case AttachmentStyle.anxiousPreoccupied:
        return 'You may tend to seek high levels of closeness and reassurance '
            'from others. You might notice a heightened sensitivity to shifts '
            'in emotional availability from people you care about.';
      case AttachmentStyle.dismissiveAvoidant:
        return 'You may tend to value self-sufficiency and emotional '
            'independence. You might notice a preference for maintaining '
            'personal space, even with people you deeply care about.';
      case AttachmentStyle.fearfulAvoidant:
        return 'You may tend to experience a push-and-pull between wanting '
            'closeness and fearing vulnerability. You might notice conflicting '
            'desires for connection and self-protection.';
    }
  }

  String get descriptionTr {
    switch (this) {
      case AttachmentStyle.secure:
        return 'Duygusal yakınlık ve karşılıklı bağımlılık konusunda rahat '
            'hissedebilirsiniz. İlişkilerde güvenin size görece doğal '
            'geldiğini fark edebilirsiniz.';
      case AttachmentStyle.anxiousPreoccupied:
        return 'Başkalarından yüksek düzeyde yakınlık ve güvence arama '
            'eğiliminde olabilirsiniz. Önem verdiğiniz kişilerin duygusal '
            'erişilebilirliğindeki değişimlere karşı yoğun bir duyarlılık '
            'fark edebilirsiniz.';
      case AttachmentStyle.dismissiveAvoidant:
        return 'Öz yeterliliğe ve duygusal bağımsızlığa değer verme '
            'eğiliminde olabilirsiniz. Derinden önemsediğiniz kişilerle '
            'bile kişisel alanınızı koruma tercihinde bulunduğunuzu '
            'fark edebilirsiniz.';
      case AttachmentStyle.fearfulAvoidant:
        return 'Yakınlık isteme ile savunmasızlık korkusu arasında bir '
            'çekme-itme yaşayabilirsiniz. Bağlantı kurma ve kendini '
            'koruma arasında çelişkili arzular fark edebilirsiniz.';
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STRENGTHS
  // ══════════════════════════════════════════════════════════════════════════

  List<String> get strengthsEn {
    switch (this) {
      case AttachmentStyle.secure:
        return [
          'Comfortable expressing needs and emotions openly',
          'Able to offer and receive support with ease',
          'Tends to navigate conflict with calm and empathy',
        ];
      case AttachmentStyle.anxiousPreoccupied:
        return [
          'Deeply attuned to others\' emotional states',
          'Brings strong dedication and warmth to relationships',
          'Courageous in expressing feelings and seeking connection',
        ];
      case AttachmentStyle.dismissiveAvoidant:
        return [
          'Strong sense of personal identity and boundaries',
          'Able to remain composed under emotional pressure',
          'Brings stability and self-reliance to partnerships',
        ];
      case AttachmentStyle.fearfulAvoidant:
        return [
          'Deeply empathetic from having navigated complex emotions',
          'Highly perceptive about relational dynamics',
          'Capable of profound growth when given safe space',
        ];
    }
  }

  List<String> get strengthsTr {
    switch (this) {
      case AttachmentStyle.secure:
        return [
          'İhtiyaç ve duyguları açıkça ifade etmede rahat',
          'Kolayca destek verebilme ve alabilme',
          'Çatışmayı sakinlik ve empatiyle yönetme eğilimi',
        ];
      case AttachmentStyle.anxiousPreoccupied:
        return [
          'Başkalarının duygusal durumlarına derin uyum',
          'İlişkilere güçlü bağlılık ve sıcaklık katma',
          'Duyguları ifade etmede ve bağlantı aramada cesaret',
        ];
      case AttachmentStyle.dismissiveAvoidant:
        return [
          'Güçlü kişisel kimlik ve sınır duygusu',
          'Duygusal baskı altında sakin kalabilme',
          'İlişkilere istikrar ve öz güven katma',
        ];
      case AttachmentStyle.fearfulAvoidant:
        return [
          'Karmaşık duygularla başa çıkmaktan gelen derin empati',
          'İlişkisel dinamikleri algılamada yüksek sezgi',
          'Güvenli alan verildiğinde derin büyüme kapasitesi',
        ];
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // GROWTH AREAS
  // ══════════════════════════════════════════════════════════════════════════

  List<String> get growthAreasEn {
    switch (this) {
      case AttachmentStyle.secure:
        return [
          'Practicing patience when others need more reassurance',
          'Recognising that not everyone shares the same relational ease',
          'Staying curious about deeper layers beneath surface comfort',
        ];
      case AttachmentStyle.anxiousPreoccupied:
        return [
          'Building tolerance for uncertainty in relationships',
          'Developing self-soothing practices for anxious moments',
          'Learning to interpret silence as neutral rather than threatening',
        ];
      case AttachmentStyle.dismissiveAvoidant:
        return [
          'Exploring the vulnerability beneath self-sufficiency',
          'Practicing staying present during emotional conversations',
          'Noticing when independence becomes emotional withdrawal',
        ];
      case AttachmentStyle.fearfulAvoidant:
        return [
          'Building a sense of safety in gradual, small steps',
          'Distinguishing past pain from present relationship signals',
          'Practicing self-compassion when the push-pull cycle appears',
        ];
    }
  }

  List<String> get growthAreasTr {
    switch (this) {
      case AttachmentStyle.secure:
        return [
          'Başkalarının daha fazla güvenceye ihtiyaç duyduğunda sabır',
          'Herkesin aynı ilişkisel rahatlığı paylaşmadığını fark etme',
          'Yüzeysel rahatlığın altındaki daha derin katmanları keşfetme',
        ];
      case AttachmentStyle.anxiousPreoccupied:
        return [
          'İlişkilerdeki belirsizliğe tolerans geliştirme',
          'Kaygılı anlar için kendini sakinleştirme pratikleri',
          'Sessizliği tehdit yerine nötr olarak yorumlamayı öğrenme',
        ];
      case AttachmentStyle.dismissiveAvoidant:
        return [
          'Öz yeterliliğin altındaki savunmasızlığı keşfetme',
          'Duygusal konuşmalarda mevcut kalmayı pratik etme',
          'Bağımsızlığın duygusal geri çekilmeye dönüştüğünü fark etme',
        ];
      case AttachmentStyle.fearfulAvoidant:
        return [
          'Kademeli, küçük adımlarla güvenlik duygusu oluşturma',
          'Geçmiş acıyı mevcut ilişki sinyallerinden ayırt etme',
          'Çekme-itme döngüsü ortaya çıktığında öz şefkat pratiği',
        ];
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // COLORS
  // ══════════════════════════════════════════════════════════════════════════

  Color get color {
    switch (this) {
      case AttachmentStyle.secure:
        return AppColors.greenAccent;
      case AttachmentStyle.anxiousPreoccupied:
        return AppColors.warmAccent;
      case AttachmentStyle.dismissiveAvoidant:
        return AppColors.blueAccent;
      case AttachmentStyle.fearfulAvoidant:
        return AppColors.amethyst;
    }
  }

  /// Icon representing each style
  String get emojiIcon {
    switch (this) {
      case AttachmentStyle.secure:
        return '\u{1F33F}'; // seedling
      case AttachmentStyle.anxiousPreoccupied:
        return '\u{1F30A}'; // ocean wave
      case AttachmentStyle.dismissiveAvoidant:
        return '\u{26F0}'; // mountain
      case AttachmentStyle.fearfulAvoidant:
        return '\u{1F300}'; // cyclone
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
// QUIZ RESULT MODEL
// ════════════════════════════════════════════════════════════════════════════

/// Stores the outcome of an attachment style self-reflection quiz
class AttachmentQuizResult {
  final AttachmentStyle attachmentStyle;
  final Map<AttachmentStyle, double> scores;
  final DateTime dateTaken;

  const AttachmentQuizResult({
    required this.attachmentStyle,
    required this.scores,
    required this.dateTaken,
  });

  /// Serialise to JSON for SharedPreferences storage
  Map<String, dynamic> toJson() => {
    'attachmentStyle': attachmentStyle.name,
    'scores': scores.map((key, value) => MapEntry(key.name, value)),
    'dateTaken': dateTaken.toIso8601String(),
  };

  /// Deserialise from JSON
  factory AttachmentQuizResult.fromJson(Map<String, dynamic> json) {
    final scoresMap = <AttachmentStyle, double>{};
    final rawScores = json['scores'] as Map<String, dynamic>? ?? {};
    for (final entry in rawScores.entries) {
      final style = AttachmentStyle.values.firstWhere(
        (s) => s.name == entry.key,
        orElse: () => AttachmentStyle.secure,
      );
      scoresMap[style] = (entry.value as num? ?? 0).toDouble();
    }

    return AttachmentQuizResult(
      attachmentStyle: AttachmentStyle.values.firstWhere(
        (s) => s.name == json['attachmentStyle'],
        orElse: () => AttachmentStyle.secure,
      ),
      scores: scoresMap,
      dateTaken:
          DateTime.tryParse(json['dateTaken']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  /// Get the percentage for a specific style, defaulting to 0
  double percentageFor(AttachmentStyle style) => scores[style] ?? 0.0;

  /// Human-readable summary
  String summaryEn() =>
      '${attachmentStyle.displayNameEn} (${(percentageFor(attachmentStyle) * 100).toStringAsFixed(0)}%)';

  String summaryTr() =>
      '${attachmentStyle.displayNameTr} (%${(percentageFor(attachmentStyle) * 100).toStringAsFixed(0)})';
}
