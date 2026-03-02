// ════════════════════════════════════════════════════════════════════════════
// GROWTH LETTERS SCREEN - Write and archive reflective letters
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/growth_letter.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';

class GrowthLettersScreen extends ConsumerStatefulWidget {
  const GrowthLettersScreen({super.key});

  @override
  ConsumerState<GrowthLettersScreen> createState() =>
      _GrowthLettersScreenState();
}

class _GrowthLettersScreenState extends ConsumerState<GrowthLettersScreen> {
  bool _composing = false;
  LetterType _selectedType = LetterType.toFutureSelf;
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_bodyController.text.trim().isEmpty) return;
    final service = await ref.read(growthLetterServiceProvider.future);
    await service.save(GrowthLetter(
      letterType: _selectedType,
      title: _titleController.text.trim().isEmpty
          ? (_selectedType.nameEn())
          : _titleController.text.trim(),
      body: _bodyController.text.trim(),
    ));
    _titleController.clear();
    _bodyController.clear();
    ref.invalidate(growthLetterServiceProvider);
    if (mounted) setState(() => _composing = false);
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(growthLetterServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              GlassSliverAppBar(
                title: isEn ? 'Growth Letters' : 'B\u00fcy\u00fcme Mektuplar\u0131',
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      if (!_composing) ...[
                        // Write new CTA
                        GestureDetector(
                          onTap: () => setState(() => _composing = true),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                AppColors.starGold,
                                AppColors.celestialGold,
                              ]),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.starGold
                                      .withValues(alpha: 0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                isEn ? 'Write a Letter' : 'Mektup Yaz',
                                style: AppTypography.modernAccent(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.deepSpace,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],

                      if (_composing) ...[
                        // Type selector
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: LetterType.values.map((t) {
                            final selected = t == _selectedType;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedType = t),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? AppColors.starGold
                                          .withValues(alpha: 0.2)
                                      : (isDark
                                          ? Colors.white
                                              .withValues(alpha: 0.05)
                                          : Colors.black
                                              .withValues(alpha: 0.04)),
                                  borderRadius: BorderRadius.circular(16),
                                  border: selected
                                      ? Border.all(
                                          color: AppColors.starGold
                                              .withValues(alpha: 0.5))
                                      : null,
                                ),
                                child: Text(
                                  '${t.emoji} ${isEn ? t.nameEn() : t.nameTr()}',
                                  style: AppTypography.elegantAccent(
                                    fontSize: 12,
                                    color: selected
                                        ? AppColors.starGold
                                        : (isDark
                                            ? AppColors.textSecondary
                                            : AppColors.lightTextSecondary),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 12),

                        // Title
                        TextField(
                          controller: _titleController,
                          style: AppTypography.modernAccent(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: isEn ? 'Title (optional)' : 'Ba\u015fl\u0131k (iste\u011fe ba\u011fl\u0131)',
                            hintStyle: AppTypography.modernAccent(
                              fontSize: 16,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                            border: InputBorder.none,
                          ),
                        ),

                        // Body
                        Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.04)
                                : Colors.black.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextField(
                            controller: _bodyController,
                            maxLines: 10,
                            minLines: 6,
                            style: AppTypography.decorativeScript(
                              fontSize: 15,
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ).copyWith(height: 1.7),
                            decoration: InputDecoration(
                              hintText: isEn
                                  ? 'Dear future me...'
                                  : 'Sevgili gelecek ben...',
                              hintStyle: AppTypography.decorativeScript(
                                fontSize: 15,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Save / Cancel
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => _composing = false),
                              child: Text(
                                isEn ? 'Cancel' : '\u0130ptal',
                                style: AppTypography.elegantAccent(
                                  fontSize: 14,
                                  color: isDark
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: _save,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    AppColors.starGold,
                                    AppColors.celestialGold,
                                  ]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  isEn ? 'Save Letter' : 'Mektubu Kaydet',
                                  style: AppTypography.modernAccent(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.deepSpace,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 24),

                      // Archive
                      serviceAsync.when(
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                        data: (service) {
                          final letters = service.getAll();
                          if (letters.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Center(
                                child: Column(
                                  children: [
                                    const Text('\u{1F4E8}',
                                        style: TextStyle(fontSize: 44)),
                                    const SizedBox(height: 12),
                                    Text(
                                      isEn
                                          ? 'Your letters will appear here'
                                          : 'Mektuplar\u0131n burada g\u00f6r\u00fcnecek',
                                      style: AppTypography.decorativeScript(
                                        fontSize: 14,
                                        color: isDark
                                            ? AppColors.textSecondary
                                            : AppColors.lightTextSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GradientText(
                                isEn ? 'Your Letters' : 'Mektuplar\u0131n',
                                variant: GradientTextVariant.amethyst,
                                style:
                                    AppTypography.modernAccent(fontSize: 15),
                              ),
                              const SizedBox(height: 10),
                              ...letters.map((l) => _LetterTile(
                                    letter: l,
                                    isEn: isEn,
                                    isDark: isDark,
                                  )),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LetterTile extends StatefulWidget {
  final GrowthLetter letter;
  final bool isEn;
  final bool isDark;

  const _LetterTile({
    required this.letter,
    required this.isEn,
    required this.isDark,
  });

  @override
  State<_LetterTile> createState() => _LetterTileState();
}

class _LetterTileState extends State<_LetterTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l = widget.letter;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => setState(() => _expanded = !_expanded),
        child: AnimatedContainer(
          duration: 200.ms,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: widget.isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.black.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(l.letterType.emoji,
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l.title,
                      style: AppTypography.modernAccent(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: widget.isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '${l.createdAt.day}/${l.createdAt.month}',
                    style: AppTypography.elegantAccent(
                      fontSize: 11,
                      color: widget.isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    _expanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    size: 18,
                    color: widget.isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 10),
                Text(
                  l.body,
                  style: AppTypography.decorativeScript(
                    fontSize: 14,
                    color: widget.isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${l.wordCount} ${widget.isEn ? 'words' : 'kelime'}',
                  style: AppTypography.elegantAccent(
                    fontSize: 11,
                    color: widget.isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
