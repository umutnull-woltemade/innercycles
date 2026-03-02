// ════════════════════════════════════════════════════════════════════════════
// TRIGGER MAP SCREEN - Visual emotional trigger tracking
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/emotional_trigger.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';

class TriggerMapScreen extends ConsumerStatefulWidget {
  const TriggerMapScreen({super.key});

  @override
  ConsumerState<TriggerMapScreen> createState() => _TriggerMapScreenState();
}

class _TriggerMapScreenState extends ConsumerState<TriggerMapScreen> {
  final _labelController = TextEditingController();
  TriggerCategory _selectedCategory = TriggerCategory.relationships;

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(triggerMapServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (service) {
              final triggers = service.getAll();
              final topTriggers = service.getTopTriggers();

              return CustomScrollView(
                slivers: [
                  GlassSliverAppBar(
                    title: isEn ? 'Trigger Map' : 'Tetikleyici Haritası',
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          // Bubble visualization
                          if (topTriggers.isNotEmpty) ...[
                            GradientText(
                              isEn ? 'Your Trigger Landscape' : 'Tetikleyici Manzaran',
                              variant: GradientTextVariant.aurora,
                              style: AppTypography.modernAccent(fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 220,
                              child: CustomPaint(
                                painter: _TriggerBubblePainter(
                                  triggers: topTriggers,
                                  isDark: isDark,
                                ),
                                size: Size.infinite,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // Add trigger
                          GradientText(
                            isEn ? 'Add Trigger' : 'Tetikleyici Ekle',
                            variant: GradientTextVariant.gold,
                            style: AppTypography.modernAccent(fontSize: 15),
                          ),
                          const SizedBox(height: 10),

                          // Category chips
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: TriggerCategory.values.map((c) {
                              final selected = c == _selectedCategory;
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedCategory = c),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
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
                                    '${c.emoji} ${isEn ? c.nameEn : c.nameTr}',
                                    style: AppTypography.elegantAccent(
                                      fontSize: 12,
                                      color: selected
                                          ? AppColors.starGold
                                          : (isDark
                                              ? AppColors.textSecondary
                                              : AppColors
                                                  .lightTextSecondary),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 10),

                          // Input + add button
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _labelController,
                                  style: AppTypography.elegantAccent(
                                    fontSize: 14,
                                    color: isDark
                                        ? AppColors.textPrimary
                                        : AppColors.lightTextPrimary,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: isEn
                                        ? 'e.g. "Feeling judged at work"'
                                        : 'ör. "İşte yargılanma hissi"',
                                    hintStyle: AppTypography.elegantAccent(
                                      fontSize: 14,
                                      color: isDark
                                          ? AppColors.textMuted
                                          : AppColors.lightTextMuted,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: isDark
                                            ? Colors.white
                                                .withValues(alpha: 0.1)
                                            : Colors.black
                                                .withValues(alpha: 0.08),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: isDark
                                            ? Colors.white
                                                .withValues(alpha: 0.1)
                                            : Colors.black
                                                .withValues(alpha: 0.08),
                                      ),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 10),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () async {
                                  if (_labelController.text.trim().isEmpty) {
                                    return;
                                  }
                                  await service.addTrigger(
                                    label: _labelController.text.trim(),
                                    category: _selectedCategory,
                                  );
                                  _labelController.clear();
                                  ref.invalidate(triggerMapServiceProvider);
                                },
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      AppColors.starGold,
                                      AppColors.celestialGold,
                                    ]),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.add_rounded,
                                      color: AppColors.deepSpace),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Trigger list by category
                          if (triggers.isNotEmpty) ...[
                            GradientText(
                              isEn ? 'All Triggers' : 'Tüm Tetikleyiciler',
                              variant: GradientTextVariant.amethyst,
                              style: AppTypography.modernAccent(fontSize: 15),
                            ),
                            const SizedBox(height: 10),
                            ...triggers
                                .map((t) => _TriggerTile(
                                      trigger: t,
                                      isEn: isEn,
                                      isDark: isDark,
                                      onLog: () async {
                                        await service
                                            .logOccurrence(t.id);
                                        ref.invalidate(
                                            triggerMapServiceProvider);
                                      },
                                      onDelete: () async {
                                        await service.delete(t.id);
                                        ref.invalidate(
                                            triggerMapServiceProvider);
                                      },
                                    ))
                                ,
                          ],

                          if (triggers.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Center(
                                child: Column(
                                  children: [
                                    const Text('\u{1F30A}',
                                        style: TextStyle(fontSize: 40)),
                                    const SizedBox(height: 12),
                                    Text(
                                      isEn
                                          ? 'Start mapping your triggers\nto understand your patterns'
                                          : 'Kalıplarını anlamak için\ntetikleyicilerini haritalamaya başla',
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

class _TriggerTile extends StatelessWidget {
  final EmotionalTrigger trigger;
  final bool isEn;
  final bool isDark;
  final VoidCallback onLog;
  final VoidCallback onDelete;

  const _TriggerTile({
    required this.trigger,
    required this.isEn,
    required this.isDark,
    required this.onLog,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          children: [
            Text(trigger.category.emoji,
                style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trigger.label,
                    style: AppTypography.modernAccent(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${trigger.recentFrequency}x ${isEn ? 'this month' : 'bu ay'} \u2022 '
                    '${isEn ? 'Intensity' : 'Yoğunluk'}: ${trigger.intensity}/5',
                    style: AppTypography.elegantAccent(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onLog,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      AppColors.starGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isEn ? '+1' : '+1',
                  style: AppTypography.modernAccent(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.starGold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _TriggerBubblePainter extends CustomPainter {
  final List<EmotionalTrigger> triggers;
  final bool isDark;

  _TriggerBubblePainter({required this.triggers, required this.isDark});

  static const _categoryColors = <TriggerCategory, Color>{
    TriggerCategory.relationships: Color(0xFFE57373),
    TriggerCategory.work: Color(0xFF64B5F6),
    TriggerCategory.health: Color(0xFF81C784),
    TriggerCategory.selfImage: Color(0xFFBA68C8),
    TriggerCategory.environment: Color(0xFFFFB74D),
    TriggerCategory.memories: Color(0xFF4FC3F7),
  };

  @override
  void paint(Canvas canvas, Size size) {
    if (triggers.isEmpty) return;

    final maxFreq = triggers
        .map((t) => t.recentFrequency)
        .reduce((a, b) => a > b ? a : b)
        .clamp(1, 999);

    final random = math.Random(42); // deterministic layout
    final centers = <Offset>[];

    for (int i = 0; i < triggers.length; i++) {
      final t = triggers[i];
      final ratio = t.recentFrequency / maxFreq;
      final radius = 20 + ratio * 40;

      // Simple force-directed placement
      Offset center;
      if (i == 0) {
        center = Offset(size.width / 2, size.height / 2);
      } else {
        final angle = random.nextDouble() * 2 * math.pi;
        final dist = 50 + random.nextDouble() * 60;
        center = Offset(
          (size.width / 2 + math.cos(angle) * dist)
              .clamp(radius, size.width - radius),
          (size.height / 2 + math.sin(angle) * dist)
              .clamp(radius, size.height - radius),
        );
      }
      centers.add(center);

      final color = _categoryColors[t.category] ?? AppColors.starGold;
      final paint = Paint()
        ..color = color.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, radius, paint);

      final borderPaint = Paint()
        ..color = color.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      canvas.drawCircle(center, radius, borderPaint);

      // Label
      final textPainter = TextPainter(
        text: TextSpan(
          text: t.label.length > 14 ? '${t.label.substring(0, 12)}...' : t.label,
          style: TextStyle(
            fontSize: 10 + ratio * 3,
            color: isDark ? Colors.white70 : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: radius * 2 - 8);

      textPainter.paint(
        canvas,
        Offset(center.dx - textPainter.width / 2,
            center.dy - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TriggerBubblePainter old) =>
      triggers != old.triggers || isDark != old.isDark;
}
