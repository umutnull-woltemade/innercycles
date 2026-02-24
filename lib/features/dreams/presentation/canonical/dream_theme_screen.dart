// ════════════════════════════════════════════════════════════════════════════
// DREAM THEME SCREEN - Consolidated canonical dream content page
// ════════════════════════════════════════════════════════════════════════════
// Replaces 12 individual dream_*_screen.dart files with a single
// data-driven screen. Each theme defines its own color, gradient,
// sections, and cross-link suggestion via _ThemeConfig.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/services/l10n_service.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/content_disclaimer.dart';
import '../../../../shared/widgets/app_symbol.dart';
import '../../../../shared/widgets/cosmic_background.dart';

// ════════════════════════════════════════════════════════════════════════════
// THEME CONFIG
// ════════════════════════════════════════════════════════════════════════════

class _SectionDef {
  final String titleKey;
  final List<String> bulletKeys;

  const _SectionDef({required this.titleKey, required this.bulletKeys});
}

class _SuggestionDef {
  final String emoji;
  final String questionKey;
  final String themeId;

  const _SuggestionDef({
    required this.emoji,
    required this.questionKey,
    required this.themeId,
  });
}

class _ThemeConfig {
  final String id;
  final String questionKey;
  final Color accentColor;
  final Color darkGradientEnd;
  final Color lightGradientStart;
  final Color lightGradientEnd;
  final List<_SectionDef> sections;
  final _SuggestionDef suggestion;

  const _ThemeConfig({
    required this.id,
    required this.questionKey,
    required this.accentColor,
    required this.darkGradientEnd,
    required this.lightGradientStart,
    required this.lightGradientEnd,
    required this.sections,
    required this.suggestion,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// ALL 12 THEME CONFIGS
// ════════════════════════════════════════════════════════════════════════════

final Map<String, _ThemeConfig> _themeConfigs = {
  'falling': _ThemeConfig(
    id: 'falling',
    questionKey: 'dreams.canonical.falling_question',
    accentColor: AppColors.starGold,
    darkGradientEnd: const Color(0xFF1A0A2E),
    lightGradientStart: const Color(0xFFFAF8FF),
    lightGradientEnd: const Color(0xFFF0E8FF),
    sections: const [
      _SectionDef(
        titleKey: 'dreams.canonical.sections.short_answer',
        bulletKeys: [
          'dreams.canonical.falling.short_answer_1',
          'dreams.canonical.falling.short_answer_2',
          'dreams.canonical.falling.short_answer_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.sections.what_it_means',
        bulletKeys: [
          'dreams.canonical.falling.meaning_1',
          'dreams.canonical.falling.meaning_2',
          'dreams.canonical.falling.meaning_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.falling.emotion_title',
        bulletKeys: [
          'dreams.canonical.falling.emotion_1',
          'dreams.canonical.falling.emotion_2',
          'dreams.canonical.falling.emotion_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.sections.if_recurring',
        bulletKeys: [
          'dreams.canonical.falling.recurring_1',
          'dreams.canonical.falling.recurring_2',
          'dreams.canonical.falling.recurring_3',
        ],
      ),
    ],
    suggestion: const _SuggestionDef(
      emoji: '💧',
      questionKey: 'dreams.canonical.water_question',
      themeId: 'water',
    ),
  ),
  'water': _ThemeConfig(
    id: 'water',
    questionKey: 'dreams.canonical.water_question',
    accentColor: AppColors.purpleAccent,
    darkGradientEnd: const Color(0xFF0A1A2E),
    lightGradientStart: const Color(0xFFF8FAFF),
    lightGradientEnd: const Color(0xFFE8F0FF),
    sections: const [
      _SectionDef(
        titleKey: 'dreams.canonical.sections.short_answer',
        bulletKeys: [
          'dreams.canonical.water.short_answer_1',
          'dreams.canonical.water.short_answer_2',
          'dreams.canonical.water.short_answer_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.water.state_title',
        bulletKeys: [
          'dreams.canonical.water.state_1',
          'dreams.canonical.water.state_2',
          'dreams.canonical.water.state_3',
          'dreams.canonical.water.state_4',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.water.emotion_title',
        bulletKeys: [
          'dreams.canonical.water.emotion_1',
          'dreams.canonical.water.emotion_2',
          'dreams.canonical.water.emotion_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.sections.if_recurring',
        bulletKeys: [
          'dreams.canonical.water.recurring_1',
          'dreams.canonical.water.recurring_2',
          'dreams.canonical.water.recurring_3',
        ],
      ),
    ],
    suggestion: const _SuggestionDef(
      emoji: '🔄',
      questionKey: 'dreams.canonical.recurring_question',
      themeId: 'recurring',
    ),
  ),
  'recurring': _ThemeConfig(
    id: 'recurring',
    questionKey: 'dreams.canonical.recurring_question',
    accentColor: AppColors.amethyst,
    darkGradientEnd: AppColors.cosmicPurple,
    lightGradientStart: const Color(0xFFFAF8FF),
    lightGradientEnd: const Color(0xFFF5F0FF),
    sections: const [
      _SectionDef(
        titleKey: 'dreams.canonical.sections.short_answer',
        bulletKeys: [
          'dreams.canonical.recurring.short_answer_1',
          'dreams.canonical.recurring.short_answer_2',
          'dreams.canonical.recurring.short_answer_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.recurring.why_title',
        bulletKeys: [
          'dreams.canonical.recurring.why_1',
          'dreams.canonical.recurring.why_2',
          'dreams.canonical.recurring.why_3',
          'dreams.canonical.recurring.why_4',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.recurring.what_to_do_title',
        bulletKeys: [
          'dreams.canonical.recurring.what_to_do_1',
          'dreams.canonical.recurring.what_to_do_2',
          'dreams.canonical.recurring.what_to_do_3',
          'dreams.canonical.recurring.what_to_do_4',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.recurring.when_stops_title',
        bulletKeys: [
          'dreams.canonical.recurring.when_stops_1',
          'dreams.canonical.recurring.when_stops_2',
          'dreams.canonical.recurring.when_stops_3',
        ],
      ),
    ],
    suggestion: const _SuggestionDef(
      emoji: '🌀',
      questionKey: 'dreams.canonical.falling_question',
      themeId: 'falling',
    ),
  ),
  'running': _ThemeConfig(
    id: 'running',
    questionKey: 'dreams.canonical.running_question',
    accentColor: AppColors.streakOrange,
    darkGradientEnd: const Color(0xFF1A1018),
    lightGradientStart: const Color(0xFFFFF8F5),
    lightGradientEnd: const Color(0xFFFFF0EB),
    sections: const [
      _SectionDef(
        titleKey: 'dreams.canonical.sections.short_answer',
        bulletKeys: [
          'dreams.canonical.running.short_answer_1',
          'dreams.canonical.running.short_answer_2',
          'dreams.canonical.running.short_answer_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.sections.what_it_means',
        bulletKeys: [
          'dreams.canonical.running.meaning_1',
          'dreams.canonical.running.meaning_2',
          'dreams.canonical.running.meaning_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.running.from_title',
        bulletKeys: [
          'dreams.canonical.running.from_1',
          'dreams.canonical.running.from_2',
          'dreams.canonical.running.from_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.sections.if_recurring',
        bulletKeys: [
          'dreams.canonical.running.recurring_1',
          'dreams.canonical.running.recurring_2',
          'dreams.canonical.running.recurring_3',
        ],
      ),
    ],
    suggestion: const _SuggestionDef(
      emoji: '🌀',
      questionKey: 'dreams.canonical.falling_question',
      themeId: 'falling',
    ),
  ),
  'losing-someone': _ThemeConfig(
    id: 'losing-someone',
    questionKey: 'dreams.canonical.losing_question',
    accentColor: AppColors.mediumSlateBlue,
    darkGradientEnd: AppColors.cosmicPurple,
    lightGradientStart: const Color(0xFFF8F5FF),
    lightGradientEnd: const Color(0xFFF0E8FF),
    sections: const [
      _SectionDef(
        titleKey: 'dreams.canonical.sections.short_answer',
        bulletKeys: [
          'dreams.canonical.losing.short_answer_1',
          'dreams.canonical.losing.short_answer_2',
          'dreams.canonical.losing.short_answer_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.losing.who_title',
        bulletKeys: [
          'dreams.canonical.losing.who_1',
          'dreams.canonical.losing.who_2',
          'dreams.canonical.losing.who_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.sections.what_it_means',
        bulletKeys: [
          'dreams.canonical.losing.meaning_1',
          'dreams.canonical.losing.meaning_2',
          'dreams.canonical.losing.meaning_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.sections.if_recurring',
        bulletKeys: [
          'dreams.canonical.losing.recurring_1',
          'dreams.canonical.losing.recurring_2',
          'dreams.canonical.losing.recurring_3',
        ],
      ),
    ],
    suggestion: const _SuggestionDef(
      emoji: '🕳️',
      questionKey: 'dreams.canonical.darkness_question',
      themeId: 'darkness',
    ),
  ),
  'flying': _ThemeConfig(
    id: 'flying',
    questionKey: 'dreams.canonical.flying_question',
    accentColor: AppColors.chartBlue,
    darkGradientEnd: const Color(0xFF0A1A2E),
    lightGradientStart: const Color(0xFFF5FAFF),
    lightGradientEnd: const Color(0xFFE8F4FF),
    sections: const [
      _SectionDef(
        titleKey: 'dreams.canonical.sections.short_answer',
        bulletKeys: [
          'dreams.canonical.flying.short_answer_1',
          'dreams.canonical.flying.short_answer_2',
          'dreams.canonical.flying.short_answer_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.flying.feeling_title',
        bulletKeys: [
          'dreams.canonical.flying.feeling_1',
          'dreams.canonical.flying.feeling_2',
          'dreams.canonical.flying.feeling_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.sections.what_it_means',
        bulletKeys: [
          'dreams.canonical.flying.meaning_1',
          'dreams.canonical.flying.meaning_2',
          'dreams.canonical.flying.meaning_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.flying.cant_fly_title',
        bulletKeys: [
          'dreams.canonical.flying.cant_fly_1',
          'dreams.canonical.flying.cant_fly_2',
          'dreams.canonical.flying.cant_fly_3',
        ],
      ),
    ],
    suggestion: const _SuggestionDef(
      emoji: '🏃',
      questionKey: 'dreams.canonical.running_question',
      themeId: 'running',
    ),
  ),
  'darkness': _ThemeConfig(
    id: 'darkness',
    questionKey: 'dreams.canonical.darkness_question',
    accentColor: const Color(0xFF546E7A),
    darkGradientEnd: const Color(0xFF0D1520),
    lightGradientStart: const Color(0xFFF5F7F9),
    lightGradientEnd: const Color(0xFFECF0F3),
    sections: const [
      _SectionDef(
        titleKey: 'dreams.canonical.sections.short_answer',
        bulletKeys: [
          'dreams.canonical.darkness.short_answer_1',
          'dreams.canonical.darkness.short_answer_2',
          'dreams.canonical.darkness.short_answer_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.darkness.action_title',
        bulletKeys: [
          'dreams.canonical.darkness.action_1',
          'dreams.canonical.darkness.action_2',
          'dreams.canonical.darkness.action_3',
          'dreams.canonical.darkness.action_4',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.sections.what_it_means',
        bulletKeys: [
          'dreams.canonical.darkness.meaning_1',
          'dreams.canonical.darkness.meaning_2',
          'dreams.canonical.darkness.meaning_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.sections.if_recurring',
        bulletKeys: [
          'dreams.canonical.darkness.recurring_1',
          'dreams.canonical.darkness.recurring_2',
          'dreams.canonical.darkness.recurring_3',
        ],
      ),
    ],
    suggestion: const _SuggestionDef(
      emoji: '👤',
      questionKey: 'dreams.canonical.past_question',
      themeId: 'someone-from-past',
    ),
  ),
  'someone-from-past': _ThemeConfig(
    id: 'someone-from-past',
    questionKey: 'dreams.canonical.past_question',
    accentColor: AppColors.amethyst,
    darkGradientEnd: const Color(0xFF1A0A20),
    lightGradientStart: const Color(0xFFFAF5FC),
    lightGradientEnd: const Color(0xFFF5E8F8),
    sections: const [
      _SectionDef(
        titleKey: 'dreams.canonical.sections.short_answer',
        bulletKeys: [
          'dreams.canonical.past.short_answer_1',
          'dreams.canonical.past.short_answer_2',
          'dreams.canonical.past.short_answer_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.past.who_title',
        bulletKeys: [
          'dreams.canonical.past.who_1',
          'dreams.canonical.past.who_2',
          'dreams.canonical.past.who_3',
          'dreams.canonical.past.who_4',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.sections.what_it_means',
        bulletKeys: [
          'dreams.canonical.past.meaning_1',
          'dreams.canonical.past.meaning_2',
          'dreams.canonical.past.meaning_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.sections.if_recurring',
        bulletKeys: [
          'dreams.canonical.past.recurring_1',
          'dreams.canonical.past.recurring_2',
          'dreams.canonical.past.recurring_3',
        ],
      ),
    ],
    suggestion: const _SuggestionDef(
      emoji: '🔍',
      questionKey: 'dreams.canonical.searching_question',
      themeId: 'searching',
    ),
  ),
  'searching': _ThemeConfig(
    id: 'searching',
    questionKey: 'dreams.canonical.searching_question',
    accentColor: AppColors.warning,
    darkGradientEnd: AppColors.deepSpace,
    lightGradientStart: const Color(0xFFFFFCF5),
    lightGradientEnd: const Color(0xFFFFF8E8),
    sections: const [
      _SectionDef(
        titleKey: 'dreams.canonical.sections.short_answer',
        bulletKeys: [
          'dreams.canonical.searching.short_answer_1',
          'dreams.canonical.searching.short_answer_2',
          'dreams.canonical.searching.short_answer_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.searching.what_title',
        bulletKeys: [
          'dreams.canonical.searching.what_1',
          'dreams.canonical.searching.what_2',
          'dreams.canonical.searching.what_3',
          'dreams.canonical.searching.what_4',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.sections.what_it_means',
        bulletKeys: [
          'dreams.canonical.searching.meaning_1',
          'dreams.canonical.searching.meaning_2',
          'dreams.canonical.searching.meaning_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.searching.not_found_title',
        bulletKeys: [
          'dreams.canonical.searching.not_found_1',
          'dreams.canonical.searching.not_found_2',
          'dreams.canonical.searching.not_found_3',
        ],
      ),
    ],
    suggestion: const _SuggestionDef(
      emoji: '🌫️',
      questionKey: 'dreams.canonical.lost_question',
      themeId: 'lost',
    ),
  ),
  'voiceless': _ThemeConfig(
    id: 'voiceless',
    questionKey: 'dreams.canonical.voiceless_question',
    accentColor: AppColors.brandPink,
    darkGradientEnd: const Color(0xFF1A0A15),
    lightGradientStart: const Color(0xFFFFF5F8),
    lightGradientEnd: const Color(0xFFFFE8EF),
    sections: const [
      _SectionDef(
        titleKey: 'dreams.canonical.sections.short_answer',
        bulletKeys: [
          'dreams.canonical.voiceless.short_answer_1',
          'dreams.canonical.voiceless.short_answer_2',
          'dreams.canonical.voiceless.short_answer_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.voiceless.why_title',
        bulletKeys: [
          'dreams.canonical.voiceless.why_1',
          'dreams.canonical.voiceless.why_2',
          'dreams.canonical.voiceless.why_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.sections.what_it_means',
        bulletKeys: [
          'dreams.canonical.voiceless.meaning_1',
          'dreams.canonical.voiceless.meaning_2',
          'dreams.canonical.voiceless.meaning_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.sections.if_recurring',
        bulletKeys: [
          'dreams.canonical.voiceless.recurring_1',
          'dreams.canonical.voiceless.recurring_2',
          'dreams.canonical.voiceless.recurring_3',
        ],
      ),
    ],
    suggestion: const _SuggestionDef(
      emoji: '💧',
      questionKey: 'dreams.canonical.water_question',
      themeId: 'water',
    ),
  ),
  'lost': _ThemeConfig(
    id: 'lost',
    questionKey: 'dreams.canonical.lost_question',
    accentColor: AppColors.exportGreen,
    darkGradientEnd: const Color(0xFF0A1A15),
    lightGradientStart: const Color(0xFFF5FFF8),
    lightGradientEnd: const Color(0xFFE8FFF0),
    sections: const [
      _SectionDef(
        titleKey: 'dreams.canonical.sections.short_answer',
        bulletKeys: [
          'dreams.canonical.lost.short_answer_1',
          'dreams.canonical.lost.short_answer_2',
          'dreams.canonical.lost.short_answer_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.lost.where_title',
        bulletKeys: [
          'dreams.canonical.lost.where_1',
          'dreams.canonical.lost.where_2',
          'dreams.canonical.lost.where_3',
          'dreams.canonical.lost.where_4',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.sections.what_it_means',
        bulletKeys: [
          'dreams.canonical.lost.meaning_1',
          'dreams.canonical.lost.meaning_2',
          'dreams.canonical.lost.meaning_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.lost.find_title',
        bulletKeys: [
          'dreams.canonical.lost.find_1',
          'dreams.canonical.lost.find_2',
          'dreams.canonical.lost.find_3',
        ],
      ),
    ],
    suggestion: const _SuggestionDef(
      emoji: '🌫️',
      questionKey: 'dreams.canonical.darkness_question',
      themeId: 'darkness',
    ),
  ),
  'unable-to-fly': _ThemeConfig(
    id: 'unable-to-fly',
    questionKey: 'dreams.canonical.unable_to_fly_question',
    accentColor: const Color(0xFF90A4AE),
    darkGradientEnd: const Color(0xFF101820),
    lightGradientStart: const Color(0xFFF5F8FA),
    lightGradientEnd: const Color(0xFFECF2F5),
    sections: const [
      _SectionDef(
        titleKey: 'dreams.canonical.sections.short_answer',
        bulletKeys: [
          'dreams.canonical.unable_to_fly.short_answer_1',
          'dreams.canonical.unable_to_fly.short_answer_2',
          'dreams.canonical.unable_to_fly.short_answer_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.unable_to_fly.why_title',
        bulletKeys: [
          'dreams.canonical.unable_to_fly.why_1',
          'dreams.canonical.unable_to_fly.why_2',
          'dreams.canonical.unable_to_fly.why_3',
          'dreams.canonical.unable_to_fly.why_4',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.sections.what_it_means',
        bulletKeys: [
          'dreams.canonical.unable_to_fly.meaning_1',
          'dreams.canonical.unable_to_fly.meaning_2',
          'dreams.canonical.unable_to_fly.meaning_3',
        ],
      ),
      _SectionDef(
        titleKey: 'dreams.canonical.sections.if_recurring',
        bulletKeys: [
          'dreams.canonical.unable_to_fly.recurring_1',
          'dreams.canonical.unable_to_fly.recurring_2',
          'dreams.canonical.unable_to_fly.recurring_3',
        ],
      ),
    ],
    suggestion: const _SuggestionDef(
      emoji: '🌀',
      questionKey: 'dreams.canonical.falling_question',
      themeId: 'falling',
    ),
  ),
};

// ════════════════════════════════════════════════════════════════════════════
// UNIFIED DREAM THEME SCREEN
// ════════════════════════════════════════════════════════════════════════════

class DreamThemeScreen extends ConsumerWidget {
  final String themeId;

  const DreamThemeScreen({super.key, required this.themeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = _themeConfigs[themeId];
    if (config == null) {
      return Scaffold(
        body: Center(child: Text('Unknown dream theme: $themeId')),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final color = config.accentColor;

    return Scaffold(
      body: CosmicBackground(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [AppColors.deepSpace, config.darkGradientEnd]
                  : [config.lightGradientStart, config.lightGradientEnd],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  IconButton(
                    onPressed: () => context.pop(),
                    tooltip: L10nService.get('common.back', language),
                    icon: Icon(
                      Icons.chevron_left,
                      color: isDark ? Colors.white70 : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // H1 title
                  Text(
                    L10nService.get(config.questionKey, language),
                    style: AppTypography.displayFont.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textDark,
                      height: 1.2,
                    ),
                  ).animate().fadeIn(duration: 400.ms),

                  const SizedBox(height: 8),

                  // Brand tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      L10nService.get('dreams.canonical.brand_tag', language),
                      style: AppTypography.elegantAccent(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Content sections
                  for (int i = 0; i < config.sections.length; i++) ...[
                    if (i > 0) const SizedBox(height: 28),
                    _buildSection(
                      isDark: isDark,
                      title: L10nService.get(
                        config.sections[i].titleKey,
                        language,
                      ),
                      color: color,
                      bullets: config.sections[i].bulletKeys
                          .map((k) => L10nService.get(k, language))
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Suggestion box
                  _buildSuggestion(
                    context: context,
                    isDark: isDark,
                    language: language,
                    emoji: config.suggestion.emoji,
                    text: L10nService.get(
                      config.suggestion.questionKey,
                      language,
                    ),
                    route: '/dreams/${config.suggestion.themeId}',
                  ),

                  const SizedBox(height: 40),

                  // Footer with disclaimer
                  PageFooterWithDisclaimer(
                    brandText:
                        L10nService.get('dreams.canonical.brand_footer', language),
                    disclaimerText: DisclaimerTexts.dreams(language),
                    language: language,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required bool isDark,
    required String title,
    required Color color,
    required List<String> bullets,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.elegantAccent(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? color : color.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 12),
        ...bullets.map(
          (bullet) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '•',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white54 : AppColors.textLight,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    bullet,
                    style: AppTypography.decorativeScript(
                      fontSize: 15,
                      color: isDark ? Colors.white70 : AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildSuggestion({
    required BuildContext context,
    required bool isDark,
    required AppLanguage language,
    required String emoji,
    required String text,
    required String route,
  }) {
    return Semantics(
      label: text,
      button: true,
      child: GestureDetector(
        onTap: () => context.push(route),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              AppSymbol.card(emoji),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      L10nService.get('common.also_discover', language),
                      style: AppTypography.elegantAccent(
                        fontSize: 11,
                        color: isDark ? Colors.white38 : AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      text,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: isDark ? Colors.white38 : AppColors.textLight,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }
}
