// ════════════════════════════════════════════════════════════════════════════
// NOTES LIST SCREEN - Browse, Search, Filter Notes to Self
// ════════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/note_to_self.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/haptic_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';

class NotesListScreen extends ConsumerStatefulWidget {
  const NotesListScreen({super.key});

  @override
  ConsumerState<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends ConsumerState<NotesListScreen> {
  String _searchQuery = '';
  String? _selectedTag;
  final _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      setState(() => _searchQuery = value.trim().toLowerCase());
    });
  }

  List<NoteToSelf> _filterNotes(List<NoteToSelf> notes) {
    var filtered = notes;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((n) =>
              n.title.toLowerCase().contains(_searchQuery) ||
              n.content.toLowerCase().contains(_searchQuery) ||
              n.tags.any((t) => t.toLowerCase().contains(_searchQuery)))
          .toList();
    }

    if (_selectedTag != null) {
      filtered = filtered
          .where((n) => n.tags.any((t) => t.toLowerCase() == _selectedTag!.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notesAsync = ref.watch(allNotesProvider);

    return Scaffold(
      body: CosmicBackground(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          behavior: HitTestBehavior.opaque,
          child: SafeArea(
            child: notesAsync.when(
              loading: () => const CosmicLoadingIndicator(),
              error: (_, _) => Center(
                child: Text(
                  isEn ? 'Something went wrong' : 'Bir şeyler ters gitti',
                  style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                ),
              ),
              data: (allNotes) {
                final filtered = _filterNotes(allNotes);
                final pinned = filtered.where((n) => n.isPinned).toList();
                final unpinned = filtered.where((n) => !n.isPinned).toList();

                // Collect all tags
                final allTags = <String>{};
                for (final note in allNotes) {
                  allTags.addAll(note.tags);
                }

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    GlassSliverAppBar(
                      title: isEn ? 'Notes to Self' : 'Kendime Notlar',
                    ),

                    // Search bar
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          decoration: InputDecoration(
                            hintText: isEn ? 'Search notes...' : 'Notlarda ara...',
                            hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.black26),
                            prefixIcon: Icon(Icons.search, size: 20, color: isDark ? Colors.white38 : Colors.black38),
                            isDense: true,
                            filled: true,
                            fillColor: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                    ),

                    // Tag filter chips
                    if (allTags.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                          child: SizedBox(
                            height: 34,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _TagChip(
                                  label: isEn ? 'All' : 'Tümü',
                                  isSelected: _selectedTag == null,
                                  isDark: isDark,
                                  onTap: () => setState(() => _selectedTag = null),
                                ),
                                const SizedBox(width: 6),
                                ...allTags.map((tag) => Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: _TagChip(
                                    label: tag,
                                    isSelected: _selectedTag == tag,
                                    isDark: isDark,
                                    onTap: () => setState(() {
                                      _selectedTag = _selectedTag == tag ? null : tag;
                                    }),
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ),
                      ),

                    const SliverToBoxAdapter(child: SizedBox(height: 12)),

                    // Empty state
                    if (filtered.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.note_add_outlined,
                                size: 64,
                                color: isDark ? Colors.white24 : Colors.black12,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                allNotes.isEmpty
                                    ? (isEn
                                        ? 'No notes yet.\nCapture your thoughts!'
                                        : 'Henüz not yok.\nDüşüncelerini kaydet!')
                                    : (isEn ? 'No matching notes' : 'Eşleşen not bulunamadı'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDark ? Colors.white38 : Colors.black38,
                                ),
                              ),
                              if (allNotes.isEmpty) ...[
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: () => context.push(Routes.noteCreate),
                                  icon: const Icon(Icons.add, size: 18),
                                  label: Text(isEn ? 'Create Note' : 'Not Oluştur'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.starGold,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                    // Pinned section
                    if (pinned.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                          child: Text(
                            isEn ? 'Pinned' : 'Sabitlenmiş',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white54 : Colors.black45,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _NoteCard(
                            note: pinned[index],
                            isEn: isEn,
                            isDark: isDark,
                            onTap: () => _openNote(pinned[index].id),
                            onDelete: () => _deleteNote(pinned[index].id),
                          ).animate().fadeIn(delay: (index * 50).ms, duration: 300.ms),
                          childCount: pinned.length,
                        ),
                      ),
                    ],

                    // Recent section
                    if (unpinned.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                          child: Text(
                            isEn ? 'Recent' : 'Son Notlar',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white54 : Colors.black45,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _NoteCard(
                            note: unpinned[index],
                            isEn: isEn,
                            isDark: isDark,
                            onTap: () => _openNote(unpinned[index].id),
                            onDelete: () => _deleteNote(unpinned[index].id),
                          ).animate().fadeIn(delay: (index * 50).ms, duration: 300.ms),
                          childCount: unpinned.length,
                        ),
                      ),
                    ],

                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticService.buttonPress();
          context.push(Routes.noteCreate);
        },
        backgroundColor: AppColors.starGold,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openNote(String noteId) {
    context.push(Routes.noteDetail, extra: {'noteId': noteId});
  }

  Future<void> _deleteNote(String noteId) async {
    final language = ref.read(languageProvider);
    final isEn = language == AppLanguage.en;

    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(isEn ? 'Delete Note?' : 'Not Silinsin mi?'),
        content: Text(
          isEn ? 'This action cannot be undone.' : 'Bu işlem geri alınamaz.',
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

    if (confirmed == true) {
      final service = await ref.read(notesToSelfServiceProvider.future);
      await service.deleteNote(noteId);
      ref.invalidate(allNotesProvider);
      ref.invalidate(pinnedNotesProvider);
      ref.invalidate(upcomingRemindersProvider);
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════
// NOTE CARD
// ═══════════════════════════════════════════════════════════════════════

class _NoteCard extends StatelessWidget {
  final NoteToSelf note;
  final bool isEn;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NoteCard({
    required this.note,
    required this.isEn,
    required this.isDark,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(note.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete();
        return false; // We handle deletion in onDelete
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: Colors.redAccent.withValues(alpha: 0.2),
        child: const Icon(Icons.delete, color: Colors.redAccent),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pin indicator
              if (note.isPinned)
                Padding(
                  padding: const EdgeInsets.only(right: 8, top: 2),
                  child: Icon(Icons.push_pin, size: 14, color: AppColors.starGold),
                ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      note.title.isEmpty ? (isEn ? 'Untitled' : 'Başlıksız') : note.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Preview
                    if (note.content.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        note.preview,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white54 : Colors.black45,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    const SizedBox(height: 8),

                    // Tags + date row
                    Row(
                      children: [
                        // Tags
                        if (note.tags.isNotEmpty)
                          ...note.tags.take(3).map((tag) => Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.cosmicPurple.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark ? Colors.white60 : Colors.black54,
                              ),
                            ),
                          )),
                        const Spacer(),
                        // Date
                        Text(
                          _formatDate(note.updatedAt, isEn),
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.white30 : Colors.black26,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt, bool isEn) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) {
      return isEn ? '${diff.inMinutes}m ago' : '${diff.inMinutes}dk önce';
    }
    if (diff.inHours < 24) {
      return isEn ? '${diff.inHours}h ago' : '${diff.inHours}sa önce';
    }
    if (diff.inDays < 7) {
      return isEn ? '${diff.inDays}d ago' : '${diff.inDays}g önce';
    }
    final months = isEn
        ? ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
        : ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'];
    return '${dt.day} ${months[dt.month - 1]}';
  }
}

// ═══════════════════════════════════════════════════════════════════════
// TAG CHIP
// ═══════════════════════════════════════════════════════════════════════

class _TagChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _TagChip({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.cosmicPurple.withValues(alpha: 0.3)
              : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.cosmicPurple.withValues(alpha: 0.5)
                : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? (isDark ? Colors.white : AppColors.cosmicPurple)
                : (isDark ? Colors.white60 : Colors.black45),
          ),
        ),
      ),
    );
  }
}
