// ════════════════════════════════════════════════════════════════════════════
// PATTERN LOOP ANALYZER - Behavioral Reinforcement Loop Visualization
// ════════════════════════════════════════════════════════════════════════════
// Structured layout showing detected behavioral loops with the 5-stage chain:
// Trigger → Emotional Shift → Behavior → Outcome → Reinforcement
// HIG-compliant: clear hierarchy, minimal cognitive load.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/services/pattern_loop_service.dart';
import 'cycle_wave_painter.dart';

class PatternLoopAnalyzer extends StatelessWidget {
  final PatternLoopAnalysis analysis;
  final bool isDark;
  final bool isEn;

  const PatternLoopAnalyzer({
    super.key,
    required this.analysis,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    if (analysis.detectedLoops.isEmpty) {
      return _buildEmpty(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Text(
          isEn ? 'Pattern Loops' : 'Kalıp Döngüleri',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: isDark
                ? AppColors.textPrimary
                : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isEn
              ? 'Behavioral patterns detected in your entries'
              : 'Kayıtlarında tespit edilen davranışsal kalıplar',
          style: TextStyle(
            fontSize: 13,
            color: isDark
                ? AppColors.textMuted
                : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),

        // Loop cards
        ...analysis.detectedLoops.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
            child: _PatternLoopCard(
              loop: entry.value,
              isDark: isDark,
              isEn: isEn,
            ),
          ).animate().fadeIn(
            delay: (entry.key * 80).ms,
            duration: 400.ms,
          ).slideY(begin: 0.03, end: 0, duration: 400.ms);
        }),

        // Reinforcement breakdown
        if (analysis.reinforcementBreakdown.isNotEmpty)
          _buildBreakdown(context),
      ],
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.7)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: isDark
              ? AppColors.surfaceLight.withValues(alpha: 0.3)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.loop,
            color: isDark
                ? AppColors.textMuted
                : AppColors.lightTextMuted,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isEn
                  ? 'Keep journaling to discover your behavioral patterns'
                  : 'Davranışsal kalıplarını keşfetmek için kayıt yapmaya devam et',
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdown(BuildContext context) {
    final positive =
        analysis.reinforcementBreakdown[ReinforcementType.positive] ?? 0;
    final negative =
        analysis.reinforcementBreakdown[ReinforcementType.negative] ?? 0;
    final neutral =
        analysis.reinforcementBreakdown[ReinforcementType.neutral] ?? 0;
    final total = positive + negative + neutral;
    if (total == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.6)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Row(
        children: [
          if (positive > 0)
            _buildBreakdownChip(
              isEn ? 'Positive' : 'Pozitif',
              positive,
              AppColors.success,
            ),
          if (positive > 0 && (negative > 0 || neutral > 0))
            const SizedBox(width: 8),
          if (negative > 0)
            _buildBreakdownChip(
              isEn ? 'Negative' : 'Negatif',
              negative,
              AppColors.warning,
            ),
          if (negative > 0 && neutral > 0) const SizedBox(width: 8),
          if (neutral > 0)
            _buildBreakdownChip(
              isEn ? 'Neutral' : 'Nötr',
              neutral,
              AppColors.textMuted,
            ),
        ],
      ),
    );
  }

  Widget _buildBreakdownChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SINGLE PATTERN LOOP CARD
// ════════════════════════════════════════════════════════════════════════════

class _PatternLoopCard extends StatefulWidget {
  final PatternLoop loop;
  final bool isDark;
  final bool isEn;

  const _PatternLoopCard({
    required this.loop,
    required this.isDark,
    required this.isEn,
  });

  @override
  State<_PatternLoopCard> createState() => _PatternLoopCardState();
}

class _PatternLoopCardState extends State<_PatternLoopCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final loop = widget.loop;
    final color = _reinforcementColor(loop.reinforcementType);
    final areaColor = kAreaColors[loop.primaryArea] ?? AppColors.auroraStart;

    return Container(
      decoration: BoxDecoration(
        color: widget.isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: widget.isDark ? 0.08 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (tappable)
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              child: Row(
                children: [
                  // Reinforcement indicator
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _reinforcementIcon(loop.reinforcementType),
                      color: color,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Area badge
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: areaColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.isEn
                                  ? loop.primaryArea.displayNameEn
                                  : loop.primaryArea.displayNameTr,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: areaColor,
                              ),
                            ),
                            if (loop.secondaryArea case final secondary?) ...[
                              Text(
                                ' + ',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: widget.isDark
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                              Text(
                                widget.isEn
                                    ? secondary.displayNameEn
                                    : secondary.displayNameTr,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: kAreaColors[secondary] ??
                                      AppColors.auroraStart,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.isEn ? loop.insightEn : loop.insightTr,
                          style: TextStyle(
                            fontSize: 13,
                            color: widget.isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Expand icon
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: widget.isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded content: 5-stage chain
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: _buildLoopChain(context, loop, color),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }

  Widget _buildLoopChain(
    BuildContext context,
    PatternLoop loop,
    Color color,
  ) {
    final stages = [
      loop.trigger,
      loop.emotionalShift,
      loop.behavior,
      loop.outcome,
      loop.reinforcement,
    ];

    final stageIcons = [
      Icons.flash_on,
      Icons.swap_vert,
      Icons.directions_walk,
      Icons.flag_outlined,
      Icons.loop,
    ];

    final stageLabelsEn = [
      'Trigger',
      'Emotional Shift',
      'Behavior',
      'Outcome',
      'Reinforcement',
    ];

    final stageLabelsTr = [
      'Tetikleyici',
      'Duygusal Kayma',
      'Davranış',
      'Sonuç',
      'Pekiştirme',
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.spacingLg,
        0,
        AppConstants.spacingLg,
        AppConstants.spacingLg,
      ),
      child: Column(
        children: [
          // Strength indicator
          Row(
            children: [
              Text(
                widget.isEn ? 'Strength' : 'Güç',
                style: TextStyle(
                  fontSize: 11,
                  color: widget.isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: loop.strength,
                    backgroundColor: widget.isDark
                        ? AppColors.surfaceLight.withValues(alpha: 0.3)
                        : AppColors.lightSurfaceVariant,
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 4,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(loop.strength * 100).round()}%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingMd),

          // 5-stage chain
          ...stages.asMap().entries.map((entry) {
            final idx = entry.key;
            final stage = entry.value;
            final isLast = idx == stages.length - 1;

            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stage indicator
                    Column(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: color.withValues(
                              alpha: 0.08 + (idx * 0.04),
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: color.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Icon(
                            stageIcons[idx],
                            size: 14,
                            color: color,
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 1.5,
                            height: 20,
                            color: color.withValues(alpha: 0.2),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Stage content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isEn
                                ? stageLabelsEn[idx]
                                : stageLabelsTr[idx],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: color.withValues(alpha: 0.7),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.isEn ? stage.labelEn : stage.labelTr,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: widget.isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          if (stage.descriptionEn != null)
                            Text(
                              widget.isEn
                                  ? stage.descriptionEn!
                                  : (stage.descriptionTr ??
                                      stage.descriptionEn!),
                              style: TextStyle(
                                fontSize: 12,
                                color: widget.isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          if (!isLast) const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),

          // Action recommendation
          if (loop.actionEn != null) ...[
            const SizedBox(height: AppConstants.spacingMd),
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingSm),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 14,
                    color: color,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.isEn
                          ? loop.actionEn!
                          : (loop.actionTr ?? loop.actionEn!),
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _reinforcementColor(ReinforcementType type) {
    switch (type) {
      case ReinforcementType.positive:
        return AppColors.success;
      case ReinforcementType.negative:
        return AppColors.warning;
      case ReinforcementType.neutral:
        return AppColors.auroraStart;
    }
  }

  IconData _reinforcementIcon(ReinforcementType type) {
    switch (type) {
      case ReinforcementType.positive:
        return Icons.trending_up;
      case ReinforcementType.negative:
        return Icons.trending_down;
      case ReinforcementType.neutral:
        return Icons.swap_horiz;
    }
  }
}
