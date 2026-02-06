import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/models/extended_horoscope.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/extended_horoscope_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/ad_banner_widget.dart';
import '../../../shared/widgets/interpretive_text.dart';
import '../../../shared/widgets/constellation_widget.dart';
import '../../../shared/widgets/page_bottom_navigation.dart';
import '../../../shared/widgets/breadcrumb_navigation.dart';
import '../../../shared/widgets/faq_section.dart';
import '../../../shared/widgets/next_blocks.dart';
import '../../../shared/widgets/energy_bar.dart';
import '../../../shared/widgets/kadim_not_card.dart';
import '../../../shared/widgets/entertainment_disclaimer.dart';
import '../../../data/services/localization_service.dart';
import '../../../data/services/l10n_service.dart';

class HoroscopeDetailScreen extends ConsumerStatefulWidget {
  final String signName;

  const HoroscopeDetailScreen({super.key, required this.signName});

  @override
  ConsumerState<HoroscopeDetailScreen> createState() => _HoroscopeDetailScreenState();
}

class _HoroscopeDetailScreenState extends ConsumerState<HoroscopeDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ZodiacSign _sign;
  // Cache for language-aware horoscopes
  AppLanguage? _cachedLanguage;
  WeeklyHoroscope? _weeklyHoroscope;
  MonthlyHoroscope? _monthlyHoroscope;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _sign = ZodiacSign.values.firstWhere(
      (s) => s.name.toLowerCase() == widget.signName.toLowerCase(),
      orElse: () => ZodiacSign.aries,
    );
  }

  void _updateHoroscopesIfNeeded(AppLanguage language) {
    if (_cachedLanguage != language || _weeklyHoroscope == null || _monthlyHoroscope == null) {
      _cachedLanguage = language;
      _weeklyHoroscope = ExtendedHoroscopeService.generateWeeklyHoroscope(
        _sign,
        DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
        language: language,
      );
      _monthlyHoroscope = ExtendedHoroscopeService.generateMonthlyHoroscope(
        _sign,
        DateTime.now().month,
        DateTime.now().year,
        language: language,
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final horoscope = ref.watch(dailyHoroscopeProvider((_sign, language)));

    // Update horoscopes when language changes
    _updateHoroscopesIfNeeded(language);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context, _sign),
              // Tab Bar
              _buildTabBar(context, language),
              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Daily Tab
                    _buildDailyContent(context, horoscope, _sign, language),
                    // Weekly Tab
                    _buildWeeklyContent(context, _weeklyHoroscope!, _sign),
                    // Monthly Tab
                    _buildMonthlyContent(context, _monthlyHoroscope!, _sign),
                    // Sign Info Tab
                    _buildSignInfoContent(context, _sign),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, AppLanguage language) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(30),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: _sign.color.withAlpha(60),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        labelColor: _sign.color,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
        unselectedLabelStyle: Theme.of(context).textTheme.labelMedium,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(text: L10n.get('tab_daily', language)),
          Tab(text: L10n.get('tab_weekly', language)),
          Tab(text: L10n.get('tab_monthly', language)),
          Tab(text: L10n.get('tab_zodiac', language)),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 300.ms);
  }

  Widget _buildDailyContent(BuildContext context, dynamic horoscope, ZodiacSign sign, AppLanguage language) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI-QUOTABLE: İlk 3 Bullet (Kısa Cevap)
          _buildQuotableBullets(context, sign, horoscope),
          const SizedBox(height: AppConstants.spacingLg),
          // Date and luck
          _buildDateSection(context, horoscope.luckRating),
          const SizedBox(height: AppConstants.spacingMd),
          // Daily Energy Bar
          DailyEnergyCard.fromLuckRating(horoscope.luckRating, accentColor: sign.color),
          const SizedBox(height: AppConstants.spacingXl),
          // Main horoscope
          _buildMainHoroscope(context, horoscope.summary, sign),
          const SizedBox(height: AppConstants.spacingXl),
          // Categories
          _buildCategoryCard(
            context,
            L10nService.get('horoscope.love_relationships', language),
            Icons.favorite,
            horoscope.loveAdvice,
            AppColors.fireElement,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildCategoryCard(
            context,
            L10nService.get('horoscope.career_finance', language),
            Icons.work,
            horoscope.careerAdvice,
            AppColors.earthElement,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildCategoryCard(
            context,
            L10nService.get('horoscope.health_wellness', language),
            Icons.spa,
            horoscope.healthAdvice,
            AppColors.airElement,
          ),
          const SizedBox(height: AppConstants.spacingXl),
          // Quick facts
          _buildQuickFacts(context, horoscope.mood,
              horoscope.luckyColor, horoscope.luckyNumber, sign),
          const SizedBox(height: AppConstants.spacingLg),
          // Kadim Not - Astroloji bilgeliği
          KadimNotCard(
            title: L10nService.get('horoscope.celestial_sync', language),
            content: L10nService.get('horoscope.celestial_sync', language),
            category: KadimCategory.astrology,
            source: L10nService.get('horoscope.hermetic_teaching', language),
            compact: true,
          ),
          const SizedBox(height: AppConstants.spacingLg),
          // Ad Banner
          const InlineAdBanner(),
          const SizedBox(height: AppConstants.spacingXl),
          // Next Blocks - Sonraki öneriler
          const NextBlocks(currentPage: 'horoscope_detail'),
          const SizedBox(height: AppConstants.spacingXl),
          // Back-Button-Free Navigation
          PageBottomNavigation(currentRoute: '/horoscope/${_sign.name.toLowerCase()}', language: language),
          const SizedBox(height: AppConstants.spacingLg),
          // AI-QUOTABLE: Footer with Disclaimer
          PageFooterWithDisclaimer(
            brandText: L10nService.get('horoscope.astrology_brand', language),
            disclaimerText: DisclaimerTexts.astrology(language),
            language: language,
          ),
          const SizedBox(height: AppConstants.spacingMd),
        ],
      ),
    );
  }

  /// AI-QUOTABLE: İlk 3 bullet - direkt cevap
  Widget _buildQuotableBullets(BuildContext context, ZodiacSign sign, dynamic horoscope) {
    final bullets = _getQuotableBullets(sign, horoscope);
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: sign.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: sign.color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            L10nService.get('horoscope.your_zodiac_readings', ref.read(languageProvider)),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: sign.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...bullets.map((bullet) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 7),
                  decoration: BoxDecoration(
                    color: sign.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AutoGlossaryText(
                    text: bullet,
                    enableHighlighting: true,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  List<String> _getQuotableBullets(ZodiacSign sign, dynamic horoscope) {
    final language = ref.read(languageProvider);
    final signKey = sign.name.toLowerCase();

    // Get localized bullets from JSON
    final bullets = L10nService.getList('horoscope.quotable_bullets.$signKey', language);
    if (bullets.isNotEmpty) {
      return bullets;
    }

    // Fallback to default
    return L10nService.getList('horoscope.quotable_bullets.default', language);
  }

  Widget _buildWeeklyContent(BuildContext context, WeeklyHoroscope horoscope, ZodiacSign sign) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Week range
          _buildWeekHeader(context, horoscope),
          const SizedBox(height: AppConstants.spacingXl),
          // Overview
          _buildWeeklyOverview(context, horoscope.overview, sign),
          const SizedBox(height: AppConstants.spacingMd),
          // Categories
          _buildCategoryCard(
            context,
            L10nService.get('horoscope.love_relationships', ref.read(languageProvider)),
            Icons.favorite,
            horoscope.loveWeek,
            AppColors.fireElement,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildCategoryCard(
            context,
            L10nService.get('horoscope.career_finance', ref.read(languageProvider)),
            Icons.work,
            horoscope.careerWeek,
            AppColors.earthElement,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildCategoryCard(
            context,
            L10nService.get('horoscope.health_energy', ref.read(languageProvider)),
            Icons.spa,
            horoscope.healthWeek,
            AppColors.airElement,
          ),
          const SizedBox(height: AppConstants.spacingXl),
          // Key Dates
          _buildKeyDatesStringSection(context, horoscope.keyDates, sign),
          const SizedBox(height: AppConstants.spacingMd),
          // Affirmation
          _buildAffirmationCard(context, horoscope.weeklyAffirmation, sign),
          const SizedBox(height: AppConstants.spacingLg),
          const InlineAdBanner(),
          const SizedBox(height: AppConstants.spacingXl),
          // Back-Button-Free Navigation (compact)
          PageBottomNavigationCompact(currentRoute: '/horoscope/${sign.name.toLowerCase()}', language: ref.read(languageProvider)),
        ],
      ),
    );
  }

  Widget _buildMonthlyContent(BuildContext context, MonthlyHoroscope horoscope, ZodiacSign sign) {
    final language = ref.read(languageProvider);
    final months = _getLocalizedMonths(language);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month header
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: sign.color.withAlpha(20),
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month, color: sign.color),
                    const SizedBox(width: AppConstants.spacingSm),
                    Text(
                      '${months[horoscope.month - 1]} ${horoscope.year}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: sign.color,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < horoscope.overallRating ? Icons.star : Icons.star_border,
                      size: 16,
                      color: AppColors.starGold,
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingXl),
          // Overview
          _buildWeeklyOverview(context, horoscope.overview, sign),
          const SizedBox(height: AppConstants.spacingMd),
          // Lucky Days
          _buildLuckyDaysSection(context, horoscope.luckyDays, sign),
          const SizedBox(height: AppConstants.spacingMd),
          // Categories
          _buildCategoryCard(
            context,
            L10nService.get('horoscope.love_relationships', language),
            Icons.favorite,
            horoscope.loveMonth,
            AppColors.fireElement,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildCategoryCard(
            context,
            L10nService.get('horoscope.career_finance', language),
            Icons.work,
            horoscope.careerMonth,
            AppColors.earthElement,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildCategoryCard(
            context,
            L10nService.get('horoscope.health_energy', language),
            Icons.spa,
            horoscope.healthMonth,
            AppColors.airElement,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildCategoryCard(
            context,
            L10nService.get('horoscope.spiritual_guidance', language),
            Icons.auto_awesome,
            horoscope.spiritualGuidance,
            AppColors.auroraStart,
          ),
          const SizedBox(height: AppConstants.spacingXl),
          // Key Transits
          _buildKeyTransitsSection(context, horoscope.keyTransits, sign),
          const SizedBox(height: AppConstants.spacingMd),
          // Monthly Mantra
          _buildAffirmationCard(context, horoscope.monthlyMantra, sign),
          const SizedBox(height: AppConstants.spacingLg),
          const InlineAdBanner(),
          const SizedBox(height: AppConstants.spacingXl),
          // Back-Button-Free Navigation (compact)
          PageBottomNavigationCompact(currentRoute: '/horoscope/${sign.name.toLowerCase()}', language: ref.read(languageProvider)),
        ],
      ),
    );
  }

  Widget _buildSignInfoContent(BuildContext context, ZodiacSign sign) {
    final language = ref.read(languageProvider);
    final signName = sign.localizedName(language);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb Navigation
          BreadcrumbNavigation.zodiacSign(signName, sign.symbol),
          const SizedBox(height: AppConstants.spacingMd),
          _buildSignInfo(context, sign),
          const SizedBox(height: AppConstants.spacingLg),
          // Deep Interpretation Card
          DeepInterpretationCard(
            title: '$signName ${L10nService.get('horoscope.sign_depth', language)}',
            summary: _getSignSummary(sign),
            deepInterpretation: _getSignDeepInterpretation(sign),
            icon: Icons.auto_stories,
            accentColor: sign.color,
            relatedTerms: [signName, sign.element.getLocalizedName(language), sign.modality.getLocalizedName(language), sign.rulingPlanet],
          ),
          const SizedBox(height: AppConstants.spacingLg),
          // FAQ Section for this zodiac sign
          FaqSection.zodiacSign(signName, language),
          const SizedBox(height: AppConstants.spacingLg),
          const InlineAdBanner(),
          const SizedBox(height: AppConstants.spacingXl),
          // Back-Button-Free Navigation
          PageBottomNavigation(currentRoute: '/horoscope/${sign.name.toLowerCase()}', language: language),
        ],
      ),
    );
  }

  String _getSignSummary(ZodiacSign sign) {
    final language = ref.read(languageProvider);
    final signKey = sign.name.toLowerCase();
    return L10nService.get('horoscope.sign_summaries.$signKey', language);
  }

  String _getSignDeepInterpretation(ZodiacSign sign) {
    final language = ref.read(languageProvider);
    final signKey = sign.name.toLowerCase();
    return L10nService.get('horoscope.deep_interpretations.$signKey', language);
  }

  List<String> _getLocalizedMonths(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return ['January', 'February', 'March', 'April', 'May', 'June',
                'July', 'August', 'September', 'October', 'November', 'December'];
      case AppLanguage.de:
        return ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni',
                'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];
      case AppLanguage.fr:
        return ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
                'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'];
      case AppLanguage.tr:
      default:
        return ['Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
                'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'];
    }
  }

  Widget _buildWeekHeader(BuildContext context, WeeklyHoroscope horoscope) {
    final weekEnd = horoscope.weekStart.add(const Duration(days: 6));
    final language = ref.read(languageProvider);
    final localeCode = language == AppLanguage.tr ? 'tr' : language == AppLanguage.de ? 'de' : language == AppLanguage.fr ? 'fr' : 'en';
    final format = DateFormat('d MMM', localeCode);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: _sign.color.withAlpha(20),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.date_range, color: _sign.color),
              const SizedBox(width: AppConstants.spacingSm),
              Text(
                '${format.format(horoscope.weekStart)} - ${format.format(weekEnd)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _sign.color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < horoscope.overallRating ? Icons.star : Icons.star_border,
                size: 16,
                color: AppColors.starGold,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyDatesStringSection(BuildContext context, List<String> keyDates, ZodiacSign sign) {
    if (keyDates.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(30),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_note, color: sign.color, size: 20),
              const SizedBox(width: 8),
              Text(
                L10nService.get('horoscope.important_days', ref.read(languageProvider)),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: sign.color,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...keyDates.take(3).map((keyDate) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: sign.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingSm),
                  Expanded(
                    child: Text(
                      keyDate,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
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

  Widget _buildWeeklyOverview(BuildContext context, String overview, ZodiacSign sign) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            sign.color.withAlpha(15),
            AppColors.surfaceDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: sign.color.withAlpha(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: sign.color, size: 20),
              const SizedBox(width: 8),
              Text(
                L10nService.get('horoscope.cosmic_energy', ref.read(languageProvider)),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: sign.color,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            overview,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.8,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildLuckyDaysSection(BuildContext context, List<String> luckyDays, ZodiacSign sign) {
    if (luckyDays.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.starGold.withAlpha(20),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.starGold.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: AppColors.starGold, size: 20),
              const SizedBox(width: 8),
              Text(
                L10nService.get('horoscope.lucky_days', ref.read(languageProvider)),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.starGold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: luckyDays.map((day) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.starGold.withAlpha(30),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  day,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.starGold,
                      ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyTransitsSection(BuildContext context, String keyTransits, ZodiacSign sign) {
    if (keyTransits.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(30),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.route, color: sign.color, size: 20),
              const SizedBox(width: 8),
              Text(
                L10nService.get('horoscope.important_transits', ref.read(languageProvider)),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: sign.color,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            keyTransits,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAffirmationCard(BuildContext context, String affirmation, ZodiacSign sign) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            sign.color.withAlpha(30),
            AppColors.starGold.withAlpha(20),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: sign.color.withAlpha(40)),
      ),
      child: Column(
        children: [
          Icon(Icons.format_quote, color: sign.color, size: 28),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            affirmation,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            L10nService.get('horoscope.weekly_affirmation_label', ref.read(languageProvider)),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }


  Widget _buildHeader(BuildContext context, ZodiacSign sign) {
    // AI-QUOTABLE HEADER - Soru formatı
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLg,
        vertical: AppConstants.spacingSm,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            sign.color.withValues(alpha: 0.25),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Back button row
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                color: AppColors.textPrimary,
                onPressed: () => context.pop(),
                visualDensity: VisualDensity.compact,
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.share),
                color: AppColors.textPrimary,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(L10nService.get('horoscope.feature_coming_soon', ref.read(languageProvider))),
                      backgroundColor: AppColors.starGold,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          // Symbol + Question H1
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: sign.color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: sign.color.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ConstellationWidget(
                  sign: sign,
                  size: 36,
                  color: sign.color,
                  showGlow: true,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // H1 - Soru formatı (AI-quotable)
                    Text(
                      L10nService.get('horoscope.sign_today', ref.read(languageProvider)).replaceAll('{sign}', sign.localizedName(ref.read(languageProvider))),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    // Brand tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: sign.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        L10nService.get('horoscope.astrology', ref.read(languageProvider)),
                        style: TextStyle(
                          fontSize: 11,
                          color: sign.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
              L10nService.get('horoscope.daily_reading', ref.read(languageProvider)),
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
              L10nService.get('horoscope.luck_rate', ref.read(languageProvider)),
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
                L10nService.get('horoscope.daily_cosmic_energy', ref.read(languageProvider)),
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
          AutoGlossaryText(
            text: content,
            enableHighlighting: true,
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
            L10nService.get('horoscope.cosmic_tips', ref.read(languageProvider)),
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
                  label: L10nService.get('horoscope.mood', ref.read(languageProvider)),
                  value: mood,
                  color: sign.color,
                ),
              ),
              Expanded(
                child: _QuickFactItem(
                  icon: Icons.palette,
                  label: L10nService.get('horoscope.lucky_color', ref.read(languageProvider)),
                  value: luckyColor,
                  color: sign.color,
                ),
              ),
              Expanded(
                child: _QuickFactItem(
                  icon: Icons.tag,
                  label: L10nService.get('horoscope.lucky_number', ref.read(languageProvider)),
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
            '${sign.localizedName(ref.read(languageProvider))} ${L10nService.get('horoscope.zodiac_secrets', ref.read(languageProvider))}',
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
                  label: '${L10nService.get('horoscope.ruling_planet', ref.read(languageProvider))}: ${sign.rulingPlanet}',
                  icon: null,
                  color: AppColors.starGold),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Text(
            L10nService.get('horoscope.spiritual_signature', ref.read(languageProvider)),
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
