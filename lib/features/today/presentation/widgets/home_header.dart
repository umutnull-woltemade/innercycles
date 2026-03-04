import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/common_strings.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/services/content_rotation_service.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/tap_scale.dart';
import '../../../bond/presentation/widgets/bond_mood_orb.dart';
import 'package:go_router/go_router.dart';
import '../../../../data/services/l10n_service.dart';
import '../../../../data/providers/app_providers.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final AppLanguage language;
  final bool isDark;
  final int? yesterdayMoodScore;
  final String? partnerSignalId;
  final bool hasBond;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.language,
    required this.isDark,
    this.yesterdayMoodScore,
    this.partnerSignalId,
    this.hasBond = false,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return L10nService.get('today.home_header.good_morning', language);
    if (hour < 18) return L10nService.get('today.home_header.good_afternoon', language);
    return L10nService.get('today.home_header.good_evening', language);
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final dayKeys = ['common.date.day_mon', 'common.date.day_tue', 'common.date.day_wed', 'common.date.day_thu', 'common.date.day_fri', 'common.date.day_sat', 'common.date.day_sun'];
    final dayName = L10nService.get(dayKeys[now.weekday - 1], language);
    final months = CommonStrings.monthsShort(language);
    final monthName = months[now.month - 1];
    return L10nService.getWithParams('common.date.format_en', language, params: {'day': dayName, 'month': monthName, 'date': '${now.day}'});
  }

  String _getInitials() {
    if (userName.isEmpty) return '';
    final parts = userName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return userName[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isEn = language == AppLanguage.en;
    final greeting = _getGreeting();
    final dateStr = _getFormattedDate();
    final insight = ContentRotationService.getDailyInsight();

    // Mood-aware subtitle: reference yesterday's emotional state
    // Falls back to time-aware contextual message, then daily insight
    String? moodSubtitle;
    if (yesterdayMoodScore != null) {
      if (yesterdayMoodScore! <= 2) {
        moodSubtitle = isEn
            ? 'A fresh start awaits you today.'
            : 'Bugün seni taze bir başlangıç bekliyor.';
      } else if (yesterdayMoodScore! >= 4) {
        moodSubtitle = isEn
            ? 'Carry that great energy forward.'
            : 'O güzel enerjiyi bugüne taşı.';
      }
    }

    // Time-aware contextual nudge when no mood data
    if (moodSubtitle == null) {
      final hour = DateTime.now().hour;
      if (hour >= 5 && hour < 10) {
        moodSubtitle = isEn
            ? 'A morning reflection sets your intention.'
            : 'Sabah yansıması niyetini belirler.';
      } else if (hour >= 21 || hour < 5) {
        moodSubtitle = isEn
            ? 'A quiet moment before rest.'
            : 'Dinlenmeden önce sessiz bir an.';
      }
      // Afternoon/evening: falls through to daily insight
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateStr.toUpperCase(),
                      style: AppTypography.elegantAccent(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                        color: isDark
                            ? AppColors.starGold.withValues(alpha: 0.6)
                            : AppColors.lightStarGold.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userName.isNotEmpty ? '$greeting,' : greeting,
                      style: AppTypography.decorativeScript(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    if (userName.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: GradientText(
                              userName,
                              variant: GradientTextVariant.gold,
                              style: GoogleFonts.sacramento(
                                fontSize: 44,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1.5,
                                height: 1.0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (hasBond) ...[
                            const SizedBox(width: 8),
                            BondMoodOrb(signalId: partnerSignalId, size: 20),
                          ],
                        ],
                      )
                          .animate()
                          .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                          .slideX(
                            begin: -0.08,
                            end: 0,
                            duration: 700.ms,
                            curve: Curves.easeOutCubic,
                          )
                          .scale(
                            begin: const Offset(0.95, 0.95),
                            end: const Offset(1.0, 1.0),
                            duration: 700.ms,
                            curve: Curves.easeOutCubic,
                          )
                          .then(delay: 600.ms)
                          .shimmer(
                            duration: 2500.ms,
                            color: AppColors.starGold.withValues(alpha: 0.2),
                          ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      moodSubtitle ?? (isEn ? insight.en : insight.tr),
                      style: AppTypography.decorativeScript(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Search icon
              Semantics(
                label: L10nService.get('today.home_header.search', language),
                button: true,
                child: TapScale(
                  onTap: () {
                    HapticService.buttonPress();
                    context.push(Routes.search);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (isDark
                              ? AppColors.starGold
                              : AppColors.lightStarGold)
                          .withValues(alpha: 0.08),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.search_rounded,
                        size: 20,
                        color: isDark
                            ? AppColors.starGold
                            : AppColors.lightStarGold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Avatar circle -> Settings
              Semantics(
                label: L10nService.get('today.home_header.profile_settings', language),
                button: true,
                child: TapScale(
                  onTap: () {
                    HapticService.buttonPress();
                    context.push(Routes.settings);
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          (isDark
                                  ? AppColors.starGold
                                  : AppColors.lightStarGold)
                              .withValues(alpha: 0.15),
                          (isDark
                                  ? AppColors.starGold
                                  : AppColors.lightStarGold)
                              .withValues(alpha: 0.05),
                        ],
                      ),
                      border: Border.all(
                        color:
                            (isDark
                                    ? AppColors.starGold
                                    : AppColors.lightStarGold)
                                .withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.starGold.withValues(
                            alpha: isDark ? 0.15 : 0.08,
                          ),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: userName.isNotEmpty
                          ? Text(
                              _getInitials(),
                              style: AppTypography.displayFont.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.starGold
                                    : AppColors.lightStarGold,
                              ),
                            )
                          : Icon(
                              Icons.person_outline_rounded,
                              size: 22,
                              color: isDark
                                  ? AppColors.starGold
                                  : AppColors.lightStarGold,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Subtle gold divider
          Container(
            height: 0.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  (isDark ? AppColors.starGold : AppColors.lightStarGold)
                      .withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
