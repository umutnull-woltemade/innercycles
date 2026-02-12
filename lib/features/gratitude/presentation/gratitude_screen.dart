// ════════════════════════════════════════════════════════════════════════════
// GRATITUDE FULL SCREEN - Gratitude Journal + History
// ════════════════════════════════════════════════════════════════════════════
// Write daily gratitude items, view history, see theme trends.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/gratitude_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

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
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              GlassSliverAppBar(
                title: isEn ? 'Gratitude Journal' : 'Şükran Günlüğü',
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: serviceAsync.when(
                  loading: () => const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, s) => const SliverToBoxAdapter(
                    child: SizedBox.shrink(),
                  ),
                  data: (service) {
                    final today = service.getTodayEntry();
                    final summary = service.getWeeklySummary();
                    final allEntries = service.getAllEntries();

                    // Pre-fill if today has entries
                    if (today != null &&
                        _controllers[0].text.isEmpty) {
                      for (var i = 0;
                          i < today.items.length && i < 3;
                          i++) {
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
                            ref.invalidate(gratitudeServiceProvider);
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
                          Text(
                            isEn ? 'History' : 'Geçmiş',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...allEntries.take(20).map((entry) =>
                              _HistoryCard(
                                entry: entry,
                                isDark: isDark,
                              )),
                        ],

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
    );
  }
}

class _WeeklyStats extends StatelessWidget {
  final GratitudeSummary summary;
  final bool isDark;
  final bool isEn;

  const _WeeklyStats({
    required this.summary,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(
            value: '${summary.daysWithGratitude}',
            label: isEn ? 'Days' : 'Gün',
            color: AppColors.starGold,
            isDark: isDark,
          ),
          _Stat(
            value: '${summary.totalItems}',
            label: isEn ? 'Items' : 'Madde',
            color: AppColors.success,
            isDark: isDark,
          ),
          _Stat(
            value: '${summary.topThemes.length}',
            label: isEn ? 'Themes' : 'Tema',
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
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
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
  final bool isEn;
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.starGold.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite_outline,
                  size: 18, color: AppColors.starGold),
              const SizedBox(width: 8),
              Text(
                isEn ? "Today's Gratitude" : 'Bugünkü Şükran',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              if (hasEntry) ...[
                const Spacer(),
                Icon(Icons.check_circle,
                    size: 16, color: AppColors.success),
              ],
            ],
          ),
          const SizedBox(height: 14),
          ...List.generate(3, (i) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              controller: controllers[i],
              maxLength: 200,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
              decoration: InputDecoration(
                hintText: prompts[i],
                hintStyle: TextStyle(
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                  fontSize: 13,
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
                    horizontal: 14, vertical: 12),
                prefixIcon: Text(
                  '  ${i + 1}. ',
                  style: TextStyle(
                    color: AppColors.starGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 32),
              ),
            ),
          )),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.starGold,
                foregroundColor: AppColors.deepSpace,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                hasEntry
                    ? (isEn ? 'Update' : 'Güncelle')
                    : (isEn ? 'Save Gratitude' : 'Şükranı Kaydet'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 300.ms);
  }
}

class _ThemeCloud extends StatelessWidget {
  final Map<String, int> themes;
  final bool isDark;
  final bool isEn;

  const _ThemeCloud({
    required this.themes,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEn ? 'This Week\'s Themes' : 'Bu Haftanın Temaları',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: themes.entries.map((e) {
              final maxCount = themes.values
                  .reduce((a, b) => a > b ? a : b);
              final opacity = 0.3 + (e.value / maxCount) * 0.7;
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.starGold
                      .withValues(alpha: opacity * 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.starGold
                        .withValues(alpha: opacity * 0.4),
                  ),
                ),
                child: Text(
                  e.key,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.starGold,
                  ),
                ),
              );
            }).toList(),
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
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 6),
            ...entry.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  •  ',
                    style: TextStyle(
                      color: AppColors.starGold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
