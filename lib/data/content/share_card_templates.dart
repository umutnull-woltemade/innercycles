// ============================================================================
// SHARE CARD TEMPLATES - 20 shareable card templates for InnerCycles
// ============================================================================
// Organized into 4 categories: Identity (5), Pattern (5), Achievement (5),
// Wisdom (5). Each template has gradient colors, layout type, and metadata.
// ============================================================================

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/emotional_gradient.dart';
import '../models/share_card_models.dart';
import '../services/l10n_service.dart';
import '../providers/app_providers.dart';

/// All 20 share card templates
class ShareCardTemplates {
  ShareCardTemplates._();

  // =========================================================================
  // IDENTITY CARDS (5)
  // =========================================================================

  static const archetypeReveal = ShareCardTemplate(
    id: 'archetype_reveal',
    category: ShareCardCategory.identity,
    titleEn: 'My Archetype',
    titleTr: 'Arketipim',
    gradientColors: [Color(0xFF2D2119), Color(0xFF3D3025), Color(0xFF1A1510)],
    layoutType: ShareCardLayout.centered,
    icon: Icons.auto_awesome,
    badgeEn: 'ARCHETYPE',
    badgeTr: 'ARKETIP',
  );

  static const attachmentStyle = ShareCardTemplate(
    id: 'attachment_style',
    category: ShareCardCategory.identity,
    titleEn: 'My Attachment Style',
    titleTr: 'Bağlanma Stilim',
    gradientColors: [Color(0xFF3D2E24), Color(0xFF4A3D33), Color(0xFF2D2119)],
    layoutType: ShareCardLayout.centered,
    icon: Icons.favorite_rounded,
    badgeEn: 'ATTACHMENT',
    badgeTr: 'BAĞLANMA',
  );

  static const dreamPersonality = ShareCardTemplate(
    id: 'dream_personality',
    category: ShareCardCategory.identity,
    titleEn: 'Dream Personality',
    titleTr: 'Rüya Kişiliğim',
    gradientColors: [Color(0xFF1E1A15), Color(0xFF3D3229), Color(0xFF4A3D33)],
    layoutType: ShareCardLayout.centered,
    icon: Icons.nights_stay_rounded,
    badgeEn: 'DREAM',
    badgeTr: 'RÜYA',
  );

  static const energyProfile = ShareCardTemplate(
    id: 'energy_profile',
    category: ShareCardCategory.identity,
    titleEn: 'My Energy Pattern',
    titleTr: 'Enerji Örüntüm',
    gradientColors: [Color(0xFF1A1508), Color(0xFF2D2410), Color(0xFF3D3018)],
    layoutType: ShareCardLayout.centered,
    icon: Icons.bolt_rounded,
    badgeEn: 'ENERGY',
    badgeTr: 'ENERJI',
  );

  static const emotionalArchetype = ShareCardTemplate(
    id: 'emotional_archetype',
    category: ShareCardCategory.identity,
    titleEn: 'My Emotional Style',
    titleTr: 'Duygusal Stilim',
    gradientColors: [Color(0xFF2D241F), Color(0xFF3D322B), Color(0xFF1E1714)],
    layoutType: ShareCardLayout.centered,
    icon: Icons.cyclone_rounded,
    badgeEn: 'EMOTIONAL',
    badgeTr: 'DUYGUSAL',
  );

  // =========================================================================
  // PATTERN CARDS (5)
  // =========================================================================

  static const weeklyMoodWave = ShareCardTemplate(
    id: 'weekly_mood_wave',
    category: ShareCardCategory.pattern,
    titleEn: 'My Week in Feelings',
    titleTr: 'Duygularla Geçen Haftam',
    gradientColors: [Color(0xFF2D2119), Color(0xFF3D2E24), Color(0xFF1A1510)],
    layoutType: ShareCardLayout.miniChart,
    icon: Icons.waves_rounded,
    badgeEn: 'MOOD',
    badgeTr: 'DUYGU',
  );

  static const focusAreaRadar = ShareCardTemplate(
    id: 'focus_area_radar',
    category: ShareCardCategory.pattern,
    titleEn: 'Focus Area Balance',
    titleTr: 'Odak Alanı Dengesi',
    gradientColors: [Color(0xFF1E1714), Color(0xFF2D241F), Color(0xFF1A1510)],
    layoutType: ShareCardLayout.miniChart,
    icon: Icons.radar_rounded,
    badgeEn: 'FOCUS',
    badgeTr: 'ODAK',
  );

  static const streakFlame = ShareCardTemplate(
    id: 'streak_flame',
    category: ShareCardCategory.pattern,
    titleEn: 'Journal Streak',
    titleTr: 'Günlük Serisi',
    gradientColors: [Color(0xFF1A1508), Color(0xFF2D2410), Color(0xFF1A1208)],
    layoutType: ShareCardLayout.badgeHero,
    icon: Icons.local_fire_department_rounded,
    badgeEn: 'STREAK',
    badgeTr: 'SERI',
  );

  static const topEmotion = ShareCardTemplate(
    id: 'top_emotion',
    category: ShareCardCategory.pattern,
    titleEn: 'Dominant Emotion',
    titleTr: 'Baskın Duygu',
    gradientColors: [Color(0xFF3D2E24), Color(0xFF4A3D33), Color(0xFF2D2119)],
    layoutType: ShareCardLayout.badgeHero,
    icon: Icons.emoji_emotions_rounded,
    badgeEn: 'EMOTION',
    badgeTr: 'DUYGU',
  );

  static const sleepPattern = ShareCardTemplate(
    id: 'sleep_pattern',
    category: ShareCardCategory.pattern,
    titleEn: 'My Sleep Quality',
    titleTr: 'Uyku Kalitem',
    gradientColors: [Color(0xFF1E1714), Color(0xFF2D241F), Color(0xFF1A1510)],
    layoutType: ShareCardLayout.miniChart,
    icon: Icons.bedtime_rounded,
    badgeEn: 'SLEEP',
    badgeTr: 'UYKU',
  );

  // =========================================================================
  // ACHIEVEMENT CARDS (5)
  // =========================================================================

  static const journalMilestone = ShareCardTemplate(
    id: 'journal_milestone',
    category: ShareCardCategory.achievement,
    titleEn: 'Journaling Milestone',
    titleTr: 'Günlük Kilometre Taşı',
    gradientColors: [Color(0xFF1A1508), Color(0xFF3D3018), Color(0xFF1A1208)],
    layoutType: ShareCardLayout.badgeHero,
    icon: Icons.menu_book_rounded,
    badgeEn: 'MILESTONE',
    badgeTr: 'BAŞARI',
  );

  static const dreamExplorer = ShareCardTemplate(
    id: 'dream_explorer',
    category: ShareCardCategory.achievement,
    titleEn: 'Dream Logger',
    titleTr: 'Rüya Kaydedici',
    gradientColors: [Color(0xFF1E1A15), Color(0xFF3D3229), Color(0xFF1E1A15)],
    layoutType: ShareCardLayout.badgeHero,
    icon: Icons.explore_rounded,
    badgeEn: 'EXPLORER',
    badgeTr: 'KAŞİF',
  );

  static const patternDiscoverer = ShareCardTemplate(
    id: 'pattern_discoverer',
    category: ShareCardCategory.achievement,
    titleEn: 'Pattern Discoverer',
    titleTr: 'Örüntü Keşfedici',
    gradientColors: [Color(0xFF2D241F), Color(0xFF3D322B), Color(0xFF1E1714)],
    layoutType: ShareCardLayout.badgeHero,
    icon: Icons.hub_rounded,
    badgeEn: 'PATTERNS',
    badgeTr: 'ÖRÜNTÜ',
  );

  static const consistencyStar = ShareCardTemplate(
    id: 'consistency_star',
    category: ShareCardCategory.achievement,
    titleEn: 'Consistency Star',
    titleTr: 'Tutarlılık Yıldızı',
    gradientColors: [Color(0xFF1A1508), Color(0xFF2D2208), Color(0xFF0D0A04)],
    layoutType: ShareCardLayout.statRow,
    icon: Icons.star_rounded,
    badgeEn: 'CONSISTENCY',
    badgeTr: 'TUTARLILIK',
  );

  static const growthJourney = ShareCardTemplate(
    id: 'growth_journey',
    category: ShareCardCategory.achievement,
    titleEn: 'Growth Progress',
    titleTr: 'Gelişim Süreci',
    gradientColors: [Color(0xFF1A2215), Color(0xFF2D3525), Color(0xFF1A2215)],
    layoutType: ShareCardLayout.statRow,
    icon: Icons.trending_up_rounded,
    badgeEn: 'GROWTH',
    badgeTr: 'GELİŞİM',
  );

  // =========================================================================
  // CYCLE POSITION CARD (1) — Instagram Stories 9:16
  // =========================================================================

  static const cyclePosition = ShareCardTemplate(
    id: 'cycle_position',
    category: ShareCardCategory.pattern,
    titleEn: 'Cycle Position',
    titleTr: 'Döngü Konumu',
    gradientColors: [Color(0xFF2D2119), Color(0xFF1E1A15), Color(0xFF1A1510)],
    layoutType: ShareCardLayout.cyclePosition,
    icon: Icons.donut_large_rounded,
    badgeEn: 'CYCLE',
    badgeTr: 'DÖNGÜ',
  );

  // =========================================================================
  // WISDOM CARDS (5)
  // =========================================================================

  static const dailyReflection = ShareCardTemplate(
    id: 'daily_reflection',
    category: ShareCardCategory.wisdom,
    titleEn: 'Daily Reflection',
    titleTr: 'Günlük Düşünce',
    gradientColors: [Color(0xFF2D2119), Color(0xFF241E19), Color(0xFF1A1510)],
    layoutType: ShareCardLayout.quoteBlock,
    icon: Icons.format_quote_rounded,
    badgeEn: 'REFLECTION',
    badgeTr: 'DÜŞÜNCE',
  );

  static const dreamInsight = ShareCardTemplate(
    id: 'dream_insight',
    category: ShareCardCategory.wisdom,
    titleEn: 'Dream Insight',
    titleTr: 'Rüya İçgörüsü',
    gradientColors: [Color(0xFF1E1A15), Color(0xFF2D2A22), Color(0xFF1E1A15)],
    layoutType: ShareCardLayout.quoteBlock,
    icon: Icons.auto_fix_high_rounded,
    badgeEn: 'INSIGHT',
    badgeTr: 'İÇGÖRÜ',
  );

  static const patternWisdom = ShareCardTemplate(
    id: 'pattern_wisdom',
    category: ShareCardCategory.wisdom,
    titleEn: 'Pattern Wisdom',
    titleTr: 'Örüntü Bilgeliği',
    gradientColors: [Color(0xFF2D241F), Color(0xFF3D322B), Color(0xFF1E1714)],
    layoutType: ShareCardLayout.quoteBlock,
    icon: Icons.psychology_rounded,
    badgeEn: 'WISDOM',
    badgeTr: 'BİLGELİK',
  );

  static const seasonalMessage = ShareCardTemplate(
    id: 'seasonal_message',
    category: ShareCardCategory.wisdom,
    titleEn: 'Seasonal Reflection',
    titleTr: 'Mevsimsel Düşünce',
    gradientColors: [Color(0xFF242D20), Color(0xFF343D2D), Color(0xFF1A2215)],
    layoutType: ShareCardLayout.quoteBlock,
    icon: Icons.eco_rounded,
    badgeEn: 'SEASON',
    badgeTr: 'MEVSIM',
  );

  static const affirmation = ShareCardTemplate(
    id: 'affirmation',
    category: ShareCardCategory.wisdom,
    titleEn: 'Daily Affirmation',
    titleTr: 'Günlük Olumlama',
    gradientColors: [Color(0xFF3D2E24), Color(0xFF4A3D33), Color(0xFF2D2119)],
    layoutType: ShareCardLayout.quoteBlock,
    icon: Icons.spa_rounded,
    badgeEn: 'AFFIRMATION',
    badgeTr: 'OLUMLAMA',
  );

  // =========================================================================
  // CURATED INSIGHT SENTENCES — Wisdom (5)
  // =========================================================================

  static const wisdomQuietWeeks = ShareCardTemplate(
    id: 'wisdom_quiet_weeks',
    category: ShareCardCategory.wisdom,
    titleEn: 'Quiet Weeks',
    titleTr: 'Sessiz Haftalar',
    gradientColors: [Color(0xFF2D241F), Color(0xFF2D2119), Color(0xFF1E1714)],
    layoutType: ShareCardLayout.quoteBlock,
    icon: Icons.nights_stay_rounded,
    badgeEn: 'INSIGHT',
    badgeTr: 'İÇGÖRÜ',
  );

  static const wisdomSmallShifts = ShareCardTemplate(
    id: 'wisdom_small_shifts',
    category: ShareCardCategory.wisdom,
    titleEn: 'Small Shifts',
    titleTr: 'Küçük Değişimler',
    gradientColors: [Color(0xFF1E1A15), Color(0xFF2D2A22), Color(0xFF1E1A15)],
    layoutType: ShareCardLayout.quoteBlock,
    icon: Icons.spa_rounded,
    badgeEn: 'INSIGHT',
    badgeTr: 'İÇGÖRÜ',
  );

  static const wisdomPatterns = ShareCardTemplate(
    id: 'wisdom_patterns',
    category: ShareCardCategory.wisdom,
    titleEn: 'Patterns',
    titleTr: 'Örüntüler',
    gradientColors: [Color(0xFF2D2119), Color(0xFF3D3025), Color(0xFF1A1510)],
    layoutType: ShareCardLayout.quoteBlock,
    icon: Icons.hub_rounded,
    badgeEn: 'INSIGHT',
    badgeTr: 'İÇGÖRÜ',
  );

  static const wisdomRest = ShareCardTemplate(
    id: 'wisdom_rest',
    category: ShareCardCategory.wisdom,
    titleEn: 'Rest',
    titleTr: 'Dinlenme',
    gradientColors: [Color(0xFF1E1714), Color(0xFF2D241F), Color(0xFF1A1510)],
    layoutType: ShareCardLayout.quoteBlock,
    icon: Icons.bedtime_rounded,
    badgeEn: 'INSIGHT',
    badgeTr: 'İÇGÖRÜ',
  );

  static const wisdomGrowth = ShareCardTemplate(
    id: 'wisdom_growth',
    category: ShareCardCategory.wisdom,
    titleEn: 'Growth',
    titleTr: 'Büyüme',
    gradientColors: [Color(0xFF1A2215), Color(0xFF2D3525), Color(0xFF1A2215)],
    layoutType: ShareCardLayout.quoteBlock,
    icon: Icons.eco_rounded,
    badgeEn: 'INSIGHT',
    badgeTr: 'İÇGÖRÜ',
  );

  // =========================================================================
  // CURATED INSIGHT SENTENCES — Reflection (5)
  // =========================================================================

  static const reflectionSelfAwareness = ShareCardTemplate(
    id: 'reflection_self_awareness',
    category: ShareCardCategory.reflection,
    titleEn: 'Self-Awareness',
    titleTr: 'Öz Farkındalık',
    gradientColors: [Color(0xFF3D2E24), Color(0xFF4A3D33), Color(0xFF2D2119)],
    layoutType: ShareCardLayout.quoteBlock,
    icon: Icons.self_improvement_rounded,
    badgeEn: 'REFLECTION',
    badgeTr: 'YANSIMA',
  );

  static const reflectionPresence = ShareCardTemplate(
    id: 'reflection_presence',
    category: ShareCardCategory.reflection,
    titleEn: 'Presence',
    titleTr: 'Şimdiki An',
    gradientColors: [Color(0xFF1A1508), Color(0xFF2D2410), Color(0xFF1A1208)],
    layoutType: ShareCardLayout.quoteBlock,
    icon: Icons.filter_vintage_rounded,
    badgeEn: 'REFLECTION',
    badgeTr: 'YANSIMA',
  );

  static const reflectionInnerVoice = ShareCardTemplate(
    id: 'reflection_inner_voice',
    category: ShareCardCategory.reflection,
    titleEn: 'Inner Voice',
    titleTr: 'İç Ses',
    gradientColors: [Color(0xFF2D241F), Color(0xFF3D322B), Color(0xFF1E1714)],
    layoutType: ShareCardLayout.quoteBlock,
    icon: Icons.record_voice_over_rounded,
    badgeEn: 'REFLECTION',
    badgeTr: 'YANSIMA',
  );

  static const reflectionResilience = ShareCardTemplate(
    id: 'reflection_resilience',
    category: ShareCardCategory.reflection,
    titleEn: 'Resilience',
    titleTr: 'Dayanıklılık',
    gradientColors: [Color(0xFF2D241F), Color(0xFF352C25), Color(0xFF1E1714)],
    layoutType: ShareCardLayout.quoteBlock,
    icon: Icons.shield_rounded,
    badgeEn: 'REFLECTION',
    badgeTr: 'YANSIMA',
  );

  static const reflectionAcceptance = ShareCardTemplate(
    id: 'reflection_acceptance',
    category: ShareCardCategory.reflection,
    titleEn: 'Acceptance',
    titleTr: 'Kabul',
    gradientColors: [Color(0xFF3D2E24), Color(0xFF4A3D33), Color(0xFF2D2119)],
    layoutType: ShareCardLayout.quoteBlock,
    icon: Icons.favorite_rounded,
    badgeEn: 'REFLECTION',
    badgeTr: 'YANSIMA',
  );

  // =========================================================================
  // MONTHLY WRAPPED CARD
  // =========================================================================

  static const monthlyWrapped = ShareCardTemplate(
    id: 'monthly_wrapped',
    category: ShareCardCategory.achievement,
    titleEn: 'Monthly Wrapped',
    titleTr: 'Aylık Özet',
    gradientColors: [Color(0xFF2D2119), Color(0xFF3D3025), Color(0xFF1E1A15)],
    layoutType: ShareCardLayout.statRow,
    icon: Icons.calendar_month_rounded,
    badgeEn: 'WRAPPED',
    badgeTr: 'ÖZET',
  );

  // =========================================================================
  // CHALLENGE COMPLETE CARD
  // =========================================================================

  static const challengeComplete = ShareCardTemplate(
    id: 'challenge_complete',
    category: ShareCardCategory.achievement,
    titleEn: 'Challenge Complete',
    titleTr: 'Meydan Okuma Tamamlandı',
    gradientColors: [Color(0xFF1A1508), Color(0xFF3D3018), Color(0xFF1A1208)],
    layoutType: ShareCardLayout.badgeHero,
    icon: Icons.emoji_events_rounded,
    badgeEn: 'CHALLENGE',
    badgeTr: 'MEYDAN OKUMA',
  );

  // =========================================================================
  // QUESTION OF THE DAY CARD
  // =========================================================================

  static const questionOfTheDay = ShareCardTemplate(
    id: 'question_of_the_day',
    category: ShareCardCategory.wisdom,
    titleEn: 'Question of the Day',
    titleTr: 'Günün Sorusu',
    gradientColors: [Color(0xFF2D241F), Color(0xFF3D322B), Color(0xFF1E1714)],
    layoutType: ShareCardLayout.quoteBlock,
    icon: Icons.help_outline_rounded,
    badgeEn: 'QUESTION',
    badgeTr: 'SORU',
  );

  // =========================================================================
  // TEMPLATE REGISTRY
  // =========================================================================

  static const List<ShareCardTemplate> all = [
    // Identity
    archetypeReveal,
    attachmentStyle,
    dreamPersonality,
    energyProfile,
    emotionalArchetype,
    // Pattern
    weeklyMoodWave,
    focusAreaRadar,
    streakFlame,
    topEmotion,
    sleepPattern,
    // Cycle Position (Stories)
    cyclePosition,
    // Achievement
    journalMilestone,
    dreamExplorer,
    patternDiscoverer,
    consistencyStar,
    growthJourney,
    // Wisdom (original)
    dailyReflection,
    dreamInsight,
    patternWisdom,
    seasonalMessage,
    affirmation,
    // Wisdom (curated insights)
    wisdomQuietWeeks,
    wisdomSmallShifts,
    wisdomPatterns,
    wisdomRest,
    wisdomGrowth,
    // Reflection (curated insights)
    reflectionSelfAwareness,
    reflectionPresence,
    reflectionInnerVoice,
    reflectionResilience,
    reflectionAcceptance,
    // Challenge Complete
    challengeComplete,
    // Monthly Wrapped & Question of the Day
    monthlyWrapped,
    questionOfTheDay,
  ];

  static List<ShareCardTemplate> byCategory(ShareCardCategory category) {
    return all.where((t) => t.category == category).toList();
  }

  static ShareCardTemplate? byId(String id) {
    return all.where((t) => t.id == id).firstOrNull;
  }

  // =========================================================================
  // DATA BUILDERS - generate ShareCardData from user state
  // =========================================================================

  /// Build card data for a given template. Uses safe language throughout.
  /// When [currentMood] is provided, a dynamic gradient override is applied.
  static ShareCardData buildData({
    required ShareCardTemplate template,
    required bool isEn,
    double? currentMood,
    int streak = 0,
    int journalDays = 0,
    int dreamCount = 0,
    int patternCount = 0,
    int monthDays = 0,
    int growthFrom = 0,
    int growthTo = 0,
    List<double>? moodValues,
    List<double>? focusValues,
    List<double>? sleepValues,
    String? archetypeName,
    String? attachmentResult,
    String? dreamType,
    String? energyType,
    String? emotionalStyle,
    String? topEmotionName,
    String? topEmotionEmoji,
    String? reflectionText,
    String? dreamInsightText,
    String? patternInsightText,
    String? seasonName,
    String? seasonMessage,
    String? affirmationText,
    String? cyclePhaseName,
    String? cyclePhaseDescription,
    int cycleDay = 0,
    int cycleLength = 0,
    String? challengeName,
    String? challengeEmoji,
  }) {
    final ShareCardData result;
    switch (template.id) {
      // ── Identity ──────────────────────────────────────────────────────
      case 'archetype_reveal':
        result = ShareCardData(
          headline: archetypeName ?? (L10nService.get('data.content.share_templates.the_reflector', isEn ? AppLanguage.en : AppLanguage.tr)),
          subtitle: L10nService.get('data.content.share_templates.your_entries_suggest_this_archetype_patt', isEn ? AppLanguage.en : AppLanguage.tr),
          detail: L10nService.get('data.content.share_templates.based_on_your_recent_journal_entries', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case 'attachment_style':
        result = ShareCardData(
          headline:
              attachmentResult ??
              (L10nService.get('data.content.share_templates.secureleaning', isEn ? AppLanguage.en : AppLanguage.tr)),
          subtitle: L10nService.get('data.content.share_templates.your_entries_suggest_this_attachment_pat', isEn ? AppLanguage.en : AppLanguage.tr),
          detail: L10nService.get('data.content.share_templates.drawn_from_your_selfreflection_quiz', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case 'dream_personality':
        result = ShareCardData(
          headline: dreamType ?? (L10nService.get('data.content.share_templates.the_voyager', isEn ? AppLanguage.en : AppLanguage.tr)),
          subtitle: L10nService.get('data.content.share_templates.your_dream_journal_suggests_this_persona', isEn ? AppLanguage.en : AppLanguage.tr),
          detail: L10nService.get('data.content.share_templates.based_on_recurring_dream_themes', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case 'energy_profile':
        result = ShareCardData(
          headline: energyType ?? (L10nService.get('data.content.share_templates.steady_flow', isEn ? AppLanguage.en : AppLanguage.tr)),
          subtitle: L10nService.get('data.content.share_templates.your_entries_suggest_this_energy_rhythm', isEn ? AppLanguage.en : AppLanguage.tr),
          detail: L10nService.get('data.content.share_templates.patterns_drawn_from_your_daily_entries', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case 'emotional_archetype':
        result = ShareCardData(
          headline:
              emotionalStyle ?? (L10nService.get('data.content.share_templates.deep_processor', isEn ? AppLanguage.en : AppLanguage.tr)),
          subtitle: L10nService.get('data.content.share_templates.you_tend_to_process_feelings_with_depth', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      // ── Pattern ───────────────────────────────────────────────────────
      case 'weekly_mood_wave':
        result = ShareCardData(
          headline: L10nService.get('data.content.share_templates.my_week_in_feelings', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: L10nService.get('data.content.share_templates.patterns_drawn_from_7day_mood_data', isEn ? AppLanguage.en : AppLanguage.tr),
          chartValues: moodValues ?? [3, 4, 3, 5, 4, 3, 4],
          chartLabels: isEn
              ? ['M', 'T', 'W', 'T', 'F', 'S', 'S']
              : ['Pt', 'Sa', 'Ca', 'Pe', 'Cu', 'Ct', 'Pa'],
        );

      case 'focus_area_radar':
        result = ShareCardData(
          headline: L10nService.get('data.content.share_templates.focus_area_balance', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: L10nService.get('data.content.share_templates.how_your_attention_spreads_across_areas', isEn ? AppLanguage.en : AppLanguage.tr),
          chartValues: focusValues ?? [4, 3, 5, 2, 4],
          chartLabels: isEn
              ? ['Mind', 'Body', 'Heart', 'Inner', 'Social']
              : ['Zihin', 'Beden', 'Kalp', 'İç', 'Sosyal'],
        );

      case 'streak_flame':
        final streakText = streak > 0 ? '$streak' : '0';
        result = ShareCardData(
          headline: isEn ? 'Day $streakText' : '$streakText Gün',
          subtitle: L10nService.get('data.content.share_templates.consistency_builds_selfawareness', isEn ? AppLanguage.en : AppLanguage.tr),
          statValue: streakText,
          statLabel: L10nService.get('data.content.share_templates.day_streak', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case 'top_emotion':
        result = ShareCardData(
          headline: topEmotionName ?? (L10nService.get('data.content.share_templates.calm', isEn ? AppLanguage.en : AppLanguage.tr)),
          subtitle: L10nService.get('data.content.share_templates.your_most_frequent_emotion_this_month', isEn ? AppLanguage.en : AppLanguage.tr),
          statValue: topEmotionEmoji ?? '\u{1F60C}',
          statLabel: L10nService.get('data.content.share_templates.dominant_this_month', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case 'sleep_pattern':
        result = ShareCardData(
          headline: L10nService.get('data.content.share_templates.my_sleep_quality', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: L10nService.get('data.content.share_templates.how_your_rest_has_been_this_week', isEn ? AppLanguage.en : AppLanguage.tr),
          chartValues: sleepValues ?? [3, 4, 4, 5, 3, 4, 4],
          chartLabels: isEn
              ? ['M', 'T', 'W', 'T', 'F', 'S', 'S']
              : ['Pt', 'Sa', 'Ca', 'Pe', 'Cu', 'Ct', 'Pa'],
        );

      // ── Achievement ───────────────────────────────────────────────────
      case 'journal_milestone':
        final days = journalDays > 0 ? journalDays : 30;
        result = ShareCardData(
          headline: isEn ? '$days Days of Journaling' : '$days Gün Günlük',
          subtitle: L10nService.get('data.content.share_templates.another_milestone_of_showing_up_for_your', isEn ? AppLanguage.en : AppLanguage.tr),
          statValue: '$days',
          statLabel: L10nService.get('data.content.share_templates.days', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case 'dream_explorer':
        final count = dreamCount > 0 ? dreamCount : 10;
        result = ShareCardData(
          headline: isEn ? 'Explored $count Dreams' : '$count Rüya Keşfedildi',
          subtitle: L10nService.get('data.content.share_templates.your_dream_world_keeps_revealing_insight', isEn ? AppLanguage.en : AppLanguage.tr),
          statValue: '$count',
          statLabel: L10nService.get('data.content.share_templates.dreams', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case 'pattern_discoverer':
        final count = patternCount > 0 ? patternCount : 5;
        result = ShareCardData(
          headline: isEn ? 'Found $count Patterns' : '$count Örüntü Bulundu',
          subtitle: L10nService.get('data.content.share_templates.selfawareness_grows_with_each_discovery', isEn ? AppLanguage.en : AppLanguage.tr),
          statValue: '$count',
          statLabel: L10nService.get('data.content.share_templates.patterns', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case 'consistency_star':
        final days = monthDays > 0 ? monthDays : 20;
        result = ShareCardData(
          headline: isEn
              ? 'Journaled $days Days This Month'
              : 'Bu Ay $days Gün Yazıldı',
          subtitle: L10nService.get('data.content.share_templates.showing_up_consistently_for_yourself', isEn ? AppLanguage.en : AppLanguage.tr),
          statValue: '$days',
          statLabel: L10nService.get('data.content.share_templates.days_this_month', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case 'growth_journey':
        final from = growthFrom > 0 ? growthFrom : 42;
        final to = growthTo > 0 ? growthTo : 78;
        result = ShareCardData(
          headline: isEn
              ? 'Growth: $from \u{2192} $to'
              : 'Gelişim: $from \u{2192} $to',
          subtitle: L10nService.get('data.content.share_templates.your_growth_score_has_been_rising_steadi', isEn ? AppLanguage.en : AppLanguage.tr),
          statValue: '+${to - from}',
          statLabel: L10nService.get('data.content.share_templates.points_gained', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      // ── Wisdom ────────────────────────────────────────────────────────
      case 'daily_reflection':
        result = ShareCardData(
          headline:
              reflectionText ??
              (L10nService.get('data.content.share_templates.every_moment_of_stillness_is_a_step_inwa', isEn ? AppLanguage.en : AppLanguage.tr)),
          subtitle: L10nService.get('data.content.share_templates.daily_reflection', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case 'dream_insight':
        result = ShareCardData(
          headline:
              dreamInsightText ??
              (L10nService.get('data.content.share_templates.your_dreams_may_be_pointing_toward_unres', isEn ? AppLanguage.en : AppLanguage.tr)),
          subtitle: L10nService.get('data.content.share_templates.from_your_dream_journal', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case 'pattern_wisdom':
        result = ShareCardData(
          headline:
              patternInsightText ??
              (L10nService.get('data.content.share_templates.your_entries_suggest_you_tend_to_find_cl', isEn ? AppLanguage.en : AppLanguage.tr)),
          subtitle: L10nService.get('data.content.share_templates.drawn_from_your_patterns', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case 'seasonal_message':
        final season = seasonName ?? (L10nService.get('data.content.share_templates.winter', isEn ? AppLanguage.en : AppLanguage.tr));
        result = ShareCardData(
          headline:
              seasonMessage ??
              (L10nService.get('data.content.share_templates.a_season_for_rest_reflection_and_inner_r', isEn ? AppLanguage.en : AppLanguage.tr)),
          subtitle: '$season ${L10nService.get('data.content.share_templates.reflection', isEn ? AppLanguage.en : AppLanguage.tr)}',
        );

      case 'affirmation':
        result = ShareCardData(
          headline:
              affirmationText ??
              (L10nService.get('data.content.share_templates.i_trust_the_process_of_my_own_growth', isEn ? AppLanguage.en : AppLanguage.tr)),
          subtitle: L10nService.get('data.content.share_templates.daily_affirmation', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      // ── Cycle Position ─────────────────────────────────────────────────
      case 'cycle_position':
        final day = cycleDay > 0 ? cycleDay : 12;
        final length = cycleLength > 0 ? cycleLength : 28;
        final phase = cyclePhaseName ?? (L10nService.get('data.content.share_templates.expansion', isEn ? AppLanguage.en : AppLanguage.tr));
        final desc =
            cyclePhaseDescription ??
            (L10nService.get('data.content.share_templates.your_recent_entries_suggest_a_period_of', isEn ? AppLanguage.en : AppLanguage.tr));
        result = ShareCardData(
          headline: phase,
          subtitle: desc,
          detail: isEn ? 'Day $day of $length' : '$length günün $day. günü',
          statValue: '$day',
          statLabel: '$length',
          chartValues: [day.toDouble(), length.toDouble()],
        );

      // ── Curated Wisdom Insights ────────────────────────────────────
      case 'wisdom_quiet_weeks':
        result = ShareCardData(
          headline: L10nService.get('data.content.share_templates.your_quietest_weeks_often_hold_your_deep', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: L10nService.get('data.content.share_templates.from_your_patterns', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case 'wisdom_small_shifts':
        result = ShareCardData(
          headline: L10nService.get('data.content.share_templates.the_smallest_shifts_in_awareness_often_l', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: L10nService.get('data.content.share_templates.curated_insight', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case 'wisdom_patterns':
        result = ShareCardData(
          headline: L10nService.get('data.content.share_templates.your_patterns_are_not_your_limits_they_a', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: L10nService.get('data.content.share_templates.pattern_wisdom', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case 'wisdom_rest':
        result = ShareCardData(
          headline: L10nService.get('data.content.share_templates.rest_is_not_the_absence_of_progress_it_i', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: L10nService.get('data.content.share_templates.rest_insight', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case 'wisdom_growth':
        result = ShareCardData(
          headline: L10nService.get('data.content.share_templates.growth_often_feels_like_confusion_before', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: L10nService.get('data.content.share_templates.growth_wisdom', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      // ── Curated Reflection Insights ─────────────────────────────────
      case 'reflection_self_awareness':
        result = ShareCardData(
          headline: L10nService.get('data.content.share_templates.noticing_yourself_is_the_first_act_of_ch', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: L10nService.get('data.content.share_templates.selfawareness', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case 'reflection_presence':
        result = ShareCardData(
          headline: L10nService.get('data.content.share_templates.the_present_moment_holds_more_wisdom_tha', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: L10nService.get('data.content.share_templates.presence', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case 'reflection_inner_voice':
        result = ShareCardData(
          headline: L10nService.get('data.content.share_templates.your_inner_voice_gets_clearer_when_you_g', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: L10nService.get('data.content.share_templates.inner_voice', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case 'reflection_resilience':
        result = ShareCardData(
          headline: L10nService.get('data.content.share_templates.you_have_survived_every_difficult_day_so', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: L10nService.get('data.content.share_templates.resilience', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case 'reflection_acceptance':
        result = ShareCardData(
          headline: L10nService.get('data.content.share_templates.acceptance_is_not_giving_up_it_is_making', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: L10nService.get('data.content.share_templates.acceptance', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      // ── Monthly Wrapped ─────────────────────────────────────────
      case 'monthly_wrapped':
        final entries = journalDays > 0 ? journalDays : 0;
        final avg = (moodValues != null && moodValues.isNotEmpty)
            ? (moodValues.reduce((a, b) => a + b) / moodValues.length)
                  .toStringAsFixed(1)
            : '—';
        result = ShareCardData(
          headline: isEn
              ? '$entries entries this month'
              : 'Bu ay $entries kayıt',
          subtitle: isEn
              ? 'Average rating: $avg — your month at a glance'
              : 'Ortalama puan: $avg — ayına genel bakış',
          statValue: '$entries',
          statLabel: L10nService.get('data.content.share_templates.entries', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      // ── Challenge Complete ──────────────────────────────────────
      case 'challenge_complete':
        final emoji = challengeEmoji ?? '\u{1F3C6}';
        final name = challengeName ?? (L10nService.get('data.content.share_templates.challenge', isEn ? AppLanguage.en : AppLanguage.tr));
        result = ShareCardData(
          headline: isEn ? '$name Completed!' : '$name Tamamlandı!',
          subtitle: L10nService.get('data.content.share_templates.you_showed_real_commitment', isEn ? AppLanguage.en : AppLanguage.tr),
          statValue: emoji,
          statLabel: L10nService.get('data.content.share_templates.completed', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      // ── Question of the Day ─────────────────────────────────────
      case 'question_of_the_day':
        result = ShareCardData(
          headline:
              reflectionText ??
              (L10nService.get('data.content.share_templates.what_would_you_tell_your_younger_self_to', isEn ? AppLanguage.en : AppLanguage.tr)),
          subtitle: L10nService.get('data.content.share_templates.question_of_the_day', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      default:
        result = ShareCardData(
          headline: L10nService.get('data.content.share_templates.innercycles', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: L10nService.get('data.content.share_templates.cyclical_intelligence', isEn ? AppLanguage.en : AppLanguage.tr),
        );
    }

    // Apply mood gradient override if currentMood is provided
    if (currentMood != null) {
      final gradient = EmotionalGradient.blendedGradient(
        moodValue: currentMood,
      );
      return result.withMoodGradient(gradient);
    }
    return result;
  }

  // =========================================================================
  // ACCENT COLOR FOR EACH TEMPLATE
  // =========================================================================

  static Color accentColor(ShareCardTemplate template) {
    switch (template.id) {
      case 'archetype_reveal':
        return AppColors.amethyst;
      case 'attachment_style':
        return AppColors.softPink;
      case 'dream_personality':
        return AppColors.blueAccent;
      case 'energy_profile':
        return AppColors.starGold;
      case 'emotional_archetype':
        return AppColors.twilightEnd;
      case 'weekly_mood_wave':
        return AppColors.sunriseStart;
      case 'focus_area_radar':
        return AppColors.auroraStart;
      case 'streak_flame':
        return AppColors.starGold;
      case 'top_emotion':
        return AppColors.sunriseEnd;
      case 'sleep_pattern':
        return AppColors.amethystBlue;
      case 'journal_milestone':
        return AppColors.celestialGold;
      case 'dream_explorer':
        return AppColors.blueAccent;
      case 'pattern_discoverer':
        return AppColors.auroraEnd;
      case 'consistency_star':
        return AppColors.starGold;
      case 'growth_journey':
        return AppColors.success;
      case 'daily_reflection':
        return AppColors.amethyst;
      case 'dream_insight':
        return AppColors.blueAccent;
      case 'pattern_wisdom':
        return AppColors.auroraStart;
      case 'seasonal_message':
        return AppColors.greenAccent;
      case 'affirmation':
        return AppColors.sunriseStart;
      case 'cycle_position':
        return AppColors.twilightEnd;
      // Curated wisdom insights
      case 'wisdom_quiet_weeks':
        return AppColors.amethyst;
      case 'wisdom_small_shifts':
        return AppColors.auroraStart;
      case 'wisdom_patterns':
        return AppColors.twilightEnd;
      case 'wisdom_rest':
        return AppColors.amethystBlue;
      case 'wisdom_growth':
        return AppColors.success;
      // Curated reflection insights
      case 'reflection_self_awareness':
        return AppColors.sunriseStart;
      case 'reflection_presence':
        return AppColors.celestialGold;
      case 'reflection_inner_voice':
        return AppColors.auroraEnd;
      case 'reflection_resilience':
        return AppColors.starGold;
      case 'reflection_acceptance':
        return AppColors.softPink;
      // Challenge Complete
      case 'challenge_complete':
        return AppColors.celestialGold;
      // Monthly Wrapped & Question of the Day
      case 'monthly_wrapped':
        return AppColors.celestialGold;
      case 'question_of_the_day':
        return AppColors.auroraEnd;
      default:
        return AppColors.auroraStart;
    }
  }
}
