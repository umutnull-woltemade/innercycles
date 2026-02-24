// ════════════════════════════════════════════════════════════════════════════
// LIFE EVENT DETAIL SCREEN - Read-Only Life Event View
// ════════════════════════════════════════════════════════════════════════════

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
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
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(
            child: Text(
              isEn ? 'Something went wrong' : 'Bir şeyler ters gitti',
              style: TextStyle(
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
          data: (service) {
            final event = service.getEvent(eventId);
            if (event == null) {
              return Center(
                child: Text(
                  isEn ? 'Event not found' : 'Olay bulunamadı',
                  style: TextStyle(
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
    bool isEn,
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

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        GlassSliverAppBar(
          title: isEn ? 'Life Event' : 'Yaşam Olayı',
          actions: [
            IconButton(
              icon: Icon(
                Icons.edit_rounded,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
              onPressed: () => context.push(
                Routes.lifeEventEdit.replaceFirst(':id', event.id),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: AppColors.error),
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
                      style: TextStyle(
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
                        isEn
                            ? event.type.displayNameEn
                            : event.type.displayNameTr,
                        style: TextStyle(
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
                      label: isEn ? 'Date' : 'Tarih',
                      value: formatted,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _infoCard(
                      icon: Icons.speed_rounded,
                      label: isEn ? 'Intensity' : 'Yoğunluk',
                      value: intensityLabels[
                          (event.intensity - 1).clamp(0, 4)],
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
                        isEn ? 'Emotions' : 'Duygular',
                        variant: GradientTextVariant.amethyst,
                        style: const TextStyle(
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
                              color: AppColors.auroraStart
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
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
                        isEn ? 'Reflection' : 'Düşünceler',
                        variant: GradientTextVariant.amethyst,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        note,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
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
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
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
    bool isEn,
  ) async {
    final confirmed = await GlassDialog.confirm(
      context,
      title: isEn ? 'Delete Event?' : 'Olayı Sil?',
      message: isEn ? 'This action cannot be undone.' : 'Bu işlem geri alınamaz.',
      cancelLabel: isEn ? 'Cancel' : 'İptal',
      confirmLabel: isEn ? 'Delete' : 'Sil',
      isDestructive: true,
    );
    if (confirmed != true) return;
    HapticService.warning();
    final service = await ref.read(lifeEventServiceProvider.future);
    await service.deleteEvent(event.id);
    if (context.mounted) context.pop();
  }
}
