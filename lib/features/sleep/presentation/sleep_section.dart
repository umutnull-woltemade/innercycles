import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

/// Collapsible sleep quality section for the daily entry screen
class SleepSection extends ConsumerStatefulWidget {
  final DateTime date;

  const SleepSection({super.key, required this.date});

  @override
  ConsumerState<SleepSection> createState() => _SleepSectionState();
}

class _SleepSectionState extends ConsumerState<SleepSection> {
  bool _isExpanded = false;
  int _selectedQuality = 0; // 0 = not selected
  final _noteController = TextEditingController();
  bool _hasLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  @override
  void didUpdateWidget(SleepSection old) {
    super.didUpdateWidget(old);
    if (old.date != widget.date) {
      _hasLoaded = false;
      _loadExisting();
    }
  }

  Future<void> _loadExisting() async {
    if (_hasLoaded) return;
    final service = await ref.read(sleepServiceProvider.future);
    final entry = service.getEntry(widget.date);
    if (entry != null && mounted) {
      setState(() {
        _selectedQuality = entry.quality;
        _noteController.text = entry.note ?? '';
        _isExpanded = true;
      });
    }
    _hasLoaded = true;
  }

  Future<void> _save() async {
    if (_selectedQuality == 0) return;
    final service = await ref.read(sleepServiceProvider.future);
    await service.saveSleep(
      date: widget.date,
      quality: _selectedQuality,
      note: _noteController.text,
    );
    ref.invalidate(sleepSummaryProvider);
    ref.invalidate(todaySleepProvider);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;

    return PremiumCard(
      style: PremiumCardStyle.subtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - tap to expand
          Semantics(
            label: isEn
                ? (_isExpanded ? 'Collapse sleep quality' : 'Expand sleep quality')
                : (_isExpanded ? 'Uyku kalitesini daralt' : 'Uyku kalitesini genişlet'),
            button: true,
            child: InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              child: Row(
                children: [
                  Icon(
                    Icons.bedtime_outlined,
                    size: 20,
                    color: isDark
                        ? AppColors.auroraEnd
                        : AppColors.lightAuroraEnd,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GradientText(
                      isEn ? 'Sleep Quality' : 'Uyku Kalitesi',
                      variant: GradientTextVariant.aurora,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (_selectedQuality > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _qualityColor(
                          _selectedQuality,
                        ).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$_selectedQuality/5',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _qualityColor(_selectedQuality),
                        ),
                      ),
                    ),
                  const SizedBox(width: 4),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ],
              ),
            ),
          ),
          ),

          // Expandable content
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.spacingLg,
                0,
                AppConstants.spacingLg,
                AppConstants.spacingLg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEn
                        ? 'How did you sleep last night?'
                        : 'Dün gece nasıl uyudun?',
                    style: AppTypography.decorativeScript(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Quality selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (i) {
                      final quality = i + 1;
                      final isActive = quality == _selectedQuality;
                      return Semantics(
                        label:
                            '${isEn ? 'Sleep quality' : 'Uyku kalitesi'} $quality: ${_qualityLabel(quality, isEn)}',
                        button: true,
                        selected: isActive,
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedQuality = quality);
                            _save();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive
                                  ? _qualityColor(quality)
                                  : (isDark
                                        ? AppColors.surfaceLight.withValues(
                                            alpha: 0.3,
                                          )
                                        : AppColors.lightSurfaceVariant),
                              border: Border.all(
                                color: isActive
                                    ? _qualityColor(quality)
                                    : (isDark
                                          ? Colors.white.withValues(alpha: 0.15)
                                          : Colors.black.withValues(
                                              alpha: 0.08,
                                            )),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                _qualityIcon(quality),
                                size: 24,
                                color: isActive
                                    ? (isDark ? Colors.white : AppColors.deepSpace)
                                    : (isDark ? Colors.white54 : Colors.black38),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  if (_selectedQuality > 0) ...[
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        _qualityLabel(_selectedQuality, isEn),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _qualityColor(_selectedQuality),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Optional note
                    TextField(
                      controller: _noteController,
                      maxLines: 2,
                      maxLength: 200,
                      onChanged: (_) => _save(),
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: isEn
                            ? 'Any sleep notes... (optional)'
                            : 'Uyku notları... (opsiyonel)',
                        hintStyle: TextStyle(
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                          fontSize: 13,
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        filled: true,
                        fillColor: isDark
                            ? AppColors.deepSpace.withValues(alpha: 0.5)
                            : AppColors.lightSurfaceVariant,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        counterStyle: TextStyle(
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ).animate().fadeIn(duration: 200.ms),
        ],
      ),
    );
  }

  IconData _qualityIcon(int quality) {
    switch (quality) {
      case 1:
        return Icons.sentiment_very_dissatisfied_rounded;
      case 2:
        return Icons.sentiment_dissatisfied_rounded;
      case 3:
        return Icons.sentiment_neutral_rounded;
      case 4:
        return Icons.sentiment_satisfied_rounded;
      case 5:
        return Icons.nights_stay_rounded;
      default:
        return Icons.bedtime_rounded;
    }
  }

  String _qualityLabel(int quality, bool isEn) {
    final labelsEn = ['Terrible', 'Poor', 'Fair', 'Good', 'Excellent'];
    final labelsTr = ['Berbat', 'Kötü', 'Orta', 'İyi', 'Mükemmel'];
    final idx = (quality - 1).clamp(0, labelsEn.length - 1);
    return isEn ? labelsEn[idx] : labelsTr[idx];
  }

  Color _qualityColor(int quality) {
    switch (quality) {
      case 1:
        return AppColors.error;
      case 2:
        return AppColors.sunriseEnd;
      case 3:
        return AppColors.warning;
      case 4:
        return AppColors.auroraStart;
      case 5:
        return AppColors.success;
      default:
        return AppColors.textMuted;
    }
  }
}

/// Sleep summary card for home screen
class SleepSummaryCard extends ConsumerWidget {
  const SleepSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final summaryAsync = ref.watch(sleepSummaryProvider);

    return summaryAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (summary) {
        if (summary.nightsLogged == 0) return const SizedBox.shrink();

        return PremiumCard(
          style: PremiumCardStyle.subtle,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bedtime_outlined,
                    size: 18,
                    color: isDark
                        ? AppColors.auroraEnd
                        : AppColors.lightAuroraEnd,
                  ),
                  const SizedBox(width: 8),
                  GradientText(
                    isEn ? 'Sleep This Week' : 'Bu Hafta Uyku',
                    variant: GradientTextVariant.aurora,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (summary.trendDirection != null)
                    Icon(
                      summary.trendDirection == 'improving'
                          ? Icons.trending_up
                          : summary.trendDirection == 'declining'
                          ? Icons.trending_down
                          : Icons.trending_flat,
                      size: 18,
                      color: summary.trendDirection == 'improving'
                          ? AppColors.success
                          : summary.trendDirection == 'declining'
                          ? AppColors.warning
                          : AppColors.textMuted,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _SleepStat(
                    label: isEn ? 'Avg' : 'Ort',
                    value: summary.averageQuality.toStringAsFixed(1),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 20),
                  _SleepStat(
                    label: isEn ? 'Nights' : 'Gece',
                    value: '${summary.nightsLogged}/7',
                    isDark: isDark,
                  ),
                  const SizedBox(width: 20),
                  _SleepStat(
                    label: isEn ? 'Best' : 'En İyi',
                    value: '${summary.bestNightQuality}/5',
                    isDark: isDark,
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(duration: 300.ms);
      },
    );
  }
}

class _SleepStat extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _SleepStat({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTypography.displayFont.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
        Text(
          label,
          style: AppTypography.elegantAccent(
            fontSize: 11,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
