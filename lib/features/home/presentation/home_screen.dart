import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/localization_service.dart';
import '../../../data/services/moon_service.dart';
import '../../../shared/widgets/cosmic_background.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final sign = userProfile?.sunSign ?? ZodiacSign.aries;

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, ref, userProfile?.name, sign),
                const SizedBox(height: AppConstants.spacingMd),
                // Mercury Retrograde Alert
                if (MoonService.isPlanetRetrograde('mercury'))
                  _buildMercuryRetrogradeAlert(context),
                const SizedBox(height: AppConstants.spacingMd),
                // Moon Phase & Sign Widget
                _buildMoonWidget(context),
                const SizedBox(height: AppConstants.spacingXl),
                _buildTodayCard(context, ref, sign),
                const SizedBox(height: AppConstants.spacingXl),
                _buildQuickActions(context),
                const SizedBox(height: AppConstants.spacingXl),
                _buildAllSigns(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, String? name, ZodiacSign sign) {
    final greeting = _getGreeting(ref);
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Language selector and settings at top
        Row(
          children: [
            _LanguageSelectorButton(
              currentLanguage: language,
              onLanguageChanged: (lang) => ref.read(languageProvider.notifier).state = lang,
            ),
            const Spacer(),
            IconButton(
              onPressed: () => _showSearchDialog(context, ref),
              icon: Icon(
                Icons.search,
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              ),
            ),
            IconButton(
              onPressed: () => context.push(Routes.settings),
              icon: Icon(
                Icons.settings_outlined,
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        Text(
          greeting,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ).animate().fadeIn(duration: 400.ms),
        const SizedBox(height: 4),
        Text(
          name ?? sign.nameTr,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppColors.starGold,
              ),
        ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
      ],
    );
  }

  String _getGreeting(WidgetRef ref) {
    final hour = DateTime.now().hour;
    final language = ref.watch(languageProvider);

    String key;
    if (hour < 6) {
      key = 'greeting_night';
    } else if (hour < 12) {
      key = 'greeting_morning';
    } else if (hour < 17) {
      key = 'greeting_afternoon';
    } else if (hour < 21) {
      key = 'greeting_evening';
    } else {
      key = 'greeting_late_night';
    }

    return L10n.get(key, language);
  }

  Widget _buildMercuryRetrogradeAlert(BuildContext context) {
    final retroEnd = MoonService.getCurrentMercuryRetrogradeEnd();
    final daysLeft = retroEnd != null
        ? retroEnd.difference(DateTime.now()).inDays
        : 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withAlpha(40),
            Colors.red.withAlpha(30),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: Colors.orange.withAlpha(100)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Merkür Retrosu',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.withAlpha(50),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Rx',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  daysLeft > 0
                      ? 'Iletisimde dikkatli ol! $daysLeft gun kaldi.'
                      : 'Iletisim ve teknolojide dikkatli ol!',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).shimmer(
          delay: 1000.ms,
          duration: 1500.ms,
          color: Colors.orange.withAlpha(30),
        );
  }

  Widget _buildMoonWidget(BuildContext context) {
    final moonPhase = MoonService.getCurrentPhase();
    final moonSign = MoonService.getCurrentMoonSign();
    final illumination = MoonService.getIllumination();
    final retrogrades = MoonService.getRetrogradePlanets();
    final vocStatus = VoidOfCourseMoonExtension.getVoidOfCourseStatus();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.moonSilver.withAlpha(30),
            AppColors.surfaceDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.moonSilver.withAlpha(50)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Moon phase visual
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.moonSilver,
                      AppColors.moonSilver.withAlpha(100),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.moonSilver.withAlpha(80),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    moonPhase.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              // Moon info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Simdi Gokyuzunde',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textMuted,
                            letterSpacing: 1.2,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      moonPhase.nameTr,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.moonSilver,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          'Ay ${moonSign.nameTr} burcunda',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          moonSign.symbol,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.starGold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Illumination
              Column(
                children: [
                  Text(
                    '${illumination.round()}%',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.moonSilver,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Aydinlik',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          // Moon phase meaning
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.moonSilver.withAlpha(15),
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            ),
            child: Text(
              moonPhase.meaning,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
            ),
          ),
          // Retrograde planets
          if (retrogrades.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spacingMd),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.withAlpha(20),
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                border: Border.all(color: Colors.orange.withAlpha(40)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.replay, color: Colors.orange, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Retro: ',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      children: retrogrades.map((planet) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.withAlpha(30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getPlanetNameTr(planet),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Colors.orange,
                                  fontSize: 10,
                                ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
          // Void of Course Moon indicator
          if (vocStatus.isVoid) ...[
            const SizedBox(height: AppConstants.spacingMd),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.withAlpha(30),
                    Colors.indigo.withAlpha(20),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                border: Border.all(color: Colors.purple.withAlpha(60)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.purple.withAlpha(40),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.do_not_disturb_on, color: Colors.purple, size: 14),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Ay Bos Seyir',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.purple.withAlpha(40),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'VOC',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: Colors.purple,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          vocStatus.timeRemainingFormatted != null
                              ? 'Onemli kararlar ertelensin. ${vocStatus.timeRemainingFormatted} kaldi.'
                              : 'Onemli kararlar ve baslangiclari erteleyiniz.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (vocStatus.nextSign != null) ...[
                    Column(
                      children: [
                        Text(
                          vocStatus.nextSign!.symbol,
                          style: TextStyle(fontSize: 18, color: Colors.purple.withAlpha(180)),
                        ),
                        Text(
                          'Sonraki',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.textMuted,
                                fontSize: 9,
                              ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 150.ms, duration: 400.ms);
  }

  String _getPlanetNameTr(String planet) {
    switch (planet.toLowerCase()) {
      case 'mercury': return 'Merkur';
      case 'venus': return 'Venus';
      case 'mars': return 'Mars';
      case 'jupiter': return 'Jupiter';
      case 'saturn': return 'Saturn';
      case 'uranus': return 'Uranus';
      case 'neptune': return 'Neptun';
      case 'pluto': return 'Pluton';
      default: return planet;
    }
  }

  Widget _buildTodayCard(BuildContext context, WidgetRef ref, ZodiacSign sign) {
    final horoscope = ref.watch(dailyHoroscopeProvider(sign));

    return GestureDetector(
      onTap: () => context.push('${Routes.horoscope}/${sign.name.toLowerCase()}'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              sign.color.withValues(alpha: 0.3),
              AppColors.surfaceDark,
            ],
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusXl),
          border: Border.all(
            color: sign.color.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: sign.color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    sign.symbol,
                    style: TextStyle(fontSize: 24, color: sign.color),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bugünün Kozmik Fısıltısı',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textMuted,
                              letterSpacing: 1.5,
                            ),
                      ),
                      Text(
                        sign.name,
                        style:
                            Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: sign.color,
                                ),
                      ),
                    ],
                  ),
                ),
                _buildLuckStars(horoscope.luckRating),
              ],
            ),
            const SizedBox(height: AppConstants.spacingLg),
            Text(
              horoscope.summary,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.6,
                  ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppConstants.spacingLg),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.mood,
                  label: horoscope.mood,
                  color: sign.color,
                ),
                const SizedBox(width: AppConstants.spacingSm),
                _InfoChip(
                  icon: Icons.palette,
                  label: horoscope.luckyColor,
                  color: sign.color,
                ),
                const SizedBox(width: AppConstants.spacingSm),
                _InfoChip(
                  icon: Icons.tag,
                  label: horoscope.luckyNumber,
                  color: sign.color,
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Keşfet',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: sign.color,
                      ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 16, color: sign.color),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildLuckStars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          size: 16,
          color: AppColors.starGold,
        );
      }),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Keşfet',
          style: Theme.of(context).textTheme.titleLarge,
        ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.public,
                label: 'Doğum Haritası',
                color: AppColors.starGold,
                onTap: () => context.push(Routes.birthChart),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.favorite,
                label: 'Uyum',
                color: AppColors.fireElement,
                onTap: () => context.push(Routes.compatibility),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.auto_awesome,
                label: 'Tüm Burçlar',
                color: AppColors.waterElement,
                onTap: () => context.push(Routes.horoscope),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.numbers,
                label: 'Numeroloji',
                color: AppColors.auroraEnd,
                onTap: () => context.push(Routes.numerology),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 450.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.account_tree,
                label: 'Kabala',
                color: AppColors.moonSilver,
                onTap: () => context.push(Routes.kabbalah),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.style,
                label: 'Tarot',
                color: AppColors.auroraStart,
                onTap: () => context.push(Routes.tarot),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.blur_on,
                label: 'Aura Analizi',
                color: AppColors.airElement,
                onTap: () => context.push(Routes.aura),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.public,
                label: 'Transitler',
                color: AppColors.sunriseEnd,
                onTap: () => context.push(Routes.transits),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 550.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Share Summary Button
        _ShareSummaryButton(
          onTap: () => context.push(Routes.shareSummary),
        ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingXl),
        // More Tools Section
        _buildMoreTools(context),
      ],
    );
  }

  Widget _buildMoreTools(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daha Fazla Araç',
          style: Theme.of(context).textTheme.titleLarge,
        ).animate().fadeIn(delay: 650.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Horoscope Types
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.calendar_view_week,
                label: 'Haftalık',
                color: AppColors.earthElement,
                onTap: () => context.push(Routes.weeklyHoroscope),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.calendar_month,
                label: 'Aylık',
                color: AppColors.waterElement,
                onTap: () => context.push(Routes.monthlyHoroscope),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 700.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.calendar_today,
                label: 'Yıllık',
                color: AppColors.fireElement,
                onTap: () => context.push(Routes.yearlyHoroscope),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.favorite_border,
                label: 'Aşk',
                color: Colors.pink,
                onTap: () => context.push(Routes.loveHoroscope),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 750.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Advanced Tools
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.auto_graph,
                label: 'Progresyon',
                color: AppColors.twilightStart,
                onTap: () => context.push(Routes.progressions),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.compare_arrows,
                label: 'Kompozit',
                color: AppColors.sunriseStart,
                onTap: () => context.push(Routes.compositeChart),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.people_alt,
                label: 'Sinastri',
                color: Colors.pink,
                onTap: () => context.push(Routes.synastry),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.event_note,
                label: 'Transit Takvimi',
                color: AppColors.auroraStart,
                onTap: () => context.push(Routes.transitCalendar),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 805.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.brightness_3,
                label: 'Vedik',
                color: AppColors.celestialGold,
                onTap: () => context.push(Routes.vedicChart),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.dark_mode,
                label: 'Tutulma',
                color: AppColors.moonSilver,
                onTap: () => context.push(Routes.eclipseCalendar),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 850.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.refresh,
                label: 'Saturn Donusu',
                color: AppColors.saturnColor,
                onTap: () => context.push(Routes.saturnReturn),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.cake,
                label: 'Solar Return',
                color: AppColors.starGold,
                onTap: () => context.push(Routes.solarReturn),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 875.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.calendar_view_month,
                label: 'Yil Ongorusu',
                color: AppColors.celestialGold,
                onTap: () => context.push(Routes.yearAhead),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.access_time,
                label: 'Zamanlama',
                color: AppColors.auroraEnd,
                onTap: () => context.push(Routes.timing),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 885.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Specialized Tools
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.explore,
                label: 'Yerel Uzay',
                color: Colors.teal,
                onTap: () => context.push(Routes.localSpace),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.map,
                label: 'Astro Harita',
                color: AppColors.auroraStart,
                onTap: () => context.push(Routes.astroCartography),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 900.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.schedule,
                label: 'Elektif',
                color: AppColors.twilightEnd,
                onTap: () => context.push(Routes.electional),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.psychology,
                label: 'Drakonik',
                color: AppColors.mystic,
                onTap: () => context.push(Routes.draconicChart),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 950.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.star_outline,
                label: 'Asteroidler',
                color: AppColors.stardust,
                onTap: () => context.push(Routes.asteroids),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.eco,
                label: 'Bahçe Ayı',
                color: AppColors.earthElement,
                onTap: () => context.push(Routes.gardeningMoon),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Reference Content
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.people,
                label: 'Ünlüler',
                color: AppColors.starGold,
                onTap: () => context.push(Routes.celebrities),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.article,
                label: 'Makaleler',
                color: AppColors.airElement,
                onTap: () => context.push(Routes.articles),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 1050.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.menu_book,
                label: 'Sözlük',
                color: AppColors.textSecondary,
                onTap: () => context.push(Routes.glossary),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            const Expanded(child: SizedBox()), // Placeholder for alignment
          ],
        ).animate().fadeIn(delay: 1100.ms, duration: 400.ms),
      ],
    );
  }

  Widget _buildAllSigns(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Zodiac Signs',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () => context.push(Routes.horoscope),
              child: Text(
                'See all',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.auroraStart,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ZodiacSign.values.length,
            itemBuilder: (context, index) {
              final sign = ZodiacSign.values[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < 11 ? AppConstants.spacingSm : 0,
                ),
                child: GestureDetector(
                  onTap: () => context
                      .push('${Routes.horoscope}/${sign.name.toLowerCase()}'),
                  child: Container(
                    width: 60,
                    padding: const EdgeInsets.all(AppConstants.spacingSm),
                    decoration: BoxDecoration(
                      gradient: AppColors.cardGradient,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusSm),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          sign.symbol,
                          style: TextStyle(fontSize: 18, color: sign.color),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          sign.nameTr,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontSize: 9,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: (500 + index * 50).ms, duration: 300.ms),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showSearchDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _SearchBottomSheet(),
    );
  }
}

class _SearchBottomSheet extends StatefulWidget {
  const _SearchBottomSheet();

  @override
  State<_SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<_SearchBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // All available features with categories
  static final List<_SearchItem> _allFeatures = [
    // Keşfet (Explore) - Main features
    _SearchItem('Günlük Burç', 'Günlük burç yorumları', Icons.wb_sunny, Routes.horoscope, _SearchCategory.explore, ['günlük', 'burç', 'yorum', 'daily']),
    _SearchItem('Haftalık Burç', 'Haftalık burç yorumları', Icons.calendar_view_week, Routes.weeklyHoroscope, _SearchCategory.explore, ['haftalık', 'weekly']),
    _SearchItem('Aylık Burç', 'Aylık burç yorumları', Icons.calendar_month, Routes.monthlyHoroscope, _SearchCategory.explore, ['aylık', 'monthly']),
    _SearchItem('Yıllık Burç', 'Yıllık burç yorumları', Icons.calendar_today, Routes.yearlyHoroscope, _SearchCategory.explore, ['yıllık', 'yearly']),
    _SearchItem('Aşk Burcu', 'Aşk ve ilişki yorumları', Icons.favorite, Routes.loveHoroscope, _SearchCategory.explore, ['aşk', 'love', 'ilişki']),
    _SearchItem('Doğum Haritası', 'Natal chart analizi', Icons.auto_awesome, Routes.birthChart, _SearchCategory.explore, ['doğum', 'natal', 'harita', 'chart']),
    _SearchItem('Uyumluluk', 'Burç uyumluluk analizi', Icons.people, Routes.compatibility, _SearchCategory.explore, ['uyumluluk', 'compatibility']),
    _SearchItem('Transitler', 'Güncel gezegen transitler', Icons.public, Routes.transits, _SearchCategory.explore, ['transit', 'gezegen']),
    _SearchItem('Numeroloji', 'Sayıların gizemi', Icons.pin, Routes.numerology, _SearchCategory.explore, ['numeroloji', 'sayı', 'number']),
    _SearchItem('Kabala', 'Kabalistik analiz', Icons.account_tree, Routes.kabbalah, _SearchCategory.explore, ['kabala', 'kabbalah']),
    _SearchItem('Tarot', 'Tarot kartları', Icons.style, Routes.tarot, _SearchCategory.explore, ['tarot', 'kart', 'fal']),
    _SearchItem('Aura', 'Aura renkleri', Icons.blur_circular, Routes.aura, _SearchCategory.explore, ['aura', 'enerji']),

    // Daha Fazla Araç (More Tools) - Advanced features
    _SearchItem('Transit Takvimi', 'Aylık transit takvimi', Icons.event_note, Routes.transitCalendar, _SearchCategory.moreTools, ['transit', 'takvim', 'calendar']),
    _SearchItem('Tutulma Takvimi', 'Güneş ve Ay tutulmaları', Icons.dark_mode, Routes.eclipseCalendar, _SearchCategory.moreTools, ['tutulma', 'eclipse', 'güneş', 'ay']),
    _SearchItem('Sinastri', 'İlişki analizi', Icons.people_alt, Routes.synastry, _SearchCategory.moreTools, ['sinastri', 'synastry', 'ilişki']),
    _SearchItem('Kompozit', 'Kompozit harita', Icons.compare_arrows, Routes.compositeChart, _SearchCategory.moreTools, ['kompozit', 'composite']),
    _SearchItem('Progresyon', 'Secondary progressions', Icons.auto_graph, Routes.progressions, _SearchCategory.moreTools, ['progresyon', 'progression']),
    _SearchItem('Saturn Dönüşü', 'Saturn Return analizi', Icons.refresh, Routes.saturnReturn, _SearchCategory.moreTools, ['saturn', 'dönüş', 'return']),
    _SearchItem('Solar Return', 'Güneş dönüşü', Icons.wb_sunny_outlined, Routes.solarReturn, _SearchCategory.moreTools, ['solar', 'güneş', 'dönüş']),
    _SearchItem('Yıl Önü', 'Yıl öngörüsü', Icons.upcoming, Routes.yearAhead, _SearchCategory.moreTools, ['yıl', 'öngörü', 'year']),
    _SearchItem('Zamanlama', 'En uygun zamanlar', Icons.access_time, Routes.timing, _SearchCategory.moreTools, ['zaman', 'timing']),
    _SearchItem('Vedik', 'Vedik astroloji', Icons.brightness_3, Routes.vedicChart, _SearchCategory.moreTools, ['vedik', 'vedic', 'hint']),
    _SearchItem('Astro Harita', 'Astrocartography', Icons.map, Routes.astroCartography, _SearchCategory.moreTools, ['astro', 'harita', 'cartography']),
    _SearchItem('Yerel Uzay', 'Local space astroloji', Icons.explore, Routes.localSpace, _SearchCategory.moreTools, ['yerel', 'local', 'space']),
    _SearchItem('Elektif', 'En iyi zamanlar', Icons.schedule, Routes.electional, _SearchCategory.moreTools, ['elektif', 'electional']),
    _SearchItem('Drakonik', 'Drakonik harita', Icons.psychology, Routes.draconicChart, _SearchCategory.moreTools, ['drakonik', 'draconic']),
    _SearchItem('Asteroidler', 'Asteroid konumları', Icons.star_outline, Routes.asteroids, _SearchCategory.moreTools, ['asteroid', 'yıldız']),
    _SearchItem('Bahçe Ayı', 'Aya göre bahçecilik', Icons.eco, Routes.gardeningMoon, _SearchCategory.moreTools, ['bahçe', 'garden', 'ay', 'moon']),
    _SearchItem('Ünlüler', 'Ünlü haritaları', Icons.people, Routes.celebrities, _SearchCategory.moreTools, ['ünlü', 'celebrity']),
    _SearchItem('Makaleler', 'Astroloji yazıları', Icons.article, Routes.articles, _SearchCategory.moreTools, ['makale', 'article', 'yazı']),
    _SearchItem('Sözlük', 'Astroloji terimleri', Icons.menu_book, Routes.glossary, _SearchCategory.moreTools, ['sözlük', 'glossary', 'terim']),
    _SearchItem('Profil', 'Profil ayarları', Icons.person, Routes.profile, _SearchCategory.moreTools, ['profil', 'profile']),
    _SearchItem('Ayarlar', 'Uygulama ayarları', Icons.settings, Routes.settings, _SearchCategory.moreTools, ['ayar', 'settings']),
    _SearchItem('Premium', 'Premium özellikler', Icons.workspace_premium, Routes.premium, _SearchCategory.moreTools, ['premium', 'pro']),
  ];

  List<_SearchItem> get _filteredFeatures {
    if (_searchQuery.isEmpty) return _allFeatures;
    final query = _searchQuery.toLowerCase();
    return _allFeatures.where((item) {
      return item.title.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query) ||
          item.keywords.any((k) => k.toLowerCase().contains(query));
    }).toList();
  }

  List<_SearchItem> get _exploreFeatures =>
      _filteredFeatures.where((f) => f.category == _SearchCategory.explore).toList();

  List<_SearchItem> get _moreToolsFeatures =>
      _filteredFeatures.where((f) => f.category == _SearchCategory.moreTools).toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(100),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Search field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Ara... (örn: burç, tarot, saturn)',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.grey.withAlpha(30),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
              const SizedBox(height: 16),
              // Results
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    if (_exploreFeatures.isNotEmpty) ...[
                      _buildCategoryHeader('Keşfet', Icons.explore),
                      const SizedBox(height: 8),
                      ..._exploreFeatures.map((f) => _buildSearchResultItem(f)),
                      const SizedBox(height: 24),
                    ],
                    if (_moreToolsFeatures.isNotEmpty) ...[
                      _buildCategoryHeader('Daha Fazla Araç', Icons.build),
                      const SizedBox(height: 8),
                      ..._moreToolsFeatures.map((f) => _buildSearchResultItem(f)),
                    ],
                    if (_filteredFeatures.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(Icons.search_off, size: 48, color: Colors.grey.withAlpha(100)),
                              const SizedBox(height: 16),
                              Text(
                                'Sonuç bulunamadı',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.starGold),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.starGold,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildSearchResultItem(_SearchItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.auroraStart.withAlpha(30),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(item.icon, color: AppColors.auroraStart),
        ),
        title: Text(item.title),
        subtitle: Text(
          item.description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.pop(context);
          context.push(item.route);
        },
      ),
    );
  }
}

enum _SearchCategory { explore, moreTools }

class _SearchItem {
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final _SearchCategory category;
  final List<String> keywords;

  const _SearchItem(this.title, this.description, this.icon, this.route, this.category, this.keywords);
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
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

class _QuickActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.color.withValues(alpha: _isPressed ? 0.3 : 0.2),
                AppColors.surfaceDark,
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            border: Border.all(
              color: widget.color.withValues(alpha: _isPressed ? 0.5 : 0.3),
              width: _isPressed ? 1.5 : 1.0,
            ),
            boxShadow: _isPressed
                ? []
                : [
                    BoxShadow(
                      color: widget.color.withAlpha(30),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: _isPressed ? 0.3 : 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: widget.color, size: 20),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageSelectorButton extends StatelessWidget {
  final AppLanguage currentLanguage;
  final ValueChanged<AppLanguage> onLanguageChanged;

  const _LanguageSelectorButton({
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => _showLanguageSelector(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceLight.withValues(alpha: 0.3)
              : AppColors.lightSurfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(currentLanguage.flag, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              currentLanguage.displayName,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.expand_more,
              size: 18,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.language,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    L10n.get('language', currentLanguage),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: AppLanguage.values.map((lang) {
                  final isSelected = lang == currentLanguage;
                  return GestureDetector(
                    onTap: () {
                      onLanguageChanged(lang);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primary.withOpacity(0.2)
                            : (isDark
                                ? AppColors.surfaceLight.withOpacity(0.3)
                                : AppColors.lightSurfaceVariant),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(lang.flag, style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Text(
                            lang.displayName,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: isSelected
                                      ? colorScheme.primary
                                      : (isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 6),
                            Icon(
                              Icons.check_circle,
                              size: 18,
                              color: colorScheme.primary,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

class _ShareSummaryButton extends StatefulWidget {
  final VoidCallback onTap;

  const _ShareSummaryButton({required this.onTap});

  @override
  State<_ShareSummaryButton> createState() => _ShareSummaryButtonState();
}

class _ShareSummaryButtonState extends State<_ShareSummaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.spacingLg,
            horizontal: AppConstants.spacingXl,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.auroraStart.withValues(alpha: _isPressed ? 0.9 : 0.8),
                AppColors.auroraEnd.withValues(alpha: _isPressed ? 0.9 : 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            boxShadow: _isPressed
                ? []
                : [
                    BoxShadow(
                      color: AppColors.auroraStart.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.share_rounded,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                'Instagram\'da Paylas',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
              ),
              const SizedBox(width: 8),
              const Text(
                '✨',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
