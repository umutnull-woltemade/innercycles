import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';

/// Wellness score card for home screen — shows composite score + mini breakdown
class WellnessScoreCard extends ConsumerWidget {
  const WellnessScoreCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final scoreAsync = ref.watch(wellnessScoreProvider);

    return scoreAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (score) {
        if (score == null || score.score == 0) {
          return _EmptyWellnessCard(isDark: isDark, isEn: isEn);
        }

        return GestureDetector(
          onTap: () => context.push(Routes.wellnessDetail),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppColors.surfaceDark.withValues(alpha: 0.9),
                        AppColors.nebulaPurple.withValues(alpha: 0.7),
                      ]
                    : [
                        AppColors.lightCard,
                        AppColors.lightSurfaceVariant,
                      ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _scoreColor(score.score).withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with score
                Row(
                  children: [
                    // Animated score ring
                    _AnimatedScoreRing(
                      score: score.score,
                      color: _scoreColor(score.score),
                      isDark: isDark,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEn ? 'Wellness Score' : 'Sağlık Skoru',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _scoreLabel(score.score, isEn),
                            style: TextStyle(
                              fontSize: 13,
                              color: _scoreColor(score.score),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Mini breakdown bars
                ...score.breakdown.map((b) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: _BreakdownBar(
                        label: _categoryLabel(b.category, isEn),
                        score: b.score,
                        isDark: isDark,
                      ),
                    )),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),
        );
      },
    );
  }

  static Color _scoreColor(int score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.auroraStart;
    if (score >= 40) return AppColors.warning;
    if (score >= 20) return AppColors.sunriseEnd;
    return AppColors.error;
  }

  static String _scoreLabel(int score, bool isEn) {
    if (score >= 80) return isEn ? 'Thriving' : 'Harika';
    if (score >= 60) return isEn ? 'Good balance' : 'İyi denge';
    if (score >= 40) return isEn ? 'Room to grow' : 'Gelişim alanı';
    if (score >= 20) return isEn ? 'Getting started' : 'Başlangıç';
    return isEn ? 'Start logging to build your score' : 'Skorunu oluşturmak için kayıt başlat';
  }

  static String _categoryLabel(String category, bool isEn) {
    switch (category) {
      case 'journal':
        return isEn ? 'Journal' : 'Günlük';
      case 'gratitude':
        return isEn ? 'Gratitude' : 'Şükran';
      case 'rituals':
        return isEn ? 'Rituals' : 'Ritüeller';
      case 'streak':
        return isEn ? 'Consistency' : 'Tutarlılık';
      case 'sleep':
        return isEn ? 'Sleep' : 'Uyku';
      default:
        return category;
    }
  }
}

class _AnimatedScoreRing extends StatelessWidget {
  final int score;
  final Color color;
  final bool isDark;

  const _AnimatedScoreRing({
    required this.score,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: score / 100),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return SizedBox(
          width: 56,
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 4,
                  backgroundColor: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.06),
                  valueColor: AlwaysStoppedAnimation(color),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Text(
                '${(value * 100).round()}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BreakdownBar extends StatelessWidget {
  final String label;
  final double score;
  final bool isDark;

  const _BreakdownBar({
    required this.label,
    required this.score,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: (score / 100).clamp(0, 1)),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Row(
          children: [
            SizedBox(
              width: 72,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color:
                      isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 6,
                  backgroundColor: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.06),
                  valueColor: AlwaysStoppedAnimation(
                    WellnessScoreCard._scoreColor(score.round()),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 28,
              child: Text(
                '${score.round()}',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EmptyWellnessCard extends StatelessWidget {
  final bool isDark;
  final bool isEn;

  const _EmptyWellnessCard({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.auroraStart.withValues(alpha: 0.15),
            ),
            child: Icon(
              Icons.favorite_outline,
              size: 22,
              color: AppColors.auroraStart.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEn ? 'Wellness Score' : 'Sağlık Skoru',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  isEn
                      ? 'Log a journal entry to see your score'
                      : 'Skorunu görmek için günlük kaydı oluştur',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
