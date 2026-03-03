// ════════════════════════════════════════════════════════════════════════════
// VALUES COMPASS SCREEN - Personal values identification + flower viz
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/values_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

class ValuesCompassScreen extends ConsumerStatefulWidget {
  const ValuesCompassScreen({super.key});

  @override
  ConsumerState<ValuesCompassScreen> createState() =>
      _ValuesCompassScreenState();
}

class _ValuesCompassScreenState extends ConsumerState<ValuesCompassScreen> {
  final _selected = <String>[];
  bool _isSelecting = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = ref.watch(languageProvider) == AppLanguage.en;
    final serviceAsync = ref.watch(valuesServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: serviceAsync.maybeWhen(
          data: (service) {
            final hasValues = service.hasCompleted;
            final topValues = service.getTopValues();

            if (hasValues && !_isSelecting) {
              return _buildCompassView(topValues, isDark, isEn, service);
            }
            return _buildSelectionView(isDark, isEn, service);
          },
          orElse: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget _buildCompassView(
    List<PersonalValue> topValues,
    bool isDark,
    bool isEn,
    ValuesService service,
  ) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        GlassSliverAppBar(
          title: isEn ? 'Your Values' : 'Değerlerin',
          actions: [
            IconButton(
              icon: Icon(Icons.refresh_rounded,
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted),
              onPressed: () => setState(() {
                _isSelecting = true;
                _selected.clear();
              }),
            ),
          ],
        ),
        // Flower visualization
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: SizedBox(
                width: 220,
                height: 220,
                child: CustomPaint(
                  size: const Size(220, 220),
                  painter: _ValuesFlowerPainter(values: topValues),
                ),
              ),
            ),
          ).animate().fadeIn(duration: 500.ms).scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.0, 1.0),
              duration: 500.ms),
        ),
        // Value cards
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final value = topValues[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: value.color.withValues(alpha: 0.08),
                    border: Border.all(
                      color: value.color.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: value.color.withValues(alpha: 0.15),
                        ),
                        child: Icon(value.icon, size: 18, color: value.color),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${index + 1}. ${value.name(isEn)}',
                              style: AppTypography.subtitle(
                                fontSize: 14,
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                              ).copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              value.desc(isEn),
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
                    ],
                  ),
                ),
              ).animate().fadeIn(
                  delay: (100 + index * 80).ms, duration: 300.ms);
            },
            childCount: topValues.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _buildSelectionView(bool isDark, bool isEn, ValuesService service) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        GlassSliverAppBar(
          title: isEn ? 'Choose Your Values' : 'Değerlerini Seç',
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Text(
              isEn
                  ? 'Select your top 5 personal values — the principles that matter most to you.'
                  : 'En önemli 5 kişisel değerini seç — senin için en anlamlı ilkeleri.',
              style: AppTypography.subtitle(
                fontSize: 14,
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '${_selected.length}/5 ${isEn ? 'selected' : 'seçildi'}',
              style: AppTypography.subtitle(
                fontSize: 12,
                color: AppColors.starGold,
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final value = ValuesService.allValues[index];
              final isSelected = _selected.contains(value.key);
              final canSelect = _selected.length < 5 || isSelected;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selected.remove(value.key);
                      } else if (canSelect) {
                        _selected.add(value.key);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: isSelected
                          ? value.color.withValues(alpha: 0.12)
                          : (isDark ? Colors.white : Colors.black)
                              .withValues(alpha: 0.04),
                      border: Border.all(
                        color: isSelected
                            ? value.color.withValues(alpha: 0.3)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(value.icon,
                            size: 20,
                            color: isSelected
                                ? value.color
                                : (isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                value.name(isEn),
                                style: AppTypography.subtitle(
                                  fontSize: 14,
                                  color: isDark
                                      ? AppColors.textPrimary
                                      : AppColors.lightTextPrimary,
                                ).copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                value.desc(isEn),
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
                        if (isSelected)
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: value.color,
                            ),
                            child: Center(
                              child: Text(
                                '${_selected.indexOf(value.key) + 1}',
                                style: AppTypography.subtitle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(
                  delay: (30 * index).ms, duration: 200.ms);
            },
            childCount: ValuesService.allValues.length,
          ),
        ),
        // Save button
        if (_selected.length == 5)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: GestureDetector(
                onTap: () async {
                  await service.saveTopValues(_selected);
                  if (mounted) {
                    setState(() => _isSelecting = false);
                    ref.invalidate(valuesServiceProvider);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      colors: [AppColors.starGold, AppColors.celestialGold],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      isEn ? 'Save My Values' : 'Değerlerimi Kaydet',
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.deepSpace,
                      ),
                    ),
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 300.ms),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }
}

class _ValuesFlowerPainter extends CustomPainter {
  final List<PersonalValue> values;

  _ValuesFlowerPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.38;

    // Draw petals
    for (int i = 0; i < values.length; i++) {
      final angle = (i * 2 * math.pi / values.length) - math.pi / 2;
      final petalCenter = Offset(
        center.dx + radius * 0.6 * math.cos(angle),
        center.dy + radius * 0.6 * math.sin(angle),
      );

      // Petal fill
      final paint = Paint()
        ..color = values[i].color.withValues(alpha: 0.25)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(petalCenter, radius * 0.4, paint);

      // Petal border
      final borderPaint = Paint()
        ..color = values[i].color.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(petalCenter, radius * 0.4, borderPaint);
    }

    // Center circle
    final centerPaint = Paint()
      ..color = AppColors.starGold.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.2, centerPaint);

    final centerBorder = Paint()
      ..color = AppColors.starGold.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius * 0.2, centerBorder);
  }

  @override
  bool shouldRepaint(covariant _ValuesFlowerPainter oldDelegate) =>
      values != oldDelegate.values;
}
