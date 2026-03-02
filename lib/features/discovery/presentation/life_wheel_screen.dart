// ════════════════════════════════════════════════════════════════════════════
// LIFE WHEEL SCREEN - Balance assessment with spider chart
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/life_wheel_entry.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';

class LifeWheelScreen extends ConsumerStatefulWidget {
  const LifeWheelScreen({super.key});

  @override
  ConsumerState<LifeWheelScreen> createState() => _LifeWheelScreenState();
}

class _LifeWheelScreenState extends ConsumerState<LifeWheelScreen> {
  final Map<LifeArea, int> _scores = {
    for (final area in LifeArea.values) area: 5,
  };
  final _noteController = TextEditingController();
  bool _showHistory = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(lifeWheelServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (service) {
              final latest = service.getLatestEntry();
              final delta = service.getDelta();

              return CustomScrollView(
                slivers: [
                  GlassSliverAppBar(
                    title: isEn ? 'Life Wheel' : 'Ya\u015fam \u00c7ark\u0131',
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
                                ? 'Rate each area of your life from 1 to 10'
                                : 'Hayat\u0131n\u0131n her alan\u0131n\u0131 1\'den 10\'a de\u011ferlendir',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Spider chart
                          SizedBox(
                            height: 260,
                            child: CustomPaint(
                              painter: _SpiderChartPainter(
                                scores: _scores,
                                isDark: isDark,
                                previousScores: latest?.scores,
                              ),
                              size: Size.infinite,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Sliders
                          ...LifeArea.values.map((area) => _AreaSlider(
                                area: area,
                                value: _scores[area]!,
                                delta: delta?[area],
                                isEn: isEn,
                                isDark: isDark,
                                onChanged: (v) => setState(() => _scores[area] = v),
                              )),

                          const SizedBox(height: 16),

                          // Note
                          Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.04)
                                  : Colors.black.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _noteController,
                              maxLines: 3,
                              style: AppTypography.subtitle(
                                fontSize: 14,
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: isEn
                                    ? 'What changed? (optional)'
                                    : 'Ne de\u011fi\u015fti? (iste\u011fe ba\u011fl\u0131)',
                                hintStyle: AppTypography.subtitle(
                                  fontSize: 14,
                                  color: isDark
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(14),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Save
                          GestureDetector(
                            onTap: _isSaving
                                ? null
                                : () async {
                                    setState(() => _isSaving = true);
                                    await service.saveEntry(
                                      scores: Map.from(_scores),
                                      note: _noteController.text.trim().isEmpty
                                          ? null
                                          : _noteController.text.trim(),
                                    );
                                    ref.invalidate(lifeWheelServiceProvider);
                                    if (mounted) {
                                      setState(() => _isSaving = false);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(isEn ? 'Saved!' : 'Kaydedildi!'),
                                          ),
                                        );
                                      }
                                    }
                                  },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColors.starGold, AppColors.celestialGold],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  isEn ? 'Save Assessment' : 'De\u011ferlendirmeyi Kaydet',
                                  style: AppTypography.modernAccent(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.deepSpace,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // History toggle
                          if (service.entryCount > 0) ...[
                            GestureDetector(
                              onTap: () => setState(() => _showHistory = !_showHistory),
                              child: Row(
                                children: [
                                  GradientText(
                                    isEn
                                        ? 'History (${service.entryCount})'
                                        : 'Ge\u00e7mi\u015f (${service.entryCount})',
                                    variant: GradientTextVariant.amethyst,
                                    style: AppTypography.modernAccent(fontSize: 15),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    _showHistory
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    size: 18,
                                    color: AppColors.amethyst,
                                  ),
                                ],
                              ),
                            ),
                            if (_showHistory)
                              ...service.getHistory().map((entry) => Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: _HistoryTile(
                                      entry: entry,
                                      isEn: isEn,
                                      isDark: isDark,
                                    ),
                                  )),
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

class _AreaSlider extends StatelessWidget {
  final LifeArea area;
  final int value;
  final int? delta;
  final bool isEn;
  final bool isDark;
  final ValueChanged<int> onChanged;

  const _AreaSlider({
    required this.area,
    required this.value,
    this.delta,
    required this.isEn,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(area.emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          SizedBox(
            width: 90,
            child: Text(
              area.label(isEn),
              style: AppTypography.modernAccent(
                fontSize: 12,
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.starGold.withValues(alpha: 0.6),
                inactiveTrackColor: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.06),
                thumbColor: AppColors.starGold,
                overlayColor: AppColors.starGold.withValues(alpha: 0.15),
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              ),
              child: Slider(
                value: value.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                onChanged: (v) => onChanged(v.round()),
              ),
            ),
          ),
          SizedBox(
            width: 24,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: AppTypography.modernAccent(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.starGold,
              ),
            ),
          ),
          if (delta != null && delta != 0)
            SizedBox(
              width: 28,
              child: Text(
                delta! > 0 ? '+$delta' : '$delta',
                style: AppTypography.elegantAccent(
                  fontSize: 10,
                  color: delta! > 0 ? AppColors.success : AppColors.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final LifeWheelEntry entry;
  final bool isEn;
  final bool isDark;

  const _HistoryTile({
    required this.entry,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${entry.createdAt.day}/${entry.createdAt.month}/${entry.createdAt.year}',
                style: AppTypography.modernAccent(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const Spacer(),
              Text(
                isEn
                    ? 'Avg: ${entry.averageScore.toStringAsFixed(1)}'
                    : 'Ort: ${entry.averageScore.toStringAsFixed(1)}',
                style: AppTypography.elegantAccent(
                  fontSize: 11,
                  color: AppColors.starGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: entry.scores.entries.map((e) {
              return Text(
                '${e.key.emoji}${e.value}',
                style: AppTypography.elegantAccent(
                  fontSize: 11,
                  color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                ),
              );
            }).toList(),
          ),
          if (entry.note != null) ...[
            const SizedBox(height: 6),
            Text(
              entry.note!,
              style: AppTypography.subtitle(
                fontSize: 12,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _SpiderChartPainter extends CustomPainter {
  final Map<LifeArea, int> scores;
  final bool isDark;
  final Map<LifeArea, int>? previousScores;

  _SpiderChartPainter({
    required this.scores,
    required this.isDark,
    this.previousScores,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.height / 2 - 20;
    final areas = LifeArea.values;
    final n = areas.length;

    // Grid rings
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int ring = 2; ring <= 10; ring += 2) {
      final r = radius * ring / 10;
      final path = Path();
      for (int i = 0; i <= n; i++) {
        final angle = (2 * math.pi * (i % n) / n) - math.pi / 2;
        final pt = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
        if (i == 0) {
          path.moveTo(pt.dx, pt.dy);
        } else {
          path.lineTo(pt.dx, pt.dy);
        }
      }
      canvas.drawPath(path, gridPaint);
    }

    // Spokes
    for (int i = 0; i < n; i++) {
      final angle = (2 * math.pi * i / n) - math.pi / 2;
      final end = Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle));
      canvas.drawLine(center, end, gridPaint);
    }

    // Previous scores (ghost)
    if (previousScores != null) {
      final ghostPath = Path();
      for (int i = 0; i <= n; i++) {
        final area = areas[i % n];
        final score = (previousScores![area] ?? 0).toDouble();
        final angle = (2 * math.pi * (i % n) / n) - math.pi / 2;
        final r = radius * score / 10;
        final pt = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
        if (i == 0) {
          ghostPath.moveTo(pt.dx, pt.dy);
        } else {
          ghostPath.lineTo(pt.dx, pt.dy);
        }
      }
      canvas.drawPath(
        ghostPath,
        Paint()
          ..color = AppColors.amethyst.withValues(alpha: 0.15)
          ..style = PaintingStyle.fill,
      );
    }

    // Current scores
    final scorePath = Path();
    for (int i = 0; i <= n; i++) {
      final area = areas[i % n];
      final score = (scores[area] ?? 0).toDouble();
      final angle = (2 * math.pi * (i % n) / n) - math.pi / 2;
      final r = radius * score / 10;
      final pt = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
      if (i == 0) {
        scorePath.moveTo(pt.dx, pt.dy);
      } else {
        scorePath.lineTo(pt.dx, pt.dy);
      }
    }
    canvas.drawPath(
      scorePath,
      Paint()
        ..color = AppColors.starGold.withValues(alpha: 0.25)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      scorePath,
      Paint()
        ..color = AppColors.starGold.withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Labels
    for (int i = 0; i < n; i++) {
      final area = areas[i];
      final angle = (2 * math.pi * i / n) - math.pi / 2;
      final labelR = radius + 14;
      final pt = Offset(center.dx + labelR * math.cos(angle), center.dy + labelR * math.sin(angle));

      final tp = TextPainter(
        text: TextSpan(
          text: area.emoji,
          style: const TextStyle(fontSize: 14),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(pt.dx - tp.width / 2, pt.dy - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _SpiderChartPainter old) =>
      scores != old.scores || isDark != old.isDark || previousScores != old.previousScores;
}
