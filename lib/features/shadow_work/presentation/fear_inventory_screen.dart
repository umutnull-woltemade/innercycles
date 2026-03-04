// ════════════════════════════════════════════════════════════════════════════
// FEAR INVENTORY SCREEN - Name, reframe, and resolve fears
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/fear_entry.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class FearInventoryScreen extends ConsumerStatefulWidget {
  const FearInventoryScreen({super.key});

  @override
  ConsumerState<FearInventoryScreen> createState() =>
      _FearInventoryScreenState();
}

class _FearInventoryScreenState extends ConsumerState<FearInventoryScreen> {
  final _fearController = TextEditingController();
  final _reframeController = TextEditingController();
  FearCategory _selectedCategory = FearCategory.unknown;
  int _intensity = 3;
  bool _showAddForm = false;
  bool _showResolved = false;

  @override
  void dispose() {
    _fearController.dispose();
    _reframeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(fearInventoryServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (service) {
              final active = service.getActiveFears();
              final resolved = service.getResolvedFears();

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  GlassSliverAppBar(
                    title: isEn ? 'Fear Inventory' : 'Korku Envanteri',
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            isEn
                                ? 'Naming your fears reduces their power. Reframe them to see clearly.'
                                : 'Korkular\u0131n\u0131 adland\u0131rmak g\u00fc\u00e7lerini azalt\u0131r. Net g\u00f6rmek i\u00e7in yeniden \u00e7er\u00e7evele.',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Stats strip
                          if (active.isNotEmpty)
                            Row(
                              children: [
                                _StatBubble(
                                  label: isEn ? 'Active' : 'Aktif',
                                  value: '${active.length}',
                                  isDark: isDark,
                                ),
                                const SizedBox(width: 8),
                                _StatBubble(
                                  label: isEn ? 'Resolved' : '\u00c7\u00f6z\u00fclen',
                                  value: '${resolved.length}',
                                  isDark: isDark,
                                ),
                                if (service.dominantCategory != null) ...[
                                  const SizedBox(width: 8),
                                  _StatBubble(
                                    label: isEn ? 'Main Area' : 'Ana Alan',
                                    value: service.dominantCategory!.emoji,
                                    isDark: isDark,
                                  ),
                                ],
                              ],
                            ),

                          const SizedBox(height: 16),

                          // Add fear button / form
                          if (!_showAddForm)
                            GestureDetector(
                              onTap: () => setState(() => _showAddForm = true),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.amethyst.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: AppColors.amethyst.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    isEn ? '+ Name a Fear' : '+ Bir Korku Adland\u0131r',
                                    style: AppTypography.modernAccent(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.amethyst,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          if (_showAddForm) _buildAddForm(isEn, isDark, service),

                          const SizedBox(height: 20),

                          // Active fears
                          if (active.isNotEmpty) ...[
                            GradientText(
                              isEn ? 'Active Fears' : 'Aktif Korkular',
                              variant: GradientTextVariant.amethyst,
                              style: AppTypography.modernAccent(fontSize: 15),
                            ),
                            const SizedBox(height: 10),
                            ...active.map((fear) => _FearTile(
                                  fear: fear,
                                  isEn: isEn,
                                  isDark: isDark,
                                  onResolve: () async {
                                    await service.markResolved(fear.id);
                                    ref.invalidate(fearInventoryServiceProvider);
                                  },
                                  onDelete: () async {
                                    await service.deleteFear(fear.id);
                                    ref.invalidate(fearInventoryServiceProvider);
                                  },
                                )),
                          ],

                          if (active.isEmpty && !_showAddForm)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Center(
                                child: Column(
                                  children: [
                                    const Text('\u{1F31F}',
                                        style: TextStyle(fontSize: 44)),
                                    const SizedBox(height: 12),
                                    Text(
                                      isEn
                                          ? 'No active fears. Name one to start your inventory.'
                                          : 'Aktif korku yok. Envanterini ba\u015flatmak i\u00e7in birini adland\u0131r.',
                                      textAlign: TextAlign.center,
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
                            ),

                          // Resolved fears
                          if (resolved.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _showResolved = !_showResolved),
                              child: Row(
                                children: [
                                  GradientText(
                                    isEn
                                        ? 'Resolved (${resolved.length})'
                                        : '\u00c7\u00f6z\u00fclen (${resolved.length})',
                                    variant: GradientTextVariant.gold,
                                    style: AppTypography.modernAccent(fontSize: 14),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    _showResolved
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    size: 18,
                                    color: AppColors.starGold,
                                  ),
                                ],
                              ),
                            ),
                            if (_showResolved)
                              ...resolved.map((fear) => Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: _ResolvedTile(
                                      fear: fear,
                                      isEn: isEn,
                                      isDark: isDark,
                                    ),
                                  )),
                          ],

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

  Widget _buildAddForm(bool isEn, bool isDark, dynamic service) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.black.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _fearController,
            maxLines: 2,
            style: AppTypography.subtitle(
              fontSize: 14,
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            ),
            decoration: InputDecoration(
              hintText: isEn
                  ? 'What are you afraid of?'
                  : 'Neden korkuyorsun?',
              hintStyle: AppTypography.subtitle(
                fontSize: 14,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Category chips
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: FearCategory.values.map((cat) {
            final selected = cat == _selectedCategory;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.amethyst.withValues(alpha: 0.2)
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.04)),
                  borderRadius: BorderRadius.circular(12),
                  border: selected
                      ? Border.all(color: AppColors.amethyst.withValues(alpha: 0.5))
                      : null,
                ),
                child: Text(
                  '${cat.emoji} ${cat.label(isEn)}',
                  style: AppTypography.elegantAccent(
                    fontSize: 11,
                    color: selected
                        ? AppColors.amethyst
                        : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),

        // Intensity
        Row(
          children: [
            Text(
              isEn ? 'Intensity:' : '\u015eiddet:',
              style: AppTypography.modernAccent(
                fontSize: 12,
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(width: 8),
            ...List.generate(5, (i) {
              final level = i + 1;
              return GestureDetector(
                onTap: () => setState(() => _intensity = level),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    level <= _intensity ? Icons.circle : Icons.circle_outlined,
                    size: 16,
                    color: level <= _intensity
                        ? AppColors.error.withValues(alpha: 0.4 + level * 0.12)
                        : (isDark
                            ? Colors.white.withValues(alpha: 0.15)
                            : Colors.black.withValues(alpha: 0.1)),
                  ),
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 10),

        // Reframe prompt
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.black.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _reframeController,
            maxLines: 2,
            style: AppTypography.subtitle(
              fontSize: 14,
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            ),
            decoration: InputDecoration(
              hintText: isEn
                  ? 'What is this fear trying to protect you from? (optional)'
                  : 'Bu korku seni neyden korumaya \u00e7al\u0131\u015f\u0131yor? (iste\u011fe ba\u011fl\u0131)',
              hintStyle: AppTypography.subtitle(
                fontSize: 13,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() {
                  _showAddForm = false;
                  _fearController.clear();
                  _reframeController.clear();
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      isEn ? 'Cancel' : '\u0130ptal',
                      style: AppTypography.modernAccent(
                        fontSize: 13,
                        color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () async {
                  final text = _fearController.text.trim();
                  if (text.isEmpty) return;
                  await service.addFear(
                    fearText: text,
                    category: _selectedCategory,
                    intensity: _intensity,
                    reframeText: _reframeController.text.trim().isEmpty
                        ? null
                        : _reframeController.text.trim(),
                  );
                  if (!mounted) return;
                  _fearController.clear();
                  _reframeController.clear();
                  ref.invalidate(fearInventoryServiceProvider);
                  setState(() {
                    _showAddForm = false;
                    _intensity = 3;
                    _selectedCategory = FearCategory.unknown;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.amethyst, AppColors.starGold],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      isEn ? 'Name This Fear' : 'Bu Korkuyu Adland\u0131r',
                      style: AppTypography.modernAccent(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepSpace,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatBubble extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _StatBubble({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.modernAccent(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.starGold,
            ),
          ),
          Text(
            label,
            style: AppTypography.elegantAccent(
              fontSize: 10,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _FearTile extends StatelessWidget {
  final FearEntry fear;
  final bool isEn;
  final bool isDark;
  final VoidCallback onResolve;
  final VoidCallback onDelete;

  const _FearTile({
    required this.fear,
    required this.isEn,
    required this.isDark,
    required this.onResolve,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PremiumCard(
        style: PremiumCardStyle.subtle,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(fear.category.emoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      fear.fearText,
                      style: AppTypography.modernAccent(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                  // Intensity dots
                  ...List.generate(5, (i) => Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Icon(
                          Icons.circle,
                          size: 6,
                          color: i < fear.intensity
                              ? AppColors.error.withValues(alpha: 0.5 + i * 0.1)
                              : (isDark
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : Colors.black.withValues(alpha: 0.08)),
                        ),
                      )),
                ],
              ),
              if (fear.reframeText != null) ...[
                const SizedBox(height: 8),
                Text(
                  fear.reframeText!,
                  style: AppTypography.decorativeScript(
                    fontSize: 13,
                    color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                  ).copyWith(fontStyle: FontStyle.italic),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: onResolve,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isEn ? 'Resolve' : '\u00c7\u00f6z',
                        style: AppTypography.elegantAccent(
                          fontSize: 11,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onDelete,
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResolvedTile extends StatelessWidget {
  final FearEntry fear;
  final bool isEn;
  final bool isDark;

  const _ResolvedTile({
    required this.fear,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 18, color: AppColors.success),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              fear.fearText,
              style: AppTypography.subtitle(
                fontSize: 13,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ).copyWith(decoration: TextDecoration.lineThrough),
            ),
          ),
          if (fear.resolvedAt != null)
            Text(
              '${fear.resolvedAt!.day}/${fear.resolvedAt!.month}',
              style: AppTypography.elegantAccent(
                fontSize: 10,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
        ],
      ),
    );
  }
}
