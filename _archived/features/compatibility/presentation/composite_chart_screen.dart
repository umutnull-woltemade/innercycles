import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/models/advanced_astrology.dart';
import '../../../data/services/advanced_astrology_service.dart';
import '../../../data/services/l10n_service.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/entertainment_disclaimer.dart';

class CompositeChartScreen extends ConsumerStatefulWidget {
  const CompositeChartScreen({super.key});

  @override
  ConsumerState<CompositeChartScreen> createState() =>
      _CompositeChartScreenState();
}

class _CompositeChartScreenState extends ConsumerState<CompositeChartScreen> {
  final _partnerNameController = TextEditingController(text: 'Partner');

  ZodiacSign _partnerSun = ZodiacSign.leo;
  ZodiacSign _partnerMoon = ZodiacSign.pisces;

  CompositeChart? _chart;

  void _generateChart() {
    final userProfile = ref.read(userProfileProvider);
    if (userProfile == null) return;

    setState(() {
      _chart = AdvancedAstrologyService.generateCompositeChart(
        person1Name: userProfile.name ?? 'Sen',
        person2Name: _partnerNameController.text,
        person1Sun: userProfile.sunSign,
        person2Sun: _partnerSun,
        person1Moon: userProfile.effectiveMoonSign,
        person2Moon: _partnerMoon,
      );
    });
  }

  @override
  void dispose() {
    _partnerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProfile = ref.watch(userProfileProvider);
    final language = ref.watch(languageProvider);

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
                  L10nService.get('composite.profile_not_found', language),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  L10nService.get('composite.enter_birth_info', language),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: Text(L10nService.get('composite.go_back', language)),
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
              _buildHeader(context, isDark, language),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.spacingLg),
                  child: Column(
                    children: [
                      _buildUserProfileCard(isDark, userProfile, language),
                      const SizedBox(height: AppConstants.spacingMd),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.pink.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.favorite, color: Colors.pink),
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingMd),
                      _buildPartnerInputCard(isDark, language),
                      const SizedBox(height: AppConstants.spacingLg),
                      if (_chart != null) ...[
                        _buildCompatibilityScore(isDark, language),
                        const SizedBox(height: AppConstants.spacingMd),
                        _buildCompositePositions(isDark, language),
                        const SizedBox(height: AppConstants.spacingMd),
                        _buildRelationshipTheme(isDark, language),
                        const SizedBox(height: AppConstants.spacingMd),
                        _buildDynamicsCards(isDark, language),
                        const SizedBox(height: AppConstants.spacingMd),
                        _buildAspectsCard(isDark, language),
                        const SizedBox(height: AppConstants.spacingMd),
                        _buildSoulPurpose(isDark, language),
                        const SizedBox(height: AppConstants.spacingXl),
                        PageFooterWithDisclaimer(
                          brandText: 'Composite Chart — Venus One',
                          disclaimerText: DisclaimerTexts.compatibility(
                            language,
                          ),
                          language: language,
                        ),
                        const SizedBox(height: AppConstants.spacingXxl),
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

  Widget _buildHeader(BuildContext context, bool isDark, AppLanguage language) {
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
                const Icon(Icons.people, color: Colors.pink, size: 24),
                const SizedBox(width: 8),
                Text(
                  L10nService.get('composite.title', language),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileCard(
    bool isDark,
    UserProfile userProfile,
    AppLanguage language,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceLight.withValues(alpha: 0.2)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: Colors.pink.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.pink.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  L10nService.get('composite.person_1_you', language),
                  style: const TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
              const SizedBox(width: 4),
              Text(
                L10nService.get('composite.from_profile', language),
                style: const TextStyle(fontSize: 11, color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildInfoRow(
            isDark,
            Icons.person_outline,
            L10nService.get('composite.name', language),
            userProfile.name ?? L10nService.get('composite.user', language),
          ),
          _buildInfoRow(
            isDark,
            Icons.wb_sunny_outlined,
            L10nService.get('composite.sun', language),
            userProfile.sunSign.localizedName(language),
          ),
          if (userProfile.moonSign != null)
            _buildInfoRow(
              isDark,
              Icons.nightlight_outlined,
              L10nService.get('composite.moon', language),
              userProfile.moonSign!.localizedName(language),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(bool isDark, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isDark ? Colors.white54 : AppColors.textLight,
          ),
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

  Widget _buildPartnerInputCard(bool isDark, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceLight.withValues(alpha: 0.2)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  L10nService.get('composite.person_2_partner', language),
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          TextField(
            controller: _partnerNameController,
            decoration: InputDecoration(
              labelText: L10nService.get('composite.name', language),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSignDropdown(
                  L10nService.get('composite.sun', language),
                  _partnerSun,
                  (sign) => setState(() => _partnerSun = sign),
                  isDark,
                  language,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSignDropdown(
                  L10nService.get('composite.moon', language),
                  _partnerMoon,
                  (sign) => setState(() => _partnerMoon = sign),
                  isDark,
                  language,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingXl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _generateChart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                ),
              ),
              child: Text(
                L10nService.get('composite.create_chart', language),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignDropdown(
    String label,
    ZodiacSign value,
    ValueChanged<ZodiacSign> onChanged,
    bool isDark,
    AppLanguage language,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: isDark ? Colors.white24 : Colors.black12),
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
          ),
          child: DropdownButton<ZodiacSign>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: ZodiacSign.values.map((sign) {
              return DropdownMenuItem(
                value: sign,
                child: Row(
                  children: [
                    Text(sign.symbol),
                    const SizedBox(width: 8),
                    Text(sign.localizedName(language)),
                  ],
                ),
              );
            }).toList(),
            onChanged: (sign) {
              if (sign != null) onChanged(sign);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCompatibilityScore(bool isDark, AppLanguage language) {
    final score = _chart!.overallCompatibility;
    final color = score >= 70
        ? Colors.green
        : score >= 50
        ? Colors.orange
        : Colors.red;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pink.withValues(alpha: isDark ? 0.3 : 0.15),
            Colors.purple.withValues(alpha: isDark ? 0.3 : 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: Colors.pink.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            '${_chart!.person1Name} & ${_chart!.person2Name}',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 10,
                  backgroundColor: color.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Column(
                children: [
                  Text(
                    '$score%',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    L10nService.get('composite.compatibility', language),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompositePositions(bool isDark, AppLanguage language) {
    final positions = [
      {
        'label': L10nService.get('composite.composite_sun', language),
        'sign': _chart!.compositeSun,
        'icon': '',
      },
      {
        'label': L10nService.get('composite.composite_moon', language),
        'sign': _chart!.compositeMoon,
        'icon': '',
      },
      {
        'label': L10nService.get('composite.composite_ascendant', language),
        'sign': _chart!.compositeAscendant,
        'icon': '',
      },
      {
        'label': L10nService.get('composite.composite_venus', language),
        'sign': _chart!.compositeVenus,
        'icon': '',
      },
      {
        'label': L10nService.get('composite.composite_mars', language),
        'sign': _chart!.compositeMars,
        'icon': '',
      },
    ];

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
            L10nService.get('composite.composite_positions', language),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: positions.map((pos) {
              final sign = pos['sign'] as ZodiacSign;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceLight.withValues(alpha: 0.3)
                      : AppColors.lightSurfaceVariant,
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      pos['icon'] as String,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 6),
                    Text(sign.symbol, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Text(
                      sign.localizedName(language),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipTheme(bool isDark, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.withValues(alpha: isDark ? 0.3 : 0.15),
            Colors.indigo.withValues(alpha: isDark ? 0.3 : 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.purple),
              const SizedBox(width: 8),
              Text(
                L10nService.get('composite.relationship_theme', language),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            _chart!.relationshipTheme,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicsCards(bool isDark, AppLanguage language) {
    final dynamics = [
      {
        'title': L10nService.get('composite.emotional_dynamics', language),
        'content': _chart!.emotionalDynamics,
        'icon': Icons.favorite,
        'color': Colors.pink,
      },
      {
        'title': L10nService.get('composite.communication_style', language),
        'content': _chart!.communicationStyle,
        'icon': Icons.chat_bubble,
        'color': Colors.blue,
      },
      {
        'title': L10nService.get('composite.strengths', language),
        'content': _chart!.strengthsOverview,
        'icon': Icons.star,
        'color': Colors.green,
      },
      {
        'title': L10nService.get('composite.challenges', language),
        'content': _chart!.challengesOverview,
        'icon': Icons.warning_amber,
        'color': Colors.orange,
      },
    ];

    return Column(
      children: dynamics.map((d) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
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
                      color: (d['color'] as Color).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      d['icon'] as IconData,
                      color: d['color'] as Color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    d['title'] as String,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                d['content'] as String,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAspectsCard(bool isDark, AppLanguage language) {
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
            L10nService.get('composite.key_aspects', language),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ..._chart!.keyAspects.map((aspect) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: aspect.isHarmonious
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: aspect.isHarmonious
                      ? Colors.green.withValues(alpha: 0.3)
                      : Colors.orange.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${aspect.planet1} ${aspect.type.symbol} ${aspect.planet2}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: aspect.isHarmonious
                              ? Colors.green.withValues(alpha: 0.2)
                              : Colors.orange.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          aspect.type.localizedName(language),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: aspect.isHarmonious
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

  Widget _buildSoulPurpose(bool isDark, AppLanguage language) {
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
          const Icon(Icons.auto_awesome, color: AppColors.starGold, size: 32),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            L10nService.get('composite.soul_purpose', language),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.starGold,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            _chart!.soulPurpose,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
