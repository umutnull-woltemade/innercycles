import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/aspect.dart';
import '../../../../data/models/natal_chart.dart';
import '../../../../data/models/planet.dart';

class AspectsCard extends StatefulWidget {
  final NatalChart chart;

  const AspectsCard({super.key, required this.chart});

  @override
  State<AspectsCard> createState() => _AspectsCardState();
}

class _AspectsCardState extends State<AspectsCard> {
  bool _showMajorOnly = true;

  @override
  Widget build(BuildContext context) {
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
                      'Açılar (${aspects.length})',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Gezegenler arası ilişkiler',
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
                    'Sadece Ana',
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
        _buildAspectSummary(context, harmoniousAspects, challengingAspects),
        const SizedBox(height: AppConstants.spacingMd),

        // Harmonious aspects
        if (harmoniousAspects.isNotEmpty)
          _buildAspectSection(
            context,
            'Uyumlu Açılar',
            'Doğal yetenekler ve kolay akış',
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
            'Zorlu Açılar',
            'Büyüme ve dönüşüm potansiyeli',
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
            'Nötr Açılar',
            'Ayarlama ve farkındalık',
            neutralAspects,
            AppColors.auroraEnd,
            300,
          ),
      ],
    );
  }

  Widget _buildAspectSummary(
    BuildContext context,
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
                label: 'Uyumlu',
                count: harmonious.length,
                color: AppColors.success,
              ),
              Container(width: 1, height: 40, color: Colors.white12),
              _SummaryItem(
                icon: Icons.warning,
                label: 'Zorlu',
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
            'Enerji Dengesi: %$harmoniousRatio Uyumlu',
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
  final bool isLast;

  const _AspectRow({required this.aspect, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final p1Symbol = PlanetExtension(aspect.planet1).symbol;
    final p1Color = PlanetExtension(aspect.planet1).color;
    final p1NameTr = PlanetExtension(aspect.planet1).nameTr;
    final p2Symbol = PlanetExtension(aspect.planet2).symbol;
    final p2Color = PlanetExtension(aspect.planet2).color;
    final p2NameTr = PlanetExtension(aspect.planet2).nameTr;

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
        '$p1NameTr - $p2NameTr',
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
                    label: aspect.type.isMajor ? 'Ana Aci' : 'Minor',
                    color: aspect.type.isMajor
                        ? AppColors.starGold
                        : AppColors.textMuted,
                  ),
                  const SizedBox(width: 8),
                  _InfoChip(
                    label: 'Guc: %${aspect.strength}',
                    color: aspect.type.color,
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingMd),
              Text(
                'Yorum',
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
