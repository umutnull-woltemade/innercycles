// ════════════════════════════════════════════════════════════════════════════
// BIRTHDAY DETAIL SCREEN - View Birthday Contact Details
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/common_strings.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/birthday_contact.dart';
import '../../../data/providers/app_providers.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import '../../../data/services/haptic_service.dart';
import '../../../data/services/notification_service.dart';
import 'package:share_plus/share_plus.dart';
import '../../../shared/widgets/birthday_avatar.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/glass_dialog.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../data/services/l10n_service.dart';

class BirthdayDetailScreen extends ConsumerWidget {
  final String contactId;

  const BirthdayDetailScreen({super.key, required this.contactId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(birthdayContactServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: serviceAsync.when(
          loading: () => const Center(child: CosmicLoadingIndicator()),
          error: (_, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  L10nService.get('birthdays.birthday_detail.couldnt_load_this_contact', language),
                  style: AppTypography.subtitle(
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () =>
                      ref.invalidate(birthdayContactServiceProvider),
                  icon: Icon(
                    Icons.refresh_rounded,
                    size: 16,
                    color: AppColors.starGold,
                  ),
                  label: Text(
                    L10nService.get('birthdays.birthday_detail.retry', language),
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
            final contact = service.getContact(contactId);
            if (contact == null) {
              return Center(
                child: Text(
                  L10nService.get('birthdays.birthday_detail.contact_not_found', language),
                  style: AppTypography.subtitle(
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              );
            }
            return _buildContent(context, ref, contact, isDark, isEn);
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    BirthdayContact contact,
    bool isDark,
    bool isEn,
  ) {
    final monthNames = isEn
        ? CommonStrings.monthsFullEn
        : CommonStrings.monthsFullTr;

    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(
            title: contact.name,
            actions: [
              IconButton(
                tooltip: L10nService.get('birthdays.birthday_detail.share_birthday', isEn ? AppLanguage.en : AppLanguage.tr),
                icon: Icon(
                  Icons.share_rounded,
                  color: AppColors.starGold,
                  size: 20,
                ),
                onPressed: () {
                  HapticService.buttonPress();
                  final dateStr =
                      '${monthNames[contact.birthdayMonth - 1]} ${contact.birthdayDay}';
                  final msg = isEn
                      ? '${contact.name}\'s birthday is on $dateStr! \u{1F382}\n\nNever miss a birthday with InnerCycles.\n${AppConstants.appStoreUrl}\n#InnerCycles'
                      : '${contact.name} doğum günü: $dateStr! \u{1F382}\n\nInnerCycles ile hiçbir doğum gününü kaçırma.\n${AppConstants.appStoreUrl}\n#InnerCycles';
                  SharePlus.instance.share(ShareParams(text: msg));
                },
              ),
              IconButton(
                tooltip: L10nService.get('birthdays.birthday_detail.edit_birthday', isEn ? AppLanguage.en : AppLanguage.tr),
                icon: Icon(
                  Icons.edit_rounded,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
                onPressed: () {
                  HapticService.buttonPress();
                  context.push(
                    Routes.birthdayEdit.replaceFirst(':id', contact.id),
                  );
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // 1. Photo Hero
                Center(
                      child: BirthdayAvatar(
                        photoPath: contact.photoPath,
                        name: contact.name,
                        size: 120,
                        showBirthdayCake: contact.isBirthdayToday,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .scale(
                      begin: const Offset(0.9, 0.9),
                      end: const Offset(1, 1),
                      duration: 300.ms,
                    ),
                const SizedBox(height: 16),

                // 2. Name + Age
                Center(
                  child: GradientText(
                    contact.name,
                    variant: GradientTextVariant.gold,
                    style: AppTypography.displayFont.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (contact.age != null)
                  Center(
                    child: Text(
                      isEn
                          ? '${contact.age} years old'
                          : '${contact.age} ya\u{015F}\u{0131}nda',
                      style: AppTypography.decorativeScript(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    '${monthNames[contact.birthdayMonth - 1]} ${contact.birthdayDay}'
                    '${contact.birthYear != null ? ', ${contact.birthYear}' : ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.elegantAccent(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 3. Countdown Card
                _buildCountdownCard(contact, isDark, isEn),
                const SizedBox(height: 16),

                // 4. Relationship Badge
                PremiumCard(
                  style: PremiumCardStyle.subtle,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        contact.relationship.emoji,
                        style: AppTypography.subtitle(fontSize: 24),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        contact.relationship.localizedName(isEn),
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 200.ms),

                // 5. Personal Note
                if (contact.note != null && contact.note!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  PremiumCard(
                    style: PremiumCardStyle.subtle,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GradientText(
                          L10nService.get('birthdays.birthday_detail.note', isEn ? AppLanguage.en : AppLanguage.tr),
                          variant: GradientTextVariant.gold,
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Semantics(
                          label: L10nService.get('birthdays.birthday_detail.long_press_to_copy_note', isEn ? AppLanguage.en : AppLanguage.tr),
                          child: GestureDetector(
                          onLongPress: () {
                            Clipboard.setData(
                              ClipboardData(text: contact.note!),
                            );
                            HapticService.buttonPress();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(L10nService.get('birthdays.birthday_detail.birthday_note_copied', isEn ? AppLanguage.en : AppLanguage.tr)),
                                duration: const Duration(seconds: 1),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          },
                          child: Text(
                            contact.note!,
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: 250.ms),
                ],

                // 6. Notification info
                const SizedBox(height: 16),
                PremiumCard(
                  style: PremiumCardStyle.subtle,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientText(
                        L10nService.get('birthdays.birthday_detail.reminders', isEn ? AppLanguage.en : AppLanguage.tr),
                        variant: GradientTextVariant.gold,
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _toggleRow(
                        isDark,
                        icon: Icons.cake_rounded,
                        label: L10nService.get('birthdays.birthday_detail.birthday_notification', isEn ? AppLanguage.en : AppLanguage.tr),
                        value: contact.notificationsEnabled,
                        onChanged: (v) => _updateNotificationSetting(
                          ref,
                          contact,
                          notificationsEnabled: v,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _toggleRow(
                        isDark,
                        icon: Icons.notifications_active_rounded,
                        label: L10nService.get('birthdays.birthday_detail.day_before', isEn ? AppLanguage.en : AppLanguage.tr),
                        value: contact.dayBeforeReminder,
                        onChanged: (v) => _updateNotificationSetting(
                          ref,
                          contact,
                          dayBeforeReminder: v,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 300.ms),

                // 7. Delete button
                const SizedBox(height: 24),
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      HapticService.buttonPress();
                      _confirmDelete(context, ref, contact, isEn);
                    },
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.error,
                      size: 18,
                    ),
                    label: Text(
                      L10nService.get('birthdays.birthday_detail.delete_contact', isEn ? AppLanguage.en : AppLanguage.tr),
                      style: AppTypography.modernAccent(
                        color: AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownCard(BirthdayContact contact, bool isDark, bool isEn) {
    final days = contact.daysUntilBirthday;
    final isToday = contact.isBirthdayToday;

    return PremiumCard(
      style: isToday ? PremiumCardStyle.gold : PremiumCardStyle.aurora,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            isToday ? '\u{1F389}' : '\u{1F382}',
            style: AppTypography.subtitle(fontSize: 36),
          ),
          const SizedBox(height: 12),
          if (isToday) ...[
            GradientText(
              L10nService.get('birthdays.birthday_detail.happy_birthday', isEn ? AppLanguage.en : AppLanguage.tr),
              variant: GradientTextVariant.gold,
              style: AppTypography.displayFont.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ] else ...[
            Text(
              '$days',
              style: AppTypography.displayFont.copyWith(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            Text(
              L10nService.get('birthdays.birthday_detail.days_left', isEn ? AppLanguage.en : AppLanguage.tr),
              style: AppTypography.decorativeScript(
                fontSize: 16,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 150.ms);
  }

  Widget _toggleRow(
    bool isDark, {
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: value
              ? AppColors.starGold
              : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: AppTypography.subtitle(
              fontSize: 13,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppColors.starGold,
        ),
      ],
    );
  }

  Future<void> _updateNotificationSetting(
    WidgetRef ref,
    BirthdayContact contact, {
    bool? notificationsEnabled,
    bool? dayBeforeReminder,
  }) async {
    try {
      final service = await ref.read(birthdayContactServiceProvider.future);
      final updated = contact.copyWith(
        notificationsEnabled: notificationsEnabled,
        dayBeforeReminder: dayBeforeReminder,
      );
      await service.updateContact(updated);

      if (updated.notificationsEnabled) {
        await NotificationService().scheduleBirthdayNotification(updated);
      } else {
        await NotificationService().cancelBirthdayNotification(updated.id);
      }

      ref.invalidate(birthdayContactServiceProvider);
    } catch (_) {
      // Silent — toggle will revert on next rebuild
    }
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    BirthdayContact contact,
    bool isEn,
  ) {
    GlassDialog.confirm(
      context,
      title: L10nService.get('birthdays.birthday_detail.delete_contact_1', isEn ? AppLanguage.en : AppLanguage.tr),
      message: isEn
          ? 'Are you sure you want to delete ${contact.name}?'
          : '${contact.name} ki\u{015F}isini silmek istedi\u{011F}inizden emin misiniz?',
      cancelLabel: L10nService.get('birthdays.birthday_detail.cancel', isEn ? AppLanguage.en : AppLanguage.tr),
      confirmLabel: L10nService.get('birthdays.birthday_detail.delete', isEn ? AppLanguage.en : AppLanguage.tr),
      isDestructive: true,
      onConfirm: () async {
        try {
          final service = await ref.read(birthdayContactServiceProvider.future);
          await service.deleteContact(contact.id);
          await NotificationService().cancelBirthdayNotification(contact.id);
          ref.invalidate(birthdayContactServiceProvider);
          if (context.mounted) context.pop();
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  L10nService.get('birthdays.birthday_detail.couldnt_delete_this_contact_please_try_a', isEn ? AppLanguage.en : AppLanguage.tr),
                ),
              ),
            );
          }
        }
      },
    );
  }
}
