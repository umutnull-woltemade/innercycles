// ════════════════════════════════════════════════════════════════════════════
// SPRINT ENTRY SCREEN - 60-second timed journaling mode
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';

class SprintEntryScreen extends ConsumerStatefulWidget {
  const SprintEntryScreen({super.key});

  @override
  ConsumerState<SprintEntryScreen> createState() => _SprintEntryScreenState();
}

class _SprintEntryScreenState extends ConsumerState<SprintEntryScreen>
    with TickerProviderStateMixin {
  static const _totalSeconds = 60;
  late AnimationController _timerController;
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isRunning = false;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _totalSeconds),
    );
    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _finishSprint();
      }
    });
  }

  @override
  void dispose() {
    _timerController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startSprint() {
    setState(() => _isRunning = true);
    _timerController.forward();
    _focusNode.requestFocus();
    HapticFeedback.lightImpact();
  }

  Future<void> _finishSprint() async {
    if (!mounted) return;
    HapticFeedback.heavyImpact();
    _focusNode.unfocus();
    final text = _textController.text.trim();
    final wordCount = text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;

    if (text.isNotEmpty) {
      try {
        final service = await ref.read(journalServiceProvider.future);
        await service.saveEntry(
          date: DateTime.now(),
          focusArea: FocusArea.emotions,
          overallRating: 3,
          note: text,
          tags: ['sprint'],
        );
      } catch (_) {
        // Silently continue — entry save failed but show summary anyway
      }
    }

    if (!mounted) return;
    setState(() {
      _isFinished = true;
      _isRunning = false;
    });

    // Show summary
    if (!mounted) return;
    _showSummary(wordCount);
  }

  void _showSummary(int wordCount) {
    final language = ref.read(languageProvider);
    final isEn = language == AppLanguage.en;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.deepSpace,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEn ? 'Sprint Complete!' : 'Sprint Tamamlandı!',
              style: AppTypography.displayFont.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.starGold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SummaryMetric(
                  value: '$wordCount',
                  label: isEn ? 'words' : 'kelime',
                ),
                _SummaryMetric(
                  value: '60s',
                  label: isEn ? 'time' : 'süre',
                ),
                _SummaryMetric(
                  value: '$wordCount',
                  label: isEn ? 'words/min' : 'kelime/dk',
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              wordCount >= 50
                  ? (isEn ? 'Incredible flow! You wrote with purpose.' : 'İnanılmaz akış! Kararlılıkla yazdın.')
                  : wordCount >= 20
                      ? (isEn ? 'Great start — every word counts.' : 'Harika başlangıç — her kelime önemli.')
                      : (isEn ? 'Even a few words can spark insight.' : 'Birkaç kelime bile farkındalık yaratır.'),
              textAlign: TextAlign.center,
              style: AppTypography.decorativeScript(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      if (context.mounted) context.pop();
                    },
                    child: Text(
                      isEn ? 'Done' : 'Tamam',
                      style: AppTypography.elegantAccent(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      if (!context.mounted) return;
                      setState(() {
                        _isFinished = false;
                        _isRunning = false;
                        _textController.clear();
                        _timerController.reset();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.starGold,
                      foregroundColor: AppColors.deepSpace,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isEn ? 'Sprint Again' : 'Tekrar Sprint',
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
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
              // App bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
                      onPressed: () => context.pop(),
                    ),
                    const Spacer(),
                    Text(
                      isEn ? '60-Second Sprint' : '60 Saniye Sprint',
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Timer ring
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: AnimatedBuilder(
                  animation: _timerController,
                  builder: (context, child) {
                    final remaining = (_totalSeconds * (1 - _timerController.value)).ceil();
                    final isWarning = remaining <= 10 && _isRunning;
                    return SizedBox(
                      width: 80,
                      height: 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(80, 80),
                            painter: _CountdownRingPainter(
                              progress: 1 - _timerController.value,
                              color: isWarning ? AppColors.warning : AppColors.starGold,
                              bgColor: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
                            ),
                          ),
                          Text(
                            '$remaining',
                            style: AppTypography.displayFont.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: isWarning ? AppColors.warning : AppColors.starGold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Text area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    enabled: _isRunning,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: AppTypography.elegantAccent(
                      fontSize: 16,
                      color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: _isRunning
                          ? (isEn ? 'Just write. No thinking, no editing...' : 'Sadece yaz. Düşünme, düzenleme...')
                          : (isEn ? 'Tap Start to begin your sprint' : 'Sprint\'i başlatmak için Başla\'ya dokun'),
                      hintStyle: AppTypography.elegantAccent(
                        fontSize: 16,
                        color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              // Start button
              if (!_isRunning && !_isFinished)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _startSprint,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.starGold,
                        foregroundColor: AppColors.deepSpace,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        isEn ? 'Start Sprint' : 'Sprint Başlat',
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountdownRingPainter extends CustomPainter {
  final double progress; // 1.0 = full, 0.0 = empty
  final Color color;
  final Color bgColor;

  _CountdownRingPainter({
    required this.progress,
    required this.color,
    required this.bgColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Background ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = bgColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    // Progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _CountdownRingPainter old) =>
      old.progress != progress || old.color != color;
}

class _SummaryMetric extends StatelessWidget {
  final String value;
  final String label;

  const _SummaryMetric({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.displayFont.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.starGold,
          ),
        ),
        Text(
          label,
          style: AppTypography.elegantAccent(
            fontSize: 11,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
