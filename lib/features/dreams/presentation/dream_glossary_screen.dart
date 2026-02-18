/// Dream Symbol Glossary Screen - Kapsamli Ruya Sembolleri Sozlugu
/// Arama, kategori filtreleme, alfabe navigasyonu, kisisel sozluk
library;

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/cosmic_palette.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/dream_interpretation_models.dart';
import '../../../data/content/dream_symbols_database.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';
import '../../../shared/widgets/cosmic_background.dart';

// ============================================================================
// SCREEN
// ============================================================================

/// Ana ruya sembolleri sozluk ekrani
class DreamGlossaryScreen extends ConsumerStatefulWidget {
  const DreamGlossaryScreen({super.key});

  @override
  ConsumerState<DreamGlossaryScreen> createState() =>
      _DreamGlossaryScreenState();
}

class _DreamGlossaryScreenState extends ConsumerState<DreamGlossaryScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();

  late TabController _tabController;

  // Filter state
  SymbolCategory? _selectedCategory;
  String _searchQuery = '';
  String? _selectedLetter;
  Timer? _searchDebounce;

  // Personal dictionary
  final PersonalDictionaryService _personalDictionary =
      PersonalDictionaryService();

  // All symbols for searching
  List<DreamSymbolData> _filteredSymbols = [];

  // Alphabet letters (Turkish)
  static const List<String> _alphabet = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'R',
    'S',
    'T',
    'U',
    'V',
    'Y',
    'Z',
  ];

  // Categories with labels - built dynamically with language
  List<_CategoryItem> _buildCategories(AppLanguage language) => [
    _CategoryItem(
      null,
      L10nService.get('screens.dream_glossary.categories.all', language),
      '',
    ),
    _CategoryItem(
      SymbolCategory.hayvan,
      L10nService.get('screens.dream_glossary.categories.animals', language),
      '',
    ),
    _CategoryItem(
      SymbolCategory.dogaOlayi,
      L10nService.get('screens.dream_glossary.categories.nature', language),
      '',
    ),
    _CategoryItem(
      SymbolCategory.insan,
      L10nService.get('screens.dream_glossary.categories.people', language),
      '',
    ),
    _CategoryItem(
      SymbolCategory.mekan,
      L10nService.get('screens.dream_glossary.categories.places', language),
      '',
    ),
    _CategoryItem(
      SymbolCategory.eylem,
      L10nService.get('screens.dream_glossary.categories.actions', language),
      '',
    ),
    _CategoryItem(
      SymbolCategory.nesne,
      L10nService.get('screens.dream_glossary.categories.objects', language),
      '',
    ),
    _CategoryItem(
      SymbolCategory.soyut,
      L10nService.get('screens.dream_glossary.categories.abstract', language),
      '',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this); // 8 categories
    _tabController.addListener(_onTabChanged);
    _filterSymbols();
    _personalDictionary.init();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    HapticFeedback.lightImpact();
    final language = ref.read(languageProvider);
    final categories = _buildCategories(language);
    setState(() {
      _selectedCategory = categories[_tabController.index].category;
      _filterSymbols();
    });
  }

  void _filterSymbols() {
    var symbols = DreamSymbolsDatabase.allSymbols.toList();

    // Category filter
    if (_selectedCategory != null) {
      symbols = symbols.where((s) => s.category == _selectedCategory).toList();
    }

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      symbols = symbols.where((s) {
        return s.symbolTr.toLowerCase().contains(query) ||
            s.symbol.toLowerCase().contains(query) ||
            s.universalMeanings.any((m) => m.toLowerCase().contains(query));
      }).toList();
    }

    // Alphabet filter
    if (_selectedLetter != null) {
      symbols = symbols.where((s) {
        final firstLetter = s.symbolTr.isNotEmpty
            ? s.symbolTr[0].toUpperCase()
            : '';
        return firstLetter == _selectedLetter;
      }).toList();
    }

    // Sort alphabetically by Turkish name
    symbols.sort((a, b) => a.symbolTr.compareTo(b.symbolTr));

    setState(() {
      _filteredSymbols = symbols;
    });
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _searchQuery = value;
        _selectedLetter = null; // Clear letter filter when searching
        _filterSymbols();
      });
    });
  }

  void _onLetterSelected(String? letter) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedLetter = letter == _selectedLetter ? null : letter;
      _searchQuery = ''; // Clear search when selecting letter
      _searchController.clear();
      _filterSymbols();
    });
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _showSymbolDetails(DreamSymbolData symbol, AppLanguage language) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SymbolDetailSheet(
        symbol: symbol,
        personalDictionary: _personalDictionary,
        language: language,
        onDreamed: () {
          _personalDictionary.markAsDreamed(symbol.symbol);
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final categories = _buildCategories(language);

    return Scaffold(
      body: CosmicBackground(
        child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            behavior: HitTestBehavior.opaque,
            child: SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(context, language),

                // Search bar
                _buildSearchBar(language),

                // Category tabs
                _buildCategoryTabs(categories),

                // Content with alphabet sidebar
                Expanded(
                  child: Row(
                    children: [
                      // Main content
                      Expanded(child: _buildSymbolGrid(language)),

                      // Alphabet sidebar
                      _buildAlphabetSidebar(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            CosmicPalette.amethyst.withValues(alpha: 0.3),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            tooltip: language == AppLanguage.en ? 'Back' : 'Geri',
            icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  CosmicPalette.starGold.withValues(alpha: 0.5),
                  CosmicPalette.amethyst.withValues(alpha: 0.3),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Text(
              '\u{1F4D6}', // Open book emoji
              style: TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10nService.get('screens.dream_glossary.title', language),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  L10nService.get(
                    'screens.dream_glossary.symbol_count',
                    language,
                  ).replaceAll(
                    '{count}',
                    '${DreamSymbolsDatabase.allSymbols.length}',
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Personal dictionary button
          IconButton(
            onPressed: () => _showPersonalDictionary(language),
            icon: const Icon(Icons.bookmark, color: CosmicPalette.starGold),
            tooltip: L10nService.get(
              'screens.dream_glossary.personal_dictionary',
              language,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildSearchBar(AppLanguage language) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              CosmicPalette.amethyst.withValues(alpha: 0.15),
              CosmicPalette.bgCosmic.withValues(alpha: 0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          border: Border.all(
            color: CosmicPalette.amethyst.withValues(alpha: 0.3),
          ),
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          style: const TextStyle(color: AppColors.textPrimary),
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: L10nService.get(
              'screens.dream_glossary.search_hint',
              language,
            ),
            hintStyle: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.6),
            ),
            prefixIcon: const Icon(Icons.search, color: CosmicPalette.starGold),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    tooltip: language == AppLanguage.en
                        ? 'Clear search'
                        : 'Aramayı temizle',
                    icon: const Icon(
                      Icons.clear,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildCategoryTabs(List<_CategoryItem> categories) {
    return Container(
      height: 44,
      margin: const EdgeInsets.only(bottom: 8),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        indicatorColor: CosmicPalette.starGold,
        indicatorWeight: 3,
        labelColor: CosmicPalette.starGold,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 13,
        ),
        dividerColor: Colors.transparent,
        tabs: categories.map((cat) {
          return Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (cat.category != null) ...[
                  Text(
                    cat.category!.emoji,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                ],
                Text(cat.label),
              ],
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(delay: 150.ms);
  }

  Widget _buildSymbolGrid(AppLanguage language) {
    if (_filteredSymbols.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('\u{1F50D}', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              L10nService.get('screens.dream_glossary.no_results', language),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              L10nService.get(
                'screens.dream_glossary.try_different_search',
                language,
              ),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
      itemCount: _filteredSymbols.length,
      itemBuilder: (context, index) {
        final symbol = _filteredSymbols[index];
        final isDreamed = _personalDictionary.hasDreamed(symbol.symbol);

        return _SymbolCard(
              symbol: symbol,
              isDreamed: isDreamed,
              searchQuery: _searchQuery,
              onTap: () => _showSymbolDetails(symbol, language),
            )
            .animate()
            .fadeIn(delay: (30 * (index % 20)).ms)
            .slideX(begin: 0.1, end: 0, delay: (30 * (index % 20)).ms);
      },
    );
  }

  Widget _buildAlphabetSidebar() {
    return Container(
      width: 32,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _alphabet.length,
        itemBuilder: (context, index) {
          final letter = _alphabet[index];
          final isSelected = letter == _selectedLetter;

          return Semantics(
            label: letter,
            button: true,
            selected: isSelected,
            child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _onLetterSelected(letter),
            child: SizedBox(
              height: 44,
              child: Center(
                child: Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? CosmicPalette.starGold.withValues(alpha: 0.3)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? CosmicPalette.starGold
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
            ),
          );
        },
      ),
    );
  }

  void _showPersonalDictionary(AppLanguage language) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PersonalDictionarySheet(
        personalDictionary: _personalDictionary,
        language: language,
        onSymbolTap: (symbol) {
          Navigator.pop(context);
          _showSymbolDetails(symbol, language);
        },
      ),
    );
  }
}

// ============================================================================
// SYMBOL CARD
// ============================================================================

class _SymbolCard extends StatelessWidget {
  final DreamSymbolData symbol;
  final bool isDreamed;
  final String searchQuery;
  final VoidCallback onTap;

  const _SymbolCard({
    required this.symbol,
    required this.isDreamed,
    required this.searchQuery,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  CosmicPalette.amethyst.withValues(alpha: 0.15),
                  CosmicPalette.bgCosmic.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: isDreamed
                    ? CosmicPalette.starGold.withValues(alpha: 0.4)
                    : CosmicPalette.amethyst.withValues(alpha: 0.2),
                width: isDreamed ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                // Emoji
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        _getCategoryColor(
                          symbol.category,
                        ).withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    symbol.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildHighlightedText(
                              symbol.symbolTr,
                              searchQuery,
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (isDreamed) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: CosmicPalette.starGold.withValues(
                                  alpha: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '\u{2728}',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        symbol.universalMeanings.isNotEmpty
                            ? symbol.universalMeanings.first
                            : '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Arrow
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedText(String text, String query, TextStyle? style) {
    if (query.isEmpty) {
      return Text(text, style: style);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);

    if (index < 0) {
      return Text(text, style: style);
    }

    return RichText(
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: text.substring(0, index)),
          TextSpan(
            text: text.substring(index, index + query.length),
            style: TextStyle(
              backgroundColor: CosmicPalette.starGold.withValues(alpha: 0.3),
              color: CosmicPalette.starGold,
            ),
          ),
          TextSpan(text: text.substring(index + query.length)),
        ],
      ),
    );
  }

  Color _getCategoryColor(SymbolCategory category) {
    switch (category) {
      case SymbolCategory.hayvan:
        return CosmicPalette.auroraGreen;
      case SymbolCategory.dogaOlayi:
        return CosmicPalette.etherealCyan;
      case SymbolCategory.insan:
        return CosmicPalette.nebulaRose;
      case SymbolCategory.mekan:
        return CosmicPalette.stardustBlue;
      case SymbolCategory.eylem:
        return CosmicPalette.solarOrange;
      case SymbolCategory.nesne:
        return CosmicPalette.lavender;
      case SymbolCategory.soyut:
        return CosmicPalette.orchid;
    }
  }
}

// ============================================================================
// SYMBOL DETAIL SHEET
// ============================================================================

class _SymbolDetailSheet extends StatelessWidget {
  final DreamSymbolData symbol;
  final PersonalDictionaryService personalDictionary;
  final AppLanguage language;
  final VoidCallback onDreamed;

  const _SymbolDetailSheet({
    required this.symbol,
    required this.personalDictionary,
    required this.language,
    required this.onDreamed,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.85,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [CosmicPalette.bgCosmic, CosmicPalette.bgDeepSpace],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        CosmicPalette.starGold.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    symbol.emoji,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        symbol.symbolTr,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: CosmicPalette.amethyst.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              symbol.category.emoji,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              symbol.category.label,
                              style: const TextStyle(
                                color: CosmicPalette.lavender,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // Universal meanings
                _buildSection(
                  context,
                  title: L10nService.get(
                    'screens.dream_glossary.sections.universal_meanings',
                    language,
                  ),
                  emoji: '\u{1F30D}',
                  content: symbol.universalMeanings
                      .map((m) => '\u{2022} $m')
                      .join('\n'),
                ),

                // Light aspect
                _buildSection(
                  context,
                  title: L10nService.get(
                    'screens.dream_glossary.sections.light_aspect',
                    language,
                  ),
                  emoji: '\u{2728}',
                  content: symbol.lightAspect,
                  color: CosmicPalette.starGold,
                ),

                // Shadow aspect
                _buildSection(
                  context,
                  title: L10nService.get(
                    'screens.dream_glossary.sections.shadow_aspect',
                    language,
                  ),
                  emoji: '\u{1F311}',
                  content: symbol.shadowAspect,
                  color: CosmicPalette.amethyst,
                ),

                // Cultural interpretations
                _buildCulturalSection(context),

                // Psychological interpretations
                _buildPsychologicalSection(context),

                // Related symbols
                if (symbol.relatedSymbols.isNotEmpty)
                  _buildRelatedSymbols(context),

                const SizedBox(height: 20),

                // "I dreamed this" button
                _buildDreamedButton(context),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String emoji,
    required String content,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (color ?? CosmicPalette.amethyst).withValues(alpha: 0.1),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: (color ?? CosmicPalette.amethyst).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: color ?? CosmicPalette.starGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCulturalSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CosmicPalette.nebulaTeal.withValues(alpha: 0.1),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: CosmicPalette.nebulaTeal.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('\u{1F3DB}', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                L10nService.get(
                  'screens.dream_glossary.sections.cultural_interpretations',
                  language,
                ),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: CosmicPalette.etherealCyan,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Turkish interpretation
          _buildInterpretationRow(
            context,
            label: L10nService.get(
              'screens.dream_glossary.interpretation_labels.turkish',
              language,
            ),
            content: _getTurkishInterpretation(),
          ),
          const SizedBox(height: 8),

          // Islamic interpretation
          _buildInterpretationRow(
            context,
            label: L10nService.get(
              'screens.dream_glossary.interpretation_labels.islamic',
              language,
            ),
            content: _getIslamicInterpretation(),
          ),
          const SizedBox(height: 8),

          // Western interpretation
          _buildInterpretationRow(
            context,
            label: L10nService.get(
              'screens.dream_glossary.interpretation_labels.western',
              language,
            ),
            content: _getWesternInterpretation(),
          ),
        ],
      ),
    );
  }

  Widget _buildPsychologicalSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CosmicPalette.orchid.withValues(alpha: 0.1),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: CosmicPalette.orchid.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('\u{1F9E0}', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                L10nService.get(
                  'screens.dream_glossary.sections.psychological_interpretations',
                  language,
                ),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: CosmicPalette.orchid,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Jungian
          _buildInterpretationRow(
            context,
            label: L10nService.get(
              'screens.dream_glossary.interpretation_labels.jung',
              language,
            ),
            content: _getJungianInterpretation(),
          ),
          const SizedBox(height: 8),

          // Freudian
          _buildInterpretationRow(
            context,
            label: L10nService.get(
              'screens.dream_glossary.interpretation_labels.freud',
              language,
            ),
            content: _getFreudianInterpretation(),
          ),
        ],
      ),
    );
  }

  Widget _buildInterpretationRow(
    BuildContext context, {
    required String label,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: CosmicPalette.bgElevated,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            content,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedSymbols(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CosmicPalette.stardustBlue.withValues(alpha: 0.1),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: CosmicPalette.stardustBlue.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('\u{1F517}', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                L10nService.get(
                  'screens.dream_glossary.sections.related_symbols',
                  language,
                ),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: CosmicPalette.stardustBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: symbol.relatedSymbols.map((related) {
              final relatedSymbol = DreamSymbolsDatabase.findSymbol(related);
              if (relatedSymbol == null) return const SizedBox.shrink();

              return Semantics(
                label: relatedSymbol.symbolTr,
                button: true,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: CosmicPalette.bgElevated,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: CosmicPalette.amethyst.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          relatedSymbol.emoji,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          relatedSymbol.symbolTr,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDreamedButton(BuildContext context) {
    final hasDreamed = personalDictionary.hasDreamed(symbol.symbol);

    final dreamedLabel = hasDreamed
        ? L10nService.get(
            'screens.dream_glossary.dreamed_button.in_journal',
            language,
          )
        : L10nService.get(
            'screens.dream_glossary.dreamed_button.i_dreamed_this',
            language,
          );

    return Semantics(
      label: dreamedLabel,
      button: !hasDreamed,
      child: GestureDetector(
        onTap: hasDreamed ? null : onDreamed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: hasDreamed
              ? null
              : LinearGradient(
                  colors: [
                    CosmicPalette.starGold.withValues(alpha: 0.8),
                    CosmicPalette.bronzeGlow.withValues(alpha: 0.8),
                  ],
                ),
          color: hasDreamed ? CosmicPalette.bgElevated : null,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: hasDreamed
              ? Border.all(color: CosmicPalette.starGold.withValues(alpha: 0.3))
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              hasDreamed ? '\u{2705}' : '\u{1F319}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 10),
            Text(
              hasDreamed
                  ? L10nService.get(
                      'screens.dream_glossary.dreamed_button.in_journal',
                      language,
                    )
                  : L10nService.get(
                      'screens.dream_glossary.dreamed_button.i_dreamed_this',
                      language,
                    ),
              style: TextStyle(
                color: hasDreamed ? CosmicPalette.starGold : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  // Interpretation helpers
  String _getTurkishInterpretation() {
    // Generate context-aware Turkish interpretation
    final base = symbol.universalMeanings.isNotEmpty
        ? symbol.universalMeanings.first
        : symbol.symbol;
    return L10nService.get(
          'screens.dream_glossary.interpretation_templates.turkish',
          language,
        )
        .replaceAll('{symbol}', symbol.symbolTr.toLowerCase())
        .replaceAll('{meaning}', base);
  }

  String _getIslamicInterpretation() {
    // Generate context-aware Islamic interpretation
    return L10nService.get(
      'screens.dream_glossary.interpretation_templates.islamic',
      language,
    ).replaceAll('{symbol}', symbol.symbolTr.toLowerCase());
  }

  String _getWesternInterpretation() {
    // Generate context-aware Western interpretation
    return L10nService.get(
          'screens.dream_glossary.interpretation_templates.western',
          language,
        )
        .replaceAll('{symbol}', symbol.symbolTr.toLowerCase())
        .replaceAll(
          '{meaning}',
          (symbol.universalMeanings.isNotEmpty
                  ? symbol.universalMeanings.first
                  : symbol.symbol)
              .toLowerCase(),
        );
  }

  String _getJungianInterpretation() {
    final archetypes = symbol.archetypes.join(', ');
    return L10nService.get(
          'screens.dream_glossary.interpretation_templates.jungian',
          language,
        )
        .replaceAll('{symbol}', symbol.symbolTr)
        .replaceAll('{archetypes}', archetypes)
        .replaceAll('{shadow}', symbol.shadowAspect);
  }

  String _getFreudianInterpretation() {
    return L10nService.get(
      'screens.dream_glossary.interpretation_templates.freudian',
      language,
    ).replaceAll('{symbol}', symbol.symbolTr.toLowerCase());
  }
}

// ============================================================================
// PERSONAL DICTIONARY SHEET
// ============================================================================

class _PersonalDictionarySheet extends StatelessWidget {
  final PersonalDictionaryService personalDictionary;
  final AppLanguage language;
  final void Function(DreamSymbolData symbol) onSymbolTap;

  const _PersonalDictionarySheet({
    required this.personalDictionary,
    required this.language,
    required this.onSymbolTap,
  });

  @override
  Widget build(BuildContext context) {
    final dreamedSymbols = personalDictionary.getDreamedSymbols();
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.7,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [CosmicPalette.bgCosmic, CosmicPalette.bgDeepSpace],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text('\u{1F4D4}', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        L10nService.get(
                          'screens.dream_glossary.personal_dictionary_sheet.title',
                          language,
                        ),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        L10nService.get(
                          'screens.dream_glossary.personal_dictionary_sheet.symbol_count',
                          language,
                        ).replaceAll('{count}', '${dreamedSymbols.length}'),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: CosmicPalette.starGold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: dreamedSymbols.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: dreamedSymbols.length,
                    itemBuilder: (context, index) {
                      final entry = dreamedSymbols[index];
                      final symbol = DreamSymbolsDatabase.findSymbol(
                        entry.symbolId,
                      );
                      if (symbol == null) return const SizedBox.shrink();

                      return _buildDreamedSymbolCard(context, symbol, entry);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('\u{1F319}', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            L10nService.get(
              'screens.dream_glossary.personal_dictionary_sheet.no_symbols_yet',
              language,
            ),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            L10nService.get(
              'screens.dream_glossary.personal_dictionary_sheet.add_symbols_hint',
              language,
            ),
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildDreamedSymbolCard(
    BuildContext context,
    DreamSymbolData symbol,
    PersonalSymbolEntry entry,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onSymbolTap(symbol),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CosmicPalette.starGold.withValues(alpha: 0.1),
                  CosmicPalette.bgCosmic.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: CosmicPalette.starGold.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                // Emoji
                Text(symbol.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 14),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        symbol.symbolTr,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            '\u{1F4C5}',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            L10nService.get(
                              'screens.dream_glossary.personal_dictionary_sheet.times_count',
                              language,
                            ).replaceAll('{count}', '${entry.count}'),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: CosmicPalette.starGold),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _formatDate(entry.lastDreamed),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return L10nService.get(
        'screens.dream_glossary.date_formats.today',
        language,
      );
    }
    if (diff.inDays == 1) {
      return L10nService.get(
        'screens.dream_glossary.date_formats.yesterday',
        language,
      );
    }
    if (diff.inDays < 7) {
      return L10nService.get(
        'screens.dream_glossary.date_formats.days_ago',
        language,
      ).replaceAll('{count}', '${diff.inDays}');
    }
    if (diff.inDays < 30) {
      return L10nService.get(
        'screens.dream_glossary.date_formats.weeks_ago',
        language,
      ).replaceAll('{count}', '${diff.inDays ~/ 7}');
    }
    return L10nService.get(
      'screens.dream_glossary.date_formats.months_ago',
      language,
    ).replaceAll('{count}', '${diff.inDays ~/ 30}');
  }
}

// ============================================================================
// PERSONAL DICTIONARY SERVICE
// ============================================================================

class PersonalSymbolEntry {
  final String symbolId;
  final int count;
  final DateTime firstDreamed;
  final DateTime lastDreamed;
  final String? personalMeaning;

  PersonalSymbolEntry({
    required this.symbolId,
    required this.count,
    required this.firstDreamed,
    required this.lastDreamed,
    this.personalMeaning,
  });

  Map<String, dynamic> toJson() => {
    'symbolId': symbolId,
    'count': count,
    'firstDreamed': firstDreamed.toIso8601String(),
    'lastDreamed': lastDreamed.toIso8601String(),
    'personalMeaning': personalMeaning,
  };

  factory PersonalSymbolEntry.fromJson(Map<String, dynamic> json) =>
      PersonalSymbolEntry(
        symbolId: json['symbolId'],
        count: json['count'],
        firstDreamed:
            DateTime.tryParse(json['firstDreamed']?.toString() ?? '') ??
            DateTime.now(),
        lastDreamed:
            DateTime.tryParse(json['lastDreamed']?.toString() ?? '') ??
            DateTime.now(),
        personalMeaning: json['personalMeaning'],
      );

  PersonalSymbolEntry copyWith({
    int? count,
    DateTime? lastDreamed,
    String? personalMeaning,
  }) => PersonalSymbolEntry(
    symbolId: symbolId,
    count: count ?? this.count,
    firstDreamed: firstDreamed,
    lastDreamed: lastDreamed ?? this.lastDreamed,
    personalMeaning: personalMeaning ?? this.personalMeaning,
  );
}

class PersonalDictionaryService {
  static const String _boxName = 'personal_dream_dictionary';
  static const String _entriesKey = 'entries';

  Box? _box;
  List<PersonalSymbolEntry> _entries = [];

  Future<void> init() async {
    // Skip on web - Hive's IndexedDB can hang and cause white screen
    if (kIsWeb) return;

    try {
      _box = await Hive.openBox(_boxName);
      _loadEntries();
    } catch (e) {
      if (kDebugMode) debugPrint('PersonalDictionaryService init error: $e');
    }
  }

  void _loadEntries() {
    final json = _box?.get(_entriesKey) as String?;
    if (json == null) {
      _entries = [];
      return;
    }

    try {
      final list = jsonDecode(json) as List;
      _entries = list
          .map((e) => PersonalSymbolEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _entries = [];
    }
  }

  Future<void> _saveEntries() async {
    final json = jsonEncode(_entries.map((e) => e.toJson()).toList());
    await _box?.put(_entriesKey, json);
  }

  bool hasDreamed(String symbolId) {
    return _entries.any((e) => e.symbolId == symbolId);
  }

  void markAsDreamed(String symbolId) {
    final existingIndex = _entries.indexWhere((e) => e.symbolId == symbolId);

    if (existingIndex >= 0) {
      _entries[existingIndex] = _entries[existingIndex].copyWith(
        count: _entries[existingIndex].count + 1,
        lastDreamed: DateTime.now(),
      );
    } else {
      _entries.add(
        PersonalSymbolEntry(
          symbolId: symbolId,
          count: 1,
          firstDreamed: DateTime.now(),
          lastDreamed: DateTime.now(),
        ),
      );
    }

    unawaited(_saveEntries());
  }

  List<PersonalSymbolEntry> getDreamedSymbols() {
    return List.from(_entries)
      ..sort((a, b) => b.lastDreamed.compareTo(a.lastDreamed));
  }

  int getSymbolCount(String symbolId) {
    final entry = _entries.firstWhere(
      (e) => e.symbolId == symbolId,
      orElse: () => PersonalSymbolEntry(
        symbolId: symbolId,
        count: 0,
        firstDreamed: DateTime.now(),
        lastDreamed: DateTime.now(),
      ),
    );
    return entry.count;
  }

  Future<void> setPersonalMeaning(String symbolId, String meaning) async {
    final index = _entries.indexWhere((e) => e.symbolId == symbolId);
    if (index >= 0) {
      _entries[index] = _entries[index].copyWith(personalMeaning: meaning);
      await _saveEntries();
    }
  }
}

// ============================================================================
// HELPERS
// ============================================================================

class _CategoryItem {
  final SymbolCategory? category;
  final String label;
  final String emoji;

  const _CategoryItem(this.category, this.label, this.emoji);
}
