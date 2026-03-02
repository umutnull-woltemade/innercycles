import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/tap_scale.dart';

class BadgeUnlockBanner extends ConsumerStatefulWidget {
  final bool isEn;
  final bool isDark;

  const BadgeUnlockBanner({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  ConsumerState<BadgeUnlockBanner> createState() => _BadgeUnlockBannerState();
}

class _BadgeUnlockBannerState extends ConsumerState<BadgeUnlockBanner> {
  static const _seenPrefix = 'badge_seen_';
  List<({String id, String emoji, String name})> _unseen = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _checkBadges();
  }

  Future<void> _checkBadges() async {
    final milestoneService = await ref.read(milestoneServiceProvider.future);
    final prefs = await SharedPreferences.getInstance();
    final language = AppLanguage.fromIsEn(widget.isEn);

    final earned = milestoneService.getEarnedMilestones();
    final unseen = <({String id, String emoji, String name})>[];

    for (final em in earned) {
      final key = '$_seenPrefix${em.milestone.id}';
      if (prefs.getBool(key) != true) {
        unseen.add((
          id: em.milestone.id,
          emoji: em.milestone.emoji,
          name: em.milestone.localizedName(language),
        ));
      }
    }

    if (mounted) {
      setState(() {
        _unseen = unseen.take(3).toList(); // Show max 3
        _loaded = true;
      });
    }
  }

  Future<void> _dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    for (final badge in _unseen) {
      await prefs.setBool('$_seenPrefix${badge.id}', true);
    }
    if (mounted) setState(() => _unseen = []);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _unseen.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: PremiumCard(
        style: PremiumCardStyle.gold,
        borderRadius: 20,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Text('\u{1F3C5}', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.isEn
                        ? 'New Badge${_unseen.length > 1 ? 's' : ''} Unlocked!'
                        : 'Yeni Rozet${_unseen.length > 1 ? 'ler' : ''} A\u{00E7}\u{0131}ld\u{0131}!',
                    style: AppTypography.displayFont.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: widget.isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
                TapScale(
                  onTap: () {
                    HapticService.selectionTap();
                    final badgeNames = _unseen.map((b) => '${b.emoji} ${b.name}').join(', ');
                    final text = widget.isEn
                        ? 'Just unlocked: $badgeNames in InnerCycles!\n\n${AppConstants.appStoreUrl}'
                        : 'InnerCycles\'da yeni rozet: $badgeNames!\n\n${AppConstants.appStoreUrl}';
                    SharePlus.instance.share(ShareParams(text: text));
                  },
                  child: Icon(
                    Icons.share_rounded,
                    size: 16,
                    color: AppColors.starGold,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    HapticService.selectionTap();
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
            // Badge pills
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: _unseen
                  .map(
                    (badge) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.starGold.withValues(alpha: 0.12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            badge.emoji,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            badge.name,
                            style: AppTypography.elegantAccent(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: widget.isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            TapScale(
              onTap: () {
                HapticService.buttonPress();
                _dismiss();
                context.push(Routes.milestones);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [AppColors.starGold, AppColors.celestialGold],
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.isEn ? 'View Badges' : 'Rozetleri G\u{00F6}r',
                    style: AppTypography.modernAccent(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepSpace,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 150.ms, duration: 400.ms).slideY(
          begin: 0.1,
          duration: 300.ms,
        );
  }
}
