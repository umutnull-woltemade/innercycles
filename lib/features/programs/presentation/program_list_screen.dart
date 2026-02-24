// ════════════════════════════════════════════════════════════════════════════
// PROGRAM LIST SCREEN - Browse & Start Guided Programs
// ════════════════════════════════════════════════════════════════════════════
// Displays all available guided programs, shows progress, allows starting.
// Free users: 2 free programs. Premium: all programs + completion badges.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/first_taste_service.dart';
import '../../../data/services/guided_program_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';

class ProgramListScreen extends ConsumerWidget {
  const ProgramListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final isPremium = ref.watch(isPremiumUserProvider);
    final serviceAsync = ref.watch(guidedProgramServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CupertinoScrollbar(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                GlassSliverAppBar(
                  title: isEn ? 'Guided Programs' : 'Rehberli Programlar',
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: serviceAsync.when(
                    loading: () => const SliverToBoxAdapter(
                      child: Center(child: CosmicLoadingIndicator()),
                    ),
                    error: (_, _) => SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          isEn
                              ? 'Could not load. Your local data is unaffected.'
                              : 'Yüklenemedi. Yerel verileriniz etkilenmedi.',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ),
                    ),
                    data: (service) {
                      final programs = GuidedProgramService.allPrograms;
                      return SliverList(
                        delegate: SliverChildListDelegate([
                          // Intro text
                          Text(
                            isEn
                                ? 'Structured reflection journeys to deepen self-awareness'
                                : 'Öz farkındalığı derinleştirmek için yapılandırılmış yansıma yolculukları',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Active programs section
                          if (service.activeProgramCount > 0) ...[
                            GradientText(
                              isEn ? 'In Progress' : 'Devam Eden',
                              variant: GradientTextVariant.aurora,
                              style: AppTypography.displayFont.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...programs
                                .where((p) {
                                  final progress = service.getProgress(p.id);
                                  return progress != null &&
                                      !progress.isCompleted;
                                })
                                .map(
                                  (p) => _ProgramCard(
                                    program: p,
                                    progress: service.getProgress(p.id),
                                    isCompleted: false,
                                    isPremium: isPremium,
                                    isDark: isDark,
                                    isEn: isEn,
                                    onTap: () => context.push(
                                      '${Routes.programs}/${p.id}',
                                    ),
                                  ),
                                ),
                            const SizedBox(height: 24),
                          ],

                          // All programs
                          GradientText(
                            isEn ? 'All Programs' : 'Tüm Programlar',
                            variant: GradientTextVariant.gold,
                            style: AppTypography.displayFont.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...programs.map((p) {
                            final firstTaste = ref
                                .watch(firstTasteServiceProvider)
                                .whenOrNull(data: (s) => s);
                            final allowFirstTaste =
                                firstTaste?.shouldAllowFree(
                                  FirstTasteFeature.guidedProgram,
                                ) ??
                                false;

                            return _ProgramCard(
                              program: p,
                              progress: service.getProgress(p.id),
                              isCompleted: service.isProgramCompleted(p.id),
                              isPremium: isPremium,
                              isFirstTasteFree: allowFirstTaste && !isPremium,
                              isDark: isDark,
                              isEn: isEn,
                              onTap: () {
                                if (p.isPremium && !isPremium) {
                                  if (allowFirstTaste) {
                                    // Allow first premium program free
                                    firstTaste?.recordUse(
                                      FirstTasteFeature.guidedProgram,
                                    );
                                    if (service.getProgress(p.id) != null) {
                                      context.push(
                                        '${Routes.programs}/${p.id}',
                                      );
                                    } else {
                                      _startProgram(
                                        context,
                                        ref,
                                        service,
                                        p,
                                        isEn,
                                      );
                                    }
                                    return;
                                  }
                                  showContextualPaywall(
                                    context,
                                    ref,
                                    paywallContext: PaywallContext.programs,
                                  );
                                  return;
                                }
                                if (service.getProgress(p.id) != null) {
                                  context.push('${Routes.programs}/${p.id}');
                                } else {
                                  _startProgram(context, ref, service, p, isEn);
                                }
                              },
                            );
                          }),
                          ToolEcosystemFooter(
                            currentToolId: 'programList',
                            isEn: isEn,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 40),
                        ]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _startProgram(
    BuildContext context,
    WidgetRef ref,
    GuidedProgramService service,
    GuidedProgram program,
    bool isEn,
  ) async {
    await service.startProgram(program.id);
    ref.invalidate(guidedProgramServiceProvider);
    HapticFeedback.mediumImpact();
    if (context.mounted) {
      context.push('${Routes.programs}/${program.id}');
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PROGRAM CARD
// ═══════════════════════════════════════════════════════════════════════════

class _ProgramCard extends StatelessWidget {
  final GuidedProgram program;
  final ProgramProgress? progress;
  final bool isCompleted;
  final bool isPremium;
  final bool isFirstTasteFree;
  final bool isDark;
  final bool isEn;
  final VoidCallback onTap;

  const _ProgramCard({
    required this.program,
    this.progress,
    required this.isCompleted,
    required this.isPremium,
    this.isFirstTasteFree = false,
    required this.isDark,
    required this.isEn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = program.isPremium && !isPremium && !isFirstTasteFree;
    final hasProgress = progress != null && !progress!.isCompleted;
    final completionPercent = hasProgress
        ? (progress!.completedDays.length / program.durationDays * 100).round()
        : 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Semantics(
        label: isEn ? program.titleEn : program.titleTr,
        button: true,
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceDark.withValues(alpha: 0.85)
                  : AppColors.lightCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCompleted
                    ? AppColors.success.withValues(alpha: 0.3)
                    : hasProgress
                    ? AppColors.starGold.withValues(alpha: 0.3)
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.15)
                          : Colors.black.withValues(alpha: 0.05)),
              ),
            ),
            child: Row(
              children: [
                // Emoji badge
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isLocked
                        ? (isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.black.withValues(alpha: 0.03))
                        : AppColors.starGold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      isLocked ? '🔒' : program.emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              isEn ? program.titleEn : program.titleTr,
                              style: AppTypography.displayFont.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isLocked
                                    ? (isDark
                                          ? AppColors.textMuted
                                          : AppColors.lightTextMuted)
                                    : (isDark
                                          ? AppColors.textPrimary
                                          : AppColors.lightTextPrimary),
                              ),
                            ),
                          ),
                          if (isCompleted)
                            Icon(
                              Icons.check_circle,
                              size: 18,
                              color: AppColors.success,
                            ),
                          if (isLocked)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.starGold.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'PRO',
                                style: AppTypography.elegantAccent(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.starGold,
                                ),
                              ),
                            ),
                          if (isFirstTasteFree &&
                              program.isPremium &&
                              !isPremium)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isEn ? 'FREE' : 'ÜCRETSİZ',
                                style: AppTypography.elegantAccent(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isEn ? program.descriptionEn : program.descriptionTr,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                      if (hasProgress) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: completionPercent / 100,
                                  minHeight: 4,
                                  backgroundColor: isDark
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : Colors.black.withValues(alpha: 0.06),
                                  valueColor: AlwaysStoppedAnimation(
                                    AppColors.starGold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$completionPercent%',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.starGold,
                              ),
                            ),
                          ],
                        ),
                      ] else if (!isCompleted && !isLocked) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${program.durationDays} ${isEn ? 'days' : 'gün'}',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.auroraStart,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),
        ),
      ),
    );
  }
}
