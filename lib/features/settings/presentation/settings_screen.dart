import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/localization_service.dart';
import '../../../data/services/l10n_service.dart';
import '../../../data/models/house.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/services/url_launcher_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../data/services/paywall_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import 'notification_settings_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final themeMode = ref.watch(themeModeProvider);
    final houseSystem = ref.watch(houseSystemProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, language),
                const SizedBox(height: AppConstants.spacingXl),
                _buildThemeSection(context, ref, language, themeMode, isDark),
                const SizedBox(height: AppConstants.spacingLg),
                _buildLanguageSection(context, ref, language, isDark),
                const SizedBox(height: AppConstants.spacingLg),
                _buildHouseSystemSection(context, ref, language, houseSystem, isDark),
                const SizedBox(height: AppConstants.spacingLg),
                _buildAccountSection(context, ref, language, isDark),
                const SizedBox(height: AppConstants.spacingLg),
                const NotificationSettingsSection()
                    .animate()
                    .fadeIn(delay: 350.ms, duration: 400.ms)
                    .slideY(begin: 0.1),
                const SizedBox(height: AppConstants.spacingXl),
                _buildAppInfoSection(context, ref, language, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLanguage language) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(width: AppConstants.spacingSm),
        Text(
          L10n.get('settings.title', language),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.starGold,
              ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildThemeSection(
    BuildContext context,
    WidgetRef ref,
    AppLanguage language,
    ThemeMode themeMode,
    bool isDark,
  ) {
    return _SettingsSection(
      title: L10n.get('theme', language),
      icon: Icons.palette_outlined,
      isDark: isDark,
      child: Row(
        children: [
          Expanded(
            child: _ThemeOption(
              label: L10n.get('settings.light_mode', language),
              icon: Icons.light_mode,
              isSelected: themeMode == ThemeMode.light,
              isDark: isDark,
              onTap: () {
                ref.read(themeModeProvider.notifier).state = ThemeMode.light;
                StorageService.saveThemeMode(ThemeMode.light);
              },
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: _ThemeOption(
              label: L10n.get('settings.dark_mode', language),
              icon: Icons.dark_mode,
              isSelected: themeMode == ThemeMode.dark,
              isDark: isDark,
              onTap: () {
                ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
                StorageService.saveThemeMode(ThemeMode.dark);
              },
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildLanguageSection(
    BuildContext context,
    WidgetRef ref,
    AppLanguage currentLanguage,
    bool isDark,
  ) {
    return _SettingsSection(
      title: L10n.get('language', currentLanguage),
      icon: Icons.language,
      isDark: isDark,
      child: Wrap(
        spacing: AppConstants.spacingSm,
        runSpacing: AppConstants.spacingSm,
        children: AppLanguage.values.map((lang) {
          final isSelected = lang == currentLanguage;
          // Use hasStrictIsolation to check if language has complete translations
          final isAvailable = lang.hasStrictIsolation;
          return GestureDetector(
            onTap: () {
              if (isAvailable) {
                ref.read(languageProvider.notifier).state = lang;
                StorageService.saveLanguage(lang);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(L10nService.get('settings.coming_soon_language', currentLanguage)),
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
                  horizontal: AppConstants.spacingMd,
                  vertical: AppConstants.spacingSm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.auroraStart.withValues(alpha: 0.2)
                      : (isDark
                          ? AppColors.surfaceLight.withValues(alpha: 0.3)
                          : AppColors.lightSurfaceVariant),
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.auroraStart
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(lang.flag, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      lang.displayName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? AppColors.auroraStart
                                : (isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary),
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
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
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildHouseSystemSection(
    BuildContext context,
    WidgetRef ref,
    AppLanguage language,
    HouseSystem currentSystem,
    bool isDark,
  ) {
    return _SettingsSection(
      title: L10nService.get('settings.house_system', language),
      icon: Icons.grid_view_rounded,
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            L10nService.get('settings.house_system_desc', language),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Wrap(
            spacing: AppConstants.spacingSm,
            runSpacing: AppConstants.spacingSm,
            children: HouseSystem.values.map((system) {
              final isSelected = system == currentSystem;
              return GestureDetector(
                onTap: () {
                  ref.read(houseSystemProvider.notifier).state = system;
                  StorageService.saveHouseSystem(system.index);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingMd,
                    vertical: AppConstants.spacingSm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.celestialGold.withValues(alpha: 0.2)
                        : (isDark
                            ? AppColors.surfaceLight.withValues(alpha: 0.3)
                            : AppColors.lightSurfaceVariant),
                    borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.celestialGold
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        system.name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? AppColors.celestialGold
                              : (isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary),
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: AppColors.celestialGold,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          if (currentSystem != HouseSystem.placidus) ...[
            const SizedBox(height: AppConstants.spacingMd),
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              decoration: BoxDecoration(
                color: AppColors.celestialGold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                border: Border.all(color: AppColors.celestialGold.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.celestialGold, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      currentSystem.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 250.ms, duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildAccountSection(
    BuildContext context,
    WidgetRef ref,
    AppLanguage language,
    bool isDark,
  ) {
    final premiumState = ref.watch(premiumProvider);
    final isPremium = premiumState.isPremium;

    return _SettingsSection(
      title: L10nService.get('settings.account', language),
      icon: Icons.person_outline,
      isDark: isDark,
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.account_circle_outlined,
            title: L10nService.get('settings.edit_profile', language),
            subtitle: L10nService.get('settings.edit_profile_desc', language),
            isDark: isDark,
            onTap: () => context.push(Routes.profile),
          ),
          const Divider(height: 1),
          _SettingsTile(
            icon: Icons.workspace_premium_outlined,
            title: L10nService.get('settings.premium', language),
            subtitle: isPremium
                ? L10nService.get('settings.premium_active', language)
                : L10nService.get('settings.premium_desc', language),
            isDark: isDark,
            onTap: () => context.push(Routes.premium),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: isPremium
                    ? LinearGradient(
                        colors: [AppColors.success, AppColors.success.withValues(alpha: 0.8)],
                      )
                    : AppColors.goldGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isPremium ? '✓ PRO' : 'PRO',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isPremium ? Colors.white : AppColors.deepSpace,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          // Show "Manage Subscription" only for premium users
          if (isPremium) ...[
            const Divider(height: 1),
            _SettingsTile(
              icon: Icons.credit_card_outlined,
              title: L10nService.get('settings.manage_subscription', language),
              subtitle: L10nService.get('settings.manage_subscription_desc', language),
              isDark: isDark,
              onTap: () async {
                await ref.read(paywallServiceProvider).presentCustomerCenter();
              },
            ),
          ],
          const Divider(height: 1),
          _SettingsTile(
            icon: Icons.delete_outline,
            title: L10nService.get('settings.clear_data', language),
            subtitle: L10nService.get('settings.clear_data_desc', language),
            isDark: isDark,
            isDestructive: true,
            onTap: () => _showClearDataDialog(context, ref, language),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildAppInfoSection(
    BuildContext context,
    WidgetRef ref,
    AppLanguage language,
    bool isDark,
  ) {
    final urlLauncher = ref.read(urlLauncherServiceProvider);

    return _SettingsSection(
      title: L10nService.get('settings.about', language),
      icon: Icons.info_outline,
      isDark: isDark,
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.star_outline,
            title: L10nService.get('settings.rate_app', language),
            subtitle: L10nService.get('settings.rate_app_desc', language),
            isDark: isDark,
            onTap: () async {
              await urlLauncher.requestAppReview();
            },
          ),
          const Divider(height: 1),
          _SettingsTile(
            icon: Icons.gavel_outlined,
            title: L10nService.get('settings.disclaimer', language),
            subtitle: L10nService.get('settings.disclaimer_desc', language),
            isDark: isDark,
            onTap: () => _showDisclaimerDialog(context, language, isDark),
          ),
          const Divider(height: 1),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: L10nService.get('settings.privacy_policy', language),
            subtitle: null,
            isDark: isDark,
            onTap: () async {
              await urlLauncher.openPrivacyPolicy();
            },
          ),
          const Divider(height: 1),
          _SettingsTile(
            icon: Icons.description_outlined,
            title: L10nService.get('settings.terms_of_service', language),
            subtitle: null,
            isDark: isDark,
            onTap: () async {
              await urlLauncher.openTermsOfService();
            },
          ),
          const Divider(height: 1),
          _SettingsTile(
            icon: Icons.mail_outline,
            title: L10nService.get('settings.contact_support', language),
            subtitle: null,
            isDark: isDark,
            onTap: () async {
              await urlLauncher.openSupportEmail(
                subject: L10n.get('settings.support', language),
                body: '\n\n---\nApp Version: 1.0.0',
              );
            },
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            L10nService.get('settings.version', language),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
          ),
          const Divider(height: 24),
          _SettingsTile(
            icon: Icons.admin_panel_settings,
            title: L10nService.get('settings.admin', language),
            subtitle: L10nService.get('settings.dashboard', language),
            isDark: isDark,
            onTap: () => context.push(Routes.adminLogin),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.starGold, AppColors.celestialGold],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                L10nService.get('settings.pin', language),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.deepSpace,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.1);
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
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
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
            color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
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

  void _showDisclaimerDialog(BuildContext context, AppLanguage language, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        ),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.starGold),
            const SizedBox(width: 12),
            Text(
              L10nService.get('settings.disclaimer', language),
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
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
                  color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.starGold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.starGold.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: AppColors.starGold, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        L10nService.get('settings.disclaimer_tip', language),
                        style: TextStyle(
                          color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
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

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final bool isDark;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.child,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
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
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.starGold,
                size: 20,
              ),
              const SizedBox(width: AppConstants.spacingSm),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLg),
          child,
        ],
      ),
    );
  }
}

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
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.auroraStart.withValues(alpha: 0.3),
                    AppColors.auroraEnd.withValues(alpha: 0.3),
                  ],
                )
              : null,
          color: isSelected
              ? null
              : (isDark
                  ? AppColors.surfaceLight.withValues(alpha: 0.3)
                  : AppColors.lightSurfaceVariant),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.auroraStart : Colors.transparent,
            width: 2,
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
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool isDark;
  final bool isDestructive;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.isDark,
    this.isDestructive = false,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? AppColors.error
        : (isDark ? AppColors.textPrimary : AppColors.lightTextPrimary);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: isDestructive
            ? AppColors.error
            : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
            ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color:
                        isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
            )
          : null,
      trailing: trailing ??
          Icon(
            Icons.chevron_right,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
      onTap: onTap,
    );
  }
}
