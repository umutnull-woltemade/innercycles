// ════════════════════════════════════════════════════════════════════════════
// COMMUNITY CHALLENGE CARD - Weekly shared challenge for social belonging
// ════════════════════════════════════════════════════════════════════════════
// Shows the current week's community challenge with participant count.
// Rotates weekly — creates "we're all doing this together" feeling.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/premium_card.dart';

class CommunityChallengeCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const CommunityChallengeCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengeAsync = ref.watch(growthChallengeServiceProvider);
    final language = ref.watch(languageProvider);

    return challengeAsync.maybeWhen(
      data: (service) {
        final community = service.getCommunityStatus();
        final template = community.template;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              context.push(Routes.challengeHub);
            },
            child: PremiumCard(
              style: PremiumCardStyle.aurora,
              borderRadius: 16,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Text(
                        template.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: AppColors.auroraStart.withValues(alpha: 0.2),
                                  ),
                                  child: Text(
                                    isEn ? 'THIS WEEK' : 'BU HAFTA',
                                    style: AppTypography.elegantAccent(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.auroraStart,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.people_rounded,
                                  size: 14,
                                  color: isDark
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${community.participants}',
                                  style: AppTypography.subtitle(
                                    fontSize: 12,
                                    color: isDark
                                        ? AppColors.textMuted
                                        : AppColors.lightTextMuted,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              template.localizedTitle(language),
                              style: AppTypography.displayFont.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (community.isCompleted)
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.success.withValues(alpha: 0.2),
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            size: 18,
                            color: AppColors.success,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Description
                  Text(
                    template.localizedDesc(language),
                    style: AppTypography.subtitle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Progress bar
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: community.percent,
                            minHeight: 6,
                            backgroundColor: isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : Colors.black.withValues(alpha: 0.06),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              community.isCompleted
                                  ? AppColors.success
                                  : AppColors.auroraStart,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${community.currentCount}/${template.targetCount}',
                        style: AppTypography.elegantAccent(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.03, end: 0),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
