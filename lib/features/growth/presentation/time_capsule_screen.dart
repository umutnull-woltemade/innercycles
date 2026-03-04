// ════════════════════════════════════════════════════════════════════════════
// TIME CAPSULE SCREEN - Write, view pending, and read opened capsules
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/time_capsule_entry.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class TimeCapsuleScreen extends ConsumerStatefulWidget {
  const TimeCapsuleScreen({super.key});

  @override
  ConsumerState<TimeCapsuleScreen> createState() => _TimeCapsuleScreenState();
}

class _TimeCapsuleScreenState extends ConsumerState<TimeCapsuleScreen> {
  int _tab = 0; // 0=write, 1=pending, 2=opened
  final _contentController = TextEditingController();
  int _deliveryDays = 30;
  bool _isSaving = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(timeCapsuleServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (_, _) => Center(child: Text('Something went wrong', style: TextStyle(color: Color(0xFF9E8E82)))),
            data: (service) {
              final all = service.getAllCapsules();
              final pending = all.where((c) => !c.isReadyToDeliver && !c.isOpened).toList();
              final ready = all.where((c) => c.isReadyToDeliver).toList();
              final opened = all.where((c) => c.isOpened).toList();

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  GlassSliverAppBar(
                    title: isEn ? 'Time Capsule' : 'Zaman Kapsülü',
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          // Tab selector
                          Row(
                            children: [
                              _TabChip(
                                label: isEn ? 'Write' : 'Yaz',
                                selected: _tab == 0,
                                isDark: isDark,
                                onTap: () => setState(() => _tab = 0),
                              ),
                              const SizedBox(width: 8),
                              _TabChip(
                                label: isEn
                                    ? 'Pending (${pending.length + ready.length})'
                                    : 'Bekleyen (${pending.length + ready.length})',
                                selected: _tab == 1,
                                isDark: isDark,
                                onTap: () => setState(() => _tab = 1),
                              ),
                              const SizedBox(width: 8),
                              _TabChip(
                                label: isEn
                                    ? 'Opened (${opened.length})'
                                    : 'Açılan (${opened.length})',
                                selected: _tab == 2,
                                isDark: isDark,
                                onTap: () => setState(() => _tab = 2),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          if (_tab == 0) _buildWriteTab(isEn, isDark, service),
                          if (_tab == 1) _buildPendingTab(isEn, isDark, pending, ready, service),
                          if (_tab == 2) _buildOpenedTab(isEn, isDark, opened),

                          const SizedBox(height: 40),
                        ],
                      ),
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

  Widget _buildWriteTab(bool isEn, bool isDark, dynamic service) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          isEn ? 'Write to Your Future Self' : 'Gelecekteki Kendine Yaz',
          variant: GradientTextVariant.gold,
          style: AppTypography.modernAccent(fontSize: 16),
        ),
        const SizedBox(height: 12),
        Text(
          isEn
              ? 'Seal a message that will be delivered to you in the future. What do you want to remember?'
              : 'Gelecekte sana teslim edilecek bir mesaj mühürle. Ne hatırlamak istiyorsun?',
          style: AppTypography.decorativeScript(
            fontSize: 14,
            color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.black.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: _contentController,
            maxLines: 8,
            style: AppTypography.subtitle(
              fontSize: 15,
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            ),
            decoration: InputDecoration(
              hintText: isEn ? 'Dear future me...' : 'Sevgili gelecekteki ben...',
              hintStyle: AppTypography.subtitle(
                fontSize: 15,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Delivery date picker
        GradientText(
          isEn ? 'Deliver in' : 'Teslim süresi',
          variant: GradientTextVariant.amethyst,
          style: AppTypography.modernAccent(fontSize: 14),
        ),
        const SizedBox(height: 8),
        Row(
          children: [7, 30, 90, 180, 365].map((d) {
            final selected = d == _deliveryDays;
            final label = d < 30
                ? '${d}d'
                : d < 365
                    ? '${d ~/ 30}mo'
                    : '1yr';
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _deliveryDays = d),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.amethyst.withValues(alpha: 0.2)
                        : (isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.04)),
                    borderRadius: BorderRadius.circular(16),
                    border: selected
                        ? Border.all(color: AppColors.amethyst.withValues(alpha: 0.5))
                        : null,
                  ),
                  child: Text(
                    label,
                    style: AppTypography.modernAccent(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? AppColors.amethyst
                          : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        // Seal button
        GestureDetector(
          onTap: _isSaving
              ? null
              : () async {
                  final text = _contentController.text.trim();
                  if (text.isEmpty) return;
                  setState(() => _isSaving = true);
                  final delivery = DateTime.now().add(Duration(days: _deliveryDays));
                  await service.createCapsule(content: text, deliveryDate: delivery);
                  _contentController.clear();
                  ref.invalidate(timeCapsuleServiceProvider);
                  if (mounted) {
                    setState(() {
                      _isSaving = false;
                      _tab = 1;
                    });
                  }
                },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.amethyst, AppColors.starGold],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                isEn ? 'Seal & Send \u2728' : 'Mühürle & Gönder \u2728',
                style: AppTypography.modernAccent(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepSpace,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPendingTab(bool isEn, bool isDark, List<TimeCapsuleEntry> pending,
      List<TimeCapsuleEntry> ready, dynamic service) {
    if (pending.isEmpty && ready.isEmpty) {
      return _EmptyState(
        emoji: '\u{1F4E8}',
        text: isEn
            ? 'No capsules waiting. Write one to your future self!'
            : 'Bekleyen kapsül yok. Gelecekteki kendine bir tane yaz!',
        isDark: isDark,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (ready.isNotEmpty) ...[
          GradientText(
            isEn ? 'Ready to Open!' : 'Açılmaya Hazır!',
            variant: GradientTextVariant.gold,
            style: AppTypography.modernAccent(fontSize: 16),
          ),
          const SizedBox(height: 10),
          ...ready.map((c) => _CapsuleTile(
                capsule: c,
                isEn: isEn,
                isDark: isDark,
                isReady: true,
                onOpen: () async {
                  await service.openCapsule(c.id);
                  ref.invalidate(timeCapsuleServiceProvider);
                },
              )),
          const SizedBox(height: 20),
        ],
        if (pending.isNotEmpty) ...[
          GradientText(
            isEn ? 'Sealed' : 'Mühürlü',
            variant: GradientTextVariant.amethyst,
            style: AppTypography.modernAccent(fontSize: 16),
          ),
          const SizedBox(height: 10),
          ...pending.map((c) => _CapsuleTile(
                capsule: c,
                isEn: isEn,
                isDark: isDark,
                isReady: false,
              )),
        ],
      ],
    );
  }

  Widget _buildOpenedTab(bool isEn, bool isDark, List<TimeCapsuleEntry> opened) {
    if (opened.isEmpty) {
      return _EmptyState(
        emoji: '\u{1F4DC}',
        text: isEn
            ? 'No opened capsules yet. They\'ll appear here once delivered.'
            : 'Henüz açılmış kapsül yok. Teslim edildiğinde burada görünecek.',
        isDark: isDark,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          isEn ? 'Archive' : 'Arşiv',
          variant: GradientTextVariant.gold,
          style: AppTypography.modernAccent(fontSize: 16),
        ),
        const SizedBox(height: 10),
        ...opened.reversed.map((c) => _OpenedCapsuleTile(
              capsule: c,
              isEn: isEn,
              isDark: isDark,
            )),
      ],
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.starGold.withValues(alpha: 0.2)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.04)),
          borderRadius: BorderRadius.circular(16),
          border: selected
              ? Border.all(color: AppColors.starGold.withValues(alpha: 0.5))
              : null,
        ),
        child: Text(
          label,
          style: AppTypography.modernAccent(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected
                ? AppColors.starGold
                : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }
}

class _CapsuleTile extends StatelessWidget {
  final TimeCapsuleEntry capsule;
  final bool isEn;
  final bool isDark;
  final bool isReady;
  final VoidCallback? onOpen;

  const _CapsuleTile({
    required this.capsule,
    required this.isEn,
    required this.isDark,
    required this.isReady,
    this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final daysLeft = capsule.deliveryDate.difference(DateTime.now()).inDays.clamp(0, 9999);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PremiumCard(
        style: isReady ? PremiumCardStyle.gold : PremiumCardStyle.subtle,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Text(
                isReady ? '\u{1F4E9}' : '\u{1F512}',
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isReady
                          ? (isEn ? 'Ready to open!' : 'Açılmaya hazır!')
                          : (isEn ? 'Opens in $daysLeft days' : '$daysLeft gün sonra açılır'),
                      style: AppTypography.modernAccent(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isReady
                            ? AppColors.starGold
                            : (isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isEn
                          ? 'Written ${_formatDate(capsule.createdAt)}'
                          : '${_formatDate(capsule.createdAt)} tarihinde yazıldı',
                      style: AppTypography.elegantAccent(
                        fontSize: 11,
                        color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (isReady)
                GestureDetector(
                  onTap: onOpen,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.starGold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isEn ? 'Open' : 'Aç',
                      style: AppTypography.modernAccent(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.starGold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day}/${d.month}/${d.year}';
}

class _OpenedCapsuleTile extends StatelessWidget {
  final TimeCapsuleEntry capsule;
  final bool isEn;
  final bool isDark;

  const _OpenedCapsuleTile({
    required this.capsule,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PremiumCard(
        style: PremiumCardStyle.amethyst,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('\u{1F4DC}', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    isEn
                        ? 'Written ${_formatDate(capsule.createdAt)}'
                        : '${_formatDate(capsule.createdAt)} tarihinde yazıldı',
                    style: AppTypography.elegantAccent(
                      fontSize: 11,
                      color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    isEn
                        ? 'Delivered ${_formatDate(capsule.deliveryDate)}'
                        : '${_formatDate(capsule.deliveryDate)} teslim edildi',
                    style: AppTypography.elegantAccent(
                      fontSize: 11,
                      color: AppColors.amethyst,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                capsule.content,
                style: AppTypography.decorativeScript(
                  fontSize: 14,
                  color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                ).copyWith(fontStyle: FontStyle.italic, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day}/${d.month}/${d.year}';
}

class _EmptyState extends StatelessWidget {
  final String emoji;
  final String text;
  final bool isDark;

  const _EmptyState({
    required this.emoji,
    required this.text,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 44)),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppTypography.decorativeScript(
                fontSize: 14,
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
