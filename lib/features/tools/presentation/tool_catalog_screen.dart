// ════════════════════════════════════════════════════════════════════════════
// TOOL CATALOG SCREEN - Browse all 35 tools by category
// ════════════════════════════════════════════════════════════════════════════
// Search bar + Recently Used + Favorites + Category sections (2-col grid)
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/tool_manifest.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/premium_service.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../data/services/smart_router_service.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';

const Map<ToolCategory, _CategoryInfo> _categoryDisplayInfo = {
  ToolCategory.journal: _CategoryInfo(
    emoji: '\u{1F4D3}',
    nameEn: 'Journal & Recording',
    nameTr: 'G\u00fcnl\u00fck & Kay\u0131t',
  ),
  ToolCategory.analysis: _CategoryInfo(
    emoji: '\u{1F4CA}',
    nameEn: 'Analysis & Patterns',
    nameTr: 'Analiz & Kal\u0131plar',
  ),
  ToolCategory.discovery: _CategoryInfo(
    emoji: '\u{1F9E0}',
    nameEn: 'Discovery & Insight',
    nameTr: 'Ke\u015fif & \u0130\u00e7g\u00f6r\u00fc',
  ),
  ToolCategory.support: _CategoryInfo(
    emoji: '\u{1F33F}',
    nameEn: 'Support & Rituals',
    nameTr: 'Destek & Rit\u00fceller',
  ),
  ToolCategory.reference: _CategoryInfo(
    emoji: '\u{1F4D6}',
    nameEn: 'Reference',
    nameTr: 'Referans',
  ),
  ToolCategory.data: _CategoryInfo(
    emoji: '\u{1F4C8}',
    nameEn: 'Data & History',
    nameTr: 'Veri & Ge\u00e7mi\u015f',
  ),
};

class _CategoryInfo {
  final String emoji;
  final String nameEn;
  final String nameTr;
  const _CategoryInfo({
    required this.emoji,
    required this.nameEn,
    required this.nameTr,
  });
}

PaywallContext _paywallContextForTool(String toolId) {
  switch (toolId) {
    case 'patterns':
    case 'emotionalCycles':
    case 'insightsDiscovery':
    case 'insight':
    case 'sleepTrends':
      return PaywallContext.patterns;
    case 'dreamGlossary':
      return PaywallContext.dreams;
    case 'challenges':
      return PaywallContext.challenges;
    case 'programs':
      return PaywallContext.programs;
    case 'monthlyReport':
    case 'weeklyDigest':
    case 'yearReview':
      return PaywallContext.monthlyReport;
    default:
      return PaywallContext.general;
  }
}

class ToolCatalogScreen extends ConsumerStatefulWidget {
  const ToolCatalogScreen({super.key});

  @override
  ConsumerState<ToolCatalogScreen> createState() => _ToolCatalogScreenState();
}

class _ToolCatalogScreenState extends ConsumerState<ToolCatalogScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ToolManifest> _filterTools(List<ToolManifest> tools, bool isEn) {
    if (_searchQuery.isEmpty) return tools;
    return tools.where((tool) {
      final name = isEn ? tool.nameEn.toLowerCase() : tool.nameTr.toLowerCase();
      return name.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final smartRouterAsync = ref.watch(smartRouterServiceProvider);

    final isPremium = ref.watch(isPremiumUserProvider);
    final allTools = ToolManifestRegistry.all;
    final filteredTools = _filterTools(allTools, isEn);

    return Scaffold(
      body: CosmicBackground(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          behavior: HitTestBehavior.opaque,
          child: CupertinoScrollbar(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                GlassSliverAppBar(
                  title: isEn ? 'Tools' : 'Ara\u00e7lar',
                  showBackButton: false,
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(AppConstants.spacingLg),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Search Bar
                      _buildSearchBar(
                        isDark,
                        isEn,
                      ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                      const SizedBox(height: AppConstants.spacingXl),

                      if (_searchQuery.isNotEmpty) ...[
                        if (filteredTools.isEmpty)
                          _buildEmptySearch(
                            isDark,
                            isEn,
                          ).animate().fadeIn(duration: 400.ms, delay: 200.ms)
                        else
                          _buildToolGrid(
                            filteredTools,
                            isDark,
                            isEn,
                            smartRouterAsync,
                            0,
                            isPremium,
                          ),
                      ] else ...[
                        // Category Sections
                        ..._buildCategorySections(
                          isDark,
                          isEn,
                          smartRouterAsync,
                          isPremium,
                        ),
                      ],

                      const SizedBox(height: AppConstants.spacingHuge),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDark, bool isEn) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.6)
            : AppColors.lightSurfaceVariant.withValues(alpha: 0.8),
        border: Border.all(
          color: isDark
              ? AppColors.surfaceLight.withValues(alpha: 0.3)
              : AppColors.lightSurfaceVariant,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v.trim().toLowerCase()),
        style: AppTypography.subtitle(
          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
        ),
        decoration: InputDecoration(
          hintText: isEn ? 'Search tools...' : 'Ara\u00e7 ara...',
          hintStyle: AppTypography.subtitle(
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            size: 22,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  tooltip: isEn ? 'Clear search' : 'Aramayı temizle',
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                    size: 20,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
            vertical: AppConstants.spacingMd,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySearch(bool isDark, bool isEn) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingHuge),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: isDark
                ? AppColors.textMuted.withValues(alpha: 0.5)
                : AppColors.lightTextMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Text(
            isEn ? 'No tools found' : 'Ara\u00e7 bulunamad\u0131',
            style: AppTypography.displayFont.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCategorySections(
    bool isDark,
    bool isEn,
    AsyncValue<SmartRouterService> smartRouterAsync,
    bool isPremium,
  ) {
    final widgets = <Widget>[];
    int sectionIndex = 0;

    for (final category in ToolCategory.values) {
      final tools = ToolManifestRegistry.getByCategory(category);
      if (tools.isEmpty) continue;

      final info = _categoryDisplayInfo[category];
      if (info == null) continue;

      final delay = 200 + (sectionIndex * 100);

      widgets.add(
        _buildCategoryHeader(info, isDark, isEn)
            .animate()
            .fadeIn(
              duration: 500.ms,
              delay: Duration(milliseconds: delay),
            )
            .slideY(
              begin: 0.05,
              end: 0,
              duration: 500.ms,
              delay: Duration(milliseconds: delay),
            ),
      );
      widgets.add(const SizedBox(height: AppConstants.spacingMd));
      widgets.add(
        _buildToolGrid(
          tools,
          isDark,
          isEn,
          smartRouterAsync,
          delay + 100,
          isPremium,
        ),
      );
      widgets.add(const SizedBox(height: AppConstants.spacingXl));
      sectionIndex++;
    }
    return widgets;
  }

  Widget _buildCategoryHeader(_CategoryInfo info, bool isDark, bool isEn) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingSm),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? AppColors.surfaceLight.withValues(alpha: 0.2)
                : AppColors.lightSurfaceVariant,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Decorative gold accent bar
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [AppColors.starGold, AppColors.celestialGold]
                    : [AppColors.lightStarGold, AppColors.celestialGold],
              ),
            ),
          ),
          const SizedBox(width: 10),
          AppSymbol(info.emoji, size: AppSymbolSize.sm),
          const SizedBox(width: AppConstants.spacingSm),
          GradientText(
            isEn ? info.nameEn : info.nameTr,
            variant: GradientTextVariant.gold,
            style: AppTypography.displayFont.copyWith(
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolGrid(
    List<ToolManifest> tools,
    bool isDark,
    bool isEn,
    AsyncValue<SmartRouterService> smartRouterAsync,
    int baseDelay,
    bool isPremium,
  ) {
    final rows = <Widget>[];
    for (int i = 0; i < tools.length; i += 2) {
      final left = tools[i];
      final right = i + 1 < tools.length ? tools[i + 1] : null;
      final rowDelay = baseDelay + (i ~/ 2) * 60;

      rows.add(
        Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
              child: Row(
                children: [
                  Expanded(
                    child: _ToolCard(
                      tool: left,
                      isDark: isDark,
                      isEn: isEn,
                      smartRouterAsync: smartRouterAsync,
                      isPremium: isPremium,
                      onFavoriteToggle: () => _toggleFavorite(left),
                      onPremiumTap: () => showContextualPaywall(
                        context,
                        ref,
                        paywallContext: _paywallContextForTool(left.id),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingMd),
                  Expanded(
                    child: right != null
                        ? _ToolCard(
                            tool: right,
                            isDark: isDark,
                            isEn: isEn,
                            smartRouterAsync: smartRouterAsync,
                            isPremium: isPremium,
                            onFavoriteToggle: () => _toggleFavorite(right),
                            onPremiumTap: () => showContextualPaywall(
                              context,
                              ref,
                              paywallContext: _paywallContextForTool(right.id),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            )
            .animate()
            .fadeIn(
              duration: 400.ms,
              delay: Duration(milliseconds: rowDelay),
            )
            .slideY(
              begin: 0.04,
              end: 0,
              duration: 400.ms,
              delay: Duration(milliseconds: rowDelay),
            ),
      );
    }
    return Column(children: rows);
  }

  void _toggleFavorite(ToolManifest tool) {
    final smartRouterAsync = ref.read(smartRouterServiceProvider);
    smartRouterAsync.whenData((service) {
      service.toggleFavorite(tool.id);
      setState(() {});
    });
  }
}

class _ToolCard extends StatelessWidget {
  final ToolManifest tool;
  final bool isDark;
  final bool isEn;
  final bool isPremium;
  final AsyncValue<SmartRouterService> smartRouterAsync;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onPremiumTap;

  const _ToolCard({
    required this.tool,
    required this.isDark,
    required this.isEn,
    required this.smartRouterAsync,
    required this.isPremium,
    required this.onFavoriteToggle,
    required this.onPremiumTap,
  });

  @override
  Widget build(BuildContext context) {
    final isFavorite =
        smartRouterAsync.whenOrNull(
          data: (service) => service.isFavorite(tool.id),
        ) ??
        false;

    return Semantics(
      button: true,
      label: isEn ? tool.nameEn : tool.nameTr,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          if (tool.requiresPremium && !isPremium) {
            onPremiumTap();
            return;
          }
          context.push(tool.route);
        },
        child: PremiumCard(
          style: PremiumCardStyle.subtle,
          borderRadius: AppConstants.radiusLg,
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSymbol(tool.icon, size: AppSymbolSize.lg),
                  const Spacer(),
                  if (tool.requiresPremium)
                    Container(
                      margin: const EdgeInsets.only(right: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusSm,
                        ),
                        gradient: AppColors.primaryGradient,
                      ),
                      child: Text(
                        'PRO',
                        style: AppTypography.elegantAccent(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  Semantics(
                    button: true,
                    label: isFavorite
                        ? (isEn
                              ? 'Remove from favorites'
                              : 'Favorilerden çıkar')
                        : (isEn ? 'Add to favorites' : 'Favorilere ekle'),
                    child: GestureDetector(
                      onTap: onFavoriteToggle,
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(
                          child: Icon(
                            isFavorite
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 20,
                            color: isFavorite
                                ? AppColors.starGold
                                : (isDark
                                      ? AppColors.textMuted.withValues(
                                          alpha: 0.5,
                                        )
                                      : AppColors.lightTextMuted),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingSm),
              Text(
                isEn ? tool.nameEn : tool.nameTr,
                style: AppTypography.subtitle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                isEn ? tool.valuePropositionEn : tool.valuePropositionTr,
                style: AppTypography.decorativeScript(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
