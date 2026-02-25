// ============================================================================
// INNERCYCLES WRAPPED - Cinematic Annual Recap Experience
// ============================================================================
// Spotify-Wrapped-style swipeable story cards summarizing the user's year.
// 8 cards: intro → emotional arc → intense week → focus map → growth score →
// breakthroughs → top patterns → CTA/share.
// First 3 free, cards 4-8 behind premium gate.
// ============================================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/common_strings.dart';
import '../../../core/theme/app_typography.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/emotional_gradient.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../data/models/wrapped_data.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/premium_service.dart';
import '../../../features/premium/presentation/contextual_paywall_modal.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_text.dart';

// ============================================================================
// PROVIDERS
// ============================================================================

final _wrappedDataProvider = FutureProvider.family<WrappedData?, int>((
  ref,
  year,
) async {
  final service = await ref.watch(yearReviewServiceProvider.future);
  return await service.generateWrapped(year);
});

// ============================================================================
// SCREEN
// ============================================================================

class WrappedScreen extends ConsumerStatefulWidget {
  final int? year;
  const WrappedScreen({super.key, this.year});

  @override
  ConsumerState<WrappedScreen> createState() => _WrappedScreenState();
}

class _WrappedScreenState extends ConsumerState<WrappedScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  int get _year => widget.year ?? DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPremium = ref.watch(isPremiumUserProvider);
    final wrappedAsync = ref.watch(_wrappedDataProvider(_year));

    return Scaffold(
      body: CosmicBackground(
        child: wrappedAsync.when(
          loading: () => const Center(child: CosmicLoadingIndicator()),
          error: (e, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: AppColors.textMuted, size: 48),
                const SizedBox(height: 16),
                Text(
                  isEn
                      ? 'Not enough entries for your Wrapped yet'
                      : 'Wrapped için henüz yeterli kayıt yok',
                  style: AppTypography.subtitle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          data: (data) {
            if (data == null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: AppColors.starGold,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isEn
                          ? 'Keep journaling to unlock your Wrapped!'
                          : 'Wrapped\'ını açmak için yazmaya devam et!',
                      style: AppTypography.subtitle(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return SafeArea(
              child: Stack(
                children: [
                  // Story cards
                  PageView.builder(
                    controller: _pageController,
                    itemCount: 8,
                    onPageChanged: (page) {
                      setState(() => _currentPage = page);
                      // Premium gate at card 4 (index 3)
                      if (page >= 3 && !isPremium) {
                        _pageController.animateToPage(
                          3,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                        showContextualPaywall(
                          context,
                          ref,
                          paywallContext: PaywallContext.monthlyReport,
                        );
                      }
                      HapticFeedback.mediumImpact();
                    },
                    itemBuilder: (context, index) {
                      // Block content for non-premium at card 4+
                      if (index >= 3 && !isPremium) {
                        return _PremiumGateCard(isEn: isEn, isDark: isDark);
                      }
                      return _buildCard(index, data, isEn, isDark);
                    },
                  ),

                  // Page indicator dots
                  Positioned(
                    top: 12,
                    left: 20,
                    right: 20,
                    child: _PageIndicator(
                      current: _currentPage,
                      total: 8,
                      isPremium: isPremium,
                    ),
                  ),

                  // Close button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: AppColors.textSecondary,
                        size: 24,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard(int index, WrappedData data, bool isEn, bool isDark) {
    switch (index) {
      case 0:
        return _IntroCard(data: data, isEn: isEn, isDark: isDark);
      case 1:
        return _EmotionalArcCard(data: data, isEn: isEn, isDark: isDark);
      case 2:
        return _IntenseWeekCard(data: data, isEn: isEn, isDark: isDark);
      case 3:
        return _FocusAreaCard(data: data, isEn: isEn, isDark: isDark);
      case 4:
        return _GrowthScoreCard(data: data, isEn: isEn, isDark: isDark);
      case 5:
        return _BreakthroughCard(data: data, isEn: isEn, isDark: isDark);
      case 6:
        return _TopPatternsCard(data: data, isEn: isEn, isDark: isDark);
      case 7:
        return _ClosingCard(data: data, isEn: isEn, isDark: isDark);
      default:
        return const SizedBox.shrink();
    }
  }
}

// ============================================================================
// PAGE INDICATOR
// ============================================================================

class _PageIndicator extends StatelessWidget {
  final int current;
  final int total;
  final bool isPremium;

  const _PageIndicator({
    required this.current,
    required this.total,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final isActive = i == current;
        final isLocked = i >= 3 && !isPremium;
        return Expanded(
          child: Container(
            height: 3,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: isLocked
                  ? AppColors.textMuted.withValues(alpha: 0.2)
                  : isActive
                      ? AppColors.starGold
                      : i < current
                          ? AppColors.starGold.withValues(alpha: 0.5)
                          : AppColors.textMuted.withValues(alpha: 0.3),
            ),
          ),
        );
      }),
    );
  }
}

// ============================================================================
// BASE CARD WRAPPER
// ============================================================================

class _WrappedCardBase extends StatelessWidget {
  final List<Color> gradientColors;
  final Widget child;

  const _WrappedCardBase({
    required this.gradientColors,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Subtle glass overlay
            Positioned.fill(
              child: GlassPanel(
                elevation: GlassElevation.g1,
                borderRadius: BorderRadius.circular(28),
                child: const SizedBox.expand(),
              ),
            ),
            // Content
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: child,
              ),
            ),
            // Watermark
            Positioned(
              bottom: 16,
              right: 20,
              child: Text(
                'InnerCycles',
                style: AppTypography.elegantAccent(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted.withValues(alpha: 0.5),
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// ANIMATED STAT COUNTER
// ============================================================================

class _AnimatedStat extends StatelessWidget {
  final int value;
  final double fontSize;
  final Color color;

  const _AnimatedStat({
    required this.value,
    this.fontSize = 56,
    this.color = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOutCubic,
      builder: (context, val, _) {
        return Text(
          '${val.toInt()}',
          style: AppTypography.displayFont.copyWith(
            fontSize: fontSize,
            fontWeight: FontWeight.w200,
            color: color,
            height: 1.0,
          ),
        );
      },
    );
  }
}

// ============================================================================
// CARD 1: INTRO — "Your Year in Patterns"
// ============================================================================

class _IntroCard extends StatelessWidget {
  final WrappedData data;
  final bool isEn;
  final bool isDark;

  const _IntroCard({
    required this.data,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return _WrappedCardBase(
      gradientColors: [
        AppColors.starGold.withValues(alpha: 0.15),
        AppColors.celestialGold.withValues(alpha: 0.08),
        AppColors.deepSpace,
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          Icon(
            Icons.auto_awesome,
            color: AppColors.starGold,
            size: 48,
          ).animate().scale(
            duration: 600.ms,
            curve: Curves.elasticOut,
          ),
          const SizedBox(height: 24),
          GradientText(
            isEn ? 'Your Year in Patterns' : 'Örüntülerle Geçen Yılın',
            variant: GradientTextVariant.cosmic,
            textAlign: TextAlign.center,
            style: AppTypography.displayFont.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideY(
            begin: 0.2,
            end: 0,
            delay: 200.ms,
            duration: 500.ms,
          ),
          const SizedBox(height: 8),
          GradientText(
            '${data.year}',
            variant: GradientTextVariant.gold,
            style: AppTypography.elegantAccent(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              letterSpacing: 4,
            ),
          ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _MiniStatColumn(
                value: '${data.totalEntries}',
                label: isEn ? 'entries' : 'kayıt',
              ),
              _MiniStatColumn(
                value: '${data.totalJournalingDays}',
                label: isEn ? 'days' : 'gün',
              ),
            ],
          ).animate().fadeIn(delay: 600.ms, duration: 500.ms),
          const Spacer(flex: 3),
          Text(
            isEn ? 'Swipe to explore →' : 'Keşfetmek için kaydır →',
            style: AppTypography.subtitle(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ).animate(
            onPlay: (c) => c.repeat(reverse: true),
          ).fadeIn(duration: 800.ms).then().fadeOut(duration: 800.ms),
        ],
      ),
    );
  }
}

// ============================================================================
// CARD 2: EMOTIONAL ARC
// ============================================================================

class _EmotionalArcCard extends StatelessWidget {
  final WrappedData data;
  final bool isEn;
  final bool isDark;

  const _EmotionalArcCard({
    required this.data,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final arcColors = EmotionalGradient.emotionalGradient(data.averageMood);

    return _WrappedCardBase(
      gradientColors: [
        arcColors.first.withValues(alpha: 0.2),
        arcColors.last.withValues(alpha: 0.1),
        AppColors.deepSpace,
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          GradientText(
            isEn ? 'Your Emotional Arc' : 'Duygusal Yörüngen',
            variant: GradientTextVariant.aurora,
            style: AppTypography.elegantAccent(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 16),
          Text(
            data.dominantEmotionalArc.label(isEn),
            style: AppTypography.displayFont.copyWith(
              fontSize: 42,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.1,
            ),
          ).animate().fadeIn(delay: 300.ms, duration: 500.ms).scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1, 1),
            delay: 300.ms,
            duration: 500.ms,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              data.dominantEmotionalArc.description(isEn),
              textAlign: TextAlign.center,
              style: AppTypography.decorativeScript(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
          ).animate().fadeIn(delay: 500.ms, duration: 500.ms),
          const SizedBox(height: 24),
          // Mini mood journey bar chart
          SizedBox(
            height: 60,
            child: _MoodJourneyBars(
              values: data.moodJourney,
              arcColors: arcColors,
            ),
          ).animate().fadeIn(delay: 700.ms, duration: 500.ms),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

// ============================================================================
// CARD 3: MOST INTENSE WEEK
// ============================================================================

class _IntenseWeekCard extends StatelessWidget {
  final WrappedData data;
  final bool isEn;
  final bool isDark;

  const _IntenseWeekCard({
    required this.data,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final weekStr = data.mostIntenseWeek != null
        ? _formatWeek(data.mostIntenseWeek!, isEn)
        : (isEn ? 'Throughout the year' : 'Yıl boyunca');

    return _WrappedCardBase(
      gradientColors: [
        AppColors.sunriseStart.withValues(alpha: 0.15),
        AppColors.sunriseEnd.withValues(alpha: 0.08),
        AppColors.deepSpace,
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          GradientText(
            isEn ? 'Most Intense Week' : 'En Yoğun Haftan',
            variant: GradientTextVariant.amethyst,
            style: AppTypography.elegantAccent(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 24),
          Icon(
            Icons.whatshot_rounded,
            color: AppColors.sunriseEnd,
            size: 56,
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms).scale(
            begin: const Offset(0.5, 0.5),
            end: const Offset(1, 1),
            delay: 200.ms,
            duration: 600.ms,
            curve: Curves.elasticOut,
          ),
          const SizedBox(height: 20),
          Text(
            weekStr,
            textAlign: TextAlign.center,
            style: AppTypography.displayFont.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
          const SizedBox(height: 12),
          Text(
            isEn
                ? 'This week had the widest range of emotions in your entries'
                : 'Bu hafta kayıtlarında en geniş duygu yelpazesi vardı',
            textAlign: TextAlign.center,
            style: AppTypography.decorativeScript(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ).animate().fadeIn(delay: 600.ms, duration: 500.ms),
          const Spacer(flex: 3),
        ],
      ),
    );
  }

  String _formatWeek(DateTime monday, bool isEn) {
    final months = isEn ? CommonStrings.monthsShortEn : CommonStrings.monthsShortTr;
    return '${months[monday.month - 1]} ${monday.day}';
  }
}

// ============================================================================
// CARD 4: FOCUS AREA MAP
// ============================================================================

class _FocusAreaCard extends StatelessWidget {
  final WrappedData data;
  final bool isEn;
  final bool isDark;

  const _FocusAreaCard({
    required this.data,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = data.focusAreaCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxVal = sorted.isNotEmpty ? sorted.first.value : 1;

    return _WrappedCardBase(
      gradientColors: [
        AppColors.auroraStart.withValues(alpha: 0.12),
        AppColors.auroraEnd.withValues(alpha: 0.06),
        AppColors.deepSpace,
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          GradientText(
            isEn ? 'Focus Area Map' : 'Odak Alanı Haritası',
            variant: GradientTextVariant.gold,
            style: AppTypography.elegantAccent(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 24),
          ...sorted.asMap().entries.map((entry) {
            final i = entry.key;
            final area = entry.value.key;
            final count = entry.value.value;
            final pct = maxVal > 0 ? count / maxVal : 0.0;
            final color = AppColors.focusAreaPalette[
                area.index % AppColors.focusAreaPalette.length];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      isEn ? area.displayNameEn : area.displayNameTr,
                      style: AppTypography.subtitle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: pct),
                      duration: Duration(milliseconds: 800 + i * 150),
                      curve: Curves.easeOutCubic,
                      builder: (context, val, _) {
                        return Container(
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: color.withValues(alpha: 0.1),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: val,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [
                                    color.withValues(alpha: 0.8),
                                    color,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 28,
                    child: Text(
                      '$count',
                      style: AppTypography.elegantAccent(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(
              delay: Duration(milliseconds: 300 + i * 100),
              duration: 400.ms,
            ).slideX(
              begin: -0.1,
              end: 0,
              delay: Duration(milliseconds: 300 + i * 100),
              duration: 400.ms,
            );
          }),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

// ============================================================================
// CARD 5: GROWTH SCORE
// ============================================================================

class _GrowthScoreCard extends StatelessWidget {
  final WrappedData data;
  final bool isEn;
  final bool isDark;

  const _GrowthScoreCard({
    required this.data,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return _WrappedCardBase(
      gradientColors: [
        AppColors.amethyst.withValues(alpha: 0.15),
        AppColors.auroraEnd.withValues(alpha: 0.08),
        AppColors.deepSpace,
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          GradientText(
            isEn ? 'Growth Score' : 'Gelişim Puanı',
            variant: GradientTextVariant.gold,
            style: AppTypography.elegantAccent(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 24),
          SizedBox(
            width: 160,
            height: 160,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: data.growthScore / 100.0),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeOutCubic,
              builder: (context, progress, _) {
                return CustomPaint(
                  painter: _GrowthArcPainter(progress: progress),
                  child: Center(
                    child: _AnimatedStat(
                      value: data.growthScore,
                      fontSize: 48,
                      color: AppColors.textPrimary,
                    ),
                  ),
                );
              },
            ),
          ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
          const SizedBox(height: 16),
          Text(
            _growthLabel(data.growthScore, isEn),
            textAlign: TextAlign.center,
            style: AppTypography.decorativeScript(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ).animate().fadeIn(delay: 600.ms, duration: 500.ms),
          const Spacer(flex: 3),
        ],
      ),
    );
  }

  String _growthLabel(int score, bool isEn) {
    if (score >= 70) {
      return isEn
          ? 'Remarkable growth this year'
          : 'Bu yıl kayda değer bir gelişim';
    } else if (score >= 50) {
      return isEn
          ? 'Steady and consistent progress'
          : 'İstikrarlı ve tutarlı bir ilerleme';
    }
    return isEn
        ? 'Every journey has its rhythm'
        : 'Her yolculuğun kendi ritmi vardır';
  }
}

// ============================================================================
// CARD 6: BREAKTHROUGH MOMENTS
// ============================================================================

class _BreakthroughCard extends StatelessWidget {
  final WrappedData data;
  final bool isEn;
  final bool isDark;

  const _BreakthroughCard({
    required this.data,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return _WrappedCardBase(
      gradientColors: [
        AppColors.success.withValues(alpha: 0.15),
        AppColors.starGold.withValues(alpha: 0.06),
        AppColors.deepSpace,
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          GradientText(
            isEn ? 'Breakthrough Moments' : 'Atılım Anları',
            variant: GradientTextVariant.amethyst,
            style: AppTypography.elegantAccent(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 32),
          _AnimatedStat(
            value: data.breakthroughCount,
            fontSize: 72,
            color: AppColors.starGold,
          ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
          const SizedBox(height: 8),
          Text(
            isEn ? 'breakthroughs' : 'atılım',
            style: AppTypography.elegantAccent(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              isEn
                  ? 'Moments where your mood lifted and a positive streak began'
                  : 'Ruh halin yükselip pozitif bir seri başladığı anlar',
              textAlign: TextAlign.center,
              style: AppTypography.decorativeScript(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ).animate().fadeIn(delay: 700.ms, duration: 500.ms),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

// ============================================================================
// CARD 7: TOP PATTERNS
// ============================================================================

class _TopPatternsCard extends StatelessWidget {
  final WrappedData data;
  final bool isEn;
  final bool isDark;

  const _TopPatternsCard({
    required this.data,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final patterns = data.topPatterns.take(3).toList();

    return _WrappedCardBase(
      gradientColors: [
        AppColors.celestialGold.withValues(alpha: 0.12),
        AppColors.starGold.withValues(alpha: 0.06),
        AppColors.deepSpace,
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          GradientText(
            isEn ? 'Your Top Patterns' : 'En Önemli Örüntülerin',
            variant: GradientTextVariant.gold,
            style: AppTypography.elegantAccent(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 28),
          if (patterns.isEmpty)
            Text(
              isEn
                  ? 'Keep journaling to discover patterns'
                  : 'Örüntüleri keşfetmek için yazmaya devam et',
              style: AppTypography.decorativeScript(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            )
          else
            ...patterns.asMap().entries.map((entry) {
              final i = entry.key;
              final label = _formatPattern(entry.value, isEn);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.starGold.withValues(alpha: 0.15),
                        border: Border.all(
                          color: AppColors.starGold.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${i + 1}',
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.starGold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        style: AppTypography.subtitle(
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(
                delay: Duration(milliseconds: 300 + i * 200),
                duration: 400.ms,
              ).slideX(
                begin: 0.1,
                end: 0,
                delay: Duration(milliseconds: 300 + i * 200),
                duration: 400.ms,
              );
            }),
          const Spacer(flex: 3),
        ],
      ),
    );
  }

  String _formatPattern(String raw, bool isEn) {
    // Parse pattern codes like "focus_dominant:energy:42"
    final parts = raw.split(':');
    if (parts.isEmpty) return raw;

    switch (parts[0]) {
      case 'focus_dominant':
        final area = parts.length > 1 ? parts[1] : '';
        final pct = parts.length > 2 ? parts[2] : '';
        return isEn
            ? '$pct% of entries focused on ${area.replaceAll('_', ' ')}'
            : 'Kayıtların %$pct\'si ${area.replaceAll('_', ' ')} odaklı';
      case 'best_month':
        final month = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
        final avg = parts.length > 2 ? parts[2] : '';
        final monthName = _monthName(month, isEn);
        return isEn
            ? 'Best month: $monthName (avg $avg)'
            : 'En iyi ay: $monthName (ort $avg)';
      case 'streak_30plus':
      case 'streak_14plus':
      case 'streak_7plus':
        final days = parts.length > 1 ? parts[1] : '';
        return isEn
            ? '$days-day journaling streak'
            : '$days günlük yazma serisi';
      case 'high_average':
        return isEn
            ? 'Consistently high mood average'
            : 'Tutarlı yüksek ruh hali ortalaması';
      case 'diverse_explorer':
        return isEn
            ? 'Explored multiple focus areas'
            : 'Birden fazla odak alanı keşfettin';
      case 'daily_journaler':
        return isEn ? 'Journaled every single day' : 'Her gün yazdın';
      case 'dedicated_journaler':
      case 'committed_journaler':
        final count = parts.length > 1 ? parts[1] : '';
        return isEn ? '$count entries this year' : 'Bu yıl $count kayıt';
      default:
        return raw;
    }
  }

  String _monthName(int month, bool isEn) {
    final en = ['', ...CommonStrings.monthsFullEn];
    final tr = ['', ...CommonStrings.monthsFullTr];
    if (month < 1 || month > 12) return '';
    return isEn ? en[month] : tr[month];
  }
}

// ============================================================================
// CARD 8: CLOSING CTA — "See You Next Year"
// ============================================================================

class _ClosingCard extends StatelessWidget {
  final WrappedData data;
  final bool isEn;
  final bool isDark;

  const _ClosingCard({
    required this.data,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return _WrappedCardBase(
      gradientColors: [
        AppColors.starGold.withValues(alpha: 0.18),
        AppColors.celestialGold.withValues(alpha: 0.1),
        AppColors.deepSpace,
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          GradientText(
            isEn ? 'See You Next Year' : 'Gelecek Yıl Görüşmek Üzere',
            variant: GradientTextVariant.cosmic,
            textAlign: TextAlign.center,
            style: AppTypography.displayFont.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ).animate().fadeIn(duration: 500.ms).slideY(
            begin: 0.2,
            end: 0,
            duration: 500.ms,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              isEn
                  ? 'Every entry you wrote brought you closer to yourself.'
                  : 'Yazdığın her kayıt seni kendine biraz daha yaklaştırdı.',
              textAlign: TextAlign.center,
              style: AppTypography.decorativeScript(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
          ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
          const Spacer(flex: 2),
          // Share button
          GradientButton.gold(
            label: isEn ? 'Share Your Wrapped' : 'Wrapped\'ını Paylaş',
            icon: Icons.share_rounded,
            onPressed: () {
              HapticFeedback.selectionClick();
              final moodStr = data.averageMood.toStringAsFixed(1);
              final shareText = isEn
                  ? 'My ${data.year} InnerCycles Wrapped\n\n'
                    '${data.totalEntries} journal entries across ${data.totalJournalingDays} days\n'
                    'Average mood: $moodStr/5\n'
                    'Growth score: ${data.growthScore}%\n'
                    'Best streak: ${data.streakBest} days\n'
                    '${data.breakthroughCount} breakthrough moments\n\n'
                    'Discover your inner patterns with InnerCycles.'
                  : '${data.year} InnerCycles Wrapped\'ım\n\n'
                    '${data.totalJournalingDays} günde ${data.totalEntries} günlük kaydı\n'
                    'Ortalama ruh hali: $moodStr/5\n'
                    'Gelişim puanı: ${data.growthScore}%\n'
                    'En iyi seri: ${data.streakBest} gün\n'
                    '${data.breakthroughCount} atılım anı\n\n'
                    'InnerCycles ile iç örüntülerini keşfet.';
              SharePlus.instance.share(ShareParams(text: shareText));
            },
            expanded: true,
          ).animate().fadeIn(delay: 600.ms, duration: 500.ms).slideY(
            begin: 0.3,
            end: 0,
            delay: 600.ms,
            duration: 500.ms,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

// ============================================================================
// PREMIUM GATE CARD
// ============================================================================

class _PremiumGateCard extends StatelessWidget {
  final bool isEn;
  final bool isDark;

  const _PremiumGateCard({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return _WrappedCardBase(
      gradientColors: [
        AppColors.starGold.withValues(alpha: 0.08),
        AppColors.deepSpace.withValues(alpha: 0.9),
        AppColors.deepSpace,
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          Icon(
            Icons.lock_rounded,
            color: AppColors.starGold.withValues(alpha: 0.6),
            size: 48,
          ),
          const SizedBox(height: 20),
          GradientText(
            isEn ? 'Unlock Your Full Wrapped' : 'Tam Wrapped\'ını Aç',
            variant: GradientTextVariant.gold,
            textAlign: TextAlign.center,
            style: AppTypography.displayFont.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isEn
                ? '5 more cards with deeper insights await you'
                : '5 derin içgörü kartı seni bekliyor',
            textAlign: TextAlign.center,
            style: AppTypography.decorativeScript(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

// ============================================================================
// HELPERS
// ============================================================================

class _MiniStatColumn extends StatelessWidget {
  final String value;
  final String label;

  const _MiniStatColumn({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.displayFont.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w200,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.elegantAccent(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class _MoodJourneyBars extends StatelessWidget {
  final List<double> values;
  final List<Color> arcColors;

  const _MoodJourneyBars({required this.values, required this.arcColors});

  @override
  Widget build(BuildContext context) {
    final maxVal = values.where((v) => v > 0).fold(5.0, math.max);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      builder: (context, progress, _) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(12, (i) {
            final v = i < values.length ? values[i] : 0.0;
            final norm = maxVal > 0 ? v / maxVal : 0.0;
            final barProgress = (progress - i * 0.04).clamp(0.0, 1.0);
            final height = v > 0 ? 10.0 + norm * 40 * barProgress : 4.0;
            final color = arcColors.isNotEmpty
                ? arcColors[i % arcColors.length]
                : AppColors.auroraStart;

            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1),
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: v > 0
                      ? color.withValues(alpha: 0.6 + norm * 0.4)
                      : AppColors.textMuted.withValues(alpha: 0.15),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _GrowthArcPainter extends CustomPainter {
  final double progress;

  _GrowthArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;

    // Background track
    final trackPaint = Paint()
      ..color = AppColors.textMuted.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    final sweepAngle = 2 * math.pi * progress;
    final arcRect = Rect.fromCircle(center: center, radius: radius);
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [
          AppColors.amethyst,
          AppColors.auroraEnd,
          AppColors.starGold,
        ],
        transform: const GradientRotation(-math.pi / 2),
      ).createShader(arcRect);

    canvas.drawArc(arcRect, -math.pi / 2, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _GrowthArcPainter old) =>
      old.progress != progress;
}
