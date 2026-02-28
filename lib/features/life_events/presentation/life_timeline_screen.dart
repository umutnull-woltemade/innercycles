// ════════════════════════════════════════════════════════════════════════════
// LIFE TIMELINE SCREEN - Chronological Life Event Browse View
// ════════════════════════════════════════════════════════════════════════════

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/common_strings.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/content/life_event_presets.dart';
import '../../../data/models/life_event.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/haptic_service.dart';
import '../../../data/services/life_event_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/content_disclaimer.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/premium_empty_state.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';
import '../../../data/services/l10n_service.dart';

class LifeTimelineScreen extends ConsumerStatefulWidget {
  const LifeTimelineScreen({super.key});

  @override
  ConsumerState<LifeTimelineScreen> createState() => _LifeTimelineScreenState();
}

class _LifeTimelineScreenState extends ConsumerState<LifeTimelineScreen> {
  LifeEventType? _filter; // null = all

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(lifeEventServiceProvider);
    final isPremium = ref.watch(isPremiumUserProvider);

    return Scaffold(
      body: CosmicBackground(
        child: serviceAsync.when(
          loading: () => const CosmicLoadingIndicator(),
          error: (_, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  L10nService.get('life_events.life_timeline.couldnt_load_your_timeline', isEn ? AppLanguage.en : AppLanguage.tr),
                  style: AppTypography.subtitle(
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () => ref.invalidate(lifeEventServiceProvider),
                  icon: Icon(
                    Icons.refresh_rounded,
                    size: 16,
                    color: AppColors.starGold,
                  ),
                  label: Text(
                    L10nService.get('life_events.life_timeline.retry', isEn ? AppLanguage.en : AppLanguage.tr),
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
          data: (service) =>
              _buildContent(context, service, isDark, isEn, isPremium),
        ),
      ),
      floatingActionButton: _AnimatedFAB(
        isEn: isEn,
        onPressed: () => context.push(Routes.lifeEventNew),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    LifeEventService service,
    bool isDark,
    bool isEn,
    bool isPremium,
  ) {
    var events = _filter != null
        ? service.getEventsByType(_filter!)
        : service.getAllEvents();

    // Free users: only show last 30 days
    if (!isPremium) {
      final cutoff = DateTime.now().subtract(const Duration(days: 30));
      events = events.where((e) => e.date.isAfter(cutoff)).toList();
    }

    // Group by month
    final grouped = <String, List<LifeEvent>>{};
    for (final event in events) {
      final key =
          '${event.date.year}-${event.date.month.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => []).add(event);
    }
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return CupertinoScrollbar(
      child: RefreshIndicator(
        color: AppColors.starGold,
        onRefresh: () async {
          ref.invalidate(lifeEventServiceProvider);
          await Future.delayed(const Duration(milliseconds: 300));
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            GlassSliverAppBar(
              title: L10nService.get('life_events.life_timeline.life_timeline', isEn ? AppLanguage.en : AppLanguage.tr),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Filter chips
                  _buildFilterChips(isDark, isEn),
                  const SizedBox(height: 16),

                  if (events.isEmpty)
                    _buildEmptyState(isDark, isEn)
                  else ...[
                    for (int i = 0; i < sortedKeys.length; i++) ...[
                      _buildMonthHeader(
                        sortedKeys[i],
                        grouped[sortedKeys[i]]!.length,
                        isDark,
                        isEn,
                      ),
                      const SizedBox(height: 8),
                      ...grouped[sortedKeys[i]]!.map(
                        (event) =>
                            _buildEventCard(context, event, isDark, isEn),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],

                  // Premium gate message
                  if (!isPremium && service.eventCount > events.length)
                    _buildPremiumGate(context, isDark, isEn),

                  ContentDisclaimer(
                    language: isEn ? AppLanguage.en : AppLanguage.tr,
                  ),
                  const SizedBox(height: 80),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(bool isDark, bool isEn) {
    return Row(
      children: [
        _filterChip(null, L10nService.get('life_events.life_timeline.all', isEn ? AppLanguage.en : AppLanguage.tr), AppColors.auroraStart, isDark),
        const SizedBox(width: 8),
        _filterChip(
          LifeEventType.positive,
          L10nService.get('life_events.life_timeline.positive', isEn ? AppLanguage.en : AppLanguage.tr),
          AppColors.starGold,
          isDark,
        ),
        const SizedBox(width: 8),
        _filterChip(
          LifeEventType.challenging,
          L10nService.get('life_events.life_timeline.challenging', isEn ? AppLanguage.en : AppLanguage.tr),
          AppColors.amethyst,
          isDark,
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _filterChip(
    LifeEventType? type,
    String label,
    Color color,
    bool isDark,
  ) {
    final isSelected = _filter == type;
    return GestureDetector(
      onTap: () => setState(() => _filter = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : (isDark
                    ? AppColors.surfaceDark.withValues(alpha: 0.6)
                    : AppColors.lightCard),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? color.withValues(alpha: 0.4)
                : (isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.05)),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.elegantAccent(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? color
                : (isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthHeader(String monthKey, int count, bool isDark, bool isEn) {
    final parts = monthKey.split('-');
    final year = parts[0];
    final monthIndex = int.tryParse(parts[1]) ?? 1;
    final monthNames = isEn
        ? CommonStrings.monthsFullEn
        : CommonStrings.monthsFullTr;

    return Row(
      children: [
        GradientText(
          '${monthNames[(monthIndex - 1).clamp(0, 11)]} $year',
          variant: GradientTextVariant.gold,
          style: AppTypography.displayFont.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.starGold.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '$count',
            style: AppTypography.elegantAccent(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.starGold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(
    BuildContext context,
    LifeEvent event,
    bool isDark,
    bool isEn,
  ) {
    final isPositive = event.type == LifeEventType.positive;
    final accentColor = isPositive ? AppColors.starGold : AppColors.amethyst;
    final preset = event.eventKey != null
        ? LifeEventPresets.getByKey(event.eventKey!)
        : null;
    final emoji = preset?.emoji ?? (isPositive ? '\u{2728}' : '\u{1F4AD}');

    final formatted =
        '${event.date.day.toString().padLeft(2, '0')}/'
        '${event.date.month.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Semantics(
        button: true,
        label: '${event.title}, $formatted',
        child: GestureDetector(
          onTap: () {
            HapticService.selectionTap();
            context.push(
              Routes.lifeEventDetail.replaceFirst(':id', event.id),
            );
          },
          child: PremiumCard(
            style: PremiumCardStyle.subtle,
            borderRadius: 14,
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Emoji + accent line
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: AppSymbol(emoji, size: AppSymbolSize.sm),
                  ),
                ),
                const SizedBox(width: 12),
                // Title + date + emotions
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            formatted,
                            style: AppTypography.elegantAccent(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                          if (event.emotionTags.isNotEmpty) ...[
                            Text(
                              '  \u{2022}  ',
                              style: AppTypography.elegantAccent(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                event.emotionTags.take(2).join(', '),
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.elegantAccent(
                                  fontSize: 11,
                                  color: accentColor.withValues(alpha: 0.8),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Photo thumbnail
                if (event.imagePath != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(event.imagePath!),
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      semanticLabel: L10nService.get('life_events.life_timeline.event_photo', isEn ? AppLanguage.en : AppLanguage.tr),
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 200.ms, delay: 80.ms),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, bool isEn) {
    return PremiumEmptyState(
      icon: Icons.auto_awesome_rounded,
      title: L10nService.get('life_events.life_timeline.your_timeline_awaits_its_first_chapter', isEn ? AppLanguage.en : AppLanguage.tr),
      description: L10nService.get('life_events.life_timeline.start_recording_the_moments_that_shape_y', isEn ? AppLanguage.en : AppLanguage.tr),
      gradientVariant: GradientTextVariant.gold,
      ctaLabel: L10nService.get('life_events.life_timeline.add_life_event', isEn ? AppLanguage.en : AppLanguage.tr),
      onCtaPressed: () => context.push(Routes.lifeEventNew),
    );
  }

  Widget _buildPremiumGate(BuildContext context, bool isDark, bool isEn) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: PremiumCard(
        style: PremiumCardStyle.gold,
        borderRadius: 14,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.lock_outline_rounded,
              color: AppColors.starGold,
              size: 28,
            ),
            const SizedBox(height: 8),
            GradientText(
              L10nService.get('life_events.life_timeline.unlock_your_full_timeline_with_pro', isEn ? AppLanguage.en : AppLanguage.tr),
              variant: GradientTextVariant.gold,
              textAlign: TextAlign.center,
              style: AppTypography.displayFont.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            GradientButton.gold(
              label: L10nService.get('life_events.life_timeline.upgrade_to_pro', isEn ? AppLanguage.en : AppLanguage.tr),
              onPressed: () => showContextualPaywall(
                context,
                ref,
                paywallContext: PaywallContext.patterns,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedFAB extends StatelessWidget {
  final bool isEn;
  final VoidCallback onPressed;

  const _AnimatedFAB({required this.isEn, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
          message: L10nService.get('life_events.life_timeline.add_life_event_1', isEn ? AppLanguage.en : AppLanguage.tr),
          child: GestureDetector(
            onTap: onPressed,
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.starGold, AppColors.celestialGold],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.starGold.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, size: 20, color: AppColors.deepSpace),
                  const SizedBox(width: 8),
                  Text(
                    L10nService.get('life_events.life_timeline.new_event', isEn ? AppLanguage.en : AppLanguage.tr),
                    style: AppTypography.displayFont.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepSpace,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: 300.ms)
        .slideY(begin: 0.3, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }
}
