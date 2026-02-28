// ════════════════════════════════════════════════════════════════════════════
// LIFE EVENT SCREEN - Create / Edit Life Events
// ════════════════════════════════════════════════════════════════════════════

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/themed_picker.dart';
import '../../../data/models/life_event.dart';
import '../../../data/content/life_event_presets.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/haptic_service.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_dialog.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../data/services/l10n_service.dart';

class LifeEventScreen extends ConsumerStatefulWidget {
  final String? editId;
  final String? initialDate; // yyyy-MM-dd from calendar tap

  const LifeEventScreen({super.key, this.editId, this.initialDate});

  @override
  ConsumerState<LifeEventScreen> createState() => _LifeEventScreenState();
}

class _LifeEventScreenState extends ConsumerState<LifeEventScreen> {
  LifeEventType _selectedType = LifeEventType.positive;
  LifeEventPreset? _selectedPreset;
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  int _intensity = 3;
  final List<String> _emotionTags = [];
  String? _imagePath;
  bool _isSaving = false;
  bool _isEditing = false;
  bool _hasChanges = false;
  LifeEvent? _existingEvent;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      final parsed = DateTime.tryParse(widget.initialDate!);
      if (parsed != null) _selectedDate = parsed;
    }
    if (widget.editId != null) {
      _isEditing = true;
      _loadExistingEvent();
    }
    _titleController.addListener(_markChanged);
    _noteController.addListener(_markChanged);
  }

  void _markChanged() {
    if (!_hasChanges) setState(() => _hasChanges = true);
  }

  void _loadExistingEvent() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final service = ref.read(lifeEventServiceProvider).valueOrNull;
      if (service == null) return;
      final event = service.getEvent(widget.editId!);
      if (event == null) return;
      setState(() {
        _existingEvent = event;
        _selectedType = event.type;
        _selectedDate = event.date;
        _intensity = event.intensity;
        _emotionTags.addAll(event.emotionTags);
        _imagePath = event.imagePath;
        _noteController.text = event.note ?? '';
        _titleController.text = event.title;
        if (event.eventKey != null) {
          _selectedPreset = LifeEventPresets.getByKey(event.eventKey!);
        }
      });
    });
  }

  @override
  void dispose() {
    _titleController.removeListener(_markChanged);
    _noteController.removeListener(_markChanged);
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _showDiscardDialog();
      },
      child: Scaffold(
        body: CosmicBackground(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: CupertinoScrollbar(
              child: CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: _isEditing
                        ? (L10nService.get('life_events.life_event.edit_life_event', language))
                        : (L10nService.get('life_events.life_event.new_life_event', language)),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // 1. Event Type Selector
                        _buildTypeSelector(isDark, isEn),
                        const SizedBox(height: 20),

                        // 2. Preset Picker or Custom Title
                        if (_selectedType != LifeEventType.custom)
                          _buildPresetPicker(isDark, isEn)
                        else
                          _buildCustomTitle(isDark, isEn),
                        const SizedBox(height: 20),

                        // 3. Date Picker
                        _buildDatePicker(context, isDark, isEn),
                        const SizedBox(height: 20),

                        // 4. Emotion Tags
                        _buildEmotionTags(isDark, isEn),
                        const SizedBox(height: 20),

                        // 5. Intensity Slider
                        _buildIntensitySlider(isDark, isEn),
                        const SizedBox(height: 20),

                        // 6. Reflection Note
                        _buildReflectionNote(isDark, isEn),
                        const SizedBox(height: 20),

                        // 7. Photo Upload
                        _buildPhotoSection(isDark, isEn),
                        const SizedBox(height: 24),

                        // 8. Save Button
                        _buildSaveButton(isDark, isEn),
                        const SizedBox(height: 40),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDiscardDialog() async {
    final language = ref.read(languageProvider);
    final confirmed = await GlassDialog.confirm(
      context,
      title: L10nService.get('life_events.life_event.discard_changes', language),
      message: L10nService.get('life_events.life_event.you_have_unsaved_changes_are_you_sure_yo', language),
      cancelLabel: L10nService.get('life_events.life_event.cancel', language),
      confirmLabel: L10nService.get('life_events.life_event.discard', language),
      isDestructive: true,
    );
    if (confirmed == true && mounted) {
      if (context.canPop()) context.pop();
    }
  }

  // ═════════════════════════════════════════════════════════════════════════
  // 1. EVENT TYPE SELECTOR
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildTypeSelector(bool isDark, bool isEn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          L10nService.get('life_events.life_event.event_type', isEn ? AppLanguage.en : AppLanguage.tr),
          variant: GradientTextVariant.gold,
          style: AppTypography.elegantAccent(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: LifeEventType.values.map((type) {
            final isSelected = _selectedType == type;
            final color = type == LifeEventType.positive
                ? AppColors.starGold
                : type == LifeEventType.challenging
                ? AppColors.amethyst
                : AppColors.auroraStart;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: type != LifeEventType.custom ? 8 : 0,
                ),
                child: GestureDetector(
                  onTap: () {
                    HapticService.selectionTap();
                    setState(() {
                      _selectedType = type;
                      _selectedPreset = null;
                      _titleController.clear();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withValues(alpha: 0.15)
                          : (isDark
                                ? AppColors.surfaceDark.withValues(alpha: 0.8)
                                : AppColors.lightCard),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? color.withValues(alpha: 0.5)
                            : (isDark
                                  ? Colors.white.withValues(alpha: 0.06)
                                  : Colors.black.withValues(alpha: 0.05)),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        type.localizedName(isEn),
                        style: AppTypography.elegantAccent(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? color
                              : (isDark
                                    ? AppColors.textSecondary
                                    : AppColors.lightTextSecondary),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }

  // ═════════════════════════════════════════════════════════════════════════
  // 2. PRESET PICKER
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildPresetPicker(bool isDark, bool isEn) {
    final presets = _selectedType == LifeEventType.positive
        ? LifeEventPresets.positive
        : LifeEventPresets.challenging;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          L10nService.get('life_events.life_event.select_event', isEn ? AppLanguage.en : AppLanguage.tr),
          variant: GradientTextVariant.gold,
          style: AppTypography.elegantAccent(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: presets.map((preset) {
            final isSelected = _selectedPreset?.key == preset.key;
            final color = _selectedType == LifeEventType.positive
                ? AppColors.starGold
                : AppColors.amethyst;

            return GestureDetector(
              onTap: () {
                HapticService.selectionTap();
                setState(() {
                  _selectedPreset = preset;
                  _titleController.text = isEn ? preset.nameEn : preset.nameTr;
                  // Pre-fill suggested emotions
                  if (_emotionTags.isEmpty) {
                    _emotionTags.addAll(preset.defaultEmotions.take(3));
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.15)
                      : (isDark
                            ? AppColors.surfaceDark.withValues(alpha: 0.6)
                            : AppColors.lightCard),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? color.withValues(alpha: 0.4)
                        : (isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.05)),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppSymbol(preset.emoji, size: AppSymbolSize.sm),
                    const SizedBox(width: 6),
                    Text(
                      isEn ? preset.nameEn : preset.nameTr,
                      style: AppTypography.elegantAccent(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected
                            ? color
                            : (isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms, delay: 100.ms);
  }

  // ═════════════════════════════════════════════════════════════════════════
  // 2b. CUSTOM TITLE
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildCustomTitle(bool isDark, bool isEn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          L10nService.get('life_events.life_event.event_title', isEn ? AppLanguage.en : AppLanguage.tr),
          variant: GradientTextVariant.gold,
          style: AppTypography.elegantAccent(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _titleController,
          maxLength: 100,
          textCapitalization: TextCapitalization.words,
          style: AppTypography.subtitle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            hintText: L10nService.get('life_events.life_event.describe_your_life_event', isEn ? AppLanguage.en : AppLanguage.tr),
            hintStyle: AppTypography.subtitle(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
            filled: true,
            fillColor: isDark
                ? AppColors.surfaceDark.withValues(alpha: 0.8)
                : AppColors.lightCard,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            counterStyle: AppTypography.subtitle(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              fontSize: 10,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms, delay: 100.ms);
  }

  // ═════════════════════════════════════════════════════════════════════════
  // 3. DATE PICKER
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildDatePicker(BuildContext context, bool isDark, bool isEn) {
    final formatted =
        '${_selectedDate.day.toString().padLeft(2, '0')}/'
        '${_selectedDate.month.toString().padLeft(2, '0')}/'
        '${_selectedDate.year}';

    return GestureDetector(
      onTap: () async {
        final picked = await ThemedPicker.showDate(
          context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked != null && mounted) {
          setState(() => _selectedDate = picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark.withValues(alpha: 0.8)
              : AppColors.lightCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: AppColors.starGold,
            ),
            const SizedBox(width: 12),
            Text(
              formatted,
              style: AppTypography.subtitle(
                fontSize: 15,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.edit_rounded,
              size: 16,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 150.ms);
  }

  // ═════════════════════════════════════════════════════════════════════════
  // 4. EMOTION TAGS
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildEmotionTags(bool isDark, bool isEn) {
    const emotions = [
      'joy',
      'pride',
      'gratitude',
      'excitement',
      'love',
      'hope',
      'relief',
      'curiosity',
      'awe',
      'confidence',
      'peace',
      'warmth',
      'sadness',
      'grief',
      'anxiety',
      'fear',
      'anger',
      'frustration',
      'loneliness',
      'confusion',
      'guilt',
      'shame',
      'vulnerability',
      'courage',
      'determination',
      'acceptance',
      'nostalgia',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GradientText(
              L10nService.get('life_events.life_event.emotion_tags', isEn ? AppLanguage.en : AppLanguage.tr),
              variant: GradientTextVariant.amethyst,
              style: AppTypography.displayFont.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '${_emotionTags.length}/5',
              style: AppTypography.elegantAccent(
                fontSize: 12,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: emotions.map((emotion) {
            final isSelected = _emotionTags.contains(emotion);
            return GestureDetector(
              onTap: () {
                HapticService.selectionTap();
                setState(() {
                  if (isSelected) {
                    _emotionTags.remove(emotion);
                  } else if (_emotionTags.length < 5) {
                    _emotionTags.add(emotion);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.auroraStart.withValues(alpha: 0.15)
                      : (isDark
                            ? AppColors.surfaceDark.withValues(alpha: 0.5)
                            : AppColors.lightCard),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.auroraStart.withValues(alpha: 0.4)
                        : (isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.05)),
                  ),
                ),
                child: Text(
                  emotion,
                  style: AppTypography.elegantAccent(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.auroraStart
                        : (isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms, delay: 200.ms);
  }

  // ═════════════════════════════════════════════════════════════════════════
  // 5. INTENSITY SLIDER
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildIntensitySlider(bool isDark, bool isEn) {
    final labels = isEn
        ? ['Subtle', 'Mild', 'Moderate', 'Strong', 'Life-Changing']
        : ['Hafif', 'Az', 'Orta', 'Güçlü', 'Hayat Değiştiren'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GradientText(
              L10nService.get('life_events.life_event.intensity', isEn ? AppLanguage.en : AppLanguage.tr),
              variant: GradientTextVariant.gold,
              style: AppTypography.displayFont.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              labels[(_intensity - 1).clamp(0, 4)],
              style: AppTypography.elegantAccent(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.starGold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.starGold,
            inactiveTrackColor: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.08),
            thumbColor: AppColors.starGold,
            overlayColor: AppColors.starGold.withValues(alpha: 0.15),
          ),
          child: Slider(
            value: _intensity.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            onChanged: (v) {
              HapticService.selectionTap();
              setState(() => _intensity = v.round());
            },
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms, delay: 250.ms);
  }

  // ═════════════════════════════════════════════════════════════════════════
  // 6. REFLECTION NOTE
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildReflectionNote(bool isDark, bool isEn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          L10nService.get('life_events.life_event.reflection', isEn ? AppLanguage.en : AppLanguage.tr),
          variant: GradientTextVariant.amethyst,
          style: AppTypography.elegantAccent(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _noteController,
          maxLines: 4,
          maxLength: 500,
          textCapitalization: TextCapitalization.sentences,
          style: AppTypography.subtitle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: L10nService.get('life_events.life_event.how_did_this_event_shape_you', isEn ? AppLanguage.en : AppLanguage.tr),
            hintStyle: AppTypography.subtitle(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
            filled: true,
            fillColor: isDark
                ? AppColors.surfaceDark.withValues(alpha: 0.8)
                : AppColors.lightCard,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            counterStyle: AppTypography.subtitle(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              fontSize: 10,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms, delay: 300.ms);
  }

  // ═════════════════════════════════════════════════════════════════════════
  // 7. PHOTO UPLOAD
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildPhotoSection(bool isDark, bool isEn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          L10nService.get('life_events.life_event.photo_optional', isEn ? AppLanguage.en : AppLanguage.tr),
          variant: GradientTextVariant.gold,
          style: AppTypography.elegantAccent(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        if (_imagePath != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(_imagePath!),
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              semanticLabel: L10nService.get('life_events.life_event.event_photo', isEn ? AppLanguage.en : AppLanguage.tr),
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => _imagePath = null),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                L10nService.get('life_events.life_event.remove_photo', isEn ? AppLanguage.en : AppLanguage.tr),
                style: AppTypography.modernAccent(
                  fontSize: 12,
                  color: AppColors.error,
                ),
              ),
            ),
          ),
        ] else
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceDark.withValues(alpha: 0.6)
                    : AppColors.lightCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.06),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_rounded,
                    size: 24,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    L10nService.get('life_events.life_event.add_a_photo', isEn ? AppLanguage.en : AppLanguage.tr),
                    style: AppTypography.elegantAccent(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    ).animate().fadeIn(duration: 300.ms, delay: 350.ms);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (picked == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName =
        'life_event_${DateTime.now().millisecondsSinceEpoch}${p.extension(picked.path)}';
    final savedFile = await File(picked.path).copy('${appDir.path}/$fileName');
    if (!mounted) return;
    setState(() {
      _imagePath = savedFile.path;
      _hasChanges = true;
    });
  }

  // ═════════════════════════════════════════════════════════════════════════
  // 8. SAVE BUTTON
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildSaveButton(bool isDark, bool isEn) {
    final title = _selectedPreset != null
        ? (isEn ? _selectedPreset!.nameEn : _selectedPreset!.nameTr)
        : _titleController.text.trim();
    final canSave = title.isNotEmpty && !_isSaving;

    return GestureDetector(
      onTap: canSave ? _save : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: canSave
              ? AppColors.starGold
              : AppColors.starGold.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: _isSaving
              ? const CupertinoActivityIndicator(radius: 10)
              : Text(
                  _isEditing
                      ? (L10nService.get('life_events.life_event.update_event', isEn ? AppLanguage.en : AppLanguage.tr))
                      : (L10nService.get('life_events.life_event.save_event', isEn ? AppLanguage.en : AppLanguage.tr)),
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepSpace,
                  ),
                ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 400.ms);
  }

  Future<void> _save() async {
    final title = _selectedPreset != null
        ? (ref.read(languageProvider) == AppLanguage.en
              ? _selectedPreset!.nameEn
              : _selectedPreset!.nameTr)
        : _titleController.text.trim();
    if (title.isEmpty) return;

    setState(() => _isSaving = true);
    HapticService.success();

    try {
      final service = await ref.read(lifeEventServiceProvider.future);

      if (_isEditing && _existingEvent != null) {
        await service.updateEvent(
          _existingEvent!.copyWith(
            type: _selectedType,
            eventKey: _selectedPreset?.key,
            title: title,
            note: _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
            emotionTags: List<String>.from(_emotionTags),
            imagePath: _imagePath,
            intensity: _intensity,
            date: _selectedDate,
          ),
        );
      } else {
        await service.saveEvent(
          date: _selectedDate,
          type: _selectedType,
          eventKey: _selectedPreset?.key,
          title: title,
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
          emotionTags: List<String>.from(_emotionTags),
          imagePath: _imagePath,
          intensity: _intensity,
        );
      }

      if (mounted) {
        _hasChanges = false;
        context.pop();
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
