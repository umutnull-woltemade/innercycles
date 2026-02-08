import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';
import '../../../data/services/moon_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/page_bottom_navigation.dart';

/// Provider for current VOC status
final voidOfCourseProvider = Provider<VoidOfCourseMoon>((ref) {
  return VoidOfCourseMoonExtension.getVoidOfCourseStatus();
});

/// Provider for upcoming VOC periods
final upcomingVocPeriodsProvider = Provider<List<VoidOfCourseMoon>>((ref) {
  final periods = <VoidOfCourseMoon>[];
  final now = DateTime.now();

  // Get VOC periods for the next 7 days
  for (int i = 0; i < 7; i++) {
    final date = now.add(Duration(days: i));
    // Check multiple times per day
    for (int hour = 0; hour < 24; hour += 6) {
      final checkTime = DateTime(date.year, date.month, date.day, hour);
      final voc = VoidOfCourseMoonExtension.getVoidOfCourseStatus(checkTime);
      if (voc.isVoid && voc.startTime != null) {
        // Avoid duplicates
        if (!periods.any((p) =>
            p.startTime?.day == voc.startTime?.day &&
            p.startTime?.hour == voc.startTime?.hour)) {
          periods.add(voc);
        }
      }
    }
  }

  // Sort by start time
  periods.sort((a, b) => (a.startTime ?? DateTime.now())
      .compareTo(b.startTime ?? DateTime.now()));

  return periods;
});

class VoidOfCourseScreen extends ConsumerWidget {
  const VoidOfCourseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentVoc = ref.watch(voidOfCourseProvider);
    final upcomingPeriods = ref.watch(upcomingVocPeriodsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, isDark, language),
                const SizedBox(height: AppConstants.spacingXl),
                _buildCurrentStatus(context, currentVoc, isDark, language)
                    .animate()
                    .fadeIn(delay: 100.ms, duration: 400.ms)
                    .slideY(begin: 0.1),
                const SizedBox(height: AppConstants.spacingXl),
                _buildWhatIsVoc(context, isDark, language)
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 400.ms)
                    .slideY(begin: 0.1),
                const SizedBox(height: AppConstants.spacingXl),
                _buildDosDonts(context, isDark, language)
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 400.ms)
                    .slideY(begin: 0.1),
                const SizedBox(height: AppConstants.spacingXl),
                _buildUpcomingPeriods(context, upcomingPeriods, isDark, language)
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 400.ms)
                    .slideY(begin: 0.1),
                const SizedBox(height: AppConstants.spacingXxl),
                PageBottomNavigation(currentRoute: '/timing', language: language),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, AppLanguage language) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(width: AppConstants.spacingSm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                L10nService.get('voc.title', language),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.starGold,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                L10nService.get('voc.subtitle', language),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                    ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.mysticBlue.withValues(alpha: 0.3),
                AppColors.cosmicPurple.withValues(alpha: 0.3),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: const Text('🌙', style: TextStyle(fontSize: 28)),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildCurrentStatus(BuildContext context, VoidOfCourseMoon voc, bool isDark, AppLanguage language) {
    final isVoid = voc.isVoid;
    final statusColor = isVoid ? AppColors.warning : AppColors.success;
    final moonPhase = MoonService.getCurrentPhase();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            statusColor.withValues(alpha: 0.2),
            statusColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withValues(alpha: 0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Status indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withValues(alpha: 0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                isVoid ? L10nService.get('voc.moon_voc', language) : L10nService.get('voc.moon_active', language),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Moon info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMoonInfoItem(
                context,
                L10nService.get('voc.moon_phase', language),
                moonPhase.emoji,
                moonPhase.localizedName(language),
                isDark,
              ),
              _buildMoonInfoItem(
                context,
                L10nService.get('voc.moon_sign', language),
                voc.currentSign.symbol,
                voc.currentSign.localizedName(language),
                isDark,
              ),
              if (voc.nextSign != null)
                _buildMoonInfoItem(
                  context,
                  L10nService.get('voc.next_sign', language),
                  voc.nextSign!.symbol,
                  voc.nextSign!.localizedName(language),
                  isDark,
                ),
            ],
          ),

          if (isVoid && voc.timeRemaining != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer_outlined, color: statusColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${L10nService.get('voc.time_remaining', language)}: ${voc.timeRemainingFormatted}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),
          Text(
            isVoid
                ? L10nService.get('voc.warning_message', language)
                : L10nService.get('voc.active_message', language),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMoonInfoItem(
    BuildContext context,
    String label,
    String symbol,
    String value,
    bool isDark,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
        ),
        const SizedBox(height: 6),
        Text(symbol, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildWhatIsVoc(BuildContext context, bool isDark, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.7)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline,
                color: AppColors.mysticBlue,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                L10nService.get('voc.what_is_voc', language),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            L10nService.get('voc.explanation_1', language),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            L10nService.get('voc.explanation_2', language),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDosDonts(BuildContext context, bool isDark, AppLanguage language) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildRecommendationCard(
            context,
            L10nService.get('voc.recommended', language),
            Icons.check_circle_outline,
            AppColors.success,
            L10nService.getList('voc.dos', language),
            isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildRecommendationCard(
            context,
            L10nService.get('voc.avoid', language),
            Icons.cancel_outlined,
            AppColors.error,
            L10nService.getList('voc.donts', language),
            isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    List<String> items,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '•',
                      style: TextStyle(color: color, fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildUpcomingPeriods(
    BuildContext context,
    List<VoidOfCourseMoon> periods,
    bool isDark,
    AppLanguage language,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.7)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: AppColors.starGold,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                L10nService.get('voc.upcoming_periods', language),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (periods.isEmpty)
            Text(
              L10nService.get('voc.no_upcoming', language),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
            )
          else
            ...periods.take(5).map((voc) => _buildVocPeriodItem(context, voc, isDark, language)),
        ],
      ),
    );
  }

  Widget _buildVocPeriodItem(BuildContext context, VoidOfCourseMoon voc, bool isDark, AppLanguage language) {
    final start = voc.startTime;
    final end = voc.endTime;

    if (start == null || end == null) return const SizedBox.shrink();

    final dayNames = L10nService.getList('common.weekdays_short', language);
    final dayName = dayNames.isNotEmpty ? dayNames[start.weekday % 7] : '${start.weekday}';
    final duration = voc.durationHours;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceLight.withValues(alpha: 0.1)
            : AppColors.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${start.day}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  dayName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.warning,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_formatTime(start)} - ${_formatTime(end)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${voc.currentSign.symbol} ${voc.currentSign.localizedName(language)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                          ),
                    ),
                    if (voc.nextSign != null) ...[
                      const Text(' → '),
                      Text(
                        '${voc.nextSign!.symbol} ${voc.nextSign!.localizedName(language)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                            ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (duration != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${duration.toStringAsFixed(1)}${L10nService.get('voc.hours_abbr', language)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
