import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/growth_challenge_service.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/tap_scale.dart';

class ActiveChallengeCard extends ConsumerWidget {
  final AppLanguage language;
  final bool isDark;

  const ActiveChallengeCard({
    super.key,
    required this.language,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEn = language == AppLanguage.en;
    final challengeAsync = ref.watch(growthChallengeServiceProvider);

    return challengeAsync.maybeWhen(
      data: (service) {
        // Get active (non-completed) challenges
        final activeChallenges = <(GrowthChallenge, ChallengeProgress)>[];
        for (final challenge in GrowthChallengeService.allChallenges) {
          final progress = service.getProgress(challenge.id);
          if (progress != null && !progress.isCompleted) {
            activeChallenges.add((challenge, progress));
          }
        }

        if (activeChallenges.isEmpty) return const SizedBox.shrink();

        // Show top 2
        final shown = activeChallenges.take(2).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: TapScale(
            onTap: () {
              HapticService.selectionTap();
              context.push(Routes.challengeHub);
            },
            child: PremiumCard(
              style: PremiumCardStyle.gold,
              borderRadius: 20,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        isEn ? 'Active Challenges' : 'Aktif G\u{00F6}revler',
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  for (int i = 0; i < shown.length; i++) ...[
                    if (i > 0) const SizedBox(height: 10),
                    _ChallengeRow(
                      challenge: shown[i].$1,
                      progress: shown[i].$2,
                      language: language,
                      isDark: isDark,
                      onIncrement: () async {
                        HapticService.buttonPress();
                        final completed = await service.incrementProgress(
                          shown[i].$1.id,
                        );
                        if (completed) {
                          HapticService.featureUnlocked();
                        }
                        ref.invalidate(growthChallengeServiceProvider);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 350.ms, duration: 400.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _ChallengeRow extends StatelessWidget {
  final GrowthChallenge challenge;
  final ChallengeProgress progress;
  final AppLanguage language;
  final bool isDark;
  final VoidCallback onIncrement;

  const _ChallengeRow({
    required this.challenge,
    required this.progress,
    required this.language,
    required this.isDark,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(challenge.emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                challenge.localizedTitle(language),
                style: AppTypography.displayFont.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress.percent,
                  minHeight: 4,
                  backgroundColor: (isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted)
                      .withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation(
                    progress.percent >= 0.7
                        ? AppColors.success
                        : AppColors.starGold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${progress.currentCount}/${progress.targetCount}',
          style: AppTypography.elegantAccent(
            fontSize: 11,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(width: 6),
        TapScale(
          onTap: onIncrement,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.starGold.withValues(alpha: 0.15),
            ),
            child: Icon(
              Icons.add_rounded,
              size: 16,
              color: AppColors.starGold,
            ),
          ),
        ),
      ],
    );
  }
}
