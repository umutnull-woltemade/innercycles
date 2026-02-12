import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../data/providers/app_providers.dart';
import '../../data/services/l10n_service.dart';

/// FAQ Section Widget
/// SEO-optimized expandable FAQ section with Schema.org markup support
class FaqSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<FaqItem> items;
  final bool initiallyExpanded;
  final AppLanguage language;

  const FaqSection({
    super.key,
    required this.title,
    this.subtitle,
    required this.items,
    this.initiallyExpanded = false,
    this.language = AppLanguage.tr,
  });

  /// Create FAQ section for zodiac signs
  factory FaqSection.zodiacSign(String signName, AppLanguage language) {
    return FaqSection(
      title: L10nService.get(
        'faq.zodiac_title',
        language,
      ).replaceAll('{sign}', signName),
      subtitle: L10nService.get('faq.zodiac_subtitle', language),
      language: language,
      items: [
        FaqItem(
          question: L10nService.get(
            'faq.zodiac_q1',
            language,
          ).replaceAll('{sign}', signName),
          answer: L10nService.get(
            'faq.zodiac_a1',
            language,
          ).replaceAll('{sign}', signName),
        ),
        FaqItem(
          question: L10nService.get(
            'faq.zodiac_q2',
            language,
          ).replaceAll('{sign}', signName),
          answer: L10nService.get(
            'faq.zodiac_a2',
            language,
          ).replaceAll('{sign}', signName),
        ),
        FaqItem(
          question: L10nService.get(
            'faq.zodiac_q3',
            language,
          ).replaceAll('{sign}', signName),
          answer: L10nService.get(
            'faq.zodiac_a3',
            language,
          ).replaceAll('{sign}', signName),
        ),
        FaqItem(
          question: L10nService.get(
            'faq.zodiac_q4',
            language,
          ).replaceAll('{sign}', signName),
          answer: L10nService.get(
            'faq.zodiac_a4',
            language,
          ).replaceAll('{sign}', signName),
        ),
      ],
    );
  }

  /// Create FAQ section for birth chart
  factory FaqSection.birthChart(AppLanguage language) {
    return FaqSection(
      title: L10nService.get('faq.birth_chart_title', language),
      subtitle: L10nService.get('faq.birth_chart_subtitle', language),
      language: language,
      items: [
        FaqItem(
          question: L10nService.get('faq.birth_chart_q1', language),
          answer: L10nService.get('faq.birth_chart_a1', language),
        ),
        FaqItem(
          question: L10nService.get('faq.birth_chart_q2', language),
          answer: L10nService.get('faq.birth_chart_a2', language),
        ),
        FaqItem(
          question: L10nService.get('faq.birth_chart_q3', language),
          answer: L10nService.get('faq.birth_chart_a3', language),
        ),
        FaqItem(
          question: L10nService.get('faq.birth_chart_q4', language),
          answer: L10nService.get('faq.birth_chart_a4', language),
        ),
      ],
    );
  }

  /// Create FAQ section for tarot
  factory FaqSection.tarot(AppLanguage language) {
    return FaqSection(
      title: L10nService.get('faq.tarot_title', language),
      subtitle: L10nService.get('faq.tarot_subtitle', language),
      language: language,
      items: [
        FaqItem(
          question: L10nService.get('faq.tarot_q1', language),
          answer: L10nService.get('faq.tarot_a1', language),
        ),
        FaqItem(
          question: L10nService.get('faq.tarot_q2', language),
          answer: L10nService.get('faq.tarot_a2', language),
        ),
        FaqItem(
          question: L10nService.get('faq.tarot_q3', language),
          answer: L10nService.get('faq.tarot_a3', language),
        ),
        FaqItem(
          question: L10nService.get('faq.tarot_q4', language),
          answer: L10nService.get('faq.tarot_a4', language),
        ),
      ],
    );
  }

  /// Create FAQ section for numerology
  factory FaqSection.numerology(AppLanguage language) {
    return FaqSection(
      title: L10nService.get('faq.numerology_title', language),
      subtitle: L10nService.get('faq.numerology_subtitle', language),
      language: language,
      items: [
        FaqItem(
          question: L10nService.get('faq.numerology_q1', language),
          answer: L10nService.get('faq.numerology_a1', language),
        ),
        FaqItem(
          question: L10nService.get('faq.numerology_q2', language),
          answer: L10nService.get('faq.numerology_a2', language),
        ),
        FaqItem(
          question: L10nService.get('faq.numerology_q3', language),
          answer: L10nService.get('faq.numerology_a3', language),
        ),
        FaqItem(
          question: L10nService.get('faq.numerology_q4', language),
          answer: L10nService.get('faq.numerology_a4', language),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingMd,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.help_outline,
                      color: isDark
                          ? AppColors.starGold
                          : AppColors.lightStarGold,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Text(
                      subtitle!,
                      style: GoogleFonts.raleway(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.textSecondary.withValues(alpha: 0.7)
                            : AppColors.lightTextSecondary.withValues(
                                alpha: 0.8,
                              ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          // FAQ Items
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return _FaqItemWidget(
                  item: item,
                  initiallyExpanded: initiallyExpanded && index == 0,
                )
                .animate(delay: Duration(milliseconds: 50 * index))
                .fadeIn(duration: 300.ms);
          }),
        ],
      ),
    );
  }
}

/// Single FAQ item model
class FaqItem {
  final String question;
  final String answer;

  const FaqItem({required this.question, required this.answer});
}

/// Expandable FAQ item widget
class _FaqItemWidget extends StatefulWidget {
  final FaqItem item;
  final bool initiallyExpanded;

  const _FaqItemWidget({required this.item, this.initiallyExpanded = false});

  @override
  State<_FaqItemWidget> createState() => _FaqItemWidgetState();
}

class _FaqItemWidgetState extends State<_FaqItemWidget> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceLight.withValues(
                alpha: _isExpanded ? 0.08 : 0.05,
              )
            : (_isExpanded
                  ? AppColors.lightCard
                  : AppColors.lightSurfaceVariant),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? (_isExpanded
                    ? AppColors.starGold.withValues(alpha: 0.2)
                    : AppColors.textMuted.withValues(alpha: 0.1))
              : (_isExpanded
                    ? AppColors.lightStarGold.withValues(alpha: 0.3)
                    : AppColors.lightTextMuted.withValues(alpha: 0.15)),
          width: _isExpanded ? 1.5 : 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
            vertical: AppConstants.spacingSm,
          ),
          childrenPadding: EdgeInsets.zero,
          initiallyExpanded: widget.initiallyExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          leading: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.starGold.withValues(
                      alpha: _isExpanded ? 0.2 : 0.1,
                    )
                  : AppColors.lightStarGold.withValues(
                      alpha: _isExpanded ? 0.2 : 0.1,
                    ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '?',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.starGold : AppColors.lightStarGold,
                ),
              ),
            ),
          ),
          title: Text(
            widget.item.question,
            style: GoogleFonts.raleway(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
              height: 1.4,
            ),
          ),
          trailing: AnimatedRotation(
            turns: _isExpanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.expand_more,
              color: isDark
                  ? (_isExpanded ? AppColors.starGold : AppColors.textMuted)
                  : (_isExpanded
                        ? AppColors.lightStarGold
                        : AppColors.lightTextMuted),
            ),
          ),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                AppConstants.spacingLg + 32 + AppConstants.spacingMd,
                0,
                AppConstants.spacingLg,
                AppConstants.spacingLg,
              ),
              child: Text(
                widget.item.answer,
                style: GoogleFonts.raleway(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact FAQ for inline usage
class FaqInline extends StatelessWidget {
  final String question;
  final String answer;

  const FaqInline({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceLight.withValues(alpha: 0.05)
            : AppColors.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark
              ? AppColors.textMuted.withValues(alpha: 0.1)
              : AppColors.lightTextMuted.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.help_outline,
                size: 16,
                color: isDark ? AppColors.starGold : AppColors.lightStarGold,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  question,
                  style: GoogleFonts.raleway(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              answer,
              style: GoogleFonts.raleway(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
