// ════════════════════════════════════════════════════════════════════════════
// CHALLENGE LIST SCREEN - Growth Challenges
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/growth_challenge_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';

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
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, _) => SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          isEn ? 'Something went wrong' : 'Bir şeyler yanlış gitti',
                          style: TextStyle(
                            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                          ),
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
                        .where((c) =>
                            service.getProgress(c.id) == null &&
                            !service.isCompleted(c.id))
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
                          ...active.map((c) => _ChallengeCard(
                                challenge: c,
                                progress: service.getProgress(c.id),
                                isCompleted: false,
                                isPremium: isPremium,
                                isDark: isDark,
                                isEn: isEn,
                                onIncrement: () async {
                                  await service.incrementProgress(c.id);
                                  ref.invalidate(
                                      growthChallengeServiceProvider);
                                  HapticFeedback.mediumImpact();
                                },
                              )),
                          const SizedBox(height: 20),
                        ],

                        // Available challenges
                        _SectionTitle(
                          title: isEn ? 'Available' : 'Mevcut',
                          isDark: isDark,
                        ),
                        const SizedBox(height: 10),
                        ...available.map((c) => _ChallengeCard(
                              challenge: c,
                              progress: null,
                              isCompleted: false,
                              isPremium: isPremium,
                              isDark: isDark,
                              isEn: isEn,
                              onStart: () async {
                                if (c.isPremium && !isPremium) {
                                  showContextualPaywall(context, ref, paywallContext: PaywallContext.challenges);
                                  return;
                                }
                                await service.startChallenge(c.id);
                                ref.invalidate(growthChallengeServiceProvider);
                                HapticFeedback.mediumImpact();
                              },
                            )),

                        // Completed challenges
                        if (completed.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          _SectionTitle(
                            title: isEn ? 'Completed' : 'Tamamlanan',
                            isDark: isDark,
                          ),
                          const SizedBox(height: 10),
                          ...completed.map((c) => _ChallengeCard(
                                challenge: c,
                                progress: null,
                                isCompleted: true,
                                isPremium: isPremium,
                                isDark: isDark,
                                isEn: isEn,
                              )),
                        ],

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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
      ),
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
            label: isEn ? 'Done' : 'Bitti',
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
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
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
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
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
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark.withValues(alpha: 0.85)
              : AppColors.lightCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isCompleted
                ? AppColors.success.withValues(alpha: 0.3)
                : hasProgress
                    ? AppColors.starGold.withValues(alpha: 0.2)
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.04)),
          ),
        ),
        child: Row(
          children: [
            Text(
              isLocked ? '🔒' : challenge.emoji,
              style: const TextStyle(fontSize: 28),
            ),
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
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                      if (isCompleted)
                        Icon(Icons.check_circle,
                            size: 18, color: AppColors.success),
                      if (isLocked)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.starGold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'PRO',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.starGold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isEn
                        ? challenge.descriptionEn
                        : challenge.descriptionTr,
                    style: TextStyle(
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
                              valueColor:
                                  AlwaysStoppedAnimation(AppColors.starGold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${progress!.currentCount}/${progress!.targetCount}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
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
              GestureDetector(
                onTap: onIncrement,
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
              )
            else if (!isCompleted &&
                !hasProgress &&
                onStart != null)
              GestureDetector(
                onTap: onStart,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.auroraStart.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isEn ? 'Start' : 'Başla',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.auroraStart,
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
