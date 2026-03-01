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
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/common_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/note_to_self.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/note_to_self_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../data/services/haptic_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_dialog.dart';
import '../../../shared/widgets/private_toggle.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';
import '../../../data/services/l10n_service.dart';

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
  bool _isPrivate = false;
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
  bool _hasChanges = false;
  int _wordCount = 0;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_updateWordCount);
    _titleController.addListener(_markChanged);
    _contentController.addListener(_markChanged);
  }

  void _markChanged() {
    if (!_hasChanges && (_isLoaded || _isCreateMode)) {
      setState(() => _hasChanges = true);
    }
  }

  @override
  void dispose() {
    _contentController.removeListener(_updateWordCount);
    _titleController.removeListener(_markChanged);
    _contentController.removeListener(_markChanged);
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
        _isPrivate = note.isPrivate;
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
        isPrivate: _isPrivate,
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
      if (_hasPendingReminder &&
          _pendingReminderDate != null &&
          savedNote != null) {
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
        isPrivate: _isPrivate,
        tags: _tags,
      );
      await service.updateNote(updated);
    }

    ref.invalidate(allNotesProvider);
    ref.invalidate(pinnedNotesProvider);
    ref.invalidate(upcomingRemindersProvider);
    ref.invalidate(privateNotesProvider);

    if (mounted) {
      _hasChanges = false;
      context.pop();
    }
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
      setState(() {
        _tags.add(tag);
        _hasChanges = true;
      });
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

    if (!mounted) return;
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
    NoteToSelfService service,
    String reminderId,
  ) async {
    HapticService.buttonPress();
    await service.removeReminder(reminderId);
    if (!mounted) return;
    setState(() {
      _reminders = service.getRemindersForNote(_existingNote!.id);
    });
    ref.invalidate(upcomingRemindersProvider);
  }

  Future<void> _pickReminderDate() async {
    final now = DateTime.now();
    final language = ref.read(languageProvider);
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
                  child: Text(L10nService.get('notes.note_detail.cancel', language)),
                  onPressed: () => Navigator.pop(ctx),
                ),
                CupertinoButton(
                  child: Text(L10nService.get('notes.note_detail.save_note', language)),
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
      _pendingReminderMessage =
          _reminderMessageController.text.trim().isNotEmpty
          ? _reminderMessageController.text.trim()
          : null;
      _showReminderForm = false;
      _reminderMessageController.clear();
    });
  }

  String _formatReminderDate(DateTime dt, bool isEn) {
    final months = isEn
        ? CommonStrings.monthsShortEn
        : CommonStrings.monthsShortTr;
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
            behavior: HitTestBehavior.opaque,
            child: serviceAsync.when(
              loading: () => const CosmicLoadingIndicator(),
              error: (_, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      L10nService.get('notes.note_detail.couldnt_load_this_note', language),
                      textAlign: TextAlign.center,
                      style: AppTypography.decorativeScript(
                        color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () =>
                          ref.invalidate(notesToSelfServiceProvider),
                      icon: Icon(Icons.refresh_rounded,
                          size: 16, color: AppColors.starGold),
                      label: Text(
                        L10nService.get('notes.note_detail.retry', language),
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
              data: (service) {
                _loadNote(service);
                return CupertinoScrollbar(
                  child: CustomScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      GlassSliverAppBar(
                        title: _isCreateMode
                            ? (L10nService.get('notes.note_detail.new_note', language))
                            : (L10nService.get('notes.note_detail.edit_note', language)),
                        useGradientTitle: true,
                        gradientVariant: GradientTextVariant.gold,
                        actions: [
                          // Save
                          GestureDetector(
                            onTap: () => _save(service, isPremium),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
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
                                L10nService.get('notes.note_detail.save_note_1', language),
                                style: AppTypography.displayFont.copyWith(
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
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      textInputAction: TextInputAction.next,
                                      style: AppTypography.displayFont.copyWith(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? AppColors.textPrimary
                                            : AppColors.lightTextPrimary,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: L10nService.get('notes.note_detail.give_this_note_a_title', language),
                                        hintStyle: AppTypography.displayFont
                                            .copyWith(
                                              fontSize: 26,
                                              fontWeight: FontWeight.w600,
                                              color: isDark
                                                  ? Colors.white.withValues(
                                                      alpha: 0.2,
                                                    )
                                                  : Colors.black.withValues(
                                                      alpha: 0.15,
                                                    ),
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
                                          : (isDark
                                                ? AppColors.textMuted
                                                : AppColors.lightTextMuted),
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
                                textCapitalization:
                                    TextCapitalization.sentences,
                                style: AppTypography.subtitle(
                                  fontSize: 16,
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.9)
                                      : AppColors.lightTextPrimary,
                                  height: 1.6,
                                ),
                                decoration: InputDecoration(
                                  hintText: L10nService.get('notes.note_detail.write_your_thoughts', language),
                                  hintStyle: AppTypography.subtitle(
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
                                  style: AppTypography.elegantAccent(
                                    fontSize: 11,
                                    color: isDark
                                        ? AppColors.textMuted
                                        : Colors.black.withValues(alpha: 0.2),
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
                                          L10nService.get('notes.note_detail.tags', language),
                                          style: AppTypography.elegantAccent(
                                            fontSize: 14,
                                            color: isDark
                                                ? AppColors.textMuted
                                                : AppColors.lightTextMuted,
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
                                            .map(
                                              (tag) => _RemovableTagChip(
                                                tag: tag,
                                                isDark: isDark,
                                                onRemove: () => setState(
                                                  () => _tags.remove(tag),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: _tagController,
                                            style: AppTypography.subtitle(
                                              fontSize: 14,
                                              color: isDark
                                                  ? Colors.white
                                                  : AppColors.lightTextPrimary,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: L10nService.get('notes.note_detail.eg_ideas_personal', language),
                                              hintStyle: AppTypography.subtitle(
                                                color: isDark
                                                    ? AppColors.textMuted
                                                    : Colors.black.withValues(
                                                        alpha: 0.2,
                                                      ),
                                              ),
                                              isDense: true,
                                              filled: true,
                                              fillColor:
                                                  (isDark
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
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.amethyst.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _existingNote!.moodAtCreation!,
                                        style: AppTypography.subtitle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        L10nService.get('notes.note_detail.mood_when_created', language),
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
                                              L10nService.get('notes.note_detail.remind_me', language),
                                              style:
                                                  AppTypography.elegantAccent(
                                                    fontSize: 14,
                                                    color: isDark
                                                        ? AppColors.textMuted
                                                        : AppColors.lightTextMuted,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            HapticService.buttonPress();
                                            setState(
                                              () => _showReminderForm =
                                                  !_showReminderForm,
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
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
                                                  L10nService.get('notes.note_detail.add', language),
                                                  style:
                                                      AppTypography.elegantAccent(
                                                        fontSize: 12,
                                                        color:
                                                            AppColors.starGold,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Pending reminder indicator (create mode)
                                    if (_isCreateMode &&
                                        _hasPendingReminder &&
                                        _pendingReminderDate != null) ...[
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.starGold.withValues(
                                            alpha: 0.08,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
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
                                                      isEn,
                                                    ),
                                                    style:
                                                        AppTypography.subtitle(
                                                          fontSize: 13,
                                                          color: isDark
                                                              ? Colors.white
                                                              : AppColors.lightTextPrimary,
                                                        ),
                                                  ),
                                                  Text(
                                                    L10nService.get('notes.note_detail.will_be_set_when_you_save', language),
                                                    style:
                                                        AppTypography.elegantAccent(
                                                          fontSize: 11,
                                                          color: isDark
                                                              ? AppColors.textMuted
                                                              : AppColors.lightTextMuted,
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
                                                  _pendingReminderMessage =
                                                      null;
                                                });
                                              },
                                              child: Icon(
                                                CupertinoIcons.xmark_circle,
                                                size: 18,
                                                color: isDark
                                                    ? AppColors.textMuted
                                                    : AppColors.lightTextMuted,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],

                                    // Existing reminders (edit mode)
                                    if (!_isCreateMode &&
                                        _reminders.isNotEmpty) ...[
                                      const SizedBox(height: 12),
                                      ..._reminders.map(
                                        (r) => _ReminderRow(
                                          reminder: r,
                                          isEn: isEn,
                                          isDark: isDark,
                                          onDelete: () =>
                                              _removeReminder(service, r.id),
                                        ),
                                      ),
                                    ],

                                    // No reminders hint
                                    if (!_showReminderForm &&
                                        _reminders.isEmpty &&
                                        !(_isCreateMode &&
                                            _hasPendingReminder)) ...[
                                      const SizedBox(height: 10),
                                      Text(
                                        L10nService.get('notes.note_detail.set_a_date_time_to_get_notified_about_th', language),
                                        style: AppTypography.elegantAccent(
                                          fontSize: 12,
                                          color: isDark
                                              ? AppColors.textMuted
                                              : AppColors.lightTextMuted,
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
                                              () =>
                                                  _pendingReminderFrequency = f,
                                            );
                                          } else {
                                            setState(
                                              () => _reminderFrequency = f,
                                            );
                                          }
                                        },
                                        onSave: _isCreateMode
                                            ? _setPendingReminder
                                            : () => _addReminder(
                                                service,
                                                isPremium,
                                              ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              // ═══════════════════════════════════════
                              // PRIVATE VAULT TOGGLE
                              // ═══════════════════════════════════════
                              const SizedBox(height: 20),
                              PrivateToggle(
                                isPrivate: _isPrivate,
                                onChanged: (v) {
                                  setState(() {
                                    _isPrivate = v;
                                    _hasChanges = true;
                                  });
                                },
                                isEn: isEn,
                                isDark: isDark,
                              ),

                              // ═══════════════════════════════════════
                              // SHARE & DELETE BUTTONS
                              // ═══════════════════════════════════════
                              if (!_isCreateMode) ...[
                                const SizedBox(height: 32),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Share button
                                    if (!_isPrivate)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 16,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            HapticService.buttonPress();
                                            final title = _titleController.text
                                                .trim();
                                            final body = _contentController.text
                                                .trim();
                                            final shareText = title.isNotEmpty
                                                ? '$title\n\n$body'
                                                : body;
                                            if (shareText.isNotEmpty) {
                                              SharePlus.instance.share(
                                                ShareParams(text: shareText),
                                              );
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.starGold
                                                  .withValues(alpha: 0.08),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.share_rounded,
                                                  size: 16,
                                                  color: AppColors.starGold,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  L10nService.get('notes.note_detail.share', language),
                                                  style: AppTypography.subtitle(
                                                    fontSize: 14,
                                                    color: AppColors.starGold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    // Delete button
                                    GestureDetector(
                                      onTap: () async {
                                        final confirmed =
                                            await GlassDialog.confirm(
                                              context,
                                              title: L10nService.get('notes.note_detail.delete_note', language),
                                              message: L10nService.get('notes.note_detail.this_note_will_be_permanently_deleted', language),
                                              cancelLabel: L10nService.get('notes.note_detail.cancel_1', language),
                                              confirmLabel: L10nService.get('notes.note_detail.delete', language),
                                              isDestructive: true,
                                            );
                                        if (confirmed == true) _delete(service);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.error.withValues(
                                            alpha: 0.08,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              CupertinoIcons.trash,
                                              size: 16,
                                              color: AppColors.error,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              L10nService.get('notes.note_detail.delete_note_1', language),
                                              style: AppTypography.subtitle(
                                                fontSize: 14,
                                                color: AppColors.error,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],

                              const SizedBox(height: 60),
                            ],
                          ).animate().fadeIn(duration: 350.ms),
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

  Future<void> _showDiscardDialog() async {
    final language = ref.read(languageProvider);
    final confirmed = await GlassDialog.confirm(
      context,
      title: L10nService.get('notes.note_detail.discard_changes', language),
      message: L10nService.get('notes.note_detail.you_have_unsaved_changes_are_you_sure_yo', language),
      cancelLabel: L10nService.get('notes.note_detail.cancel_2', language),
      confirmLabel: L10nService.get('notes.note_detail.discard', language),
      isDestructive: true,
    );
    if (confirmed == true && mounted) {
      if (context.canPop()) context.pop();
    }
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
            style: AppTypography.subtitle(
              fontSize: 13,
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
              color: (isDark ? Colors.white : Colors.black).withValues(
                alpha: 0.3,
              ),
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
    final freq = reminder.frequency.localizedName(isEn);
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
                  style: AppTypography.subtitle(
                    fontSize: 13,
                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  freq,
                  style: AppTypography.elegantAccent(
                    fontSize: 11,
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                ),
                if (reminder.customMessage != null)
                  Text(
                    reminder.customMessage!,
                    style: AppTypography.decorativeScript(
                      fontSize: 11,
                      color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(
              CupertinoIcons.xmark_circle,
              size: 18,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt, bool isEn) {
    final months = isEn
        ? CommonStrings.monthsShortEn
        : CommonStrings.monthsShortTr;
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
    final language = AppLanguage.fromIsEn(isEn);
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
                color: (isDark ? Colors.white : Colors.black).withValues(
                  alpha: 0.04,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.calendar,
                    size: 16,
                    color: AppColors.starGold,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    reminderDate != null
                        ? _formatDate(reminderDate!, isEn)
                        : (L10nService.get('notes.note_detail.pick_date_time', language)),
                    style: AppTypography.subtitle(
                      fontSize: 14,
                      color: reminderDate != null
                          ? (isDark ? Colors.white : AppColors.lightTextPrimary)
                          : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Frequency chips
          Text(
            L10nService.get('notes.note_detail.frequency', language),
            style: AppTypography.elegantAccent(
              fontSize: 12,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: ReminderFrequency.values.map((f) {
              final isSelected = f == frequency;
              final isLocked = !isPremium && f != ReminderFrequency.once;
              final label = f.localizedName(isEn);
              return GestureDetector(
                onTap: isLocked ? null : () => onFrequencyChanged(f),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.starGold.withValues(alpha: 0.2)
                        : (isDark ? Colors.white : Colors.black).withValues(
                            alpha: 0.05,
                          ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isLocked ? '$label (PRO)' : label,
                    style: isSelected
                        ? AppTypography.elegantAccent(
                            fontSize: 12,
                            color: isLocked
                                ? (isDark ? AppColors.textMuted : AppColors.lightTextMuted)
                                : AppColors.starGold,
                          )
                        : AppTypography.elegantAccent(
                            fontSize: 12,
                            color: isLocked
                                ? (isDark ? AppColors.textMuted : AppColors.lightTextMuted)
                                : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
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
            style: AppTypography.subtitle(
              fontSize: 14,
              color: isDark ? Colors.white : AppColors.lightTextPrimary,
            ),
            decoration: InputDecoration(
              hintText: L10nService.get('notes.note_detail.custom_message_optional', language),
              hintStyle: AppTypography.subtitle(
                color: isDark
                    ? AppColors.textMuted
                    : Colors.black.withValues(alpha: 0.2),
              ),
              isDense: true,
              filled: true,
              fillColor: (isDark ? Colors.white : Colors.black).withValues(
                alpha: 0.04,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
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
                      ? (isDark ? Colors.white : Colors.black).withValues(
                          alpha: 0.08,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  L10nService.get('notes.note_detail.set_reminder', language),
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: reminderDate != null
                        ? Colors.white
                        : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
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
        ? CommonStrings.monthsShortEn
        : CommonStrings.monthsShortTr;
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $h:$m';
  }
}
