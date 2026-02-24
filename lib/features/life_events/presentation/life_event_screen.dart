// ════════════════════════════════════════════════════════════════════════════
// LIFE EVENT SCREEN - Create / Edit Life Events
// ════════════════════════════════════════════════════════════════════════════

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../../core/theme/app_colors.dart';
import '../../../data/models/life_event.dart';
import '../../../data/content/life_event_presets.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/haptic_service.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';

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
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;

    return Scaffold(
      body: CosmicBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            GlassSliverAppBar(
              title: _isEditing
                  ? (isEn ? 'Edit Life Event' : 'Yaşam Olayını Düzenle')
                  : (isEn ? 'New Life Event' : 'Yeni Yaşam Olayı'),
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
    );
  }

  // ═════════════════════════════════════════════════════════════════════════
  // 1. EVENT TYPE SELECTOR
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildTypeSelector(bool isDark, bool isEn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          isEn ? 'Event Type' : 'Olay Türü',
          variant: GradientTextVariant.gold,
          style: const TextStyle(
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
                        isEn ? type.displayNameEn : type.displayNameTr,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
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
          isEn ? 'Select Event' : 'Olay Seçin',
          variant: GradientTextVariant.gold,
          style: const TextStyle(
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
                  _titleController.text =
                      isEn ? preset.nameEn : preset.nameTr;
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
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
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
          isEn ? 'Event Title' : 'Olay Başlığı',
          variant: GradientTextVariant.gold,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _titleController,
          maxLength: 100,
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            hintText: isEn
                ? 'Describe your life event...'
                : 'Yaşam olayınızı tanımlayın...',
            hintStyle: TextStyle(
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
            counterStyle: TextStyle(
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
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
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
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
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
      'joy', 'pride', 'gratitude', 'excitement', 'love', 'hope',
      'relief', 'curiosity', 'awe', 'confidence', 'peace', 'warmth',
      'sadness', 'grief', 'anxiety', 'fear', 'anger', 'frustration',
      'loneliness', 'confusion', 'guilt', 'shame', 'vulnerability',
      'courage', 'determination', 'acceptance', 'nostalgia',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GradientText(
              isEn ? 'Emotion Tags' : 'Duygu Etiketleri',
              variant: GradientTextVariant.amethyst,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '${_emotionTags.length}/5',
              style: TextStyle(
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
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
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
              isEn ? 'Intensity' : 'Yoğunluk',
              variant: GradientTextVariant.gold,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              labels[(_intensity - 1).clamp(0, 4)],
              style: TextStyle(
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
          isEn ? 'Reflection' : 'Düşünceler',
          variant: GradientTextVariant.amethyst,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _noteController,
          maxLines: 4,
          maxLength: 500,
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: isEn
                ? 'How did this event shape you?'
                : 'Bu olay sizi nasıl şekillendirdi?',
            hintStyle: TextStyle(
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
            counterStyle: TextStyle(
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
          isEn ? 'Photo (Optional)' : 'Fotoğraf (İsteğe Bağlı)',
          variant: GradientTextVariant.gold,
          style: const TextStyle(
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
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => _imagePath = null),
            child: Text(
              isEn ? 'Remove photo' : 'Fotoğrafı kaldır',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.error,
                fontWeight: FontWeight.w500,
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
                    isEn ? 'Add a photo' : 'Fotoğraf ekle',
                    style: TextStyle(
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
    final savedFile = await File(picked.path).copy(
      '${appDir.path}/$fileName',
    );
    setState(() => _imagePath = savedFile.path);
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
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.deepSpace,
                  ),
                )
              : Text(
                  _isEditing
                      ? (isEn ? 'Update Event' : 'Olayı Güncelle')
                      : (isEn ? 'Save Event' : 'Olayı Kaydet'),
                  style: TextStyle(
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

      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
