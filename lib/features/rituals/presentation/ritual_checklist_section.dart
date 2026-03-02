import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/ritual_service.dart';
import '../../../data/services/habit_suggestion_service.dart';
import '../../../data/content/habit_suggestions_content.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

/// Collapsible ritual & habit checklist for the daily entry screen.
/// Shows user's active rituals and adopted habits as quick check-off items.
class RitualChecklistSection extends ConsumerStatefulWidget {
  final DateTime date;

  const RitualChecklistSection({super.key, required this.date});

  @override
  ConsumerState<RitualChecklistSection> createState() =>
      _RitualChecklistSectionState();
}

class _RitualChecklistSectionState
    extends ConsumerState<RitualChecklistSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final ritualAsync = ref.watch(ritualServiceProvider);
    final habitAsync = ref.watch(habitSuggestionServiceProvider);

    return ritualAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (ritualService) {
        return habitAsync.when(
          loading: () => _buildWithRitualsOnly(
              ritualService, null, isDark, isEn),
          error: (_, _) => _buildWithRitualsOnly(
              ritualService, null, isDark, isEn),
          data: (habitService) => _buildWithRitualsOnly(
              ritualService, habitService, isDark, isEn),
        );
      },
    );
  }

  Widget _buildWithRitualsOnly(
    RitualService ritualService,
    HabitSuggestionService? habitService,
    bool isDark,
    bool isEn,
  ) {
    final stacks = ritualService.getStacks();
    final adoptedHabits = habitService?.getAdoptedHabits() ?? [];

    // Don't show if user has no rituals and no adopted habits
    if (stacks.isEmpty && adoptedHabits.isEmpty) return const SizedBox.shrink();

    // Auto-expand if there are items to check off
    final totalItems = stacks.fold<int>(0, (sum, s) => sum + s.items.length) +
        adoptedHabits.length;
    if (totalItems == 0) return const SizedBox.shrink();

    // Count completed
    int completedCount = 0;
    for (final stack in stacks) {
      final completion =
          ritualService.getCompletion(stack.id, date: widget.date);
      completedCount += completion?.completedItemIds.length ?? 0;
    }
    for (final habit in adoptedHabits) {
      if (habitService!.isCheckedToday(habit.id)) completedCount++;
    }

    return PremiumCard(
      style: PremiumCardStyle.subtle,
      child: Column(
        children: [
          // Toggle header
          Semantics(
            label: isEn
                ? (_isExpanded
                    ? 'Collapse rituals and habits'
                    : 'Expand rituals and habits')
                : (_isExpanded
                    ? 'Ritüelleri daralt'
                    : 'Ritüelleri genişlet'),
            button: true,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _isExpanded = !_isExpanded);
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.celestialGold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.check_circle_outline_rounded,
                          color: AppColors.celestialGold,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GradientText(
                              isEn ? 'Rituals & Habits' : 'Ritüeller & Alışkanlıklar',
                              variant: GradientTextVariant.gold,
                              style: AppTypography.displayFont.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              isEn
                                  ? '$completedCount / $totalItems completed'
                                  : '$completedCount / $totalItems tamamlandı',
                              style: AppTypography.decorativeScript(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Progress indicator
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          value: totalItems > 0
                              ? completedCount / totalItems
                              : 0,
                          strokeWidth: 3,
                          backgroundColor: isDark
                              ? AppColors.textMuted.withValues(alpha: 0.2)
                              : AppColors.lightTextMuted.withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            completedCount == totalItems
                                ? AppColors.success
                                : AppColors.celestialGold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.expand_more_rounded,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Expanded checklist
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _buildChecklist(
              ritualService,
              habitService,
              stacks,
              adoptedHabits,
              isDark,
              isEn,
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 300.ms);
  }

  Widget _buildChecklist(
    RitualService ritualService,
    HabitSuggestionService? habitService,
    List<RitualStack> stacks,
    List<HabitSuggestion> adoptedHabits,
    bool isDark,
    bool isEn,
  ) {
    final language = AppLanguage.fromIsEn(isEn);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ritual stacks
          for (final stack in stacks) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 4, top: 4),
              child: Row(
                children: [
                  Text(
                    stack.time.icon,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${stack.name} · ${stack.time.localizedName(language)}',
                    style: AppTypography.elegantAccent(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
            for (final item in stack.items)
              _buildRitualCheckbox(
                ritualService,
                stack,
                item,
                isDark,
              ),
          ],

          // Adopted habits
          if (adoptedHabits.isNotEmpty && stacks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Divider(
                color: isDark
                    ? AppColors.textMuted.withValues(alpha: 0.15)
                    : AppColors.lightTextMuted.withValues(alpha: 0.15),
                height: 1,
              ),
            ),

          if (adoptedHabits.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 4, top: 4),
              child: Row(
                children: [
                  const Text('✨', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    isEn ? 'Daily Habits' : 'Günlük Alışkanlıklar',
                    style: AppTypography.elegantAccent(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
            for (final habit in adoptedHabits)
              _buildHabitCheckbox(
                habitService!,
                habit,
                isDark,
                isEn,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildRitualCheckbox(
    RitualService service,
    RitualStack stack,
    RitualItem item,
    bool isDark,
  ) {
    final isChecked = service.isItemCompleted(
      stackId: stack.id,
      itemId: item.id,
      date: widget.date,
    );

    return InkWell(
      onTap: () async {
        HapticFeedback.selectionClick();
        await service.toggleItem(
          stackId: stack.id,
          itemId: item.id,
          date: widget.date,
        );
        if (mounted) {
          ref.invalidate(todayRitualSummaryProvider);
          setState(() {});
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Icon(
              isChecked
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 20,
              color: isChecked
                  ? AppColors.success
                  : (isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.name,
                style: AppTypography.subtitle(
                  fontSize: 14,
                  color: isChecked
                      ? (isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted)
                      : (isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary),
                ).copyWith(
                  decoration:
                      isChecked ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitCheckbox(
    HabitSuggestionService service,
    HabitSuggestion habit,
    bool isDark,
    bool isEn,
  ) {
    final isChecked = service.isCheckedToday(habit.id);
    final language = AppLanguage.fromIsEn(isEn);

    return InkWell(
      onTap: () async {
        HapticFeedback.selectionClick();
        if (isChecked) {
          await service.uncheckToday(habit.id);
        } else {
          await service.checkOffToday(habit.id);
        }
        if (mounted) setState(() {});
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Icon(
              isChecked
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 20,
              color: isChecked
                  ? AppColors.success
                  : (isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                habit.localizedTitle(language),
                style: AppTypography.subtitle(
                  fontSize: 14,
                  color: isChecked
                      ? (isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted)
                      : (isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary),
                ).copyWith(
                  decoration:
                      isChecked ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            if (isChecked)
              Icon(
                Icons.local_fire_department_rounded,
                size: 16,
                color: AppColors.celestialGold.withValues(alpha: 0.6),
              ),
          ],
        ),
      ),
    );
  }
}
