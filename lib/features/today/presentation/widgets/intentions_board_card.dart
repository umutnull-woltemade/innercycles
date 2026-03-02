// ════════════════════════════════════════════════════════════════════════════
// INTENTIONS BOARD CARD - Weekly intentions on today feed
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

class IntentionsBoardCard extends ConsumerStatefulWidget {
  final bool isEn;
  final bool isDark;

  const IntentionsBoardCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  ConsumerState<IntentionsBoardCard> createState() =>
      _IntentionsBoardCardState();
}

class _IntentionsBoardCardState extends ConsumerState<IntentionsBoardCard> {
  final _controller = TextEditingController();
  bool _isAdding = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serviceAsync = ref.watch(intentionServiceProvider);

    return serviceAsync.maybeWhen(
      data: (service) {
        final intentions = service.getCurrentWeekIntentions();
        final needsRating = service.needsWeeklyRating;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: GestureDetector(
            onTap: () => context.push(Routes.intentions),
            child: PremiumCard(
              style: PremiumCardStyle.gold,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.flag_rounded,
                          size: 16, color: AppColors.starGold),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.isEn
                              ? 'This Week\'s Intentions'
                              : 'Bu Haftanın Niyetleri',
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: widget.isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                      if (needsRating)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.starGold.withValues(alpha: 0.15),
                          ),
                          child: Text(
                            widget.isEn ? 'Rate' : 'Puanla',
                            style: AppTypography.subtitle(
                              fontSize: 10,
                              color: AppColors.starGold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (intentions.isEmpty && !_isAdding) ...[
                    GestureDetector(
                      onTap: () => setState(() => _isAdding = true),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: (widget.isDark ? Colors.white : Colors.black)
                                .withValues(alpha: 0.08),
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Text(
                          widget.isEn
                              ? '+ Set your first intention for this week'
                              : '+ Bu hafta için ilk niyetini belirle',
                          style: AppTypography.subtitle(
                            fontSize: 13,
                            color: widget.isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    ...intentions.map((intention) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Icon(
                                intention.selfRating != null
                                    ? Icons.check_circle_rounded
                                    : Icons.circle_outlined,
                                size: 16,
                                color: intention.selfRating != null
                                    ? AppColors.starGold
                                    : (widget.isDark
                                            ? Colors.white
                                            : Colors.black)
                                        .withValues(alpha: 0.2),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  intention.text,
                                  style: AppTypography.subtitle(
                                    fontSize: 13,
                                    color: widget.isDark
                                        ? AppColors.textPrimary
                                        : AppColors.lightTextPrimary,
                                  ),
                                ),
                              ),
                              if (intention.selfRating != null)
                                Text(
                                  '${intention.selfRating}/5',
                                  style: AppTypography.subtitle(
                                    fontSize: 11,
                                    color: AppColors.starGold,
                                  ),
                                ),
                            ],
                          ),
                        )),
                  ],
                  if (_isAdding || (intentions.isNotEmpty && intentions.length < 3))
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              autofocus: _isAdding,
                              style: AppTypography.subtitle(
                                fontSize: 13,
                                color: widget.isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: widget.isEn
                                    ? 'What do you want to practice?'
                                    : 'Bu hafta neyi uygulamak istiyorsun?',
                                hintStyle: AppTypography.subtitle(
                                  fontSize: 12,
                                  color: widget.isDark
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onSubmitted: (text) async {
                                if (text.trim().isEmpty) return;
                                await service.addIntention(text.trim());
                                _controller.clear();
                                if (mounted) {
                                  setState(() => _isAdding = false);
                                  ref.invalidate(intentionServiceProvider);
                                }
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final text = _controller.text.trim();
                              if (text.isEmpty) return;
                              await service.addIntention(text);
                              _controller.clear();
                              if (mounted) {
                                setState(() => _isAdding = false);
                                ref.invalidate(intentionServiceProvider);
                              }
                            },
                            child: Icon(Icons.add_circle_rounded,
                                size: 20, color: AppColors.starGold),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 350.ms, duration: 400.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
