// ════════════════════════════════════════════════════════════════════════════
// BLIND SPOT SCREEN - Emotional Blind Spot Reveal
// ════════════════════════════════════════════════════════════════════════════
// Presents journal-derived blind spots with expandable insight cards,
// severity indicators, growth suggestions, and pull-to-refresh.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/blind_spot_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

class BlindSpotScreen extends ConsumerWidget {
  const BlindSpotScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;

    final blindSpotAsync = ref.watch(blindSpotServiceProvider);
    final journalAsync = ref.watch(journalServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: blindSpotAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(
              child: Text(
                isEn ? 'Could not load data' : 'Veri yüklenemedi',
                style: TextStyle(
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ),
            data: (blindSpotService) => journalAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(
                child: Text(
                  isEn ? 'Could not load data' : 'Veri yüklenemedi',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ),
              data: (journalService) {
                final entries = journalService.getAllEntries();
                final hasEnough = blindSpotService.hasEnoughData(entries);

                return _BlindSpotBody(
                  blindSpotService: blindSpotService,
                  entries: entries,
                  hasEnough: hasEnough,
                  isDark: isDark,
                  isEn: isEn,
                  onRefresh: () {
                    ref.invalidate(blindSpotServiceProvider);
                    ref.invalidate(journalServiceProvider);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MAIN BODY
// ═══════════════════════════════════════════════════════════════════════════

class _BlindSpotBody extends StatefulWidget {
  final BlindSpotService blindSpotService;
  final List entries;
  final bool hasEnough;
  final bool isDark;
  final bool isEn;
  final VoidCallback onRefresh;

  const _BlindSpotBody({
    required this.blindSpotService,
    required this.entries,
    required this.hasEnough,
    required this.isDark,
    required this.isEn,
    required this.onRefresh,
  });

  @override
  State<_BlindSpotBody> createState() => _BlindSpotBodyState();
}

class _BlindSpotBodyState extends State<_BlindSpotBody> {
  BlindSpotReport? _report;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    if (widget.hasEnough) {
      _report = widget.blindSpotService.getLastReport();
      if (_report == null) {
        _generateReport();
      }
    }
  }

  Future<void> _generateReport() async {
    if (!widget.hasEnough) return;
    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(milliseconds: 300));
    final report = widget.blindSpotService.generateReport(
      List.from(widget.entries),
    );
    if (mounted) {
      setState(() {
        _report = report;
        _isGenerating = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    await _generateReport();
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppColors.auroraStart,
      backgroundColor: widget.isDark ? AppColors.surfaceDark : AppColors.lightCard,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(
            title: widget.isEn
                ? 'What Your Journal Reveals'
                : 'Günlüğün Ne Ortaya Çıkarıyor',
          ),
          if (!widget.hasEnough)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _NotEnoughData(
                isDark: widget.isDark,
                isEn: widget.isEn,
                entryCount: widget.entries.length,
              ),
            )
          else if (_isGenerating || _report == null)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _OverallInsightCard(
                    report: _report!,
                    isDark: widget.isDark,
                    isEn: widget.isEn,
                  ),
                  const SizedBox(height: 20),
                  _BlindSpotsList(
                    spots: _report!.blindSpots,
                    isDark: widget.isDark,
                    isEn: widget.isEn,
                  ),
                  const SizedBox(height: 20),
                  _GrowthSuggestionsCard(
                    report: _report!,
                    isDark: widget.isDark,
                    isEn: widget.isEn,
                  ),
                  const SizedBox(height: 24),
                  _DisclaimerFooter(
                    isDark: widget.isDark,
                    isEn: widget.isEn,
                  ),
                  const SizedBox(height: 20),
                  _ShareInsightsButton(
                    spotCount: _report!.blindSpots.length,
                    isDark: widget.isDark,
                    isEn: widget.isEn,
                  ),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// NOT ENOUGH DATA
// ═══════════════════════════════════════════════════════════════════════════

class _NotEnoughData extends StatelessWidget {
  final bool isDark;
  final bool isEn;
  final int entryCount;

  const _NotEnoughData({
    required this.isDark,
    required this.isEn,
    required this.entryCount,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = 14 - entryCount;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.visibility_outlined,
            size: 64,
            color: isDark
                ? AppColors.textMuted.withValues(alpha: 0.5)
                : AppColors.lightTextMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 20),
          Text(
            isEn
                ? 'A little more journaling to go'
                : 'Biraz daha günlük tutmaya devam',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            isEn
                ? 'You have $entryCount entries so far. After $remaining more, '
                    'your journal will have enough data to reveal patterns '
                    'you might not notice on your own.'
                : 'Şu ana kadar $entryCount kaydın var. $remaining kayıt daha '
                    'sonra, günlüğün kendi başına fark edemeyebileceğin '
                    'örüntüleri ortaya çıkarmak için yeterli veriye sahip olacak.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  AppColors.auroraStart.withValues(alpha: 0.15),
                  AppColors.auroraEnd.withValues(alpha: 0.15),
                ],
              ),
              border: Border.all(
                color: AppColors.auroraStart.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 18,
                  color: AppColors.auroraStart,
                ),
                const SizedBox(width: 8),
                Text(
                  isEn
                      ? '$entryCount / 14 entries'
                      : '$entryCount / 14 kayıt',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.auroraStart,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// OVERALL INSIGHT CARD
// ═══════════════════════════════════════════════════════════════════════════

class _OverallInsightCard extends StatelessWidget {
  final BlindSpotReport report;
  final bool isDark;
  final bool isEn;

  const _OverallInsightCard({
    required this.report,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.surfaceDark.withValues(alpha: 0.9),
                  AppColors.cosmicPurple.withValues(alpha: 0.7),
                ]
              : [
                  AppColors.lightCard,
                  AppColors.lightSurfaceVariant,
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.auroraStart.withValues(alpha: 0.3)
              : AppColors.auroraStart.withValues(alpha: 0.15),
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: AppColors.auroraStart.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.auroraStart.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.psychology_outlined,
                  size: 22,
                  color: AppColors.auroraStart,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isEn ? 'Your Overview' : 'Genel Bakış',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              _SpotCountBadge(
                count: report.blindSpots.length,
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            isEn ? report.overallInsightEn : report.overallInsightTr,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0);
  }
}

class _SpotCountBadge extends StatelessWidget {
  final int count;
  final bool isDark;

  const _SpotCountBadge({required this.count, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.auroraStart,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BLIND SPOTS LIST
// ═══════════════════════════════════════════════════════════════════════════

class _BlindSpotsList extends StatelessWidget {
  final List<BlindSpot> spots;
  final bool isDark;
  final bool isEn;

  const _BlindSpotsList({
    required this.spots,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    if (spots.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
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
            Icon(
              Icons.check_circle_outline,
              color: AppColors.success,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isEn
                    ? 'No blind spots detected at this time. Keep journaling!'
                    : 'Şu anda bir kör nokta tespit edilmedi. Günlük tutmaya devam et!',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 100.ms, duration: 300.ms);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEn ? 'Blind Spots' : 'Kör Noktalar',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.textPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(spots.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _BlindSpotCard(
              spot: spots[i],
              isDark: isDark,
              isEn: isEn,
            ).animate().fadeIn(
                  delay: Duration(milliseconds: 100 + i * 80),
                  duration: 300.ms,
                ),
          );
        }),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SINGLE BLIND SPOT CARD (EXPANDABLE)
// ═══════════════════════════════════════════════════════════════════════════

class _BlindSpotCard extends StatefulWidget {
  final BlindSpot spot;
  final bool isDark;
  final bool isEn;

  const _BlindSpotCard({
    required this.spot,
    required this.isDark,
    required this.isEn,
  });

  @override
  State<_BlindSpotCard> createState() => _BlindSpotCardState();
}

class _BlindSpotCardState extends State<_BlindSpotCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final spot = widget.spot;
    final isDark = widget.isDark;
    final isEn = widget.isEn;

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark.withValues(alpha: 0.85)
              : AppColors.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _severityColor(spot.severity).withValues(alpha: 0.3),
          ),
          boxShadow: _expanded
              ? [
                  BoxShadow(
                    color:
                        _severityColor(spot.severity).withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _severityColor(spot.severity)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _categoryIcon(spot.category),
                    size: 20,
                    color: _severityColor(spot.severity),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEn ? spot.typeEn : spot.typeTr,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      _SeverityIndicator(
                        severity: spot.severity,
                        isEn: isEn,
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                    size: 22,
                  ),
                ),
              ],
            ),
            // Expanded content
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Text(
                  isEn ? spot.insightEn : spot.insightTr,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
              sizeCurve: Curves.easeInOut,
            ),
          ],
        ),
      ),
    );
  }

  Color _severityColor(BlindSpotSeverity severity) {
    switch (severity) {
      case BlindSpotSeverity.low:
        return AppColors.auroraStart;
      case BlindSpotSeverity.medium:
        return AppColors.warning;
      case BlindSpotSeverity.high:
        return AppColors.error;
    }
  }

  IconData _categoryIcon(BlindSpotCategory category) {
    switch (category) {
      case BlindSpotCategory.avoidedArea:
        return Icons.explore_off_outlined;
      case BlindSpotCategory.ratingBias:
        return Icons.tune_outlined;
      case BlindSpotCategory.dayPattern:
        return Icons.calendar_today_outlined;
      case BlindSpotCategory.moodCorrelation:
        return Icons.compare_arrows_outlined;
      case BlindSpotCategory.neglectedSubRating:
        return Icons.trending_down_outlined;
      case BlindSpotCategory.stagnation:
        return Icons.horizontal_rule_outlined;
    }
  }
}

class _SeverityIndicator extends StatelessWidget {
  final BlindSpotSeverity severity;
  final bool isEn;

  const _SeverityIndicator({
    required this.severity,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final color = _color;
    final label = _label;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(3, (i) {
          final active = i < _level;
          return Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(right: 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? color : color.withValues(alpha: 0.2),
            ),
          );
        }),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  int get _level {
    switch (severity) {
      case BlindSpotSeverity.low:
        return 1;
      case BlindSpotSeverity.medium:
        return 2;
      case BlindSpotSeverity.high:
        return 3;
    }
  }

  Color get _color {
    switch (severity) {
      case BlindSpotSeverity.low:
        return AppColors.auroraStart;
      case BlindSpotSeverity.medium:
        return AppColors.warning;
      case BlindSpotSeverity.high:
        return AppColors.error;
    }
  }

  String get _label {
    switch (severity) {
      case BlindSpotSeverity.low:
        return isEn ? 'Subtle' : 'Hafif';
      case BlindSpotSeverity.medium:
        return isEn ? 'Notable' : 'Dikkat Çekici';
      case BlindSpotSeverity.high:
        return isEn ? 'Significant' : 'Belirgin';
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// GROWTH SUGGESTIONS
// ═══════════════════════════════════════════════════════════════════════════

class _GrowthSuggestionsCard extends StatelessWidget {
  final BlindSpotReport report;
  final bool isDark;
  final bool isEn;

  const _GrowthSuggestionsCard({
    required this.report,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final suggestions =
        isEn ? report.growthSuggestionsEn : report.growthSuggestionsTr;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.success.withValues(alpha: 0.25)
              : AppColors.success.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.spa_outlined,
                  size: 20,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                isEn ? 'Growth Suggestions' : 'Gelişim Önerileri',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...suggestions.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    margin: const EdgeInsets.only(top: 1),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success.withValues(alpha: 0.12),
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
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
    ).animate().fadeIn(delay: 400.ms, duration: 300.ms);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DISCLAIMER FOOTER
// ═══════════════════════════════════════════════════════════════════════════

class _DisclaimerFooter extends StatelessWidget {
  final bool isDark;
  final bool isEn;

  const _DisclaimerFooter({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 14,
            color: isDark
                ? AppColors.textMuted.withValues(alpha: 0.6)
                : AppColors.lightTextMuted.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isEn
                  ? 'Based on your journal patterns. These observations are not professional advice and are meant for personal reflection only.'
                  : 'Günlük örüntülerini temel alıyor. Bu gözlemler profesyonel tavsiye değildir ve yalnızca kişisel düşünce için tasarlanmıştır.',
              style: TextStyle(
                fontSize: 11,
                height: 1.4,
                color: isDark
                    ? AppColors.textMuted.withValues(alpha: 0.6)
                    : AppColors.lightTextMuted.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 300.ms);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SHARE INSIGHTS BUTTON
// ═══════════════════════════════════════════════════════════════════════════

class _ShareInsightsButton extends StatelessWidget {
  final int spotCount;
  final bool isDark;
  final bool isEn;

  const _ShareInsightsButton({
    required this.spotCount,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () {
          final text = isEn
              ? 'I uncovered $spotCount emotional blind spots through self-reflection with InnerCycles.\n\n'
                'Discover your hidden patterns:\nhttps://apps.apple.com/app/innercycles/id6758612716'
              : 'InnerCycles ile öz yansıma yaparak $spotCount duygusal kör noktamı keşfettim.\n\n'
                'Gizli kalıplarını keşfet:\nhttps://apps.apple.com/app/innercycles/id6758612716';
          SharePlus.instance.share(ShareParams(text: text));
        },
        icon: const Icon(Icons.share_rounded, size: 18),
        label: Text(
          isEn ? 'Share Your Insights' : 'İçgörülerini Paylaş',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandPink.withValues(alpha: 0.15),
          foregroundColor: AppColors.brandPink,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: AppColors.brandPink.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
    );
  }
}
