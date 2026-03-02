// ════════════════════════════════════════════════════════════════════════════
// JOURNAL QUERY TEASER CARD - Prompts users to "Ask Your Journal"
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/premium_card.dart';

class JournalQueryTeaserCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const JournalQueryTeaserCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalAsync = ref.watch(journalServiceProvider);

    return journalAsync.maybeWhen(
      data: (service) {
        final entries = service.getAllEntries();
        if (entries.length < 5) return const SizedBox.shrink();

        // Rotate suggested question based on day
        final questions = isEn
            ? [
                'What patterns do you see in your journal?',
                'When do you feel most energized?',
                'What topics keep coming back?',
                'How has your mood shifted lately?',
              ]
            : [
                'Günlüğünde hangi örüntüleri görüyorsun?',
                'En enerjik ne zaman hissediyorsun?',
                'Hangi konular tekrar tekrar geliyor?',
                'Ruh halin son zamanlarda nasıl değişti?',
              ];
        final question = questions[DateTime.now().day % questions.length];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: GestureDetector(
            onTap: () => context.push(Routes.journalQuery),
            child: PremiumCard(
              style: PremiumCardStyle.amethyst,
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.amethyst.withValues(alpha: 0.2),
                          AppColors.auroraStart.withValues(alpha: 0.15),
                        ],
                      ),
                    ),
                    child: Icon(Icons.search_rounded,
                        size: 18, color: AppColors.amethyst),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEn ? 'Ask Your Journal' : 'Günlüğüne Sor',
                          style: AppTypography.subtitle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          question,
                          style: AppTypography.decorativeScript(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded,
                      size: 18,
                      color:
                          isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 300.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
