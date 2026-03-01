import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/common_strings.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/app_symbol.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/tap_scale.dart';
import '../../../../data/services/introductory_offer_service.dart';
import '../../../../data/services/l10n_service.dart';

class PromotionalBannerStack extends ConsumerStatefulWidget {
  final bool isEn;
  final bool isDark;

  const PromotionalBannerStack({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  ConsumerState<PromotionalBannerStack> createState() =>
      _PromotionalBannerStackState();
}

class _PromotionalBannerStackState
    extends ConsumerState<PromotionalBannerStack> {
  static const _dismissKey = 'invite_card_dismissed_at';
  static const _cooldownDays = 14;
  bool _inviteDismissed = false;

  bool get isEn => widget.isEn;
  bool get isDark => widget.isDark;

  Future<bool> _recentlyDismissed() async {
    final prefs = await SharedPreferences.getInstance();
    final dismissedAt = prefs.getInt(_dismissKey);
    if (dismissedAt == null) return false;
    final diff = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(dismissedAt))
        .inDays;
    return diff < _cooldownDays;
  }

  Future<void> _dismissInvite() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dismissKey, DateTime.now().millisecondsSinceEpoch);
    if (mounted) setState(() => _inviteDismissed = true);
  }

  @override
  Widget build(BuildContext context) {
    final banners = <Widget>[];

    // 0. Introductory Offer (72hr countdown — highest priority)
    final introWidget = _buildIntroOffer();
    if (introWidget != null) banners.add(introWidget);

    // 1. Upcoming Reminders
    final remindersWidget = _buildReminders();
    if (remindersWidget != null) banners.add(remindersWidget);

    // 2. Retrospective
    final retroWidget = _buildRetrospective();
    if (retroWidget != null) banners.add(retroWidget);

    // 3. Wrapped
    final wrappedWidget = _buildWrapped(context);
    if (wrappedWidget != null) banners.add(wrappedWidget);

    // 4. Monthly Wrapped
    final monthlyWidget = _buildMonthlyWrapped(context);
    if (monthlyWidget != null) banners.add(monthlyWidget);

    // 5. Weekly Share
    final weeklyWidget = _buildWeeklyShare();
    if (weeklyWidget != null) banners.add(weeklyWidget);

    // 6. Invite Friends (referral-powered)
    final inviteWidget = _buildInviteFriends();
    if (inviteWidget != null) banners.add(inviteWidget);

    if (banners.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          for (int i = 0; i < banners.length; i++) ...[
            banners[i].glassListItem(context: context, index: i),
            if (i < banners.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  // ── INTRODUCTORY OFFER (72hr countdown) ──
  Widget? _buildIntroOffer() {
    final offerAsync = ref.watch(introductoryOfferProvider);
    return offerAsync.whenOrNull(
      data: (service) {
        final language = AppLanguage.fromIsEn(isEn);
        if (!service.isOfferActive) return null;

        final parts = service.countdownParts;

        return Semantics(
          button: true,
          label: L10nService.get('today.promotional_stack.limited_time_offer', language),
          child: TapScale(
            onTap: () {
              HapticService.buttonPress();
              context.push(Routes.premium);
            },
            child: PremiumCard(
              style: PremiumCardStyle.gold,
              showInnerShadow: false,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const AppSymbol.inline('\u{1F525}'),
                      const SizedBox(width: 6),
                      Expanded(
                        child: GradientText(
                          L10nService.get('today.promotional_stack.50_off_new_user_offer', language),
                          variant: GradientTextVariant.gold,
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const SizedBox(width: 26),
                      _CountdownDigit(parts.hours),
                      _CountdownSep(),
                      _CountdownDigit(parts.minutes),
                      _CountdownSep(),
                      _CountdownDigit(parts.seconds),
                      const Spacer(),
                      GradientButton.gold(
                        label: L10nService.get('today.promotional_stack.claim', language),
                        onPressed: () => context.push(Routes.premium),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── UPCOMING REMINDERS ──
  Widget? _buildReminders() {
    final remindersAsync = ref.watch(upcomingRemindersProvider);
    final notesServiceAsync = ref.watch(notesToSelfServiceProvider);

    return remindersAsync.whenOrNull(
      data: (reminders) {
        final language = AppLanguage.fromIsEn(isEn);
        if (reminders.isEmpty) return null;

        return notesServiceAsync.whenOrNull(
          data: (service) {
            final upcoming = reminders.take(2).toList();

            return Semantics(
              button: true,
              label: L10nService.get('today.promotional_stack.view_upcoming_reminders', language),
              child: TapScale(
                onTap: () => context.push(Routes.notesList),
                child: PremiumCard(
                  style: PremiumCardStyle.gold,
                  showInnerShadow: false,
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const AppSymbol.inline('\uD83D\uDD14'),
                          const SizedBox(width: 6),
                          Flexible(
                            child: GradientText(
                              L10nService.get('today.promotional_stack.upcoming_reminders', language),
                              variant: GradientTextVariant.gold,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.displayFont.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            L10nService.get('today.promotional_stack.see_all', language),
                            style: AppTypography.elegantAccent(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.starGold
                                  : AppColors.lightStarGold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...upcoming.map((r) {
                        final language = AppLanguage.fromIsEn(isEn);
                        final note = service.getNote(r.noteId);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 14,
                                color: isDark
                                    ? Colors.white38
                                    : Colors.black38,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  note?.title ?? (L10nService.get('today.promotional_stack.note', language)),
                                  style: AppTypography.subtitle(
                                    fontSize: 14,
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.8)
                                        : Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatTimeLeft(r.scheduledAt),
                                style: AppTypography.elegantAccent(
                                  fontSize: 13,
                                  color: isDark
                                      ? Colors.white38
                                      : Colors.black38,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── RETROSPECTIVE ──
  Widget? _buildRetrospective() {
    final language = AppLanguage.fromIsEn(isEn);
    final journalAsync = ref.watch(journalServiceProvider);
    final retroAsync = ref.watch(retrospectiveDateServiceProvider);

    final shouldShow =
        journalAsync.whenOrNull(
          data: (service) {
            final entryCount = service.getAllEntries().length;
            final hasRetro =
                retroAsync.whenOrNull(data: (retro) => retro.hasAnyDates) ??
                false;
            return entryCount < 5 || !hasRetro;
          },
        ) ??
        false;

    if (!shouldShow) return null;

    return Semantics(
      button: true,
      label: L10nService.get('today.promotional_stack.add_retrospective_entries', language),
      child: TapScale(
        onTap: () {
          HapticService.buttonPress();
          context.push(Routes.retrospective);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.auroraStart.withValues(alpha: 0.08)
                : AppColors.auroraStart.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const AppSymbol.card('\uD83D\uDCDA'),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      L10nService.get('today.promotional_stack.add_entries_for_your_most_meaningful_day', language),
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      L10nService.get('today.promotional_stack.your_story_didnt_start_today', language),
                      style: AppTypography.elegantAccent(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── WRAPPED (Dec 26 - Jan 7) ──
  Widget? _buildWrapped(BuildContext context) {
    final language = AppLanguage.fromIsEn(isEn);
    final now = DateTime.now();
    final isWrappedSeason =
        (now.month == 12 && now.day >= 26) ||
        (now.month == 1 && now.day <= 7);
    if (!isWrappedSeason) return null;

    return Semantics(
      button: true,
      label: L10nService.get('today.promotional_stack.view_year_wrapped', language),
      child: TapScale(
        onTap: () {
          HapticService.buttonPress();
          context.push(Routes.wrapped);
        },
        child: PremiumCard(
          style: PremiumCardStyle.gold,
          showInnerShadow: false,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const AppSymbol.card('\u2728'),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GradientText(
                      isEn
                          ? 'Your ${DateTime.now().year} Wrapped is ready!'
                          : '${DateTime.now().year} Wrapped\'ın hazır!',
                      variant: GradientTextVariant.cosmic,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      L10nService.get('today.promotional_stack.see_your_year_in_patterns', language),
                      style: AppTypography.elegantAccent(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: isDark ? AppColors.starGold : AppColors.lightStarGold,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── MONTHLY WRAPPED (first 10 days of month) ──
  Widget? _buildMonthlyWrapped(BuildContext context) {
    final language = AppLanguage.fromIsEn(isEn);
    final now = DateTime.now();
    if (now.day > 10) return null;
    if ((now.month == 1 && now.day <= 7) ||
        (now.month == 12 && now.day >= 26)) {
      return null;
    }

    final lastMonth = now.month == 1 ? 12 : now.month - 1;
    final monthNames = isEn
        ? ['', ...CommonStrings.monthsFullEn]
        : ['', ...CommonStrings.monthsFullTr];

    return Semantics(
      button: true,
      label: L10nService.get('today.promotional_stack.view_monthly_wrapped', language),
      child: TapScale(
        onTap: () {
          HapticService.buttonPress();
          context.push(Routes.monthlyWrapped);
        },
        child: PremiumCard(
          style: PremiumCardStyle.amethyst,
          showInnerShadow: false,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const AppSymbol.card('\u{1F4CA}'),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GradientText(
                      isEn
                          ? 'Your ${monthNames[lastMonth]} Wrapped'
                          : '${monthNames[lastMonth]} Özetin Hazır',
                      variant: GradientTextVariant.amethyst,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      L10nService.get('today.promotional_stack.see_your_month_at_a_glance_share_it', language),
                      style: AppTypography.elegantAccent(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Quick share button
              GestureDetector(
                onTap: () {
                  HapticService.buttonPress();
                  final shareText = isEn
                      ? 'My ${monthNames[lastMonth]} wrapped is here!\n\n'
                        'See your month in patterns with InnerCycles.\n'
                        '#InnerCycles #MonthlyWrapped #Journaling'
                      : '${monthNames[lastMonth]} özetim hazır!\n\n'
                        'InnerCycles ile ayını örüntülerle gör.\n'
                        '#InnerCycles #AylıkÖzet #Günlük';
                  SharePlus.instance.share(ShareParams(text: shareText));
                },
                child: Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.amethyst.withValues(alpha: 0.12),
                  ),
                  child: const Icon(
                    Icons.share_rounded,
                    size: 16,
                    color: AppColors.amethyst,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.amethyst,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── WEEKLY SHARE (Sundays only) ──
  Widget? _buildWeeklyShare() {
    final language = AppLanguage.fromIsEn(isEn);
    if (DateTime.now().weekday != DateTime.sunday) return null;

    final journalAsync = ref.watch(journalServiceProvider);
    final hasEntries =
        journalAsync.whenOrNull(
          data: (service) => service.getAllEntries().length >= 3,
        ) ??
        false;

    if (!hasEntries) return null;

    return Semantics(
      button: true,
      label: L10nService.get('today.promotional_stack.share_weekly_insights', language),
      child: TapScale(
        onTap: () {
          HapticService.buttonPress();
          context.push(Routes.shareCardGallery);
        },
        child: PremiumCard(
          style: PremiumCardStyle.aurora,
          showInnerShadow: false,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: isDark
                    ? AppColors.auroraStart
                    : AppColors.lightAuroraStart,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GradientText(
                      L10nService.get('today.promotional_stack.your_latest_pattern_card_is_ready', language),
                      variant: GradientTextVariant.aurora,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      L10nService.get('today.promotional_stack.share_your_weeks_insights', language),
                      style: AppTypography.elegantAccent(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── INVITE FRIENDS ──
  Widget? _buildInviteFriends() {
    final language = AppLanguage.fromIsEn(isEn);
    if (_inviteDismissed) return null;

    final journalAsync = ref.watch(journalServiceProvider);
    final entryCount =
        journalAsync.whenOrNull(data: (s) => s.getAllEntries().length) ?? 0;

    if (entryCount < 5) return null;

    return FutureBuilder<bool>(
      future: _recentlyDismissed(),
      builder: (context, snap) {
        if (snap.data == true) return const SizedBox.shrink();

        return PremiumCard(
          style: PremiumCardStyle.gold,
          showInnerShadow: false,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.favorite_rounded,
                    color: AppColors.starGold,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GradientText(
                      L10nService.get('today.promotional_stack.enjoying_innercycles', language),
                      variant: GradientTextVariant.gold,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _dismissInvite,
                    child: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Text(
                  L10nService.get('today.promotional_stack.share_it_with_a_friend_who_would_love_it', language),
                  style: AppTypography.elegantAccent(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: GradientButton.gold(
                  label: L10nService.get('today.promotional_stack.invite_earn_premium', language),
                  icon: Icons.card_giftcard_rounded,
                  onPressed: () {
                    HapticService.buttonPress();
                    context.push(Routes.referralProgram);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTimeLeft(DateTime dt) {
    final language = AppLanguage.fromIsEn(isEn);
    final now = DateTime.now();
    final diff = dt.difference(now);
    if (diff.isNegative) return L10nService.get('today.promotional_stack.now', language);
    if (diff.inMinutes < 60) {
      return L10nService.getWithParams('common.time.in_minutes', language, params: {'count': '${diff.inMinutes}'});
    }
    if (diff.inHours < 24) {
      return L10nService.getWithParams('common.time.in_hours', language, params: {'count': '${diff.inHours}'});
    }
    return L10nService.getWithParams('common.time.in_days', language, params: {'count': '${diff.inDays}'});
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// COUNTDOWN WIDGETS
// ════════════════════════════════════════════════════════════════════════════════

class _CountdownDigit extends StatelessWidget {
  final String value;
  const _CountdownDigit(this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.starGold.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        value,
        style: AppTypography.displayFont.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.starGold,
        ),
      ),
    );
  }
}

class _CountdownSep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        ':',
        style: AppTypography.displayFont.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.starGold.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
