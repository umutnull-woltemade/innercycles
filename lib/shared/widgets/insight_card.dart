import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../data/services/l10n_service.dart';
import '../../data/providers/app_providers.dart';

/// Swipeable insight card for TikTok-style micro-engagement
/// Increases session time through snackable content consumption
class InsightCard extends StatelessWidget {
  final String title;
  final String content;
  final String? emoji;
  final String? deepLink;
  final bool isPremium;
  final Color? accentColor;
  final VoidCallback? onTap;
  final VoidCallback? onLockTap;
  final AppLanguage language;

  const InsightCard({
    super.key,
    required this.title,
    required this.content,
    this.emoji,
    this.deepLink,
    this.isPremium = false,
    this.accentColor,
    this.onTap,
    this.onLockTap,
    this.language = AppLanguage.en,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = accentColor ?? AppColors.auroraStart;

    return GestureDetector(
      onTap: isPremium ? onLockTap : onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsetsDirectional.only(end: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    color.withValues(alpha: 0.2),
                    color.withValues(alpha: 0.05),
                    AppColors.surfaceDark,
                  ]
                : [
                    color.withValues(alpha: 0.15),
                    color.withValues(alpha: 0.05),
                    Colors.white,
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with emoji and title
                Row(
                  children: [
                    if (emoji != null) ...[
                      Text(
                        emoji!,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: color,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    if (isPremium)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.starGold.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.starGold.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lock,
                              size: 12,
                              color: AppColors.starGold,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'PRO',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.starGold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),

                // Content
                Text(
                  isPremium ? _blurText(content) : content,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 16),

                // Footer action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (deepLink != null && !isPremium)
                      Text(
                        L10nService.get('common.read_more', language),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      )
                    else if (isPremium)
                      Text(
                        L10nService.get('common.unlock', language),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.starGold,
                        ),
                      )
                    else
                      const SizedBox(),
                    Icon(
                      isPremium ? Icons.lock_outline : Icons.arrow_forward_rounded,
                      size: 16,
                      color: isPremium ? AppColors.starGold : color,
                    ),
                  ],
                ),
              ],
            ),

            // Premium blur overlay
            if (isPremium)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          (isDark ? AppColors.surfaceDark : Colors.white).withValues(alpha: 0.7),
                        ],
                        stops: const [0.3, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1, duration: 300.ms);
  }

  String _blurText(String text) {
    // Show first part, blur/hide rest
    if (text.length > 60) {
      return '${text.substring(0, 60)}...';
    }
    return text;
  }
}

/// Horizontal scrollable list of insight cards
class InsightCarousel extends StatelessWidget {
  final List<InsightCardData> insights;
  final String? title;
  final VoidCallback? onPremiumTap;
  final AppLanguage language;

  const InsightCarousel({
    super.key,
    required this.insights,
    this.title,
    this.onPremiumTap,
    this.language = AppLanguage.en,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4, bottom: 16),
            child: Row(
              children: [
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {}, // View all
                  child: Text(
                    L10nService.get('common.view_all', language),
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.auroraStart,
                    ),
                  ),
                ),
              ],
            ),
          ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: insights.length,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, index) {
              final insight = insights[index];
              return InsightCard(
                title: insight.title,
                content: insight.content,
                emoji: insight.emoji,
                deepLink: insight.deepLink,
                isPremium: insight.isPremium,
                accentColor: insight.color,
                onTap: insight.onTap,
                onLockTap: onPremiumTap,
                language: language,
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Data model for insight cards
class InsightCardData {
  final String title;
  final String content;
  final String? emoji;
  final String? deepLink;
  final bool isPremium;
  final Color? color;
  final VoidCallback? onTap;

  const InsightCardData({
    required this.title,
    required this.content,
    this.emoji,
    this.deepLink,
    this.isPremium = false,
    this.color,
    this.onTap,
  });
}

/// Pre-built insight card themes
class InsightThemes {
  static List<InsightCardData> getDailyInsights(String sunSign, AppLanguage language) {
    return [
      InsightCardData(
        title: L10nService.get('insights.daily_energy_title', language),
        content: L10nService.get('insights.daily_energy_content', language),
        emoji: '🌙',
        color: AppColors.mystic,
      ),
      InsightCardData(
        title: L10nService.get('insights.transit_effect_title', language),
        content: L10nService.get('insights.transit_effect_content', language),
        emoji: '💫',
        color: AppColors.venusColor,
        isPremium: true,
      ),
      InsightCardData(
        title: L10nService.get('insights.sign_message_title', language),
        content: _getSignMessage(sunSign, language),
        emoji: '✨',
        color: AppColors.starGold,
      ),
      InsightCardData(
        title: L10nService.get('insights.dream_guide_title', language),
        content: L10nService.get('insights.dream_guide_content', language),
        emoji: '🌠',
        color: AppColors.nebulaPurple,
      ),
      InsightCardData(
        title: L10nService.get('insights.weekly_preview_title', language),
        content: L10nService.get('insights.weekly_preview_content', language),
        emoji: '📅',
        color: AppColors.auroraStart,
        isPremium: true,
      ),
    ];
  }

  static String _getSignMessage(String sign, AppLanguage language) {
    final signKey = sign.toLowerCase();
    final message = L10nService.get('insights.sign_messages.$signKey', language);
    // If key not found, return default
    if (message.contains('[insights.sign_messages.')) {
      return L10nService.get('insights.sign_messages.default', language);
    }
    return message;
  }
}
