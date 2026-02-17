import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/localization_service.dart';
import '../../../data/services/l10n_service.dart';

import '../../../data/services/storage_service.dart';
import '../../../data/services/url_launcher_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../data/services/paywall_service.dart';
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
    final premiumState = ref.watch(premiumProvider);
    final isPremium = premiumState.isPremium;
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
                  title: L10n.get('settings.title', language),
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
                      title: L10n.get('theme', language).toUpperCase(),
                      isDark: isDark,
                    ),
                    _GroupedContainer(
                      isDark: isDark,
                      child: Row(
                        children: [
                          Expanded(
                            child: _ThemeOption(
                              label: L10n.get(
                                'settings.light_mode',
                                language,
                              ),
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
                              label: L10n.get(
                                'settings.dark_mode',
                                language,
                              ),
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
                      title: L10n.get('language', language).toUpperCase(),
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
                            return GestureDetector(
                              onTap: () {
                                if (isAvailable) {
                                  HapticFeedback.selectionClick();
                                  ref.read(languageProvider.notifier).state =
                                      lang;
                                  StorageService.saveLanguage(lang);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
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
                                        style: const TextStyle(fontSize: 16),
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
                            onTap: () => showContextualPaywall(context, ref, paywallContext: PaywallContext.general),
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
                        title: (language == AppLanguage.en
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
                      title: (language == AppLanguage.en
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
                            icon: Icons.emoji_events_outlined,
                            title: language == AppLanguage.en
                                ? 'Growth Challenges'
                                : 'Büyüme Görevleri',
                            isDark: isDark,
                            onTap: () => context.push(Routes.challenges),
                          ),
                          _GroupedSeparator(isDark: isDark),
                          _GroupedTile(
                            icon: Icons.eco_outlined,
                            title: language == AppLanguage.en
                                ? 'Seasonal Reflections'
                                : 'Mevsimsel Yansımalar',
                            isDark: isDark,
                            onTap: () => context.push(Routes.seasonal),
                          ),
                          _GroupedSeparator(isDark: isDark),
                          _GroupedTile(
                            icon: Icons.dark_mode_outlined,
                            title: language == AppLanguage.en
                                ? 'Moon Calendar'
                                : 'Ay Takvimi',
                            isDark: isDark,
                            onTap: () => context.push(Routes.moonCalendar),
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
                            onTap: () =>
                                _showDisclaimerDialog(context, language, isDark),
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
                                subject: L10n.get('settings.support', language),
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

                    // ═══ ADMIN SECTION ═══
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
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
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
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
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
            onPressed: () => Navigator.pop(context),
            child: Text(
              L10n.get('common.cancel', language),
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await StorageService.clearAllData();
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
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
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
              L10n.get('common.ok', language),
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

    return GestureDetector(
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
                  style: TextStyle(
                    fontSize: 17,
                    color: textColor,
                  ),
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
    return GestureDetector(
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
                    : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
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
                    status.isUnlocked
                        ? AppColors.success
                        : AppColors.starGold,
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
                      backgroundColor:
                          AppColors.starGold.withValues(alpha: 0.15),
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
