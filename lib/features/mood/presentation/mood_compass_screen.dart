// ════════════════════════════════════════════════════════════════════════════
// MOOD COMPASS SCREEN - Full compass + signal history log
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/content/signal_content.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/haptic_service.dart';
import '../../../data/services/mood_checkin_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/signal_orb.dart';

class MoodCompassScreen extends ConsumerStatefulWidget {
  const MoodCompassScreen({super.key});

  @override
  ConsumerState<MoodCompassScreen> createState() => _MoodCompassScreenState();
}

class _MoodCompassScreenState extends ConsumerState<MoodCompassScreen> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final moodAsync = ref.watch(moodCheckinServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: moodAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (service) {
              final entries = service.getAllEntries();
              final signalEntries =
                  entries.where((e) => e.hasSignal).toList();
              final distribution = service.getQuadrantDistribution(30);

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: isEn ? 'Mood Compass' : 'Ruh Hali Pusulası',
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
                                ? 'Tap the signal closest to how you feel'
                                : 'Hissine en yakın sinyale dokun',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Interactive compass
                          Center(
                            child: _CompassWidget(
                              selectedId: _selectedId,
                              language: language,
                              isDark: isDark,
                              onSelect: (id) =>
                                  setState(() => _selectedId = id),
                            ),
                          ).animate().fadeIn(duration: 400.ms),

                          const SizedBox(height: 16),

                          // Log button
                          if (_selectedId != null) ...[
                            GradientButton.gold(
                              label: isEn ? 'Log Signal' : 'Sinyali Kaydet',
                              expanded: true,
                              onPressed: () async {
                                await service.logSignal(_selectedId!);
                                ref.invalidate(moodCheckinServiceProvider);
                                if (mounted) {
                                  setState(() => _selectedId = null);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(isEn
                                            ? 'Signal logged!'
                                            : 'Sinyal kaydedildi!'),
                                      ),
                                    );
                                  }
                                }
                              },
                            ).animate().fadeIn(duration: 300.ms),
                            const SizedBox(height: 24),
                          ],

                          // Quadrant distribution (last 30 days)
                          if (distribution.isNotEmpty) ...[
                            GradientText(
                              isEn
                                  ? 'Last 30 Days'
                                  : 'Son 30 Gün',
                              variant: GradientTextVariant.gold,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _QuadrantDistribution(
                              distribution: distribution,
                              isEn: isEn,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Signal history
                          GradientText(
                            isEn
                                ? 'Signal History (${signalEntries.length})'
                                : 'Sinyal Geçmişi (${signalEntries.length})',
                            variant: GradientTextVariant.amethyst,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),

                          if (signalEntries.isEmpty)
                            _EmptyHistory(isEn: isEn, isDark: isDark)
                          else
                            ...signalEntries.take(30).map((entry) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _SignalHistoryTile(
                                    entry: entry,
                                    isEn: isEn,
                                    isDark: isDark,
                                  ),
                                )),

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

class _CompassWidget extends StatelessWidget {
  final String? selectedId;
  final AppLanguage language;
  final bool isDark;
  final ValueChanged<String> onSelect;

  const _CompassWidget({
    required this.selectedId,
    required this.language,
    required this.isDark,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isEn = language == AppLanguage.en;
    final compassSize = math.min(MediaQuery.of(context).size.width - 48, 320.0);

    return SizedBox(
      width: compassSize,
      height: compassSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RepaintBoundary(
            child: CustomPaint(
              size: Size(compassSize, compassSize),
              painter: _CompassPainter(isDark: isDark),
            ),
          ),
          // Axis labels
          _label(isEn ? 'High Energy' : 'Yüksek Enerji', Alignment.topCenter,
              const Offset(0, 4)),
          _label(isEn ? 'Low Energy' : 'Düşük Enerji',
              Alignment.bottomCenter, const Offset(0, -4)),
          _label(isEn ? 'Pleasant' : 'Hoş', Alignment.centerRight,
              const Offset(-4, 0)),
          _label(isEn ? 'Unpleasant' : 'Nahoş', Alignment.centerLeft,
              const Offset(4, 0)),
          // Signal orbs
          ..._buildOrbs(compassSize, language),
        ],
      ),
    );
  }

  Widget _label(String text, Alignment alignment, Offset offset) {
    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: offset,
        child: Text(
          text,
          style: AppTypography.elegantAccent(
            fontSize: 10,
            color: (isDark ? AppColors.textMuted : AppColors.lightTextMuted)
                .withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOrbs(double compassSize, AppLanguage language) {
    final center = compassSize / 2;
    final radius = compassSize * 0.35;
    final widgets = <Widget>[];

    final quadrantAngles = {
      SignalQuadrant.fire: -math.pi / 4,
      SignalQuadrant.water: math.pi / 4,
      SignalQuadrant.storm: -3 * math.pi / 4,
      SignalQuadrant.shadow: 3 * math.pi / 4,
    };

    for (final quadrant in SignalQuadrant.values) {
      final signals = getSignalsByQuadrant(quadrant);
      final baseAngle = quadrantAngles[quadrant]!;
      final spread = math.pi / 6;

      for (int i = 0; i < signals.length; i++) {
        final signal = signals[i];
        final angle = baseAngle + (i - 1.5) * (spread / 3);
        final r = radius * (0.7 + i * 0.1);
        final x = center + r * math.cos(angle) - 12;
        final y = center + r * math.sin(angle) - 12;

        widgets.add(
          Positioned(
            left: x,
            top: y,
            child: GestureDetector(
              onTap: () {
                HapticService.moodSelected();
                onSelect(signal.id);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(2),
                    decoration: selectedId == signal.id
                        ? BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.starGold,
                              width: 2,
                            ),
                          )
                        : null,
                    child: SignalOrb(
                      signalId: signal.id,
                      size: SignalOrbSize.inline,
                      animate: selectedId == signal.id,
                    ),
                  ),
                  if (selectedId == signal.id) ...[
                    const SizedBox(height: 2),
                    Text(
                      signal.localizedName(language),
                      style: AppTypography.elegantAccent(
                        fontSize: 10,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }
    }
    return widgets;
  }
}

class _CompassPainter extends CustomPainter {
  final bool isDark;
  _CompassPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(center.dx, 24), Offset(center.dx, size.height - 24), paint);
    canvas.drawLine(Offset(24, center.dy), Offset(size.width - 24, center.dy), paint);
    for (final r in [0.2, 0.35, 0.5]) {
      canvas.drawCircle(center, size.width * r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _QuadrantDistribution extends StatelessWidget {
  final Map<String, int> distribution;
  final bool isEn;
  final bool isDark;

  const _QuadrantDistribution({
    required this.distribution,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final total = distribution.values.fold<int>(0, (a, b) => a + b);
    if (total == 0) return const SizedBox.shrink();

    return Row(
      children: SignalQuadrant.values.map((q) {
        final count = distribution[q.name] ?? 0;
        final pct = (count / total * 100).round();
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: q.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(q.emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 4),
                Text(
                  '$pct%',
                  style: AppTypography.modernAccent(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: q.color,
                  ),
                ),
                Text(
                  q.localizedName(isEn ? AppLanguage.en : AppLanguage.tr),
                  style: AppTypography.elegantAccent(
                    fontSize: 10,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SignalHistoryTile extends StatelessWidget {
  final MoodEntry entry;
  final bool isEn;
  final bool isDark;

  const _SignalHistoryTile({
    required this.entry,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final signal = entry.signalId != null ? getSignalById(entry.signalId!) : null;
    final quadrant = entry.quadrant != null
        ? SignalQuadrant.values.where((q) => q.name == entry.quadrant).firstOrNull
        : null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (entry.signalId != null)
            SignalOrb(signalId: entry.signalId!, size: SignalOrbSize.inline)
          else
            Text(entry.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  signal?.localizedName(
                          isEn ? AppLanguage.en : AppLanguage.tr) ??
                      entry.emoji,
                  style: AppTypography.modernAccent(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                if (quadrant != null)
                  Text(
                    quadrant.localizedName(
                        isEn ? AppLanguage.en : AppLanguage.tr),
                    style: AppTypography.elegantAccent(
                      fontSize: 11,
                      color: quadrant.color,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '${entry.date.day}/${entry.date.month}',
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
  }
}

class _EmptyHistory extends StatelessWidget {
  final bool isEn;
  final bool isDark;

  const _EmptyHistory({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          isEn
              ? 'Log your first signal to start tracking your emotional compass'
              : 'Duygusal pusulacını takip etmeye başlamak için ilk sinyalini kaydet',
          textAlign: TextAlign.center,
          style: AppTypography.decorativeScript(
            fontSize: 13,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ),
    );
  }
}
