import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/affirmation_service.dart';
import '../../../data/services/haptic_service.dart';
import '../../../data/services/smart_router_service.dart';
import '../../../data/services/ecosystem_analytics_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';
import '../../../data/services/l10n_service.dart';

class AffirmationLibraryScreen extends ConsumerStatefulWidget {
  const AffirmationLibraryScreen({super.key});

  @override
  ConsumerState<AffirmationLibraryScreen> createState() =>
      _AffirmationLibraryScreenState();
}

class _AffirmationLibraryScreenState
    extends ConsumerState<AffirmationLibraryScreen> {
  AffirmationCategory? _selectedCategory;
  bool _showFavoritesOnly = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(smartRouterServiceProvider)
          .whenData((s) => s.recordToolVisit('affirmations'));
      ref
          .read(ecosystemAnalyticsServiceProvider)
          .whenData((s) => s.trackToolOpen('affirmations', source: 'direct'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(affirmationServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: serviceAsync.when(
          loading: () => const CosmicLoadingIndicator(),
          error: (_, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    CommonStrings.somethingWentWrong(language),
                    textAlign: TextAlign.center,
                    style: AppTypography.decorativeScript(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () =>
                        ref.invalidate(affirmationServiceProvider),
                    icon: Icon(
                      Icons.refresh_rounded,
                      size: 16,
                      color: AppColors.starGold,
                    ),
                    label: Text(
                      L10nService.get('affirmation.affirmation_library.retry', isEn ? AppLanguage.en : AppLanguage.tr),
                      style: AppTypography.elegantAccent(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.starGold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          data: (service) => _buildContent(context, service, isDark, isEn),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AffirmationService service,
    bool isDark,
    bool isEn,
  ) {
    // Get filtered affirmations
    List<Affirmation> affirmations;
    if (_showFavoritesOnly) {
      affirmations = service.getFavorites();
    } else if (_selectedCategory != null) {
      affirmations = service.getAllByCategory(_selectedCategory!);
    } else {
      affirmations = AffirmationCategory.values
          .expand((c) => service.getAllByCategory(c))
          .toList();
    }

    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(title: L10nService.get('affirmation.affirmation_library.affirmations', isEn ? AppLanguage.en : AppLanguage.tr)),
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Today's affirmation hero
                _buildTodayHero(service, isDark, isEn),
                const SizedBox(height: AppConstants.spacingLg),

                // Filter chips
                _buildFilterChips(service, isDark, isEn),
                const SizedBox(height: AppConstants.spacingLg),

                // Affirmation list
                ...affirmations.map(
                  (a) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppConstants.spacingSm,
                    ),
                    child: _AffirmationTile(
                      affirmation: a,
                      isFavorite: service.isFavorite(a.id),
                      isDark: isDark,
                      isEn: isEn,
                      onToggleFavorite: () async {
                        await service.toggleFavorite(a.id);
                        if (!mounted) return;
                        setState(() {});
                      },
                    ),
                  ),
                ),

                if (affirmations.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(AppConstants.spacingXl),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border_rounded,
                            size: 48,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            L10nService.get('affirmation.affirmation_library.no_favorites_yet', isEn ? AppLanguage.en : AppLanguage.tr),
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ToolEcosystemFooter(
                  currentToolId: 'affirmations',
                  isEn: isEn,
                  isDark: isDark,
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, duration: 400.ms);
  }

  Widget _buildTodayHero(AffirmationService service, bool isDark, bool isEn) {
    final today = service.getDailyAffirmation();

    return GlassPanel(
      elevation: GlassElevation.g3,
      glowColor: AppColors.starGold.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      child: Column(
        children: [
          Icon(Icons.auto_awesome, size: 28, color: AppColors.starGold),
          const SizedBox(height: AppConstants.spacingMd),
          GradientText(
            isEn ? "Today's Affirmation" : 'Günün Olumlaması',
            variant: GradientTextVariant.gold,
            style: AppTypography.elegantAccent(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          GradientText(
            isEn ? today.textEn : today.textTr,
            variant: GradientTextVariant.amethyst,
            textAlign: TextAlign.center,
            style: AppTypography.displayFont.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.starGold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            ),
            child: Text(
              today.category.localizedName(isEn),
              style: AppTypography.elegantAccent(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.starGold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(AffirmationService service, bool isDark, bool isEn) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          // All chip
          _FilterChip(
            label: L10nService.get('affirmation.affirmation_library.all', isEn ? AppLanguage.en : AppLanguage.tr),
            isSelected: _selectedCategory == null && !_showFavoritesOnly,
            isDark: isDark,
            isEn: isEn,
            onTap: () => setState(() {
              _selectedCategory = null;
              _showFavoritesOnly = false;
            }),
          ),
          const SizedBox(width: 8),

          // Favorites chip
          _FilterChip(
            label: L10nService.get('affirmation.affirmation_library.favorites', isEn ? AppLanguage.en : AppLanguage.tr),
            isSelected: _showFavoritesOnly,
            isDark: isDark,
            isEn: isEn,
            icon: Icons.favorite,
            onTap: () => setState(() {
              _showFavoritesOnly = !_showFavoritesOnly;
              if (_showFavoritesOnly) _selectedCategory = null;
            }),
          ),
          const SizedBox(width: 8),

          // Category chips
          ...AffirmationCategory.values.map(
            (cat) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _FilterChip(
                label: cat.localizedName(isEn),
                isSelected: _selectedCategory == cat && !_showFavoritesOnly,
                isDark: isDark,
                isEn: isEn,
                onTap: () => setState(() {
                  _selectedCategory = cat;
                  _showFavoritesOnly = false;
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final bool isEn;
  final IconData? icon;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.isEn,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: L10nService.getWithParams('affirmation.library.filter_label', isEn ? AppLanguage.en : AppLanguage.tr, params: {'label': label}),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.starGold.withValues(alpha: 0.2)
                : (isDark
                      ? AppColors.surfaceLight.withValues(alpha: 0.1)
                      : AppColors.lightSurfaceVariant),
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            border: Border.all(
              color: isSelected
                  ? AppColors.starGold
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.05)),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: isSelected
                      ? AppColors.starGold
                      : (isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted),
                ),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: AppTypography.elegantAccent(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.starGold
                      : (isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AffirmationTile extends StatelessWidget {
  final Affirmation affirmation;
  final bool isFavorite;
  final bool isDark;
  final bool isEn;
  final VoidCallback onToggleFavorite;

  const _AffirmationTile({
    required this.affirmation,
    required this.isFavorite,
    required this.isDark,
    required this.isEn,
    required this.onToggleFavorite,
  });

  IconData _getIconForCategory(AffirmationCategory category) {
    switch (category) {
      case AffirmationCategory.selfWorth:
        return Icons.star_outline;
      case AffirmationCategory.growth:
        return Icons.eco_outlined;
      case AffirmationCategory.resilience:
        return Icons.shield_outlined;
      case AffirmationCategory.connection:
        return Icons.favorite_border;
      case AffirmationCategory.calm:
        return Icons.spa_outlined;
      case AffirmationCategory.purpose:
        return Icons.explore_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        final text = isEn ? affirmation.textEn : affirmation.textTr;
        Clipboard.setData(ClipboardData(text: text));
        HapticService.buttonPress();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(L10nService.get('affirmation.affirmation_library.affirmation_copied', isEn ? AppLanguage.en : AppLanguage.tr)),
            duration: const Duration(seconds: 1),
            backgroundColor: AppColors.success,
          ),
        );
      },
      child: GlassPanel(
      elevation: GlassElevation.g2,
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _getIconForCategory(affirmation.category),
            size: 20,
            color: AppColors.auroraStart,
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEn ? affirmation.textEn : affirmation.textTr,
                  style: AppTypography.decorativeScript(
                    fontSize: 15,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  affirmation.category.localizedName(isEn),
                  style: AppTypography.elegantAccent(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Semantics(
            button: true,
            label: isFavorite
                ? (L10nService.get('affirmation.affirmation_library.remove_from_favorites', isEn ? AppLanguage.en : AppLanguage.tr))
                : (L10nService.get('affirmation.affirmation_library.add_to_favorites', isEn ? AppLanguage.en : AppLanguage.tr)),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onToggleFavorite,
              child: SizedBox(
                width: 44,
                height: 44,
                child: Center(
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: isFavorite
                        ? AppColors.starGold
                        : (isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
