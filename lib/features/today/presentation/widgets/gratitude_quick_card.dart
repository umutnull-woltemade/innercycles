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

class GratitudeQuickCard extends ConsumerStatefulWidget {
  final bool isEn;
  final bool isDark;

  const GratitudeQuickCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  ConsumerState<GratitudeQuickCard> createState() => _GratitudeQuickCardState();
}

class _GratitudeQuickCardState extends ConsumerState<GratitudeQuickCard> {
  final _controller = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gratitudeAsync = ref.watch(gratitudeServiceProvider);

    return gratitudeAsync.maybeWhen(
      data: (service) {
        final today = service.getTodayEntry();

        // Already logged today — show compact "done" indicator
        if (today != null && today.items.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            child: TapScale(
              onTap: () {
                HapticService.selectionTap();
                context.push(Routes.gratitudeJournal);
              },
              child: PremiumCard(
                style: PremiumCardStyle.subtle,
                borderRadius: 16,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        today.items.first,
                        style: AppTypography.elegantAccent(
                          fontSize: 13,
                          color: widget.isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (today.items.length > 1)
                      Text(
                        ' +${today.items.length - 1}',
                        style: AppTypography.elegantAccent(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: widget.isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 300.ms);
        }

        // Not logged — show quick-add field
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: PremiumCard(
            style: PremiumCardStyle.gold,
            borderRadius: 20,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('\u{1F64F}', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(
                      widget.isEn
                          ? 'What are you grateful for?'
                          : 'Bug\u{00FC}n neye minnettar\u{0131}s\u{0131}n?',
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: widget.isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: AppTypography.subtitle(
                          fontSize: 14,
                          color: widget.isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.isEn
                              ? 'A small moment today...'
                              : 'Bug\u{00FC}nden k\u{00FC}\u{00E7}\u{00FC}k bir an...',
                          hintStyle: AppTypography.subtitle(
                            fontSize: 14,
                            color: widget.isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _save(service),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TapScale(
                      onTap: _saving ? null : () => _save(service),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.starGold,
                              AppColors.celestialGold,
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          size: 18,
                          color: AppColors.deepSpace,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {
                    HapticService.selectionTap();
                    context.push(Routes.gratitudeJournal);
                  },
                  child: Text(
                    widget.isEn ? 'Add more details \u{2192}' : 'Daha fazla ekle \u{2192}',
                    style: AppTypography.elegantAccent(
                      fontSize: 12,
                      color: widget.isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Future<void> _save(dynamic service) async {
    final text = _controller.text.trim();
    if (text.isEmpty || _saving) return;

    setState(() => _saving = true);
    HapticService.buttonPress();

    await service.saveGratitude(
      date: DateTime.now(),
      items: [text],
    );

    _controller.clear();
    ref.invalidate(gratitudeServiceProvider);
    if (mounted) setState(() => _saving = false);
  }
}
