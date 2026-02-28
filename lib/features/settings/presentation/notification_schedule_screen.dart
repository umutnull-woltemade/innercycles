import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/themed_picker.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/notification_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../data/services/l10n_service.dart';

class NotificationScheduleScreen extends ConsumerStatefulWidget {
  const NotificationScheduleScreen({super.key});

  @override
  ConsumerState<NotificationScheduleScreen> createState() =>
      _NotificationScheduleScreenState();
}

class _NotificationScheduleScreenState
    extends ConsumerState<NotificationScheduleScreen> {
  final _notificationService = NotificationService();
  NotificationSettings? _settings;
  bool _isLoading = true;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await _notificationService.initialize();
    final settings = await _notificationService.getSettings();
    final hasPermission = await _notificationService.areNotificationsEnabled();
    if (mounted) {
      setState(() {
        _settings = settings;
        _hasPermission = hasPermission;
        _isLoading = false;
      });
    }
  }

  Future<void> _requestPermission() async {
    final granted = await _notificationService.requestPermissions();
    if (mounted) {
      setState(() => _hasPermission = granted);
    }
  }

  Future<void> _toggleDailyReflection(bool enabled) async {
    if (enabled) {
      final time =
          _settings?.dailyReflectionTime ?? const TimeOfDay(hour: 9, minute: 0);
      await _notificationService.scheduleDailyReflection(
        hour: time.hour,
        minute: time.minute,
      );
    } else {
      await _notificationService.cancelDailyReflection();
    }
    if (!mounted) return;
    await _loadSettings();
  }

  Future<void> _pickDailyTime() async {
    final current =
        _settings?.dailyReflectionTime ?? const TimeOfDay(hour: 9, minute: 0);
    final picked = await ThemedPicker.showTime(context, initialTime: current);
    if (picked != null && mounted) {
      await _notificationService.scheduleDailyReflection(
        hour: picked.hour,
        minute: picked.minute,
      );
      if (!mounted) return;
      await _loadSettings();
    }
  }

  Future<void> _toggleEveningReflection(bool enabled) async {
    if (enabled) {
      await _notificationService.scheduleEveningReflection(hour: 20, minute: 0);
    } else {
      await _notificationService.cancelEveningReflection();
    }
    if (!mounted) return;
    await _loadSettings();
  }

  Future<void> _toggleWellness(bool enabled) async {
    await _notificationService.setWellnessRemindersEnabled(enabled);
    if (!mounted) return;
    await _loadSettings();
  }

  Future<void> _toggleJournalPrompt(bool enabled) async {
    if (enabled) {
      final time =
          _settings?.journalPromptTime ?? const TimeOfDay(hour: 10, minute: 0);
      await _notificationService.scheduleJournalPromptNotification(
        hour: time.hour,
        minute: time.minute,
      );
    } else {
      await _notificationService.cancelJournalPromptNotification();
    }
    if (!mounted) return;
    await _loadSettings();
  }

  Future<void> _pickJournalPromptTime() async {
    final current =
        _settings?.journalPromptTime ?? const TimeOfDay(hour: 10, minute: 0);
    final picked = await ThemedPicker.showTime(context, initialTime: current);
    if (picked != null && mounted) {
      await _notificationService.scheduleJournalPromptNotification(
        hour: picked.hour,
        minute: picked.minute,
      );
      if (!mounted) return;
      await _loadSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;

    return Scaffold(
      body: CosmicBackground(
        child: _isLoading
            ? const CosmicLoadingIndicator()
            : CupertinoScrollbar(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    GlassSliverAppBar(
                      title: L10nService.get('settings.notification_schedule.notifications', language),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(AppConstants.spacingLg),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Permission banner
                          if (!_hasPermission)
                            _buildPermissionBanner(isDark, isEn),

                          // Daily reflection
                          _buildNotificationCard(
                            context: context,
                            isDark: isDark,
                            language: language,
                            icon: Icons.wb_sunny_outlined,
                            iconColor: AppColors.starGold,
                            titleEn: 'Daily Reflection',
                            titleTr: 'Günlük Yansıma',
                            subtitleEn:
                                'A morning reminder to journal your cycle position',
                            subtitleTr:
                                'Döngü pozisyonunu kaydetmen için sabah hatırlatıcısı',
                            enabled: _settings?.dailyReflectionEnabled ?? false,
                            onToggle: _toggleDailyReflection,
                            timeWidget:
                                _settings?.dailyReflectionEnabled == true
                                ? _buildTimePicker(isDark, isEn)
                                : null,
                          ).animate().fadeIn(duration: 300.ms),
                          const SizedBox(height: AppConstants.spacingMd),

                          // Evening reflection
                          _buildNotificationCard(
                            context: context,
                            isDark: isDark,
                            language: language,
                            icon: Icons.nightlight_round_outlined,
                            iconColor: AppColors.auroraStart,
                            titleEn: 'Evening Reflection',
                            titleTr: 'Akşam Yansıması',
                            subtitleEn:
                                'End-of-day prompt to capture your emotional state',
                            subtitleTr:
                                'Duygusal durumunu kaydetmen için gün sonu hatırlatıcısı',
                            enabled:
                                _settings?.eveningReflectionEnabled ?? false,
                            onToggle: _toggleEveningReflection,
                          ).animate().fadeIn(duration: 300.ms, delay: 60.ms),
                          const SizedBox(height: AppConstants.spacingMd),

                          // Journal prompt
                          _buildNotificationCard(
                            context: context,
                            isDark: isDark,
                            language: language,
                            icon: Icons.auto_awesome_outlined,
                            iconColor: AppColors.auroraEnd,
                            titleEn: 'Daily Journal Prompt',
                            titleTr: 'Günlük Soru',
                            subtitleEn:
                                'A fresh journaling question to inspire your writing',
                            subtitleTr:
                                'Yazmanıza ilham verecek günlük bir soru',
                            enabled: _settings?.journalPromptEnabled ?? false,
                            onToggle: _toggleJournalPrompt,
                            timeWidget: _settings?.journalPromptEnabled == true
                                ? _buildJournalPromptTimePicker(isDark, isEn)
                                : null,
                          ).animate().fadeIn(duration: 300.ms, delay: 120.ms),
                          const SizedBox(height: AppConstants.spacingMd),

                          // Wellness reminders
                          _buildNotificationCard(
                            context: context,
                            isDark: isDark,
                            language: language,
                            icon: Icons.spa_outlined,
                            iconColor: AppColors.auroraEnd,
                            titleEn: 'Wellness Reminders',
                            titleTr: 'Sağlık Hatırlatıcıları',
                            subtitleEn:
                                'Gentle nudges for breathing, hydration & movement',
                            subtitleTr:
                                'Nefes, su ve hareket için nazik hatırlatmalar',
                            enabled:
                                _settings?.wellnessRemindersEnabled ?? false,
                            onToggle: _toggleWellness,
                          ).animate().fadeIn(duration: 300.ms, delay: 180.ms),
                          const SizedBox(height: AppConstants.spacingXl),

                          // Info text
                          Text(
                            L10nService.get('settings.notification_schedule.notifications_help_you_build_a_consisten', language),
                            style: AppTypography.decorativeScript(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildPermissionBanner(bool isDark, AppLanguage language) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingLg),
      child: GlassPanel(
        elevation: GlassElevation.g3,
        glowColor: AppColors.warning.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 32,
              color: AppColors.warning,
            ),
            const SizedBox(height: AppConstants.spacingMd),
            GradientText(
              L10nService.get('settings.notification_schedule.notifications_are_disabled', language),
              variant: GradientTextVariant.gold,
              style: AppTypography.displayFont.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              L10nService.get('settings.notification_schedule.enable_notifications_to_receive_journali', language),
              textAlign: TextAlign.center,
              style: AppTypography.decorativeScript(
                fontSize: 13,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            GradientButton.gold(
              label: L10nService.get('settings.notification_schedule.enable_notifications', language),
              onPressed: _requestPermission,
              expanded: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required BuildContext context,
    required bool isDark,
    required AppLanguage language,
    required IconData icon,
    required Color iconColor,
    required String titleEn,
    required String titleTr,
    required String subtitleEn,
    required String subtitleTr,
    required bool enabled,
    required Future<void> Function(bool) onToggle,
    Widget? timeWidget,
  }) {
    return GlassPanel(
      elevation: GlassElevation.g2,
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconColor.withValues(alpha: 0.15),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEn ? titleEn : titleTr,
                      style: AppTypography.subtitle(
                        fontSize: 15,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isEn ? subtitleEn : subtitleTr,
                      style: AppTypography.elegantAccent(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
              CupertinoSwitch(
                value: enabled,
                activeTrackColor: AppColors.auroraStart,
                onChanged: (value) => onToggle(value),
              ),
            ],
          ),
          if (timeWidget != null) ...[
            const SizedBox(height: AppConstants.spacingMd),
            timeWidget,
          ],
        ],
      ),
    );
  }

  Widget _buildTimePicker(bool isDark, AppLanguage language) {
    final time =
        _settings?.dailyReflectionTime ?? const TimeOfDay(hour: 9, minute: 0);
    final formatted = time.format(context);

    return Semantics(
      label: isEn
          ? 'Change reminder time: $formatted'
          : 'Hatırlatma saatini değiştir: $formatted',
      button: true,
      child: GestureDetector(
        onTap: _pickDailyTime,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMd,
            vertical: AppConstants.spacingSm,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceLight.withValues(alpha: 0.1)
                : AppColors.lightSurfaceVariant,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                L10nService.get('settings.notification_schedule.reminder_time', language),
                style: AppTypography.elegantAccent(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              Row(
                children: [
                  Text(
                    formatted,
                    style: AppTypography.modernAccent(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.starGold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.access_time, size: 16, color: AppColors.starGold),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJournalPromptTimePicker(bool isDark, AppLanguage language) {
    final time =
        _settings?.journalPromptTime ?? const TimeOfDay(hour: 10, minute: 0);
    final formatted = time.format(context);

    return Semantics(
      label: isEn
          ? 'Change prompt time: $formatted'
          : 'Soru saatini değiştir: $formatted',
      button: true,
      child: GestureDetector(
        onTap: _pickJournalPromptTime,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMd,
            vertical: AppConstants.spacingSm,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceLight.withValues(alpha: 0.1)
                : AppColors.lightSurfaceVariant,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                L10nService.get('settings.notification_schedule.prompt_time', language),
                style: AppTypography.elegantAccent(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              Row(
                children: [
                  Text(
                    formatted,
                    style: AppTypography.modernAccent(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.auroraEnd,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.access_time, size: 16, color: AppColors.auroraEnd),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
