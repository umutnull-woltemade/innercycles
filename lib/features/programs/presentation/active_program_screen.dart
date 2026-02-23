// ════════════════════════════════════════════════════════════════════════════
// ACTIVE PROGRAM SCREEN - Daily Prompt & Progress View
// ════════════════════════════════════════════════════════════════════════════
// Shows today's prompt, day progress circles, and completion state.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/guided_program_service.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/premium_card.dart';

class ActiveProgramScreen extends ConsumerStatefulWidget {
  final String programId;

  const ActiveProgramScreen({super.key, required this.programId});

  @override
  ConsumerState<ActiveProgramScreen> createState() =>
      _ActiveProgramScreenState();
}

class _ActiveProgramScreenState extends ConsumerState<ActiveProgramScreen> {
  final _reflectionController = TextEditingController();

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(guidedProgramServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          behavior: HitTestBehavior.opaque,
          child: SafeArea(
            child: serviceAsync.when(
              loading: () => const CosmicLoadingIndicator(),
              error: (_, _) => Center(
                child: Text(
                  CommonStrings.errorLoadingProgram(language),
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ),
              data: (service) {
                final program = GuidedProgramService.allPrograms.firstWhere(
                  (p) => p.id == widget.programId,
                  orElse: () => GuidedProgramService.allPrograms.first,
                );
                final progress = service.getProgress(widget.programId);
                final todayPrompt = service.getTodayPrompt(widget.programId);

                return CupertinoScrollbar(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      GlassSliverAppBar(
                        title: isEn ? program.titleEn : program.titleTr,
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            // Program header
                            _ProgramHeader(
                              program: program,
                              progress: progress,
                              isDark: isDark,
                              isEn: isEn,
                            ),
                            const SizedBox(height: 20),

                            // Day progress circles
                            _DayProgressRow(
                              program: program,
                              progress: progress,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 24),

                            // Today's prompt
                            if (todayPrompt != null &&
                                progress != null &&
                                !progress.isCompleted) ...[
                              _TodayPromptCard(
                                day: todayPrompt,
                                isDark: isDark,
                                isEn: isEn,
                              ),
                              const SizedBox(height: 16),

                              // Reflection input
                              _ReflectionInput(
                                controller: _reflectionController,
                                isDark: isDark,
                                isEn: isEn,
                              ),
                              const SizedBox(height: 16),

                              // Complete day button
                              _CompleteButton(
                                isDark: isDark,
                                isEn: isEn,
                                isAlreadyDone: progress.completedDays.contains(
                                  todayPrompt.dayNumber,
                                ),
                                onComplete: () => _completeDay(
                                  service,
                                  todayPrompt.dayNumber,
                                ),
                              ),
                            ] else if (progress?.isCompleted ?? false) ...[
                              _CompletedBanner(isDark: isDark, isEn: isEn),
                            ] else ...[
                              _NotStartedBanner(isDark: isDark, isEn: isEn),
                            ],

                            const SizedBox(height: 40),
                          ]),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _completeDay(GuidedProgramService service, int dayNumber) async {
    final reflection = _reflectionController.text;
    await service.completeDay(
      widget.programId,
      dayNumber,
      reflection: reflection.isNotEmpty ? reflection : null,
    );
    ref.invalidate(guidedProgramServiceProvider);
    HapticFeedback.heavyImpact();
    _reflectionController.clear();
    if (mounted) {
      final isEn = ref.read(languageProvider) == AppLanguage.en;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEn ? 'Day $dayNumber completed!' : '$dayNumber. gün tamamlandı!',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PROGRAM HEADER
// ═══════════════════════════════════════════════════════════════════════════

class _ProgramHeader extends StatelessWidget {
  final GuidedProgram program;
  final ProgramProgress? progress;
  final bool isDark;
  final bool isEn;

  const _ProgramHeader({
    required this.program,
    this.progress,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final completed = progress?.completedDays.length ?? 0;

    return PremiumCard(
      style: PremiumCardStyle.amethyst,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          AppSymbol.hero(program.emoji),
          const SizedBox(height: 12),
          Text(
            isEn ? program.descriptionEn : program.descriptionTr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _MiniStat(
                label: isEn ? 'Duration' : 'Süre',
                value: '${program.durationDays} ${isEn ? 'days' : 'gün'}',
                isDark: isDark,
              ),
              const SizedBox(width: 24),
              _MiniStat(
                label: isEn ? 'Completed' : 'Tamamlanan',
                value: '$completed / ${program.durationDays}',
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.starGold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DAY PROGRESS ROW
// ═══════════════════════════════════════════════════════════════════════════

class _DayProgressRow extends StatelessWidget {
  final GuidedProgram program;
  final ProgramProgress? progress;
  final bool isDark;

  const _DayProgressRow({
    required this.program,
    this.progress,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(program.durationDays, (i) {
          final dayNum = i + 1;
          final isComplete = progress?.completedDays.contains(dayNum) ?? false;
          final isCurrent = progress != null && progress!.currentDay == dayNum;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isComplete
                    ? AppColors.success
                    : isCurrent
                    ? AppColors.starGold.withValues(alpha: 0.2)
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.04)),
                border: isCurrent
                    ? Border.all(color: AppColors.starGold, width: 2)
                    : null,
              ),
              child: Center(
                child: isComplete
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : Text(
                        '$dayNum',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isCurrent
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isCurrent
                              ? AppColors.starGold
                              : (isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted),
                        ),
                      ),
              ),
            ),
          );
        }),
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 300.ms);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TODAY'S PROMPT CARD
// ═══════════════════════════════════════════════════════════════════════════

class _TodayPromptCard extends StatelessWidget {
  final ProgramDay day;
  final bool isDark;
  final bool isEn;

  const _TodayPromptCard({
    required this.day,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.gold,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.starGold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${isEn ? 'Day' : 'Gün'} ${day.dayNumber}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.starGold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isEn ? day.titleEn : day.titleTr,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            isEn ? day.promptEn : day.promptTr,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 300.ms);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// REFLECTION INPUT
// ═══════════════════════════════════════════════════════════════════════════

class _ReflectionInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;
  final bool isEn;

  const _ReflectionInput({
    required this.controller,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      showGradientBorder: false,
      showInnerShadow: false,
      child: TextField(
        controller: controller,
        maxLines: 4,
        maxLength: 500,
        style: TextStyle(
          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
        ),
        decoration: InputDecoration(
          hintText: isEn
              ? 'Write your reflection here (optional)...'
              : 'Yansımanı buraya yaz (opsiyonel)...',
          hintStyle: TextStyle(
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
          counterStyle: TextStyle(
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ),
    ).animate().fadeIn(delay: 250.ms, duration: 300.ms);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// COMPLETE BUTTON
// ═══════════════════════════════════════════════════════════════════════════

class _CompleteButton extends StatelessWidget {
  final bool isDark;
  final bool isEn;
  final bool isAlreadyDone;
  final VoidCallback onComplete;

  const _CompleteButton({
    required this.isDark,
    required this.isEn,
    required this.isAlreadyDone,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isAlreadyDone ? null : onComplete,
        style: ElevatedButton.styleFrom(
          backgroundColor: isAlreadyDone
              ? AppColors.success
              : AppColors.starGold,
          foregroundColor: isAlreadyDone ? Colors.white : AppColors.deepSpace,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: Text(
          isAlreadyDone
              ? (isEn ? 'Completed' : 'Tamamlandı')
              : (isEn ? 'Complete Today' : 'Bugünü Tamamla'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 300.ms);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BANNERS
// ═══════════════════════════════════════════════════════════════════════════

class _CompletedBanner extends StatelessWidget {
  final bool isDark;
  final bool isEn;

  const _CompletedBanner({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                size: 48,
                color: AppColors.starGold,
              ),
              const SizedBox(height: 12),
              Text(
                isEn ? 'Program Completed!' : 'Program Tamamlandı!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isEn
                    ? 'You have finished this guided program. Well done!'
                    : 'Bu rehberli programı tamamladın. Tebrikler!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.0, 1.0),
          duration: 400.ms,
        );
  }
}

class _NotStartedBanner extends StatelessWidget {
  final bool isDark;
  final bool isEn;

  const _NotStartedBanner({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        isEn
            ? 'This program hasn\'t been started yet.'
            : 'Bu program henüz başlatılmadı.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
        ),
      ),
    );
  }
}
