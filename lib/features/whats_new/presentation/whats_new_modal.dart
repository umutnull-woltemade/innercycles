// ============================================================================
// WHAT'S NEW MODAL - Shows feature highlights on first launch after update
// ============================================================================
// Triggered via WhatsNewModal.showIfNeeded(context, language) after app loads.
// Compares current app version against SharedPreferences 'last_seen_version'.
// ============================================================================

import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../data/services/l10n_service.dart';
import '../../../data/providers/app_providers.dart';

// ---------------------------------------------------------------------------
// Data model for a single feature highlight
// ---------------------------------------------------------------------------

class _FeatureItem {
  final String emoji;
  final String titleEn;
  final String titleTr;
  final String descEn;
  final String descTr;

  const _FeatureItem({
    required this.emoji,
    required this.titleEn,
    required this.titleTr,
    required this.descEn,
    required this.descTr,
  });

  String localizedTitle(AppLanguage language) =>
      language == AppLanguage.en ? titleEn : titleTr;
  String localizedDesc(AppLanguage language) =>
      language == AppLanguage.en ? descEn : descTr;
}

// ---------------------------------------------------------------------------
// What's New Modal
// ---------------------------------------------------------------------------

class WhatsNewModal {
  WhatsNewModal._();

  static const String _prefKey = 'last_seen_version';

  /// Feature list for the current release
  static const List<_FeatureItem> _features = [
    _FeatureItem(
      emoji: '\u{1F512}', // lock
      titleEn: 'Private Vault',
      titleTr: 'Gizli Kasa',
      descEn:
          'Protect your most personal entries with PIN and biometric lock.',
      descTr:
          'En \u00f6zel giri\u015flerini PIN ve biyometrik kilitle koru.',
    ),
    _FeatureItem(
      emoji: '\u{1F382}', // birthday cake
      titleEn: 'Birthday Agenda',
      titleTr: 'Do\u011fum G\u00fcn\u00fc Ajandas\u0131',
      descEn:
          'Never miss a birthday. Import from contacts or add manually.',
      descTr:
          'Hi\u00e7bir do\u011fum g\u00fcn\u00fcn\u00fc ka\u00e7\u0131rma. Rehberden aktar veya elle ekle.',
    ),
    _FeatureItem(
      emoji: '\u{1F3A8}', // palette
      titleEn: 'Share Cards',
      titleTr: 'Payla\u015f\u0131m Kartlar\u0131',
      descEn:
          'Beautiful shareable cards for your mood trends, streaks, and milestones.',
      descTr:
          'Ruh hali e\u011filimlerin, serilerin ve kilometre ta\u015flar\u0131n i\u00e7in g\u00f6rsel kartlar.',
    ),
    _FeatureItem(
      emoji: '\u{1F331}', // seedling
      titleEn: 'Gratitude & Sleep Tracking',
      titleTr: '\u015e\u00fck\u00fcr ve Uyku Takibi',
      descEn:
          'Log gratitude moments and sleep quality alongside your journal.',
      descTr:
          'G\u00fcnl\u00fc\u011f\u00fcnle birlikte \u015f\u00fck\u00fcr anlar\u0131n\u0131 ve uyku kaliteni kaydet.',
    ),
    _FeatureItem(
      emoji: '\u{1F3AF}', // dart
      titleEn: 'Daily Focus Widget',
      titleTr: 'G\u00fcnl\u00fck Odak Widget\u0131',
      descEn:
          'See your daily focus and emotional rhythm right on your home screen.',
      descTr:
          'G\u00fcnl\u00fck oda\u011f\u0131n\u0131 ve duygusal ritmini ana ekran\u0131nda g\u00f6r.',
    ),
    _FeatureItem(
      emoji: '\u{1F381}', // gift
      titleEn: 'Invite Friends, Earn Premium',
      titleTr: 'Arkada\u015flar\u0131n\u0131 Davet Et, Premium Kazan',
      descEn:
          'Share your referral code and both you and your friend get free Premium.',
      descTr:
          'Davet kodunu payla\u015f, hem sen hem arkada\u015f\u0131n \u00fccretsiz Premium kazan\u0131n.',
    ),
  ];

  // -------------------------------------------------------------------------
  // Public API
  // -------------------------------------------------------------------------

  /// Check if the modal should be shown and display it if needed.
  /// Call this after the app is fully loaded and the navigator context is valid.
  static Future<void> showIfNeeded(BuildContext context, AppLanguage language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSeen = prefs.getString(_prefKey);

      final info = await PackageInfo.fromPlatform();
      final currentVersion = info.version; // e.g. "1.0.0"

      if (lastSeen == currentVersion) return; // already seen

      if (!context.mounted) return;

      await _show(context, language);

      // Persist after dismissal
      await prefs.setString(_prefKey, currentVersion);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('\u26a0\ufe0f WhatsNewModal.showIfNeeded error: $e');
      }
    }
  }

  // -------------------------------------------------------------------------
  // Modal presentation
  // -------------------------------------------------------------------------

  static Future<void> _show(BuildContext context, AppLanguage language) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _WhatsNewSheet(language: language, isDark: isDark);
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Sheet content (StatelessWidget for clean separation)
// ---------------------------------------------------------------------------

class _WhatsNewSheet extends StatelessWidget {
  final AppLanguage language;
  final bool isDark;

  const _WhatsNewSheet({required this.language, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? AppColors.surfaceDark : AppColors.lightSurface;
    final textColor = isDark
        ? AppColors.textPrimary
        : AppColors.lightTextPrimary;
    final subtextColor = isDark
        ? AppColors.textSecondary
        : AppColors.lightTextSecondary;
    final mutedColor = isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: bgColor.withValues(alpha: isDark ? 0.85 : 0.92),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(
                color: AppColors.auroraStart.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ---- Drag handle ----
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.auroraStart.withValues(alpha: 0.6),
                      AppColors.auroraEnd.withValues(alpha: 0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // ---- Header ----
              GradientText(
                    L10nService.get('whats_new.title', language),
                    variant: GradientTextVariant.aurora,
                    style: AppTypography.displayFont.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: -0.2, duration: 400.ms, curve: Curves.easeOut),
              const SizedBox(height: 4),
              Text(
                L10nService.get('whats_new.whats_new.latest_features_and_improvements', language),
                style: AppTypography.decorativeScript(
                  fontSize: 14,
                  color: subtextColor,
                ),
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
              const SizedBox(height: 20),

              // ---- Feature list ----
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: WhatsNewModal._features.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: mutedColor.withValues(alpha: 0.15),
                  ),
                  itemBuilder: (_, index) {
                    final f = WhatsNewModal._features[index];
                    return _FeatureTile(
                      emoji: f.emoji,
                      title: f.localizedTitle(language),
                      description: f.localizedDesc(language),
                      textColor: textColor,
                      subtextColor: subtextColor,
                      delay: Duration(milliseconds: 150 + index * 80),
                    );
                  },
                ),
              ),

              // ---- "Got it" button ----
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child:
                    SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                L10nService.get('whats_new.whats_new.got_it', language),
                                style: AppTypography.subtitle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 500.ms, duration: 400.ms)
                        .slideY(
                          begin: 0.15,
                          delay: 500.ms,
                          duration: 400.ms,
                          curve: Curves.easeOut,
                        ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Individual feature row
// ---------------------------------------------------------------------------

class _FeatureTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final Color textColor;
  final Color subtextColor;
  final Duration delay;

  const _FeatureTile({
    required this.emoji,
    required this.title,
    required this.description,
    required this.textColor,
    required this.subtextColor,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emoji circle
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.auroraStart.withValues(alpha: 0.15),
                      AppColors.auroraEnd.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: AppSymbol(emoji, size: AppSymbolSize.sm),
              ),
              const SizedBox(width: 14),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: AppTypography.decorativeScript(
                        fontSize: 13,
                        color: subtextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: delay, duration: 350.ms)
        .slideX(
          begin: 0.05,
          delay: delay,
          duration: 350.ms,
          curve: Curves.easeOut,
        );
  }
}
