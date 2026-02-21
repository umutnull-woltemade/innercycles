// ════════════════════════════════════════════════════════════════════════════
// MILESTONE SCREEN - InnerCycles Badge & Achievement Gallery
// ════════════════════════════════════════════════════════════════════════════
// Displays all 30 milestones across 6 categories in a filterable grid.
// Earned badges show full color + emoji; locked badges are dimmed with a
// lock icon and hint text. Tapping an earned badge opens a detail dialog.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/milestone_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';

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
              child: Text(
                CommonStrings.somethingWentWrong(language),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
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

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        GlassSliverAppBar(title: isEn ? 'Milestones' : 'Rozetler'),

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
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PROGRESS CARD
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildProgressCard() {
    final earned = service.earnedCount;
    final total = service.totalCount;
    final progress = service.getProgress();

    return Container(
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
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    Text(
                      '$earned/$total',
                      style: const TextStyle(
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
                Text(
                  isEn ? 'Milestones Earned' : 'Kazanılan Rozetler',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.95),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isEn
                      ? '${(progress * 100).round()}% complete'
                      : '%${(progress * 100).round()} tamamlandi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getProgressMessage(earned, total),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getProgressMessage(int earned, int total) {
    final remaining = total - earned;
    if (earned == 0) {
      return isEn ? 'Start your journey!' : 'Yolculuğuna başla!';
    }
    if (earned >= total) {
      return isEn ? 'You earned them all!' : 'Hepsini kazandin!';
    }
    return isEn
        ? '$remaining more to discover'
        : '$remaining tane daha kesfedilecek';
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
              ? (isEn ? 'All' : 'Tumu')
              : (isEn ? cat.displayNameEn : cat.displayNameTr);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                label,
                style: TextStyle(
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
          label: name,
          button: earned,
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
                    Text(milestone.emoji, style: const TextStyle(fontSize: 32))
                  else
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          milestone.emoji,
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.white.withValues(alpha: 0.15),
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
                    style: TextStyle(
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
                      style: TextStyle(
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
        return isEn ? 'Keep logging' : 'Kayıt tutmaya devam';
      case MilestoneCategory.entries:
        return isEn ? 'Write more' : 'Daha fazla yaz';
      case MilestoneCategory.exploration:
        return isEn ? 'Try new features' : 'Yeni özellikleri dene';
      case MilestoneCategory.depth:
        return isEn ? 'Go deeper' : 'Daha derine dal';
      case MilestoneCategory.social:
        return isEn ? 'Share & connect' : 'Paylaş ve bağlan';
      case MilestoneCategory.growth:
        return isEn ? 'Keep growing' : 'Gelişmeye devam';
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
    final categoryName = isEn
        ? milestone.category.displayNameEn
        : milestone.category.displayNameTr;

    showDialog(
      context: context,
      builder: (ctx) {
        final dialogDark = Theme.of(ctx).brightness == Brightness.dark;

        return Dialog(
          backgroundColor: dialogDark
              ? AppColors.surfaceDark
              : AppColors.lightSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
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
                  child: Text(
                    milestone.emoji,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
                const SizedBox(height: 16),
                // Name
                Text(
                  name,
                  style: TextStyle(
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
                    style: TextStyle(
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
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
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
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isEn
                            ? 'Earned ${_formatDate(earnedDate, isEn)}'
                            : 'Kazanildi: ${_formatDate(earnedDate, isEn)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.success,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                // Close button
                SizedBox(
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
                      isEn ? 'Close' : 'Kapat',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.starGold,
                      ),
                    ),
                  ),
                ),
              ],
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
            'Sub',
            'Mar',
            'Nis',
            'May',
            'Haz',
            'Tem',
            'Agu',
            'Eyl',
            'Eki',
            'Kas',
            'Ara',
          ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
