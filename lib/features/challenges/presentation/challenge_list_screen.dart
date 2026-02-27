// ════════════════════════════════════════════════════════════════════════════
// CHALLENGE LIST SCREEN - Growth Challenges
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/growth_challenge_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';
import '../../streak/presentation/challenge_celebration_modal.dart';

class ChallengeListScreen extends ConsumerWidget {
  const ChallengeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final isPremium = ref.watch(isPremiumUserProvider);
    final serviceAsync = ref.watch(growthChallengeServiceProvider);

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
                  title: isEn ? 'Growth Challenges' : 'Büyüme Görevleri',
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: serviceAsync.when(
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
                                    ref.invalidate(growthChallengeServiceProvider),
                                icon: Icon(
                                  Icons.refresh_rounded,
                                  size: 16,
                                  color: AppColors.starGold,
                                ),
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
                    data: (service) {
                      final challenges = GrowthChallengeService.allChallenges;

                      // Split into active, available, completed
                      final active = challenges.where((c) {
                        final p = service.getProgress(c.id);
                        return p != null && !p.isCompleted;
                      }).toList();
                      final completed = challenges
                          .where((c) => service.isCompleted(c.id))
                          .toList();
                      final available = challenges
                          .where(
                            (c) =>
                                service.getProgress(c.id) == null &&
                                !service.isCompleted(c.id),
                          )
                          .toList();

                      return SliverList(
                        delegate: SliverChildListDelegate([
                          // Stats bar
                          _StatsBar(
                            active: active.length,
                            completed: completed.length,
                            total: challenges.length,
                            isDark: isDark,
                            isEn: isEn,
                          ),
                          const SizedBox(height: 20),

                          // Active challenges
                          if (active.isNotEmpty) ...[
                            _SectionTitle(
                              title: isEn ? 'In Progress' : 'Devam Eden',
                              isDark: isDark,
                            ),
                            const SizedBox(height: 10),
                            ...active.map(
                              (c) => _ChallengeCard(
                                challenge: c,
                                progress: service.getProgress(c.id),
                                isCompleted: false,
                                isPremium: isPremium,
                                isDark: isDark,
                                isEn: isEn,
                                onIncrement: () async {
                                  final justCompleted = await service
                                      .incrementProgress(c.id);
                                  if (!context.mounted) return;
                                  ref.invalidate(
                                    growthChallengeServiceProvider,
                                  );
                                  HapticFeedback.mediumImpact();
                                  if (justCompleted && context.mounted) {
                                    ChallengeCelebrationModal.show(
                                      context,
                                      c,
                                      isEn,
                                    );
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // Available challenges
                          _SectionTitle(
                            title: isEn ? 'Available' : 'Mevcut',
                            isDark: isDark,
                          ),
                          const SizedBox(height: 10),
                          ...available.map(
                            (c) => _ChallengeCard(
                              challenge: c,
                              progress: null,
                              isCompleted: false,
                              isPremium: isPremium,
                              isDark: isDark,
                              isEn: isEn,
                              onStart: () async {
                                if (c.isPremium && !isPremium) {
                                  showContextualPaywall(
                                    context,
                                    ref,
                                    paywallContext: PaywallContext.challenges,
                                  );
                                  return;
                                }
                                await service.startChallenge(c.id);
                                if (!context.mounted) return;
                                ref.invalidate(growthChallengeServiceProvider);
                                HapticFeedback.mediumImpact();
                              },
                            ),
                          ),

                          // Completed challenges
                          if (completed.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            _SectionTitle(
                              title: isEn ? 'Completed' : 'Tamamlanan',
                              isDark: isDark,
                            ),
                            const SizedBox(height: 10),
                            ...completed.map(
                              (c) => _ChallengeCard(
                                challenge: c,
                                progress: null,
                                isCompleted: true,
                                isPremium: isPremium,
                                isDark: isDark,
                                isEn: isEn,
                              ),
                            ),
                          ],

                          ToolEcosystemFooter(
                            currentToolId: 'challengeList',
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

class _StatsBar extends StatelessWidget {
  final int active;
  final int completed;
  final int total;
  final bool isDark;
  final bool isEn;

  const _StatsBar({
    required this.active,
    required this.completed,
    required this.total,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      borderRadius: 14,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            value: '$active',
            label: isEn ? 'Active' : 'Aktif',
            color: AppColors.starGold,
            isDark: isDark,
          ),
          _StatItem(
            value: '$completed',
            label: isEn ? 'Completed' : 'Tamamlanan',
            color: AppColors.success,
            isDark: isDark,
          ),
          _StatItem(
            value: '$total',
            label: isEn ? 'Total' : 'Toplam',
            color: AppColors.auroraStart,
            isDark: isDark,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool isDark;

  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.displayFont.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTypography.elegantAccent(
            fontSize: 11,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SectionTitle({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GradientText(
      title,
      variant: GradientTextVariant.gold,
      style: AppTypography.displayFont.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final GrowthChallenge challenge;
  final ChallengeProgress? progress;
  final bool isCompleted;
  final bool isPremium;
  final bool isDark;
  final bool isEn;
  final VoidCallback? onStart;
  final VoidCallback? onIncrement;

  const _ChallengeCard({
    required this.challenge,
    this.progress,
    required this.isCompleted,
    required this.isPremium,
    required this.isDark,
    required this.isEn,
    this.onStart,
    this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = challenge.isPremium && !isPremium;
    final hasProgress = progress != null && !progress!.isCompleted;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PremiumCard(
        style: PremiumCardStyle.subtle,
        borderRadius: 14,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            isLocked
                ? Icon(
                    Icons.lock_rounded,
                    size: 24,
                    color: isDark ? Colors.white30 : Colors.black26,
                  )
                : AppSymbol(challenge.emoji, size: AppSymbolSize.md),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isEn ? challenge.titleEn : challenge.titleTr,
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                      if (isCompleted)
                        Icon(
                          Icons.check_circle,
                          size: 18,
                          color: AppColors.success,
                        ),
                      if (isLocked)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.starGold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'PRO',
                            style: AppTypography.elegantAccent(
                              fontSize: 10,
                              color: AppColors.starGold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isEn ? challenge.descriptionEn : challenge.descriptionTr,
                    style: AppTypography.decorativeScript(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                  if (hasProgress) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress!.percent,
                              minHeight: 4,
                              backgroundColor: isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : Colors.black.withValues(alpha: 0.06),
                              valueColor: AlwaysStoppedAnimation(
                                AppColors.starGold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${progress!.currentCount}/${progress!.targetCount}',
                          style: AppTypography.elegantAccent(
                            fontSize: 11,
                            color: AppColors.starGold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (hasProgress && onIncrement != null)
              Semantics(
                label: isEn ? 'Increment progress' : 'İlerlemeyi artır',
                button: true,
                child: GestureDetector(
                  onTap: onIncrement,
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Center(
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.starGold.withValues(alpha: 0.15),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 18,
                          color: AppColors.starGold,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else if (!isCompleted && !hasProgress && onStart != null)
              Semantics(
                label: isEn ? 'Start challenge' : 'Görevi başlat',
                button: true,
                child: GestureDetector(
                  onTap: onStart,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 44),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.auroraStart.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isEn ? 'Start' : 'Başla',
                        style: AppTypography.elegantAccent(
                          fontSize: 12,
                          color: AppColors.auroraStart,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms),
    );
  }
}
