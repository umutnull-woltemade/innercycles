// ════════════════════════════════════════════════════════════════════════════
// COSMIC MESSAGE CARD - Daily Intention & Reflection Widget for Home Screen
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/content/cosmic_messages_content.dart';
import '../../../data/providers/app_providers.dart';

class CosmicMessageCard extends ConsumerWidget {
  const CosmicMessageCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final now = DateTime.now();

    // Get today's cosmic content
    final intention = CosmicMessagesContent.getDailyIntention(now);
    final wisdom = CosmicMessagesContent.getExtendedCosmicWisdom(now);

    // Use Turkish content for TR, English fallback phrases for EN
    final message = isEn ? _toEnglishIntention(now) : intention;
    final detail = isEn ? _toEnglishWisdom(now) : wisdom;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.cosmicPurple.withValues(alpha: 0.15),
                  AppColors.amethyst.withValues(alpha: 0.08),
                  AppColors.surfaceDark.withValues(alpha: 0.9),
                ]
              : [
                  AppColors.cosmicPurple.withValues(alpha: 0.06),
                  AppColors.amethyst.withValues(alpha: 0.03),
                  AppColors.lightCard,
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.amethyst.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.amethyst.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.amethyst,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isEn ? 'Daily Intention' : 'Günün Niyeti',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              Icon(
                _timeOfDayIcon(now),
                size: 16,
                color: AppColors.amethyst.withValues(alpha: 0.6),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Main intention text
          Text(
            message,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              fontStyle: FontStyle.italic,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),

          const SizedBox(height: 8),

          // Wisdom snippet
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.amethyst.withValues(alpha: isDark ? 0.08 : 0.04),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.amethyst.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.format_quote_rounded,
                  size: 14,
                  color: AppColors.amethyst.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    detail,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.06, duration: 400.ms);
  }

  IconData _timeOfDayIcon(DateTime now) {
    final hour = now.hour;
    if (hour < 12) return Icons.wb_sunny_rounded;
    if (hour < 18) return Icons.light_mode_rounded;
    return Icons.nights_stay_rounded;
  }

  /// English daily intentions — deterministic rotation
  String _toEnglishIntention(DateTime date) {
    final intentions = [
      'Set an intention to notice your emotions without judgment today.',
      'Today, practice giving yourself the same compassion you\'d offer a friend.',
      'Focus on one small act of kindness — towards yourself or someone else.',
      'Take a moment to appreciate something you normally overlook.',
      'Let today be about progress, not perfection.',
      'Notice when you\'re rushing. Slow down and breathe.',
      'Ask yourself: what do I truly need right now?',
      'Today, let go of one expectation and see what unfolds.',
      'Practice being present in your conversations today.',
      'Give yourself permission to rest without guilt.',
      'Notice three things that bring you peace today.',
      'What would your wisest self say to you right now?',
      'Today is a good day to listen more than you speak.',
      'Embrace the uncertainty — growth lives there.',
      'Set a boundary that honors your energy today.',
      'Choose one thing to do mindfully and fully today.',
      'Let curiosity guide you more than worry today.',
      'Today, notice where you hold tension and release it.',
      'Trust that you are exactly where you need to be.',
      'End today by naming one thing you\'re grateful for.',
      'Today, move your body with appreciation, not obligation.',
    ];
    final idx = (date.day + date.month * 31) % intentions.length;
    return intentions[idx];
  }

  /// English wisdom quotes — deterministic rotation
  String _toEnglishWisdom(DateTime date) {
    final wisdoms = [
      'Self-awareness is the beginning of transformation.',
      'Every emotion carries a message worth hearing.',
      'The patterns you notice today shape the growth of tomorrow.',
      'Stillness is not inaction — it is a form of deep listening.',
      'Your inner world reflects your outer experience.',
      'Healing is not linear. Honor every step of the journey.',
      'What you resist persists. What you accept transforms.',
      'The quiet moments often hold the loudest truths.',
      'You don\'t need to have all the answers — just the right questions.',
      'Reflection is a bridge between where you are and who you\'re becoming.',
      'Your emotions are data, not directives.',
      'Growth happens in the space between stimulus and response.',
      'The most important relationship is the one with yourself.',
      'Vulnerability is not weakness — it is courage.',
    ];
    final idx = (date.day + date.month * 31 + 7) % wisdoms.length;
    return wisdoms[idx];
  }
}
