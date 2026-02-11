// ignore_for_file: unused_element

import 'dart:math' as math;
import 'package:flutter/material.dart' hide Element;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/config/feature_flags.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/localization_service.dart';
import '../../../data/services/l10n_service.dart';
import '../../../data/services/moon_service.dart';
import '../../../data/services/ai_content_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/page_bottom_navigation.dart';
import '../../../shared/widgets/entertainment_disclaimer.dart';
import '../widgets/insight_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    // Guard: Redirect to onboarding if no valid profile
    if (userProfile == null ||
        userProfile.name == null ||
        userProfile.name!.isEmpty) {
      // Use addPostFrameCallback to navigate after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go(Routes.onboarding);
        }
      });
      // Show loading while redirecting
      return const Scaffold(
        backgroundColor: Color(0xFF0D0D1A),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFFD700)),
        ),
      );
    }

    final sign = userProfile.sunSign;

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, ref, userProfile.name, sign),
                const SizedBox(height: AppConstants.spacingLg),
                // ════════════════════════════════════════════════════════════
                // INSIGHT - Apple-Safe Personal Reflection Assistant
                // Replaces Kozmoz for App Store compliance
                // ════════════════════════════════════════════════════════════
                const InsightSection(),
                const SizedBox(height: AppConstants.spacingLg),
                // Mercury Retrograde Alert
                if (MoonService.isPlanetRetrograde('mercury'))
                  _buildMercuryRetrogradeAlert(context, ref),
                const SizedBox(height: AppConstants.spacingMd),
                // Moon Phase & Sign Widget
                _buildMoonWidget(context, ref),
                const SizedBox(height: AppConstants.spacingXl),
                // ════════════════════════════════════════════════════════════
                // APP STORE 4.3(b): Show quick actions only when not in review mode
                // ════════════════════════════════════════════════════════════
                if (!FeatureFlags.appStoreReviewMode) ...[
                  _buildQuickActions(context, ref),
                  const SizedBox(height: AppConstants.spacingXl),
                ],
                // ═══════════════════════════════════════════════════════════════
                // RUHSAL & WELLNESS - Meditasyon, ritüeller, chakra
                // ═══════════════════════════════════════════════════════════════
                _buildSpiritualSection(context, ref),
                const SizedBox(height: AppConstants.spacingXl),
                // ════════════════════════════════════════════════════════════
                // APP STORE 4.3(b): Hide zodiac sign grid in review mode
                // ════════════════════════════════════════════════════════════
                if (FeatureFlags.showZodiacIdentity)
                  _buildAllSigns(context, ref),
                const SizedBox(height: AppConstants.spacingXl),
                // ═══════════════════════════════════════════════════════════════
                // TÜM ÇÖZÜMLEMELERİ GÖR - Ana katalog butonu
                // ═══════════════════════════════════════════════════════════════
                _buildAllServicesButton(context, ref),
                const SizedBox(height: AppConstants.spacingXl),
                // ═══════════════════════════════════════════════════════════════
                // ENTERTAINMENT DISCLAIMER - App Store 4.3(b) Compliance
                // ═══════════════════════════════════════════════════════════════
                EntertainmentDisclaimer(
                  language: ref.watch(languageProvider),
                  compact: true,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                // Back-Button-Free Navigation
                PageBottomNavigation(
                  currentRoute: '/',
                  language: ref.watch(languageProvider),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    String? name,
    ZodiacSign sign,
  ) {
    final language = ref.watch(languageProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Language selector and settings at top
        Row(
          children: [
            _LanguageSelectorButton(
              currentLanguage: language,
              onLanguageChanged: (lang) =>
                  ref.read(languageProvider.notifier).state = lang,
            ),
            const Spacer(),
            // ════════════════════════════════════════════════════════════
            // APP STORE 4.3(b) COMPLIANCE: Hide high-risk buttons in review mode
            // ════════════════════════════════════════════════════════════
            if (FeatureFlags.showKozmoz) ...[
              // Kozmik Iletisim Butonu - Chatbot (now redirects to Insight)
              _KozmikIletisimButton(onTap: () => context.push(Routes.insight)),
              const SizedBox(width: 8),
              // Ruya Dongusu Butonu - 7 Boyutlu Form (now redirects to Insight)
              _RuyaDongusuButton(onTap: () => context.push(Routes.insight)),
              const SizedBox(width: 8),
              // KOZMOZ Butonu - Her zaman parlayan özel buton
              _KozmozButton(onTap: () => context.push(Routes.kozmoz)),
              const SizedBox(width: 8),
            ],
            // Arama Butonu - Büyük ve animasyonlu
            _AnimatedHeaderButton(
              icon: Icons.search_rounded,
              label: L10nService.get('navigation.search', language),
              color: AppColors.mysticBlue,
              onTap: () => _showSearchDialog(context, ref),
            ),
            const SizedBox(width: 8),
            // Profil Ekle Butonu
            _AnimatedHeaderButton(
              icon: Icons.person_add_rounded,
              label: L10nService.get('navigation.profile', language),
              color: AppColors.starGold,
              onTap: () => _showAddProfileDialog(context, ref),
            ),
            const SizedBox(width: 8),
            // Ayarlar Butonu
            _AnimatedHeaderButton(
              icon: Icons.settings_rounded,
              label: L10nService.get('navigation.settings', language),
              color: AppColors.cosmicPurple,
              onTap: () => context.push(Routes.settings),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        // Günlük yorum kartı header'da
        _buildCompactDailyCard(context, ref, name, sign),
      ],
    );
  }

  // Kompakt günlük yorum kartı - header'a entegre
  Widget _buildCompactDailyCard(
    BuildContext context,
    WidgetRef ref,
    String? name,
    ZodiacSign sign,
  ) {
    final language = ref.watch(languageProvider);
    final horoscope = ref.watch(dailyHoroscopeProvider((sign, language)));
    final userProfile = ref.watch(userProfileProvider);

    // Doğum bilgileri
    final birthDate = userProfile?.birthDate;
    final birthTime = userProfile?.birthTime;
    final birthPlace = userProfile?.birthPlace;

    return GestureDetector(
      // App Store 4.3(b): Navigate to Insight instead of horoscope in review mode
      onTap: () => context.push(
        FeatureFlags.showHoroscopes
            ? '${Routes.horoscope}/${sign.name.toLowerCase()}'
            : Routes.insight,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              sign.color.withValues(alpha: 0.25),
              sign.color.withValues(alpha: 0.1),
              const Color(0xFF1A1A2E).withValues(alpha: 0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: sign.color.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: sign.color.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ════════════════════════════════════════════════════════════
            // ÜST KISIM: İsim, Burç ve Doğum Bilgileri
            // ════════════════════════════════════════════════════════════
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sol: Tantrik logo (tap to Kozmoz)
                GestureDetector(
                  onTap: () => context.push(Routes.kozmoz),
                  child: const _TantricLogoSmall(),
                ),
                const SizedBox(width: 12),
                // Orta: Burç sembolü
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        sign.color.withValues(alpha: 0.5),
                        sign.color.withValues(alpha: 0.15),
                      ],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: sign.color.withValues(alpha: 0.7),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: sign.color.withValues(alpha: 0.4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Text(
                    sign.symbol,
                    style: TextStyle(fontSize: 24, color: sign.color),
                  ),
                ),
                const SizedBox(width: 14),
                // Sağ: İsim, Burç ve Doğum Bilgileri
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // İsim ve Burç
                      Row(
                        children: [
                          if (name != null && name.isNotEmpty) ...[
                            Flexible(
                              child: Text(
                                name,
                                style: GoogleFonts.playfairDisplay(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '•',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            sign.localizedName(language),
                            style: TextStyle(
                              color: sign.color,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Doğum Tarihi ve Saati
                      if (birthDate != null)
                        Row(
                          children: [
                            Icon(
                              Icons.cake_outlined,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formatBirthDate(birthDate, language),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 13,
                              ),
                            ),
                            if (birthTime != null && birthTime.isNotEmpty) ...[
                              const SizedBox(width: 10),
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                birthTime,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ],
                        ),
                      // Doğum Yeri
                      if (birthPlace != null && birthPlace.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                birthPlace,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Energy level indicator (thematic intensity, not prediction)
                Column(
                  children: [
                    _buildEnergyIndicator(horoscope.energyLevel),
                    const SizedBox(height: 2),
                    Text(
                      L10nService.get('home.daily_theme', language),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Info chips
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _MiniChip(
                  icon: Icons.mood,
                  label: horoscope.mood,
                  color: sign.color,
                ),
                const SizedBox(width: 8),
                _MiniChip(
                  icon: Icons.palette,
                  label: horoscope.reflectionColor,
                  color: sign.color,
                ),
                const SizedBox(width: 8),
                _MiniChip(
                  icon: Icons.tag,
                  label: horoscope.focusNumber,
                  color: sign.color,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Kozmik mesaj
            if (horoscope.dailyTheme.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.starGold.withValues(alpha: 0.2),
                      sign.color.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.starGold.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: AppColors.starGold,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        horoscope.dailyTheme,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            // Tüm Çözümlemeler - Psikedelik buton
            GestureDetector(
              onTap: () => context.push(Routes.allServices),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.withValues(alpha: 0.7),
                      Colors.pink.withValues(alpha: 0.6),
                      Colors.orange.withValues(alpha: 0.5),
                      Colors.cyan.withValues(alpha: 0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withValues(alpha: 0.4),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Colors.pink.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      L10nService.get('home.all_services', language),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Detailed reading button
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      sign.color.withValues(alpha: 0.4),
                      sign.color.withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: sign.color.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      L10nService.get('home.detailed_reading', language),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildMercuryRetrogradeAlert(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    // ignore: unused_local_variable
    final retroEnd = MoonService.getCurrentMercuryRetrogradeEnd();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.withAlpha(40), Colors.red.withAlpha(30)],
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
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      L10nService.get('home.mercury_retrograde', language),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
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
                  L10nService.get('home.mercury_retrograde_warning', language),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildMoonWidget(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final moonPhase = MoonService.getCurrentPhase();
    final moonSign = MoonService.getCurrentMoonSign();
    final illumination = MoonService.getIllumination();
    final retrogrades = MoonService.getRetrogradePlanets();
    final vocStatus = VoidOfCourseMoonExtension.getVoidOfCourseStatus();

    return GestureDetector(
      onTap: () => context.push(Routes.timing),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.moonSilver.withAlpha(30), AppColors.surfaceDark],
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
                        L10nService.get('home.currently_in_sky', language),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textMuted,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        moonPhase.nameTr,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.moonSilver,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 2),
                      GestureDetector(
                        onTap: () {
                          context.push(
                            '/horoscope/${moonSign.name.toLowerCase()}',
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              L10nService.getWithParams(
                                'home.moon_in_sign_formatted',
                                language,
                                params: {
                                  'sign': L10nService.get(
                                    'zodiac.${moonSign.name.toLowerCase()}',
                                    language,
                                  ),
                                },
                              ),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.textSecondary
                                        .withAlpha(100),
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
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 10,
                              color: AppColors.textSecondary.withAlpha(150),
                            ),
                          ],
                        ),
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
                      L10nService.get('home.illumination', language),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withAlpha(30),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _getPlanetNameTr(planet),
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
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
                      child: const Icon(
                        Icons.do_not_disturb_on,
                        color: Colors.purple,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                L10nService.get(
                                  'home.void_of_course',
                                  language,
                                ),
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withAlpha(40),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'VOC',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
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
                                ? L10nService.get(
                                    'home.voc_delay_decisions',
                                    language,
                                  ).replaceAll(
                                    '{time}',
                                    vocStatus.timeRemainingFormatted!,
                                  )
                                : L10nService.get(
                                    'home.voc_postpone_important',
                                    language,
                                  ),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
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
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.purple.withAlpha(180),
                            ),
                          ),
                          Text(
                            L10nService.get('common.next', language),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
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
      ),
    ).animate().fadeIn(delay: 150.ms, duration: 400.ms);
  }

  String _getPlanetNameTr(String planet) {
    switch (planet.toLowerCase()) {
      case 'mercury':
        return 'Merkur';
      case 'venus':
        return 'Venus';
      case 'mars':
        return 'Mars';
      case 'jupiter':
        return 'Jupiter';
      case 'saturn':
        return 'Saturn';
      case 'uranus':
        return 'Uranus';
      case 'neptune':
        return 'Neptun';
      case 'pluto':
        return 'Pluton';
      default:
        return planet;
    }
  }

  String _formatBirthDate(DateTime date, AppLanguage language) {
    final monthKeys = [
      'january',
      'february',
      'march',
      'april',
      'may',
      'june',
      'july',
      'august',
      'september',
      'october',
      'november',
      'december',
    ];
    final monthName = L10nService.get(
      'months.${monthKeys[date.month - 1]}',
      language,
    );
    return '${date.day} $monthName ${date.year}';
  }

  /// Displays thematic energy intensity (for visual purposes only, not prediction)
  Widget _buildEnergyIndicator(int level) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < level ? Icons.circle : Icons.circle_outlined,
          size: 10,
          color: AppColors.starGold.withValues(
            alpha: index < level ? 1.0 : 0.3,
          ),
        );
      }),
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ═══════════════════════════════════════════════════════════════
        // ÖZEL ÇÖZÜMLEMELERİMİZ - Profil tabanlı, kişiye özel analizler
        // ═══════════════════════════════════════════════════════════════
        _buildSectionHeader(
          context,
          '✨ ${L10nService.get('home.special_readings', language)}',
          L10nService.get('home.personalized_readings', language),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        // Doğum Haritası & Uyum
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.public,
                label: L10nService.get(
                  'home.quick_actions.birth_chart',
                  language,
                ),
                color: AppColors.starGold,
                onTap: () => context.push(Routes.birthChart),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.favorite,
                label: L10nService.get(
                  'home.quick_actions.compatibility',
                  language,
                ),
                color: AppColors.fireElement,
                onTap: () => context.push(Routes.compatibility),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Sinastri & Kompozit
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.people_alt,
                label: L10nService.get('home.quick_actions.synastry', language),
                color: Colors.pink,
                onTap: () => context.push(Routes.synastry),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.compare_arrows,
                label: L10nService.get(
                  'home.quick_actions.composite',
                  language,
                ),
                color: AppColors.sunriseStart,
                onTap: () => context.push(Routes.compositeChart),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 450.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Transitler & Transit Takvimi
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.public,
                label: L10nService.get('home.quick_actions.transits', language),
                color: AppColors.sunriseEnd,
                onTap: () => context.push(Routes.transits),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.event_note,
                label: L10nService.get(
                  'home.quick_actions.transit_calendar',
                  language,
                ),
                color: AppColors.auroraStart,
                onTap: () => context.push(Routes.transitCalendar),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Progresyon & Saturn Dönüşü
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.auto_graph,
                label: L10nService.get(
                  'home.quick_actions.progressions',
                  language,
                ),
                color: AppColors.twilightStart,
                onTap: () => context.push(Routes.progressions),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.refresh,
                label: L10nService.get(
                  'home.quick_actions.saturn_return',
                  language,
                ),
                color: AppColors.saturnColor,
                onTap: () => context.push(Routes.saturnReturn),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 550.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Solar Return & Yıl Öngörüsü
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.cake,
                label: L10nService.get(
                  'home.quick_actions.solar_return',
                  language,
                ),
                color: AppColors.starGold,
                onTap: () => context.push(Routes.solarReturn),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.calendar_view_month,
                label: L10nService.get(
                  'home.quick_actions.year_ahead',
                  language,
                ),
                color: AppColors.celestialGold,
                onTap: () => context.push(Routes.yearAhead),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Vedik & Drakonik
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.brightness_3,
                label: L10nService.get('home.quick_actions.vedic', language),
                color: AppColors.celestialGold,
                onTap: () => context.push(Routes.vedicChart),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.psychology,
                label: L10nService.get('home.quick_actions.draconic', language),
                color: AppColors.mystic,
                onTap: () => context.push(Routes.draconicChart),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 650.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Asteroidler & Astro Harita
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.star_outline,
                label: L10nService.get(
                  'home.quick_actions.asteroids',
                  language,
                ),
                color: AppColors.stardust,
                onTap: () => context.push(Routes.asteroids),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.map,
                label: L10nService.get(
                  'home.quick_actions.astrocartography',
                  language,
                ),
                color: AppColors.auroraStart,
                onTap: () => context.push(Routes.astroCartography),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 700.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Yerel Uzay & Elektif
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.explore,
                label: L10nService.get(
                  'home.quick_actions.local_space',
                  language,
                ),
                color: Colors.teal,
                onTap: () => context.push(Routes.localSpace),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.schedule,
                label: L10nService.get(
                  'home.quick_actions.electional',
                  language,
                ),
                color: AppColors.twilightEnd,
                onTap: () => context.push(Routes.electional),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 750.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Zamanlama & Numeroloji
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.access_time,
                label: L10nService.get('home.quick_actions.timing', language),
                color: AppColors.auroraEnd,
                onTap: () => context.push(Routes.timing),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.numbers,
                label: L10nService.get(
                  'home.quick_actions.numerology',
                  language,
                ),
                color: AppColors.auroraEnd,
                onTap: () => context.push(Routes.numerology),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Share Summary Button
        _ShareSummaryButton(
          onTap: () => context.push(Routes.shareSummary),
          language: language,
        ).animate().fadeIn(delay: 850.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingXxl),
        // ═══════════════════════════════════════════════════════════════
        // 12 ASTROLOJİK EV - Kompakt görünüm
        // ═══════════════════════════════════════════════════════════════
        _buildCompactHousesSection(context, ref),
        const SizedBox(height: AppConstants.spacingXxl),
        // ═══════════════════════════════════════════════════════════════
        // KALAN ÇÖZÜMLEMELERİMİZ - Genel araçlar
        // ═══════════════════════════════════════════════════════════════
        _buildOtherTools(context, ref),
      ],
    );
  }

  Widget _buildCompactHousesSection(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    // 12 ev sistemi - buyuk pencere gorunumu
    final houses = [
      {
        'num': 1,
        'name': L10nService.get('houses.compact.1.name', language),
        'icon': Icons.person,
        'color': Colors.red,
        'desc': L10nService.get('houses.compact.1.desc', language),
      },
      {
        'num': 2,
        'name': L10nService.get('houses.compact.2.name', language),
        'icon': Icons.attach_money,
        'color': Colors.green,
        'desc': L10nService.get('houses.compact.2.desc', language),
      },
      {
        'num': 3,
        'name': L10nService.get('houses.compact.3.name', language),
        'icon': Icons.chat_bubble,
        'color': Colors.orange,
        'desc': L10nService.get('houses.compact.3.desc', language),
      },
      {
        'num': 4,
        'name': L10nService.get('houses.compact.4.name', language),
        'icon': Icons.home,
        'color': Colors.blue,
        'desc': L10nService.get('houses.compact.4.desc', language),
      },
      {
        'num': 5,
        'name': L10nService.get('houses.compact.5.name', language),
        'icon': Icons.palette,
        'color': Colors.purple,
        'desc': L10nService.get('houses.compact.5.desc', language),
      },
      {
        'num': 6,
        'name': L10nService.get('houses.compact.6.name', language),
        'icon': Icons.favorite,
        'color': Colors.teal,
        'desc': L10nService.get('houses.compact.6.desc', language),
      },
      {
        'num': 7,
        'name': L10nService.get('houses.compact.7.name', language),
        'icon': Icons.people,
        'color': Colors.pink,
        'desc': L10nService.get('houses.compact.7.desc', language),
      },
      {
        'num': 8,
        'name': L10nService.get('houses.compact.8.name', language),
        'icon': Icons.autorenew,
        'color': Colors.deepPurple,
        'desc': L10nService.get('houses.compact.8.desc', language),
      },
      {
        'num': 9,
        'name': L10nService.get('houses.compact.9.name', language),
        'icon': Icons.school,
        'color': Colors.indigo,
        'desc': L10nService.get('houses.compact.9.desc', language),
      },
      {
        'num': 10,
        'name': L10nService.get('houses.compact.10.name', language),
        'icon': Icons.work,
        'color': Colors.amber,
        'desc': L10nService.get('houses.compact.10.desc', language),
      },
      {
        'num': 11,
        'name': L10nService.get('houses.compact.11.name', language),
        'icon': Icons.groups,
        'color': Colors.cyan,
        'desc': L10nService.get('houses.compact.11.desc', language),
      },
      {
        'num': 12,
        'name': L10nService.get('houses.compact.12.name', language),
        'icon': Icons.psychology,
        'color': Colors.deepOrange,
        'desc': L10nService.get('houses.compact.12.desc', language),
      },
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF1A1A2E), const Color(0xFF16213E)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.cosmicPurple.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cosmicPurple.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - Pencere başlığı
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.cosmicPurple.withValues(alpha: 0.4),
                  AppColors.mysticBlue.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.cosmicPurple, AppColors.mysticBlue],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.grid_view_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      L10nService.get('houses.section_title', language),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      L10nService.get('houses.section_subtitle', language),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => context.push(Routes.birthChart),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          L10nService.get('houses.detail_button', language),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 12 Ev - Tek satırda yatay scroll, büyük boyut
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: 12,
              itemBuilder: (context, index) {
                final house = houses[index];
                final houseColor = house['color'] as Color;
                final houseIcon = house['icon'] as IconData;

                return Padding(
                  padding: EdgeInsets.only(right: index < 11 ? 8 : 0),
                  child: GestureDetector(
                    onTap: () => _showHouseDetail(context, house, language),
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            houseColor.withValues(alpha: 0.5),
                            houseColor.withValues(alpha: 0.2),
                          ],
                        ),
                        border: Border.all(
                          color: houseColor.withValues(alpha: 0.7),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: houseColor.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(houseIcon, color: houseColor, size: 24),
                          const SizedBox(height: 4),
                          Text(
                            house['name'] as String,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 900.ms, duration: 400.ms);
  }

  void _showHouseDetail(
    BuildContext context,
    Map<String, dynamic> house,
    AppLanguage language,
  ) {
    final houseNum = house['num'] as int;

    final houseColor = house['color'] as Color;
    final houseIcon = house['icon'] as IconData;

    // Ev detay bilgileri - i18n
    final title = L10nService.get('houses.detail.$houseNum.title', language);
    final keywords = L10nService.get(
      'houses.detail.$houseNum.keywords',
      language,
    );
    final description = L10nService.get(
      'houses.detail.$houseNum.description',
      language,
    );
    final areas = L10nService.getList(
      'houses.detail.$houseNum.areas',
      language,
    );

    final detail = {
      'title': title,
      'keywords': keywords,
      'description': description,
      'areas': areas,
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: houseColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(houseIcon, color: houseColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail['title'] as String,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: houseColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        detail['keywords'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingLg),
            // Description
            Text(
              detail['description'] as String,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            // Areas
            Text(
              L10nService.get('houses.areas_governed', language),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: houseColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (detail['areas'] as List<String>).map((area) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: houseColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: houseColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    area,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: houseColor),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppConstants.spacingLg),
            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  context.push(Routes.birthChart);
                },
                icon: const Icon(Icons.auto_awesome),
                label: Text(
                  L10nService.get('houses.view_house_on_chart', language),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: houseColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.starGold.withValues(alpha: 0.15),
            AppColors.auroraStart.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.starGold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.starGold,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  Widget _buildOtherTools(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.moonSilver.withValues(alpha: 0.15),
                AppColors.waterElement.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            border: Border.all(
              color: AppColors.moonSilver.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                L10nService.get('home.other_tools.title', language),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.moonSilver,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                L10nService.get('home.other_tools.subtitle', language),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 900.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Tüm Burçlar & Günlük
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.auto_awesome,
                label: L10nService.get(
                  'home.quick_actions.all_signs',
                  language,
                ),
                color: AppColors.waterElement,
                onTap: () => context.push(Routes.horoscope),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.calendar_view_week,
                label: L10nService.get('tabs.weekly', language),
                color: AppColors.earthElement,
                tooltip: L10nService.get(
                  'home.other_tools.weekly_tooltip',
                  language,
                ),
                onTap: () => context.push(Routes.weeklyHoroscope),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 950.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Aylık & Yıllık
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.calendar_month,
                label: L10nService.get('tabs.monthly', language),
                color: AppColors.waterElement,
                tooltip: L10nService.get('home.tooltips.monthly', language),
                onTap: () => context.push(Routes.monthlyHoroscope),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.calendar_today,
                label: L10nService.get('tabs.yearly', language),
                color: AppColors.fireElement,
                tooltip: L10nService.get('home.tooltips.yearly', language),
                onTap: () => context.push(Routes.yearlyHoroscope),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Aşk & Tutulma
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.favorite_border,
                label: L10nService.get('home.quick_actions.love', language),
                color: Colors.pink,
                onTap: () => context.push(Routes.loveHoroscope),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.dark_mode,
                label: L10nService.get('home.quick_actions.eclipse', language),
                color: AppColors.moonSilver,
                onTap: () => context.push(Routes.eclipseCalendar),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 1050.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Kabala & Tarot
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.account_tree,
                label: L10nService.get('home.quick_actions.kabbalah', language),
                color: AppColors.moonSilver,
                onTap: () => context.push(Routes.kabbalah),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.style,
                label: L10nService.get('onboarding.features.tarot', language),
                color: AppColors.auroraStart,
                tooltip: L10nService.get('home.tooltips.tarot', language),
                onTap: () => context.push(Routes.tarot),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 1100.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Aura & Bahçe Ayı
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.blur_on,
                label: L10nService.get('home.quick_actions.aura', language),
                color: AppColors.airElement,
                onTap: () => context.push(Routes.aura),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.eco,
                label: L10nService.get(
                  'home.quick_actions.gardening_moon',
                  language,
                ),
                color: AppColors.earthElement,
                onTap: () => context.push(Routes.gardeningMoon),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 1150.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Ünlüler & Makaleler
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.people,
                label: L10nService.get(
                  'home.quick_actions.celebrities',
                  language,
                ),
                color: AppColors.starGold,
                onTap: () => context.push(Routes.celebrities),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.article,
                label: L10nService.get('home.quick_actions.articles', language),
                color: AppColors.airElement,
                onTap: () => context.push(Routes.articles),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 1200.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Sözlük
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.menu_book,
                label: L10nService.get('home.quick_actions.glossary', language),
                color: AppColors.textSecondary,
                onTap: () => context.push(Routes.glossary),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            const Expanded(child: SizedBox()),
          ],
        ).animate().fadeIn(delay: 1250.ms, duration: 400.ms),
        // Ruhsal & Wellness section moved after Kozmik Keşif
      ],
    );
  }

  Widget _buildSpiritualSection(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.cosmicPurple.withValues(alpha: 0.2),
                AppColors.mysticBlue.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            border: Border.all(
              color: AppColors.cosmicPurple.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ruhsal & Wellness',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.cosmicPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                L10nService.get('home.meditation_subtitle', language),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 1300.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Günlük Ritüeller & Chakra
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.self_improvement,
                label: L10nService.get('screens.daily_ritual', language),
                color: AppColors.cosmicPurple,
                onTap: () => context.push(Routes.dailyRituals),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.blur_circular,
                label: L10nService.get('home.quick_actions.chakra', language),
                color: AppColors.mysticBlue,
                onTap: () => context.push(Routes.chakraAnalysis),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 1350.ms, duration: 400.ms),
      ],
    );
  }

  // Tüm Çözümlemeler - Psikedelik buton (Kozmik Mesaj altı, Yıldız Kapısı üstü)
  Widget _buildPsychedelicAllServicesButton(
    BuildContext context,
    WidgetRef ref,
  ) {
    final language = ref.watch(languageProvider);
    return GestureDetector(
      onTap: () => context.push(Routes.allServices),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple.withValues(alpha: 0.7),
              Colors.pink.withValues(alpha: 0.6),
              Colors.orange.withValues(alpha: 0.5),
              Colors.cyan.withValues(alpha: 0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.4),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withValues(alpha: 0.4),
              blurRadius: 16,
              spreadRadius: 4,
            ),
            BoxShadow(
              color: Colors.pink.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(5, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              L10nService.get('home.all_analyses', language),
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  // Tüm Çözümlemeler - Ana katalog butonu
  // Sadece Türkçe'de aktif, diğer dillerde "Yakında" gösterir
  Widget _buildAllServicesButton(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isAvailable = language == AppLanguage.tr; // Sadece Türkçe'de aktif

    return GestureDetector(
      onTap: isAvailable ? () => context.push(Routes.allServices) : null,
      child: Opacity(
        opacity: isAvailable ? 1.0 : 0.6,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF9C27B0).withValues(alpha: 0.35),
                const Color(0xFF673AB7).withValues(alpha: 0.25),
                const Color(0xFFE91E63).withValues(alpha: 0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF9C27B0).withValues(alpha: 0.4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9C27B0).withValues(alpha: 0.25),
                blurRadius: 15,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon with gradient
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFFE040FB),
                    Color(0xFFFFD700),
                    Color(0xFFE040FB),
                  ],
                ).createShader(bounds),
                child: const Icon(
                  Icons.explore_rounded,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFFE040FB),
                          Color(0xFFFFD700),
                          Color(0xFFFF4081),
                        ],
                      ).createShader(bounds),
                      child: Text(
                        L10nService.get('home.tooltips.all_kozmoz', language),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isAvailable
                          ? L10nService.get(
                              'home.tooltips.all_cosmic_tools',
                              language,
                            )
                          : L10nService.get('common.coming_soon', language),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isAvailable)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    L10nService.get('common.coming_soon', language),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                )
              else
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 600.ms);
  }

  Widget _buildAllSigns(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    // Zodiac date ranges - using L10nService
    String getSignDates(ZodiacSign sign) {
      return L10nService.get('zodiac.dates.${sign.name}', language);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '✨ ${L10nService.get('common.zodiac_signs', language)}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        // Tüm burçlar tek satırda - scroll ile, BÜYÜK boyut
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ZodiacSign.values.length,
            itemBuilder: (context, index) {
              final sign = ZodiacSign.values[index];
              return Padding(
                padding: EdgeInsets.only(right: index < 11 ? 10 : 0),
                child: GestureDetector(
                  onTap: () => context.push(
                    '${Routes.horoscope}/${sign.name.toLowerCase()}',
                  ),
                  child: Container(
                    width: 72,
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 5,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          sign.color.withValues(alpha: 0.4),
                          sign.color.withValues(alpha: 0.15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: sign.color.withValues(alpha: 0.6),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: sign.color.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Parlak burç sembolü
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [sign.color, Colors.white, sign.color],
                          ).createShader(bounds),
                          child: Text(
                            sign.symbol,
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              shadows: [
                                Shadow(color: sign.color, blurRadius: 15),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          sign.localizedName(language),
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          getSignDates(sign),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: Colors.white60, fontSize: 7),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
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

  void _showAddProfileDialog(BuildContext context, WidgetRef ref) {
    context.push(Routes.savedProfiles);
  }
}

class _SearchBottomSheet extends ConsumerStatefulWidget {
  const _SearchBottomSheet();

  @override
  ConsumerState<_SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends ConsumerState<_SearchBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // All available features with categories - using i18n
  List<_SearchItem> _getAllFeatures(AppLanguage language) => [
    // Kesfet (Explore) - Main features
    _SearchItem(
      L10nService.get('home.search_items.daily_horoscope.title', language),
      L10nService.get('home.search_items.daily_horoscope.desc', language),
      Icons.wb_sunny,
      Routes.horoscope,
      _SearchCategory.explore,
      ['gunluk', 'burc', 'yorum', 'daily', 'horoscope'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.weekly_horoscope.title', language),
      L10nService.get('home.search_items.weekly_horoscope.desc', language),
      Icons.calendar_view_week,
      Routes.weeklyHoroscope,
      _SearchCategory.explore,
      ['haftalik', 'weekly'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.monthly_horoscope.title', language),
      L10nService.get('home.search_items.monthly_horoscope.desc', language),
      Icons.calendar_month,
      Routes.monthlyHoroscope,
      _SearchCategory.explore,
      ['aylik', 'monthly'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.yearly_horoscope.title', language),
      L10nService.get('home.search_items.yearly_horoscope.desc', language),
      Icons.calendar_today,
      Routes.yearlyHoroscope,
      _SearchCategory.explore,
      ['yillik', 'yearly'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.love_horoscope.title', language),
      L10nService.get('home.search_items.love_horoscope.desc', language),
      Icons.favorite,
      Routes.loveHoroscope,
      _SearchCategory.explore,
      ['ask', 'love', 'iliski'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.birth_chart.title', language),
      L10nService.get('home.search_items.birth_chart.desc', language),
      Icons.auto_awesome,
      Routes.birthChart,
      _SearchCategory.explore,
      ['dogum', 'natal', 'harita', 'chart', 'birth'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.compatibility.title', language),
      L10nService.get('home.search_items.compatibility.desc', language),
      Icons.people,
      Routes.compatibility,
      _SearchCategory.explore,
      ['uyumluluk', 'compatibility'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.transits.title', language),
      L10nService.get('home.search_items.transits.desc', language),
      Icons.public,
      Routes.transits,
      _SearchCategory.explore,
      ['transit', 'gezegen', 'planet'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.numerology.title', language),
      L10nService.get('home.search_items.numerology.desc', language),
      Icons.pin,
      Routes.numerology,
      _SearchCategory.explore,
      ['numeroloji', 'sayi', 'number'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.kabbalah.title', language),
      L10nService.get('home.search_items.kabbalah.desc', language),
      Icons.account_tree,
      Routes.kabbalah,
      _SearchCategory.explore,
      ['kabala', 'kabbalah'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.tarot.title', language),
      L10nService.get('home.search_items.tarot.desc', language),
      Icons.style,
      Routes.tarot,
      _SearchCategory.explore,
      ['tarot', 'kart', 'card'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.aura.title', language),
      L10nService.get('home.search_items.aura.desc', language),
      Icons.blur_circular,
      Routes.aura,
      _SearchCategory.explore,
      ['aura', 'enerji', 'energy'],
    ),

    // Daha Fazla Arac (More Tools) - Advanced features
    _SearchItem(
      L10nService.get('home.search_items.transit_calendar.title', language),
      L10nService.get('home.search_items.transit_calendar.desc', language),
      Icons.event_note,
      Routes.transitCalendar,
      _SearchCategory.moreTools,
      ['transit', 'takvim', 'calendar'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.eclipse_calendar.title', language),
      L10nService.get('home.search_items.eclipse_calendar.desc', language),
      Icons.dark_mode,
      Routes.eclipseCalendar,
      _SearchCategory.moreTools,
      ['tutulma', 'eclipse', 'gunes', 'ay'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.synastry.title', language),
      L10nService.get('home.search_items.synastry.desc', language),
      Icons.people_alt,
      Routes.synastry,
      _SearchCategory.moreTools,
      ['sinastri', 'synastry', 'iliski', 'relationship'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.composite.title', language),
      L10nService.get('home.search_items.composite.desc', language),
      Icons.compare_arrows,
      Routes.compositeChart,
      _SearchCategory.moreTools,
      ['kompozit', 'composite'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.progressions.title', language),
      L10nService.get('home.search_items.progressions.desc', language),
      Icons.auto_graph,
      Routes.progressions,
      _SearchCategory.moreTools,
      ['progresyon', 'progression'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.saturn_return.title', language),
      L10nService.get('home.search_items.saturn_return.desc', language),
      Icons.refresh,
      Routes.saturnReturn,
      _SearchCategory.moreTools,
      ['saturn', 'donus', 'return'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.solar_return.title', language),
      L10nService.get('home.search_items.solar_return.desc', language),
      Icons.wb_sunny_outlined,
      Routes.solarReturn,
      _SearchCategory.moreTools,
      ['solar', 'gunes', 'donus'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.year_ahead.title', language),
      L10nService.get('home.search_items.year_ahead.desc', language),
      Icons.upcoming,
      Routes.yearAhead,
      _SearchCategory.moreTools,
      ['yil', 'ongoru', 'year', 'ahead'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.timing.title', language),
      L10nService.get('home.search_items.timing.desc', language),
      Icons.access_time,
      Routes.timing,
      _SearchCategory.moreTools,
      ['zaman', 'timing', 'time'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.vedic.title', language),
      L10nService.get('home.search_items.vedic.desc', language),
      Icons.brightness_3,
      Routes.vedicChart,
      _SearchCategory.moreTools,
      ['vedik', 'vedic', 'hint'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.astro_map.title', language),
      L10nService.get('home.search_items.astro_map.desc', language),
      Icons.map,
      Routes.astroCartography,
      _SearchCategory.moreTools,
      ['astro', 'harita', 'cartography', 'map'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.local_space.title', language),
      L10nService.get('home.search_items.local_space.desc', language),
      Icons.explore,
      Routes.localSpace,
      _SearchCategory.moreTools,
      ['yerel', 'local', 'space'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.electional.title', language),
      L10nService.get('home.search_items.electional.desc', language),
      Icons.schedule,
      Routes.electional,
      _SearchCategory.moreTools,
      ['elektif', 'electional'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.draconic.title', language),
      L10nService.get('home.search_items.draconic.desc', language),
      Icons.psychology,
      Routes.draconicChart,
      _SearchCategory.moreTools,
      ['drakonik', 'draconic'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.asteroids.title', language),
      L10nService.get('home.search_items.asteroids.desc', language),
      Icons.star_outline,
      Routes.asteroids,
      _SearchCategory.moreTools,
      ['asteroid', 'yildiz'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.gardening_moon.title', language),
      L10nService.get('home.search_items.gardening_moon.desc', language),
      Icons.eco,
      Routes.gardeningMoon,
      _SearchCategory.moreTools,
      ['bahce', 'garden', 'ay', 'moon'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.celebrities.title', language),
      L10nService.get('home.search_items.celebrities.desc', language),
      Icons.people,
      Routes.celebrities,
      _SearchCategory.moreTools,
      ['unlu', 'celebrity'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.articles.title', language),
      L10nService.get('home.search_items.articles.desc', language),
      Icons.article,
      Routes.articles,
      _SearchCategory.moreTools,
      ['makale', 'article', 'yazi'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.glossary.title', language),
      L10nService.get('home.search_items.glossary.desc', language),
      Icons.menu_book,
      Routes.glossary,
      _SearchCategory.moreTools,
      ['sozluk', 'glossary', 'terim'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.profile.title', language),
      L10nService.get('home.search_items.profile.desc', language),
      Icons.person,
      Routes.profile,
      _SearchCategory.moreTools,
      ['profil', 'profile'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.saved_profiles.title', language),
      L10nService.get('home.search_items.saved_profiles.desc', language),
      Icons.people_outline,
      Routes.savedProfiles,
      _SearchCategory.moreTools,
      ['kayitli', 'profil', 'saved'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.comparison.title', language),
      L10nService.get('home.search_items.comparison.desc', language),
      Icons.compare,
      Routes.comparison,
      _SearchCategory.moreTools,
      ['karsilastir', 'compare'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.settings.title', language),
      L10nService.get('home.search_items.settings.desc', language),
      Icons.settings,
      Routes.settings,
      _SearchCategory.moreTools,
      ['ayar', 'settings'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.premium.title', language),
      L10nService.get('home.search_items.premium.desc', language),
      Icons.workspace_premium,
      Routes.premium,
      _SearchCategory.moreTools,
      ['premium', 'pro'],
    ),
    // Spiritual & Wellness
    _SearchItem(
      L10nService.get('home.search_items.daily_ritual.title', language),
      L10nService.get('home.search_items.daily_ritual.desc', language),
      Icons.self_improvement,
      Routes.dailyRituals,
      _SearchCategory.explore,
      ['rituel', 'ritual', 'meditasyon', 'sabah', 'aksam'],
    ),
    _SearchItem(
      L10nService.get('home.search_items.chakra_analysis.title', language),
      L10nService.get('home.search_items.chakra_analysis.desc', language),
      Icons.blur_circular,
      Routes.chakraAnalysis,
      _SearchCategory.explore,
      ['chakra', 'cakra', 'enerji', 'denge'],
    ),
  ];

  List<_SearchItem> _getFilteredFeatures(AppLanguage language) {
    final allFeatures = _getAllFeatures(language);
    if (_searchQuery.isEmpty) return allFeatures;
    final query = _searchQuery.toLowerCase();
    return allFeatures.where((item) {
      return item.title.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query) ||
          item.keywords.any((k) => k.toLowerCase().contains(query));
    }).toList();
  }

  List<_SearchItem> _getExploreFeatures(AppLanguage language) =>
      _getFilteredFeatures(
        language,
      ).where((f) => f.category == _SearchCategory.explore).toList();

  List<_SearchItem> _getMoreToolsFeatures(AppLanguage language) =>
      _getFilteredFeatures(
        language,
      ).where((f) => f.category == _SearchCategory.moreTools).toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);

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
                    hintText: L10nService.get('home.search_hint', language),
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
                    if (_getExploreFeatures(language).isNotEmpty) ...[
                      _buildCategoryHeader(
                        L10nService.get('home.explore_category', language),
                        Icons.explore,
                      ),
                      const SizedBox(height: 8),
                      ..._getExploreFeatures(
                        language,
                      ).map((f) => _buildSearchResultItem(f)),
                      const SizedBox(height: 24),
                    ],
                    if (_getMoreToolsFeatures(language).isNotEmpty) ...[
                      _buildCategoryHeader(
                        L10nService.get('home.more_tools_category', language),
                        Icons.build,
                      ),
                      const SizedBox(height: 8),
                      ..._getMoreToolsFeatures(
                        language,
                      ).map((f) => _buildSearchResultItem(f)),
                    ],
                    if (_getFilteredFeatures(language).isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 48,
                                color: Colors.grey.withAlpha(100),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                L10nService.get('home.no_results', language),
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: Colors.grey),
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
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
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

  const _SearchItem(
    this.title,
    this.description,
    this.icon,
    this.route,
    this.category,
    this.keywords,
  );
}

// Animasyonlu Tantrik Logo Widget
// Küçük Tantrik Logo - Kompakt görünüm için
class _TantricLogoSmall extends StatefulWidget {
  const _TantricLogoSmall();

  @override
  State<_TantricLogoSmall> createState() => _TantricLogoSmallState();
}

class _TantricLogoSmallState extends State<_TantricLogoSmall> {
  @override
  Widget build(BuildContext context) {
    // Venus One Logo - Scottish Shorthair Kedi
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cosmicPurple.withValues(alpha: 0.8),
            AppColors.auroraStart.withValues(alpha: 0.6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.auroraStart.withValues(alpha: 0.4),
            blurRadius: 15,
            spreadRadius: 3,
          ),
          BoxShadow(
            color: AppColors.cosmicPurple.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dış halka - yıldızlı
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.starGold.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
          ),
          // Scottish Shorthair Kedi - Kozmik Maskot
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.starGold, Colors.white, AppColors.moonSilver],
            ).createShader(bounds),
            child: const Text(
              '🐱',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
          ),
          // Küçük yıldız aksan
          Positioned(
            top: 4,
            right: 6,
            child: Text(
              '✨',
              style: TextStyle(fontSize: 8, color: AppColors.starGold),
            ),
          ),
        ],
      ),
    );
  }
}

// Mini Chip - Kompakt bilgi gösterici
class _MiniChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MiniChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: color, fontSize: 10),
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
  final String? tooltip;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.tooltip,
  });

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final cardContent = GestureDetector(
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
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: cardContent);
    }
    return cardContent;
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
            color: colorScheme.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(currentLanguage.flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 4),
            Icon(
              Icons.expand_more,
              size: 16,
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
                  Icon(Icons.language, color: colorScheme.primary, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    L10n.get('language', currentLanguage),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: AppLanguage.values.map((lang) {
                  final isSelected = lang == currentLanguage;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: GestureDetector(
                      onTap: () {
                        onLanguageChanged(lang);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary.withValues(alpha: 0.2)
                              : (isDark
                                    ? AppColors.surfaceLight.withValues(
                                        alpha: 0.3,
                                      )
                                    : AppColors.lightSurfaceVariant),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            lang.flag,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
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
  final AppLanguage language;

  const _ShareSummaryButton({required this.onTap, required this.language});

  @override
  State<_ShareSummaryButton> createState() => _ShareSummaryButtonState();
}

// ════════════════════════════════════════════════════════════════════════════
// KOZMOZ USTASI - Premium AI Asistan Widget
// Ana sayfanın en önemli özelliği, kullanıcının ilk göreceği interaktif element
// ════════════════════════════════════════════════════════════════════════════

class _KozmozMasterSection extends ConsumerStatefulWidget {
  const _KozmozMasterSection();

  @override
  ConsumerState<_KozmozMasterSection> createState() =>
      _KozmozMasterSectionState();
}

class _KozmozMasterSectionState extends ConsumerState<_KozmozMasterSection> {
  final _questionController = TextEditingController();
  bool _isLoading = false;
  bool _isExpanded = false;
  final List<Map<String, String>> _chatHistory = [];

  // Featured questions - localized via i18n
  List<Map<String, dynamic>> _getFeaturedQuestions(AppLanguage language) {
    return [
      {
        'text':
            '💕 ${L10nService.get('home.featured_questions.soulmate', language)}',
        'category': 'love',
        'gradient': [const Color(0xFFE91E63), const Color(0xFFFF5722)],
      },
      {
        'text':
            '💰 ${L10nService.get('home.featured_questions.rich', language)}',
        'category': 'money',
        'gradient': [const Color(0xFF4CAF50), const Color(0xFF8BC34A)],
      },
      {
        'text':
            '🔮 ${L10nService.get('home.featured_questions.future', language)}',
        'category': 'future',
        'gradient': [const Color(0xFF9C27B0), const Color(0xFF673AB7)],
      },
      {
        'text':
            '⭐ ${L10nService.get('home.featured_questions.luck_today', language)}',
        'category': 'daily',
        'gradient': [const Color(0xFFFFD700), const Color(0xFFFF9800)],
      },
      {
        'text':
            '😈 ${L10nService.get('home.featured_questions.darkest_secret', language)}',
        'category': 'shadow',
        'gradient': [const Color(0xFF424242), const Color(0xFF880E4F)],
      },
      {
        'text':
            '💋 ${L10nService.get('home.featured_questions.love_improve', language)}',
        'category': 'love',
        'gradient': [const Color(0xFFE91E63), const Color(0xFFAD1457)],
      },
    ];
  }

  // Extended questions list - keys for localization
  static const List<Map<String, dynamic>> _allQuestionKeys = [
    // Zodiac Compatibility
    {'key': 'home.questions.aries_man', 'category': 'compatibility'},
    {'key': 'home.questions.scorpio_women', 'category': 'compatibility'},
    {'key': 'home.questions.leo_attention', 'category': 'compatibility'},
    {'key': 'home.questions.gemini_decisions', 'category': 'compatibility'},
    {'key': 'home.questions.fire_water', 'category': 'compatibility'},
    {'key': 'home.questions.most_loyal', 'category': 'compatibility'},
    {'key': 'home.questions.most_jealous', 'category': 'compatibility'},
    {'key': 'home.questions.most_passionate', 'category': 'compatibility'},
    // Love & Relationships
    {'key': 'home.questions.love_luck_today', 'category': 'love'},
    {'key': 'home.questions.ex_return', 'category': 'love'},
    {'key': 'home.questions.cheating', 'category': 'love'},
    {'key': 'home.questions.marriage_proposal', 'category': 'love'},
    {'key': 'home.questions.does_like_me', 'category': 'love'},
    {'key': 'home.questions.no_message', 'category': 'love'},
    // Career & Money
    {'key': 'home.questions.promotion', 'category': 'career'},
    {'key': 'home.questions.job_change', 'category': 'career'},
    {'key': 'home.questions.gambling', 'category': 'career'},
    // Spiritual
    {'key': 'home.questions.gratitude_star', 'category': 'spiritual'},
    {'key': 'home.questions.mercury_retrograde', 'category': 'spiritual'},
    {'key': 'home.questions.big_change', 'category': 'general'},
  ];

  List<Map<String, dynamic>> _getLocalizedQuestions(AppLanguage language) {
    return _allQuestionKeys
        .map(
          (q) => {
            'text': L10nService.get(q['key'] as String, language),
            'category': q['category'],
          },
        )
        .toList();
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _askQuestion([String? predefinedQuestion]) async {
    final question = predefinedQuestion ?? _questionController.text.trim();
    if (question.isEmpty) return;

    setState(() {
      _isLoading = true;
      _isExpanded = true;
      _chatHistory.add({'role': 'user', 'content': question});
    });

    _questionController.clear();

    try {
      final userProfile = ref.read(userProfileProvider);
      final sign = userProfile?.sunSign ?? ZodiacSign.aries;
      final aiService = AiContentService();

      String response;
      if (aiService.isAiAvailable) {
        response = await aiService.generatePersonalizedAdvice(
          sign: sign,
          area: _determineAdviceArea(question),
          context: question,
        );
      } else {
        response = _generateSmartLocalResponse(
          question,
          sign,
          ref.read(languageProvider),
        );
      }

      setState(() {
        _chatHistory.add({'role': 'assistant', 'content': response});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _chatHistory.add({
          'role': 'assistant',
          'content':
              '${L10nService.get('home.cosmic_connection_lost', ref.read(languageProvider))} 🌟',
        });
        _isLoading = false;
      });
    }
  }

  AdviceArea _determineAdviceArea(String question) {
    final lowerQuestion = question.toLowerCase();
    if (lowerQuestion.contains('aşk') ||
        lowerQuestion.contains('ilişki') ||
        lowerQuestion.contains('partner') ||
        lowerQuestion.contains('sevgili') ||
        lowerQuestion.contains('evlilik') ||
        lowerQuestion.contains('ruh eşi')) {
      return AdviceArea.love;
    } else if (lowerQuestion.contains('kariyer') ||
        lowerQuestion.contains('iş') ||
        lowerQuestion.contains('para') ||
        lowerQuestion.contains('maaş') ||
        lowerQuestion.contains('terfi') ||
        lowerQuestion.contains('zengin')) {
      return AdviceArea.career;
    } else if (lowerQuestion.contains('sağlık') ||
        lowerQuestion.contains('enerji') ||
        lowerQuestion.contains('stres')) {
      return AdviceArea.health;
    } else if (lowerQuestion.contains('ruhsal') ||
        lowerQuestion.contains('spiritüel') ||
        lowerQuestion.contains('karma')) {
      return AdviceArea.spiritual;
    }
    return AdviceArea.spiritual;
  }

  String _generateSmartLocalResponse(
    String question,
    ZodiacSign sign,
    AppLanguage language,
  ) {
    final lowerQuestion = question.toLowerCase();
    final signName = sign.localizedName(language);

    // Aries relationship questions
    if (_matchesAriesQuestion(lowerQuestion, language)) {
      return L10nService.getWithParams(
        'home.zodiac.smart_responses.aries_relationship',
        language,
        params: {
          'sign': signName,
          'compatibility': _getCompatibilityWithAries(sign, language),
        },
      );
    }

    // Scorpio relationship questions
    if (_matchesScorpioQuestion(lowerQuestion, language)) {
      return L10nService.getWithParams(
        'home.zodiac.smart_responses.scorpio_relationship',
        language,
        params: {
          'sign': signName,
          'compatibility': _getCompatibilityWithScorpio(sign, language),
        },
      );
    }

    // Leo attention questions
    if (_matchesLeoQuestion(lowerQuestion, language)) {
      return L10nService.getWithParams(
        'home.zodiac.smart_responses.leo_attention',
        language,
        params: {
          'sign': signName,
          'compatibility': _getCompatibilityWithLeo(sign, language),
        },
      );
    }

    // Gemini decision questions
    if (_matchesGeminiQuestion(lowerQuestion, language)) {
      return L10nService.getWithParams(
        'home.zodiac.smart_responses.gemini_decisions',
        language,
        params: {
          'sign': signName,
          'compatibility': _getCompatibilityWithGemini(sign, language),
        },
      );
    }

    // Fire and water compatibility
    if (_matchesFireWaterQuestion(lowerQuestion, language)) {
      return L10nService.get(
        'home.zodiac.smart_responses.fire_water_compatibility',
        language,
      );
    }

    // Most loyal signs
    if (_matchesLoyalQuestion(lowerQuestion, language)) {
      return L10nService.get(
        'home.zodiac.smart_responses.most_loyal',
        language,
      );
    }

    // Most jealous signs
    if (_matchesJealousQuestion(lowerQuestion, language)) {
      return L10nService.get(
        'home.zodiac.smart_responses.most_jealous',
        language,
      );
    }

    // Most passionate signs
    if (_matchesPassionateQuestion(lowerQuestion, language)) {
      return L10nService.get(
        'home.zodiac.smart_responses.most_passionate',
        language,
      );
    }

    // Financial/wealth questions
    if (_matchesWealthQuestion(lowerQuestion, language)) {
      return L10nService.getWithParams(
        'home.zodiac.smart_responses.financial_future',
        language,
        params: {
          'sign': signName,
          'lucky_months': _getLuckyMonths(sign, language),
          'financial_strength': _getFinancialStrength(sign, language),
        },
      );
    }

    // Soulmate questions
    if (_matchesSoulmateQuestion(lowerQuestion, language)) {
      return L10nService.getWithParams(
        'home.zodiac.smart_responses.soulmate',
        language,
        params: {
          'sign': signName,
          'soulmate_compatibility': _getSoulMateCompatibility(sign, language),
        },
      );
    }

    // Love questions
    if (_matchesLoveQuestion(lowerQuestion, language)) {
      final venusEffectKey = sign.element == Element.fire
          ? 'venus_fire'
          : sign.element == Element.water
          ? 'venus_water'
          : sign.element == Element.earth
          ? 'venus_earth'
          : 'venus_air';
      return L10nService.getWithParams(
        'home.zodiac.smart_responses.love_reading',
        language,
        params: {
          'sign': signName,
          'venus_effect': L10nService.get(
            'home.zodiac.smart_responses.$venusEffectKey',
            language,
          ),
          'love_advice': _getLoveAdvice(sign, language),
        },
      );
    }

    // General/Spiritual questions (default)
    return L10nService.getWithParams(
      'home.zodiac.smart_responses.general_spiritual',
      language,
      params: {
        'sign': signName,
        'daily_message': _getDailyMessage(sign, language),
        'daily_energy': _getDailyEnergy(sign, language),
      },
    );
  }

  // Question matching helpers for multi-language support
  bool _matchesAriesQuestion(String q, AppLanguage lang) {
    if (lang == AppLanguage.tr)
      return q.contains('koç') &&
          (q.contains('erkek') || q.contains('kadın') || q.contains('anlaş'));
    return q.contains('aries') &&
        (q.contains('man') || q.contains('woman') || q.contains('along'));
  }

  bool _matchesScorpioQuestion(String q, AppLanguage lang) {
    if (lang == AppLanguage.tr)
      return q.contains('akrep') &&
          (q.contains('kadın') || q.contains('erkek') || q.contains('gizemli'));
    return q.contains('scorpio') &&
        (q.contains('woman') || q.contains('man') || q.contains('mysterious'));
  }

  bool _matchesLeoQuestion(String q, AppLanguage lang) {
    if (lang == AppLanguage.tr)
      return q.contains('aslan') &&
          (q.contains('ilgi') || q.contains('bekler') || q.contains('ego'));
    return q.contains('leo') &&
        (q.contains('attention') || q.contains('need') || q.contains('ego'));
  }

  bool _matchesGeminiQuestion(String q, AppLanguage lang) {
    if (lang == AppLanguage.tr)
      return q.contains('ikizler') &&
          (q.contains('karar') ||
              q.contains('veremez') ||
              q.contains('değişken'));
    return q.contains('gemini') &&
        (q.contains('decision') ||
            q.contains('decide') ||
            q.contains('changeable'));
  }

  bool _matchesFireWaterQuestion(String q, AppLanguage lang) {
    if (lang == AppLanguage.tr) return q.contains('ateş') && q.contains('su');
    return q.contains('fire') && q.contains('water');
  }

  bool _matchesLoyalQuestion(String q, AppLanguage lang) {
    if (lang == AppLanguage.tr)
      return q.contains('sadık') || q.contains('en sadık');
    return q.contains('loyal') || q.contains('most loyal');
  }

  bool _matchesJealousQuestion(String q, AppLanguage lang) {
    if (lang == AppLanguage.tr)
      return q.contains('kıskanç') || q.contains('kıskançlık');
    return q.contains('jealous') || q.contains('jealousy');
  }

  bool _matchesPassionateQuestion(String q, AppLanguage lang) {
    if (lang == AppLanguage.tr)
      return q.contains('yatakta') ||
          q.contains('ateşli') ||
          q.contains('cinsel');
    return q.contains('bed') ||
        q.contains('passionate') ||
        q.contains('sexual');
  }

  bool _matchesWealthQuestion(String q, AppLanguage lang) {
    if (lang == AppLanguage.tr)
      return q.contains('zengin') || q.contains('para') || q.contains('bolluk');
    return q.contains('rich') ||
        q.contains('money') ||
        q.contains('wealth') ||
        q.contains('abundance');
  }

  bool _matchesSoulmateQuestion(String q, AppLanguage lang) {
    if (lang == AppLanguage.tr)
      return q.contains('ruh eşi') ||
          q.contains('kader') ||
          q.contains('büyük aşk');
    return q.contains('soulmate') ||
        q.contains('soul mate') ||
        q.contains('destiny') ||
        q.contains('true love');
  }

  bool _matchesLoveQuestion(String q, AppLanguage lang) {
    if (lang == AppLanguage.tr)
      return q.contains('aşk') ||
          q.contains('ilişki') ||
          q.contains('sevgili') ||
          q.contains('evlilik');
    return q.contains('love') ||
        q.contains('relationship') ||
        q.contains('partner') ||
        q.contains('marriage');
  }

  String _getLuckyMonths(ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('home.zodiac.favorable_months.$signKey', language);
  }

  String _getFinancialStrength(ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('home.zodiac.financial_strength.$signKey', language);
  }

  String _getSoulMateCompatibility(ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get(
      'home.zodiac.soulmate_compatibility.$signKey',
      language,
    );
  }

  String _getLoveAdvice(ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('home.zodiac.love_advice.$signKey', language);
  }

  String _getDailyMessage(ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('home.zodiac.daily_message.$signKey', language);
  }

  String _getDailyEnergy(ZodiacSign sign, AppLanguage language) {
    final energyKeys = [
      'positive',
      'strong',
      'creative',
      'passionate',
      'balanced',
      'peaceful',
      'energetic',
      'intuitive',
    ];
    final index = (DateTime.now().day + sign.index) % energyKeys.length;
    return L10nService.get(
      'home.zodiac.daily_energy.${energyKeys[index]}',
      language,
    );
  }

  // Burç uyumu hesaplama fonksiyonları
  String _getCompatibilityWithAries(ZodiacSign userSign, AppLanguage language) {
    final signKey = userSign.name.toLowerCase();
    return L10nService.get(
      'home.zodiac.compatibility.aries.$signKey',
      language,
    );
  }

  String _getCompatibilityWithScorpio(
    ZodiacSign userSign,
    AppLanguage language,
  ) {
    final signKey = userSign.name.toLowerCase();
    return L10nService.get(
      'home.zodiac.compatibility.scorpio.$signKey',
      language,
    );
  }

  String _getCompatibilityWithLeo(ZodiacSign userSign, AppLanguage language) {
    final signKey = userSign.name.toLowerCase();
    return L10nService.get('home.zodiac.compatibility.leo.$signKey', language);
  }

  String _getCompatibilityWithGemini(
    ZodiacSign userSign,
    AppLanguage language,
  ) {
    final signKey = userSign.name.toLowerCase();
    return L10nService.get(
      'home.zodiac.compatibility.gemini.$signKey',
      language,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final sign = userProfile?.sunSign ?? ZodiacSign.aries;
    final language = ref.watch(languageProvider);

    return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F0F23)],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF9C27B0).withValues(alpha: 0.6),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9C27B0).withValues(alpha: 0.3),
                blurRadius: 25,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: const Color(0xFFE91E63).withValues(alpha: 0.2),
                blurRadius: 40,
                spreadRadius: 5,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ════════════════════════════════════════════════════════════
              // HEADER - Premium görünüm
              // ════════════════════════════════════════════════════════════
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF9C27B0).withValues(alpha: 0.4),
                      const Color(0xFFE91E63).withValues(alpha: 0.3),
                      const Color(0xFF673AB7).withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                  ),
                ),
                child: Row(
                  children: [
                    // Animated Icon Container
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF9C27B0),
                            const Color(0xFFE91E63),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF9C27B0,
                            ).withValues(alpha: 0.6),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.white, Color(0xFFFFD700)],
                        ).createShader(bounds),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Title & Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Color(0xFFFFD700),
                                        Colors.white,
                                      ],
                                    ).createShader(bounds),
                                child: Text(
                                  '🔮 ${L10nService.get('home.kozmoz_master', language)}',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFFD700),
                                      Color(0xFFFF9800),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFFFD700,
                                      ).withValues(alpha: 0.5),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'AI',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            L10nService.getWithParams(
                              'home.zodiac.personalized_guidance',
                              language,
                              params: {'sign': sign.getLocalizedName(language)},
                            ),
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ════════════════════════════════════════════════════════════
              // FEATURED QUESTIONS - Hızlı erişim butonları
              // ════════════════════════════════════════════════════════════
              if (!_isExpanded && _chatHistory.isEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Icon(Icons.trending_up, color: Colors.amber, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        L10nService.get(
                          'home.most_popular_questions',
                          language,
                        ),
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Featured questions grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _getFeaturedQuestions(language).map((q) {
                      final gradientColors = q['gradient'] as List<Color>;
                      return GestureDetector(
                        onTap: () => _askQuestion(q['text'] as String),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                gradientColors[0].withValues(alpha: 0.3),
                                gradientColors[1].withValues(alpha: 0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: gradientColors[0].withValues(alpha: 0.5),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: gradientColors[0].withValues(alpha: 0.2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Text(
                            q['text'] as String,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // ════════════════════════════════════════════════════════════
              // CHAT HISTORY - Sohbet geçmişi
              // ════════════════════════════════════════════════════════════
              if (_chatHistory.isNotEmpty)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(16),
                  constraints: BoxConstraints(
                    minHeight: 120,
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF9C27B0).withValues(alpha: 0.3),
                    ),
                  ),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _chatHistory.map((message) {
                        final isUser = message['role'] == 'user';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isUser
                                        ? [
                                            const Color(0xFFFFD700),
                                            Colors.orange,
                                          ]
                                        : [
                                            const Color(0xFF9C27B0),
                                            const Color(0xFFE91E63),
                                          ],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          (isUser
                                                  ? const Color(0xFFFFD700)
                                                  : const Color(0xFF9C27B0))
                                              .withValues(alpha: 0.4),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isUser ? Icons.person : Icons.auto_awesome,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: isUser
                                        ? const Color(
                                            0xFFFFD700,
                                          ).withValues(alpha: 0.15)
                                        : const Color(
                                            0xFF9C27B0,
                                          ).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isUser
                                          ? const Color(
                                              0xFFFFD700,
                                            ).withValues(alpha: 0.4)
                                          : const Color(
                                              0xFF9C27B0,
                                            ).withValues(alpha: 0.4),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    message['content'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

              // ════════════════════════════════════════════════════════════
              // INPUT FIELD - Soru sorma alanı
              // ════════════════════════════════════════════════════════════
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF9C27B0).withValues(alpha: 0.1),
                              const Color(0xFFE91E63).withValues(alpha: 0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(
                              0xFF9C27B0,
                            ).withValues(alpha: 0.3),
                          ),
                        ),
                        child: TextField(
                          controller: _questionController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: L10nService.get(
                              'home.ask_stars_hint',
                              ref.watch(languageProvider),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: 13,
                            ),
                            prefixIcon: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
                              ).createShader(bounds),
                              child: Icon(
                                Icons.chat_bubble_outline,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            filled: false,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          onSubmitted: (_) => _askQuestion(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _isLoading ? null : () => _askQuestion(),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isLoading
                                ? [Colors.grey, Colors.grey.shade600]
                                : [
                                    const Color(0xFF9C27B0),
                                    const Color(0xFFE91E63),
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: _isLoading
                              ? []
                              : [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF9C27B0,
                                    ).withValues(alpha: 0.5),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              // ════════════════════════════════════════════════════════════
              // MORE QUESTIONS - Daha fazla soru
              // ════════════════════════════════════════════════════════════
              if (_chatHistory.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            L10nService.get('home.other_questions', language),
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 36,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _getLocalizedQuestions(language).length,
                          itemBuilder: (context, index) {
                            final question = _getLocalizedQuestions(
                              language,
                            )[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () =>
                                    _askQuestion(question['text'] as String),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(
                                          0xFF9C27B0,
                                        ).withValues(alpha: 0.2),
                                        const Color(
                                          0xFFE91E63,
                                        ).withValues(alpha: 0.15),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: const Color(
                                        0xFF9C27B0,
                                      ).withValues(alpha: 0.4),
                                    ),
                                  ),
                                  child: Text(
                                    question['text'] as String,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(
          begin: 0.1,
          end: 0,
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// ESKİ _AiChatSection - Kullanılmıyor, referans için tutuldu
// ════════════════════════════════════════════════════════════════════════════

class _AiChatSection extends ConsumerStatefulWidget {
  const _AiChatSection();

  @override
  ConsumerState<_AiChatSection> createState() => _AiChatSectionState();
}

class _AiChatSectionState extends ConsumerState<_AiChatSection> {
  final _questionController = TextEditingController();
  bool _isLoading = false;
  final List<Map<String, String>> _chatHistory = [];

  // Suggested questions - localized via i18n
  List<Map<String, dynamic>> _getSuggestedQuestions(AppLanguage language) {
    return [
      // Zodiac Compatibility
      {
        'text': L10nService.get('home.questions.aries_man', language),
        'category': 'compatibility',
        'icon': '♈',
      },
      {
        'text': L10nService.get('home.questions.scorpio_women', language),
        'category': 'compatibility',
        'icon': '♏',
      },
      {
        'text': L10nService.get('home.questions.leo_attention', language),
        'category': 'compatibility',
        'icon': '♌',
      },
      {
        'text': L10nService.get('home.questions.gemini_decisions', language),
        'category': 'compatibility',
        'icon': '♊',
      },
      {
        'text': L10nService.get('home.questions.fire_water', language),
        'category': 'compatibility',
        'icon': '🔥',
      },
      {
        'text': L10nService.get('home.questions.most_loyal', language),
        'category': 'compatibility',
        'icon': '💫',
      },
      {
        'text': L10nService.get('home.questions.most_jealous', language),
        'category': 'compatibility',
        'icon': '😈',
      },
      {
        'text': L10nService.get('home.questions.most_passionate', language),
        'category': 'compatibility',
        'icon': '💋',
      },
      // Love & Relationships
      {
        'text': L10nService.get('home.questions.love_luck_today', language),
        'category': 'love',
        'icon': '💕',
      },
      {
        'text': L10nService.get('home.questions.soulmate_find', language),
        'category': 'love',
        'icon': '💑',
      },
      {
        'text': L10nService.get('home.questions.ex_return', language),
        'category': 'love',
        'icon': '💔',
      },
      {
        'text': L10nService.get('home.questions.cheating', language),
        'category': 'love',
        'icon': '🤫',
      },
      {
        'text': L10nService.get('home.questions.marriage_proposal', language),
        'category': 'love',
        'icon': '💍',
      },
      {
        'text': L10nService.get('home.questions.does_like_me', language),
        'category': 'love',
        'icon': '😍',
      },
      {
        'text': L10nService.get('home.questions.no_message', language),
        'category': 'love',
        'icon': '💬',
      },
      {
        'text': L10nService.get('home.questions.future_love', language),
        'category': 'love',
        'icon': '🔮',
      },
      // Career & Money
      {
        'text': L10nService.get('home.questions.promotion', language),
        'category': 'career',
        'icon': '💼',
      },
      {
        'text': L10nService.get('home.questions.rich_become', language),
        'category': 'career',
        'icon': '💰',
      },
      {
        'text': L10nService.get('home.questions.job_change', language),
        'category': 'career',
        'icon': '📈',
      },
      {
        'text': L10nService.get('home.questions.gambling', language),
        'category': 'career',
        'icon': '🎰',
      },
      // Spiritual & General
      {
        'text': L10nService.get('home.questions.gratitude_star', language),
        'category': 'spiritual',
        'icon': '✨',
      },
      {
        'text': L10nService.get('home.questions.mercury_retrograde', language),
        'category': 'spiritual',
        'icon': '🌙',
      },
      {
        'text': L10nService.get('home.questions.big_change', language),
        'category': 'general',
        'icon': '🦋',
      },
      {
        'text': L10nService.get('home.questions.attention_this_week', language),
        'category': 'general',
        'icon': '🎭',
      },
    ];
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _askQuestion([String? predefinedQuestion]) async {
    final question = predefinedQuestion ?? _questionController.text.trim();
    if (question.isEmpty) return;

    setState(() {
      _isLoading = true;
      _chatHistory.add({'role': 'user', 'content': question});
    });

    _questionController.clear();

    try {
      final userProfile = ref.read(userProfileProvider);
      final sign = userProfile?.sunSign ?? ZodiacSign.aries;
      final aiService = AiContentService();

      String response;
      if (aiService.isAiAvailable) {
        response = await aiService.generatePersonalizedAdvice(
          sign: sign,
          area: _determineAdviceArea(question),
          context: question,
        );
      } else {
        response = _generateSmartLocalResponse(
          question,
          sign,
          ref.read(languageProvider),
        );
      }

      setState(() {
        _chatHistory.add({'role': 'assistant', 'content': response});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _chatHistory.add({
          'role': 'assistant',
          'content':
              '${L10nService.get('home.cosmic_connection_lost', ref.read(languageProvider))} 🌟',
        });
        _isLoading = false;
      });
    }
  }

  AdviceArea _determineAdviceArea(String question) {
    final lowerQuestion = question.toLowerCase();
    // Multi-language keywords for love
    if (lowerQuestion.contains('aşk') ||
        lowerQuestion.contains('ilişki') ||
        lowerQuestion.contains('partner') ||
        lowerQuestion.contains('sevgili') ||
        lowerQuestion.contains('evlilik') ||
        lowerQuestion.contains('ruh eşi') ||
        lowerQuestion.contains('love') ||
        lowerQuestion.contains('relationship') ||
        lowerQuestion.contains('marriage') ||
        lowerQuestion.contains('soulmate')) {
      return AdviceArea.love;
      // Multi-language keywords for career
    } else if (lowerQuestion.contains('kariyer') ||
        lowerQuestion.contains('iş') ||
        lowerQuestion.contains('para') ||
        lowerQuestion.contains('maaş') ||
        lowerQuestion.contains('terfi') ||
        lowerQuestion.contains('career') ||
        lowerQuestion.contains('job') ||
        lowerQuestion.contains('money') ||
        lowerQuestion.contains('salary') ||
        lowerQuestion.contains('promotion')) {
      return AdviceArea.career;
      // Multi-language keywords for health
    } else if (lowerQuestion.contains('sağlık') ||
        lowerQuestion.contains('enerji') ||
        lowerQuestion.contains('stres') ||
        lowerQuestion.contains('uyku') ||
        lowerQuestion.contains('health') ||
        lowerQuestion.contains('energy') ||
        lowerQuestion.contains('stress') ||
        lowerQuestion.contains('sleep')) {
      return AdviceArea.health;
      // Multi-language keywords for spiritual
    } else if (lowerQuestion.contains('ruhsal') ||
        lowerQuestion.contains('spiritüel') ||
        lowerQuestion.contains('meditasyon') ||
        lowerQuestion.contains('karma') ||
        lowerQuestion.contains('evren') ||
        lowerQuestion.contains('spiritual') ||
        lowerQuestion.contains('meditation') ||
        lowerQuestion.contains('universe')) {
      return AdviceArea.spiritual;
    }
    return AdviceArea.spiritual;
  }

  String _generateSmartLocalResponse(
    String question,
    ZodiacSign sign,
    AppLanguage language,
  ) {
    final lowerQuestion = question.toLowerCase();
    final signName = sign.localizedName(language);

    // Aries relationship questions
    if (_matchesAriesQuestion2(lowerQuestion, language)) {
      return L10nService.getWithParams(
        'home.zodiac.smart_responses.aries_relationship',
        language,
        params: {
          'sign': signName,
          'compatibility': _getCompatibilityWithAries(sign, language),
        },
      );
    }

    // Scorpio relationship questions
    if (_matchesScorpioQuestion2(lowerQuestion, language)) {
      return L10nService.getWithParams(
        'home.zodiac.smart_responses.scorpio_relationship',
        language,
        params: {
          'sign': signName,
          'compatibility': _getCompatibilityWithScorpio(sign, language),
        },
      );
    }

    // Leo attention questions
    if (_matchesLeoQuestion2(lowerQuestion, language)) {
      return L10nService.getWithParams(
        'home.zodiac.smart_responses.leo_attention',
        language,
        params: {
          'sign': signName,
          'compatibility': _getCompatibilityWithLeo(sign, language),
        },
      );
    }

    // Gemini decision questions
    if (_matchesGeminiQuestion2(lowerQuestion, language)) {
      return L10nService.getWithParams(
        'home.zodiac.smart_responses.gemini_decisions',
        language,
        params: {
          'sign': signName,
          'compatibility': _getCompatibilityWithGemini(sign, language),
        },
      );
    }

    // Fire and water compatibility
    if (_matchesFireWaterQuestion2(lowerQuestion, language)) {
      return L10nService.get(
        'home.zodiac.smart_responses.fire_water_compatibility',
        language,
      );
    }

    // Most loyal signs
    if (_matchesLoyalQuestion2(lowerQuestion, language)) {
      return L10nService.get(
        'home.zodiac.smart_responses.most_loyal',
        language,
      );
    }

    // Most jealous signs
    if (_matchesJealousQuestion2(lowerQuestion, language)) {
      return L10nService.get(
        'home.zodiac.smart_responses.most_jealous',
        language,
      );
    }

    // Most passionate signs
    if (_matchesPassionateQuestion2(lowerQuestion, language)) {
      return L10nService.get(
        'home.zodiac.smart_responses.most_passionate',
        language,
      );
    }

    // Financial/wealth questions
    if (_matchesWealthQuestion2(lowerQuestion, language)) {
      return L10nService.getWithParams(
        'home.zodiac.smart_responses.financial_future',
        language,
        params: {
          'sign': signName,
          'lucky_months': _getLuckyMonths2(sign, language),
          'financial_strength': _getFinancialStrength2(sign, language),
        },
      );
    }

    // Soulmate questions
    if (_matchesSoulmateQuestion2(lowerQuestion, language)) {
      return L10nService.getWithParams(
        'home.zodiac.smart_responses.soulmate',
        language,
        params: {
          'sign': signName,
          'soulmate_compatibility': _getSoulMateCompatibility2(sign, language),
        },
      );
    }

    // Love questions
    if (_matchesLoveQuestion2(lowerQuestion, language)) {
      final venusEffectKey = sign.element == Element.fire
          ? 'venus_fire'
          : sign.element == Element.water
          ? 'venus_water'
          : sign.element == Element.earth
          ? 'venus_earth'
          : 'venus_air';
      return L10nService.getWithParams(
        'home.zodiac.smart_responses.love_reading',
        language,
        params: {
          'sign': signName,
          'venus_effect': L10nService.get(
            'home.zodiac.smart_responses.$venusEffectKey',
            language,
          ),
          'love_advice': _getLoveAdvice2(sign, language),
        },
      );
    }

    // General/Spiritual questions (default)
    return L10nService.getWithParams(
      'home.zodiac.smart_responses.general_spiritual',
      language,
      params: {
        'sign': signName,
        'daily_message': _getDailyMessage2(sign, language),
        'daily_energy': _getDailyEnergy2(sign, language),
      },
    );
  }

  // Question matching helpers for multi-language support
  bool _matchesAriesQuestion2(String q, AppLanguage lang) {
    if (lang == AppLanguage.tr)
      return q.contains('koç') &&
          (q.contains('erkek') || q.contains('kadın') || q.contains('anlaş'));
    return q.contains('aries') &&
        (q.contains('man') || q.contains('woman') || q.contains('along'));
  }

  bool _matchesScorpioQuestion2(String q, AppLanguage lang) {
    if (lang == AppLanguage.tr)
      return q.contains('akrep') &&
          (q.contains('kadın') || q.contains('erkek') || q.contains('gizemli'));
    return q.contains('scorpio') &&
        (q.contains('woman') || q.contains('man') || q.contains('mysterious'));
  }

  bool _matchesLeoQuestion2(String q, AppLanguage lang) {
    if (lang == AppLanguage.tr)
      return q.contains('aslan') &&
          (q.contains('ilgi') || q.contains('bekler') || q.contains('ego'));
    return q.contains('leo') &&
        (q.contains('attention') || q.contains('need') || q.contains('ego'));
  }

  bool _matchesGeminiQuestion2(String q, AppLanguage lang) {
    if (lang == AppLanguage.tr)
      return q.contains('ikizler') &&
          (q.contains('karar') ||
              q.contains('veremez') ||
              q.contains('değişken'));
    return q.contains('gemini') &&
        (q.contains('decision') ||
            q.contains('decide') ||
            q.contains('changeable'));
  }

  bool _matchesFireWaterQuestion2(String q, AppLanguage lang) {
    if (lang == AppLanguage.tr) return q.contains('ateş') && q.contains('su');
    return q.contains('fire') && q.contains('water');
  }

  bool _matchesLoyalQuestion2(String q, AppLanguage lang) {
    if (lang == AppLanguage.tr)
      return q.contains('sadık') || q.contains('en sadık');
    return q.contains('loyal') || q.contains('most loyal');
  }

  bool _matchesJealousQuestion2(String q, AppLanguage lang) {
    if (lang == AppLanguage.tr)
      return q.contains('kıskanç') || q.contains('kıskançlık');
    return q.contains('jealous') || q.contains('jealousy');
  }

  bool _matchesPassionateQuestion2(String q, AppLanguage lang) {
    if (lang == AppLanguage.tr)
      return q.contains('yatakta') ||
          q.contains('ateşli') ||
          q.contains('cinsel');
    return q.contains('bed') ||
        q.contains('passionate') ||
        q.contains('sexual');
  }

  bool _matchesWealthQuestion2(String q, AppLanguage lang) {
    if (lang == AppLanguage.tr)
      return q.contains('zengin') || q.contains('para') || q.contains('bolluk');
    return q.contains('rich') ||
        q.contains('money') ||
        q.contains('wealth') ||
        q.contains('abundance');
  }

  bool _matchesSoulmateQuestion2(String q, AppLanguage lang) {
    if (lang == AppLanguage.tr)
      return q.contains('ruh eşi') ||
          q.contains('kader') ||
          q.contains('büyük aşk');
    return q.contains('soulmate') ||
        q.contains('soul mate') ||
        q.contains('destiny') ||
        q.contains('true love');
  }

  bool _matchesLoveQuestion2(String q, AppLanguage lang) {
    if (lang == AppLanguage.tr)
      return q.contains('aşk') ||
          q.contains('ilişki') ||
          q.contains('sevgili') ||
          q.contains('evlilik');
    return q.contains('love') ||
        q.contains('relationship') ||
        q.contains('partner') ||
        q.contains('marriage');
  }

  String _getLuckyMonths2(ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('home.zodiac.favorable_months.$signKey', language);
  }

  String _getFinancialStrength2(ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('home.zodiac.financial_strength.$signKey', language);
  }

  String _getSoulMateCompatibility2(ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get(
      'home.zodiac.soulmate_compatibility.$signKey',
      language,
    );
  }

  String _getLoveAdvice2(ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('home.zodiac.love_advice.$signKey', language);
  }

  String _getDailyMessage2(ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('home.zodiac.daily_message.$signKey', language);
  }

  String _getDailyEnergy2(ZodiacSign sign, AppLanguage language) {
    final energyKeys = [
      'positive',
      'strong',
      'creative',
      'passionate',
      'balanced',
      'peaceful',
      'energetic',
      'intuitive',
    ];
    final index = (DateTime.now().day + sign.index) % energyKeys.length;
    return L10nService.get(
      'home.zodiac.daily_energy.${energyKeys[index]}',
      language,
    );
  }

  // Burç uyumu hesaplama fonksiyonları
  String _getCompatibilityWithAries(ZodiacSign userSign, AppLanguage language) {
    final signKey = userSign.name.toLowerCase();
    return L10nService.get(
      'home.zodiac.compatibility.aries.$signKey',
      language,
    );
  }

  String _getCompatibilityWithScorpio(
    ZodiacSign userSign,
    AppLanguage language,
  ) {
    final signKey = userSign.name.toLowerCase();
    return L10nService.get(
      'home.zodiac.compatibility.scorpio.$signKey',
      language,
    );
  }

  String _getCompatibilityWithLeo(ZodiacSign userSign, AppLanguage language) {
    final signKey = userSign.name.toLowerCase();
    return L10nService.get('home.zodiac.compatibility.leo.$signKey', language);
  }

  String _getCompatibilityWithGemini(
    ZodiacSign userSign,
    AppLanguage language,
  ) {
    final signKey = userSign.name.toLowerCase();
    return L10nService.get(
      'home.zodiac.compatibility.gemini.$signKey',
      language,
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF1A1A2E), const Color(0xFF16213E)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.auroraStart.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.auroraStart.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - Premium görünüm
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.auroraStart.withValues(alpha: 0.4),
                  AppColors.auroraEnd.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.auroraStart, AppColors.auroraEnd],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.auroraStart.withValues(alpha: 0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '🔮 Kozmik Asistan',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.amber, Colors.orange],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'MASTER',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        L10nService.get('home.discover_stars_wisdom', language),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Chat History - Geniş ve otomatik genişleyen
          if (_chatHistory.isNotEmpty)
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              constraints: BoxConstraints(
                minHeight: 150,
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.auroraStart.withValues(alpha: 0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.auroraStart.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _chatHistory.map((message) {
                    final isUser = message['role'] == 'user';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isUser
                                    ? [AppColors.starGold, Colors.orange]
                                    : [
                                        AppColors.auroraStart,
                                        AppColors.auroraEnd,
                                      ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (isUser
                                              ? AppColors.starGold
                                              : AppColors.auroraStart)
                                          .withValues(alpha: 0.4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Icon(
                              isUser ? Icons.person : Icons.auto_awesome,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? AppColors.starGold.withValues(alpha: 0.15)
                                    : AppColors.auroraStart.withValues(
                                        alpha: 0.15,
                                      ),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isUser
                                      ? AppColors.starGold.withValues(
                                          alpha: 0.4,
                                        )
                                      : AppColors.auroraStart.withValues(
                                          alpha: 0.4,
                                        ),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                message['content'] ?? '',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

          // Input Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: L10nService.get(
                        'home.ask_stars_short',
                        language,
                      ),
                      hintStyle: TextStyle(color: Colors.white38, fontSize: 13),
                      prefixIcon: Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white38,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: AppColors.auroraStart,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onSubmitted: (_) => _askQuestion(),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _isLoading ? null : () => _askQuestion(),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isLoading
                            ? [Colors.grey, Colors.grey.shade600]
                            : [AppColors.auroraStart, AppColors.auroraEnd],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: _isLoading
                          ? []
                          : [
                              BoxShadow(
                                color: AppColors.auroraStart.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                  ),
                ),
              ],
            ),
          ),

          // Hazır Sorular - Genişletilmiş
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      L10nService.get(
                        'home.zodiac.popular_questions',
                        language,
                      ),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _getSuggestedQuestions(language).length,
                    itemBuilder: (context, index) {
                      final question = _getSuggestedQuestions(language)[index];
                      return Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: _buildSuggestionChip(question['text'] as String),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return GestureDetector(
      onTap: () => _askQuestion(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.auroraStart.withValues(alpha: 0.2),
              AppColors.auroraEnd.withValues(alpha: 0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.auroraStart.withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
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
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment(-1, -1),
              end: Alignment(1, 1),
              colors: [
                Color(0xFFFF3CAC), // Hot pink
                Color(0xFF784BA0), // Purple
                Color(0xFF2B86C5), // Blue
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withAlpha(60), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF3CAC).withAlpha(120),
                blurRadius: 25,
                offset: const Offset(-3, 6),
                spreadRadius: 2,
              ),
              BoxShadow(
                color: const Color(0xFF2B86C5).withAlpha(120),
                blurRadius: 25,
                offset: const Offset(3, 6),
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.white.withAlpha(30),
                blurRadius: 1,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Glass effect overlay
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withAlpha(40),
                          Colors.white.withAlpha(5),
                        ],
                        stops: const [0.0, 0.5],
                      ),
                    ),
                  ),
                ),
              ),
              // Content
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Sparkle emoji
                  const Text('✨', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  // Instagram icon - premium design
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFEDA77),
                          Color(0xFFF58529),
                          Color(0xFFDD2A7B),
                          Color(0xFF8134AF),
                          Color(0xFF515BD4),
                        ],
                        stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFDD2A7B).withAlpha(120),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Inner border
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                        // Camera icon
                        const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        // Dot
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Text content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Instagram\'da Paylaş',
                            style: GoogleFonts.raleway(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.3,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withAlpha(60),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text('💫', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        L10nService.get(
                          'home.share_cosmic_energy',
                          widget.language,
                        ),
                        style: GoogleFonts.raleway(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withAlpha(220),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  const Text('🔮', style: TextStyle(fontSize: 22)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// KOZMOZ Özel Parlayan Buton - Sürekli animasyonlu, göz alıcı
class _KozmozButton extends StatefulWidget {
  final VoidCallback onTap;

  const _KozmozButton({required this.onTap});

  @override
  State<_KozmozButton> createState() => _KozmozButtonState();
}

class _KozmozButtonState extends State<_KozmozButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          // Static gradient background
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFD700),
              Color(0xFFFF6B9D),
              Color(0xFF9D4EDD),
              Color(0xFF00D9FF),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withValues(alpha: 0.5),
              blurRadius: 20,
              spreadRadius: 3,
            ),
            BoxShadow(
              color: const Color(0xFF00D9FF).withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D1A).withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Static star icon
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFD700), Color(0xFF9D4EDD)],
                ).createShader(bounds),
                child: const Text(
                  '✧',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(width: 6),
              // Static text
              ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFD700),
                      Color(0xFFFFFFFF),
                      Color(0xFFFF6B9D),
                    ],
                  ).createShader(bounds);
                },
                child: Text(
                  'KOZMOZ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.5),
                        blurRadius: 8,
                      ),
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
}

// Kozmik Iletisim Butonu - Chatbot, Mistik mor tema
class _KozmikIletisimButton extends StatefulWidget {
  final VoidCallback onTap;

  const _KozmikIletisimButton({required this.onTap});

  @override
  State<_KozmikIletisimButton> createState() => _KozmikIletisimButtonState();
}

class _KozmikIletisimButtonState extends State<_KozmikIletisimButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            final glowIntensity = 0.4 + (_glowController.value * 0.3);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                // Kozmik mor-mavi gradient
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF7B2CBF).withValues(alpha: 0.85),
                    const Color(0xFF5A189A).withValues(alpha: 0.9),
                    const Color(0xFF3C096C).withValues(alpha: 0.95),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(
                    0xFFE0AAFF,
                  ).withValues(alpha: _isHovered ? 0.8 : 0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFF7B2CBF,
                    ).withValues(alpha: glowIntensity),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                  if (_isHovered)
                    BoxShadow(
                      color: const Color(0xFFE0AAFF).withValues(alpha: 0.4),
                      blurRadius: 22,
                      spreadRadius: 3,
                    ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\u{1F4AC}', // Speech bubble emoji
                    style: TextStyle(
                      fontSize: 14,
                      shadows: [
                        Shadow(
                          color: Colors.white.withValues(alpha: 0.5),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Kozmik',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      shadows: [
                        Shadow(
                          color: const Color(0xFFE0AAFF).withValues(alpha: 0.6),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Ruya Dongusu Butonu - 7 Boyutlu Form, Mistik indigo tema
class _RuyaDongusuButton extends StatefulWidget {
  final VoidCallback onTap;

  const _RuyaDongusuButton({required this.onTap});

  @override
  State<_RuyaDongusuButton> createState() => _RuyaDongusuButtonState();
}

class _RuyaDongusuButtonState extends State<_RuyaDongusuButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _rotateController;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _rotateController,
          builder: (context, child) {
            final glowIntensity =
                0.35 + (math.sin(_rotateController.value * math.pi * 2) * 0.25);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                // Mistik indigo-turkuaz gradient
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF4361EE).withValues(alpha: 0.85),
                    const Color(0xFF3A0CA3).withValues(alpha: 0.9),
                    const Color(0xFF240046).withValues(alpha: 0.95),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(
                    0xFF72EFDD,
                  ).withValues(alpha: _isHovered ? 0.8 : 0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFF4361EE,
                    ).withValues(alpha: glowIntensity),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                  if (_isHovered)
                    BoxShadow(
                      color: const Color(0xFF72EFDD).withValues(alpha: 0.4),
                      blurRadius: 22,
                      spreadRadius: 3,
                    ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Rotating moon cycle emoji
                  Transform.rotate(
                    angle: _rotateController.value * math.pi * 2,
                    child: Text(
                      '\u{1F319}', // Crescent moon
                      style: TextStyle(
                        fontSize: 14,
                        shadows: [
                          Shadow(
                            color: Colors.white.withValues(alpha: 0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Dongu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      shadows: [
                        Shadow(
                          color: const Color(0xFF72EFDD).withValues(alpha: 0.6),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Animasyonlu Header Butonu
class _AnimatedHeaderButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AnimatedHeaderButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_AnimatedHeaderButton> createState() => _AnimatedHeaderButtonState();
}

class _AnimatedHeaderButtonState extends State<_AnimatedHeaderButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                // Daha yoğun gradient - daha görünür
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _isHovered
                      ? [
                          widget.color.withAlpha(120),
                          widget.color.withAlpha(80),
                        ]
                      : [
                          widget.color.withAlpha(80),
                          widget.color.withAlpha(50),
                        ],
                ),
                borderRadius: BorderRadius.circular(16),
                // Daha belirgin border
                border: Border.all(
                  color: widget.color.withAlpha(_isHovered ? 220 : 160),
                  width: 2,
                ),
                // Güçlü glow efekti
                boxShadow: [
                  // Ana glow - nabız efektli
                  BoxShadow(
                    color: widget.color.withAlpha(
                      (100 * _pulseAnimation.value).round(),
                    ),
                    blurRadius: 20 * _pulseAnimation.value,
                    spreadRadius: 2 * _pulseAnimation.value,
                  ),
                  // İç glow
                  BoxShadow(
                    color: widget.color.withAlpha(50),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                  if (_isHovered)
                    BoxShadow(
                      color: widget.color.withAlpha(100),
                      blurRadius: 25,
                      spreadRadius: 4,
                    ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Daha büyük ve parlak ikon
                  AnimatedRotation(
                    turns: _isHovered ? 0.05 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: widget.color.withAlpha(40),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(widget.icon, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Daha okunabilir yazı
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      shadows: [
                        Shadow(
                          color: widget.color.withAlpha(150),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
