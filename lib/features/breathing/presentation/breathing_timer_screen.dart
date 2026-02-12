// ════════════════════════════════════════════════════════════════════════════
// BREATHING TIMER SCREEN - Guided Breathing Exercises
// ════════════════════════════════════════════════════════════════════════════
// 3 presets: 4-7-8 Relaxation, Box Breathing, Calming Breath.
// Animated expanding/contracting circle with haptic feedback.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

enum BreathingPreset {
  relaxation478,
  boxBreathing,
  calming55;

  String nameEn() {
    switch (this) {
      case BreathingPreset.relaxation478:
        return '4-7-8 Relaxation';
      case BreathingPreset.boxBreathing:
        return 'Box Breathing';
      case BreathingPreset.calming55:
        return 'Calming Breath';
    }
  }

  String nameTr() {
    switch (this) {
      case BreathingPreset.relaxation478:
        return '4-7-8 Rahatlama';
      case BreathingPreset.boxBreathing:
        return 'Kutu Nefesi';
      case BreathingPreset.calming55:
        return 'Sakinleştirici Nefes';
    }
  }

  String descEn() {
    switch (this) {
      case BreathingPreset.relaxation478:
        return 'Inhale 4s, hold 7s, exhale 8s';
      case BreathingPreset.boxBreathing:
        return 'Inhale 4s, hold 4s, exhale 4s, hold 4s';
      case BreathingPreset.calming55:
        return 'Inhale 5s, exhale 5s';
    }
  }

  String descTr() {
    switch (this) {
      case BreathingPreset.relaxation478:
        return 'Nefes al 4sn, tut 7sn, ver 8sn';
      case BreathingPreset.boxBreathing:
        return 'Nefes al 4sn, tut 4sn, ver 4sn, tut 4sn';
      case BreathingPreset.calming55:
        return 'Nefes al 5sn, ver 5sn';
    }
  }

  /// Returns list of (phase, seconds) tuples
  List<BreathPhase> get phases {
    switch (this) {
      case BreathingPreset.relaxation478:
        return [
          BreathPhase.inhale(4),
          BreathPhase.hold(7),
          BreathPhase.exhale(8),
        ];
      case BreathingPreset.boxBreathing:
        return [
          BreathPhase.inhale(4),
          BreathPhase.hold(4),
          BreathPhase.exhale(4),
          BreathPhase.hold(4),
        ];
      case BreathingPreset.calming55:
        return [
          BreathPhase.inhale(5),
          BreathPhase.exhale(5),
        ];
    }
  }

  int get totalCycleSeconds =>
      phases.fold(0, (sum, p) => sum + p.seconds);
}

enum PhaseType { inhale, hold, exhale }

class BreathPhase {
  final PhaseType type;
  final int seconds;

  const BreathPhase(this.type, this.seconds);
  factory BreathPhase.inhale(int s) => BreathPhase(PhaseType.inhale, s);
  factory BreathPhase.hold(int s) => BreathPhase(PhaseType.hold, s);
  factory BreathPhase.exhale(int s) => BreathPhase(PhaseType.exhale, s);

  String labelEn() {
    switch (type) {
      case PhaseType.inhale:
        return 'Breathe In';
      case PhaseType.hold:
        return 'Hold';
      case PhaseType.exhale:
        return 'Breathe Out';
    }
  }

  String labelTr() {
    switch (type) {
      case PhaseType.inhale:
        return 'Nefes Al';
      case PhaseType.hold:
        return 'Tut';
      case PhaseType.exhale:
        return 'Nefes Ver';
    }
  }
}

class BreathingTimerScreen extends ConsumerStatefulWidget {
  const BreathingTimerScreen({super.key});

  @override
  ConsumerState<BreathingTimerScreen> createState() =>
      _BreathingTimerScreenState();
}

class _BreathingTimerScreenState
    extends ConsumerState<BreathingTimerScreen>
    with SingleTickerProviderStateMixin {
  BreathingPreset _preset = BreathingPreset.relaxation478;
  bool _isRunning = false;
  int _completedCycles = 0;
  int _currentPhaseIndex = 0;
  int _phaseCountdown = 0;
  Timer? _timer;

  late AnimationController _breathController;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breathController.dispose();
    super.dispose();
  }

  void _start() {
    setState(() {
      _isRunning = true;
      _completedCycles = 0;
      _currentPhaseIndex = 0;
    });
    _startPhase();
  }

  void _stop() {
    _timer?.cancel();
    _breathController.stop();
    setState(() => _isRunning = false);
  }

  void _startPhase() {
    final phases = _preset.phases;
    final phase = phases[_currentPhaseIndex];

    setState(() => _phaseCountdown = phase.seconds);

    // Animate breath circle
    _breathController.duration = Duration(seconds: phase.seconds);
    switch (phase.type) {
      case PhaseType.inhale:
        _breathController.forward(from: _breathController.value);
        break;
      case PhaseType.hold:
        // Hold at current position
        break;
      case PhaseType.exhale:
        _breathController.reverse(from: _breathController.value);
        break;
    }

    HapticFeedback.lightImpact();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_phaseCountdown <= 1) {
        timer.cancel();
        _nextPhase();
      } else {
        setState(() => _phaseCountdown--);
      }
    });
  }

  void _nextPhase() {
    final phases = _preset.phases;
    _currentPhaseIndex++;

    if (_currentPhaseIndex >= phases.length) {
      // Cycle complete
      _currentPhaseIndex = 0;
      _completedCycles++;
      HapticFeedback.mediumImpact();
    }

    if (_isRunning) {
      _startPhase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;

    final currentPhase = _isRunning
        ? _preset.phases[_currentPhaseIndex]
        : null;

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CupertinoScrollbar(
            child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              GlassSliverAppBar(
                title: isEn ? 'Breathing' : 'Nefes Egzersizi',
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Preset selector
                      _PresetSelector(
                        current: _preset,
                        isEn: isEn,
                        isDark: isDark,
                        enabled: !_isRunning,
                        onChanged: (p) => setState(() => _preset = p),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isEn ? _preset.descEn() : _preset.descTr(),
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),

                      const Spacer(),

                      // Breath circle
                      AnimatedBuilder(
                        animation: _breathController,
                        builder: (context, child) {
                          final scale =
                              0.5 + (_breathController.value * 0.5);
                          return Container(
                            width: 200 * scale,
                            height: 200 * scale,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  AppColors.auroraStart
                                      .withValues(alpha: 0.4),
                                  AppColors.auroraStart
                                      .withValues(alpha: 0.1),
                                ],
                              ),
                              border: Border.all(
                                color: AppColors.auroraStart
                                    .withValues(alpha: 0.4),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.auroraStart
                                      .withValues(alpha: 0.2),
                                  blurRadius: 30 * scale,
                                  spreadRadius: 5 * scale,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_isRunning && currentPhase != null) ...[
                                    Text(
                                      isEn
                                          ? currentPhase.labelEn()
                                          : currentPhase.labelTr(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white
                                            : AppColors.lightTextPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$_phaseCountdown',
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.auroraStart,
                                      ),
                                    ),
                                  ] else
                                    Icon(
                                      Icons.air,
                                      size: 48,
                                      color: AppColors.auroraStart
                                          .withValues(alpha: 0.6),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Cycle counter
                      if (_completedCycles > 0)
                        Text(
                          isEn
                              ? '$_completedCycles ${_completedCycles == 1 ? 'cycle' : 'cycles'} completed'
                              : '$_completedCycles döngü tamamlandı',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.success,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                      const Spacer(),

                      // Start/Stop button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isRunning ? _stop : _start,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isRunning
                                ? AppColors.error.withValues(alpha: 0.8)
                                : AppColors.auroraStart,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            _isRunning
                                ? (isEn ? 'Stop' : 'Durdur')
                                : (isEn ? 'Start Breathing' : 'Nefese Başla'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}

class _PresetSelector extends StatelessWidget {
  final BreathingPreset current;
  final bool isEn;
  final bool isDark;
  final bool enabled;
  final ValueChanged<BreathingPreset> onChanged;

  const _PresetSelector({
    required this.current,
    required this.isEn,
    required this.isDark,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: BreathingPreset.values.map((preset) {
        final isSelected = preset == current;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: GestureDetector(
            onTap: enabled ? () => onChanged(preset) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.auroraStart.withValues(alpha: 0.2)
                    : (isDark
                        ? AppColors.surfaceDark
                        : AppColors.lightSurfaceVariant),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.auroraStart.withValues(alpha: 0.5)
                      : Colors.transparent,
                ),
              ),
              child: Text(
                isEn ? preset.nameEn() : preset.nameTr(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.auroraStart
                      : (isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
