// ════════════════════════════════════════════════════════════════════════════
// MEDITATION TIMER SCREEN - Timed Meditation Sessions
// ════════════════════════════════════════════════════════════════════════════
// 4 presets: 5, 10, 15, 20 minutes.
// Animated countdown ring with gentle haptic at completion.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/smart_router_service.dart';
import '../../../data/services/ecosystem_analytics_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_outlined_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../data/services/l10n_service.dart';

class MeditationTimerScreen extends ConsumerStatefulWidget {
  const MeditationTimerScreen({super.key});

  @override
  ConsumerState<MeditationTimerScreen> createState() =>
      _MeditationTimerScreenState();
}

class _MeditationTimerScreenState extends ConsumerState<MeditationTimerScreen>
    with SingleTickerProviderStateMixin {
  int _selectedMinutes = 5;
  bool _isRunning = false;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  Timer? _timer;
  late AnimationController _pulseController;

  static const _presets = [5, 10, 15, 20];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(smartRouterServiceProvider)
          .whenData((s) => s.recordToolVisit('meditation'));
      ref
          .read(ecosystemAnalyticsServiceProvider)
          .whenData((s) => s.trackToolOpen('meditation', source: 'direct'));
    });
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _start() {
    _totalSeconds = _selectedMinutes * 60;
    _remainingSeconds = _totalSeconds;
    _isRunning = true;
    _pulseController.repeat(reverse: true);
    HapticFeedback.mediumImpact();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remainingSeconds <= 1) {
        _complete();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
    setState(() {});
  }

  void _pause() {
    _timer?.cancel();
    _pulseController.stop();
    setState(() => _isRunning = false);
  }

  void _resume() {
    _isRunning = true;
    _pulseController.repeat(reverse: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remainingSeconds <= 1) {
        _complete();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
    setState(() {});
  }

  void _reset() {
    _timer?.cancel();
    _pulseController.stop();
    _pulseController.reset();
    setState(() {
      _isRunning = false;
      _remainingSeconds = 0;
      _totalSeconds = 0;
    });
  }

  void _complete() {
    _timer?.cancel();
    _pulseController.stop();
    HapticFeedback.heavyImpact();
    if (!mounted) return;
    setState(() {
      _isRunning = false;
      _remainingSeconds = 0;
    });

    final language = ref.read(languageProvider);
    final isEn = language == AppLanguage.en;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          L10nService.get('meditation.meditation_timer.session_complete_well_done', isEn ? AppLanguage.en : AppLanguage.tr),
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final hasStarted = _totalSeconds > 0;
    final progress = _totalSeconds > 0
        ? 1.0 - (_remainingSeconds / _totalSeconds)
        : 0.0;

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CupertinoScrollbar(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                GlassSliverAppBar(title: L10nService.get('meditation.meditation_timer.meditation', isEn ? AppLanguage.en : AppLanguage.tr)),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Duration selector
                        if (!hasStarted) ...[
                          GradientText(
                            L10nService.get('meditation.meditation_timer.choose_duration', isEn ? AppLanguage.en : AppLanguage.tr),
                            variant: GradientTextVariant.aurora,
                            style: AppTypography.displayFont.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _presets.map((m) {
                              final isSelected = m == _selectedMinutes;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Semantics(
                                  label: L10nService.getWithParams('meditation.timer.n_minutes', isEn ? AppLanguage.en : AppLanguage.tr, params: {'count': '$m'}),
                                  button: true,
                                  selected: isSelected,
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() => _selectedMinutes = m),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? AppColors.cosmicPurple.withValues(
                                                alpha: 0.3,
                                              )
                                            : (isDark
                                                  ? AppColors.surfaceDark
                                                  : AppColors
                                                        .lightSurfaceVariant),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.cosmicPurple
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${m}m',
                                          style: AppTypography.elegantAccent(
                                            fontSize: 16,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                            color: isSelected
                                                ? AppColors.cosmicPurple
                                                : (isDark
                                                      ? AppColors.textSecondary
                                                      : AppColors
                                                            .lightTextSecondary),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],

                        const Spacer(),

                        // Timer ring
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            final pulse = hasStarted && _isRunning
                                ? 1.0 + (_pulseController.value * 0.03)
                                : 1.0;
                            return Transform.scale(
                              scale: pulse,
                              child: SizedBox(
                                width: 220,
                                height: 220,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Background ring
                                    SizedBox(
                                      width: 220,
                                      height: 220,
                                      child: CircularProgressIndicator(
                                        value: 1.0,
                                        strokeWidth: 6,
                                        color: isDark
                                            ? Colors.white.withValues(
                                                alpha: 0.06,
                                              )
                                            : Colors.black.withValues(
                                                alpha: 0.04,
                                              ),
                                      ),
                                    ),
                                    // Progress ring
                                    SizedBox(
                                      width: 220,
                                      height: 220,
                                      child: CircularProgressIndicator(
                                        value: progress,
                                        strokeWidth: 6,
                                        strokeCap: StrokeCap.round,
                                        color: AppColors.cosmicPurple,
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                    // Center content
                                    Semantics(
                                      liveRegion: _isRunning,
                                      label: hasStarted
                                          ? (isEn
                                                ? '${_formatTime(_remainingSeconds)} remaining'
                                                : '${_formatTime(_remainingSeconds)} kaldı')
                                          : (isEn
                                                ? '$_selectedMinutes minutes selected'
                                                : '$_selectedMinutes dakika seçildi'),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (hasStarted) ...[
                                            Text(
                                              _formatTime(_remainingSeconds),
                                              style: AppTypography.displayFont
                                                  .copyWith(
                                                    fontSize: 44,
                                                    fontWeight: FontWeight.w300,
                                                    color: isDark
                                                        ? Colors.white
                                                        : AppColors
                                                              .lightTextPrimary,
                                                    letterSpacing: 2,
                                                  ),
                                            ),
                                            Text(
                                              _isRunning
                                                  ? (L10nService.get('meditation.meditation_timer.be_present', isEn ? AppLanguage.en : AppLanguage.tr))
                                                  : (L10nService.get('meditation.meditation_timer.paused', isEn ? AppLanguage.en : AppLanguage.tr)),
                                              style:
                                                  AppTypography.decorativeScript(
                                                    fontSize: 14,
                                                    color: AppColors
                                                        .cosmicPurple
                                                        .withValues(alpha: 0.8),
                                                  ),
                                            ),
                                          ] else ...[
                                            Icon(
                                              Icons.self_improvement,
                                              size: 56,
                                              color: AppColors.cosmicPurple
                                                  .withValues(alpha: 0.5),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '$_selectedMinutes ${L10nService.get('meditation.meditation_timer.min', isEn ? AppLanguage.en : AppLanguage.tr)}',
                                              style: AppTypography.modernAccent(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: isDark
                                                    ? AppColors.textSecondary
                                                    : AppColors
                                                          .lightTextSecondary,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 32),

                        // Motivational text
                        if (_isRunning)
                          Text(
                            L10nService.get('meditation.meditation_timer.focus_on_your_breath', isEn ? AppLanguage.en : AppLanguage.tr),
                            style: AppTypography.decorativeScript(
                              fontSize: 16,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),

                        const Spacer(),

                        // Controls
                        if (!hasStarted)
                          GradientButton(
                            label: L10nService.get('meditation.meditation_timer.begin_meditation', isEn ? AppLanguage.en : AppLanguage.tr),
                            onPressed: _start,
                            expanded: true,
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.cosmicPurple,
                                AppColors.auroraEnd,
                              ],
                            ),
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 56,
                                  child: GradientOutlinedButton(
                                    label: L10nService.get('meditation.meditation_timer.reset', isEn ? AppLanguage.en : AppLanguage.tr),
                                    variant: GradientTextVariant.aurora,
                                    expanded: true,
                                    fontSize: 16,
                                    borderRadius: 16,
                                    onPressed: _reset,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: GradientButton(
                                  label: _isRunning
                                      ? (L10nService.get('meditation.meditation_timer.pause', isEn ? AppLanguage.en : AppLanguage.tr))
                                      : (L10nService.get('meditation.meditation_timer.resume', isEn ? AppLanguage.en : AppLanguage.tr)),
                                  onPressed: _isRunning ? _pause : _resume,
                                  expanded: true,
                                  gradient: LinearGradient(
                                    colors: _isRunning
                                        ? [
                                            AppColors.warning,
                                            AppColors.warning.withValues(
                                              alpha: 0.8,
                                            ),
                                          ]
                                        : [
                                            AppColors.cosmicPurple,
                                            AppColors.auroraEnd,
                                          ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.02, duration: 400.ms),
        ),
      ),
    );
  }
}
