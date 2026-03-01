import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../data/models/journal_entry.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/haptic_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/glass_dialog.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../data/services/l10n_service.dart';

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      CommonStrings.somethingWentWrong(language),
                      textAlign: TextAlign.center,
                      style: AppTypography.subtitle(
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () =>
                          ref.invalidate(journalServiceProvider),
                      icon: Icon(
                        Icons.refresh_rounded,
                        size: 16,
                        color: AppColors.starGold,
                      ),
                      label: Text(
                        L10nService.get('journal.entry_detail.retry', language),
                        style: AppTypography.elegantAccent(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.starGold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            data: (service) {
              final entry = service.getEntry(entryId);
              if (entry == null) {
                return Center(
                  child: Text(
                    L10nService.get('journal.entry_detail.entry_not_found', language),
                    style: AppTypography.subtitle(
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
    final language = AppLanguage.fromIsEn(isEn);
    final areaLabel = entry.focusArea.localizedName(isEn);
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
                onPressed: () {
                  HapticService.buttonPress();
                  final stars = '★' * entry.overallRating +
                      '☆' * (5 - entry.overallRating);
                  final noteSnippet = entry.note != null && entry.note!.isNotEmpty
                      ? '\n"${entry.note!.length > 100 ? '${entry.note!.substring(0, 100)}...' : entry.note!}"'
                      : '';
                  final msg = isEn
                      ? '$areaLabel — $stars$noteSnippet\n\nReflecting with InnerCycles.\n${AppConstants.appStoreUrl}\n#InnerCycles #Journaling'
                      : '$areaLabel — $stars$noteSnippet\n\nInnerCycles ile yansıma yapıyorum.\n${AppConstants.appStoreUrl}\n#InnerCycles';
                  SharePlus.instance.share(ShareParams(text: msg));
                },
                tooltip: L10nService.get('journal.entry_detail.share_entry', language),
                icon: Icon(
                  Icons.share_rounded,
                  color: AppColors.starGold,
                  size: 20,
                ),
              ),
              IconButton(
                onPressed: () => _confirmDelete(context, ref, entry.id, isEn),
                tooltip: L10nService.get('journal.entry_detail.delete_entry', language),
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
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
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
          GradientText(
            areaLabel,
            variant: GradientTextVariant.gold,
            style: AppTypography.displayFont.copyWith(
              fontSize: 28,
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
            style: AppTypography.displayFont.copyWith(
              fontSize: 22,
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
                        style: AppTypography.subtitle(
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
                    style: AppTypography.modernAccent(
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
    final language = AppLanguage.fromIsEn(isEn);
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
          semanticLabel: L10nService.get('journal.entry_detail.journal_entry_photo', language),
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
    final language = AppLanguage.fromIsEn(isEn);
    return GlassPanel(
      elevation: GlassElevation.g2,
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            (L10nService.get('journal.entry_detail.notes', language)).toUpperCase(),
            variant: GradientTextVariant.gold,
            style: AppTypography.elegantAccent(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          GestureDetector(
            onLongPress: () {
              final language = AppLanguage.fromIsEn(isEn);
              Clipboard.setData(ClipboardData(text: note));
              HapticService.buttonPress();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(L10nService.get('journal.entry_detail.entry_copied_to_clipboard', language)),
                  duration: const Duration(seconds: 1),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text(
              note,
              style: AppTypography.decorativeScript(
                fontSize: 17,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String id,
    bool isEn,
  ) async {
    final language = AppLanguage.fromIsEn(isEn);
    final confirmed = await GlassDialog.confirm(
      context,
      title: L10nService.get('journal.entry_detail.delete_entry_1', language),
      message: L10nService.get('journal.entry_detail.this_journal_entry_will_be_permanently_d', language),
      cancelLabel: L10nService.get('journal.entry_detail.cancel', language),
      confirmLabel: L10nService.get('journal.entry_detail.delete', language),
      isDestructive: true,
    );
    if (confirmed != true) return;
    HapticFeedback.heavyImpact();
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
  }
}
