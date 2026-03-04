// ════════════════════════════════════════════════════════════════════════════
// BREATHING TIMER SCREEN - Guided Breathing Exercises
// ════════════════════════════════════════════════════════════════════════════
// 3 presets: 4-7-8 Relaxation, Box Breathing, Calming Breath.
// Animated expanding/contracting circle with haptic feedback.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/ambient_audio_service.dart';
import '../../../data/services/haptic_service.dart';
import '../../../data/services/smart_router_service.dart';
import '../../../data/services/ecosystem_analytics_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../data/services/l10n_service.dart';

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
        return [BreathPhase.inhale(5), BreathPhase.exhale(5)];
    }
  }

  int get totalCycleSeconds => phases.fold(0, (sum, p) => sum + p.seconds);

  String localizedName(AppLanguage language) =>
      language == AppLanguage.en ? nameEn() : nameTr();

  String localizedDesc(AppLanguage language) =>
      language == AppLanguage.en ? descEn() : descTr();
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

  String localizedLabel(AppLanguage language) =>
      language == AppLanguage.en ? labelEn() : labelTr();
}

class BreathingTimerScreen extends ConsumerStatefulWidget {
  const BreathingTimerScreen({super.key});

  @override
  ConsumerState<BreathingTimerScreen> createState() =>
      _BreathingTimerScreenState();
}

class _BreathingTimerScreenState extends ConsumerState<BreathingTimerScreen>
    with SingleTickerProviderStateMixin {
  BreathingPreset _preset = BreathingPreset.relaxation478;
  bool _isRunning = false;
  int _completedCycles = 0;
  int _currentPhaseIndex = 0;
  int _phaseCountdown = 0;
  Timer? _timer;

  // Ambient audio
  AmbientSound _ambientSound = AmbientSound.none;
  double _ambientVolume = 0.3;
  final _audioService = AmbientAudioService.instance;

  late AnimationController _breathController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(smartRouterServiceProvider)
          .whenData((s) => s.recordToolVisit('breathing'));
      ref
          .read(ecosystemAnalyticsServiceProvider)
          .whenData((s) => s.trackToolOpen('breathing', source: 'direct'));
    });
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _loadAmbientPreference();
  }

  Future<void> _loadAmbientPreference() async {
    await _audioService.loadPreference();
    if (mounted) {
      setState(() {
        _ambientSound = _audioService.savedPreference;
        _ambientVolume = _audioService.volume;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breathController.dispose();
    _audioService.stop();
    super.dispose();
  }

  void _start() {
    setState(() {
      _isRunning = true;
      _completedCycles = 0;
      _currentPhaseIndex = 0;
    });
    _startPhase();
    // Start ambient audio if selected
    if (_ambientSound != AmbientSound.none) {
      _audioService.play(_ambientSound);
    }
  }

  void _stop() {
    _timer?.cancel();
    _breathController.stop();
    _audioService.stop();
    setState(() => _isRunning = false);
  }

  void _startPhase() {
    if (!mounted) return;
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

    HapticService.breathingPhase();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
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
      HapticService.success();
      _incrementBreathingCount();
    }

    if (_isRunning) {
      _startPhase();
    }
  }

  Future<void> _incrementBreathingCount() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt('mindfulness_breathing_count') ?? 0;
    await prefs.setInt('mindfulness_breathing_count', count + 1);
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;

    final currentPhase = _isRunning ? _preset.phases[_currentPhaseIndex] : null;

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
                  title: L10nService.get('breathing.breathing_timer.guided_breathwork', language),
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
                          _preset.localizedDesc(language),
                          style: AppTypography.decorativeScript(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Ambient sound selector
                        _AmbientSoundSelector(
                          current: _ambientSound,
                          volume: _ambientVolume,
                          isEn: isEn,
                          isDark: isDark,
                          enabled: !_isRunning,
                          onChanged: (s) {
                            setState(() => _ambientSound = s);
                            _audioService.savePreference(s, _ambientVolume);
                            if (s != AmbientSound.none && !_isRunning) {
                              _audioService.play(s);
                              Future.delayed(
                                const Duration(seconds: 3),
                                () {
                                  if (!_isRunning) _audioService.stop();
                                },
                              );
                            } else {
                              _audioService.stop();
                            }
                          },
                          onVolumeChanged: (v) {
                            setState(() => _ambientVolume = v);
                            _audioService.setVolume(v);
                            _audioService.savePreference(_ambientSound, v);
                          },
                        ),

                        const Spacer(),

                        // Breath circle
                        Semantics(
                          label: _isRunning && currentPhase != null
                              ? (isEn
                                    ? '${currentPhase.labelEn()}, $_phaseCountdown seconds'
                                    : '${currentPhase.labelTr()}, $_phaseCountdown saniye')
                              : (L10nService.get('breathing.breathing_timer.breathing_circle_tap_start_to_begin', language)),
                          liveRegion: _isRunning,
                          child: AnimatedBuilder(
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
                                      AppColors.auroraStart.withValues(
                                        alpha: 0.4,
                                      ),
                                      AppColors.auroraStart.withValues(
                                        alpha: 0.1,
                                      ),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: AppColors.auroraStart.withValues(
                                      alpha: 0.4,
                                    ),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.auroraStart.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 30 * scale,
                                      spreadRadius: 5 * scale,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (_isRunning &&
                                          currentPhase != null) ...[
                                        Text(
                                          isEn
                                              ? currentPhase.labelEn()
                                              : currentPhase.labelTr(),
                                          style: AppTypography.decorativeScript(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? Colors.white
                                                : AppColors.lightTextPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        GradientText(
                                          '$_phaseCountdown',
                                          variant: GradientTextVariant.aurora,
                                          style: AppTypography.displayFont
                                              .copyWith(
                                                fontSize: 40,
                                                fontWeight: FontWeight.w300,
                                                letterSpacing: 2,
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
                        ),

                        const SizedBox(height: 24),

                        // Cycle counter
                        if (_completedCycles > 0) ...[
                          Text(
                            isEn
                                ? '$_completedCycles ${_completedCycles == 1 ? 'cycle' : 'cycles'} completed'
                                : '$_completedCycles döngü tamamlandı',
                            style: AppTypography.subtitle(
                              fontSize: 14,
                              color: AppColors.success,
                            ),
                          ),
                          if (!_isRunning && _completedCycles >= 2) ...[
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                HapticService.buttonPress();
                                final presetName = isEn
                                    ? _preset.nameEn()
                                    : _preset.nameTr();
                                final msg = isEn
                                    ? 'Just completed $_completedCycles cycles of $presetName breathing on InnerCycles. Feeling centered.\n\n${AppConstants.appStoreUrl}\n#InnerCycles #Breathing #Mindfulness'
                                    : 'InnerCycles\'da $_completedCycles döngü $presetName nefes egzersizi tamamladım. Kendimi merkezde hissediyorum.\n\n${AppConstants.appStoreUrl}\n#InnerCycles';
                                SharePlus.instance.share(ShareParams(text: msg));
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.share_rounded,
                                    size: 14,
                                    color: AppColors.starGold.withValues(alpha: 0.7),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    L10nService.get('breathing.breathing_timer.share_session', language),
                                    style: AppTypography.elegantAccent(
                                      fontSize: 12,
                                      color: AppColors.starGold.withValues(alpha: 0.7),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],

                        const Spacer(),

                        // Start/Stop button
                        if (_isRunning)
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: GestureDetector(
                              onTap: _stop,
                              child: Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.error.withValues(alpha: 0.9),
                                      AppColors.error.withValues(alpha: 0.7),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.error.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    L10nService.get('breathing.breathing_timer.stop', language),
                                    style: AppTypography.modernAccent(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          GradientButton(
                            label: L10nService.get('breathing.breathing_timer.start_breathing', language),
                            onPressed: _start,
                            expanded: true,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.auroraStart,
                                AppColors.auroraEnd,
                              ],
                            ),
                          ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.02, duration: 400.ms),
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
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 0,
      runSpacing: 8,
      children: BreathingPreset.values.map((preset) {
        final language = AppLanguage.fromIsEn(isEn);
        final isSelected = preset == current;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Semantics(
            label: preset.localizedName(language),
            button: true,
            selected: isSelected,
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
                  preset.localizedName(language),
                  style: AppTypography.elegantAccent(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.auroraStart
                        : (isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _AmbientSoundSelector extends StatelessWidget {
  final AmbientSound current;
  final double volume;
  final bool isEn;
  final bool isDark;
  final bool enabled;
  final ValueChanged<AmbientSound> onChanged;
  final ValueChanged<double> onVolumeChanged;

  const _AmbientSoundSelector({
    required this.current,
    required this.volume,
    required this.isEn,
    required this.isDark,
    required this.enabled,
    required this.onChanged,
    required this.onVolumeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final language = AppLanguage.fromIsEn(isEn);
    return Column(
      children: [
        // Label
        Text(
          isEn ? 'Ambient Sound' : 'Ortam Sesi',
          style: AppTypography.elegantAccent(
            fontSize: 12,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 8),

        // Sound chips
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 0,
          runSpacing: 8,
          children: AmbientSound.values.map((sound) {
            final isSelected = sound == current;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Semantics(
                label: sound.localizedName(language),
                button: true,
                selected: isSelected,
                child: GestureDetector(
                  onTap: enabled ? () => onChanged(sound) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.starGold.withValues(alpha: 0.2)
                          : (isDark
                                ? AppColors.surfaceDark
                                : AppColors.lightSurfaceVariant),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.starGold.withValues(alpha: 0.5)
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          sound.icon,
                          size: 14,
                          color: isSelected
                              ? AppColors.starGold
                              : (isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          sound.localizedName(language),
                          style: AppTypography.elegantAccent(
                            fontSize: 11,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? AppColors.starGold
                                : (isDark
                                      ? AppColors.textSecondary
                                      : AppColors.lightTextSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        // Volume slider (only when a sound is selected)
        if (current != AmbientSound.none) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: 200,
            child: Row(
              children: [
                Icon(
                  Icons.volume_down_rounded,
                  size: 16,
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 2,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6,
                      ),
                      activeTrackColor: AppColors.starGold,
                      inactiveTrackColor: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.08),
                      thumbColor: AppColors.starGold,
                      overlayColor: AppColors.starGold.withValues(alpha: 0.1),
                    ),
                    child: Slider(
                      value: volume,
                      min: 0.05,
                      max: 1.0,
                      onChanged: enabled ? onVolumeChanged : null,
                    ),
                  ),
                ),
                Icon(
                  Icons.volume_up_rounded,
                  size: 16,
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
              ],
            ),
          ),
          if (current == AmbientSound.binauralCalm)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                isEn ? 'Use headphones' : 'Kulaklık kullanın',
                style: AppTypography.subtitle(
                  fontSize: 10,
                  color: AppColors.starGold.withValues(alpha: 0.7),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
