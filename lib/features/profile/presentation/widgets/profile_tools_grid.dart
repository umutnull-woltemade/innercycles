// ════════════════════════════════════════════════════════════════════════════
// PROFILE TOOLS GRID - Suggested tools, category tabs, 2-col grid
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/tool_manifest.dart';
import '../../../../data/services/premium_service.dart';
import '../../../../data/services/smart_router_service.dart';
import '../../../../shared/widgets/app_symbol.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../premium/presentation/contextual_paywall_modal.dart';
import '../../../../data/services/l10n_service.dart';
import '../../../../data/providers/app_providers.dart';

class ProfileToolsGrid extends ConsumerStatefulWidget {
  final bool isDark;
  final bool isEn;

  const ProfileToolsGrid({
    super.key,
    required this.isDark,
    required this.isEn,
  });

  @override
  ConsumerState<ProfileToolsGrid> createState() => _ProfileToolsGridState();
}

class _ProfileToolsGridState extends ConsumerState<ProfileToolsGrid> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  ToolCategory? _selectedCategory;
  bool _isFavoritesFilter = false;

  static const _suggestedToolIds = ['journal', 'patterns', 'breathing'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ToolManifest> _getFilteredTools(SmartRouterService? service) {
    var tools = ToolManifestRegistry.all;

    if (_searchQuery.isNotEmpty) {
      tools = tools.where((t) {
        final name = widget.isEn
            ? t.nameEn.toLowerCase()
            : t.nameTr.toLowerCase();
        return name.contains(_searchQuery);
      }).toList();
    }

    if (_isFavoritesFilter && service != null) {
      tools = tools.where((t) => service.isFavorite(t.id)).toList();
    } else if (_selectedCategory != null) {
      tools = tools.where((t) => t.category == _selectedCategory).toList();
    }

    return tools;
  }

  @override
  Widget build(BuildContext context) {
    final smartRouterAsync = ref.watch(smartRouterServiceProvider);
    final isPremium = ref.watch(isPremiumUserProvider);
    final service = smartRouterAsync.whenOrNull(data: (s) => s);
    final filteredTools = _getFilteredTools(service);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        GradientText(
          L10nService.get('profile.profile_tools_grid.tools', widget.isEn ? AppLanguage.en : AppLanguage.tr),
          variant: GradientTextVariant.gold,
          style: AppTypography.elegantAccent(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.5,
          ),
        ),
        const SizedBox(height: AppConstants.spacingLg),

        // Suggested for You
        _buildSuggestedSection(isPremium),
        const SizedBox(height: AppConstants.spacingXl),

        // Search bar
        _buildSearchBar(),
        const SizedBox(height: AppConstants.spacingMd),

        // Category filter tabs
        _buildCategoryTabs(),
        const SizedBox(height: AppConstants.spacingLg),

        // Tool grid or empty state
        if (filteredTools.isEmpty)
          _buildEmptyState()
        else
          _buildToolGrid(filteredTools, smartRouterAsync, isPremium),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SUGGESTED FOR YOU
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildSuggestedSection(bool isPremium) {
    final suggestedTools = ToolManifestRegistry.all
        .where((t) => _suggestedToolIds.contains(t.id))
        .toList();

    if (suggestedTools.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          L10nService.get('profile.profile_tools_grid.suggested_for_you', widget.isEn ? AppLanguage.en : AppLanguage.tr),
          variant: GradientTextVariant.gold,
          style: AppTypography.elegantAccent(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: suggestedTools.asMap().entries.map((entry) {
              return Padding(
                padding: EdgeInsets.only(
                  right: entry.key < suggestedTools.length - 1
                      ? AppConstants.spacingMd
                      : 0,
                ),
                child: _buildSuggestionCard(entry.value, isPremium),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionCard(ToolManifest tool, bool isPremium) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (tool.requiresPremium && !isPremium) {
          showContextualPaywall(
            context,
            ref,
            paywallContext: _paywallContextForTool(tool.id),
          );
          return;
        }
        context.push(tool.route);
      },
      child: SizedBox(
        width: 140,
        child: PremiumCard(
          style: PremiumCardStyle.aurora,
          borderRadius: AppConstants.radiusMd,
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSymbol.card(tool.icon),
              const SizedBox(height: AppConstants.spacingSm),
              Text(
                widget.isEn ? tool.nameEn : tool.nameTr,
                style: AppTypography.subtitle(
                  fontSize: 12,
                  color: widget.isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                widget.isEn
                    ? tool.valuePropositionEn
                    : tool.valuePropositionTr,
                style: AppTypography.decorativeScript(
                  fontSize: 11,
                  color: widget.isDark
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

  // ══════════════════════════════════════════════════════════════════════════
  // SEARCH BAR
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        color: widget.isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.6)
            : AppColors.lightSurfaceVariant.withValues(alpha: 0.8),
        border: Border.all(
          color: widget.isDark
              ? AppColors.surfaceLight.withValues(alpha: 0.3)
              : AppColors.lightSurfaceVariant,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v.trim().toLowerCase()),
        style: AppTypography.subtitle(
          color: widget.isDark
              ? AppColors.textPrimary
              : AppColors.lightTextPrimary,
        ),
        decoration: InputDecoration(
          hintText: L10nService.get('profile.profile_tools_grid.search_by_name_or_category', widget.isEn ? AppLanguage.en : AppLanguage.tr),
          hintStyle: AppTypography.subtitle(
            color: widget.isDark
                ? AppColors.textMuted
                : AppColors.lightTextMuted,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: widget.isDark
                ? AppColors.textMuted
                : AppColors.lightTextMuted,
            size: 22,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  tooltip: L10nService.get('profile.profile_tools_grid.clear_search', widget.isEn ? AppLanguage.en : AppLanguage.tr),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    color: widget.isDark
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

  // ══════════════════════════════════════════════════════════════════════════
  // CATEGORY TABS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildCategoryTabs() {
    final isAll = !_isFavoritesFilter && _selectedCategory == null;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _buildChip(
            L10nService.get('profile.profile_tools_grid.all', widget.isEn ? AppLanguage.en : AppLanguage.tr),
            isActive: isAll,
            onTap: () => setState(() {
              _selectedCategory = null;
              _isFavoritesFilter = false;
            }),
          ),
          const SizedBox(width: AppConstants.spacingSm),
          _buildChip(
            L10nService.get('profile.profile_tools_grid.favorites_u2b50', widget.isEn ? AppLanguage.en : AppLanguage.tr),
            isActive: _isFavoritesFilter,
            onTap: () => setState(() {
              _isFavoritesFilter = true;
              _selectedCategory = null;
            }),
          ),
          const SizedBox(width: AppConstants.spacingSm),
          ...ToolCategory.values.map((cat) {
            return Padding(
              padding: const EdgeInsets.only(right: AppConstants.spacingSm),
              child: _buildChip(
                _categoryLabel(cat),
                isActive: _selectedCategory == cat,
                onTap: () => setState(() {
                  _selectedCategory = cat;
                  _isFavoritesFilter = false;
                }),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          gradient: isActive
              ? const LinearGradient(
                  colors: [AppColors.starGold, AppColors.celestialGold],
                )
              : null,
          color: isActive
              ? null
              : (widget.isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06)),
        ),
        child: Text(
          label,
          style: AppTypography.elegantAccent(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive
                ? AppColors.deepSpace
                : (widget.isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary),
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TOOL GRID
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildToolGrid(
    List<ToolManifest> tools,
    AsyncValue<SmartRouterService> smartRouterAsync,
    bool isPremium,
  ) {
    final rows = <Widget>[];
    for (int i = 0; i < tools.length; i += 2) {
      final left = tools[i];
      final right = i + 1 < tools.length ? tools[i + 1] : null;
      final rowDelay = (i ~/ 2) * 60;

      rows.add(
        Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
              child: Row(
                children: [
                  Expanded(
                    child: _ProfileToolCard(
                      tool: left,
                      isDark: widget.isDark,
                      isEn: widget.isEn,
                      isPremium: isPremium,
                      smartRouterAsync: smartRouterAsync,
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
                        ? _ProfileToolCard(
                            tool: right,
                            isDark: widget.isDark,
                            isEn: widget.isEn,
                            isPremium: isPremium,
                            smartRouterAsync: smartRouterAsync,
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

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingHuge),
      child: Column(
        children: [
          Icon(
            _isFavoritesFilter
                ? Icons.star_outline_rounded
                : Icons.search_off_rounded,
            size: 48,
            color: widget.isDark
                ? AppColors.textMuted.withValues(alpha: 0.5)
                : AppColors.lightTextMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Text(
            _isFavoritesFilter
                ? (L10nService.get('profile.profile_tools_grid.no_favorites_yet', widget.isEn ? AppLanguage.en : AppLanguage.tr))
                : (L10nService.get('profile.profile_tools_grid.no_tools_found', widget.isEn ? AppLanguage.en : AppLanguage.tr)),
            style: AppTypography.displayFont.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: widget.isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(ToolManifest tool) {
    final smartRouterAsync = ref.read(smartRouterServiceProvider);
    smartRouterAsync.whenData((service) {
      service.toggleFavorite(tool.id);
      setState(() {});
    });
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  String _categoryLabel(ToolCategory category) {
    switch (category) {
      case ToolCategory.journal:
        return L10nService.get('profile.profile_tools_grid.journal', widget.isEn ? AppLanguage.en : AppLanguage.tr);
      case ToolCategory.analysis:
        return L10nService.get('profile.profile_tools_grid.analysis', widget.isEn ? AppLanguage.en : AppLanguage.tr);
      case ToolCategory.discovery:
        return L10nService.get('profile.profile_tools_grid.discovery', widget.isEn ? AppLanguage.en : AppLanguage.tr);
      case ToolCategory.support:
        return L10nService.get('profile.profile_tools_grid.support', widget.isEn ? AppLanguage.en : AppLanguage.tr);
      case ToolCategory.reference:
        return L10nService.get('profile.profile_tools_grid.reference', widget.isEn ? AppLanguage.en : AppLanguage.tr);
      case ToolCategory.data:
        return L10nService.get('profile.profile_tools_grid.data', widget.isEn ? AppLanguage.en : AppLanguage.tr);
    }
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// TOOL CARD - Enhanced with category accent bar
// ══════════════════════════════════════════════════════════════════════════════

Color _categoryAccentColor(ToolCategory category) {
  switch (category) {
    case ToolCategory.journal:
      return AppColors.starGold;
    case ToolCategory.analysis:
      return AppColors.auroraStart;
    case ToolCategory.discovery:
      return AppColors.amethyst;
    case ToolCategory.support:
      return AppColors.chartGreen;
    case ToolCategory.reference:
      return AppColors.cosmic;
    case ToolCategory.data:
      return AppColors.chartBlue;
  }
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

class _ProfileToolCard extends StatelessWidget {
  final ToolManifest tool;
  final bool isDark;
  final bool isEn;
  final bool isPremium;
  final AsyncValue<SmartRouterService> smartRouterAsync;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onPremiumTap;

  const _ProfileToolCard({
    required this.tool,
    required this.isDark,
    required this.isEn,
    required this.isPremium,
    required this.smartRouterAsync,
    required this.onFavoriteToggle,
    required this.onPremiumTap,
  });

  @override
  Widget build(BuildContext context) {
    final isFavorite = smartRouterAsync.whenOrNull(
          data: (service) => service.isFavorite(tool.id),
        ) ??
        false;

    final accentColor = _categoryAccentColor(tool.category);

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
          padding: EdgeInsets.zero,
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Category accent bar
                Container(
                  width: 3,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppConstants.radiusLg),
                      bottomLeft: Radius.circular(AppConstants.radiusLg),
                    ),
                    color: accentColor,
                  ),
                ),
                // Card content
                Expanded(
                  child: Padding(
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
                                  ? (L10nService.get('profile.profile_tools_grid.remove_from_favorites', isEn ? AppLanguage.en : AppLanguage.tr))
                                  : (L10nService.get('profile.profile_tools_grid.add_to_favorites', isEn ? AppLanguage.en : AppLanguage.tr)),
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
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isEn
                              ? tool.valuePropositionEn
                              : tool.valuePropositionTr,
                          style: AppTypography.decorativeScript(
                            fontSize: 11,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
