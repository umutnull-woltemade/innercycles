import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/services/l10n_service.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/entertainment_disclaimer.dart';

/// Kozmik - Bugünün Teması
/// Günlük değişen kozmik tema sayfası
class CosmicTodayScreen extends ConsumerWidget {
  const CosmicTodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final today = DateTime.now();
    final theme = _getDailyTheme(today, language);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF0D0D1A),
                    Color.lerp(const Color(0xFF0D0D1A), theme.color, 0.15)!,
                  ]
                : [
                    const Color(0xFFFFFDF8),
                    Color.lerp(const Color(0xFFFFFDF8), theme.color, 0.08)!,
                  ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      tooltip: L10nService.get('common.back', language),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: isDark ? Colors.white70 : AppColors.textDark,
                      ),
                    ),
                    const Spacer(),
                    _buildDateBadge(context, isDark, today),
                  ],
                ),
                const SizedBox(height: 32),

                // Emoji
                Center(
                  child: Text(
                    theme.emoji,
                    style: const TextStyle(fontSize: 64),
                  ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                ),
                const SizedBox(height: 24),

                // Title
                Center(
                  child: Text(
                    theme.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textDark,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 400.ms),
                ),
                const SizedBox(height: 8),

                // Tag
                Center(
                  child: _buildTag(
                    L10nService.get('cosmic_today.kozmik_tag', language),
                    theme.color,
                  ),
                ),
                const SizedBox(height: 40),

                // 3 Bullets - Core Message
                _buildMainBullets(context, isDark, theme),
                const SizedBox(height: 36),

                // Sections
                _buildSection(
                  isDark,
                  L10nService.get('cosmic_today.todays_emphasis', language),
                  theme.color,
                  theme.emphasis,
                ),
                const SizedBox(height: 28),
                _buildSection(
                  isDark,
                  L10nService.get('cosmic_today.emotional_tone', language),
                  theme.color,
                  theme.emotionalTone,
                ),
                const SizedBox(height: 28),
                _buildSection(
                  isDark,
                  L10nService.get('cosmic_today.awareness', language),
                  theme.color,
                  theme.awareness,
                ),
                const SizedBox(height: 32),

                // Suggestion - Kozmik → rüya + numeroloji
                _buildSuggestion(
                  context,
                  isDark,
                  language,
                  '🌙',
                  L10nService.get(
                    'cosmic_today.discover_dream_trace',
                    language,
                  ),
                  Routes.dreamRecurring,
                ),
                const SizedBox(height: 40),

                // Footer with disclaimer
                const PageFooterWithDisclaimer(brandText: 'Kozmik — Venus One'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateBadge(BuildContext context, bool isDark, DateTime date) {
    return Consumer(
      builder: (context, ref, _) {
        final language = ref.watch(languageProvider);
        final monthKeys = [
          'january',
          'february',
          'march',
          'april',
          'may',
          'june',
          'july',
          'august',
          'september',
          'october',
          'november',
          'december',
        ];
        final monthName = L10nService.get(
          'cosmic_today.months.${monthKeys[date.month - 1]}',
          language,
        );
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${date.day} $monthName',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : AppColors.textDark,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTag(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w500),
    ),
  );

  Widget _buildMainBullets(
    BuildContext context,
    bool isDark,
    _DailyTheme theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? theme.color.withValues(alpha: 0.1)
            : theme.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: theme.coreBullets
            .map(
              (bullet) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: theme.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        bullet,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: isDark ? Colors.white : AppColors.textDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildSection(
    bool isDark,
    String title,
    Color color,
    List<String> bullets,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDark ? color : color.withValues(alpha: 0.85),
        ),
      ),
      const SizedBox(height: 12),
      ...bullets.map(
        (b) => Padding(
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
                  b,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
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

  Widget _buildSuggestion(
    BuildContext context,
    bool isDark,
    AppLanguage language,
    String emoji,
    String text,
    String route,
  ) => GestureDetector(
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
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10nService.get('common.also_discover', language),
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white38 : AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  text,
                  style: TextStyle(
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
  ).animate().fadeIn(delay: 200.ms, duration: 400.ms);

  _DailyTheme _getDailyTheme(DateTime date, AppLanguage language) {
    // Rotate themes based on day of year
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    final themes = _getLocalizedThemes(language);
    return themes[dayOfYear % themes.length];
  }

  List<_DailyTheme> _getLocalizedThemes(AppLanguage language) {
    return [
      _DailyTheme(
        emoji: '🌅',
        title: L10nService.get(
          'cosmic_today.themes.new_beginnings.title',
          language,
        ),
        color: const Color(0xFFFF9800),
        coreBullets: [
          L10nService.get(
            'cosmic_today.themes.new_beginnings.bullet1',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.new_beginnings.bullet2',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.new_beginnings.bullet3',
            language,
          ),
        ],
        emphasis: [
          L10nService.get(
            'cosmic_today.themes.new_beginnings.emphasis1',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.new_beginnings.emphasis2',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.new_beginnings.emphasis3',
            language,
          ),
        ],
        emotionalTone: [
          L10nService.get(
            'cosmic_today.themes.new_beginnings.emotional1',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.new_beginnings.emotional2',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.new_beginnings.emotional3',
            language,
          ),
        ],
        awareness: [
          L10nService.get(
            'cosmic_today.themes.new_beginnings.awareness1',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.new_beginnings.awareness2',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.new_beginnings.awareness3',
            language,
          ),
        ],
      ),
      _DailyTheme(
        emoji: '🌊',
        title: L10nService.get(
          'cosmic_today.themes.emotional_depth.title',
          language,
        ),
        color: const Color(0xFF2196F3),
        coreBullets: [
          L10nService.get(
            'cosmic_today.themes.emotional_depth.bullet1',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.emotional_depth.bullet2',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.emotional_depth.bullet3',
            language,
          ),
        ],
        emphasis: [
          L10nService.get(
            'cosmic_today.themes.emotional_depth.emphasis1',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.emotional_depth.emphasis2',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.emotional_depth.emphasis3',
            language,
          ),
        ],
        emotionalTone: [
          L10nService.get(
            'cosmic_today.themes.emotional_depth.emotional1',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.emotional_depth.emotional2',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.emotional_depth.emotional3',
            language,
          ),
        ],
        awareness: [
          L10nService.get(
            'cosmic_today.themes.emotional_depth.awareness1',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.emotional_depth.awareness2',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.emotional_depth.awareness3',
            language,
          ),
        ],
      ),
      _DailyTheme(
        emoji: '🔥',
        title: L10nService.get(
          'cosmic_today.themes.inner_strength.title',
          language,
        ),
        color: const Color(0xFFE91E63),
        coreBullets: [
          L10nService.get(
            'cosmic_today.themes.inner_strength.bullet1',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.inner_strength.bullet2',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.inner_strength.bullet3',
            language,
          ),
        ],
        emphasis: [
          L10nService.get(
            'cosmic_today.themes.inner_strength.emphasis1',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.inner_strength.emphasis2',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.inner_strength.emphasis3',
            language,
          ),
        ],
        emotionalTone: [
          L10nService.get(
            'cosmic_today.themes.inner_strength.emotional1',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.inner_strength.emotional2',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.inner_strength.emotional3',
            language,
          ),
        ],
        awareness: [
          L10nService.get(
            'cosmic_today.themes.inner_strength.awareness1',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.inner_strength.awareness2',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.inner_strength.awareness3',
            language,
          ),
        ],
      ),
      _DailyTheme(
        emoji: '🌿',
        title: L10nService.get('cosmic_today.themes.grounding.title', language),
        color: const Color(0xFF4CAF50),
        coreBullets: [
          L10nService.get('cosmic_today.themes.grounding.bullet1', language),
          L10nService.get('cosmic_today.themes.grounding.bullet2', language),
          L10nService.get('cosmic_today.themes.grounding.bullet3', language),
        ],
        emphasis: [
          L10nService.get('cosmic_today.themes.grounding.emphasis1', language),
          L10nService.get('cosmic_today.themes.grounding.emphasis2', language),
          L10nService.get('cosmic_today.themes.grounding.emphasis3', language),
        ],
        emotionalTone: [
          L10nService.get('cosmic_today.themes.grounding.emotional1', language),
          L10nService.get('cosmic_today.themes.grounding.emotional2', language),
          L10nService.get('cosmic_today.themes.grounding.emotional3', language),
        ],
        awareness: [
          L10nService.get('cosmic_today.themes.grounding.awareness1', language),
          L10nService.get('cosmic_today.themes.grounding.awareness2', language),
          L10nService.get('cosmic_today.themes.grounding.awareness3', language),
        ],
      ),
      _DailyTheme(
        emoji: '💨',
        title: L10nService.get(
          'cosmic_today.themes.mental_clarity.title',
          language,
        ),
        color: const Color(0xFF9C27B0),
        coreBullets: [
          L10nService.get(
            'cosmic_today.themes.mental_clarity.bullet1',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.mental_clarity.bullet2',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.mental_clarity.bullet3',
            language,
          ),
        ],
        emphasis: [
          L10nService.get(
            'cosmic_today.themes.mental_clarity.emphasis1',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.mental_clarity.emphasis2',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.mental_clarity.emphasis3',
            language,
          ),
        ],
        emotionalTone: [
          L10nService.get(
            'cosmic_today.themes.mental_clarity.emotional1',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.mental_clarity.emotional2',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.mental_clarity.emotional3',
            language,
          ),
        ],
        awareness: [
          L10nService.get(
            'cosmic_today.themes.mental_clarity.awareness1',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.mental_clarity.awareness2',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.mental_clarity.awareness3',
            language,
          ),
        ],
      ),
      _DailyTheme(
        emoji: '🌙',
        title: L10nService.get(
          'cosmic_today.themes.introspection.title',
          language,
        ),
        color: const Color(0xFF607D8B),
        coreBullets: [
          L10nService.get(
            'cosmic_today.themes.introspection.bullet1',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.introspection.bullet2',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.introspection.bullet3',
            language,
          ),
        ],
        emphasis: [
          L10nService.get(
            'cosmic_today.themes.introspection.emphasis1',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.introspection.emphasis2',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.introspection.emphasis3',
            language,
          ),
        ],
        emotionalTone: [
          L10nService.get(
            'cosmic_today.themes.introspection.emotional1',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.introspection.emotional2',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.introspection.emotional3',
            language,
          ),
        ],
        awareness: [
          L10nService.get(
            'cosmic_today.themes.introspection.awareness1',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.introspection.awareness2',
            language,
          ),
          L10nService.get(
            'cosmic_today.themes.introspection.awareness3',
            language,
          ),
        ],
      ),
      _DailyTheme(
        emoji: '⭐',
        title: L10nService.get('cosmic_today.themes.potential.title', language),
        color: const Color(0xFFFFD700),
        coreBullets: [
          L10nService.get('cosmic_today.themes.potential.bullet1', language),
          L10nService.get('cosmic_today.themes.potential.bullet2', language),
          L10nService.get('cosmic_today.themes.potential.bullet3', language),
        ],
        emphasis: [
          L10nService.get('cosmic_today.themes.potential.emphasis1', language),
          L10nService.get('cosmic_today.themes.potential.emphasis2', language),
          L10nService.get('cosmic_today.themes.potential.emphasis3', language),
        ],
        emotionalTone: [
          L10nService.get('cosmic_today.themes.potential.emotional1', language),
          L10nService.get('cosmic_today.themes.potential.emotional2', language),
          L10nService.get('cosmic_today.themes.potential.emotional3', language),
        ],
        awareness: [
          L10nService.get('cosmic_today.themes.potential.awareness1', language),
          L10nService.get('cosmic_today.themes.potential.awareness2', language),
          L10nService.get('cosmic_today.themes.potential.awareness3', language),
        ],
      ),
    ];
  }
}

class _DailyTheme {
  final String emoji;
  final String title;
  final Color color;
  final List<String> coreBullets;
  final List<String> emphasis;
  final List<String> emotionalTone;
  final List<String> awareness;

  const _DailyTheme({
    required this.emoji,
    required this.title,
    required this.color,
    required this.coreBullets,
    required this.emphasis,
    required this.emotionalTone,
    required this.awareness,
  });
}
