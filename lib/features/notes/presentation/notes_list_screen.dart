// ════════════════════════════════════════════════════════════════════════════
// NOTES LIST SCREEN - A++ Tab-Level Notes to Self Browser
// ════════════════════════════════════════════════════════════════════════════
// Primary tab screen — search, filter, pin, swipe-to-delete, rich cards,
// animated empty state, note count header, staggered entrance animations.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/common_strings.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/note_to_self.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/haptic_service.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/premium_empty_state.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_dialog.dart';
import '../../../data/services/l10n_service.dart';

class NotesListScreen extends ConsumerStatefulWidget {
  const NotesListScreen({super.key});

  @override
  ConsumerState<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends ConsumerState<NotesListScreen> {
  String _searchQuery = '';
  String? _selectedTag;
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  Timer? _searchDebounce;
  bool _isSearchActive = false;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _searchQuery = value.trim().toLowerCase());
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _isSearchActive = false;
    });
    _searchFocus.unfocus();
  }

  List<NoteToSelf> _filterNotes(List<NoteToSelf> notes) {
    var filtered = notes;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (n) =>
                n.title.toLowerCase().contains(_searchQuery) ||
                n.content.toLowerCase().contains(_searchQuery) ||
                n.tags.any((t) => t.toLowerCase().contains(_searchQuery)),
          )
          .toList();
    }

    if (_selectedTag != null) {
      filtered = filtered
          .where(
            (n) => n.tags.any(
              (t) => t.toLowerCase() == _selectedTag!.toLowerCase(),
            ),
          )
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notesAsync = ref.watch(allNotesProvider);

    return Scaffold(
      body: CosmicBackground(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          behavior: HitTestBehavior.opaque,
          child: notesAsync.when(
            loading: () => const CosmicLoadingIndicator(),
            error: (_, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    L10nService.get('notes.notes_list.couldnt_load_your_notes', language),
                    textAlign: TextAlign.center,
                    style: AppTypography.decorativeScript(
                      color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () =>
                        ref.invalidate(allNotesProvider),
                    icon: Icon(Icons.refresh_rounded,
                        size: 16, color: AppColors.starGold),
                    label: Text(
                      L10nService.get('notes.notes_list.retry', language),
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
            data: (allNotes) {
              final filtered = _filterNotes(allNotes);
              final pinned = <NoteToSelf>[];
              final unpinned = <NoteToSelf>[];
              for (final n in filtered) {
                (n.isPinned ? pinned : unpinned).add(n);
              }

              // Collect all tags
              final allTags = <String>{};
              for (final note in allNotes) {
                allTags.addAll(note.tags);
              }

              return CupertinoScrollbar(
                child: CustomScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    GlassSliverAppBar(
                      title: L10nService.get('notes.notes_list.notes', language),
                      showBackButton: false,
                    ),

                    // ═══════════════════════════════════════════════════
                    // STATS HEADER
                    // ═══════════════════════════════════════════════════
                    if (allNotes.isNotEmpty)
                      SliverToBoxAdapter(
                        child: _NotesStatsBar(
                          total: allNotes.length,
                          pinnedCount: allNotes.where((n) => n.isPinned).length,
                          tagCount: allTags.length,
                          isDark: isDark,
                          isEn: isEn,
                        ).animate().fadeIn(duration: 400.ms),
                      ),

                    // ═══════════════════════════════════════════════════
                    // SEARCH BAR
                    // ═══════════════════════════════════════════════════
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                        child: Container(
                          decoration: BoxDecoration(
                            color: (isDark ? Colors.white : Colors.black)
                                .withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(14),
                            border: _isSearchActive
                                ? Border.all(
                                    color: AppColors.auroraStart.withValues(
                                      alpha: 0.3,
                                    ),
                                    width: 1,
                                  )
                                : null,
                          ),
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocus,
                            onChanged: _onSearchChanged,
                            onTap: () => setState(() => _isSearchActive = true),
                            style: AppTypography.subtitle(
                              fontSize: 14,
                              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: L10nService.get('notes.notes_list.search_notes', language),
                              hintStyle: AppTypography.subtitle(
                                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                              ),
                              prefixIcon: Icon(
                                CupertinoIcons.search,
                                size: 18,
                                color: _isSearchActive
                                    ? AppColors.auroraStart
                                    : (isDark
                                          ? AppColors.textMuted
                                          : AppColors.lightTextMuted),
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        CupertinoIcons.xmark_circle_fill,
                                        size: 18,
                                        color: isDark
                                            ? AppColors.textMuted
                                            : AppColors.lightTextMuted,
                                      ),
                                      tooltip: L10nService.get('notes.notes_list.clear_search', language),
                                      onPressed: _clearSearch,
                                    )
                                  : null,
                              isDense: true,
                              filled: false,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 13,
                              ),
                            ),
                          ),
                        ),
                      ).animate().fadeIn(duration: 350.ms, delay: 50.ms),
                    ),

                    // ═══════════════════════════════════════════════════
                    // TAG FILTER CHIPS
                    // ═══════════════════════════════════════════════════
                    if (allTags.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
                          child: SizedBox(
                            height: 36,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _TagChip(
                                  label: L10nService.get('notes.notes_list.all', language),
                                  isSelected: _selectedTag == null,
                                  isDark: isDark,
                                  onTap: () =>
                                      setState(() => _selectedTag = null),
                                ),
                                const SizedBox(width: 8),
                                ...allTags.map(
                                  (tag) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: _TagChip(
                                      label: tag,
                                      isSelected: _selectedTag == tag,
                                      isDark: isDark,
                                      onTap: () => setState(() {
                                        _selectedTag = _selectedTag == tag
                                            ? null
                                            : tag;
                                      }),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(duration: 350.ms, delay: 100.ms),
                      ),

                    const SliverToBoxAdapter(child: SizedBox(height: 8)),

                    // ═══════════════════════════════════════════════════
                    // EMPTY STATE
                    // ═══════════════════════════════════════════════════
                    if (filtered.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _EmptyState(
                          hasNotes: allNotes.isNotEmpty,
                          isEn: isEn,
                          isDark: isDark,
                          onCreate: () {
                            HapticService.buttonPress();
                            context.push(Routes.noteCreate);
                          },
                        ),
                      ),

                    // ═══════════════════════════════════════════════════
                    // PINNED SECTION
                    // ═══════════════════════════════════════════════════
                    if (pinned.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: _SectionHeader(
                          icon: CupertinoIcons.pin_fill,
                          iconColor: AppColors.starGold,
                          label: L10nService.get('notes.notes_list.pinned', language),
                          isDark: isDark,
                        ).animate().fadeIn(duration: 300.ms, delay: 120.ms),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              _NoteCard(
                                    note: pinned[index],
                                    isEn: isEn,
                                    isDark: isDark,
                                    onTap: () => _openNote(pinned[index].id),
                                    onDelete: () =>
                                        _deleteNote(pinned[index].id),
                                  )
                                  .animate()
                                  .fadeIn(
                                    delay: (140 + index * 60).ms,
                                    duration: 350.ms,
                                  )
                                  .slideX(
                                    begin: -0.02,
                                    end: 0,
                                    duration: 350.ms,
                                  ),
                          childCount: pinned.length,
                        ),
                      ),
                    ],

                    // ═══════════════════════════════════════════════════
                    // RECENT SECTION
                    // ═══════════════════════════════════════════════════
                    if (unpinned.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child:
                            _SectionHeader(
                              icon: CupertinoIcons.clock,
                              iconColor: AppColors.auroraStart,
                              label: L10nService.get('notes.notes_list.recent', language),
                              isDark: isDark,
                            ).animate().fadeIn(
                              duration: 300.ms,
                              delay: pinned.isNotEmpty ? 200.ms : 120.ms,
                            ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              _NoteCard(
                                    note: unpinned[index],
                                    isEn: isEn,
                                    isDark: isDark,
                                    onTap: () => _openNote(unpinned[index].id),
                                    onDelete: () =>
                                        _deleteNote(unpinned[index].id),
                                  )
                                  .animate()
                                  .fadeIn(
                                    delay:
                                        ((pinned.isNotEmpty ? 220 : 140) +
                                                index * 60)
                                            .ms,
                                    duration: 350.ms,
                                  )
                                  .slideX(
                                    begin: -0.02,
                                    end: 0,
                                    duration: 350.ms,
                                  ),
                          childCount: unpinned.length,
                        ),
                      ),
                    ],

                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: _AnimatedFAB(
        isEn: isEn,
        isDark: isDark,
        onPressed: () {
          HapticService.buttonPress();
          context.push(Routes.noteCreate);
        },
      ),
    );
  }

  void _openNote(String noteId) {
    context.push(Routes.noteDetail, extra: {'noteId': noteId});
  }

  Future<void> _deleteNote(String noteId) async {
    final language = ref.read(languageProvider);

    final confirmed = await GlassDialog.confirm(
      context,
      title: L10nService.get('notes.notes_list.delete_note', language),
      message: L10nService.get('notes.notes_list.this_note_will_be_permanently_deleted', language),
      cancelLabel: L10nService.get('notes.notes_list.cancel', language),
      confirmLabel: L10nService.get('notes.notes_list.delete', language),
      isDestructive: true,
    );

    if (confirmed == true) {
      HapticService.buttonPress();
      final service = await ref.read(notesToSelfServiceProvider.future);
      await service.deleteNote(noteId);
      ref.invalidate(allNotesProvider);
      ref.invalidate(pinnedNotesProvider);
      ref.invalidate(upcomingRemindersProvider);
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════
// NOTES STATS BAR
// ═══════════════════════════════════════════════════════════════════════

class _NotesStatsBar extends StatelessWidget {
  final int total;
  final int pinnedCount;
  final int tagCount;
  final bool isDark;
  final bool isEn;

  const _NotesStatsBar({
    required this.total,
    required this.pinnedCount,
    required this.tagCount,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: Row(
        children: [
          _StatPill(
            icon: CupertinoIcons.doc_text,
            value: '$total',
            label: L10nService.get('notes.notes_list.notes_1', language),
            isDark: isDark,
          ),
          const SizedBox(width: 10),
          if (pinnedCount > 0) ...[
            _StatPill(
              icon: CupertinoIcons.pin_fill,
              value: '$pinnedCount',
              label: L10nService.get('notes.notes_list.pinned_1', language),
              isDark: isDark,
              accentColor: AppColors.starGold,
            ),
            const SizedBox(width: 10),
          ],
          if (tagCount > 0)
            _StatPill(
              icon: CupertinoIcons.tag,
              value: '$tagCount',
              label: L10nService.get('notes.notes_list.tags', language),
              isDark: isDark,
              accentColor: AppColors.amethyst,
            ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool isDark;
  final Color? accentColor;

  const _StatPill({
    required this.icon,
    required this.value,
    required this.label,
    required this.isDark,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? (isDark ? AppColors.textMuted : AppColors.lightTextMuted);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            '$value $label',
            style: AppTypography.subtitle(fontSize: 11, color: color),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// SECTION HEADER
// ═══════════════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool isDark;

  const _SectionHeader({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 6),
          GradientText(
            label,
            variant: GradientTextVariant.gold,
            style: AppTypography.elegantAccent(
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// EMPTY STATE
// ═══════════════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  final bool hasNotes;
  final bool isEn;
  final bool isDark;
  final VoidCallback onCreate;

  const _EmptyState({
    required this.hasNotes,
    required this.isEn,
    required this.isDark,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
    if (hasNotes) {
      // Filtered empty
      return PremiumEmptyState(
        icon: CupertinoIcons.search,
        title: L10nService.get('notes.notes_list.no_notes_matched_your_search', language),
        description: L10nService.get('notes.notes_list.try_a_different_search_term', language),
        gradientVariant: GradientTextVariant.aurora,
      );
    }

    // First-time empty — welcoming onboarding state
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Decorative icon cluster
            SizedBox(
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 0,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.auroraStart.withValues(alpha: 0.12),
                            AppColors.auroraEnd.withValues(alpha: 0.03),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    CupertinoIcons.pencil_outline,
                    size: 44,
                    color: isDark
                        ? AppColors.auroraStart.withValues(alpha: 0.6)
                        : AppColors.lightAuroraStart.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ).animate().scale(
              begin: const Offset(0.8, 0.8),
              duration: 600.ms,
              curve: Curves.elasticOut,
            ),
            const SizedBox(height: 20),
            Text(
              L10nService.get('notes.notes_list.capture_your_thoughts', language),
              style: AppTypography.displayFont.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              L10nService.get('notes.notes_list.quick_notes_reminders_ideas_neverything', language),
              style: AppTypography.decorativeScript(
                fontSize: 14,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            GestureDetector(
                  onTap: onCreate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.auroraStart, AppColors.auroraEnd],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.auroraStart.withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          CupertinoIcons.plus,
                          size: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          L10nService.get('notes.notes_list.write_your_first_note', language),
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 200.ms, duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms);
  }
}

// ═══════════════════════════════════════════════════════════════════════
// NOTE CARD — Glass-morphism style
// ═══════════════════════════════════════════════════════════════════════

class _NoteCard extends StatelessWidget {
  final NoteToSelf note;
  final bool isEn;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NoteCard({
    required this.note,
    required this.isEn,
    required this.isDark,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
    return Dismissible(
      key: ValueKey(note.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 28),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        child: const Icon(
          CupertinoIcons.trash,
          color: AppColors.error,
          size: 22,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: PremiumCard(
            style: PremiumCardStyle.subtle,
            borderRadius: AppConstants.radiusMd,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row with pin
                Row(
                  children: [
                    if (note.isPinned)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Icon(
                          CupertinoIcons.pin_fill,
                          size: 13,
                          color: AppColors.starGold,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        note.title.isEmpty
                            ? (L10nService.get('notes.notes_list.untitled', language))
                            : note.title,
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(note.updatedAt, isEn),
                      style: AppTypography.elegantAccent(
                        fontSize: 11,
                        color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),

                // Preview
                if (note.content.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    note.preview,
                    style: AppTypography.decorativeScript(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // Tags + mood row
                if (note.tags.isNotEmpty || note.moodAtCreation != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (note.moodAtCreation != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            note.moodAtCreation!,
                            style: AppTypography.subtitle(fontSize: 16),
                          ),
                        ),
                      ...note.tags
                          .take(3)
                          .map(
                            (tag) => Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.auroraStart.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                tag,
                                style: AppTypography.subtitle(
                                  fontSize: 10,
                                  color: isDark
                                      ? AppColors.auroraStart
                                      : AppColors.lightAuroraStart,
                                ),
                              ),
                            ),
                          ),
                      if (note.tags.length > 3)
                        Text(
                          '+${note.tags.length - 3}',
                          style: AppTypography.elegantAccent(
                            fontSize: 10,
                            color: isDark ? Colors.white38 : Colors.black26,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt, bool isEn) {
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) {
      return L10nService.get('notes.notes_list.now', language);
    }
    if (diff.inMinutes < 60) {
      return L10nService.getWithParams('common.time.minutes_short', language, params: {'count': '${diff.inMinutes}'});
    }
    if (diff.inHours < 24) {
      return L10nService.getWithParams('common.time.hours_short', language, params: {'count': '${diff.inHours}'});
    }
    if (diff.inDays < 7) {
      return L10nService.getWithParams('common.time.days_short', language, params: {'count': '${diff.inDays}'});
    }
    final months = isEn
        ? CommonStrings.monthsShortEn
        : CommonStrings.monthsShortTr;
    return '${dt.day} ${months[dt.month - 1]}';
  }
}

// ═══════════════════════════════════════════════════════════════════════
// TAG CHIP
// ═══════════════════════════════════════════════════════════════════════

class _TagChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _TagChip({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.buttonPress();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.auroraStart.withValues(alpha: 0.2)
              : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.auroraStart.withValues(alpha: 0.4)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: isSelected
              ? AppTypography.elegantAccent(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.auroraStart
                      : AppColors.lightAuroraStart,
                )
              : AppTypography.elegantAccent(
                  fontSize: 12,
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// ANIMATED FAB
// ═══════════════════════════════════════════════════════════════════════

class _AnimatedFAB extends StatelessWidget {
  final bool isEn;
  final bool isDark;
  final VoidCallback onPressed;

  const _AnimatedFAB({
    required this.isEn,
    required this.isDark,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
    return GestureDetector(
          onTap: onPressed,
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.auroraStart, AppColors.auroraEnd],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.auroraStart.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(CupertinoIcons.plus, size: 20, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  L10nService.get('notes.notes_list.new_note', language),
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: 300.ms)
        .slideY(begin: 0.3, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }
}
