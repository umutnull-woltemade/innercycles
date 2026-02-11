import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';

class EntryDetailScreen extends ConsumerWidget {
  final String entryId;

  const EntryDetailScreen({super.key, required this.entryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              final entry = service.getEntry(entryId);
              if (entry == null) {
                return Center(
                  child: Text(
                    isEn ? 'Entry not found' : 'Kayıt bulunamadı',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                );
              }
              return _buildContent(context, ref, entry, isDark, isEn);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    JournalEntry entry,
    bool isDark,
    bool isEn,
  ) {
    final areaLabel =
        isEn ? entry.focusArea.displayNameEn : entry.focusArea.displayNameTr;
    final names = isEn
        ? entry.focusArea.subRatingNamesEn
        : entry.focusArea.subRatingNamesTr;
    final dateStr =
        '${entry.date.day}.${entry.date.month}.${entry.date.year}';

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          pinned: true,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          title: Text(
            dateStr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.starGold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => _confirmDelete(context, ref, entry.id, isEn),
              icon: Icon(Icons.delete_outline, color: AppColors.error),
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Focus area & rating header
              _buildHeaderCard(context, areaLabel, entry, isDark)
                  .animate()
                  .fadeIn(duration: 300.ms),
              const SizedBox(height: AppConstants.spacingLg),

              // Sub-ratings
              if (entry.subRatings.isNotEmpty)
                _buildSubRatingsCard(context, names, entry, isDark)
                    .animate()
                    .fadeIn(delay: 100.ms, duration: 300.ms),
              if (entry.subRatings.isNotEmpty)
                const SizedBox(height: AppConstants.spacingLg),

              // Note
              if (entry.note != null && entry.note!.isNotEmpty)
                _buildNoteCard(context, entry.note!, isDark, isEn)
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 300.ms),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    String areaLabel,
    JournalEntry entry,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.7)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: AppColors.starGold.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            areaLabel,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.starGold,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final filled = i < entry.overallRating;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  filled ? Icons.circle : Icons.circle_outlined,
                  color: filled
                      ? AppColors.starGold
                      : (isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted),
                  size: 24,
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            '${entry.overallRating}/5',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubRatingsCard(
    BuildContext context,
    Map<String, String> names,
    JournalEntry entry,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.7)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: entry.subRatings.entries.map((e) {
          final label = names[e.key] ?? e.key;
          final value = e.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 120,
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
                      value: value / 5.0,
                      backgroundColor: isDark
                          ? AppColors.surfaceLight.withValues(alpha: 0.3)
                          : AppColors.lightSurfaceVariant,
                      valueColor: AlwaysStoppedAnimation(AppColors.starGold),
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$value',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.starGold,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNoteCard(
    BuildContext context,
    String note,
    bool isDark,
    bool isEn,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.7)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEn ? 'Notes' : 'Notlar',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            note,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String id,
    bool isEn,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEn ? 'Delete Entry?' : 'Kaydı Sil?'),
        content: Text(
          isEn
              ? 'This action cannot be undone.'
              : 'Bu işlem geri alınamaz.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isEn ? 'Cancel' : 'İptal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final service = await ref.read(journalServiceProvider.future);
              await service.deleteEntry(id);
              ref.invalidate(todayJournalEntryProvider);
              ref.invalidate(journalStreakProvider);
              if (context.mounted) context.pop();
            },
            child: Text(
              isEn ? 'Delete' : 'Sil',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
