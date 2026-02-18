import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/cosmic_background.dart';
import '../../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../../shared/widgets/page_bottom_navigation.dart';
import '../../../../data/services/l10n_service.dart';

/// DESKTOP RICH HOMEPAGE - InnerCycles
///
/// App Store 4.3(b) Compliant - Journal & Reflection focused.
/// Journal-focused, safe language.
class DesktopRichHomepage extends ConsumerWidget {
  const DesktopRichHomepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final language = ref.watch(languageProvider);

    if (userProfile == null ||
        userProfile.name == null ||
        userProfile.name!.isEmpty) {
      return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.deepSpace
            : AppColors.lightBackground,
        body: const Center(
          child: CosmicLoadingIndicator(),
        ),
      );
    }

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                children: [
                  _DesktopHeader(
                    userName: userProfile.name ?? '',
                    language: language,
                  ).glassEntrance(context: context),

                  const SizedBox(height: 16),

                  _QuickDiscoveryBar(
                    language: language,
                  ).glassListItem(context: context, index: 1),

                  const SizedBox(height: 24),

                  _HeroSection(language: language)
                      .glassReveal(context: context),

                  const SizedBox(height: 40),

                  _FeatureCategoriesSection(language: language)
                      .glassListItem(context: context, index: 2),

                  const SizedBox(height: 40),

                  PageBottomNavigation(
                    currentRoute: '/',
                    language: language,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DESKTOP HEADER
// ═══════════════════════════════════════════════════════════════════════════

class _DesktopHeader extends StatelessWidget {
  final String userName;
  final AppLanguage language;

  const _DesktopHeader({
    required this.userName,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(20),
      child: Row(
        children: [
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
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  language == AppLanguage.en
                      ? 'Emotional Cycle Intelligence'
                      : 'Duygusal Döngü Zekası',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.push(Routes.settings),
            icon: Icon(
              Icons.settings_outlined,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => context.push(Routes.profile),
            icon: Icon(
              Icons.person_outline,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// QUICK DISCOVERY BAR
// ═══════════════════════════════════════════════════════════════════════════

class _QuickDiscoveryBar extends StatelessWidget {
  final AppLanguage language;

  const _QuickDiscoveryBar({required this.language});

  @override
  Widget build(BuildContext context) {
    final items = [
      _QuickItem(
        icon: '📓',
        label: language == AppLanguage.en ? 'Journal' : 'Günlük',
        route: Routes.journal,
      ),
      _QuickItem(
        icon: '📊',
        label: language == AppLanguage.en ? 'Patterns' : 'Kaliplar',
        route: Routes.journalPatterns,
      ),
      _QuickItem(
        icon: '✨',
        label: language == AppLanguage.en ? 'Insight' : 'Icgörü',
        route: Routes.insight,
      ),
      _QuickItem(
        icon: '🌙',
        label: language == AppLanguage.en ? 'Dreams' : 'Rüyalar',
        route: Routes.dreamInterpretation,
      ),
      _QuickItem(
        icon: '📅',
        label: language == AppLanguage.en ? 'Monthly' : 'Aylik',
        route: Routes.journalMonthly,
      ),
      _QuickItem(
        icon: '📚',
        label: language == AppLanguage.en ? 'Archive' : 'Arsiv',
        route: Routes.journalArchive,
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _QuickDiscoveryChip(
                  icon: item.icon,
                  label: item.label,
                  onTap: () => context.push(item.route),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _QuickItem {
  final String icon;
  final String label;
  final String route;

  const _QuickItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

class _QuickDiscoveryChip extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _QuickDiscoveryChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: GlassPanel(
          elevation: GlassElevation.g2,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          borderRadius: BorderRadius.circular(20),
          glowColor: AppColors.starGold.withValues(alpha: 0.15),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(icon, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
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
// HERO SECTION
// ═══════════════════════════════════════════════════════════════════════════

class _HeroSection extends StatelessWidget {
  final AppLanguage language;

  const _HeroSection({required this.language});

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      elevation: GlassElevation.g3,
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      borderRadius: BorderRadius.circular(24),
      glowColor: AppColors.starGold.withValues(alpha: 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getDailyHeadline(language),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.starGold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _getDailySentence(language),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.push(Routes.journal),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.starGold,
              foregroundColor: AppColors.deepSpace,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  language == AppLanguage.en
                      ? 'Start Today\'s Entry'
                      : 'Bugünün Kaydını Başlat',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDailyHeadline(AppLanguage language) {
    final headlines = language == AppLanguage.en
        ? [
            'A recurring pattern may be active today',
            'Your cycle engine detected a familiar position',
            'Check where you are in your emotional cycle',
            'A past cycle entry matches today\'s position',
            'Your recurrence map updated overnight',
            'Shadow-light ratio shifted since last week',
            'Archetype progression: new data point logged',
          ]
        : [
            'Bugün tekrarlayan bir örüntü aktif olabilir',
            'Döngü motorun tanıdık bir pozisyon tespit etti',
            'Duygusal döngünde nerede olduğunu kontrol et',
            'Geçmiş bir döngü kaydı bugünkü pozisyonla eşleşiyor',
            'Tekrar haritanız gece güncellendi',
            'Gölge-ışık oranı geçen haftadan bu yana değişti',
            'Arketip ilerlemesi: yeni veri noktası kaydedildi',
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
            'Past entries from similar cycle positions are surfacing connections.',
            'The recurrence detection engine found a matching pattern from 3 weeks ago.',
            'Your archetype has shifted — check your progression dashboard.',
            'Dream archaeology detected a recurring symbol across your last 5 dreams.',
            'Shadow-light integration: a previously unresolved theme is re-emerging.',
            'Cycle position 4 of 7 — here is what happened last time you were here.',
          ]
        : [
            'Döngü motorun son kayıtlarındaki örüntüleri analiz ediyor.',
            'Benzer döngü pozisyonlarındaki geçmiş kayıtlar bağlantılar ortaya çıkarıyor.',
            'Tekrar tespit motoru 3 hafta önceki eşleşen bir örüntü buldu.',
            'Arketipin değişti — ilerleme panelini kontrol et.',
            'Rüya arkeolojisi son 5 rüyanda tekrarlayan bir sembol tespit etti.',
            'Gölge-ışık entegrasyonu: daha önce çözülmemiş bir tema yeniden ortaya çıkıyor.',
            'Döngü pozisyonu 7\'de 4 — en son burada olduğunda ne olmuştu.',
          ];

    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    return sentences[dayOfYear % sentences.length];
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// FEATURE CATEGORIES SECTION
// ═══════════════════════════════════════════════════════════════════════════

class _FeatureCategoriesSection extends StatelessWidget {
  final AppLanguage language;

  const _FeatureCategoriesSection({required this.language});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1200 ? 3 : 2;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.5,
          children: [
            _FeatureCard(
              title: language == AppLanguage.en
                  ? 'Cycle Entry'
                  : 'Döngü Kaydı',
              subtitle: language == AppLanguage.en
                  ? 'Map your cycle position & emotional state'
                  : 'Döngü pozisyonunu ve duygusal durumunu haritalandır',
              icon: Icons.edit_note,
              color: AppColors.auroraStart,
              route: Routes.journal,
            ),
            _FeatureCard(
              title: language == AppLanguage.en
                  ? 'Recurrence Detection'
                  : 'Tekrar Tespiti',
              subtitle: language == AppLanguage.en
                  ? 'Recurring cycles & pattern correlations'
                  : 'Tekrarlayan döngüler ve örüntü korelasyonları',
              icon: Icons.insights,
              color: AppColors.starGold,
              route: Routes.journalPatterns,
            ),
            _FeatureCard(
              title: language == AppLanguage.en
                  ? 'Cyclical Insight'
                  : 'Döngüsel İçgörü',
              subtitle: language == AppLanguage.en
                  ? 'Pattern-aware reflection engine'
                  : 'Örüntü farkındalıklı yansıma motoru',
              icon: Icons.auto_awesome,
              color: AppColors.starGold,
              route: Routes.insight,
            ),
            _FeatureCard(
              title: language == AppLanguage.en
                  ? 'Dream Archaeology'
                  : 'Rüya Arkeolojisi',
              subtitle: language == AppLanguage.en
                  ? 'Track recurring symbols & story arcs'
                  : 'Tekrarlayan sembolleri ve hikaye arklarını takip et',
              icon: Icons.nights_stay,
              color: AppColors.purpleAccent,
              route: Routes.dreamInterpretation,
            ),
            _FeatureCard(
              title: language == AppLanguage.en
                  ? 'Monthly Reflection'
                  : 'Aylık Yansıma',
              subtitle: language == AppLanguage.en
                  ? 'Review your month'
                  : 'Ayını gözden geçir',
              icon: Icons.calendar_month,
              color: AppColors.warmAccent,
              route: Routes.journalMonthly,
            ),
            _FeatureCard(
              title: language == AppLanguage.en
                  ? 'Reference'
                  : 'Referans',
              subtitle: language == AppLanguage.en
                  ? 'Glossary & Articles'
                  : 'Sözlük ve Makaleler',
              icon: Icons.menu_book,
              color: AppColors.greenAccent,
              route: Routes.glossary,
            ),
          ],
        );
      },
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(route),
        borderRadius: BorderRadius.circular(20),
        child: GlassPanel(
          elevation: GlassElevation.g2,
          padding: const EdgeInsets.all(24),
          borderRadius: BorderRadius.circular(20),
          glowColor: color.withValues(alpha: 0.15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
