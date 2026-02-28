// ════════════════════════════════════════════════════════════════════════════
// GRATITUDE FULL SCREEN - Gratitude Journal + History
// ════════════════════════════════════════════════════════════════════════════
// Write daily gratitude items, view history, see theme trends.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/gratitude_service.dart';
import '../../../data/services/smart_router_service.dart';
import '../../../data/services/ecosystem_analytics_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';
import '../../../data/services/l10n_service.dart';

class GratitudeScreen extends ConsumerStatefulWidget {
  const GratitudeScreen({super.key});

  @override
  ConsumerState<GratitudeScreen> createState() => _GratitudeScreenState();
}

class _GratitudeScreenState extends ConsumerState<GratitudeScreen> {
  final _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  // Cache allEntries to avoid refetching on every setState
  GratitudeService? _lastService;
  List<GratitudeEntry> _cachedEntries = const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(smartRouterServiceProvider)
          .whenData((s) => s.recordToolVisit('gratitude'));
      ref
          .read(ecosystemAnalyticsServiceProvider)
          .whenData((s) => s.trackToolOpen('gratitude', source: 'direct'));
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(gratitudeServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          behavior: HitTestBehavior.opaque,
          child: SafeArea(
            child: CupertinoScrollbar(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: L10nService.get('gratitude.gratitude.gratitude_journal', isEn ? AppLanguage.en : AppLanguage.tr),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: serviceAsync.when(
                      loading: () => const SliverToBoxAdapter(
                        child: Center(child: CosmicLoadingIndicator()),
                      ),
                      error: (_, _) => SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  CommonStrings.somethingWentWrong(language),
                                  textAlign: TextAlign.center,
                                  style: AppTypography.decorativeScript(
                                    color: isDark
                                        ? AppColors.textMuted
                                        : AppColors.lightTextMuted,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextButton.icon(
                                  onPressed: () =>
                                      ref.invalidate(gratitudeServiceProvider),
                                  icon: Icon(Icons.refresh_rounded,
                                      size: 16, color: AppColors.starGold),
                                  label: Text(
                                    L10nService.get('gratitude.gratitude.retry', isEn ? AppLanguage.en : AppLanguage.tr),
                                    style: AppTypography.elegantAccent(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.starGold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      data: (service) {
                        final today = service.getTodayEntry();
                        final summary = service.getWeeklySummary();
                        if (!identical(service, _lastService)) {
                          _lastService = service;
                          _cachedEntries = service.getAllEntries();
                        }
                        final allEntries = _cachedEntries;

                        // Pre-fill if today has entries
                        if (today != null && _controllers[0].text.isEmpty) {
                          for (
                            var i = 0;
                            i < today.items.length && i < 3;
                            i++
                          ) {
                            _controllers[i].text = today.items[i];
                          }
                        }

                        return SliverList(
                          delegate: SliverChildListDelegate([
                            // Weekly stats
                            _WeeklyStats(
                              summary: summary,
                              isDark: isDark,
                              isEn: isEn,
                            ),
                            const SizedBox(height: 20),

                            // Today's entry
                            _TodaySection(
                              controllers: _controllers,
                              hasEntry: today != null,
                              isDark: isDark,
                              isEn: isEn,
                              onSave: () async {
                                final items = _controllers
                                    .map((c) => c.text.trim())
                                    .where((s) => s.isNotEmpty)
                                    .toList();
                                if (items.isEmpty) return;
                                await service.saveGratitude(
                                  date: DateTime.now(),
                                  items: items,
                                );
                                if (!context.mounted) return;
                                ref.invalidate(gratitudeServiceProvider);
                                ref
                                    .read(smartRouterServiceProvider)
                                    .whenData(
                                      (s) =>
                                          s.recordOutput('gratitude', 'entry'),
                                    );
                                ref
                                    .read(ecosystemAnalyticsServiceProvider)
                                    .whenData(
                                      (s) => s.trackToolOutput(
                                        'gratitude',
                                        'entry',
                                      ),
                                    );
                                HapticFeedback.mediumImpact();
                              },
                            ),
                            const SizedBox(height: 24),

                            // Theme cloud
                            if (summary.topThemes.isNotEmpty) ...[
                              _ThemeCloud(
                                themes: summary.topThemes,
                                isDark: isDark,
                                isEn: isEn,
                              ),
                              const SizedBox(height: 24),
                            ],

                            // History
                            if (allEntries.isNotEmpty) ...[
                              GradientText(
                                L10nService.get('gratitude.gratitude.history', isEn ? AppLanguage.en : AppLanguage.tr),
                                variant: GradientTextVariant.gold,
                                style: AppTypography.displayFont.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...allEntries
                                  .take(20)
                                  .map(
                                    (entry) => _HistoryCard(
                                      entry: entry,
                                      isDark: isDark,
                                    ),
                                  ),
                            ],

                            ToolEcosystemFooter(
                              currentToolId: 'gratitude',
                              isEn: isEn,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 40),
                          ]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WeeklyStats extends StatelessWidget {
  final GratitudeSummary summary;
  final bool isDark;
  final AppLanguage language;  bool get isEn => language.isEn;

  const _WeeklyStats({
    required this.summary,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(16),
      borderRadius: 14,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(
            value: '${summary.daysWithGratitude}',
            label: L10nService.get('gratitude.gratitude.days', isEn ? AppLanguage.en : AppLanguage.tr),
            color: AppColors.starGold,
            isDark: isDark,
          ),
          _Stat(
            value: '${summary.totalItems}',
            label: L10nService.get('gratitude.gratitude.items', isEn ? AppLanguage.en : AppLanguage.tr),
            color: AppColors.success,
            isDark: isDark,
          ),
          _Stat(
            value: '${summary.topThemes.length}',
            label: L10nService.get('gratitude.gratitude.themes', isEn ? AppLanguage.en : AppLanguage.tr),
            color: AppColors.auroraStart,
            isDark: isDark,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool isDark;

  const _Stat({
    required this.value,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.displayFont.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTypography.elegantAccent(
            fontSize: 11,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}

class _TodaySection extends StatelessWidget {
  final List<TextEditingController> controllers;
  final bool hasEntry;
  final bool isDark;
  final AppLanguage language;  bool get isEn => language.isEn;
  final VoidCallback onSave;

  const _TodaySection({
    required this.controllers,
    required this.hasEntry,
    required this.isDark,
    required this.isEn,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final prompts = isEn
        ? [
            'I am grateful for...',
            'Something that made me smile...',
            'A small joy today...',
          ]
        : [
            'Şükran duyduğum şey...',
            'Beni gülümseten bir şey...',
            'Bugünkü küçük bir sevinç...',
          ];

    return PremiumCard(
      style: PremiumCardStyle.gold,
      padding: const EdgeInsets.all(16),
      borderRadius: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite_outline, size: 18, color: AppColors.starGold),
              const SizedBox(width: 8),
              GradientText(
                isEn ? "Today's Gratitude" : 'Bugünkü Şükran',
                variant: GradientTextVariant.gold,
                style: AppTypography.displayFont.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (hasEntry) ...[
                const Spacer(),
                Icon(Icons.check_circle, size: 16, color: AppColors.success),
              ],
            ],
          ),
          const SizedBox(height: 14),
          ...List.generate(
            3,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: controllers[i],
                maxLength: 200,
                style: AppTypography.subtitle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText: prompts[i],
                  hintStyle: AppTypography.decorativeScript(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                  counterText: '',
                  filled: true,
                  fillColor: isDark
                      ? Colors.white.withValues(alpha: 0.04)
                      : Colors.black.withValues(alpha: 0.02),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  prefixIcon: Text(
                    '  ${i + 1}. ',
                    style: AppTypography.modernAccent(
                      color: AppColors.starGold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 32),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          GradientButton.gold(
            label: hasEntry
                ? (L10nService.get('gratitude.gratitude.update', isEn ? AppLanguage.en : AppLanguage.tr))
                : (L10nService.get('gratitude.gratitude.save_gratitude', isEn ? AppLanguage.en : AppLanguage.tr)),
            onPressed: onSave,
            expanded: true,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 300.ms);
  }
}

class _ThemeCloud extends StatelessWidget {
  final Map<String, int> themes;
  final bool isDark;
  final AppLanguage language;  bool get isEn => language.isEn;

  const _ThemeCloud({
    required this.themes,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(16),
      borderRadius: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            L10nService.get('gratitude.gratitude.this_weeks_themes', isEn ? AppLanguage.en : AppLanguage.tr),
            variant: GradientTextVariant.gold,
            style: AppTypography.displayFont.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Builder(
            builder: (_) {
              final maxCount = themes.values.reduce((a, b) => a > b ? a : b);
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: themes.entries.map((e) {
                  final opacity = maxCount > 0
                      ? 0.3 + (e.value / maxCount) * 0.7
                      : 0.3;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.starGold.withValues(
                        alpha: opacity * 0.2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.starGold.withValues(
                          alpha: opacity * 0.4,
                        ),
                      ),
                    ),
                    child: Text(
                      e.key,
                      style: AppTypography.subtitle(
                        fontSize: 13,
                        color: AppColors.starGold,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 300.ms);
  }
}

class _HistoryCard extends StatelessWidget {
  final GratitudeEntry entry;
  final bool isDark;

  const _HistoryCard({required this.entry, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark.withValues(alpha: 0.85)
              : AppColors.lightCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.dateKey,
              style: AppTypography.modernAccent(
                fontSize: 11,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 6),
            ...entry.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '  •  ',
                      style: AppTypography.modernAccent(
                        color: AppColors.starGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: AppTypography.decorativeScript(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
