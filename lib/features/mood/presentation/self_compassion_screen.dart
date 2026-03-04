// ════════════════════════════════════════════════════════════════════════════
// SELF-COMPASSION SCREEN - Deep dive into journal kindness analysis
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/self_compassion_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/sparkline_chart.dart';

class SelfCompassionScreen extends ConsumerWidget {
  const SelfCompassionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(selfCompassionServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (_, _) => Center(child: Text('Something went wrong', style: TextStyle(color: Color(0xFF9E8E82)))),
            data: (service) {
              final score7 = service.computeScore(days: 7);
              final score30 = service.computeScore(days: 30);
              final weeklyScores = service.getWeeklyScores(weeks: 8);

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: isEn ? 'Self-Compassion' : 'Öz Şefkat',
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            isEn
                                ? 'How you talk to yourself matters'
                                : 'Kendine nasıl konuştuğun önemli',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Score hero
                          _ScoreHero(
                            score: score7,
                            isEn: isEn,
                            isDark: isDark,
                          ).animate().fadeIn(duration: 400.ms),

                          const SizedBox(height: 24),

                          // 8-week trend
                          GradientText(
                            isEn ? '8-Week Trend' : '8 Haftalık Trend',
                            variant: GradientTextVariant.amethyst,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 120,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.04)
                                  : Colors.black.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: SparklineChart(
                              data: weeklyScores,
                              lineColor: AppColors.amethyst,
                              fillColor:
                                  AppColors.amethyst.withValues(alpha: 0.15),
                              minValue: 0,
                              maxValue: 100,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Kind vs Harsh breakdown
                          GradientText(
                            isEn ? 'Word Analysis' : 'Kelime Analizi',
                            variant: GradientTextVariant.gold,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _WordBreakdown(
                            score7: score7,
                            score30: score30,
                            isEn: isEn,
                            isDark: isDark,
                          ),

                          const SizedBox(height: 24),

                          // Guided reframes
                          _ReframeSection(
                            tone: score7.dominantTone ?? 'neutral',
                            isEn: isEn,
                            isDark: isDark,
                          ),

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

class _ScoreHero extends StatelessWidget {
  final CompassionScore score;
  final bool isEn;
  final bool isDark;

  const _ScoreHero({
    required this.score,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    String toneEmoji;
    String toneLabel;
    Color toneColor;
    switch (score.dominantTone) {
      case 'kind':
        toneEmoji = '\u{1F49A}';
        toneLabel = isEn ? 'Self-Kind' : 'Öz-Şefkatli';
        toneColor = AppColors.success;
      case 'harsh':
        toneEmoji = '\u{1F494}';
        toneLabel = isEn ? 'Self-Critical' : 'Öz-Eleştirel';
        toneColor = AppColors.warning;
      default:
        toneEmoji = '\u{1F90D}';
        toneLabel = isEn ? 'Balanced' : 'Dengeli';
        toneColor = AppColors.amethyst;
    }

    return PremiumCard(
      style: PremiumCardStyle.amethyst,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(toneEmoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 10),
                Text(
                  toneLabel,
                  style: AppTypography.modernAccent(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: toneColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${score.score.toInt()}',
              style: AppTypography.displayFont.copyWith(
                fontSize: 56,
                fontWeight: FontWeight.w300,
                color: toneColor,
              ),
            ),
            Text(
              isEn ? 'Compassion Score' : 'Şefkat Puanı',
              style: AppTypography.elegantAccent(
                fontSize: 13,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isEn
                  ? 'Based on ${score.totalEntries} journal entries this week'
                  : 'Bu haftaki ${score.totalEntries} günlük girdisine dayalı',
              style: AppTypography.subtitle(
                fontSize: 12,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WordBreakdown extends StatelessWidget {
  final CompassionScore score7;
  final CompassionScore score30;
  final bool isEn;
  final bool isDark;

  const _WordBreakdown({
    required this.score7,
    required this.score30,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _WordCard(
            emoji: '\u{1F49A}',
            label: isEn ? 'Kind Words' : 'Nazik Kelimeler',
            thisWeek: score7.kindWords,
            thisMonth: score30.kindWords,
            color: AppColors.success,
            isEn: isEn,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _WordCard(
            emoji: '\u{1F494}',
            label: isEn ? 'Harsh Words' : 'Sert Kelimeler',
            thisWeek: score7.harshWords,
            thisMonth: score30.harshWords,
            color: AppColors.warning,
            isEn: isEn,
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}

class _WordCard extends StatelessWidget {
  final String emoji;
  final String label;
  final int thisWeek;
  final int thisMonth;
  final Color color;
  final bool isEn;
  final bool isDark;

  const _WordCard({
    required this.emoji,
    required this.label,
    required this.thisWeek,
    required this.thisMonth,
    required this.color,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.modernAccent(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$thisWeek',
            style: AppTypography.displayFont.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            ),
          ),
          Text(
            isEn ? 'this week' : 'bu hafta',
            style: AppTypography.elegantAccent(
              fontSize: 10,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$thisMonth',
            style: AppTypography.modernAccent(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
            ),
          ),
          Text(
            isEn ? 'this month' : 'bu ay',
            style: AppTypography.elegantAccent(
              fontSize: 10,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReframeSection extends StatelessWidget {
  final String tone;
  final bool isEn;
  final bool isDark;

  const _ReframeSection({
    required this.tone,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final reframes = tone == 'harsh'
        ? (isEn ? _harshReframesEn : _harshReframesTr)
        : (isEn ? _kindReframesEn : _kindReframesTr);

    final title = tone == 'harsh'
        ? (isEn ? 'Gentle Reframes' : 'Nazik Yeniden Çerçevelemeler')
        : (isEn ? 'Keep Nurturing' : 'Beslemeye Devam Et');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          title,
          variant: GradientTextVariant.aurora,
          style: AppTypography.modernAccent(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...reframes.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.04)
                      : Colors.black.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.$1, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        r.$2,
                        style: AppTypography.subtitle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  static const _harshReframesEn = [
    ('\u{1F33F}', 'Replace "I should have" with "Next time I can"'),
    ('\u{1F49B}', 'Talk to yourself like you would talk to a close friend'),
    ('\u{2728}', 'Progress isn\'t linear. Every setback is information'),
    ('\u{1F331}', 'You are allowed to be a work in progress'),
  ];

  static const _harshReframesTr = [
    ('\u{1F33F}', '"Yapmalıydım" yerine "Bir dahaki sefere yapabilirim" de'),
    ('\u{1F49B}', 'Kendine yakın bir arkadaşına konuşur gibi konuş'),
    ('\u{2728}', 'İlerleme doğrusal değildir. Her aksilik bir bilgidir'),
    ('\u{1F331}', 'Gelişmekte olan bir süreç olmana izin var'),
  ];

  static const _kindReframesEn = [
    ('\u{1F49A}', 'Your inner voice is warm. Keep that tenderness alive'),
    ('\u{2728}', 'Self-kindness is a skill you\'re building daily'),
    ('\u{1F338}', 'Notice how compassion opens space for growth'),
    ('\u{1F331}', 'You deserve the same care you give others'),
  ];

  static const _kindReframesTr = [
    ('\u{1F49A}', 'İç sesin sıcak. O hassasiyeti canlı tut'),
    ('\u{2728}', 'Öz-şefkat her gün inşa ettiğin bir beceri'),
    ('\u{1F338}', 'Şefkatin büyüme için nasıl alan açtığını fark et'),
    ('\u{1F331}', 'Başkalarına verdiğin özeni sen de hak ediyorsun'),
  ];
}
