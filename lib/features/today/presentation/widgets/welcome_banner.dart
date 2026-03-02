import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/premium_card.dart';

/// Welcome banner for first-time users (0-2 entries).
/// Dismissable with a SharedPreferences key.
class WelcomeBanner extends ConsumerStatefulWidget {
  final bool isEn;
  final bool isDark;

  const WelcomeBanner({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  ConsumerState<WelcomeBanner> createState() => _WelcomeBannerState();
}

class _WelcomeBannerState extends ConsumerState<WelcomeBanner> {
  static const _dismissKey = 'welcome_banner_dismissed';
  bool _dismissed = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _checkDismissed();
  }

  Future<void> _checkDismissed() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _dismissed = prefs.getBool(_dismissKey) == true;
        _loaded = true;
      });
    }
  }

  Future<void> _dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dismissKey, true);
    if (mounted) setState(() => _dismissed = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _dismissed) return const SizedBox.shrink();

    final journalAsync = ref.watch(journalServiceProvider);
    return journalAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        if (service.entryCount > 2) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: PremiumCard(
            style: PremiumCardStyle.gold,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GradientText(
                        widget.isEn
                            ? 'Welcome to InnerCycles'
                            : 'InnerCycles\'a Hoş Geldin',
                        variant: GradientTextVariant.gold,
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 17,
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
                        size: 18,
                        color: widget.isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.isEn
                      ? 'Your personal journaling space. Track your mood, discover patterns, and grow through reflection.'
                      : 'Kişisel günlük alanın. Ruh halini takip et, örüntüleri keşfet ve yansımayla büyü.',
                  style: AppTypography.subtitle(
                    fontSize: 13,
                    color: widget.isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      context.push(Routes.journal);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.starGold,
                            AppColors.celestialGold,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit_note_rounded,
                            size: 18,
                            color: AppColors.deepSpace,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.isEn
                                ? 'Write Your First Entry'
                                : 'İlk Kaydını Yaz',
                            style: AppTypography.elegantAccent(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.deepSpace,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideY(
                begin: 0.1,
                duration: 400.ms,
              ),
        );
      },
    );
  }
}
