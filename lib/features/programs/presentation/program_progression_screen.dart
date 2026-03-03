// ════════════════════════════════════════════════════════════════════════════
// PROGRAM PROGRESSION - Overview of all guided programs & progress
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/guided_program_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class ProgramProgressionScreen extends ConsumerWidget {
  const ProgramProgressionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(guidedProgramServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (service) {
              final programs = GuidedProgramService.allPrograms;
              final activeCount = service.activeProgramCount;
              final completedCount = service.completedProgramCount;

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: isEn
                        ? 'Program Progress'
                        : 'Program İlerlemesi',
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            isEn
                                ? 'Track your guided reflection journeys'
                                : 'Rehberli yansıma yolculuklarını takip et',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Overview
                          _OverviewHero(
                            total: programs.length,
                            active: activeCount,
                            completed: completedCount,
                            isEn: isEn,
                            isDark: isDark,
                          )
                              .animate()
                              .fadeIn(duration: 400.ms),

                          const SizedBox(height: 24),

                          GradientText(
                            isEn ? 'All Programs' : 'Tüm Programlar',
                            variant: GradientTextVariant.aurora,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),

                          ...programs.asMap().entries.map((entry) {
                            final program = entry.value;
                            final progress =
                                service.getProgress(program.id);
                            final isCompleted =
                                service.isProgramCompleted(
                                    program.id);

                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 12),
                              child: _ProgramCard(
                                program: program,
                                progress: progress,
                                isCompleted: isCompleted,
                                isEn: isEn,
                                isDark: isDark,
                              ),
                            );
                          }),

                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              isEn
                                  ? '$completedCount / ${programs.length} programs completed'
                                  : '$completedCount / ${programs.length} program tamamlandı',
                              style: AppTypography.subtitle(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OverviewHero extends StatelessWidget {
  final int total;
  final int active;
  final int completed;
  final bool isEn;
  final bool isDark;

  const _OverviewHero({
    required this.total,
    required this.active,
    required this.completed,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.aurora,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  '$total',
                  style: AppTypography.modernAccent(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.auroraStart,
                  ),
                ),
                Text(
                  isEn ? 'Programs' : 'Program',
                  style: AppTypography.elegantAccent(
                    fontSize: 9,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
            if (active > 0)
              Column(
                children: [
                  Text(
                    '$active',
                    style: AppTypography.modernAccent(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.starGold,
                    ),
                  ),
                  Text(
                    isEn ? 'Active' : 'Aktif',
                    style: AppTypography.elegantAccent(
                      fontSize: 9,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            Column(
              children: [
                Text(
                  '$completed',
                  style: AppTypography.modernAccent(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
                Text(
                  isEn ? 'Completed' : 'Tamamlandı',
                  style: AppTypography.elegantAccent(
                    fontSize: 9,
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
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final GuidedProgram program;
  final ProgramProgress? progress;
  final bool isCompleted;
  final bool isEn;
  final bool isDark;

  const _ProgramCard({
    required this.program,
    required this.progress,
    required this.isCompleted,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final lang = isEn ? AppLanguage.en : AppLanguage.tr;
    final completedDays = progress?.completedDays.length ?? 0;
    final totalDays = program.durationDays;
    final progressRatio =
        totalDays > 0 ? completedDays / totalDays : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: isCompleted
            ? Border.all(
                color:
                    AppColors.success.withValues(alpha: 0.25))
            : progress != null
                ? Border.all(
                    color: AppColors.starGold
                        .withValues(alpha: 0.2))
                : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(program.emoji,
                  style: const TextStyle(fontSize: 26)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.localizedTitle(lang),
                      style: AppTypography.modernAccent(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${program.durationDays} ${isEn ? 'days' : 'gün'}${program.isPremium ? ' · Premium' : ''}',
                      style: AppTypography.subtitle(
                        fontSize: 10,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            program.localizedDescription(lang),
            style: AppTypography.subtitle(
              fontSize: 11,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: 14),

            // Day grid
            _DayGrid(
              totalDays: totalDays,
              completedDays: progress!.completedDays,
              isDark: isDark,
            ),

            const SizedBox(height: 10),

            // Progress bar
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progressRatio,
                      minHeight: 4,
                      backgroundColor: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.06),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isCompleted
                            ? AppColors.success
                            : AppColors.starGold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '$completedDays / $totalDays',
                  style: AppTypography.modernAccent(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 10),
            Text(
              isEn ? 'Not started' : 'Başlanmadı',
              style: AppTypography.subtitle(
                fontSize: 10,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DayGrid extends StatelessWidget {
  final int totalDays;
  final Set<int> completedDays;
  final bool isDark;

  const _DayGrid({
    required this.totalDays,
    required this.completedDays,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: List.generate(totalDays, (i) {
        final day = i + 1;
        final done = completedDays.contains(day);
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: done
                ? AppColors.success.withValues(alpha: 0.2)
                : isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.04),
            border: done
                ? Border.all(
                    color: AppColors.success
                        .withValues(alpha: 0.4))
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            '$day',
            style: AppTypography.modernAccent(
              fontSize: 9,
              fontWeight: done ? FontWeight.w700 : FontWeight.w400,
              color: done
                  ? AppColors.success
                  : isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
            ),
          ),
        );
      }),
    );
  }
}
