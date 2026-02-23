// ════════════════════════════════════════════════════════════════════════════
// NOTE DETAIL SCREEN - A++ Create / Edit / View a Note to Self
// ════════════════════════════════════════════════════════════════════════════
// Polished typography, glass-morphism sections, animated tag chips,
// Cupertino-style reminders, word count, premium gating.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/note_to_self.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/note_to_self_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../data/services/haptic_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';

class NoteDetailScreen extends ConsumerStatefulWidget {
  final String? noteId;

  const NoteDetailScreen({super.key, this.noteId});

  @override
  ConsumerState<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends ConsumerState<NoteDetailScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagController = TextEditingController();
  final _reminderMessageController = TextEditingController();

  bool _isPinned = false;
  List<String> _tags = [];
  NoteToSelf? _existingNote;
  List<NoteReminder> _reminders = [];

  // Reminder form state
  DateTime? _reminderDate;
  ReminderFrequency _reminderFrequency = ReminderFrequency.once;
  bool _showReminderForm = false;

  // Pending reminder for create mode (will be attached after save)
  DateTime? _pendingReminderDate;
  ReminderFrequency _pendingReminderFrequency = ReminderFrequency.once;
  String? _pendingReminderMessage;
  bool _hasPendingReminder = false;

  bool get _isCreateMode => widget.noteId == null || widget.noteId!.isEmpty;
  bool _isLoaded = false;
  int _wordCount = 0;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_updateWordCount);
  }

  @override
  void dispose() {
    _contentController.removeListener(_updateWordCount);
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    _reminderMessageController.dispose();
    super.dispose();
  }

  void _updateWordCount() {
    final text = _contentController.text.trim();
    final count = text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
    if (count != _wordCount) {
      setState(() => _wordCount = count);
    }
  }

  void _loadNote(NoteToSelfService service) {
    if (_isLoaded) return;
    _isLoaded = true;

    if (!_isCreateMode) {
      final note = service.getNote(widget.noteId!);
      if (note != null) {
        _existingNote = note;
        _titleController.text = note.title;
        _contentController.text = note.content;
        _isPinned = note.isPinned;
        _tags = List.from(note.tags);
        _reminders = service.getRemindersForNote(note.id);
      }
    }
  }

  Future<void> _save(NoteToSelfService service, bool isPremium) async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty && content.isEmpty) return;

    HapticService.buttonPress();

    NoteToSelf? savedNote;

    if (_isCreateMode) {
      final effectiveTitle = title.isEmpty
          ? (content.length > 30 ? '${content.substring(0, 30)}...' : content)
          : title;
      final result = await service.saveNote(
        title: effectiveTitle,
        content: content,
        tags: _tags,
        isPinned: _isPinned,
        isPremium: isPremium,
      );
      if (result == null && mounted) {
        await showContextualPaywall(
          context,
          ref,
          paywallContext: PaywallContext.general,
        );
        return;
      }
      savedNote = result;

      // Attach pending reminder if set during creation
      if (_hasPendingReminder && _pendingReminderDate != null && savedNote != null) {
        await service.addReminder(
          noteId: savedNote.id,
          scheduledAt: _pendingReminderDate!,
          frequency: _pendingReminderFrequency,
          customMessage: _pendingReminderMessage,
          isPremium: isPremium,
        );
      }
    } else if (_existingNote != null) {
      final updated = _existingNote!.copyWith(
        title: title.isEmpty
            ? (content.length > 30 ? '${content.substring(0, 30)}...' : content)
            : title,
        content: content,
        isPinned: _isPinned,
        tags: _tags,
      );
      await service.updateNote(updated);
    }

    ref.invalidate(allNotesProvider);
    ref.invalidate(pinnedNotesProvider);
    ref.invalidate(upcomingRemindersProvider);

    if (mounted) context.pop();
  }

  Future<void> _delete(NoteToSelfService service) async {
    if (_existingNote == null) return;
    HapticService.buttonPress();
    await service.deleteNote(_existingNote!.id);
    ref.invalidate(allNotesProvider);
    ref.invalidate(pinnedNotesProvider);
    ref.invalidate(upcomingRemindersProvider);
    if (mounted) context.pop();
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      HapticService.buttonPress();
      setState(() => _tags.add(tag));
      _tagController.clear();
    }
  }

  Future<void> _addReminder(NoteToSelfService service, bool isPremium) async {
    if (_existingNote == null || _reminderDate == null) return;

    HapticService.buttonPress();
    final result = await service.addReminder(
      noteId: _existingNote!.id,
      scheduledAt: _reminderDate!,
      frequency: _reminderFrequency,
      customMessage: _reminderMessageController.text.trim().isNotEmpty
          ? _reminderMessageController.text.trim()
          : null,
      isPremium: isPremium,
    );

    if (result == null && mounted) {
      await showContextualPaywall(
        context,
        ref,
        paywallContext: PaywallContext.general,
      );
      return;
    }

    setState(() {
      _reminders = service.getRemindersForNote(_existingNote!.id);
      _showReminderForm = false;
      _reminderDate = null;
      _reminderMessageController.clear();
      _reminderFrequency = ReminderFrequency.once;
    });
    ref.invalidate(upcomingRemindersProvider);
  }

  Future<void> _removeReminder(
      NoteToSelfService service, String reminderId) async {
    HapticService.buttonPress();
    await service.removeReminder(reminderId);
    setState(() {
      _reminders = service.getRemindersForNote(_existingNote!.id);
    });
    ref.invalidate(upcomingRemindersProvider);
  }

  Future<void> _pickReminderDate() async {
    final now = DateTime.now();
    final language = ref.read(languageProvider);
    final isEn = language == AppLanguage.en;
    final currentDate = _isCreateMode ? _pendingReminderDate : _reminderDate;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => Container(
        height: 280,
        color: CupertinoColors.systemBackground.resolveFrom(ctx),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: Text(isEn ? 'Cancel' : '\u0130ptal'),
                  onPressed: () => Navigator.pop(ctx),
                ),
                CupertinoButton(
                  child: Text(isEn ? 'Done' : 'Tamam'),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                initialDateTime:
                    currentDate ?? now.add(const Duration(hours: 1)),
                minimumDate: now,
                onDateTimeChanged: (dt) {
                  setState(() {
                    if (_isCreateMode) {
                      _pendingReminderDate = dt;
                    } else {
                      _reminderDate = dt;
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Set a pending reminder for create mode (will be attached after save)
  void _setPendingReminder() {
    if (_pendingReminderDate == null) return;
    HapticService.buttonPress();
    setState(() {
      _hasPendingReminder = true;
      _pendingReminderMessage = _reminderMessageController.text.trim().isNotEmpty
          ? _reminderMessageController.text.trim()
          : null;
      _showReminderForm = false;
      _reminderMessageController.clear();
    });
  }

  String _formatReminderDate(DateTime dt, bool isEn) {
    final months = isEn
        ? ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
        : ['Oca', '\u015eub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'A\u011fu', 'Eyl', 'Eki', 'Kas', 'Ara'];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPremium = ref.watch(isPremiumUserProvider);
    final serviceAsync = ref.watch(notesToSelfServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          behavior: HitTestBehavior.opaque,
          child: serviceAsync.when(
            loading: () => const CosmicLoadingIndicator(),
            error: (_, _) => Center(
              child: Text(
                isEn ? 'Something went wrong' : 'Bir \u015feyler ters gitti',
                style:
                    TextStyle(color: isDark ? Colors.white70 : Colors.black54),
              ),
            ),
            data: (service) {
              _loadNote(service);
              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: _isCreateMode
                        ? (isEn ? 'New Note' : 'Yeni Not')
                        : (isEn ? 'Edit Note' : 'Notu D\u00fczenle'),
                    useGradientTitle: true,
                    gradientVariant: GradientTextVariant.gold,
                    actions: [
                      // Save
                      GestureDetector(
                        onTap: () => _save(service, isPremium),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.auroraStart,
                                AppColors.auroraEnd,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            isEn ? 'Save' : 'Kaydet',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ═══════════════════════════════════════
                          // TITLE INPUT + PIN
                          // ═══════════════════════════════════════
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _titleController,
                                  style: GoogleFonts.inter(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? AppColors.textPrimary
                                        : AppColors.lightTextPrimary,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: isEn ? 'Title' : 'Ba\u015fl\u0131k',
                                    hintStyle: GoogleFonts.inter(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.2)
                                          : Colors.black.withValues(alpha: 0.15),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticService.buttonPress();
                                  setState(() => _isPinned = !_isPinned);
                                },
                                child: Icon(
                                  _isPinned
                                      ? Icons.push_pin
                                      : Icons.push_pin_outlined,
                                  size: 20,
                                  color: _isPinned
                                      ? AppColors.starGold
                                      : (isDark ? Colors.white38 : Colors.black26),
                                ),
                              ),
                            ],
                          ),

                          // Subtle divider
                          Container(
                            height: 1,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  (isDark ? Colors.white : Colors.black)
                                      .withValues(alpha: 0.08),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // ═══════════════════════════════════════
                          // CONTENT INPUT
                          // ═══════════════════════════════════════
                          TextField(
                            controller: _contentController,
                            maxLines: null,
                            minLines: 8,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.9)
                                  : Colors.black87,
                              height: 1.6,
                            ),
                            decoration: InputDecoration(
                              hintText: isEn
                                  ? 'Write your thoughts...'
                                  : 'D\u00fc\u015f\u00fcncelerini yaz...',
                              hintStyle: GoogleFonts.inter(
                                fontSize: 16,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.2)
                                    : Colors.black.withValues(alpha: 0.15),
                              ),
                              border: InputBorder.none,
                            ),
                          ),

                          // Word count
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              _wordCount == 0
                                  ? ''
                                  : (isEn
                                      ? '$_wordCount words'
                                      : '$_wordCount kelime'),
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: isDark ? Colors.white24 : Colors.black.withValues(alpha: 0.2),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ═══════════════════════════════════════
                          // TAGS SECTION
                          // ═══════════════════════════════════════
                          _GlassSection(
                            isDark: isDark,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.tag,
                                      size: 15,
                                      color: AppColors.amethyst,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      isEn ? 'Tags' : 'Etiketler',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                if (_tags.isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 6,
                                    children: _tags
                                        .map((tag) => _RemovableTagChip(
                                              tag: tag,
                                              isDark: isDark,
                                              onRemove: () => setState(
                                                  () => _tags.remove(tag)),
                                            ))
                                        .toList(),
                                  ),
                                ],
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _tagController,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: isEn
                                              ? 'Add tag...'
                                              : 'Etiket ekle...',
                                          hintStyle: TextStyle(
                                            color: isDark
                                                ? Colors.white24
                                                : Colors.black.withValues(alpha: 0.2),
                                          ),
                                          isDense: true,
                                          filled: true,
                                          fillColor: (isDark
                                                  ? Colors.white
                                                  : Colors.black)
                                              .withValues(alpha: 0.05),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
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
                                          color: AppColors.amethyst
                                              .withValues(alpha: 0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          CupertinoIcons.plus,
                                          size: 18,
                                          color: AppColors.amethyst,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Mood badge
                          if (_existingNote?.moodAtCreation != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.amethyst.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _existingNote!.moodAtCreation!,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isEn
                                        ? 'Mood when created'
                                        : 'Olu\u015fturuldu\u011fundaki ruh hali',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: isDark
                                          ? Colors.white54
                                          : Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          // ═══════════════════════════════════════
                          // REMINDERS SECTION (both create & edit)
                          // ═══════════════════════════════════════
                          const SizedBox(height: 20),
                          _GlassSection(
                            isDark: isDark,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.bell,
                                          size: 15,
                                          color: AppColors.starGold,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          isEn
                                              ? 'Remind Me'
                                              : 'Hat\u0131rlat',
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        HapticService.buttonPress();
                                        setState(() => _showReminderForm =
                                            !_showReminderForm);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppColors.starGold
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              _showReminderForm
                                                  ? CupertinoIcons.minus
                                                  : CupertinoIcons.plus,
                                              size: 14,
                                              color: AppColors.starGold,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              isEn ? 'Add' : 'Ekle',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.starGold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Pending reminder indicator (create mode)
                                if (_isCreateMode && _hasPendingReminder && _pendingReminderDate != null) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.starGold
                                          .withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.bell_fill,
                                          size: 16,
                                          color: AppColors.starGold,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _formatReminderDate(
                                                    _pendingReminderDate!,
                                                    isEn),
                                                style: GoogleFonts.inter(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.black87,
                                                ),
                                              ),
                                              Text(
                                                isEn
                                                    ? 'Will be set when you save'
                                                    : 'Kaydetti\u011finde ayarlanacak',
                                                style: GoogleFonts.inter(
                                                  fontSize: 11,
                                                  color: isDark
                                                      ? Colors.white54
                                                      : Colors.black45,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            HapticService.buttonPress();
                                            setState(() {
                                              _hasPendingReminder = false;
                                              _pendingReminderDate = null;
                                              _pendingReminderMessage = null;
                                            });
                                          },
                                          child: Icon(
                                            CupertinoIcons.xmark_circle,
                                            size: 18,
                                            color: isDark
                                                ? Colors.white38
                                                : Colors.black26,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],

                                // Existing reminders (edit mode)
                                if (!_isCreateMode && _reminders.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  ..._reminders.map((r) => _ReminderRow(
                                        reminder: r,
                                        isEn: isEn,
                                        isDark: isDark,
                                        onDelete: () => _removeReminder(
                                            service, r.id),
                                      )),
                                ],

                                // No reminders hint
                                if (!_showReminderForm &&
                                    _reminders.isEmpty &&
                                    !(_isCreateMode && _hasPendingReminder)) ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    isEn
                                        ? 'Set a date & time to get notified about this note'
                                        : 'Bu not hakk\u0131nda bildirim almak i\u00e7in tarih ve saat belirle',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: isDark
                                          ? Colors.white30
                                          : Colors.black26,
                                    ),
                                  ),
                                ],

                                // Add reminder form
                                if (_showReminderForm) ...[
                                  const SizedBox(height: 12),
                                  _ReminderForm(
                                    isEn: isEn,
                                    isDark: isDark,
                                    isPremium: isPremium,
                                    reminderDate: _isCreateMode
                                        ? _pendingReminderDate
                                        : _reminderDate,
                                    frequency: _isCreateMode
                                        ? _pendingReminderFrequency
                                        : _reminderFrequency,
                                    messageController:
                                        _reminderMessageController,
                                    onPickDate: _pickReminderDate,
                                    onFrequencyChanged: (f) {
                                      if (_isCreateMode) {
                                        setState(
                                            () => _pendingReminderFrequency = f);
                                      } else {
                                        setState(
                                            () => _reminderFrequency = f);
                                      }
                                    },
                                    onSave: _isCreateMode
                                        ? _setPendingReminder
                                        : () => _addReminder(service, isPremium),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // ═══════════════════════════════════════
                          // DELETE BUTTON
                          // ═══════════════════════════════════════
                          if (!_isCreateMode) ...[
                            const SizedBox(height: 32),
                            Center(
                              child: GestureDetector(
                                onTap: () async {
                                  final confirmed =
                                      await showCupertinoDialog<bool>(
                                    context: context,
                                    builder: (ctx) => CupertinoAlertDialog(
                                      title: Text(isEn
                                          ? 'Delete Note?'
                                          : 'Not Silinsin mi?'),
                                      content: Text(
                                        isEn
                                            ? 'This action cannot be undone.'
                                            : 'Bu i\u015flem geri al\u0131namaz.',
                                      ),
                                      actions: [
                                        CupertinoDialogAction(
                                          child:
                                              Text(isEn ? 'Cancel' : '\u0130ptal'),
                                          onPressed: () =>
                                              Navigator.pop(ctx, false),
                                        ),
                                        CupertinoDialogAction(
                                          isDestructiveAction: true,
                                          child: Text(isEn ? 'Delete' : 'Sil'),
                                          onPressed: () =>
                                              Navigator.pop(ctx, true),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirmed == true) _delete(service);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent
                                        .withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        CupertinoIcons.trash,
                                        size: 16,
                                        color: Colors.redAccent,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        isEn ? 'Delete Note' : 'Notu Sil',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 60),
                        ],
                      ).animate().fadeIn(duration: 350.ms),
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
}

// ═══════════════════════════════════════════════════════════════════════
// GLASS SECTION CONTAINER
// ═══════════════════════════════════════════════════════════════════════

class _GlassSection extends StatelessWidget {
  final bool isDark;
  final Widget child;

  const _GlassSection({required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.035)
            : Colors.black.withValues(alpha: 0.025),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// REMOVABLE TAG CHIP
// ═══════════════════════════════════════════════════════════════════════

class _RemovableTagChip extends StatelessWidget {
  final String tag;
  final bool isDark;
  final VoidCallback onRemove;

  const _RemovableTagChip({
    required this.tag,
    required this.isDark,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 5, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.amethyst.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.amethyst
                  : AppColors.amethyst.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              CupertinoIcons.xmark_circle_fill,
              size: 16,
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// REMINDER ROW
// ═══════════════════════════════════════════════════════════════════════

class _ReminderRow extends StatelessWidget {
  final NoteReminder reminder;
  final bool isEn;
  final bool isDark;
  final VoidCallback onDelete;

  const _ReminderRow({
    required this.reminder,
    required this.isEn,
    required this.isDark,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final freq =
        isEn ? reminder.frequency.displayNameEn() : reminder.frequency.displayNameTr();
    final dateStr = _formatDate(reminder.scheduledAt, isEn);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(CupertinoIcons.bell_fill, size: 16, color: AppColors.starGold),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateStr,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  freq,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
                if (reminder.customMessage != null)
                  Text(
                    reminder.customMessage!,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(CupertinoIcons.xmark_circle, size: 18, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt, bool isEn) {
    final months = isEn
        ? ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
        : ['Oca', '\u015eub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'A\u011fu', 'Eyl', 'Eki', 'Kas', 'Ara'];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $h:$m';
  }
}

// ═══════════════════════════════════════════════════════════════════════
// REMINDER FORM
// ═══════════════════════════════════════════════════════════════════════

class _ReminderForm extends StatelessWidget {
  final bool isEn;
  final bool isDark;
  final bool isPremium;
  final DateTime? reminderDate;
  final ReminderFrequency frequency;
  final TextEditingController messageController;
  final VoidCallback onPickDate;
  final ValueChanged<ReminderFrequency> onFrequencyChanged;
  final VoidCallback onSave;

  const _ReminderForm({
    required this.isEn,
    required this.isDark,
    required this.isPremium,
    required this.reminderDate,
    required this.frequency,
    required this.messageController,
    required this.onPickDate,
    required this.onFrequencyChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.starGold.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date picker
          GestureDetector(
            onTap: onPickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: (isDark ? Colors.white : Colors.black)
                    .withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(CupertinoIcons.calendar, size: 16, color: AppColors.starGold),
                  const SizedBox(width: 8),
                  Text(
                    reminderDate != null
                        ? _formatDate(reminderDate!, isEn)
                        : (isEn
                            ? 'Pick date & time'
                            : 'Tarih ve saat se\u00e7'),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: reminderDate != null
                          ? (isDark ? Colors.white : Colors.black87)
                          : (isDark ? Colors.white38 : Colors.black38),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Frequency chips
          Text(
            isEn ? 'Frequency' : 'S\u0131kl\u0131k',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: ReminderFrequency.values.map((f) {
              final isSelected = f == frequency;
              final isLocked = !isPremium && f != ReminderFrequency.once;
              final label = isEn ? f.displayNameEn() : f.displayNameTr();
              return GestureDetector(
                onTap: isLocked ? null : () => onFrequencyChanged(f),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.starGold.withValues(alpha: 0.2)
                        : (isDark ? Colors.white : Colors.black)
                            .withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isLocked ? '$label (PRO)' : label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isLocked
                          ? (isDark ? Colors.white30 : Colors.black26)
                          : isSelected
                              ? AppColors.starGold
                              : (isDark ? Colors.white70 : Colors.black54),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          // Custom message
          TextField(
            controller: messageController,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: isEn
                  ? 'Custom message (optional)'
                  : '\u00d6zel mesaj (iste\u011fe ba\u011fl\u0131)',
              hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.black.withValues(alpha: 0.2)),
              isDense: true,
              filled: true,
              fillColor:
                  (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),

          const SizedBox(height: 14),

          // Save button
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: reminderDate != null ? onSave : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: reminderDate != null
                      ? LinearGradient(
                          colors: [AppColors.auroraStart, AppColors.auroraEnd],
                        )
                      : null,
                  color: reminderDate == null
                      ? (isDark ? Colors.white : Colors.black)
                          .withValues(alpha: 0.08)
                      : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  isEn ? 'Set Reminder' : 'Hat\u0131rlat\u0131c\u0131 Ayarla',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: reminderDate != null
                        ? Colors.white
                        : (isDark ? Colors.white38 : Colors.black26),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.05, end: 0);
  }

  String _formatDate(DateTime dt, bool isEn) {
    final months = isEn
        ? ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
        : ['Oca', '\u015eub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'A\u011fu', 'Eyl', 'Eki', 'Kas', 'Ara'];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $h:$m';
  }
}
