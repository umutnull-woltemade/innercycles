// ════════════════════════════════════════════════════════════════════════════
// WORD CLOUD SCREEN - Visual word frequency from journal entries
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/word_cloud_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';

class WordCloudScreen extends ConsumerStatefulWidget {
  const WordCloudScreen({super.key});

  @override
  ConsumerState<WordCloudScreen> createState() => _WordCloudScreenState();
}

class _WordCloudScreenState extends ConsumerState<WordCloudScreen> {
  int _rangeDays = 30;

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(wordCloudServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (service) {
              final words = service.getTopWords(days: _rangeDays, limit: 30);

              return CustomScrollView(
                slivers: [
                  GlassSliverAppBar(
                    title: isEn ? 'Word Cloud' : 'Kelime Bulutu',
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          // Range picker
                          Row(
                            children: [7, 14, 30, 90].map((d) {
                              final selected = d == _rangeDays;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => _rangeDays = d),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? AppColors.starGold
                                              .withValues(alpha: 0.2)
                                          : (isDark
                                              ? Colors.white
                                                  .withValues(alpha: 0.05)
                                              : Colors.black
                                                  .withValues(alpha: 0.04)),
                                      borderRadius: BorderRadius.circular(16),
                                      border: selected
                                          ? Border.all(
                                              color: AppColors.starGold
                                                  .withValues(alpha: 0.5))
                                          : null,
                                    ),
                                    child: Text(
                                      '${d}d',
                                      style: AppTypography.modernAccent(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: selected
                                            ? AppColors.starGold
                                            : (isDark
                                                ? AppColors.textSecondary
                                                : AppColors
                                                    .lightTextSecondary),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 20),

                          if (words.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 60),
                              child: Center(
                                child: Column(
                                  children: [
                                    const Text('\u{2601}\u{FE0F}',
                                        style: TextStyle(fontSize: 44)),
                                    const SizedBox(height: 12),
                                    Text(
                                      isEn
                                          ? 'Write more to see your word cloud'
                                          : 'Kelime bulutunu g\u00f6rmek i\u00e7in daha fazla yaz',
                                      style: AppTypography.decorativeScript(
                                        fontSize: 14,
                                        color: isDark
                                            ? AppColors.textSecondary
                                            : AppColors.lightTextSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else ...[
                            GradientText(
                              isEn ? 'Your Words' : 'Kelimelerin',
                              variant: GradientTextVariant.gold,
                              style: AppTypography.modernAccent(fontSize: 16),
                            ),
                            const SizedBox(height: 12),

                            // Word cloud as wrapped chips with varying sizes
                            SizedBox(
                              height: 280,
                              child: CustomPaint(
                                painter: _WordCloudPainter(
                                  words: words,
                                  isDark: isDark,
                                ),
                                size: Size.infinite,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Top words list
                            GradientText(
                              isEn ? 'Most Used' : 'En \u00c7ok Kullan\u0131lan',
                              variant: GradientTextVariant.amethyst,
                              style: AppTypography.modernAccent(fontSize: 15),
                            ),
                            const SizedBox(height: 10),
                            ...words.take(10).toList().asMap().entries.map((e) {
                              final w = e.value;
                              final maxCount = words.first.count;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      child: Text(
                                        '${e.key + 1}',
                                        style: AppTypography.modernAccent(
                                          fontSize: 12,
                                          color: AppColors.starGold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        w.word,
                                        style: AppTypography.modernAccent(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: isDark
                                              ? AppColors.textPrimary
                                              : AppColors.lightTextPrimary,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(3),
                                        child: LinearProgressIndicator(
                                          value: w.count / maxCount,
                                          backgroundColor: isDark
                                              ? Colors.white
                                                  .withValues(alpha: 0.06)
                                              : Colors.black
                                                  .withValues(alpha: 0.04),
                                          valueColor:
                                              AlwaysStoppedAnimation(
                                            AppColors.starGold
                                                .withValues(alpha: 0.5),
                                          ),
                                          minHeight: 6,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${w.count}x',
                                      style: AppTypography.elegantAccent(
                                        fontSize: 11,
                                        color: isDark
                                            ? AppColors.textMuted
                                            : AppColors.lightTextMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WordCloudPainter extends CustomPainter {
  final List<WordFrequency> words;
  final bool isDark;

  _WordCloudPainter({required this.words, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    if (words.isEmpty) return;

    final maxCount = words.first.count;
    final random = math.Random(42);
    final colors = [
      AppColors.starGold,
      AppColors.celestialGold,
      AppColors.amethyst,
      const Color(0xFFD4A07A),
      const Color(0xFFB8956A),
    ];

    final placed = <Rect>[];

    for (int i = 0; i < words.length && i < 25; i++) {
      final w = words[i];
      final ratio = w.count / maxCount;
      final fontSize = 12 + ratio * 28;
      final color = colors[i % colors.length];

      final textPainter = TextPainter(
        text: TextSpan(
          text: w.word,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: ratio > 0.5 ? FontWeight.w700 : FontWeight.w400,
            color: color.withValues(alpha: 0.6 + ratio * 0.4),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: size.width - 20);

      // Try to place without overlap
      Offset pos;
      bool found = false;
      for (int attempt = 0; attempt < 50; attempt++) {
        final x = random.nextDouble() * (size.width - textPainter.width);
        final y = random.nextDouble() * (size.height - textPainter.height);
        final rect = Rect.fromLTWH(x, y, textPainter.width, textPainter.height);

        if (!placed.any((r) => r.overlaps(rect.inflate(2)))) {
          pos = Offset(x, y);
          placed.add(rect);
          found = true;
          textPainter.paint(canvas, pos);
          break;
        }
      }
      if (!found && placed.length < 3) {
        // Force place for first few words
        pos = Offset(
          random.nextDouble() * (size.width - textPainter.width).clamp(0, size.width),
          random.nextDouble() * (size.height - textPainter.height).clamp(0, size.height),
        );
        textPainter.paint(canvas, pos);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WordCloudPainter old) =>
      words != old.words || isDark != old.isDark;
}
