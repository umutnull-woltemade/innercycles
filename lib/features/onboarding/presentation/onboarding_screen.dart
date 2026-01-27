import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/cities/world_cities.dart';
import '../../../data/services/storage_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/birth_date_picker.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime = const TimeOfDay(hour: 12, minute: 0); // Default 12:00
  String? _userName;
  String? _birthPlace = 'Marmaris, Mugla (Türkiye)'; // Default Marmaris
  double? _birthLatitude = 36.8500; // Marmaris coordinates
  double? _birthLongitude = 28.2667;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() async {
    if (_selectedDate != null) {
      String? birthTimeStr;
      if (_selectedTime != null) {
        birthTimeStr =
            '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
      }

      final profile = UserProfile(
        name: _userName,
        birthDate: _selectedDate!,
        birthTime: birthTimeStr,
        birthPlace: _birthPlace,
        birthLatitude: _birthLatitude,
        birthLongitude: _birthLongitude,
      );

      // Save to state
      ref.read(userProfileProvider.notifier).setProfile(profile);
      ref.read(onboardingCompleteProvider.notifier).state = true;

      // Persist to local storage
      await StorageService.saveUserProfile(profile);
      await StorageService.saveOnboardingComplete(true);

      if (mounted) {
        context.go(Routes.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  children: [
                    _WelcomePage(onContinue: _nextPage),
                    _BirthDataPage(
                      selectedDate: _selectedDate,
                      onDateSelected: (date) {
                        setState(() => _selectedDate = date);
                      },
                      selectedTime: _selectedTime,
                      onTimeSelected: (time) {
                        setState(() => _selectedTime = time);
                      },
                      userName: _userName,
                      onNameChanged: (name) {
                        setState(() => _userName = name);
                      },
                      birthPlace: _birthPlace,
                      onPlaceChanged: (place, lat, lng) {
                        setState(() {
                          _birthPlace = place;
                          _birthLatitude = lat;
                          _birthLongitude = lng;
                        });
                      },
                      onContinue: _nextPage,
                    ),
                    _YourSignPage(
                      selectedDate: _selectedDate,
                      selectedTime: _selectedTime,
                      birthPlace: _birthPlace,
                      onComplete: _completeOnboarding,
                    ),
                  ],
                ),
              ),
              _buildBottomSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      child: Column(
        children: [
          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? AppColors.auroraStart
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: AppConstants.spacingXl),
          // Continue button
          GradientButton(
            label: _currentPage == 2 ? 'Yolculuğa Başla' : 'İlerle',
            icon: _currentPage == 2 ? Icons.auto_awesome : Icons.arrow_forward,
            width: double.infinity,
            onPressed: _canProceed() ? _nextPage : null,
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    if (_currentPage == 1) {
      // All fields are required for accurate chart calculation
      return _userName != null &&
             _userName!.isNotEmpty &&
             _selectedDate != null &&
             _selectedTime != null &&
             _birthPlace != null;
    }
    return true;
  }
}

class _WelcomePage extends StatelessWidget {
  final VoidCallback onContinue;

  const _WelcomePage({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '✨',
            style: TextStyle(fontSize: 40),
          )
              .animate(onPlay: (c) => c.repeat())
              .shimmer(duration: 2.seconds, color: AppColors.starGold),
          const SizedBox(height: AppConstants.spacingLg),
          Text(
            AppConstants.appName,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.starGold,
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                ),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            AppConstants.appTagline,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 18,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
          const SizedBox(height: AppConstants.spacingHuge),
          Text(
            'Evrenin sana fısıldadığı sırları dinle.\nDoğduğun an gökyüzü senin için\nbir harita çizdi, onu keşfet.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  height: 1.8,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 600.ms, duration: 600.ms),
        ],
      ),
    );
  }
}

class _BirthDataPage extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay> onTimeSelected;
  final String? userName;
  final ValueChanged<String> onNameChanged;
  final String? birthPlace;
  final void Function(String place, double lat, double lng) onPlaceChanged;
  final VoidCallback onContinue;

  const _BirthDataPage({
    required this.selectedDate,
    required this.onDateSelected,
    required this.selectedTime,
    required this.onTimeSelected,
    required this.userName,
    required this.onNameChanged,
    required this.birthPlace,
    required this.onPlaceChanged,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Center(
            child: const Text(
              '🌟',
              style: TextStyle(fontSize: 32),
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Center(
            child: Text(
              'Kozmik Kimliğin',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 400.ms),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Center(
            child: Text(
              'Evrenle bağlantını kurmak için bilgilerini gir',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          ),
          const SizedBox(height: AppConstants.spacingXl),

          // Name input
          _buildSectionTitle(context, 'İsim *'),
          const SizedBox(height: 8),
          _NameInput(
            userName: userName,
            onNameChanged: onNameChanged,
          ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
          const SizedBox(height: AppConstants.spacingLg),

          // Birth Date
          _buildSectionTitle(context, 'Doğum Tarihi *'),
          const SizedBox(height: 8),
          BirthDatePicker(
            initialDate: selectedDate,
            onDateChanged: onDateSelected,
          ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
          const SizedBox(height: AppConstants.spacingLg),

          // Birth Time
          _buildSectionTitle(context, 'Doğum Saati *'),
          const SizedBox(height: 8),
          _BirthTimePicker(
            selectedTime: selectedTime,
            onTimeSelected: onTimeSelected,
          ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
          const SizedBox(height: AppConstants.spacingLg),

          // Birth Place
          _buildSectionTitle(context, 'Doğum Yeri *'),
          const SizedBox(height: 8),
          _BirthPlacePicker(
            selectedPlace: birthPlace,
            onPlaceSelected: onPlaceChanged,
          ).animate().fadeIn(delay: 600.ms, duration: 400.ms),

          const SizedBox(height: AppConstants.spacingLg),

          // Info box
          _InfoBox().animate().fadeIn(delay: 700.ms, duration: 400.ms),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
            fontWeight: FontWeight.w500,
          ),
    );
  }
}

class _NameInput extends StatelessWidget {
  final String? userName;
  final ValueChanged<String> onNameChanged;

  const _NameInput({
    required this.userName,
    required this.onNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final hasValue = userName != null && userName!.isNotEmpty;

    return TextField(
      onChanged: onNameChanged,
      style: TextStyle(
        color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: 'İsmin',
        hintStyle: TextStyle(
          color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          fontSize: 15,
        ),
        prefixIcon: Icon(
          Icons.person_outline,
          color: hasValue ? colorScheme.primary : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
        ),
        suffixIcon: hasValue
            ? const Icon(Icons.check_circle, color: AppColors.success, size: 20)
            : null,
        filled: true,
        fillColor: isDark ? AppColors.surfaceDark.withAlpha(128) : AppColors.lightSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: hasValue
                ? colorScheme.primary
                : (isDark ? AppColors.surfaceLight : Colors.grey.shade300),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: colorScheme.primary.withAlpha(isDark ? 25 : 15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withAlpha(isDark ? 76 : 50)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Kozmik haritanın tüm katmanlarını açmak için bilgilerini eksiksiz gir.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BirthTimePicker extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay> onTimeSelected;

  const _BirthTimePicker({
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => _showTimePicker(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark.withAlpha(128) : AppColors.lightSurfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedTime != null
                ? colorScheme.primary
                : (isDark ? AppColors.surfaceLight : Colors.grey.shade300),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time,
              color: selectedTime != null
                  ? colorScheme.primary
                  : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: selectedTime != null
                  ? Text(
                      '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                          ),
                    )
                  : Text(
                      'Saat seç',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                          ),
                    ),
            ),
            if (selectedTime != null)
              const Icon(Icons.check_circle, color: AppColors.success, size: 20),
          ],
        ),
      ),
    );
  }

  void _showTimePicker(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        int selectedHour = selectedTime?.hour ?? 12;
        int selectedMinute = selectedTime?.minute ?? 0;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 350,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('İptal',
                            style: TextStyle(color: isDark ? AppColors.textMuted : AppColors.lightTextMuted)),
                      ),
                      Text(
                        'Doğum Saati',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                            ),
                      ),
                      TextButton(
                        onPressed: () {
                          onTimeSelected(TimeOfDay(
                            hour: selectedHour,
                            minute: selectedMinute,
                          ));
                          Navigator.pop(context);
                        },
                        child: Text('Tamam',
                            style: TextStyle(color: colorScheme.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Row(
                      children: [
                        // Hour picker
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                                initialItem: selectedHour),
                            itemExtent: 40,
                            onSelectedItemChanged: (index) {
                              setModalState(() => selectedHour = index);
                            },
                            children: List.generate(24, (index) {
                              return Center(
                                child: Text(
                                  index.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                                    fontSize: 20,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        Text(
                          ':',
                          style: TextStyle(
                            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Minute picker
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                                initialItem: selectedMinute),
                            itemExtent: 40,
                            onSelectedItemChanged: (index) {
                              setModalState(() => selectedMinute = index);
                            },
                            children: List.generate(60, (index) {
                              return Center(
                                child: Text(
                                  index.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                                    fontSize: 20,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _BirthPlacePicker extends StatefulWidget {
  final String? selectedPlace;
  final void Function(String place, double lat, double lng) onPlaceSelected;

  const _BirthPlacePicker({
    required this.selectedPlace,
    required this.onPlaceSelected,
  });

  @override
  State<_BirthPlacePicker> createState() => _BirthPlacePickerState();
}

class _BirthPlacePickerState extends State<_BirthPlacePicker> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => _showPlacePicker(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark.withAlpha(128) : AppColors.lightSurfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.selectedPlace != null
                ? colorScheme.primary
                : (isDark ? AppColors.surfaceLight : Colors.grey.shade300),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              color: widget.selectedPlace != null
                  ? colorScheme.primary
                  : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: widget.selectedPlace != null
                  ? Text(
                      widget.selectedPlace!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                          ),
                      overflow: TextOverflow.ellipsis,
                    )
                  : Text(
                      'Şehir seç (${WorldCities.sortedCities.length} şehir)',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                          ),
                    ),
            ),
            if (widget.selectedPlace != null)
              const Icon(Icons.check_circle, color: AppColors.success, size: 20),
          ],
        ),
      ),
    );
  }

  void _showPlacePicker(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.lightSurface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        String searchQuery = '';

        return StatefulBuilder(
          builder: (context, setModalState) {
            List<CityData> filteredCities;
            if (searchQuery.isEmpty) {
              filteredCities = WorldCities.sortedCities;
            } else {
              filteredCities = WorldCities.search(searchQuery);
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('İptal',
                            style: TextStyle(color: isDark ? AppColors.textMuted : AppColors.lightTextMuted)),
                      ),
                      Column(
                        children: [
                          Text(
                            'Doğum Yeri',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                                ),
                          ),
                          Text(
                            '${WorldCities.sortedCities.length} şehir',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 60),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Search field
                  TextField(
                    onChanged: (value) {
                      setModalState(() => searchQuery = value);
                    },
                    style: TextStyle(color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
                    decoration: InputDecoration(
                      hintText: 'Şehir veya ülke ara...',
                      hintStyle: TextStyle(color: isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                      prefixIcon:
                          Icon(Icons.search, color: isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                      filled: true,
                      fillColor: isDark ? AppColors.surfaceLight.withAlpha(76) : AppColors.lightSurfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Results count
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${filteredCities.length} sonuç',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredCities.length,
                      itemBuilder: (context, index) {
                        final city = filteredCities[index];
                        final isSelected =
                            widget.selectedPlace == city.displayName;

                        return ListTile(
                          leading: Icon(
                            city.country == 'Türkiye' || city.country == 'KKTC'
                                ? Icons.flag
                                : Icons.public,
                            color: isSelected
                                ? colorScheme.primary
                                : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                          ),
                          title: Text(
                            city.name,
                            style: TextStyle(
                              color: isSelected
                                  ? colorScheme.primary
                                  : (isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            city.region != null
                                ? '${city.region}, ${city.country}'
                                : city.country,
                            style: TextStyle(
                              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                              fontSize: 12,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check_circle,
                                  color: colorScheme.primary)
                              : null,
                          onTap: () {
                            widget.onPlaceSelected(
                              city.displayName,
                              city.lat,
                              city.lng,
                            );
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _YourSignPage extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final String? birthPlace;
  final VoidCallback onComplete;

  const _YourSignPage({
    required this.selectedDate,
    required this.selectedTime,
    required this.birthPlace,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedDate == null) {
      return Center(
        child: Text(
          'Lütfen doğum tarihini gir',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 18,
              ),
        ),
      );
    }

    final sign = ZodiacSignExtension.fromDate(selectedDate!);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Üst bölüm - Burç sembolü ve ismi
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  sign.color.withAlpha(50),
                  sign.color.withAlpha(20),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: sign.color.withAlpha(80)),
            ),
            child: Row(
              children: [
                // Burç sembolü
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: sign.color.withAlpha(40),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: sign.color.withAlpha(100),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Text(
                    sign.symbol,
                    style: TextStyle(fontSize: 48, color: sign.color),
                  ),
                ).animate().scale(begin: const Offset(0.5, 0.5), curve: Curves.elasticOut, duration: 600.ms),
                const SizedBox(width: 16),
                // Burç bilgileri
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Güneş Burcun',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                      ),
                      Text(
                        sign.nameTr,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: sign.color,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        sign.dateRange,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 16),

          // Alt bölüm - Sol: Doğum bilgileri, Sağ: Çözümlenecekler
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sol - Doğum Bilgileri
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight.withAlpha(50),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withAlpha(30)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person_outline, color: AppColors.auroraStart, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Doğum Bilgilerin',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppColors.auroraStart,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildCompactDataRow(context, '📅', 'Tarih', _formatDate(selectedDate!)),
                        if (selectedTime != null)
                          _buildCompactDataRow(
                            context,
                            '🕐',
                            'Saat',
                            '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                          ),
                        if (birthPlace != null)
                          _buildCompactDataRow(context, '📍', 'Yer', birthPlace!),
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideX(begin: -0.2),
                ),

                const SizedBox(width: 12),

                // Sağ - Çözümlenecekler
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: AppColors.cardGradient,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.starGold.withAlpha(60)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.auto_awesome, color: AppColors.starGold, size: 20),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Çözümlenecekler',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: AppColors.starGold,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildCompactFeatureRow(context, '🪐', '10 Gezegen', true),
                        _buildCompactFeatureRow(context, '📐', 'Gezegen Açıları', true),
                        _buildCompactFeatureRow(context, '🏠', '12 Ev Sistemi', selectedTime != null && birthPlace != null),
                        _buildCompactFeatureRow(context, '⬆️', 'Yükselen Burç', selectedTime != null && birthPlace != null),
                        _buildCompactFeatureRow(context, '🧠', 'Psikolojik Profil', true),
                        _buildCompactFeatureRow(context, '🔢', 'Numeroloji', true),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideX(begin: 0.2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactDataRow(BuildContext context, String emoji, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactFeatureRow(BuildContext context, String emoji, String feature, bool available) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 15)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              feature,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: available ? AppColors.textPrimary : AppColors.textMuted,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            available ? Icons.check_circle : Icons.remove_circle_outline,
            size: 16,
            color: available ? AppColors.success : AppColors.textMuted,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
