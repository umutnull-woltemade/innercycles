// ════════════════════════════════════════════════════════════════════════════
// WIN-BACK OFFER BANNER - Premium nudge for lapsed free users (14+ days away)
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/services/premium_service.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/tap_scale.dart';
import '../../../premium/presentation/contextual_paywall_modal.dart';

class WinBackOfferBanner extends ConsumerStatefulWidget {
  final bool isEn;
  final bool isDark;

  const WinBackOfferBanner({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  ConsumerState<WinBackOfferBanner> createState() =>
      _WinBackOfferBannerState();
}

class _WinBackOfferBannerState extends ConsumerState<WinBackOfferBanner> {
  static const _lastOpenKey = 'today_feed_last_open';
  static const _dismissedKey = 'win_back_dismissed_at';

  int _daysAway = 0;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _checkEligibility();
  }

  Future<void> _checkEligibility() async {
    final prefs = await SharedPreferences.getInstance();
    final lastOpen = prefs.getInt(_lastOpenKey);
    if (lastOpen == null) return;

    final daysAway = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(lastOpen))
        .inDays;

    // Only show for users away 14+ days
    if (daysAway < 14) return;

    // Don't re-show if dismissed within the last 7 days
    final dismissedAt = prefs.getInt(_dismissedKey);
    if (dismissedAt != null) {
      final daysSinceDismiss = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(dismissedAt))
          .inDays;
      if (daysSinceDismiss < 7) return;
    }

    if (!mounted) return;
    setState(() {
      _daysAway = daysAway;
      _visible = true;
    });
  }

  Future<void> _dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dismissedKey, DateTime.now().millisecondsSinceEpoch);
    if (mounted) setState(() => _visible = false);
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(isPremiumUserProvider);

    // Only for free users who've been away 14+ days
    if (isPremium || !_visible) return const SizedBox.shrink();

    final accentColor = AppColors.starGold;

    final headline = widget.isEn
        ? 'We saved your spot'
        : 'Yerini sakladık';

    final subtitle = widget.isEn
        ? 'It\'s been $_daysAway days. Your journal is waiting — '
            'unlock Premium for the full experience.'
        : '$_daysAway gündür burada değilsin. Günlüğün seni bekliyor — '
            'tam deneyim için Premium\'u aç.';

    final features = widget.isEn
        ? ['Unlimited AI insights', 'Pattern analysis', 'Streak protection']
        : ['Sınırsız AI içgörüler', 'Örüntü analizi', 'Seri koruma'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: TapScale(
        onTap: () => showContextualPaywall(
          context,
          ref,
          paywallContext: PaywallContext.general,
          bypassTimingGate: true,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accentColor.withValues(alpha: widget.isDark ? 0.12 : 0.06),
                AppColors.celestialGold
                    .withValues(alpha: widget.isDark ? 0.06 : 0.03),
              ],
            ),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.25),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with dismiss
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          accentColor.withValues(alpha: 0.2),
                          AppColors.celestialGold.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        size: 20,
                        color: accentColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GradientText(
                      headline,
                      variant: GradientTextVariant.gold,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _dismiss,
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

              // Subtitle
              Text(
                subtitle,
                style: AppTypography.subtitle(
                  fontSize: 13,
                  color: widget.isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 12),

              // Feature chips
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: features
                    .map((f) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: accentColor
                                .withValues(alpha: widget.isDark ? 0.1 : 0.06),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                size: 12,
                                color: accentColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                f,
                                style: AppTypography.elegantAccent(
                                  fontSize: 11,
                                  color: accentColor,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 14),

              // CTA button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [AppColors.starGold, AppColors.celestialGold],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.isEn ? 'Try Premium' : 'Premium\'u Dene',
                    style: AppTypography.modernAccent(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepSpace,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 200.ms)
        .slideY(begin: 0.06, duration: 400.ms);
  }
}
