import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/themed_picker.dart';
import '../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_dialog.dart';
import '../../../shared/widgets/gradient_outlined_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../data/cities/world_cities.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late TextEditingController _nameController;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedCity;
  double? _selectedLatitude;
  double? _selectedLongitude;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _loadCurrentProfile();
  }

  void _loadCurrentProfile() {
    final profile = ref.read(userProfileProvider);
    if (profile != null) {
      _nameController.text = profile.name ?? '';
      _selectedDate = profile.birthDate;
      if (profile.birthTime != null) {
        final parts = profile.birthTime!.split(':');
        if (parts.length >= 2) {
          _selectedTime = TimeOfDay(
            hour: int.tryParse(parts[0]) ?? 0,
            minute: int.tryParse(parts[1]) ?? 0,
          );
        }
      }
      _selectedCity = profile.birthPlace;
      _selectedLatitude = profile.birthLatitude;
      _selectedLongitude = profile.birthLongitude;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.opaque,
        child: CosmicBackground(
          child: SafeArea(
            child:
                SingleChildScrollView(
                      padding: const EdgeInsets.all(AppConstants.spacingLg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(context, language),
                          const SizedBox(height: AppConstants.spacingXl),
                          if (profile != null) ...[
                            _buildProfileHeader(context, profile, isDark),
                            const SizedBox(height: AppConstants.spacingXl),
                          ],
                          _buildEditSection(context, language, isDark),
                          const SizedBox(height: AppConstants.spacingXl),
                          if (profile != null)
                            _buildCosmicInfo(
                              context,
                              profile,
                              language,
                              isDark,
                            ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.05, duration: 400.ms),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLanguage language) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        IconButton(
          tooltip: language == AppLanguage.en ? 'Back' : 'Geri',
          onPressed: () {
            if (_hasChanges) {
              _showDiscardDialog(context, language);
            } else {
              context.pop();
            }
          },
          icon: Icon(
            Icons.chevron_left,
            size: 28,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(width: AppConstants.spacingSm),
        GradientText(
          L10nService.get('navigation.profile', language),
          variant: GradientTextVariant.gold,
          style: AppTypography.displayFont.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        if (_hasChanges)
          TextButton(
            onPressed: _saveProfile,
            child: Text(
              L10nService.get('common.save', language),
              style: AppTypography.modernAccent(
                color: AppColors.auroraStart,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    ).glassEntrance(context: context);
  }

  Widget _buildProfileHeader(
    BuildContext context,
    dynamic profile,
    bool isDark,
  ) {
    // Compact header with logo and name inline
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // InnerCycles Logo
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.starGold.withValues(alpha: 0.3),
                AppColors.starGold.withValues(alpha: 0.1),
              ],
            ),
            border: Border.all(
              color: AppColors.starGold.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                'assets/brand/app-logo/png/app-logo-96.png',
                fit: BoxFit.contain,
                semanticLabel: 'InnerCycles logo',
                errorBuilder: (_, _, _) => Icon(
                  Icons.auto_awesome,
                  color: AppColors.starGold,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppConstants.spacingMd),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientText(
              profile.name ?? profile.displayEmoji,
              variant: GradientTextVariant.gold,
              style: AppTypography.displayFont.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (profile.age > 0) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.starGold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${profile.age}',
                  style: AppTypography.modernAccent(
                    fontSize: 11,
                    color: AppColors.starGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    ).glassReveal(context: context);
  }

  Widget _buildEditSection(
    BuildContext context,
    AppLanguage language,
    bool isDark,
  ) {
    return GlassPanel(
      elevation: GlassElevation.g2,
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit_outlined, color: AppColors.starGold, size: 20),
              const SizedBox(width: AppConstants.spacingSm),
              GradientText(
                L10nService.get('profile.edit_info', language),
                variant: GradientTextVariant.gold,
                style: AppTypography.displayFont.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLg),

          // Name field
          _buildTextField(
            context,
            controller: _nameController,
            label: L10nService.get('input.name', language),
            hint: L10nService.get('input.your_name', language),
            icon: Icons.person_outline,
            isDark: isDark,
            onChanged: (value) => setState(() => _hasChanges = true),
          ),
          const SizedBox(height: AppConstants.spacingMd),

          // Birth date
          _buildInfoField(
            context,
            label: L10nService.get('input.birth_date', language),
            value: _selectedDate != null
                ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                : L10nService.get('input.select_time', language),
            icon: Icons.calendar_today_outlined,
            isDark: isDark,
            onTap: () => _selectDate(context),
          ),
          const SizedBox(height: AppConstants.spacingMd),

          // Birth time
          _buildInfoField(
            context,
            label: L10nService.get('input.birth_time', language),
            value: _selectedTime != null
                ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                : L10nService.get('input.select_time', language),
            icon: Icons.access_time_outlined,
            isDark: isDark,
            onTap: () => _selectTime(context),
          ),
          const SizedBox(height: AppConstants.spacingMd),

          // Birth place
          _buildInfoField(
            context,
            label: L10nService.get('input.birth_place', language),
            value:
                _selectedCity ?? L10nService.get('input.select_city', language),
            icon: Icons.location_on_outlined,
            isDark: isDark,
            onTap: () => _selectCity(context, language),
          ),
        ],
      ),
    ).glassListItem(context: context, index: 0);
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.subtitle(
            fontSize: 12,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: AppTypography.subtitle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.subtitle(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
            prefixIcon: Icon(
              icon,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
            filled: true,
            fillColor: isDark
                ? AppColors.surfaceLight.withValues(alpha: 0.3)
                : AppColors.lightSurfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              borderSide: BorderSide(color: AppColors.auroraStart, width: 2),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildInfoField(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.subtitle(
            fontSize: 12,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 6),
        Semantics(
          button: true,
          label: '$label: $value',
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceLight.withValues(alpha: 0.3)
                    : AppColors.lightSurfaceVariant,
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  const SizedBox(width: AppConstants.spacingMd),
                  Expanded(
                    child: Text(
                      value,
                      style: AppTypography.subtitle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCosmicInfo(
    BuildContext context,
    dynamic profile,
    AppLanguage language,
    bool isDark,
  ) {
    final isEn = language == AppLanguage.en;
    return GlassPanel(
      elevation: GlassElevation.g3,
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      glowColor: AppColors.starGold.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: AppColors.starGold, size: 20),
              const SizedBox(width: AppConstants.spacingSm),
              GradientText(
                isEn ? 'Your Progress' : 'İlerlemen',
                variant: GradientTextVariant.gold,
                style: AppTypography.displayFont.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            isEn
                ? 'Explore your patterns, track your growth, and discover insights from your journal entries.'
                : 'Örüntülerini keşfet, gelişimini takip et ve günlük kayıtlarından içgörüler elde et.',
            style: AppTypography.subtitle(
              fontSize: 12,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          // Navigate to Signal Dashboard (CORE Insights)
          GradientOutlinedButton(
            label: isEn ? 'View Insights' : 'İçgörüleri Gör',
            icon: Icons.insights,
            variant: GradientTextVariant.aurora,
            expanded: true,
            onPressed: () => context.go(Routes.moodTrends),
          ),
        ],
      ),
    ).glassListItem(context: context, index: 1);
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await ThemedPicker.showDate(
      context,
      initialDate: _selectedDate ?? DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      if (!mounted) return;
      setState(() {
        _selectedDate = date;
        _hasChanges = true;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final time = await ThemedPicker.showTime(
      context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 12, minute: 0),
    );

    if (time != null) {
      if (!mounted) return;
      setState(() {
        _selectedTime = time;
        _hasChanges = true;
      });
    }
  }

  Future<void> _selectCity(BuildContext context, AppLanguage language) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final result = await showModalBottomSheet<CityData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        String searchQuery = '';
        bool showTurkeyOnly = true;

        return StatefulBuilder(
          builder: (context, setModalState) {
            List<CityData> filteredCities;
            if (searchQuery.isEmpty) {
              filteredCities = showTurkeyOnly
                  ? WorldCities.turkishCities
                  : WorldCities.allCities;
            } else {
              filteredCities = WorldCities.search(searchQuery);
            }

            return ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                    color:
                        (isDark
                                ? AppColors.surfaceDark
                                : AppColors.lightSurface)
                            .withValues(alpha: isDark ? 0.85 : 0.92),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    border: Border(
                      top: BorderSide(
                        color: AppColors.auroraStart.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Gradient drag handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.auroraStart.withValues(alpha: 0.6),
                                AppColors.auroraEnd.withValues(alpha: 0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              L10nService.get('common.cancel', language),
                              style: AppTypography.modernAccent(
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ),
                          GradientText(
                            L10nService.get('input.select_city', language),
                            variant: GradientTextVariant.aurora,
                            style: AppTypography.displayFont.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 60),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        style: AppTypography.subtitle(
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: L10nService.get(
                            'input.search_city',
                            language,
                          ),
                          hintStyle: AppTypography.subtitle(
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? AppColors.surfaceLight.withValues(alpha: 0.12)
                              : AppColors.lightSurfaceVariant,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          setModalState(() => searchQuery = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilterChip(
                            label: Text(
                              L10nService.get('input.turkey_kktc', language),
                              style: AppTypography.modernAccent(
                                fontSize: 13,
                                color: showTurkeyOnly
                                    ? Colors.white
                                    : (isDark
                                          ? AppColors.textSecondary
                                          : AppColors.lightTextSecondary),
                              ),
                            ),
                            selected: showTurkeyOnly,
                            selectedColor: AppColors.auroraStart,
                            checkmarkColor: Colors.white,
                            backgroundColor: isDark
                                ? AppColors.surfaceLight.withValues(alpha: 0.12)
                                : AppColors.lightSurfaceVariant,
                            side: BorderSide(
                              color: showTurkeyOnly
                                  ? AppColors.auroraStart.withValues(alpha: 0.5)
                                  : (isDark
                                        ? Colors.white.withValues(alpha: 0.08)
                                        : Colors.black.withValues(alpha: 0.06)),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onSelected: (selected) {
                              setModalState(() => showTurkeyOnly = selected);
                            },
                          ),
                          FilterChip(
                            label: Text(
                              L10nService.get('input.whole_world', language),
                              style: AppTypography.modernAccent(
                                fontSize: 13,
                                color: !showTurkeyOnly
                                    ? Colors.white
                                    : (isDark
                                          ? AppColors.textSecondary
                                          : AppColors.lightTextSecondary),
                              ),
                            ),
                            selected: !showTurkeyOnly,
                            selectedColor: AppColors.auroraStart,
                            checkmarkColor: Colors.white,
                            backgroundColor: isDark
                                ? AppColors.surfaceLight.withValues(alpha: 0.12)
                                : AppColors.lightSurfaceVariant,
                            side: BorderSide(
                              color: !showTurkeyOnly
                                  ? AppColors.auroraStart.withValues(alpha: 0.5)
                                  : (isDark
                                        ? Colors.white.withValues(alpha: 0.08)
                                        : Colors.black.withValues(alpha: 0.06)),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onSelected: (selected) {
                              setModalState(() => showTurkeyOnly = !selected);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          itemCount: filteredCities.length,
                          itemBuilder: (context, index) {
                            final city = filteredCities[index];
                            return ListTile(
                              leading: Icon(
                                Icons.location_city,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                              title: Text(
                                city.name,
                                style: AppTypography.subtitle(
                                  color: isDark
                                      ? AppColors.textPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                              subtitle: Text(
                                city.country,
                                style: AppTypography.elegantAccent(
                                  fontSize: 13,
                                  color: isDark
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                              onTap: () => Navigator.pop(context, city),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      if (!mounted) return;
      setState(() {
        _selectedCity = result.name;
        _selectedLatitude = result.lat;
        _selectedLongitude = result.lng;
        _hasChanges = true;
      });
    }
  }

  void _saveProfile() {
    HapticFeedback.mediumImpact();
    final currentProfile = ref.read(userProfileProvider);
    if (currentProfile == null || _selectedDate == null) return;

    final timeString = _selectedTime != null
        ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
        : currentProfile.birthTime;

    final updatedProfile = currentProfile.copyWith(
      name: _nameController.text.isNotEmpty ? _nameController.text : null,
      birthDate: _selectedDate,
      birthTime: timeString,
      birthPlace: _selectedCity,
      birthLatitude: _selectedLatitude,
      birthLongitude: _selectedLongitude,
    );

    ref.read(userProfileProvider.notifier).setProfile(updatedProfile);
    StorageService.saveUserProfile(updatedProfile);

    setState(() => _hasChanges = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          L10nService.get('profile.profile_saved', ref.read(languageProvider)),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        ),
      ),
    );
  }

  void _showDiscardDialog(BuildContext context, AppLanguage language) async {
    final confirmed = await GlassDialog.confirm(
      context,
      title: L10nService.get('profile.discard_changes_title', language),
      message: L10nService.get('profile.discard_changes_message', language),
      cancelLabel: L10nService.get('common.cancel', language),
      confirmLabel: L10nService.get('common.delete', language),
      isDestructive: true,
    );
    if (confirmed == true && context.mounted) {
      if (context.canPop()) context.pop();
    }
  }
}
