// ════════════════════════════════════════════════════════════════════════════
// SHADOW WORK SCREEN - Guided Shadow Integration Journal
// ════════════════════════════════════════════════════════════════════════════
// Dark, introspective UI for exploring shadow archetypes through
// guided prompts with depth progression and breakthrough tracking.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../data/models/shadow_work_entry.dart';
import '../../../data/content/shadow_prompts_content.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../data/services/premium_service.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';

class ShadowWorkScreen extends ConsumerStatefulWidget {
  const ShadowWorkScreen({super.key});

  @override
  ConsumerState<ShadowWorkScreen> createState() => _ShadowWorkScreenState();
}

class _ShadowWorkScreenState extends ConsumerState<ShadowWorkScreen> {
  ShadowArchetype _selectedArchetype = ShadowArchetype.innerCritic;
  final TextEditingController _responseController = TextEditingController();
  int _intensity = 5;
  bool _breakthroughMoment = false;
  bool _isWriting = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _responseController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _responseController.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  void dispose() {
    _responseController.removeListener(_onTextChanged);
    _responseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shadowAsync = ref.watch(shadowWorkServiceProvider);
    final isPremium = ref.watch(isPremiumUserProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: shadowAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => Center(
              child: Text(
                isEn ? 'Something went wrong' : 'Bir şeyler ters gitti',
                style: TextStyle(
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
            data: (shadowService) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: isEn ? 'Shadow Work' : 'Gölge Çalışması',
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(AppConstants.spacingLg),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Hero Section
                        _buildHeroSection(
                          context,
                          shadowService,
                          isDark,
                          isEn,
                        ).glassReveal(context: context),
                        const SizedBox(height: AppConstants.spacingLg),

                        // Archetype Selector
                        _buildArchetypeSelector(
                          context,
                          isDark,
                          isEn,
                        ).glassListItem(context: context, index: 1),
                        const SizedBox(height: AppConstants.spacingLg),

                        // Today's Prompt
                        _buildPromptCard(
                          context,
                          shadowService,
                          isDark,
                          isEn,
                        ).glassListItem(context: context, index: 2),
                        const SizedBox(height: AppConstants.spacingLg),

                        // Response Area (when writing)
                        if (_isWriting) ...[
                          _buildResponseArea(
                            context,
                            shadowService,
                            isDark,
                            isEn,
                          ).glassListItem(context: context, index: 3),
                          const SizedBox(height: AppConstants.spacingLg),
                        ],

                        // Archetype Stats (PREMIUM)
                        if (shadowService.hasData)
                          _buildPremiumGate(
                            context,
                            isDark,
                            isEn,
                            isPremium,
                            child: _buildArchetypeStats(
                              context,
                              shadowService,
                              isDark,
                              isEn,
                            ),
                          ).glassListItem(context: context, index: 4),
                        if (shadowService.hasData)
                          const SizedBox(height: AppConstants.spacingLg),

                        // Recent Entries (PREMIUM)
                        if (shadowService.hasData)
                          _buildPremiumGate(
                            context,
                            isDark,
                            isEn,
                            isPremium,
                            child: _buildRecentEntries(
                              context,
                              shadowService,
                              isDark,
                              isEn,
                            ),
                          ).glassListItem(context: context, index: 5),
                        const SizedBox(height: AppConstants.spacingXl),
                      ]),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // HERO SECTION
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildHeroSection(
    BuildContext context,
    dynamic shadowService,
    bool isDark,
    bool isEn,
  ) {
    final streak = shadowService.getStreak();
    final breakthroughs = shadowService.getBreakthroughCount();
    final totalEntries = shadowService.totalEntries;

    return GlassPanel(
      elevation: GlassElevation.g3,
      glowColor: _shadowPurple.withValues(alpha: 0.3),
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        children: [
          ExcludeSemantics(
            child: Icon(
              Icons.psychology_rounded,
              size: 48,
              color: _shadowPurple,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          GradientText(
            isEn ? 'Explore Your Inner Landscape' : 'İç Dünyani Keşfet',
            variant: GradientTextVariant.amethyst,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isEn
                ? 'Shadow work helps you understand hidden patterns that shape your emotions and behaviors.'
                : 'Gölge çalışması, duygularını ve davranışlarını şekillendiren gizli kalıpları anlamanı sağlar.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          if (totalEntries > 0) ...[
            const SizedBox(height: AppConstants.spacingLg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatChip(
                  context,
                  '$totalEntries',
                  isEn ? 'Entries' : 'Giriş',
                  isDark,
                ),
                _buildStatChip(
                  context,
                  '$streak',
                  isEn ? 'Streak' : 'Seri',
                  isDark,
                ),
                _buildStatChip(
                  context,
                  '$breakthroughs',
                  isEn ? 'Insights' : 'İçgörü',
                  isDark,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    String value,
    String label,
    bool isDark,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: _shadowPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ARCHETYPE SELECTOR
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildArchetypeSelector(BuildContext context, bool isDark, bool isEn) {
    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            isEn ? 'Choose an Archetype' : 'Bir Arketip Seç',
            variant: GradientTextVariant.amethyst,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ShadowArchetype.values.map((archetype) {
              final isSelected = archetype == _selectedArchetype;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedArchetype = archetype;
                    _isWriting = false;
                    _responseController.clear();
                  });
                },
                child: Semantics(
                  label: isEn
                      ? archetype.displayNameEn
                      : archetype.displayNameTr,
                  selected: isSelected,
                  button: true,
                  child: AnimatedContainer(
                    duration: 200.ms,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _shadowPurple.withValues(alpha: 0.3)
                          : (isDark
                                ? Colors.white.withValues(alpha: 0.05)
                                : Colors.black.withValues(alpha: 0.05)),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? _shadowPurple : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      isEn ? archetype.displayNameEn : archetype.displayNameTr,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? _shadowPurple
                            : (isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          // Selected archetype description
          Text(
            isEn
                ? _selectedArchetype.descriptionEn
                : _selectedArchetype.descriptionTr,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // TODAY'S PROMPT
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildPromptCard(
    BuildContext context,
    dynamic shadowService,
    bool isDark,
    bool isEn,
  ) {
    final entryCount = shadowService
        .getEntriesByArchetype(_selectedArchetype)
        .length;
    final prompt = ShadowPromptsContent.getDepthAppropriatePrompt(
      _selectedArchetype,
      entryCount as int,
      DateTime.now(),
    );

    return GlassPanel(
      elevation: GlassElevation.g2,
      glowColor: _shadowGold.withValues(alpha: 0.2),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.auto_fix_high_rounded,
                  size: 20,
                  color: _shadowGold,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GradientText(
                  isEn ? "Today's Prompt" : 'Günün Sorusu',
                  variant: GradientTextVariant.amethyst,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _shadowPurple.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isEn
                      ? prompt.depth.displayNameEn
                      : prompt.depth.displayNameTr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _shadowPurple,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            isEn ? prompt.promptEn : prompt.promptTr,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() => _isWriting = true);
              },
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: Text(isEn ? 'Begin Writing' : 'Yazmaya Başla'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _shadowPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // RESPONSE AREA
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildResponseArea(
    BuildContext context,
    dynamic shadowService,
    bool isDark,
    bool isEn,
  ) {
    final entryCount = shadowService
        .getEntriesByArchetype(_selectedArchetype)
        .length;
    final prompt = ShadowPromptsContent.getDepthAppropriatePrompt(
      _selectedArchetype,
      entryCount as int,
      DateTime.now(),
    );

    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Response text field
          TextField(
            controller: _responseController,
            maxLines: 8,
            minLines: 4,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
              height: 1.6,
            ),
            decoration: InputDecoration(
              hintText: isEn
                  ? 'Write freely, without judgment...'
                  : 'Yargılamadan, özgürce yaz...',
              hintStyle: TextStyle(
                color: isDark
                    ? AppColors.textSecondary.withValues(alpha: 0.5)
                    : AppColors.lightTextSecondary.withValues(alpha: 0.5),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const Divider(height: 24),

          // Intensity Slider
          Text(
            isEn
                ? 'Emotional Intensity: $_intensity/10'
                : 'Duygusal Yoğunluk: $_intensity/10',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          Semantics(
            label: isEn ? 'Intensity slider' : 'Yoğunluk kaydırıcısı',
            value: '$_intensity',
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: _shadowPurple,
                inactiveTrackColor: _shadowPurple.withValues(alpha: 0.2),
                thumbColor: _shadowPurple,
                overlayColor: _shadowPurple.withValues(alpha: 0.1),
              ),
              child: Slider(
                value: _intensity.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                onChanged: (v) {
                  HapticFeedback.selectionClick();
                  setState(() => _intensity = v.round());
                },
              ),
            ),
          ),

          // Breakthrough toggle
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _breakthroughMoment = !_breakthroughMoment);
            },
            child: Semantics(
              label: isEn ? 'Breakthrough moment toggle' : 'İçgörü anı düğmesi',
              toggled: _breakthroughMoment,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 44),
                child: Row(
                  children: [
                    Icon(
                      _breakthroughMoment
                          ? Icons.lightbulb_rounded
                          : Icons.lightbulb_outline_rounded,
                      color: _breakthroughMoment
                          ? _shadowGold
                          : (isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isEn
                            ? 'This was a breakthrough moment'
                            : 'Bu bir içgörü anıydı',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _breakthroughMoment
                              ? _shadowGold
                              : (isDark
                                    ? AppColors.textSecondary
                                    : AppColors.lightTextSecondary),
                          fontWeight: _breakthroughMoment
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: !_hasText
                  ? null
                  : () async {
                      HapticFeedback.mediumImpact();
                      final entry = ShadowWorkEntry(
                        id: '${DateTime.now().millisecondsSinceEpoch}',
                        date: DateTime.now(),
                        archetype: _selectedArchetype,
                        prompt: isEn ? prompt.promptEn : prompt.promptTr,
                        response: _responseController.text.trim(),
                        intensity: _intensity,
                        breakthroughMoment: _breakthroughMoment,
                      );
                      await shadowService.saveEntry(entry);
                      if (!mounted) return;
                      setState(() {
                        _isWriting = false;
                        _responseController.clear();
                        _intensity = 5;
                        _breakthroughMoment = false;
                      });
                      ref.invalidate(shadowWorkServiceProvider);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isEn ? 'Entry saved' : 'Giriş kaydedildi',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
              icon: const Icon(Icons.save_rounded, size: 18),
              label: Text(isEn ? 'Save Entry' : 'Girişi Kaydet'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _shadowPurple,
                foregroundColor: Colors.white,
                disabledBackgroundColor: _shadowPurple.withValues(alpha: 0.3),
                disabledForegroundColor: Colors.white.withValues(alpha: 0.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ARCHETYPE STATS
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildArchetypeStats(
    BuildContext context,
    dynamic shadowService,
    bool isDark,
    bool isEn,
  ) {
    final stats =
        shadowService.getArchetypeStats() as Map<ShadowArchetype, int>;
    if (stats.isEmpty) return const SizedBox.shrink();

    final maxCount = stats.values.reduce((a, b) => a > b ? a : b);

    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.insights_rounded,
                  size: 20,
                  color: _shadowPurple,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isEn ? 'Your Shadow Map' : 'Gölge Haritan',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...ShadowArchetype.values.map((archetype) {
            final count = stats[archetype] ?? 0;
            final ratio = maxCount > 0 ? count / maxCount : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Semantics(
                label:
                    '${isEn ? archetype.displayNameEn : archetype.displayNameTr}: $count',
                child: Row(
                  children: [
                    SizedBox(
                      width: 90,
                      child: Text(
                        isEn
                            ? archetype.displayNameEn
                            : archetype.displayNameTr,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: ratio,
                          backgroundColor: _shadowPurple.withValues(alpha: 0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _shadowPurple.withValues(
                              alpha: 0.4 + (ratio * 0.6),
                            ),
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 24,
                      child: Text(
                        '$count',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _shadowPurple,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          // Unexplored archetypes hint
          if (shadowService.getUnexploredArchetypes().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              isEn
                  ? '${(shadowService.getUnexploredArchetypes() as List).length} archetypes still unexplored'
                  : '${(shadowService.getUnexploredArchetypes() as List).length} arketip henüz keşfedilmedi',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _shadowGold.withValues(alpha: 0.8),
                fontStyle: FontStyle.italic,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // RECENT ENTRIES
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildRecentEntries(
    BuildContext context,
    dynamic shadowService,
    bool isDark,
    bool isEn,
  ) {
    final entries = (shadowService.getEntries() as List<ShadowWorkEntry>)
        .take(5)
        .toList();
    if (entries.isEmpty) return const SizedBox.shrink();

    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.history_rounded,
                  size: 20,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(width: 8),
              GradientText(
                isEn ? 'Recent Entries' : 'Son Girişler',
                variant: GradientTextVariant.amethyst,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...entries.map((entry) {
            final daysAgo = DateTime.now().difference(entry.date).inDays;
            final dateLabel = daysAgo == 0
                ? (isEn ? 'Today' : 'Bugün')
                : daysAgo == 1
                ? (isEn ? 'Yesterday' : 'Dün')
                : (isEn ? '$daysAgo days ago' : '$daysAgo gün önce');

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _shadowPurple.withValues(
                        alpha: 0.3 + (entry.intensity / 10 * 0.7),
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
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
                                isEn
                                    ? entry.archetype.displayNameEn
                                    : entry.archetype.displayNameTr,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: _shadowPurple,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            if (entry.breakthroughMoment)
                              Semantics(
                                label: isEn
                                    ? 'Breakthrough moment'
                                    : 'İçgörü anı',
                                child: Icon(
                                  Icons.lightbulb_rounded,
                                  size: 14,
                                  color: _shadowGold,
                                ),
                              ),
                            const SizedBox(width: 4),
                            Text(
                              dateLabel,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: isDark
                                        ? AppColors.textSecondary
                                        : AppColors.lightTextSecondary,
                                    fontSize: 10,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.response,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: isDark
                                    ? AppColors.textSecondary
                                    : AppColors.lightTextSecondary,
                                height: 1.4,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PREMIUM GATE
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildPremiumGate(
    BuildContext context,
    bool isDark,
    bool isEn,
    bool isPremium, {
    required Widget child,
  }) {
    if (isPremium) return child;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: child,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.3),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 28, color: _shadowGold),
                  const SizedBox(height: 8),
                  GradientText(
                    isEn ? 'Unlock your shadow map' : 'Gölge haritanı aç',
                    variant: GradientTextVariant.gold,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => showContextualPaywall(
                      context,
                      ref,
                      paywallContext: PaywallContext.shadowWork,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _shadowGold,
                      foregroundColor: AppColors.deepSpace,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusMd,
                        ),
                      ),
                    ),
                    child: Text(
                      isEn ? 'Upgrade to Pro' : "Pro'ya Yükselt",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════

  static const Color _shadowPurple = Color(0xFF9C27B0);
  static const Color _shadowGold = Color(0xFFFFD54F);
}
