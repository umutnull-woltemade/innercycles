import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/dream_journal_service.dart';
import '../../../data/services/gratitude_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

enum _ResultType { journal, dream, gratitude }

class _SearchResult {
  final _ResultType type;
  final String id;
  final String title;
  final String preview;
  final DateTime date;
  final dynamic raw;

  const _SearchResult({
    required this.type,
    required this.id,
    required this.title,
    required this.preview,
    required this.date,
    this.raw,
  });
}

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;
  String _query = '';
  List<_SearchResult> _results = [];
  bool _isSearching = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _query = value.trim());
        if (_query.isNotEmpty) {
          _performSearch();
        } else {
          setState(() {
            _results = [];
            _hasSearched = false;
          });
        }
      }
    });
  }

  Future<void> _performSearch() async {
    if (_query.isEmpty) return;
    setState(() => _isSearching = true);

    final results = <_SearchResult>[];

    final journalAsync = ref.read(journalServiceProvider);
    final dreamAsync = ref.read(dreamJournalServiceProvider);
    final gratitudeAsync = ref.read(gratitudeServiceProvider);

    final lowQuery = _query.toLowerCase();

    // Journal entries
    journalAsync.whenData((service) {
      final entries = service.getAllEntries();
      for (final entry in entries) {
        if (entry.note != null &&
            entry.note!.toLowerCase().contains(lowQuery)) {
          final focusLabel = entry.focusArea.displayNameEn;
          results.add(_SearchResult(
            type: _ResultType.journal,
            id: entry.id,
            title: '$focusLabel - ${entry.overallRating}/5',
            preview: entry.note!,
            date: entry.date,
            raw: entry,
          ));
        }
      }
    });

    // Dream entries
    if (dreamAsync.hasValue) {
      final dreamService = dreamAsync.value!;
      final dreams = await dreamService.searchByKeyword(_query);
      for (final dream in dreams) {
        results.add(_SearchResult(
          type: _ResultType.dream,
          id: dream.id,
          title: dream.title,
          preview: dream.content,
          date: dream.dreamDate,
          raw: dream,
        ));
      }
    }

    // Gratitude entries
    gratitudeAsync.whenData((service) {
      final entries = service.getAllEntries();
      for (final entry in entries) {
        final match = entry.items.any(
          (item) => item.toLowerCase().contains(lowQuery),
        );
        if (match) {
          results.add(_SearchResult(
            type: _ResultType.gratitude,
            id: entry.dateKey,
            title: entry.dateKey,
            preview: entry.items.join(', '),
            date: entry.createdAt,
            raw: entry,
          ));
        }
      }
    });

    results.sort((a, b) => b.date.compareTo(a.date));

    if (mounted) {
      setState(() {
        _results = results;
        _isSearching = false;
        _hasSearched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CupertinoScrollbar(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                GlassSliverAppBar(
                  title: isEn ? 'Search' : 'Ara',
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: _buildSearchBar(isDark, isEn),
                  ),
                ),
                if (_isSearching)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (!_hasSearched)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(isDark, isEn),
                  )
                else if (_results.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildNoResults(isDark, isEn),
                  )
                else
                  _buildResultsList(isDark, isEn),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDark, bool isEn) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: _onQueryChanged,
        style: TextStyle(
          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: isEn
              ? 'Search journals, dreams, gratitude...'
              : 'Günlük, rüya, minnettarlık ara...',
          hintStyle: TextStyle(
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.starGold,
            size: 22,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _controller.clear();
                    _onQueryChanged('');
                  },
                  icon: Icon(
                    Icons.close,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                    size: 20,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        textInputAction: TextInputAction.search,
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1, end: 0);
  }

  Widget _buildEmptyState(bool isDark, bool isEn) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.manage_search_rounded,
              size: 64,
              color: AppColors.starGold.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 20),
            Text(
              isEn
                  ? 'Search across all your entries'
                  : 'Tum kayitlariniz arasinda arayin',
              style: TextStyle(
                fontSize: 16,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isEn
                  ? 'Journals, dreams, and gratitude notes'
                  : 'Gunlukler, ruyalar ve minnettarlik notlari',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ].animate(interval: 80.ms).fadeIn(duration: 400.ms),
        ),
      ),
    );
  }

  Widget _buildNoResults(bool isDark, bool isEn) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 56,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
            const SizedBox(height: 16),
            Text(
              isEn ? 'No results found' : 'Sonuc bulunamadi',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isEn
                  ? 'Try a different keyword'
                  : 'Farkli bir anahtar kelime deneyin',
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ].animate(interval: 60.ms).fadeIn(duration: 300.ms),
        ),
      ),
    );
  }

  Widget _buildResultsList(bool isDark, bool isEn) {
    final journalResults =
        _results.where((r) => r.type == _ResultType.journal).toList();
    final dreamResults =
        _results.where((r) => r.type == _ResultType.dream).toList();
    final gratitudeResults =
        _results.where((r) => r.type == _ResultType.gratitude).toList();

    final sections = <Widget>[];

    if (journalResults.isNotEmpty) {
      sections.add(_buildSectionHeader(
        isEn ? 'Journal' : 'Gunluk',
        Icons.book_outlined,
        journalResults.length,
        isDark,
      ));
      for (final result in journalResults) {
        sections.add(_buildResultCard(result, isDark, isEn));
      }
    }

    if (dreamResults.isNotEmpty) {
      sections.add(_buildSectionHeader(
        isEn ? 'Dreams' : 'Ruyalar',
        Icons.nights_stay_outlined,
        dreamResults.length,
        isDark,
      ));
      for (final result in dreamResults) {
        sections.add(_buildResultCard(result, isDark, isEn));
      }
    }

    if (gratitudeResults.isNotEmpty) {
      sections.add(_buildSectionHeader(
        isEn ? 'Gratitude' : 'Minnettarlik',
        Icons.favorite_outline,
        gratitudeResults.length,
        isDark,
      ));
      for (final result in gratitudeResults) {
        sections.add(_buildResultCard(result, isDark, isEn));
      }
    }

    sections.add(const SizedBox(height: 40));

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => sections[index]
              .animate()
              .fadeIn(delay: (50 * index).ms, duration: 300.ms),
          childCount: sections.length,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    IconData icon,
    int count,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.starGold, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.starGold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.starGold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(_SearchResult result, bool isDark, bool isEn) {
    final dateStr =
        '${result.date.day}.${result.date.month}.${result.date.year}';

    IconData typeIcon;
    Color iconColor;
    switch (result.type) {
      case _ResultType.journal:
        typeIcon = Icons.book_outlined;
        iconColor = AppColors.auroraStart;
      case _ResultType.dream:
        typeIcon = Icons.nights_stay_outlined;
        iconColor = AppColors.amethyst;
      case _ResultType.gratitude:
        typeIcon = Icons.favorite_outline;
        iconColor = AppColors.starGold;
    }

    final preview = result.preview.length > 120
        ? '${result.preview.substring(0, 120)}...'
        : result.preview;

    final highlightedPreview = _highlightQuery(preview, _query, isDark);

    return GestureDetector(
      onTap: () => _onResultTap(result, isDark, isEn),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark.withValues(alpha: 0.85)
              : AppColors.lightCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(typeIcon, color: iconColor, size: 18),
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
                          result.title,
                          style: TextStyle(
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
                        dateStr,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  highlightedPreview,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _highlightQuery(String text, String query, bool isDark) {
    if (query.isEmpty) {
      return Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }

    final lowText = text.toLowerCase();
    final lowQuery = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final index = lowText.indexOf(lowQuery, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: TextStyle(
          color: AppColors.auroraStart,
          fontWeight: FontWeight.w600,
        ),
      ));
      start = index + query.length;
    }

    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: TextStyle(
          fontSize: 13,
          color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
        ),
        children: spans,
      ),
    );
  }

  void _onResultTap(_SearchResult result, bool isDark, bool isEn) {
    HapticFeedback.lightImpact();

    switch (result.type) {
      case _ResultType.journal:
        context.push('/journal/entry/${result.id}');
      case _ResultType.dream:
        _showDreamSheet(result.raw as DreamEntry, isDark, isEn);
      case _ResultType.gratitude:
        _showGratitudeSheet(result.raw as GratitudeEntry, isDark, isEn);
    }
  }

  void _showDreamSheet(DreamEntry dream, bool isDark, bool isEn) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.7,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.lightCard,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.nights_stay_outlined,
                            color: AppColors.amethyst,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              dream.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${dream.dreamDate.day}.${dream.dreamDate.month}.${dream.dreamDate.year}',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        dream.content,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                      if (dream.detectedSymbols.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: dream.detectedSymbols.map((symbol) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.amethyst.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                symbol,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.amethyst,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      if (dream.dominantEmotion.name.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              isEn ? 'Emotion: ' : 'Duygu: ',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                            Text(
                              dream.dominantEmotion.name,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.starGold,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showGratitudeSheet(GratitudeEntry entry, bool isDark, bool isEn) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.lightCard,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.favorite_outline,
                          color: AppColors.starGold,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          isEn ? 'Gratitude' : 'Minnettarlik',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      entry.dateKey,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...entry.items.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 6,
                              color: AppColors.starGold,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.4,
                                  color: isDark
                                      ? AppColors.textSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
