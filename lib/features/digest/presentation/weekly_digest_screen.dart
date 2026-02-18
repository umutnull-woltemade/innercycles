// ════════════════════════════════════════════════════════════════════════════
// WEEKLY DIGEST SCREEN - InnerCycles Weekly Summary
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/weekly_digest_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';

class WeeklyDigestScreen extends ConsumerWidget {
  const WeeklyDigestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final digestAsync = ref.watch(weeklyDigestServiceProvider);
    final journalAsync = ref.watch(journalServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              GlassSliverAppBar(
                title: isEn ? 'Weekly Digest' : 'Haftalık Özet',
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: digestAsync.when(
                  loading: () => const SliverToBoxAdapter(
                    child: Center(child: CosmicLoadingIndicator()),
                  ),
                  error: (_, _) => SliverToBoxAdapter(
                    child: _EmptyDigest(isDark: isDark, isEn: isEn),
                  ),
                  data: (digestService) {
                    return journalAsync.when(
                      loading: () => const SliverToBoxAdapter(
                        child: Center(child: CosmicLoadingIndicator()),
                      ),
                      error: (_, _) => SliverToBoxAdapter(
                        child: _EmptyDigest(isDark: isDark, isEn: isEn),
                      ),
                      data: (journalService) {
                        final entries = journalService.getAllEntries();
                        if (entries.isEmpty) {
                          return SliverToBoxAdapter(
                            child: _EmptyDigest(isDark: isDark, isEn: isEn),
                          );
                        }

                        final digest = digestService.generateDigest(entries);
                        final allDigests = digestService.getAllDigests();

                        return SliverList(
                          delegate: SliverChildListDelegate([
                            _DigestHeader(
                              digest: digest,
                              isDark: isDark,
                              isEn: isEn,
                            ),
                            const SizedBox(height: 16),
                            _StatsRow(
                              digest: digest,
                              isDark: isDark,
                              isEn: isEn,
                            ),
                            const SizedBox(height: 16),
                            _MoodTrendCard(
                              digest: digest,
                              isDark: isDark,
                              isEn: isEn,
                            ),
                            const SizedBox(height: 16),
                            if (digest.areaAverages.isNotEmpty)
                              _AreaBreakdown(
                                digest: digest,
                                isDark: isDark,
                                isEn: isEn,
                              ),
                            if (digest.areaAverages.isNotEmpty)
                              const SizedBox(height: 16),
                            _GrowthNudgeCard(
                              digest: digest,
                              isDark: isDark,
                              isEn: isEn,
                            ),
                            if (allDigests.length > 1) ...[
                              const SizedBox(height: 24),
                              _PastDigests(
                                digests: allDigests.skip(1).take(4).toList(),
                                isDark: isDark,
                                isEn: isEn,
                              ),
                            ],
                            ToolEcosystemFooter(
                              currentToolId: 'weeklyDigest',
                              isEn: isEn,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 40),
                          ]),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════

class _DigestHeader extends StatelessWidget {
  final WeeklyDigest digest;
  final bool isDark;
  final bool isEn;

  const _DigestHeader({
    required this.digest,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d');
    final range =
        '${dateFormat.format(digest.weekStart)} – ${dateFormat.format(digest.weekEnd)}';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.surfaceDark.withValues(alpha: 0.9),
                  AppColors.cosmicPurple.withValues(alpha: 0.4),
                ]
              : [
                  AppColors.lightCard,
                  AppColors.lightSurfaceVariant,
                ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            isEn ? 'Your Week' : 'Haftanız',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            range,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isEn ? digest.highlightEn : digest.highlightTr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color:
                  isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _StatsRow extends StatelessWidget {
  final WeeklyDigest digest;
  final bool isDark;
  final bool isEn;

  const _StatsRow({
    required this.digest,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          value: '${digest.entryCount}',
          label: isEn ? 'Entries' : 'Kayıt',
          icon: Icons.edit_note,
          color: AppColors.auroraStart,
          isDark: isDark,
        ),
        const SizedBox(width: 10),
        _StatCard(
          value: digest.avgMood.toStringAsFixed(1),
          label: isEn ? 'Avg Mood' : 'Ort. Ruh Hali',
          icon: Icons.mood,
          color: _moodColor(digest.avgMood),
          isDark: isDark,
        ),
        const SizedBox(width: 10),
        _StatCard(
          value: '${digest.streakDays}',
          label: isEn ? 'Streak' : 'Seri',
          icon: Icons.local_fire_department,
          color: AppColors.starGold,
          isDark: isDark,
        ),
      ],
    ).animate().fadeIn(delay: 100.ms, duration: 300.ms);
  }

  Color _moodColor(double mood) {
    if (mood >= 7) return AppColors.success;
    if (mood >= 5) return AppColors.auroraStart;
    if (mood >= 3) return AppColors.warning;
    return AppColors.error;
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark.withValues(alpha: 0.85)
              : AppColors.lightCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodTrendCard extends StatelessWidget {
  final WeeklyDigest digest;
  final bool isDark;
  final bool isEn;

  const _MoodTrendCard({
    required this.digest,
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
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
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
            child: const Icon(Icons.trending_up, size: 22, color: AppColors.auroraStart),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEn ? 'Mood Trend' : 'Ruh Hali Eğilimi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isEn ? digest.moodTrendEn : digest.moodTrendTr,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 300.ms);
  }
}

class _AreaBreakdown extends StatelessWidget {
  final WeeklyDigest digest;
  final bool isDark;
  final bool isEn;

  const _AreaBreakdown({
    required this.digest,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final areaNames = {
      'energy': isEn ? 'Energy' : 'Enerji',
      'focus': isEn ? 'Focus' : 'Odak',
      'emotions': isEn ? 'Emotions' : 'Duygular',
      'decisions': isEn ? 'Decisions' : 'Kararlar',
      'social': isEn ? 'Social' : 'Sosyal',
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEn ? 'Focus Areas This Week' : 'Bu Haftanın Odak Alanları',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...digest.areaAverages.entries.map((entry) {
            final label = areaNames[entry.key] ?? entry.key;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 72,
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (entry.value / 10).clamp(0, 1),
                        minHeight: 6,
                        backgroundColor: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.06),
                        valueColor: AlwaysStoppedAnimation(
                          _areaColor(entry.value),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 28,
                    child: Text(
                      entry.value.toStringAsFixed(1),
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
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 300.ms);
  }

  Color _areaColor(double score) {
    if (score >= 7) return AppColors.success;
    if (score >= 5) return AppColors.auroraStart;
    if (score >= 3) return AppColors.warning;
    return AppColors.error;
  }
}

class _GrowthNudgeCard extends StatelessWidget {
  final WeeklyDigest digest;
  final bool isDark;
  final bool isEn;

  const _GrowthNudgeCard({
    required this.digest,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.starGold.withValues(alpha: 0.15),
                  AppColors.surfaceDark.withValues(alpha: 0.9),
                ]
              : [
                  AppColors.starGold.withValues(alpha: 0.08),
                  AppColors.lightCard,
                ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.starGold.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          const Text('💡', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEn ? 'Growth Nudge' : 'Büyüme İpucu',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.starGold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isEn ? digest.growthNudgeEn : digest.growthNudgeTr,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 300.ms);
  }
}

class _PastDigests extends StatelessWidget {
  final List<WeeklyDigest> digests;
  final bool isDark;
  final bool isEn;

  const _PastDigests({
    required this.digests,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEn ? 'Past Weeks' : 'Geçmiş Haftalar',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...digests.map((d) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceDark.withValues(alpha: 0.85)
                      : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(
                      '${dateFormat.format(d.weekStart)} – ${dateFormat.format(d.weekEnd)}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${d.entryCount} ${isEn ? 'entries' : 'kayıt'}',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _moodColor(d.avgMood).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${d.avgMood}/10',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _moodColor(d.avgMood),
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

  Color _moodColor(double mood) {
    if (mood >= 7) return AppColors.success;
    if (mood >= 5) return AppColors.auroraStart;
    if (mood >= 3) return AppColors.warning;
    return AppColors.error;
  }
}

class _EmptyDigest extends StatelessWidget {
  final bool isDark;
  final bool isEn;

  const _EmptyDigest({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('📊', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            isEn ? 'Your Weekly Digest' : 'Haftalık Özetin',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isEn
                ? 'Start journaling to see your weekly summary with mood trends, patterns, and growth nudges.'
                : 'Ruh hali eğilimleri, kalıplar ve büyüme ipuçları içeren haftalık özetini görmek için günlük tutmaya başla.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color:
                  isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}
