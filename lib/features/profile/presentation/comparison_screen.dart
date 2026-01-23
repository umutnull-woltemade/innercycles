import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/comparison_service.dart';
import '../../../shared/widgets/cosmic_background.dart';

class ComparisonScreen extends ConsumerStatefulWidget {
  const ComparisonScreen({super.key});

  @override
  ConsumerState<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends ConsumerState<ComparisonScreen> {
  ComparisonResult? _result;

  @override
  Widget build(BuildContext context) {
    final profiles = ref.watch(savedProfilesProvider);
    final primary = ref.watch(primaryProfileProvider);
    final profile1 = ref.watch(comparisonProfile1Provider) ?? primary;
    final profile2 = ref.watch(comparisonProfile2Provider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (profile1 != null && profile2 != null && _result == null) {
      _result = ComparisonService.analyze(profile1, profile2);
    }

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isDark),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.spacingLg),
                  child: Column(
                    children: [
                      _buildProfileSelectors(context, ref, profiles, profile1, profile2, isDark),
                      if (_result != null) ...[
                        const SizedBox(height: AppConstants.spacingLg),
                        _buildScoreSection(context, _result!, isDark),
                        const SizedBox(height: AppConstants.spacingLg),
                        _buildCategoryScores(context, _result!, isDark),
                        const SizedBox(height: AppConstants.spacingLg),
                        _buildSummaryCard(context, _result!, isDark),
                        const SizedBox(height: AppConstants.spacingLg),
                        _buildStrengthsCard(context, _result!, isDark),
                        const SizedBox(height: AppConstants.spacingLg),
                        _buildChallengesCard(context, _result!, isDark),
                        const SizedBox(height: AppConstants.spacingLg),
                        _buildAdviceCard(context, _result!, isDark),
                        const SizedBox(height: AppConstants.spacingXl),
                      ] else if (profile1 == null || profile2 == null)
                        _buildEmptyState(context, isDark),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(width: AppConstants.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Burç Uyumu',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Detaylı karşılaştırma analizi',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink.withAlpha(40), Colors.purple.withAlpha(30)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite, color: Colors.pink, size: 24),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildProfileSelectors(
    BuildContext context,
    WidgetRef ref,
    List<UserProfile> profiles,
    UserProfile? profile1,
    UserProfile? profile2,
    bool isDark,
  ) {
    return Row(
      children: [
        Expanded(
          child: _ProfileSelector(
            profile: profile1,
            label: 'Sen',
            profiles: profiles,
            isDark: isDark,
            onSelect: (p) {
              ref.read(comparisonProfile1Provider.notifier).state = p;
              setState(() => _result = null);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.pink.withAlpha(60), Colors.pink.withAlpha(20)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite, color: Colors.pink, size: 20),
          ),
        ),
        Expanded(
          child: _ProfileSelector(
            profile: profile2,
            label: 'Partner',
            profiles: profiles,
            isDark: isDark,
            onSelect: (p) {
              ref.read(comparisonProfile2Provider.notifier).state = p;
              setState(() => _result = null);
            },
          ),
        ),
      ],
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.pink.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.compare_arrows,
              size: 48,
              color: Colors.pink.withAlpha(150),
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Text(
            'İki profil seçin',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            'Karşılaştırma için yukarıdaki\nkutulardan profil seçin',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildScoreSection(BuildContext context, ComparisonResult result, bool isDark) {
    final scoreColor = result.overallScore >= 70
        ? Colors.green
        : result.overallScore >= 50
            ? Colors.amber
            : Colors.red;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pink.withAlpha(25),
            Colors.purple.withAlpha(15),
            isDark ? AppColors.surfaceDark : AppColors.lightCard,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: Colors.pink.withAlpha(40)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildProfileAvatar(result.profile1),
              const SizedBox(width: 16),
              Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          scoreColor.withAlpha(100),
                          scoreColor.withAlpha(30),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: scoreColor.withAlpha(60),
                          blurRadius: 16,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${result.overallScore}%',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: scoreColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            result.emoji,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: scoreColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      result.levelTr,
                      style: TextStyle(
                        color: scoreColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              _buildProfileAvatar(result.profile2),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildProfileAvatar(UserProfile profile) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                profile.sunSign.color.withAlpha(100),
                profile.sunSign.color.withAlpha(30),
              ],
            ),
          ),
          child: Center(
            child: Text(
              profile.avatarEmoji ?? profile.sunSign.symbol,
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          profile.name ?? 'İsimsiz',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        Text(
          profile.sunSign.nameTr,
          style: TextStyle(
            fontSize: 10,
            color: profile.sunSign.color,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryScores(BuildContext context, ComparisonResult result, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _ScoreCard(
            label: 'Aşk',
            score: result.loveScore,
            icon: Icons.favorite,
            color: Colors.pink,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ScoreCard(
            label: 'Arkadaş',
            score: result.friendshipScore,
            icon: Icons.people,
            color: Colors.blue,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ScoreCard(
            label: 'İletişim',
            score: result.communicationScore,
            icon: Icons.chat,
            color: Colors.orange,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ScoreCard(
            label: 'Güven',
            score: result.trustScore,
            icon: Icons.shield,
            color: Colors.green,
            isDark: isDark,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  Widget _buildSummaryCard(BuildContext context, ComparisonResult result, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceLight.withAlpha(20) : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black12,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.purple, size: 20),
              const SizedBox(width: 8),
              Text(
                'Genel Bakış',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            result.summaryTr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                  height: 1.6,
                ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
  }

  Widget _buildStrengthsCard(BuildContext context, ComparisonResult result, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(15),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: Colors.green.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.thumb_up, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Text(
                'Güçlü Yanlar',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...result.strengthsTr.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        s,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                            ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 400.ms);
  }

  Widget _buildChallengesCard(BuildContext context, ComparisonResult result, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: Colors.orange.withAlpha(15),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: Colors.orange.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Text(
                'Dikkat Edilecekler',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...result.challengesTr.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        c,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                            ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 400.ms);
  }

  Widget _buildAdviceCard(BuildContext context, ComparisonResult result, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.withAlpha(20), Colors.pink.withAlpha(15)],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: Colors.purple.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: Colors.purple, size: 20),
              const SizedBox(width: 8),
              Text(
                'Tavsiye',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            result.adviceTr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 700.ms, duration: 400.ms);
  }
}

class _ProfileSelector extends StatelessWidget {
  final UserProfile? profile;
  final String label;
  final List<UserProfile> profiles;
  final bool isDark;
  final Function(UserProfile) onSelect;

  const _ProfileSelector({
    required this.profile,
    required this.label,
    required this.profiles,
    required this.isDark,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showProfilePicker(context),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceLight.withAlpha(20) : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(
            color: profile != null
                ? profile!.sunSign.color.withAlpha(60)
                : (isDark ? Colors.white12 : Colors.black12),
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
            ),
            const SizedBox(height: 8),
            if (profile != null) ...[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      profile!.sunSign.color.withAlpha(100),
                      profile!.sunSign.color.withAlpha(30),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    profile!.avatarEmoji ?? profile!.sunSign.symbol,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                profile!.name ?? 'İsimsiz',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                profile!.sunSign.nameTr,
                style: TextStyle(
                  fontSize: 10,
                  color: profile!.sunSign.color,
                ),
              ),
            ] else ...[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppColors.surfaceLight.withAlpha(40) : Colors.grey.shade200,
                ),
                child: Icon(
                  Icons.person_add,
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Profil Seç',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showProfilePicker(BuildContext context) {
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
              'Profil Seç',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.spacingLg),
            if (profiles.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                child: Text(
                  'Henüz profil eklenmedi',
                  style: TextStyle(
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                ),
              )
            else
              ...profiles.map((p) => ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            p.sunSign.color.withAlpha(100),
                            p.sunSign.color.withAlpha(30),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(p.avatarEmoji ?? p.sunSign.symbol, style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                    title: Text(
                      p.name ?? 'İsimsiz',
                      style: TextStyle(
                        color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    subtitle: Text(
                      p.sunSign.nameTr,
                      style: TextStyle(color: p.sunSign.color),
                    ),
                    onTap: () {
                      onSelect(p);
                      Navigator.pop(context);
                    },
                  )),
            const SizedBox(height: AppConstants.spacingMd),
          ],
        ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final String label;
  final int score;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _ScoreCard({
    required this.label,
    required this.score,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(
            '$score%',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
