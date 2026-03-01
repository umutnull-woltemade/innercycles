// ════════════════════════════════════════════════════════════════════════════
// LIFE EVENT PRESETS - 40 Structured Life Events
// ════════════════════════════════════════════════════════════════════════════
// 20 positive + 20 challenging preset life events with bilingual names,
// emoji identifiers, and suggested emotion tags from the 36-emotion vocabulary.
// ════════════════════════════════════════════════════════════════════════════

import '../models/life_event.dart';
import '../providers/app_providers.dart';

class LifeEventPreset {
  final String key;
  final String nameEn;
  final String nameTr;
  final String emoji;
  final LifeEventType category;
  final List<String> defaultEmotions;

  const LifeEventPreset({
    required this.key,
    required this.nameEn,
    required this.nameTr,
    required this.emoji,
    required this.category,
    this.defaultEmotions = const [],
  });

  String localizedName(AppLanguage language) =>
      language == AppLanguage.en ? nameEn : nameTr;
}

class LifeEventPresets {
  LifeEventPresets._();

  static const List<LifeEventPreset> positive = [
    LifeEventPreset(
      key: 'graduation',
      nameEn: 'Graduation',
      nameTr: 'Mezuniyet',
      emoji: '\u{1F393}',
      category: LifeEventType.positive,
      defaultEmotions: ['pride', 'excitement', 'gratitude'],
    ),
    LifeEventPreset(
      key: 'new_job',
      nameEn: 'New Job',
      nameTr: 'Yeni İş',
      emoji: '\u{1F4BC}',
      category: LifeEventType.positive,
      defaultEmotions: ['excitement', 'hope', 'confidence'],
    ),
    LifeEventPreset(
      key: 'marriage',
      nameEn: 'Marriage',
      nameTr: 'Evlilik',
      emoji: '\u{1F492}',
      category: LifeEventType.positive,
      defaultEmotions: ['love', 'joy', 'gratitude'],
    ),
    LifeEventPreset(
      key: 'birth_of_child',
      nameEn: 'Birth of a Child',
      nameTr: 'Çocuk Doğumu',
      emoji: '\u{1F476}',
      category: LifeEventType.positive,
      defaultEmotions: ['love', 'awe', 'tenderness'],
    ),
    LifeEventPreset(
      key: 'first_home',
      nameEn: 'First Home',
      nameTr: 'İlk Ev',
      emoji: '\u{1F3E0}',
      category: LifeEventType.positive,
      defaultEmotions: ['pride', 'excitement', 'security'],
    ),
    LifeEventPreset(
      key: 'promotion',
      nameEn: 'Promotion',
      nameTr: 'Terfi',
      emoji: '\u{1F4C8}',
      category: LifeEventType.positive,
      defaultEmotions: ['pride', 'confidence', 'satisfaction'],
    ),
    LifeEventPreset(
      key: 'travel_milestone',
      nameEn: 'Travel Milestone',
      nameTr: 'Seyahat Dönüm Noktası',
      emoji: '\u{2708}\u{FE0F}',
      category: LifeEventType.positive,
      defaultEmotions: ['excitement', 'curiosity', 'wonder'],
    ),
    LifeEventPreset(
      key: 'new_friendship',
      nameEn: 'New Friendship',
      nameTr: 'Yeni Dostluk',
      emoji: '\u{1F91D}',
      category: LifeEventType.positive,
      defaultEmotions: ['warmth', 'connection', 'joy'],
    ),
    LifeEventPreset(
      key: 'creative_achievement',
      nameEn: 'Creative Achievement',
      nameTr: 'Yaratıcı Başarı',
      emoji: '\u{1F3A8}',
      category: LifeEventType.positive,
      defaultEmotions: ['inspiration', 'pride', 'fulfillment'],
    ),
    LifeEventPreset(
      key: 'health_recovery',
      nameEn: 'Health Recovery',
      nameTr: 'Sağlık İyileşmesi',
      emoji: '\u{1F49A}',
      category: LifeEventType.positive,
      defaultEmotions: ['relief', 'gratitude', 'hope'],
    ),
    LifeEventPreset(
      key: 'financial_goal',
      nameEn: 'Financial Goal',
      nameTr: 'Finansal Hedef',
      emoji: '\u{1F4B0}',
      category: LifeEventType.positive,
      defaultEmotions: ['security', 'pride', 'relief'],
    ),
    LifeEventPreset(
      key: 'pet_adoption',
      nameEn: 'Pet Adoption',
      nameTr: 'Evcil Hayvan Sahiplenme',
      emoji: '\u{1F43E}',
      category: LifeEventType.positive,
      defaultEmotions: ['love', 'tenderness', 'joy'],
    ),
    LifeEventPreset(
      key: 'reconciliation',
      nameEn: 'Reconciliation',
      nameTr: 'Barışma',
      emoji: '\u{1F54A}\u{FE0F}',
      category: LifeEventType.positive,
      defaultEmotions: ['relief', 'warmth', 'hope'],
    ),
    LifeEventPreset(
      key: 'volunteer_milestone',
      nameEn: 'Volunteer Milestone',
      nameTr: 'Gönüllülük Dönüm Noktası',
      emoji: '\u{1F64F}',
      category: LifeEventType.positive,
      defaultEmotions: ['fulfillment', 'connection', 'compassion'],
    ),
    LifeEventPreset(
      key: 'skill_mastery',
      nameEn: 'Skill Mastery',
      nameTr: 'Beceri Ustalığı',
      emoji: '\u{1F3AF}',
      category: LifeEventType.positive,
      defaultEmotions: ['confidence', 'pride', 'satisfaction'],
    ),
    LifeEventPreset(
      key: 'retirement',
      nameEn: 'Retirement',
      nameTr: 'Emeklilik',
      emoji: '\u{1F305}',
      category: LifeEventType.positive,
      defaultEmotions: ['peace', 'gratitude', 'nostalgia'],
    ),
    LifeEventPreset(
      key: 'anniversary',
      nameEn: 'Anniversary',
      nameTr: 'Yıl Dönümü',
      emoji: '\u{1F389}',
      category: LifeEventType.positive,
      defaultEmotions: ['love', 'gratitude', 'nostalgia'],
    ),
    LifeEventPreset(
      key: 'fitness_goal',
      nameEn: 'Fitness Goal',
      nameTr: 'Fitness Hedefi',
      emoji: '\u{1F4AA}',
      category: LifeEventType.positive,
      defaultEmotions: ['pride', 'energy', 'determination'],
    ),
    LifeEventPreset(
      key: 'published_work',
      nameEn: 'Published Work',
      nameTr: 'Yayınlanan Eser',
      emoji: '\u{1F4D6}',
      category: LifeEventType.positive,
      defaultEmotions: ['pride', 'excitement', 'vulnerability'],
    ),
    LifeEventPreset(
      key: 'award_recognition',
      nameEn: 'Award / Recognition',
      nameTr: 'Ödül / Takdir',
      emoji: '\u{1F3C6}',
      category: LifeEventType.positive,
      defaultEmotions: ['pride', 'gratitude', 'surprise'],
    ),
  ];

  static const List<LifeEventPreset> challenging = [
    LifeEventPreset(
      key: 'loss_of_loved_one',
      nameEn: 'Loss of a Loved One',
      nameTr: 'Sevilen Birini Kaybetme',
      emoji: '\u{1F54A}\u{FE0F}',
      category: LifeEventType.challenging,
      defaultEmotions: ['grief', 'sadness', 'numbness'],
    ),
    LifeEventPreset(
      key: 'breakup',
      nameEn: 'Breakup',
      nameTr: 'Ayrılık',
      emoji: '\u{1F494}',
      category: LifeEventType.challenging,
      defaultEmotions: ['heartbreak', 'loneliness', 'confusion'],
    ),
    LifeEventPreset(
      key: 'job_loss',
      nameEn: 'Job Loss',
      nameTr: 'İş Kaybı',
      emoji: '\u{1F4E6}',
      category: LifeEventType.challenging,
      defaultEmotions: ['anxiety', 'uncertainty', 'frustration'],
    ),
    LifeEventPreset(
      key: 'health_diagnosis',
      nameEn: 'Health Diagnosis',
      nameTr: 'Sağlık Tanısı',
      emoji: '\u{1FA7A}',
      category: LifeEventType.challenging,
      defaultEmotions: ['fear', 'anxiety', 'vulnerability'],
    ),
    LifeEventPreset(
      key: 'relocation',
      nameEn: 'Move / Relocation',
      nameTr: 'Taşınma',
      emoji: '\u{1F69A}',
      category: LifeEventType.challenging,
      defaultEmotions: ['anxiety', 'nostalgia', 'uncertainty'],
    ),
    LifeEventPreset(
      key: 'financial_setback',
      nameEn: 'Financial Setback',
      nameTr: 'Finansal Sıkıntı',
      emoji: '\u{1F4C9}',
      category: LifeEventType.challenging,
      defaultEmotions: ['anxiety', 'stress', 'frustration'],
    ),
    LifeEventPreset(
      key: 'family_conflict',
      nameEn: 'Family Conflict',
      nameTr: 'Aile İçi Çatışma',
      emoji: '\u{1F3E0}',
      category: LifeEventType.challenging,
      defaultEmotions: ['frustration', 'sadness', 'guilt'],
    ),
    LifeEventPreset(
      key: 'friendship_ending',
      nameEn: 'Friendship Ending',
      nameTr: 'Dostluk Sonu',
      emoji: '\u{1F91D}',
      category: LifeEventType.challenging,
      defaultEmotions: ['sadness', 'confusion', 'loneliness'],
    ),
    LifeEventPreset(
      key: 'academic_setback',
      nameEn: 'Academic Setback',
      nameTr: 'Akademik Başarısızlık',
      emoji: '\u{1F4DA}',
      category: LifeEventType.challenging,
      defaultEmotions: ['frustration', 'shame', 'disappointment'],
    ),
    LifeEventPreset(
      key: 'identity_crisis',
      nameEn: 'Identity Crisis',
      nameTr: 'Kimlik Krizi',
      emoji: '\u{1F9E9}',
      category: LifeEventType.challenging,
      defaultEmotions: ['confusion', 'anxiety', 'vulnerability'],
    ),
    LifeEventPreset(
      key: 'trauma_recovery',
      nameEn: 'Trauma Recovery',
      nameTr: 'Travma İyileşmesi',
      emoji: '\u{1F33F}',
      category: LifeEventType.challenging,
      defaultEmotions: ['vulnerability', 'courage', 'hope'],
    ),
    LifeEventPreset(
      key: 'burnout',
      nameEn: 'Burnout',
      nameTr: 'Tükenmişlik',
      emoji: '\u{1F525}',
      category: LifeEventType.challenging,
      defaultEmotions: ['exhaustion', 'numbness', 'frustration'],
    ),
    LifeEventPreset(
      key: 'addiction_recovery',
      nameEn: 'Addiction Recovery',
      nameTr: 'Bağımlılık İyileşmesi',
      emoji: '\u{1F4AA}',
      category: LifeEventType.challenging,
      defaultEmotions: ['courage', 'vulnerability', 'determination'],
    ),
    LifeEventPreset(
      key: 'loneliness_period',
      nameEn: 'Loneliness Period',
      nameTr: 'Yalnızlık Dönemi',
      emoji: '\u{1F311}',
      category: LifeEventType.challenging,
      defaultEmotions: ['loneliness', 'sadness', 'introspection'],
    ),
    LifeEventPreset(
      key: 'career_change',
      nameEn: 'Career Change',
      nameTr: 'Kariyer Değişikliği',
      emoji: '\u{1F500}',
      category: LifeEventType.challenging,
      defaultEmotions: ['uncertainty', 'excitement', 'anxiety'],
    ),
    LifeEventPreset(
      key: 'legal_issue',
      nameEn: 'Legal Issue',
      nameTr: 'Hukuki Sorun',
      emoji: '\u{2696}\u{FE0F}',
      category: LifeEventType.challenging,
      defaultEmotions: ['stress', 'anxiety', 'frustration'],
    ),
    LifeEventPreset(
      key: 'betrayal',
      nameEn: 'Betrayal',
      nameTr: 'İhanet',
      emoji: '\u{1F5E1}\u{FE0F}',
      category: LifeEventType.challenging,
      defaultEmotions: ['anger', 'heartbreak', 'distrust'],
    ),
    LifeEventPreset(
      key: 'natural_disaster',
      nameEn: 'Natural Disaster',
      nameTr: 'Doğal Afet',
      emoji: '\u{1F30A}',
      category: LifeEventType.challenging,
      defaultEmotions: ['fear', 'shock', 'vulnerability'],
    ),
    LifeEventPreset(
      key: 'chronic_illness',
      nameEn: 'Chronic Illness Onset',
      nameTr: 'Kronik Hastalık Başlangıcı',
      emoji: '\u{1FA7A}',
      category: LifeEventType.challenging,
      defaultEmotions: ['grief', 'frustration', 'acceptance'],
    ),
    LifeEventPreset(
      key: 'caregiver_burden',
      nameEn: 'Caregiver Burden',
      nameTr: 'Bakım Verme Yükü',
      emoji: '\u{1F9D1}\u{200D}\u{2695}\u{FE0F}',
      category: LifeEventType.challenging,
      defaultEmotions: ['exhaustion', 'guilt', 'compassion'],
    ),
  ];

  static List<LifeEventPreset> get all => [...positive, ...challenging];

  static LifeEventPreset? getByKey(String key) {
    for (final preset in all) {
      if (preset.key == key) return preset;
    }
    return null;
  }
}
