// ════════════════════════════════════════════════════════════════════════════
// CHALLENGE HUB SCREEN - Redesigned Growth Challenges
// ════════════════════════════════════════════════════════════════════════════
// Active challenges with progress bars, available challenges grid,
// completed section, and stats bar.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/growth_challenge_service.dart';
import '../../../data/services/premium_service.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../data/services/smart_router_service.dart';
import '../../../data/services/ecosystem_analytics_service.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';

class ChallengeHubScreen extends ConsumerStatefulWidget {
  const ChallengeHubScreen({super.key});

  @override
  ConsumerState<ChallengeHubScreen> createState() => _ChallengeHubScreenState();
}

class _ChallengeHubScreenState extends ConsumerState<ChallengeHubScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(smartRouterServiceProvider).whenData((s) => s.recordToolVisit('challenges'));
      ref.read(ecosystemAnalyticsServiceProvider).whenData((s) => s.trackToolOpen('challenges', source: 'direct'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final challengeAsync = ref.watch(growthChallengeServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: challengeAsync.when(
          loading: () => const CosmicLoadingIndicator(),
          error: (_, _) => Center(
            child: Text(
              CommonStrings.somethingWentWrong(language),
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ),
          data: (service) => _buildContent(service, isDark, isEn),
        ),
      ),
    );
  }

  Widget _buildContent(GrowthChallengeService service, bool isDark, bool isEn) {
    final allChallenges = GrowthChallengeService.allChallenges;
    final activeChallenges = allChallenges.where((c) {
      final progress = service.getProgress(c.id);
      return progress != null && !progress.isCompleted;
    }).toList();
    final completedChallenges = allChallenges.where((c) => service.isCompleted(c.id)).toList();
    final availableChallenges = allChallenges.where((c) {
      final progress = service.getProgress(c.id);
      return progress == null && !service.isCompleted(c.id);
    }).toList();

    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          GlassSliverAppBar(title: isEn ? 'Challenges' : 'G\u00f6revler', showBackButton: false),
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats Bar
                _StatsBar(active: activeChallenges.length, completed: completedChallenges.length, total: allChallenges.length, isDark: isDark, isEn: isEn).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: AppConstants.spacingXl),

                // Active Challenges
                if (activeChallenges.isNotEmpty) ...[
                  _SectionTitle(title: isEn ? 'Active Challenges' : 'Aktif G\u00f6revler', isDark: isDark).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                  const SizedBox(height: AppConstants.spacingMd),
                  ...activeChallenges.asMap().entries.map((entry) {
                    final challenge = entry.value;
                    final progress = service.getProgress(challenge.id)!;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
                      child: _ActiveChallengeCard(challenge: challenge, progress: progress, isDark: isDark, isEn: isEn),
                    ).animate().fadeIn(delay: Duration(milliseconds: 150 + entry.key * 80), duration: 400.ms);
                  }),
                  const SizedBox(height: AppConstants.spacingLg),
                ],

                // Available Challenges
                _SectionTitle(title: isEn ? 'Available Challenges' : 'Mevcut G\u00f6revler', isDark: isDark).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                const SizedBox(height: AppConstants.spacingMd),
                ..._buildAvailableGrid(availableChallenges, service, isDark, isEn),
                const SizedBox(height: AppConstants.spacingXl),

                // Completed
                if (completedChallenges.isNotEmpty) ...[
                  _SectionTitle(title: isEn ? 'Completed (${completedChallenges.length})' : 'Tamamlanan (${completedChallenges.length})', isDark: isDark).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                  const SizedBox(height: AppConstants.spacingMd),
                  ...completedChallenges.map((c) => Padding(
                    padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
                    child: _CompletedChallengeTile(challenge: c, isDark: isDark, isEn: isEn),
                  )),
                ],

                ToolEcosystemFooter(
                  currentToolId: 'challengeHub',
                  isEn: isEn,
                  isDark: isDark,
                ),
                const SizedBox(height: AppConstants.spacingHuge),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAvailableGrid(List<GrowthChallenge> challenges, GrowthChallengeService service, bool isDark, bool isEn) {
    final rows = <Widget>[];
    for (int i = 0; i < challenges.length; i += 2) {
      final left = challenges[i];
      final right = i + 1 < challenges.length ? challenges[i + 1] : null;
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
          child: Row(
            children: [
              Expanded(child: _AvailableChallengeCard(challenge: left, isDark: isDark, isEn: isEn, onStart: () => _startChallenge(service, left.id))),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(child: right != null ? _AvailableChallengeCard(challenge: right, isDark: isDark, isEn: isEn, onStart: () => _startChallenge(service, right.id)) : const SizedBox.shrink()),
            ],
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: 250 + (i ~/ 2) * 60), duration: 400.ms),
      );
    }
    return rows;
  }

  Future<void> _startChallenge(GrowthChallengeService service, String id) async {
    // Check if this is a premium challenge and user is not premium
    final challenge = GrowthChallengeService.allChallenges.where((c) => c.id == id).firstOrNull;
    if (challenge != null && challenge.isPremium) {
      final isPremium = ref.read(isPremiumUserProvider);
      if (!isPremium) {
        if (mounted) {
          await showContextualPaywall(context, ref, paywallContext: PaywallContext.challenges);
        }
        return;
      }
    }
    await service.startChallenge(id);
    if (!mounted) return;
    setState(() {});
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;
  const _SectionTitle({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary));
  }
}

class _StatsBar extends StatelessWidget {
  final int active;
  final int completed;
  final int total;
  final bool isDark;
  final bool isEn;
  const _StatsBar({required this.active, required this.completed, required this.total, required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark.withValues(alpha: 0.85) : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(value: '$active', label: isEn ? 'Active' : 'Aktif', color: AppColors.auroraStart, isDark: isDark),
          _StatItem(value: '$completed', label: isEn ? 'Done' : 'Bitti', color: AppColors.success, isDark: isDark),
          _StatItem(value: '$total', label: isEn ? 'Total' : 'Toplam', color: AppColors.starGold, isDark: isDark),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool isDark;
  const _StatItem({required this.value, required this.label, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: color)),
        Text(label, style: TextStyle(fontSize: 11, color: isDark ? AppColors.textMuted : AppColors.lightTextMuted)),
      ],
    );
  }
}

class _ActiveChallengeCard extends StatelessWidget {
  final GrowthChallenge challenge;
  final ChallengeProgress progress;
  final bool isDark;
  final bool isEn;
  const _ActiveChallengeCard({required this.challenge, required this.progress, required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: AppColors.auroraStart.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(challenge.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isEn ? challenge.titleEn : challenge.titleTr, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary)),
                    Text('${progress.currentCount} / ${progress.targetCount}', style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.percent, minHeight: 6,
              backgroundColor: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.06),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.auroraStart),
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(isEn ? challenge.descriptionEn : challenge.descriptionTr, style: TextStyle(fontSize: 13, color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary, height: 1.4)),
        ],
      ),
    );
  }
}

class _AvailableChallengeCard extends StatelessWidget {
  final GrowthChallenge challenge;
  final bool isDark;
  final bool isEn;
  final VoidCallback onStart;
  const _AvailableChallengeCard({required this.challenge, required this.isDark, required this.isEn, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark.withValues(alpha: 0.6) : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: isDark ? AppColors.surfaceLight.withValues(alpha: 0.3) : AppColors.lightSurfaceVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(challenge.emoji, style: const TextStyle(fontSize: 24)),
              const Spacer(),
              if (challenge.isPremium)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppConstants.radiusSm), gradient: AppColors.primaryGradient),
                  child: Text('PRO', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(isEn ? challenge.titleEn : challenge.titleTr, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(isEn ? '${challenge.targetCount} days' : '${challenge.targetCount} g\u00fcn', style: TextStyle(fontSize: 12, color: isDark ? AppColors.textMuted : AppColors.lightTextMuted)),
          const SizedBox(height: AppConstants.spacingMd),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onStart,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.auroraStart,
                side: BorderSide(color: AppColors.auroraStart.withValues(alpha: 0.4)),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusSm)),
              ),
              child: Text(isEn ? 'Start' : 'Ba\u015fla', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedChallengeTile extends StatelessWidget {
  final GrowthChallenge challenge;
  final bool isDark;
  final bool isEn;
  const _CompletedChallengeTile({required this.challenge, required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg, vertical: AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark.withValues(alpha: 0.5) : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Row(
        children: [
          Text(challenge.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(child: Text(isEn ? challenge.titleEn : challenge.titleTr, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary))),
          const Icon(Icons.check_circle, size: 20, color: AppColors.success),
        ],
      ),
    );
  }
}
