// ════════════════════════════════════════════════════════════════════════════
// NOTE DETAIL SCREEN - Create / Edit / View a Note to Self
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/note_to_self.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/note_to_self_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../data/services/haptic_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
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

  bool get _isCreateMode => widget.noteId == null || widget.noteId!.isEmpty;
  bool _isLoaded = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    _reminderMessageController.dispose();
    super.dispose();
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

    if (_isCreateMode) {
      final result = await service.saveNote(
        title: title.isEmpty ? (content.length > 30 ? '${content.substring(0, 30)}...' : content) : title,
        content: content,
        tags: _tags,
        isPinned: _isPinned,
        isPremium: isPremium,
      );
      if (result == null && mounted) {
        // Free limit reached — show paywall
        await showContextualPaywall(
          context,
          ref,
          paywallContext: PaywallContext.general,
        );
        return;
      }
    } else if (_existingNote != null) {
      final updated = _existingNote!.copyWith(
        title: title.isEmpty ? (content.length > 30 ? '${content.substring(0, 30)}...' : content) : title,
        content: content,
        isPinned: _isPinned,
        tags: _tags,
      );
      await service.updateNote(updated);
    }

    // Invalidate providers so list refreshes
    ref.invalidate(allNotesProvider);
    ref.invalidate(pinnedNotesProvider);
    ref.invalidate(upcomingRemindersProvider);

    if (mounted) context.pop();
  }

  Future<void> _delete(NoteToSelfService service) async {
    if (_existingNote == null) return;
    await service.deleteNote(_existingNote!.id);
    ref.invalidate(allNotesProvider);
    ref.invalidate(pinnedNotesProvider);
    ref.invalidate(upcomingRemindersProvider);
    if (mounted) context.pop();
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() => _tags.add(tag));
      _tagController.clear();
    }
  }

  Future<void> _addReminder(NoteToSelfService service, bool isPremium) async {
    if (_existingNote == null || _reminderDate == null) return;

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

  Future<void> _removeReminder(NoteToSelfService service, String reminderId) async {
    await service.removeReminder(reminderId);
    setState(() {
      _reminders = service.getRemindersForNote(_existingNote!.id);
    });
    ref.invalidate(upcomingRemindersProvider);
  }

  Future<void> _pickReminderDate() async {
    final now = DateTime.now();
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
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(ctx),
                ),
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                initialDateTime: _reminderDate ?? now.add(const Duration(hours: 1)),
                minimumDate: now,
                onDateTimeChanged: (dt) {
                  setState(() => _reminderDate = dt);
                },
              ),
            ),
          ],
        ),
      ),
    );
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
          child: SafeArea(
            child: serviceAsync.when(
              loading: () => const CosmicLoadingIndicator(),
              error: (_, _) => Center(
                child: Text(
                  isEn ? 'Something went wrong' : 'Bir şeyler ters gitti',
                  style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                ),
              ),
              data: (service) {
                _loadNote(service);
                return CustomScrollView(
                  slivers: [
                    GlassSliverAppBar(
                      title: _isCreateMode
                          ? (isEn ? 'New Note' : 'Yeni Not')
                          : (isEn ? 'Edit Note' : 'Notu Düzenle'),
                      actions: [
                        // Pin toggle
                        IconButton(
                          icon: Icon(
                            _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                            color: _isPinned ? AppColors.starGold : (isDark ? Colors.white54 : Colors.black45),
                          ),
                          onPressed: () {
                            HapticService.buttonPress();
                            setState(() => _isPinned = !_isPinned);
                          },
                        ),
                        // Save
                        IconButton(
                          icon: Icon(Icons.check, color: AppColors.starGold),
                          onPressed: () {
                            HapticService.buttonPress();
                            _save(service, isPremium);
                          },
                        ),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            TextField(
                              controller: _titleController,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              decoration: InputDecoration(
                                hintText: isEn ? 'Title' : 'Başlık',
                                hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.black26),
                                border: InputBorder.none,
                              ),
                            ),

                            const Divider(height: 1),
                            const SizedBox(height: 12),

                            // Content
                            TextField(
                              controller: _contentController,
                              maxLines: null,
                              minLines: 6,
                              style: TextStyle(
                                fontSize: 16,
                                color: isDark ? Colors.white.withValues(alpha: 0.9) : Colors.black87,
                                height: 1.5,
                              ),
                              decoration: InputDecoration(
                                hintText: isEn ? 'Write your note...' : 'Notunu yaz...',
                                hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.black26),
                                border: InputBorder.none,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Tags section
                            Text(
                              isEn ? 'Tags' : 'Etiketler',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white60 : Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                ..._tags.map((tag) => Chip(
                                  label: Text(tag, style: const TextStyle(fontSize: 12)),
                                  deleteIcon: const Icon(Icons.close, size: 16),
                                  onDeleted: () => setState(() => _tags.remove(tag)),
                                  backgroundColor: AppColors.cosmicPurple.withValues(alpha: 0.2),
                                  side: BorderSide.none,
                                )),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _tagController,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: isEn ? 'Add tag...' : 'Etiket ekle...',
                                      hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.black26),
                                      isDense: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    ),
                                    onSubmitted: (_) => _addTag(),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(Icons.add_circle, color: AppColors.starGold),
                                  onPressed: _addTag,
                                ),
                              ],
                            ),

                            // Mood badge
                            if (_existingNote?.moodAtCreation != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.amethyst.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  isEn
                                      ? 'Created when mood was: ${_existingNote!.moodAtCreation}'
                                      : 'Oluşturulduğunda ruh hali: ${_existingNote!.moodAtCreation}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? Colors.white60 : Colors.black54,
                                  ),
                                ),
                              ),
                            ],

                            // Reminders section (only for existing notes)
                            if (!_isCreateMode) ...[
                              const SizedBox(height: 28),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isEn ? 'Reminders' : 'Hatırlatıcılar',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  TextButton.icon(
                                    icon: const Icon(Icons.add, size: 18),
                                    label: Text(isEn ? 'Add' : 'Ekle'),
                                    onPressed: () {
                                      setState(() => _showReminderForm = !_showReminderForm);
                                    },
                                  ),
                                ],
                              ),

                              // Existing reminders
                              ..._reminders.map((r) => _ReminderRow(
                                reminder: r,
                                isEn: isEn,
                                isDark: isDark,
                                onDelete: () => _removeReminder(service, r.id),
                              )),

                              // Add reminder form
                              if (_showReminderForm)
                                _ReminderForm(
                                  isEn: isEn,
                                  isDark: isDark,
                                  isPremium: isPremium,
                                  reminderDate: _reminderDate,
                                  frequency: _reminderFrequency,
                                  messageController: _reminderMessageController,
                                  onPickDate: _pickReminderDate,
                                  onFrequencyChanged: (f) => setState(() => _reminderFrequency = f),
                                  onSave: () => _addReminder(service, isPremium),
                                ),
                            ],

                            // Delete button (existing notes only)
                            if (!_isCreateMode) ...[
                              const SizedBox(height: 40),
                              Center(
                                child: TextButton.icon(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                  label: Text(
                                    isEn ? 'Delete Note' : 'Notu Sil',
                                    style: const TextStyle(color: Colors.redAccent),
                                  ),
                                  onPressed: () async {
                                    final confirmed = await showCupertinoDialog<bool>(
                                      context: context,
                                      builder: (ctx) => CupertinoAlertDialog(
                                        title: Text(isEn ? 'Delete Note?' : 'Not Silinsin mi?'),
                                        content: Text(
                                          isEn
                                              ? 'This action cannot be undone.'
                                              : 'Bu işlem geri alınamaz.',
                                        ),
                                        actions: [
                                          CupertinoDialogAction(
                                            child: Text(isEn ? 'Cancel' : 'İptal'),
                                            onPressed: () => Navigator.pop(ctx, false),
                                          ),
                                          CupertinoDialogAction(
                                            isDestructiveAction: true,
                                            child: Text(isEn ? 'Delete' : 'Sil'),
                                            onPressed: () => Navigator.pop(ctx, true),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirmed == true) _delete(service);
                                  },
                                ),
                              ),
                            ],

                            const SizedBox(height: 40),
                          ],
                        ).animate().fadeIn(duration: 300.ms),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
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
    final freq = isEn
        ? reminder.frequency.displayNameEn()
        : reminder.frequency.displayNameTr();
    final dateStr = _formatDate(reminder.scheduledAt, isEn);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.notifications_active, size: 18, color: AppColors.starGold),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  freq,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
                if (reminder.customMessage != null)
                  Text(
                    reminder.customMessage!,
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            color: Colors.redAccent,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt, bool isEn) {
    final months = isEn
        ? ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
        : ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'];
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
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cosmicPurple.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cosmicPurple.withValues(alpha: 0.2)),
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
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: AppColors.starGold),
                  const SizedBox(width: 8),
                  Text(
                    reminderDate != null
                        ? _formatDate(reminderDate!, isEn)
                        : (isEn ? 'Pick date & time' : 'Tarih ve saat seç'),
                    style: TextStyle(
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
            isEn ? 'Frequency' : 'Sıklık',
            style: TextStyle(
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
              return ChoiceChip(
                label: Text(
                  isLocked ? '$label (PRO)' : label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black54),
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.cosmicPurple,
                onSelected: isLocked ? null : (_) => onFrequencyChanged(f),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          // Custom message
          TextField(
            controller: messageController,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: isEn ? 'Custom message (optional)' : 'Özel mesaj (isteğe bağlı)',
              hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.black26),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),

          const SizedBox(height: 14),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: reminderDate != null ? onSave : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.starGold,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(isEn ? 'Set Reminder' : 'Hatırlatıcı Ayarla'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt, bool isEn) {
    final months = isEn
        ? ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
        : ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $h:$m';
  }
}
