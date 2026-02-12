import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/services/l10n_service.dart';
import '../../../../data/providers/app_providers.dart';

/// Günlük Sayı Enerjisi Ne Anlatır? - AI-First Canonical Sayfa
class DailyNumberScreen extends ConsumerWidget {
  const DailyNumberScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final color = const Color(0xFF9C27B0);
    final today = DateTime.now();
    final dailyNumber = _calculateDailyNumber(today);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0D0D1A), const Color(0xFF1A0A20)]
                : [const Color(0xFFFDF5FF), const Color(0xFFF8E8FF)],
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
                    Icons.arrow_back_ios,
                    color: isDark ? Colors.white70 : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  L10nService.get(
                    'numerology.daily_number.page_title',
                    language,
                  ),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textDark,
                    height: 1.2,
                  ),
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 8),
                _buildTag(
                  L10nService.get('numerology.daily_number.tag', language),
                  color,
                ),
                const SizedBox(height: 32),

                _buildSection(
                  isDark,
                  L10nService.get(
                    'numerology.daily_number.short_answer_title',
                    language,
                  ),
                  color,
                  [
                    L10nService.get(
                      'numerology.daily_number.short_answer_1',
                      language,
                    ),
                    L10nService.get(
                      'numerology.daily_number.short_answer_2',
                      language,
                    ),
                    L10nService.get(
                      'numerology.daily_number.short_answer_3',
                      language,
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Today's number highlight
                _buildTodayNumber(
                  context,
                  isDark,
                  dailyNumber,
                  today,
                  language,
                ),
                const SizedBox(height: 28),

                _buildSection(
                  isDark,
                  L10nService.get(
                    'numerology.daily_number.how_calculated_title',
                    language,
                  ),
                  color,
                  [
                    L10nService.get(
                      'numerology.daily_number.how_calculated_1',
                      language,
                    ),
                    L10nService.get(
                      'numerology.daily_number.how_calculated_2',
                      language,
                    ),
                    L10nService.get(
                      'numerology.daily_number.how_calculated_3',
                      language,
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                _buildSection(
                  isDark,
                  L10nService.get(
                    'numerology.daily_number.what_for_title',
                    language,
                  ),
                  color,
                  [
                    L10nService.get(
                      'numerology.daily_number.what_for_1',
                      language,
                    ),
                    L10nService.get(
                      'numerology.daily_number.what_for_2',
                      language,
                    ),
                    L10nService.get(
                      'numerology.daily_number.what_for_3',
                      language,
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                _buildSection(
                  isDark,
                  L10nService.get(
                    'numerology.daily_number.important_note_title',
                    language,
                  ),
                  color,
                  [
                    L10nService.get(
                      'numerology.daily_number.important_note_1',
                      language,
                    ),
                    L10nService.get(
                      'numerology.daily_number.important_note_2',
                      language,
                    ),
                    L10nService.get(
                      'numerology.daily_number.important_note_3',
                      language,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                _buildSuggestion(
                  context,
                  isDark,
                  language,
                  '🎯',
                  L10nService.get(
                    'numerology.daily_number.suggestion_text',
                    language,
                  ),
                  Routes.numerology,
                ),
                const SizedBox(height: 40),

                Center(
                  child: Text(
                    L10nService.get('numerology.daily_number.footer', language),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white38 : AppColors.textLight,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _calculateDailyNumber(DateTime date) {
    int sum = date.day + date.month + date.year;
    while (sum > 9 && sum != 11 && sum != 22 && sum != 33) {
      int newSum = 0;
      while (sum > 0) {
        newSum += sum % 10;
        sum ~/= 10;
      }
      sum = newSum;
    }
    return sum;
  }

  Widget _buildTodayNumber(
    BuildContext context,
    bool isDark,
    int number,
    DateTime date,
    AppLanguage language,
  ) {
    String getMeaning(int num) {
      final key = 'numerology.daily_number.meaning_$num';
      final meaning = L10nService.get(key, language);
      // If key not found (returns the key itself), use default
      if (meaning == key) {
        return L10nService.get(
          'numerology.daily_number.meaning_default',
          language,
        );
      }
      return meaning;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF9C27B0).withValues(alpha: 0.2),
            const Color(0xFFE91E63).withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF9C27B0).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            L10nService.get('numerology.daily_number.todays_number', language),
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white60 : AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            number.toString(),
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF9C27B0),
            ),
          ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 8),
          Text(
            getMeaning(number),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildTag(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
    ),
  );

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
}
