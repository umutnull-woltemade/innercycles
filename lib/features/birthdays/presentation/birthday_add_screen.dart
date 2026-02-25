// ════════════════════════════════════════════════════════════════════════════
// BIRTHDAY ADD/EDIT SCREEN - Create or Edit Birthday Contacts
// ════════════════════════════════════════════════════════════════════════════

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../../core/constants/common_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/birthday_contact.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/notification_service.dart';
import '../../../shared/widgets/birthday_avatar.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_dialog.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';

class BirthdayAddScreen extends ConsumerStatefulWidget {
  final String? editId;

  const BirthdayAddScreen({super.key, this.editId});

  @override
  ConsumerState<BirthdayAddScreen> createState() => _BirthdayAddScreenState();
}

class _BirthdayAddScreenState extends ConsumerState<BirthdayAddScreen> {
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();
  int _selectedMonth = DateTime.now().month;
  int _selectedDay = 1;
  int? _selectedYear;
  BirthdayRelationship _relationship = BirthdayRelationship.friend;
  String? _imagePath;
  bool _notificationsEnabled = true;
  bool _dayBeforeReminder = true;
  bool _isSaving = false;
  bool _isEditing = false;
  bool _hasChanges = false;
  BirthdayContact? _existingContact;

  @override
  void initState() {
    super.initState();
    if (widget.editId != null) {
      _isEditing = true;
      _loadExisting();
    }
  }

  void _loadExisting() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final service = ref.read(birthdayContactServiceProvider).valueOrNull;
      if (service == null) return;
      final contact = service.getContact(widget.editId!);
      if (contact == null) return;
      setState(() {
        _existingContact = contact;
        _nameController.text = contact.name;
        _selectedMonth = contact.birthdayMonth;
        _selectedDay = contact.birthdayDay;
        _selectedYear = contact.birthYear;
        _relationship = contact.relationship;
        _imagePath = contact.photoPath;
        _noteController.text = contact.note ?? '';
        _notificationsEnabled = contact.notificationsEnabled;
        _dayBeforeReminder = contact.dayBeforeReminder;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CosmicBackground(
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
          slivers: [
            GlassSliverAppBar(
              title: _isEditing
                  ? (isEn ? 'Edit Birthday' : 'Do\u{011F}um G\u{00FC}n\u{00FC} D\u{00FC}zenle')
                  : (isEn ? 'Add Birthday' : 'Do\u{011F}um G\u{00FC}n\u{00FC} Ekle'),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildPhotoSection(isDark, isEn),
                  const SizedBox(height: 20),
                  _buildNameField(isDark, isEn),
                  const SizedBox(height: 20),
                  _buildDateSection(isDark, isEn),
                  const SizedBox(height: 20),
                  _buildRelationshipSection(isDark, isEn),
                  const SizedBox(height: 20),
                  _buildNoteField(isDark, isEn),
                  const SizedBox(height: 20),
                  _buildNotificationToggles(isDark, isEn),
                  const SizedBox(height: 32),
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

  void _showDiscardDialog() async {
    final language = ref.read(languageProvider);
    final isEn = language == AppLanguage.en;
    final confirmed = await GlassDialog.confirm(
      context,
      title: isEn ? 'Discard Changes?' : 'De\u{011F}i\u{015F}iklikleri At?',
      message: isEn
          ? 'You have unsaved changes. Are you sure you want to go back?'
          : 'Kaydedilmemi\u{015F} de\u{011F}i\u{015F}iklikleriniz var. Geri d\u{00F6}nmek istedi\u{011F}inizden emin misiniz?',
      cancelLabel: isEn ? 'Cancel' : '\u{0130}ptal',
      confirmLabel: isEn ? 'Discard' : 'At',
      isDestructive: true,
    );
    if (confirmed == true && mounted) {
      if (context.canPop()) context.pop();
    }
  }

  // ═════════════════════════════════════════════════════════════════════════
  // PHOTO
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildPhotoSection(bool isDark, bool isEn) {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Column(
          children: [
            BirthdayAvatar(
              photoPath: _imagePath,
              name: _nameController.text.isEmpty ? '?' : _nameController.text,
              size: 100,
            ),
            const SizedBox(height: 8),
            Text(
              isEn ? 'Tap to change photo' : 'Foto\u{011F}raf\u{0131} de\u{011F}i\u{015F}tirmek i\u{00E7}in dokun',
              style: AppTypography.elegantAccent(
                fontSize: 12,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 85,
    );
    if (picked == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName =
        'birthday_${DateTime.now().millisecondsSinceEpoch}${p.extension(picked.path)}';
    final savedFile = await File(picked.path).copy('${appDir.path}/$fileName');
    setState(() {
      _imagePath = savedFile.path;
      _hasChanges = true;
    });
  }

  // ═════════════════════════════════════════════════════════════════════════
  // NAME
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildNameField(bool isDark, bool isEn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          isEn ? 'Name' : '\u{0130}sim',
          variant: GradientTextVariant.gold,
          style: AppTypography.elegantAccent(fontSize: 14, letterSpacing: 1.5),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          onChanged: (_) => setState(() => _hasChanges = true),
          style: AppTypography.subtitle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: isEn ? 'Enter name...' : '\u{0130}sim girin...',
            hintStyle: AppTypography.subtitle(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
            filled: true,
            fillColor: isDark
                ? AppColors.surfaceDark.withValues(alpha: 0.6)
                : AppColors.lightCard,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms, delay: 100.ms);
  }

  // ═════════════════════════════════════════════════════════════════════════
  // DATE PICKER (Month + Day + optional Year)
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildDateSection(bool isDark, bool isEn) {
    final monthNames = isEn ? CommonStrings.monthsFullEn : CommonStrings.monthsFullTr;

    final daysInMonth = DateTime(2024, _selectedMonth + 1, 0).day;
    if (_selectedDay > daysInMonth) _selectedDay = daysInMonth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          isEn ? 'Birthday' : 'Do\u{011F}um G\u{00FC}n\u{00FC}',
          variant: GradientTextVariant.gold,
          style: AppTypography.elegantAccent(fontSize: 14, letterSpacing: 1.5),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            // Month dropdown
            Expanded(
              flex: 3,
              child: _dropdownContainer(
                isDark,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selectedMonth,
                    isExpanded: true,
                    dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
                    style: AppTypography.subtitle(
                      fontSize: 14,
                      color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                    ),
                    items: List.generate(12, (i) {
                      return DropdownMenuItem(
                        value: i + 1,
                        child: Text(monthNames[i]),
                      );
                    }),
                    onChanged: (v) {
                      if (v != null) setState(() {
                        _selectedMonth = v;
                        _hasChanges = true;
                      });
                      HapticFeedback.selectionClick();
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Day dropdown
            Expanded(
              flex: 2,
              child: _dropdownContainer(
                isDark,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selectedDay,
                    isExpanded: true,
                    dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
                    style: AppTypography.subtitle(
                      fontSize: 14,
                      color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                    ),
                    items: List.generate(daysInMonth, (i) {
                      return DropdownMenuItem(
                        value: i + 1,
                        child: Text('${i + 1}'),
                      );
                    }),
                    onChanged: (v) {
                      if (v != null) setState(() {
                        _selectedDay = v;
                        _hasChanges = true;
                      });
                      HapticFeedback.selectionClick();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Optional year
        Row(
          children: [
            Expanded(
              child: _dropdownContainer(
                isDark,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int?>(
                    value: _selectedYear,
                    isExpanded: true,
                    dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
                    style: AppTypography.subtitle(
                      fontSize: 14,
                      color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                    ),
                    hint: Text(
                      isEn ? 'Year (optional)' : 'Y\u{0131}l (iste\u{011F}e ba\u{011F}l\u{0131})',
                      style: TextStyle(
                        color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                      ),
                    ),
                    items: [
                      DropdownMenuItem<int?>(
                        value: null,
                        child: Text(
                          isEn ? 'Not specified' : 'Belirtilmemi\u{015F}',
                          style: TextStyle(
                            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                          ),
                        ),
                      ),
                      ...List.generate(80, (i) {
                        final year = DateTime.now().year - i;
                        return DropdownMenuItem(
                          value: year,
                          child: Text('$year'),
                        );
                      }),
                    ],
                    onChanged: (v) => setState(() {
                      _selectedYear = v;
                      _hasChanges = true;
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 300.ms, delay: 150.ms);
  }

  Widget _dropdownContainer(bool isDark, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.6)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  // ═════════════════════════════════════════════════════════════════════════
  // RELATIONSHIP
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildRelationshipSection(bool isDark, bool isEn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          isEn ? 'Relationship' : '\u{0130}li\u{015F}ki',
          variant: GradientTextVariant.gold,
          style: AppTypography.elegantAccent(fontSize: 14, letterSpacing: 1.5),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: BirthdayRelationship.values.map((rel) {
            final isSelected = _relationship == rel;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  _relationship = rel;
                  _hasChanges = true;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.starGold.withValues(alpha: 0.15)
                      : (isDark
                            ? AppColors.surfaceDark.withValues(alpha: 0.6)
                            : AppColors.lightCard),
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected
                      ? Border.all(
                          color: AppColors.starGold.withValues(alpha: 0.4),
                        )
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(rel.emoji, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      isEn ? rel.displayNameEn : rel.displayNameTr,
                      style: AppTypography.elegantAccent(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? AppColors.starGold
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
    ).animate().fadeIn(duration: 300.ms, delay: 200.ms);
  }

  // ═════════════════════════════════════════════════════════════════════════
  // NOTE
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildNoteField(bool isDark, bool isEn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          isEn ? 'Note (Optional)' : 'Not (\u{0130}ste\u{011F}e Ba\u{011F}l\u{0131})',
          variant: GradientTextVariant.gold,
          style: AppTypography.elegantAccent(fontSize: 14, letterSpacing: 1.5),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _noteController,
          onChanged: (_) => setState(() => _hasChanges = true),
          maxLines: 3,
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: isEn
                ? 'Gift ideas, memories...'
                : 'Hediye fikirleri, an\u{0131}lar...',
            hintStyle: TextStyle(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
            filled: true,
            fillColor: isDark
                ? AppColors.surfaceDark.withValues(alpha: 0.6)
                : AppColors.lightCard,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms, delay: 250.ms);
  }

  // ═════════════════════════════════════════════════════════════════════════
  // NOTIFICATION TOGGLES
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildNotificationToggles(bool isDark, bool isEn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          isEn ? 'Reminders' : 'Hat\u{0131}rlat\u{0131}c\u{0131}lar',
          variant: GradientTextVariant.gold,
          style: AppTypography.elegantAccent(fontSize: 14, letterSpacing: 1.5),
        ),
        const SizedBox(height: 10),
        _toggleRow(
          isDark,
          label: isEn ? 'Birthday notification' : 'Do\u{011F}um g\u{00FC}n\u{00FC} bildirimi',
          value: _notificationsEnabled,
          onChanged: (v) => setState(() {
            _notificationsEnabled = v;
            _hasChanges = true;
          }),
        ),
        const SizedBox(height: 8),
        _toggleRow(
          isDark,
          label: isEn ? 'Day before reminder' : 'Bir g\u{00FC}n \u{00F6}nce hat\u{0131}rlat',
          value: _dayBeforeReminder,
          onChanged: (v) => setState(() {
            _dayBeforeReminder = v;
            _hasChanges = true;
          }),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms, delay: 300.ms);
  }

  Widget _toggleRow(
    bool isDark, {
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.subtitle(
              fontSize: 14,
              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppColors.starGold,
        ),
      ],
    );
  }

  // ═════════════════════════════════════════════════════════════════════════
  // SAVE BUTTON
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildSaveButton(bool isDark, bool isEn) {
    final canSave = _nameController.text.trim().isNotEmpty && !_isSaving;

    return GestureDetector(
      onTap: canSave ? _save : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: canSave
              ? const LinearGradient(
                  colors: [AppColors.starGold, AppColors.celestialGold],
                )
              : null,
          color: canSave ? null : (isDark ? Colors.white12 : Colors.black12),
          borderRadius: BorderRadius.circular(14),
          boxShadow: canSave
              ? [
                  BoxShadow(
                    color: AppColors.starGold.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.deepSpace,
                  ),
                )
              : Text(
                  _isEditing
                      ? (isEn ? 'Update' : 'G\u{00FC}ncelle')
                      : (isEn ? 'Save' : 'Kaydet'),
                  style: AppTypography.modernAccent(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: canSave
                        ? AppColors.deepSpace
                        : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                  ),
                ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 350.ms);
  }

  Future<void> _save() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final service =
          await ref.read(birthdayContactServiceProvider.future);

      BirthdayContact saved;
      final trimmedNote = _noteController.text.trim();
      if (_isEditing && _existingContact != null) {
        // Construct directly to allow clearing nullable fields
        saved = await service.updateContact(
          BirthdayContact(
            id: _existingContact!.id,
            name: _nameController.text.trim(),
            birthdayMonth: _selectedMonth,
            birthdayDay: _selectedDay,
            birthYear: _selectedYear,
            createdAt: _existingContact!.createdAt,
            photoPath: _imagePath,
            relationship: _relationship,
            note: trimmedNote.isEmpty ? null : trimmedNote,
            source: _existingContact!.source,
            notificationsEnabled: _notificationsEnabled,
            dayBeforeReminder: _dayBeforeReminder,
          ),
        );
      } else {
        saved = await service.saveContact(
          name: _nameController.text.trim(),
          birthdayMonth: _selectedMonth,
          birthdayDay: _selectedDay,
          birthYear: _selectedYear,
          photoPath: _imagePath,
          relationship: _relationship,
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
          notificationsEnabled: _notificationsEnabled,
          dayBeforeReminder: _dayBeforeReminder,
        );
      }

      // Schedule notification
      if (saved.notificationsEnabled) {
        await NotificationService().scheduleBirthdayNotification(saved);
      } else {
        await NotificationService().cancelBirthdayNotification(saved.id);
      }

      // Invalidate providers
      ref.invalidate(birthdayContactServiceProvider);

      if (mounted) {
        _hasChanges = false;
        context.pop();
      }
    } catch (_) {
      if (mounted) {
        final lang = ref.read(languageProvider);
        final isEn = lang == AppLanguage.en;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEn
                  ? 'Could not save. Please try again.'
                  : 'Kaydedilemedi. L\u{00FC}tfen tekrar deneyin.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
