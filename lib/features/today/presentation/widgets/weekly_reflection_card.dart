import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/premium_card.dart';

/// Weekly reflection prompt card shown on Friday, Saturday, Sunday.
/// Surfaces 3 structured reflection prompts to deepen weekly engagement.
class WeeklyReflectionCard extends ConsumerStatefulWidget {
  final bool isEn;
  final bool isDark;

  const WeeklyReflectionCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  ConsumerState<WeeklyReflectionCard> createState() =>
      _WeeklyReflectionCardState();
}

class _WeeklyReflectionCardState extends ConsumerState<WeeklyReflectionCard> {
  static const _dismissKey = 'weekly_reflection_dismissed_week';
  bool _dismissed = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _checkDismissed();
  }

  Future<void> _checkDismissed() async {
    final prefs = await SharedPreferences.getInstance();
    final dismissedWeek = prefs.getString(_dismissKey) ?? '';
    final currentWeek = _weekKey();
    if (mounted) {
      setState(() {
        _dismissed = dismissedWeek == currentWeek;
        _loaded = true;
      });
    }
  }

  String _weekKey() {
    final now = DateTime.now();
    // ISO week calculation
    final jan1 = DateTime(now.year, 1, 1);
    final dayOfYear = now.difference(jan1).inDays + 1;
    final weekNumber = ((dayOfYear - now.weekday + 10) / 7).floor();
    return '${now.year}-W$weekNumber';
  }

  Future<void> _dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dismissKey, _weekKey());
    if (mounted) setState(() => _dismissed = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _dismissed) return const SizedBox.shrink();

    // Only show Friday (5), Saturday (6), Sunday (7)
    final weekday = DateTime.now().weekday;
    if (weekday < 5) return const SizedBox.shrink();

    final prompts = widget.isEn
        ? const [
            ('What went well this week?', Icons.thumb_up_rounded),
            ('What drained your energy?', Icons.battery_1_bar_rounded),
            ('What surprised you?', Icons.lightbulb_outline_rounded),
          ]
        : const [
            ('Bu hafta ne iyi gitti?', Icons.thumb_up_rounded),
            ('Enerjini ne tüketti?', Icons.battery_1_bar_rounded),
            ('Seni ne şaşırttı?', Icons.lightbulb_outline_rounded),
          ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: PremiumCard(
        style: PremiumCardStyle.aurora,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.amethyst.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.auto_stories_rounded,
                    size: 18,
                    color: AppColors.amethyst,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GradientText(
                    widget.isEn ? 'Weekly Reflection' : 'Haftalık Yansıma',
                    variant: GradientTextVariant.aurora,
                    style: AppTypography.displayFont.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Dismiss button
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _dismiss();
                  },
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: widget.isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              widget.isEn
                  ? 'Take a moment to look back at your week.'
                  : 'Haftana bir göz atmak için biraz zaman ayır.',
              style: AppTypography.decorativeScript(
                fontSize: 12,
                color: widget.isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 12),
            // Prompt buttons
            ...prompts.map((prompt) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        context.push(
                          Routes.journal,
                          extra: {'journalPrompt': prompt.$1},
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: widget.isDark
                              ? AppColors.amethyst.withValues(alpha: 0.08)
                              : AppColors.amethyst.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              prompt.$2,
                              size: 18,
                              color: AppColors.amethyst
                                  .withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                prompt.$1,
                                style: AppTypography.subtitle(
                                  fontSize: 13,
                                  color: widget.isDark
                                      ? AppColors.textPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: widget.isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ).animate().fadeIn(delay: 500.ms, duration: 400.ms).slideY(
            begin: 0.08,
            duration: 400.ms,
          ),
    );
  }
}
