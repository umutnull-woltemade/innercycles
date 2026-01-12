import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/natal_chart.dart';
import '../../../../data/models/zodiac_sign.dart' as zodiac;

class ChartSummaryCard extends StatelessWidget {
  final NatalChart chart;

  const ChartSummaryCard({super.key, required this.chart});

  @override
  Widget build(BuildContext context) {
    final sunSign = chart.sunSign;
    final signColor = zodiac.ZodiacSignExtension(sunSign).color;
    final signSymbol = zodiac.ZodiacSignExtension(sunSign).symbol;
    final signNameTr = zodiac.ZodiacSignExtension(sunSign).nameTr;
    final elementNameTr = zodiac.ElementExtension(sunSign.element).nameTr;
    final elementSymbol = zodiac.ElementExtension(sunSign.element).symbol;
    final modalityNameTr = zodiac.ModalityExtension(sunSign.modality).nameTr;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            signColor.withAlpha(76),
            AppColors.surfaceDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: signColor.withAlpha(76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: signColor.withAlpha(51),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  signSymbol,
                  style: TextStyle(fontSize: 32, color: signColor),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      signNameTr,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: signColor,
                          ),
                    ),
                    Text(
                      '$elementNameTr $elementSymbol | $modalityNameTr',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLg),
          _buildInfoRow(
            context,
            'Doğum Tarihi',
            _formatDate(chart.birthDate),
            Icons.calendar_today,
          ),
          if (chart.birthTime != null)
            _buildInfoRow(
              context,
              'Doğum Saati',
              chart.birthTime!,
              Icons.access_time,
            ),
          if (chart.birthPlace != null)
            _buildInfoRow(
              context,
              'Doğum Yeri',
              chart.birthPlace!,
              Icons.location_on,
            ),
          const SizedBox(height: AppConstants.spacingMd),
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight.withAlpha(128),
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: 'Gezegen',
                  value: '${chart.planets.length}',
                  icon: Icons.public,
                ),
                _StatItem(
                  label: 'Ev',
                  value: '${chart.houses.length}',
                  icon: Icons.home,
                ),
                _StatItem(
                  label: 'Aci',
                  value: '${chart.aspects.length}',
                  icon: Icons.compare_arrows,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
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
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.auroraStart, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textMuted,
              ),
        ),
      ],
    );
  }
}
