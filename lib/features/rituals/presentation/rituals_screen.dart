import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/ritual_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

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
                GlassSliverAppBar(
                  title: isEn ? 'My Rituals' : 'Ritüellerim',
                ),
              SliverPadding(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                sliver: stacksAsync.when(
                  loading: () => const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, _) => const SliverToBoxAdapter(
                    child: SizedBox.shrink(),
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
    return Column(
      children: [
        const SizedBox(height: 60),
        Icon(
          Icons.playlist_add_check_rounded,
          size: 64,
          color: AppColors.auroraStart.withValues(alpha: 0.5),
        ),
        const SizedBox(height: 16),
        Text(
          isEn ? 'No rituals yet' : 'Henüz ritüel yok',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isEn
              ? 'Create your first daily ritual to start tracking habits'
              : 'Alışkanlıkları takip etmek için ilk ritüelini oluştur',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () => context.push(Routes.ritualCreate),
          icon: const Icon(Icons.add),
          label: Text(isEn ? 'Create Ritual' : 'Ritüel Oluştur'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.auroraStart,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
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
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark.withValues(alpha: 0.85)
              : AppColors.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(stack.time.icon, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stack.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        '${stack.items.length} ${isEn ? 'items' : 'madde'}',
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
                IconButton(
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
            ...stack.items.map((item) => Padding(
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
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ).animate().fadeIn(delay: (index * 100).ms, duration: 300.ms),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    HapticFeedback.mediumImpact();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEn ? 'Delete Ritual?' : 'Ritüelü Sil?'),
        content: Text(
          isEn
              ? 'This will delete "${stack.name}" and all its completion history.'
              : '"${stack.name}" ve tüm tamamlama geçmişi silinecek.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(isEn ? 'Cancel' : 'İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              isEn ? 'Delete' : 'Sil',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final service = await ref.read(ritualServiceProvider.future);
      await service.deleteStack(stack.id);
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
      child: OutlinedButton.icon(
        onPressed: () => context.push(Routes.ritualCreate),
        icon: const Icon(Icons.add),
        label: Text(isEn ? 'Add Ritual' : 'Ritüel Ekle'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.auroraStart,
          side: BorderSide(color: AppColors.auroraStart.withValues(alpha: 0.5)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
