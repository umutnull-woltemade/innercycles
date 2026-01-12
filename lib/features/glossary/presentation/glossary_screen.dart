import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/reference_content.dart';
import '../../../data/services/reference_content_service.dart';
import '../../../shared/widgets/cosmic_background.dart';

class GlossaryScreen extends StatefulWidget {
  const GlossaryScreen({super.key});

  @override
  State<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends State<GlossaryScreen> {
  final _service = ReferenceContentService();
  final _searchController = TextEditingController();

  List<GlossaryEntry> _entries = [];
  List<GlossaryEntry> _filteredEntries = [];
  GlossaryCategory? _selectedCategory;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _entries = _service.getGlossaryEntries();
    _filteredEntries = _entries;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterEntries() {
    setState(() {
      _filteredEntries = _entries.where((entry) {
        final matchesSearch = _searchQuery.isEmpty ||
            entry.term.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            entry.termTr.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            entry.definition.toLowerCase().contains(_searchQuery.toLowerCase());

        final matchesCategory =
            _selectedCategory == null || entry.category == _selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isDark),
              _buildSearchBar(isDark),
              _buildCategoryFilter(isDark),
              Expanded(
                child: _filteredEntries.isEmpty
                    ? _buildEmptyState(isDark)
                    : _buildEntriesList(isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
          Expanded(
            child: Text(
              'Astroloji Sözlüğü',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Terim ara...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                    _filterEntries();
                  },
                )
              : null,
          filled: true,
          fillColor: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
          _filterEntries();
        },
      ),
    );
  }

  Widget _buildCategoryFilter(bool isDark) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: AppConstants.spacingMd),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
        children: [
          _buildCategoryChip(null, 'Tümü', '📚', isDark),
          ...GlossaryCategory.values.map(
            (cat) => _buildCategoryChip(cat, cat.nameTr, cat.icon, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
      GlossaryCategory? category, String label, String icon, bool isDark) {
    final isSelected = _selectedCategory == category;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        onSelected: (_) {
          setState(() {
            _selectedCategory = category;
          });
          _filterEntries();
        },
        selectedColor: AppColors.cosmic.withValues(alpha: 0.3),
        backgroundColor: isDark
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.9),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            'Sonuç bulunamadı',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Farklı bir arama terimi deneyin',
            style: TextStyle(
              color: isDark ? Colors.white60 : AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntriesList(bool isDark) {
    // Group by category
    final groupedEntries = <GlossaryCategory, List<GlossaryEntry>>{};
    for (final entry in _filteredEntries) {
      groupedEntries.putIfAbsent(entry.category, () => []).add(entry);
    }

    if (_selectedCategory != null) {
      // Show flat list when category is selected
      return ListView.builder(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        itemCount: _filteredEntries.length,
        itemBuilder: (context, index) {
          return _buildEntryCard(_filteredEntries[index], isDark);
        },
      );
    }

    // Show grouped list
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      itemCount: groupedEntries.length,
      itemBuilder: (context, index) {
        final category = groupedEntries.keys.elementAt(index);
        final entries = groupedEntries[category]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Text(category.icon, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    category.nameTr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cosmic.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${entries.length}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.cosmic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...entries.map((entry) => _buildEntryCard(entry, isDark)),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildEntryCard(GlossaryEntry entry, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingLg,
          vertical: AppConstants.spacingSm,
        ),
        childrenPadding: const EdgeInsets.only(
          left: AppConstants.spacingLg,
          right: AppConstants.spacingLg,
          bottom: AppConstants.spacingLg,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.termTr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : AppColors.textDark,
              ),
            ),
            Text(
              entry.term,
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: isDark ? Colors.white60 : AppColors.textLight,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.expand_more,
          color: isDark ? Colors.white60 : AppColors.textLight,
        ),
        children: [
          Text(
            entry.definition,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDark ? Colors.white70 : AppColors.textLight,
            ),
          ),
          if (entry.example != null) ...[
            const SizedBox(height: AppConstants.spacingMd),
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              decoration: BoxDecoration(
                color: AppColors.cosmic.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                border: Border.all(
                  color: AppColors.cosmic.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💡', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.example!,
                      style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: isDark ? Colors.white70 : AppColors.textLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (entry.relatedTerms.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spacingMd),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Text(
                  'İlgili:',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : AppColors.textLight,
                  ),
                ),
                ...entry.relatedTerms.map(
                  (term) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      term,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white70 : AppColors.textLight,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
