import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../data/providers/app_providers.dart';
import '../../data/services/l10n_service.dart';

/// Premium Upsell Widget Types
enum PremiumUpsellType {
  banner, // Full-width banner
  card, // Floating card
  inline, // Inline text link
  modal, // Modal popup
  subtle, // Subtle hint
}

/// Premium Upsell Widget
/// Contextual premium feature promotion
class PremiumUpsell extends ConsumerWidget {
  final PremiumUpsellType type;
  final String? titleOverride;
  final String? descriptionOverride;
  final String? ctaTextOverride;
  final List<String>? features;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool dismissible;
  final _UpsellPreset _preset;

  const PremiumUpsell({
    super.key,
    this.type = PremiumUpsellType.card,
    String? title,
    String? description,
    String? ctaText,
    this.features,
    this.icon,
    this.onTap,
    this.dismissible = false,
  })  : titleOverride = title,
        descriptionOverride = description,
        ctaTextOverride = ctaText,
        _preset = _UpsellPreset.defaultPreset;

  /// Factory for birth chart upsell
  const PremiumUpsell.birthChart({
    super.key,
    this.onTap,
  })  : type = PremiumUpsellType.card,
        titleOverride = null,
        descriptionOverride = null,
        ctaTextOverride = null,
        features = null,
        icon = Icons.auto_graph,
        dismissible = false,
        _preset = _UpsellPreset.birthChart;

  /// Factory for transit report upsell
  const PremiumUpsell.transits({
    super.key,
    this.onTap,
  })  : type = PremiumUpsellType.card,
        titleOverride = null,
        descriptionOverride = null,
        ctaTextOverride = null,
        features = null,
        icon = Icons.timeline,
        dismissible = false,
        _preset = _UpsellPreset.transits;

  /// Factory for compatibility upsell
  const PremiumUpsell.compatibility({
    super.key,
    this.onTap,
  })  : type = PremiumUpsellType.card,
        titleOverride = null,
        descriptionOverride = null,
        ctaTextOverride = null,
        features = null,
        icon = Icons.favorite,
        dismissible = false,
        _preset = _UpsellPreset.compatibility;

  /// Factory for subtle inline upsell
  const PremiumUpsell.subtle({
    super.key,
    required String featureName,
    this.onTap,
  })  : type = PremiumUpsellType.subtle,
        titleOverride = featureName,
        descriptionOverride = null,
        ctaTextOverride = null,
        features = null,
        icon = null,
        dismissible = false,
        _preset = _UpsellPreset.subtle;

  /// Factory for banner upsell
  const PremiumUpsell.banner({
    super.key,
    this.onTap,
  })  : type = PremiumUpsellType.banner,
        titleOverride = null,
        descriptionOverride = null,
        ctaTextOverride = null,
        features = null,
        icon = Icons.auto_awesome,
        dismissible = false,
        _preset = _UpsellPreset.banner;

  String _getTitle(AppLanguage language) {
    if (titleOverride != null) return titleOverride!;
    switch (_preset) {
      case _UpsellPreset.birthChart:
        return L10nService.get('widgets.premium_upsell.birth_chart_title', language);
      case _UpsellPreset.transits:
        return L10nService.get('widgets.premium_upsell.transits_title', language);
      case _UpsellPreset.compatibility:
        return L10nService.get('widgets.premium_upsell.compatibility_title', language);
      case _UpsellPreset.banner:
        return L10nService.get('widgets.premium_upsell.banner_title', language);
      case _UpsellPreset.subtle:
        return titleOverride ?? '';
      case _UpsellPreset.defaultPreset:
        return L10nService.get('widgets.premium_upsell.default_title', language);
    }
  }

  String _getDescription(AppLanguage language) {
    if (descriptionOverride != null) return descriptionOverride!;
    switch (_preset) {
      case _UpsellPreset.birthChart:
        return L10nService.get('widgets.premium_upsell.birth_chart_description', language);
      case _UpsellPreset.transits:
        return L10nService.get('widgets.premium_upsell.transits_description', language);
      case _UpsellPreset.compatibility:
        return L10nService.get('widgets.premium_upsell.compatibility_description', language);
      case _UpsellPreset.banner:
        return L10nService.get('widgets.premium_upsell.banner_description', language);
      case _UpsellPreset.subtle:
        return L10nService.get('widgets.premium_upsell.subtle_description', language);
      case _UpsellPreset.defaultPreset:
        return L10nService.get('widgets.premium_upsell.default_description', language);
    }
  }

  String _getCtaText(AppLanguage language) {
    if (ctaTextOverride != null) return ctaTextOverride!;
    switch (_preset) {
      case _UpsellPreset.birthChart:
        return L10nService.get('widgets.premium_upsell.birth_chart_cta', language);
      case _UpsellPreset.transits:
        return L10nService.get('widgets.premium_upsell.transits_cta', language);
      case _UpsellPreset.compatibility:
        return L10nService.get('widgets.premium_upsell.compatibility_cta', language);
      case _UpsellPreset.banner:
        return L10nService.get('widgets.premium_upsell.banner_cta', language);
      case _UpsellPreset.subtle:
        return L10nService.get('widgets.premium_upsell.pro_badge', language);
      case _UpsellPreset.defaultPreset:
        return L10nService.get('widgets.premium_upsell.default_cta', language);
    }
  }

  List<String> _getFeatures(AppLanguage language) {
    if (features != null) return features!;
    switch (_preset) {
      case _UpsellPreset.birthChart:
        return [
          L10nService.get('widgets.premium_upsell.birth_chart_feature_1', language),
          L10nService.get('widgets.premium_upsell.birth_chart_feature_2', language),
          L10nService.get('widgets.premium_upsell.birth_chart_feature_3', language),
          L10nService.get('widgets.premium_upsell.birth_chart_feature_4', language),
        ];
      case _UpsellPreset.transits:
        return [
          L10nService.get('widgets.premium_upsell.transits_feature_1', language),
          L10nService.get('widgets.premium_upsell.transits_feature_2', language),
          L10nService.get('widgets.premium_upsell.transits_feature_3', language),
          L10nService.get('widgets.premium_upsell.transits_feature_4', language),
        ];
      case _UpsellPreset.compatibility:
        return [
          L10nService.get('widgets.premium_upsell.compatibility_feature_1', language),
          L10nService.get('widgets.premium_upsell.compatibility_feature_2', language),
          L10nService.get('widgets.premium_upsell.compatibility_feature_3', language),
          L10nService.get('widgets.premium_upsell.compatibility_feature_4', language),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);

    switch (type) {
      case PremiumUpsellType.banner:
        return _buildBanner(context, language);
      case PremiumUpsellType.card:
        return _buildCard(context, language);
      case PremiumUpsellType.inline:
        return _buildInline(context, language);
      case PremiumUpsellType.subtle:
        return _buildSubtle(context, language);
      case PremiumUpsellType.modal:
        return _buildCard(context, language); // Modal uses same UI, different presentation
    }
  }

  Widget _buildBanner(BuildContext context, AppLanguage language) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = _getTitle(language);
    final description = _getDescription(language);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingLg,
      ),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.auroraStart.withValues(alpha: isDark ? 0.3 : 0.15),
            AppColors.auroraEnd.withValues(alpha: isDark ? 0.2 : 0.1),
            AppColors.starGold.withValues(alpha: isDark ? 0.15 : 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.starGold.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.auroraStart.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.starGold, AppColors.auroraStart],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon ?? Icons.auto_awesome,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.starGold, AppColors.auroraStart],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            L10nService.get('widgets.premium_upsell.premium_badge', language),
                            style: GoogleFonts.raleway(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: GoogleFonts.raleway(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          _buildCtaButton(context, language, compact: false),
        ],
      ),
    ).animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, curve: Curves.easeOut);
  }

  Widget _buildCard(BuildContext context, AppLanguage language) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = _getTitle(language);
    final description = _getDescription(language);
    final featuresList = _getFeatures(language);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingMd,
      ),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.surfaceLight.withValues(alpha: 0.1),
                  AppColors.surfaceDark.withValues(alpha: 0.5),
                ]
              : [
                  AppColors.lightCard,
                  AppColors.lightSurfaceVariant,
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.starGold.withValues(alpha: 0.2)
              : AppColors.lightStarGold.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.starGold.withValues(alpha: 0.15)
                      : AppColors.lightStarGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon ?? Icons.workspace_premium,
                  color: isDark ? AppColors.starGold : AppColors.lightStarGold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.starGold, AppColors.auroraStart],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  L10nService.get('widgets.premium_upsell.pro_badge', language),
                  style: GoogleFonts.raleway(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: GoogleFonts.raleway(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              height: 1.4,
            ),
          ),
          // Features list
          if (featuresList.isNotEmpty) ...[
            const SizedBox(height: 14),
            ...featuresList.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 14,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: GoogleFonts.raleway(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.textSecondary.withValues(alpha: 0.9)
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
          const SizedBox(height: 16),
          _buildCtaButton(context, language, compact: true),
        ],
      ),
    ).animate()
        .fadeIn(duration: 300.ms)
        .scale(begin: const Offset(0.98, 0.98));
  }

  Widget _buildInline(BuildContext context, AppLanguage language) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = _getTitle(language);

    return GestureDetector(
      onTap: onTap ?? () => context.push('/premium'),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingSm,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.starGold.withValues(alpha: 0.1)
              : AppColors.lightStarGold.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark
                ? AppColors.starGold.withValues(alpha: 0.2)
                : AppColors.lightStarGold.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline,
              size: 14,
              color: isDark ? AppColors.starGold : AppColors.lightStarGold,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: GoogleFonts.raleway(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.starGold : AppColors.lightStarGold,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios,
              size: 10,
              color: isDark ? AppColors.starGold : AppColors.lightStarGold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtle(BuildContext context, AppLanguage language) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = _getTitle(language);

    return GestureDetector(
      onTap: onTap ?? () => context.push('/premium'),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.workspace_premium,
            size: 12,
            color: isDark
                ? AppColors.starGold.withValues(alpha: 0.7)
                : AppColors.lightStarGold.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 4),
          Text(
            title,
            style: GoogleFonts.raleway(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.starGold.withValues(alpha: 0.7)
                  : AppColors.lightStarGold.withValues(alpha: 0.8),
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCtaButton(BuildContext context, AppLanguage language, {bool compact = false}) {
    final ctaText = _getCtaText(language);

    return GestureDetector(
      onTap: onTap ?? () => context.push('/premium'),
      child: Container(
        width: compact ? null : double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 20 : 24,
          vertical: compact ? 10 : 14,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.starGold, AppColors.auroraStart],
          ),
          borderRadius: BorderRadius.circular(compact ? 10 : 12),
          boxShadow: [
            BoxShadow(
              color: AppColors.starGold.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: compact ? 16 : 18,
            ),
            const SizedBox(width: 8),
            Text(
              ctaText,
              style: GoogleFonts.raleway(
                fontSize: compact ? 13 : 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _UpsellPreset {
  defaultPreset,
  birthChart,
  transits,
  compatibility,
  subtle,
  banner,
}

/// Show premium upsell modal
Future<void> showPremiumUpsellModal(
  BuildContext context, {
  required AppLanguage language,
  String? title,
  String? description,
  List<String>? features,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.lightBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.textMuted.withValues(alpha: 0.3)
                      : AppColors.lightTextMuted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),
              PremiumUpsell(
                type: PremiumUpsellType.card,
                title: title ?? L10nService.get('widgets.premium_upsell.modal_default_title', language),
                description: description ??
                    L10nService.get('widgets.premium_upsell.modal_default_description', language),
                features: features ??
                    [
                      L10nService.get('widgets.premium_upsell.modal_feature_1', language),
                      L10nService.get('widgets.premium_upsell.modal_feature_2', language),
                      L10nService.get('widgets.premium_upsell.modal_feature_3', language),
                      L10nService.get('widgets.premium_upsell.modal_feature_4', language),
                    ],
                onTap: () {
                  Navigator.pop(context);
                  context.push('/premium');
                },
              ),
              const SizedBox(height: AppConstants.spacingMd),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  L10nService.get('widgets.premium_upsell.not_now', language),
                  style: GoogleFonts.raleway(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
