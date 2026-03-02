import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/guided_program_service.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/tap_scale.dart';

class GuidedProgramCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const GuidedProgramCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(guidedProgramServiceProvider);

    return serviceAsync.maybeWhen(
      data: (service) {
        // Find first active (non-completed) program
        GuidedProgram? activeProgram;
        ProgramProgress? active;
        for (final p in GuidedProgramService.allPrograms) {
          final progress = service.getProgress(p.id);
          if (progress != null && !progress.isCompleted) {
            activeProgram = p;
            active = progress;
            break;
          }
        }

        if (active == null || activeProgram == null) {
          // No active program — show discovery teaser
          return _buildDiscoveryTeaser(context);
        }

        final language = AppLanguage.fromIsEn(isEn);
        final completed = active.completedDays.length;
        final total = activeProgram.durationDays;
        final pct = total > 0 ? completed / total : 0.0;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: TapScale(
            onTap: () {
              HapticService.selectionTap();
              context.push(Routes.programs);
            },
            child: PremiumCard(
              style: PremiumCardStyle.aurora,
              borderRadius: 16,
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Text(activeProgram.emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activeProgram.localizedTitle(language),
                          style: AppTypography.modernAccent(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: pct,
                                  minHeight: 4,
                                  backgroundColor: isDark
                                      ? AppColors.surfaceDark
                                      : AppColors.lightSurfaceVariant,
                                  valueColor: AlwaysStoppedAnimation(
                                    AppColors.auroraStart,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${isEn ? 'Day' : 'Gün'} $completed/$total',
                              style: AppTypography.subtitle(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 420.ms, duration: 300.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildDiscoveryTeaser(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: TapScale(
        onTap: () {
          HapticService.selectionTap();
          context.push(Routes.programs);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: isDark
                ? AppColors.surfaceLight.withValues(alpha: 0.25)
                : AppColors.lightSurfaceVariant.withValues(alpha: 0.5),
          ),
          child: Row(
            children: [
              Icon(
                Icons.explore_rounded,
                size: 18,
                color: AppColors.auroraStart,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isEn
                      ? 'Start a 7-day guided program'
                      : '7 günlük rehberli program başlat',
                  style: AppTypography.subtitle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 420.ms, duration: 300.ms);
  }
}
