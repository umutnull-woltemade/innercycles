// ════════════════════════════════════════════════════════════════════════════
// JOURNAL QUERY SCREEN - "Ask Your Journal" local search with insight
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

class JournalQueryScreen extends ConsumerStatefulWidget {
  const JournalQueryScreen({super.key});

  @override
  ConsumerState<JournalQueryScreen> createState() => _JournalQueryScreenState();
}

class _JournalQueryScreenState extends ConsumerState<JournalQueryScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  List<_QueryResult> _results = [];
  String? _insight;
  bool _hasSearched = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _search(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _insight = null;
        _hasSearched = false;
      });
      return;
    }

    final service = ref.read(journalServiceProvider).valueOrNull;
    if (service == null) return;

    final entries = service.getAllEntries();
    final lowerQuery = query.toLowerCase();
    final matches = <_QueryResult>[];

    for (final entry in entries) {
      final noteMatch =
          entry.note?.toLowerCase().contains(lowerQuery) ?? false;
      final tagMatch =
          entry.tags.any((t) => t.toLowerCase().contains(lowerQuery));
      final areaMatch = entry.focusArea.name.toLowerCase().contains(lowerQuery);

      if (noteMatch || tagMatch || areaMatch) {
        String? snippet;
        if (noteMatch && entry.note != null) {
          final idx = entry.note!.toLowerCase().indexOf(lowerQuery);
          final start = (idx - 30).clamp(0, entry.note!.length);
          final end = (idx + query.length + 30).clamp(0, entry.note!.length);
          snippet =
              '${start > 0 ? '...' : ''}${entry.note!.substring(start, end)}${end < entry.note!.length ? '...' : ''}';
        }
        matches.add(_QueryResult(entry: entry, snippet: snippet));
      }
    }

    // Generate insight
    String? insightText;
    if (matches.isNotEmpty) {
      final avgRating =
          matches.fold<int>(0, (s, r) => s + r.entry.overallRating) /
              matches.length;
      final areaCounts = <FocusArea, int>{};
      for (final m in matches) {
        areaCounts[m.entry.focusArea] =
            (areaCounts[m.entry.focusArea] ?? 0) + 1;
      }
      final topArea = (areaCounts.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value)))
          .first
          .key;

      final isEn = ref.read(languageProvider) == AppLanguage.en;

      if (isEn) {
        insightText =
            'Found ${matches.length} entries about "$query". Average rating: ${avgRating.toStringAsFixed(1)}/5. Most often in ${topArea.name} entries.';
      } else {
        insightText =
            '"$query" ile ilgili ${matches.length} kayıt bulundu. Ortalama puan: ${avgRating.toStringAsFixed(1)}/5. En çok ${topArea.name} alanında.';
      }
    }

    setState(() {
      _results = matches;
      _insight = insightText;
      _hasSearched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn =
        ref.watch(languageProvider) == AppLanguage.en;

    final suggestedQuestions = isEn
        ? [
            'When am I most creative?',
            'What triggers my best mood?',
            'How do I feel about work?',
            'What patterns do I see?',
          ]
        : [
            'En yaratıcı ne zaman oluyorum?',
            'Ruh halimi en çok ne yükseltiyor?',
            'İş hakkında ne hissediyorum?',
            'Hangi örüntüleri görüyorum?',
          ];

    return Scaffold(
      body: CosmicBackground(
        child: GestureDetector(
          onTap: () => _focusNode.unfocus(),
          child: CustomScrollView(
          slivers: [
            GlassSliverAppBar(
              title: isEn ? 'Ask Your Journal' : 'Günlüğüne Sor',
            ),
            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: (isDark ? Colors.white : Colors.black)
                        .withValues(alpha: 0.06),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onSubmitted: _search,
                    style: AppTypography.subtitle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: isEn
                          ? 'Search your entries...'
                          : 'Kayıtlarında ara...',
                      hintStyle: AppTypography.subtitle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                      prefixIcon: Icon(Icons.search_rounded,
                          color: AppColors.amethyst),
                      suffixIcon: _controller.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear_rounded,
                                  size: 18,
                                  color: isDark
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted),
                              onPressed: () {
                                _controller.clear();
                                _search('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ),
            ),

            // Suggested questions (shown when no search)
            if (!_hasSearched)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEn ? 'Try asking' : 'Şunları dene',
                        style: AppTypography.subtitle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: suggestedQuestions.map((q) {
                          // Extract keyword from question
                          final words = q
                              .replaceAll(RegExp(r'[?.!]'), '')
                              .split(' ')
                              .where((w) => w.length > 3)
                              .toList();
                          final keyword = words.isNotEmpty
                              ? words.last
                              : q.split(' ').last;
                          return GestureDetector(
                            onTap: () {
                              _controller.text = keyword;
                              _search(keyword);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: (isDark ? Colors.white : Colors.black)
                                    .withValues(alpha: 0.05),
                                border: Border.all(
                                  color: (isDark ? Colors.white : Colors.black)
                                      .withValues(alpha: 0.06),
                                ),
                              ),
                              child: Text(
                                q,
                                style: AppTypography.subtitle(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.textSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms),
              ),

            // Insight bubble
            if (_insight != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.amethyst.withValues(alpha: 0.12),
                          AppColors.auroraStart.withValues(alpha: 0.08),
                        ],
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.auto_awesome_rounded,
                            size: 16, color: AppColors.amethyst),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _insight!,
                            style: AppTypography.subtitle(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 300.ms),
              ),

            // No results
            if (_hasSearched && _results.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      isEn
                          ? 'No entries found for that query.'
                          : 'Bu sorgu için kayıt bulunamadı.',
                      style: AppTypography.subtitle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ),
                ),
              ),

            // Results
            if (_results.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final result = _results[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 4),
                      child: GestureDetector(
                        onTap: () => context.push(
                          Routes.journalEntryDetail
                              .replaceFirst(':id', result.entry.id),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(14),
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
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _focusAreaColor(
                                          result.entry.focusArea),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${result.entry.focusArea.name[0].toUpperCase()}${result.entry.focusArea.name.substring(1)} · ${result.entry.overallRating}/5',
                                      style: AppTypography.subtitle(
                                        fontSize: 13,
                                        color: isDark
                                            ? AppColors.textPrimary
                                            : AppColors.lightTextPrimary,
                                      ).copyWith(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Text(
                                    '${result.entry.date.day}/${result.entry.date.month}/${result.entry.date.year}',
                                    style: AppTypography.subtitle(
                                      fontSize: 11,
                                      color: isDark
                                          ? AppColors.textMuted
                                          : AppColors.lightTextMuted,
                                    ),
                                  ),
                                ],
                              ),
                              if (result.snippet != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  result.snippet!,
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
                              if (result.entry.tags.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 6,
                                  children: result.entry.tags.take(3).map((t) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8),
                                        color:
                                            (isDark ? Colors.white : Colors.black)
                                                .withValues(alpha: 0.06),
                                      ),
                                      child: Text(
                                        '#$t',
                                        style: AppTypography.subtitle(
                                          fontSize: 10,
                                          color: AppColors.amethyst,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(
                        delay: (30 * index).ms, duration: 200.ms);
                  },
                  childCount: _results.length,
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
      ),
    );
  }

  Color _focusAreaColor(FocusArea area) {
    switch (area) {
      case FocusArea.energy:
        return const Color(0xFFC8553D);
      case FocusArea.focus:
        return const Color(0xFF6B8FB5);
      case FocusArea.emotions:
        return const Color(0xFFB5727A);
      case FocusArea.decisions:
        return const Color(0xFF7EB8A8);
      case FocusArea.social:
        return const Color(0xFF9B8EC4);
    }
  }
}

class _QueryResult {
  final JournalEntry entry;
  final String? snippet;

  const _QueryResult({required this.entry, this.snippet});
}
