import 'package:flutter/cupertino.dart' show CupertinoScrollbar;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../data/content/emotional_vocabulary_content.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

class EmotionalVocabularyScreen extends ConsumerStatefulWidget {
  const EmotionalVocabularyScreen({super.key});

  @override
  ConsumerState<EmotionalVocabularyScreen> createState() =>
      _EmotionalVocabularyScreenState();
}

class _EmotionalVocabularyScreenState
    extends ConsumerState<EmotionalVocabularyScreen> {
  EmotionFamily? _selectedFamily;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;

    // Filter emotions
    var emotions = List<GranularEmotion>.from(allGranularEmotions);
    if (_selectedFamily != null) {
      emotions = emotions.where((e) => e.family == _selectedFamily).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      emotions = emotions.where((e) {
        return e.nameEn.toLowerCase().contains(query) ||
            e.nameTr.toLowerCase().contains(query) ||
            e.descriptionEn.toLowerCase().contains(query) ||
            e.descriptionTr.toLowerCase().contains(query);
      }).toList();
    }

    return Scaffold(
      body: CosmicBackground(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          behavior: HitTestBehavior.opaque,
          child: CupertinoScrollbar(
            child:
                CustomScrollView(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      slivers: [
                        GlassSliverAppBar(
                          title: isEn
                              ? 'Emotional Vocabulary'
                              : 'Duygusal Sözlük',
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.all(AppConstants.spacingLg),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              // Family filter chips
                              _buildFamilyChips(isDark, isEn),
                              const SizedBox(height: AppConstants.spacingMd),

                              // Search bar
                              _buildSearchBar(isDark, isEn),
                              const SizedBox(height: AppConstants.spacingLg),

                              // Emotion count
                              Text(
                                isEn
                                    ? '${emotions.length} emotions'
                                    : '${emotions.length} duygu',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                              const SizedBox(height: AppConstants.spacingMd),

                              // Emotion cards
                              ...emotions.map(
                                (emotion) => Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppConstants.spacingSm,
                                  ),
                                  child: _EmotionCard(
                                    emotion: emotion,
                                    isDark: isDark,
                                    isEn: isEn,
                                  ),
                                ),
                              ),

                              if (emotions.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(
                                    AppConstants.spacingXl,
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.search,
                                          size: 40,
                                          color: isDark
                                              ? AppColors.textMuted
                                              : AppColors.lightTextMuted,
                                        ),
                                        const SizedBox(
                                          height: AppConstants.spacingMd,
                                        ),
                                        Text(
                                          isEn
                                              ? 'No emotions found'
                                              : 'Duygu bulunamadı',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: isDark
                                                ? AppColors.textMuted
                                                : AppColors.lightTextMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ]),
                          ),
                        ),
                      ],
                    )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.02, duration: 400.ms),
          ),
        ),
      ),
    );
  }

  Widget _buildFamilyChips(bool isDark, bool isEn) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FamilyChip(
            label: isEn ? 'All' : 'Tümü',
            emoji: '🎭',
            isSelected: _selectedFamily == null,
            isDark: isDark,
            onTap: () => setState(() => _selectedFamily = null),
          ),
          const SizedBox(width: 8),
          ...EmotionFamily.values.map(
            (family) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _FamilyChip(
                label: isEn ? family.displayNameEn : family.displayNameTr,
                emoji: family.emoji,
                isSelected: _selectedFamily == family,
                isDark: isDark,
                onTap: () => setState(() => _selectedFamily = family),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark, bool isEn) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v.trim()),
        style: TextStyle(
          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
        ),
        decoration: InputDecoration(
          hintText: isEn ? 'Search emotions...' : 'Duygu ara...',
          hintStyle: TextStyle(
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  tooltip: isEn ? 'Clear search' : 'Aramayı temizle',
                  icon: Icon(
                    Icons.cancel,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                    size: 18,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMd,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

class _FamilyChip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _FamilyChip({
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$emoji $label',
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.auroraStart.withValues(alpha: 0.2)
                : (isDark
                      ? AppColors.surfaceLight.withValues(alpha: 0.1)
                      : AppColors.lightSurfaceVariant),
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            border: Border.all(
              color: isSelected
                  ? AppColors.auroraStart
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.05)),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.auroraStart
                      : (isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmotionCard extends StatefulWidget {
  final GranularEmotion emotion;
  final bool isDark;
  final bool isEn;

  const _EmotionCard({
    required this.emotion,
    required this.isDark,
    required this.isEn,
  });

  @override
  State<_EmotionCard> createState() => _EmotionCardState();
}

class _EmotionCardState extends State<_EmotionCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.emotion;
    final isDark = widget.isDark;
    final isEn = widget.isEn;

    return Semantics(
      button: true,
      label: isEn ? e.nameEn : e.nameTr,
      child: GestureDetector(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: GlassPanel(
          elevation: GlassElevation.g2,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(e.emoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: AppConstants.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEn ? e.nameEn : e.nameTr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getIntensityColor(
                                  e.intensity,
                                ).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(
                                  AppConstants.radiusFull,
                                ),
                              ),
                              child: Text(
                                isEn
                                    ? e.intensity.displayNameEn
                                    : e.intensity.displayNameTr,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: _getIntensityColor(e.intensity),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isEn
                                  ? e.family.displayNameEn
                                  : e.family.displayNameTr,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ],
              ),
              if (_isExpanded) ...[
                const SizedBox(height: AppConstants.spacingMd),
                Text(
                  isEn ? e.descriptionEn : e.descriptionTr,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingMd),
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingMd),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surfaceLight.withValues(alpha: 0.08)
                        : AppColors.lightSurfaceVariant,
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.accessibility_new,
                        size: 16,
                        color: AppColors.auroraStart,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEn ? 'Body Sensation' : 'Bedensel Duyum',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.auroraStart,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isEn ? e.bodySensationEn : e.bodySensationTr,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? AppColors.textSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getIntensityColor(EmotionIntensity intensity) {
    switch (intensity) {
      case EmotionIntensity.low:
        return AppColors.auroraEnd;
      case EmotionIntensity.medium:
        return AppColors.starGold;
      case EmotionIntensity.high:
        return AppColors.warning;
    }
  }
}
