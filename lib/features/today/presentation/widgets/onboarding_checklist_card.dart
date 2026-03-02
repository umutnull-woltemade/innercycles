import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/premium_card.dart';

/// First-week onboarding checklist that guides new users through
/// key features. Shows for 7 days after install, auto-checks items
/// as users complete them. Dismissable after all items checked.
class OnboardingChecklistCard extends ConsumerStatefulWidget {
  final bool isEn;
  final bool isDark;

  const OnboardingChecklistCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  ConsumerState<OnboardingChecklistCard> createState() =>
      _OnboardingChecklistCardState();
}

class _OnboardingChecklistCardState
    extends ConsumerState<OnboardingChecklistCard> {
  static const _dismissKey = 'onboarding_checklist_dismissed';
  static const _installTimeKey = 'ic_intro_offer_install_time';
  static const _patternsVisitedKey = 'onboarding_patterns_visited';

  bool _dismissed = false;
  bool _loaded = false;
  bool _patternsVisited = false;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    final dismissed = prefs.getBool(_dismissKey) == true;
    final patternsVisited = prefs.getBool(_patternsVisitedKey) == true;

    // Check if within first 7 days
    final installMs = prefs.getInt(_installTimeKey);
    final isExpired = installMs != null &&
        DateTime.now()
                .difference(DateTime.fromMillisecondsSinceEpoch(installMs))
                .inDays >
            7;

    setState(() {
      _dismissed = dismissed || isExpired;
      _patternsVisited = patternsVisited;
      _loaded = true;
    });
  }

  Future<void> _dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dismissKey, true);
    if (mounted) setState(() => _dismissed = true);
  }

  Future<void> _markPatternsVisited() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_patternsVisitedKey, true);
    if (mounted) setState(() => _patternsVisited = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _dismissed) return const SizedBox.shrink();

    final journalAsync = ref.watch(journalServiceProvider);
    final moodAsync = ref.watch(moodCheckinServiceProvider);
    final streakAsync = ref.watch(streakStatsProvider);

    return journalAsync.maybeWhen(
      data: (journalService) {
        // Don't show for very experienced users
        if (journalService.entryCount > 10) return const SizedBox.shrink();

        final entryCount = journalService.entryCount;
        final hasEntry = entryCount >= 1;

        // Count distinct focus areas
        final entries = journalService.getAllEntries();
        final focusAreas = entries.map((e) => e.focusArea).toSet();
        final hasExploredFocus = focusAreas.length >= 2;

        final hasMood = moodAsync.whenOrNull(
              data: (service) => service.getAllEntries().isNotEmpty,
            ) ??
            false;

        final hasStreak = streakAsync.whenOrNull(
              data: (stats) => stats.currentStreak >= 3,
            ) ??
            false;

        final items = [
          _CheckItem(
            isEn: widget.isEn,
            titleEn: 'Write your first entry',
            titleTr: 'İlk kaydını yaz',
            checked: hasEntry,
            icon: Icons.edit_note_rounded,
            onTap: () => context.push(Routes.journal),
          ),
          _CheckItem(
            isEn: widget.isEn,
            titleEn: 'Log your mood',
            titleTr: 'Ruh halini kaydet',
            checked: hasMood,
            icon: Icons.mood_rounded,
            onTap: null, // Quick mood checkin is already on feed
          ),
          _CheckItem(
            isEn: widget.isEn,
            titleEn: 'Try a second focus area',
            titleTr: 'İkinci bir odak alanı dene',
            checked: hasExploredFocus,
            icon: Icons.explore_outlined,
            onTap: () => context.push(Routes.journal),
          ),
          _CheckItem(
            isEn: widget.isEn,
            titleEn: 'Build a 3-day streak',
            titleTr: '3 günlük seri oluştur',
            checked: hasStreak,
            icon: Icons.local_fire_department_rounded,
            onTap: null,
          ),
          _CheckItem(
            isEn: widget.isEn,
            titleEn: 'Explore your patterns',
            titleTr: 'Örüntülerini keşfet',
            checked: _patternsVisited,
            icon: Icons.insights_rounded,
            onTap: () {
              _markPatternsVisited();
              context.push(Routes.journalPatterns);
            },
          ),
        ];

        final completedCount = items.where((i) => i.checked).length;
        final progress = completedCount / items.length;

        // Auto-dismiss when all complete
        if (completedCount == items.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _dismiss());
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: PremiumCard(
            style: PremiumCardStyle.gold,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GradientText(
                        widget.isEn
                            ? 'Getting Started'
                            : 'Başlangıç Rehberi',
                        variant: GradientTextVariant.gold,
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _dismiss();
                      },
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: widget.isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    backgroundColor: (widget.isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted)
                        .withValues(alpha: 0.15),
                    valueColor: const AlwaysStoppedAnimation(AppColors.starGold),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.isEn
                      ? '$completedCount of ${items.length} complete'
                      : '$completedCount / ${items.length} tamamlandı',
                  style: AppTypography.subtitle(
                    fontSize: 11,
                    color: widget.isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(height: 10),
                // Checklist items
                for (int i = 0; i < items.length; i++) ...[
                  if (i > 0) const SizedBox(height: 6),
                  _buildItem(items[i]),
                ],
              ],
            ),
          ),
        ).animate().fadeIn(delay: 250.ms, duration: 400.ms).slideY(
              begin: 0.08,
              duration: 400.ms,
            );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildItem(_CheckItem item) {
    return GestureDetector(
      onTap: item.checked
          ? null
          : () {
              HapticFeedback.lightImpact();
              item.onTap?.call();
            },
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: item.checked
                  ? AppColors.success.withValues(alpha: 0.15)
                  : (widget.isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted)
                      .withValues(alpha: 0.1),
              border: Border.all(
                color: item.checked
                    ? AppColors.success.withValues(alpha: 0.5)
                    : (widget.isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted)
                        .withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: item.checked
                ? const Icon(
                    Icons.check_rounded,
                    size: 12,
                    color: AppColors.success,
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Icon(
            item.icon,
            size: 15,
            color: item.checked
                ? AppColors.success.withValues(alpha: 0.6)
                : (widget.isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary)
                    .withValues(alpha: 0.7),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.isEn ? item.titleEn : item.titleTr,
              style: AppTypography.subtitle(
                fontSize: 13,
                color: item.checked
                    ? (widget.isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted)
                        .withValues(alpha: 0.6)
                    : (widget.isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary),
              ).copyWith(
                decoration:
                    item.checked ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          if (!item.checked && item.onTap != null)
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 10,
              color: widget.isDark
                  ? AppColors.textMuted
                  : AppColors.lightTextMuted,
            ),
        ],
      ),
    );
  }
}

class _CheckItem {
  final bool isEn;
  final String titleEn;
  final String titleTr;
  final bool checked;
  final IconData icon;
  final VoidCallback? onTap;

  const _CheckItem({
    required this.isEn,
    required this.titleEn,
    required this.titleTr,
    required this.checked,
    required this.icon,
    this.onTap,
  });
}
