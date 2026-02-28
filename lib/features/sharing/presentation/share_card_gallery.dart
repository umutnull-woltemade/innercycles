// ============================================================================
// SHARE CARD GALLERY - Browse and share all 21 card templates
// ============================================================================
// Gallery view of all available card templates organized by category.
// Tap a thumbnail to preview the full card with real user data, then
// share via the native share sheet (InstagramShareService).
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/share_card_models.dart';
import '../../../data/content/share_card_templates.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/emotional_cycle_service.dart';
import '../../../data/services/instagram_share_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import 'widgets/share_card_renderer.dart';
import '../../../data/services/l10n_service.dart';

// ============================================================================
// SCREEN
// ============================================================================

class ShareCardGalleryScreen extends ConsumerStatefulWidget {
  const ShareCardGalleryScreen({super.key});

  @override
  ConsumerState<ShareCardGalleryScreen> createState() =>
      _ShareCardGalleryScreenState();
}

class _ShareCardGalleryScreenState
    extends ConsumerState<ShareCardGalleryScreen> {
  ShareCardCategory _selectedCategory = ShareCardCategory.identity;
  ShareCardTemplate? _previewTemplate;
  final GlobalKey _repaintKey = GlobalKey();
  bool _isSharing = false;

  // =========================================================================
  // DATA HELPERS
  // =========================================================================

  ShareCardData _buildDataForTemplate(
    ShareCardTemplate template,
    bool isEn,
    int streak, {
    EmotionalCycleAnalysis? cycleAnalysis,
  }) {
    // Extract cycle position data when available
    String? cyclePhaseName;
    String? cyclePhaseDescription;
    int cycleDay = 0;
    int cycleLength = 0;

    if (cycleAnalysis != null && template.id == 'cycle_position') {
      final phase = cycleAnalysis.overallPhase;
      if (phase != null) {
        cyclePhaseName = isEn ? phase.labelEn() : phase.labelTr();
        cyclePhaseDescription = isEn
            ? phase.descriptionEn()
            : phase.descriptionTr();
      }

      // Find the best cycle length from area summaries
      int? bestCycleLength;
      for (final summary in cycleAnalysis.areaSummaries.values) {
        if (summary.cycleLengthDays != null) {
          bestCycleLength = summary.cycleLengthDays;
          break;
        }
      }
      cycleLength = bestCycleLength ?? 28;

      // Approximate the current day within the cycle
      // Use total entries modulo cycle length as a simple heuristic
      cycleDay = cycleAnalysis.totalEntries > 0
          ? (cycleAnalysis.totalEntries % cycleLength) + 1
          : 1;
    }

    return ShareCardTemplates.buildData(
      template: template,
      isEn: isEn,
      streak: streak,
      cyclePhaseName: cyclePhaseName,
      cyclePhaseDescription: cyclePhaseDescription,
      cycleDay: cycleDay,
      cycleLength: cycleLength,
    );
  }

  // =========================================================================
  // SHARE ACTION
  // =========================================================================

  Future<void> _onShare(bool isEn, AppLanguage language) async {
    // Share cards are now FREE for all users (viral growth strategy).
    // Free users get a "Made with InnerCycles" watermark on their cards.
    // Premium users get clean cards without promotional watermark.
    if (!mounted) return;

    final boundary =
        _repaintKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) return;

    setState(() => _isSharing = true);

    final shareText = L10nService.get('sharing.share_gallery.check_out_my_innercycles_card_innercycle', isEn ? AppLanguage.en : AppLanguage.tr);

    final result = await InstagramShareService.shareCosmicContent(
      boundary: boundary,
      shareText: shareText,
      hashtags: '#InnerCycles #Journaling #SelfAwareness',
      language: language,
    );

    if (!mounted) return;
    setState(() => _isSharing = false);

    if (result.success) {
      _showSnackBar(L10nService.get('sharing.share_gallery.shared_successfully', isEn ? AppLanguage.en : AppLanguage.tr));
    } else if (result.error == ShareError.dismissed) {
      // user cancelled
    } else {
      _showSnackBar(CommonStrings.couldNotShareTryAgain(language));
    }
  }

  Future<void> _onCopy(bool isEn, ShareCardData cardData) async {
    final text =
        '${cardData.headline}\n${cardData.subtitle}'
        '${cardData.detail != null ? '\n${cardData.detail}' : ''}'
        '\n\n- InnerCycles';
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    _showSnackBar(L10nService.get('sharing.share_gallery.copied_to_clipboard', isEn ? AppLanguage.en : AppLanguage.tr));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // =========================================================================
  // BUILD
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final streakAsync = ref.watch(journalStreakProvider);
    final streak = streakAsync.whenOrNull(data: (s) => s) ?? 0;
    final cycleAnalysis = ref
        .watch(emotionalCycleAnalysisProvider)
        .whenOrNull(data: (a) => a);

    return Scaffold(
      backgroundColor: isDark ? AppColors.deepSpace : AppColors.lightBackground,
      // NOTE: Keeping plain AppBar here intentionally. This gallery screen
      // switches between gallery mode (Column with Expanded GridView) and
      // preview mode (SafeArea > Column). Converting to GlassSliverAppBar
      // inside a CustomScrollView would require major restructuring of both
      // layout modes due to the Expanded GridView pattern.
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          L10nService.get('sharing.share_gallery.share_cards', isEn ? AppLanguage.en : AppLanguage.tr),
          style: AppTypography.displayFont.copyWith(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          tooltip: L10nService.get('sharing.share_gallery.back', isEn ? AppLanguage.en : AppLanguage.tr),
          icon: Icon(
            Icons.chevron_left,
            size: 28,
            color: isDark ? AppColors.textMuted : AppColors.lightTextPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: CosmicBackground(
        child: _previewTemplate != null
            ? _buildPreview(isDark, isEn, language, streak, cycleAnalysis)
            : _buildGallery(isDark, isEn, streak, cycleAnalysis),
      ),
    );
  }

  // =========================================================================
  // GALLERY VIEW
  // =========================================================================

  Widget _buildGallery(
    bool isDark,
    bool isEn,
    int streak,
    EmotionalCycleAnalysis? cycleAnalysis,
  ) {
    return Column(
      children: [
        // Category tabs
        _buildCategoryTabs(isDark, isEn),
        const SizedBox(height: 16),

        // Card grid
        Expanded(child: _buildCardGrid(isDark, isEn, streak, cycleAnalysis)),
      ],
    );
  }

  Widget _buildCategoryTabs(bool isDark, bool isEn) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: ShareCardCategory.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = ShareCardCategory.values[index];
          final isSelected = category == _selectedCategory;
          final accent = _categoryAccent(category);

          return Semantics(
            button: true,
            selected: isSelected,
            label: 'Category: ${category.label(isEn)}',
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedCategory = category);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: isSelected
                      ? accent.withValues(alpha: 0.2)
                      : (isDark
                            ? AppColors.surfaceDark
                            : AppColors.lightSurfaceVariant),
                  border: Border.all(
                    color: isSelected
                        ? accent.withValues(alpha: 0.6)
                        : (isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.06)),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category.icon,
                      size: 16,
                      color: isSelected
                          ? accent
                          : (isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      category.label(isEn),
                      style: AppTypography.subtitle(
                        fontSize: 13,
                        color: isSelected
                            ? accent
                            : (isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardGrid(
    bool isDark,
    bool isEn,
    int streak,
    EmotionalCycleAnalysis? cycleAnalysis,
  ) {
    final templates = ShareCardTemplates.byCategory(_selectedCategory);

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        final data = _buildDataForTemplate(
          template,
          isEn,
          streak,
          cycleAnalysis: cycleAnalysis,
        );
        final accent = ShareCardTemplates.accentColor(template);

        return Semantics(
          button: true,
          label: 'Preview ${template.title(isEn)} card',
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() => _previewTemplate = template);
            },
            child:
                _ThumbnailCard(
                      template: template,
                      data: data,
                      accent: accent,
                      isDark: isDark,
                      isEn: isEn,
                    )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: (index * 80).ms)
                    .scale(
                      begin: const Offset(0.92, 0.92),
                      end: const Offset(1.0, 1.0),
                      duration: 400.ms,
                      delay: (index * 80).ms,
                      curve: Curves.easeOutCubic,
                    ),
          ),
        );
      },
    );
  }

  // =========================================================================
  // PREVIEW VIEW
  // =========================================================================

  Widget _buildPreview(
    bool isDark,
    bool isEn,
    AppLanguage language,
    int streak,
    EmotionalCycleAnalysis? cycleAnalysis,
  ) {
    final template = _previewTemplate!;
    final data = _buildDataForTemplate(
      template,
      isEn,
      streak,
      cycleAnalysis: cycleAnalysis,
    );
    final isStory = template.layoutType == ShareCardLayout.cyclePosition;
    final isPremium = ref.watch(premiumProvider).isPremium;

    return SafeArea(
      child: Column(
        children: [
          // Back to gallery
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => setState(() => _previewTemplate = null),
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                size: 16,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
              label: Text(
                L10nService.get('sharing.share_gallery.back_to_gallery', isEn ? AppLanguage.en : AppLanguage.tr),
                style: AppTypography.subtitle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
          ),

          // Card preview
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child:
                    ShareCardRenderer(
                          template: template,
                          data: data,
                          repaintKey: _repaintKey,
                          isDark: isDark,
                          isPremium: isPremium,
                          isEn: isEn,
                          displaySize: isStory ? 220 : 360,
                        )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .scale(
                          begin: const Offset(0.95, 0.95),
                          end: const Offset(1.0, 1.0),
                          duration: 400.ms,
                          curve: Curves.easeOutCubic,
                        ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Action buttons
          _buildActionButtons(isDark, isEn, language, data),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    bool isDark,
    bool isEn,
    AppLanguage language,
    ShareCardData cardData,
  ) {
    final accent = _previewTemplate != null
        ? ShareCardTemplates.accentColor(_previewTemplate!)
        : AppColors.auroraStart;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Share (primary)
          Expanded(
            flex: 2,
            child: _ActionButton(
              icon: Icons.share_rounded,
              label: L10nService.get('sharing.share_gallery.share', isEn ? AppLanguage.en : AppLanguage.tr),
              isPrimary: true,
              isLoading: _isSharing,
              accentColor: accent,
              isDark: isDark,
              onTap: () => _onShare(isEn, language),
            ),
          ),
          const SizedBox(width: 12),

          // Copy
          Expanded(
            child: _ActionButton(
              icon: Icons.copy_rounded,
              label: L10nService.get('sharing.share_gallery.copy', isEn ? AppLanguage.en : AppLanguage.tr),
              isDark: isDark,
              onTap: () => _onCopy(isEn, cardData),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // HELPERS
  // =========================================================================

  Color _categoryAccent(ShareCardCategory category) {
    switch (category) {
      case ShareCardCategory.identity:
        return AppColors.amethyst;
      case ShareCardCategory.pattern:
        return AppColors.sunriseStart;
      case ShareCardCategory.achievement:
        return AppColors.starGold;
      case ShareCardCategory.wisdom:
        return AppColors.auroraStart;
      case ShareCardCategory.reflection:
        return AppColors.sunriseEnd;
    }
  }
}

// ============================================================================
// THUMBNAIL CARD (Gallery Grid Item)
// ============================================================================

class _ThumbnailCard extends StatelessWidget {
  final ShareCardTemplate template;
  final ShareCardData data;
  final Color accent;
  final bool isDark;
  final bool isEn;

  const _ThumbnailCard({
    required this.template,
    required this.data,
    required this.accent,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? template.gradientColors
              : template.gradientColors.map((c) {
                  final hsl = HSLColor.fromColor(c);
                  return hsl
                      .withLightness((hsl.lightness + 0.5).clamp(0.0, 0.92))
                      .withSaturation((hsl.saturation * 0.4).clamp(0.0, 1.0))
                      .toColor();
                }).toList(),
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Badge
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: accent.withValues(alpha: 0.2),
                border: Border.all(color: accent.withValues(alpha: 0.4)),
              ),
              child: Text(
                template.badge(isEn),
                style: AppTypography.elegantAccent(
                  fontSize: 10,
                  color: accent,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // Center content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(template.icon, color: accent, size: 32),
                  const SizedBox(height: 10),
                  Text(
                    template.title(isEn),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.displayFont.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    template.category.label(isEn),
                    style: AppTypography.elegantAccent(
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// ACTION BUTTON
// ============================================================================

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final bool isLoading;
  final Color accentColor;
  final bool isDark;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.isPrimary = false,
    this.isLoading = false,
    this.accentColor = AppColors.auroraStart,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: isLoading
            ? null
            : () {
                HapticFeedback.mediumImpact();
                onTap();
              },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: isPrimary
                ? LinearGradient(
                    colors: [accentColor, accentColor.withValues(alpha: 0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isPrimary
                ? null
                : (isDark
                      ? AppColors.surfaceDark
                      : AppColors.lightSurfaceVariant),
            border: isPrimary
                ? null
                : Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.15)
                        : Colors.black.withValues(alpha: 0.08),
                  ),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const CosmicLoadingIndicator(size: 18)
              else
                Icon(
                  icon,
                  size: 18,
                  color: isPrimary
                      ? Colors.white
                      : (isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary),
                ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTypography.subtitle(
                  fontSize: 14,
                  color: isPrimary
                      ? Colors.white
                      : (isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
