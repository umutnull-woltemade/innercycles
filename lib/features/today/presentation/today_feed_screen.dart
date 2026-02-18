// ════════════════════════════════════════════════════════════════════════════
// TODAY FEED SCREEN - InnerCycles Personalized Daily Hub
// ════════════════════════════════════════════════════════════════════════════
// The "Today" tab. Shows personalized daily feed with smart suggestions,
// active challenges, mood check-in, streak, and quick actions.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/growth_challenge_service.dart';
import '../../streak/presentation/streak_card.dart';
import '../../streak/presentation/streak_recovery_banner.dart';
import '../../mood/presentation/mood_checkin_card.dart';
import '../../affirmation/presentation/affirmation_card.dart';
import '../../rituals/presentation/ritual_checkoff_card.dart';
import '../../prompts/presentation/today_prompt_card.dart';
import '../../quiz/presentation/quiz_suggestion_card.dart';
import '../../cosmic/presentation/cosmic_message_card.dart';

class TodayFeedScreen extends ConsumerStatefulWidget {
  const TodayFeedScreen({super.key});

  @override
  ConsumerState<TodayFeedScreen> createState() => _TodayFeedScreenState();
}

class _TodayFeedScreenState extends ConsumerState<TodayFeedScreen> {
  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProfile = ref.watch(userProfileProvider);
    final userName = userProfile?.name ?? '';

    return Scaffold(
      backgroundColor: isDark ? AppColors.deepSpace : AppColors.lightBackground,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            // ═══════════════════════════════════════════════════════
            // HEADER - Greeting + Quick Actions
            // ═══════════════════════════════════════════════════════
            SliverToBoxAdapter(
              child: _TodayHeader(
                userName: userName,
                isEn: isEn,
                isDark: isDark,
                language: language,
              ).animate().fadeIn(duration: 400.ms),
            ),

            // ═══════════════════════════════════════════════════════
            // QUICK ACCESS CHIPS
            // ═══════════════════════════════════════════════════════
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _QuickChip(
                        icon: Icons.edit_note_outlined,
                        label: isEn ? 'Journal' : 'Günlük',
                        onTap: () => context.push(Routes.journal),
                        isDark: isDark,
                      ),
                      const SizedBox(width: 8),
                      _QuickChip(
                        icon: Icons.nights_stay_outlined,
                        label: isEn ? 'Dream' : 'Rüya',
                        onTap: () => context.push(Routes.dreamInterpretation),
                        isDark: isDark,
                      ),
                      const SizedBox(width: 8),
                      _QuickChip(
                        icon: Icons.favorite_border,
                        label: isEn ? 'Gratitude' : 'Şükran',
                        onTap: () => context.push(Routes.gratitudeJournal),
                        isDark: isDark,
                      ),
                      const SizedBox(width: 8),
                      _QuickChip(
                        icon: Icons.air_outlined,
                        label: isEn ? 'Breathe' : 'Nefes',
                        onTap: () => context.push(Routes.breathing),
                        isDark: isDark,
                      ),
                      const SizedBox(width: 8),
                      _QuickChip(
                        icon: Icons.search_rounded,
                        label: isEn ? 'Search' : 'Ara',
                        onTap: () => context.push(Routes.search),
                        isDark: isDark,
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
              ),
            ),

            // ═══════════════════════════════════════════════════════
            // PRIMARY CTA
            // ═══════════════════════════════════════════════════════
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.push(Routes.journal),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDark ? AppColors.starGold : AppColors.lightStarGold,
                      foregroundColor: AppColors.deepSpace,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusLg),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            isEn
                                ? 'Map Today\'s Cycle Position'
                                : 'Bugünün Döngü Pozisyonunu Haritalandır',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ═══════════════════════════════════════════════════════
            // ACTIVE CHALLENGE CARD
            // ═══════════════════════════════════════════════════════
            SliverToBoxAdapter(
              child: _ActiveChallengeSection(isEn: isEn, isDark: isDark),
            ),

            // ═══════════════════════════════════════════════════════
            // FEED CARDS
            // ═══════════════════════════════════════════════════════
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Streak
                    const StreakRecoveryBanner(),
                    const MoodCheckinCard(),
                    const SizedBox(height: 12),
                    const AffirmationCard(),
                    const SizedBox(height: 12),
                    const CosmicMessageCard(),
                    const SizedBox(height: 12),
                    const TodayPromptCard(),
                    const SizedBox(height: 12),
                    const QuizSuggestionCard(),
                    const SizedBox(height: 12),
                    const StreakCard(),
                    const SizedBox(height: 12),
                    const RitualCheckoffCard(),
                    const SizedBox(height: 24),

                    // ═══════════════════════════════════════════════════
                    // SUGGESTED TOOLS
                    // ═══════════════════════════════════════════════════
                    _SuggestedToolsSection(isEn: isEn, isDark: isDark),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// TODAY HEADER
// ════════════════════════════════════════════════════════════════════════════

class _TodayHeader extends ConsumerWidget {
  final String userName;
  final bool isEn;
  final bool isDark;
  final AppLanguage language;

  const _TodayHeader({
    required this.userName,
    required this.isEn,
    required this.isDark,
    required this.language,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentAsync = ref.watch(contentEngineServiceProvider);
    final hookAsync = ref.watch(dailyHookServiceProvider);
    final hour = DateTime.now().hour;

    String greeting;
    if (hour < 12) {
      greeting = isEn ? 'Good morning' : 'Günaydın';
    } else if (hour < 18) {
      greeting = isEn ? 'Good afternoon' : 'İyi günler';
    } else {
      greeting = isEn ? 'Good evening' : 'İyi akşamlar';
    }

    final headline = contentAsync.maybeWhen(
      data: (engine) {
        final content = engine.generateDailyContent();
        return content.reflectiveQuestion;
      },
      orElse: () => isEn
          ? 'Which emotional cycle are you in right now?'
          : 'Şu an hangi duygusal döngüdesin?',
    );

    final sentence = hookAsync.maybeWhen(
      data: (hookService) => hour >= 18
          ? hookService.getEveningHook(isEnglish: isEn)
          : hookService.getMorningHook(isEnglish: isEn),
      orElse: () => isEn
          ? 'Your cycle engine is analyzing patterns across your recent entries.'
          : 'Döngü motorun son kayıtlarındaki örüntüleri analiz ediyor.',
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting, $userName',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
                          ? 'Emotional Cycle Intelligence'
                          : 'Duygusal Döngü Zekası',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => context.push(Routes.settings),
                icon: Icon(
                  Icons.settings_outlined,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                  size: 22,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Daily headline
          Text(
            headline,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.starGold : AppColors.lightStarGold,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 8),

          // Daily sentence
          Text(
            sentence,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// QUICK CHIP
// ════════════════════════════════════════════════════════════════════════════

class _QuickChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _QuickChip({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.cosmicPurple.withValues(alpha: 0.3)
                : AppColors.lightSurfaceVariant,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? AppColors.starGold.withValues(alpha: 0.2)
                  : AppColors.lightStarGold.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isDark ? AppColors.starGold : AppColors.lightStarGold,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// ACTIVE CHALLENGE SECTION
// ════════════════════════════════════════════════════════════════════════════

class _ActiveChallengeSection extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const _ActiveChallengeSection({
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengeAsync = ref.watch(growthChallengeServiceProvider);

    return challengeAsync.maybeWhen(
      data: (service) {
        // Build list of active challenges
        final activeList = <_ActiveChallengeData>[];
        for (final challenge in GrowthChallengeService.allChallenges) {
          final progress = service.getProgress(challenge.id);
          if (progress != null && !progress.isCompleted) {
            activeList.add(_ActiveChallengeData(
              challenge: challenge,
              progress: progress,
            ));
          }
        }

        if (activeList.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEn ? 'Active Challenges' : 'Aktif Görevler',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ...activeList.take(2).map((data) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ActiveChallengeCard(
                      data: data,
                      isEn: isEn,
                      isDark: isDark,
                    ),
                  )),
              const SizedBox(height: 8),
            ],
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _ActiveChallengeData {
  final GrowthChallenge challenge;
  final ChallengeProgress progress;

  const _ActiveChallengeData({
    required this.challenge,
    required this.progress,
  });
}

class _ActiveChallengeCard extends StatelessWidget {
  final _ActiveChallengeData data;
  final bool isEn;
  final bool isDark;

  const _ActiveChallengeCard({
    required this.data,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final challenge = data.challenge;
    final progress = data.progress;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: AppColors.starGold.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(challenge.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEn ? challenge.titleEn : challenge.titleTr,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${progress.currentCount}/${progress.targetCount}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(progress.percent * 100).round()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.starGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.percent,
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.starGold),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 12),
          // Apply button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                // Route to the appropriate tool based on challenge
                final route = _getChallengeRoute(challenge.id);
                context.push(route);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.starGold,
                side: const BorderSide(color: AppColors.starGold, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMd),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: Text(
                isEn ? 'Apply Now' : 'Şimdi Uygula',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getChallengeRoute(String challengeId) {
    switch (challengeId) {
      case 'journal_7day':
      case 'all_areas':
      case 'notes_master':
      case 'monthly_30':
        return Routes.journal;
      case 'gratitude_5':
        return Routes.gratitudeJournal;
      case 'morning_ritual':
        return Routes.rituals;
      case 'sleep_week':
        return Routes.sleepDetail;
      case 'breathing_5':
        return Routes.breathing;
      case 'pattern_seeker':
        return Routes.journalPatterns;
      case 'dream_week':
        return Routes.dreamInterpretation;
      case 'wellness_high':
        return Routes.wellnessDetail;
      case 'share_3':
        return Routes.shareCardGallery;
      default:
        return Routes.journal;
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SUGGESTED TOOLS SECTION
// ════════════════════════════════════════════════════════════════════════════

class _SuggestedToolsSection extends StatelessWidget {
  final bool isEn;
  final bool isDark;

  const _SuggestedToolsSection({
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final suggestions = [
      _ToolSuggestion(
        icon: Icons.insights_outlined,
        title: isEn ? 'Recurrence Detection' : 'Tekrar Tespiti',
        subtitle: isEn
            ? 'See patterns in your recent entries'
            : 'Son kayıtlarındaki kalıpları gör',
        route: Routes.journalPatterns,
        color: AppColors.auroraStart,
      ),
      _ToolSuggestion(
        icon: Icons.waves_outlined,
        title: isEn ? 'Emotional Cycles' : 'Duygusal Döngüler',
        subtitle: isEn
            ? 'Visualize your cycle rhythms'
            : 'Döngü ritimlerini görselleştir',
        route: Routes.emotionalCycles,
        color: AppColors.amethyst,
      ),
      _ToolSuggestion(
        icon: Icons.fingerprint_outlined,
        title: isEn ? 'Your Archetype' : 'Arketipiniz',
        subtitle: isEn ? 'Emotional profile' : 'Duygusal profil',
        route: Routes.archetype,
        color: AppColors.brandPink,
      ),
      _ToolSuggestion(
        icon: Icons.quiz_outlined,
        title: isEn ? 'Quiz Hub' : 'Test Merkezi',
        subtitle: isEn ? 'Pattern detection quizzes' : 'Örüntü tespit testleri',
        route: Routes.quizHub,
        color: AppColors.success,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEn ? 'Explore Tools' : 'Araçları Keşfet',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.textPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final tool = suggestions[index];
              return Padding(
                padding: EdgeInsets.only(right: index < suggestions.length - 1 ? 12 : 0),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.push(tool.route);
                  },
                  child: Container(
                    width: 150,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? tool.color.withValues(alpha: 0.08)
                          : tool.color.withValues(alpha: 0.05),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMd),
                      border: Border.all(
                        color: tool.color.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(tool.icon, color: tool.color, size: 24),
                        const Spacer(),
                        Text(
                          tool.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tool.subtitle,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate(delay: (50 * index).ms).fadeIn(duration: 300.ms);
            },
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }
}

class _ToolSuggestion {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final Color color;

  const _ToolSuggestion({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.color,
  });
}
