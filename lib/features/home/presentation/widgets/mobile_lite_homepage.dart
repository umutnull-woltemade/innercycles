import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/l10n_service.dart';
import '../../../../data/services/premium_service.dart';
import '../../../../data/services/upgrade_trigger_service.dart';
import '../../../streak/presentation/streak_card.dart';
import '../../../gratitude/presentation/gratitude_section.dart';
import '../../../rituals/presentation/ritual_checkoff_card.dart';
import '../../../wellness/presentation/wellness_score_card.dart';
import '../../../sleep/presentation/sleep_section.dart';
import '../../../moon/presentation/moon_phase_widget.dart'; // P1: Moon phase card
import '../../../mood/presentation/mood_checkin_card.dart';
import '../../../streak/presentation/streak_recovery_banner.dart';
import '../../../affirmation/presentation/affirmation_card.dart';
import '../../../insight/presentation/context_module_card.dart';
import '../../../mood/presentation/emotion_of_day_card.dart';
import '../../../habits/presentation/habit_suggestion_card.dart';
import '../../../monthly_themes/presentation/monthly_theme_card.dart';
import '../../../digest/presentation/weekly_digest_card.dart';
import '../../../prompts/presentation/today_prompt_card.dart';
import '../../../referral/presentation/referral_progress_card.dart';
import '../../../cosmic/presentation/cosmic_message_card.dart';
import '../../../quiz/presentation/quiz_suggestion_card.dart';
import '../../../premium/presentation/contextual_paywall_modal.dart';
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
                ).glassReveal(context: context),
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
    final hour = DateTime.now().hour;

    String? contentSubtitle;
    final headline = contentAsync.maybeWhen(
      data: (engine) {
        final content = engine.generateDailyContent();
        // Surface archetype + growth direction as subtitle
        if (content.archetype.isNotEmpty && content.growthDirection.isNotEmpty) {
          contentSubtitle = '${content.archetype} · ${content.growthDirection}';
        }
        return content.reflectiveQuestion;
      },
      orElse: () => _getDailyHeadline(language),
    );

    // Time-aware hook: morning before noon, evening after 6pm
    final sentence = hookAsync.maybeWhen(
      data: (hookService) => hour >= 18
          ? hookService.getEveningHook(isEnglish: isEn)
          : hookService.getMorningHook(isEnglish: isEn),
      orElse: () => _getDailySentence(language),
    );

    return GlassPanel(
      elevation: GlassElevation.g3,
      borderRadius: BorderRadius.zero,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      glowColor: AppColors.starGold.withValues(alpha: 0.2),
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
                          ? 'Emotional Cycle Intelligence'
                          : 'Duygusal Döngü Zekası',
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
              Semantics(
                label: isEn ? 'Settings' : 'Ayarlar',
                button: true,
                child: IconButton(
                  onPressed: () => context.push(Routes.settings),
                  icon: Icon(
                    Icons.settings_outlined,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Quick access chips — 5 core actions
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
                  icon: '🌙',
                  label: L10nService.get('home.chips.dream', language),
                  onTap: () => context.push(Routes.dreamInterpretation),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '📊',
                  label: language == AppLanguage.en ? 'Patterns' : 'Kalıplar',
                  onTap: () => context.push(Routes.journalPatterns),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '📈',
                  label: language == AppLanguage.en ? 'Growth' : 'Büyüme',
                  onTap: () => context.push(Routes.growthDashboard),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '✨',
                  label: language == AppLanguage.en ? 'Insight' : 'İçgörü',
                  onTap: () => context.push(Routes.insight),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '📅',
                  label: language == AppLanguage.en ? 'Calendar' : 'Takvim',
                  onTap: () => context.push(Routes.calendarHeatmap),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '🔍',
                  label: language == AppLanguage.en ? 'Search' : 'Ara',
                  onTap: () => context.push(Routes.search),
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

          // Content engine context subtitle
          if (contentSubtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              contentSubtitle!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
                letterSpacing: 0.3,
              ),
            ),
          ],

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
                          ? 'Map Today\'s Cycle Position'
                          : 'Bugünün Döngü Pozisyonunu Haritalandır',
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
            'Which emotional cycle are you in right now?',
            'A recurring pattern may be active today',
            'Your cycle position has shifted since last week',
            'Check if today matches a previous cycle entry',
            'New recurrence detected in your recent entries',
            'Your archetype is showing a progression signal',
            'Map this moment against your cycle history',
          ]
        : [
            'Şu an hangi duygusal döngüdesin?',
            'Bugün tekrarlayan bir örüntü aktif olabilir',
            'Döngü pozisyonun geçen haftadan beri değişti',
            'Bugünün önceki bir döngü kaydıyla eşleşip eşleşmediğini kontrol et',
            'Son kayıtlarında yeni bir tekrar tespit edildi',
            'Arketipin bir ilerleme sinyali gösteriyor',
            'Bu anı döngü geçmişinle haritalandır',
          ];

    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    return headlines[dayOfYear % headlines.length];
  }

  String _getDailySentence(AppLanguage language) {
    final sentences = language == AppLanguage.en
        ? [
            'Your cycle engine is analyzing patterns across your recent entries.',
            'Recurring emotional signatures become visible after 7 entries.',
            'The recurrence detection engine maps what repeats and when.',
            'Cycle awareness turns invisible patterns into visible structure.',
            'Your dream archaeology data is building symbol frequency maps.',
            'Each entry strengthens the cycle position accuracy for your profile.',
            'Shadow-light integration tracking requires consistent entries.',
          ]
        : [
            'Döngü motorun son kayıtlarındaki örüntüleri analiz ediyor.',
            'Tekrarlayan duygusal imzalar 7 kayıttan sonra görünür hale gelir.',
            'Tekrar tespit motoru neyin ne zaman tekrarladığını haritalandırır.',
            'Döngü farkındalığı görünmez örüntüleri görünür yapıya dönüştürür.',
            'Rüya arkeolojisi verilerin sembol frekans haritaları oluşturuyor.',
            'Her kayıt profilin için döngü pozisyon doğruluğunu güçlendirir.',
            'Gölge-ışık entegrasyonu takibi tutarlı kayıtlar gerektirir.',
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

          // ═══ P0: Referral Progress (non-premium only) ═══
          const ReferralProgressCard(),
          const SizedBox(height: 16),

          // ═══ P1: Daily Affirmation ═══
          const AffirmationCard(),
          const SizedBox(height: 16),

          // ═══ P1: Daily Cosmic Intention ═══
          const CosmicMessageCard(),
          const SizedBox(height: 16),

          // ═══ P1: Daily Insight Module ═══
          const ContextModuleCard(),
          const SizedBox(height: 16),

          // ═══ P1: Emotion of the Day ═══
          const EmotionOfDayCard(),
          const SizedBox(height: 16),

          // ═══ P1: Daily Habit Suggestion ═══
          const HabitSuggestionCard(),
          const SizedBox(height: 16),

          // ═══ P1: Monthly Theme ═══
          const MonthlyThemeCard(),
          const SizedBox(height: 16),

          // ═══ P1: Today's Prompt ═══
          const TodayPromptCard(),
          const SizedBox(height: 16),

          // ═══ P1: Suggested Quiz ═══
          const QuizSuggestionCard(),
          const SizedBox(height: 16),

          // ═══ P1: Weekly Digest ═══
          const WeeklyDigestCard(),
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

          // ═══ JOURNAL & PATTERNS ═══
          Text(
            language == AppLanguage.en
                ? 'Journal & Patterns'
                : 'Günlük ve Kalıplar',
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
                ? 'Cycle Entry'
                : 'Döngü Kaydı',
            subtitle: language == AppLanguage.en
                ? 'Map your cycle position, energy & emotional state'
                : 'Döngü pozisyonunu, enerji ve duygusal durumunu haritalandır',
            route: Routes.journal,
            isDark: isDark,
            isHighlighted: true,
            index: 0,
          ),

          _EntryPointTile(
            icon: Icons.insights_outlined,
            title: language == AppLanguage.en
                ? 'Recurrence Detection'
                : 'Tekrar Tespiti',
            subtitle: language == AppLanguage.en
                ? 'Recurring cycles & pattern correlations'
                : 'Tekrarlayan döngüler ve örüntü korelasyonları',
            route: Routes.journalPatterns,
            isDark: isDark,
            index: 1,
          ),

          _EntryPointTile(
            icon: Icons.waves_outlined,
            title: language == AppLanguage.en
                ? 'Emotional Cycles'
                : 'Duygusal Döngüler',
            subtitle: language == AppLanguage.en
                ? 'Visualize your emotional cycle rhythms over time'
                : 'Duygusal döngü ritimlerini zaman içinde görselleştir',
            route: Routes.emotionalCycles,
            isDark: isDark,
            index: 2,
          ),

          _EntryPointTile(
            icon: Icons.calendar_month_outlined,
            title: language == AppLanguage.en
                ? 'Monthly Cycle Report'
                : 'Aylık Döngü Raporu',
            subtitle: language == AppLanguage.en
                ? 'Cycle position summary and pattern recurrences'
                : 'Döngü pozisyon özeti ve örüntü tekrarları',
            route: Routes.journalMonthly,
            isDark: isDark,
            index: 3,
          ),

          _EntryPointTile(
            icon: Icons.favorite_border_outlined,
            title: language == AppLanguage.en
                ? 'Gratitude Journal'
                : 'Şükran Günlüğü',
            subtitle: language == AppLanguage.en
                ? 'Capture what you\'re thankful for'
                : 'Minnettar olduğun şeyleri kaydet',
            route: Routes.gratitudeJournal,
            isDark: isDark,
            index: 4,
          ),

          _EntryPointTile(
            icon: Icons.lightbulb_outline,
            title: language == AppLanguage.en
                ? 'Prompt Library'
                : 'Soru Kütüphanesi',
            subtitle: language == AppLanguage.en
                ? 'Cycle-aware prompts for pattern exploration'
                : 'Örüntü keşfi için döngü odaklı sorular',
            route: Routes.promptLibrary,
            isDark: isDark,
            index: 5,
          ),

          const SizedBox(height: 24),

          // ═══ DREAM JOURNAL ═══
          Text(
            language == AppLanguage.en
                ? 'Dream Archaeology'
                : 'Rüya Arkeolojisi',
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
                ? 'Dream Archaeology'
                : 'Rüya Arkeolojisi',
            subtitle: language == AppLanguage.en
                ? 'Map recurring symbols, arcs & archetype patterns'
                : 'Tekrarlayan sembolleri, hikaye yaylarını ve arketip örüntülerini haritalandır',
            route: Routes.dreamInterpretation,
            isDark: isDark,
            isHighlighted: true,
            index: 0,
          ),

          _EntryPointTile(
            icon: Icons.book_outlined,
            title: language == AppLanguage.en
                ? 'Dream Dictionary'
                : 'Rüya Sözlüğü',
            subtitle: language == AppLanguage.en
                ? '1000+ symbols with meanings'
                : '1000+ sembol ve anlamı',
            route: Routes.dreamGlossary,
            isDark: isDark,
            index: 1,
          ),

          const SizedBox(height: 24),

          // ═══ GROWTH & SELF-DISCOVERY ═══
          Text(
            language == AppLanguage.en
                ? 'Archetype & Pattern Tools'
                : 'Arketip ve Örüntü Araçları',
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
                ? 'Cycle Dashboard'
                : 'Döngü Paneli',
            subtitle: language == AppLanguage.en
                ? 'Cycle position, streaks & pattern milestones'
                : 'Döngü pozisyonu, seriler ve örüntü kilometre taşları',
            route: Routes.growthDashboard,
            isDark: isDark,
            isHighlighted: true,
            index: 0,
          ),

          _EntryPointTile(
            icon: Icons.psychology_outlined,
            title: language == AppLanguage.en
                ? 'Attachment Style Quiz'
                : 'Bağlanma Stili Testi',
            subtitle: language == AppLanguage.en
                ? 'Detect recurring relationship cycles'
                : 'Tekrarlayan ilişki döngülerini tespit et',
            route: Routes.attachmentQuiz,
            isDark: isDark,
            index: 1,
          ),

          _EntryPointTile(
            icon: Icons.auto_awesome_outlined,
            title: language == AppLanguage.en
                ? 'Cyclical Insight'
                : 'Döngüsel İçgörü',
            subtitle: language == AppLanguage.en
                ? 'Pattern-aware reflection engine'
                : 'Örüntü farkındalıklı yansıma motoru',
            route: Routes.insight,
            isDark: isDark,
            index: 2,
          ),

          _EntryPointTile(
            icon: Icons.psychology_alt_outlined,
            title: language == AppLanguage.en
                ? 'Cycle Insights'
                : 'Döngü İçgörüleri',
            subtitle: language == AppLanguage.en
                ? '36 modules on emotional cycle literacy'
                : '36 duygusal döngü okuryazarlığı modülü',
            route: Routes.insightsDiscovery,
            isDark: isDark,
            index: 3,
          ),

          _EntryPointTile(
            icon: Icons.quiz_outlined,
            title: language == AppLanguage.en
                ? 'Quiz Hub'
                : 'Test Merkezi',
            subtitle: language == AppLanguage.en
                ? 'All pattern-detection quizzes in one place'
                : 'Tüm örüntü tespit testleri tek yerde',
            route: Routes.quizHub,
            isDark: isDark,
            index: 4,
          ),

          _EntryPointTile(
            icon: Icons.school_outlined,
            title: language == AppLanguage.en
                ? 'Guided Programs'
                : 'Rehberli Programlar',
            subtitle: language == AppLanguage.en
                ? 'Structured cycle-awareness journeys'
                : 'Yapılandırılmış döngü farkındalığı yolculukları',
            route: Routes.programs,
            isDark: isDark,
            index: 5,
          ),

          _EntryPointTile(
            icon: Icons.emoji_events_outlined,
            title: language == AppLanguage.en
                ? 'Challenges'
                : 'Meydan Okumalar',
            subtitle: language == AppLanguage.en
                ? 'Break recurring cycles with guided challenges'
                : 'Rehberli meydan okumalarla tekrarlayan döngüleri kır',
            route: Routes.challenges,
            isDark: isDark,
            index: 6,
          ),

          _EntryPointTile(
            icon: Icons.share_outlined,
            title: language == AppLanguage.en
                ? 'Share Cards'
                : 'Paylaşım Kartları',
            subtitle: language == AppLanguage.en
                ? 'Create & share cyclical intelligence cards'
                : 'Döngüsel zeka kartları oluştur ve paylaş',
            route: Routes.shareCardGallery,
            isDark: isDark,
            index: 7,
          ),

          _EntryPointTile(
            icon: Icons.fingerprint_outlined,
            title: language == AppLanguage.en
                ? 'Your Archetype'
                : 'Arketipiniz',
            subtitle: language == AppLanguage.en
                ? 'Track your archetype progression across 12 frameworks'
                : '12 çerçevede arketip ilerlemeni takip et',
            route: Routes.archetype,
            isDark: isDark,
            index: 8,
          ),

          _EntryPointTile(
            icon: Icons.visibility_off_outlined,
            title: language == AppLanguage.en
                ? 'Blind Spot Mirror'
                : 'Kör Nokta Aynası',
            subtitle: language == AppLanguage.en
                ? 'Detect blind-spot cycles in your behavior'
                : 'Davranışlarındaki kör nokta döngülerini tespit et',
            route: Routes.blindSpot,
            isDark: isDark,
            index: 9,
          ),

          _EntryPointTile(
            icon: Icons.people_outline_rounded,
            title: language == AppLanguage.en
                ? 'Compatibility Reflection'
                : 'Uyumluluk Yansıması',
            subtitle: language == AppLanguage.en
                ? 'Map recurring dynamics in your relationships'
                : 'İlişkilerindeki tekrarlayan dinamikleri haritalandır',
            route: Routes.compatibilityReflection,
            isDark: isDark,
            index: 10,
          ),

          _EntryPointTile(
            icon: Icons.military_tech_outlined,
            title: language == AppLanguage.en
                ? 'Milestones & Badges'
                : 'Kilometre Taşları ve Rozetler',
            subtitle: language == AppLanguage.en
                ? 'Cycle milestones & pattern-breaking badges'
                : 'Döngü kilometre taşları ve örüntü kırma rozetleri',
            route: Routes.milestones,
            isDark: isDark,
            index: 11,
          ),

          const SizedBox(height: 24),

          // ═══ WELLNESS ═══
          Text(
            language == AppLanguage.en
                ? 'Cycle Support & Rituals'
                : 'Döngü Desteği ve Ritüeller',
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
                ? 'Regulate cycle-linked stress with guided breathing'
                : 'Döngü bağlantılı stresi rehberli nefesle düzenle',
            route: Routes.breathing,
            isDark: isDark,
            index: 0,
          ),

          _EntryPointTile(
            icon: Icons.self_improvement_outlined,
            title: language == AppLanguage.en
                ? 'Meditation Timer'
                : 'Meditasyon Zamanlayıcı',
            subtitle: language == AppLanguage.en
                ? 'Timed sessions for cycle awareness'
                : 'Döngü farkındalığı için zamanlı oturumlar',
            route: Routes.meditation,
            isDark: isDark,
            index: 1,
          ),

          _EntryPointTile(
            icon: Icons.spa_outlined,
            title: language == AppLanguage.en
                ? 'Rituals & Habits'
                : 'Ritüeller ve Alışkanlıklar',
            subtitle: language == AppLanguage.en
                ? 'Build cycle-anchored daily rituals'
                : 'Döngü odaklı günlük ritüeller oluştur',
            route: Routes.rituals,
            isDark: isDark,
            index: 2,
          ),

          _EntryPointTile(
            icon: Icons.lightbulb_outline_rounded,
            title: language == AppLanguage.en
                ? 'Micro-Habits'
                : 'Mikro Alışkanlıklar',
            subtitle: language == AppLanguage.en
                ? '56 cycle-aware micro-habits to try'
                : '56 döngü farkındalıklı mikro alışkanlık',
            route: Routes.habitSuggestions,
            isDark: isDark,
            index: 3,
          ),

          _EntryPointTile(
            icon: Icons.checklist_rounded,
            title: language == AppLanguage.en
                ? 'Daily Habit Tracker'
                : 'Günlük Alışkanlık Takibi',
            subtitle: language == AppLanguage.en
                ? 'Check off your adopted habits daily'
                : 'Benimsediğin alışkanlıkları günlük takip et',
            route: Routes.dailyHabits,
            isDark: isDark,
            index: 4,
          ),

          _EntryPointTile(
            icon: Icons.park_outlined,
            title: language == AppLanguage.en
                ? 'Seasonal Reflection'
                : 'Mevsimsel Yansıma',
            subtitle: language == AppLanguage.en
                ? 'Map your cycles against seasonal rhythms'
                : 'Döngülerini mevsimsel ritimlerle haritalandır',
            route: Routes.seasonal,
            isDark: isDark,
            index: 4,
          ),

          _EntryPointTile(
            icon: Icons.dark_mode_outlined,
            title: language == AppLanguage.en
                ? 'Moon Calendar'
                : 'Ay Takvimi',
            subtitle: language == AppLanguage.en
                ? 'Correlate moon phases with your emotional cycles'
                : 'Ay evrelerini duygusal döngülerinle ilişkilendir',
            route: Routes.moonCalendar,
            isDark: isDark,
            index: 5,
          ),

          _EntryPointTile(
            icon: Icons.bedtime_outlined,
            title: language == AppLanguage.en
                ? 'Sleep Tracker'
                : 'Uyku Takibi',
            subtitle: language == AppLanguage.en
                ? 'Detect sleep-cycle correlations with mood'
                : 'Uyku döngüsü ve ruh hali korelasyonlarını tespit et',
            route: Routes.sleepDetail,
            isDark: isDark,
            index: 6,
          ),

          _EntryPointTile(
            icon: Icons.bolt_outlined,
            title: language == AppLanguage.en
                ? 'Energy Map'
                : 'Enerji Haritası',
            subtitle: language == AppLanguage.en
                ? 'Visualize energy cycles and recurring shifts'
                : 'Enerji döngülerini ve tekrarlayan değişimleri görselleştir',
            route: Routes.energyMap,
            isDark: isDark,
            index: 7,
          ),

          const SizedBox(height: 24),

          // ═══ YOUR DATA ═══
          Text(
            language == AppLanguage.en
                ? 'Your Cycle Data'
                : 'Döngü Verileriniz',
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
            icon: Icons.calendar_view_month_outlined,
            title: language == AppLanguage.en
                ? 'Activity Calendar'
                : 'Aktivite Takvimi',
            subtitle: language == AppLanguage.en
                ? 'Visual heatmap of your journaling activity'
                : 'Günlük yazma aktivitenizin görsel ısı haritası',
            route: Routes.calendarHeatmap,
            isDark: isDark,
            index: 0,
          ),

          _EntryPointTile(
            icon: Icons.search_rounded,
            title: language == AppLanguage.en
                ? 'Search Everything'
                : 'Her Şeyi Ara',
            subtitle: language == AppLanguage.en
                ? 'Find entries across journals, dreams & gratitude'
                : 'Günlük, rüya ve minnettarlık kayıtlarında ara',
            route: Routes.search,
            isDark: isDark,
            index: 1,
          ),

          _EntryPointTile(
            icon: Icons.archive_outlined,
            title: language == AppLanguage.en
                ? 'Journal Archive'
                : 'Günlük Arşivi',
            subtitle: language == AppLanguage.en
                ? 'Search & browse all cycle entries'
                : 'Tüm döngü kayıtlarını ara ve gözat',
            route: Routes.journalArchive,
            isDark: isDark,
            index: 2,
          ),

          _EntryPointTile(
            icon: Icons.file_download_outlined,
            title: language == AppLanguage.en
                ? 'Export Data'
                : 'Verileri Dışa Aktar',
            subtitle: language == AppLanguage.en
                ? 'Export your cycle data as text, CSV, or JSON'
                : 'Döngü verilerinizi metin, CSV veya JSON olarak indirin',
            route: Routes.exportData,
            isDark: isDark,
            index: 3,
          ),

          _EntryPointTile(
            icon: Icons.auto_stories_outlined,
            title: language == AppLanguage.en
                ? 'Year in Review'
                : 'Yıllık Özet',
            subtitle: language == AppLanguage.en
                ? 'Your full-year cycle progression arc'
                : 'Yıllık döngü ilerleme arkın',
            route: Routes.yearReview,
            isDark: isDark,
            index: 4,
          ),

          _EntryPointTile(
            icon: Icons.summarize_outlined,
            title: language == AppLanguage.en
                ? 'Weekly Digest'
                : 'Haftalık Özet',
            subtitle: language == AppLanguage.en
                ? 'This week\'s cycle position & recurrences'
                : 'Bu haftanın döngü pozisyonu ve tekrarları',
            route: Routes.weeklyDigest,
            isDark: isDark,
            index: 5,
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
    return Semantics(
      label: label,
      button: true,
      child: Material(
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
                ExcludeSemantics(
                  child: Text(icon, style: const TextStyle(fontSize: 16)),
                ),
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
  final int index;

  const _EntryPointTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.isDark,
    this.isHighlighted = false,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final tile = Semantics(
      label: '$title. $subtitle',
      button: true,
      child: Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push(route),
          borderRadius: BorderRadius.circular(12),
          child: GlassPanel(
            elevation: isHighlighted ? GlassElevation.g3 : GlassElevation.g2,
            borderRadius: BorderRadius.circular(12),
            padding: const EdgeInsets.all(16),
            glowColor: isHighlighted
                ? AppColors.starGold.withValues(alpha: 0.2)
                : null,
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
                ExcludeSemantics(
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
    return tile.glassListItem(context: context, index: index);
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
            showContextualPaywall(
              context,
              ref,
              paywallContext: _mapTriggerToPaywallContext(trigger),
              entryCount: entryCount,
              streakDays: streak,
            );
          },
          child: GlassPanel(
            elevation: GlassElevation.g3,
            borderRadius: BorderRadius.circular(16),
            padding: const EdgeInsets.all(16),
            glowColor: AppColors.starGold.withValues(alpha: 0.2),
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
        ).glassReveal(context: context);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  /// Map upgrade triggers to contextual paywall types
  PaywallContext _mapTriggerToPaywallContext(UpgradeTrigger trigger) {
    switch (trigger) {
      case UpgradeTrigger.insightsReady:
      case UpgradeTrigger.patternShift:
        return PaywallContext.patterns;
      case UpgradeTrigger.dreamPatterns:
        return PaywallContext.dreams;
      case UpgradeTrigger.streakMilestone:
        return PaywallContext.streakFreeze;
      case UpgradeTrigger.monthlyReport:
        return PaywallContext.monthlyReport;
      case UpgradeTrigger.unlimitedSharing:
      case UpgradeTrigger.comparePatterns:
        return PaywallContext.general;
      case UpgradeTrigger.attachmentDeep:
        return PaywallContext.general;
      case UpgradeTrigger.seasonalReset:
        return PaywallContext.programs;
      case UpgradeTrigger.removeAds:
        return PaywallContext.adRemoval;
    }
  }
}
