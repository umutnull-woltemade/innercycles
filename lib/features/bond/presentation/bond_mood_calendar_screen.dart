// ════════════════════════════════════════════════════════════════════════════
// BOND MOOD CALENDAR SCREEN - Side-by-side mood calendars (user vs partner)
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/bond.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/providers/bond_providers.dart';
import '../../../data/services/haptic_service.dart';
import '../../../data/services/mood_checkin_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../mood/presentation/widgets/signal_calendar.dart';

class BondMoodCalendarScreen extends ConsumerStatefulWidget {
  final String bondId;

  const BondMoodCalendarScreen({
    super.key,
    required this.bondId,
  });

  @override
  ConsumerState<BondMoodCalendarScreen> createState() =>
      _BondMoodCalendarScreenState();
}

class _BondMoodCalendarScreenState
    extends ConsumerState<BondMoodCalendarScreen> {
  String get _currentUserId =>
      Supabase.instance.client.auth.currentUser?.id ?? '';

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bondsAsync = ref.watch(activeBondsProvider);

    return Scaffold(
      body: CosmicBackground(
        child: bondsAsync.when(
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (_, __) => Center(
            child: Text(
              isEn ? 'Could not load bond' : 'Bag yuklenemedi',
              style: AppTypography.subtitle(
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
          data: (bonds) {
            final bond =
                bonds.where((b) => b.id == widget.bondId).firstOrNull;
            if (bond == null) {
              return Center(
                child: Text(
                  isEn ? 'Bond not found' : 'Bag bulunamadi',
                  style: AppTypography.subtitle(
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              );
            }
            return _buildContent(bond, isDark, isEn, language);
          },
        ),
      ),
    );
  }

  Widget _buildContent(
      Bond bond, bool isDark, bool isEn, AppLanguage language) {
    final partnerName = bond.partnerDisplayName(_currentUserId) ??
        (isEn ? 'Partner' : 'Partner');
    final moodServiceAsync = ref.watch(moodCheckinServiceProvider);

    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(
            title: isEn ? 'Mood Calendar' : 'Ruh Hali Takvimi',
            useGradientTitle: true,
            gradientVariant: GradientTextVariant.aurora,
          ),

          // ─── Header ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Text(
                isEn
                    ? 'See how your moods align with $partnerName.'
                    : '$partnerName ile ruh hallerinizin nasil uyustugunu gorun.',
                style: AppTypography.subtitle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, curve: Curves.easeOut),
            ),
          ),

          // ─── Your Calendar ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: _buildUserCalendar(
                isDark,
                isEn,
                language,
                moodServiceAsync,
              )
                  .animate(delay: 100.ms)
                  .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                  .slideY(
                      begin: 0.05,
                      end: 0,
                      duration: 500.ms,
                      curve: Curves.easeOut),
            ),
          ),

          // ─── Partner Calendar ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: _buildPartnerCalendar(
                partnerName,
                isDark,
                isEn,
                language,
              )
                  .animate(delay: 250.ms)
                  .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                  .slideY(
                      begin: 0.05,
                      end: 0,
                      duration: 500.ms,
                      curve: Curves.easeOut),
            ),
          ),

          // ─── Legend ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: _buildLegend(isDark, isEn)
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 400.ms, curve: Curves.easeOut),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // YOUR CALENDAR
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildUserCalendar(
    bool isDark,
    bool isEn,
    AppLanguage language,
    AsyncValue<MoodCheckinService> moodServiceAsync,
  ) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section label
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.starGold,
                ),
              ),
              const SizedBox(width: 8),
              GradientText(
                isEn ? 'Your Moods' : 'Senin Ruh Hallerin',
                variant: GradientTextVariant.gold,
                style: AppTypography.displayFont.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Calendar
          moodServiceAsync.when(
            loading: () => const SizedBox(
              height: 200,
              child: Center(child: CupertinoActivityIndicator()),
            ),
            error: (_, __) => SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  isEn ? 'Could not load mood data' : 'Ruh hali verileri yuklenemedi',
                  style: AppTypography.subtitle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ),
            ),
            data: (moodService) {
              final entries = moodService.getAllEntries();
              return SignalCalendar(
                entries: entries,
                language: language,
                isDark: isDark,
              );
            },
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PARTNER CALENDAR (PLACEHOLDER — Phase 2)
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPartnerCalendar(
    String partnerName,
    bool isDark,
    bool isEn,
    AppLanguage language,
  ) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section label
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.amethyst,
                ),
              ),
              const SizedBox(width: 8),
              GradientText(
                isEn
                    ? '$partnerName\'s Moods'
                    : '$partnerName\'in Ruh Halleri',
                variant: GradientTextVariant.amethyst,
                style: AppTypography.displayFont.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Phase 2 placeholder
          SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColors.amethyst.withValues(alpha: 0.1)
                          : AppColors.amethyst.withValues(alpha: 0.07),
                    ),
                    child: Icon(
                      CupertinoIcons.lock_fill,
                      size: 20,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isEn
                        ? 'Partner mood calendar coming soon'
                        : 'Partner ruh hali takvimi yakinda',
                    style: AppTypography.subtitle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isEn
                        ? 'This feature will show your partner\'s mood history when they share it with you.'
                        : 'Bu ozellik, partnerinizin sizinle paylastigi ruh hali gecmisini gosterecek.',
                    style: AppTypography.subtitle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textMuted.withValues(alpha: 0.7)
                          : AppColors.lightTextMuted.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LEGEND
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildLegend(bool isDark, bool isEn) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendDot(
          color: AppColors.starGold,
          label: isEn ? 'You' : 'Sen',
          isDark: isDark,
        ),
        const SizedBox(width: 24),
        _LegendDot(
          color: AppColors.amethyst,
          label: isEn ? 'Partner' : 'Partner',
          isDark: isDark,
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// LEGEND DOT
// ═══════════════════════════════════════════════════════════════════════════

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final bool isDark;

  const _LegendDot({
    required this.color,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.subtitle(
            fontSize: 13,
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}
