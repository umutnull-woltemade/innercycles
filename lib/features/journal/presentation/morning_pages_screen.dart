// ════════════════════════════════════════════════════════════════════════════
// MORNING PAGES SCREEN - Timed free-writing journaling mode
// ════════════════════════════════════════════════════════════════════════════

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';

class MorningPagesScreen extends ConsumerStatefulWidget {
  const MorningPagesScreen({super.key});

  @override
  ConsumerState<MorningPagesScreen> createState() =>
      _MorningPagesScreenState();
}

class _MorningPagesScreenState extends ConsumerState<MorningPagesScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  int _selectedMinutes = 10;
  bool _started = false;
  bool _finished = false;
  int _remainingSeconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    setState(() {
      _started = true;
      _remainingSeconds = _selectedMinutes * 60;
    });
    _focusNode.requestFocus();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remainingSeconds <= 0) {
        _timer?.cancel();
        _finish();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  Future<void> _finish() async {
    _timer?.cancel();
    final wordCount = _controller.text
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .length;

    // Log session
    final morningService = await ref.read(morningPagesServiceProvider.future);
    await morningService.logSession(
      durationMinutes: _selectedMinutes,
      wordCount: wordCount,
    );

    // Save as journal entry if substantial
    if (wordCount >= 10) {
      final journalService = await ref.read(journalServiceProvider.future);
      await journalService.saveEntry(
        date: DateTime.now(),
        focusArea: FocusArea.emotions,
        overallRating: 5,
        note: _controller.text.trim(),
        tags: ['morning-pages'],
      );
    }

    if (mounted) {
      setState(() => _finished = true);
    }
  }

  int get _wordCount => _controller.text
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .length;

  String get _timerDisplay {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  double get _progress {
    if (_selectedMinutes == 0) return 0;
    final total = _selectedMinutes * 60;
    return 1 - (_remainingSeconds / total);
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_finished) {
      return _CompletionView(
        wordCount: _wordCount,
        minutes: _selectedMinutes,
        isEn: isEn,
        isDark: isDark,
        onDone: () => context.pop(),
      );
    }

    if (!_started) {
      return _SetupView(
        selectedMinutes: _selectedMinutes,
        onSelect: (m) => setState(() => _selectedMinutes = m),
        onStart: _start,
        isEn: isEn,
        isDark: isDark,
      );
    }

    // Active writing view
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Timer bar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _finish(),
                      child: Text(
                        isEn ? 'Finish' : 'Bitir',
                        style: AppTypography.modernAccent(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.starGold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _timerDisplay,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        color: _remainingSeconds < 60
                            ? AppColors.starGold
                            : (isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$_wordCount ${isEn ? 'words' : 'kelime'}',
                      style: AppTypography.elegantAccent(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),

              // Progress bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.black.withValues(alpha: 0.04),
                    valueColor: AlwaysStoppedAnimation(
                        AppColors.starGold.withValues(alpha: 0.5)),
                    minHeight: 3,
                  ),
                ),
              ),

              // Writing area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    onChanged: (_) => setState(() {}),
                    style: AppTypography.decorativeScript(
                      fontSize: 16,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ).copyWith(height: 1.8),
                    decoration: InputDecoration(
                      hintText: isEn
                          ? 'Just write. Don\'t think. Let the words flow...'
                          : 'Sadece yaz. D\u00fc\u015f\u00fcnme. Kelimeler aks\u0131n...',
                      hintStyle: AppTypography.decorativeScript(
                        fontSize: 16,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SetupView extends StatelessWidget {
  final int selectedMinutes;
  final ValueChanged<int> onSelect;
  final VoidCallback onStart;
  final bool isEn;
  final bool isDark;

  const _SetupView({
    required this.selectedMinutes,
    required this.onSelect,
    required this.onStart,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final options = [5, 10, 15, 20];

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('\u{2600}\u{FE0F}',
                    style: TextStyle(fontSize: 56)),
                const SizedBox(height: 20),
                Text(
                  isEn ? 'Morning Pages' : 'Sabah Sayfalar\u0131',
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isEn
                      ? 'Stream of consciousness.\nNo editing. No judgment. Just write.'
                      : 'Bilin\u00e7 ak\u0131\u015f\u0131.\nD\u00fczenleme yok. Yarg\u0131 yok. Sadece yaz.',
                  textAlign: TextAlign.center,
                  style: AppTypography.decorativeScript(
                    fontSize: 15,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                // Duration picker
                Text(
                  isEn ? 'How long?' : 'Ne kadar s\u00fcre?',
                  style: AppTypography.modernAccent(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: options.map((m) {
                    final selected = m == selectedMinutes;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: GestureDetector(
                        onTap: () => onSelect(m),
                        child: AnimatedContainer(
                          duration: 200.ms,
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected
                                ? AppColors.starGold
                                    .withValues(alpha: 0.2)
                                : (isDark
                                    ? Colors.white
                                        .withValues(alpha: 0.06)
                                    : Colors.black
                                        .withValues(alpha: 0.04)),
                            border: selected
                                ? Border.all(
                                    color: AppColors.starGold
                                        .withValues(alpha: 0.6),
                                    width: 2)
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              '${m}m',
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? AppColors.starGold
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
                ),

                const SizedBox(height: 32),

                // Start button
                GestureDetector(
                  onTap: onStart,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.starGold,
                          AppColors.celestialGold,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color:
                              AppColors.starGold.withValues(alpha: 0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        isEn ? 'Begin Writing' : 'Yazmaya Ba\u015fla',
                        style: AppTypography.modernAccent(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepSpace,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                GestureDetector(
                  onTap: () => context.pop(),
                  child: Text(
                    isEn ? 'Not now' : '\u015eimdi de\u011fil',
                    style: AppTypography.elegantAccent(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
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

class _CompletionView extends StatelessWidget {
  final int wordCount;
  final int minutes;
  final bool isEn;
  final bool isDark;
  final VoidCallback onDone;

  const _CompletionView({
    required this.wordCount,
    required this.minutes,
    required this.isEn,
    required this.isDark,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('\u{2728}', style: TextStyle(fontSize: 56))
                      .animate()
                      .scale(delay: 200.ms, duration: 400.ms),
                  const SizedBox(height: 20),
                  Text(
                    isEn ? 'Session Complete' : 'Oturum Tamamland\u0131',
                    style: AppTypography.displayFont.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w300,
                      color: AppColors.starGold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatBubble(
                        value: '$wordCount',
                        label: isEn ? 'words' : 'kelime',
                        isDark: isDark,
                      ),
                      const SizedBox(width: 24),
                      _StatBubble(
                        value: '$minutes',
                        label: isEn ? 'minutes' : 'dakika',
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isEn
                        ? 'Your words are saved.\nEvery page is a step toward clarity.'
                        : 'Kelimelerin kaydedildi.\nHer sayfa berrakl\u0131\u011fa bir ad\u0131m.',
                    textAlign: TextAlign.center,
                    style: AppTypography.decorativeScript(
                      fontSize: 15,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: onDone,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.starGold,
                            AppColors.celestialGold,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          isEn ? 'Done' : 'Tamam',
                          style: AppTypography.modernAccent(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepSpace,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatBubble extends StatelessWidget {
  final String value;
  final String label;
  final bool isDark;

  const _StatBubble({
    required this.value,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.displayFont.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w300,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
        Text(
          label,
          style: AppTypography.elegantAccent(
            fontSize: 12,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}
