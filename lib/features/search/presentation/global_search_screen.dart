// ════════════════════════════════════════════════════════════════════════════
// GLOBAL SEARCH - Search across journals, notes, dreams, and tools
// ════════════════════════════════════════════════════════════════════════════
// Unified search with tab filtering (All / Journal / Notes / Dreams).
// Shows tag cloud and recent searches when query is empty.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/models/note_to_self.dart';
import '../../../data/models/tool_manifest.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/dream_journal_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../data/services/l10n_service.dart';

enum _SearchTab { all, journal, notes, dreams }

class GlobalSearchScreen extends ConsumerStatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  ConsumerState<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends ConsumerState<GlobalSearchScreen> {
  static const _recentSearchesKey = 'recent_searches';

  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';
  _SearchTab _activeTab = _SearchTab.all;
  Timer? _debounce;
  List<String> _recentSearches = [];

  // Cached search results
  List<JournalEntry> _journalResults = [];
  List<NoteToSelf> _noteResults = [];
  List<DreamEntry> _dreamResults = [];
  List<ToolManifest> _toolResults = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _recentSearches = prefs.getStringList(_recentSearchesKey) ?? [];
    });
  }

  Future<void> _saveRecentSearch(String query) async {
    if (query.isEmpty) return;
    _recentSearches.remove(query);
    _recentSearches.insert(0, query);
    if (_recentSearches.length > 5) {
      _recentSearches = _recentSearches.sublist(0, 5);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_recentSearchesKey, _recentSearches);
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() => _query = value.trim());
      if (_query.isNotEmpty) _performSearch();
    });
  }

  Future<void> _performSearch() async {
    if (_query.isEmpty) return;
    _saveRecentSearch(_query);

    // Search journals
    final journalService = await ref.read(journalServiceProvider.future);
    final journals = journalService.searchEntries(_query);

    // Search notes
    final noteService = await ref.read(notesToSelfServiceProvider.future);
    final notes = noteService.searchNotes(_query);

    // Search dreams
    final dreamService = await ref.read(dreamJournalServiceProvider.future);
    final dreams = await dreamService.searchDreams(_query);

    // Search tools
    final q = _query.toLowerCase();
    final tools = ToolManifestRegistry.all.where((tool) {
      return tool.nameEn.toLowerCase().contains(q) ||
          tool.nameTr.toLowerCase().contains(q) ||
          tool.valuePropositionEn.toLowerCase().contains(q) ||
          tool.valuePropositionTr.toLowerCase().contains(q);
    }).toList();

    if (!mounted) return;
    setState(() {
      _journalResults = journals;
      _noteResults = notes;
      _dreamResults = dreams;
      _toolResults = tools;
    });
  }

  int get _totalResults =>
      _journalResults.length +
      _noteResults.length +
      _dreamResults.length +
      _toolResults.length;

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;

    return Scaffold(
      backgroundColor: isDark ? AppColors.deepSpace : AppColors.lightBackground,
      body: CosmicBackground(
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                // Search bar + close button
                Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingLg),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusLg),
                            color: isDark
                                ? AppColors.surfaceDark
                                    .withValues(alpha: 0.6)
                                : AppColors.lightSurfaceVariant,
                            border: Border.all(
                              color: isDark
                                  ? AppColors.surfaceLight
                                      .withValues(alpha: 0.3)
                                  : AppColors.lightSurfaceVariant,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            focusNode: _focusNode,
                            onChanged: _onQueryChanged,
                            style: AppTypography.subtitle(
                              fontSize: 15,
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: L10nService.get('search.global_search.search_entries_notes_dreams', language),
                              hintStyle: AppTypography.subtitle(
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                              suffixIcon: _query.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.clear_rounded,
                                        size: 18,
                                        color: isDark
                                            ? AppColors.textMuted
                                            : AppColors.lightTextMuted,
                                      ),
                                      tooltip: L10nService.get('search.global_search.clear_search', language),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {
                                          _query = '';
                                          _journalResults = [];
                                          _noteResults = [];
                                          _dreamResults = [];
                                          _toolResults = [];
                                        });
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.spacingLg,
                                vertical: AppConstants.spacingMd,
                              ),
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 300.ms)
                            .slideX(begin: -0.05, end: 0, duration: 300.ms),
                      ),
                      const SizedBox(width: AppConstants.spacingSm),
                      IconButton(
                        tooltip: L10nService.get('search.global_search.close_search', language),
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close_rounded,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Tab bar (only when searching)
                if (_query.isNotEmpty) _buildTabBar(isDark, isEn),

                // Content
                Expanded(
                  child: _query.isEmpty
                      ? _buildEmptyState(isDark, isEn)
                      : _totalResults == 0
                          ? _buildNoResults(isDark, isEn)
                          : _buildSearchResults(isDark, isEn),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(bool isDark, AppLanguage language) {
    final tabs = [
      (
        _SearchTab.all,
        L10nService.get('search.global_search.all', language),
        _totalResults,
      ),
      (
        _SearchTab.journal,
        L10nService.get('search.global_search.journal', language),
        _journalResults.length,
      ),
      (
        _SearchTab.notes,
        L10nService.get('search.global_search.notes', language),
        _noteResults.length,
      ),
      (
        _SearchTab.dreams,
        L10nService.get('search.global_search.dreams', language),
        _dreamResults.length,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: tabs.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final (tab, label, count) = tabs[index];
            final isActive = _activeTab == tab;
            return GestureDetector(
              onTap: () => setState(() => _activeTab = tab),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.starGold.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isActive
                        ? AppColors.starGold.withValues(alpha: 0.5)
                        : (isDark ? Colors.white : Colors.black)
                            .withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  count > 0 ? '$label ($count)' : label,
                  style: AppTypography.subtitle(
                    fontSize: 13,
                    color: isActive
                        ? AppColors.starGold
                        : (isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ).animate().fadeIn(duration: 200.ms);
  }

  Widget _buildEmptyState(bool isDark, AppLanguage language) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tag cloud
          _TagCloudSection(isDark: isDark, language: language, onTagTapped: (tag) {
            _searchController.text = tag;
            _onQueryChanged(tag);
          }),

          // Recent searches
          if (_recentSearches.isNotEmpty) ...[
            const SizedBox(height: 24),
            GradientText(
              L10nService.get('search.global_search.recent_searches', language),
              variant: GradientTextVariant.gold,
              style: AppTypography.elegantAccent(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            ..._recentSearches.map(
              (search) => GestureDetector(
                onTap: () {
                  _searchController.text = search;
                  _onQueryChanged(search);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history_rounded,
                        size: 16,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        search,
                        style: AppTypography.subtitle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],

          // Quick actions
          const SizedBox(height: 24),
          GradientText(
            L10nService.get('search.global_search.quick_actions', language),
            variant: GradientTextVariant.aurora,
            style: AppTypography.elegantAccent(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          ..._getQuickActions().toList().asMap().entries.map((entry) {
            final tool = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: _ToolResultTile(tool: tool, isDark: isDark, language: language)
                  .animate()
                  .fadeIn(
                    delay: Duration(milliseconds: 150 + entry.key * 40),
                    duration: 300.ms,
                  ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSearchResults(bool isDark, AppLanguage language) {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      children: [
        // Journal results
        if ((_activeTab == _SearchTab.all || _activeTab == _SearchTab.journal) &&
            _journalResults.isNotEmpty) ...[
          _buildSectionHeader(
            isDark,
            L10nService.get('search.global_search.journal_entries', language),
            _journalResults.length,
            GradientTextVariant.gold,
          ),
          const SizedBox(height: 8),
          ..._journalResults.take(10).toList().asMap().entries.map((entry) {
            final e = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _JournalResultTile(entry: e, isDark: isDark, language: language)
                  .animate()
                  .fadeIn(
                    delay: Duration(milliseconds: entry.key * 30),
                    duration: 250.ms,
                  ),
            );
          }),
          const SizedBox(height: 16),
        ],

        // Note results
        if ((_activeTab == _SearchTab.all || _activeTab == _SearchTab.notes) &&
            _noteResults.isNotEmpty) ...[
          _buildSectionHeader(
            isDark,
            L10nService.get('search.global_search.notes_1', language),
            _noteResults.length,
            GradientTextVariant.amethyst,
          ),
          const SizedBox(height: 8),
          ..._noteResults.take(10).toList().asMap().entries.map((entry) {
            final n = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _NoteResultTile(note: n, isDark: isDark, language: language)
                  .animate()
                  .fadeIn(
                    delay: Duration(milliseconds: entry.key * 30),
                    duration: 250.ms,
                  ),
            );
          }),
          const SizedBox(height: 16),
        ],

        // Dream results
        if ((_activeTab == _SearchTab.all || _activeTab == _SearchTab.dreams) &&
            _dreamResults.isNotEmpty) ...[
          _buildSectionHeader(
            isDark,
            L10nService.get('search.global_search.dreams_1', language),
            _dreamResults.length,
            GradientTextVariant.cosmic,
          ),
          const SizedBox(height: 8),
          ..._dreamResults.take(10).toList().asMap().entries.map((entry) {
            final d = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _DreamResultTile(dream: d, isDark: isDark, language: language)
                  .animate()
                  .fadeIn(
                    delay: Duration(milliseconds: entry.key * 30),
                    duration: 250.ms,
                  ),
            );
          }),
          const SizedBox(height: 16),
        ],

        // Tool results
        if (_activeTab == _SearchTab.all && _toolResults.isNotEmpty) ...[
          _buildSectionHeader(
            isDark,
            L10nService.get('search.global_search.tools', language),
            _toolResults.length,
            GradientTextVariant.aurora,
          ),
          const SizedBox(height: 8),
          ..._toolResults.take(5).map(
                (tool) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child:
                      _ToolResultTile(tool: tool, isDark: isDark, language: language),
                ),
              ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(
    bool isDark,
    String title,
    int count,
    GradientTextVariant variant,
  ) {
    return Row(
      children: [
        GradientText(
          title.toUpperCase(),
          variant: variant,
          style: AppTypography.elegantAccent(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '($count)',
          style: AppTypography.subtitle(
            fontSize: 12,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildNoResults(bool isDark, AppLanguage language) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: isDark
                ? AppColors.textMuted.withValues(alpha: 0.4)
                : AppColors.lightTextMuted.withValues(alpha: 0.4),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Text(
            L10nService.get('search.global_search.nothing_matched_try_different_words', language),
            style: AppTypography.subtitle(
              fontSize: 16,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 120.ms);
  }

  List<ToolManifest> _getQuickActions() {
    const quickIds = [
      'journal',
      'gratitude',
      'breathing',
      'dreamInterpretation',
      'patterns',
      'quizHub',
      'challenges',
      'wellness',
    ];
    return quickIds
        .map((id) => ToolManifestRegistry.findById(id))
        .whereType<ToolManifest>()
        .toList();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TAG CLOUD — shows all tags from journals + notes when query is empty
// ═══════════════════════════════════════════════════════════════════════════

class _TagCloudSection extends ConsumerWidget {
  final bool isDark;
  final AppLanguage language;
  bool get isEn => language.isEn;
  final ValueChanged<String> onTagTapped;

  const _TagCloudSection({
    required this.isDark,
    required this.language,
    required this.onTagTapped,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalAsync = ref.watch(journalServiceProvider);
    final notesAsync = ref.watch(notesToSelfServiceProvider);

    final journalTags =
        journalAsync.whenOrNull(data: (s) => s.getAllTags()) ?? [];
    final noteTags = notesAsync.whenOrNull(data: (s) => s.getAllTags()) ?? [];

    final allTags = {...journalTags, ...noteTags}.toList()..sort();
    if (allTags.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          L10nService.get('search.global_search.tags', language),
          variant: GradientTextVariant.gold,
          style: AppTypography.elegantAccent(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allTags
              .take(20)
              .map(
                (tag) => GestureDetector(
                  onTap: () => onTagTapped(tag),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.starGold.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.starGold.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      tag,
                      style: AppTypography.subtitle(
                        fontSize: 13,
                        color: AppColors.starGold,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    ).animate().fadeIn(delay: 100.ms, duration: 300.ms);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// RESULT TILES
// ═══════════════════════════════════════════════════════════════════════════

class _JournalResultTile extends StatelessWidget {
  final JournalEntry entry;
  final bool isDark;
  final AppLanguage language;
  bool get isEn => language.isEn;

  const _JournalResultTile({
    required this.entry,
    required this.isDark,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final areaName =
        entry.focusArea.localizedName(isEn);
    final dateStr =
        '${entry.date.day}.${entry.date.month}.${entry.date.year}';
    final preview = entry.note?.length != null && entry.note!.length > 80
        ? '${entry.note!.substring(0, 80)}...'
        : entry.note ?? '';

    return GestureDetector(
      onTap: () =>
          context.push(Routes.journalEntryDetail.replaceFirst(':id', entry.id)),
      child: PremiumCard(
        style: PremiumCardStyle.subtle,
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Focus area accent
            Container(
              width: 3,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: _focusAreaColor(entry.focusArea),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '$areaName  \u2022  $dateStr',
                        style: AppTypography.subtitle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${entry.overallRating}/5',
                        style: AppTypography.modernAccent(
                          fontSize: 12,
                          color: AppColors.starGold,
                        ),
                      ),
                    ],
                  ),
                  if (preview.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      preview,
                      style: AppTypography.subtitle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (entry.tags.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      children: entry.tags
                          .take(3)
                          .map(
                            (t) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.starGold.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                t,
                                style: AppTypography.subtitle(
                                  fontSize: 10,
                                  color: AppColors.starGold,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color _focusAreaColor(FocusArea area) {
    switch (area) {
      case FocusArea.energy:
        return AppColors.starGold;
      case FocusArea.focus:
        return AppColors.auroraStart;
      case FocusArea.emotions:
        return AppColors.amethyst;
      case FocusArea.decisions:
        return Colors.green;
      case FocusArea.social:
        return AppColors.chartPurple;
    }
  }
}

class _NoteResultTile extends StatelessWidget {
  final NoteToSelf note;
  final bool isDark;
  final AppLanguage language;
  bool get isEn => language.isEn;

  const _NoteResultTile({
    required this.note,
    required this.isDark,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final preview = note.content.length > 80
        ? '${note.content.substring(0, 80)}...'
        : note.content;

    return GestureDetector(
      onTap: () => context.push(Routes.noteDetail, extra: {'noteId': note.id}),
      child: PremiumCard(
        style: PremiumCardStyle.subtle,
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              note.isPinned ? Icons.push_pin_rounded : Icons.sticky_note_2_outlined,
              size: 18,
              color: AppColors.amethyst,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: AppTypography.displayFont.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (preview.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      preview,
                      style: AppTypography.subtitle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (note.tags.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      children: note.tags
                          .take(3)
                          .map(
                            (t) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.amethyst.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                t,
                                style: AppTypography.subtitle(
                                  fontSize: 10,
                                  color: AppColors.amethyst,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DreamResultTile extends StatelessWidget {
  final DreamEntry dream;
  final bool isDark;
  final AppLanguage language;
  bool get isEn => language.isEn;

  const _DreamResultTile({
    required this.dream,
    required this.isDark,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final preview = dream.content.length > 80
        ? '${dream.content.substring(0, 80)}...'
        : dream.content;
    final dateStr =
        '${dream.dreamDate.day}.${dream.dreamDate.month}.${dream.dreamDate.year}';

    return GestureDetector(
      onTap: () => context.push(Routes.dreamInterpretation),
      child: PremiumCard(
        style: PremiumCardStyle.subtle,
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.nightlight_round,
              size: 18,
              color: isDark ? AppColors.starGold : AppColors.lightStarGold,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dream.title,
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        dateStr,
                        style: AppTypography.subtitle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    preview,
                    style: AppTypography.subtitle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (dream.userTags.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      children: dream.userTags
                          .take(3)
                          .map(
                            (t) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.starGold.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                t,
                                style: AppTypography.subtitle(
                                  fontSize: 10,
                                  color: AppColors.starGold,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolResultTile extends StatelessWidget {
  final ToolManifest tool;
  final bool isDark;
  final AppLanguage language;
  bool get isEn => language.isEn;

  const _ToolResultTile({
    required this.tool,
    required this.isDark,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isEn ? tool.nameEn : tool.nameTr,
      hint: L10nService.get('search.global_search.double_tap_to_open', language),
      button: true,
      child: GestureDetector(
        onTap: () => context.go(tool.route),
        child: PremiumCard(
          style: PremiumCardStyle.subtle,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
            vertical: AppConstants.spacingMd,
          ),
          child: Row(
            children: [
              Text(tool.icon, style: AppTypography.subtitle(fontSize: 24)),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEn ? tool.nameEn : tool.nameTr,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      isEn
                          ? tool.valuePropositionEn
                          : tool.valuePropositionTr,
                      style: AppTypography.decorativeScript(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
