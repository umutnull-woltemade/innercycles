// ════════════════════════════════════════════════════════════════════════════
// VAULT SCREEN - Private Content Hub (Journals, Notes, Photos)
// ════════════════════════════════════════════════════════════════════════════

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../core/constants/routes.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/models/note_to_self.dart';
import '../../../data/models/vault_photo.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/haptic_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/glass_dialog.dart';
import '../../../data/services/l10n_service.dart';

class VaultScreen extends ConsumerStatefulWidget {
  const VaultScreen({super.key});

  @override
  ConsumerState<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends ConsumerState<VaultScreen> {
  int _selectedTab = 0; // 0=all, 1=journals, 2=notes, 3=photos

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final privateJournals = ref.watch(privateJournalEntriesProvider);
    final privateNotes = ref.watch(privateNotesProvider);
    final vaultPhotos = ref.watch(vaultPhotosProvider);

    return Scaffold(
      body: CosmicBackground(
        child: CupertinoScrollbar(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              GlassSliverAppBar(
                title: L10nService.get('vault.vault.private_vault', language),
                useGradientTitle: true,
                gradientVariant: GradientTextVariant.amethyst,
                actions: [
                  Semantics(
                    button: true,
                    label: L10nService.get('vault.vault.vault_settings', language),
                    child: GestureDetector(
                      onTap: () => _showVaultSettings(isEn, isDark),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(
                          CupertinoIcons.gear,
                          size: 22,
                          color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tab bar
                      _buildTabBar(isEn, isDark),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Content based on tab
              _buildContent(
                isEn,
                isDark,
                privateJournals,
                privateNotes,
                vaultPhotos,
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
      floatingActionButton: _selectedTab == 3
          ? FloatingActionButton(
              onPressed: () => _addPhoto(isEn),
              backgroundColor: AppColors.amethyst,
              child: const Icon(CupertinoIcons.camera, color: Colors.white),
            ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8))
          : null,
    );
  }

  Widget _buildTabBar(AppLanguage language, bool isDark) {
    final tabs = isEn
        ? ['All', 'Journals', 'Notes', 'Photos']
        : ['Tümü', 'Günlük', 'Notlar', 'Fotoğraflar'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isActive = _selectedTab == i;
          return Padding(
            padding: EdgeInsets.only(right: i < tabs.length - 1 ? 8 : 0),
            child: Semantics(
              button: true,
              selected: isActive,
              label: tabs[i],
              child: GestureDetector(
                onTap: () {
                  HapticService.buttonPress();
                  setState(() => _selectedTab = i);
                },
                child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.amethyst.withValues(alpha: 0.2)
                      : (isDark ? Colors.white : Colors.black).withValues(
                          alpha: 0.05,
                        ),
                  borderRadius: BorderRadius.circular(20),
                  border: isActive
                      ? Border.all(
                          color: AppColors.amethyst.withValues(alpha: 0.5),
                        )
                      : null,
                ),
                child: Text(
                  tabs[i],
                  style:
                      AppTypography.subtitle(
                        fontSize: 13,
                        color: isActive
                            ? AppColors.amethyst
                            : (isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted),
                      ).copyWith(
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                ),
              ),
            ),
            ),
          );
        }),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildContent(
    AppLanguage language,
    bool isDark,
    AsyncValue<List<JournalEntry>> journalsAsync,
    AsyncValue<List<NoteToSelf>> notesAsync,
    AsyncValue<List<VaultPhoto>> photosAsync,
  ) {
    final journals = journalsAsync.valueOrNull ?? [];
    final notes = notesAsync.valueOrNull ?? [];
    final photos = photosAsync.valueOrNull ?? [];

    // Check if everything is empty
    if (_selectedTab == 0 &&
        journals.isEmpty &&
        notes.isEmpty &&
        photos.isEmpty) {
      return SliverToBoxAdapter(child: _buildEmptyState(isEn, isDark));
    }
    if (_selectedTab == 1 && journals.isEmpty) {
      return SliverToBoxAdapter(child: _buildEmptyState(isEn, isDark));
    }
    if (_selectedTab == 2 && notes.isEmpty) {
      return SliverToBoxAdapter(child: _buildEmptyState(isEn, isDark));
    }
    if (_selectedTab == 3 && photos.isEmpty) {
      return SliverToBoxAdapter(child: _buildEmptyState(isEn, isDark));
    }

    final List<Widget> items = [];

    // Journals
    if (_selectedTab == 0 || _selectedTab == 1) {
      if (journals.isNotEmpty) {
        items.add(
          _buildSectionHeader(
            L10nService.get('vault.vault.private_journals', language),
            '${journals.length}',
            isDark,
          ),
        );
        for (final entry in journals) {
          items.add(_buildJournalCard(entry, isEn, isDark));
        }
      }
    }

    // Notes
    if (_selectedTab == 0 || _selectedTab == 2) {
      if (notes.isNotEmpty) {
        items.add(
          _buildSectionHeader(
            L10nService.get('vault.vault.private_notes', language),
            '${notes.length}',
            isDark,
          ),
        );
        for (final note in notes) {
          items.add(_buildNoteCard(note, isEn, isDark));
        }
      }
    }

    // Photos
    if (_selectedTab == 0 || _selectedTab == 3) {
      if (photos.isNotEmpty) {
        items.add(
          _buildSectionHeader(
            L10nService.get('vault.vault.private_photos', language),
            '${photos.length}',
            isDark,
          ),
        );
        items.add(_buildPhotoGrid(photos, isDark));
      }
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => items[index]
              .animate()
              .fadeIn(delay: Duration(milliseconds: 50 * index))
              .slideY(begin: 0.03),
          childCount: items.length,
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLanguage language, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Column(
        children: [
          Icon(
            CupertinoIcons.lock_shield,
            size: 64,
            color: AppColors.amethyst.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 20),
          Text(
            L10nService.get('vault.vault.your_vault_is_empty', language),
            style: AppTypography.displayFont.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            L10nService.get('vault.vault.mark_journals_or_notes_as_private_or_add', language),
            textAlign: TextAlign.center,
            style: AppTypography.subtitle(
              fontSize: 14,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildSectionHeader(String title, String count, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Row(
        children: [
          GradientText(
            title,
            variant: GradientTextVariant.amethyst,
            style: AppTypography.elegantAccent(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.amethyst.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count,
              style: AppTypography.subtitle(
                fontSize: 11,
                color: AppColors.amethyst,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalCard(JournalEntry entry, AppLanguage language, bool isDark) {
    final dayName = _dayName(entry.date, isEn);
    final dateStr = '${entry.date.day}.${entry.date.month}.${entry.date.year}';
    final areaName = entry.focusArea.localizedName(isEn);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
          context.push(Routes.journalEntryDetail.replaceFirst(':id', entry.id));
        },
        child: GlassPanel(
          elevation: GlassElevation.g2,
          borderRadius: BorderRadius.circular(14),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Focus area accent
              Container(
                width: 3,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.amethyst,
                      AppColors.amethyst.withValues(alpha: 0.3),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$dayName, $dateStr',
                      style: AppTypography.subtitle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$areaName  ${entry.overallRating}/5',
                      style: AppTypography.subtitle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                    if (entry.note != null && entry.note!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        entry.note!.length > 60
                            ? '${entry.note!.substring(0, 60)}...'
                            : entry.note!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.subtitle(
                          fontSize: 12,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                CupertinoIcons.chevron_right,
                size: 16,
                color: isDark ? Colors.white24 : Colors.black26,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteCard(NoteToSelf note, AppLanguage language, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
          context.push(Routes.noteDetail, extra: {'noteId': note.id});
        },
        child: GlassPanel(
          elevation: GlassElevation.g2,
          borderRadius: BorderRadius.circular(14),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.starGold,
                      AppColors.starGold.withValues(alpha: 0.3),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title.isNotEmpty
                          ? note.title
                          : (L10nService.get('vault.vault.untitled', language)),
                      style: AppTypography.subtitle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ).copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (note.content.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        note.preview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.subtitle(
                          fontSize: 12,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (note.isPinned)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.push_pin,
                    size: 14,
                    color: AppColors.starGold,
                  ),
                ),
              Icon(
                CupertinoIcons.chevron_right,
                size: 16,
                color: isDark ? Colors.white24 : Colors.black26,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoGrid(List<VaultPhoto> photos, bool isDark) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return GestureDetector(
          onTap: () => _showPhotoViewer(photo, isDark),
          onLongPress: () => _showPhotoOptions(photo),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              File(photo.filePath),
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: isDark
                    ? Colors.white10
                    : Colors.black.withValues(alpha: 0.05),
                child: Icon(
                  CupertinoIcons.photo,
                  color: isDark ? Colors.white24 : Colors.black26,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPhotoViewer(VaultPhoto photo, bool isDark) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => _FullScreenPhoto(photo: photo)));
  }

  Future<void> _showPhotoOptions(VaultPhoto photo) async {
    final language = ref.read(languageProvider);
    final isEn = language == AppLanguage.en;

    final confirmed = await GlassDialog.confirm(
      context,
      title: L10nService.get('vault.vault.delete_photo', language),
      message: L10nService.get('vault.vault.this_photo_will_be_permanently_deleted_f', language),
      cancelLabel: L10nService.get('vault.vault.cancel', language),
      confirmLabel: L10nService.get('vault.vault.delete', language),
      isDestructive: true,
    );

    if (confirmed == true) {
      final vaultService = await ref.read(vaultServiceProvider.future);
      await vaultService.deletePhoto(photo.id);
      ref.invalidate(vaultPhotosProvider);
      ref.invalidate(vaultPhotoCountProvider);
    }
  }

  Future<void> _addPhoto(AppLanguage language) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (picked == null) return;

    final vaultService = await ref.read(vaultServiceProvider.future);
    await vaultService.addPhoto(sourcePath: picked.path);
    if (!mounted) return;
    ref.invalidate(vaultPhotosProvider);
    ref.invalidate(vaultPhotoCountProvider);
  }

  void _showVaultSettings(AppLanguage language, bool isDark) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(L10nService.get('vault.vault.vault_settings_1', language)),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(ctx);
              context.push(Routes.vaultPin, extra: {'mode': 'change'});
            },
            child: Text(L10nService.get('vault.vault.change_pin', language)),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(ctx);
              final vaultService = await ref.read(vaultServiceProvider.future);
              final canBio = await vaultService.canUseBiometrics();
              if (!canBio) return;
              final current = vaultService.isBiometricEnabled;
              await vaultService.setBiometricEnabled(!current);
              ref.invalidate(vaultServiceProvider);
              if (mounted) {
                HapticService.buttonPress();
              }
            },
            child: FutureBuilder(
              future: ref.read(vaultServiceProvider.future),
              builder: (_, snap) {
                final enabled = snap.data?.isBiometricEnabled ?? false;
                return Text(
                  enabled
                      ? (L10nService.get('vault.vault.disable_face_id', language))
                      : (L10nService.get('vault.vault.enable_face_id', language)),
                );
              },
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(ctx),
          child: Text(L10nService.get('vault.vault.cancel_1', language)),
        ),
      ),
    );
  }

  String _dayName(DateTime date, AppLanguage language) {
    const en = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const tr = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    return (isEn ? en : tr)[date.weekday - 1];
  }
}

// ═══════════════════════════════════════════════════════════════════════
// FULL SCREEN PHOTO VIEWER
// ═══════════════════════════════════════════════════════════════════════

class _FullScreenPhoto extends StatelessWidget {
  final VaultPhoto photo;

  const _FullScreenPhoto({required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: InteractiveViewer(
            child: Image.file(
              File(photo.filePath),
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Icon(
                CupertinoIcons.photo,
                color: Colors.white38,
                size: 64,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
