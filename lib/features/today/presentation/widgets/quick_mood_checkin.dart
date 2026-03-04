import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/content/signal_content.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../data/services/signal_response_service.dart';
import '../../../../shared/widgets/quadrant_selector.dart';
import '../../../../shared/widgets/signal_picker.dart';
import '../../../mood/presentation/widgets/signal_response_sheet.dart';

/// Inline quick mood check-in row for the home feed.
/// Two-step flow: 1) Pick quadrant  2) Pick signal within quadrant.
/// Hides itself after the user checks in.
class QuickMoodCheckin extends ConsumerStatefulWidget {
  final bool isEn;
  final bool isDark;

  const QuickMoodCheckin({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  ConsumerState<QuickMoodCheckin> createState() => _QuickMoodCheckinState();
}

class _QuickMoodCheckinState extends ConsumerState<QuickMoodCheckin> {
  bool _justCheckedIn = false;
  SignalQuadrant? _selectedQuadrant;

  @override
  Widget build(BuildContext context) {
    final moodAsync = ref.watch(moodCheckinServiceProvider);
    final todayMood = moodAsync.whenOrNull(
      data: (service) => service.getTodayMood(),
    );

    // Already logged today — don't show
    if (todayMood != null || _justCheckedIn) return const SizedBox.shrink();

    final language = AppLanguage.fromIsEn(widget.isEn);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
      child: Column(
        children: [
          Text(
            widget.isEn ? 'How are you feeling?' : 'Bugün nasıl hissediyorsun?',
            style: AppTypography.subtitle(
              fontSize: 13,
              color: widget.isDark
                  ? AppColors.textMuted
                  : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 12),
          if (_selectedQuadrant == null)
            // Step 1: Pick quadrant
            QuadrantSelector(
              compact: true,
              selected: _selectedQuadrant,
              onSelected: (q) => setState(() => _selectedQuadrant = q),
              language: language,
            ).animate().fadeIn(duration: 300.ms)
          else
            // Step 2: Pick signal within quadrant
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    HapticService.selectionTap();
                    setState(() => _selectedQuadrant = null);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 12,
                        color: widget.isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${_selectedQuadrant!.emoji} ${_selectedQuadrant!.localizedName(language)}',
                        style: AppTypography.subtitle(
                          fontSize: 13,
                          color: widget.isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SignalPicker(
                  quadrant: _selectedQuadrant!,
                  onSelected: (signal) => _logSignal(signal.id),
                  language: language,
                ),
              ],
            ).animate().fadeIn(duration: 300.ms),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Future<void> _logSignal(String signalId) async {
    HapticService.moodSelected();
    setState(() => _justCheckedIn = true);

    final moodService = ref.read(moodCheckinServiceProvider).valueOrNull;
    if (moodService != null) {
      await moodService.logSignal(signalId);
      if (!mounted) return;
      ref.invalidate(moodCheckinServiceProvider);

      // Show signal response sheet for low-mood quadrants
      if (_selectedQuadrant != null &&
          SignalResponseService.shouldShowResponse(_selectedQuadrant!)) {
        if (!mounted) return;
        SignalResponseSheet.show(
          context,
          quadrant: _selectedQuadrant!,
          isEn: widget.isEn,
          isDark: widget.isDark,
        );
      }
    }
  }
}
