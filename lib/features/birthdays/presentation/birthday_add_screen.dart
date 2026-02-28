// ════════════════════════════════════════════════════════════════════════════
// BIRTHDAY ADD/EDIT SCREEN - Create or Edit Birthday Contacts
// ════════════════════════════════════════════════════════════════════════════

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
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
import '../../../data/services/l10n_service.dart';

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
                        ? (L10nService.get('birthdays.birthday_add.edit_birthday', isEn ? AppLanguage.en : AppLanguage.tr))
                        : (L10nService.get('birthdays.birthday_add.add_birthday', isEn ? AppLanguage.en : AppLanguage.tr)),
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
      ),
    );
  }

  void _showDiscardDialog() async {
    final language = ref.read(languageProvider);
    final isEn = language == AppLanguage.en;
    final confirmed = await GlassDialog.confirm(
      context,
      title: L10nService.get('birthdays.birthday_add.discard_changes', isEn ? AppLanguage.en : AppLanguage.tr),
      message: L10nService.get('birthdays.birthday_add.you_have_unsaved_changes_are_you_sure_yo', isEn ? AppLanguage.en : AppLanguage.tr),
      cancelLabel: L10nService.get('birthdays.birthday_add.cancel', isEn ? AppLanguage.en : AppLanguage.tr),
      confirmLabel: L10nService.get('birthdays.birthday_add.discard', isEn ? AppLanguage.en : AppLanguage.tr),
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
      child: Semantics(
        button: true,
        label: L10nService.get('birthdays.birthday_add.change_photo', isEn ? AppLanguage.en : AppLanguage.tr),
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
              L10nService.get('birthdays.birthday_add.tap_to_change_photo', isEn ? AppLanguage.en : AppLanguage.tr),
              style: AppTypography.elegantAccent(
                fontSize: 12,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
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
    if (!mounted) return;
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
          L10nService.get('birthdays.birthday_add.name', isEn ? AppLanguage.en : AppLanguage.tr),
          variant: GradientTextVariant.gold,
          style: AppTypography.elegantAccent(fontSize: 14, letterSpacing: 1.5),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          onChanged: (_) => setState(() => _hasChanges = true),
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.name,
          style: AppTypography.subtitle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: L10nService.get('birthdays.birthday_add.friends_name', isEn ? AppLanguage.en : AppLanguage.tr),
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
    final monthNames = isEn
        ? CommonStrings.monthsFullEn
        : CommonStrings.monthsFullTr;

    final daysInMonth = DateTime(2024, _selectedMonth + 1, 0).day;
    if (_selectedDay > daysInMonth) _selectedDay = daysInMonth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          L10nService.get('birthdays.birthday_add.birthday', isEn ? AppLanguage.en : AppLanguage.tr),
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
                    dropdownColor: isDark
                        ? AppColors.surfaceDark
                        : Colors.white,
                    style: AppTypography.subtitle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    items: List.generate(12, (i) {
                      return DropdownMenuItem(
                        value: i + 1,
                        child: Text(monthNames[i]),
                      );
                    }),
                    onChanged: (v) {
                      if (v != null)
                        setState(() {
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
                    dropdownColor: isDark
                        ? AppColors.surfaceDark
                        : Colors.white,
                    style: AppTypography.subtitle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    items: List.generate(daysInMonth, (i) {
                      return DropdownMenuItem(
                        value: i + 1,
                        child: Text('${i + 1}'),
                      );
                    }),
                    onChanged: (v) {
                      if (v != null)
                        setState(() {
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
                    dropdownColor: isDark
                        ? AppColors.surfaceDark
                        : Colors.white,
                    style: AppTypography.subtitle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    hint: Text(
                      L10nService.get('birthdays.birthday_add.year_optional', isEn ? AppLanguage.en : AppLanguage.tr),
                      style: AppTypography.subtitle(
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                    items: [
                      DropdownMenuItem<int?>(
                        value: null,
                        child: Text(
                          L10nService.get('birthdays.birthday_add.not_specified', isEn ? AppLanguage.en : AppLanguage.tr),
                          style: AppTypography.subtitle(
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
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
          L10nService.get('birthdays.birthday_add.relationship', isEn ? AppLanguage.en : AppLanguage.tr),
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
                    Text(
                      rel.emoji,
                      style: AppTypography.subtitle(fontSize: 14),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      rel.localizedName(isEn),
                      style: AppTypography.elegantAccent(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
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
          L10nService.get('birthdays.birthday_add.note_optional', isEn ? AppLanguage.en : AppLanguage.tr),
          variant: GradientTextVariant.gold,
          style: AppTypography.elegantAccent(fontSize: 14, letterSpacing: 1.5),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _noteController,
          onChanged: (_) => setState(() => _hasChanges = true),
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
          style: AppTypography.subtitle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: L10nService.get('birthdays.birthday_add.gift_ideas_memories', isEn ? AppLanguage.en : AppLanguage.tr),
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
          L10nService.get('birthdays.birthday_add.reminders', isEn ? AppLanguage.en : AppLanguage.tr),
          variant: GradientTextVariant.gold,
          style: AppTypography.elegantAccent(fontSize: 14, letterSpacing: 1.5),
        ),
        const SizedBox(height: 10),
        _toggleRow(
          isDark,
          label: L10nService.get('birthdays.birthday_add.birthday_notification', isEn ? AppLanguage.en : AppLanguage.tr),
          value: _notificationsEnabled,
          onChanged: (v) => setState(() {
            _notificationsEnabled = v;
            _hasChanges = true;
          }),
        ),
        const SizedBox(height: 8),
        _toggleRow(
          isDark,
          label: L10nService.get('birthdays.birthday_add.day_before_reminder', isEn ? AppLanguage.en : AppLanguage.tr),
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
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
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
              ? const CupertinoActivityIndicator(radius: 10)
              : Text(
                  _isEditing
                      ? (L10nService.get('birthdays.birthday_add.update_contact', isEn ? AppLanguage.en : AppLanguage.tr))
                      : (L10nService.get('birthdays.birthday_add.save_contact', isEn ? AppLanguage.en : AppLanguage.tr)),
                  style: AppTypography.modernAccent(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: canSave
                        ? AppColors.deepSpace
                        : (isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted),
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
      final service = await ref.read(birthdayContactServiceProvider.future);

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
              L10nService.get('birthdays.birthday_add.couldnt_save_this_contact_please_try_aga', isEn ? AppLanguage.en : AppLanguage.tr),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
