// ============================================================================
// SHARE CARD MODELS - Template definitions for shareable InnerCycles cards
// ============================================================================
// 20 unique card templates across 4 categories: identity, pattern,
// achievement, and wisdom. Each template defines its visual style, layout,
// and data requirements.
// ============================================================================

import 'package:flutter/material.dart';
import '../services/l10n_service.dart';
import '../providers/app_providers.dart';

/// High-level category for share card templates
enum ShareCardCategory {
  identity,
  pattern,
  achievement,
  wisdom,
  reflection;

  String label(bool isEn) {
    final language = AppLanguage.fromIsEn(isEn);
    switch (this) {
      case ShareCardCategory.identity:
        return L10nService.get('data.models.share_models.identity', language);
      case ShareCardCategory.pattern:
        return L10nService.get('data.models.share_models.patterns', language);
      case ShareCardCategory.achievement:
        return L10nService.get('data.models.share_models.achievements', language);
      case ShareCardCategory.wisdom:
        return L10nService.get('data.models.share_models.wisdom', language);
      case ShareCardCategory.reflection:
        return L10nService.get('data.models.share_models.reflection', language);
    }
  }

  IconData get icon {
    switch (this) {
      case ShareCardCategory.identity:
        return Icons.auto_awesome;
      case ShareCardCategory.pattern:
        return Icons.insights_rounded;
      case ShareCardCategory.achievement:
        return Icons.emoji_events_rounded;
      case ShareCardCategory.wisdom:
        return Icons.lightbulb_rounded;
      case ShareCardCategory.reflection:
        return Icons.self_improvement_rounded;
    }
  }
}

/// Layout type for rendering the card body
enum ShareCardLayout {
  centered, // headline + subtitle centered
  badgeHero, // large badge/icon + stats
  miniChart, // small inline chart + text
  quoteBlock, // decorative quote with attribution
  statRow, // key stat numbers in a row
  cyclePosition, // circular arc + phase name (Instagram Stories 9:16)
}

/// A single shareable card template definition
class ShareCardTemplate {
  final String id;
  final ShareCardCategory category;
  final String titleEn;
  final String titleTr;
  final List<Color> gradientColors;
  final ShareCardLayout layoutType;
  final IconData icon;
  final String badgeEn;
  final String badgeTr;

  const ShareCardTemplate({
    required this.id,
    required this.category,
    required this.titleEn,
    required this.titleTr,
    required this.gradientColors,
    required this.layoutType,
    required this.icon,
    required this.badgeEn,
    required this.badgeTr,
  });

  String title(bool isEn) => isEn ? titleEn : titleTr;
  String badge(bool isEn) => isEn ? badgeEn : badgeTr;
}

/// User-specific data that gets injected into a template at render time
class ShareCardData {
  final String headline;
  final String subtitle;
  final String? detail;
  final String? statValue;
  final String? statLabel;
  final List<double>? chartValues;
  final List<String>? chartLabels;

  /// Dynamic mood-based gradient override (from EmotionalGradient engine)
  final List<Color>? moodGradientOverride;

  /// When this card was generated (used for seasonal tone shifts)
  final DateTime? generatedAt;

  const ShareCardData({
    required this.headline,
    required this.subtitle,
    this.detail,
    this.statValue,
    this.statLabel,
    this.chartValues,
    this.chartLabels,
    this.moodGradientOverride,
    this.generatedAt,
  });

  /// Create a copy with mood gradient applied
  ShareCardData withMoodGradient(List<Color> gradient) => ShareCardData(
    headline: headline,
    subtitle: subtitle,
    detail: detail,
    statValue: statValue,
    statLabel: statLabel,
    chartValues: chartValues,
    chartLabels: chartLabels,
    moodGradientOverride: gradient,
    generatedAt: generatedAt ?? DateTime.now(),
  );
}
