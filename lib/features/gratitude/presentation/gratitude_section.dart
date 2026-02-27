import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/gratitude_service.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

/// Collapsible gratitude section for the daily entry screen
class GratitudeSection extends ConsumerStatefulWidget {
  final DateTime date;
  final bool isPremium;

  const GratitudeSection({
    super.key,
    required this.date,
    this.isPremium = false,
  });

  @override
  ConsumerState<GratitudeSection> createState() => _GratitudeSectionState();
}

class _GratitudeSectionState extends ConsumerState<GratitudeSection> {
  bool _isExpanded = false;
  final List<TextEditingController> _controllers = [];
  bool _loaded = false;

  int get _maxItems => widget.isPremium ? 3 : 1;

  @override
  void initState() {
    super.initState();
    _controllers.add(TextEditingController());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _loadExisting(GratitudeService service) {
    if (_loaded) return;
    _loaded = true;
    final existing = service.getEntry(widget.date);
    if (existing != null && existing.items.isNotEmpty) {
      _isExpanded = true;
      for (final c in _controllers) {
        c.dispose();
      }
      _controllers.clear();
      for (final item in existing.items.take(_maxItems)) {
        _controllers.add(TextEditingController(text: item));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(gratitudeServiceProvider);

    return serviceAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        _loadExisting(service);
        return _buildSection(isDark, isEn, service);
      },
    );
  }

  Widget _buildSection(bool isDark, bool isEn, GratitudeService service) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      child: Column(
        children: [
          // Toggle header
          Semantics(
            label: isEn
                ? (_isExpanded ? 'Collapse gratitude' : 'Expand gratitude')
                : (_isExpanded ? 'Şükranı daralt' : 'Şükranı genişlet'),
            button: true,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _isExpanded = !_isExpanded);
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.favorite_rounded,
                          color: AppColors.success,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GradientText(
                              isEn ? 'Gratitude' : 'Şükran',
                              variant: GradientTextVariant.gold,
                              style: AppTypography.displayFont.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              isEn
                                  ? 'What went well today?'
                                  : 'Bugün ne iyi gitti?',
                              style: AppTypography.decorativeScript(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.expand_more_rounded,
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

          // Expanded content
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _buildGratitudeFields(isDark, isEn, service),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 450.ms, duration: 300.ms);
  }

  Widget _buildGratitudeFields(
    bool isDark,
    bool isEn,
    GratitudeService service,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          ...List.generate(_controllers.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(
                    '${index + 1}.',
                    style: AppTypography.elegantAccent(
                      fontSize: 14,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controllers[index],
                      maxLength: 150,
                      textCapitalization: TextCapitalization.sentences,
                      style: AppTypography.subtitle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: isEn
                            ? 'I\'m grateful for...'
                            : 'Şükran duyduğum...',
                        hintStyle: AppTypography.subtitle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                        border: InputBorder.none,
                        counterText: '',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onChanged: (_) => _autoSave(service),
                    ),
                  ),
                ],
              ),
            );
          }),

          // Add more button (if under max)
          if (_controllers.length < _maxItems)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _controllers.add(TextEditingController());
                });
              },
              icon: Icon(Icons.add, size: 18, color: AppColors.success),
              label: Text(
                isEn ? 'Add another' : 'Bir tane daha ekle',
                style: AppTypography.elegantAccent(
                  fontSize: 13,
                  color: AppColors.success,
                ),
              ),
            ),

          // Premium upsell
          if (!widget.isPremium && _controllers.length >= _maxItems)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.starGold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, size: 16, color: AppColors.starGold),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isEn
                          ? 'Premium: Add up to 3 gratitude items + theme analysis'
                          : 'Premium: 3 şükran maddesi + tema analizi',
                      style: AppTypography.elegantAccent(
                        fontSize: 12,
                        color: AppColors.starGold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _autoSave(GratitudeService service) async {
    final items = _controllers
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (items.isNotEmpty) {
      await service.saveGratitude(date: widget.date, items: items);
      if (!mounted) return;
      ref.invalidate(todayGratitudeProvider);
      ref.invalidate(gratitudeSummaryProvider);
    }
  }
}

/// Gratitude summary card for home screen
class GratitudeSummaryCard extends ConsumerWidget {
  const GratitudeSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final summaryAsync = ref.watch(gratitudeSummaryProvider);

    return summaryAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (summary) {
        if (summary.totalItems == 0) return const SizedBox.shrink();
        return _GratitudeSummaryContent(
          summary: summary,
          isDark: isDark,
          isEn: isEn,
        );
      },
    );
  }
}

class _GratitudeSummaryContent extends StatelessWidget {
  final GratitudeSummary summary;
  final bool isDark;
  final bool isEn;

  const _GratitudeSummaryContent({
    required this.summary,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite_rounded, size: 18, color: AppColors.success),
              const SizedBox(width: 8),
              GradientText(
                isEn ? 'This Week\'s Gratitude' : 'Bu Haftanın Şükranı',
                variant: GradientTextVariant.gold,
                style: AppTypography.displayFont.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isEn
                ? '${summary.totalItems} gratitude items across ${summary.daysWithGratitude} days'
                : '${summary.daysWithGratitude} günde ${summary.totalItems} şükran maddesi',
            style: AppTypography.decorativeScript(
              fontSize: 13,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          if (summary.topThemes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: summary.topThemes.keys.take(3).map((theme) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    theme,
                    style: AppTypography.elegantAccent(
                      fontSize: 12,
                      color: AppColors.success,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, duration: 400.ms);
  }
}
