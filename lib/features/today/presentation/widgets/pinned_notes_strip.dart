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

class PinnedNotesStrip extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const PinnedNotesStrip({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinnedAsync = ref.watch(pinnedNotesProvider);

    return pinnedAsync.maybeWhen(
      data: (pinnedNotes) {
        if (pinnedNotes.isEmpty) return const SizedBox.shrink();

        // Show first 2 pinned notes
        final shown = pinnedNotes.take(2).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: PremiumCard(
            style: PremiumCardStyle.subtle,
            borderRadius: 16,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.push_pin_rounded,
                      size: 14,
                      color: AppColors.starGold,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isEn ? 'Pinned Notes' : 'Sabitlenmi\u{015F} Notlar',
                      style: AppTypography.elegantAccent(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    const Spacer(),
                    TapScale(
                      onTap: () {
                        HapticService.selectionTap();
                        context.push(Routes.notesList);
                      },
                      child: Text(
                        isEn ? 'All' : 'T\u{00FC}m\u{00FC}',
                        style: AppTypography.elegantAccent(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.starGold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                for (int i = 0; i < shown.length; i++) ...[
                  if (i > 0) const SizedBox(height: 6),
                  TapScale(
                    onTap: () {
                      HapticService.selectionTap();
                      context.push(Routes.noteDetail, extra: shown[i]);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.sticky_note_2_outlined,
                          size: 14,
                          color: AppColors.starGold.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            shown[i].content,
                            style: AppTypography.subtitle(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ).animate().fadeIn(delay: 350.ms, duration: 300.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
