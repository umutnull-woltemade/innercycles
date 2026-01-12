import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/models/premium_astrology.dart';
import '../../../data/services/premium_astrology_service.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';

class DraconicChartScreen extends ConsumerStatefulWidget {
  const DraconicChartScreen({super.key});

  @override
  ConsumerState<DraconicChartScreen> createState() => _DraconicChartScreenState();
}

class _DraconicChartScreenState extends ConsumerState<DraconicChartScreen> {
  final _service = PremiumAstrologyService();

  DraconicChart? _chart;

  @override
  void initState() {
    super.initState();
    // Auto-generate chart after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateChart();
    });
  }

  void _generateChart() {
    final userProfile = ref.read(userProfileProvider);
    if (userProfile == null) return;

    setState(() {
      _chart = _service.generateDraconicChart(
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
                      if (_chart != null) ...[
                        _buildDraconicOverviewCard(isDark),
                        const SizedBox(height: AppConstants.spacingMd),
                        _buildSoulPurposeCard(isDark),
                        const SizedBox(height: AppConstants.spacingMd),
                        _buildKarmicLessonsCard(isDark),
                        const SizedBox(height: AppConstants.spacingMd),
                        _buildSpiritualGiftsCard(isDark),
                        const SizedBox(height: AppConstants.spacingMd),
                        _buildPastLifeCard(isDark),
                        const SizedBox(height: AppConstants.spacingMd),
                        _buildEvolutionaryPathCard(isDark),
                        const SizedBox(height: AppConstants.spacingMd),
                        _buildPlanetPositionsCard(isDark),
                        const SizedBox(height: AppConstants.spacingXxl),
                      ] else ...[
                        const SizedBox(height: 100),
                        const CircularProgressIndicator(color: AppColors.mystic),
                        const SizedBox(height: 16),
                        Text(
                          'Harita olusturuluyor...',
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
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
          Expanded(
            child: Text(
              'Drakonik Harita',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.mystic.withValues(alpha: 0.3),
            AppColors.cosmic.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: AppColors.mystic.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          const Text('', style: TextStyle(fontSize: 32)),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ruh Seviyesi Astroloji',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
                Text(
                  'Ruhunuzun gercek amacini ve gecmis yasam izlerini kesfedin',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : AppColors.textLight,
                  ),
                ),
              ],
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
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: AppColors.mystic.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: AppColors.mystic,
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

  Widget _buildDraconicOverviewCard(bool isDark) {
    if (_chart == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.mystic.withValues(alpha: 0.2),
            AppColors.cosmic.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: AppColors.mystic.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Drakonik Uclusu',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDraconicSign(
                'Gunes',
                _chart!.draconicSun,
                '',
                isDark,
              ),
              _buildDraconicSign(
                'Ay',
                _chart!.draconicMoon,
                '',
                isDark,
              ),
              _buildDraconicSign(
                'Yukselen',
                _chart!.draconicAscendant,
                '',
                isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDraconicSign(
      String label, ZodiacSign sign, String emoji, bool isDark) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white60 : AppColors.textLight,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: sign.color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: sign.color.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(sign.symbol, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 4),
              Text(
                sign.nameTr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isDark ? Colors.white : AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSoulPurposeCard(bool isDark) {
    if (_chart == null) return const SizedBox.shrink();

    return _buildContentCard(
      icon: '',
      title: 'Ruhsal Amac',
      content: _chart!.soulPurpose,
      isDark: isDark,
      color: AppColors.gold,
    );
  }

  Widget _buildKarmicLessonsCard(bool isDark) {
    if (_chart == null) return const SizedBox.shrink();

    return _buildContentCard(
      icon: '',
      title: 'Karmik Dersler',
      content: _chart!.karmicLessons,
      isDark: isDark,
      color: AppColors.mystic,
    );
  }

  Widget _buildSpiritualGiftsCard(bool isDark) {
    if (_chart == null) return const SizedBox.shrink();

    return _buildContentCard(
      icon: '',
      title: 'Spiritual Hediyeler',
      content: _chart!.spiritualGifts,
      isDark: isDark,
      color: AppColors.cosmic,
    );
  }

  Widget _buildPastLifeCard(bool isDark) {
    if (_chart == null) return const SizedBox.shrink();

    return _buildContentCard(
      icon: '',
      title: 'Gecmis Yasam Gostergeleri',
      content: _chart!.pastLifeIndicators,
      isDark: isDark,
      color: Colors.purple,
    );
  }

  Widget _buildEvolutionaryPathCard(bool isDark) {
    if (_chart == null) return const SizedBox.shrink();

    return _buildContentCard(
      icon: '',
      title: 'Evrimsel Yol',
      content: _chart!.evolutionaryPath,
      isDark: isDark,
      color: Colors.teal,
    );
  }

  Widget _buildContentCard({
    required String icon,
    required String title,
    required String content,
    required bool isDark,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: AppConstants.spacingMd),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.white : AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDark ? Colors.white70 : AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanetPositionsCard(bool isDark) {
    if (_chart == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('', style: TextStyle(fontSize: 24)),
              const SizedBox(width: AppConstants.spacingMd),
              Text(
                'Drakonik Gezegen Pozisyonlari',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.white : AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ..._chart!.planets.map((planet) => _buildPlanetTile(planet, isDark)),
        ],
      ),
    );
  }

  Widget _buildPlanetTile(DraconicPlanet planet, bool isDark) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: planet.sign.color.withValues(alpha: 0.2),
        child: Text(
          _getPlanetEmoji(planet.planet),
          style: const TextStyle(fontSize: 14),
        ),
      ),
      title: Row(
        children: [
          Text(
            planet.planet,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: planet.sign.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${planet.sign.symbol} ${planet.sign.nameTr}',
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white : AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
      subtitle: Text(
        '${planet.degree.toStringAsFixed(1)} - ${planet.house}. Ev',
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.white60 : AppColors.textLight,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 56,
            right: 16,
            bottom: 16,
          ),
          child: Text(
            planet.interpretation,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: isDark ? Colors.white60 : AppColors.textLight,
            ),
          ),
        ),
      ],
    );
  }

  String _getPlanetEmoji(String planet) {
    switch (planet) {
      case 'Gunes':
        return '';
      case 'Ay':
        return '';
      case 'Merkur':
        return '';
      case 'Venus':
        return '';
      case 'Mars':
        return '';
      case 'Jupiter':
        return '';
      case 'Saturn':
        return '';
      case 'Uranus':
        return '';
      case 'Neptun':
        return '';
      case 'Pluto':
        return '';
      default:
        return '';
    }
  }
}
