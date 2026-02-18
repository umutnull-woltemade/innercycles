import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/wellness_score_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';

class WellnessDetailScreen extends ConsumerWidget {
  const WellnessDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final scoreAsync = ref.watch(wellnessScoreProvider);
    final trendAsync = ref.watch(wellnessTrendProvider);
    final isPremium = ref.watch(isPremiumUserProvider);

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
                  title: isEn ? 'Wellness Score' : 'Sağlık Skoru',
                ),
              SliverPadding(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Score hero
                    scoreAsync.when(
                      loading: () => const Center(
                        child: CosmicLoadingIndicator(),
                      ),
                      error: (_, _) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            isEn ? 'Could not load wellness data' : 'Sağlık verileri yüklenemedi',
                            style: TextStyle(
                              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                            ),
                          ),
                        ),
                      ),
                      data: (score) {
                        if (score == null) {
                          return _buildEmptyState(isDark, isEn);
                        }
                        return _ScoreHero(
                          score: score,
                          isDark: isDark,
                          isEn: isEn,
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Breakdown detail
                    scoreAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, _) => const SizedBox.shrink(),
                      data: (score) {
                        if (score == null) return const SizedBox.shrink();
                        return _BreakdownDetail(
                          breakdown: score.breakdown,
                          isDark: isDark,
                          isEn: isEn,
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Weekly trend
                    trendAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, _) => const SizedBox.shrink(),
                      data: (trend) {
                        if (trend.dailyScores.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return _WeeklyTrendChart(
                          trend: trend,
                          isDark: isDark,
                          isEn: isEn,
                          isPremium: isPremium,
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Tips
                    _buildTips(isDark, isEn),

                    const SizedBox(height: 24),
                    ToolEcosystemFooter(
                      currentToolId: 'wellnessDetail',
                      isEn: isEn,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, bool isEn) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Icon(
          Icons.favorite_outline,
          size: 64,
          color: AppColors.auroraStart.withValues(alpha: 0.5),
        ),
        const SizedBox(height: 16),
        Text(
          isEn ? 'No score yet' : 'Henüz skor yok',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isEn
              ? 'Log a cycle entry, gratitude, or sleep to see your cycle score'
              : 'Döngü skorunu görmek için döngü kaydı, şükran veya uyku kaydı oluştur',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildTips(bool isDark, bool isEn) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEn ? 'How your score works' : 'Skorun nasıl çalışır',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 10),
          _TipRow(
            icon: Icons.edit_note,
            text: isEn ? 'Journal rating = 40% of score' : 'Günlük puanı = skorun %40\'ı',
            isDark: isDark,
          ),
          _TipRow(
            icon: Icons.favorite_border,
            text: isEn ? 'Gratitude items = 15%' : 'Şükran maddeleri = %15',
            isDark: isDark,
          ),
          _TipRow(
            icon: Icons.playlist_add_check,
            text: isEn ? 'Ritual completion = 15%' : 'Ritüel tamamlama = %15',
            isDark: isDark,
          ),
          _TipRow(
            icon: Icons.local_fire_department,
            text: isEn ? 'Streak consistency = 15%' : 'Tutarlılık serisi = %15',
            isDark: isDark,
          ),
          _TipRow(
            icon: Icons.bedtime_outlined,
            text: isEn ? 'Sleep quality = 15%' : 'Uyku kalitesi = %15',
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _ScoreHero extends StatelessWidget {
  final WellnessScore score;
  final bool isDark;
  final bool isEn;

  const _ScoreHero({
    required this.score,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _scoreColor(score.score),
                  _scoreColor(score.score).withValues(alpha: 0.5),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: _scoreColor(score.score).withValues(alpha: 0.3),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${score.score}',
                style: const TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ).animate().scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: 400.ms,
                curve: Curves.easeOutBack,
              ),
          const SizedBox(height: 12),
          Text(
            _scoreLabel(score.score, isEn),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _scoreColor(score.score),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isEn ? 'out of 100' : '100 üzerinden',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Color _scoreColor(int score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.auroraStart;
    if (score >= 40) return AppColors.warning;
    if (score >= 20) return AppColors.sunriseEnd;
    return AppColors.error;
  }

  String _scoreLabel(int score, bool isEn) {
    if (score >= 80) return isEn ? 'Thriving' : 'Harika';
    if (score >= 60) return isEn ? 'Good Balance' : 'İyi Denge';
    if (score >= 40) return isEn ? 'Room to Grow' : 'Gelişim Alanı';
    if (score >= 20) return isEn ? 'Getting Started' : 'Başlangıç';
    return isEn ? 'Begin Your Journey' : 'Yolculuğuna Başla';
  }
}

class _BreakdownDetail extends StatelessWidget {
  final List<WellnessBreakdown> breakdown;
  final bool isDark;
  final bool isEn;

  const _BreakdownDetail({
    required this.breakdown,
    required this.isDark,
    required this.isEn,
  });

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEn ? 'Score Breakdown' : 'Skor Dağılımı',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 14),
          ...breakdown.asMap().entries.map((entry) {
            final b = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        _categoryIcon(b.category),
                        size: 16,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _categoryLabel(b.category, isEn),
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                      Text(
                        '${b.score.round()}/100',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${(b.weight * 100).round()}%)',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (b.score / 100).clamp(0, 1),
                      minHeight: 8,
                      backgroundColor: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.06),
                      valueColor: AlwaysStoppedAnimation(
                        _barColor(b.score),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(
                  delay: (entry.key * 80).ms,
                  duration: 300.ms,
                );
          }),
        ],
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'journal':
        return Icons.edit_note;
      case 'gratitude':
        return Icons.favorite_border;
      case 'rituals':
        return Icons.playlist_add_check;
      case 'streak':
        return Icons.local_fire_department;
      case 'sleep':
        return Icons.bedtime_outlined;
      default:
        return Icons.circle;
    }
  }

  String _categoryLabel(String category, bool isEn) {
    switch (category) {
      case 'journal':
        return isEn ? 'Journal Rating' : 'Günlük Puanı';
      case 'gratitude':
        return isEn ? 'Gratitude Practice' : 'Şükran Pratiği';
      case 'rituals':
        return isEn ? 'Ritual Completion' : 'Ritüel Tamamlama';
      case 'streak':
        return isEn ? 'Streak Consistency' : 'Tutarlılık Serisi';
      case 'sleep':
        return isEn ? 'Sleep Quality' : 'Uyku Kalitesi';
      default:
        return category;
    }
  }

  Color _barColor(double score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.auroraStart;
    if (score >= 40) return AppColors.warning;
    if (score >= 20) return AppColors.sunriseEnd;
    return AppColors.error;
  }
}

class _WeeklyTrendChart extends StatelessWidget {
  final WellnessTrend trend;
  final bool isDark;
  final bool isEn;
  final bool isPremium;

  const _WeeklyTrendChart({
    required this.trend,
    required this.isDark,
    required this.isEn,
    required this.isPremium,
  });

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isEn ? 'Weekly Trend' : 'Haftalık Trend',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const Spacer(),
              Icon(
                trend.direction == 'up'
                    ? Icons.trending_up
                    : trend.direction == 'down'
                        ? Icons.trending_down
                        : Icons.trending_flat,
                size: 20,
                color: trend.direction == 'up'
                    ? AppColors.success
                    : trend.direction == 'down'
                        ? AppColors.warning
                        : AppColors.textMuted,
              ),
              const SizedBox(width: 4),
              Text(
                _trendLabel(trend.direction, isEn),
                style: TextStyle(
                  fontSize: 12,
                  color: trend.direction == 'up'
                      ? AppColors.success
                      : trend.direction == 'down'
                          ? AppColors.warning
                          : (isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Simple bar chart for the week
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: trend.dailyScores.reversed.take(7).toList().reversed.map((score) {
                final height = (score.score / 100 * 80).clamp(4.0, 80.0);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${score.score}',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 28,
                      height: height,
                      decoration: BoxDecoration(
                        color: _barColor(score.score),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      score.dateKey.length > 8 ? score.dateKey.substring(8) : score.dateKey,
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _trendLabel(String direction, bool isEn) {
    switch (direction) {
      case 'up':
        return isEn ? 'Improving' : 'Yükseliyor';
      case 'down':
        return isEn ? 'Declining' : 'Düşüyor';
      default:
        return isEn ? 'Stable' : 'Sabit';
    }
  }

  Color _barColor(int score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.auroraStart;
    if (score >= 40) return AppColors.warning;
    return AppColors.sunriseEnd;
  }
}

class _TipRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDark;

  const _TipRow({
    required this.icon,
    required this.text,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
