// ════════════════════════════════════════════════════════════════════════════
// LIFE EVENT DETAIL SCREEN - Read-Only Life Event View
// ════════════════════════════════════════════════════════════════════════════

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../data/content/life_event_presets.dart';
import '../../../data/models/life_event.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/haptic_service.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/glass_dialog.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../data/services/l10n_service.dart';

class LifeEventDetailScreen extends ConsumerWidget {
  final String eventId;

  const LifeEventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(lifeEventServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: serviceAsync.when(
          loading: () => const Center(child: CosmicLoadingIndicator()),
          error: (_, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  L10nService.get('life_events.life_event_detail.couldnt_load_this_event', language),
                  style: AppTypography.subtitle(
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () => ref.invalidate(lifeEventServiceProvider),
                  icon: Icon(
                    Icons.refresh_rounded,
                    size: 16,
                    color: AppColors.starGold,
                  ),
                  label: Text(
                    L10nService.get('life_events.life_event_detail.retry', language),
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
          data: (service) {
            final event = service.getEvent(eventId);
            if (event == null) {
              return Center(
                child: Text(
                  L10nService.get('life_events.life_event_detail.event_not_found', language),
                  style: AppTypography.subtitle(
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              );
            }
            return _buildContent(context, ref, event, isDark, isEn);
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    LifeEvent event,
    bool isDark,
    AppLanguage language,
  ) {
    final isPositive = event.type == LifeEventType.positive;
    final accentColor = isPositive ? AppColors.starGold : AppColors.amethyst;
    final preset = event.eventKey != null
        ? LifeEventPresets.getByKey(event.eventKey!)
        : null;
    final emoji = preset?.emoji ?? (isPositive ? '\u{2728}' : '\u{1F4AD}');

    final intensityLabels = isEn
        ? ['Subtle', 'Mild', 'Moderate', 'Strong', 'Life-Changing']
        : ['Hafif', 'Az', 'Orta', 'Güçlü', 'Hayat Değiştiren'];

    final formatted =
        '${event.date.day.toString().padLeft(2, '0')}/'
        '${event.date.month.toString().padLeft(2, '0')}/'
        '${event.date.year}';

    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(
            title: L10nService.get('life_events.life_event_detail.life_event', language),
            actions: [
              IconButton(
                tooltip: L10nService.get('life_events.life_event_detail.share_event', language),
                icon: Icon(
                  Icons.share_rounded,
                  color: AppColors.starGold,
                  size: 20,
                ),
                onPressed: () {
                  HapticService.buttonPress();
                  final noteSnippet =
                      event.note != null && event.note!.isNotEmpty
                      ? '\n"${event.note!.length > 80 ? '${event.note!.substring(0, 80)}...' : event.note!}"'
                      : '';
                  final msg = isEn
                      ? '${event.title} — $formatted$noteSnippet\n\nReflecting with InnerCycles.\n${AppConstants.appStoreUrl}\n#InnerCycles #LifeEvent'
                      : '${event.title} — $formatted$noteSnippet\n\nInnerCycles ile yansıma yapıyorum.\n${AppConstants.appStoreUrl}\n#InnerCycles';
                  SharePlus.instance.share(ShareParams(text: msg));
                },
              ),
              IconButton(
                tooltip: L10nService.get('life_events.life_event_detail.edit_event', language),
                icon: Icon(
                  Icons.edit_rounded,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
                onPressed: () {
                  HapticService.buttonPress();
                  context.push(
                    Routes.lifeEventEdit.replaceFirst(':id', event.id),
                  );
                },
              ),
              IconButton(
                tooltip: L10nService.get('life_events.life_event_detail.delete_event', language),
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.error,
                ),
                onPressed: () => _confirmDelete(context, ref, event, isEn),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Photo header
                if (event.imagePath != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(event.imagePath!),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel: L10nService.get('life_events.life_event_detail.event_photo', language),
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 16),
                ],

                // Emoji + Title + Type badge
                PremiumCard(
                  style: PremiumCardStyle.gold,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      AppSymbol.hero(emoji),
                      const SizedBox(height: 12),
                      Text(
                        event.title,
                        textAlign: TextAlign.center,
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          event.type.localizedName(isEn),
                          style: AppTypography.elegantAccent(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms),
                const SizedBox(height: 16),

                // Date + Intensity row
                Row(
                  children: [
                    Expanded(
                      child: _infoCard(
                        icon: Icons.calendar_today_rounded,
                        label: L10nService.get('life_events.life_event_detail.date', language),
                        value: formatted,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _infoCard(
                        icon: Icons.speed_rounded,
                        label: L10nService.get('life_events.life_event_detail.intensity', language),
                        value:
                            intensityLabels[(event.intensity - 1).clamp(0, 4)],
                        isDark: isDark,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
                const SizedBox(height: 16),

                // Emotion tags
                if (event.emotionTags.isNotEmpty) ...[
                  PremiumCard(
                    style: PremiumCardStyle.subtle,
                    borderRadius: 14,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GradientText(
                          L10nService.get('life_events.life_event_detail.emotions', language),
                          variant: GradientTextVariant.amethyst,
                          style: AppTypography.elegantAccent(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: event.emotionTags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.auroraStart.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                tag,
                                style: AppTypography.elegantAccent(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.auroraStart,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: 150.ms),
                  const SizedBox(height: 16),
                ],

                // Reflection note
                if (event.note case final note? when note.isNotEmpty) ...[
                  PremiumCard(
                    style: PremiumCardStyle.subtle,
                    borderRadius: 14,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GradientText(
                          L10nService.get('life_events.life_event_detail.reflection', language),
                          variant: GradientTextVariant.amethyst,
                          style: AppTypography.elegantAccent(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onLongPress: () {
                            Clipboard.setData(ClipboardData(text: note));
                            HapticService.buttonPress();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(L10nService.get('life_events.life_event_detail.event_copied_to_clipboard', language)),
                                duration: const Duration(seconds: 1),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          },
                          child: Text(
                            note,
                            style: AppTypography.decorativeScript(
                              fontSize: 15,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                ],

                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      borderRadius: 12,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTypography.elegantAccent(
              fontSize: 11,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.displayFont.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    LifeEvent event,
    AppLanguage language,
  ) async {
    final confirmed = await GlassDialog.confirm(
      context,
      title: L10nService.get('life_events.life_event_detail.delete_event_1', language),
      message: L10nService.get('life_events.life_event_detail.this_life_event_will_be_permanently_dele', language),
      cancelLabel: L10nService.get('life_events.life_event_detail.cancel', language),
      confirmLabel: L10nService.get('life_events.life_event_detail.delete', language),
      isDestructive: true,
    );
    if (confirmed != true) return;
    HapticService.warning();
    final service = await ref.read(lifeEventServiceProvider.future);
    await service.deleteEvent(event.id);
    if (context.mounted) context.pop();
  }
}
