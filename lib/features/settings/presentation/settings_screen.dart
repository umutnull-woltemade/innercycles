import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';

import '../../../data/services/notification_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/services/url_launcher_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../data/services/paywall_service.dart';
import '../../../data/services/app_lock_service.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';
import 'notification_settings_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPremium = ref.watch(isPremiumUserProvider);
    final urlLauncher = ref.read(urlLauncherServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CupertinoScrollbar(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                GlassSliverAppBar(
                  title: language == AppLanguage.en ? 'Settings' : 'Ayarlar',
                  largeTitleMode: true,
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // ═══ APPEARANCE SECTION ═══
                      _SectionHeader(
                        title: (language == AppLanguage.en ? 'Theme' : 'Tema')
                            .toUpperCase(),
                        isDark: isDark,
                      ),
                      _GroupedContainer(
                        isDark: isDark,
                        child: Row(
                          children: [
                            Expanded(
                              child: _ThemeOption(
                                label: language == AppLanguage.en
                                    ? 'Light'
                                    : 'Açık',
                                icon: Icons.light_mode,
                                isSelected: themeMode == ThemeMode.light,
                                isDark: isDark,
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  ref.read(themeModeProvider.notifier).state =
                                      ThemeMode.light;
                                  StorageService.saveThemeMode(ThemeMode.light);
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _ThemeOption(
                                label: language == AppLanguage.en
                                    ? 'Dark'
                                    : 'Koyu',
                                icon: Icons.dark_mode,
                                isSelected: themeMode == ThemeMode.dark,
                                isDark: isDark,
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  ref.read(themeModeProvider.notifier).state =
                                      ThemeMode.dark;
                                  StorageService.saveThemeMode(ThemeMode.dark);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 35),

                      // ═══ LANGUAGE SECTION ═══
                      _SectionHeader(
                        title: (language == AppLanguage.en ? 'Language' : 'Dil')
                            .toUpperCase(),
                        isDark: isDark,
                      ),
                      _GroupedContainer(
                        isDark: isDark,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: AppLanguage.values.map((lang) {
                              final isSelected = lang == language;
                              final isAvailable = lang.hasStrictIsolation;
                              return Semantics(
                                label: lang.displayName,
                                button: true,
                                selected: isSelected,
                                enabled: isAvailable,
                                child: GestureDetector(
                                  onTap: () {
                                    if (isAvailable) {
                                      HapticFeedback.selectionClick();
                                      ref
                                              .read(languageProvider.notifier)
                                              .state =
                                          lang;
                                      StorageService.saveLanguage(lang);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            L10nService.get(
                                              'settings.coming_soon_language',
                                              language,
                                            ),
                                          ),
                                          duration: const Duration(seconds: 2),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  },
                                  child: Opacity(
                                    opacity: isAvailable ? 1.0 : 0.5,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.auroraStart.withValues(
                                                alpha: 0.2,
                                              )
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.auroraStart
                                              : Colors.transparent,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            lang.flag,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            lang.displayName,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: isSelected
                                                  ? AppColors.auroraStart
                                                  : (isDark
                                                        ? AppColors.textPrimary
                                                        : AppColors
                                                              .lightTextPrimary),
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                          if (isSelected) ...[
                                            const SizedBox(width: 4),
                                            Icon(
                                              Icons.check_circle,
                                              size: 14,
                                              color: AppColors.auroraStart,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),

                      // ═══ ACCOUNT SECTION ═══
                      _SectionHeader(
                        title: L10nService.get(
                          'settings.account',
                          language,
                        ).toUpperCase(),
                        isDark: isDark,
                      ),
                      _GroupedContainer(
                        isDark: isDark,
                        noPadding: true,
                        child: Column(
                          children: [
                            _GroupedTile(
                              icon: Icons.account_circle_outlined,
                              title: L10nService.get(
                                'settings.edit_profile',
                                language,
                              ),
                              isDark: isDark,
                              onTap: () => context.push(Routes.profile),
                            ),
                            _GroupedSeparator(isDark: isDark),
                            _GroupedTile(
                              icon: Icons.workspace_premium_outlined,
                              title: L10nService.get(
                                'settings.premium',
                                language,
                              ),
                              isDark: isDark,
                              onTap: () => isPremium
                                  ? context.push(Routes.premium)
                                  : showContextualPaywall(
                                      context,
                                      ref,
                                      paywallContext: PaywallContext.general,
                                    ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  gradient: isPremium
                                      ? LinearGradient(
                                          colors: [
                                            AppColors.success,
                                            AppColors.success.withValues(
                                              alpha: 0.8,
                                            ),
                                          ],
                                        )
                                      : AppColors.goldGradient,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isPremium ? '✓ PRO' : 'PRO',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isPremium
                                        ? Colors.white
                                        : AppColors.deepSpace,
                                  ),
                                ),
                              ),
                            ),
                            if (isPremium) ...[
                              _GroupedSeparator(isDark: isDark),
                              _GroupedTile(
                                icon: Icons.credit_card_outlined,
                                title: L10nService.get(
                                  'settings.manage_subscription',
                                  language,
                                ),
                                isDark: isDark,
                                onTap: () async {
                                  await ref
                                      .read(paywallServiceProvider)
                                      .presentCustomerCenter();
                                },
                              ),
                            ],
                            _GroupedSeparator(isDark: isDark),
                            _GroupedTile(
                              icon: Icons.restore,
                              title: language == AppLanguage.en
                                  ? 'Restore Purchases'
                                  : 'Satın Alımları Geri Yükle',
                              isDark: isDark,
                              onTap: () async {
                                final restored = await ref
                                    .read(premiumProvider.notifier)
                                    .restorePurchases();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        restored
                                            ? (language == AppLanguage.en
                                                ? 'Purchases restored'
                                                : 'Satın alımlar geri yüklendi')
                                            : (language == AppLanguage.en
                                                ? 'No purchases found'
                                                : 'Satın alım bulunamadı'),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            _GroupedSeparator(isDark: isDark),
                            _GroupedTile(
                              icon: Icons.delete_outline,
                              title: L10nService.get(
                                'settings.clear_data',
                                language,
                              ),
                              isDark: isDark,
                              isDestructive: true,
                              onTap: () =>
                                  _showClearDataDialog(context, ref, language),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 35),

                      // ═══ SHARE & EARN SECTION ═══
                      if (!isPremium) ...[
                        _SectionHeader(
                          title:
                              (language == AppLanguage.en
                                      ? 'Share & Earn'
                                      : 'Paylaş ve Kazan')
                                  .toUpperCase(),
                          isDark: isDark,
                        ),
                        _ReferralCard(isDark: isDark, language: language),
                        const SizedBox(height: 35),
                      ],

                      // ═══ FEATURES SECTION ═══
                      _SectionHeader(
                        title:
                            (language == AppLanguage.en
                                    ? 'Features'
                                    : 'Özellikler')
                                .toUpperCase(),
                        isDark: isDark,
                      ),
                      _GroupedContainer(
                        isDark: isDark,
                        noPadding: true,
                        child: Column(
                          children: [
                            _GroupedTile(
                              icon: Icons.air_outlined,
                              title: language == AppLanguage.en
                                  ? 'Breathing Exercises'
                                  : 'Nefes Egzersizleri',
                              isDark: isDark,
                              onTap: () => context.push(Routes.breathing),
                            ),
                            _GroupedSeparator(isDark: isDark),
                            _GroupedTile(
                              icon: Icons.self_improvement_outlined,
                              title: language == AppLanguage.en
                                  ? 'Meditation Timer'
                                  : 'Meditasyon Zamanlayıcı',
                              isDark: isDark,
                              onTap: () => context.push(Routes.meditation),
                            ),
                            _GroupedSeparator(isDark: isDark),
                            _GroupedTile(
                              icon: Icons.file_download_outlined,
                              title: language == AppLanguage.en
                                  ? 'Export Data'
                                  : 'Verileri Dışa Aktar',
                              isDark: isDark,
                              onTap: () => context.push(Routes.exportData),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 35),

                      // ═══ NOTIFICATIONS SECTION ═══
                      _SectionHeader(
                        title: L10nService.get(
                          'settings.notifications_title',
                          language,
                        ).toUpperCase(),
                        isDark: isDark,
                      ),
                      const NotificationSettingsSection(),
                      const SizedBox(height: 35),

                      // ═══ PRIVACY & SECURITY SECTION ═══
                      _SectionHeader(
                        title:
                            (language == AppLanguage.en
                                    ? 'Privacy & Security'
                                    : 'Gizlilik ve Güvenlik')
                                .toUpperCase(),
                        isDark: isDark,
                      ),
                      _AppLockSection(isDark: isDark, language: language),
                      const SizedBox(height: 35),

                      // ═══ ABOUT SECTION ═══
                      _SectionHeader(
                        title: L10nService.get(
                          'settings.about',
                          language,
                        ).toUpperCase(),
                        isDark: isDark,
                      ),
                      _GroupedContainer(
                        isDark: isDark,
                        noPadding: true,
                        child: Column(
                          children: [
                            _GroupedTile(
                              icon: Icons.star_outline,
                              title: L10nService.get(
                                'settings.rate_app',
                                language,
                              ),
                              isDark: isDark,
                              onTap: () async {
                                await urlLauncher.requestAppReview();
                              },
                            ),
                            _GroupedSeparator(isDark: isDark),
                            _GroupedTile(
                              icon: Icons.gavel_outlined,
                              title: L10nService.get(
                                'settings.disclaimer',
                                language,
                              ),
                              isDark: isDark,
                              onTap: () => _showDisclaimerDialog(
                                context,
                                language,
                                isDark,
                              ),
                            ),
                            _GroupedSeparator(isDark: isDark),
                            _GroupedTile(
                              icon: Icons.privacy_tip_outlined,
                              title: L10nService.get(
                                'settings.privacy_policy',
                                language,
                              ),
                              isDark: isDark,
                              onTap: () async {
                                await urlLauncher.openPrivacyPolicy();
                              },
                            ),
                            _GroupedSeparator(isDark: isDark),
                            _GroupedTile(
                              icon: Icons.description_outlined,
                              title: L10nService.get(
                                'settings.terms_of_service',
                                language,
                              ),
                              isDark: isDark,
                              onTap: () async {
                                await urlLauncher.openTermsOfService();
                              },
                            ),
                            _GroupedSeparator(isDark: isDark),
                            _GroupedTile(
                              icon: Icons.mail_outline,
                              title: L10nService.get(
                                'settings.contact_support',
                                language,
                              ),
                              isDark: isDark,
                              onTap: () async {
                                await urlLauncher.openSupportEmail(
                                  subject: language == AppLanguage.en
                                      ? 'Support Request'
                                      : 'Destek Talebi',
                                  body: '\n\n---\nApp Version: 1.0.0',
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          L10nService.get('settings.version', language),
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),

                      // ═══ ADMIN SECTION (debug only) ═══
                      if (kDebugMode) ...[
                        _GroupedContainer(
                          isDark: isDark,
                          noPadding: true,
                          child: _GroupedTile(
                            icon: Icons.admin_panel_settings,
                            title: L10nService.get('settings.admin', language),
                            isDark: isDark,
                            onTap: () => context.push(Routes.adminLogin),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.starGold,
                                    AppColors.celestialGold,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                L10nService.get('settings.pin', language),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.deepSpace,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 40),
                    ]),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.02, duration: 400.ms),
          ),
        ),
      ),
    );
  }

  void _showClearDataDialog(
    BuildContext context,
    WidgetRef ref,
    AppLanguage language,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.surfaceDark
            : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(
          L10nService.get('settings.clear_data_confirm', language),
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
        content: Text(
          L10nService.get('settings.clear_data_warning', language),
          style: TextStyle(
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              language == AppLanguage.en ? 'Cancel' : 'İptal',
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);
              // Cancel scheduled notifications
              try {
                await NotificationService().cancelAll();
              } catch (e) {
                if (kDebugMode) debugPrint('Cancel notifications failed: $e');
              }
              await StorageService.clearAllData();
              if (!context.mounted) return;
              ref.read(userProfileProvider.notifier).clearProfile();
              ref.read(onboardingCompleteProvider.notifier).state = false;
              if (context.mounted) {
                context.go(Routes.onboarding);
              }
            },
            child: Text(
              L10nService.get('settings.delete', language),
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showDisclaimerDialog(
    BuildContext context,
    AppLanguage language,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.surfaceDark
            : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.starGold),
            const SizedBox(width: 12),
            Text(
              L10nService.get('settings.disclaimer', language),
              style: TextStyle(
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                L10nService.get('settings.disclaimer_content', language),
                style: TextStyle(
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.starGold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.starGold.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: AppColors.starGold,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        L10nService.get('settings.disclaimer_tip', language),
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              language == AppLanguage.en ? 'OK' : 'Tamam',
              style: TextStyle(color: AppColors.starGold),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// iOS GROUPED LIST COMPONENTS
// ══════════════════════════════════════════════════════════════════════════════

/// iOS-style section header (13pt uppercase, secondaryLabel color)
class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SectionHeader({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          letterSpacing: -0.08,
        ),
      ),
    );
  }
}

/// iOS-style .insetGrouped container (10pt radius, proper background)
class _GroupedContainer extends StatelessWidget {
  final bool isDark;
  final Widget child;
  final bool noPadding;

  const _GroupedContainer({
    required this.isDark,
    required this.child,
    this.noPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      elevation: GlassElevation.g2,
      borderRadius: BorderRadius.circular(10),
      padding: noPadding ? EdgeInsets.zero : const EdgeInsets.all(16),
      child: child,
    );
  }
}

/// iOS-style 0.33pt separator with leading inset
class _GroupedSeparator extends StatelessWidget {
  final bool isDark;

  const _GroupedSeparator({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 60),
      height: 0.33,
      color: isDark
          ? Colors.white.withValues(alpha: 0.15)
          : Colors.black.withValues(alpha: 0.1),
    );
  }
}

/// iOS-style grouped list row (44pt minimum height, disclosure chevron)
class _GroupedTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDark;
  final bool isDestructive;
  final Widget? trailing;
  final VoidCallback onTap;

  const _GroupedTile({
    required this.icon,
    required this.title,
    required this.isDark,
    this.isDestructive = false,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDestructive
        ? AppColors.error
        : (isDark ? AppColors.textPrimary : AppColors.lightTextPrimary);
    final iconColor = isDestructive
        ? AppColors.error
        : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary);

    return Semantics(
      label: title,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 17, color: textColor),
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  trailing!,
                  const SizedBox(width: 4),
                ],
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: isDark
                      ? AppColors.textMuted.withValues(alpha: 0.5)
                      : AppColors.lightTextMuted.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Theme selection option within grouped container
class _ThemeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.auroraStart.withValues(alpha: 0.15)
                : (isDark
                      ? AppColors.surfaceLight.withValues(alpha: 0.2)
                      : AppColors.lightSurfaceVariant),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppColors.auroraStart.withValues(alpha: 0.6)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AppColors.starGold
                    : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                size: 28,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isSelected
                      ? (isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary)
                      : (isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Referral card — share app to earn premium trial
class _ReferralCard extends ConsumerWidget {
  final bool isDark;
  final AppLanguage language;

  const _ReferralCard({required this.isDark, required this.language});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final referralAsync = ref.watch(referralServiceProvider);

    return referralAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        final status = service.getStatus(language);
        final isEn = language == AppLanguage.en;

        return _GroupedContainer(
          isDark: isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    status.isUnlocked
                        ? Icons.card_giftcard
                        : Icons.share_outlined,
                    color: AppColors.starGold,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          status.headline,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          status.subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: status.progress,
                  minHeight: 6,
                  backgroundColor: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.08),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    status.isUnlocked ? AppColors.success : AppColors.starGold,
                  ),
                ),
              ),
              if (!status.isUnlocked && !status.isExpired) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      final unlocked = await service.shareApp(
                        language: language,
                      );
                      if (unlocked && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isEn
                                  ? 'Premium trial unlocked for 7 days!'
                                  : 'Premium deneme 7 gün için açıldı!',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                      // Refresh the provider
                      ref.invalidate(referralServiceProvider);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.starGold.withValues(
                        alpha: 0.15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isEn ? 'Share InnerCycles' : 'InnerCycles\'ı Paylaş',
                      style: TextStyle(
                        color: AppColors.starGold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// App Lock toggle section
class _AppLockSection extends ConsumerStatefulWidget {
  final bool isDark;
  final AppLanguage language;

  const _AppLockSection({required this.isDark, required this.language});

  @override
  ConsumerState<_AppLockSection> createState() => _AppLockSectionState();
}

class _AppLockSectionState extends ConsumerState<_AppLockSection> {
  @override
  Widget build(BuildContext context) {
    final lockAsync = ref.watch(appLockServiceProvider);
    final isEn = widget.language == AppLanguage.en;

    return lockAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        final isEnabled = service.isEnabled;

        return _GroupedContainer(
          isDark: widget.isDark,
          noPadding: true,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      color: widget.isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                      size: 22,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEn ? 'App Lock' : 'Uygulama Kilidi',
                            style: TextStyle(
                              fontSize: 17,
                              color: widget.isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          Text(
                            isEn
                                ? 'Require PIN or biometrics to open'
                                : 'Açmak için PIN veya biyometrik gerekli',
                            style: TextStyle(
                              fontSize: 13,
                              color: widget.isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CupertinoSwitch(
                      value: isEnabled,
                      activeTrackColor: AppColors.auroraStart,
                      onChanged: (value) async {
                        if (value) {
                          _showPinSetup(service);
                        } else {
                          await service.setEnabled(false);
                          await service.removePin();
                          if (!mounted) return;
                          ref.invalidate(appLockServiceProvider);
                        }
                      },
                    ),
                  ],
                ),
              ),
              if (isEnabled) ...[
                _GroupedSeparator(isDark: widget.isDark),
                Semantics(
                  label: isEn ? 'Change PIN' : 'PIN Değiştir',
                  button: true,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _showPinSetup(service),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.pin_outlined,
                            color: widget.isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary,
                            size: 22,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              isEn ? 'Change PIN' : 'PIN Değiştir',
                              style: TextStyle(
                                fontSize: 17,
                                color: widget.isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 20,
                            color: widget.isDark
                                ? AppColors.textMuted.withValues(alpha: 0.5)
                                : AppColors.lightTextMuted.withValues(
                                    alpha: 0.5,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showPinSetup(AppLockService service) {
    final isEn = widget.language == AppLanguage.en;
    final controller = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.isDark
            ? AppColors.surfaceDark
            : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(
          isEn ? 'Set 4-Digit PIN' : '4 Haneli PIN Belirle',
          style: TextStyle(
            color: widget.isDark
                ? AppColors.textPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              style: TextStyle(
                color: widget.isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
              decoration: InputDecoration(
                labelText: isEn ? 'PIN' : 'PIN',
                labelStyle: TextStyle(
                  color: widget.isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ),
            TextField(
              controller: confirmController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              style: TextStyle(
                color: widget.isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
              decoration: InputDecoration(
                labelText: isEn ? 'Confirm PIN' : 'PIN Onayla',
                labelStyle: TextStyle(
                  color: widget.isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              isEn ? 'Cancel' : 'İptal',
              style: TextStyle(
                color: widget.isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final pin = controller.text;
              final confirm = confirmController.text;

              if (pin.length != 4) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEn ? 'PIN must be 4 digits' : 'PIN 4 haneli olmalı',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              if (pin != confirm) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEn ? 'PINs do not match' : 'PIN\'ler eşleşmiyor',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              await service.setPin(pin);
              await service.setEnabled(true);
              if (!mounted) return;
              ref.invalidate(appLockServiceProvider);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text(
              isEn ? 'Save' : 'Kaydet',
              style: TextStyle(color: AppColors.starGold),
            ),
          ),
        ],
      ),
    ).then((_) {
      controller.dispose();
      confirmController.dispose();
    });
  }
}
