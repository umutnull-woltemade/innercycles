// ════════════════════════════════════════════════════════════════════════════
// INNER DIALOGUE SCREEN - Heart vs Mind dual-perspective journaling
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/inner_dialogue.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';

class InnerDialogueScreen extends ConsumerStatefulWidget {
  final String? editId;
  const InnerDialogueScreen({super.key, this.editId});

  @override
  ConsumerState<InnerDialogueScreen> createState() =>
      _InnerDialogueScreenState();
}

class _InnerDialogueScreenState extends ConsumerState<InnerDialogueScreen> {
  DialoguePerspective _perspective = DialoguePerspective.heartMind;
  final _leftController = TextEditingController();
  final _rightController = TextEditingController();
  final _topicController = TextEditingController();
  bool _saved = false;
  InnerDialogue? _existing;

  @override
  void initState() {
    super.initState();
    if (widget.editId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadExisting());
    }
  }

  Future<void> _loadExisting() async {
    final service = await ref.read(innerDialogueServiceProvider.future);
    final d = service.getById(widget.editId!);
    if (d != null && mounted) {
      setState(() {
        _existing = d;
        _perspective = d.perspective;
        _leftController.text = d.leftText;
        _rightController.text = d.rightText;
        _topicController.text = d.topic ?? '';
      });
    }
  }

  @override
  void dispose() {
    _leftController.dispose();
    _rightController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_leftController.text.trim().isEmpty &&
        _rightController.text.trim().isEmpty) return;

    final service = await ref.read(innerDialogueServiceProvider.future);
    final dialogue = (_existing ?? InnerDialogue(perspective: _perspective))
        .copyWith(
      leftText: _leftController.text.trim(),
      rightText: _rightController.text.trim(),
      topic: _topicController.text.trim().isEmpty
          ? null
          : _topicController.text.trim(),
    );
    await service.save(dialogue);
    if (mounted) {
      setState(() => _saved = true);
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              GlassSliverAppBar(
                title: isEn ? 'Inner Dialogue' : '\u0130\u00e7 Diyalog',
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // Perspective picker
                      GradientText(
                        isEn ? 'Choose a perspective' : 'Bir bak\u0131\u015f a\u00e7\u0131s\u0131 se\u00e7',
                        variant: GradientTextVariant.gold,
                        style: AppTypography.modernAccent(fontSize: 15),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: DialoguePerspective.values.map((p) {
                          final selected = p == _perspective;
                          final label = isEn
                              ? '${p.labelLeftEn()} vs ${p.labelRightEn()}'
                              : '${p.labelLeftTr()} vs ${p.labelRightTr()}';
                          return GestureDetector(
                            onTap: () => setState(() => _perspective = p),
                            child: AnimatedContainer(
                              duration: 200.ms,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.starGold
                                        .withValues(alpha: 0.2)
                                    : (isDark
                                        ? Colors.white
                                            .withValues(alpha: 0.05)
                                        : Colors.black
                                            .withValues(alpha: 0.04)),
                                borderRadius: BorderRadius.circular(20),
                                border: selected
                                    ? Border.all(
                                        color: AppColors.starGold
                                            .withValues(alpha: 0.5))
                                    : null,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(p.emoji,
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(width: 6),
                                  Text(
                                    label,
                                    style: AppTypography.elegantAccent(
                                      fontSize: 13,
                                      color: selected
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

                      const SizedBox(height: 16),

                      // Optional topic
                      TextField(
                        controller: _topicController,
                        style: AppTypography.elegantAccent(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: isEn
                              ? 'Topic (optional)'
                              : 'Konu (iste\u011fe ba\u011fl\u0131)',
                          hintStyle: AppTypography.elegantAccent(
                            fontSize: 14,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Dual text areas
                      _DialogueColumn(
                        label: isEn
                            ? _perspective.labelLeftEn()
                            : _perspective.labelLeftTr(),
                        controller: _leftController,
                        isEn: isEn,
                        isDark: isDark,
                        color: AppColors.starGold,
                        hintEn: 'What does your ${_perspective.labelLeftEn().toLowerCase()} say?',
                        hintTr: '${_perspective.labelLeftTr()} ne diyor?',
                      ),

                      const SizedBox(height: 16),

                      _DialogueColumn(
                        label: isEn
                            ? _perspective.labelRightEn()
                            : _perspective.labelRightTr(),
                        controller: _rightController,
                        isEn: isEn,
                        isDark: isDark,
                        color: AppColors.amethyst,
                        hintEn: 'What does your ${_perspective.labelRightEn().toLowerCase()} say?',
                        hintTr: '${_perspective.labelRightTr()} ne diyor?',
                      ),

                      const SizedBox(height: 24),

                      // Save button
                      GestureDetector(
                        onTap: _saved ? null : _save,
                        child: AnimatedContainer(
                          duration: 300.ms,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: _saved
                                ? LinearGradient(colors: [
                                    AppColors.success,
                                    AppColors.success
                                  ])
                                : LinearGradient(colors: [
                                    AppColors.starGold,
                                    AppColors.celestialGold,
                                  ]),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.starGold
                                    .withValues(alpha: 0.25),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _saved
                                  ? (isEn ? 'Saved' : 'Kaydedildi')
                                  : (isEn ? 'Save Dialogue' : 'Diyalo\u011fu Kaydet'),
                              style: AppTypography.modernAccent(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.deepSpace,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Past dialogues
                      _PastDialoguesSection(isEn: isEn, isDark: isDark),

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

class _DialogueColumn extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isEn;
  final bool isDark;
  final Color color;
  final String hintEn;
  final String hintTr;

  const _DialogueColumn({
    required this.label,
    required this.controller,
    required this.isEn,
    required this.isDark,
    required this.color,
    required this.hintEn,
    required this.hintTr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: color.withValues(alpha: 0.5), width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Text(
              label,
              style: AppTypography.modernAccent(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          TextField(
            controller: controller,
            maxLines: 6,
            minLines: 4,
            style: AppTypography.decorativeScript(
              fontSize: 15,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
            decoration: InputDecoration(
              hintText: isEn ? hintEn : hintTr,
              hintStyle: AppTypography.decorativeScript(
                fontSize: 15,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
        ],
      ),
    );
  }
}

class _PastDialoguesSection extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const _PastDialoguesSection({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(innerDialogueServiceProvider);
    return serviceAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        final recent = service.getRecent(limit: 5);
        if (recent.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientText(
              isEn ? 'Past Dialogues' : 'Ge\u00e7mi\u015f Diyaloglar',
              variant: GradientTextVariant.amethyst,
              style: AppTypography.modernAccent(fontSize: 15),
            ),
            const SizedBox(height: 10),
            ...recent.map((d) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.04)
                          : Colors.black.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(d.perspective.emoji,
                                style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 6),
                            Text(
                              d.topic ??
                                  (isEn
                                      ? '${d.perspective.labelLeftEn()} vs ${d.perspective.labelRightEn()}'
                                      : '${d.perspective.labelLeftTr()} vs ${d.perspective.labelRightTr()}'),
                              style: AppTypography.modernAccent(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${d.totalWords} ${isEn ? 'words' : 'kelime'}',
                              style: AppTypography.elegantAccent(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                        if (d.leftText.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            d.leftText.length > 80
                                ? '${d.leftText.substring(0, 80)}...'
                                : d.leftText,
                            style: AppTypography.decorativeScript(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                )),
          ],
        );
      },
    );
  }
}
