import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/natal_chart.dart';
import '../../../../data/models/zodiac_sign.dart' as zodiac;
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/l10n_service.dart';
import '../../../../shared/widgets/interpretive_text.dart';

class ChartSummaryCard extends ConsumerWidget {
  final NatalChart chart;

  const ChartSummaryCard({super.key, required this.chart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final sunSign = chart.sunSign;
    final signColor = zodiac.ZodiacSignExtension(sunSign).color;
    final signSymbol = zodiac.ZodiacSignExtension(sunSign).symbol;
    final signName = zodiac.ZodiacSignExtension(sunSign).localizedName(language);
    final elementName = zodiac.ElementExtension(sunSign.element).localizedName(language);
    final elementSymbol = zodiac.ElementExtension(sunSign.element).symbol;
    final modalityName = zodiac.ModalityExtension(sunSign.modality).localizedName(language);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [signColor.withAlpha(76), AppColors.surfaceDark],
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
                      signName,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(color: signColor),
                    ),
                    Text(
                      '$elementName $elementSymbol | $modalityName',
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
            L10nService.get('chart.birth_date', language),
            _formatDate(chart.birthDate, language),
            Icons.calendar_today,
          ),
          if (chart.birthTime != null)
            _buildInfoRow(
              context,
              L10nService.get('chart.birth_time', language),
              chart.birthTime!,
              Icons.access_time,
            ),
          if (chart.birthPlace != null)
            _buildInfoRow(
              context,
              L10nService.get('chart.birth_place', language),
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
                  label: L10nService.get('chart.planets', language),
                  value: '${chart.planets.length}',
                  icon: Icons.public,
                ),
                _StatItem(
                  label: L10nService.get('chart.houses', language),
                  value: '${chart.houses.length}',
                  icon: Icons.home,
                ),
                _StatItem(
                  label: L10nService.get('chart.aspects', language),
                  value: '${chart.aspects.length}',
                  icon: Icons.compare_arrows,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          // Deep Interpretation Section
          DeepInterpretationCard(
            title: '$signName ${L10nService.get('chart.your_sun', language)}',
            summary: _getSunSignSummary(sunSign, language),
            deepInterpretation: _getSunSignDeepInterpretation(sunSign, language),
            icon: Icons.wb_sunny,
            accentColor: signColor,
            relatedTerms: [signName, elementName, modalityName, L10nService.get('planets.sun', language)],
          ),
        ],
      ),
    );
  }

  String _getSunSignSummary(zodiac.ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('chart.sun_sign_summary.$signKey', language);
  }

  String _getSunSignDeepInterpretation(zodiac.ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('chart.sun_sign_interpretation.$signKey', language);
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
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date, AppLanguage language) {
    final monthKey = [
      'months.january',
      'months.february',
      'months.march',
      'months.april',
      'months.may',
      'months.june',
      'months.july',
      'months.august',
      'months.september',
      'months.october',
      'months.november',
      'months.december',
    ][date.month - 1];
    final monthName = L10nService.get(monthKey, language);
    return '${date.day} $monthName ${date.year}';
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
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: AppColors.textPrimary),
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
