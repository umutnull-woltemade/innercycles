import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../data/content/context_modules_content.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/context_module_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';

class ArticlesScreen extends ConsumerStatefulWidget {
  const ArticlesScreen({super.key});

  @override
  ConsumerState<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends ConsumerState<ArticlesScreen> {
  ContextModuleCategory? _selectedCategory;
  String? _expandedModuleId;

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(contextModuleServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: serviceAsync.when(
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
          data: (service) => _buildContent(context, service, isDark, isEn),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ContextModuleService service,
    bool isDark,
    bool isEn,
  ) {
    // Filter modules
    List<ContextModule> modules;
    if (_selectedCategory != null) {
      modules = service.getByCategory(_selectedCategory!);
    } else {
      modules = service.getAllModules();
    }

    final readCount = service.readCount;
    final totalCount = service.totalCount;
    final progress = service.readProgress;

    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(
            title: isEn ? 'Insight Library' : 'İçgörü Kütüphanesi',
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Reading progress
                _buildProgressCard(
                  readCount,
                  totalCount,
                  progress,
                  isDark,
                  isEn,
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // Category chips
                _buildCategoryChips(isDark, isEn),
                const SizedBox(height: AppConstants.spacingLg),

                // Module cards
                ...modules.map(
                  (module) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppConstants.spacingMd,
                    ),
                    child: _ModuleCard(
                      module: module,
                      isRead: service.isRead(module.id),
                      isBookmarked: service.isBookmarked(module.id),
                      isExpanded: _expandedModuleId == module.id,
                      isDark: isDark,
                      isEn: isEn,
                      onTap: () {
                        setState(() {
                          _expandedModuleId = _expandedModuleId == module.id
                              ? null
                              : module.id;
                        });
                        if (!service.isRead(module.id)) {
                          service.markAsRead(module.id);
                        }
                      },
                      onToggleBookmark: () async {
                        await service.toggleBookmark(module.id);
                        if (!mounted) return;
                        setState(() {});
                      },
                    ),
                  ),
                ),
                ToolEcosystemFooter(
                  currentToolId: 'articles',
                  isEn: isEn,
                  isDark: isDark,
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, duration: 400.ms);
  }

  Widget _buildProgressCard(
    int readCount,
    int totalCount,
    double progress,
    bool isDark,
    bool isEn,
  ) {
    return GlassPanel(
      elevation: GlassElevation.g2,
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEn ? 'Reading Progress' : 'Okuma İlerlemesi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              Text(
                '$readCount / $totalCount',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.starGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: isDark
                  ? AppColors.surfaceLight.withValues(alpha: 0.15)
                  : AppColors.lightSurfaceVariant,
              valueColor: AlwaysStoppedAnimation(AppColors.auroraStart),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(bool isDark, bool isEn) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _CategoryChip(
            label: isEn ? 'All' : 'Tümü',
            isSelected: _selectedCategory == null,
            isDark: isDark,
            onTap: () => setState(() => _selectedCategory = null),
          ),
          const SizedBox(width: 8),
          ...ContextModuleCategory.values.map(
            (cat) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _CategoryChip(
                label: isEn ? cat.displayNameEn : cat.displayNameTr,
                isSelected: _selectedCategory == cat,
                isDark: isDark,
                onTap: () => setState(() => _selectedCategory = cat),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.auroraStart.withValues(alpha: 0.2)
                : (isDark
                      ? AppColors.surfaceLight.withValues(alpha: 0.1)
                      : AppColors.lightSurfaceVariant),
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            border: Border.all(
              color: isSelected
                  ? AppColors.auroraStart
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.05)),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? AppColors.auroraStart
                  : (isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final ContextModule module;
  final bool isRead;
  final bool isBookmarked;
  final bool isExpanded;
  final bool isDark;
  final bool isEn;
  final VoidCallback onTap;
  final VoidCallback onToggleBookmark;

  const _ModuleCard({
    required this.module,
    required this.isRead,
    required this.isBookmarked,
    required this.isExpanded,
    required this.isDark,
    required this.isEn,
    required this.onTap,
    required this.onToggleBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isEn ? module.titleEn : module.titleTr,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: GlassPanel(
          elevation: isExpanded ? GlassElevation.g3 : GlassElevation.g2,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Read indicator
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isRead
                          ? AppColors.auroraEnd.withValues(alpha: 0.5)
                          : AppColors.auroraStart,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEn ? module.titleEn : module.titleTr,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.auroraStart.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppConstants.radiusFull,
                                ),
                              ),
                              child: Text(
                                isEn
                                    ? module.category.displayNameEn
                                    : module.category.displayNameTr,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.auroraStart,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.starGold.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppConstants.radiusFull,
                                ),
                              ),
                              child: Text(
                                isEn
                                    ? module.depth.displayNameEn
                                    : module.depth.displayNameTr,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.starGold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Semantics(
                    label: isBookmarked
                        ? (isEn ? 'Remove bookmark' : 'Yer imini kaldır')
                        : (isEn ? 'Add bookmark' : 'Yer imi ekle'),
                    button: true,
                    child: GestureDetector(
                      onTap: onToggleBookmark,
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(
                          child: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            size: 20,
                            color: isBookmarked
                                ? AppColors.starGold
                                : (isDark
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Summary (always shown)
              const SizedBox(height: AppConstants.spacingMd),
              Text(
                isEn ? module.summaryEn : module.summaryTr,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
                maxLines: isExpanded ? null : 2,
                overflow: isExpanded ? null : TextOverflow.ellipsis,
              ),

              // Expanded content
              if (isExpanded) ...[
                const SizedBox(height: AppConstants.spacingLg),
                Text(
                  isEn ? module.bodyEn : module.bodyTr,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // "Why it matters" section
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingMd),
                  decoration: BoxDecoration(
                    color: AppColors.starGold.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                    border: Border.all(
                      color: AppColors.starGold.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEn ? 'Why It Matters' : 'Neden Önemli',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.starGold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isEn ? module.whyItMattersEn : module.whyItMattersTr,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Screenshot line / shareable insight
                if (module.screenshotLineEn != null) ...[
                  const SizedBox(height: AppConstants.spacingMd),
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingMd),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceLight.withValues(alpha: 0.08)
                          : AppColors.lightSurfaceVariant,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusSm,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.format_quote,
                          size: 16,
                          color: AppColors.auroraStart,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isEn
                                ? module.screenshotLineEn!
                                : (module.screenshotLineTr ??
                                      module.screenshotLineEn!),
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                              color: isDark
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
            ],
          ),
        ),
      ),
    );
  }
}
