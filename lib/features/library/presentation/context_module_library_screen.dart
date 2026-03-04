// ════════════════════════════════════════════════════════════════════════════
// CONTEXT MODULE LIBRARY - Browse 36 educational insight modules
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/content/context_modules_content.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/haptic_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class ContextModuleLibraryScreen extends ConsumerStatefulWidget {
  const ContextModuleLibraryScreen({super.key});

  @override
  ConsumerState<ContextModuleLibraryScreen> createState() =>
      _ContextModuleLibraryScreenState();
}

class _ContextModuleLibraryScreenState
    extends ConsumerState<ContextModuleLibraryScreen> {
  ContextModuleCategory? _selectedCategory;
  ContextModuleDepth? _selectedDepth;

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(contextModuleServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => Center(child: CupertinoActivityIndicator()),
            error: (_, _) => Center(child: Text('Something went wrong', style: TextStyle(color: Color(0xFF9E8E82)))),
            data: (service) {
              final allModules = service.getAllModules();
              final readCount = service.readCount;
              final totalCount = service.totalCount;
              final bookmarked = service.getBookmarked();

              // Filter
              var filtered = List<ContextModule>.from(allModules);
              if (_selectedCategory != null) {
                filtered = filtered
                    .where((m) => m.category == _selectedCategory)
                    .toList();
              }
              if (_selectedDepth != null) {
                filtered = filtered
                    .where((m) => m.depth == _selectedDepth)
                    .toList();
              }

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: isEn
                        ? 'Module Library'
                        : 'Modül Kütüphanesi',
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            isEn
                                ? 'Explore insights for personal growth'
                                : 'Kişisel gelişim için içgörüleri keşfet',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Overview hero
                          _OverviewHero(
                            readCount: readCount,
                            totalCount: totalCount,
                            bookmarkCount: bookmarked.length,
                            isEn: isEn,
                            isDark: isDark,
                          )
                              .animate()
                              .fadeIn(duration: 400.ms),

                          const SizedBox(height: 20),

                          // Category filter
                          GradientText(
                            isEn ? 'Categories' : 'Kategoriler',
                            variant: GradientTextVariant.gold,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _CategoryChips(
                            selected: _selectedCategory,
                            isEn: isEn,
                            isDark: isDark,
                            onSelected: (cat) {
                              setState(() {
                                _selectedCategory =
                                    _selectedCategory == cat
                                        ? null
                                        : cat;
                              });
                            },
                          ),

                          const SizedBox(height: 16),

                          // Depth filter
                          _DepthChips(
                            selected: _selectedDepth,
                            isEn: isEn,
                            isDark: isDark,
                            onSelected: (depth) {
                              setState(() {
                                _selectedDepth =
                                    _selectedDepth == depth
                                        ? null
                                        : depth;
                              });
                            },
                          ),

                          const SizedBox(height: 20),

                          // Bookmarked section
                          if (bookmarked.isNotEmpty &&
                              _selectedCategory == null &&
                              _selectedDepth == null) ...[
                            GradientText(
                              isEn ? 'Bookmarked' : 'Kaydedilenler',
                              variant: GradientTextVariant.amethyst,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...bookmarked.map(
                              (m) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8),
                                child: _ModuleCard(
                                  module: m,
                                  isRead: service.isRead(m.id),
                                  isBookmarked: true,
                                  isEn: isEn,
                                  isDark: isDark,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // All modules
                          GradientText(
                            isEn
                                ? 'All Modules (${filtered.length})'
                                : 'Tüm Modüller (${filtered.length})',
                            variant: GradientTextVariant.aurora,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),

                          ...filtered.asMap().entries.map((entry) {
                            final m = entry.value;
                            return Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 8),
                              child: _ModuleCard(
                                module: m,
                                isRead: service.isRead(m.id),
                                isBookmarked:
                                    service.isBookmarked(m.id),
                                isEn: isEn,
                                isDark: isDark,
                              ),
                            );
                          }),

                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              isEn
                                  ? '$readCount / $totalCount modules read'
                                  : '$readCount / $totalCount modül okundu',
                              style: AppTypography.subtitle(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
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

class _OverviewHero extends StatelessWidget {
  final int readCount;
  final int totalCount;
  final int bookmarkCount;
  final bool isEn;
  final bool isDark;

  const _OverviewHero({
    required this.readCount,
    required this.totalCount,
    required this.bookmarkCount,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
        totalCount > 0 ? readCount / totalCount : 0.0;

    return PremiumCard(
      style: PremiumCardStyle.aurora,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  '$totalCount',
                  style: AppTypography.modernAccent(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.auroraStart,
                  ),
                ),
                Text(
                  isEn ? 'Modules' : 'Modül',
                  style: AppTypography.elegantAccent(
                    fontSize: 9,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: 44,
                  height: 44,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 3,
                        backgroundColor: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.06),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(
                                AppColors.starGold),
                      ),
                      Text(
                        '${(progress * 100).round()}%',
                        style: AppTypography.modernAccent(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.starGold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isEn ? 'Read' : 'Okundu',
                  style: AppTypography.elegantAccent(
                    fontSize: 9,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '$bookmarkCount',
                  style: AppTypography.modernAccent(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.celestialGold,
                  ),
                ),
                Text(
                  isEn ? 'Saved' : 'Kayıtlı',
                  style: AppTypography.elegantAccent(
                    fontSize: 9,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final ContextModuleCategory? selected;
  final bool isEn;
  final bool isDark;
  final ValueChanged<ContextModuleCategory> onSelected;

  const _CategoryChips({
    required this.selected,
    required this.isEn,
    required this.isDark,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: ContextModuleCategory.values.map((cat) {
        final isActive = selected == cat;
        final lang = isEn ? AppLanguage.en : AppLanguage.tr;
        return GestureDetector(
          onTap: () {
            HapticService.selectionTap();
            onSelected(cat);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isActive
                  ? AppColors.starGold.withValues(alpha: 0.15)
                  : isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.04),
              border: isActive
                  ? Border.all(
                      color:
                          AppColors.starGold.withValues(alpha: 0.4))
                  : null,
            ),
            child: Text(
              cat.localizedName(lang),
              style: AppTypography.modernAccent(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive
                    ? AppColors.starGold
                    : isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _DepthChips extends StatelessWidget {
  final ContextModuleDepth? selected;
  final bool isEn;
  final bool isDark;
  final ValueChanged<ContextModuleDepth> onSelected;

  const _DepthChips({
    required this.selected,
    required this.isEn,
    required this.isDark,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final lang = isEn ? AppLanguage.en : AppLanguage.tr;
    return Row(
      children: ContextModuleDepth.values.map((depth) {
        final isActive = selected == depth;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () {
              HapticService.selectionTap();
              onSelected(depth);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isActive
                    ? AppColors.amethyst.withValues(alpha: 0.15)
                    : isDark
                        ? Colors.white.withValues(alpha: 0.04)
                        : Colors.black.withValues(alpha: 0.03),
                border: isActive
                    ? Border.all(
                        color: AppColors.amethyst
                            .withValues(alpha: 0.3))
                    : null,
              ),
              child: Text(
                depth.localizedName(lang),
                style: AppTypography.modernAccent(
                  fontSize: 10,
                  fontWeight:
                      isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? AppColors.amethyst
                      : isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final ContextModule module;
  final bool isRead;
  final bool isBookmarked;
  final bool isEn;
  final bool isDark;

  const _ModuleCard({
    required this.module,
    required this.isRead,
    required this.isBookmarked,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final lang = isEn ? AppLanguage.en : AppLanguage.tr;
    final depthColors = {
      ContextModuleDepth.beginner: AppColors.success,
      ContextModuleDepth.intermediate: AppColors.starGold,
      ContextModuleDepth.advanced: AppColors.amethyst,
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
        border: isRead
            ? null
            : Border.all(
                color:
                    AppColors.auroraStart.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  module.localizedTitle(lang),
                  style: AppTypography.modernAccent(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              if (isBookmarked)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Icon(
                    Icons.bookmark_rounded,
                    size: 16,
                    color: AppColors.celestialGold,
                  ),
                ),
              if (isRead)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 14,
                    color: AppColors.success
                        .withValues(alpha: 0.6),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: AppColors.starGold.withValues(alpha: 0.1),
                ),
                child: Text(
                  module.category.localizedName(lang),
                  style: AppTypography.elegantAccent(
                    fontSize: 9,
                    color: AppColors.starGold,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: (depthColors[module.depth] ??
                          AppColors.starGold)
                      .withValues(alpha: 0.1),
                ),
                child: Text(
                  module.depth.localizedName(lang),
                  style: AppTypography.elegantAccent(
                    fontSize: 9,
                    color: depthColors[module.depth] ??
                        AppColors.starGold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            module.localizedSummary(lang),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.subtitle(
              fontSize: 11,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
