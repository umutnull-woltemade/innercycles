// ════════════════════════════════════════════════════════════════════════════
// TIME CAPSULE DELIVERY CARD - Shows when a capsule is ready to open
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/premium_card.dart';

class TimeCapsuleDeliveryCard extends ConsumerStatefulWidget {
  final bool isEn;
  final bool isDark;

  const TimeCapsuleDeliveryCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  ConsumerState<TimeCapsuleDeliveryCard> createState() =>
      _TimeCapsuleDeliveryCardState();
}

class _TimeCapsuleDeliveryCardState
    extends ConsumerState<TimeCapsuleDeliveryCard> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final capsuleAsync = ref.watch(timeCapsuleServiceProvider);

    return capsuleAsync.maybeWhen(
      data: (service) {
        final ready = service.getReadyCapsules();
        if (ready.isEmpty) return const SizedBox.shrink();

        final capsule = ready.first;
        final daysAgo = DateTime.now().difference(capsule.createdAt).inDays;

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
                    Icon(Icons.mail_rounded, size: 18, color: AppColors.starGold),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.isEn
                            ? 'A Letter From Your Past Self'
                            : 'Geçmiş Beninden Bir Mektup',
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: widget.isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.isEn
                      ? 'Written $daysAgo days ago, waiting for today.'
                      : '$daysAgo gün önce yazılmış, bugün için bekliyordu.',
                  style: AppTypography.decorativeScript(
                    fontSize: 12,
                    color: widget.isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(height: 12),
                if (!_revealed)
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _revealed = true);
                        service.openCapsule(capsule.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [AppColors.starGold, AppColors.celestialGold],
                          ),
                        ),
                        child: Text(
                          widget.isEn ? 'Open Letter' : 'Mektubu Aç',
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.deepSpace,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: (widget.isDark ? Colors.white : Colors.black)
                          .withValues(alpha: 0.04),
                    ),
                    child: Text(
                      capsule.content,
                      style: AppTypography.elegantAccent(
                        fontSize: 14,
                        color: widget.isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ).animate().fadeIn(duration: 600.ms),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
