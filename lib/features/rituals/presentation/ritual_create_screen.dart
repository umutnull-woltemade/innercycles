import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/ritual_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../data/content/habit_suggestions_content.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

class RitualCreateScreen extends ConsumerStatefulWidget {
  const RitualCreateScreen({super.key});

  @override
  ConsumerState<RitualCreateScreen> createState() => _RitualCreateScreenState();
}

class _RitualCreateScreenState extends ConsumerState<RitualCreateScreen> {
  RitualTime _selectedTime = RitualTime.morning;
  final _nameController = TextEditingController();
  final List<TextEditingController> _itemControllers = [
    TextEditingController(),
  ];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Default name based on time
    _updateDefaultName();
  }

  void _updateDefaultName() {
    final language = ref.read(languageProvider);
    final isEn = language == AppLanguage.en;
    _nameController.text = isEn
        ? _selectedTime.displayNameEn
        : _selectedTime.displayNameTr;
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final c in _itemControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final isPremium = ref.watch(isPremiumUserProvider);
    final maxItems = isPremium ? 5 : 3;

    return Scaffold(
      body: CosmicBackground(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          behavior: HitTestBehavior.opaque,
          child: SafeArea(
            child: CupertinoScrollbar(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: isEn ? 'Create Ritual' : 'Ritüel Oluştur',
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(AppConstants.spacingLg),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Time selector
                        Text(
                          isEn ? 'When' : 'Zaman',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: RitualTime.values.map((time) {
                            final isSelected = time == _selectedTime;
                            return ConstrainedBox(
                              constraints: const BoxConstraints(minHeight: 44),
                              child: Semantics(
                                label: isEn
                                    ? time.displayNameEn
                                    : time.displayNameTr,
                                button: true,
                                selected: isSelected,
                                child: GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    setState(() {
                                      _selectedTime = time;
                                      _updateDefaultName();
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.auroraStart.withValues(
                                              alpha: 0.2,
                                            )
                                          : (isDark
                                                ? AppColors.surfaceDark
                                                      .withValues(alpha: 0.5)
                                                : AppColors
                                                      .lightSurfaceVariant),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.auroraStart
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          time.icon,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          isEn
                                              ? time.displayNameEn
                                              : time.displayNameTr,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                            color: isSelected
                                                ? AppColors.auroraStart
                                                : (isDark
                                                      ? AppColors.textPrimary
                                                      : AppColors
                                                            .lightTextPrimary),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ).animate().fadeIn(duration: 300.ms),

                        const SizedBox(height: 24),

                        // Name field
                        Text(
                          isEn ? 'Name' : 'İsim',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.surfaceDark.withValues(alpha: 0.85)
                                : AppColors.lightCard,
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusLg,
                            ),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.15)
                                  : Colors.black.withValues(alpha: 0.05),
                            ),
                          ),
                          child: TextField(
                            controller: _nameController,
                            maxLength: 30,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: isEn
                                  ? 'e.g. Morning Routine'
                                  : 'ör. Sabah Rutini',
                              hintStyle: TextStyle(
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                              contentPadding: const EdgeInsets.all(16),
                              border: InputBorder.none,
                              counterText: '',
                            ),
                          ),
                        ).animate().fadeIn(delay: 100.ms, duration: 300.ms),

                        const SizedBox(height: 24),

                        // Items
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isEn
                                  ? 'Ritual Items (${_itemControllers.length}/$maxItems)'
                                  : 'Ritüel Maddeleri (${_itemControllers.length}/$maxItems)',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.textSecondary
                                    : AppColors.lightTextSecondary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            if (_itemControllers.length < maxItems)
                              IconButton(
                                tooltip: isEn ? 'Add step' : 'Adım ekle',
                                onPressed: () {
                                  setState(() {
                                    _itemControllers.add(
                                      TextEditingController(),
                                    );
                                  });
                                },
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  color: AppColors.auroraStart,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Habit suggestions
                        _buildHabitSuggestions(isDark, isEn),
                        const SizedBox(height: 12),

                        ...List.generate(_itemControllers.length, (i) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child:
                                Container(
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.surfaceDark.withValues(
                                            alpha: 0.85,
                                          )
                                        : AppColors.lightCard,
                                    borderRadius: BorderRadius.circular(
                                      AppConstants.radiusMd,
                                    ),
                                    border: Border.all(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.15)
                                          : Colors.black.withValues(
                                              alpha: 0.05,
                                            ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 14,
                                        ),
                                        child: Text(
                                          '${i + 1}.',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.auroraStart,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: _itemControllers[i],
                                          maxLength: 50,
                                          style: TextStyle(
                                            color: isDark
                                                ? AppColors.textPrimary
                                                : AppColors.lightTextPrimary,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: _getPlaceholder(i, isEn),
                                            hintStyle: TextStyle(
                                              color: isDark
                                                  ? AppColors.textMuted
                                                  : AppColors.lightTextMuted,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(14),
                                            border: InputBorder.none,
                                            counterText: '',
                                          ),
                                        ),
                                      ),
                                      if (_itemControllers.length > 1)
                                        IconButton(
                                          tooltip: isEn
                                              ? 'Remove step'
                                              : 'Adımı kaldır',
                                          onPressed: () {
                                            setState(() {
                                              _itemControllers[i].dispose();
                                              _itemControllers.removeAt(i);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.remove_circle_outline,
                                            color: AppColors.error.withValues(
                                              alpha: 0.6,
                                            ),
                                            size: 20,
                                          ),
                                        ),
                                    ],
                                  ),
                                ).animate().fadeIn(
                                  delay: (200 + i * 50).ms,
                                  duration: 300.ms,
                                ),
                          );
                        }),

                        const SizedBox(height: 32),

                        // Save button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _save,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.auroraStart,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppConstants.radiusLg,
                                ),
                              ),
                              elevation: 0,
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CupertinoActivityIndicator(),
                                  )
                                : Text(
                                    isEn ? 'Create Ritual' : 'Ritüel Oluştur',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ).animate().fadeIn(delay: 500.ms, duration: 300.ms),

                        const SizedBox(height: 40),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> _categoriesForTime(RitualTime time) {
    switch (time) {
      case RitualTime.morning:
        return ['morning'];
      case RitualTime.midday:
        return ['mindfulness', 'social', 'creative'];
      case RitualTime.evening:
        return ['evening', 'reflective'];
    }
  }

  Widget _buildHabitSuggestions(bool isDark, bool isEn) {
    final categories = _categoriesForTime(_selectedTime);
    final suggestions = allHabitSuggestions
        .where((h) => categories.contains(h.category))
        .take(6)
        .toList();

    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEn ? 'Suggestions' : 'Öneriler',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: suggestions.map((habit) {
            final title = isEn ? habit.titleEn : habit.titleTr;
            return Semantics(
              label: title,
              button: true,
              child: GestureDetector(
                onTap: () {
                  // Find first empty controller or add new one
                  final emptyIndex = _itemControllers.indexWhere(
                    (c) => c.text.trim().isEmpty,
                  );
                  if (emptyIndex >= 0) {
                    _itemControllers[emptyIndex].text = title;
                  } else {
                    final isPremium = ref.read(premiumProvider).isPremium;
                    final maxItems = isPremium ? 5 : 3;
                    if (_itemControllers.length < maxItems) {
                      setState(() {
                        _itemControllers.add(
                          TextEditingController(text: title),
                        );
                      });
                    }
                  }
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.auroraStart.withValues(alpha: 0.12)
                        : AppColors.lightSurfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.auroraStart.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.auroraStart
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getPlaceholder(int index, bool isEn) {
    final enPlaceholders = [
      'e.g. Drink water',
      'e.g. Stretch for 5 min',
      'e.g. Write in journal',
      'e.g. Meditate',
      'e.g. Read for 10 min',
    ];
    final trPlaceholders = [
      'ör. Su iç',
      'ör. 5 dk esneme',
      'ör. Günlük yaz',
      'ör. Meditasyon',
      'ör. 10 dk kitap oku',
    ];
    final list = isEn ? enPlaceholders : trPlaceholders;
    return list[index % list.length];
  }

  Future<void> _save() async {
    final itemNames = _itemControllers
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (itemNames.isEmpty) {
      final isEn = ref.read(languageProvider) == AppLanguage.en;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEn ? 'Add at least one ritual item' : 'En az bir madde ekle',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final service = await ref.read(ritualServiceProvider.future);
      final isPremium = ref.read(premiumProvider).isPremium;
      await service.createStack(
        time: _selectedTime,
        name: _nameController.text.trim().isNotEmpty
            ? _nameController.text.trim()
            : (ref.read(languageProvider) == AppLanguage.en
                  ? _selectedTime.displayNameEn
                  : _selectedTime.displayNameTr),
        itemNames: itemNames,
        isPremium: isPremium,
      );

      ref.invalidate(ritualStacksProvider);
      ref.invalidate(todayRitualSummaryProvider);

      if (mounted) {
        HapticFeedback.mediumImpact();
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ref.read(languageProvider) == AppLanguage.en
                  ? 'Save failed'
                  : 'Kayıt başarısız',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
