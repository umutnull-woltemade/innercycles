import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../data/models/journal_entry.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

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
            loading: () => const CosmicLoadingIndicator(),
            error: (_, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  CommonStrings.somethingWentWrong(language),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ),
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
    final areaLabel = isEn
        ? entry.focusArea.displayNameEn
        : entry.focusArea.displayNameTr;
    final names = isEn
        ? entry.focusArea.subRatingNamesEn
        : entry.focusArea.subRatingNamesTr;
    final dateStr = '${entry.date.day}.${entry.date.month}.${entry.date.year}';

    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(
            title: dateStr,
            actions: [
              IconButton(
                onPressed: () => _confirmDelete(context, ref, entry.id, isEn),
                tooltip: isEn ? 'Delete entry' : 'Kaydı sil',
                icon: Icon(Icons.delete_outline, color: AppColors.error),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Focus area & rating header
                _buildHeaderCard(
                  context,
                  areaLabel,
                  entry,
                  isDark,
                ).glassReveal(context: context),
                const SizedBox(height: AppConstants.spacingLg),

                // Sub-ratings
                if (entry.subRatings.isNotEmpty)
                  _buildSubRatingsCard(
                    context,
                    names,
                    entry,
                    isDark,
                    isEn: isEn,
                  ).glassListItem(context: context, index: 1),
                if (entry.subRatings.isNotEmpty)
                  const SizedBox(height: AppConstants.spacingLg),

                // Photo
                if (!kIsWeb &&
                    entry.imagePath != null &&
                    entry.imagePath!.isNotEmpty)
                  _buildPhotoCard(
                    context,
                    entry.imagePath!,
                    isDark,
                    isEn,
                  ).glassListItem(context: context, index: 2),

                // Note
                if (entry.note != null && entry.note!.isNotEmpty)
                  _buildNoteCard(
                    context,
                    entry.note!,
                    isDark,
                    isEn,
                  ).glassListItem(context: context, index: 3),
              ]),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, duration: 400.ms);
  }

  Widget _buildHeaderCard(
    BuildContext context,
    String areaLabel,
    JournalEntry entry,
    bool isDark,
  ) {
    return GlassPanel(
      elevation: GlassElevation.g3,
      glowColor: AppColors.starGold.withValues(alpha: 0.3),
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
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
    bool isDark, {
    bool isEn = true,
  }) {
    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: entry.subRatings.entries.map((e) {
          final label = names[e.key] ?? e.key;
          final value = e.value;
          return Semantics(
            label: isEn
                ? '$label: $value out of 5'
                : '$label: 5 üzerinden $value',
            child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  child: ExcludeSemantics(
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
          ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPhotoCard(
    BuildContext context,
    String imagePath,
    bool isDark,
    bool isEn,
  ) {
    final file = File(imagePath);
    try {
      if (!file.existsSync()) return const SizedBox.shrink();
    } catch (e) {
      if (kDebugMode) debugPrint('EntryDetail: photo file check error: $e');
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingLg),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        child: Image.file(
          file,
          width: double.infinity,
          fit: BoxFit.cover,
          cacheWidth: 800,
          semanticLabel: isEn
              ? 'Journal entry photo'
              : 'Günlük kaydı fotoğrafı',
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _buildNoteCard(
    BuildContext context,
    String note,
    bool isDark,
    bool isEn,
  ) {
    return GlassPanel(
      elevation: GlassElevation.g2,
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
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
          isEn ? 'This action cannot be undone.' : 'Bu işlem geri alınamaz.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isEn ? 'Cancel' : 'İptal'),
          ),
          TextButton(
            onPressed: () async {
              HapticFeedback.heavyImpact();
              Navigator.pop(ctx);
              try {
                final service = await ref.read(journalServiceProvider.future);
                await service.deleteEntry(id);
                if (!context.mounted) return;
                ref.invalidate(todayJournalEntryProvider);
                ref.invalidate(journalStreakProvider);
              } catch (e) {
                if (kDebugMode) debugPrint('Failed to delete entry: $e');
              }
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
