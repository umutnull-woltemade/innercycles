import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/l10n_service.dart';
import '../../../../data/services/premium_service.dart';
import '../../../streak/presentation/streak_card.dart';
import '../../../gratitude/presentation/gratitude_section.dart';
import '../../../rituals/presentation/ritual_checkoff_card.dart';
import '../../../wellness/presentation/wellness_score_card.dart';
import '../../../sleep/presentation/sleep_section.dart';
import '../../../moon/presentation/moon_phase_widget.dart'; // P1: Moon phase card
import '../../../mood/presentation/mood_checkin_card.dart';
import '../../../streak/presentation/streak_recovery_banner.dart';
import '../../../affirmation/presentation/affirmation_card.dart';
import 'whats_new_card.dart';

/// MOBILE LITE HOMEPAGE - InnerCycles
///
/// App Store 4.3(b) Compliant - Journal & Reflection focused.
/// Journal-focused, safe language.
class MobileLiteHomepage extends ConsumerWidget {
  const MobileLiteHomepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    if (userProfile == null ||
        userProfile.name == null ||
        userProfile.name!.isEmpty) {
      final language = ref.watch(languageProvider);
      return Scaffold(
        backgroundColor: const Color(0xFF0D0D1A),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFFFFD700)),
              const SizedBox(height: 16),
              Text(
                L10nService.get('common.loading', language),
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.deepSpace : AppColors.lightBackground,
      body: SafeArea(
        child: RepaintBoundary(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _AboveTheFold(
                  userName: userProfile.name ?? '',
                  isDark: isDark,
                ),
                _BelowTheFold(isDark: isDark),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ABOVE THE FOLD SECTION
// ═══════════════════════════════════════════════════════════════════════════

class _AboveTheFold extends ConsumerWidget {
  final String userName;
  final bool isDark;

  const _AboveTheFold({
    required this.userName,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;

    // Try ContentEngine for dynamic headline, fallback to static
    final contentAsync = ref.watch(contentEngineServiceProvider);
    final hookAsync = ref.watch(dailyHookServiceProvider);

    final headline = contentAsync.maybeWhen(
      data: (engine) {
        final content = engine.generateDailyContent();
        return content.reflectiveQuestion;
      },
      orElse: () => _getDailyHeadline(language),
    );

    final sentence = hookAsync.maybeWhen(
      data: (hookService) => hookService.getMorningHook(isEnglish: isEn),
      orElse: () => _getDailySentence(language),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF0F2F8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.cosmicPurple
                      : AppColors.lightSurfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons.auto_awesome,
                    size: 24,
                    color: isDark
                        ? AppColors.starGold
                        : AppColors.lightStarGold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      L10nService.getWithParams(
                        'home.greeting',
                        language,
                        params: {'name': userName},
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      language == AppLanguage.en
                          ? 'Personal Reflection Journal'
                          : 'Kisisel Yansima Günlügü',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => context.push(Routes.settings),
                icon: Icon(
                  Icons.settings_outlined,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                  size: 22,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Quick access chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _QuickDiscoveryChip(
                  icon: '📓',
                  label: language == AppLanguage.en ? 'Journal' : 'Günlük',
                  onTap: () => context.push(Routes.journal),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '📊',
                  label: language == AppLanguage.en ? 'Patterns' : 'Kaliplar',
                  onTap: () => context.push(Routes.journalPatterns),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '✨',
                  label: language == AppLanguage.en ? 'Insight' : 'Icgörü',
                  onTap: () => context.push(Routes.insight),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '🌙',
                  label: L10nService.get('home.chips.dream', language),
                  onTap: () => context.push(Routes.dreamInterpretation),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '📅',
                  label: language == AppLanguage.en ? 'Monthly' : 'Aylik',
                  onTap: () => context.push(Routes.journalMonthly),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '📈',
                  label: language == AppLanguage.en ? 'Growth' : 'Büyüme',
                  onTap: () => context.push(Routes.growthDashboard),
                  isDark: isDark,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Reflection headline
          Text(
            headline,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.starGold : AppColors.lightStarGold,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 12),

          // Daily sentence
          Text(
            sentence,
            style: TextStyle(
              fontSize: 15,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          // Primary CTA
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push(Routes.journal),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark
                    ? AppColors.starGold
                    : AppColors.lightStarGold,
                foregroundColor: AppColors.deepSpace,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      language == AppLanguage.en
                          ? 'Start Today\'s Entry'
                          : 'Bugünün Kaydini Baslat',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDailyHeadline(AppLanguage language) {
    final headlines = language == AppLanguage.en
        ? [
            'What patterns are you noticing today?',
            'Take a moment for self-reflection',
            'Your inner wisdom awaits',
            'Discover something new about yourself',
            'Today is a day for growth',
            'Embrace your personal journey',
            'Find clarity in stillness',
          ]
        : [
            'Bugün hangi kaliplari fark ediyorsun?',
            'Kendine yansima için bir an al',
            'Ic bilgeligin seni bekliyor',
            'Kendin hakkinda yeni bir sey kesfet',
            'Bugün büyüme günü',
            'Kisisel yolculugunu kucakla',
            'Sessizlikte netlik bul',
          ];

    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    return headlines[dayOfYear % headlines.length];
  }

  String _getDailySentence(AppLanguage language) {
    final sentences = language == AppLanguage.en
        ? [
            'Every moment of reflection brings you closer to understanding yourself.',
            'Your thoughts and feelings hold valuable insights.',
            'Take time to explore your inner world today.',
            'Self-awareness is the first step to personal growth.',
            'What does your intuition tell you today?',
            'Notice the patterns in your thoughts and emotions.',
            'Your journey of self-discovery continues.',
          ]
        : [
            'Her yansima ani seni kendini anlamaya yaklastirir.',
            'Düsüncelerin ve duyularin degerli icgörüler tasir.',
            'Bugün ic dünyanı kesfetmek için zaman ayir.',
            'Öz farkindalik kisisel büyümenin ilk adimidir.',
            'Sezgilerin bugün sana ne söylüyor?',
            'Düsüncelerindeki ve duygularindaki kaliplari fark et.',
            'Kendini kesfif yolculugun devam ediyor.',
          ];

    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    return sentences[dayOfYear % sentences.length];
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BELOW THE FOLD SECTION
// ═══════════════════════════════════════════════════════════════════════════

class _BelowTheFold extends ConsumerWidget {
  final bool isDark;

  const _BelowTheFold({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ═══ What's New (dismissible) ═══
          const WhatsNewCard(),

          // ═══ P0: Streak Recovery (shows only when streak broken) ═══
          const StreakRecoveryBanner(),

          // ═══ P0: Quick Mood Check-in ═══
          const MoodCheckinCard(),
          const SizedBox(height: 16),

          // ═══ P1: Daily Affirmation ═══
          const AffirmationCard(),
          const SizedBox(height: 16),

          // ═══ P0: Streak Card ═══
          const StreakCard(),
          const SizedBox(height: 16),

          // ═══ P0: Ritual Check-off ═══
          const RitualCheckoffCard(),
          const SizedBox(height: 16),

          // ═══ P0: Gratitude Summary ═══
          const GratitudeSummaryCard(),
          const SizedBox(height: 16),

          // ═══ P1: Wellness Score ═══
          const WellnessScoreCard(),
          const SizedBox(height: 16),

          // ═══ P1: Sleep Summary ═══
          const SleepSummaryCard(),
          const SizedBox(height: 16),

          // ═══ P1: Moon Phase ═══
          const MoonPhaseCard(),
          const SizedBox(height: 16),

          // ═══ P2: Upgrade Trigger Banner (contextual) ═══
          _UpgradeTriggerBanner(isDark: isDark),
          const SizedBox(height: 24),

          // Journal & Patterns
          Text(
            language == AppLanguage.en
                ? 'Journal & Patterns'
                : 'Günlük ve Kaliplar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 16),

          _EntryPointTile(
            icon: Icons.edit_note_outlined,
            title: language == AppLanguage.en
                ? 'Daily Journal'
                : 'Günlük Kayit',
            subtitle: language == AppLanguage.en
                ? 'Track your energy, focus & emotions'
                : 'Enerji, odak ve duygularini takip et',
            route: Routes.journal,
            isDark: isDark,
            isHighlighted: true,
          ),

          _EntryPointTile(
            icon: Icons.insights_outlined,
            title: language == AppLanguage.en
                ? 'Your Patterns'
                : 'Kaliplarin',
            subtitle: language == AppLanguage.en
                ? 'Trends & correlations from your entries'
                : 'Kayitlarindaki egilimler ve baglantilar',
            route: Routes.journalPatterns,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.calendar_month_outlined,
            title: language == AppLanguage.en
                ? 'Monthly Reflection'
                : 'Aylik Yansima',
            subtitle: language == AppLanguage.en
                ? 'Review your month at a glance'
                : 'Ayina bir bakista göz at',
            route: Routes.journalMonthly,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.archive_outlined,
            title: language == AppLanguage.en
                ? 'Archive'
                : 'Arsiv',
            subtitle: language == AppLanguage.en
                ? 'Search & browse all entries'
                : 'Tüm kayitlari ara ve gözat',
            route: Routes.journalArchive,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.waves_outlined,
            title: language == AppLanguage.en
                ? 'Emotional Cycles'
                : 'Duygusal Döngüler',
            subtitle: language == AppLanguage.en
                ? 'Visualize your emotional wave patterns'
                : 'Duygusal dalga kaliplarini görsellestin',
            route: Routes.emotionalCycles,
            isDark: isDark,
          ),

          const SizedBox(height: 24),

          // Growth & Self-Discovery
          Text(
            language == AppLanguage.en
                ? 'Growth & Self-Discovery'
                : 'Büyüme ve Kendini Kesfetme',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 16),

          _EntryPointTile(
            icon: Icons.dashboard_outlined,
            title: language == AppLanguage.en
                ? 'Growth Dashboard'
                : 'Büyüme Paneli',
            subtitle: language == AppLanguage.en
                ? 'Your wellness score, streaks & milestones'
                : 'Saglik skorun, serilerin ve kilometre taslarin',
            route: Routes.growthDashboard,
            isDark: isDark,
            isHighlighted: true,
          ),

          _EntryPointTile(
            icon: Icons.psychology_outlined,
            title: language == AppLanguage.en
                ? 'Attachment Style Quiz'
                : 'Baglanma Stili Testi',
            subtitle: language == AppLanguage.en
                ? 'Discover your relationship patterns'
                : 'Iliski kaliplarini kesfet',
            route: Routes.attachmentQuiz,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.share_outlined,
            title: language == AppLanguage.en
                ? 'Share Insights'
                : 'Icgörüleri Paylas',
            subtitle: language == AppLanguage.en
                ? 'Beautiful cards for your journey moments'
                : 'Yolculuk anlarinin güzel kartlari',
            route: Routes.shareInsight,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.grid_view_rounded,
            title: language == AppLanguage.en
                ? 'Energy Map'
                : 'Enerji Haritasi',
            subtitle: language == AppLanguage.en
                ? 'Heatmap of your energy by day & area'
                : 'Gün ve alana göre enerji isi haritasi',
            route: Routes.energyMap,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.auto_stories_outlined,
            title: language == AppLanguage.en
                ? 'Guided Programs'
                : 'Rehberli Programlar',
            subtitle: language == AppLanguage.en
                ? 'Structured journeys for self-discovery'
                : 'Kendini kesfetme icin yapilandirilmis yolculuklar',
            route: Routes.programs,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.emoji_events_outlined,
            title: language == AppLanguage.en
                ? 'Growth Challenges'
                : 'Büyüme Görevleri',
            subtitle: language == AppLanguage.en
                ? 'Gamified challenges to build habits'
                : 'Aliskanlık olusturmak icin oyunlastirilmis görevler',
            route: Routes.challenges,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.eco_outlined,
            title: language == AppLanguage.en
                ? 'Seasonal Reflections'
                : 'Mevsimsel Yansimalar',
            subtitle: language == AppLanguage.en
                ? 'Guided prompts for each season'
                : 'Her mevsim icin rehberli sorular',
            route: Routes.seasonal,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.theater_comedy_outlined,
            title: language == AppLanguage.en
                ? 'Your Archetype'
                : 'Arketip Profilin',
            subtitle: language == AppLanguage.en
                ? 'Discover your inner archetype from your patterns'
                : 'Kaliplarından iç arketipini keşfet',
            route: Routes.archetype,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.people_outline,
            title: language == AppLanguage.en
                ? 'Relationship Reflections'
                : 'İlişki Yansımaları',
            subtitle: language == AppLanguage.en
                ? 'Reflect on your connections with others'
                : 'Başkalarıyla bağlantılarını yansıt',
            route: Routes.compatibilityReflection,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.visibility_outlined,
            title: language == AppLanguage.en
                ? 'Blind Spot Reveal'
                : 'Kör Nokta Keşfi',
            subtitle: language == AppLanguage.en
                ? 'Patterns you might not notice about yourself'
                : 'Kendin hakkında fark etmeyebileceğin kalıplar',
            route: Routes.blindSpot,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.summarize_outlined,
            title: language == AppLanguage.en
                ? 'Weekly Digest'
                : 'Haftalık Özet',
            subtitle: language == AppLanguage.en
                ? 'Your week summarized with insights'
                : 'İçgörülerle haftalık özetin',
            route: Routes.weeklyDigest,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.lightbulb_outline,
            title: language == AppLanguage.en
                ? 'Journal Prompts'
                : 'Günlük Soruları',
            subtitle: language == AppLanguage.en
                ? '80+ prompts to spark self-reflection'
                : '80+ öz-yansıma sorusu',
            route: Routes.promptLibrary,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.emoji_events_outlined,
            title: language == AppLanguage.en
                ? 'Milestones & Badges'
                : 'Kilometre Taşları',
            subtitle: language == AppLanguage.en
                ? 'Track your achievements & unlock badges'
                : 'Başarılarını takip et ve rozetleri aç',
            route: Routes.milestones,
            isDark: isDark,
          ),

          const SizedBox(height: 24),

          // Wellness & Mindfulness
          Text(
            language == AppLanguage.en
                ? 'Wellness & Mindfulness'
                : 'Saglik ve Farkindalik',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 16),

          _EntryPointTile(
            icon: Icons.air_outlined,
            title: language == AppLanguage.en
                ? 'Breathing Exercises'
                : 'Nefes Egzersizleri',
            subtitle: language == AppLanguage.en
                ? 'Guided breathing for calm & focus'
                : 'Sakinlik ve odak icin rehberli nefes',
            route: Routes.breathing,
            isDark: isDark,
            isHighlighted: true,
          ),

          _EntryPointTile(
            icon: Icons.dark_mode_outlined,
            title: language == AppLanguage.en
                ? 'Moon Calendar'
                : 'Ay Takvimi',
            subtitle: language == AppLanguage.en
                ? 'Lunar phases & reflection prompts'
                : 'Ay evreleri ve yansima sorulari',
            route: Routes.moonCalendar,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.self_improvement_outlined,
            title: language == AppLanguage.en
                ? 'Meditation Timer'
                : 'Meditasyon Zamanlayıcı',
            subtitle: language == AppLanguage.en
                ? 'Timed sessions for mindfulness'
                : 'Farkındalık için zamanlı oturumlar',
            route: Routes.meditation,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.bedtime_outlined,
            title: language == AppLanguage.en
                ? 'Sleep Quality'
                : 'Uyku Kalitesi',
            subtitle: language == AppLanguage.en
                ? 'Track and improve your sleep patterns'
                : 'Uyku kalıplarınızı takip edin ve iyileştirin',
            route: Routes.sleepDetail,
            isDark: isDark,
          ),

          const SizedBox(height: 24),

          // Insight & Reflection
          Text(
            language == AppLanguage.en
                ? 'Insight & Reflection'
                : 'Icgörü ve Yansima',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 16),

          _EntryPointTile(
            icon: Icons.auto_awesome_outlined,
            title: language == AppLanguage.en
                ? 'Personal Insight'
                : 'Kisisel Icgörü',
            subtitle: language == AppLanguage.en
                ? 'AI-powered self-reflection assistant'
                : 'Yapay zeka destekli öz-yansima asistani',
            route: Routes.insight,
            isDark: isDark,
            isHighlighted: true,
          ),

          const SizedBox(height: 24),

          // Dream Journal
          Text(
            language == AppLanguage.en
                ? 'Dream Journal'
                : 'Rüya Günlügü',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 16),

          _EntryPointTile(
            icon: Icons.nights_stay_outlined,
            title: language == AppLanguage.en
                ? 'Dream Interpretation'
                : 'Rüya Yorumu',
            subtitle: language == AppLanguage.en
                ? 'Explore your dream symbols'
                : 'Rüya sembollerini kesfet',
            route: Routes.dreamInterpretation,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.book_outlined,
            title: language == AppLanguage.en
                ? 'Dream Dictionary'
                : 'Rüya Sözlügü',
            subtitle: language == AppLanguage.en
                ? 'Symbol reference guide'
                : 'Sembol referans rehberi',
            route: Routes.dreamGlossary,
            isDark: isDark,
          ),

          const SizedBox(height: 24),

          // Reference
          Text(
            language == AppLanguage.en
                ? 'Reference'
                : 'Referans',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 16),

          _EntryPointTile(
            icon: Icons.menu_book_outlined,
            title: language == AppLanguage.en
                ? 'Glossary'
                : 'Sözlük',
            subtitle: language == AppLanguage.en
                ? 'Terms & definitions'
                : 'Terimler ve tanimlar',
            route: Routes.glossary,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.article_outlined,
            title: language == AppLanguage.en
                ? 'Articles'
                : 'Makaleler',
            subtitle: language == AppLanguage.en
                ? 'Wellness & self-growth articles'
                : 'Saglik ve kisisel gelisim makaleleri',
            route: Routes.articles,
            isDark: isDark,
          ),

          const SizedBox(height: 24),

          // Your Data
          Text(
            language == AppLanguage.en
                ? 'Your Data'
                : 'Verileriniz',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 16),

          _EntryPointTile(
            icon: Icons.favorite_outline,
            title: language == AppLanguage.en
                ? 'Gratitude Journal'
                : 'Şükran Günlüğü',
            subtitle: language == AppLanguage.en
                ? 'Daily gratitude entries & themes'
                : 'Günlük şükran girdileri ve temalar',
            route: Routes.gratitudeJournal,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.file_download_outlined,
            title: language == AppLanguage.en
                ? 'Export Data'
                : 'Verileri Dışa Aktar',
            subtitle: language == AppLanguage.en
                ? 'Download your journal as text, CSV, or JSON'
                : 'Günlüğünüzü metin, CSV veya JSON olarak indirin',
            route: Routes.exportData,
            isDark: isDark,
          ),

          const SizedBox(height: 32),

          // Footer branding
          Center(
            child: GestureDetector(
              onTap: () => context.push(Routes.settings),
              child: Text(
                'InnerCycles',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.textMuted.withValues(alpha: 0.7)
                      : AppColors.lightTextMuted.withValues(alpha: 0.7),
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// QUICK DISCOVERY CHIP
// ═══════════════════════════════════════════════════════════════════════════

class _QuickDiscoveryChip extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _QuickDiscoveryChip({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.cosmicPurple.withValues(alpha: 0.3)
                : AppColors.lightSurfaceVariant,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? AppColors.starGold.withValues(alpha: 0.3)
                  : AppColors.lightStarGold.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(icon, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ENTRY POINT TILE
// ═══════════════════════════════════════════════════════════════════════════

class _EntryPointTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final bool isDark;
  final bool isHighlighted;

  const _EntryPointTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.isDark,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push(route),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isHighlighted
                  ? (isDark
                        ? AppColors.starGold.withValues(alpha: 0.1)
                        : AppColors.lightStarGold.withValues(alpha: 0.1))
                  : (isDark ? AppColors.surfaceDark : AppColors.lightCard),
              borderRadius: BorderRadius.circular(12),
              border: isHighlighted
                  ? Border.all(
                      color: isDark
                          ? AppColors.starGold.withValues(alpha: 0.3)
                          : AppColors.lightStarGold.withValues(alpha: 0.3),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.cosmicPurple
                        : AppColors.lightSurfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: isHighlighted
                        ? (isDark
                              ? AppColors.starGold
                              : AppColors.lightStarGold)
                        : (isDark
                              ? AppColors.auroraStart
                              : AppColors.lightAuroraStart),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// UPGRADE TRIGGER BANNER
// ═══════════════════════════════════════════════════════════════════════════

class _UpgradeTriggerBanner extends ConsumerWidget {
  final bool isDark;

  const _UpgradeTriggerBanner({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(premiumProvider).isPremium;
    if (isPremium) return const SizedBox.shrink();

    final upgradeAsync = ref.watch(upgradeTriggerServiceProvider);
    final journalAsync = ref.watch(journalServiceProvider);
    final streakAsync = ref.watch(streakStatsProvider);
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;

    return upgradeAsync.maybeWhen(
      data: (upgradeService) {
        final entryCount = journalAsync.valueOrNull?.entryCount ?? 0;
        final streak = streakAsync.valueOrNull?.currentStreak ?? 0;

        final trigger = upgradeService.checkTriggers(
          entryCount: entryCount,
          dreamCount: 0,
          streak: streak,
          shareCount: 0,
          profileCount: 1,
          hasCompletedQuiz: false,
          adExposures: 0,
        );

        if (trigger == null) return const SizedBox.shrink();

        final prompt = upgradeService.getPromptForTrigger(trigger);

        return GestureDetector(
          onTap: () {
            upgradeService.markTriggerShown(trigger);
            context.push(Routes.premium);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.starGold.withValues(alpha: isDark ? 0.15 : 0.1),
                  AppColors.auroraStart.withValues(alpha: isDark ? 0.1 : 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.starGold.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(prompt.icon, size: 28, color: AppColors.starGold),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEn ? prompt.headlineEn : prompt.headlineTr,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isEn ? prompt.ctaEn : prompt.ctaTr,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.starGold,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: AppColors.starGold.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
