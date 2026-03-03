// ════════════════════════════════════════════════════════════════════════════
// EMOTIONAL TIMELINE SCREEN - Scrollable life story visualization
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/models/timeline_event.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/dream_journal_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

/// Derived provider: fetches all dream entries for the timeline
final _dreamEntriesProvider = FutureProvider<List<DreamEntry>>((ref) async {
  final service = await ref.watch(dreamJournalServiceProvider.future);
  return service.getAllDreams();
});

class EmotionalTimelineScreen extends ConsumerWidget {
  const EmotionalTimelineScreen({super.key});

  List<TimelineEvent> _aggregateEvents(WidgetRef ref) {
    final events = <TimelineEvent>[];

    // Journal entries
    final journalService = ref.watch(journalServiceProvider).valueOrNull;
    if (journalService != null) {
      for (final entry in journalService.getAllEntries()) {
        events.add(TimelineEvent(
          id: entry.id,
          date: entry.date,
          type: TimelineEventType.journal,
          title: entry.focusArea.name[0].toUpperCase() +
              entry.focusArea.name.substring(1),
          subtitle: entry.note != null && entry.note!.length > 60
              ? '${entry.note!.substring(0, 60)}...'
              : entry.note,
          color: TimelineEvent.colorForFocusArea(entry.focusArea),
          icon: _iconForFocusArea(entry.focusArea),
          rating: entry.overallRating,
          routeId: entry.id,
        ));
      }
    }

    // Mood entries
    final moodService = ref.watch(moodCheckinServiceProvider).valueOrNull;
    if (moodService != null) {
      for (final entry in moodService.getAllEntries()) {
        events.add(TimelineEvent(
          id: 'mood_${entry.date.millisecondsSinceEpoch}',
          date: entry.date,
          type: TimelineEventType.mood,
          title: 'Mood: ${entry.mood}/5',
          subtitle: entry.emoji,
          color: TimelineEvent.colorForMood(entry.mood),
          icon: Icons.mood_rounded,
          rating: entry.mood,
        ));
      }
    }

    // Life events
    final lifeEventService = ref.watch(lifeEventServiceProvider).valueOrNull;
    if (lifeEventService != null) {
      for (final event in lifeEventService.getAllEvents()) {
        events.add(TimelineEvent(
          id: event.id,
          date: event.date,
          type: TimelineEventType.lifeEvent,
          title: event.title,
          subtitle: event.note,
          color: AppColors.starGold,
          icon: Icons.star_rounded,
        ));
      }
    }

    // Dream entries
    final dreams = ref.watch(_dreamEntriesProvider).valueOrNull;
    if (dreams != null) {
      for (final dream in dreams) {
        final subtitle = dream.content.length > 60
            ? '${dream.content.substring(0, 60)}...'
            : dream.content;
        events.add(TimelineEvent(
          id: dream.id,
          date: dream.dreamDate,
          type: TimelineEventType.dream,
          title: dream.title,
          subtitle: subtitle,
          color: AppColors.amethyst,
          icon: Icons.nightlight_round,
        ));
      }
    }

    events.sort((a, b) => b.date.compareTo(a.date));
    return events;
  }

  IconData _iconForFocusArea(FocusArea area) {
    switch (area) {
      case FocusArea.energy:
        return Icons.bolt_rounded;
      case FocusArea.focus:
        return Icons.center_focus_strong_rounded;
      case FocusArea.emotions:
        return Icons.favorite_rounded;
      case FocusArea.decisions:
        return Icons.explore_rounded;
      case FocusArea.social:
        return Icons.people_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = ref.watch(languageProvider) == AppLanguage.en;
    final events = _aggregateEvents(ref);

    // Group by month
    final grouped = <String, List<TimelineEvent>>{};
    for (final e in events) {
      final key =
          '${e.date.year}-${e.date.month.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => []).add(e);
    }
    final sortedMonths = grouped.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      body: CosmicBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            GlassSliverAppBar(
              title: isEn ? 'Your Timeline' : 'Zaman Çizelgen',
            ),
          if (events.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  isEn
                      ? 'Start journaling to build your timeline'
                      : 'Zaman çizelgeni oluşturmak için yazmaya başla',
                  style: AppTypography.subtitle(
                    fontSize: 14,
                    color:
                        isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                ),
              ),
            )
          else
            ...sortedMonths.map((monthKey) {
              final parts = monthKey.split('-');
              final year = parts[0];
              final month = int.parse(parts[1]);
              final monthNames = isEn
                  ? [
                      '',
                      'January',
                      'February',
                      'March',
                      'April',
                      'May',
                      'June',
                      'July',
                      'August',
                      'September',
                      'October',
                      'November',
                      'December'
                    ]
                  : [
                      '',
                      'Ocak',
                      'Şubat',
                      'Mart',
                      'Nisan',
                      'Mayıs',
                      'Haziran',
                      'Temmuz',
                      'Ağustos',
                      'Eylül',
                      'Ekim',
                      'Kasım',
                      'Aralık'
                    ];

              return SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Month header
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(24, 20, 24, 8),
                      child: Text(
                        '${monthNames[month]} $year',
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    // Timeline events
                    ...grouped[monthKey]!.asMap().entries.map((entry) {
                      final i = entry.key;
                      final event = entry.value;
                      final isLast =
                          i == grouped[monthKey]!.length - 1;

                      return _TimelineNode(
                        event: event,
                        isLast: isLast,
                        isDark: isDark,
                        onTap: event.type == TimelineEventType.journal &&
                                event.routeId != null
                            ? () => context.push(
                                Routes.journalEntryDetail
                                    .replaceFirst(':id', event.routeId!))
                            : null,
                      )
                          .animate()
                          .fadeIn(
                              delay: (50 * i).ms,
                              duration: 300.ms);
                    }),
                  ],
                ),
              );
            }),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
        ),
      ),
    );
  }
}

class _TimelineNode extends StatelessWidget {
  final TimelineEvent event;
  final bool isLast;
  final bool isDark;
  final VoidCallback? onTap;

  const _TimelineNode({
    required this.event,
    required this.isLast,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline line + dot
              SizedBox(
                width: 32,
                child: Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: event.color,
                        boxShadow: [
                          BoxShadow(
                            color: event.color.withValues(alpha: 0.3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 1.5,
                          color: (isDark ? Colors.white : Colors.black)
                              .withValues(alpha: 0.08),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: (isDark ? Colors.white : Colors.black)
                        .withValues(alpha: 0.04),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(event.icon, size: 14, color: event.color),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              event.title,
                              style: AppTypography.subtitle(
                                fontSize: 13,
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                              ).copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            '${event.date.day}/${event.date.month}',
                            style: AppTypography.subtitle(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                      if (event.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          event.subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.subtitle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                      if (event.rating != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: List.generate(
                            5,
                            (i) => Padding(
                              padding: const EdgeInsets.only(right: 2),
                              child: Container(
                                width: 16,
                                height: 4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: i < event.rating!
                                      ? event.color
                                      : (isDark ? Colors.white : Colors.black)
                                          .withValues(alpha: 0.08),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
