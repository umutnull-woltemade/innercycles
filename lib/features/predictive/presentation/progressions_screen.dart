import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/models/advanced_astrology.dart';
import '../../../data/services/advanced_astrology_service.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';

class ProgressionsScreen extends ConsumerStatefulWidget {
  const ProgressionsScreen({super.key});

  @override
  ConsumerState<ProgressionsScreen> createState() => _ProgressionsScreenState();
}

class _ProgressionsScreenState extends ConsumerState<ProgressionsScreen> {
  SecondaryProgressions? _progressions;

  @override
  void initState() {
    super.initState();
    // Auto-generate progressions after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateProgressions();
    });
  }

  void _generateProgressions() {
    final userProfile = ref.read(userProfileProvider);
    if (userProfile == null) return;

    setState(() {
      _progressions = AdvancedAstrologyService.generateProgressions(
        birthDate: userProfile.birthDate,
        natalSun: userProfile.sunSign ?? ZodiacSign.aries,
        natalMoon: userProfile.moonSign ?? ZodiacSign.cancer,
        natalAscendant: userProfile.risingSign ?? ZodiacSign.leo,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProfile = ref.watch(userProfileProvider);

    if (userProfile == null) {
      return Scaffold(
        body: CosmicBackground(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('', style: TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                Text(
                  'Profil bulunamadi',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Lutfen once dogum bilgilerinizi girin',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Geri Don'),
                ),
              ],
            ),
          ),
        ),
      );
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
                      _buildInfoBanner(isDark),
                      const SizedBox(height: AppConstants.spacingLg),
                      _buildProfileCard(isDark, userProfile),
                      const SizedBox(height: AppConstants.spacingLg),
                      if (_progressions != null) ...[
                        _buildProgressedPositions(isDark, userProfile),
                        const SizedBox(height: AppConstants.spacingMd),
                        _buildLifePhaseCard(isDark),
                        const SizedBox(height: AppConstants.spacingMd),
                        _buildEmotionalThemeCard(isDark),
                        const SizedBox(height: AppConstants.spacingMd),
                        _buildIdentityCard(isDark),
                        const SizedBox(height: AppConstants.spacingMd),
                        _buildAspectsCard(isDark),
                        const SizedBox(height: AppConstants.spacingMd),
                        _buildEventsCard(isDark),
                        const SizedBox(height: AppConstants.spacingMd),
                        _buildUpcomingCard(isDark),
                        const SizedBox(height: AppConstants.spacingXxl),
                      ] else ...[
                        const SizedBox(height: 100),
                        const CircularProgressIndicator(color: AppColors.auroraStart),
                        const SizedBox(height: 16),
                        Text(
                          'Ilerlemeler hesaplaniyor...',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : AppColors.textLight,
                          ),
                        ),
                      ],
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
            icon: const Icon(Icons.arrow_back),
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: AppConstants.spacingSm),
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.trending_up, color: AppColors.auroraStart, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Ikincil Ilerlemeler',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.auroraStart.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.auroraStart.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.auroraStart),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Ikincil ilerlemeler, "bir gun = bir yil" prensibine dayanir. Natal haritanizin yavas evrimini gosterir.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(bool isDark, dynamic userProfile) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceLight.withValues(alpha: 0.2)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: AppColors.auroraStart,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Profil Bilgileri',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.white : AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildInfoRow(isDark, Icons.person_outline, 'Isim', userProfile.name ?? 'Kullanici'),
          _buildInfoRow(isDark, Icons.cake_outlined, 'Dogum Tarihi', _formatDate(userProfile.birthDate)),
          if (userProfile.sunSign != null)
            _buildInfoRow(isDark, Icons.wb_sunny_outlined, 'Gunes Burcu', userProfile.sunSign!.nameTr),
          if (userProfile.moonSign != null)
            _buildInfoRow(isDark, Icons.nightlight_outlined, 'Ay Burcu', userProfile.moonSign!.nameTr),
          if (userProfile.risingSign != null)
            _buildInfoRow(isDark, Icons.arrow_upward, 'Yukselen', userProfile.risingSign!.nameTr),
        ],
      ),
    );
  }

  Widget _buildInfoRow(bool isDark, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: isDark ? Colors.white54 : AppColors.textLight),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white54 : AppColors.textLight,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : AppColors.textDark,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Ocak', 'Subat', 'Mart', 'Nisan', 'Mayis', 'Haziran',
      'Temmuz', 'Agustos', 'Eylul', 'Ekim', 'Kasim', 'Aralik'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildProgressedPositions(bool isDark, dynamic userProfile) {
    final natalSun = userProfile.sunSign ?? ZodiacSign.aries;
    final natalMoon = userProfile.moonSign ?? ZodiacSign.cancer;
    final natalAscendant = userProfile.risingSign ?? ZodiacSign.leo;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.auroraStart.withValues(alpha: isDark ? 0.3 : 0.15),
            AppColors.auroraEnd.withValues(alpha: isDark ? 0.3 : 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: AppColors.auroraStart.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ilerlemis Pozisyonlar',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.starGold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                ),
                child: Text(
                  '${_progressions!.progressedAge} yas',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.starGold,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Row(
            children: [
              Expanded(
                child: _buildProgressedPlanet(
                  'Gunes',
                  '',
                  natalSun,
                  _progressions!.progressedSun,
                  isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildProgressedPlanet(
                  'Ay',
                  '',
                  natalMoon,
                  _progressions!.progressedMoon,
                  isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildProgressedPlanet(
                  'Yukselen',
                  '',
                  natalAscendant,
                  _progressions!.progressedAscendant,
                  isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              Expanded(
                child: _buildProgressedPlanet(
                  'Merkur',
                  '',
                  natalSun, // Simplified
                  _progressions!.progressedMercury,
                  isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildProgressedPlanet(
                  'Venus',
                  '',
                  natalSun,
                  _progressions!.progressedVenus,
                  isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildProgressedPlanet(
                  'Mars',
                  '',
                  natalSun,
                  _progressions!.progressedMars,
                  isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressedPlanet(
    String name,
    String icon,
    ZodiacSign natal,
    ZodiacSign progressed,
    bool isDark,
  ) {
    final hasChanged = natal != progressed;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceLight.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(8),
        border: hasChanged
            ? Border.all(color: AppColors.starGold.withValues(alpha: 0.5))
            : null,
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          Text(
            name,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 4),
          Text(
            progressed.symbol,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            progressed.nameTr,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          if (hasChanged) ...[
            const SizedBox(height: 2),
            Text(
              '(${natal.nameTr}\'dan)',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.starGold,
                    fontSize: 8,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLifePhaseCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceLight.withValues(alpha: 0.2)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.person, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Mevcut Yasam Evresi',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            _progressions!.currentLifePhase,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionalThemeCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pink.withValues(alpha: isDark ? 0.2 : 0.1),
            Colors.purple.withValues(alpha: isDark ? 0.2 : 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: Colors.pink.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.pink),
              const SizedBox(width: 8),
              Text(
                'Duygusal Tema',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            _progressions!.emotionalTheme,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceLight.withValues(alpha: 0.2)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.orange, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Kimlik Evrimi',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            _progressions!.identityEvolution,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAspectsCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceLight.withValues(alpha: 0.2)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aktif Acilar',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ..._progressions!.activeAspects.map((aspect) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceLight.withValues(alpha: 0.2)
                    : AppColors.lightSurfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'P.${aspect.progressedPlanet} ${aspect.type.symbol} N.${aspect.natalPlanet}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: aspect.isApplying
                              ? Colors.green.withValues(alpha: 0.2)
                              : Colors.orange.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          aspect.isApplying ? 'Yaklasan' : 'Ayrilan',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: aspect.isApplying
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    aspect.interpretation,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEventsCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceLight.withValues(alpha: 0.2)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.event, color: Colors.purple, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Onemli Olaylar',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ..._progressions!.significantEvents.map((event) {
            final isPast = event.date.isBefore(DateTime.now());

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isPast
                    ? Colors.grey.withValues(alpha: 0.1)
                    : Colors.purple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isPast
                      ? Colors.grey.withValues(alpha: 0.3)
                      : Colors.purple.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    event.type.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              event.event,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const Spacer(),
                            Text(
                              '${event.date.day}.${event.date.month}.${event.date.year}',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: isPast ? Colors.grey : Colors.purple,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          event.description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildUpcomingCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.starGold.withValues(alpha: isDark ? 0.2 : 0.1),
            AppColors.celestialGold.withValues(alpha: isDark ? 0.2 : 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.starGold.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.upcoming,
            color: AppColors.starGold,
            size: 32,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            'Gelecek Degisimler',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.starGold,
                ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            _progressions!.upcomingChanges,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
