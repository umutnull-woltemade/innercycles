import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../../core/constants/app_constants.dart';
import '../../../data/services/haptic_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/themed_picker.dart';
import '../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/content/cycle_prompts_content.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/review_service.dart';
import '../../../data/services/smart_router_service.dart';
import '../../../data/services/ecosystem_analytics_service.dart';
import '../../../data/services/widget_data_service.dart';
import '../../streak/presentation/milestone_celebration_modal.dart';
import '../../../data/content/share_card_templates.dart';
import '../../../shared/widgets/share_card_sheet.dart';

import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../data/services/premium_service.dart';
import '../../gratitude/presentation/gratitude_section.dart';
import '../../sleep/presentation/sleep_section.dart';
import '../../../shared/widgets/private_toggle.dart';
import 'widgets/post_save_engagement_sheet.dart';
import 'widgets/voice_input_button.dart';

class DailyEntryScreen extends ConsumerStatefulWidget {
  final DateTime? initialDate;
  final String? journalPrompt;
  final String? retrospectiveDateId;

  const DailyEntryScreen({
    super.key,
    this.initialDate,
    this.journalPrompt,
    this.retrospectiveDateId,
  });

  @override
  ConsumerState<DailyEntryScreen> createState() => _DailyEntryScreenState();
}

class _DailyEntryScreenState extends ConsumerState<DailyEntryScreen> {
  static const _draftKey = 'journal_draft';

  DateTime _selectedDate = DateTime.now();
  FocusArea _selectedArea = FocusArea.energy;
  int _overallRating = 3;
  final Map<String, int> _subRatings = {};
  final _noteController = TextEditingController();
  final _tagController = TextEditingController();
  final List<String> _tags = [];
  bool _isSaving = false;
  bool _isPrivate = false;
  String? _selectedImagePath;
  Timer? _autosaveTimer;

  /// Stores the note text before a voice session starts, so partial
  /// results can be appended without duplicating previous voice output.
  String _textBeforeVoice = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate!;
    }
    _initSubRatings();
    _loadDraft();
    _noteController.addListener(_scheduleDraftSave);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(smartRouterServiceProvider)
          .whenData((s) => s.recordToolVisit('journal'));
      ref
          .read(ecosystemAnalyticsServiceProvider)
          .whenData((s) => s.trackToolOpen('journal', source: 'direct'));
    });
  }

  void _initSubRatings() {
    _subRatings.clear();
    for (final key in _selectedArea.subRatingKeys) {
      _subRatings[key] = 3;
    }
  }

  @override
  void dispose() {
    _autosaveTimer?.cancel();
    _saveDraft();
    _noteController.removeListener(_scheduleDraftSave);
    _noteController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _scheduleDraftSave() {
    _autosaveTimer?.cancel();
    _autosaveTimer = Timer(const Duration(seconds: 2), _saveDraft);
  }

  Future<void> _saveDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draft = {
        'date': _selectedDate.toIso8601String(),
        'area': _selectedArea.index,
        'rating': _overallRating,
        'subRatings': _subRatings,
        'note': _noteController.text,
        'image': _selectedImagePath,
        'tags': _tags,
      };
      await prefs.setString(_draftKey, jsonEncode(draft));
    } catch (e) {
      if (kDebugMode) debugPrint('DailyEntry: draft save failed: $e');
    }
  }

  Future<void> _loadDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_draftKey);
      if (raw == null) return;
      final draft = jsonDecode(raw) as Map<String, dynamic>;
      if (!mounted) return;
      setState(() {
        _selectedDate =
            DateTime.tryParse(draft['date'] as String? ?? '') ?? DateTime.now();
        final areaIdx = draft['area'] as int? ?? 0;
        _selectedArea =
            FocusArea.values[areaIdx.clamp(0, FocusArea.values.length - 1)];
        _overallRating = (draft['rating'] as int? ?? 3).clamp(1, 5);
        _initSubRatings();
        final saved = draft['subRatings'] as Map<String, dynamic>? ?? {};
        for (final e in saved.entries) {
          if (_subRatings.containsKey(e.key)) {
            _subRatings[e.key] = (e.value as int? ?? 3).clamp(1, 5);
          }
        }
        final note = draft['note'] as String? ?? '';
        if (note.isNotEmpty) _noteController.text = note;
        _selectedImagePath = draft['image'] as String?;
        _tags.clear();
        final savedTags = draft['tags'] as List<dynamic>? ?? [];
        _tags.addAll(savedTags.map((e) => e.toString()));
      });
    } catch (e) {
      if (kDebugMode) debugPrint('DailyEntry: draft load failed: $e');
    }
  }

  Future<void> _clearDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_draftKey);
    } catch (e) {
      if (kDebugMode) debugPrint('DailyEntry: clearDraft failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;

    return Scaffold(
      body: CosmicBackground(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          behavior: HitTestBehavior.opaque,
          child: SafeArea(
            child: CupertinoScrollbar(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: isEn ? 'Log Your Day' : 'Gününü Kaydet',
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(AppConstants.spacingLg),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Date selector
                        _buildDateSelector(context, isDark, isEn),
                        const SizedBox(height: AppConstants.spacingSm),

                        const SizedBox(height: AppConstants.spacingMd),

                        // Focus area selector
                        _buildSectionLabel(
                          context,
                          isDark,
                          isEn ? 'Focus Area' : 'Odak Alanı',
                        ),
                        const SizedBox(height: AppConstants.spacingMd),
                        _buildFocusAreaSelector(isDark, isEn),
                        const SizedBox(height: AppConstants.spacingXl),

                        // Overall rating
                        _buildSectionLabel(
                          context,
                          isDark,
                          isEn ? 'Overall Rating' : 'Genel Değerlendirme',
                        ),
                        const SizedBox(height: AppConstants.spacingMd),
                        _buildRatingSlider(isDark, isEn, _overallRating, (v) {
                          setState(() => _overallRating = v);
                          _scheduleDraftSave();
                        }),
                        const SizedBox(height: AppConstants.spacingXl),

                        // Sub-ratings (adaptive: collapsed if abandonment >40%)
                        _buildAdaptiveSubRatings(context, isDark, isEn),
                        const SizedBox(height: AppConstants.spacingXl),

                        // Note
                        _buildSectionLabel(
                          context,
                          isDark,
                          isEn ? 'Notes (optional)' : 'Notlar (opsiyonel)',
                        ),
                        const SizedBox(height: AppConstants.spacingMd),
                        _CyclePhasePromptHint(isEn: isEn, isDark: isDark),
                        _buildNoteField(isDark, isEn),
                        const SizedBox(height: AppConstants.spacingXl),

                        // Tags (optional)
                        _buildSectionLabel(
                          context,
                          isDark,
                          isEn ? 'Tags (optional)' : 'Etiketler (opsiyonel)',
                        ),
                        const SizedBox(height: AppConstants.spacingMd),
                        _buildTagSection(isDark, isEn),
                        const SizedBox(height: AppConstants.spacingXl),

                        // Photo attachment
                        if (!kIsWeb) ...[
                          _buildSectionLabel(
                            context,
                            isDark,
                            isEn ? 'Photo (optional)' : 'Fotoğraf (opsiyonel)',
                          ),
                          const SizedBox(height: AppConstants.spacingMd),
                          _buildPhotoPicker(isDark, isEn),
                          const SizedBox(height: AppConstants.spacingXl),
                        ],

                        // Gratitude section (collapsible)
                        GratitudeSection(
                          date: _selectedDate,
                          isPremium: ref.watch(isPremiumUserProvider),
                        ),
                        const SizedBox(height: AppConstants.spacingXl),

                        // Sleep quality section (collapsible)
                        SleepSection(date: _selectedDate),
                        const SizedBox(height: AppConstants.spacingXl),

                        // Private vault toggle
                        if (!kIsWeb)
                          PrivateToggle(
                            isPrivate: _isPrivate,
                            onChanged: (v) => setState(() => _isPrivate = v),
                            isEn: isEn,
                            isDark: isDark,
                          ),
                        if (!kIsWeb)
                          const SizedBox(height: AppConstants.spacingXl),

                        // Save button
                        _buildSaveButton(isDark, isEn),
                        const SizedBox(height: 40),
                      ]),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, duration: 400.ms),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, bool isDark, bool isEn) {
    final dayName = _getDayName(_selectedDate, isEn);
    final dateStr =
        '${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}';

    return Semantics(
      label: isEn
          ? 'Select date: $dayName $dateStr'
          : 'Tarih seç: $dayName $dateStr',
      button: true,
      child: GestureDetector(
        onTap: () async {
          HapticService.dateSelected();
          final now = DateTime.now();
          final picked = await ThemedPicker.showDate(
            context,
            initialDate: _selectedDate,
            firstDate: widget.initialDate != null
                ? DateTime(1950)
                : now.subtract(const Duration(days: 365)),
            lastDate: now,
          );
          if (picked != null && mounted) {
            setState(() => _selectedDate = picked);
            _scheduleDraftSave();
          }
        },
        child: GlassPanel(
          elevation: GlassElevation.g2,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: AppColors.starGold, size: 24),
              const SizedBox(width: AppConstants.spacingMd),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayName,
                    style: AppTypography.displayFont.copyWith(
                      fontSize: 20,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    dateStr,
                    style: AppTypography.subtitle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                Icons.edit_calendar,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    ).glassReveal(context: context);
  }

  Widget _buildSectionLabel(BuildContext context, bool isDark, String label) {
    return GradientText(
      label.toUpperCase(),
      variant: GradientTextVariant.gold,
      style: AppTypography.elegantAccent(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildFocusAreaSelector(bool isDark, bool isEn) {
    return Wrap(
      spacing: AppConstants.spacingSm,
      runSpacing: AppConstants.spacingSm,
      children: FocusArea.values.map((area) {
        final isSelected = area == _selectedArea;
        final label = isEn ? area.displayNameEn : area.displayNameTr;
        final icon = _getAreaIcon(area);

        return Semantics(
          button: true,
          label: label,
          selected: isSelected,
          child: GestureDetector(
            onTap: () {
              HapticService.moodSelected();
              setState(() {
                _selectedArea = area;
                _initSubRatings();
              });
              _scheduleDraftSave();
            },
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 44),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMd,
                  vertical: AppConstants.spacingSm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.starGold.withValues(alpha: 0.2)
                      : (isDark
                            ? AppColors.surfaceDark.withValues(alpha: 0.5)
                            : AppColors.lightSurfaceVariant),
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  border: Border.all(
                    color: isSelected ? AppColors.starGold : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.starGold.withValues(alpha: 0.2),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 18,
                      color: isSelected
                          ? AppColors.starGold
                          : (isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: isSelected
                          ? AppTypography.modernAccent(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.starGold,
                            )
                          : AppTypography.subtitle(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ).glassListItem(context: context, index: 1);
  }

  Widget _buildRatingSlider(
    bool isDark,
    bool isEn,
    int value,
    ValueChanged<int> onChanged,
  ) {
    final labels = isEn
        ? ['Low', 'Below Avg', 'Average', 'Good', 'Excellent']
        : ['Düşük', 'Ortanın Altı', 'Orta', 'İyi', 'Mükemmel'];

    return GlassPanel(
      elevation: GlassElevation.g2,
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (i) {
              final rating = i + 1;
              final isActive = rating == value;
              return Semantics(
                button: true,
                label: '${isEn ? 'Rating' : 'Puan'} $rating',
                selected: isActive,
                child: GestureDetector(
                  onTap: () {
                    HapticService.ratingChanged();
                    onChanged(rating);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? AppColors.starGold
                          : (isDark
                                ? AppColors.surfaceLight.withValues(alpha: 0.3)
                                : AppColors.lightSurfaceVariant),
                      border: Border.all(
                        color: isActive
                            ? AppColors.starGold
                            : (isDark
                                  ? Colors.white.withValues(alpha: 0.15)
                                  : Colors.black.withValues(alpha: 0.1)),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$rating',
                        style: AppTypography.modernAccent(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isActive
                              ? AppColors.deepSpace
                              : (isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            labels[(value - 1).clamp(0, labels.length - 1)],
            style: AppTypography.elegantAccent(
              fontSize: 14,
              color: AppColors.starGold,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    ).glassListItem(context: context, index: 2);
  }

  /// Adaptive sub-ratings: if telemetry shows >40% entry abandonment,
  /// collapse sub-ratings into an expandable section to reduce friction.
  Widget _buildAdaptiveSubRatings(
    BuildContext context,
    bool isDark,
    bool isEn,
  ) {
    final telemetryAsync = ref.watch(telemetryServiceProvider);
    final shouldSimplify =
        telemetryAsync.whenOrNull(data: (t) => t.shouldSimplifyEntryForm) ??
        false;

    if (shouldSimplify) {
      // Collapsed mode: show expandable tile
      return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Text(
            isEn ? 'Details (optional)' : 'Detaylar (opsiyonel)',
            style: AppTypography.elegantAccent(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextPrimary,
              letterSpacing: 1.0,
            ),
          ),
          children: [_buildSubRatings(isDark, isEn)],
        ),
      );
    }

    // Full mode: always show sub-ratings
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(context, isDark, isEn ? 'Details' : 'Detaylar'),
        const SizedBox(height: AppConstants.spacingMd),
        _buildSubRatings(isDark, isEn),
      ],
    );
  }

  Widget _buildSubRatings(bool isDark, bool isEn) {
    final names = isEn
        ? _selectedArea.subRatingNamesEn
        : _selectedArea.subRatingNamesTr;

    return GlassPanel(
      elevation: GlassElevation.g2,
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        children: _selectedArea.subRatingKeys.map((key) {
          final label = names[key] ?? key;
          final value = _subRatings[key] ?? 3;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    label,
                    style: AppTypography.subtitle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: AppColors.starGold,
                      inactiveTrackColor: isDark
                          ? AppColors.surfaceLight.withValues(alpha: 0.3)
                          : AppColors.lightSurfaceVariant,
                      thumbColor: AppColors.starGold,
                      overlayColor: AppColors.starGold.withValues(alpha: 0.2),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: value.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      semanticFormatterCallback: (v) => '$label: ${v.round()}',
                      onChanged: (v) {
                        HapticService.ratingChanged();
                        setState(() => _subRatings[key] = v.round());
                        _scheduleDraftSave();
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 24,
                  child: Text(
                    '$value',
                    textAlign: TextAlign.center,
                    style: AppTypography.modernAccent(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.starGold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    ).glassListItem(context: context, index: 3);
  }

  Widget _buildNoteField(bool isDark, bool isEn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassPanel(
          elevation: GlassElevation.g2,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              TextField(
                controller: _noteController,
                maxLines: 4,
                maxLength: 2000,
                style: AppTypography.subtitle(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText:
                      widget.journalPrompt ??
                      (isEn
                          ? 'How was your day? Any reflections...'
                          : 'Bugün nasıl geçti? Düşüncelerin...'),
                  hintStyle: AppTypography.decorativeScript(
                    fontSize: 16,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                  contentPadding: const EdgeInsets.all(AppConstants.spacingLg),
                  border: InputBorder.none,
                  counterStyle: TextStyle(
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ),
              // Voice input row
              Padding(
                padding: const EdgeInsets.only(
                  left: AppConstants.spacingMd,
                  right: AppConstants.spacingMd,
                  bottom: AppConstants.spacingSm,
                ),
                child: Row(
                  children: [
                    VoiceInputButton(
                      localeId: isEn ? 'en_US' : 'tr_TR',
                      size: 40,
                      onListeningStateChanged: (listening) {
                        if (listening) {
                          // Snapshot current text when voice starts
                          _textBeforeVoice = _noteController.text;
                        } else {
                          // Reset snapshot when voice stops
                          _textBeforeVoice = '';
                        }
                      },
                      onTextRecognized: (text) {
                        if (text.isNotEmpty) {
                          setState(() {
                            // Combine base text with latest voice result
                            if (_textBeforeVoice.isNotEmpty) {
                              _noteController.text = '$_textBeforeVoice $text';
                            } else {
                              _noteController.text = text;
                            }

                            // Move cursor to end
                            _noteController
                                .selection = TextSelection.fromPosition(
                              TextPosition(offset: _noteController.text.length),
                            );
                          });
                        }
                      },
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                    Text(
                      isEn ? 'Tap to speak' : 'Konuşmak için dokun',
                      style: AppTypography.elegantAccent(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ).glassListItem(context: context, index: 4);
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      HapticService.buttonPress();
      setState(() => _tags.add(tag));
      _tagController.clear();
      _scheduleDraftSave();
    }
  }

  Widget _buildTagSection(bool isDark, bool isEn) {
    return GlassPanel(
      elevation: GlassElevation.g2,
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Existing tags as removable chips
          if (_tags.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 5,
                        top: 6,
                        bottom: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.starGold.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tag,
                            style: AppTypography.subtitle(
                              fontSize: 13,
                              color: AppColors.starGold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              setState(() => _tags.remove(tag));
                              _scheduleDraftSave();
                            },
                            child: Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: (isDark ? Colors.white : Colors.black)
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
          ],
          // Tag input row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _tagController,
                  style: AppTypography.subtitle(
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: isEn ? 'Add tag...' : 'Etiket ekle...',
                    hintStyle: AppTypography.subtitle(
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                    isDense: true,
                    filled: true,
                    fillColor: (isDark ? Colors.white : Colors.black)
                        .withValues(alpha: 0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  onSubmitted: (_) => _addTag(),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _addTag,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.starGold.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    size: 18,
                    color: AppColors.starGold,
                  ),
                ),
              ),
            ],
          ),
          // Smart tag suggestions from frequent tags
          _TagSuggestions(
            currentTags: _tags,
            isDark: isDark,
            isEn: isEn,
            onTagSelected: (tag) {
              if (!_tags.contains(tag)) {
                HapticService.buttonPress();
                setState(() => _tags.add(tag));
                _scheduleDraftSave();
              }
            },
          ),
        ],
      ),
    ).glassListItem(context: context, index: 4);
  }

  Widget _buildPhotoPicker(bool isDark, bool isEn) {
    if (_selectedImagePath != null) {
      return GlassPanel(
        elevation: GlassElevation.g2,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              child: Image.file(
                File(_selectedImagePath!),
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                cacheWidth: 800,
                cacheHeight: 360,
                semanticLabel: isEn ? 'Journal photo' : 'Günlük fotoğrafı',
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(
                    Icons.swap_horiz,
                    size: 18,
                    color: AppColors.auroraStart,
                  ),
                  label: Text(
                    isEn ? 'Change' : 'Değiştir',
                    style: AppTypography.modernAccent(
                      color: AppColors.auroraStart,
                      fontSize: 13,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() => _selectedImagePath = null);
                    _scheduleDraftSave();
                  },
                  icon: Icon(
                    Icons.close,
                    size: 18,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                  label: Text(
                    isEn ? 'Remove' : 'Kaldır',
                    style: AppTypography.subtitle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ).glassListItem(context: context, index: 4);
    }

    return Semantics(
      label: isEn ? 'Add a photo' : 'Fotoğraf ekle',
      button: true,
      child: GestureDetector(
        onTap: () {
          HapticService.buttonPress();
          _pickImage();
        },
        child: GlassPanel(
          elevation: GlassElevation.g2,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo_outlined,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                size: 22,
              ),
              const SizedBox(width: AppConstants.spacingSm),
              Text(
                isEn ? 'Add a photo' : 'Fotoğraf ekle',
                style: AppTypography.subtitle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    ).glassListItem(context: context, index: 4);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (picked != null) {
      try {
        // Copy to app documents directory for persistence
        final appDir = await getApplicationDocumentsDirectory();
        final journalDir = Directory('${appDir.path}/journal_photos');
        if (!await journalDir.exists()) {
          await journalDir.create(recursive: true);
        }
        final ext = p.extension(picked.path);
        final savedPath =
            '${journalDir.path}/${DateTime.now().millisecondsSinceEpoch}$ext';
        await File(picked.path).copy(savedPath);
        if (!mounted) return;
        setState(() => _selectedImagePath = savedPath);
        _scheduleDraftSave();
      } catch (_) {
        // File copy failed (disk full, permission denied, etc.)
        if (!mounted) return;
      }
    }
  }

  Widget _buildSaveButton(bool isDark, bool isEn) {
    return GestureDetector(
      onTap: _isSaving ? null : _saveEntry,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isSaving
                ? [
                    AppColors.starGold.withValues(alpha: 0.5),
                    AppColors.celestialGold.withValues(alpha: 0.5),
                  ]
                : [AppColors.starGold, AppColors.celestialGold],
          ),
          boxShadow: _isSaving
              ? null
              : [
                  BoxShadow(
                    color: AppColors.starGold.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Center(
          child: _isSaving
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CupertinoActivityIndicator(),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_rounded,
                      size: 22,
                      color: AppColors.deepSpace,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isEn ? 'Save Entry' : 'Kaydet',
                      style: AppTypography.modernAccent(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepSpace,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    ).glassListItem(context: context, index: 5);
  }

  Future<void> _saveEntry() async {
    setState(() => _isSaving = true);
    try {
      final service = await ref.read(journalServiceProvider.future);
      await service.saveEntry(
        date: _selectedDate,
        focusArea: _selectedArea,
        overallRating: _overallRating,
        subRatings: Map.from(_subRatings),
        note: _noteController.text.isNotEmpty ? _noteController.text : null,
        imagePath: _selectedImagePath,
        tags: List<String>.from(_tags),
        isPrivate: _isPrivate,
      );

      if (!mounted) return;

      // Link retrospective date if applicable
      if (widget.retrospectiveDateId != null) {
        try {
          final retroService = await ref.read(
            retrospectiveDateServiceProvider.future,
          );
          await retroService.linkJournalEntry(
            widget.retrospectiveDateId!,
            'linked', // journal entry ID from save
          );
        } catch (_) {}
      }

      // Clear draft on successful save
      await _clearDraft();

      // Invalidate providers to refresh data
      ref.invalidate(todayJournalEntryProvider);
      ref.invalidate(journalStreakProvider);
      if (_isPrivate) ref.invalidate(privateJournalEntriesProvider);

      // Track output for SmartRouter (feeds rule R3)
      ref
          .read(smartRouterServiceProvider)
          .whenData((s) => s.recordOutput('journal', 'entry'));
      ref
          .read(ecosystemAnalyticsServiceProvider)
          .whenData((s) => s.trackToolOutput('journal', 'entry'));

      // Update notification lifecycle with new activity
      _updateNotificationLifecycle(service);

      // Check for review prompt at engagement milestones
      _checkReviewTrigger(service);

      // Push fresh data to iOS widgets
      _updateWidgetData(service);

      // Increment progressive unlock entry count
      ref.read(progressiveUnlockServiceProvider).whenData((unlock) async {
        await unlock.incrementEntryCount();
        // Check for newly unlocked features
        final newlyUnlocked = unlock.getNewlyUnlockedFeatures();
        for (final feature in newlyUnlocked) {
          HapticService.featureUnlocked();
          await unlock.markFeatureShown(feature);
        }
      });

      // Track telemetry
      ref.read(telemetryServiceProvider).whenData((telemetry) {
        telemetry.entryCompleted(
          focusArea: _selectedArea.name,
          durationSeconds: 0,
          hasNote: _noteController.text.isNotEmpty,
          hasPhoto: _selectedImagePath != null,
        );
      });

      // Check for first-ever entry celebration
      final entryCount = service.entryCount;
      if (entryCount == 1 && mounted) {
        await _showFirstEntryCelebration();
      }

      // Check for streak milestone celebration (D3, D7, D14, etc.)
      await _checkStreakMilestone();

      // Check for streak share nudge (every 5 entries, non-milestone)
      await _checkStreakShareNudge();

      if (mounted) {
        HapticService.entryCompleted();
        final streak = service.getCurrentStreak();

        // Show engagement bottom sheet instead of simple SnackBar
        PostSaveEngagementSheet.show(
          context,
          entryCount: entryCount,
          currentStreak: streak,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ref.read(languageProvider) == AppLanguage.en
                  ? 'Entry not saved. Try again — your text is preserved.'
                  : 'Giriş kaydedilemedi. Tekrar dene — yazın korunuyor.',
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _updateNotificationLifecycle(dynamic journalService) async {
    try {
      final nlcService = await ref.read(
        notificationLifecycleServiceProvider.future,
      );
      await nlcService.recordActivity();
      await nlcService.evaluate(journalService);
    } catch (e) {
      if (kDebugMode)
        debugPrint('DailyEntry: notification lifecycle error: $e');
    }
  }

  Future<void> _checkReviewTrigger(dynamic service) async {
    try {
      final reviewService = await ref.read(reviewServiceProvider.future);
      final streak = service.getCurrentStreak();
      final entryCount = service.entryCount;
      await reviewService.checkAndPromptReview(
        ReviewTrigger.streakMilestone,
        currentStreak: streak,
        journalEntryCount: entryCount,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('DailyEntry: review trigger error: $e');
    }
  }

  Future<void> _updateWidgetData(dynamic service) async {
    try {
      final widgetService = WidgetDataService();
      if (!widgetService.isSupported) return;

      final isEn = ref.read(languageProvider) == AppLanguage.en;
      final streak = service.getCurrentStreak();
      final moodEmoji = _ratingToMoodEmoji(_overallRating);
      final moodLabel = _ratingToMoodLabel(_overallRating, isEn);

      await widgetService.updateDailyReflection(
        moodEmoji: moodEmoji,
        moodLabel: moodLabel,
        dailyPrompt: isEn
            ? 'How did your day feel?'
            : 'Günün nasıl hissettirdi?',
        focusArea: isEn
            ? _selectedArea.displayNameEn
            : _selectedArea.displayNameTr,
        streakDays: streak,
        moodRating: _overallRating,
      );

      await widgetService.updateMoodInsight(
        currentMood: moodLabel,
        moodEmoji: moodEmoji,
        energyLevel: (_overallRating * 20).clamp(0, 100),
        advice: isEn
            ? 'Keep journaling to reveal your patterns'
            : 'Kalıplarını ortaya çıkarmak için yazmaya devam et',
      );

      await widgetService.updateLockScreen(
        moodEmoji: moodEmoji,
        accentEmoji: _focusAreaEmoji(_selectedArea),
        shortMessage: isEn ? '$streak day streak' : '$streak gün seri',
        energyLevel: _overallRating,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('DailyEntry: widget update error: $e');
    }
  }

  Future<void> _showFirstEntryCelebration() async {
    if (!mounted) return;
    final isEn = ref.read(languageProvider) == AppLanguage.en;
    HapticFeedback.heavyImpact();

    await showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [AppColors.cosmicPurple, AppColors.deepSpace]
                    : [
                        AppColors.lightSurface,
                        AppColors.lightSurfaceVariant,
                      ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.starGold.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.starGold.withValues(alpha: 0.15),
                  blurRadius: 40,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('\u{1F31F}', style: const TextStyle(fontSize: 56))
                    .animate()
                    .scale(
                      begin: const Offset(0.3, 0.3),
                      end: const Offset(1, 1),
                      duration: 500.ms,
                      curve: Curves.elasticOut,
                    )
                    .shimmer(delay: 500.ms, duration: 1200.ms),
                const SizedBox(height: 16),
                GradientText(
                  isEn ? 'Your Journey Begins' : 'Yolculuğun Başlıyor',
                  variant: GradientTextVariant.gold,
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                const SizedBox(height: 12),
                Text(
                  isEn
                      ? 'You just wrote your first reflection.\nEvery great story starts with a single page.'
                      : 'İlk yansımanı yazdın.\nHer büyük hikaye tek bir sayfayla başlar.',
                  style: AppTypography.decorativeScript(
                    fontSize: 16,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
                const SizedBox(height: 24),
                GradientButton.gold(
                  label: isEn ? 'Continue' : 'Devam Et',
                  onPressed: () => Navigator.of(ctx).pop(),
                ).animate().fadeIn(delay: 600.ms, duration: 300.ms),
              ],
            ),
          ).animate().scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: 400.ms,
                curve: Curves.easeOutBack,
              ),
        );
      },
    );
  }

  Future<void> _checkStreakMilestone() async {
    try {
      final streakService = await ref.read(streakServiceProvider.future);
      final milestone = streakService.checkForNewMilestone();

      if (milestone != null && mounted) {
        await streakService.celebrateMilestone(milestone);
        final isEn = ref.read(languageProvider) == AppLanguage.en;
        if (mounted) {
          MilestoneCelebrationModal.show(context, milestone, isEn);
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('DailyEntry: streak milestone error: $e');
    }
  }

  /// Streak milestones that already have a celebration modal
  static const _milestoneDays = {3, 7, 14, 30, 60, 90, 180, 365};

  Future<void> _checkStreakShareNudge() async {
    try {
      final service = await ref.read(journalServiceProvider.future);
      final streak = service.getCurrentStreak();

      // Only fire on multiples of 5 that are NOT milestone days
      if (streak < 5 || streak % 5 != 0 || _milestoneDays.contains(streak)) {
        return;
      }

      // Don't show if we already nudged for this streak count
      final prefs = await SharedPreferences.getInstance();
      final lastNudgedStreak = prefs.getInt('streak_nudge_last') ?? 0;
      if (lastNudgedStreak >= streak) return;

      await prefs.setInt('streak_nudge_last', streak);

      if (!mounted) return;

      final isEn = ref.read(languageProvider) == AppLanguage.en;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEn
                ? '$streak-day streak! Share your progress?'
                : '$streak günlük seri! İlerlemeni paylaş?',
          ),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: isEn ? 'Share' : 'Paylaş',
            onPressed: () {
              if (!mounted) return;
              ShareCardSheet.show(
                context,
                template: ShareCardTemplates.streakFlame,
                data: ShareCardTemplates.buildData(
                  template: ShareCardTemplates.streakFlame,
                  isEn: isEn,
                  streak: streak,
                ),
                isEn: isEn,
              );
            },
          ),
        ),
      );
    } catch (e) {
      if (kDebugMode) debugPrint('DailyEntry: streak share nudge error: $e');
    }
  }

  static String _ratingToMoodEmoji(int rating) {
    switch (rating) {
      case 1:
        return '\u{1F614}'; // pensive
      case 2:
        return '\u{1F615}'; // confused
      case 3:
        return '\u{1F610}'; // neutral
      case 4:
        return '\u{1F60A}'; // smiling
      case 5:
        return '\u{1F929}'; // star-struck
      default:
        return '\u{1F610}';
    }
  }

  static String _ratingToMoodLabel(int rating, bool isEn) {
    switch (rating) {
      case 1:
        return isEn ? 'Difficult' : 'Zor';
      case 2:
        return isEn ? 'Low' : 'Düşük';
      case 3:
        return isEn ? 'Neutral' : 'Nötr';
      case 4:
        return isEn ? 'Good' : 'İyi';
      case 5:
        return isEn ? 'Great' : 'Harika';
      default:
        return isEn ? 'Neutral' : 'Nötr';
    }
  }

  static String _focusAreaEmoji(FocusArea area) {
    switch (area) {
      case FocusArea.energy:
        return '\u{26A1}';
      case FocusArea.focus:
        return '\u{1F3AF}';
      case FocusArea.emotions:
        return '\u{1F49C}';
      case FocusArea.decisions:
        return '\u{1F9ED}';
      case FocusArea.social:
        return '\u{1F91D}';
    }
  }

  IconData _getAreaIcon(FocusArea area) {
    switch (area) {
      case FocusArea.energy:
        return Icons.bolt;
      case FocusArea.focus:
        return Icons.center_focus_strong;
      case FocusArea.emotions:
        return Icons.favorite_border;
      case FocusArea.decisions:
        return Icons.compass_calibration;
      case FocusArea.social:
        return Icons.people_outline;
    }
  }

  String _getDayName(DateTime date, bool isEn) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(date.year, date.month, date.day);
    final diff = today.difference(selected).inDays;

    if (diff == 0) return isEn ? 'Today' : 'Bugün';
    if (diff == 1) return isEn ? 'Yesterday' : 'Dün';

    final days = isEn
        ? [
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday',
            'Sunday',
          ]
        : [
            'Pazartesi',
            'Salı',
            'Çarşamba',
            'Perşembe',
            'Cuma',
            'Cumartesi',
            'Pazar',
          ];
    return days[date.weekday - 1];
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TAG SUGGESTIONS - Shows frequent tags as quick-add chips
// ═══════════════════════════════════════════════════════════════════════════

class _TagSuggestions extends ConsumerWidget {
  final List<String> currentTags;
  final bool isDark;
  final bool isEn;
  final ValueChanged<String> onTagSelected;

  const _TagSuggestions({
    required this.currentTags,
    required this.isDark,
    required this.isEn,
    required this.onTagSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(journalServiceProvider);
    return serviceAsync.when(
      data: (service) {
        final suggestions = service
            .getFrequentTags(limit: 8)
            .where((t) => !currentTags.contains(t))
            .toList();
        if (suggestions.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: suggestions
                .map(
                  (tag) => GestureDetector(
                    onTap: () => onTagSelected(tag),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: (isDark ? Colors.white : Colors.black)
                              .withValues(alpha: 0.1),
                        ),
                      ),
                      child: Text(
                        '+ $tag',
                        style: AppTypography.subtitle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CYCLE PHASE PROMPT HINT - Contextual suggestion above note field
// ═══════════════════════════════════════════════════════════════════════════

class _CyclePhasePromptHint extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const _CyclePhasePromptHint({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleSyncAsync = ref.watch(cycleSyncServiceProvider);

    return cycleSyncAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        if (!service.hasData) return const SizedBox.shrink();
        final phase = service.getCurrentPhase();
        if (phase == null) return const SizedBox.shrink();

        final prompt = CyclePromptsContent.getPromptForDate(
          phase,
          DateTime.now(),
        );

        return Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.amethyst.withValues(alpha: isDark ? 0.08 : 0.05),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: AppColors.amethyst.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.water_drop_rounded,
                  size: 16,
                  color: AppColors.amethyst.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isEn ? prompt.promptEn : prompt.promptTr,
                    style: AppTypography.decorativeScript(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
