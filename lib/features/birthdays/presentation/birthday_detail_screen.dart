// ════════════════════════════════════════════════════════════════════════════
// BIRTHDAY DETAIL SCREEN - View Birthday Contact Details
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/birthday_contact.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/notification_service.dart';
import '../../../shared/widgets/birthday_avatar.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/glass_dialog.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

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
            child: Text(
              isEn ? 'Something went wrong' : 'Bir \u{015F}eyler ters gitti',
              style: TextStyle(
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
          data: (service) {
            final contact = service.getContact(contactId);
            if (contact == null) {
              return Center(
                child: Text(
                  isEn ? 'Contact not found' : 'Ki\u{015F}i bulunamad\u{0131}',
                  style: TextStyle(
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
        ? [
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December',
          ]
        : [
            'Ocak', '\u{015E}ubat', 'Mart', 'Nisan', 'May\u{0131}s', 'Haziran',
            'Temmuz', 'A\u{011F}ustos', 'Eyl\u{00FC}l', 'Ekim', 'Kas\u{0131}m', 'Aral\u{0131}k',
          ];

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        GlassSliverAppBar(
          title: contact.name,
          actions: [
            IconButton(
              icon: Icon(
                Icons.edit_rounded,
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              ),
              onPressed: () => context.push(
                Routes.birthdayEdit.replaceFirst(':id', contact.id),
              ),
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
              ).animate().fadeIn(duration: 300.ms).scale(
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
                    isEn ? '${contact.age} years old' : '${contact.age} ya\u{015F}\u{0131}nda',
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
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isEn
                          ? contact.relationship.displayNameEn
                          : contact.relationship.displayNameTr,
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
                        isEn ? 'Note' : 'Not',
                        variant: GradientTextVariant.gold,
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        contact.note!,
                        style: AppTypography.decorativeScript(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
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
                      isEn ? 'Reminders' : 'Hat\u{0131}rlat\u{0131}c\u{0131}lar',
                      variant: GradientTextVariant.gold,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _infoRow(
                      isDark,
                      icon: Icons.cake_rounded,
                      label: isEn ? 'Birthday notification' : 'Do\u{011F}um g\u{00FC}n\u{00FC} bildirimi',
                      value: contact.notificationsEnabled
                          ? (isEn ? 'On' : 'A\u{00E7}\u{0131}k')
                          : (isEn ? 'Off' : 'Kapal\u{0131}'),
                      isEnabled: contact.notificationsEnabled,
                    ),
                    const SizedBox(height: 6),
                    _infoRow(
                      isDark,
                      icon: Icons.notifications_active_rounded,
                      label: isEn ? 'Day before' : 'Bir g\u{00FC}n \u{00F6}nce',
                      value: contact.dayBeforeReminder
                          ? (isEn ? 'On' : 'A\u{00E7}\u{0131}k')
                          : (isEn ? 'Off' : 'Kapal\u{0131}'),
                      isEnabled: contact.dayBeforeReminder,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 300.ms),

              // 7. Delete button
              const SizedBox(height: 24),
              Center(
                child: TextButton.icon(
                  onPressed: () => _confirmDelete(context, ref, contact, isEn),
                  icon: Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 18),
                  label: Text(
                    isEn ? 'Delete Contact' : 'Ki\u{015F}iyi Sil',
                    style: TextStyle(
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
            style: const TextStyle(fontSize: 36),
          ),
          const SizedBox(height: 12),
          if (isToday) ...[
            GradientText(
              isEn ? 'Happy Birthday!' : 'Do\u{011F}um G\u{00FC}n\u{00FC} Kutlu Olsun!',
              variant: GradientTextVariant.gold,
              style: AppTypography.displayFont.copyWith(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ] else ...[
            Text(
              '$days',
              style: AppTypography.displayFont.copyWith(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
              ),
            ),
            Text(
              isEn ? 'days left' : 'g\u{00FC}n kald\u{0131}',
              style: AppTypography.decorativeScript(
                fontSize: 16,
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 150.ms);
  }

  Widget _infoRow(
    bool isDark, {
    required IconData icon,
    required String label,
    required String value,
    required bool isEnabled,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isEnabled ? AppColors.starGold : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTypography.subtitle(
            fontSize: 13,
            color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTypography.elegantAccent(
            fontSize: 13,
            color: isEnabled
                ? AppColors.starGold
                : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
          ),
        ),
      ],
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    BirthdayContact contact,
    bool isEn,
  ) {
    GlassDialog.confirm(
      context,
      title: isEn ? 'Delete Contact' : 'Ki\u{015F}iyi Sil',
      message: isEn
          ? 'Are you sure you want to delete ${contact.name}?'
          : '${contact.name} ki\u{015F}isini silmek istedi\u{011F}inizden emin misiniz?',
      cancelLabel: isEn ? 'Cancel' : '\u{0130}ptal',
      confirmLabel: isEn ? 'Delete' : 'Sil',
      isDestructive: true,
      onConfirm: () async {
        final service =
            await ref.read(birthdayContactServiceProvider.future);
        await service.deleteContact(contact.id);
        await NotificationService().cancelBirthdayNotification(contact.id);
        ref.invalidate(birthdayContactServiceProvider);
        if (context.mounted) context.pop();
      },
    );
  }
}
