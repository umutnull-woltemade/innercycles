// ════════════════════════════════════════════════════════════════════════════
// SHADOW WORK SCREEN - Guided Shadow Integration Journal
// ════════════════════════════════════════════════════════════════════════════
// Dark, introspective UI for exploring shadow archetypes through
// guided prompts with depth progression and breakthrough tracking.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../data/models/shadow_work_entry.dart';
import '../../../data/content/shadow_prompts_content.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../data/services/premium_service.dart';
import '../../../shared/widgets/glass_dialog.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';
import '../../../data/services/l10n_service.dart';

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

    return PopScope(
      canPop: !_hasText,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _showDiscardDialog();
      },
      child: Scaffold(
        body: CosmicBackground(
          child: SafeArea(
            child: shadowAsync.when(
              loading: () => const Center(child: CosmicLoadingIndicator()),
              error: (_, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      L10nService.get('shadow_work.shadow_work.couldnt_load_your_shadow_work', language),
                      textAlign: TextAlign.center,
                      style: AppTypography.decorativeScript(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () =>
                          ref.invalidate(shadowWorkServiceProvider),
                      icon: Icon(Icons.refresh_rounded,
                          size: 16, color: AppColors.starGold),
                      label: Text(
                        L10nService.get('shadow_work.shadow_work.retry', language),
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
              data: (shadowService) {
                return CupertinoScrollbar(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      GlassSliverAppBar(
                        title: L10nService.get('shadow_work.shadow_work.shadow_work', language),
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
                  ),
                );
              },
            ),
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
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
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
            L10nService.get('shadow_work.shadow_work.explore_your_inner_landscape', language),
            variant: GradientTextVariant.amethyst,
            textAlign: TextAlign.center,
            style: AppTypography.displayFont.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            L10nService.get('shadow_work.shadow_work.shadow_work_helps_you_understand_hidden', language),
            style: AppTypography.subtitle(
              fontSize: 14,
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
                  L10nService.get('shadow_work.shadow_work.entries', language),
                  isDark,
                ),
                _buildStatChip(
                  context,
                  '$streak',
                  L10nService.get('shadow_work.shadow_work.streak', language),
                  isDark,
                ),
                _buildStatChip(
                  context,
                  '$breakthroughs',
                  L10nService.get('shadow_work.shadow_work.insights', language),
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
        GradientText(
          value,
          variant: GradientTextVariant.amethyst,
          style: AppTypography.modernAccent(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTypography.subtitle(
            fontSize: 12,
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
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            L10nService.get('shadow_work.shadow_work.choose_an_archetype', language),
            variant: GradientTextVariant.amethyst,
            style: AppTypography.displayFont.copyWith(
              fontSize: 16,
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
                  label: archetype.localizedName(isEn),
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
                      archetype.localizedName(isEn),
                      style:
                          AppTypography.subtitle(
                            fontSize: 12,
                            color: isSelected
                                ? _shadowPurple
                                : (isDark
                                      ? AppColors.textSecondary
                                      : AppColors.lightTextSecondary),
                          ).copyWith(
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
            style: AppTypography.subtitle(
              fontSize: 12,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
              height: 1.4,
            ).copyWith(fontStyle: FontStyle.italic),
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
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
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
                  L10nService.get('shadow_work.todays_prompt', language),
                  variant: GradientTextVariant.amethyst,
                  style: AppTypography.elegantAccent(
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
                  prompt.depth.localizedName(isEn),
                  style: AppTypography.subtitle(
                    fontSize: 10,
                    color: _shadowPurple,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            prompt.localizedPrompt(language),
            style: AppTypography.decorativeScript(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() => _isWriting = true);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                  gradient: LinearGradient(
                    colors: [AppColors.amethyst, AppColors.cosmicAmethyst],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.amethyst.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.edit_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      L10nService.get('shadow_work.shadow_work.begin_writing', language),
                      style: AppTypography.modernAccent(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
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
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
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
            style: AppTypography.subtitle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
              height: 1.6,
            ),
            decoration: InputDecoration(
              hintText: L10nService.get('shadow_work.shadow_work.write_freely_without_judgment', language),
              hintStyle: AppTypography.subtitle(
                color: isDark
                    ? AppColors.textSecondary.withValues(alpha: 0.5)
                    : AppColors.lightTextSecondary.withValues(alpha: 0.5),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          Divider(
            height: 24,
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
          ),

          // Intensity Slider
          Text(
            isEn
                ? 'Emotional Intensity: $_intensity/10'
                : 'Duygusal Yoğunluk: $_intensity/10',
            style: AppTypography.subtitle(
              fontSize: 12,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          Semantics(
            label: L10nService.get('shadow_work.shadow_work.intensity_slider', language),
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
              label: L10nService.get('shadow_work.shadow_work.breakthrough_moment_toggle', language),
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
                        L10nService.get('shadow_work.shadow_work.this_was_a_breakthrough_moment', language),
                        style:
                            AppTypography.subtitle(
                              fontSize: 12,
                              color: _breakthroughMoment
                                  ? _shadowGold
                                  : (isDark
                                        ? AppColors.textSecondary
                                        : AppColors.lightTextSecondary),
                            ).copyWith(
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
            child: GestureDetector(
              onTap: !_hasText
                  ? null
                  : () async {
                      final language = isEn ? AppLanguage.en : AppLanguage.tr;
                      HapticFeedback.mediumImpact();
                      final entry = ShadowWorkEntry(
                        id: '${DateTime.now().millisecondsSinceEpoch}',
                        date: DateTime.now(),
                        archetype: _selectedArchetype,
                        prompt: prompt.localizedPrompt(language),
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
                            L10nService.get('shadow_work.shadow_work.shadow_work_entry_saved', language),
                          ),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
              child: AnimatedOpacity(
                opacity: _hasText ? 1.0 : 0.4,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                    gradient: LinearGradient(
                      colors: [AppColors.amethyst, AppColors.cosmicAmethyst],
                    ),
                    boxShadow: _hasText
                        ? [
                            BoxShadow(
                              color: AppColors.amethyst.withValues(alpha: 0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.save_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        L10nService.get('shadow_work.shadow_work.save_entry', language),
                        style: AppTypography.modernAccent(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
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
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
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
              GradientText(
                L10nService.get('shadow_work.shadow_work.your_shadow_map', language),
                variant: GradientTextVariant.amethyst,
                style: AppTypography.modernAccent(
                  fontSize: 14,
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
                    '${archetype.localizedName(isEn)}: $count',
                child: Row(
                  children: [
                    SizedBox(
                      width: 90,
                      child: Text(
                        archetype.localizedName(isEn),
                        style: AppTypography.subtitle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
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
                        style: AppTypography.subtitle(
                          fontSize: 11,
                          color: _shadowPurple,
                        ).copyWith(fontWeight: FontWeight.w600),
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
              style: AppTypography.subtitle(
                fontSize: 11,
                color: _shadowGold.withValues(alpha: 0.8),
              ).copyWith(fontStyle: FontStyle.italic),
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
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
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
                L10nService.get('shadow_work.shadow_work.recent_entries', language),
                variant: GradientTextVariant.amethyst,
                style: AppTypography.modernAccent(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...entries.map((entry) {
            final language = isEn ? AppLanguage.en : AppLanguage.tr;
            final daysAgo = DateTime.now().difference(entry.date).inDays;
            final dateLabel = daysAgo == 0
                ? (L10nService.get('shadow_work.shadow_work.today', language))
                : daysAgo == 1
                ? (L10nService.get('shadow_work.shadow_work.yesterday', language))
                : (L10nService.getWithParams('shadow_work.days_ago', language, params: {'count': '$daysAgo'}));

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
                                entry.archetype.localizedName(isEn),
                                style: AppTypography.subtitle(
                                  fontSize: 12,
                                  color: _shadowPurple,
                                ).copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            if (entry.breakthroughMoment)
                              Semantics(
                                label: L10nService.get('shadow_work.shadow_work.breakthrough_moment', language),
                                child: Icon(
                                  Icons.lightbulb_rounded,
                                  size: 14,
                                  color: _shadowGold,
                                ),
                              ),
                            const SizedBox(width: 4),
                            Text(
                              dateLabel,
                              style: AppTypography.subtitle(
                                fontSize: 10,
                                color: isDark
                                    ? AppColors.textSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.response,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.subtitle(
                            fontSize: 12,
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

  void _showDiscardDialog() async {
    final language = ref.read(languageProvider);
    final confirmed = await GlassDialog.confirm(
      context,
      title: L10nService.get('shadow_work.shadow_work.discard_changes', language),
      message: L10nService.get('shadow_work.shadow_work.you_have_unsaved_text_are_you_sure_you_w', language),
      cancelLabel: L10nService.get('shadow_work.shadow_work.cancel', language),
      confirmLabel: L10nService.get('shadow_work.shadow_work.discard', language),
      isDestructive: true,
    );
    if (confirmed == true && mounted) {
      Navigator.of(context).pop();
    }
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
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
    if (isPremium) return child;

    return Stack(
      children: [
        ExcludeSemantics(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: child,
            ),
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
                    L10nService.get('shadow_work.shadow_work.unlock_your_shadow_map', language),
                    variant: GradientTextVariant.gold,
                    style: AppTypography.elegantAccent(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => showContextualPaywall(
                      context,
                      ref,
                      paywallContext: PaywallContext.shadowWork,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusMd,
                        ),
                        gradient: const LinearGradient(
                          colors: [AppColors.starGold, AppColors.celestialGold],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.starGold.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        L10nService.get('common.upgrade_to_pro', language),
                        style: AppTypography.modernAccent(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepSpace,
                          letterSpacing: 0.3,
                        ),
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

  static const Color _shadowPurple = AppColors.amethyst;
  static const Color _shadowGold = AppColors.starGold;
}
