import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/haptic_service.dart';

/// Shows progressive unlock progress on the home screen.
///
/// Displays "X more entries unlock [Feature]" with animated progress bar.
/// Disappears when all features are unlocked.
class UnlockProgressBanner extends ConsumerWidget {
  const UnlockProgressBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlockAsync = ref.watch(progressiveUnlockServiceProvider);
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return unlockAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (unlock) {
        final next = unlock.nextUnlock;
        if (next == null) return const SizedBox.shrink();

        final featureNames = _getFeatureNames(isEn);
        final featureName = featureNames[next.feature] ?? next.feature;
        final progress = unlock.overallProgress;

        // Check for newly unlocked features
        final newlyUnlocked = unlock.getNewlyUnlockedFeatures();
        if (newlyUnlocked.isNotEmpty) {
          // Show celebration for first newly unlocked
          final celebrationFeature = featureNames[newlyUnlocked.first] ?? newlyUnlocked.first;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            HapticService.featureUnlocked();
            for (final f in newlyUnlocked) {
              unlock.markFeatureShown(f);
            }
          });

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: GlassPanel(
              elevation: GlassElevation.g3,
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.starGold.withValues(alpha: 0.2),
                    ),
                    child: const Icon(
                      Icons.lock_open_rounded,
                      color: AppColors.starGold,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEn ? 'Unlocked!' : 'Kilidi Açıldı!',
                          style: TextStyle(
                            color: AppColors.starGold,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          celebrationFeature,
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ).animate().scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
            duration: 400.ms,
            curve: Curves.elasticOut,
          );
        }

        // Normal progress banner
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: GlassPanel(
            elevation: GlassElevation.g1,
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      color: isDark
                          ? AppColors.starGold.withValues(alpha: 0.7)
                          : AppColors.lightStarGold,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isEn
                            ? '${next.remaining} more ${next.remaining == 1 ? 'entry' : 'entries'} unlock $featureName'
                            : '${next.remaining} giriş daha $featureName açar',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    backgroundColor: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.08),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDark ? AppColors.starGold : AppColors.lightStarGold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 400.ms);
      },
    );
  }

  Map<String, String> _getFeatureNames(bool isEn) {
    return {
      'dream_journal': isEn ? 'Dream Journal' : 'Rüya Günlüğü',
      'patterns': isEn ? 'Pattern Analysis' : 'Örüntü Analizi',
      'monthly_reflection': isEn ? 'Monthly Reflection' : 'Aylık Yansıma',
      'annual_heatmap': isEn ? 'Annual Heatmap' : 'Yıllık Isı Haritası',
      'cycle_correlation': isEn ? 'Cycle Correlation' : 'Döngü Korelasyonu',
    };
  }
}
