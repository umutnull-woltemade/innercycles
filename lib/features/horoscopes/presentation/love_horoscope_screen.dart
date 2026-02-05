import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/extended_horoscope.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/services/extended_horoscope_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/entertainment_disclaimer.dart';
import '../../../shared/widgets/quiz_cta_card.dart';
import '../../../data/services/localization_service.dart';
import '../../../data/services/l10n_service.dart';

class LoveHoroscopeScreen extends ConsumerStatefulWidget {
  final String? signName;

  const LoveHoroscopeScreen({super.key, this.signName});

  @override
  ConsumerState<LoveHoroscopeScreen> createState() => _LoveHoroscopeScreenState();
}

class _LoveHoroscopeScreenState extends ConsumerState<LoveHoroscopeScreen> {
  late ZodiacSign _selectedSign;
  LoveHoroscope? _horoscope;
  late DateTime _selectedDate;
  AppLanguage? _cachedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedSign = widget.signName != null
        ? ZodiacSign.values.firstWhere(
            (s) => s.name.toLowerCase() == widget.signName!.toLowerCase(),
            orElse: () => ZodiacSign.aries,
          )
        : ZodiacSign.aries;
    _selectedDate = DateTime.now();
  }

  void _loadHoroscope(AppLanguage language) {
    _horoscope = ExtendedHoroscopeService.generateLoveHoroscope(
      _selectedSign,
      _selectedDate,
      language: language,
    );
    _cachedLanguage = language;
  }

  void _changeDate(int delta, AppLanguage language) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: delta));
      _loadHoroscope(language);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);

    // Load horoscope if not loaded or language changed
    if (_horoscope == null || _cachedLanguage != language) {
      _loadHoroscope(language);
    }

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isDark, language),
              _buildDateSelector(isDark, language),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.spacingLg),
                  child: Column(
                    children: [
                      _buildSignSelector(isDark),
                      const SizedBox(height: AppConstants.spacingLg),
                      _buildOverviewCard(isDark),
                      const SizedBox(height: AppConstants.spacingMd),
                      _buildRatingsCard(isDark),
                      const SizedBox(height: AppConstants.spacingMd),
                      _buildSingleAdviceCard(isDark),
                      const SizedBox(height: AppConstants.spacingMd),
                      _buildCouplesAdviceCard(isDark),
                      const SizedBox(height: AppConstants.spacingMd),
                      _buildCompatibilityCard(isDark),
                      const SizedBox(height: AppConstants.spacingMd),
                      _buildSoulConnectionCard(isDark),
                      const SizedBox(height: AppConstants.spacingMd),
                      _buildVenusCard(isDark),
                      const SizedBox(height: AppConstants.spacingXxl),
                      // Quiz CTA - Google Discover Funnel
                      QuizCTACard.astrology(compact: true),
                      const SizedBox(height: AppConstants.spacingXl),
                      // Entertainment Disclaimer
                      PageFooterWithDisclaimer(
                        brandText: L10n.get('brand_love_horoscope', language),
                        disclaimerText: DisclaimerTexts.astrology(language),
                        language: language,
                      ),
                      const SizedBox(height: AppConstants.spacingLg),
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
                const Icon(Icons.favorite, color: Colors.pink, size: 24),
                const SizedBox(width: 8),
                Text(
                  L10nService.get('love_horoscope.title', language),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(bool isDark, AppLanguage language) {
    final dateFormat =
        '${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}';
    final isToday =
        _selectedDate.day == DateTime.now().day &&
        _selectedDate.month == DateTime.now().month &&
        _selectedDate.year == DateTime.now().year;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingSm,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.pink.withValues(alpha: isDark ? 0.3 : 0.15),
            Colors.red.withValues(alpha: isDark ? 0.3 : 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: Colors.pink.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _changeDate(-1, language),
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
          Column(
            children: [
              Text(
                isToday ? L10nService.get('love_horoscope.today', language) : dateFormat,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              if (!isToday)
                Text(dateFormat, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _changeDate(1, language),
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildSignSelector(bool isDark) {
    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ZodiacSign.values.length,
        itemBuilder: (context, index) {
          final sign = ZodiacSign.values[index];
          final isSelected = sign == _selectedSign;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedSign = sign;
                _loadHoroscope(ref.read(languageProvider));
              });
            },
            child: Container(
              width: 52,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.pink.withValues(alpha: 0.3)
                    : isDark
                    ? AppColors.surfaceLight.withValues(alpha: 0.2)
                    : AppColors.lightSurfaceVariant,
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                border: isSelected
                    ? Border.all(color: Colors.pink, width: 2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(sign.symbol, style: const TextStyle(fontSize: 20)),
                  Text(
                    sign.localizedName(ref.read(languageProvider)),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pink.withValues(alpha: isDark ? 0.3 : 0.15),
            Colors.red.withValues(alpha: isDark ? 0.3 : 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: Colors.pink.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.pink.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  _selectedSign.symbol,
                  style: const TextStyle(fontSize: 26),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedSign.localizedName(ref.read(languageProvider)),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    L10nService.get('love_horoscope.love_energy', ref.read(languageProvider)),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.pink),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.pink.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  _horoscope!.overallLoveRating.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Text(
            _horoscope!.romanticOutlook,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingsCard(bool isDark) {
    final language = ref.read(languageProvider);
    final ratings = [
      {
        'label': L10nService.get('love_horoscope.passion', language),
        'value': _horoscope!.passionRating,
        'color': Colors.red,
      },
      {
        'label': L10nService.get('love_horoscope.romance', language),
        'value': _horoscope!.romanceRating,
        'color': Colors.pink,
      },
      {
        'label': L10nService.get('love_horoscope.communication', language),
        'value': _horoscope!.communicationRating,
        'color': Colors.purple,
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceLight.withValues(alpha: 0.2)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            L10nService.get('love_horoscope.daily_love_energies', language),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          ...ratings.map((rating) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        rating['label'] as String,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < (rating['value'] as int)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: rating['color'] as Color,
                            size: 16,
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: (rating['value'] as int) / 5,
                    backgroundColor: (rating['color'] as Color).withValues(
                      alpha: 0.2,
                    ),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      rating['color'] as Color,
                    ),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSingleAdviceCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceLight.withValues(alpha: 0.2)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.pink.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.person, color: Colors.pink, size: 20),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Text(
                L10nService.get('love_horoscope.for_singles', ref.read(languageProvider)),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            _horoscope!.singleAdvice,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildCouplesAdviceCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceLight.withValues(alpha: 0.2)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.people, color: Colors.red, size: 20),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Text(
                L10nService.get('love_horoscope.for_couples', ref.read(languageProvider)),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            _horoscope!.couplesAdvice,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildCompatibilityCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.auroraStart.withValues(alpha: isDark ? 0.2 : 0.1),
            AppColors.auroraEnd.withValues(alpha: isDark ? 0.2 : 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.auroraStart.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            L10nService.get('love_horoscope.todays_compatibility', ref.read(languageProvider)),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Row(
            children: [
              Expanded(
                child: _buildMatchCard(
                  L10nService.get('love_horoscope.most_compatible', ref.read(languageProvider)),
                  _horoscope!.bestMatch,
                  Colors.green,
                  Icons.favorite,
                  isDark,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: _buildMatchCard(
                  L10nService.get('love_horoscope.challenging', ref.read(languageProvider)),
                  _horoscope!.challengingMatch,
                  Colors.orange,
                  Icons.warning_amber,
                  isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(
    String label,
    ZodiacSign sign,
    Color color,
    IconData icon,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceLight.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(sign.symbol, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 4),
          Text(
            sign.localizedName(ref.read(languageProvider)),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSoulConnectionCard(bool isDark) {
    return Container(
      width: double.infinity,
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.purple,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Text(
                L10nService.get('love_horoscope.soul_connection', ref.read(languageProvider)),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            _horoscope!.soulConnection,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildVenusCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceLight.withValues(alpha: 0.2)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.starGold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('♀', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Text(
                L10nService.get('love_horoscope.venus_influence', ref.read(languageProvider)),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            _horoscope!.venusInfluence,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          const Divider(),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                color: Colors.amber,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                L10nService.get('love_horoscope.intimacy_advice', ref.read(languageProvider)),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _horoscope!.intimacyAdvice,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
