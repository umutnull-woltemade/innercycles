import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/tap_scale.dart';

class LifeEventAnniversaryCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const LifeEventAnniversaryCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(lifeEventServiceProvider);

    return serviceAsync.maybeWhen(
      data: (service) {
        final now = DateTime.now();
        final allEvents = service.getAllEvents();

        // Find events with anniversaries today (1, 2, 3, 5, 10 years)
        final milestoneYears = [1, 2, 3, 5, 10];
        MapEntry<int, dynamic>? anniversaryMatch;

        for (final event in allEvents) {
          for (final years in milestoneYears) {
            if (event.date.month == now.month &&
                event.date.day == now.day &&
                event.date.year == now.year - years) {
              anniversaryMatch = MapEntry(years, event);
              break;
            }
          }
          if (anniversaryMatch != null) break;
        }

        if (anniversaryMatch == null) return const SizedBox.shrink();

        final years = anniversaryMatch.key;
        final event = anniversaryMatch.value;
        final yearLabel = isEn
            ? '$years year${years > 1 ? 's' : ''} ago'
            : '$years yıl önce';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: TapScale(
            onTap: () {
              HapticService.selectionTap();
              context.push(Routes.lifeEventDetail.replaceFirst(':id', event.id as String));
            },
            child: PremiumCard(
              style: PremiumCardStyle.gold,
              borderRadius: 16,
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.starGold.withValues(alpha: 0.15),
                    ),
                    child: Center(
                      child: Text(
                        _milestoneEmoji(years),
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                          yearLabel,
                          style: AppTypography.elegantAccent(
                            fontSize: 12,
                            color: AppColors.starGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 500.ms, duration: 400.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  String _milestoneEmoji(int years) {
    return switch (years) {
      1 => '\u{1F382}', // birthday cake
      2 => '\u{2B50}', // star
      3 => '\u{1F31F}', // glowing star
      5 => '\u{1F3C6}', // trophy
      10 => '\u{1F48E}', // gem
      _ => '\u{2728}', // sparkles
    };
  }
}
