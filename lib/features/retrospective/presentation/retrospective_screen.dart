// ════════════════════════════════════════════════════════════════════════════
// RETROSPECTIVE SCREEN - Guided Past Journaling Flow (4 Steps)
// ════════════════════════════════════════════════════════════════════════════
// Step 1: Welcome — "Your story didn't start today"
// Step 2: Day Selection — Category-grouped grid of presets
// Step 3: Date Entry — Date picker + prompt for each selected day
// Step 4: Summary — Congrats, return to Today Feed
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/themed_picker.dart';
import '../../../data/content/important_date_presets.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/haptic_service.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_outlined_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/cosmic_background.dart';

class RetrospectiveScreen extends ConsumerStatefulWidget {
  const RetrospectiveScreen({super.key});

  @override
  ConsumerState<RetrospectiveScreen> createState() =>
      _RetrospectiveScreenState();
}

class _RetrospectiveScreenState extends ConsumerState<RetrospectiveScreen> {
  final _pageController = PageController();
  int _currentStep = 0;

  // Step 2 state: selected preset keys
  final Set<String> _selectedPresets = {};

  // Step 3 state: date entries per preset key
  final Map<String, DateTime> _presetDates = {};

  // Track saved retrospective IDs
  final List<String> _savedIds = [];
  int _journalsSaved = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Step indicator
              _StepIndicator(currentStep: _currentStep, isDark: isDark),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _WelcomeStep(
                      isEn: isEn,
                      isDark: isDark,
                      onContinue: () => _goToStep(1),
                    ),
                    _DaySelectionStep(
                      isEn: isEn,
                      isDark: isDark,
                      selectedPresets: _selectedPresets,
                      onToggle: (key) {
                        setState(() {
                          if (_selectedPresets.contains(key)) {
                            _selectedPresets.remove(key);
                          } else {
                            _selectedPresets.add(key);
                          }
                        });
                      },
                      onContinue: () => _goToStep(2),
                    ),
                    _DateEntryStep(
                      isEn: isEn,
                      isDark: isDark,
                      selectedPresets: _selectedPresets,
                      presetDates: _presetDates,
                      onDateChanged: (key, date) {
                        setState(() => _presetDates[key] = date);
                      },
                      onSaveAll: _saveAllDates,
                      onJournalTap: _openJournal,
                    ),
                    _SummaryStep(
                      isEn: isEn,
                      isDark: isDark,
                      savedCount: _savedIds.length,
                      journalCount: _journalsSaved,
                      onDone: () => context.go(Routes.today),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveAllDates() async {
    final service = await ref.read(retrospectiveDateServiceProvider.future);
    _savedIds.clear();
    for (final key in _selectedPresets) {
      final date = _presetDates[key];
      if (date != null) {
        final saved = await service.saveDate(presetKey: key, date: date);
        _savedIds.add(saved.id);
      }
    }
    if (!mounted) return;
    _goToStep(3);
  }

  void _openJournal(String presetKey) {
    final preset = ImportantDatePresets.getByKey(presetKey);
    if (preset == null) return;
    final date = _presetDates[presetKey];
    if (date == null) return;

    final isEn = ref.read(languageProvider) == AppLanguage.en;

    // Find the retrospective ID for this preset
    String? retroId;
    for (int i = 0; i < _savedIds.length; i++) {
      final keys = _selectedPresets.toList();
      if (i < keys.length && keys[i] == presetKey) {
        retroId = _savedIds[i];
        break;
      }
    }

    context.push(
      Routes.journal,
      extra: {
        'initialDate': date,
        'journalPrompt': preset.prompt(isEn),
        'retrospectiveDateId': retroId,
      },
    );
    setState(() => _journalsSaved++);
  }
}

// ════════════════════════════════════════════════════════════════════════════
// STEP INDICATOR
// ════════════════════════════════════════════════════════════════════════════

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final bool isDark;

  const _StepIndicator({required this.currentStep, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Step ${currentStep + 1} of 4',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        child: Row(
          children: List.generate(4, (i) {
            final isActive = i <= currentStep;
            return Expanded(
              child: Container(
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: isActive
                      ? AppColors.starGold
                      : (isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.08)),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// STEP 1: WELCOME
// ════════════════════════════════════════════════════════════════════════════

class _WelcomeStep extends StatelessWidget {
  final bool isEn;
  final bool isDark;
  final VoidCallback onContinue;

  const _WelcomeStep({
    required this.isEn,
    required this.isDark,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppSymbol.hero('\u{1F4D6}').animate().scale(
            begin: const Offset(0.5, 0.5),
            end: const Offset(1, 1),
            duration: 600.ms,
            curve: Curves.elasticOut,
          ),
          const SizedBox(height: 32),
          GradientText(
            isEn ? 'Your story didn\'t start today' : 'Hikayen bugün başlamadı',
            variant: GradientTextVariant.aurora,
            textAlign: TextAlign.center,
            style: AppTypography.displayFont.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          const SizedBox(height: 16),
          Text(
            isEn
                ? 'Add journal entries for the most meaningful days in your past. Reflect on what shaped you.'
                : 'Geçmişindeki en anlamlı günler için günlük kayıtları ekle. Seni şekillendiren şeyleri düşün.',
            textAlign: TextAlign.center,
            style: AppTypography.decorativeScript(
              fontSize: 16,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ).animate().fadeIn(delay: 350.ms, duration: 400.ms),
          const SizedBox(height: 48),
          GradientButton.gold(
            label: isEn ? 'Let\'s Begin' : 'Başlayalım',
            onPressed: () {
              HapticService.buttonPress();
              onContinue();
            },
            expanded: true,
          ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// STEP 2: DAY SELECTION
// ════════════════════════════════════════════════════════════════════════════

class _DaySelectionStep extends StatelessWidget {
  final bool isEn;
  final bool isDark;
  final Set<String> selectedPresets;
  final ValueChanged<String> onToggle;
  final VoidCallback onContinue;

  const _DaySelectionStep({
    required this.isEn,
    required this.isDark,
    required this.selectedPresets,
    required this.onToggle,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
          child: GradientText(
            isEn
                ? 'Choose the days that matter to you'
                : 'Senin için önemli günleri seç',
            variant: GradientTextVariant.gold,
            style: AppTypography.displayFont.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            children: ImportantDateCategory.values.map((category) {
              final presets = ImportantDatePresets.byCategory(category);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, top: 12, bottom: 8),
                    child: Text(
                      category.label(isEn),
                      style: AppTypography.elegantAccent(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.starGold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: presets.map((preset) {
                      final selected = selectedPresets.contains(preset.key);
                      return Semantics(
                        label:
                            '${preset.name(isEn)}, ${selected ? (isEn ? 'selected' : 'seçili') : (isEn ? 'not selected' : 'seçili değil')}',
                        button: true,
                        selected: selected,
                        child: GestureDetector(
                          onTap: () {
                            HapticService.selectionTap();
                            onToggle(preset.key);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.starGold.withValues(alpha: 0.2)
                                  : (isDark
                                        ? AppColors.surfaceDark.withValues(
                                            alpha: 0.5,
                                          )
                                        : AppColors.lightSurfaceVariant),
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusFull,
                              ),
                              border: Border.all(
                                color: selected
                                    ? AppColors.starGold
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppSymbol(preset.emoji, size: AppSymbolSize.sm),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    preset.name(isEn),
                                    style:
                                        AppTypography.elegantAccent(
                                          fontSize: 13,
                                          color: selected
                                              ? AppColors.starGold
                                              : (isDark
                                                    ? AppColors.textPrimary
                                                    : AppColors
                                                          .lightTextPrimary),
                                        ).copyWith(
                                          fontWeight: selected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: GradientButton.gold(
            label: isEn
                ? 'Continue (${selectedPresets.length} selected)'
                : 'Devam (${selectedPresets.length} seçili)',
            onPressed: selectedPresets.isEmpty
                ? null
                : () {
                    HapticService.buttonPress();
                    onContinue();
                  },
            expanded: true,
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// STEP 3: DATE ENTRY + JOURNAL
// ════════════════════════════════════════════════════════════════════════════

class _DateEntryStep extends StatelessWidget {
  final bool isEn;
  final bool isDark;
  final Set<String> selectedPresets;
  final Map<String, DateTime> presetDates;
  final void Function(String key, DateTime date) onDateChanged;
  final VoidCallback onSaveAll;
  final ValueChanged<String> onJournalTap;

  const _DateEntryStep({
    required this.isEn,
    required this.isDark,
    required this.selectedPresets,
    required this.presetDates,
    required this.onDateChanged,
    required this.onSaveAll,
    required this.onJournalTap,
  });

  @override
  Widget build(BuildContext context) {
    final presets = selectedPresets
        .map((k) => ImportantDatePresets.getByKey(k))
        .where((p) => p != null)
        .cast<ImportantDatePreset>()
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
          child: GradientText(
            isEn ? 'When did these happen?' : 'Bunlar ne zaman oldu?',
            variant: GradientTextVariant.gold,
            style: AppTypography.displayFont.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            itemCount: presets.length,
            itemBuilder: (context, index) {
              final preset = presets[index];
              final date = presetDates[preset.key];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: PremiumCard(
                  style: PremiumCardStyle.subtle,
                  borderRadius: AppConstants.radiusMd,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppSymbol.card(preset.emoji),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              preset.name(isEn),
                              style: AppTypography.displayFont.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        preset.prompt(isEn),
                        style: AppTypography.decorativeScript(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: GradientOutlinedButton(
                              label: date != null
                                  ? '${date.day}.${date.month}.${date.year}'
                                  : (isEn ? 'Pick a date' : 'Tarih seç'),
                              icon: Icons.calendar_today,
                              variant: GradientTextVariant.gold,
                              expanded: true,
                              fontSize: 13,
                              onPressed: () async {
                                final picked = await ThemedPicker.showDate(
                                  context,
                                  initialDate: date ?? DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  onDateChanged(preset.key, picked);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(
                delay: Duration(milliseconds: 80 * index),
                duration: 300.ms,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: GradientButton.gold(
            label: isEn
                ? 'Save ${presetDates.length} memories'
                : '${presetDates.length} anıyı kaydet',
            onPressed: presetDates.isEmpty
                ? null
                : () {
                    HapticService.buttonPress();
                    onSaveAll();
                  },
            expanded: true,
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// STEP 4: SUMMARY
// ════════════════════════════════════════════════════════════════════════════

class _SummaryStep extends StatelessWidget {
  final bool isEn;
  final bool isDark;
  final int savedCount;
  final int journalCount;
  final VoidCallback onDone;

  const _SummaryStep({
    required this.isEn,
    required this.isDark,
    required this.savedCount,
    required this.journalCount,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppSymbol.hero('\u{2728}').animate().scale(
            begin: const Offset(0.3, 0.3),
            end: const Offset(1, 1),
            duration: 600.ms,
            curve: Curves.elasticOut,
          ),
          const SizedBox(height: 32),
          GradientText(
            isEn ? '$savedCount memories saved' : '$savedCount anı kaydedildi',
            variant: GradientTextVariant.aurora,
            textAlign: TextAlign.center,
            style: AppTypography.displayFont.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          const SizedBox(height: 16),
          Text(
            isEn
                ? 'Your past is now part of your journey. Come back anytime to write about these days.'
                : 'Geçmişin artık yolculuğunun bir parçası. Bu günler hakkında yazmak için istediğin zaman geri dön.',
            textAlign: TextAlign.center,
            style: AppTypography.decorativeScript(
              fontSize: 16,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ).animate().fadeIn(delay: 350.ms, duration: 400.ms),
          const SizedBox(height: 48),
          GradientButton.gold(
            label: isEn ? 'Back to Home' : 'Ana Sayfaya Dön',
            onPressed: () {
              HapticService.buttonPress();
              onDone();
            },
            expanded: true,
          ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
        ],
      ),
    );
  }
}
