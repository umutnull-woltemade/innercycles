// ════════════════════════════════════════════════════════════════════════════
// ECOSYSTEM WIDGETS - Shared UI components for InnerCycles ecosystem
// ════════════════════════════════════════════════════════════════════════════
// 1. ToolEmptyState - Empty state with progress + demo CTA
// 2. ToolDoneScreen - Completion screen with next actions
// 3. NextBestActions - Vertical list of next-step suggestions
// 4. RelatedToolsStrip - Horizontal scrolling related tools
// 5. ToolFeedbackFooter - Was this useful? thumbs up/down
// 6. ActiveChallengeCard - Challenge card with progress bar
// 7. QuickActionFAB - Expandable FAB with 5 action chips
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

// ═══════════════════════════════════════════════════════════════════════════
// DATA MODELS
// ═══════════════════════════════════════════════════════════════════════════

class DoneScreenAction {
  final String labelEn;
  final String labelTr;
  final IconData icon;
  final String route;
  final bool isPrimary;

  const DoneScreenAction({
    required this.labelEn,
    required this.labelTr,
    required this.icon,
    required this.route,
    this.isPrimary = false,
  });
}

class NextAction {
  final String labelEn;
  final String labelTr;
  final IconData icon;
  final String route;
  final bool isPrimary;

  const NextAction({
    required this.labelEn,
    required this.labelTr,
    required this.icon,
    required this.route,
    this.isPrimary = false,
  });
}

class RelatedTool {
  final String nameEn;
  final String nameTr;
  final IconData icon;
  final Color color;
  final String route;

  const RelatedTool({
    required this.nameEn,
    required this.nameTr,
    required this.icon,
    required this.color,
    required this.route,
  });
}

// ═══════════════════════════════════════════════════════════════════════════
// 1. TOOL EMPTY STATE
// ═══════════════════════════════════════════════════════════════════════════

class ToolEmptyState extends StatelessWidget {
  final IconData icon;
  final String titleEn;
  final String titleTr;
  final String descriptionEn;
  final String descriptionTr;
  final int currentEntries;
  final int requiredEntries;
  final VoidCallback? onSeeExample;
  final VoidCallback? onStartTemplate;
  final bool isEn;
  final bool isDark;

  const ToolEmptyState({
    super.key,
    required this.icon,
    required this.titleEn,
    required this.titleTr,
    required this.descriptionEn,
    required this.descriptionTr,
    this.currentEntries = 0,
    this.requiredEntries = 0,
    this.onSeeExample,
    this.onStartTemplate,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final progress = requiredEntries > 0
        ? (currentEntries / requiredEntries).clamp(0.0, 1.0)
        : 0.0;

    return Padding(
          padding: const EdgeInsets.all(AppConstants.spacingXl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 64,
                color: isDark
                    ? AppColors.textMuted.withValues(alpha: 0.4)
                    : AppColors.lightTextMuted.withValues(alpha: 0.4),
              ),
              const SizedBox(height: AppConstants.spacingLg),
              Text(
                isEn ? titleEn : titleTr,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: AppConstants.spacingMd),
              Text(
                isEn ? descriptionEn : descriptionTr,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.5,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              if (requiredEntries > 0) ...[
                const SizedBox(height: AppConstants.spacingLg),
                SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.black.withValues(alpha: 0.06),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.auroraStart,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$currentEntries / $requiredEntries',
                        style: TextStyle(
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
              const SizedBox(height: AppConstants.spacingXl),
              if (onStartTemplate != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onStartTemplate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.auroraStart,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusMd,
                        ),
                      ),
                    ),
                    child: Text(
                      isEn ? 'Start with Template' : 'Sablonla Basla',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              if (onSeeExample != null) ...[
                const SizedBox(height: AppConstants.spacingSm),
                TextButton(
                  onPressed: onSeeExample,
                  child: Text(
                    isEn ? 'See Example' : 'Ornek Gor',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.05, duration: 500.ms, curve: Curves.easeOut);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 2. TOOL DONE SCREEN
// ═══════════════════════════════════════════════════════════════════════════

class ToolDoneScreen extends StatelessWidget {
  final String headlineEn;
  final String headlineTr;
  final String? impactTextEn;
  final String? impactTextTr;
  final List<DoneScreenAction> actions;
  final bool isEn;
  final bool isDark;

  const ToolDoneScreen({
    super.key,
    required this.headlineEn,
    required this.headlineTr,
    this.impactTextEn,
    this.impactTextTr,
    this.actions = const [],
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.auto_awesome,
            size: 56,
            color: AppColors.starGold,
          ).animate().scale(
            begin: const Offset(0.5, 0.5),
            end: const Offset(1.0, 1.0),
            duration: 600.ms,
            curve: Curves.elasticOut,
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Text(
            isEn ? headlineEn : headlineTr,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          if (impactTextEn != null) ...[
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              isEn ? impactTextEn! : (impactTextTr ?? impactTextEn!),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
                height: 1.5,
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
          ],
          const SizedBox(height: AppConstants.spacingXl),
          ...actions.asMap().entries.map((entry) {
            final index = entry.key;
            final action = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
              child: SizedBox(
                width: double.infinity,
                child: action.isPrimary
                    ? ElevatedButton.icon(
                        onPressed: () => context.push(action.route),
                        icon: Icon(action.icon, size: 18),
                        label: Text(isEn ? action.labelEn : action.labelTr),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.auroraStart,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusMd,
                            ),
                          ),
                        ),
                      )
                    : OutlinedButton.icon(
                        onPressed: () => context.push(action.route),
                        icon: Icon(action.icon, size: 18),
                        label: Text(isEn ? action.labelEn : action.labelTr),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                          side: BorderSide(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.15)
                                : Colors.black.withValues(alpha: 0.1),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusMd,
                            ),
                          ),
                        ),
                      ),
              ),
            ).animate().fadeIn(
              delay: Duration(milliseconds: 400 + index * 100),
              duration: 400.ms,
            );
          }),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 3. NEXT BEST ACTIONS
// ═══════════════════════════════════════════════════════════════════════════

class NextBestActions extends StatelessWidget {
  final List<NextAction> actions;
  final String titleEn;
  final String titleTr;
  final bool isEn;
  final bool isDark;

  const NextBestActions({
    super.key,
    required this.actions,
    this.titleEn = 'Next Steps',
    this.titleTr = 'Sonraki Adimlar',
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
          ),
          child: Text(
            isEn ? titleEn : titleTr,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ).animate().fadeIn(duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        ...actions.asMap().entries.map((entry) {
          final index = entry.key;
          final action = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLg,
              vertical: 4,
            ),
            child: Semantics(
              button: true,
              label: isEn ? action.labelEn : action.labelTr,
              child: GestureDetector(
                onTap: () => context.push(action.route),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingLg,
                    vertical: AppConstants.spacingMd,
                  ),
                  decoration: BoxDecoration(
                    color: action.isPrimary
                        ? null
                        : (isDark
                              ? AppColors.surfaceDark
                              : AppColors.lightCard),
                    gradient: action.isPrimary
                        ? AppColors.primaryGradient
                        : null,
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    border: action.isPrimary
                        ? null
                        : Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : Colors.black.withValues(alpha: 0.06),
                          ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        action.icon,
                        size: 18,
                        color: action.isPrimary
                            ? Colors.white
                            : (isDark
                                  ? AppColors.auroraStart
                                  : AppColors.lightAuroraStart),
                      ),
                      const SizedBox(width: AppConstants.spacingMd),
                      Expanded(
                        child: Text(
                          isEn ? action.labelEn : action.labelTr,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: action.isPrimary
                                ? Colors.white
                                : (isDark
                                      ? AppColors.textPrimary
                                      : AppColors.lightTextPrimary),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: action.isPrimary
                            ? Colors.white.withValues(alpha: 0.6)
                            : (isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(
            delay: Duration(milliseconds: 100 + index * 80),
            duration: 400.ms,
          );
        }),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 4. RELATED TOOLS STRIP
// ═══════════════════════════════════════════════════════════════════════════

class RelatedToolsStrip extends StatelessWidget {
  final List<RelatedTool> tools;
  final String titleEn;
  final String titleTr;
  final bool isEn;
  final bool isDark;

  const RelatedToolsStrip({
    super.key,
    required this.tools,
    this.titleEn = 'Related Tools',
    this.titleTr = 'Ilgili Araclar',
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
          ),
          child: Text(
            isEn ? titleEn : titleTr,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ).animate().fadeIn(duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLg,
            ),
            itemCount: tools.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppConstants.spacingSm),
            itemBuilder: (context, index) {
              final tool = tools[index];
              return Semantics(
                button: true,
                label: isEn ? tool.nameEn : tool.nameTr,
                child: GestureDetector(
                  onTap: () => context.push(tool.route),
                  child: Container(
                    width: 88,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.spacingMd,
                      horizontal: AppConstants.spacingSm,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceDark
                          : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusMd,
                      ),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.06),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: tool.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusSm,
                            ),
                          ),
                          child: Icon(tool.icon, size: 20, color: tool.color),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isEn ? tool.nameEn : tool.nameTr,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(
                delay: Duration(milliseconds: 80 + index * 60),
                duration: 400.ms,
              );
            },
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 5. TOOL FEEDBACK FOOTER
// ═══════════════════════════════════════════════════════════════════════════

class ToolFeedbackFooter extends StatefulWidget {
  final String toolId;
  final bool isEn;
  final bool isDark;
  final Function(bool isPositive) onFeedback;

  const ToolFeedbackFooter({
    super.key,
    required this.toolId,
    required this.isEn,
    required this.isDark,
    required this.onFeedback,
  });

  @override
  State<ToolFeedbackFooter> createState() => _ToolFeedbackFooterState();
}

class _ToolFeedbackFooterState extends State<ToolFeedbackFooter> {
  bool? _selectedFeedback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLg,
        vertical: AppConstants.spacingMd,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.isEn ? 'Was this useful?' : 'Bu faydali oldu mu?',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: widget.isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          _buildFeedbackButton(
            Icons.thumb_up_outlined,
            Icons.thumb_up,
            true,
            AppColors.success,
          ),
          const SizedBox(width: AppConstants.spacingSm),
          _buildFeedbackButton(
            Icons.thumb_down_outlined,
            Icons.thumb_down,
            false,
            AppColors.softCoral,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildFeedbackButton(
    IconData icon,
    IconData activeIcon,
    bool isPositive,
    Color activeColor,
  ) {
    final isActive = _selectedFeedback == isPositive;
    return Semantics(
      button: true,
      label: isPositive
          ? (widget.isEn ? 'Thumbs up' : 'Beğen')
          : (widget.isEn ? 'Thumbs down' : 'Beğenme'),
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedFeedback = isPositive);
          widget.onFeedback(isPositive);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive
                ? activeColor.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            border: Border.all(
              color: isActive
                  ? activeColor.withValues(alpha: 0.4)
                  : (widget.isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.08)),
            ),
          ),
          child: Icon(
            isActive ? activeIcon : icon,
            size: 18,
            color: isActive
                ? activeColor
                : (widget.isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 6. ACTIVE CHALLENGE CARD
// ═══════════════════════════════════════════════════════════════════════════

class ActiveChallengeCard extends StatelessWidget {
  final String challengeTitle;
  final String emoji;
  final int currentDay;
  final int totalDays;
  final String todayActionEn;
  final String todayActionTr;
  final VoidCallback onApply;
  final bool isEn;
  final bool isDark;

  const ActiveChallengeCard({
    super.key,
    required this.challengeTitle,
    required this.emoji,
    required this.currentDay,
    required this.totalDays,
    required this.todayActionEn,
    required this.todayActionTr,
    required this.onApply,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalDays > 0
        ? (currentDay / totalDays).clamp(0.0, 1.0)
        : 0.0;

    return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
          ),
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.lightCard,
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            border: Border.all(
              color: isDark
                  ? AppColors.auroraStart.withValues(alpha: 0.2)
                  : AppColors.lightAuroraStart.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: AppConstants.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challengeTitle,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          isEn
                              ? 'Day $currentDay of $totalDays'
                              : '$totalDays gunun $currentDay. gunu',
                          style: GoogleFonts.inter(
                            fontSize: 12,
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
              const SizedBox(height: AppConstants.spacingMd),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.06),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? AppColors.auroraStart : AppColors.lightAuroraStart,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingMd),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.auroraStart.withValues(alpha: 0.08)
                      : AppColors.lightAuroraStart.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: Text(
                  isEn ? todayActionEn : todayActionTr,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.4,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingMd),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.auroraStart,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusMd,
                      ),
                    ),
                  ),
                  child: Text(
                    isEn ? 'Apply Now' : 'Simdi Uygula',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.08, duration: 500.ms, curve: Curves.easeOut);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 7. QUICK ACTION FAB
// ═══════════════════════════════════════════════════════════════════════════

class QuickActionFAB extends StatefulWidget {
  final VoidCallback onJournal;
  final VoidCallback onDream;
  final VoidCallback onGratitude;
  final VoidCallback onMood;
  final VoidCallback onBreathing;
  final bool isEn;
  final bool isDark;

  const QuickActionFAB({
    super.key,
    required this.onJournal,
    required this.onDream,
    required this.onGratitude,
    required this.onMood,
    required this.onBreathing,
    required this.isEn,
    required this.isDark,
  });

  @override
  State<QuickActionFAB> createState() => _QuickActionFABState();
}

class _QuickActionFABState extends State<QuickActionFAB>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final actions = [
      _FABAction(
        Icons.edit_note,
        widget.isEn ? 'Journal' : 'Gunluk',
        AppColors.auroraStart,
        () {
          _toggle();
          widget.onJournal();
        },
      ),
      _FABAction(
        Icons.nightlight_round,
        widget.isEn ? 'Dream' : 'Ruya',
        AppColors.amethyst,
        () {
          _toggle();
          widget.onDream();
        },
      ),
      _FABAction(
        Icons.favorite,
        widget.isEn ? 'Gratitude' : 'Sukran',
        AppColors.brandPink,
        () {
          _toggle();
          widget.onGratitude();
        },
      ),
      _FABAction(
        Icons.mood,
        widget.isEn ? 'Mood' : 'Ruh Hali',
        AppColors.celestialGold,
        () {
          _toggle();
          widget.onMood();
        },
      ),
      _FABAction(
        Icons.air,
        widget.isEn ? 'Breathe' : 'Nefes',
        AppColors.success,
        () {
          _toggle();
          widget.onBreathing();
        },
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            return ClipRect(
              child: Align(
                heightFactor: _expandAnimation.value,
                alignment: Alignment.bottomCenter,
                child: Opacity(opacity: _expandAnimation.value, child: child),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: actions
                  .map(
                    (a) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppConstants.spacingSm,
                      ),
                      child: _buildChip(a),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        Semantics(
          button: true,
          label: _isExpanded ? 'Close quick actions' : 'Open quick actions',
          child: GestureDetector(
            onTap: _toggle,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.auroraStart.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AnimatedRotation(
                turns: _isExpanded ? 0.125 : 0,
                duration: const Duration(milliseconds: 300),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(_FABAction action) {
    return Semantics(
      button: true,
      label: action.label,
      child: GestureDetector(
        onTap: action.onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: widget.isDark
                    ? AppColors.surfaceDark
                    : AppColors.lightCard,
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: widget.isDark ? 0.3 : 0.08,
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                action.label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: widget.isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ),
            const SizedBox(width: AppConstants.spacingSm),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: action.color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: action.color.withValues(alpha: 0.3)),
              ),
              child: Icon(action.icon, size: 20, color: action.color),
            ),
          ],
        ),
      ),
    );
  }
}

class _FABAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _FABAction(this.icon, this.label, this.color, this.onTap);
}
