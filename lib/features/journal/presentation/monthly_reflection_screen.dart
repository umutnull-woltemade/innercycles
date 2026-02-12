import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';

import '../../../data/providers/app_providers.dart';
import '../../../data/services/pattern_engine_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

class MonthlyReflectionScreen extends ConsumerStatefulWidget {
  const MonthlyReflectionScreen({super.key});

  @override
  ConsumerState<MonthlyReflectionScreen> createState() =>
      _MonthlyReflectionScreenState();
}

class _MonthlyReflectionScreenState
    extends ConsumerState<MonthlyReflectionScreen> {
  late int _selectedYear;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYear = now.year;
    _selectedMonth = now.month;
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(journalServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (service) {
              final engine = PatternEngineService(service);
              final summary =
                  engine.getMonthSummary(_selectedYear, _selectedMonth);

              return CupertinoScrollbar(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    GlassSliverAppBar(
                      title: isEn ? 'Monthly Reflection' : 'Aylık Yansıma',
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(AppConstants.spacingLg),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Month selector
                          _buildMonthSelector(context, isDark, isEn),
                          const SizedBox(height: AppConstants.spacingXl),

                          // Summary card
                          _buildSummaryCard(context, summary, isDark, isEn)
                              .animate()
                              .fadeIn(duration: 400.ms),
                          const SizedBox(height: AppConstants.spacingLg),

                          // Area breakdown
                          if (summary.averagesByArea.isNotEmpty)
                            _buildAreaBreakdown(
                              context,
                              summary,
                              isDark,
                              isEn,
                            )
                                .animate()
                                .fadeIn(delay: 100.ms, duration: 400.ms),
                          const SizedBox(height: 40),
                        ]),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSelector(BuildContext context, bool isDark, bool isEn) {
    final months = isEn
        ? [
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December',
          ]
        : [
            'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
            'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
          ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLg,
        vertical: AppConstants.spacingMd,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: AppColors.starGold.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _selectedMonth--;
                if (_selectedMonth < 1) {
                  _selectedMonth = 12;
                  _selectedYear--;
                }
              });
            },
            icon: Icon(
              Icons.chevron_left,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          Expanded(
            child: Text(
              '${months[_selectedMonth - 1]} $_selectedYear',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.starGold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              final now = DateTime.now();
              if (_selectedYear < now.year ||
                  (_selectedYear == now.year &&
                      _selectedMonth < now.month)) {
                setState(() {
                  _selectedMonth++;
                  if (_selectedMonth > 12) {
                    _selectedMonth = 1;
                    _selectedYear++;
                  }
                });
              }
            },
            icon: Icon(
              Icons.chevron_right,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    MonthlySummary summary,
    bool isDark,
    bool isEn,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          // Entry count
          Row(
            children: [
              Icon(Icons.edit_note, color: AppColors.starGold, size: 24),
              const SizedBox(width: 12),
              Text(
                isEn
                    ? '${summary.totalEntries} entries this month'
                    : 'Bu ay ${summary.totalEntries} kayıt',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          if (summary.totalEntries == 0) ...[
            const SizedBox(height: 24),
            Text(
              isEn
                  ? 'No entries for this month yet.'
                  : 'Bu ay için henüz kayıt yok.',
              style: TextStyle(
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
          ],
          if (summary.strongestArea != null) ...[
            const SizedBox(height: AppConstants.spacingLg),
            _buildHighlight(
              context,
              isDark,
              isEn ? 'Strongest area' : 'En güçlü alan',
              isEn
                  ? summary.strongestArea!.displayNameEn
                  : summary.strongestArea!.displayNameTr,
              Icons.star,
              AppColors.success,
            ),
          ],
          if (summary.weakestArea != null &&
              summary.weakestArea != summary.strongestArea) ...[
            const SizedBox(height: AppConstants.spacingMd),
            _buildHighlight(
              context,
              isDark,
              isEn ? 'Needs attention' : 'Dikkat gerektirebilir',
              isEn
                  ? summary.weakestArea!.displayNameEn
                  : summary.weakestArea!.displayNameTr,
              Icons.info_outline,
              AppColors.warning,
            ),
          ],
          const SizedBox(height: AppConstants.spacingMd),
          _buildHighlight(
            context,
            isDark,
            isEn ? 'Current streak' : 'Mevcut seri',
            isEn
                ? '${summary.currentStreak} days'
                : '${summary.currentStreak} gün',
            Icons.local_fire_department,
            AppColors.starGold,
          ),
        ],
      ),
    );
  }

  Widget _buildHighlight(
    BuildContext context,
    bool isDark,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildAreaBreakdown(
    BuildContext context,
    MonthlySummary summary,
    bool isDark,
    bool isEn,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEn ? 'Area Breakdown' : 'Alan Dağılımı',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...summary.averagesByArea.entries.map((e) {
            final label =
                isEn ? e.key.displayNameEn : e.key.displayNameTr;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: e.value / 5,
                        backgroundColor: isDark
                            ? AppColors.surfaceLight.withValues(alpha: 0.3)
                            : AppColors.lightSurfaceVariant,
                        valueColor:
                            AlwaysStoppedAnimation(AppColors.starGold),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    e.value.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.starGold,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
