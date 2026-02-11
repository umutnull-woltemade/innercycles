import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';

class AddProfileSheet extends ConsumerStatefulWidget {
  final Function(UserProfile) onSave;

  const AddProfileSheet({super.key, required this.onSave});

  @override
  ConsumerState<AddProfileSheet> createState() => _AddProfileSheetState();
}

class _AddProfileSheetState extends ConsumerState<AddProfileSheet> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime _birthDate = DateTime(1990, 6, 15);
  TimeOfDay? _birthTime;
  String? _birthPlace;
  double? _birthLatitude;
  double? _birthLongitude;
  String? _relationship;
  String? _avatarEmoji;

  List<Map<String, String>> _getRelationshipOptions(AppLanguage language) => [
    {
      'value': 'partner',
      'label': L10nService.get('profile.relationship_types.partner', language),
      'emoji': '💕',
    },
    {
      'value': 'friend',
      'label': L10nService.get('profile.relationship_types.friend', language),
      'emoji': '👫',
    },
    {
      'value': 'family',
      'label': L10nService.get('profile.relationship_types.family', language),
      'emoji': '👨‍👩‍👧',
    },
    {
      'value': 'colleague',
      'label': L10nService.get(
        'profile.relationship_types.colleague',
        language,
      ),
      'emoji': '💼',
    },
    {
      'value': 'other',
      'label': L10nService.get('profile.relationship_types.other', language),
      'emoji': '✨',
    },
  ];

  final _emojiOptions = [
    '👤',
    '👱',
    '👩',
    '👨',
    '🧑',
    '👧',
    '👦',
    '🧔',
    '👵',
    '👴',
    '💫',
    '🌟',
    '🔮',
    '🌙',
    '☀️',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sign = ZodiacSignExtension.fromDate(_birthDate);
    final language = ref.watch(languageProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(80),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, isDark, language),
                  const SizedBox(height: AppConstants.spacingXl),
                  _buildAvatarSection(context, isDark, sign, language),
                  const SizedBox(height: AppConstants.spacingLg),
                  _buildNameField(context, isDark, language),
                  const SizedBox(height: AppConstants.spacingLg),
                  _buildDateField(context, isDark, sign, language),
                  const SizedBox(height: AppConstants.spacingLg),
                  _buildTimeField(context, isDark, language),
                  const SizedBox(height: AppConstants.spacingLg),
                  _buildLocationField(context, isDark, language),
                  const SizedBox(height: AppConstants.spacingLg),
                  _buildRelationshipField(context, isDark, language),
                  const SizedBox(height: AppConstants.spacingXl),
                  _buildSaveButton(context, sign, language),
                  const SizedBox(height: AppConstants.spacingLg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, AppLanguage language) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            L10nService.get('common.cancel', language),
            style: TextStyle(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ),
        Text(
          L10nService.get('profile.create_profile', language),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.starGold,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 60),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildAvatarSection(
    BuildContext context,
    bool isDark,
    ZodiacSign sign,
    AppLanguage language,
  ) {
    return Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _showEmojiPicker(context, isDark, language),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        sign.color.withAlpha(100),
                        sign.color.withAlpha(30),
                      ],
                    ),
                    border: Border.all(
                      color: sign.color.withAlpha(100),
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _avatarEmoji ?? sign.symbol,
                      style: const TextStyle(fontSize: 36),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => _showEmojiPicker(context, isDark, language),
                icon: const Icon(Icons.edit, size: 16),
                label: Text(L10nService.get('profile.emoji_select', language)),
                style: TextButton.styleFrom(
                  foregroundColor: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 100.ms, duration: 400.ms)
        .scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildNameField(
    BuildContext context,
    bool isDark,
    AppLanguage language,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10nService.get('input.name', language),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: L10nService.get('input.profile_name_hint', language),
            hintStyle: TextStyle(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
            prefixIcon: Icon(
              Icons.person_outline,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
            filled: true,
            fillColor: isDark
                ? AppColors.surfaceLight.withAlpha(30)
                : AppColors.lightSurfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              borderSide: const BorderSide(
                color: AppColors.auroraStart,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildDateField(
    BuildContext context,
    bool isDark,
    ZodiacSign sign,
    AppLanguage language,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10nService.get('input.birth_date', language),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceLight.withAlpha(30)
                  : AppColors.lightSurfaceVariant,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  child: Text(
                    '${_birthDate.day}/${_birthDate.month}/${_birthDate.year}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: sign.color.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(sign.symbol, style: TextStyle(color: sign.color)),
                      const SizedBox(width: 4),
                      Text(
                        sign.getLocalizedName(language),
                        style: TextStyle(
                          color: sign.color,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  Widget _buildTimeField(
    BuildContext context,
    bool isDark,
    AppLanguage language,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              L10nService.get('input.birth_time', language),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.starGold.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                L10nService.get('input.required_for_rising', language),
                style: TextStyle(
                  color: AppColors.starGold,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectTime(context),
          child: Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceLight.withAlpha(30)
                  : AppColors.lightSurfaceVariant,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: _birthTime != null
                  ? Border.all(
                      color: AppColors.auroraStart.withAlpha(100),
                      width: 1.5,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time_outlined,
                  color: _birthTime != null
                      ? AppColors.auroraStart
                      : (isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary),
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  child: Text(
                    _birthTime != null
                        ? '${_birthTime!.hour.toString().padLeft(2, '0')}:${_birthTime!.minute.toString().padLeft(2, '0')}'
                        : L10nService.get(
                            'input.select_time_optional',
                            language,
                          ),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _birthTime != null
                          ? (isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary)
                          : (isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted),
                    ),
                  ),
                ),
                if (_birthTime != null)
                  GestureDetector(
                    onTap: () => setState(() => _birthTime = null),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 350.ms, duration: 400.ms);
  }

  Widget _buildLocationField(
    BuildContext context,
    bool isDark,
    AppLanguage language,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              L10nService.get('input.birth_place', language),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.cosmicPurple.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                L10nService.get('input.required_for_moon', language),
                style: TextStyle(
                  color: AppColors.cosmicPurple,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showLocationPicker(context, isDark, language),
          child: Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceLight.withAlpha(30)
                  : AppColors.lightSurfaceVariant,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: _birthPlace != null
                  ? Border.all(
                      color: AppColors.cosmicPurple.withAlpha(100),
                      width: 1.5,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: _birthPlace != null
                      ? AppColors.cosmicPurple
                      : (isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary),
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  child: Text(
                    _birthPlace ??
                        L10nService.get(
                          'input.select_location_optional',
                          language,
                        ),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _birthPlace != null
                          ? (isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary)
                          : (isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_birthPlace != null)
                  GestureDetector(
                    onTap: () => setState(() {
                      _birthPlace = null;
                      _birthLatitude = null;
                      _birthLongitude = null;
                      _locationController.clear();
                    }),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
  }

  Widget _buildRelationshipField(
    BuildContext context,
    bool isDark,
    AppLanguage language,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10nService.get('profile.relationship_type', language),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _getRelationshipOptions(language).map((option) {
            final isSelected = _relationship == option['value'];
            return GestureDetector(
              onTap: () =>
                  setState(() => _relationship = option['value'] as String),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.auroraStart.withAlpha(40)
                      : (isDark
                            ? AppColors.surfaceLight.withAlpha(30)
                            : AppColors.lightSurfaceVariant),
                  borderRadius: BorderRadius.circular(20),
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
                    Text(option['emoji'] as String),
                    const SizedBox(width: 6),
                    Text(
                      option['label'] as String,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.auroraStart
                            : (isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
  }

  Widget _buildSaveButton(
    BuildContext context,
    ZodiacSign sign,
    AppLanguage language,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _saveProfile(language),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.auroraStart,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
        ),
        child: Text(
          L10nService.get('common.save', language),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 400.ms);
  }

  Future<void> _selectDate(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final date = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.auroraStart,
              surface: isDark ? AppColors.surfaceDark : AppColors.lightSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() => _birthDate = date);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final time = await showTimePicker(
      context: context,
      initialTime: _birthTime ?? const TimeOfDay(hour: 12, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.auroraStart,
              surface: isDark ? AppColors.surfaceDark : AppColors.lightSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() => _birthTime = time);
    }
  }

  void _showLocationPicker(
    BuildContext context,
    bool isDark,
    AppLanguage language,
  ) {
    final popularCities = [
      {'name': 'İstanbul', 'lat': 41.0082, 'lng': 28.9784},
      {'name': 'Ankara', 'lat': 39.9334, 'lng': 32.8597},
      {'name': 'İzmir', 'lat': 38.4192, 'lng': 27.1287},
      {'name': 'Bursa', 'lat': 40.1885, 'lng': 29.0610},
      {'name': 'Antalya', 'lat': 36.8969, 'lng': 30.7133},
      {'name': 'Adana', 'lat': 37.0000, 'lng': 35.3213},
      {'name': 'Konya', 'lat': 37.8746, 'lng': 32.4932},
      {'name': 'Gaziantep', 'lat': 37.0662, 'lng': 37.3833},
      {'name': 'Mersin', 'lat': 36.8121, 'lng': 34.6415},
      {'name': 'Kayseri', 'lat': 38.7312, 'lng': 35.4787},
      {'name': 'Eskişehir', 'lat': 39.7767, 'lng': 30.5206},
      {'name': 'Diyarbakır', 'lat': 37.9144, 'lng': 40.2306},
      {'name': 'Samsun', 'lat': 41.2867, 'lng': 36.3300},
      {'name': 'Denizli', 'lat': 37.7765, 'lng': 29.0864},
      {'name': 'Trabzon', 'lat': 41.0027, 'lng': 39.7168},
      {'name': 'Malatya', 'lat': 38.3552, 'lng': 38.3095},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.lightSurface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => StatefulBuilder(
          builder: (context, setModalState) => Container(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(80),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),
                Text(
                  '📍 ${L10nService.get('input.select_city', language)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  L10nService.get('input.required_for_moon', language),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),
                // Arama alanı
                TextField(
                  controller: _locationController,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: L10nService.get('input.search_city', language),
                    hintStyle: TextStyle(
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    filled: true,
                    fillColor: isDark
                        ? AppColors.surfaceLight.withAlpha(30)
                        : AppColors.lightSurfaceVariant,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusMd,
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    // Filter cities
                    setModalState(() {});
                  },
                ),
                const SizedBox(height: AppConstants.spacingMd),
                Text(
                  L10nService.get('input.popular_cities', language),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.starGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: popularCities.length,
                    itemBuilder: (context, index) {
                      final city = popularCities[index];
                      final searchTerm = _locationController.text.toLowerCase();
                      final cityName = (city['name'] as String).toLowerCase();

                      if (searchTerm.isNotEmpty &&
                          !cityName.contains(searchTerm)) {
                        return const SizedBox.shrink();
                      }

                      return ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.cosmicPurple.withAlpha(30),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_city,
                            color: AppColors.cosmicPurple,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          city['name'] as String,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          L10nService.get('input.turkey_kktc', language),
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                            fontSize: 12,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                        onTap: () {
                          setState(() {
                            _birthPlace = city['name'] as String;
                            _birthLatitude = city['lat'] as double;
                            _birthLongitude = city['lng'] as double;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEmojiPicker(
    BuildContext context,
    bool isDark,
    AppLanguage language,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              L10nService.get('profile.emoji_select', language),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.spacingLg),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _emojiOptions.map((emoji) {
                final isSelected = _avatarEmoji == emoji;
                return GestureDetector(
                  onTap: () {
                    setState(() => _avatarEmoji = emoji);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.auroraStart.withAlpha(40)
                          : (isDark
                                ? AppColors.surfaceLight.withAlpha(30)
                                : AppColors.lightSurfaceVariant),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.auroraStart
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(emoji, style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppConstants.spacingLg),
          ],
        ),
      ),
    );
  }

  void _saveProfile(AppLanguage language) {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10nService.get('input.please_enter_name', language)),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
          ),
        ),
      );
      return;
    }

    final sign = ZodiacSignExtension.fromDate(_birthDate);

    // Convert time to string format
    String? birthTimeStr;
    if (_birthTime != null) {
      birthTimeStr =
          '${_birthTime!.hour.toString().padLeft(2, '0')}:${_birthTime!.minute.toString().padLeft(2, '0')}';
    }

    final profile = UserProfile(
      name: _nameController.text,
      birthDate: _birthDate,
      birthTime: birthTimeStr,
      birthPlace: _birthPlace,
      birthLatitude: _birthLatitude,
      birthLongitude: _birthLongitude,
      sunSign: sign,
      relationship: _relationship,
      avatarEmoji: _avatarEmoji,
    );

    widget.onSave(profile);
  }
}
