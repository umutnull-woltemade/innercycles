// ════════════════════════════════════════════════════════════════════════════
// LIFE TIMELINE SCREEN - Chronological Life Event Browse View
// ════════════════════════════════════════════════════════════════════════════

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/content/life_event_presets.dart';
import '../../../data/models/life_event.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/life_event_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/content_disclaimer.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';

class LifeTimelineScreen extends ConsumerStatefulWidget {
  const LifeTimelineScreen({super.key});

  @override
  ConsumerState<LifeTimelineScreen> createState() =>
      _LifeTimelineScreenState();
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
            child: Text(
              isEn ? 'Something went wrong' : 'Bir şeyler ters gitti',
              style: TextStyle(
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
          data: (service) =>
              _buildContent(context, service, isDark, isEn, isPremium),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(Routes.lifeEventNew),
        backgroundColor: AppColors.starGold,
        child: Icon(Icons.add_rounded, color: AppColors.deepSpace),
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
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        GlassSliverAppBar(
          title: isEn ? 'Life Timeline' : 'Yaşam Zaman Çizelgesi',
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
                    (event) => _buildEventCard(context, event, isDark, isEn),
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
    );
  }

  Widget _buildFilterChips(bool isDark, bool isEn) {
    return Row(
      children: [
        _filterChip(
          null,
          isEn ? 'All' : 'Tümü',
          AppColors.auroraStart,
          isDark,
        ),
        const SizedBox(width: 8),
        _filterChip(
          LifeEventType.positive,
          isEn ? 'Positive' : 'Olumlu',
          AppColors.starGold,
          isDark,
        ),
        const SizedBox(width: 8),
        _filterChip(
          LifeEventType.challenging,
          isEn ? 'Challenging' : 'Zorlu',
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
          style: TextStyle(
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

  Widget _buildMonthHeader(
    String monthKey,
    int count,
    bool isDark,
    bool isEn,
  ) {
    final parts = monthKey.split('-');
    final year = parts[0];
    final monthIndex = int.tryParse(parts[1]) ?? 1;
    final monthNames = isEn
        ? [
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December',
          ]
        : [
            'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
            'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
          ];

    return Row(
      children: [
        Text(
          '${monthNames[(monthIndex - 1).clamp(0, 11)]} $year',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
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
            style: TextStyle(
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
      child: GestureDetector(
        onTap: () => context.push(
          Routes.lifeEventDetail.replaceFirst(':id', event.id),
        ),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceDark.withValues(alpha: 0.8)
                : AppColors.lightCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.15),
            ),
          ),
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
                  child: Text(emoji, style: const TextStyle(fontSize: 22)),
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
                      style: TextStyle(
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
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                        if (event.emotionTags.isNotEmpty) ...[
                          Text(
                            '  \u{2022}  ',
                            style: TextStyle(
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
                              style: TextStyle(
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
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 200.ms),
    );
  }

  Widget _buildEmptyState(bool isDark, bool isEn) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 48,
            color: AppColors.starGold.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            isEn ? 'No life events yet' : 'Henüz yaşam olayı yok',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isEn
                ? 'Start recording the moments that shape your story'
                : 'Hikayenizi şekillendiren anları kaydetmeye başlayın',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumGate(BuildContext context, bool isDark, bool isEn) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.starGold.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.starGold.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.lock_outline_rounded, color: AppColors.starGold, size: 28),
          const SizedBox(height: 8),
          Text(
            isEn
                ? 'Unlock your full timeline with Pro'
                : 'Pro ile tüm zaman çizelgenizi açın',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => showContextualPaywall(
              context,
              ref,
              paywallContext: PaywallContext.patterns,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.starGold,
              foregroundColor: AppColors.deepSpace,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              isEn ? 'Upgrade to Pro' : 'Pro\'ya Yükselt',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
