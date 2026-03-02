// ════════════════════════════════════════════════════════════════════════════
// REFLECTION PROMPT CARD - Today feed contextual prompt
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/premium_card.dart';

class ReflectionPromptCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const ReflectionPromptCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engineAsync = ref.watch(reflectionPromptEngineProvider);
    return engineAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (engine) {
        final prompt = engine.getTodayPrompt();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: GestureDetector(
            onTap: () => context.push(Routes.journal, extra: {
              'journalPrompt': prompt.text(isEn),
            }),
            child: PremiumCard(
              style: PremiumCardStyle.amethyst,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('\u{1F4AD}',
                            style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Text(
                          isEn ? 'Reflect' : 'D\u00fc\u015f\u00fcn',
                          style: AppTypography.modernAccent(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      prompt.text(isEn),
                      style: AppTypography.decorativeScript(
                        fontSize: 15,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ).copyWith(fontStyle: FontStyle.italic, height: 1.5),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.amethyst
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isEn ? 'Reflect Now \u2192' : '\u015eimdi D\u00fc\u015f\u00fcn \u2192',
                          style: AppTypography.modernAccent(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.amethyst,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
