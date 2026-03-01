import '../services/l10n_service.dart';
import '../providers/app_providers.dart';
// ════════════════════════════════════════════════════════════════════════════
// IMPORTANT DATE PRESETS - 24 Retrospective Journaling Suggestions
// ════════════════════════════════════════════════════════════════════════════
// Bilingual preset dates that encourage users to journal about meaningful
// past moments. Each preset includes a writing prompt for guidance.
// ════════════════════════════════════════════════════════════════════════════

enum ImportantDateCategory {
  personalMilestone,
  relationship,
  challenge,
  growth,
  reflective;

  String label(bool isEn) {
    switch (this) {
      case ImportantDateCategory.personalMilestone:
        return L10nService.get('data.content.important_date_presets.personal_milestones', isEn ? AppLanguage.en : AppLanguage.tr);
      case ImportantDateCategory.relationship:
        return L10nService.get('data.content.important_date_presets.relationships', isEn ? AppLanguage.en : AppLanguage.tr);
      case ImportantDateCategory.challenge:
        return L10nService.get('data.content.important_date_presets.challenges', isEn ? AppLanguage.en : AppLanguage.tr);
      case ImportantDateCategory.growth:
        return L10nService.get('data.content.important_date_presets.growth', isEn ? AppLanguage.en : AppLanguage.tr);
      case ImportantDateCategory.reflective:
        return L10nService.get('data.content.important_date_presets.reflective', isEn ? AppLanguage.en : AppLanguage.tr);
    }
  }
}

class ImportantDatePreset {
  final String key;
  final String nameEn;
  final String nameTr;
  final String promptEn;
  final String promptTr;
  final String emoji;
  final ImportantDateCategory category;

  const ImportantDatePreset({
    required this.key,
    required this.nameEn,
    required this.nameTr,
    required this.promptEn,
    required this.promptTr,
    required this.emoji,
    required this.category,
  });

  String name(bool isEn) => isEn ? nameEn : nameTr;
  String prompt(bool isEn) => isEn ? promptEn : promptTr;

  String localizedName(AppLanguage language) =>
      language == AppLanguage.en ? nameEn : nameTr;

  String localizedPrompt(AppLanguage language) =>
      language == AppLanguage.en ? promptEn : promptTr;
}

class ImportantDatePresets {
  ImportantDatePresets._();

  static const List<ImportantDatePreset> all = [
    // ═══════════════════════════════════════════════════════════════
    // PERSONAL MILESTONES (6)
    // ═══════════════════════════════════════════════════════════════
    ImportantDatePreset(
      key: 'birthday',
      nameEn: 'Your Birthday',
      nameTr: 'Doğum Günün',
      promptEn: 'How did you feel waking up that day? What made it special?',
      promptTr: 'O gün uyandığında nasıl hissettin? Onu özel kılan ne oldu?',
      emoji: '\u{1F382}',
      category: ImportantDateCategory.personalMilestone,
    ),
    ImportantDatePreset(
      key: 'graduation',
      nameEn: 'Graduation Day',
      nameTr: 'Mezuniyet Günün',
      promptEn: 'What emotions did you feel as you crossed that finish line?',
      promptTr: 'O bitiş çizgisini geçerken neler hissettin?',
      emoji: '\u{1F393}',
      category: ImportantDateCategory.personalMilestone,
    ),
    ImportantDatePreset(
      key: 'first_job',
      nameEn: 'First Day at Work',
      nameTr: 'İlk İş Günün',
      promptEn: 'What were your expectations? How did reality compare?',
      promptTr: 'Beklentilerin nelerdi? Gerçeklik nasıl karşıladı?',
      emoji: '\u{1F4BC}',
      category: ImportantDateCategory.personalMilestone,
    ),
    ImportantDatePreset(
      key: 'first_home',
      nameEn: 'Moving Into Your Own Place',
      nameTr: 'Kendi Evine Taşındığın Gün',
      promptEn: 'What did independence feel like in that moment?',
      promptTr: 'O anda bağımsızlık nasıl hissettirdi?',
      emoji: '\u{1F3E0}',
      category: ImportantDateCategory.personalMilestone,
    ),
    ImportantDatePreset(
      key: 'learned_to_drive',
      nameEn: 'Day You Learned to Drive',
      nameTr: 'Araba Kullanmayı Öğrendiğin Gün',
      promptEn: 'What did that first solo drive feel like?',
      promptTr: 'İlk tek başına sürüş nasıl hissettirdi?',
      emoji: '\u{1F697}',
      category: ImportantDateCategory.personalMilestone,
    ),
    ImportantDatePreset(
      key: 'big_travel',
      nameEn: 'A Trip That Changed You',
      nameTr: 'Seni Değiştiren Bir Yolculuk',
      promptEn: 'What did you discover about yourself far from home?',
      promptTr: 'Evden uzakta kendine dair ne keşfettin?',
      emoji: '\u{2708}\u{FE0F}',
      category: ImportantDateCategory.personalMilestone,
    ),

    // ═══════════════════════════════════════════════════════════════
    // RELATIONSHIPS (5)
    // ═══════════════════════════════════════════════════════════════
    ImportantDatePreset(
      key: 'first_date',
      nameEn: 'First Date with Someone Special',
      nameTr: 'Özel Biriyle İlk Buluşma',
      promptEn: 'What do you remember most vividly from that evening?',
      promptTr: 'O akşamdan en canlı hatırladığın şey ne?',
      emoji: '\u{1F495}',
      category: ImportantDateCategory.relationship,
    ),
    ImportantDatePreset(
      key: 'engagement',
      nameEn: 'Your Engagement',
      nameTr: 'Nişan Günün',
      promptEn: 'What was running through your mind in that moment?',
      promptTr: 'O anda aklından neler geçiyordu?',
      emoji: '\u{1F48D}',
      category: ImportantDateCategory.relationship,
    ),
    ImportantDatePreset(
      key: 'wedding',
      nameEn: 'Your Wedding Day',
      nameTr: 'Düğün Günün',
      promptEn: 'What surprised you most about how you felt?',
      promptTr: 'Hissettiklerin konusunda seni en çok ne şaşırttı?',
      emoji: '\u{1F492}',
      category: ImportantDateCategory.relationship,
    ),
    ImportantDatePreset(
      key: 'birth_of_child',
      nameEn: 'Day Your Child Was Born',
      nameTr: 'Çocuğunun Doğduğu Gün',
      promptEn: 'How did the world look different after that moment?',
      promptTr: 'O andan sonra dünya nasıl farklı göründü?',
      emoji: '\u{1F476}',
      category: ImportantDateCategory.relationship,
    ),
    ImportantDatePreset(
      key: 'met_best_friend',
      nameEn: 'Day You Met Your Best Friend',
      nameTr: 'En Yakın Arkadaşınla Tanıştığın Gün',
      promptEn: 'What drew you to each other? What clicked?',
      promptTr: 'Sizi birbirinize çeken ne oldu? Ne tıkladı?',
      emoji: '\u{1F91D}',
      category: ImportantDateCategory.relationship,
    ),

    // ═══════════════════════════════════════════════════════════════
    // CHALLENGES (5)
    // ═══════════════════════════════════════════════════════════════
    ImportantDatePreset(
      key: 'loss',
      nameEn: 'A Day You Lost Someone',
      nameTr: 'Birini Kaybettiğin Gün',
      promptEn: 'What would you want them to know today?',
      promptTr: 'Bugün onların bilmesini ne isterdin?',
      emoji: '\u{1F54A}\u{FE0F}',
      category: ImportantDateCategory.challenge,
    ),
    ImportantDatePreset(
      key: 'breakup',
      nameEn: 'End of a Relationship',
      nameTr: 'Bir İlişkinin Bittiği Gün',
      promptEn: 'What did that ending teach you about yourself?',
      promptTr: 'O bitiş sana kendin hakkında ne öğretti?',
      emoji: '\u{1F494}',
      category: ImportantDateCategory.challenge,
    ),
    ImportantDatePreset(
      key: 'health_crisis',
      nameEn: 'A Health Scare',
      nameTr: 'Bir Sağlık Krizi',
      promptEn: 'How did your perspective shift after that moment?',
      promptTr: 'O andan sonra bakış açın nasıl değişti?',
      emoji: '\u{1F3E5}',
      category: ImportantDateCategory.challenge,
    ),
    ImportantDatePreset(
      key: 'moved_away',
      nameEn: 'Day You Left Your Hometown',
      nameTr: 'Memleketinden Ayrıldığın Gün',
      promptEn: 'What did you leave behind? What did you carry with you?',
      promptTr: 'Arkada ne bıraktın? Yanında ne taşıdın?',
      emoji: '\u{1F9F3}',
      category: ImportantDateCategory.challenge,
    ),
    ImportantDatePreset(
      key: 'failure',
      nameEn: 'A Day You Felt You Failed',
      nameTr: 'Başarısız Hissettiğin Bir Gün',
      promptEn: 'Looking back, what did that experience actually build in you?',
      promptTr: 'Geriye bakınca, o deneyim aslında sende neyi inşa etti?',
      emoji: '\u{1F327}\u{FE0F}',
      category: ImportantDateCategory.challenge,
    ),

    // ═══════════════════════════════════════════════════════════════
    // GROWTH (4)
    // ═══════════════════════════════════════════════════════════════
    ImportantDatePreset(
      key: 'overcame_fear',
      nameEn: 'Day You Overcame a Fear',
      nameTr: 'Bir Korkunu Yendiğin Gün',
      promptEn: 'What gave you the courage to face it?',
      promptTr: 'Onunla yüzleşme cesaretini sana ne verdi?',
      emoji: '\u{1F981}',
      category: ImportantDateCategory.growth,
    ),
    ImportantDatePreset(
      key: 'proudest_moment',
      nameEn: 'Your Proudest Achievement',
      nameTr: 'En Gurur Duyduğun Başarı',
      promptEn: 'What does that achievement mean to you now?',
      promptTr: 'O başarı şimdi senin için ne ifade ediyor?',
      emoji: '\u{1F3C6}',
      category: ImportantDateCategory.growth,
    ),
    ImportantDatePreset(
      key: 'life_changing_decision',
      nameEn: 'A Life-Changing Decision',
      nameTr: 'Hayatını Değiştiren Bir Karar',
      promptEn: 'What pushed you to choose that path?',
      promptTr: 'Seni o yolu seçmeye iten ne oldu?',
      emoji: '\u{1F500}',
      category: ImportantDateCategory.growth,
    ),
    ImportantDatePreset(
      key: 'forgiveness',
      nameEn: 'A Day of Forgiveness',
      nameTr: 'Affettiğin ya da Affedildiğin Gün',
      promptEn: 'How did letting go change you?',
      promptTr: 'Bırakmak seni nasıl değiştirdi?',
      emoji: '\u{1F54A}\u{FE0F}',
      category: ImportantDateCategory.growth,
    ),

    // ═══════════════════════════════════════════════════════════════
    // REFLECTIVE (4)
    // ═══════════════════════════════════════════════════════════════
    ImportantDatePreset(
      key: 'new_year_this',
      nameEn: 'January 1st This Year',
      nameTr: 'Bu Yılın 1 Ocak\'ı',
      promptEn: 'What were you hoping for? How do you feel about it now?',
      promptTr: 'Neler umuyordun? Şimdi bu konuda nasıl hissediyorsun?',
      emoji: '\u{1F386}',
      category: ImportantDateCategory.reflective,
    ),
    ImportantDatePreset(
      key: 'last_birthday',
      nameEn: 'Your Last Birthday',
      nameTr: 'Son Doğum Günün',
      promptEn: 'What has changed since then? What has stayed the same?',
      promptTr: 'O zamandan beri ne değişti? Ne aynı kaldı?',
      emoji: '\u{1F388}',
      category: ImportantDateCategory.reflective,
    ),
    ImportantDatePreset(
      key: 'season_start',
      nameEn: 'Start of Your Favorite Season',
      nameTr: 'En Sevdiğin Mevsimin Başlangıcı',
      promptEn: 'What does this season awaken in you?',
      promptTr: 'Bu mevsim sende neyi uyandırıyor?',
      emoji: '\u{1F342}',
      category: ImportantDateCategory.reflective,
    ),
    ImportantDatePreset(
      key: 'random_meaningful',
      nameEn: 'A Random Day That Changed Everything',
      nameTr: 'Her Şeyi Değiştiren Sıradan Bir Gün',
      promptEn: 'What happened that you didn\'t see coming?',
      promptTr: 'Geleceğini öngörmediğin ne oldu?',
      emoji: '\u{26A1}',
      category: ImportantDateCategory.reflective,
    ),
  ];

  static List<ImportantDatePreset> byCategory(ImportantDateCategory category) {
    return all.where((p) => p.category == category).toList();
  }

  static ImportantDatePreset? getByKey(String key) {
    for (final preset in all) {
      if (preset.key == key) return preset;
    }
    return null;
  }
}
