import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/services/l10n_service.dart';
import '../../../../data/providers/app_providers.dart';

/// Tantra Mikro Rituel - AI-First Canonical Sayfa
/// 2-3 satir, fiziksel yonlendirme YOK, cinsel ima YOK
/// Story-safe, marka izi gorunur
class TantraMicroRitualScreen extends ConsumerWidget {
  const TantraMicroRitualScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final AppLanguage language = ref.watch(languageProvider);
    final today = DateTime.now();
    final ritual = _getDailyRitual(today);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0D0D1A), const Color(0xFF1A0A10)]
                : [const Color(0xFFFFFAF8), const Color(0xFFFFF0EB)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white70 : AppColors.textDark),
                    ),
                    const Spacer(),
                    _buildDateBadge(context, isDark, today, language),
                  ],
                ),
                const SizedBox(height: 48),

                // Emoji
                Text(
                  ritual.emoji,
                  style: const TextStyle(fontSize: 72),
                ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                const SizedBox(height: 32),

                // Title
                Text(
                  L10nService.get('screens.tantra_micro_ritual.todays_micro_ritual', language),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white54 : AppColors.textLight,
                    letterSpacing: 1.5,
                  ),
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 12),

                // Ritual Name
                Text(
                  L10nService.get('screens.tantra_micro_ritual.rituals.${ritual.key}.name', language),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textDark,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                const SizedBox(height: 8),

                // Tag
                _buildTag(L10nService.get('screens.tantra_micro_ritual.tantra_tag', language), const Color(0xFFE57373)),
                const SizedBox(height: 48),

                // Core Message Box - 2-3 lines
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFFE57373).withOpacity(0.2)
                          : const Color(0xFFE57373).withOpacity(0.15),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        L10nService.get('screens.tantra_micro_ritual.rituals.${ritual.key}.instruction', language),
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.6,
                          color: isDark ? Colors.white : AppColors.textDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1),
                const SizedBox(height: 32),

                // Intention
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE57373).withOpacity(isDark ? 0.15 : 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('\u2728', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          L10nService.get('screens.tantra_micro_ritual.rituals.${ritual.key}.intention', language),
                          style: TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            color: isDark ? const Color(0xFFE57373) : const Color(0xFFC62828),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                const SizedBox(height: 64),

                // Suggestion Box - Link to Dreams
                _buildSuggestion(
                  context,
                  isDark,
                  '\ud83c\udf19',
                  L10nService.get('screens.tantra_micro_ritual.discover_dream_trace', language),
                  Routes.dreamRecurring,
                ),
                const SizedBox(height: 48),

                // Footer
                Text(
                  L10nService.get('screens.tantra_micro_ritual.brand_footer', language),
                  style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : AppColors.textLight),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateBadge(BuildContext context, bool isDark, DateTime date, AppLanguage language) {
    final monthKeys = [
      'january', 'february', 'march', 'april', 'may', 'june',
      'july', 'august', 'september', 'october', 'november', 'december'
    ];
    final monthName = L10nService.get('screens.tantra_micro_ritual.months.${monthKeys[date.month - 1]}', language);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
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
  }

  Widget _buildTag(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    decoration: BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(text, style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w500)),
  );

  Widget _buildSuggestion(BuildContext context, bool isDark, String emoji, String text, String route) => GestureDetector(
    onTap: () => context.push(route),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? Colors.white : AppColors.textDark)),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.white38 : AppColors.textLight),
        ],
      ),
    ),
  ).animate().fadeIn(delay: 400.ms, duration: 400.ms);

  _MicroRitual _getDailyRitual(DateTime date) {
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    final rituals = _rituals;
    return rituals[dayOfYear % rituals.length];
  }

  static final List<_MicroRitual> _rituals = [
    _MicroRitual(emoji: '\ud83d\udd6f\ufe0f', key: 'breath_awareness'),
    _MicroRitual(emoji: '\ud83c\udf38', key: 'heart_listening'),
    _MicroRitual(emoji: '\ud83c\udf0a', key: 'flow_intention'),
    _MicroRitual(emoji: '\u2728', key: 'gratitude_moment'),
    _MicroRitual(emoji: '\ud83c\udf19', key: 'silence_minute'),
    _MicroRitual(emoji: '\ud83d\udd25', key: 'intention_setting'),
    _MicroRitual(emoji: '\ud83d\udcab', key: 'body_scan'),
  ];
}

class _MicroRitual {
  final String emoji;
  final String key;

  const _MicroRitual({
    required this.emoji,
    required this.key,
  });
}
