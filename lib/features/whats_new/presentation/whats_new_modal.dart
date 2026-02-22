// ============================================================================
// WHAT'S NEW MODAL - Shows feature highlights on first launch after update
// ============================================================================
// Triggered via WhatsNewModal.showIfNeeded(context, isEn) after app loads.
// Compares current app version against SharedPreferences 'last_seen_version'.
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_colors.dart';

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
      emoji: '\u{1F30A}', // wave
      titleEn: 'Emotional Cycle Detection',
      titleTr: 'Duygusal D\u00f6ng\u00fc Tespiti',
      descEn: 'Discover recurring emotional patterns across your journal entries.',
      descTr:
          'G\u00fcnl\u00fck kay\u0131tlar\u0131n\u0131zda tekrarlayan duygusal kal\u0131plar\u0131 ke\u015ffedin.',
    ),
    _FeatureItem(
      emoji: '\u{1F4AD}', // thought bubble
      titleEn: 'Dream Symbol Tracking',
      titleTr: 'R\u00fcya Sembol\u00fc Takibi',
      descEn: 'Log dream symbols and see how they connect to your daily mood.',
      descTr:
          'R\u00fcya sembollerini kaydedin ve g\u00fcnl\u00fck ruh halinizle ba\u011flant\u0131lar\u0131n\u0131 g\u00f6r\u00fcn.',
    ),
    _FeatureItem(
      emoji: '\u{1F4CA}', // bar chart
      titleEn: 'Weekly Digest Reports',
      titleTr: 'Haftal\u0131k \u00d6zet Raporlar\u0131',
      descEn:
          'Get a concise weekly summary of your emotional trends and insights.',
      descTr:
          'Duygusal e\u011filimlerinizin ve i\u00e7g\u00f6r\u00fclerinizin k\u0131sa haftal\u0131k \u00f6zetini al\u0131n.',
    ),
    _FeatureItem(
      emoji: '\u{1F91D}', // handshake
      titleEn: 'Partner Sync',
      titleTr: 'Partner Senkronizasyonu',
      descEn:
          'Share cycle insights with a partner for deeper mutual understanding.',
      descTr:
          'Daha derin kar\u015f\u0131l\u0131kl\u0131 anlay\u0131\u015f i\u00e7in d\u00f6ng\u00fc bilgilerinizi partnerinizle payla\u015f\u0131n.',
    ),
    _FeatureItem(
      emoji: '\u{1F3C6}', // trophy
      titleEn: 'Milestones & Achievements',
      titleTr: 'Kilometre Ta\u015flar\u0131 ve Ba\u015far\u0131lar',
      descEn:
          'Celebrate journaling streaks, insights unlocked, and personal growth.',
      descTr:
          'G\u00fcnl\u00fck serilerinizi, a\u00e7\u0131lan i\u00e7g\u00f6r\u00fclerinizi ve ki\u015fisel geli\u015fiminizi kutlay\u0131n.',
    ),
    _FeatureItem(
      emoji: '\u{270D}\u{FE0F}', // writing hand
      titleEn: 'Daily Journaling Prompts',
      titleTr: 'G\u00fcnl\u00fck Yazma \u0130pu\u00e7lar\u0131',
      descEn:
          'Thoughtful prompts tailored to your emotional patterns each day.',
      descTr:
          'Her g\u00fcn duygusal kal\u0131plar\u0131n\u0131za \u00f6zel d\u00fc\u015f\u00fcnd\u00fcr\u00fcc\u00fc sorular.',
    ),
  ];

  // -------------------------------------------------------------------------
  // Public API
  // -------------------------------------------------------------------------

  /// Check if the modal should be shown and display it if needed.
  /// Call this after the app is fully loaded and the navigator context is valid.
  static Future<void> showIfNeeded(BuildContext context, bool isEn) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSeen = prefs.getString(_prefKey);

      final info = await PackageInfo.fromPlatform();
      final currentVersion = info.version; // e.g. "1.0.0"

      if (lastSeen == currentVersion) return; // already seen

      if (!context.mounted) return;

      await _show(context, isEn);

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

  static Future<void> _show(BuildContext context, bool isEn) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _WhatsNewSheet(isEn: isEn, isDark: isDark);
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Sheet content (StatelessWidget for clean separation)
// ---------------------------------------------------------------------------

class _WhatsNewSheet extends StatelessWidget {
  final bool isEn;
  final bool isDark;

  const _WhatsNewSheet({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? AppColors.surfaceDark : AppColors.lightSurface;
    final textColor =
        isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
    final subtextColor =
        isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;
    final mutedColor = isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
              color: mutedColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // ---- Header ----
          Text(
            isEn ? "What's New" : 'Yenilikler',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: -0.2, duration: 400.ms, curve: Curves.easeOut),
          const SizedBox(height: 4),
          Text(
            isEn ? 'Latest features and improvements' : 'Son \u00f6zellikler ve iyile\u015ftirmeler',
            style: TextStyle(fontSize: 14, color: subtextColor),
          )
              .animate()
              .fadeIn(delay: 100.ms, duration: 400.ms),
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
                  title: isEn ? f.titleEn : f.titleTr,
                  description: isEn ? f.descEn : f.descTr,
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
            child: SizedBox(
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
                    isEn ? 'Got it' : 'Anla\u015f\u0131ld\u0131',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
              color: AppColors.cosmicPurple.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: TextStyle(fontSize: 13, color: subtextColor, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: delay, duration: 350.ms)
        .slideX(begin: 0.05, delay: delay, duration: 350.ms, curve: Curves.easeOut);
  }
}
