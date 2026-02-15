// ============================================================================
// SHARE CARD GALLERY - Browse and share all 20 card templates
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
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/share_card_models.dart';
import '../../../data/content/share_card_templates.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/instagram_share_service.dart';
import 'widgets/share_card_renderer.dart';

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

  ShareCardData _buildDataForTemplate(ShareCardTemplate template, bool isEn,
      int streak) {
    return ShareCardTemplates.buildData(
      template: template,
      isEn: isEn,
      streak: streak,
    );
  }

  // =========================================================================
  // SHARE ACTION
  // =========================================================================

  Future<void> _onShare(bool isEn, AppLanguage language) async {
    final boundary = _repaintKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) return;

    setState(() => _isSharing = true);

    final shareText = isEn
        ? 'Check out my InnerCycles card! #InnerCycles #SelfGrowth'
        : 'InnerCycles kartımı keşfet! #InnerCycles #KendiniFarkEt';

    final result = await InstagramShareService.shareCosmicContent(
      boundary: boundary,
      shareText: shareText,
      hashtags: '#InnerCycles #Journaling #SelfAwareness',
      language: language,
    );

    setState(() => _isSharing = false);
    if (!mounted) return;

    if (result.success) {
      _showSnackBar(isEn ? 'Shared successfully!' : 'Başarıyla paylaşıldı!');
    } else if (result.error == ShareError.dismissed) {
      // user cancelled
    } else {
      _showSnackBar(
        isEn ? 'Could not share. Try again.' : 'Paylaşılamadı. Tekrar dene.',
      );
    }
  }

  Future<void> _onCopy(bool isEn, ShareCardData cardData) async {
    final text = '${cardData.headline}\n${cardData.subtitle}'
        '${cardData.detail != null ? '\n${cardData.detail}' : ''}'
        '\n\n- InnerCycles';
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    _showSnackBar(isEn ? 'Copied to clipboard' : 'Panoya kopyalandi');
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

    return Scaffold(
      backgroundColor: isDark ? AppColors.deepSpace : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          isEn ? 'Share Cards' : 'Paylasim Kartlari',
          style: GoogleFonts.plusJakartaSans(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 28,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _previewTemplate != null
          ? _buildPreview(isDark, isEn, language, streak)
          : _buildGallery(isDark, isEn, streak),
    );
  }

  // =========================================================================
  // GALLERY VIEW
  // =========================================================================

  Widget _buildGallery(bool isDark, bool isEn, int streak) {
    return Column(
      children: [
        // Category tabs
        _buildCategoryTabs(isDark, isEn),
        const SizedBox(height: 16),

        // Card grid
        Expanded(
          child: _buildCardGrid(isDark, isEn, streak),
        ),
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

          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
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
          );
        },
      ),
    );
  }

  Widget _buildCardGrid(bool isDark, bool isEn, int streak) {
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
        final data = _buildDataForTemplate(template, isEn, streak);
        final accent = ShareCardTemplates.accentColor(template);

        return GestureDetector(
          onTap: () => setState(() => _previewTemplate = template),
          child: _ThumbnailCard(
            template: template,
            data: data,
            accent: accent,
            isDark: isDark,
            isEn: isEn,
          )
              .animate()
              .fadeIn(
                duration: 400.ms,
                delay: (index * 80).ms,
              )
              .scale(
                begin: const Offset(0.92, 0.92),
                end: const Offset(1.0, 1.0),
                duration: 400.ms,
                delay: (index * 80).ms,
                curve: Curves.easeOutCubic,
              ),
        );
      },
    );
  }

  // =========================================================================
  // PREVIEW VIEW
  // =========================================================================

  Widget _buildPreview(
      bool isDark, bool isEn, AppLanguage language, int streak) {
    final template = _previewTemplate!;
    final data = _buildDataForTemplate(template, isEn, streak);

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
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              ),
              label: Text(
                isEn ? 'Back to gallery' : 'Galeriye don',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ),
          ),

          // Card preview
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ShareCardRenderer(
                  template: template,
                  data: data,
                  repaintKey: _repaintKey,
                  isDark: isDark,
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
              label: isEn ? 'Share' : 'Paylas',
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
              label: isEn ? 'Copy' : 'Kopyala',
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
                      .withLightness(
                          (hsl.lightness + 0.5).clamp(0.0, 0.92))
                      .withSaturation(
                          (hsl.saturation * 0.4).clamp(0.0, 1.0))
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
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
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
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    template.category.label(isEn),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
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
    return GestureDetector(
      onTap: isLoading ? null : onTap,
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
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isPrimary ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              )
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
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: isPrimary ? FontWeight.w700 : FontWeight.w500,
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
    );
  }
}
