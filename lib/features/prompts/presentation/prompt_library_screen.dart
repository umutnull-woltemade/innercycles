// ════════════════════════════════════════════════════════════════════════════
// PROMPT LIBRARY SCREEN - Curated Journaling Prompts
// ════════════════════════════════════════════════════════════════════════════
// Displays 80 bilingual prompts across 8 categories with smart selection,
// daily prompt highlight, category filtering, and completion tracking.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/journal_prompt_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';

class PromptLibraryScreen extends ConsumerWidget {
  const PromptLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(journalPromptServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: serviceAsync.when(
          loading: () => const CosmicLoadingIndicator(),
          error: (_, _) => Center(
            child: Text(
              CommonStrings.somethingWentWrong(language),
              style: TextStyle(
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),
          data: (service) => _PromptLibraryContent(
            service: service,
            isDark: isDark,
            isEn: isEn,
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// MAIN CONTENT (StatefulWidget for local filter state)
// ════════════════════════════════════════════════════════════════════════════

class _PromptLibraryContent extends StatefulWidget {
  final JournalPromptService service;
  final bool isDark;
  final bool isEn;

  const _PromptLibraryContent({
    required this.service,
    required this.isDark,
    required this.isEn,
  });

  @override
  State<_PromptLibraryContent> createState() => _PromptLibraryContentState();
}

class _PromptLibraryContentState extends State<_PromptLibraryContent> {
  PromptCategory? _selectedCategory;

  JournalPromptService get service => widget.service;
  bool get isDark => widget.isDark;
  bool get isEn => widget.isEn;

  List<JournalPrompt> get _filteredPrompts {
    if (_selectedCategory == null) {
      return service.getAllPrompts();
    }
    return service.getPromptsByCategory(_selectedCategory!);
  }

  @override
  Widget build(BuildContext context) {
    final dailyPrompt = service.getDailyPrompt();
    final completionPercent = service.getCompletionPercent();
    final completedCount = service.getCompletedCount();
    final totalCount = JournalPromptService.allPrompts.length;

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(
            title: isEn ? 'Prompt Library' : 'İlham Kütüphanesi',
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Completion progress bar
                  _buildProgressBar(
                        completionPercent,
                        completedCount,
                        totalCount,
                      )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: -0.1, end: 0, duration: 400.ms),
                  const SizedBox(height: 16),

                  // Today's prompt card
                  _buildDailyPromptCard(dailyPrompt)
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 100.ms)
                      .slideY(begin: 0.05, end: 0, duration: 500.ms),
                  const SizedBox(height: 16),

                  // Category filter chips
                  _buildCategoryChips(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // Prompts list
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final prompt = _filteredPrompts[index];
                return _buildPromptCard(prompt, index)
                    .animate()
                    .fadeIn(
                      duration: 300.ms,
                      delay: Duration(milliseconds: 50 * (index % 10)),
                    )
                    .slideX(
                      begin: 0.03,
                      end: 0,
                      duration: 300.ms,
                      delay: Duration(milliseconds: 50 * (index % 10)),
                    );
              }, childCount: _filteredPrompts.length),
            ),
          ),

          // Tool ecosystem footer
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: ToolEcosystemFooter(
                currentToolId: 'promptLibrary',
                isEn: isEn,
                isDark: isDark,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PROGRESS BAR
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildProgressBar(double percent, int completed, int total) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : AppColors.textMuted.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEn ? 'Your Progress' : 'İlerlemeniz',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                '$completed / $total',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.starGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : AppColors.textMuted.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.auroraStart,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // DAILY PROMPT CARD
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildDailyPromptCard(JournalPrompt prompt) {
    final promptText = isEn ? prompt.promptEn : prompt.promptTr;
    final isCompleted = service.isCompleted(prompt.id);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.auroraStart.withValues(alpha: 0.25),
                  AppColors.auroraEnd.withValues(alpha: 0.2),
                ]
              : [
                  AppColors.lightAuroraStart.withValues(alpha: 0.15),
                  AppColors.lightAuroraEnd.withValues(alpha: 0.1),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.auroraStart.withValues(alpha: 0.4),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.starGold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isEn ? "Today's Prompt" : 'Günün İlhamı',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.starGold,
                  ),
                ),
              ),
              const Spacer(),
              _buildDepthIndicator(prompt.depth),
              if (isCompleted) ...[
                const SizedBox(width: 8),
                Icon(Icons.check_circle, size: 20, color: AppColors.success),
              ],
            ],
          ),
          const SizedBox(height: 14),
          Text(
            promptText,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _categoryLabel(prompt.category),
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                service.markCompleted(prompt.id);
                context.push(Routes.journal);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.auroraStart,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                isEn ? 'Start Writing' : 'Yazmaya Başla',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CATEGORY CHIPS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          _buildChip(null, isEn ? 'All' : 'Tümü'),
          ...PromptCategory.values.map(
            (cat) => _buildChip(cat, _categoryLabel(cat)),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(PromptCategory? category, String label) {
    final isSelected = _selectedCategory == category;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? Colors.white
                : (isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary),
          ),
        ),
        onSelected: (_) {
          HapticFeedback.selectionClick();
          setState(() {
            _selectedCategory = category;
          });
        },
        selectedColor: AppColors.auroraStart.withValues(alpha: 0.8),
        backgroundColor: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.white.withValues(alpha: 0.9),
        side: BorderSide(
          color: isSelected
              ? AppColors.auroraStart.withValues(alpha: 0.6)
              : (isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : AppColors.textMuted.withValues(alpha: 0.2)),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PROMPT CARD
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildPromptCard(JournalPrompt prompt, int index) {
    final promptText = isEn ? prompt.promptEn : prompt.promptTr;
    final isCompleted = service.isCompleted(prompt.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: isCompleted ? 0.03 : 0.06)
            : Colors.white.withValues(alpha: isCompleted ? 0.6 : 0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCompleted
              ? AppColors.success.withValues(alpha: 0.3)
              : (isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : AppColors.textMuted.withValues(alpha: 0.2)),
        ),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          _showPromptDetail(context, prompt);
        },
        borderRadius: BorderRadius.circular(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildDepthIndicator(prompt.depth),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _categoryLabel(prompt.category),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    promptText,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      fontWeight: FontWeight.w400,
                      color: isCompleted
                          ? (isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted)
                          : (isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (isCompleted)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Icon(
                  Icons.check_circle,
                  size: 22,
                  color: AppColors.success.withValues(alpha: 0.8),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: ExcludeSemantics(
                  child: Icon(
                    Icons.chevron_right,
                    size: 22,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.3)
                        : AppColors.textMuted.withValues(alpha: 0.4),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PROMPT DETAIL BOTTOM SHEET
  // ══════════════════════════════════════════════════════════════════════════

  void _showPromptDetail(BuildContext context, JournalPrompt prompt) {
    final promptText = isEn ? prompt.promptEn : prompt.promptTr;
    final isCompleted = service.isCompleted(prompt.id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.2)
                      : AppColors.textMuted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Category and depth
            Row(
              children: [
                _buildDepthIndicator(prompt.depth),
                const SizedBox(width: 8),
                Text(
                  _categoryLabel(prompt.category),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.auroraStart,
                  ),
                ),
                const Spacer(),
                if (isCompleted)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 18,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isEn ? 'Completed' : 'Tamamlandı',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 18),

            // Prompt text
            Text(
              promptText,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w500,
                height: 1.55,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                // Skip button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      service.markSkipped(prompt.id);
                      Navigator.pop(ctx);
                      setState(() {});
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                      side: BorderSide(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.15)
                            : AppColors.textMuted.withValues(alpha: 0.3),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isEn ? 'Skip' : 'Atla',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Start Writing button
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      service.markCompleted(prompt.id);
                      Navigator.pop(ctx);
                      context.push(Routes.journal);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.auroraStart,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isEn ? 'Start Writing' : 'Yazmaya Başla',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildDepthIndicator(PromptDepth depth) {
    Color color;
    String label;

    switch (depth) {
      case PromptDepth.surface:
        color = AppColors.success;
        label = isEn ? 'Light' : 'Hafif';
      case PromptDepth.medium:
        color = AppColors.warning;
        label = isEn ? 'Medium' : 'Orta';
      case PromptDepth.deep:
        color = AppColors.amethyst;
        label = isEn ? 'Deep' : 'Derin';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  String _categoryLabel(PromptCategory category) {
    switch (category) {
      case PromptCategory.selfDiscovery:
        return isEn ? 'Cycle Awareness' : 'Döngü Farkındalığı';
      case PromptCategory.relationships:
        return isEn ? 'Relationships' : 'İlişkiler';
      case PromptCategory.gratitude:
        return isEn ? 'Gratitude' : 'Minnettarlık';
      case PromptCategory.emotions:
        return isEn ? 'Emotions' : 'Duygular';
      case PromptCategory.goals:
        return isEn ? 'Goals' : 'Hedefler';
      case PromptCategory.recovery:
        return isEn ? 'Recovery' : 'İyileşme';
      case PromptCategory.creativity:
        return isEn ? 'Creativity' : 'Yaratıcılık';
      case PromptCategory.mindfulness:
        return isEn ? 'Mindfulness' : 'Farkındalık';
    }
  }
}
