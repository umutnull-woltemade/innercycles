// ════════════════════════════════════════════════════════════════════════════
// JOURNEY ANALYTICS SCREEN - User engagement & tool usage analytics
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/ecosystem_analytics_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class JourneyAnalyticsScreen extends ConsumerWidget {
  const JourneyAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(ecosystemAnalyticsServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (_, _) => Center(child: Text('Something went wrong', style: TextStyle(color: Color(0xFF9E8E82)))),
            data: (service) {
              final toolEvents = service.getEvents(
                  name: 'tool_open', limit: 500);
              final sessionEvents = service.getEvents(
                  name: 'session_end', limit: 100);
              final challengeStarts = service.getEventCount(
                  'challenge_start');
              final challengeCompletes = service.getEventCount(
                  'challenge_complete');
              final totalSessions = service.getEventCount(
                  'session_start');
              final searchCount = service.getEventCount(
                  'search_query');

              // Build tool usage map
              final toolUsage = <String, int>{};
              for (final e in toolEvents) {
                final toolId =
                    e.properties['tool_id']?.toString() ?? 'unknown';
                toolUsage[toolId] = (toolUsage[toolId] ?? 0) + 1;
              }
              final sortedTools = toolUsage.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));

              // Session durations
              final durations = <int>[];
              for (final e in sessionEvents) {
                final d = (e.properties['duration_seconds'] as num?)?.toInt();
                if (d != null && d > 0) durations.add(d);
              }
              final avgDuration = durations.isNotEmpty
                  ? durations.reduce((a, b) => a + b) ~/ durations.length
                  : 0;

              if (toolEvents.isEmpty && totalSessions == 0) {
                return _EmptyState(isEn: isEn, isDark: isDark);
              }

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: isEn
                        ? 'Your Journey'
                        : 'Yolculuğun',
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            isEn
                                ? 'How you explore and engage with your tools'
                                : 'Araçlarını nasıl keşfedip kullandığın',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Overview hero
                          _OverviewHero(
                            sessions: totalSessions,
                            toolsExplored: toolUsage.length,
                            avgDuration: avgDuration,
                            searches: searchCount,
                            isEn: isEn,
                            isDark: isDark,
                          ).animate().fadeIn(duration: 400.ms),

                          const SizedBox(height: 24),

                          // Challenge stats
                          if (challengeStarts > 0) ...[
                            GradientText(
                              isEn
                                  ? 'Challenge Progress'
                                  : 'Meydan Okuma İlerlemesi',
                              variant: GradientTextVariant.gold,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _ChallengeStats(
                              started: challengeStarts,
                              completed: challengeCompletes,
                              isEn: isEn,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Most used tools
                          if (sortedTools.isNotEmpty) ...[
                            GradientText(
                              isEn
                                  ? 'Most Used Tools'
                                  : 'En Çok Kullanılan Araçlar',
                              variant: GradientTextVariant.aurora,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...sortedTools.take(10).map(
                                  (entry) => Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 6),
                                    child: _ToolUsageRow(
                                      toolId: entry.key,
                                      count: entry.value,
                                      maxCount:
                                          sortedTools.first.value,
                                      isEn: isEn,
                                      isDark: isDark,
                                    ),
                                  ),
                                ),
                            const SizedBox(height: 24),
                          ],

                          // Least explored
                          if (sortedTools.length > 5) ...[
                            GradientText(
                              isEn
                                  ? 'Least Explored'
                                  : 'En Az Keşfedilen',
                              variant: GradientTextVariant.amethyst,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: sortedTools
                                  .reversed
                                  .take(5)
                                  .map((entry) => Container(
                                        padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 6),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(
                                                  10),
                                          color: AppColors.amethyst
                                              .withValues(
                                                  alpha: 0.08),
                                        ),
                                        child: Text(
                                          '${_formatToolId(entry.key)} (${entry.value})',
                                          style: AppTypography
                                              .elegantAccent(
                                            fontSize: 11,
                                            color:
                                                AppColors.amethyst,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ],

                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              isEn
                                  ? '${toolEvents.length} tool interactions tracked'
                                  : '${toolEvents.length} araç etkileşimi takip edildi',
                              style: AppTypography.subtitle(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
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

String _formatToolId(String toolId) {
  return toolId
      .replaceAll('_', ' ')
      .replaceAll('-', ' ')
      .split(' ')
      .map((w) => w.isNotEmpty
          ? '${w[0].toUpperCase()}${w.substring(1)}'
          : '')
      .join(' ');
}

class _OverviewHero extends StatelessWidget {
  final int sessions;
  final int toolsExplored;
  final int avgDuration;
  final int searches;
  final bool isEn;
  final bool isDark;

  const _OverviewHero({
    required this.sessions,
    required this.toolsExplored,
    required this.avgDuration,
    required this.searches,
    required this.isEn,
    required this.isDark,
  });

  String _formatDuration(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final minutes = seconds ~/ 60;
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.aurora,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _Stat(
              value: '$sessions',
              label: isEn ? 'Sessions' : 'Oturum',
              color: AppColors.auroraStart,
              isDark: isDark,
            ),
            _Stat(
              value: '$toolsExplored',
              label: isEn ? 'Tools' : 'Araç',
              color: AppColors.starGold,
              isDark: isDark,
            ),
            _Stat(
              value: _formatDuration(avgDuration),
              label: isEn ? 'Avg Time' : 'Ort Süre',
              color: AppColors.amethyst,
              isDark: isDark,
            ),
            _Stat(
              value: '$searches',
              label: isEn ? 'Searches' : 'Arama',
              color: AppColors.chartBlue,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool isDark;

  const _Stat({
    required this.value,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.modernAccent(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTypography.elegantAccent(
            fontSize: 9,
            color:
                isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}

class _ChallengeStats extends StatelessWidget {
  final int started;
  final int completed;
  final bool isEn;
  final bool isDark;

  const _ChallengeStats({
    required this.started,
    required this.completed,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final rate = started > 0 ? completed / started : 0.0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '$started',
                    style: AppTypography.modernAccent(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.starGold,
                    ),
                  ),
                  Text(
                    isEn ? 'Started' : 'Başlanan',
                    style: AppTypography.elegantAccent(
                      fontSize: 10,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '$completed',
                    style: AppTypography.modernAccent(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                  Text(
                    isEn ? 'Completed' : 'Tamamlanan',
                    style: AppTypography.elegantAccent(
                      fontSize: 10,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '${(rate * 100).round()}%',
                    style: AppTypography.modernAccent(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.auroraStart,
                    ),
                  ),
                  Text(
                    isEn ? 'Rate' : 'Oran',
                    style: AppTypography.elegantAccent(
                      fontSize: 10,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: rate.clamp(0.0, 1.0),
              backgroundColor: (isDark ? Colors.white : Colors.black)
                  .withValues(alpha: 0.06),
              valueColor: AlwaysStoppedAnimation(AppColors.success),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolUsageRow extends StatelessWidget {
  final String toolId;
  final int count;
  final int maxCount;
  final bool isEn;
  final bool isDark;

  const _ToolUsageRow({
    required this.toolId,
    required this.count,
    required this.maxCount,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = maxCount > 0 ? count / maxCount : 0.0;
    final label = _formatToolId(toolId);

    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.modernAccent(
              fontSize: 12,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: (isDark ? Colors.white : Colors.black)
                  .withValues(alpha: 0.06),
              valueColor:
                  AlwaysStoppedAnimation(AppColors.auroraStart),
              minHeight: 5,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 30,
          child: Text(
            '$count',
            textAlign: TextAlign.end,
            style: AppTypography.modernAccent(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.auroraStart,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isEn;
  final bool isDark;

  const _EmptyState({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        GlassSliverAppBar(
          title: isEn ? 'Your Journey' : 'Yolculuğun',
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: PremiumCard(
                style: PremiumCardStyle.subtle,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('\u{1F680}',
                          style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 12),
                      Text(
                        isEn
                            ? 'Start exploring tools and features to see your journey analytics'
                            : 'Yolculuk analizlerini görmek için araçları ve özellikleri keşfetmeye başla',
                        textAlign: TextAlign.center,
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}
