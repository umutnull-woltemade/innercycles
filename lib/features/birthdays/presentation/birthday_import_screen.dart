// ════════════════════════════════════════════════════════════════════════════
// BIRTHDAY IMPORT SCREEN - Facebook Data Import Flow
// ════════════════════════════════════════════════════════════════════════════

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/birthday_contact.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/facebook_birthday_import_service.dart';
import '../../../data/services/notification_service.dart';
import '../../../shared/widgets/birthday_avatar.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class BirthdayImportScreen extends ConsumerStatefulWidget {
  const BirthdayImportScreen({super.key});

  @override
  ConsumerState<BirthdayImportScreen> createState() =>
      _BirthdayImportScreenState();
}

class _BirthdayImportScreenState extends ConsumerState<BirthdayImportScreen> {
  _ImportStep _step = _ImportStep.instructions;
  List<BirthdayContact> _parsedContacts = [];
  final Set<int> _selectedIndices = {};
  bool _isLoading = false;
  int _importedCount = 0;

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
              title: isEn ? 'Import Birthdays' : 'Do\u{011F}um G\u{00FC}nlerini Aktar',
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  switch (_step) {
                    _ImportStep.instructions =>
                      _buildInstructions(isDark, isEn),
                    _ImportStep.preview =>
                      _buildPreview(isDark, isEn),
                    _ImportStep.success =>
                      _buildSuccess(isDark, isEn),
                  },
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
  // STEP 1: Instructions
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildInstructions(bool isDark, bool isEn) {
    final steps = isEn
        ? [
            'Go to Facebook Settings & Privacy > Settings',
            'Click "Download Your Information"',
            'Select "Friends and Followers" only',
            'Choose JSON format',
            'Download and extract the file',
            'Select the friends.json file below',
          ]
        : [
            'Facebook Ayarlar ve Gizlilik > Ayarlar\'a gidin',
            '"Bilgilerinizi \u{0130}ndirin" \u{00FC}zerine t\u{0131}klay\u{0131}n',
            'Sadece "Arkada\u{015F}lar ve Takip\u{00E7}iler" se\u{00E7}in',
            'JSON format\u{0131}n\u{0131} se\u{00E7}in',
            'Dosyay\u{0131} indirip \u{00E7}\u{0131}kar\u{0131}n',
            'A\u{015F}a\u{011F}\u{0131}dan friends.json dosyas\u{0131}n\u{0131} se\u{00E7}in',
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PremiumCard(
          style: PremiumCardStyle.aurora,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientText(
                isEn ? 'How to Export from Facebook' : 'Facebook\'tan Nas\u{0131}l D\u{0131}\u{015F}a Aktar\u{0131}l\u{0131}r',
                variant: GradientTextVariant.gold,
                style: AppTypography.displayFont.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              ...steps.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.starGold.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: AppTypography.elegantAccent(
                              fontSize: 12,
                              letterSpacing: 0,
                              color: AppColors.starGold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ).animate().fadeIn(duration: 300.ms),
        const SizedBox(height: 24),
        // Select file button
        GestureDetector(
          onTap: _isLoading ? null : _pickAndParseFile,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.starGold, AppColors.celestialGold],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.starGold.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.deepSpace,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.file_upload_outlined,
                          color: AppColors.deepSpace,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isEn ? 'Select JSON File' : 'JSON Dosyas\u{0131} Se\u{00E7}',
                          style: AppTypography.modernAccent(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepSpace,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
      ],
    );
  }

  Future<void> _pickAndParseFile() async {
    setState(() => _isLoading = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result == null || result.files.single.path == null) {
        setState(() => _isLoading = false);
        return;
      }

      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      final contacts = FacebookBirthdayImportService.parseJsonExport(content);

      if (contacts.isEmpty && mounted) {
        final lang = ref.read(languageProvider);
        final isEn = lang == AppLanguage.en;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEn
                  ? 'No birthday data found in this file'
                  : 'Bu dosyada do\u{011F}um g\u{00FC}n\u{00FC} verisi bulunamad\u{0131}',
            ),
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      setState(() {
        _parsedContacts = contacts;
        _selectedIndices.addAll(List.generate(contacts.length, (i) => i));
        _step = _ImportStep.preview;
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) {
        final lang = ref.read(languageProvider);
        final isEn = lang == AppLanguage.en;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEn
                  ? 'Could not read this file. Please check the format.'
                  : 'Dosya okunamad\u{0131}. L\u{00FC}tfen format\u{0131} kontrol edin.',
            ),
          ),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  // ═════════════════════════════════════════════════════════════════════════
  // STEP 2: Preview
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildPreview(bool isDark, bool isEn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GradientText(
              isEn
                  ? '${_parsedContacts.length} Birthdays Found'
                  : '${_parsedContacts.length} Do\u{011F}um G\u{00FC}n\u{00FC} Bulundu',
              variant: GradientTextVariant.gold,
              style: AppTypography.displayFont.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (_selectedIndices.length == _parsedContacts.length) {
                    _selectedIndices.clear();
                  } else {
                    _selectedIndices.addAll(
                      List.generate(_parsedContacts.length, (i) => i),
                    );
                  }
                });
              },
              child: Text(
                _selectedIndices.length == _parsedContacts.length
                    ? (isEn ? 'Deselect All' : 'T\u{00FC}m\u{00FC}n\u{00FC} Kald\u{0131}r')
                    : (isEn ? 'Select All' : 'T\u{00FC}m\u{00FC}n\u{00FC} Se\u{00E7}'),
                style: AppTypography.modernAccent(
                  color: AppColors.starGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(_parsedContacts.length, (index) {
          final contact = _parsedContacts[index];
          final isSelected = _selectedIndices.contains(index);

          final monthNames = isEn
              ? ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
              : ['Oca', '\u{015E}ub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'A\u{011F}u', 'Eyl', 'Eki', 'Kas', 'Ara'];

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedIndices.remove(index);
                  } else {
                    _selectedIndices.add(index);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.starGold.withValues(alpha: 0.08)
                      : (isDark
                            ? AppColors.surfaceDark.withValues(alpha: 0.6)
                            : AppColors.lightCard),
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(
                          color: AppColors.starGold.withValues(alpha: 0.3),
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: isSelected,
                      onChanged: (v) {
                        setState(() {
                          if (v == true) {
                            _selectedIndices.add(index);
                          } else {
                            _selectedIndices.remove(index);
                          }
                        });
                      },
                      activeColor: AppColors.starGold,
                    ),
                    BirthdayAvatar(
                      name: contact.name,
                      size: 36,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact.name,
                            style: AppTypography.modernAccent(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          Text(
                            '${monthNames[contact.birthdayMonth - 1]} ${contact.birthdayDay}'
                            '${contact.birthYear != null ? ', ${contact.birthYear}' : ''}',
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
            ),
          );
        }),
        const SizedBox(height: 20),
        // Import button
        GestureDetector(
          onTap: _selectedIndices.isEmpty || _isLoading
              ? null
              : _importSelected,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: _selectedIndices.isNotEmpty
                  ? const LinearGradient(
                      colors: [AppColors.starGold, AppColors.celestialGold],
                    )
                  : null,
              color: _selectedIndices.isEmpty
                  ? (isDark ? Colors.white12 : Colors.black12)
                  : null,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.deepSpace,
                      ),
                    )
                  : Text(
                      isEn
                          ? 'Import ${_selectedIndices.length} Contacts'
                          : '${_selectedIndices.length} Ki\u{015F}iyi Aktar',
                      style: AppTypography.modernAccent(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _selectedIndices.isNotEmpty
                            ? AppColors.deepSpace
                            : (isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _importSelected() async {
    setState(() => _isLoading = true);
    try {
      final service =
          await ref.read(birthdayContactServiceProvider.future);
      final selected = _selectedIndices
          .map((i) => _parsedContacts[i])
          .toList();
      final imported = await service.importContacts(selected);

      // Schedule notifications using the actual imported contacts (correct UUIDs)
      final notifService = NotificationService();
      for (final contact in imported) {
        if (contact.notificationsEnabled) {
          await notifService.scheduleBirthdayNotification(contact);
        }
      }

      ref.invalidate(birthdayContactServiceProvider);

      setState(() {
        _importedCount = imported.length;
        _step = _ImportStep.success;
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) {
        final lang = ref.read(languageProvider);
        final isEn = lang == AppLanguage.en;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEn
                  ? 'Import failed. Please try again.'
                  : 'Aktarma ba\u{015F}ar\u{0131}s\u{0131}z. L\u{00FC}tfen tekrar deneyin.',
            ),
          ),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  // ═════════════════════════════════════════════════════════════════════════
  // STEP 3: Success
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildSuccess(bool isDark, bool isEn) {
    return PremiumCard(
      style: PremiumCardStyle.gold,
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Text('\u{1F389}', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          GradientText(
            isEn ? 'Import Complete!' : 'Aktarma Tamamland\u{0131}!',
            variant: GradientTextVariant.gold,
            style: AppTypography.displayFont.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            isEn
                ? '$_importedCount birthdays imported successfully'
                : '$_importedCount do\u{011F}um g\u{00FC}n\u{00FC} ba\u{015F}ar\u{0131}yla aktar\u{0131}ld\u{0131}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.starGold, AppColors.celestialGold],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isEn ? 'View Birthdays' : 'Do\u{011F}um G\u{00FC}nlerini G\u{00F6}r',
                style: AppTypography.modernAccent(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.deepSpace,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).scale(
      begin: const Offset(0.95, 0.95),
      end: const Offset(1, 1),
      duration: 400.ms,
    );
  }
}

enum _ImportStep { instructions, preview, success }
