import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/reference_content.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';
import '../../../data/services/reference_content_service.dart';
import '../../../shared/widgets/cosmic_background.dart';

class CelebritiesScreen extends ConsumerStatefulWidget {
  const CelebritiesScreen({super.key});

  @override
  ConsumerState<CelebritiesScreen> createState() => _CelebritiesScreenState();
}

class _CelebritiesScreenState extends ConsumerState<CelebritiesScreen> {
  final _service = ReferenceContentService();
  final _searchController = TextEditingController();

  List<CelebrityChart> _celebrities = [];
  List<CelebrityChart> _filteredCelebrities = [];
  CelebrityCategory? _selectedCategory;
  String _searchQuery = '';
  CelebrityChart? _selectedCelebrity;

  @override
  void initState() {
    super.initState();
    _celebrities = _service.getCelebrityCharts();
    _filteredCelebrities = _celebrities;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCelebrities() {
    setState(() {
      _filteredCelebrities = _celebrities.where((celeb) {
        final matchesSearch = _searchQuery.isEmpty ||
            celeb.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            celeb.profession.toLowerCase().contains(_searchQuery.toLowerCase());

        final matchesCategory =
            _selectedCategory == null || celeb.category == _selectedCategory;

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
                child: _selectedCelebrity != null
                    ? _buildCelebrityDetail(isDark)
                    : _buildCelebritiesList(isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final language = ref.watch(languageProvider);
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (_selectedCelebrity != null) {
                setState(() {
                  _selectedCelebrity = null;
                });
              } else {
                context.pop();
              }
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
          Expanded(
            child: Text(
              _selectedCelebrity?.name ?? L10nService.get('screens.celebrities.title', language),
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
    if (_selectedCelebrity != null) return const SizedBox.shrink();
    final language = ref.watch(languageProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: L10nService.get('screens.celebrities.search_hint', language),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                    _filterCelebrities();
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
          _filterCelebrities();
        },
      ),
    );
  }

  Widget _buildCategoryFilter(bool isDark) {
    if (_selectedCelebrity != null) return const SizedBox.shrink();
    final language = ref.watch(languageProvider);

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: AppConstants.spacingMd),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
        children: [
          _buildCategoryChip(null, L10nService.get('common.all', language), '⭐', isDark),
          ...CelebrityCategory.values.map(
            (cat) => _buildCategoryChip(cat, cat.localizedName(language), cat.icon, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
      CelebrityCategory? category, String label, String icon, bool isDark) {
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
          _filterCelebrities();
        },
        selectedColor: AppColors.gold.withValues(alpha: 0.3),
        backgroundColor: isDark
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.9),
      ),
    );
  }

  Widget _buildCelebritiesList(bool isDark) {
    final language = ref.watch(languageProvider);
    if (_filteredCelebrities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🔍', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              L10nService.get('screens.celebrities.no_results', language),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textDark,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      itemCount: _filteredCelebrities.length,
      itemBuilder: (context, index) {
        final celeb = _filteredCelebrities[index];
        return _buildCelebrityCard(celeb, isDark);
      },
    );
  }

  Widget _buildCelebrityCard(CelebrityChart celeb, bool isDark) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCelebrity = celeb;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
        padding: const EdgeInsets.all(AppConstants.spacingLg),
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
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: celeb.sunSign.color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  celeb.sunSign.symbol,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.spacingLg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        celeb.category.icon,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          celeb.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDark ? Colors.white : AppColors.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    celeb.profession,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white60 : AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildSignBadge('☀️', celeb.sunSign, isDark),
                      const SizedBox(width: 4),
                      _buildSignBadge('🌙', celeb.moonSign, isDark),
                      const SizedBox(width: 4),
                      _buildSignBadge('⬆️', celeb.ascendant, isDark),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? Colors.white30 : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignBadge(String emoji, ZodiacSign sign, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: sign.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 10)),
          Text(
            sign.symbol,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildCelebrityDetail(bool isDark) {
    final celeb = _selectedCelebrity!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        children: [
          _buildDetailHeader(celeb, isDark),
          const SizedBox(height: AppConstants.spacingLg),
          _buildSignsCard(celeb, isDark),
          const SizedBox(height: AppConstants.spacingMd),
          _buildAnalysisCard(celeb, isDark),
          const SizedBox(height: AppConstants.spacingMd),
          _buildAspectsCard(celeb, isDark),
          const SizedBox(height: AppConstants.spacingXxl),
        ],
      ),
    );
  }

  Widget _buildDetailHeader(CelebrityChart celeb, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            celeb.sunSign.color.withValues(alpha: 0.3),
            AppColors.cosmic.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: celeb.sunSign.color.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
              child: Text(
                celeb.sunSign.symbol,
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            celeb.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(celeb.category.icon),
              const SizedBox(width: 4),
              Text(
                celeb.profession,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            '${celeb.birthDate.day}/${celeb.birthDate.month}/${celeb.birthDate.year} • ${celeb.birthPlace}',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white60 : AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignsCard(CelebrityChart celeb, bool isDark) {
    final language = ref.watch(languageProvider);
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDetailedSign(L10nService.get('natal_chart.sun_sign', language), '☀️', celeb.sunSign, isDark),
          Container(
            width: 1,
            height: 60,
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.3),
          ),
          _buildDetailedSign(L10nService.get('natal_chart.moon_sign', language), '🌙', celeb.moonSign, isDark),
          Container(
            width: 1,
            height: 60,
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.3),
          ),
          _buildDetailedSign(L10nService.get('natal_chart.rising_sign', language), '⬆️', celeb.ascendant, isDark),
        ],
      ),
    );
  }

  Widget _buildDetailedSign(
      String label, String emoji, ZodiacSign sign, bool isDark) {
    final language = ref.watch(languageProvider);
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white60 : AppColors.textLight,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: sign.color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(sign.symbol, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text(
                sign.localizedName(language),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisCard(CelebrityChart celeb, bool isDark) {
    final language = ref.watch(languageProvider);
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📊', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                L10nService.get('screens.celebrities.chart_analysis', language),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.white : AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            celeb.chartAnalysis,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDark ? Colors.white70 : AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAspectsCard(CelebrityChart celeb, bool isDark) {
    final language = ref.watch(languageProvider);
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('⚡', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                L10nService.get('screens.celebrities.notable_aspects', language),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.white : AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...celeb.notableAspects.map(
            (aspect) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              decoration: BoxDecoration(
                color: AppColors.cosmic.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
              child: Row(
                children: [
                  const Text('🔮', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      aspect,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : AppColors.textLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
