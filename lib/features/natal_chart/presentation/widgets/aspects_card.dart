import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/aspect.dart';
import '../../../../data/models/natal_chart.dart';
import '../../../../data/models/planet.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/l10n_service.dart';

class AspectsCard extends ConsumerStatefulWidget {
  final NatalChart chart;

  const AspectsCard({super.key, required this.chart});

  @override
  ConsumerState<AspectsCard> createState() => _AspectsCardState();
}

class _AspectsCardState extends ConsumerState<AspectsCard> {
  bool _showMajorOnly = true;

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final aspects = _showMajorOnly
        ? widget.chart.majorAspects
        : widget.chart.aspects;

    // Group by type
    final harmoniousAspects = aspects
        .where((a) => a.type.isHarmonious)
        .toList();
    final challengingAspects = aspects
        .where((a) => a.type.isChallenging)
        .toList();
    final neutralAspects = aspects
        .where((a) => !a.type.isHarmonious && !a.type.isChallenging)
        .toList();

    return Column(
      children: [
        // Filter toggle
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            border: Border.all(color: Colors.white.withAlpha(25)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${L10nService.get('aspects.title', language)} (${aspects.length})',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      L10nService.get('aspects.subtitle', language),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    L10nService.get('aspects.filter_main_only', language),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  Switch(
                    value: _showMajorOnly,
                    onChanged: (value) {
                      setState(() => _showMajorOnly = value);
                    },
                    activeTrackColor: AppColors.auroraStart.withAlpha(128),
                    thumbColor: WidgetStateProperty.all(AppColors.auroraStart),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),

        // Aspect type summary
        _buildAspectSummary(
          context,
          language,
          harmoniousAspects,
          challengingAspects,
        ),
        const SizedBox(height: AppConstants.spacingMd),

        // Harmonious aspects
        if (harmoniousAspects.isNotEmpty)
          _buildAspectSection(
            context,
            language,
            L10nService.get('aspects.harmonious', language),
            L10nService.get('aspects.harmonious_desc', language),
            harmoniousAspects,
            AppColors.success,
            100,
          ),
        if (harmoniousAspects.isNotEmpty)
          const SizedBox(height: AppConstants.spacingMd),

        // Challenging aspects
        if (challengingAspects.isNotEmpty)
          _buildAspectSection(
            context,
            language,
            L10nService.get('aspects.challenging', language),
            L10nService.get('aspects.challenging_desc', language),
            challengingAspects,
            AppColors.error,
            200,
          ),
        if (challengingAspects.isNotEmpty && neutralAspects.isNotEmpty)
          const SizedBox(height: AppConstants.spacingMd),

        // Neutral aspects
        if (neutralAspects.isNotEmpty)
          _buildAspectSection(
            context,
            language,
            L10nService.get('aspects.neutral', language),
            L10nService.get('aspects.neutral_desc', language),
            neutralAspects,
            AppColors.auroraEnd,
            300,
          ),
      ],
    );
  }

  Widget _buildAspectSummary(
    BuildContext context,
    AppLanguage language,
    List<Aspect> harmonious,
    List<Aspect> challenging,
  ) {
    final total = harmonious.length + challenging.length;
    final harmoniousRatio = total > 0
        ? (harmonious.length / total * 100).round()
        : 0;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: Colors.white.withAlpha(25)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _SummaryItem(
                icon: Icons.check_circle,
                label: L10nService.get('aspects.harmonious_label', language),
                count: harmonious.length,
                color: AppColors.success,
              ),
              Container(width: 1, height: 40, color: Colors.white12),
              _SummaryItem(
                icon: Icons.warning,
                label: L10nService.get('aspects.challenging_label', language),
                count: challenging.length,
                color: AppColors.error,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          // Balance bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppColors.error.withAlpha(128),
            ),
            child: FractionallySizedBox(
              widthFactor: harmoniousRatio / 100,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColors.success,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            L10nService.get(
              'aspects.energy_balance',
              language,
            ).replaceAll('{percent}', '$harmoniousRatio'),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 50.ms, duration: 400.ms);
  }

  Widget _buildAspectSection(
    BuildContext context,
    AppLanguage language,
    String title,
    String subtitle,
    List<Aspect> aspects,
    Color accentColor,
    int delayMs,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: accentColor.withAlpha(76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$title (${aspects.length})',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: accentColor),
                      ),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white12),
          ...aspects.asMap().entries.map((entry) {
            final index = entry.key;
            final aspect = entry.value;
            return _AspectRow(
              aspect: aspect,
              language: language,
              isLast: index == aspects.length - 1,
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: delayMs.ms, duration: 400.ms);
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _AspectRow extends StatelessWidget {
  final Aspect aspect;
  final AppLanguage language;
  final bool isLast;

  const _AspectRow({
    required this.aspect,
    required this.language,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final p1Symbol = PlanetExtension(aspect.planet1).symbol;
    final p1Color = PlanetExtension(aspect.planet1).color;
    final p1Name = PlanetExtension(aspect.planet1).localizedName(language);
    final p2Symbol = PlanetExtension(aspect.planet2).symbol;
    final p2Color = PlanetExtension(aspect.planet2).color;
    final p2Name = PlanetExtension(aspect.planet2).localizedName(language);

    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: 0,
      ),
      childrenPadding: const EdgeInsets.only(
        left: AppConstants.spacingMd,
        right: AppConstants.spacingMd,
        bottom: AppConstants.spacingMd,
      ),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: aspect.type.color.withAlpha(51),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            aspect.type.symbol,
            style: TextStyle(fontSize: 18, color: aspect.type.color),
          ),
        ),
      ),
      title: Row(
        children: [
          Text(p1Symbol, style: TextStyle(fontSize: 16, color: p1Color)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              aspect.type.symbol,
              style: TextStyle(fontSize: 14, color: aspect.type.color),
            ),
          ),
          Text(p2Symbol, style: TextStyle(fontSize: 16, color: p2Color)),
          const SizedBox(width: 8),
          Text(
            aspect.type.nameTr,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
      subtitle: Text(
        '$p1Name - $p2Name',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            aspect.orb.toStringAsFixed(1),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          // Strength indicator
          Container(
            width: 50,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.white12,
            ),
            child: FractionallySizedBox(
              widthFactor: aspect.strength / 100,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: aspect.type.color,
                ),
              ),
            ),
          ),
        ],
      ),
      iconColor: AppColors.textMuted,
      collapsedIconColor: AppColors.textMuted,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight.withAlpha(76),
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _InfoChip(
                    label: aspect.type.isMajor
                        ? L10nService.get('aspects.main_aspect', language)
                        : L10nService.get('aspects.minor', language),
                    color: aspect.type.isMajor
                        ? AppColors.starGold
                        : AppColors.textMuted,
                  ),
                  const SizedBox(width: 8),
                  _InfoChip(
                    label: L10nService.get(
                      'aspects.strength',
                      language,
                    ).replaceAll('{percent}', '${aspect.strength}'),
                    color: aspect.type.color,
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingMd),
              Text(
                L10nService.get('aspects.interpretation', language),
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: AppColors.starGold),
              ),
              const SizedBox(height: 4),
              Text(
                aspect.interpretation,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;

  const _InfoChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(51),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(128)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}
