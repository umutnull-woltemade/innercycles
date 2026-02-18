import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/review_service.dart';

import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../data/services/premium_service.dart';
import '../../gratitude/presentation/gratitude_section.dart';
import '../../sleep/presentation/sleep_section.dart';
import '../../moon/presentation/moon_phase_widget.dart';
import 'widgets/voice_input_button.dart';

class DailyEntryScreen extends ConsumerStatefulWidget {
  const DailyEntryScreen({super.key});

  @override
  ConsumerState<DailyEntryScreen> createState() => _DailyEntryScreenState();
}

class _DailyEntryScreenState extends ConsumerState<DailyEntryScreen> {
  DateTime _selectedDate = DateTime.now();
  FocusArea _selectedArea = FocusArea.energy;
  int _overallRating = 3;
  final Map<String, int> _subRatings = {};
  final _noteController = TextEditingController();
  bool _isSaving = false;
  String? _selectedImagePath;

  /// Stores the note text before a voice session starts, so partial
  /// results can be appended without duplicating previous voice output.
  String _textBeforeVoice = '';

  @override
  void initState() {
    super.initState();
    _initSubRatings();
  }

  void _initSubRatings() {
    _subRatings.clear();
    for (final key in _selectedArea.subRatingKeys) {
      _subRatings[key] = 3;
    }
  }

  @override
  void dispose() {
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

                      // Moon phase badge
                      Align(
                        alignment: Alignment.centerLeft,
                        child: MoonPhaseBadge(
                          date: _selectedDate,
                          isEn: isEn,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingXl),

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
                      _buildRatingSlider(
                        isDark,
                        isEn,
                        _overallRating,
                        (v) => setState(() => _overallRating = v),
                      ),
                      const SizedBox(height: AppConstants.spacingXl),

                      // Sub-ratings
                      _buildSectionLabel(
                        context,
                        isDark,
                        isEn ? 'Details' : 'Detaylar',
                      ),
                      const SizedBox(height: AppConstants.spacingMd),
                      _buildSubRatings(isDark, isEn),
                      const SizedBox(height: AppConstants.spacingXl),

                      // Note
                      _buildSectionLabel(
                        context,
                        isDark,
                        isEn ? 'Notes (optional)' : 'Notlar (opsiyonel)',
                      ),
                      const SizedBox(height: AppConstants.spacingMd),
                      _buildNoteField(isDark, isEn),
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
                        isPremium: ref.watch(premiumProvider).isPremium,
                      ),
                      const SizedBox(height: AppConstants.spacingXl),

                      // Sleep quality section (collapsible)
                      SleepSection(date: _selectedDate),
                      const SizedBox(height: AppConstants.spacingXl),

                      // Save button
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
    );
  }

  Widget _buildDateSelector(BuildContext context, bool isDark, bool isEn) {
    final dayName = _getDayName(_selectedDate, isEn);
    final dateStr =
        '${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}';

    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now(),
        );
        if (picked != null && mounted) setState(() => _selectedDate = picked);
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  dateStr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color:
                        isDark ? AppColors.textMuted : AppColors.lightTextMuted,
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
    ).glassReveal(context: context);
  }

  Widget _buildSectionLabel(
    BuildContext context,
    bool isDark,
    String label,
  ) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
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

        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() {
              _selectedArea = area;
              _initSubRatings();
            });
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
                color: isSelected
                    ? AppColors.starGold
                    : Colors.transparent,
                width: 2,
              ),
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? AppColors.starGold
                        : (isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary),
                  ),
                ),
              ],
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
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
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
                      style: TextStyle(
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
              );
            }),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            labels[(value - 1).clamp(0, labels.length - 1)],
            style: TextStyle(
              fontSize: 14,
              color: AppColors.starGold,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ).glassListItem(context: context, index: 2);
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
                    style: TextStyle(
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
                      onChanged: (v) {
                        HapticFeedback.selectionClick();
                        setState(() => _subRatings[key] = v.round());
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 24,
                  child: Text(
                    '$value',
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
                maxLength: 500,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText: isEn
                      ? 'How was your day? Any reflections...'
                      : 'Bugün nasıl geçti? Düşüncelerin...',
                  hintStyle: TextStyle(
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                  contentPadding:
                      const EdgeInsets.all(AppConstants.spacingLg),
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
                              _noteController.text =
                                  '$_textBeforeVoice $text';
                            } else {
                              _noteController.text = text;
                            }

                            // Move cursor to end
                            _noteController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                offset: _noteController.text.length,
                              ),
                            );
                          });
                        }
                      },
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                    Text(
                      isEn ? 'Tap to speak' : 'Konuşmak için dokun',
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
            ],
          ),
        ),
      ],
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
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.swap_horiz, size: 18, color: AppColors.auroraStart),
                  label: Text(
                    isEn ? 'Change' : 'Değiştir',
                    style: TextStyle(color: AppColors.auroraStart, fontSize: 13),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => setState(() => _selectedImagePath = null),
                  icon: Icon(Icons.close, size: 18,
                      color: isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                  label: Text(
                    isEn ? 'Remove' : 'Kaldır',
                    style: TextStyle(
                      color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ).glassListItem(context: context, index: 4);
    }

    return GestureDetector(
      onTap: _pickImage,
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
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
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
      // Copy to app documents directory for persistence
      final appDir = await getApplicationDocumentsDirectory();
      final journalDir = Directory('${appDir.path}/journal_photos');
      if (!await journalDir.exists()) {
        await journalDir.create(recursive: true);
      }
      final ext = p.extension(picked.path);
      final savedPath = '${journalDir.path}/${DateTime.now().millisecondsSinceEpoch}$ext';
      await File(picked.path).copy(savedPath);
      if (!mounted) return;
      setState(() => _selectedImagePath = savedPath);
    }
  }

  Widget _buildSaveButton(bool isDark, bool isEn) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _saveEntry,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.starGold,
          foregroundColor: AppColors.deepSpace,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          ),
          elevation: 0,
        ),
        child: _isSaving
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                ),
              )
            : Text(
                isEn ? 'Save Entry' : 'Kaydet',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
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
      );

      // Invalidate providers to refresh data
      ref.invalidate(todayJournalEntryProvider);
      ref.invalidate(journalStreakProvider);

      // Update notification lifecycle with new activity
      _updateNotificationLifecycle(service);

      // Check for review prompt at engagement milestones
      _checkReviewTrigger(service);

      if (mounted) {
        HapticFeedback.heavyImpact();
        final isEn = ref.read(languageProvider) == AppLanguage.en;
        final entryCount = service.entryCount;
        final suggestion = _getPostSaveSuggestion(entryCount, isEn);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              suggestion != null
                  ? '${isEn ? 'Saved!' : 'Kaydedildi!'} ${suggestion.$1}'
                  : (isEn ? 'Entry saved!' : 'Kayıt kaydedildi!'),
            ),
            behavior: SnackBarBehavior.floating,
            action: suggestion != null
                ? SnackBarAction(
                    label: isEn ? 'Explore' : 'Keşfet',
                    onPressed: () => context.push(suggestion.$2),
                  )
                : null,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(
            ref.read(languageProvider) == AppLanguage.en
                ? 'Save failed' : 'Kayıt başarısız',
          )),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _updateNotificationLifecycle(dynamic journalService) async {
    try {
      final nlcService =
          await ref.read(notificationLifecycleServiceProvider.future);
      await nlcService.recordActivity();
      await nlcService.evaluate(journalService);
    } catch (_) {
      // Non-critical — silently ignore
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
    } catch (_) {
      // Review prompt is non-critical, silently ignore errors
    }
  }

  /// Returns a contextual (message, route) suggestion based on entry count,
  /// or null if no suggestion is appropriate.
  (String, String)? _getPostSaveSuggestion(int entryCount, bool isEn) {
    if (entryCount == 7) {
      return (
        isEn
            ? 'See how your cycles flow'
            : 'Döngülerini keşfet',
        Routes.emotionalCycles,
      );
    }
    if (entryCount == 14) {
      return (
        isEn
            ? 'Try a pattern-detection quiz'
            : 'Bir örüntü tespit testini dene',
        Routes.quizHub,
      );
    }
    if (entryCount > 5 && entryCount % 5 == 0) {
      return (
        isEn
            ? 'Your patterns are emerging'
            : 'Örüntülerin belirginleşiyor',
        Routes.journalPatterns,
      );
    }
    return null;
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
