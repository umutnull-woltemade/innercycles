// ════════════════════════════════════════════════════════════════════════════
// MILESTONE SCREEN - InnerCycles Badge & Achievement Gallery
// ════════════════════════════════════════════════════════════════════════════
// Displays all 30 milestones across 6 categories in a filterable grid.
// Earned badges show full color + emoji; locked badges are dimmed with a
// lock icon and hint text. Tapping an earned badge opens a detail dialog.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/milestone_service.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';
import '../../../data/services/l10n_service.dart';

// ════════════════════════════════════════════════════════════════════════════
// MILESTONE SCREEN
// ════════════════════════════════════════════════════════════════════════════

class MilestoneScreen extends ConsumerWidget {
  const MilestoneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final milestoneAsync = ref.watch(milestoneServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: milestoneAsync.when(
          loading: () => const CosmicLoadingIndicator(),
          error: (_, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    CommonStrings.somethingWentWrong(language),
                    textAlign: TextAlign.center,
                    style: AppTypography.subtitle(
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () =>
                        ref.invalidate(milestoneServiceProvider),
                    icon: Icon(Icons.refresh_rounded,
                        size: 16, color: AppColors.starGold),
                    label: Text(
                      L10nService.get('milestones.milestone.retry', language),
                      style: AppTypography.elegantAccent(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.starGold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          data: (service) =>
              _MilestoneBody(service: service, isEn: isEn, isDark: isDark),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// MILESTONE BODY (stateful for filter chips)
// ════════════════════════════════════════════════════════════════════════════

class _MilestoneBody extends StatefulWidget {
  final MilestoneService service;
  final bool isEn;
  final bool isDark;

  const _MilestoneBody({
    required this.service,
    required this.isEn,
    required this.isDark,
  });

  @override
  State<_MilestoneBody> createState() => _MilestoneBodyState();
}

class _MilestoneBodyState extends State<_MilestoneBody> {
  MilestoneCategory? _selectedCategory;

  MilestoneService get service => widget.service;
  bool get isEn => widget.isEn;
  bool get isDark => widget.isDark;

  @override
  Widget build(BuildContext context) {
    final allMilestones = service.getAllMilestones();
    final filtered = _selectedCategory == null
        ? allMilestones
        : allMilestones.where((m) => m.category == _selectedCategory).toList();

    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(title: L10nService.get('milestones.milestone.milestones', isEn ? AppLanguage.en : AppLanguage.tr)),

          // ── Progress Card ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _buildProgressCard()
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.08, duration: 400.ms, curve: Curves.easeOut),
            ),
          ),

          // ── Filter Chips ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: _buildFilterChips().animate().fadeIn(
                delay: 100.ms,
                duration: 300.ms,
              ),
            ),
          ),

          // ── Badge Grid ────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.78,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final milestone = filtered[index];
                final earned = service.isEarned(milestone.id);
                return _buildBadgeTile(milestone, earned, index);
              }, childCount: filtered.length),
            ),
          ),

          // Footer
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ToolEcosystemFooter(
                currentToolId: 'milestones',
                isEn: isEn,
                isDark: isDark,
              ),
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PROGRESS CARD
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildProgressCard() {
    final earned = service.earnedCount;
    final total = service.totalCount;
    final progress = service.getProgress();

    return Semantics(
      label: isEn
          ? '$earned of $total milestones earned, ${(progress * 100).round()} percent complete'
          : '$total rozetin $earned tanesi kazanıldı, yüzde ${(progress * 100).round()} tamamlandı',
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.auroraStart, AppColors.auroraEnd],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.auroraStart.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Progress ring
            SizedBox(
              width: 80,
              height: 80,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: 1.0,
                          strokeWidth: 6,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation(
                            Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: value,
                          strokeWidth: 6,
                          strokeCap: StrokeCap.round,
                          backgroundColor: Colors.transparent,
                          valueColor: const AlwaysStoppedAnimation(
                            Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        '$earned/$total',
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(width: 20),
            // Text block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradientText(
                    L10nService.get('milestones.milestone.milestones_earned', isEn ? AppLanguage.en : AppLanguage.tr),
                    variant: GradientTextVariant.gold,
                    style: AppTypography.displayFont.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isEn
                        ? '${(progress * 100).round()}% complete'
                        : '%${(progress * 100).round()} tamamlandı',
                    style: AppTypography.subtitle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getProgressMessage(earned, total),
                    style: AppTypography.elegantAccent(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getProgressMessage(int earned, int total) {
    final remaining = total - earned;
    if (earned == 0) {
      return L10nService.get('milestones.milestone.start_tracking', isEn ? AppLanguage.en : AppLanguage.tr);
    }
    if (earned >= total) {
      return L10nService.get('milestones.milestone.you_earned_them_all', isEn ? AppLanguage.en : AppLanguage.tr);
    }
    return isEn
        ? '$remaining more to discover'
        : '$remaining tane daha keşfedilecek';
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FILTER CHIPS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildFilterChips() {
    final categories = [null, ...MilestoneCategory.values];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: categories.map((cat) {
          final selected = _selectedCategory == cat;
          final label = cat == null
              ? (L10nService.get('milestones.milestone.all', isEn ? AppLanguage.en : AppLanguage.tr))
              : (cat.localizedName(isEn));

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Semantics(
              label: selected
                  ? (isEn
                        ? '$label filter, selected'
                        : '$label filtresi, seçili')
                  : (L10nService.getWithParams('milestones.filter_label', isEn ? AppLanguage.en : AppLanguage.tr, params: {'label': label})),
              button: true,
              selected: selected,
              child: FilterChip(
                label: Text(
                  label,
                  style: AppTypography.elegantAccent(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected
                        ? (isDark ? AppColors.deepSpace : Colors.white)
                        : (isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary),
                  ),
                ),
                selected: selected,
                onSelected: (_) {
                  setState(() => _selectedCategory = cat);
                },
                backgroundColor: isDark
                    ? AppColors.surfaceDark.withValues(alpha: 0.6)
                    : AppColors.lightSurfaceVariant,
                selectedColor: AppColors.starGold,
                checkmarkColor: isDark ? AppColors.deepSpace : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: selected
                        ? AppColors.starGold
                        : isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.06),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // BADGE TILE
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildBadgeTile(Milestone milestone, bool earned, int index) {
    final name = isEn ? milestone.nameEn : milestone.nameTr;

    return Semantics(
          label: earned
              ? (isEn
                    ? '$name badge, earned. Double tap to view details'
                    : '$name rozeti, kazanıldı. Ayrıntıları görmek için iki kez dokun')
              : (isEn
                    ? '$name badge, locked. ${_getCategoryHint(milestone.category)}'
                    : '$name rozeti, kilitli. ${_getCategoryHint(milestone.category)}'),
          button: earned,
          enabled: earned,
          child: GestureDetector(
            onTap: earned ? () => _showBadgeDetail(milestone) : null,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: earned
                    ? (isDark
                          ? AppColors.surfaceDark.withValues(alpha: 0.85)
                          : AppColors.lightCard)
                    : (isDark
                          ? AppColors.surfaceDark.withValues(alpha: 0.35)
                          : AppColors.lightSurfaceVariant.withValues(
                              alpha: 0.5,
                            )),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: earned
                      ? AppColors.starGold.withValues(alpha: 0.5)
                      : isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.04),
                  width: earned ? 1.5 : 1,
                ),
                boxShadow: earned
                    ? [
                        BoxShadow(
                          color: AppColors.starGold.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Emoji or lock
                  if (earned)
                    AppSymbol(milestone.emoji, size: AppSymbolSize.lg)
                  else
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: 0.15,
                          child: AppSymbol(
                            milestone.emoji,
                            size: AppSymbolSize.lg,
                          ),
                        ),
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 20,
                          color: isDark
                              ? AppColors.textMuted.withValues(alpha: 0.5)
                              : AppColors.lightTextMuted.withValues(alpha: 0.6),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  // Name
                  Text(
                    name,
                    style: AppTypography.elegantAccent(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: earned
                          ? (isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary)
                          : (isDark
                                ? AppColors.textMuted.withValues(alpha: 0.5)
                                : AppColors.lightTextMuted),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Hint text for locked
                  if (!earned) ...[
                    const SizedBox(height: 4),
                    Text(
                      _getCategoryHint(milestone.category),
                      style: AppTypography.elegantAccent(
                        fontSize: 10,
                        color: isDark
                            ? AppColors.textMuted.withValues(alpha: 0.4)
                            : AppColors.lightTextMuted.withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        )
        .animate(delay: (40 * index).ms)
        .fadeIn(duration: 300.ms)
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }

  String _getCategoryHint(MilestoneCategory category) {
    switch (category) {
      case MilestoneCategory.streak:
        return L10nService.get('milestones.milestone.keep_logging', isEn ? AppLanguage.en : AppLanguage.tr);
      case MilestoneCategory.entries:
        return L10nService.get('milestones.milestone.write_more', isEn ? AppLanguage.en : AppLanguage.tr);
      case MilestoneCategory.exploration:
        return L10nService.get('milestones.milestone.try_new_features', isEn ? AppLanguage.en : AppLanguage.tr);
      case MilestoneCategory.depth:
        return L10nService.get('milestones.milestone.go_deeper', isEn ? AppLanguage.en : AppLanguage.tr);
      case MilestoneCategory.social:
        return L10nService.get('milestones.milestone.share_connect', isEn ? AppLanguage.en : AppLanguage.tr);
      case MilestoneCategory.growth:
        return L10nService.get('milestones.milestone.keep_growing', isEn ? AppLanguage.en : AppLanguage.tr);
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // BADGE DETAIL DIALOG
  // ══════════════════════════════════════════════════════════════════════════

  void _showBadgeDetail(Milestone milestone) {
    final earnedDate = service.earnedAt(milestone.id);
    final name = isEn ? milestone.nameEn : milestone.nameTr;
    final description = isEn
        ? milestone.descriptionEn
        : milestone.descriptionTr;
    final categoryName = milestone.category.localizedName(isEn);

    showDialog(
      context: context,
      builder: (ctx) {
        final dialogDark = Theme.of(ctx).brightness == Brightness.dark;

        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      (dialogDark
                              ? AppColors.surfaceDark
                              : AppColors.lightSurface)
                          .withValues(alpha: dialogDark ? 0.82 : 0.90),
                  borderRadius: BorderRadius.circular(24),
                  border: Border(
                    top: BorderSide(
                      color: AppColors.starGold.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.starGold.withValues(alpha: 0.06),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 32,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Emoji large
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.starGold.withValues(alpha: 0.2),
                            AppColors.auroraStart.withValues(alpha: 0.15),
                          ],
                        ),
                        border: Border.all(
                          color: AppColors.starGold.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: AppSymbol.hero(milestone.emoji),
                    ),
                    const SizedBox(height: 16),
                    // Name
                    Text(
                      name,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: dialogDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    // Category chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.starGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        categoryName,
                        style: AppTypography.elegantAccent(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.starGold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Description
                    Text(
                      description,
                      style: AppTypography.decorativeScript(
                        fontSize: 15,
                        color: dialogDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // Earned date
                    if (earnedDate != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ExcludeSemantics(
                            child: Icon(
                              Icons.check_circle_outline,
                              size: 16,
                              color: AppColors.success,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isEn
                                ? 'Earned ${_formatDate(earnedDate, isEn)}'
                                : 'Kazanıldı: ${_formatDate(earnedDate, isEn)}',
                            style: AppTypography.subtitle(
                              fontSize: 13,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 24),
                    // Close button
                    Semantics(
                      button: true,
                      label: L10nService.get('milestones.milestone.close_dialog', isEn ? AppLanguage.en : AppLanguage.tr),
                      child: SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.starGold.withValues(
                              alpha: 0.1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            L10nService.get('milestones.milestone.done', isEn ? AppLanguage.en : AppLanguage.tr),
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.starGold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date, bool isEn) {
    final months = isEn
        ? [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec',
          ]
        : [
            'Oca',
            'Şub',
            'Mar',
            'Nis',
            'May',
            'Haz',
            'Tem',
            'Ağu',
            'Eyl',
            'Eki',
            'Kas',
            'Ara',
          ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
