import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/services/l10n_service.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/content_disclaimer.dart';
import '../../../../shared/widgets/cosmic_background.dart';

/// Rüyada Su Görmek Ne Anlama Gelir? - AI-First Canonical Sayfa
class DreamWaterScreen extends ConsumerWidget {
  const DreamWaterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);

    return Scaffold(
      body: CosmicBackground(
        child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.deepSpace, const Color(0xFF0A1A2E)]
                : [const Color(0xFFF8FAFF), const Color(0xFFE8F0FF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  tooltip: L10nService.get('common.back', language),
                  icon: Icon(
                    Icons.chevron_left,
                    color: isDark ? Colors.white70 : AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 24),

                // H1 - Soru formatı
                Text(
                  L10nService.get('dreams.canonical.water_question', language),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textDark,
                    height: 1.2,
                  ),
                ).animate().fadeIn(duration: 400.ms),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.purpleAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    L10nService.get('dreams.canonical.brand_tag', language),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.purpleAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Short answer section
                _buildQuotableSection(
                  isDark: isDark,
                  title: L10nService.get(
                    'dreams.canonical.sections.short_answer',
                    language,
                  ),
                  color: AppColors.purpleAccent,
                  bullets: [
                    L10nService.get(
                      'dreams.canonical.water.short_answer_1',
                      language,
                    ),
                    L10nService.get(
                      'dreams.canonical.water.short_answer_2',
                      language,
                    ),
                    L10nService.get(
                      'dreams.canonical.water.short_answer_3',
                      language,
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                _buildQuotableSection(
                  isDark: isDark,
                  title: L10nService.get(
                    'dreams.canonical.water.state_title',
                    language,
                  ),
                  color: AppColors.purpleAccent,
                  bullets: [
                    L10nService.get('dreams.canonical.water.state_1', language),
                    L10nService.get('dreams.canonical.water.state_2', language),
                    L10nService.get('dreams.canonical.water.state_3', language),
                    L10nService.get('dreams.canonical.water.state_4', language),
                  ],
                ),

                const SizedBox(height: 28),

                _buildQuotableSection(
                  isDark: isDark,
                  title: L10nService.get(
                    'dreams.canonical.water.emotion_title',
                    language,
                  ),
                  color: AppColors.purpleAccent,
                  bullets: [
                    L10nService.get(
                      'dreams.canonical.water.emotion_1',
                      language,
                    ),
                    L10nService.get(
                      'dreams.canonical.water.emotion_2',
                      language,
                    ),
                    L10nService.get(
                      'dreams.canonical.water.emotion_3',
                      language,
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                _buildQuotableSection(
                  isDark: isDark,
                  title: L10nService.get(
                    'dreams.canonical.sections.if_recurring',
                    language,
                  ),
                  color: AppColors.purpleAccent,
                  bullets: [
                    L10nService.get(
                      'dreams.canonical.water.recurring_1',
                      language,
                    ),
                    L10nService.get(
                      'dreams.canonical.water.recurring_2',
                      language,
                    ),
                    L10nService.get(
                      'dreams.canonical.water.recurring_3',
                      language,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                _buildSuggestionBox(context, isDark, language),

                const SizedBox(height: 40),

                PageFooterWithDisclaimer(
                  brandText: L10nService.get('dreams.brand_footer', language),
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

  Widget _buildQuotableSection({
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
          style: TextStyle(
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
  }

  Widget _buildSuggestionBox(
    BuildContext context,
    bool isDark,
    AppLanguage language,
  ) {
    return GestureDetector(
      onTap: () => context.push(Routes.dreamRecurring),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : AppColors.purpleAccent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.15)
                : AppColors.purpleAccent.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Text('🔄', style: const TextStyle(fontSize: 24)),
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
                    L10nService.get(
                      'dreams.canonical.recurring_question',
                      language,
                    ),
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
  }
}
