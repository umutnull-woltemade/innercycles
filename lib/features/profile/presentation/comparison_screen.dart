// ════════════════════════════════════════════════════════════════════════════
// COMPARISON SCREEN - Profile Comparison (App Store 4.3(b) Compliant)
// ════════════════════════════════════════════════════════════════════════════
// This screen allows users to compare profiles for pattern awareness.
// All astrology-specific comparisons have been removed.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';

class ComparisonScreen extends ConsumerStatefulWidget {
  const ComparisonScreen({super.key});

  @override
  ConsumerState<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends ConsumerState<ComparisonScreen> {
  List<UserProfile?> _selectedProfiles = [null, null];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final primary = ref.read(primaryProfileProvider);
      if (primary != null && _selectedProfiles[0] == null) {
        setState(() {
          _selectedProfiles[0] = primary;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profiles = ref.watch(savedProfilesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final isEnglish = language == AppLanguage.en;

    return Scaffold(
      backgroundColor: isDark ? AppColors.deepSpace : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black87,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isEnglish ? 'Compare Profiles' : L10nService.get('comparison.title', language),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card
              _buildInfoCard(isDark, isEnglish, language),
              const SizedBox(height: 24),

              // Profile Selection
              _buildProfileSelection(profiles, isDark, isEnglish, language),
              const SizedBox(height: 24),

              // Comparison Results (if two profiles selected)
              if (_selectedProfiles[0] != null && _selectedProfiles[1] != null)
                _buildComparisonResult(isDark, isEnglish, language),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(bool isDark, bool isEnglish, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black12,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isEnglish
                  ? 'Compare profiles to see shared patterns and unique traits.'
                  : L10nService.get('comparison.info', language),
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildProfileSelection(
    List<UserProfile> profiles,
    bool isDark,
    bool isEnglish,
    AppLanguage language,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEnglish ? 'Select Profiles' : L10nService.get('comparison.select_profiles', language),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildProfileCard(0, profiles, isDark, isEnglish, language),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildProfileCard(1, profiles, isDark, isEnglish, language),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileCard(
    int index,
    List<UserProfile> profiles,
    bool isDark,
    bool isEnglish,
    AppLanguage language,
  ) {
    final selected = _selectedProfiles[index];

    return GestureDetector(
      onTap: () => _showProfilePicker(index, profiles, isDark),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected != null
                ? AppColors.cosmicPurple
                : (isDark ? Colors.white12 : Colors.black12),
            width: selected != null ? 2 : 1,
          ),
        ),
        child: selected != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    selected.displayEmoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    selected.name ?? (isEnglish ? 'Profile' : L10nService.get('profile.default_name', language)),
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${selected.age} ${isEnglish ? "years" : L10nService.get("common.years", language)}',
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black45,
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: isDark ? Colors.white38 : Colors.black26,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isEnglish ? 'Select Profile' : L10nService.get('comparison.select', language),
                    style: TextStyle(
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                ],
              ),
      ),
    ).animate().fadeIn(delay: (100 * index).ms, duration: 400.ms);
  }

  void _showProfilePicker(int index, List<UserProfile> profiles, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.deepSpace : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ...profiles.map((profile) => ListTile(
                leading: Text(profile.displayEmoji, style: const TextStyle(fontSize: 24)),
                title: Text(
                  profile.name ?? 'Profile',
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                ),
                subtitle: Text(
                  '${profile.age} years',
                  style: TextStyle(color: isDark ? Colors.white54 : Colors.black45),
                ),
                onTap: () {
                  setState(() {
                    _selectedProfiles[index] = profile;
                  });
                  Navigator.pop(context);
                },
              )),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildComparisonResult(bool isDark, bool isEnglish, AppLanguage language) {
    final profile1 = _selectedProfiles[0]!;
    final profile2 = _selectedProfiles[1]!;

    // Calculate age difference
    final ageDiff = (profile1.age - profile2.age).abs();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEnglish ? 'Comparison' : L10nService.get('comparison.result_title', language),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        // Age Comparison Card
        _buildResultCard(
          isDark,
          Icons.cake_outlined,
          isEnglish ? 'Age Difference' : L10nService.get('comparison.age_diff', language),
          '$ageDiff ${isEnglish ? "years" : L10nService.get("common.years", language)}',
        ),

        // Birth Month Card
        _buildResultCard(
          isDark,
          Icons.calendar_month,
          isEnglish ? 'Birth Months' : L10nService.get('comparison.birth_months', language),
          '${_getMonthName(profile1.birthDate.month)} & ${_getMonthName(profile2.birthDate.month)}',
        ),

        // Shared Patterns Card
        _buildResultCard(
          isDark,
          Icons.pattern,
          isEnglish ? 'Pattern Insight' : L10nService.get('comparison.pattern', language),
          _getPatternInsight(profile1, profile2, isEnglish),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildResultCard(bool isDark, IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.cosmicPurple),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black54,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String _getPatternInsight(UserProfile p1, UserProfile p2, bool isEnglish) {
    final ageDiff = (p1.age - p2.age).abs();

    if (ageDiff == 0) {
      return isEnglish
          ? 'Same age - may share generational experiences'
          : 'Aynı yaş - kuşak deneyimlerini paylaşabilir';
    } else if (ageDiff < 5) {
      return isEnglish
          ? 'Close in age - likely share cultural references'
          : 'Yakın yaş - muhtemelen kültürel referansları paylaşır';
    } else if (ageDiff < 10) {
      return isEnglish
          ? 'Moderate age gap - different life stages'
          : 'Orta yaş farkı - farklı yaşam evreleri';
    } else {
      return isEnglish
          ? 'Significant age difference - diverse perspectives'
          : 'Önemli yaş farkı - çeşitli bakış açıları';
    }
  }
}
