// ============================================================================
// SHARE CARD TEMPLATES - 20 shareable card templates for InnerCycles
// ============================================================================
// Organized into 4 categories: Identity (5), Pattern (5), Achievement (5),
// Wisdom (5). Each template has gradient colors, layout type, and metadata.
// ============================================================================

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../models/share_card_models.dart';

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
    gradientColors: [Color(0xFF1A0A2E), Color(0xFF2D1B69), Color(0xFF0D0517)],
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
    gradientColors: [Color(0xFF2D1B3D), Color(0xFF4A2040), Color(0xFF1A0A1E)],
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
    gradientColors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
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
    gradientColors: [Color(0xFF1A1A3E), Color(0xFF2A1A4E), Color(0xFF0D0D1F)],
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
    gradientColors: [Color(0xFF1A0A2E), Color(0xFF2E1065), Color(0xFF1A0530)],
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
    gradientColors: [Color(0xFF0D1B2A), Color(0xFF1B2838), Color(0xFF0A1628)],
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
    gradientColors: [Color(0xFF2D1B3D), Color(0xFF3D2050), Color(0xFF1A0A2E)],
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
    gradientColors: [Color(0xFF0D0D2B), Color(0xFF151540), Color(0xFF0A0A1F)],
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
    titleEn: 'Dream Explorer',
    titleTr: 'Rüya Kâşifi',
    gradientColors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF0F2027)],
    layoutType: ShareCardLayout.badgeHero,
    icon: Icons.explore_rounded,
    badgeEn: 'EXPLORER',
    badgeTr: 'KÂŞİF',
  );

  static const patternDiscoverer = ShareCardTemplate(
    id: 'pattern_discoverer',
    category: ShareCardCategory.achievement,
    titleEn: 'Pattern Discoverer',
    titleTr: 'Örüntü Keşfedici',
    gradientColors: [Color(0xFF1A1A3E), Color(0xFF2A2A5E), Color(0xFF0D0D1F)],
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
    titleEn: 'Growth Journey',
    titleTr: 'Gelişim Yolculuğu',
    gradientColors: [Color(0xFF0A1F0A), Color(0xFF1A3A1A), Color(0xFF0A1F0A)],
    layoutType: ShareCardLayout.statRow,
    icon: Icons.trending_up_rounded,
    badgeEn: 'GROWTH',
    badgeTr: 'GELİŞİM',
  );

  // =========================================================================
  // WISDOM CARDS (5)
  // =========================================================================

  static const dailyReflection = ShareCardTemplate(
    id: 'daily_reflection',
    category: ShareCardCategory.wisdom,
    titleEn: 'Daily Reflection',
    titleTr: 'Günlük Düşünce',
    gradientColors: [Color(0xFF1A0A2E), Color(0xFF16082A), Color(0xFF0D0517)],
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
    gradientColors: [Color(0xFF0F2027), Color(0xFF1A3040), Color(0xFF0F2027)],
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
    gradientColors: [Color(0xFF1A1A3E), Color(0xFF252550), Color(0xFF0D0D1F)],
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
    gradientColors: [Color(0xFF1A2A1A), Color(0xFF2A3A2A), Color(0xFF0A1A0A)],
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
    gradientColors: [Color(0xFF2D1B3D), Color(0xFF3D2850), Color(0xFF1A0A2E)],
    layoutType: ShareCardLayout.quoteBlock,
    icon: Icons.spa_rounded,
    badgeEn: 'AFFIRMATION',
    badgeTr: 'OLUMLAMA',
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
    // Achievement
    journalMilestone,
    dreamExplorer,
    patternDiscoverer,
    consistencyStar,
    growthJourney,
    // Wisdom
    dailyReflection,
    dreamInsight,
    patternWisdom,
    seasonalMessage,
    affirmation,
  ];

  static List<ShareCardTemplate> byCategory(ShareCardCategory category) {
    return all.where((t) => t.category == category).toList();
  }

  static ShareCardTemplate? byId(String id) {
    try {
      return all.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  // =========================================================================
  // DATA BUILDERS - generate ShareCardData from user state
  // =========================================================================

  /// Build card data for a given template. Uses safe language throughout.
  static ShareCardData buildData({
    required ShareCardTemplate template,
    required bool isEn,
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
  }) {
    switch (template.id) {
      // ── Identity ──────────────────────────────────────────────────────
      case 'archetype_reveal':
        return ShareCardData(
          headline: archetypeName ?? (isEn ? 'The Reflector' : 'Yansıtıcı'),
          subtitle: isEn
              ? 'Your entries suggest this archetype pattern'
              : 'Kayıtların bu arketip örüntüsünü gösteriyor',
          detail: isEn
              ? 'Based on your recent journal entries'
              : 'Son kayıtlarına dayanarak',
        );

      case 'attachment_style':
        return ShareCardData(
          headline: attachmentResult ??
              (isEn ? 'Secure-Leaning' : 'Güvenli Eğilimli'),
          subtitle: isEn
              ? 'Your entries suggest this attachment pattern'
              : 'Kayıtların bu bağlanma örüntüsünü gösteriyor',
          detail: isEn
              ? 'Drawn from your self-reflection quiz'
              : 'Öz-düşünce testinden çıkarıldı',
        );

      case 'dream_personality':
        return ShareCardData(
          headline:
              dreamType ?? (isEn ? 'The Voyager' : 'Gezgin'),
          subtitle: isEn
              ? 'Your dream journal suggests this personality type'
              : 'Rüya güncen bu kişilik tipini gösteriyor',
          detail: isEn
              ? 'Based on recurring dream themes'
              : 'Tekrarlayan rüya temalarına dayanarak',
        );

      case 'energy_profile':
        return ShareCardData(
          headline:
              energyType ?? (isEn ? 'Steady Flow' : 'Düzenli Akış'),
          subtitle: isEn
              ? 'Your entries suggest this energy rhythm'
              : 'Kayıtların bu enerji ritmini gösteriyor',
          detail: isEn
              ? 'Patterns drawn from your daily entries'
              : 'Günlük kayıtlarından çıkarıldı',
        );

      case 'emotional_archetype':
        return ShareCardData(
          headline: emotionalStyle ??
              (isEn ? 'Deep Processor' : 'Derin İşleyici'),
          subtitle: isEn
              ? 'You tend to process feelings with depth and care'
              : 'Duyguları derinlik ve özenle işleme eğiliminde olabilirsin',
        );

      // ── Pattern ───────────────────────────────────────────────────────
      case 'weekly_mood_wave':
        return ShareCardData(
          headline: isEn ? 'My Week in Feelings' : 'Duygularla Geçen Haftam',
          subtitle: isEn
              ? 'Patterns drawn from 7-day mood data'
              : 'Son 7 günlük duygu verisinden çıkarıldı',
          chartValues: moodValues ?? [3, 4, 3, 5, 4, 3, 4],
          chartLabels: isEn
              ? ['M', 'T', 'W', 'T', 'F', 'S', 'S']
              : ['Pt', 'Sa', 'Ca', 'Pe', 'Cu', 'Ct', 'Pa'],
        );

      case 'focus_area_radar':
        return ShareCardData(
          headline:
              isEn ? 'Focus Area Balance' : 'Odak Alanı Dengesi',
          subtitle: isEn
              ? 'How your attention spreads across areas'
              : 'Dikkatinin alanlara nasıl dağıldığını gösteriyor',
          chartValues: focusValues ?? [4, 3, 5, 2, 4],
          chartLabels: isEn
              ? ['Mind', 'Body', 'Heart', 'Inner', 'Social']
              : ['Zihin', 'Beden', 'Kalp', 'İç', 'Sosyal'],
        );

      case 'streak_flame':
        final streakText = streak > 0 ? '$streak' : '0';
        return ShareCardData(
          headline: isEn ? 'Day $streakText' : '$streakText Gün',
          subtitle: isEn
              ? 'Consistency builds self-awareness'
              : 'Tutarlılık öz-farkındalığın temelidir',
          statValue: streakText,
          statLabel: isEn ? 'day streak' : 'günlük seri',
        );

      case 'top_emotion':
        return ShareCardData(
          headline: topEmotionName ?? (isEn ? 'Calm' : 'Sakin'),
          subtitle: isEn
              ? 'Your most frequent emotion this month'
              : 'Bu ayın en sık duygun',
          statValue: topEmotionEmoji ?? '\u{1F60C}',
          statLabel: isEn ? 'dominant this month' : 'bu ay baskın',
        );

      case 'sleep_pattern':
        return ShareCardData(
          headline:
              isEn ? 'My Sleep Quality' : 'Uyku Kalitem',
          subtitle: isEn
              ? 'How your rest has been this week'
              : 'Bu hafta uyku durumun nasıl geçti',
          chartValues: sleepValues ?? [3, 4, 4, 5, 3, 4, 4],
          chartLabels: isEn
              ? ['M', 'T', 'W', 'T', 'F', 'S', 'S']
              : ['Pt', 'Sa', 'Ca', 'Pe', 'Cu', 'Ct', 'Pa'],
        );

      // ── Achievement ───────────────────────────────────────────────────
      case 'journal_milestone':
        final days = journalDays > 0 ? journalDays : 30;
        return ShareCardData(
          headline: isEn ? '$days Days of Journaling' : '$days Gün Günlük',
          subtitle: isEn
              ? 'Another milestone of showing up for yourself'
              : 'Kendin için var olduğun bir basamak daha',
          statValue: '$days',
          statLabel: isEn ? 'days' : 'gün',
        );

      case 'dream_explorer':
        final count = dreamCount > 0 ? dreamCount : 10;
        return ShareCardData(
          headline: isEn
              ? 'Explored $count Dreams'
              : '$count Rüya Keşfedildi',
          subtitle: isEn
              ? 'Your dream world keeps revealing insights'
              : 'Rüya dünyan içgörüler sunmaya devam ediyor',
          statValue: '$count',
          statLabel: isEn ? 'dreams' : 'rüya',
        );

      case 'pattern_discoverer':
        final count = patternCount > 0 ? patternCount : 5;
        return ShareCardData(
          headline: isEn
              ? 'Found $count Patterns'
              : '$count Örüntü Bulundu',
          subtitle: isEn
              ? 'Self-awareness grows with each discovery'
              : 'Her keşifle öz-farkındalık büyüyor',
          statValue: '$count',
          statLabel: isEn ? 'patterns' : 'örüntü',
        );

      case 'consistency_star':
        final days = monthDays > 0 ? monthDays : 20;
        return ShareCardData(
          headline: isEn
              ? 'Journaled $days Days This Month'
              : 'Bu Ay $days Gün Yazıldı',
          subtitle: isEn
              ? 'Showing up consistently for yourself'
              : 'Kendin için düzenli olarak var oluyorsun',
          statValue: '$days',
          statLabel: isEn ? 'days this month' : 'gün bu ay',
        );

      case 'growth_journey':
        final from = growthFrom > 0 ? growthFrom : 42;
        final to = growthTo > 0 ? growthTo : 78;
        return ShareCardData(
          headline: isEn
              ? 'Growth: $from \u{2192} $to'
              : 'Gelişim: $from \u{2192} $to',
          subtitle: isEn
              ? 'Your growth score has been rising steadily'
              : 'Gelişim puanın istikrarlı bir şekilde yükseliyor',
          statValue: '+${to - from}',
          statLabel: isEn ? 'points gained' : 'puan kazanıldı',
        );

      // ── Wisdom ────────────────────────────────────────────────────────
      case 'daily_reflection':
        return ShareCardData(
          headline: reflectionText ??
              (isEn
                  ? 'Every moment of stillness is a step inward.'
                  : 'Her sessizlik anı, içeride atılan bir adımdır.'),
          subtitle: isEn ? 'Daily Reflection' : 'Günlük Düşünce',
        );

      case 'dream_insight':
        return ShareCardData(
          headline: dreamInsightText ??
              (isEn
                  ? 'Your dreams may be pointing toward unresolved feelings.'
                  : 'Rüyaların çözülmemiş duygulara işaret ediyor olabilir.'),
          subtitle: isEn ? 'From your dream journal' : 'Rüya güncenden',
        );

      case 'pattern_wisdom':
        return ShareCardData(
          headline: patternInsightText ??
              (isEn
                  ? 'Your entries suggest you tend to find clarity after rest.'
                  : 'Kayıtların, dinlendikten sonra netleştiği gösteriyor.'),
          subtitle: isEn
              ? 'Drawn from your patterns'
              : 'Örüntülerinizden çıkarıldı',
        );

      case 'seasonal_message':
        final season = seasonName ?? (isEn ? 'Winter' : 'Kış');
        return ShareCardData(
          headline: seasonMessage ??
              (isEn
                  ? 'A season for rest, reflection, and inner renewal.'
                  : 'Dinlenme, düşünme ve iç yenilenme mevsimi.'),
          subtitle: '$season ${isEn ? 'Reflection' : 'Düşüncesi'}',
        );

      case 'affirmation':
        return ShareCardData(
          headline: affirmationText ??
              (isEn
                  ? 'I trust the process of my own growth.'
                  : 'Kendi gelişim sürecime güveniyorum.'),
          subtitle: isEn ? 'Daily Affirmation' : 'Günlük Olumlama',
        );

      default:
        return ShareCardData(
          headline: isEn ? 'InnerCycles' : 'InnerCycles',
          subtitle: isEn ? 'Personal Reflection' : 'Kişisel Yansıtma',
        );
    }
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
        return AppColors.mysticBlue;
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
      default:
        return AppColors.auroraStart;
    }
  }
}
