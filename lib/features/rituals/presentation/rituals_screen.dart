import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/ritual_service.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/glass_dialog.dart';
import '../../../shared/widgets/gradient_outlined_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/premium_empty_state.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';
import '../../../data/services/l10n_service.dart';

class RitualsScreen extends ConsumerStatefulWidget {
  const RitualsScreen({super.key});

  @override
  ConsumerState<RitualsScreen> createState() => _RitualsScreenState();
}

class _RitualsScreenState extends ConsumerState<RitualsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _timeFilter = 'all'; // all, morning, midday, evening

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final stacksAsync = ref.watch(ritualStacksProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CupertinoScrollbar(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                GlassSliverAppBar(title: L10nService.get('rituals.rituals.my_rituals', language)),
                SliverPadding(
                  padding: const EdgeInsets.all(AppConstants.spacingLg),
                  sliver: stacksAsync.when(
                    loading: () => const SliverToBoxAdapter(
                      child: Center(child: CosmicLoadingIndicator()),
                    ),
                    error: (_, _) => SliverToBoxAdapter(
                      child: Center(
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
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton.icon(
                                onPressed: () =>
                                    ref.invalidate(ritualStacksProvider),
                                icon: Icon(Icons.refresh_rounded,
                                    size: 16, color: AppColors.starGold),
                                label: Text(
                                  L10nService.get('rituals.rituals.retry', language),
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
                    ),
                    data: (stacks) {
                      if (stacks.isEmpty) {
                        return SliverToBoxAdapter(
                          child: _EmptyState(isDark: isDark, isEn: isEn),
                        );
                      }

                      // Apply filters
                      var filtered = stacks.toList();
                      if (_searchQuery.isNotEmpty) {
                        filtered = filtered.where((s) =>
                            s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            s.items.any((i) => i.name.toLowerCase().contains(_searchQuery.toLowerCase()))).toList();
                      }
                      if (_timeFilter != 'all') {
                        filtered = filtered.where((s) => s.time.name == _timeFilter).toList();
                      }

                      return SliverList(
                        delegate: SliverChildListDelegate([
                          // Search bar
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : Colors.black.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (v) => setState(() => _searchQuery = v.trim()),
                              style: AppTypography.subtitle(
                                fontSize: 14,
                                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: isEn ? 'Search rituals...' : 'Ritüellerde ara...',
                                hintStyle: AppTypography.decorativeScript(
                                  fontSize: 13,
                                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                                ),
                                prefixIcon: Icon(CupertinoIcons.search, size: 18,
                                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          _searchController.clear();
                                          setState(() => _searchQuery = '');
                                        },
                                        child: Icon(CupertinoIcons.xmark_circle_fill, size: 16,
                                            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                                      )
                                    : null,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                            ),
                          ),
                          // Time filter chips
                          SizedBox(
                            height: 32,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _buildTimeChip(isEn ? 'All' : 'Tümü', 'all', isDark),
                                const SizedBox(width: 6),
                                _buildTimeChip(isEn ? 'Morning' : 'Sabah', 'morning', isDark),
                                const SizedBox(width: 6),
                                _buildTimeChip(isEn ? 'Evening' : 'Akşam', 'evening', isDark),
                                const SizedBox(width: 6),
                                _buildTimeChip(isEn ? 'Midday' : 'Öğle', 'midday', isDark),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),

                          ...filtered.asMap().entries.map((entry) {
                            return _StackCard(
                              stack: entry.value,
                              isDark: isDark,
                              isEn: isEn,
                              index: entry.key,
                            );
                          }),
                          const SizedBox(height: 24),
                          _AddButton(isDark: isDark, isEn: isEn),
                          const SizedBox(height: 24),
                          ToolEcosystemFooter(
                            currentToolId: 'rituals',
                            isEn: isEn,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 40),
                        ]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeChip(String label, String value, bool isDark) {
    final selected = _timeFilter == value;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _timeFilter = value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.auroraStart.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? AppColors.auroraStart
                : (isDark ? AppColors.textMuted : AppColors.lightTextMuted)
                    .withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.modernAccent(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected
                ? AppColors.auroraStart
                : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  final bool isEn;

  const _EmptyState({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    final language = AppLanguage.fromIsEn(isEn);
    return PremiumEmptyState(
      icon: Icons.playlist_add_check_rounded,
      title: L10nService.get('rituals.rituals.your_ritual_practice_starts_here', language),
      description: L10nService.get('rituals.rituals.create_your_first_daily_ritual_to_start', language),
      gradientVariant: GradientTextVariant.aurora,
      ctaLabel: L10nService.get('rituals.rituals.create_ritual', language),
      onCtaPressed: () => context.push(Routes.ritualCreate),
    );
  }
}

class _StackCard extends ConsumerWidget {
  final RitualStack stack;
  final bool isDark;
  final bool isEn;
  final int index;

  const _StackCard({
    required this.stack,
    required this.isDark,
    required this.isEn,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = AppLanguage.fromIsEn(isEn);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        style: PremiumCardStyle.subtle,
        borderRadius: 16,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppSymbol(stack.time.icon, size: AppSymbolSize.sm),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientText(
                        stack.name,
                        variant: GradientTextVariant.aurora,
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${stack.items.length} ${L10nService.get('rituals.rituals.items', language)}',
                        style: AppTypography.elegantAccent(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: L10nService.get('rituals.rituals.delete_ritual', language),
                  onPressed: () => _confirmDelete(context, ref),
                  icon: Icon(
                    Icons.delete_outline,
                    color: AppColors.error.withValues(alpha: 0.6),
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...stack.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 6,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.name,
                      style: AppTypography.decorativeScript(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: (index * 100).ms, duration: 300.ms),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final language = AppLanguage.fromIsEn(isEn);
    HapticFeedback.mediumImpact();
    final confirmed = await GlassDialog.confirm(
      context,
      title: L10nService.get('rituals.rituals.delete_ritual_1', language),
      message: isEn
          ? 'This will delete "${stack.name}" and all its completion history.'
          : '"${stack.name}" ve tüm tamamlama geçmişi silinecek.',
      cancelLabel: L10nService.get('rituals.rituals.cancel', language),
      confirmLabel: L10nService.get('rituals.rituals.delete', language),
      isDestructive: true,
    );

    if (confirmed == true) {
      if (!context.mounted) return;
      final service = await ref.read(ritualServiceProvider.future);
      await service.deleteStack(stack.id);
      if (!context.mounted) return;
      ref.invalidate(ritualStacksProvider);
      ref.invalidate(todayRitualSummaryProvider);
    }
  }
}

class _AddButton extends StatelessWidget {
  final bool isDark;
  final bool isEn;

  const _AddButton({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    final language = AppLanguage.fromIsEn(isEn);
    return Center(
      child: GradientOutlinedButton(
        label: L10nService.get('rituals.rituals.add_ritual', language),
        icon: Icons.add,
        variant: GradientTextVariant.aurora,
        onPressed: () => context.push(Routes.ritualCreate),
      ),
    );
  }
}
