import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../data/providers/app_providers.dart';
import '../../data/services/l10n_service.dart';
import '../../data/services/moon_service.dart';

/// Personalized "Your Day" summary card for home dashboard
/// Creates daily anchor for retention - competitive advantage vs Co-Star
class TodayOverviewCard extends StatelessWidget {
  final String userName;
  final String sunSign;
  final String? moonSign;
  final String? risingSign;
  final VoidCallback? onTap;
  final VoidCallback? onTransitsTap;
  final VoidCallback? onDreamTap;
  final AppLanguage language;

  const TodayOverviewCard({
    super.key,
    required this.userName,
    required this.sunSign,
    this.moonSign,
    this.risingSign,
    this.onTap,
    this.onTransitsTap,
    this.onDreamTap,
    this.language = AppLanguage.en,
  });

  String t(String key) => L10nService.get(key, language);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final moonPhase = MoonService.getCurrentPhase();
    final moonInSign = MoonService.getCurrentMoonSign(DateTime.now());
    final greeting = _getTimeBasedGreeting();
    final todayEnergy = _getTodayEnergy(moonPhase.name);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1A1A2E),
                    const Color(0xFF16213E),
                    const Color(0xFF0F0F1A),
                  ]
                : [
                    Colors.white,
                    const Color(0xFFF8F9FC),
                    const Color(0xFFF0F2F8),
                  ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? AppColors.starGold.withValues(alpha: 0.3)
                : AppColors.lightStarGold.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.starGold.withValues(alpha: isDark ? 0.15 : 0.1),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Greeting + Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Today's Energy Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        todayEnergy.color.withValues(alpha: 0.3),
                        todayEnergy.color.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: todayEnergy.color.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        todayEnergy.emoji,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        todayEnergy.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: todayEnergy.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Moon Phase + Current Transit
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Moon Phase Visual
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.moonSilver,
                          AppColors.moonSilver.withValues(alpha: 0.3),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.moonSilver.withValues(alpha: 0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        moonPhase.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t(
                            'widgets.today_overview_card.moon_in_sign',
                          ).replaceAll('{sign}', moonInSign.toString()),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          moonPhase.nameTr,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getMoonMessage(moonPhase.name, moonInSign.nameTr),
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Quick Action Cards
            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.auto_awesome,
                    label: t('widgets.today_overview_card.todays_transits'),
                    color: AppColors.auroraStart,
                    onTap: onTransitsTap,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.nightlight_round,
                    label: t('widgets.today_overview_card.save_dream'),
                    color: AppColors.mystic,
                    onTap: onDreamTap,
                    showBadge: true,
                    badgeText: t('widgets.today_overview_card.new_badge'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Today's Focus (Personalized)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.starGold.withValues(alpha: 0.15),
                    AppColors.starGold.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.starGold.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 18,
                        color: AppColors.starGold,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        t('widgets.today_overview_card.todays_focus'),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.starGold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _getDailyFocus(sunSign, moonInSign.nameTr),
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Bottom CTA
            Center(
              child: Text(
                t('widgets.today_overview_card.tap_for_details'),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, duration: 400.ms);
  }

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) return t('widgets.today_overview_card.greetings.midnight');
    if (hour < 12)
      return t('widgets.today_overview_card.greetings.good_morning');
    if (hour < 17) return t('widgets.today_overview_card.greetings.good_day');
    if (hour < 21)
      return t('widgets.today_overview_card.greetings.good_evening');
    return t('widgets.today_overview_card.greetings.good_night');
  }

  _TodayEnergy _getTodayEnergy(String moonPhase) {
    switch (moonPhase.toLowerCase()) {
      case 'new moon':
        return _TodayEnergy(
          t('widgets.today_overview_card.energy.new_beginnings'),
          AppColors.mysticBlue,
          'seed',
        );
      case 'waxing crescent':
        return _TodayEnergy(
          t('widgets.today_overview_card.energy.growth_energy'),
          AppColors.success,
          'sprout',
        );
      case 'first quarter':
        return _TodayEnergy(
          t('widgets.today_overview_card.energy.action_time'),
          AppColors.fireElement,
          'fire',
        );
      case 'waxing gibbous':
        return _TodayEnergy(
          t('widgets.today_overview_card.energy.development_day'),
          AppColors.auroraStart,
          'star',
        );
      case 'full moon':
        return _TodayEnergy(
          t('widgets.today_overview_card.energy.full_moon_power'),
          AppColors.starGold,
          'moon',
        );
      case 'waning gibbous':
        return _TodayEnergy(
          t('widgets.today_overview_card.energy.gratitude_time'),
          AppColors.venusColor,
          'heart',
        );
      case 'last quarter':
        return _TodayEnergy(
          t('widgets.today_overview_card.energy.letting_go'),
          AppColors.waterElement,
          'water',
        );
      case 'waning crescent':
        return _TodayEnergy(
          t('widgets.today_overview_card.energy.rest_period'),
          AppColors.moonSilver,
          'rest',
        );
      default:
        return _TodayEnergy(
          t('widgets.today_overview_card.energy.cosmic_energy'),
          AppColors.cosmic,
          'sparkle',
        );
    }
  }

  String _getMoonMessage(String phase, String sign) {
    // Map Turkish sign names to English keys
    final signKeyMap = {
      'Koc': 'aries',
      'Boga': 'taurus',
      'Ikizler': 'gemini',
      'Yengec': 'cancer',
      'Aslan': 'leo',
      'Basak': 'virgo',
      'Terazi': 'libra',
      'Akrep': 'scorpio',
      'Yay': 'sagittarius',
      'Oglak': 'capricorn',
      'Kova': 'aquarius',
      'Balik': 'pisces',
    };
    final signKey = signKeyMap[sign] ?? 'default';
    return t('widgets.today_overview_card.moon_messages.$signKey');
  }

  String _getDailyFocus(String sunSign, String moonSign) {
    // Simplified personalized focus based on sun sign and current moon
    final signKey = sunSign.toLowerCase();
    final validSigns = [
      'aries',
      'taurus',
      'gemini',
      'cancer',
      'leo',
      'virgo',
      'libra',
      'scorpio',
      'sagittarius',
      'capricorn',
      'aquarius',
      'pisces',
    ];
    final key = validSigns.contains(signKey) ? signKey : 'default';
    return t('widgets.today_overview_card.daily_focus.$key');
  }
}

class _TodayEnergy {
  final String label;
  final Color color;
  final String emoji;

  _TodayEnergy(this.label, this.color, String type) : emoji = _getEmoji(type);

  static String _getEmoji(String type) {
    switch (type) {
      case 'seed':
        return '🌱';
      case 'sprout':
        return '🌿';
      case 'fire':
        return '🔥';
      case 'star':
        return '⭐';
      case 'moon':
        return '🌕';
      case 'heart':
        return '💜';
      case 'water':
        return '💧';
      case 'rest':
        return '🌙';
      default:
        return '✨';
    }
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool showBadge;
  final String? badgeText;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
    this.showBadge = false,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.15 : 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                      height: 1.3,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: color.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
          if (showBadge && badgeText != null)
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badgeText!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
