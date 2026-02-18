import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/ritual_service.dart';
import 'package:go_router/go_router.dart';

/// Ritual check-off card for the home screen
class RitualCheckoffCard extends ConsumerWidget {
  const RitualCheckoffCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final stacksAsync = ref.watch(ritualStacksProvider);

    return stacksAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (stacks) {
        if (stacks.isEmpty) {
          return _EmptyRitualCard(isDark: isDark, isEn: isEn);
        }
        return _RitualCheckoffContent(
          stacks: stacks,
          isDark: isDark,
          isEn: isEn,
        );
      },
    );
  }
}

/// Empty state suggesting user create their first ritual
class _EmptyRitualCard extends StatelessWidget {
  final bool isDark;
  final bool isEn;

  const _EmptyRitualCard({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isEn ? 'Start a Daily Ritual' : 'Günlük Ritüel Başlat',
      button: true,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark.withValues(alpha: 0.85)
              : AppColors.lightCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            context.push(Routes.ritualCreate);
          },
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.auroraStart.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.playlist_add_check_rounded,
                  color: AppColors.auroraStart,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEn
                          ? 'Start a Daily Ritual'
                          : 'Günlük Ritüel Başlat',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      isEn
                          ? 'Track habits that matter to you'
                          : 'Senin için önemli alışkanlıkları takip et',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.add_circle_outline,
                color: AppColors.auroraStart,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, duration: 400.ms);
  }
}

class _RitualCheckoffContent extends ConsumerWidget {
  final List<RitualStack> stacks;
  final bool isDark;
  final bool isEn;

  const _RitualCheckoffContent({
    required this.stacks,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(todayRitualSummaryProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.auroraStart.withValues(alpha: 0.1),
                  AppColors.surfaceDark.withValues(alpha: 0.9),
                ]
              : [AppColors.auroraStart.withValues(alpha: 0.05), Colors.white],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.auroraStart.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with summary
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.auroraStart.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.playlist_add_check_rounded,
                  color: AppColors.auroraStart,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isEn ? 'Today\'s Rituals' : 'Bugünün Ritüelleri',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              summaryAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (summary) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: summary.overallCompletion >= 1.0
                        ? AppColors.success.withValues(alpha: 0.2)
                        : AppColors.auroraStart.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${summary.completedItems}/${summary.totalItems}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: summary.overallCompletion >= 1.0
                          ? AppColors.success
                          : AppColors.auroraStart,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Stack items
          ...stacks.map(
            (stack) => _StackSection(stack: stack, isDark: isDark, isEn: isEn),
          ),

          // Manage button
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () => context.push(Routes.rituals),
              child: Text(
                isEn ? 'Manage Rituals' : 'Ritüelleri Yönet',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, duration: 400.ms);
  }
}

class _StackSection extends ConsumerWidget {
  final RitualStack stack;
  final bool isDark;
  final bool isEn;

  const _StackSection({
    required this.stack,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(ritualServiceProvider);

    return serviceAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stack name with time icon
              Row(
                children: [
                  Text(stack.time.icon, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    stack.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Items
              ...stack.items.map((item) {
                final isCompleted = service.isItemCompleted(
                  stackId: stack.id,
                  itemId: item.id,
                );
                return _RitualItemTile(
                  item: item,
                  stackId: stack.id,
                  isCompleted: isCompleted,
                  isDark: isDark,
                  onToggle: () async {
                    HapticFeedback.lightImpact();
                    await service.toggleItem(
                      stackId: stack.id,
                      itemId: item.id,
                    );
                    ref.invalidate(ritualServiceProvider);
                    ref.invalidate(todayRitualSummaryProvider);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _RitualItemTile extends StatelessWidget {
  final RitualItem item;
  final String stackId;
  final bool isCompleted;
  final bool isDark;
  final VoidCallback onToggle;

  const _RitualItemTile({
    required this.item,
    required this.stackId,
    required this.isCompleted,
    required this.isDark,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Semantics(
        label: '${item.name}, ${isCompleted ? 'completed' : 'not completed'}',
        button: true,
        toggled: isCompleted,
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 44,
                  height: 44,
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? AppColors.success
                            : Colors.transparent,
                        border: Border.all(
                          color: isCompleted
                              ? AppColors.success
                              : (isDark
                                    ? AppColors.textMuted.withValues(
                                        alpha: 0.4,
                                      )
                                    : AppColors.lightTextMuted.withValues(
                                        alpha: 0.4,
                                      )),
                          width: 2,
                        ),
                      ),
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: isCompleted
                          ? (isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted)
                          : (isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary),
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
