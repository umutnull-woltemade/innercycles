// ════════════════════════════════════════════════════════════════════════════
// MOOD COMPASS - Full circular compass bottom sheet with 16 signals
// ════════════════════════════════════════════════════════════════════════════
// Premium feature: 4 quadrants arranged in compass directions with all 16
// signal orbs positioned around a circular layout. Axis labels for
// Energy (vertical) and Pleasantness (horizontal).
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/content/signal_content.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/haptic_service.dart';
import '../../../shared/widgets/signal_orb.dart';

/// Shows the mood compass as a modal bottom sheet.
Future<MoodSignal?> showMoodCompass(BuildContext context) {
  return showModalBottomSheet<MoodSignal>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const MoodCompassSheet(),
  );
}

class MoodCompassSheet extends ConsumerStatefulWidget {
  const MoodCompassSheet({super.key});

  @override
  ConsumerState<MoodCompassSheet> createState() => _MoodCompassSheetState();
}

class _MoodCompassSheetState extends ConsumerState<MoodCompassSheet> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final size = MediaQuery.of(context).size;
    final compassSize = math.min(size.width - 48, 340.0);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cosmicPurple : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          // Handle
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            isEn ? 'Mood Compass' : 'Ruh Hali Pusulası',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isEn ? 'Tap the signal closest to how you feel' : 'Hissine en yakın sinyale dokun',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 20),
          // Compass
          SizedBox(
            width: compassSize,
            height: compassSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Compass lines
                RepaintBoundary(
                  child: CustomPaint(
                    size: Size(compassSize, compassSize),
                    painter: _CompassPainter(isDark: isDark),
                  ),
                ),
                // Axis labels
                _AxisLabel(
                  text: isEn ? 'High Energy' : 'Yüksek Enerji',
                  alignment: Alignment.topCenter,
                  offset: const Offset(0, 4),
                  isDark: isDark,
                ),
                _AxisLabel(
                  text: isEn ? 'Low Energy' : 'Düşük Enerji',
                  alignment: Alignment.bottomCenter,
                  offset: const Offset(0, -4),
                  isDark: isDark,
                ),
                _AxisLabel(
                  text: isEn ? 'Pleasant' : 'Hoş',
                  alignment: Alignment.centerRight,
                  offset: const Offset(-4, 0),
                  isDark: isDark,
                ),
                _AxisLabel(
                  text: isEn ? 'Unpleasant' : 'Nahoş',
                  alignment: Alignment.centerLeft,
                  offset: const Offset(4, 0),
                  isDark: isDark,
                ),
                // Signal orbs positioned in compass layout
                ..._buildOrbPositions(compassSize, language, isDark),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 20),
          // Confirm button
          if (_selectedId != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    final signal = getSignalById(_selectedId!);
                    if (signal != null) {
                      Navigator.of(context).pop(signal);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.starGold,
                    foregroundColor: AppColors.deepSpace,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isEn ? 'Log Signal' : 'Sinyali Kaydet',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }

  List<Widget> _buildOrbPositions(
      double compassSize, AppLanguage language, bool isDark) {
    final center = compassSize / 2;
    final radius = compassSize * 0.35;
    final widgets = <Widget>[];

    // Position signals in their quadrant arc
    // Fire (top-right), Water (bottom-right), Storm (top-left), Shadow (bottom-left)
    final quadrantAngles = {
      SignalQuadrant.fire: -math.pi / 4, // NE
      SignalQuadrant.water: math.pi / 4, // SE
      SignalQuadrant.storm: -3 * math.pi / 4, // NW
      SignalQuadrant.shadow: 3 * math.pi / 4, // SW
    };

    for (final quadrant in SignalQuadrant.values) {
      final signals = getSignalsByQuadrant(quadrant);
      final baseAngle = quadrantAngles[quadrant]!;
      final spread = math.pi / 6; // ~30 degrees

      for (int i = 0; i < signals.length; i++) {
        final signal = signals[i];
        final angle = baseAngle + (i - 1.5) * (spread / 3);
        final r = radius * (0.7 + i * 0.1);
        final x = center + r * math.cos(angle) - 16;
        final y = center + r * math.sin(angle) - 16;

        widgets.add(
          Positioned(
            left: x,
            top: y,
            child: GestureDetector(
              onTap: () {
                HapticService.moodSelected();
                setState(() => _selectedId = signal.id);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: 200.ms,
                    padding: const EdgeInsets.all(2),
                    decoration: _selectedId == signal.id
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
                      animate: _selectedId == signal.id,
                    ),
                  ),
                  if (_selectedId == signal.id) ...[
                    const SizedBox(height: 2),
                    Text(
                      signal.localizedName(language),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
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

class _AxisLabel extends StatelessWidget {
  final String text;
  final Alignment alignment;
  final Offset offset;
  final bool isDark;

  const _AxisLabel({
    required this.text,
    required this.alignment,
    required this.offset,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: offset,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: (isDark ? AppColors.textMuted : AppColors.lightTextMuted)
                .withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}

class _CompassPainter extends CustomPainter {
  final bool isDark;
  _CompassPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final lineColor = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06);

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Cross lines
    canvas.drawLine(
      Offset(center.dx, 24),
      Offset(center.dx, size.height - 24),
      paint,
    );
    canvas.drawLine(
      Offset(24, center.dy),
      Offset(size.width - 24, center.dy),
      paint,
    );

    // Concentric circles
    for (final r in [0.2, 0.35, 0.5]) {
      canvas.drawCircle(center, size.width * r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
