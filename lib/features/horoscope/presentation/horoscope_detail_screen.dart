import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/ad_banner_widget.dart';

class HoroscopeDetailScreen extends ConsumerWidget {
  final String signName;

  const HoroscopeDetailScreen({super.key, required this.signName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sign = ZodiacSign.values.firstWhere(
      (s) => s.name.toLowerCase() == signName.toLowerCase(),
      orElse: () => ZodiacSign.aries,
    );

    final horoscope = ref.watch(dailyHoroscopeProvider(sign));

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(context, sign),
                // Content
                Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date and luck
                      _buildDateSection(context, horoscope.luckRating),
                      const SizedBox(height: AppConstants.spacingXl),
                      // Main horoscope
                      _buildMainHoroscope(context, horoscope.summary, sign),
                      const SizedBox(height: AppConstants.spacingXl),
                      // Categories
                      _buildCategoryCard(
                        context,
                        'Love & Relationships',
                        Icons.favorite,
                        horoscope.loveAdvice,
                        AppColors.fireElement,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),
                      _buildCategoryCard(
                        context,
                        'Career & Finance',
                        Icons.work,
                        horoscope.careerAdvice,
                        AppColors.earthElement,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),
                      _buildCategoryCard(
                        context,
                        'Health & Wellness',
                        Icons.spa,
                        horoscope.healthAdvice,
                        AppColors.airElement,
                      ),
                      const SizedBox(height: AppConstants.spacingXl),
                      // Quick facts
                      _buildQuickFacts(context, horoscope.mood,
                          horoscope.luckyColor, horoscope.luckyNumber, sign),
                      const SizedBox(height: AppConstants.spacingXl),
                      // Sign info
                      _buildSignInfo(context, sign),
                      const SizedBox(height: AppConstants.spacingLg),
                      // Ad Banner
                      const InlineAdBanner(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ZodiacSign sign) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            sign.color.withValues(alpha: 0.3),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                color: AppColors.textPrimary,
                onPressed: () => context.pop(),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.share),
                color: AppColors.textPrimary,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: sign.color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: sign.color.withValues(alpha: 0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Text(
              sign.symbol,
              style: TextStyle(fontSize: 56, color: sign.color),
            ),
          ).animate().fadeIn(duration: 400.ms).scale(
                begin: const Offset(0.8, 0.8),
                curve: Curves.elasticOut,
              ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            sign.name,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: sign.color,
                ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          Text(
            sign.dateRange,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
        ],
      ),
    );
  }

  Widget _buildDateSection(BuildContext context, int luckRating) {
    final today = DateTime.now();
    final dateStr = DateFormat('EEEE, MMMM d').format(today);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Reading',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textMuted,
                    letterSpacing: 1.5,
                  ),
            ),
            Text(
              dateStr,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Luck Rating',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textMuted,
                    letterSpacing: 1.5,
                  ),
            ),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < luckRating ? Icons.star : Icons.star_border,
                  size: 18,
                  color: AppColors.starGold,
                );
              }),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
  }

  Widget _buildMainHoroscope(
      BuildContext context, String summary, ZodiacSign sign) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            sign.color.withValues(alpha: 0.15),
            AppColors.surfaceDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: sign.color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: sign.color, size: 20),
              const SizedBox(width: 8),
              Text(
                'Daily Overview',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: sign.color,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            summary,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.8,
                ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 400.ms);
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon,
      String content, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 400.ms);
  }

  Widget _buildQuickFacts(BuildContext context, String mood, String luckyColor,
      String luckyNumber, ZodiacSign sign) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Cosmic Tips',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Row(
            children: [
              Expanded(
                child: _QuickFactItem(
                  icon: Icons.mood,
                  label: 'Mood',
                  value: mood,
                  color: sign.color,
                ),
              ),
              Expanded(
                child: _QuickFactItem(
                  icon: Icons.palette,
                  label: 'Lucky Color',
                  value: luckyColor,
                  color: sign.color,
                ),
              ),
              Expanded(
                child: _QuickFactItem(
                  icon: Icons.tag,
                  label: 'Lucky Number',
                  value: luckyNumber,
                  color: sign.color,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 700.ms, duration: 400.ms);
  }

  Widget _buildSignInfo(BuildContext context, ZodiacSign sign) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About ${sign.name}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: sign.color,
                ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            sign.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoTag(
                  label: sign.element.name, icon: null, color: sign.element.color),
              _InfoTag(label: sign.modality.name, icon: null, color: sign.color),
              _InfoTag(
                  label: 'Ruled by ${sign.rulingPlanet}',
                  icon: null,
                  color: AppColors.starGold),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Text(
            'Key Traits',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sign.traits.map((trait) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: sign.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  trait,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: sign.color,
                      ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms, duration: 400.ms);
  }
}

class _QuickFactItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _QuickFactItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textMuted,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _InfoTag extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;

  const _InfoTag({
    required this.label,
    this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}
