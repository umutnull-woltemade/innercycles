// ════════════════════════════════════════════════════════════════════════════
// INSIGHTS DISCOVERY SCREEN - Browse Educational Context Modules
// ════════════════════════════════════════════════════════════════════════════
// Browsable library of 36 educational psychology modules organized by
// category and depth. Features daily spotlight, reading progress,
// bookmarks, and focus-area filtering.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/content/context_modules_content.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/context_module_service.dart';
import '../../../data/services/smart_router_service.dart';
import '../../../data/services/ecosystem_analytics_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';
import '../../../shared/widgets/share_insight_button.dart';

class InsightsDiscoveryScreen extends ConsumerStatefulWidget {
  const InsightsDiscoveryScreen({super.key});

  @override
  ConsumerState<InsightsDiscoveryScreen> createState() =>
      _InsightsDiscoveryScreenState();
}

class _InsightsDiscoveryScreenState
    extends ConsumerState<InsightsDiscoveryScreen> {
  ContextModuleCategory? _selectedCategory;
  bool _showBookmarksOnly = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(smartRouterServiceProvider)
          .whenData((s) => s.recordToolVisit('insightsDiscovery'));
      ref
          .read(ecosystemAnalyticsServiceProvider)
          .whenData(
            (s) => s.trackToolOpen('insightsDiscovery', source: 'direct'),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(contextModuleServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const CosmicLoadingIndicator(),
            error: (_, _) => Center(
              child: Text(
                isEn ? 'Could not load. Your local data is unaffected.' : 'Yüklenemedi. Yerel verileriniz etkilenmedi.',
                style: TextStyle(
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
            data: (service) => _buildContent(context, service, isDark, isEn),
          ),
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
    final daily = service.getDailyModule();
    final modules = _getFilteredModules(service);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        // App Bar
        GlassSliverAppBar(
          title: isEn ? 'Discover Insights' : 'İçgörüleri Keşfet',
          actions: [
            // Bookmark filter toggle
            IconButton(
              tooltip: _showBookmarksOnly
                  ? (isEn ? 'Show all insights' : 'Tüm içgörüleri göster')
                  : (isEn ? 'Show bookmarks' : 'Kaydedilenleri göster'),
              icon: Icon(
                _showBookmarksOnly
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                color: _showBookmarksOnly
                    ? AppColors.starGold
                    : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() => _showBookmarksOnly = !_showBookmarksOnly);
              },
            ),
          ],
        ),

        // Reading progress
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: _buildProgressBar(service, isDark, isEn),
          ),
        ),

        // Daily spotlight card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildDailySpotlight(daily, service, isDark, isEn),
          ),
        ),

        // Category filter chips
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: _buildCategoryChips(isDark, isEn),
          ),
        ),

        // Module list
        if (modules.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Text(
                  isEn ? 'No insights found' : 'İçgörü bulunamadı',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final module = modules[index];
              return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6,
                    ),
                    child: _buildModuleCard(module, service, isDark, isEn),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: (index * 60).ms)
                  .slideY(begin: 0.05, duration: 400.ms);
            }, childCount: modules.length),
          ),

        // Related tools
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ToolEcosystemFooter(
              currentToolId: 'insightsDiscovery',
              isEn: isEn,
              isDark: isDark,
            ),
          ),
        ),
        // Bottom padding
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // PROGRESS BAR
  // ═══════════════════════════════════════════════════════════════

  Widget _buildProgressBar(
    ContextModuleService service,
    bool isDark,
    bool isEn,
  ) {
    final progress = service.readProgress;
    final read = service.readCount;
    final total = service.totalCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isEn ? 'Reading Progress' : 'Okuma İlerlemesi',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
            Text(
              '$read / $total',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.auroraStart,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: isDark
                ? AppColors.surfaceLight.withValues(alpha: 0.3)
                : AppColors.lightSurfaceVariant,
            valueColor: AlwaysStoppedAnimation(AppColors.auroraStart),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // DAILY SPOTLIGHT
  // ═══════════════════════════════════════════════════════════════

  Widget _buildDailySpotlight(
    ContextModule module,
    ContextModuleService service,
    bool isDark,
    bool isEn,
  ) {
    return Semantics(
      button: true,
      label: isEn
          ? 'Today\'s Insight: ${module.titleEn}'
          : 'Bugünün İçgörüsü: ${module.titleTr}',
      child: GestureDetector(
        onTap: () => _openModuleDetail(module, service),
        child: PremiumCard(
          style: PremiumCardStyle.aurora,
          borderRadius: 20,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.starGold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.starGold,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isEn ? 'Today\'s Insight' : 'Bugünün İçgörüsü',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  _buildDepthBadge(module.depth, isDark, isEn),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                isEn ? module.titleEn : module.titleTr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isEn ? module.summaryEn : module.summaryTr,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryPill(module.category, isDark, isEn),
                  Text(
                    isEn ? 'Tap to read' : 'Okumak için dokun',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.textMuted.withValues(alpha: 0.6)
                          : AppColors.lightTextMuted.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.08, duration: 500.ms);
  }

  // ═══════════════════════════════════════════════════════════════
  // CATEGORY CHIPS
  // ═══════════════════════════════════════════════════════════════

  Widget _buildCategoryChips(bool isDark, bool isEn) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(
            label: isEn ? 'All' : 'Tümü',
            isSelected: _selectedCategory == null,
            isDark: isDark,
            onTap: () => setState(() => _selectedCategory = null),
          ),
          const SizedBox(width: 8),
          ...ContextModuleCategory.values.map(
            (cat) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildChip(
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

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      label: label,
      selected: isSelected,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.auroraStart.withValues(alpha: 0.2)
                : (isDark
                      ? AppColors.surfaceLight.withValues(alpha: 0.3)
                      : AppColors.lightSurfaceVariant),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppColors.auroraStart.withValues(alpha: 0.5)
                  : Colors.transparent,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
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

  // ═══════════════════════════════════════════════════════════════
  // MODULE CARD
  // ═══════════════════════════════════════════════════════════════

  Widget _buildModuleCard(
    ContextModule module,
    ContextModuleService service,
    bool isDark,
    bool isEn,
  ) {
    final isRead = service.isRead(module.id);
    final isBookmarked = service.isBookmarked(module.id);

    return Semantics(
      button: true,
      label: isEn ? module.titleEn : module.titleTr,
      child: GestureDetector(
        onTap: () => _openModuleDetail(module, service),
        child: PremiumCard(
          style: PremiumCardStyle.subtle,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Read indicator
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isRead
                          ? AppColors.auroraStart.withValues(alpha: 0.4)
                          : AppColors.starGold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isEn ? module.titleEn : module.titleTr,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                  // Share button
                  ShareInsightButton(
                    insightText: isEn ? module.summaryEn : module.summaryTr,
                    iconSize: 16,
                  ),
                  const SizedBox(width: 4),
                  // Bookmark button
                  Semantics(
                    button: true,
                    label: isBookmarked
                        ? (isEn ? 'Remove bookmark' : 'Yer işaretini kaldır')
                        : (isEn ? 'Add bookmark' : 'Yer işareti ekle'),
                    child: GestureDetector(
                      onTap: () async {
                        HapticFeedback.lightImpact();
                        await service.toggleBookmark(module.id);
                        if (!mounted) return;
                        setState(() {});
                      },
                      child: Icon(
                        isBookmarked
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        size: 20,
                        color: isBookmarked
                            ? AppColors.starGold
                            : (isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isEn ? module.summaryEn : module.summaryTr,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildCategoryPill(module.category, isDark, isEn),
                  const SizedBox(width: 8),
                  _buildDepthBadge(module.depth, isDark, isEn),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // MODULE DETAIL BOTTOM SHEET
  // ═══════════════════════════════════════════════════════════════

  void _openModuleDetail(ContextModule module, ContextModuleService service) {
    HapticFeedback.mediumImpact();
    service.markAsRead(module.id);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.read(languageProvider);
    final isEn = language == AppLanguage.en;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.lightBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.all(24),
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surfaceLight
                        : AppColors.lightSurfaceVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Category + Depth
              Row(
                children: [
                  _buildCategoryPill(module.category, isDark, isEn),
                  const SizedBox(width: 8),
                  _buildDepthBadge(module.depth, isDark, isEn),
                ],
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                isEn ? module.titleEn : module.titleTr,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 12),

              // Summary
              Text(
                isEn ? module.summaryEn : module.summaryTr,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 20),

              // Body
              Text(
                isEn ? module.bodyEn : module.bodyTr,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.7,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 24),

              // Why It Matters box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.auroraStart.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.auroraStart.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline_rounded,
                          size: 16,
                          color: AppColors.starGold,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isEn ? 'Why This Matters' : 'Neden Önemli',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.starGold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isEn ? module.whyItMattersEn : module.whyItMattersTr,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              // Screenshot line (shareable insight)
              if (module.screenshotLineEn != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              AppColors.surfaceLight.withValues(alpha: 0.5),
                              AppColors.surfaceDark,
                            ]
                          : [
                              AppColors.lightSurfaceVariant,
                              AppColors.lightCard,
                            ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.format_quote_rounded,
                        size: 24,
                        color: AppColors.auroraStart.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isEn
                            ? module.screenshotLineEn!
                            : (module.screenshotLineTr ??
                                  module.screenshotLineEn!),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Related modules
              if (module.relatedModuleIds.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  isEn ? 'Related Insights' : 'İlgili İçgörüler',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                ...service
                    .getRelatedModules(module)
                    .map(
                      (related) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Semantics(
                          button: true,
                          label: isEn ? related.titleEn : related.titleTr,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(ctx).pop();
                              Future.delayed(
                                const Duration(milliseconds: 300),
                                () {
                                  if (!mounted) return;
                                  _openModuleDetail(related, service);
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.surfaceLight.withValues(
                                        alpha: 0.3,
                                      )
                                    : AppColors.lightSurfaceVariant,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 16,
                                    color: AppColors.auroraStart,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      isEn ? related.titleEn : related.titleTr,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: isDark
                                            ? AppColors.textPrimary
                                            : AppColors.lightTextPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );

    // Refresh to show read state
    setState(() {});
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════

  List<ContextModule> _getFilteredModules(ContextModuleService service) {
    List<ContextModule> modules;

    if (_showBookmarksOnly) {
      modules = service.getBookmarked();
    } else if (_selectedCategory != null) {
      modules = service.getByCategory(_selectedCategory!);
    } else {
      modules = service.getAllModules();
    }

    return modules;
  }

  Widget _buildCategoryPill(
    ContextModuleCategory category,
    bool isDark,
    bool isEn,
  ) {
    final color = _categoryColor(category);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_categoryIcon(category), size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            isEn ? category.displayNameEn : category.displayNameTr,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepthBadge(ContextModuleDepth depth, bool isDark, bool isEn) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceLight.withValues(alpha: 0.3)
            : AppColors.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isEn ? depth.displayNameEn : depth.displayNameTr,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
        ),
      ),
    );
  }

  Color _categoryColor(ContextModuleCategory category) {
    switch (category) {
      case ContextModuleCategory.emotionalLiteracy:
        return AppColors.brandPink;
      case ContextModuleCategory.mythVsReality:
        return AppColors.sunriseEnd;
      case ContextModuleCategory.patternRecognition:
        return AppColors.auroraStart;
      case ContextModuleCategory.selfAwareness:
        return AppColors.amethyst;
      case ContextModuleCategory.cyclicalWellness:
        return AppColors.success;
      case ContextModuleCategory.journalScience:
        return AppColors.starGold;
    }
  }

  IconData _categoryIcon(ContextModuleCategory category) {
    switch (category) {
      case ContextModuleCategory.emotionalLiteracy:
        return Icons.psychology_rounded;
      case ContextModuleCategory.mythVsReality:
        return Icons.lightbulb_outline_rounded;
      case ContextModuleCategory.patternRecognition:
        return Icons.timeline_rounded;
      case ContextModuleCategory.selfAwareness:
        return Icons.self_improvement_rounded;
      case ContextModuleCategory.cyclicalWellness:
        return Icons.loop_rounded;
      case ContextModuleCategory.journalScience:
        return Icons.science_rounded;
    }
  }
}
