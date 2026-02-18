import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/services/notification_service.dart';
import '../../../data/services/l10n_service.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';

/// Notification settings section for the settings screen
class NotificationSettingsSection extends ConsumerStatefulWidget {
  const NotificationSettingsSection({super.key});

  @override
  ConsumerState<NotificationSettingsSection> createState() =>
      _NotificationSettingsSectionState();
}

class _NotificationSettingsSectionState
    extends ConsumerState<NotificationSettingsSection> {
  final NotificationService _notificationService = NotificationService();
  bool _isInitialized = false;
  bool _permissionsGranted = false;

  bool _dailyInsightEnabled = false;
  int _dailyHour = 8;
  int _dailyMinute = 0;
  bool _moonPhaseEnabled = false;
  bool _wellnessRemindersEnabled = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.initialize();
    _permissionsGranted = await _notificationService.areNotificationsEnabled();

    final settings = await _notificationService.getSettings();
    if (!mounted) return;
    setState(() {
      _isInitialized = true;
      _dailyInsightEnabled = settings.dailyReflectionEnabled;
      if (settings.dailyReflectionTimeMinutes != null) {
        _dailyHour = settings.dailyReflectionTimeMinutes! ~/ 60;
        _dailyMinute = settings.dailyReflectionTimeMinutes! % 60;
      }
      _moonPhaseEnabled = settings.moonPhaseEnabled;
      _wellnessRemindersEnabled = settings.wellnessRemindersEnabled;
    });
  }

  Future<void> _requestPermissions() async {
    final granted = await _notificationService.requestPermissions();
    if (!mounted) return;
    setState(() {
      _permissionsGranted = granted;
    });
  }

  Future<void> _toggleDailyInsight(bool value) async {
    setState(() => _dailyInsightEnabled = value);

    if (value) {
      await _notificationService.scheduleDailyReflection(
        hour: _dailyHour,
        minute: _dailyMinute,
      );
    } else {
      await _notificationService.cancelDailyReflection();
    }
  }

  Future<void> _selectDailyTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _dailyHour, minute: _dailyMinute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.starGold,
              surface: AppColors.surfaceDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      if (!mounted) return;
      setState(() {
        _dailyHour = time.hour;
        _dailyMinute = time.minute;
      });

      if (_dailyInsightEnabled) {
        await _notificationService.scheduleDailyReflection(
          hour: _dailyHour,
          minute: _dailyMinute,
        );
      }
    }
  }

  Future<void> _toggleMoonPhase(bool value) async {
    setState(() => _moonPhaseEnabled = value);

    if (value) {
      await _notificationService.scheduleMoonPhaseNotifications();
    } else {
      await _notificationService.cancelMoonPhaseNotifications();
    }
  }

  Future<void> _toggleWellnessReminders(bool value) async {
    setState(() => _wellnessRemindersEnabled = value);
    await _notificationService.setWellnessRemindersEnabled(value);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final isEnglish = language == AppLanguage.en;

    if (!_isInitialized) {
      return const Center(child: CosmicLoadingIndicator());
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceLight.withValues(alpha: 0.08)
            : Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isDark
              ? AppColors.surfaceLight.withValues(alpha: 0.12)
              : AppColors.lightSurfaceVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notifications_outlined,
                color: AppColors.starGold,
                size: 24,
              ),
              const SizedBox(width: AppConstants.spacingSm),
              Text(
                L10nService.get('common.notifications', language),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),

          if (!_permissionsGranted)
            _buildPermissionBanner(context, isDark, language),

          if (_permissionsGranted) ...[
            _buildNotificationTile(
              context,
              isDark,
              icon: Icons.auto_awesome_outlined,
              title: isEnglish ? 'Daily Insight' : 'Günlük İçgörü',
              subtitle: _dailyInsightEnabled
                  ? (isEnglish
                        ? 'Reminder at ${_dailyHour.toString().padLeft(2, '0')}:${_dailyMinute.toString().padLeft(2, '0')}'
                        : 'Hatırlatma: ${_dailyHour.toString().padLeft(2, '0')}:${_dailyMinute.toString().padLeft(2, '0')}')
                  : (isEnglish ? 'Off' : 'Kapalı'),
              value: _dailyInsightEnabled,
              onChanged: _toggleDailyInsight,
              onTap: _dailyInsightEnabled ? _selectDailyTime : null,
            ),

            const Divider(height: 24),

            _buildNotificationTile(
              context,
              isDark,
              icon: Icons.nightlight_round_outlined,
              title: isEnglish
                  ? 'Moon Cycle Awareness'
                  : 'Ay Döngüsü Farkındalığı',
              subtitle: isEnglish
                  ? 'New & full moon mindfulness reminders'
                  : 'Yeni ve dolunay farkındalık hatırlatmaları',
              value: _moonPhaseEnabled,
              onChanged: _toggleMoonPhase,
            ),

            const Divider(height: 24),

            _buildNotificationTile(
              context,
              isDark,
              icon: Icons.spa_outlined,
              title: isEnglish ? 'Wellness Reminders' : 'Sağlık Hatırlatmaları',
              subtitle: isEnglish
                  ? 'Self-care and reflection prompts'
                  : 'Öz bakım ve yansıma uyarıları',
              value: _wellnessRemindersEnabled,
              onChanged: _toggleWellnessReminders,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPermissionBanner(
    BuildContext context,
    bool isDark,
    AppLanguage language,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.starGold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: Border.all(color: AppColors.starGold.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.starGold, size: 20),
          const SizedBox(width: AppConstants.spacingSm),
          Expanded(
            child: Text(
              L10nService.get('common.permission_required', language),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: _requestPermissions,
            child: Text(
              L10nService.get('common.grant_permission', language),
              style: TextStyle(color: AppColors.starGold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (value ? AppColors.starGold : AppColors.textMuted)
                  .withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: value ? AppColors.starGold : AppColors.textMuted,
              size: 20,
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null && value)
            Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
          const SizedBox(width: 8),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.starGold.withValues(alpha: 0.5),
            thumbColor: WidgetStatePropertyAll(AppColors.starGold),
          ),
        ],
      ),
    );
  }
}
