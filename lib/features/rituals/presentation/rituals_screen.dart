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

class RitualsScreen extends ConsumerWidget {
  const RitualsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                GlassSliverAppBar(title: isEn ? 'My Rituals' : 'Ritüellerim'),
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
                                  isEn ? 'Retry' : 'Tekrar Dene',
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
                      return SliverList(
                        delegate: SliverChildListDelegate([
                          ...stacks.asMap().entries.map((entry) {
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
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  final bool isEn;

  const _EmptyState({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return PremiumEmptyState(
      icon: Icons.playlist_add_check_rounded,
      title: isEn ? 'Your ritual practice starts here' : 'Ritüel pratiğin burada başlıyor',
      description: isEn
          ? 'Create your first daily ritual to start tracking habits'
          : 'Alışkanlıkları takip etmek için ilk ritüelini oluştur',
      gradientVariant: GradientTextVariant.aurora,
      ctaLabel: isEn ? 'Create Ritual' : 'Ritüel Oluştur',
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
                        '${stack.items.length} ${isEn ? 'items' : 'madde'}',
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
                  tooltip: isEn ? 'Delete ritual' : 'Ritüeli sil',
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
    HapticFeedback.mediumImpact();
    final confirmed = await GlassDialog.confirm(
      context,
      title: isEn ? 'Delete Ritual?' : 'Ritüelü Sil?',
      message: isEn
          ? 'This will delete "${stack.name}" and all its completion history.'
          : '"${stack.name}" ve tüm tamamlama geçmişi silinecek.',
      cancelLabel: isEn ? 'Cancel' : 'İptal',
      confirmLabel: isEn ? 'Delete' : 'Sil',
      isDestructive: true,
    );

    if (confirmed == true) {
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
    return Center(
      child: GradientOutlinedButton(
        label: isEn ? 'Add Ritual' : 'Ritüel Ekle',
        icon: Icons.add,
        variant: GradientTextVariant.aurora,
        onPressed: () => context.push(Routes.ritualCreate),
      ),
    );
  }
}
