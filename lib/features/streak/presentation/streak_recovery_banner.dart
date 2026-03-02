// ════════════════════════════════════════════════════════════════════════════
// STREAK RECOVERY BANNER - Structured comeback flow after streak break
// ════════════════════════════════════════════════════════════════════════════
// Shows days-away context, motivational messaging, past stats, and
// personalized quick-start actions to re-engage returning users.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/premium_service.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';
import '../../../data/services/l10n_service.dart';

class StreakRecoveryBanner extends ConsumerWidget {
  const StreakRecoveryBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final streakAsync = ref.watch(streakStatsProvider);
    final journalAsync = ref.watch(journalServiceProvider);
    final isPremium = ref.watch(isPremiumUserProvider);

    return streakAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (stats) {
        final currentStreak = stats.currentStreak;
        final longestStreak = stats.longestStreak;

        if (currentStreak > 0 || longestStreak < 3) {
          return const SizedBox.shrink();
        }

        // Calculate days since last entry
        int daysAway = 0;
        int totalEntries = stats.totalEntries;
        final service = journalAsync.valueOrNull;
        if (service != null) {
          final recent = service.getRecentEntries(1);
          if (recent.isNotEmpty) {
            daysAway = DateTime.now().difference(recent.first.date).inDays;
          }
        }

        // Contextual messaging based on days away
        final (emoji, title, subtitle) = _getCombackMessage(
          daysAway: daysAway,
          longestStreak: longestStreak,
          totalEntries: totalEntries,
          isEn: isEn,
        );

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main comeback card
            Semantics(
              label: L10nService.get('streak.streak_recovery.start_a_new_streak', language),
              button: true,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.go(Routes.journal);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              AppColors.warning.withValues(alpha: 0.15),
                              AppColors.surfaceDark.withValues(alpha: 0.9),
                            ]
                          : [
                              AppColors.warning.withValues(alpha: 0.08),
                              AppColors.lightCard,
                            ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.warning.withValues(alpha: 0.2),
                            ),
                            child: Center(
                              child: AppSymbol(emoji, size: AppSymbolSize.sm),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: AppTypography.displayFont.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.textPrimary
                                        : AppColors.lightTextPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  subtitle,
                                  style: AppTypography.decorativeScript(
                                    fontSize: 12,
                                    color: AppColors.warning,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: AppColors.warning.withValues(alpha: 0.7),
                          ),
                        ],
                      ),
                      // Past stats reminder (only if meaningful history)
                      if (totalEntries >= 5) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: (isDark ? Colors.white : Colors.black)
                                .withValues(alpha: 0.04),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _StatChip(
                                value: '$longestStreak',
                                label: isEn ? 'best streak' : 'en iyi seri',
                                isDark: isDark,
                              ),
                              Container(
                                width: 1,
                                height: 24,
                                color: (isDark ? Colors.white : Colors.black)
                                    .withValues(alpha: 0.08),
                              ),
                              _StatChip(
                                value: '$totalEntries',
                                label: isEn ? 'entries' : 'kayıt',
                                isDark: isDark,
                              ),
                              Container(
                                width: 1,
                                height: 24,
                                color: (isDark ? Colors.white : Colors.black)
                                    .withValues(alpha: 0.08),
                              ),
                              _StatChip(
                                value: daysAway > 0 ? '$daysAway' : '—',
                                label: isEn ? 'days away' : 'gün uzakta',
                                isDark: isDark,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1, end: 0),

            // Streak freeze upsell for non-premium users
            if (!isPremium)
              Semantics(
                label: L10nService.get('streak.streak_recovery.access_streak_freeze', language),
                button: true,
                child: GestureDetector(
                  onTap: () => showContextualPaywall(
                    context,
                    ref,
                    paywallContext: PaywallContext.streakFreeze,
                    streakDays: longestStreak,
                    bypassTimingGate: true,
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.streakOrange.withValues(alpha: 0.08)
                          : AppColors.streakOrange.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.streakOrange.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.ac_unit_rounded,
                          size: 18,
                          color: AppColors.streakOrange,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            L10nService.get('streak.streak_recovery.premium_streak_freezes_could_have_saved', language),
                            style: AppTypography.decorativeScript(
                              fontSize: 12,
                              color: AppColors.streakOrange,
                            ),
                          ),
                        ),
                        Text(
                          L10nService.get('streak.streak_recovery.learn_more', language),
                          style: AppTypography.elegantAccent(
                            fontSize: 11,
                            color: AppColors.streakOrange.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 150.ms),
          ],
        );
      },
    );
  }

  /// Returns (emoji, title, subtitle) based on days away and history
  static (String, String, String) _getCombackMessage({
    required int daysAway,
    required int longestStreak,
    required int totalEntries,
    required bool isEn,
  }) {
    // 1-2 days: gentle nudge
    if (daysAway <= 2) {
      return (
        '🔥',
        isEn
            ? 'Your $longestStreak-day streak ended'
            : '$longestStreak günlük seri sona erdi',
        isEn
            ? 'One entry to start a new one'
            : 'Yeni bir tane başlatmak için bir kayıt yeter',
      );
    }

    // 3-7 days: warm welcome back
    if (daysAway <= 7) {
      return (
        '👋',
        isEn ? 'Welcome back' : 'Tekrar hoş geldin',
        isEn
            ? 'Your journal misses you — pick up where you left off'
            : 'Günlüğün seni özledi — kaldığın yerden devam et',
      );
    }

    // 8-30 days: motivational
    if (daysAway <= 30) {
      return (
        '✨',
        isEn
            ? 'It\'s been $daysAway days'
            : '$daysAway gün olmuş',
        isEn
            ? 'Your $totalEntries entries are waiting — you\'ve done this before'
            : '$totalEntries kaydın bekliyor — bunu daha önce yaptın',
      );
    }

    // 30+ days: fresh start energy
    return (
      '🌱',
      isEn ? 'Ready for a fresh start?' : 'Yeni bir başlangıca hazır mısın?',
      isEn
          ? 'Every great streak starts with day one'
          : 'Her büyük seri ilk günle başlar',
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  final bool isDark;

  const _StatChip({
    required this.value,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.displayFont.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.warning,
          ),
        ),
        Text(
          label,
          style: AppTypography.subtitle(
            fontSize: 10,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}
